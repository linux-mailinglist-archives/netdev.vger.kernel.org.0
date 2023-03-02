Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 135236A7A0B
	for <lists+netdev@lfdr.de>; Thu,  2 Mar 2023 04:29:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbjCBD3R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 22:29:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjCBD3Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 22:29:16 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AACB1630B;
        Wed,  1 Mar 2023 19:29:15 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 321JY32C025972;
        Wed, 1 Mar 2023 19:29:03 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=NNLvYJGSY6WpFKcOab3eDXfODfphueuuKW4IyeoblG4=;
 b=OY/sUO4RCUbRn5+sgxFk7hJKbUgBdrtM9sKxBq/Ko5AiyVpfh8uKu3vrQl31z0PM/Ulc
 5LQ9I/XxX/r+eUqNoVnIvTYdXtz6XLbas1v4zxzoCr2lnOEsqjXuZI40PGdAxkEGdF2X
 WABM6lXEL8j5VDma0jpCZnpOLHOtLsM8Rr/g+kkGzhCTd23XWvANKM8UMoDLgWWHjSvL
 HsIKkNExHiOvFKfypUOzaf2LCEYvmDmfYN0fhidHe1XE5tjJ8q25j6cbJI59ZS8f+Ck5
 3uNrI5ZgA70feIw2iutcvTsnOqq89ZwUHCOU6r1n4OTusyZ+KEwbnsjmCXKNf70ZpZGK Xg== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3p1wr9pmge-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 01 Mar 2023 19:29:03 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Wed, 1 Mar
 2023 19:29:01 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.42 via Frontend
 Transport; Wed, 1 Mar 2023 19:29:01 -0800
Received: from localhost.localdomain (unknown [10.28.36.165])
        by maili.marvell.com (Postfix) with ESMTP id 690215B6928;
        Wed,  1 Mar 2023 19:28:58 -0800 (PST)
From:   Ratheesh Kannoth <rkannoth@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <leon@kernel.org>
CC:     <sgoutham@marvell.com>, Ratheesh Kannoth <rkannoth@marvell.com>
Subject: [net PATCH] octeontx2-af: Fix start and end bit for scan config
Date:   Thu, 2 Mar 2023 08:58:55 +0530
Message-ID: <20230302032855.831573-1-rkannoth@marvell.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: J3q9HEDujG_aX_pNKG7Gvu8tZoNCcQwF
X-Proofpoint-GUID: J3q9HEDujG_aX_pNKG7Gvu8tZoNCcQwF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-01_17,2023-03-01_03,2023-02-09_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

for_each_set_bit_from() needs start bit as one bit prior
and end bit as one bit post position in the bit map

Fixes: 88fffc65f940 (octeontx2-af: Exact match scan from kex profile)
Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
Reviewed-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
index 327d3c6b1175..9c7bbef27e31 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
@@ -603,9 +603,8 @@ static int npc_scan_kex(struct rvu *rvu, int blkaddr, u8 intf)
 	 * exact match code.
 	 */
 	masked_cfg = cfg & NPC_EXACT_NIBBLE;
-	bitnr = NPC_EXACT_NIBBLE_START;
-	for_each_set_bit_from(bitnr, (unsigned long *)&masked_cfg,
-			      NPC_EXACT_NIBBLE_START) {
+	bitnr = NPC_EXACT_NIBBLE_START - 1;
+	for_each_set_bit_from(bitnr, (unsigned long *)&masked_cfg, NPC_EXACT_NIBBLE_END + 1) {
 		npc_scan_exact_result(mcam, bitnr, key_nibble, intf);
 		key_nibble++;
 	}
-- 
2.25.1

