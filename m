Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1B49535AE6
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 10:01:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244767AbiE0IAx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 04:00:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233820AbiE0IAt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 04:00:49 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB9F331923;
        Fri, 27 May 2022 01:00:48 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24R7IWFc023100;
        Fri, 27 May 2022 00:59:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=8xXRJisppYweSmA8I0oE3va1N5s89FNW4+TyQk46JvI=;
 b=hUsZsG22ciksNmFzGDav1sfXHWa3c30y1WCsgcuRx+9iT09cQz/dBIe5N7EuAjMQL4LC
 9dq3q7xjEFNUW/uC0Bh9OvJ14eX/58YVtensLm0YHGQM3LRX3L4ktGGogLG3QfglHWH5
 1DhMxIP7JTovNRD01dZjktd0UugRM7jkh4AdsAz4w8XlU3C9Q4wOF9zbpEzwQ7ODCZt3
 rxGBuIGwqpBIqsLJnZ9gJWdas+LSYDDyGIZU4xjhmPbJcrKjTQhMkZafxvzd2pm+O3Rd
 J9pgfKQp3PnBcQoB+Plhf1lNnfEAH58RlY+nniHRBiZPzanWeHppBm9c6rf2oLAzdOZE XA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3g93tycqna-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 27 May 2022 00:59:59 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 27 May
 2022 00:59:57 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Fri, 27 May 2022 00:59:57 -0700
Received: from localhost.localdomain (unknown [10.28.34.29])
        by maili.marvell.com (Postfix) with ESMTP id 3CBA63F7065;
        Fri, 27 May 2022 00:59:53 -0700 (PDT)
From:   Shijith Thotton <sthotton@marvell.com>
To:     Arnaud Ebalard <arno@natisbad.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Boris Brezillon <bbrezillon@kernel.org>
CC:     Shijith Thotton <sthotton@marvell.com>,
        <linux-crypto@vger.kernel.org>, <jerinj@marvell.com>,
        <sgoutham@marvell.com>, Linu Cherian <lcherian@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "open list:MARVELL OCTEONTX2 RVU ADMIN FUNCTION DRIVER" 
        <netdev@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Subject: [PATCH] octeontx2-af: fix operand size in bitwise operation
Date:   Fri, 27 May 2022 13:29:28 +0530
Message-ID: <6baefc0e5cddb99df98b6a96a15fbd0328b12bda.1653637964.git.sthotton@marvell.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: 4kUlaroqSe8q7ZxO_YQ6Lnrts-MsjhoV
X-Proofpoint-ORIG-GUID: 4kUlaroqSe8q7ZxO_YQ6Lnrts-MsjhoV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-27_02,2022-05-25_02,2022-02-23_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Made size of operands same in bitwise operations.

The patch fixes the klocwork issue, operands in a bitwise operation have
different size at line 375 and 483.

Signed-off-by: Shijith Thotton <sthotton@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
index a79201a9a6f0..d08cddb651fb 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
@@ -17,7 +17,7 @@
 #define	PCI_DEVID_OTX2_CPT10K_PF 0xA0F2
 
 /* Length of initial context fetch in 128 byte words */
-#define CPT_CTX_ILEN    2
+#define CPT_CTX_ILEN    2ULL
 
 #define cpt_get_eng_sts(e_min, e_max, rsp, etype)                   \
 ({                                                                  \
@@ -480,7 +480,7 @@ static int cpt_inline_ipsec_cfg_inbound(struct rvu *rvu, int blkaddr, u8 cptlf,
 	 */
 	if (!is_rvu_otx2(rvu)) {
 		val = (ilog2(NIX_CHAN_CPT_X2P_MASK + 1) << 16);
-		val |= rvu->hw->cpt_chan_base;
+		val |= (u64)rvu->hw->cpt_chan_base;
 
 		rvu_write64(rvu, blkaddr, CPT_AF_X2PX_LINK_CFG(0), val);
 		rvu_write64(rvu, blkaddr, CPT_AF_X2PX_LINK_CFG(1), val);
-- 
2.25.1

