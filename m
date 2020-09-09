Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B71B263443
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 19:17:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730544AbgIIRRd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 13:17:33 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:26604 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730158AbgIIP2A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 11:28:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599665244;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WiK+CLNHCkGtArM+EWzVkhYFO4V34cQn5Dk8gnAgqYI=;
        b=JbR6/g1fMBYV9guWPu7wh0TG7ODY66R4TBMd/PRPJpBkqvBxgr+YxSUJd8oC75tqlrvayU
        WoVCJGAJBCmRxJwaPOu1eg3LVejxU/GQM6umIxIazftZfqR4tAmSygZ/ZjkEhSHb5F57r8
        GqqNo4Bqp5U4pl7Z7SxWeX0FrcVsy7M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-22-InbDKSgzP6WcdO2Nor3JbQ-1; Wed, 09 Sep 2020 11:09:10 -0400
X-MC-Unique: InbDKSgzP6WcdO2Nor3JbQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 323CB8015A5;
        Wed,  9 Sep 2020 15:09:06 +0000 (UTC)
Received: from wsfd-advnetlab06.anl.lab.eng.bos.redhat.com (wsfd-advnetlab06.anl.lab.eng.bos.redhat.com [10.19.107.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B667119C4F;
        Wed,  9 Sep 2020 15:09:04 +0000 (UTC)
From:   Nitesh Narayan Lal <nitesh@redhat.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, frederic@kernel.org,
        mtosatti@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, jacob.e.keller@intel.com,
        jlelli@redhat.com, hch@infradead.org, bhelgaas@google.com,
        mike.marciniszyn@intel.com, dennis.dalessandro@intel.com,
        thomas.lendacky@amd.com, jerinj@marvell.com,
        mathias.nyman@intel.com, jiri@nvidia.com
Subject: [RFC][Patch v1 2/3] i40e: limit msix vectors based on housekeeping CPUs
Date:   Wed,  9 Sep 2020 11:08:17 -0400
Message-Id: <20200909150818.313699-3-nitesh@redhat.com>
In-Reply-To: <20200909150818.313699-1-nitesh@redhat.com>
References: <20200909150818.313699-1-nitesh@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In a realtime environment, it is essential to isolate unwanted IRQs from
isolated CPUs to prevent latency overheads. Creating MSIX vectors only
based on the online CPUs could lead to a potential issue on an RT setup
that has several isolated CPUs but a very few housekeeping CPUs. This is
because in these kinds of setups an attempt to move the IRQs to the
limited housekeeping CPUs from isolated CPUs might fail due to the per
CPU vector limit. This could eventually result in latency spikes because
of the IRQ threads that we fail to move from isolated CPUs.

This patch prevents i40e to add vectors only based on available
housekeeping CPUs by using num_housekeeping_cpus().

Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 2e433fdbf2c3..3b4cd4b3de85 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -5,6 +5,7 @@
 #include <linux/of_net.h>
 #include <linux/pci.h>
 #include <linux/bpf.h>
+#include <linux/sched/isolation.h>
 #include <generated/utsrelease.h>
 
 /* Local includes */
@@ -11002,7 +11003,7 @@ static int i40e_init_msix(struct i40e_pf *pf)
 	 * will use any remaining vectors to reach as close as we can to the
 	 * number of online CPUs.
 	 */
-	cpus = num_online_cpus();
+	cpus = num_housekeeping_cpus();
 	pf->num_lan_msix = min_t(int, cpus, vectors_left / 2);
 	vectors_left -= pf->num_lan_msix;
 
-- 
2.27.0

