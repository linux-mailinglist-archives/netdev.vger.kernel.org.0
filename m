Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A21396D3391
	for <lists+netdev@lfdr.de>; Sat,  1 Apr 2023 21:34:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbjDATeb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Apr 2023 15:34:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbjDATea (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Apr 2023 15:34:30 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0336527005
        for <netdev@vger.kernel.org>; Sat,  1 Apr 2023 12:34:22 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id m2so25569103wrh.6
        for <netdev@vger.kernel.org>; Sat, 01 Apr 2023 12:34:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google; t=1680377661;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=27+VlMXdPLvzXSnUrwJm9nakvNajqVTiP7Ug38TY9fM=;
        b=gF/dDLjmzRf/B4AYCkH1SMmSmsCn8hgXT+YXcnfAo6MW0g3W9bgpnVbKBmOQuGviq6
         9da8vTRag1Fq9mCrrCXY70mjLCfAGWTmHT2gjLSHZPSVvgtLiKc9iMocCbezFhwCyMNr
         +RZSyxnI0QQ4tZReKoWLohtz5yz80LKuDuyWA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680377661;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=27+VlMXdPLvzXSnUrwJm9nakvNajqVTiP7Ug38TY9fM=;
        b=r7uOtrf2aTlGNmPFl2vJdrZr0QAgMpvMvzQsooxn5XdceTsOQzPXLZlOpcCQxEjuB0
         Ly8mLcQIJpSJBJkR6cUn25VSN0FzXDfHAj98+NqMm8sM/Xp+bcVOzYDzY1yZlWrQXlhz
         zSEUm/AfExs4V81iAyv/TJtFyg4MP3E7mpIUg9ticFGZ6sniSeghhKu/oeTv6yCYNn14
         dSvEmNAv0zgkAU07xleIKIIx27IWp232pvv0FpFCirKcfjWtlrJBRxlDRL25HDkywLwT
         eCHNterACZWk4aKutssYRboMvo8kkT9dxs1GXMmU5ZLSCzT+K411vV31/35pCxcZ3WRA
         NgaQ==
X-Gm-Message-State: AAQBX9dYLymOlHaiDPiOZvAElVkXOZepU+y0C8ZEHZHINGgucpms13dq
        C4bH9Qj8VDhCZA5eN7yv1Dcywg==
X-Google-Smtp-Source: AKy350b0uzzkUf1GjJtfYEVarZBBt6RIy6RpbOxrSxeOgkiPQLY+/b7i+RoQI6qZspMkVo13Lmsiag==
X-Received: by 2002:a5d:6243:0:b0:2d8:708a:d84 with SMTP id m3-20020a5d6243000000b002d8708a0d84mr24990840wrv.19.1680377661262;
        Sat, 01 Apr 2023 12:34:21 -0700 (PDT)
Received: from workstation.ehrig.io (tmo-065-106.customers.d1-online.com. [80.187.65.106])
        by smtp.gmail.com with ESMTPSA id b5-20020a5d4b85000000b002c559843748sm5600416wrt.10.2023.04.01.12.34.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Apr 2023 12:34:20 -0700 (PDT)
From:   Christian Ehrig <cehrig@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     cehrig@cloudflare.com, "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next 1/3] ipip,ip_tunnel,sit: Add FOU support for externally controlled ipip devices
Date:   Sat,  1 Apr 2023 22:33:26 +0200
Message-Id: <29b21ba7f3b465caad22ac6369c50cabc622e19d.1680379518.git.cehrig@cloudflare.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <cover.1680379518.git.cehrig@cloudflare.com>
References: <cover.1680379518.git.cehrig@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Today ipip devices in collect-metadata mode don't allow for sending FOU
or GUE encapsulated packets. This patch lifts the restriction by adding
a struct ip_tunnel_encap to the tunnel metadata.

On the egress path, the members of this struct can be set by the
bpf_skb_set_fou_encap kfunc via a BPF tc-hook. Instead of dropping packets
wishing to use additional UDP encapsulation, ip_md_tunnel_xmit now
evaluates the contents of this struct and adds the corresponding FOU or
GUE header. Furthermore, it is making sure that additional header bytes
are taken into account for PMTU discovery.

On the ingress path, an ipip device in collect-metadata mode will fill this
struct and a BPF tc-hook can obtain the information via a call to the
bpf_skb_get_fou_encap kfunc.

The minor change to ip_tunnel_encap, which now takes a pointer to
struct ip_tunnel_encap instead of struct ip_tunnel, allows us to control
FOU encap type and parameters on a per packet-level.

Signed-off-by: Christian Ehrig <cehrig@cloudflare.com>
---
 include/net/ip_tunnels.h | 27 ++++++++++++++-------------
 net/ipv4/ip_tunnel.c     | 22 ++++++++++++++++++++--
 net/ipv4/ipip.c          |  1 +
 net/ipv6/sit.c           |  2 +-
 4 files changed, 36 insertions(+), 16 deletions(-)

diff --git a/include/net/ip_tunnels.h b/include/net/ip_tunnels.h
index fca357679816..ce091a3c257f 100644
--- a/include/net/ip_tunnels.h
+++ b/include/net/ip_tunnels.h
@@ -57,6 +57,13 @@ struct ip_tunnel_key {
 	__u8			flow_flags;
 };
 
+struct ip_tunnel_encap {
+	u16			type;
+	u16			flags;
+	__be16			sport;
+	__be16			dport;
+};
+
 /* Flags for ip_tunnel_info mode. */
 #define IP_TUNNEL_INFO_TX	0x01	/* represents tx tunnel parameters */
 #define IP_TUNNEL_INFO_IPV6	0x02	/* key contains IPv6 addresses */
@@ -66,9 +73,9 @@ struct ip_tunnel_key {
 #define IP_TUNNEL_OPTS_MAX					\
 	GENMASK((sizeof_field(struct ip_tunnel_info,		\
 			      options_len) * BITS_PER_BYTE) - 1, 0)
-
 struct ip_tunnel_info {
 	struct ip_tunnel_key	key;
+	struct ip_tunnel_encap	encap;
 #ifdef CONFIG_DST_CACHE
 	struct dst_cache	dst_cache;
 #endif
@@ -86,13 +93,6 @@ struct ip_tunnel_6rd_parm {
 };
 #endif
 
-struct ip_tunnel_encap {
-	u16			type;
-	u16			flags;
-	__be16			sport;
-	__be16			dport;
-};
-
 struct ip_tunnel_prl_entry {
 	struct ip_tunnel_prl_entry __rcu *next;
 	__be32				addr;
@@ -293,6 +293,7 @@ struct ip_tunnel *ip_tunnel_lookup(struct ip_tunnel_net *itn,
 				   __be32 remote, __be32 local,
 				   __be32 key);
 
+void ip_tunnel_md_udp_encap(struct sk_buff *skb, struct ip_tunnel_info *info);
 int ip_tunnel_rcv(struct ip_tunnel *tunnel, struct sk_buff *skb,
 		  const struct tnl_ptk_info *tpi, struct metadata_dst *tun_dst,
 		  bool log_ecn_error);
@@ -371,22 +372,22 @@ static inline int ip_encap_hlen(struct ip_tunnel_encap *e)
 	return hlen;
 }
 
-static inline int ip_tunnel_encap(struct sk_buff *skb, struct ip_tunnel *t,
+static inline int ip_tunnel_encap(struct sk_buff *skb, struct ip_tunnel_encap *e,
 				  u8 *protocol, struct flowi4 *fl4)
 {
 	const struct ip_tunnel_encap_ops *ops;
 	int ret = -EINVAL;
 
-	if (t->encap.type == TUNNEL_ENCAP_NONE)
+	if (e->type == TUNNEL_ENCAP_NONE)
 		return 0;
 
-	if (t->encap.type >= MAX_IPTUN_ENCAP_OPS)
+	if (e->type >= MAX_IPTUN_ENCAP_OPS)
 		return -EINVAL;
 
 	rcu_read_lock();
-	ops = rcu_dereference(iptun_encaps[t->encap.type]);
+	ops = rcu_dereference(iptun_encaps[e->type]);
 	if (likely(ops && ops->build_header))
-		ret = ops->build_header(skb, &t->encap, protocol, fl4);
+		ret = ops->build_header(skb, e, protocol, fl4);
 	rcu_read_unlock();
 
 	return ret;
diff --git a/net/ipv4/ip_tunnel.c b/net/ipv4/ip_tunnel.c
index de90b09dfe78..add437f710fc 100644
--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -359,6 +359,20 @@ static struct ip_tunnel *ip_tunnel_create(struct net *net,
 	return ERR_PTR(err);
 }
 
+void ip_tunnel_md_udp_encap(struct sk_buff *skb, struct ip_tunnel_info *info)
+{
+	const struct iphdr *iph = ip_hdr(skb);
+	const struct udphdr *udph;
+
+	if (iph->protocol != IPPROTO_UDP)
+		return;
+
+	udph = (struct udphdr *)((__u8 *)iph + (iph->ihl << 2));
+	info->encap.sport = udph->source;
+	info->encap.dport = udph->dest;
+}
+EXPORT_SYMBOL(ip_tunnel_md_udp_encap);
+
 int ip_tunnel_rcv(struct ip_tunnel *tunnel, struct sk_buff *skb,
 		  const struct tnl_ptk_info *tpi, struct metadata_dst *tun_dst,
 		  bool log_ecn_error)
@@ -572,7 +586,11 @@ void ip_md_tunnel_xmit(struct sk_buff *skb, struct net_device *dev,
 			    tunnel_id_to_key32(key->tun_id), RT_TOS(tos),
 			    dev_net(dev), 0, skb->mark, skb_get_hash(skb),
 			    key->flow_flags);
-	if (tunnel->encap.type != TUNNEL_ENCAP_NONE)
+
+	if (!tunnel_hlen)
+		tunnel_hlen = ip_encap_hlen(&tun_info->encap);
+
+	if (ip_tunnel_encap(skb, &tun_info->encap, &proto, &fl4) < 0)
 		goto tx_error;
 
 	use_cache = ip_tunnel_dst_cache_usable(skb, tun_info);
@@ -732,7 +750,7 @@ void ip_tunnel_xmit(struct sk_buff *skb, struct net_device *dev,
 			    dev_net(dev), tunnel->parms.link,
 			    tunnel->fwmark, skb_get_hash(skb), 0);
 
-	if (ip_tunnel_encap(skb, tunnel, &protocol, &fl4) < 0)
+	if (ip_tunnel_encap(skb, &tunnel->encap, &protocol, &fl4) < 0)
 		goto tx_error;
 
 	if (connected && md) {
diff --git a/net/ipv4/ipip.c b/net/ipv4/ipip.c
index abea77759b7e..27b8f83c6ea2 100644
--- a/net/ipv4/ipip.c
+++ b/net/ipv4/ipip.c
@@ -241,6 +241,7 @@ static int ipip_tunnel_rcv(struct sk_buff *skb, u8 ipproto)
 			tun_dst = ip_tun_rx_dst(skb, 0, 0, 0);
 			if (!tun_dst)
 				return 0;
+			ip_tunnel_md_udp_encap(skb, &tun_dst->u.tun_info);
 		}
 		skb_reset_mac_header(skb);
 
diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index 70d81bba5093..063560e2cb1a 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -1024,7 +1024,7 @@ static netdev_tx_t ipip6_tunnel_xmit(struct sk_buff *skb,
 		ttl = iph6->hop_limit;
 	tos = INET_ECN_encapsulate(tos, ipv6_get_dsfield(iph6));
 
-	if (ip_tunnel_encap(skb, tunnel, &protocol, &fl4) < 0) {
+	if (ip_tunnel_encap(skb, &tunnel->encap, &protocol, &fl4) < 0) {
 		ip_rt_put(rt);
 		goto tx_error;
 	}
-- 
2.39.2

