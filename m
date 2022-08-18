Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01C15597F5A
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 09:42:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243740AbiHRHlj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 03:41:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243631AbiHRHli (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 03:41:38 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA5EF5727A;
        Thu, 18 Aug 2022 00:41:36 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id m10-20020a05600c3b0a00b003a603fc3f81so499606wms.0;
        Thu, 18 Aug 2022 00:41:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=/g4km6FxDiqO++AcbVWHXR1P5CevBxANAOiKHbix4ck=;
        b=DJVlCrI7UI6SX23b+6S0oqa6DloKDWoOMA+3yumzI4YXQ5oyOz6A7BDdzo7TZu1vB8
         DKn4TAlTrhQ5+dzpBi0zsxAAeAYmAGFEjN+ZoWvcR72l225WgyxkhLOgjV3PCdK0Di6S
         2qFkdEOH1hdBFiYx9aHgOpFTnhYK4hZ6aTuT8XNdHHq0bJxrQlTYAC8rsFPeNaxabFjT
         ZRCp6earwpFA2pGebTo9I4VQul09aODYvIL4ESEgdSEMdjSGBHANNo52Uo80T0eJgTrB
         tlP3YwZMHK4OJ5GvOYu230UoRbGSgV5U4qH/AmztA2Pa4b5ksXXhsO7YWI390LVACyG6
         jzdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=/g4km6FxDiqO++AcbVWHXR1P5CevBxANAOiKHbix4ck=;
        b=FBDrlBO9eEabh8M520GrfaRhnwxHSnlCYOQvCeL2zOni/2oUiR/NjU9C/4JeYpmBv+
         MQv18iFZh1P9AS1lob9FUWNpbHDBTbOOMtWuJoaoNCqPFiWdBgcr3/C4uVsJdb380+U7
         Ut7K/q9k2POW7gG7XMQSjlQRnQBt4CxTIcLNmHRyuKiHUFAFNY72lT60/mrSP+kYkUT4
         DAC3He6Zey3mGsw5SZLQ9as2vqBoiqUw4BoWvtNicdThQPRENhgeQ69QvzsDQuUPUgAH
         XsQWYxAPIHKlzHs4WZtYSW5WqrtFyNmVfyE4Egqimie+BMU4LtIitX9Y2UoLV8YG5Gyg
         66UQ==
X-Gm-Message-State: ACgBeo2PlZE7leue8F2DdMwmDbdnbiPnFjVPFQ26WVSZUSxltj8YPa8+
        zQhxvdOkuF7y1S7zVXjvmwBNnYf0xAorGA==
X-Google-Smtp-Source: AA6agR4m5C7RuMvGPEDoDPeUEWS69lYE8TAFKSos2KXhmbfMRSAI6r9Z7J0Rs8bAcXCa8M3bohQMcg==
X-Received: by 2002:a7b:ce12:0:b0:3a5:4d8b:65df with SMTP id m18-20020a7bce12000000b003a54d8b65dfmr1011183wmc.27.1660808495347;
        Thu, 18 Aug 2022 00:41:35 -0700 (PDT)
Received: from localhost.localdomain ([213.57.189.88])
        by smtp.gmail.com with ESMTPSA id r28-20020adfb1dc000000b00225232154d7sm643158wra.110.2022.08.18.00.41.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 00:41:34 -0700 (PDT)
From:   Eyal Birger <eyal.birger@gmail.com>
To:     idosch@nvidia.com, petrm@nvidia.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, razor@blackwall.org,
        daniel@iogearbox.net, kafai@fb.com, paul@isovalent.com
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Eyal Birger <eyal.birger@gmail.com>
Subject: [PATCH bpf] ip_tunnel: respect tunnel key's "flow_flags" in IP tunnels
Date:   Thu, 18 Aug 2022 10:41:18 +0300
Message-Id: <20220818074118.726639-1-eyal.birger@gmail.com>
X-Mailer: git-send-email 2.34.1
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

Commit 451ef36bd229 ("ip_tunnels: Add new flow flags field to ip_tunnel_key")
added a "flow_flags" member to struct ip_tunnel_key which was later used by
the commit in the fixes tag to avoid dropping packets with sources that
aren't locally configured when set in bpf_set_tunnel_key().

VXLAN and GENEVE were made to respect this flag, ip tunnels like IPIP and GRE
were not.

This commit fixes this omission by making ip_tunnel_init_flow() receive
the flow flags from the tunnel key in the relevant collect_md paths.

Fixes: b8fff748521c ("bpf: Set flow flag to allow any source IP in bpf_tunnel_key")
Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c | 3 ++-
 include/net/ip_tunnels.h                            | 4 +++-
 net/ipv4/ip_gre.c                                   | 2 +-
 net/ipv4/ip_tunnel.c                                | 7 ++++---
 4 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
index 39904dacf4f0..b3472fb94617 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
@@ -423,7 +423,8 @@ mlxsw_sp_span_gretap4_route(const struct net_device *to_dev,
 
 	parms = mlxsw_sp_ipip_netdev_parms4(to_dev);
 	ip_tunnel_init_flow(&fl4, parms.iph.protocol, *daddrp, *saddrp,
-			    0, 0, dev_net(to_dev), parms.link, tun->fwmark, 0);
+			    0, 0, dev_net(to_dev), parms.link, tun->fwmark, 0,
+			    0);
 
 	rt = ip_route_output_key(tun->net, &fl4);
 	if (IS_ERR(rt))
diff --git a/include/net/ip_tunnels.h b/include/net/ip_tunnels.h
index 63fac94f9ace..ced80e2f8b58 100644
--- a/include/net/ip_tunnels.h
+++ b/include/net/ip_tunnels.h
@@ -246,7 +246,8 @@ static inline void ip_tunnel_init_flow(struct flowi4 *fl4,
 				       __be32 daddr, __be32 saddr,
 				       __be32 key, __u8 tos,
 				       struct net *net, int oif,
-				       __u32 mark, __u32 tun_inner_hash)
+				       __u32 mark, __u32 tun_inner_hash,
+				       __u8 flow_flags)
 {
 	memset(fl4, 0, sizeof(*fl4));
 
@@ -263,6 +264,7 @@ static inline void ip_tunnel_init_flow(struct flowi4 *fl4,
 	fl4->fl4_gre_key = key;
 	fl4->flowi4_mark = mark;
 	fl4->flowi4_multipath_hash = tun_inner_hash;
+	fl4->flowi4_flags = flow_flags;
 }
 
 int ip_tunnel_init(struct net_device *dev);
diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index 5c58e21f724e..f866d6282b2b 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -609,7 +609,7 @@ static int gre_fill_metadata_dst(struct net_device *dev, struct sk_buff *skb)
 	ip_tunnel_init_flow(&fl4, IPPROTO_GRE, key->u.ipv4.dst, key->u.ipv4.src,
 			    tunnel_id_to_key32(key->tun_id),
 			    key->tos & ~INET_ECN_MASK, dev_net(dev), 0,
-			    skb->mark, skb_get_hash(skb));
+			    skb->mark, skb_get_hash(skb), key->flow_flags);
 	rt = ip_route_output_key(dev_net(dev), &fl4);
 	if (IS_ERR(rt))
 		return PTR_ERR(rt);
diff --git a/net/ipv4/ip_tunnel.c b/net/ipv4/ip_tunnel.c
index e65e948cab9f..019f3b0839c5 100644
--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -295,7 +295,7 @@ static int ip_tunnel_bind_dev(struct net_device *dev)
 		ip_tunnel_init_flow(&fl4, iph->protocol, iph->daddr,
 				    iph->saddr, tunnel->parms.o_key,
 				    RT_TOS(iph->tos), dev_net(dev),
-				    tunnel->parms.link, tunnel->fwmark, 0);
+				    tunnel->parms.link, tunnel->fwmark, 0, 0);
 		rt = ip_route_output_key(tunnel->net, &fl4);
 
 		if (!IS_ERR(rt)) {
@@ -570,7 +570,8 @@ void ip_md_tunnel_xmit(struct sk_buff *skb, struct net_device *dev,
 	}
 	ip_tunnel_init_flow(&fl4, proto, key->u.ipv4.dst, key->u.ipv4.src,
 			    tunnel_id_to_key32(key->tun_id), RT_TOS(tos),
-			    dev_net(dev), 0, skb->mark, skb_get_hash(skb));
+			    dev_net(dev), 0, skb->mark, skb_get_hash(skb),
+			    key->flow_flags);
 	if (tunnel->encap.type != TUNNEL_ENCAP_NONE)
 		goto tx_error;
 
@@ -729,7 +730,7 @@ void ip_tunnel_xmit(struct sk_buff *skb, struct net_device *dev,
 	ip_tunnel_init_flow(&fl4, protocol, dst, tnl_params->saddr,
 			    tunnel->parms.o_key, RT_TOS(tos),
 			    dev_net(dev), tunnel->parms.link,
-			    tunnel->fwmark, skb_get_hash(skb));
+			    tunnel->fwmark, skb_get_hash(skb), 0);
 
 	if (ip_tunnel_encap(skb, tunnel, &protocol, &fl4) < 0)
 		goto tx_error;
-- 
2.34.1

