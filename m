Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E1354DA2C7
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 19:56:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241004AbiCOS5n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 14:57:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351177AbiCOS5m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 14:57:42 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 569E04E393
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 11:56:29 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id u10so30448103wra.9
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 11:56:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZZTQ4UWBXV5FRq5rxqpDxv4UW877OsPGB4uD6/A90Tw=;
        b=oePSNNbyH5x3eT+snVmrgGfVBtLyTvvZxoM5zKmv3uXB5bwJjD46mNwET9iEYXrWYF
         abXK4/zV95x3/pIggHW0VvE+9o/eJCmB+z//TJ6Yehk+/9xcd8aR7BLDsy97MYfSQYHi
         IaPoZhoJl0QvZcTzo1VduzTg0M2lSKt70K9q5MSrmOp17Txw1pLX/uS4zvIoi6yTYI1Z
         HlzXbA9ag7IVYCHeqQ1a3tKiqchYn8n1sp1cYZ72Zud6GQyXoZv5Vj0kvjwmRwNX78ye
         5FqVxpaNsH52HXkh0DPEeJhgndnelO4XniqBQ1CtEH6g8NemnMqONoeTBxdATdacdt4d
         rHOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZZTQ4UWBXV5FRq5rxqpDxv4UW877OsPGB4uD6/A90Tw=;
        b=qlNL3HDftG2TchSu/Pxnr+emZvmIQimkQqSLlIaaiyA7Qf9bslLzZjQMsFeZli98Ba
         j7oqccyIc/pQG3ooYrMVpIVcc4p1rX0oPG79tEivXhDumyRpskjJk9iu6YNHDDlt30dn
         cF0jnEX5PECGxGi+AR5A1EaevKDdR3r0LVoiVNC+IozEDUbSxHVnAErLP9XJIPyS4sYS
         RkvqETQoCYBSxkQPEoFZP9JWluKUJQuYrHYjD8E9OT0fyl3gviGvFS0GMvpJ7q9Bqwyx
         zhkbHMiweY2nPFyD8d0Y+RoeaQyHS0xinHJdPnUp7kvG1/XVNsF/NKh18hSqgBQAHgy/
         M4Ag==
X-Gm-Message-State: AOAM533WalMjNJ5hgazrchTtxg85OZbVH8U6JIP4xwTlFwcwjdNibCwD
        1rnJJ7eIl4/6b4Gh/RQR7k0=
X-Google-Smtp-Source: ABdhPJz4Ggnd5eN9O/qm1lJWHYCaBafGCvAk3963f5yW3mgTdDD9rKhVGbIW2dt19QMNBzduVsRoGA==
X-Received: by 2002:adf:fb47:0:b0:1ed:9f2c:492e with SMTP id c7-20020adffb47000000b001ed9f2c492emr21582586wrs.196.1647370587541;
        Tue, 15 Mar 2022 11:56:27 -0700 (PDT)
Received: from jimi.localdomain ([37.142.70.89])
        by smtp.gmail.com with ESMTPSA id n65-20020a1c2744000000b003862bfb509bsm3250189wmn.46.2022.03.15.11.56.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Mar 2022 11:56:27 -0700 (PDT)
From:   Eyal Birger <eyal.birger@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     shmulik.ladkani@gmail.com, netdev@vger.kernel.org,
        Eyal Birger <eyal.birger@gmail.com>
Subject: [PATCH net-next] net: geneve: support IPv4/IPv6 as inner protocol
Date:   Tue, 15 Mar 2022 20:56:03 +0200
Message-Id: <20220315185603.160778-1-eyal.birger@gmail.com>
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

In order use this, a new IFLA_GENEVE_TUN flag needs to be provided at
device creation. This property cannot be changed for the time being.

In case IP traffic is received on a non-tun device the drop count is
increased.

Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
---
 drivers/net/geneve.c         | 79 +++++++++++++++++++++++++++---------
 include/uapi/linux/if_link.h |  1 +
 2 files changed, 61 insertions(+), 19 deletions(-)

diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
index a895ff756093..37305ec26250 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -56,6 +56,7 @@ struct geneve_config {
 	bool			use_udp6_rx_checksums;
 	bool			ttl_inherit;
 	enum ifla_geneve_df	df;
+	bool			tun;
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
@@ -356,8 +365,13 @@ static int geneve_udp_encap_recv(struct sock *sk, struct sk_buff *skb)
 	if (unlikely(geneveh->ver != GENEVE_VER))
 		goto drop;
 
-	if (unlikely(geneveh->proto_type != htons(ETH_P_TEB)))
+	inner_proto = geneveh->proto_type;
+
+	if (unlikely((inner_proto != htons(ETH_P_TEB) &&
+		      inner_proto != htons(ETH_P_IP) &&
+		      inner_proto != htons(ETH_P_IPV6)))) {
 		goto drop;
+	}
 
 	gs = rcu_dereference_sk_user_data(sk);
 	if (!gs)
@@ -367,9 +381,13 @@ static int geneve_udp_encap_recv(struct sock *sk, struct sk_buff *skb)
 	if (!geneve)
 		goto drop;
 
+	if (unlikely((!geneve->cfg.tun && inner_proto != htons(ETH_P_TEB)))) {
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
@@ -734,8 +753,9 @@ static void geneve_build_header(struct genevehdr *geneveh,
 
 static int geneve_build_skb(struct dst_entry *dst, struct sk_buff *skb,
 			    const struct ip_tunnel_info *info,
-			    bool xnet, int ip_hdr_len)
+			    bool xnet, int ip_hdr_len, bool tun)
 {
+	__be16 inner_proto = tun ? skb->protocol : htons(ETH_P_TEB);
 	bool udp_sum = !!(info->key.tun_flags & TUNNEL_CSUM);
 	struct genevehdr *gnvh;
 	int min_headroom;
@@ -755,8 +775,8 @@ static int geneve_build_skb(struct dst_entry *dst, struct sk_buff *skb,
 		goto free_dst;
 
 	gnvh = __skb_push(skb, sizeof(*gnvh) + info->options_len);
-	geneve_build_header(gnvh, info);
-	skb_set_inner_protocol(skb, htons(ETH_P_TEB));
+	geneve_build_header(gnvh, info, inner_proto);
+	skb_set_inner_protocol(skb, inner_proto);
 	return 0;
 
 free_dst:
@@ -959,7 +979,8 @@ static int geneve_xmit_skb(struct sk_buff *skb, struct net_device *dev,
 		}
 	}
 
-	err = geneve_build_skb(&rt->dst, skb, info, xnet, sizeof(struct iphdr));
+	err = geneve_build_skb(&rt->dst, skb, info, xnet, sizeof(struct iphdr),
+			       geneve->cfg.tun);
 	if (unlikely(err))
 		return err;
 
@@ -1038,7 +1059,8 @@ static int geneve6_xmit_skb(struct sk_buff *skb, struct net_device *dev,
 			ttl = key->ttl;
 		ttl = ttl ? : ip6_dst_hoplimit(dst);
 	}
-	err = geneve_build_skb(dst, skb, info, xnet, sizeof(struct ipv6hdr));
+	err = geneve_build_skb(dst, skb, info, xnet, sizeof(struct ipv6hdr),
+			       geneve->cfg.tun);
 	if (unlikely(err))
 		return err;
 
@@ -1388,6 +1410,14 @@ static int geneve_configure(struct net *net, struct net_device *dev,
 	dst_cache_reset(&geneve->cfg.info.dst_cache);
 	memcpy(&geneve->cfg, cfg, sizeof(*cfg));
 
+	if (geneve->cfg.tun) {
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
@@ -1561,10 +1591,18 @@ static int geneve_nl2info(struct nlattr *tb[], struct nlattr *data[],
 #endif
 	}
 
+	if (data[IFLA_GENEVE_TUN]) {
+		if (changelink) {
+			attrtype = IFLA_GENEVE_TUN;
+			goto change_notsup;
+		}
+		cfg->tun = true;
+	}
+
 	return 0;
 change_notsup:
 	NL_SET_ERR_MSG_ATTR(extack, data[attrtype],
-			    "Changing VNI, Port, endpoint IP address family, external, and UDP checksum attributes are not supported");
+			    "Changing VNI, Port, endpoint IP address family, external, tun, and UDP checksum attributes are not supported");
 	return -EOPNOTSUPP;
 }
 
@@ -1799,6 +1837,9 @@ static int geneve_fill_info(struct sk_buff *skb, const struct net_device *dev)
 	if (nla_put_u8(skb, IFLA_GENEVE_TTL_INHERIT, ttl_inherit))
 		goto nla_put_failure;
 
+	if (geneve->cfg.tun && nla_put_flag(skb, IFLA_GENEVE_TUN))
+		goto nla_put_failure;
+
 	return 0;
 
 nla_put_failure:
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index bd24c7dc10a2..198aefa2c513 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -842,6 +842,7 @@ enum {
 	IFLA_GENEVE_LABEL,
 	IFLA_GENEVE_TTL_INHERIT,
 	IFLA_GENEVE_DF,
+	IFLA_GENEVE_TUN,
 	__IFLA_GENEVE_MAX
 };
 #define IFLA_GENEVE_MAX	(__IFLA_GENEVE_MAX - 1)
-- 
2.32.0

