Return-Path: <netdev+bounces-9190-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 54E2B727D3C
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 12:52:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ACD531C2100F
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 10:51:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2F8AC8E7;
	Thu,  8 Jun 2023 10:50:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B644111187
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 10:50:41 +0000 (UTC)
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E770E2D69;
	Thu,  8 Jun 2023 03:50:36 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35887B8X023585;
	Thu, 8 Jun 2023 03:50:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=3yaqcdBg41d7mhWAoxcGyVDU3b5DBL/sd2gMwajYnRY=;
 b=KIXCVREOZ/ZZ/GFs7DJsZquDuxUby+JLkS67P82Vj7oZEn+ZdHbWLSenFogiBfIv69xA
 aV6ahY3h6nsZNHClsSXPgEnQkVPweiWFrok+XQIJ/1cBRJF8VocpAHmRU2PUYtJbCSLU
 RmBtY4ZJwGk9g44vVIE7b4toVM5erKM/UifzgVr8MvTMFC2Id8Up+A2vwvmuMxfrxXQH
 pO7zkRitrYzwBvESOvPo9nTVzLyBCj6W9dxqN11iYPh9sVFg1JVacLb6++ny7e83H+wR
 03nz4TTrXO3oHhE0QlzroZumKOkc2Eio1wEkiwtkoCWWd7nfJKZteM5cn5ihmVPiChdY 5A== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3r329c2c3c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
	Thu, 08 Jun 2023 03:50:30 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Thu, 8 Jun
 2023 03:50:28 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Thu, 8 Jun 2023 03:50:28 -0700
Received: from #hyd1583.marvell.com (unknown [10.29.37.44])
	by maili.marvell.com (Postfix) with ESMTP id 90D623F707F;
	Thu,  8 Jun 2023 03:50:25 -0700 (PDT)
From: Naveen Mamindlapalli <naveenm@marvell.com>
To: <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <sgoutham@marvell.com>
CC: Nithin Dabilpuram <ndabilpuram@marvell.com>,
        Jerin Jacob Kollanukkaran
	<jerinj@marvell.com>,
        Naveen Mamindlapalli <naveenm@marvell.com>
Subject: [net-next PATCH 5/6] octeontx2-af: add option to toggle DROP_RE enable in rx cfg
Date: Thu, 8 Jun 2023 16:20:06 +0530
Message-ID: <20230608105007.26924-6-naveenm@marvell.com>
X-Mailer: git-send-email 2.39.0.198.ga38d39a4c5
In-Reply-To: <20230608105007.26924-1-naveenm@marvell.com>
References: <20230608105007.26924-1-naveenm@marvell.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: 6QVY8VUU-nGZ68CMqLXeJgI5jlPPdlD4
X-Proofpoint-ORIG-GUID: 6QVY8VUU-nGZ68CMqLXeJgI5jlPPdlD4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-08_07,2023-06-08_01,2023-05-22_02
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
index f233f98cbeea..3f30db28eff1 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -1151,6 +1151,7 @@ struct nix_rx_cfg {
 	struct mbox_msghdr hdr;
 #define NIX_RX_OL3_VERIFY   BIT(0)
 #define NIX_RX_OL4_VERIFY   BIT(1)
+#define NIX_RX_DROP_RE      BIT(2)
 	u8 len_verify; /* Outer L3/L4 len check */
 #define NIX_RX_CSUM_OL4_VERIFY  BIT(0)
 	u8 csum_verify; /* Outer L4 checksum verification */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 842ee9909af4..18a146e9c4ef 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -4130,6 +4130,11 @@ int rvu_mbox_handler_nix_set_rx_cfg(struct rvu *rvu, struct nix_rx_cfg *req,
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


