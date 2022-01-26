Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B2F149CD2C
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 16:00:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242492AbiAZPAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 10:00:22 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:38350 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235637AbiAZPAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 10:00:21 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id F162C218E9;
        Wed, 26 Jan 2022 15:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1643209220; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=g0MOvo5VPuGo3H1eOn6O7jk1jR5vC1yMSjpMaYXrmRo=;
        b=eIKSHOFxllvxrEACrUVLtstWl0QvRqIKRCKgsqN3Zc1AyvABdnOuiMEChG2ongYOFkv+W/
        L4Fib7f+6C2LfJW/2VBxhvmmKPbfZPVPwNtHJfclh33htSVD3fCk/9NwyD+tL4FmOmcEFc
        SpZQZu4wahOCAHrf6BPVn0b7F2DmxZQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1643209220;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=g0MOvo5VPuGo3H1eOn6O7jk1jR5vC1yMSjpMaYXrmRo=;
        b=9YFUeNWzPHt9b2MfUpMNotAQYZ0qNCJ22KlwLfrAdCoEZiEwUA5hpz3gsMyL0Q+3vgLvTO
        3fF/gzl9AVDwlrDA==
Received: from localhost (dwarf.suse.cz [10.100.12.32])
        by relay2.suse.de (Postfix) with ESMTP id 8463BA3B81;
        Wed, 26 Jan 2022 15:00:18 +0000 (UTC)
Date:   Wed, 26 Jan 2022 16:00:18 +0100
From:   Jiri Bohac <jbohac@suse.cz>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Sabrina Dubroca <sd@queasysnail.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Mike Maloney <maloneykernel@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH] Revert "xfrm: xfrm_state_mtu should return at least 1280
 for ipv6"
Message-ID: <20220126150018.7cdfxtkq2nfkqj4j@dwarf.suse.cz>
References: <20220114173133.tzmdm2hy4flhblo3@dwarf.suse.cz>
 <20220114174058.rqhtuwpfhq6czldn@dwarf.suse.cz>
 <20220119073519.GJ1223722@gauss3.secunet.de>
 <20220119091233.pzqdlzpcyicjavk5@dwarf.suse.cz>
 <20220124154531.GM1223722@gauss3.secunet.de>
 <20220125094102.ju7bhuplcxnkyv4x@dwarf.suse.cz>
 <20220126064214.GO1223722@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220126064214.GO1223722@gauss3.secunet.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit b515d2637276a3810d6595e10ab02c13bfd0b63a.

Commit b515d2637276a3810d6595e10ab02c13bfd0b63a ("xfrm: xfrm_state_mtu
should return at least 1280 for ipv6") in v5.14 breaks the TCP MSS
calculation in ipsec transport mode, resulting complete stalls of TCP
connections. This happens when the (P)MTU is 1280 or slighly larger.

The desired formula for the MSS is:
MSS = (MTU - ESP_overhead) - IP header - TCP header

However, the above commit clamps the (MTU - ESP_overhead) to a
minimum of 1280, turning the formula into
MSS = max(MTU - ESP overhead, 1280) -  IP header - TCP header

With the (P)MTU near 1280, the calculated MSS is too large and the
resulting TCP packets never make it to the destination because they
are over the actual PMTU.

The above commit also causes suboptimal double fragmentation in
xfrm tunnel mode, as described in
https://lore.kernel.org/netdev/20210429202529.codhwpc7w6kbudug@dwarf.suse.cz/

The original problem the above commit was trying to fix is now fixed
by commit 6596a0229541270fb8d38d989f91b78838e5e9da ("xfrm: fix MTU
regression").

Signed-off-by: Jiri Bohac <jbohac@suse.cz>

---
 include/net/xfrm.h    |  1 -
 net/ipv4/esp4.c       |  2 +-
 net/ipv6/esp6.c       |  2 +-
 net/xfrm/xfrm_state.c | 14 ++------------
 4 files changed, 4 insertions(+), 15 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index fdb41e8bb626..d78a294e1d0c 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -1568,7 +1568,6 @@ void xfrm_sad_getinfo(struct net *net, struct xfrmk_sadinfo *si);
 void xfrm_spd_getinfo(struct net *net, struct xfrmk_spdinfo *si);
 u32 xfrm_replay_seqhi(struct xfrm_state *x, __be32 net_seq);
 int xfrm_init_replay(struct xfrm_state *x);
-u32 __xfrm_state_mtu(struct xfrm_state *x, int mtu);
 u32 xfrm_state_mtu(struct xfrm_state *x, int mtu);
 int __xfrm_init_state(struct xfrm_state *x, bool init_replay, bool offload);
 int xfrm_init_state(struct xfrm_state *x);
diff --git a/net/ipv4/esp4.c b/net/ipv4/esp4.c
index 851f542928a3..e1b1d080e908 100644
--- a/net/ipv4/esp4.c
+++ b/net/ipv4/esp4.c
@@ -671,7 +671,7 @@ static int esp_output(struct xfrm_state *x, struct sk_buff *skb)
 		struct xfrm_dst *dst = (struct xfrm_dst *)skb_dst(skb);
 		u32 padto;
 
-		padto = min(x->tfcpad, __xfrm_state_mtu(x, dst->child_mtu_cached));
+		padto = min(x->tfcpad, xfrm_state_mtu(x, dst->child_mtu_cached));
 		if (skb->len < padto)
 			esp.tfclen = padto - skb->len;
 	}
diff --git a/net/ipv6/esp6.c b/net/ipv6/esp6.c
index 8bb2c407b46b..7591160edce1 100644
--- a/net/ipv6/esp6.c
+++ b/net/ipv6/esp6.c
@@ -707,7 +707,7 @@ static int esp6_output(struct xfrm_state *x, struct sk_buff *skb)
 		struct xfrm_dst *dst = (struct xfrm_dst *)skb_dst(skb);
 		u32 padto;
 
-		padto = min(x->tfcpad, __xfrm_state_mtu(x, dst->child_mtu_cached));
+		padto = min(x->tfcpad, xfrm_state_mtu(x, dst->child_mtu_cached));
 		if (skb->len < padto)
 			esp.tfclen = padto - skb->len;
 	}
diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index ca6bee18346d..dde82f8eb949 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -2572,7 +2572,7 @@ void xfrm_state_delete_tunnel(struct xfrm_state *x)
 }
 EXPORT_SYMBOL(xfrm_state_delete_tunnel);
 
-u32 __xfrm_state_mtu(struct xfrm_state *x, int mtu)
+u32 xfrm_state_mtu(struct xfrm_state *x, int mtu)
 {
 	const struct xfrm_type *type = READ_ONCE(x->type);
 	struct crypto_aead *aead;
@@ -2603,17 +2603,7 @@ u32 __xfrm_state_mtu(struct xfrm_state *x, int mtu)
 	return ((mtu - x->props.header_len - crypto_aead_authsize(aead) -
 		 net_adj) & ~(blksize - 1)) + net_adj - 2;
 }
-EXPORT_SYMBOL_GPL(__xfrm_state_mtu);
-
-u32 xfrm_state_mtu(struct xfrm_state *x, int mtu)
-{
-	mtu = __xfrm_state_mtu(x, mtu);
-
-	if (x->props.family == AF_INET6 && mtu < IPV6_MIN_MTU)
-		return IPV6_MIN_MTU;
-
-	return mtu;
-}
+EXPORT_SYMBOL_GPL(xfrm_state_mtu);
 
 int __xfrm_init_state(struct xfrm_state *x, bool init_replay, bool offload)
 {

-- 
Jiri Bohac <jbohac@suse.cz>
SUSE Labs, Prague, Czechia

