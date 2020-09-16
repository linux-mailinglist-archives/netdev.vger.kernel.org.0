Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFCFB26BFED
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 10:56:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726438AbgIPI4t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 04:56:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:34704 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725840AbgIPI4q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 04:56:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600246604;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=gsSuuwOM1HZHIH/9xEU+RRc3nsPcI35w2ChtA7/HJSo=;
        b=G0KWOQRpdaUgt9iBDXutf7NWnXLlxuBqXnvWeUi+1KkvSwdlHdafsnrz/txlt6oMkekfJ1
        qL2GlP2BR98E6gOxwiDKj1Ql8iC/KdZw1S0OuSR+8p+DEeC79wT2k2v0Rrw3ElvLJhdtLE
        SQL0DjZN3G9ZdZZI6JqICEUxu/QU2NM=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-106-Bn8mylo7MV6IFhAuEE08EA-1; Wed, 16 Sep 2020 04:56:41 -0400
X-MC-Unique: Bn8mylo7MV6IFhAuEE08EA-1
Received: by mail-qt1-f200.google.com with SMTP id e6so5495185qtg.13
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 01:56:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gsSuuwOM1HZHIH/9xEU+RRc3nsPcI35w2ChtA7/HJSo=;
        b=uma9IqTSnse8oL75refTqZK2UhBU1krmRIN9lJfkrk+jd0+tCjPf7ZjBIU7ANhinC+
         GNlN5Q5ViC9BTKP5bKjn2kdoKh8X1jpy+j+Gerqzz5/byax56MDBykWugqMsf4pF+Eme
         yw3/aD209zqd8izPDoah1RJ4t2UKL4gzfJ+RwaMhtU9F2lnP2uUQ4OmvEZh6SY3hpOQ0
         C9eUWZS1uNFBPGelB6N5zQrufFl5XOk4ZUPxKNZkLlX7eMbkR29nlcDB64Y2kAOi0OTE
         R981y8MH25V2h5sarpAP+Pz1Kv9wDJ5Tkr/iPaMfmhyd6sDspVk6hxLEVlny0IGYf0xS
         ZAEw==
X-Gm-Message-State: AOAM530cqUfFPj0gyeIpRn2iKW6sCFsMRymJRHgsBQqQWBowGg2IwCG+
        hC8oZf6hPlvAWG+9VHqSriWn9BOSwtHHjXtj6DeNGA+CNh1ToP023MFLeE9OmeH+wjMIg2c644M
        k1F0p9iGLq3lmf8YD
X-Received: by 2002:a37:9c16:: with SMTP id f22mr21822939qke.331.1600246600383;
        Wed, 16 Sep 2020 01:56:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzSj3/uROPuSZhfV20Q6i3aY7EnJYV5KXbpzhwz3nbEGzXkwTGYp0ztO+F/BwO84V06rf9d+Q==
X-Received: by 2002:a37:9c16:: with SMTP id f22mr21822923qke.331.1600246600148;
        Wed, 16 Sep 2020 01:56:40 -0700 (PDT)
Received: from wsfd-netdev77.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id 25sm19363780qks.41.2020.09.16.01.56.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2020 01:56:39 -0700 (PDT)
From:   Mark Gray <mark.d.gray@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Mark Gray <mark.d.gray@redhat.com>,
        Qiuyu Xiao <qiuyu.xiao.qyx@gmail.com>,
        Greg Rose <gvrose8192@gmail.com>
Subject: [PATCH net] geneve: add transport ports in route lookup for geneve
Date:   Wed, 16 Sep 2020 04:56:28 -0400
Message-Id: <20200916085628.858922-1-mark.d.gray@redhat.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds transport ports information for route lookup so that
IPsec can select Geneve tunnel traffic to do encryption. This is
needed for OVS/OVN IPsec with encrypted Geneve tunnels.

This can be tested by configuring a host-host VPN using an IKE
daemon and specifying port numbers. For example, for an
Openswan-type configuration, the following parameters should be
configured on both hosts and IPsec set up as-per normal:

$ cat /etc/ipsec.conf

conn in
...
left=$IP1
right=$IP2
...
leftprotoport=udp/6081
rightprotoport=udp
...
conn out
...
left=$IP1
right=$IP2
...
leftprotoport=udp
rightprotoport=udp/6081
...

The tunnel can then be setup using "ip" on both hosts (but
changing the relevant IP addresses):

$ ip link add tun type geneve id 1000 remote $IP2
$ ip addr add 192.168.0.1/24 dev tun
$ ip link set tun up

This can then be tested by pinging from $IP1:

$ ping 192.168.0.2

Without this patch the traffic is unencrypted on the wire.

Fixes: 2d07dc79fe04 ("geneve: add initial netdev driver for GENEVE tunnels")
Signed-off-by: Qiuyu Xiao <qiuyu.xiao.qyx@gmail.com>
Signed-off-by: Mark Gray <mark.d.gray@redhat.com>
Reviewed-by: Greg Rose <gvrose8192@gmail.com>
---
 drivers/net/geneve.c | 37 +++++++++++++++++++++++++++----------
 1 file changed, 27 insertions(+), 10 deletions(-)

diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
index c71f994fbc73..974a244f45ba 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -777,7 +777,8 @@ static struct rtable *geneve_get_v4_rt(struct sk_buff *skb,
 				       struct net_device *dev,
 				       struct geneve_sock *gs4,
 				       struct flowi4 *fl4,
-				       const struct ip_tunnel_info *info)
+				       const struct ip_tunnel_info *info,
+				       __be16 dport, __be16 sport)
 {
 	bool use_cache = ip_tunnel_dst_cache_usable(skb, info);
 	struct geneve_dev *geneve = netdev_priv(dev);
@@ -793,6 +794,8 @@ static struct rtable *geneve_get_v4_rt(struct sk_buff *skb,
 	fl4->flowi4_proto = IPPROTO_UDP;
 	fl4->daddr = info->key.u.ipv4.dst;
 	fl4->saddr = info->key.u.ipv4.src;
+	fl4->fl4_dport = dport;
+	fl4->fl4_sport = sport;
 
 	tos = info->key.tos;
 	if ((tos == 1) && !geneve->cfg.collect_md) {
@@ -827,7 +830,8 @@ static struct dst_entry *geneve_get_v6_dst(struct sk_buff *skb,
 					   struct net_device *dev,
 					   struct geneve_sock *gs6,
 					   struct flowi6 *fl6,
-					   const struct ip_tunnel_info *info)
+					   const struct ip_tunnel_info *info,
+					   __be16 dport, __be16 sport)
 {
 	bool use_cache = ip_tunnel_dst_cache_usable(skb, info);
 	struct geneve_dev *geneve = netdev_priv(dev);
@@ -843,6 +847,9 @@ static struct dst_entry *geneve_get_v6_dst(struct sk_buff *skb,
 	fl6->flowi6_proto = IPPROTO_UDP;
 	fl6->daddr = info->key.u.ipv6.dst;
 	fl6->saddr = info->key.u.ipv6.src;
+	fl6->fl6_dport = dport;
+	fl6->fl6_sport = sport;
+
 	prio = info->key.tos;
 	if ((prio == 1) && !geneve->cfg.collect_md) {
 		prio = ip_tunnel_get_dsfield(ip_hdr(skb), skb);
@@ -889,7 +896,9 @@ static int geneve_xmit_skb(struct sk_buff *skb, struct net_device *dev,
 	__be16 sport;
 	int err;
 
-	rt = geneve_get_v4_rt(skb, dev, gs4, &fl4, info);
+	sport = udp_flow_src_port(geneve->net, skb, 1, USHRT_MAX, true);
+	rt = geneve_get_v4_rt(skb, dev, gs4, &fl4, info,
+			      geneve->cfg.info.key.tp_dst, sport);
 	if (IS_ERR(rt))
 		return PTR_ERR(rt);
 
@@ -919,7 +928,6 @@ static int geneve_xmit_skb(struct sk_buff *skb, struct net_device *dev,
 		return -EMSGSIZE;
 	}
 
-	sport = udp_flow_src_port(geneve->net, skb, 1, USHRT_MAX, true);
 	if (geneve->cfg.collect_md) {
 		tos = ip_tunnel_ecn_encap(key->tos, ip_hdr(skb), skb);
 		ttl = key->ttl;
@@ -974,7 +982,9 @@ static int geneve6_xmit_skb(struct sk_buff *skb, struct net_device *dev,
 	__be16 sport;
 	int err;
 
-	dst = geneve_get_v6_dst(skb, dev, gs6, &fl6, info);
+	sport = udp_flow_src_port(geneve->net, skb, 1, USHRT_MAX, true);
+	dst = geneve_get_v6_dst(skb, dev, gs6, &fl6, info,
+				geneve->cfg.info.key.tp_dst, sport);
 	if (IS_ERR(dst))
 		return PTR_ERR(dst);
 
@@ -1003,7 +1013,6 @@ static int geneve6_xmit_skb(struct sk_buff *skb, struct net_device *dev,
 		return -EMSGSIZE;
 	}
 
-	sport = udp_flow_src_port(geneve->net, skb, 1, USHRT_MAX, true);
 	if (geneve->cfg.collect_md) {
 		prio = ip_tunnel_ecn_encap(key->tos, ip_hdr(skb), skb);
 		ttl = key->ttl;
@@ -1085,13 +1094,18 @@ static int geneve_fill_metadata_dst(struct net_device *dev, struct sk_buff *skb)
 {
 	struct ip_tunnel_info *info = skb_tunnel_info(skb);
 	struct geneve_dev *geneve = netdev_priv(dev);
+	__be16 sport;
 
 	if (ip_tunnel_info_af(info) == AF_INET) {
 		struct rtable *rt;
 		struct flowi4 fl4;
+
 		struct geneve_sock *gs4 = rcu_dereference(geneve->sock4);
+		sport = udp_flow_src_port(geneve->net, skb,
+					  1, USHRT_MAX, true);
 
-		rt = geneve_get_v4_rt(skb, dev, gs4, &fl4, info);
+		rt = geneve_get_v4_rt(skb, dev, gs4, &fl4, info,
+				      geneve->cfg.info.key.tp_dst, sport);
 		if (IS_ERR(rt))
 			return PTR_ERR(rt);
 
@@ -1101,9 +1115,13 @@ static int geneve_fill_metadata_dst(struct net_device *dev, struct sk_buff *skb)
 	} else if (ip_tunnel_info_af(info) == AF_INET6) {
 		struct dst_entry *dst;
 		struct flowi6 fl6;
+
 		struct geneve_sock *gs6 = rcu_dereference(geneve->sock6);
+		sport = udp_flow_src_port(geneve->net, skb,
+					  1, USHRT_MAX, true);
 
-		dst = geneve_get_v6_dst(skb, dev, gs6, &fl6, info);
+		dst = geneve_get_v6_dst(skb, dev, gs6, &fl6, info,
+					geneve->cfg.info.key.tp_dst, sport);
 		if (IS_ERR(dst))
 			return PTR_ERR(dst);
 
@@ -1114,8 +1132,7 @@ static int geneve_fill_metadata_dst(struct net_device *dev, struct sk_buff *skb)
 		return -EINVAL;
 	}
 
-	info->key.tp_src = udp_flow_src_port(geneve->net, skb,
-					     1, USHRT_MAX, true);
+	info->key.tp_src = sport;
 	info->key.tp_dst = geneve->cfg.info.key.tp_dst;
 	return 0;
 }
-- 
2.26.2

