Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EC3F3D059C
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 01:42:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237159AbhGTWup (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 18:50:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32952 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236052AbhGTWrI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 18:47:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626823660;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mzNBCx76Oue97s85xgfDBxjBA71n2ChlEIMSiGVXCV8=;
        b=FEH0WZk5u3zILw2oHnrYb4MvfVqhKXJH1p6jVce8bUStj2qhlHluUyKek25rcQl25peZGr
        Vj+n29rSwPchdEnbMd6kJjOtSdKewaPFipn+yUhEzcGaLeYqFqABP2LbMa/iOwOKqpTwu8
        w/GL8uk+zH/dAhnk5wGM38RnfWIIa4g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-165-QCP44qdSPp6J0SR3Ysz4nQ-1; Tue, 20 Jul 2021 19:27:39 -0400
X-MC-Unique: QCP44qdSPp6J0SR3Ysz4nQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7466B100C610;
        Tue, 20 Jul 2021 23:27:37 +0000 (UTC)
Received: from virtlab719.virt.lab.eng.bos.redhat.com (virtlab719.virt.lab.eng.bos.redhat.com [10.19.153.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BA57969FAD;
        Tue, 20 Jul 2021 23:27:32 +0000 (UTC)
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
Subject: [PATCH v5 11/14] scsi: lpfc: Use irq_set_affinity
Date:   Tue, 20 Jul 2021 19:26:21 -0400
Message-Id: <20210720232624.1493424-12-nitesh@redhat.com>
In-Reply-To: <20210720232624.1493424-1-nitesh@redhat.com>
References: <20210720232624.1493424-1-nitesh@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver uses irq_set_affinity_hint to set the affinity for the lpfc
interrupts to a mask corresponding to the local NUMA node to avoid
performance overhead on AMD architectures.

However, irq_set_affinity_hint() setting the affinity is an undocumented
side effect that this function also sets the affinity under the hood.
To remove this side effect irq_set_affinity_hint() has been marked as
deprecated and new interfaces have been introduced.

Also, as per the commit dcaa21367938 ("scsi: lpfc: Change default IRQ model
on AMD architectures"):
"On AMD architecture, revert the irq allocation to the normal style
(non-managed) and then use irq_set_affinity_hint() to set the cpu affinity
and disable user-space rebalancing."
we don't really need to set the affinity_hint as user-space rebalancing for
the lpfc interrupts is not desired.

Hence, replace the irq_set_affinity_hint() with irq_set_affinity() which
only applies the affinity for the interrupts.

Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 5983e05b648f..8a16bacb8c93 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -11455,7 +11455,7 @@ lpfc_irq_set_aff(struct lpfc_hba_eq_hdl *eqhdl, unsigned int cpu)
 	cpumask_clear(&eqhdl->aff_mask);
 	cpumask_set_cpu(cpu, &eqhdl->aff_mask);
 	irq_set_status_flags(eqhdl->irq, IRQ_NO_BALANCING);
-	irq_set_affinity_hint(eqhdl->irq, &eqhdl->aff_mask);
+	irq_set_affinity(eqhdl->irq, &eqhdl->aff_mask);
 }
 
 /**
@@ -11744,7 +11744,6 @@ lpfc_sli4_enable_msix(struct lpfc_hba *phba)
 	for (--index; index >= 0; index--) {
 		eqhdl = lpfc_get_eq_hdl(index);
 		lpfc_irq_clear_aff(eqhdl);
-		irq_set_affinity_hint(eqhdl->irq, NULL);
 		free_irq(eqhdl->irq, eqhdl);
 	}
 
@@ -11905,7 +11904,6 @@ lpfc_sli4_disable_intr(struct lpfc_hba *phba)
 		for (index = 0; index < phba->cfg_irq_chann; index++) {
 			eqhdl = lpfc_get_eq_hdl(index);
 			lpfc_irq_clear_aff(eqhdl);
-			irq_set_affinity_hint(eqhdl->irq, NULL);
 			free_irq(eqhdl->irq, eqhdl);
 		}
 	} else {
-- 
2.27.0

