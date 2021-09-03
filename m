Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF67740023B
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 17:27:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349847AbhICP11 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 11:27:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:25463 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1349859AbhICP1W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 11:27:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630682781;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zD/AaGcE7EIGISn2zwz3u10joSTkCMi6Zhxs5OikZmo=;
        b=JaYxNBI4DzdDCRxL/UV62NkKtxDXj+9CJ2TQiSzBa8+tor3plgkKfefhDc1+i4x90H6YKX
        K18UuXZrIjJ/lOg8zdKyLd3zb70i3CGTHircfIUkWYywjuos9IVHFHCddkcjOwjcid4z2l
        Su5axN8oyi23Z0YpOu4rGnBXxObUoVU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-13-GsbIoxdaNKiCTEeJ_M2xXA-1; Fri, 03 Sep 2021 11:26:20 -0400
X-MC-Unique: GsbIoxdaNKiCTEeJ_M2xXA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9F13D18460E1;
        Fri,  3 Sep 2021 15:26:18 +0000 (UTC)
Received: from virtlab512.virt.lab.eng.bos.redhat.com (virtlab512.virt.lab.eng.bos.redhat.com [10.19.152.206])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BA5DB69CBB;
        Fri,  3 Sep 2021 15:26:13 +0000 (UTC)
From:   Nitesh Narayan Lal <nitesh@redhat.com>
To:     linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, ajit.khaparde@broadcom.com,
        sriharsha.basavapatna@broadcom.com, somnath.kotur@broadcom.com,
        huangguangbin2@huawei.com, huangdaode@huawei.com,
        mtosatti@redhat.com, juri.lelli@redhat.com, frederic@kernel.org,
        abelits@marvell.com, bhelgaas@google.com, rostedt@goodmis.org,
        peterz@infradead.org
Cc:     nilal@redhat.com, jesse.brandeburg@intel.com, robin.murphy@arm.com,
        mingo@kernel.org, jbrandeb@kernel.org, akpm@linuxfoundation.org,
        sfr@canb.auug.org.au, stephen@networkplumber.org,
        rppt@linux.vnet.ibm.com, chris.friesen@windriver.com,
        maz@kernel.org, nhorman@tuxdriver.com, pjwaskiewicz@gmail.com,
        sassmann@redhat.com, thenzl@redhat.com, james.smart@broadcom.com,
        dick.kennedy@broadcom.com, jkc@redhat.com, faisal.latif@intel.com,
        shiraz.saleem@intel.com, tariqt@nvidia.com, ahleihel@redhat.com,
        kheib@redhat.com, borisp@nvidia.com, saeedm@nvidia.com,
        tatyana.e.nikolova@intel.com, mustafa.ismail@intel.com,
        ahs3@redhat.com, leonro@nvidia.com,
        chandrakanth.patil@broadcom.com, bjorn.andersson@linaro.org,
        chunkuang.hu@kernel.org, yongqiang.niu@mediatek.com,
        baolin.wang7@gmail.com, poros@redhat.com, minlei@redhat.com,
        emilne@redhat.com, jejb@linux.ibm.com, martin.petersen@oracle.com,
        kabel@kernel.org, viresh.kumar@linaro.org, kuba@kernel.org,
        kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        shivasharan.srikanteshwara@broadcom.com,
        sathya.prakash@broadcom.com, sreekanth.reddy@broadcom.com,
        suganath-prabu.subramani@broadcom.com, tglx@linutronix.de,
        ley.foon.tan@intel.com, jbrunet@baylibre.com,
        johannes@sipsolutions.net, snelson@pensando.io,
        lewis.hanly@microchip.com, benve@cisco.com, _govind@gmx.com,
        jassisinghbrar@gmail.com
Subject: [PATCH v6 12/14] hinic: Use irq_set_affinity_and_hint
Date:   Fri,  3 Sep 2021 11:24:28 -0400
Message-Id: <20210903152430.244937-13-nitesh@redhat.com>
In-Reply-To: <20210903152430.244937-1-nitesh@redhat.com>
References: <20210903152430.244937-1-nitesh@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver uses irq_set_affinity_hint() to:

- Set the affinity_hint which is consumed by the userspace for
  distributing the interrupts

- Enforce affinity

As per commit 352f58b0d9f2 ("net-next/hinic: Set Rxq irq to specific cpu
for NUMA"), the hinic driver enforces its own affinity to bind IRQs to the
local NUMA node. However, irq_set_affinity_hint() applying the provided
cpumask as an affinity for the interrupt is an undocumented side effect.

To remove this side effect irq_set_affinity_hint() has been marked as
deprecated and new interfaces have been introduced. Hence, replace the
irq_set_affinity_hint() with the new interface irq_set_affinity_and_hint()
where the provided mask needs to be applied as the affinity and
affinity_hint pointer needs to be set and replace with
irq_update_affinity_hint() where only affinity_hint needs to be updated.

Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>
---
 drivers/net/ethernet/huawei/hinic/hinic_rx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_rx.c b/drivers/net/ethernet/huawei/hinic/hinic_rx.c
index fed3b6bc0d76..b33ed4d92b71 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_rx.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_rx.c
@@ -548,7 +548,7 @@ static int rx_request_irq(struct hinic_rxq *rxq)
 		goto err_req_irq;
 
 	cpumask_set_cpu(qp->q_id % num_online_cpus(), &rq->affinity_mask);
-	err = irq_set_affinity_hint(rq->irq, &rq->affinity_mask);
+	err = irq_set_affinity_and_hint(rq->irq, &rq->affinity_mask);
 	if (err)
 		goto err_irq_affinity;
 
@@ -565,7 +565,7 @@ static void rx_free_irq(struct hinic_rxq *rxq)
 {
 	struct hinic_rq *rq = rxq->rq;
 
-	irq_set_affinity_hint(rq->irq, NULL);
+	irq_update_affinity_hint(rq->irq, NULL);
 	free_irq(rq->irq, rxq);
 	rx_del_napi(rxq);
 }
-- 
2.27.0

