Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBFC018F56D
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 14:14:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728404AbgCWNO4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 09:14:56 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:55298 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728240AbgCWNOz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 09:14:55 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02ND6OGY010599;
        Mon, 23 Mar 2020 06:14:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=AfJvl4YQkpPHf0YXHp9mM8O4lFNcbvonW9a0wXBuoLo=;
 b=K2OZJhzQJUgdFzx+MPzLWGMBrfhxCqEzvYyITI/9122gLZrQHYLY9AHv29sF71cjTL5w
 LCD0jK4TxgcLPCKYbciXVUJ9nb09wp7h4ymS5IkI2vKwC/IYaar3ncUrmZ/bQiipM2wD
 NvJXoN63TG0JWlIe58UQwEakGhoJpZjqDgCYUDnxMd0v2QYgnz23xu2UDyoX49pPnf4l
 IeOJPff9gzRbq3cyVUGjEJ4+Ii3hgM4bmJ7YyLy5/AFyUOCHKY9GFTOUhO8nCtwdl8K/
 csijgjSCFpVK6+CEXD8nIixTeKmwnIPAcz/9DILBsjW7aDnTzXFEXNA0IIC/Tdd4G56e lQ== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 2ywg9nefqg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 23 Mar 2020 06:14:52 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 23 Mar
 2020 06:14:50 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 23 Mar 2020 06:14:50 -0700
Received: from localhost.localdomain (unknown [10.9.16.91])
        by maili.marvell.com (Postfix) with ESMTP id 1E2813F7041;
        Mon, 23 Mar 2020 06:14:48 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     Mark Starovoytov <mstarovoitov@marvell.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        "Dmitry Bogdanov" <dbogdanov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH net-next 05/17] net: macsec: init secy pointer in macsec_context
Date:   Mon, 23 Mar 2020 16:13:36 +0300
Message-ID: <20200323131348.340-6-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200323131348.340-1-irusskikh@marvell.com>
References: <20200323131348.340-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-23_04:2020-03-21,2020-03-23 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmitry Bogdanov <dbogdanov@marvell.com>

This patch adds secy pointer initialization in the macsec_context.
It will be used by MAC drivers in offloading operations.

Signed-off-by: Dmitry Bogdanov <dbogdanov@marvell.com>
Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 drivers/net/macsec.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index c4d5f609871e..0f6808f3ff91 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -1793,6 +1793,7 @@ static int macsec_add_rxsa(struct sk_buff *skb, struct genl_info *info)
 
 		ctx.sa.assoc_num = assoc_num;
 		ctx.sa.rx_sa = rx_sa;
+		ctx.secy = secy;
 		memcpy(ctx.sa.key, nla_data(tb_sa[MACSEC_SA_ATTR_KEY]),
 		       MACSEC_KEYID_LEN);
 
@@ -1840,6 +1841,7 @@ static int macsec_add_rxsc(struct sk_buff *skb, struct genl_info *info)
 	struct nlattr **attrs = info->attrs;
 	struct macsec_rx_sc *rx_sc;
 	struct nlattr *tb_rxsc[MACSEC_RXSC_ATTR_MAX + 1];
+	struct macsec_secy *secy;
 	bool was_active;
 	int ret;
 
@@ -1859,6 +1861,7 @@ static int macsec_add_rxsc(struct sk_buff *skb, struct genl_info *info)
 		return PTR_ERR(dev);
 	}
 
+	secy = &macsec_priv(dev)->secy;
 	sci = nla_get_sci(tb_rxsc[MACSEC_RXSC_ATTR_SCI]);
 
 	rx_sc = create_rx_sc(dev, sci);
@@ -1882,6 +1885,7 @@ static int macsec_add_rxsc(struct sk_buff *skb, struct genl_info *info)
 		}
 
 		ctx.rx_sc = rx_sc;
+		ctx.secy = secy;
 
 		ret = macsec_offload(ops->mdo_add_rxsc, &ctx);
 		if (ret)
@@ -2031,6 +2035,7 @@ static int macsec_add_txsa(struct sk_buff *skb, struct genl_info *info)
 
 		ctx.sa.assoc_num = assoc_num;
 		ctx.sa.tx_sa = tx_sa;
+		ctx.secy = secy;
 		memcpy(ctx.sa.key, nla_data(tb_sa[MACSEC_SA_ATTR_KEY]),
 		       MACSEC_KEYID_LEN);
 
@@ -2106,6 +2111,7 @@ static int macsec_del_rxsa(struct sk_buff *skb, struct genl_info *info)
 
 		ctx.sa.assoc_num = assoc_num;
 		ctx.sa.rx_sa = rx_sa;
+		ctx.secy = secy;
 
 		ret = macsec_offload(ops->mdo_del_rxsa, &ctx);
 		if (ret)
@@ -2171,6 +2177,7 @@ static int macsec_del_rxsc(struct sk_buff *skb, struct genl_info *info)
 		}
 
 		ctx.rx_sc = rx_sc;
+		ctx.secy = secy;
 		ret = macsec_offload(ops->mdo_del_rxsc, &ctx);
 		if (ret)
 			goto cleanup;
@@ -2229,6 +2236,7 @@ static int macsec_del_txsa(struct sk_buff *skb, struct genl_info *info)
 
 		ctx.sa.assoc_num = assoc_num;
 		ctx.sa.tx_sa = tx_sa;
+		ctx.secy = secy;
 
 		ret = macsec_offload(ops->mdo_del_txsa, &ctx);
 		if (ret)
@@ -2340,6 +2348,7 @@ static int macsec_upd_txsa(struct sk_buff *skb, struct genl_info *info)
 
 		ctx.sa.assoc_num = assoc_num;
 		ctx.sa.tx_sa = tx_sa;
+		ctx.secy = secy;
 
 		ret = macsec_offload(ops->mdo_upd_txsa, &ctx);
 		if (ret)
@@ -2432,6 +2441,7 @@ static int macsec_upd_rxsa(struct sk_buff *skb, struct genl_info *info)
 
 		ctx.sa.assoc_num = assoc_num;
 		ctx.sa.rx_sa = rx_sa;
+		ctx.secy = secy;
 
 		ret = macsec_offload(ops->mdo_upd_rxsa, &ctx);
 		if (ret)
@@ -2502,6 +2512,7 @@ static int macsec_upd_rxsc(struct sk_buff *skb, struct genl_info *info)
 		}
 
 		ctx.rx_sc = rx_sc;
+		ctx.secy = secy;
 
 		ret = macsec_offload(ops->mdo_upd_rxsc, &ctx);
 		if (ret)
@@ -3369,6 +3380,7 @@ static int macsec_dev_open(struct net_device *dev)
 			goto clear_allmulti;
 		}
 
+		ctx.secy = &macsec->secy;
 		err = macsec_offload(ops->mdo_dev_open, &ctx);
 		if (err)
 			goto clear_allmulti;
@@ -3400,8 +3412,10 @@ static int macsec_dev_stop(struct net_device *dev)
 		struct macsec_context ctx;
 
 		ops = macsec_get_ops(macsec, &ctx);
-		if (ops)
+		if (ops) {
+			ctx.secy = &macsec->secy;
 			macsec_offload(ops->mdo_dev_stop, &ctx);
+		}
 	}
 
 	dev_mc_unsync(real_dev, dev);
-- 
2.17.1

