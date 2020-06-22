Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75CC52035AB
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 13:26:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728042AbgFVLOd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 07:14:33 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:40838 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727113AbgFVLOb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 07:14:31 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05MB8QW8013162;
        Mon, 22 Jun 2020 04:14:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0818;
 bh=1QW1IxHoD3xSCenyj2u+wxcmHv8yzEDbcY1yUBAWXI0=;
 b=ZyUnXi0Cd/8gUahYpuripPgvK9oZAlKCp0+NqAc6R+y+6EVL4us+6UTAkNYWwZfmC/me
 eS7ICzwW6EQNgJlI90bWAxFL8ZDhGDimL920NIxXwX2wITVc/OqzrtxCx3l9ZFDbmjNt
 /Lt1oygBy+0pIQU7o+IV16n5Fv+Kwg/5ZBYXbe/sD11wwBhy0XB0Jy13v/xHQWW9iVw4
 n2B5qCDfaWs7em4Bm2unKEMTgQ1FB2lZ2Llnvsutz/xZvfs8UsDnYkMoc3miw9IIiCDV
 VmceCTcIMPfXQXU9fhy4YT4ja0cBkhwCETDIp+slAvMI4aFBBlhAjVOLKToEzb8MTQ5J TQ== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 31shynqpa2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 22 Jun 2020 04:14:28 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 22 Jun
 2020 04:14:26 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 22 Jun 2020 04:14:26 -0700
Received: from NN-LT0049.marvell.com (unknown [10.193.39.36])
        by maili.marvell.com (Postfix) with ESMTP id 2EBE23F703F;
        Mon, 22 Jun 2020 04:14:21 -0700 (PDT)
From:   Alexander Lobakin <alobakin@marvell.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Igor Russkikh <irusskikh@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        Ariel Elior <aelior@marvell.com>,
        Yuval Mintz <yuval.mintz@marvell.com>,
        Denis Bolotin <denis.bolotin@marvell.com>,
        "Ram Amrani" <ram.amrani@marvell.com>,
        Tomer Tayar <tomer.tayar@marvell.com>,
        Alexander Lobakin <alobakin@marvell.com>,
        <GR-everest-linux-l2@marvell.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net 1/9] net: qed: fix left elements count calculation
Date:   Mon, 22 Jun 2020 14:14:05 +0300
Message-ID: <20200622111413.7006-2-alobakin@marvell.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200622111413.7006-1-alobakin@marvell.com>
References: <20200622111413.7006-1-alobakin@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-22_04:2020-06-22,2020-06-22 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

qed_chain_get_element_left{,_u32} returned 0 when the difference
between producer and consumer page count was equal to the total
page count.
Fix this by conditional expanding of producer value (vs
unconditional). This allowed to eliminate normalizaton against
total page count, which was the cause of this bug.

Misc: replace open-coded constants with common defines.

Fixes: a91eb52abb50 ("qed: Revisit chain implementation")
Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
---
 include/linux/qed/qed_chain.h | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/include/linux/qed/qed_chain.h b/include/linux/qed/qed_chain.h
index 733fad7dfbed..6d15040c642c 100644
--- a/include/linux/qed/qed_chain.h
+++ b/include/linux/qed/qed_chain.h
@@ -207,28 +207,34 @@ static inline u32 qed_chain_get_cons_idx_u32(struct qed_chain *p_chain)
 
 static inline u16 qed_chain_get_elem_left(struct qed_chain *p_chain)
 {
+	u16 elem_per_page = p_chain->elem_per_page;
+	u32 prod = p_chain->u.chain16.prod_idx;
+	u32 cons = p_chain->u.chain16.cons_idx;
 	u16 used;
 
-	used = (u16) (((u32)0x10000 +
-		       (u32)p_chain->u.chain16.prod_idx) -
-		      (u32)p_chain->u.chain16.cons_idx);
+	if (prod < cons)
+		prod += (u32)U16_MAX + 1;
+
+	used = (u16)(prod - cons);
 	if (p_chain->mode == QED_CHAIN_MODE_NEXT_PTR)
-		used -= p_chain->u.chain16.prod_idx / p_chain->elem_per_page -
-		    p_chain->u.chain16.cons_idx / p_chain->elem_per_page;
+		used -= prod / elem_per_page - cons / elem_per_page;
 
 	return (u16)(p_chain->capacity - used);
 }
 
 static inline u32 qed_chain_get_elem_left_u32(struct qed_chain *p_chain)
 {
+	u16 elem_per_page = p_chain->elem_per_page;
+	u64 prod = p_chain->u.chain32.prod_idx;
+	u64 cons = p_chain->u.chain32.cons_idx;
 	u32 used;
 
-	used = (u32) (((u64)0x100000000ULL +
-		       (u64)p_chain->u.chain32.prod_idx) -
-		      (u64)p_chain->u.chain32.cons_idx);
+	if (prod < cons)
+		prod += (u64)U32_MAX + 1;
+
+	used = (u32)(prod - cons);
 	if (p_chain->mode == QED_CHAIN_MODE_NEXT_PTR)
-		used -= p_chain->u.chain32.prod_idx / p_chain->elem_per_page -
-		    p_chain->u.chain32.cons_idx / p_chain->elem_per_page;
+		used -= (u32)(prod / elem_per_page - cons / elem_per_page);
 
 	return p_chain->capacity - used;
 }
-- 
2.21.0

