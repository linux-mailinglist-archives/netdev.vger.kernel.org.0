Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2569263439
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 19:17:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731054AbgIIRQL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 13:16:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43873 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730178AbgIIP2P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 11:28:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599665254;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+BCz3wPlVfUrMQm65Je9XbtrGnOGZT7lnY6dkRWqnmM=;
        b=NpNnzOgw9kc7CEFbCAdEmBWdA9JGfgmoQO5Y3zXbvjEJfROgh+lAiQkW2SWpjn4tfOmy5D
        xf+8Tm3jLO5DF0QPS6Ko2P8+Brjm26NWa+K5gxzJslHxqvEZRbR9gUtxSvrgGs387MWnO8
        eWANiB3CdMP12zLt6inSttyp/LVr4F8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-359-6B6-ByPUO9KRZAKC5KxUow-1; Wed, 09 Sep 2020 11:09:14 -0400
X-MC-Unique: 6B6-ByPUO9KRZAKC5KxUow-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6D82318BA290;
        Wed,  9 Sep 2020 15:09:12 +0000 (UTC)
Received: from wsfd-advnetlab06.anl.lab.eng.bos.redhat.com (wsfd-advnetlab06.anl.lab.eng.bos.redhat.com [10.19.107.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5242A19C4F;
        Wed,  9 Sep 2020 15:09:06 +0000 (UTC)
From:   Nitesh Narayan Lal <nitesh@redhat.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, frederic@kernel.org,
        mtosatti@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, jacob.e.keller@intel.com,
        jlelli@redhat.com, hch@infradead.org, bhelgaas@google.com,
        mike.marciniszyn@intel.com, dennis.dalessandro@intel.com,
        thomas.lendacky@amd.com, jerinj@marvell.com,
        mathias.nyman@intel.com, jiri@nvidia.com
Subject: [RFC][Patch v1 3/3] PCI: Limit pci_alloc_irq_vectors as per housekeeping CPUs
Date:   Wed,  9 Sep 2020 11:08:18 -0400
Message-Id: <20200909150818.313699-4-nitesh@redhat.com>
In-Reply-To: <20200909150818.313699-1-nitesh@redhat.com>
References: <20200909150818.313699-1-nitesh@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch limits the pci_alloc_irq_vectors max vectors that is passed on
by the caller based on the available housekeeping CPUs by only using the
minimum of the two.

A minimum of the max_vecs passed and available housekeeping CPUs is
derived to ensure that we don't create excess vectors which can be
problematic specifically in an RT environment. This is because for an RT
environment unwanted IRQs are moved to the housekeeping CPUs from
isolated CPUs to keep the latency overhead to a minimum. If the number of
housekeeping CPUs are significantly lower than that of the isolated CPUs
we can run into failures while moving these IRQs to housekeeping due to
per CPU vector limit.

Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
---
 include/linux/pci.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/include/linux/pci.h b/include/linux/pci.h
index 835530605c0d..750ba927d963 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -38,6 +38,7 @@
 #include <linux/interrupt.h>
 #include <linux/io.h>
 #include <linux/resource_ext.h>
+#include <linux/sched/isolation.h>
 #include <uapi/linux/pci.h>
 
 #include <linux/pci_ids.h>
@@ -1797,6 +1798,21 @@ static inline int
 pci_alloc_irq_vectors(struct pci_dev *dev, unsigned int min_vecs,
 		      unsigned int max_vecs, unsigned int flags)
 {
+	unsigned int num_housekeeping = num_housekeeping_cpus();
+	unsigned int num_online = num_online_cpus();
+
+	/*
+	 * Try to be conservative and at max only ask for the same number of
+	 * vectors as there are housekeeping CPUs. However, skip any
+	 * modification to the of max vectors in two conditions:
+	 * 1. If the min_vecs requested are higher than that of the
+	 *    housekeeping CPUs as we don't want to prevent the initialization
+	 *    of a device.
+	 * 2. If there are no isolated CPUs as in this case the driver should
+	 *    already have taken online CPUs into consideration.
+	 */
+	if (min_vecs < num_housekeeping && num_housekeeping != num_online)
+		max_vecs = min_t(int, max_vecs, num_housekeeping);
 	return pci_alloc_irq_vectors_affinity(dev, min_vecs, max_vecs, flags,
 					      NULL);
 }
-- 
2.27.0

