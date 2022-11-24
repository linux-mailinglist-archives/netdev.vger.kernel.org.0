Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A87B637BA6
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 15:44:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbiKXOox (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 09:44:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbiKXOos (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 09:44:48 -0500
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [217.70.183.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4E5EEC7A0
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 06:44:46 -0800 (PST)
Received: (Authenticated sender: sd@queasysnail.net)
        by mail.gandi.net (Postfix) with ESMTPSA id E0345C001A;
        Thu, 24 Nov 2022 14:44:44 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     steffen.klassert@secunet.com, Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH ipsec-next 6/7] xfrm: add extack to xfrm_alloc_userspi
Date:   Thu, 24 Nov 2022 15:43:43 +0100
Message-Id: <7e039d04e53ba342ae5a785ee46359139063d2cf.1668507420.git.sd@queasysnail.net>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1668507420.git.sd@queasysnail.net>
References: <cover.1668507420.git.sd@queasysnail.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
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
2.38.0

