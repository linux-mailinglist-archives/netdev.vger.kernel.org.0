Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 358BB5763FB
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 17:01:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231660AbiGOPBk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 11:01:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231777AbiGOPBh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 11:01:37 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B7767B37E
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 08:01:36 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id f24-20020a1cc918000000b003a30178c022so3028654wmb.3
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 08:01:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sAK+1eDl4p0U2zzE18FluVyvJNB/v7GV3zwJU7RBeRY=;
        b=P2NNwW1NfFyPnKnRuP8E40Sf/lTLdvB7ei+BXITQfLU9BrgrfPZIzNRiM3uyiDGOgB
         8FJB5XHkbVZTC5hDNNin6cNEXmvw+aFn5zjSblmCyTV4xe4r5nqtyl49Xpp8mSJW8vti
         lLRXZ0KNuLvZCMpHv8byvskZ1OvPHT4iHpzx4zsOiwqSKEhyYAumHv+0Fm5FHM2Sbxcs
         h7Vf2//ttRKFOLDJJac59TYCXlKhvra7JkgkY40b5S2/4lRXpkA1DRaH0ZiTQELO8G+H
         2eXJDQ5RAJ6WrDQCpPtMkOdnizK79GYgIK1tp8i3JSROOKJRRnBLXIeezrqt1kIKDWJ+
         uvpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sAK+1eDl4p0U2zzE18FluVyvJNB/v7GV3zwJU7RBeRY=;
        b=ipZ1bWtVO9Pnbsujs8Omlo/98CixQ/NyppUUXQAGWDz2sg9gw4B4gjJbllDwO6nbe1
         XZ6Q6QpTERrMM1Oz32OpsLyAh9zvRuJe760rH2L00s82ZKY0f1NhGwKLbTC8xNwIh0CA
         /TTFToxO43ZfxTQHKZmQOAAm08YXz6Z8z7xV69KBuGnZX/Efj1lNht1FT0djyCJPlK5E
         YRno4lhZQfPh4efu2BXtPLGhMmgQupUGhjipfW1a8K/9MCs8UuCQ2Wizg2dxNFVEVsbR
         C/VRrgRHwXbvmfFP5uWIsAdu7eMHouVH2wvMeL1RkfJdkQy7Tx11OdsraGkZ07Ezt6U3
         Lfag==
X-Gm-Message-State: AJIora+9HmtEmj26p7G8VX3uyJfrVDlXqxeL6q1NzL1hpSGokoa2fKGM
        Y16eyXjkGkGson5a+uIIXAFh
X-Google-Smtp-Source: AGRyM1uSL1lHx/F3ktq2lj73s4yHTlYBZRt+SdeP0H4xYhCBXcmnFOx8ryPTt8YqsPNQWd7EYutjmA==
X-Received: by 2002:a7b:c3d4:0:b0:3a3:ce7:7894 with SMTP id t20-20020a7bc3d4000000b003a30ce77894mr3445137wmj.134.1657897295216;
        Fri, 15 Jul 2022 08:01:35 -0700 (PDT)
Received: from Mem (2a01cb088160fc0095dc955fbebd15a0.ipv6.abo.wanadoo.fr. [2a01:cb08:8160:fc00:95dc:955f:bebd:15a0])
        by smtp.gmail.com with ESMTPSA id p19-20020a05600c359300b003a300452f7fsm7304955wmq.32.2022.07.15.08.01.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jul 2022 08:01:34 -0700 (PDT)
Date:   Fri, 15 Jul 2022 17:01:33 +0200
From:   Paul Chaignon <paul@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <martin.lau@linux.dev>,
        John Fastabend <john.fastabend@gmail.com>,
        Kaixi Fan <fankaixi.li@bytedance.com>,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: [PATCH bpf 2/5] vxlan: Use ip_tunnel_key flow flags in route lookups
Message-ID: <40ddf5780215bd001604410682c42d132d8f01ed.1657895526.git.paul@isovalent.com>
References: <cover.1657895526.git.paul@isovalent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1657895526.git.paul@isovalent.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the new ip_tunnel_key field with the flow flags in the route lookups
for the encapsulated packet. This will be used by the
bpf_skb_set_tunnel_key helper in a subsequent commit.

Signed-off-by: Paul Chaignon <paul@isovalent.com>
---
 drivers/net/vxlan/vxlan_core.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index 265d4a0245e7..3c93cf5683be 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -2243,7 +2243,7 @@ static struct rtable *vxlan_get_route(struct vxlan_dev *vxlan, struct net_device
 				      struct vxlan_sock *sock4,
 				      struct sk_buff *skb, int oif, u8 tos,
 				      __be32 daddr, __be32 *saddr, __be16 dport, __be16 sport,
-				      struct dst_cache *dst_cache,
+				      __u8 flow_flags, struct dst_cache *dst_cache,
 				      const struct ip_tunnel_info *info)
 {
 	bool use_cache = ip_tunnel_dst_cache_usable(skb, info);
@@ -2270,6 +2270,7 @@ static struct rtable *vxlan_get_route(struct vxlan_dev *vxlan, struct net_device
 	fl4.saddr = *saddr;
 	fl4.fl4_dport = dport;
 	fl4.fl4_sport = sport;
+	fl4.flowi4_flags = flow_flags;
 
 	rt = ip_route_output_key(vxlan->net, &fl4);
 	if (!IS_ERR(rt)) {
@@ -2298,6 +2299,7 @@ static struct dst_entry *vxlan6_get_route(struct vxlan_dev *vxlan,
 					  const struct in6_addr *daddr,
 					  struct in6_addr *saddr,
 					  __be16 dport, __be16 sport,
+					  __u8 flow_flags,
 					  struct dst_cache *dst_cache,
 					  const struct ip_tunnel_info *info)
 {
@@ -2325,6 +2327,7 @@ static struct dst_entry *vxlan6_get_route(struct vxlan_dev *vxlan,
 	fl6.flowi6_proto = IPPROTO_UDP;
 	fl6.fl6_dport = dport;
 	fl6.fl6_sport = sport;
+	fl6.flowi6_flags = flow_flags;
 
 	ndst = ipv6_stub->ipv6_dst_lookup_flow(vxlan->net, sock6->sock->sk,
 					       &fl6, NULL);
@@ -2459,7 +2462,7 @@ static void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 	unsigned int pkt_len = skb->len;
 	__be16 src_port = 0, dst_port;
 	struct dst_entry *ndst = NULL;
-	__u8 tos, ttl;
+	__u8 tos, ttl, flow_flags = 0;
 	int ifindex;
 	int err;
 	u32 flags = vxlan->cfg.flags;
@@ -2525,6 +2528,7 @@ static void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 		}
 		dst = &remote_ip;
 		dst_port = info->key.tp_dst ? : vxlan->cfg.dst_port;
+		flow_flags = info->key.flow_flags;
 		vni = tunnel_id_to_key32(info->key.tun_id);
 		ifindex = 0;
 		dst_cache = &info->dst_cache;
@@ -2555,7 +2559,7 @@ static void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 		rt = vxlan_get_route(vxlan, dev, sock4, skb, ifindex, tos,
 				     dst->sin.sin_addr.s_addr,
 				     &local_ip.sin.sin_addr.s_addr,
-				     dst_port, src_port,
+				     dst_port, src_port, flow_flags,
 				     dst_cache, info);
 		if (IS_ERR(rt)) {
 			err = PTR_ERR(rt);
@@ -2628,7 +2632,7 @@ static void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 		ndst = vxlan6_get_route(vxlan, dev, sock6, skb, ifindex, tos,
 					label, &dst->sin6.sin6_addr,
 					&local_ip.sin6.sin6_addr,
-					dst_port, src_port,
+					dst_port, src_port, flow_flags,
 					dst_cache, info);
 		if (IS_ERR(ndst)) {
 			err = PTR_ERR(ndst);
@@ -3061,7 +3065,8 @@ static int vxlan_fill_metadata_dst(struct net_device *dev, struct sk_buff *skb)
 		rt = vxlan_get_route(vxlan, dev, sock4, skb, 0, info->key.tos,
 				     info->key.u.ipv4.dst,
 				     &info->key.u.ipv4.src, dport, sport,
-				     &info->dst_cache, info);
+				     info->key.flow_flags, &info->dst_cache,
+				     info);
 		if (IS_ERR(rt))
 			return PTR_ERR(rt);
 		ip_rt_put(rt);
@@ -3073,7 +3078,8 @@ static int vxlan_fill_metadata_dst(struct net_device *dev, struct sk_buff *skb)
 		ndst = vxlan6_get_route(vxlan, dev, sock6, skb, 0, info->key.tos,
 					info->key.label, &info->key.u.ipv6.dst,
 					&info->key.u.ipv6.src, dport, sport,
-					&info->dst_cache, info);
+					info->key.flow_flags, &info->dst_cache,
+					info);
 		if (IS_ERR(ndst))
 			return PTR_ERR(ndst);
 		dst_release(ndst);
-- 
2.25.1

