Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B57E557FCA4
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 11:44:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232078AbiGYJoZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 05:44:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230095AbiGYJoY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 05:44:24 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 460A813F6B;
        Mon, 25 Jul 2022 02:44:23 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26OLXD0D012904;
        Mon, 25 Jul 2022 02:44:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=dutQ9NGuRDjmpyqfsU4lsQO/9zEoJp1k6QzkZrvIygg=;
 b=cBH0HX1pBix5w/Ak0suq70osF3IVWpa6eLfjOATL+CEBHQcsF/bb8TSAhfeysnLOQUAn
 9M7fwiGmUsyMlMojG2KvipbI9yhwy1cwhzfkaVkpuWvPLWCgIyFWKu/UFdlE1s2SpL3S
 fEnVeZxZlKykNif1ed7RNvfw1Vd+sEBn9/tmP3b1is+yxWMPlzukbEwcjoEEUgc9mhjw
 fAOdsoMlX4OwuwoSKzA1wYrntoSb+4JdE4W1xdgSkT384+l+kJZrBv40omkeBCgQ4fYw
 EyH/3NVIBa3LhjA1YF3SKMq2w241MmFmaBBBwuOK3ML4Ydgl0FgyQJPlOXFz1rVUEeTp Lw== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3hgggn57r0-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 25 Jul 2022 02:44:12 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 25 Jul
 2022 02:44:11 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Mon, 25 Jul 2022 02:44:11 -0700
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id E8E053F7053;
        Mon, 25 Jul 2022 02:44:08 -0700 (PDT)
From:   Geetha sowjanya <gakula@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <edumazet@google.com>,
        "Geetha sowjanya" <gakula@marvell.com>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>
Subject: [net-next PATCH] octeontx2-pf: Use only non-isolated cpus in irq affinity
Date:   Mon, 25 Jul 2022 15:14:02 +0530
Message-ID: <20220725094402.21203-1-gakula@marvell.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: 9QF2UXxlF6Dpr3GsE-VaD6_sc7IefsCO
X-Proofpoint-ORIG-GUID: 9QF2UXxlF6Dpr3GsE-VaD6_sc7IefsCO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-25_07,2022-07-21_02,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch excludes the isolates cpus from the cpus list
while setting up TX/RX queue interrupts affinity

Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
---
 .../ethernet/marvell/octeontx2/nic/otx2_common.c    | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index fb8db5888d2f..9886a02dd756 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -8,6 +8,7 @@
 #include <linux/interrupt.h>
 #include <linux/pci.h>
 #include <net/tso.h>
+#include <linux/sched/isolation.h>
 
 #include "otx2_reg.h"
 #include "otx2_common.h"
@@ -1657,9 +1658,16 @@ void otx2_set_cints_affinity(struct otx2_nic *pfvf)
 {
 	struct otx2_hw *hw = &pfvf->hw;
 	int vec, cpu, irq, cint;
+	cpumask_var_t mask;
+
+	if (!alloc_cpumask_var(&mask, GFP_KERNEL))
+		return;
+
+	cpumask_and(mask, cpu_online_mask,
+		    housekeeping_cpumask(HK_TYPE_DOMAIN));
+	cpu = cpumask_first(mask);
 
 	vec = hw->nix_msixoff + NIX_LF_CINT_VEC_START;
-	cpu = cpumask_first(cpu_online_mask);
 
 	/* CQ interrupts */
 	for (cint = 0; cint < pfvf->hw.cint_cnt; cint++, vec++) {
@@ -1671,10 +1679,11 @@ void otx2_set_cints_affinity(struct otx2_nic *pfvf)
 		irq = pci_irq_vector(pfvf->pdev, vec);
 		irq_set_affinity_hint(irq, hw->affinity_mask[vec]);
 
-		cpu = cpumask_next(cpu, cpu_online_mask);
+		cpu = cpumask_next(cpu, mask);
 		if (unlikely(cpu >= nr_cpu_ids))
 			cpu = 0;
 	}
+	free_cpumask_var(mask);
 }
 
 u16 otx2_get_max_mtu(struct otx2_nic *pfvf)
-- 
2.17.1

