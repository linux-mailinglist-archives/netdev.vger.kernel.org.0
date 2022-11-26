Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB938639598
	for <lists+netdev@lfdr.de>; Sat, 26 Nov 2022 12:03:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbiKZLDU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Nov 2022 06:03:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbiKZLDM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Nov 2022 06:03:12 -0500
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C262118E20
        for <netdev@vger.kernel.org>; Sat, 26 Nov 2022 03:03:10 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 10CF820501;
        Sat, 26 Nov 2022 12:03:09 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id l63CdphWmWWR; Sat, 26 Nov 2022 12:03:08 +0100 (CET)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id AD1732035C;
        Sat, 26 Nov 2022 12:03:07 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id A816C80004A;
        Sat, 26 Nov 2022 12:03:07 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 26 Nov 2022 12:03:07 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Sat, 26 Nov
 2022 12:03:06 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 40A083183C54; Sat, 26 Nov 2022 12:03:06 +0100 (CET)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 09/10] xfrm: add extack to xfrm_alloc_userspi
Date:   Sat, 26 Nov 2022 12:03:02 +0100
Message-ID: <20221126110303.1859238-10-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221126110303.1859238-1-steffen.klassert@secunet.com>
References: <20221126110303.1859238-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sabrina Dubroca <sd@queasysnail.net>

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 include/net/xfrm.h    |  5 +++--
 net/key/af_key.c      |  4 ++--
 net/xfrm/xfrm_state.c | 21 ++++++++++++++++-----
 net/xfrm/xfrm_user.c  |  8 +++++---
 4 files changed, 26 insertions(+), 12 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 576566bd0be9..e0cc6791c001 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -1681,8 +1681,9 @@ struct xfrm_policy *xfrm_policy_byid(struct net *net,
 int xfrm_policy_flush(struct net *net, u8 type, bool task_valid);
 void xfrm_policy_hash_rebuild(struct net *net);
 u32 xfrm_get_acqseq(void);
-int verify_spi_info(u8 proto, u32 min, u32 max);
-int xfrm_alloc_spi(struct xfrm_state *x, u32 minspi, u32 maxspi);
+int verify_spi_info(u8 proto, u32 min, u32 max, struct netlink_ext_ack *extack);
+int xfrm_alloc_spi(struct xfrm_state *x, u32 minspi, u32 maxspi,
+		   struct netlink_ext_ack *extack);
 struct xfrm_state *xfrm_find_acq(struct net *net, const struct xfrm_mark *mark,
 				 u8 mode, u32 reqid, u32 if_id, u8 proto,
 				 const xfrm_address_t *daddr,
diff --git a/net/key/af_key.c b/net/key/af_key.c
index 7f4ff5fe2257..e1d2155605aa 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -1377,13 +1377,13 @@ static int pfkey_getspi(struct sock *sk, struct sk_buff *skb, const struct sadb_
 		max_spi = range->sadb_spirange_max;
 	}
 
-	err = verify_spi_info(x->id.proto, min_spi, max_spi);
+	err = verify_spi_info(x->id.proto, min_spi, max_spi, NULL);
 	if (err) {
 		xfrm_state_put(x);
 		return err;
 	}
 
-	err = xfrm_alloc_spi(x, min_spi, max_spi);
+	err = xfrm_alloc_spi(x, min_spi, max_spi, NULL);
 	resp_skb = err ? ERR_PTR(err) : pfkey_xfrm_state2msg(x);
 
 	if (IS_ERR(resp_skb)) {
diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index 81df34b3da6e..d0ae17e3bb38 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -2017,7 +2017,7 @@ u32 xfrm_get_acqseq(void)
 }
 EXPORT_SYMBOL(xfrm_get_acqseq);
 
-int verify_spi_info(u8 proto, u32 min, u32 max)
+int verify_spi_info(u8 proto, u32 min, u32 max, struct netlink_ext_ack *extack)
 {
 	switch (proto) {
 	case IPPROTO_AH:
@@ -2026,22 +2026,28 @@ int verify_spi_info(u8 proto, u32 min, u32 max)
 
 	case IPPROTO_COMP:
 		/* IPCOMP spi is 16-bits. */
-		if (max >= 0x10000)
+		if (max >= 0x10000) {
+			NL_SET_ERR_MSG(extack, "IPCOMP SPI must be <= 65535");
 			return -EINVAL;
+		}
 		break;
 
 	default:
+		NL_SET_ERR_MSG(extack, "Invalid protocol, must be one of AH, ESP, IPCOMP");
 		return -EINVAL;
 	}
 
-	if (min > max)
+	if (min > max) {
+		NL_SET_ERR_MSG(extack, "Invalid SPI range: min > max");
 		return -EINVAL;
+	}
 
 	return 0;
 }
 EXPORT_SYMBOL(verify_spi_info);
 
-int xfrm_alloc_spi(struct xfrm_state *x, u32 low, u32 high)
+int xfrm_alloc_spi(struct xfrm_state *x, u32 low, u32 high,
+		   struct netlink_ext_ack *extack)
 {
 	struct net *net = xs_net(x);
 	unsigned int h;
@@ -2053,8 +2059,10 @@ int xfrm_alloc_spi(struct xfrm_state *x, u32 low, u32 high)
 	u32 mark = x->mark.v & x->mark.m;
 
 	spin_lock_bh(&x->lock);
-	if (x->km.state == XFRM_STATE_DEAD)
+	if (x->km.state == XFRM_STATE_DEAD) {
+		NL_SET_ERR_MSG(extack, "Target ACQUIRE is in DEAD state");
 		goto unlock;
+	}
 
 	err = 0;
 	if (x->id.spi)
@@ -2065,6 +2073,7 @@ int xfrm_alloc_spi(struct xfrm_state *x, u32 low, u32 high)
 	if (minspi == maxspi) {
 		x0 = xfrm_state_lookup(net, mark, &x->id.daddr, minspi, x->id.proto, x->props.family);
 		if (x0) {
+			NL_SET_ERR_MSG(extack, "Requested SPI is already in use");
 			xfrm_state_put(x0);
 			goto unlock;
 		}
@@ -2089,6 +2098,8 @@ int xfrm_alloc_spi(struct xfrm_state *x, u32 low, u32 high)
 		spin_unlock_bh(&net->xfrm.xfrm_state_lock);
 
 		err = 0;
+	} else {
+		NL_SET_ERR_MSG(extack, "No SPI available in the requested range");
 	}
 
 unlock:
diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index c5d6a92d73cb..5c280e04e02c 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -1523,7 +1523,7 @@ static int xfrm_alloc_userspi(struct sk_buff *skb, struct nlmsghdr *nlh,
 	u32 if_id = 0;
 
 	p = nlmsg_data(nlh);
-	err = verify_spi_info(p->info.id.proto, p->min, p->max);
+	err = verify_spi_info(p->info.id.proto, p->min, p->max, extack);
 	if (err)
 		goto out_noput;
 
@@ -1551,10 +1551,12 @@ static int xfrm_alloc_userspi(struct sk_buff *skb, struct nlmsghdr *nlh,
 				  &p->info.saddr, 1,
 				  family);
 	err = -ENOENT;
-	if (!x)
+	if (!x) {
+		NL_SET_ERR_MSG(extack, "Target ACQUIRE not found");
 		goto out_noput;
+	}
 
-	err = xfrm_alloc_spi(x, p->min, p->max);
+	err = xfrm_alloc_spi(x, p->min, p->max, extack);
 	if (err)
 		goto out;
 
-- 
2.25.1

