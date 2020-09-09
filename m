Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8D2E2634DB
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 19:44:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbgIIRoG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 13:44:06 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:59470 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728936AbgIIRnx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 13:43:53 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 089HfWiN013639;
        Wed, 9 Sep 2020 10:43:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=Hx1RagAJ72K8MWwE4yvTpgHOlfP7rTF/AX459NvVHGY=;
 b=E/EaNwFdiMPSiai/lRb4laOLEvvtLk0cpXI74APnxwex4wX25hSM+joOBMom103doyWK
 +z4hxdcli7GbBYCAA12eEoOKEVCLuGjV3zZNvUuKrZQ2nLe9nEl19FYMIL9K53Pgbzrb
 cETCnob3KHCYfGne9CDdAFHnxuZScscEIG+puSwE9PSxFFPf4Ndor9lamLWmoG4BDgQQ
 Em/QG6xeIV/6uBzOBPVs/fIOg8h471udNhE0syUVtKZeJHnw+uR39tMrlKQSii66dXiN
 Lz2L15cZpaAXgCTiphgXW6aYy/Ii7UHRSpi+sVJaR3lf2LJgKgLGORPctR69cVjAWRq4 Cg== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 33ccvr7gyb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 09 Sep 2020 10:43:50 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 9 Sep
 2020 10:43:48 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 9 Sep 2020 10:43:49 -0700
Received: from NN-LT0019.marvell.com (NN-LT0019.marvell.com [10.6.200.75])
        by maili.marvell.com (Postfix) with ESMTP id B4B403F703F;
        Wed,  9 Sep 2020 10:43:46 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Dmitry Bogdanov <dbogdanov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        "Michal Kalderon" <michal.kalderon@marvell.com>
Subject: [PATCH v3 net 3/3] net: qed: RDMA personality shouldn't fail VF load
Date:   Wed, 9 Sep 2020 20:43:10 +0300
Message-ID: <20200909174310.686-4-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200909174310.686-1-irusskikh@marvell.com>
References: <20200909174310.686-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-09_13:2020-09-09,2020-09-09 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmitry Bogdanov <dbogdanov@marvell.com>

Fix the assert during VF driver installation when the personality is iWARP

Fixes: 1fe614d10f45 ("qed: Relax VF firmware requirements")
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
Signed-off-by: Dmitry Bogdanov <dbogdanov@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_sriov.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_sriov.c b/drivers/net/ethernet/qlogic/qed/qed_sriov.c
index f1f75b6d0421..b8dc5c4591ef 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_sriov.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_sriov.c
@@ -71,6 +71,7 @@ static int qed_sp_vf_start(struct qed_hwfn *p_hwfn, struct qed_vf_info *p_vf)
 		p_ramrod->personality = PERSONALITY_ETH;
 		break;
 	case QED_PCI_ETH_ROCE:
+	case QED_PCI_ETH_IWARP:
 		p_ramrod->personality = PERSONALITY_RDMA_AND_ETH;
 		break;
 	default:
-- 
2.17.1

