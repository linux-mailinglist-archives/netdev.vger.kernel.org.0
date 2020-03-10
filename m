Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE5B8180104
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 16:04:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727718AbgCJPEK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 11:04:10 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:35920 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727693AbgCJPEJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 11:04:09 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02AEtvtW011748;
        Tue, 10 Mar 2020 08:04:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=KvX7DLdi1dWU3Wz5dlWkE2n1w8Gxut+P0tCzcRF2J2Y=;
 b=oSLOIpjNeGQ6vCme6vGQgD2Eh5z6vYB0jwt24c13ZiePEcH7cKb1VMUgp7KE4a8ECuT8
 bwp5FKgXYK/1ms96Ue95qPpUEH5Dbsj+pqVnk6Ei2ssTt0KyOH2eualA5HEO7l26sRWr
 yDvax3W+GunUbOP+r+49NhQ+YIjXCOtkhLU/fYApSpBa2qI67q4m1N3BFQiV66nmB25c
 +V+7THiS1L0euoecbLZ4h73b3x+T7U+WnUxH2rY8ZGlJdOC7uSHfJVYV/OYFQlMm3rRJ
 Y8cppF9Q5G0X4dPqv7YYO8rV9VLoROZ1k/8/yJ9CIAzwak7vIs4MSXgE4zyezQS6l1ea iw== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 2yp04fm0qk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 10 Mar 2020 08:04:06 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 10 Mar
 2020 08:04:04 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 10 Mar 2020 08:04:04 -0700
Received: from NN-LT0019.rdc.aquantia.com (nn-lt0019.marvell.com [10.9.16.69])
        by maili.marvell.com (Postfix) with ESMTP id 7CEFA3F7041;
        Tue, 10 Mar 2020 08:04:03 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     Mark Starovoytov <mstarovoitov@marvell.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Igor Russkikh <irusskikh@marvell.com>,
        Dmitry Bogdanov <dbogdanov@marvell.com>
Subject: [RFC v2 05/16] net: macsec: init secy pointer in macsec_context
Date:   Tue, 10 Mar 2020 18:03:31 +0300
Message-ID: <20200310150342.1701-6-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200310150342.1701-1-irusskikh@marvell.com>
References: <20200310150342.1701-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-10_08:2020-03-10,2020-03-10 signatures=0
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
index a88b41a79103..af41887d9a1e 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -1692,6 +1692,7 @@ static int macsec_add_rxsa(struct sk_buff *skb, struct genl_info *info)
 
 		ctx.sa.assoc_num = assoc_num;
 		ctx.sa.rx_sa = rx_sa;
+		ctx.secy = secy;
 		memcpy(ctx.sa.key, nla_data(tb_sa[MACSEC_SA_ATTR_KEY]),
 		       MACSEC_KEYID_LEN);
 
@@ -1733,6 +1734,7 @@ static int macsec_add_rxsc(struct sk_buff *skb, struct genl_info *info)
 	struct nlattr **attrs = info->attrs;
 	struct macsec_rx_sc *rx_sc;
 	struct nlattr *tb_rxsc[MACSEC_RXSC_ATTR_MAX + 1];
+	struct macsec_secy *secy;
 	bool was_active;
 	int ret;
 
@@ -1752,6 +1754,7 @@ static int macsec_add_rxsc(struct sk_buff *skb, struct genl_info *info)
 		return PTR_ERR(dev);
 	}
 
+	secy = &macsec_priv(dev)->secy;
 	sci = nla_get_sci(tb_rxsc[MACSEC_RXSC_ATTR_SCI]);
 
 	rx_sc = create_rx_sc(dev, sci);
@@ -1775,6 +1778,7 @@ static int macsec_add_rxsc(struct sk_buff *skb, struct genl_info *info)
 		}
 
 		ctx.rx_sc = rx_sc;
+		ctx.secy = secy;
 
 		ret = macsec_offload(ops->mdo_add_rxsc, &ctx);
 		if (ret)
@@ -1900,6 +1904,7 @@ static int macsec_add_txsa(struct sk_buff *skb, struct genl_info *info)
 
 		ctx.sa.assoc_num = assoc_num;
 		ctx.sa.tx_sa = tx_sa;
+		ctx.secy = secy;
 		memcpy(ctx.sa.key, nla_data(tb_sa[MACSEC_SA_ATTR_KEY]),
 		       MACSEC_KEYID_LEN);
 
@@ -1969,6 +1974,7 @@ static int macsec_del_rxsa(struct sk_buff *skb, struct genl_info *info)
 
 		ctx.sa.assoc_num = assoc_num;
 		ctx.sa.rx_sa = rx_sa;
+		ctx.secy = secy;
 
 		ret = macsec_offload(ops->mdo_del_rxsa, &ctx);
 		if (ret)
@@ -2034,6 +2040,7 @@ static int macsec_del_rxsc(struct sk_buff *skb, struct genl_info *info)
 		}
 
 		ctx.rx_sc = rx_sc;
+		ctx.secy = secy;
 		ret = macsec_offload(ops->mdo_del_rxsc, &ctx);
 		if (ret)
 			goto cleanup;
@@ -2092,6 +2099,7 @@ static int macsec_del_txsa(struct sk_buff *skb, struct genl_info *info)
 
 		ctx.sa.assoc_num = assoc_num;
 		ctx.sa.tx_sa = tx_sa;
+		ctx.secy = secy;
 
 		ret = macsec_offload(ops->mdo_del_txsa, &ctx);
 		if (ret)
@@ -2189,6 +2197,7 @@ static int macsec_upd_txsa(struct sk_buff *skb, struct genl_info *info)
 
 		ctx.sa.assoc_num = assoc_num;
 		ctx.sa.tx_sa = tx_sa;
+		ctx.secy = secy;
 
 		ret = macsec_offload(ops->mdo_upd_txsa, &ctx);
 		if (ret)
@@ -2269,6 +2278,7 @@ static int macsec_upd_rxsa(struct sk_buff *skb, struct genl_info *info)
 
 		ctx.sa.assoc_num = assoc_num;
 		ctx.sa.rx_sa = rx_sa;
+		ctx.secy = secy;
 
 		ret = macsec_offload(ops->mdo_upd_rxsa, &ctx);
 		if (ret)
@@ -2339,6 +2349,7 @@ static int macsec_upd_rxsc(struct sk_buff *skb, struct genl_info *info)
 		}
 
 		ctx.rx_sc = rx_sc;
+		ctx.secy = secy;
 
 		ret = macsec_offload(ops->mdo_upd_rxsc, &ctx);
 		if (ret)
@@ -3184,6 +3195,7 @@ static int macsec_dev_open(struct net_device *dev)
 			goto clear_allmulti;
 		}
 
+		ctx.secy = &macsec->secy;
 		err = macsec_offload(ops->mdo_dev_open, &ctx);
 		if (err)
 			goto clear_allmulti;
@@ -3215,8 +3227,10 @@ static int macsec_dev_stop(struct net_device *dev)
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

