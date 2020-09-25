Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D4CF27904C
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 20:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729785AbgIYS1a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 14:27:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60341 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729724AbgIYS1O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 14:27:14 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601058433;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:in-reply-to:in-reply-to:references:references;
        bh=qD7K+UDAAPv7p1xhR7GsE6Qr4qBNVKTkChHI2rSdLN0=;
        b=h6hBl2TpouAZ70pSN4pyGrBAsdzzPCtc/v29FvuKmeYCk7LVqK1Me7h8r/Sb6v5v/YqSHc
        HCA8/NrdQ49bYcnvXSPwLuRX+QaXxfTNk4AlgDLcD6Fv2i3IhW6rl6YhrZqrbX8nzX0mxk
        pIc46Mf2J73e1W2/12hCV3FJ87oCCW0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-501-deZDjWaiMCqrv1ZQexTisA-1; Fri, 25 Sep 2020 14:27:12 -0400
X-MC-Unique: deZDjWaiMCqrv1ZQexTisA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0216D1007474;
        Fri, 25 Sep 2020 18:27:09 +0000 (UTC)
Received: from virtlab719.virt.lab.eng.bos.redhat.com (virtlab719.virt.lab.eng.bos.redhat.com [10.19.153.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4FE1078810;
        Fri, 25 Sep 2020 18:27:07 +0000 (UTC)
From:   Nitesh Narayan Lal <nitesh@redhat.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        frederic@kernel.org, mtosatti@redhat.com, sassmann@redhat.com,
        jesse.brandeburg@intel.com, lihong.yang@intel.com,
        helgaas@kernel.org, nitesh@redhat.com, jeffrey.t.kirsher@intel.com,
        jacob.e.keller@intel.com, jlelli@redhat.com, hch@infradead.org,
        bhelgaas@google.com, mike.marciniszyn@intel.com,
        dennis.dalessandro@intel.com, thomas.lendacky@amd.com,
        jiri@nvidia.com, mingo@redhat.com, peterz@infradead.org,
        juri.lelli@redhat.com, vincent.guittot@linaro.org,
        lgoncalv@redhat.com
Subject: [PATCH v3 3/4] i40e: Limit msix vectors to housekeeping CPUs
Date:   Fri, 25 Sep 2020 14:26:53 -0400
Message-Id: <20200925182654.224004-4-nitesh@redhat.com>
In-Reply-To: <20200925182654.224004-1-nitesh@redhat.com>
References: <20200925182654.224004-1-nitesh@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If we have isolated CPUs designated to perform real-time tasks, to keep the
latency overhead to a minimum for real-time CPUs IRQ vectors are moved to
housekeeping CPUs from the userspace. Creating MSIX vectors only based on
the online CPUs could lead to exhaustion of housekeeping CPU IRQ vectors in
such environments.

This patch prevents i40e to create vectors only based on online CPUs by
retrieving the online housekeeping CPUs that are designated to perform
managed IRQ jobs.

Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
Reviewed-by: Marcelo Tosatti <mtosatti@redhat.com>
Acked-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 2e433fdbf2c3..370b581cd48c 100644
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
+	cpus = housekeeping_num_online_cpus(HK_FLAG_MANAGED_IRQ);
 	pf->num_lan_msix = min_t(int, cpus, vectors_left / 2);
 	vectors_left -= pf->num_lan_msix;
 
-- 
2.18.2

