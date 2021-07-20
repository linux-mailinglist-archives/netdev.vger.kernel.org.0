Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7586E3D0584
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 01:42:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236283AbhGTWrg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 18:47:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:54210 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235706AbhGTWqo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 18:46:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626823640;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O5KXq/z7dZ/+GfJwFgmvdOMFBPu0TxASq5EsvM935Ms=;
        b=ZuVcTtzawJVzxCf/9esB5+eQZR7xxr6c3GiuQP87/Vi8dnx4gzsK2E/kxLTjbU3g6N8zvc
        8G0+Ae9pYyA6fW1NEqv2hdnW2eppYwGt24KoUz4UvvtitmEheLX3MCc1Nru5wgSh5c7wkT
        Mv+TbjgnbLGxjIU//JRSI3v/xjmU+o8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-324-8WgploXoNpyu_g6RZoIMcw-1; Tue, 20 Jul 2021 19:27:16 -0400
X-MC-Unique: 8WgploXoNpyu_g6RZoIMcw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 135A6802920;
        Tue, 20 Jul 2021 23:27:15 +0000 (UTC)
Received: from virtlab719.virt.lab.eng.bos.redhat.com (virtlab719.virt.lab.eng.bos.redhat.com [10.19.153.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7A40C69FAD;
        Tue, 20 Jul 2021 23:27:10 +0000 (UTC)
From:   Nitesh Narayan Lal <nitesh@redhat.com>
To:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-api@vger.kernel.org, linux-pci@vger.kernel.org,
        tglx@linutronix.de, jesse.brandeburg@intel.com,
        robin.murphy@arm.com, mtosatti@redhat.com, mingo@kernel.org,
        jbrandeb@kernel.org, frederic@kernel.org, juri.lelli@redhat.com,
        abelits@marvell.com, bhelgaas@google.com, rostedt@goodmis.org,
        peterz@infradead.org, davem@davemloft.net,
        akpm@linux-foundation.org, sfr@canb.auug.org.au,
        stephen@networkplumber.org, rppt@linux.vnet.ibm.com,
        chris.friesen@windriver.com, maz@kernel.org, nhorman@tuxdriver.com,
        pjwaskiewicz@gmail.com, sassmann@redhat.com, thenzl@redhat.com,
        kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        shivasharan.srikanteshwara@broadcom.com,
        sathya.prakash@broadcom.com, sreekanth.reddy@broadcom.com,
        suganath-prabu.subramani@broadcom.com, james.smart@broadcom.com,
        dick.kennedy@broadcom.com, jkc@redhat.com, faisal.latif@intel.com,
        shiraz.saleem@intel.com, tariqt@nvidia.com, ahleihel@redhat.com,
        kheib@redhat.com, borisp@nvidia.com, saeedm@nvidia.com,
        benve@cisco.com, govind@gmx.com, jassisinghbrar@gmail.com,
        ajit.khaparde@broadcom.com, sriharsha.basavapatna@broadcom.com,
        somnath.kotur@broadcom.com, nilal@redhat.com,
        tatyana.e.nikolova@intel.com, mustafa.ismail@intel.com,
        ahs3@redhat.com, leonro@nvidia.com,
        chandrakanth.patil@broadcom.com, bjorn.andersson@linaro.org,
        chunkuang.hu@kernel.org, yongqiang.niu@mediatek.com,
        baolin.wang7@gmail.com, poros@redhat.com, minlei@redhat.com,
        emilne@redhat.com, jejb@linux.ibm.com, martin.petersen@oracle.com,
        _govind@gmx.com, kabel@kernel.org, viresh.kumar@linaro.org,
        Tushar.Khandelwal@arm.com, kuba@kernel.org
Subject: [PATCH v5 07/14] enic: Use irq_update_affinity_hint
Date:   Tue, 20 Jul 2021 19:26:17 -0400
Message-Id: <20210720232624.1493424-8-nitesh@redhat.com>
In-Reply-To: <20210720232624.1493424-1-nitesh@redhat.com>
References: <20210720232624.1493424-1-nitesh@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver uses irq_set_affinity_hint() to update the affinity_hint mask
that is consumed by the userspace to distribute the interrupts. However,
under the hood irq_set_affinity_hint() also applies the provided cpumask
(if not NULL) as the affinity for the given interrupt which is an
undocumented side effect.

To remove this side effect irq_set_affinity_hint() has been marked
as deprecated and new interfaces have been introduced. Hence, replace the
irq_set_affinity_hint() with the new interface irq_update_affinity_hint()
that only updates the affinity_hint pointer.

Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
---
 drivers/net/ethernet/cisco/enic/enic_main.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/cisco/enic/enic_main.c b/drivers/net/ethernet/cisco/enic/enic_main.c
index d0a8f7106958..97eb5bd62855 100644
--- a/drivers/net/ethernet/cisco/enic/enic_main.c
+++ b/drivers/net/ethernet/cisco/enic/enic_main.c
@@ -150,10 +150,10 @@ static void enic_set_affinity_hint(struct enic *enic)
 		    !cpumask_available(enic->msix[i].affinity_mask) ||
 		    cpumask_empty(enic->msix[i].affinity_mask))
 			continue;
-		err = irq_set_affinity_hint(enic->msix_entry[i].vector,
-					    enic->msix[i].affinity_mask);
+		err = irq_update_affinity_hint(enic->msix_entry[i].vector,
+					       enic->msix[i].affinity_mask);
 		if (err)
-			netdev_warn(enic->netdev, "irq_set_affinity_hint failed, err %d\n",
+			netdev_warn(enic->netdev, "irq_update_affinity_hint failed, err %d\n",
 				    err);
 	}
 
@@ -173,7 +173,7 @@ static void enic_unset_affinity_hint(struct enic *enic)
 	int i;
 
 	for (i = 0; i < enic->intr_count; i++)
-		irq_set_affinity_hint(enic->msix_entry[i].vector, NULL);
+		irq_update_affinity_hint(enic->msix_entry[i].vector, NULL);
 }
 
 static int enic_udp_tunnel_set_port(struct net_device *netdev,
-- 
2.27.0

