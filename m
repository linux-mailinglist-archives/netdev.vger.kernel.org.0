Return-Path: <netdev+bounces-9970-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D529172B7EB
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 08:06:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 903EA2809A6
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 06:06:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E6D1257E;
	Mon, 12 Jun 2023 06:05:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 117EB2570
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 06:05:04 +0000 (UTC)
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5961D10D3;
	Sun, 11 Jun 2023 23:05:02 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35C0Zi02020371;
	Sun, 11 Jun 2023 23:04:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=ErVcLXGUDcy7EtV178w/W1jH5B7U8cyHMEzW9irMO0o=;
 b=RLcexpIngzrC4YlpaywhmlWye4dmXTtcOp3C8ClC1QdQEMmtn32HjBHnnQWd9ODQU3Nc
 lx5EpJxaHWcZCB7DhPm9CgXBjoFfezf1Igc5DGmTNRCXCnU2gTgA8u9+03LSuw3aGodz
 mxR8aF46lE54Bh9rB6UnSop9gkXW3X638oKKib/7/kOmiYBs5ycJ3HNumgptkZOV0MLC
 vu3EO8p2GHGQ7q6VaZOSZcCg2Uk0V4vf+q8WFRetbaCA5bTcbG/V7QVYsGUT21JHf3Wo
 CyU9LTWqjUCXdvMRQSsMf/VroEt/inuSFMpX9DQBHQtgPDQy6xA9eAzMmyr80k+zYrnl Ag== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3r4rpkbenx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
	Sun, 11 Jun 2023 23:04:47 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Sun, 11 Jun
 2023 23:04:45 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Sun, 11 Jun 2023 23:04:45 -0700
Received: from #hyd1583.marvell.com (unknown [10.29.37.44])
	by maili.marvell.com (Postfix) with ESMTP id 570275B6942;
	Sun, 11 Jun 2023 23:04:42 -0700 (PDT)
From: Naveen Mamindlapalli <naveenm@marvell.com>
To: <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <sgoutham@marvell.com>
CC: Nithin Dabilpuram <ndabilpuram@marvell.com>,
        Jerin Jacob Kollanukkaran
	<jerinj@marvell.com>,
        Naveen Mamindlapalli <naveenm@marvell.com>
Subject: [net-next PATCH v2 5/6] octeontx2-af: add option to toggle DROP_RE enable in rx cfg
Date: Mon, 12 Jun 2023 11:34:23 +0530
Message-ID: <20230612060424.1427-6-naveenm@marvell.com>
X-Mailer: git-send-email 2.39.0.198.ga38d39a4c5
In-Reply-To: <20230612060424.1427-1-naveenm@marvell.com>
References: <20230612060424.1427-1-naveenm@marvell.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: Ws-BWVlaxE13uaobi8QCnzCnm0uaD6Mu
X-Proofpoint-GUID: Ws-BWVlaxE13uaobi8QCnzCnm0uaD6Mu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-12_03,2023-06-09_01,2023-05-22_02
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Nithin Dabilpuram <ndabilpuram@marvell.com>

Add option to toggle DROP_RE bit in rx cfg mbox. This helps in
modifying the config runtime as opposed to setting available via
nix_lf_alloc() mbox at NIX LF init time.

Signed-off-by: Nithin Dabilpuram <ndabilpuram@marvell.com>
Signed-off-by: Jerin Jacob Kollanukkaran <jerinj@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h    | 1 +
 drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index 1794ef0f9ae0..eba307eee2b2 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -1157,6 +1157,7 @@ struct nix_rx_cfg {
 	struct mbox_msghdr hdr;
 #define NIX_RX_OL3_VERIFY   BIT(0)
 #define NIX_RX_OL4_VERIFY   BIT(1)
+#define NIX_RX_DROP_RE      BIT(2)
 	u8 len_verify; /* Outer L3/L4 len check */
 #define NIX_RX_CSUM_OL4_VERIFY  BIT(0)
 	u8 csum_verify; /* Outer L4 checksum verification */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 8a89cc5e5e40..23149036be77 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -4196,6 +4196,11 @@ int rvu_mbox_handler_nix_set_rx_cfg(struct rvu *rvu, struct nix_rx_cfg *req,
 	else
 		cfg &= ~BIT_ULL(40);
 
+	if (req->len_verify & NIX_RX_DROP_RE)
+		cfg |= BIT_ULL(32);
+	else
+		cfg &= ~BIT_ULL(32);
+
 	if (req->csum_verify & BIT(0))
 		cfg |= BIT_ULL(37);
 	else
-- 
2.39.0.198.ga38d39a4c5


