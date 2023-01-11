Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5DAA665B50
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 13:25:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238018AbjAKMYx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 07:24:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233901AbjAKMYZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 07:24:25 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37B2BE0BC
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 04:24:24 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30B9ZwoD016326;
        Wed, 11 Jan 2023 04:24:18 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=H3n4mngFffvhQwSvaC5r1UX99YdZT3eZQWuAFZW+VWM=;
 b=a6gYls6Fqv2cPP5lNg0cPFBDFubXOJE0WLMTFvN1Dgu4j9jWnQY7yeLznP8OZWOBTDR0
 hgWuJOqk+y+yAWU2KWFXbP/5vt/+txLxQ+Ab2egzqhGmG3cKQgpyFdoevXdGjHhYgQ91
 kW0c+OXQv31TZ0WOhZYD0r1/GFHpfexB4KYddqMJFYbLehslSyX5PGjwlNlk/3p042qc
 clZ2CYfZQEIYC1D7FaN8xcrNdwZo6Tg5bNJlLlW6BGTYacxexdezGXaMZyzO8vKCVPK3
 B/Ucv0U9idO3Z1cBF1ZgSyvj2B1nKG50dWm597AeOWilu8AdxMN/0X3USVLabTGCAnZp qA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3n1k56t55g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 11 Jan 2023 04:24:18 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Wed, 11 Jan
 2023 04:24:15 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.42 via Frontend
 Transport; Wed, 11 Jan 2023 04:24:15 -0800
Received: from localhost.localdomain (unknown [10.28.36.175])
        by maili.marvell.com (Postfix) with ESMTP id B9C1A3F7051;
        Wed, 11 Jan 2023 04:24:11 -0800 (PST)
From:   Srujana Challa <schalla@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <jerinj@marvell.com>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>, <schalla@marvell.com>
Subject: [PATCH v2 net-next,7/8] octeontx2-af: add ctx ilen to cpt lf alloc mailbox
Date:   Wed, 11 Jan 2023 17:53:42 +0530
Message-ID: <20230111122343.928694-8-schalla@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230111122343.928694-1-schalla@marvell.com>
References: <20230111122343.928694-1-schalla@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: WBot73-CdcSsLncoD0ONv0qy3qPuIWt6
X-Proofpoint-GUID: WBot73-CdcSsLncoD0ONv0qy3qPuIWt6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-11_05,2023-01-11_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adds ctx_ilen to CPT_LF_ALLOC mailbox to provide
the provison to user to give CPT_AF_LFX_CTL:ctx_ilen.

Signed-off-by: Srujana Challa <schalla@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h    |  2 ++
 drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c | 10 +++++++---
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index 9eac73bfc9cb..abe86778b064 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -1614,6 +1614,8 @@ struct cpt_lf_alloc_req_msg {
 	u16 sso_pf_func;
 	u16 eng_grpmsk;
 	int blkaddr;
+	u8 ctx_ilen_valid : 1;
+	u8 ctx_ilen : 7;
 };
 
 #define CPT_INLINE_INBOUND      0
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
index 302ff549284e..d7ca7e953683 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
@@ -17,7 +17,7 @@
 #define	PCI_DEVID_OTX2_CPT10K_PF 0xA0F2
 
 /* Length of initial context fetch in 128 byte words */
-#define CPT_CTX_ILEN    2ULL
+#define CPT_CTX_ILEN    1ULL
 
 #define cpt_get_eng_sts(e_min, e_max, rsp, etype)                   \
 ({                                                                  \
@@ -421,8 +421,12 @@ int rvu_mbox_handler_cpt_lf_alloc(struct rvu *rvu,
 
 		/* Set CPT LF group and priority */
 		val = (u64)req->eng_grpmsk << 48 | 1;
-		if (!is_rvu_otx2(rvu))
-			val |= (CPT_CTX_ILEN << 17);
+		if (!is_rvu_otx2(rvu)) {
+			if (req->ctx_ilen_valid)
+				val |= (req->ctx_ilen << 17);
+			else
+				val |= (CPT_CTX_ILEN << 17);
+		}
 
 		rvu_write64(rvu, blkaddr, CPT_AF_LFX_CTL(cptlf), val);
 
-- 
2.25.1

