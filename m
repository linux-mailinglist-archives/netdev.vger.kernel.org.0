Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8902C4DA9AF
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 06:25:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353607AbiCPF0S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 01:26:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239007AbiCPF0S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 01:26:18 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5462B4DF6C
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 22:25:04 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id 130-20020a1c0288000000b0038c2c33d8f3so48476wmc.4
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 22:25:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vm2LuFLqNif2Blkf2sBan2mbuvJcJ4V9bhnskrGzcBE=;
        b=AQswZlbOanQZ5GfWJPl2CavZ6BXj2fL1z0vw7tVLA3jnXxXbJrb8QNnrjXKShroXmE
         KeeosUrkxixhLofBptF6mv43yCRdGV2uCqEYTRkJ9lVLIJRvlwNuy0oEPGT/t7e8DekA
         7aDdf8XfpfoF82Ln9SPPmA33vg9OmjmDOhFYg39zOuSOF8OOrch0e1u1wQawotNRvu9A
         Az5oBMuBH0fyYUsORC9UqVzDO8KVLnhh73OOiyl/x4A3hBoIvUwNdkIePO465X65ScXp
         3a0qP0DAqnmSXL4hcPNiH6QpSGqqAS7O+7otPWTLmo1keZDAyevwMke3hQW170vDUuS0
         lOfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vm2LuFLqNif2Blkf2sBan2mbuvJcJ4V9bhnskrGzcBE=;
        b=JhGI2o5FYkp4AxIrsRDx2qsIYQhpR3+UxHCiw46ADNstCZLLbFzXABRxWjEW4rT5tF
         GLYEQVGw8iIqdbwLB+6qVNVpeXt6Ficph89KX6AE/EfTjsJ5YBf+6daG8vFgFEvjCFXA
         OyQcNUHu2ukf6yfMgoQO2b+qya4kT5FiQLlZaty86Ag5x8MZluM/g9IwZth31T3Ttdh/
         9agTaxJM4tlzrZFD8Zu4x2IxUfeBbRo+xreW0oGncCWCjiZEPBhS4dw7Q94BreXHrh9O
         T5B0JUVY9ysy2bGQBkbF/w2P4Vuz4Ckkq1Es5Rv83y+BHxxX1kCWn5k3h84PE25qMP3h
         wbcg==
X-Gm-Message-State: AOAM533Xnec472cHoxHIVBKf8F5yL5JUtHYHOfIaPLz1Dt02x2Zmj8nD
        bwNrp0NcFpV71RuzdNpj0aEzMwO060W+Ag==
X-Google-Smtp-Source: ABdhPJy7odeXTWRy2mrP+jV9Vcaxq3NQUW+wbx7ja82ODCp7pEcScr/fJa/SVQ3mU4cbsz+C0mGsUA==
X-Received: by 2002:a05:600c:3c9f:b0:38c:6dc6:6de2 with SMTP id bg31-20020a05600c3c9f00b0038c6dc66de2mr941730wmb.132.1647408302414;
        Tue, 15 Mar 2022 22:25:02 -0700 (PDT)
Received: from jimi.localdomain ([37.142.70.89])
        by smtp.gmail.com with ESMTPSA id f8-20020adfb608000000b0020229d72a4esm672331wre.38.2022.03.15.22.25.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Mar 2022 22:25:01 -0700 (PDT)
From:   Eyal Birger <eyal.birger@gmail.com>
To:     roopa@nvidia.com, davem@davemloft.net, kuba@kernel.org
Cc:     shmulik.ladkani@gmail.com, netdev@vger.kernel.org,
        Eyal Birger <eyal.birger@gmail.com>
Subject: [PATCH net-next,v2] net: geneve: support IPv4/IPv6 as inner protocol
Date:   Wed, 16 Mar 2022 07:24:47 +0200
Message-Id: <20220316052447.406700-1-eyal.birger@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support for encapsulating IPv4/IPv6 within GENEVE.

In order to use this, a new IFLA_GENEVE_INNER_PROTO_INHERIT flag needs
to be provided at device creation. This property cannot be changed for
the time being.

In case IP traffic is received on a non-tun device the drop count is
increased.

Signed-off-by: Eyal Birger <eyal.birger@gmail.com>

---

v2: remove unnecessary braces, rename flag (suggested by Roopa Prabhu)
---
 drivers/net/geneve.c         | 82 +++++++++++++++++++++++++++---------
 include/uapi/linux/if_link.h |  1 +
 2 files changed, 64 insertions(+), 19 deletions(-)

diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
index a895ff756093..680dbfd8c205 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -56,6 +56,7 @@ struct geneve_config {
 	bool			use_udp6_rx_checksums;
 	bool			ttl_inherit;
 	enum ifla_geneve_df	df;
+	bool			inner_proto_inherit;
 };
 
 /* Pseudo network device */
@@ -251,17 +252,24 @@ static void geneve_rx(struct geneve_dev *geneve, struct geneve_sock *gs,
 		}
 	}
 
-	skb_reset_mac_header(skb);
-	skb->protocol = eth_type_trans(skb, geneve->dev);
-	skb_postpull_rcsum(skb, eth_hdr(skb), ETH_HLEN);
-
 	if (tun_dst)
 		skb_dst_set(skb, &tun_dst->dst);
 
-	/* Ignore packet loops (and multicast echo) */
-	if (ether_addr_equal(eth_hdr(skb)->h_source, geneve->dev->dev_addr)) {
-		geneve->dev->stats.rx_errors++;
-		goto drop;
+	if (gnvh->proto_type == htons(ETH_P_TEB)) {
+		skb_reset_mac_header(skb);
+		skb->protocol = eth_type_trans(skb, geneve->dev);
+		skb_postpull_rcsum(skb, eth_hdr(skb), ETH_HLEN);
+
+		/* Ignore packet loops (and multicast echo) */
+		if (ether_addr_equal(eth_hdr(skb)->h_source,
+				     geneve->dev->dev_addr)) {
+			geneve->dev->stats.rx_errors++;
+			goto drop;
+		}
+	} else {
+		skb_reset_mac_header(skb);
+		skb->dev = geneve->dev;
+		skb->pkt_type = PACKET_HOST;
 	}
 
 	oiph = skb_network_header(skb);
@@ -345,6 +353,7 @@ static int geneve_udp_encap_recv(struct sock *sk, struct sk_buff *skb)
 	struct genevehdr *geneveh;
 	struct geneve_dev *geneve;
 	struct geneve_sock *gs;
+	__be16 inner_proto;
 	int opts_len;
 
 	/* Need UDP and Geneve header to be present */
@@ -356,7 +365,11 @@ static int geneve_udp_encap_recv(struct sock *sk, struct sk_buff *skb)
 	if (unlikely(geneveh->ver != GENEVE_VER))
 		goto drop;
 
-	if (unlikely(geneveh->proto_type != htons(ETH_P_TEB)))
+	inner_proto = geneveh->proto_type;
+
+	if (unlikely((inner_proto != htons(ETH_P_TEB) &&
+		      inner_proto != htons(ETH_P_IP) &&
+		      inner_proto != htons(ETH_P_IPV6))))
 		goto drop;
 
 	gs = rcu_dereference_sk_user_data(sk);
@@ -367,9 +380,14 @@ static int geneve_udp_encap_recv(struct sock *sk, struct sk_buff *skb)
 	if (!geneve)
 		goto drop;
 
+	if (unlikely((!geneve->cfg.inner_proto_inherit &&
+		      inner_proto != htons(ETH_P_TEB)))) {
+		geneve->dev->stats.rx_dropped++;
+		goto drop;
+	}
+
 	opts_len = geneveh->opt_len * 4;
-	if (iptunnel_pull_header(skb, GENEVE_BASE_HLEN + opts_len,
-				 htons(ETH_P_TEB),
+	if (iptunnel_pull_header(skb, GENEVE_BASE_HLEN + opts_len, inner_proto,
 				 !net_eq(geneve->net, dev_net(geneve->dev)))) {
 		geneve->dev->stats.rx_dropped++;
 		goto drop;
@@ -717,7 +735,8 @@ static int geneve_stop(struct net_device *dev)
 }
 
 static void geneve_build_header(struct genevehdr *geneveh,
-				const struct ip_tunnel_info *info)
+				const struct ip_tunnel_info *info,
+				__be16 inner_proto)
 {
 	geneveh->ver = GENEVE_VER;
 	geneveh->opt_len = info->options_len / 4;
@@ -725,7 +744,7 @@ static void geneve_build_header(struct genevehdr *geneveh,
 	geneveh->critical = !!(info->key.tun_flags & TUNNEL_CRIT_OPT);
 	geneveh->rsvd1 = 0;
 	tunnel_id_to_vni(info->key.tun_id, geneveh->vni);
-	geneveh->proto_type = htons(ETH_P_TEB);
+	geneveh->proto_type = inner_proto;
 	geneveh->rsvd2 = 0;
 
 	if (info->key.tun_flags & TUNNEL_GENEVE_OPT)
@@ -734,10 +753,12 @@ static void geneve_build_header(struct genevehdr *geneveh,
 
 static int geneve_build_skb(struct dst_entry *dst, struct sk_buff *skb,
 			    const struct ip_tunnel_info *info,
-			    bool xnet, int ip_hdr_len)
+			    bool xnet, int ip_hdr_len,
+			    bool inner_proto_inherit)
 {
 	bool udp_sum = !!(info->key.tun_flags & TUNNEL_CSUM);
 	struct genevehdr *gnvh;
+	__be16 inner_proto;
 	int min_headroom;
 	int err;
 
@@ -755,8 +776,9 @@ static int geneve_build_skb(struct dst_entry *dst, struct sk_buff *skb,
 		goto free_dst;
 
 	gnvh = __skb_push(skb, sizeof(*gnvh) + info->options_len);
-	geneve_build_header(gnvh, info);
-	skb_set_inner_protocol(skb, htons(ETH_P_TEB));
+	inner_proto = inner_proto_inherit ? skb->protocol : htons(ETH_P_TEB);
+	geneve_build_header(gnvh, info, inner_proto);
+	skb_set_inner_protocol(skb, inner_proto);
 	return 0;
 
 free_dst:
@@ -959,7 +981,8 @@ static int geneve_xmit_skb(struct sk_buff *skb, struct net_device *dev,
 		}
 	}
 
-	err = geneve_build_skb(&rt->dst, skb, info, xnet, sizeof(struct iphdr));
+	err = geneve_build_skb(&rt->dst, skb, info, xnet, sizeof(struct iphdr),
+			       geneve->cfg.inner_proto_inherit);
 	if (unlikely(err))
 		return err;
 
@@ -1038,7 +1061,8 @@ static int geneve6_xmit_skb(struct sk_buff *skb, struct net_device *dev,
 			ttl = key->ttl;
 		ttl = ttl ? : ip6_dst_hoplimit(dst);
 	}
-	err = geneve_build_skb(dst, skb, info, xnet, sizeof(struct ipv6hdr));
+	err = geneve_build_skb(dst, skb, info, xnet, sizeof(struct ipv6hdr),
+			       geneve->cfg.inner_proto_inherit);
 	if (unlikely(err))
 		return err;
 
@@ -1388,6 +1412,14 @@ static int geneve_configure(struct net *net, struct net_device *dev,
 	dst_cache_reset(&geneve->cfg.info.dst_cache);
 	memcpy(&geneve->cfg, cfg, sizeof(*cfg));
 
+	if (geneve->cfg.inner_proto_inherit) {
+		dev->header_ops = NULL;
+		dev->type = ARPHRD_NONE;
+		dev->hard_header_len = 0;
+		dev->addr_len = 0;
+		dev->flags = IFF_NOARP;
+	}
+
 	err = register_netdevice(dev);
 	if (err)
 		return err;
@@ -1561,10 +1593,18 @@ static int geneve_nl2info(struct nlattr *tb[], struct nlattr *data[],
 #endif
 	}
 
+	if (data[IFLA_GENEVE_INNER_PROTO_INHERIT]) {
+		if (changelink) {
+			attrtype = INNER_PROTO_INHERIT;
+			goto change_notsup;
+		}
+		cfg->inner_proto_inherit = true;
+	}
+
 	return 0;
 change_notsup:
 	NL_SET_ERR_MSG_ATTR(extack, data[attrtype],
-			    "Changing VNI, Port, endpoint IP address family, external, and UDP checksum attributes are not supported");
+			    "Changing VNI, Port, endpoint IP address family, external, inner_proto_inherit, and UDP checksum attributes are not supported");
 	return -EOPNOTSUPP;
 }
 
@@ -1799,6 +1839,10 @@ static int geneve_fill_info(struct sk_buff *skb, const struct net_device *dev)
 	if (nla_put_u8(skb, IFLA_GENEVE_TTL_INHERIT, ttl_inherit))
 		goto nla_put_failure;
 
+	if (geneve->cfg.inner_proto_inherit &&
+	    nla_put_flag(skb, INNER_PROTO_INHERIT))
+		goto nla_put_failure;
+
 	return 0;
 
 nla_put_failure:
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index bd24c7dc10a2..cc284c048e69 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -842,6 +842,7 @@ enum {
 	IFLA_GENEVE_LABEL,
 	IFLA_GENEVE_TTL_INHERIT,
 	IFLA_GENEVE_DF,
+	IFLA_GENEVE_INNER_PROTO_INHERIT,
 	__IFLA_GENEVE_MAX
 };
 #define IFLA_GENEVE_MAX	(__IFLA_GENEVE_MAX - 1)
-- 
2.32.0

