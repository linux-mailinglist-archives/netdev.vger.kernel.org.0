Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13AB7DD9A3
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 18:26:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726128AbfJSQ0r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Oct 2019 12:26:47 -0400
Received: from mail-pl1-f201.google.com ([209.85.214.201]:46526 "EHLO
        mail-pl1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726008AbfJSQ0q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Oct 2019 12:26:46 -0400
Received: by mail-pl1-f201.google.com with SMTP id o9so5789885plk.13
        for <netdev@vger.kernel.org>; Sat, 19 Oct 2019 09:26:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc
         :content-transfer-encoding;
        bh=WR6PVyO5oE1ZZcwUje+EMoQjO5771vBN9klza3Fc3ls=;
        b=Ks+FpnlkcfY2DEFoASlHhcigbqzWDEQiBArvzvD7z0Cy2ccGJx4IxBko2IJLJieoiB
         Rv4/8x6rtf3aM1Q+Q9nsm7TCtuWC8hEIhSZ1EZ0t/WgIhfxbFd2FoC99fWwL9YEmGEWl
         KWem5J8e13COwIGk578/4qOwtj/jqScvsGW14tExlCxh5QfpELp2LHBSCTgUK2J2uxi3
         otG56hrSj6fTkahq+clxz0DOZxJwODNuWYUN7NCUHVIu6Mvw0i74In6z+SURi72vP8Bv
         j375T09YIvcXL5rAmbjkFDWDAnIK8lydFQEd0pq7EUhLOsGPFO8qIPIDPtH0aB48RlMZ
         oXig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc
         :content-transfer-encoding;
        bh=WR6PVyO5oE1ZZcwUje+EMoQjO5771vBN9klza3Fc3ls=;
        b=k3EHVEPIg3PQ3TMs/nBc8thKVsXbdmFM9q8QMp3XEZKiWn80/lfDWJnID5ycfQyEDy
         XYOmzx7XBCIthefRo9DfuOS1avq/8tFgY54VHwQbD7zmRNDTc6WwH0whISfxybv81ghG
         hJQ7ReqMYAi8SPjWlud2dFcqXwSzRllJDcFEnpFZVJvmZJEjs04XhplT9olCnbJQKHbi
         AWEtRl3iQnAxnd9iv7KWzrFAGPPfxx5zP/aCKhK8SOAXKqReymV3mnDI9EVoYjFH/JMA
         HHbtK5N2mKzDH9legddOqEggq9EAtCRsmP6923X+dwWm6xmHy904RaqqqeaPacJsvcr6
         n/gw==
X-Gm-Message-State: APjAAAViAhZ8nNlVbGD+6PjfN8gUVsYYKg88CjrnlmhdWnh/w4FrhSmF
        ijFrI/7g/04jVEVFpZCKOqHQ6vVDhn3PAA==
X-Google-Smtp-Source: APXvYqzAu7DiSeicGjDoCnsZeauOlKy8iw0TZ8Lb3E6bvIT/12yxKOsUg1ZR+B2qkF/5ZAXeG3hbNCyEfLIp0Q==
X-Received: by 2002:a63:7c03:: with SMTP id x3mr16504222pgc.382.1571502405593;
 Sat, 19 Oct 2019 09:26:45 -0700 (PDT)
Date:   Sat, 19 Oct 2019 09:26:37 -0700
Message-Id: <20191019162637.222512-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.866.gb869b98d4c-goog
Subject: [PATCH] ipv4: fix IPSKB_FRAG_PMTU handling with fragmentation
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "=?UTF-8?q?Patrick=20Sch=C3=B6nthaler?=" <patrick@notvads.ovh>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch removes the iph field from the state structure, which is not
properly initialized. Instead, add a new field to make the "do we want
to set DF" be the state bit and move the code to set the DF flag from
ip_frag_next().

Joint work with Pablo and Linus.

Fixes: 19c3401a917b ("net: ipv4: place control buffer handling away from fr=
agmentation iterators")
Reported-by: Patrick Sch=C3=B6nthaler <patrick@notvads.ovh>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 include/net/ip.h                           |  4 ++--
 net/bridge/netfilter/nf_conntrack_bridge.c |  2 +-
 net/ipv4/ip_output.c                       | 11 ++++++-----
 3 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/include/net/ip.h b/include/net/ip.h
index 95bb77f95bcc..a2c61c36dc4a 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -185,7 +185,7 @@ static inline struct sk_buff *ip_fraglist_next(struct i=
p_fraglist_iter *iter)
 }
=20
 struct ip_frag_state {
-	struct iphdr	*iph;
+	bool		DF;
 	unsigned int	hlen;
 	unsigned int	ll_rs;
 	unsigned int	mtu;
@@ -196,7 +196,7 @@ struct ip_frag_state {
 };
=20
 void ip_frag_init(struct sk_buff *skb, unsigned int hlen, unsigned int ll_=
rs,
-		  unsigned int mtu, struct ip_frag_state *state);
+		  unsigned int mtu, bool DF, struct ip_frag_state *state);
 struct sk_buff *ip_frag_next(struct sk_buff *skb,
 			     struct ip_frag_state *state);
=20
diff --git a/net/bridge/netfilter/nf_conntrack_bridge.c b/net/bridge/netfil=
ter/nf_conntrack_bridge.c
index 8842798c29e6..3f51ff4db184 100644
--- a/net/bridge/netfilter/nf_conntrack_bridge.c
+++ b/net/bridge/netfilter/nf_conntrack_bridge.c
@@ -93,7 +93,7 @@ static int nf_br_ip_fragment(struct net *net, struct sock=
 *sk,
 	 * This may also be a clone skbuff, we could preserve the geometry for
 	 * the copies but probably not worth the effort.
 	 */
-	ip_frag_init(skb, hlen, ll_rs, frag_max_size, &state);
+	ip_frag_init(skb, hlen, ll_rs, frag_max_size, false, &state);
=20
 	while (state.left > 0) {
 		struct sk_buff *skb2;
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 28fca408812c..06a8b56ba33d 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -645,11 +645,12 @@ void ip_fraglist_prepare(struct sk_buff *skb, struct =
ip_fraglist_iter *iter)
 EXPORT_SYMBOL(ip_fraglist_prepare);
=20
 void ip_frag_init(struct sk_buff *skb, unsigned int hlen,
-		  unsigned int ll_rs, unsigned int mtu,
+		  unsigned int ll_rs, unsigned int mtu, bool DF,
 		  struct ip_frag_state *state)
 {
 	struct iphdr *iph =3D ip_hdr(skb);
=20
+	state->DF =3D DF;
 	state->hlen =3D hlen;
 	state->ll_rs =3D ll_rs;
 	state->mtu =3D mtu;
@@ -668,9 +669,6 @@ static void ip_frag_ipcb(struct sk_buff *from, struct s=
k_buff *to,
 	/* Copy the flags to each fragment. */
 	IPCB(to)->flags =3D IPCB(from)->flags;
=20
-	if (IPCB(from)->flags & IPSKB_FRAG_PMTU)
-		state->iph->frag_off |=3D htons(IP_DF);
-
 	/* ANK: dirty, but effective trick. Upgrade options only if
 	 * the segment to be fragmented was THE FIRST (otherwise,
 	 * options are already fixed) and make it ONCE
@@ -738,6 +736,8 @@ struct sk_buff *ip_frag_next(struct sk_buff *skb, struc=
t ip_frag_state *state)
 	 */
 	iph =3D ip_hdr(skb2);
 	iph->frag_off =3D htons((state->offset >> 3));
+	if (state->DF)
+		iph->frag_off |=3D htons(IP_DF);
=20
 	/*
 	 *	Added AC : If we are fragmenting a fragment that's not the
@@ -881,7 +881,8 @@ int ip_do_fragment(struct net *net, struct sock *sk, st=
ruct sk_buff *skb,
 	 *	Fragment the datagram.
 	 */
=20
-	ip_frag_init(skb, hlen, ll_rs, mtu, &state);
+	ip_frag_init(skb, hlen, ll_rs, mtu, IPCB(skb)->flags & IPSKB_FRAG_PMTU,
+		     &state);
=20
 	/*
 	 *	Keep copying data until we run out.
--=20
2.11.0

