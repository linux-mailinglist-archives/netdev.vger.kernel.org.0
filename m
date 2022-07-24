Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 590AE57F579
	for <lists+netdev@lfdr.de>; Sun, 24 Jul 2022 16:17:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233775AbiGXORf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jul 2022 10:17:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231493AbiGXORa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jul 2022 10:17:30 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1288813CFA
        for <netdev@vger.kernel.org>; Sun, 24 Jul 2022 07:17:30 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26OBigJx010169;
        Sun, 24 Jul 2022 07:17:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=e4NyC5ZXHIe2s5Q+D9KtWoT/QysYKhBEYhppcVEcjkM=;
 b=A4jeTLVdxzIgVL5qpA2yezG8wF8wpJ3Gvm8Zh2aUs/NUNKKd5yJaDzJfVr8ZxjYYi3N3
 dOqueCQvP+tWs1EEkugJeZKIHmS386xz8PiGJiniFDdVsBZqAMV25vvDM8WxxlrJ5jmg
 OVoz6peZPZ+y4DD5/jzwnmlEFIZ3b6CbGZIB6wTDl38aGgtC4Td5Wflk/xUjpTafhCzP
 Ie3/XzjTL9lGXydgiVa4B4ILI2671Gf8vxGRxbyB9/qIVfdmZVm9fUVZAoi/oP4snrPa
 CpiGBnVrIewxXa1FmXzD5xpZIioP9ATZwJpFRTX2clj/a2NbyDmxkg03Lda6W8Q9qJ8O 2w== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3hgebq32qn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 24 Jul 2022 07:17:28 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 24 Jul
 2022 07:17:09 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 24 Jul 2022 07:17:09 -0700
Received: from hyd1358.marvell.com (unknown [10.29.37.11])
        by maili.marvell.com (Postfix) with ESMTP id DE62A5E6895;
        Sun, 24 Jul 2022 07:17:03 -0700 (PDT)
From:   Subbaraya Sundeep <sbhatta@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <sgoutham@marvell.com>,
        <netdev@vger.kernel.org>
CC:     Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [net PATCH 5/5] octeontx2-af: Fix key checking for source mac
Date:   Sun, 24 Jul 2022 19:46:49 +0530
Message-ID: <1658672209-8837-6-git-send-email-sbhatta@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1658672209-8837-1-git-send-email-sbhatta@marvell.com>
References: <1658672209-8837-1-git-send-email-sbhatta@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: PmuDNWw9W0-X5ret5w_dD2Fh-uY2yE4X
X-Proofpoint-ORIG-GUID: PmuDNWw9W0-X5ret5w_dD2Fh-uY2yE4X
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-23_02,2022-07-21_02,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Given a field with its location/offset in input packet,
the key checking logic verifies whether extracting the
field can be supported or not based on the mkex profile
loaded in hardware. This logic is wrong wrt source mac
and this patch fixes that.

Fixes: 9b179a960a96 ("octeontx2-af: Generate key field bit mask from KEX profile")
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
index 0a163fa..fc744cf 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
@@ -462,7 +462,8 @@ do {									       \
 	NPC_SCAN_HDR(NPC_VLAN_TAG1, NPC_LID_LB, NPC_LT_LB_CTAG, 2, 2);
 	NPC_SCAN_HDR(NPC_VLAN_TAG2, NPC_LID_LB, NPC_LT_LB_STAG_QINQ, 2, 2);
 	NPC_SCAN_HDR(NPC_DMAC, NPC_LID_LA, la_ltype, la_start, 6);
-	NPC_SCAN_HDR(NPC_SMAC, NPC_LID_LA, la_ltype, la_start, 6);
+	/* SMAC follows the DMAC(which is 6 bytes) */
+	NPC_SCAN_HDR(NPC_SMAC, NPC_LID_LA, la_ltype, la_start + 6, 6);
 	/* PF_FUNC is 2 bytes at 0th byte of NPC_LT_LA_IH_NIX_ETHER */
 	NPC_SCAN_HDR(NPC_PF_FUNC, NPC_LID_LA, NPC_LT_LA_IH_NIX_ETHER, 0, 2);
 }
-- 
2.7.4

