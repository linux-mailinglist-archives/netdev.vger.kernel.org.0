Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 966493509A2
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 23:38:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232627AbhCaViU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 17:38:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231210AbhCaViR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 17:38:17 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D846C061574
        for <netdev@vger.kernel.org>; Wed, 31 Mar 2021 14:38:17 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id bt4so10200900pjb.5
        for <netdev@vger.kernel.org>; Wed, 31 Mar 2021 14:38:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NZm7RaKIS+bgLQU/KWuJ5y+M6y9GHWGtZvpwkfMJY4Q=;
        b=TR3gNRLrDW37AsRibJTCn1Zj99VvKyUhbbuxSy/Si9bi/rcbYAtPgDpZxJCk/D7Q59
         GfRbMYx74At2DzqHR5y3G9n+6YizVQMjnupXuE9sLsV9XlGEwnxCeEyz1305prXYCLOs
         9a9hYFRdPI+XKR4zOZDn7iXjL1/cBiWdM9OExOlXKSNkoGy+hTv0jWiKItlZcmeOoVfH
         BobugeQlZznXxQqY/pqI3mYbcLpKByKh37OzY5D/4RdaBmsTplqTCLOkdMFv5f8zzveN
         GVtqNutEleDmYvEQzez0E0xpjjSi/dqtE0gpmHfWja0Qq19ED24y+pNCbxm9EdDzlD2T
         34KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NZm7RaKIS+bgLQU/KWuJ5y+M6y9GHWGtZvpwkfMJY4Q=;
        b=VF4oUl5uuaj29+Thd9KKv5c1py6YWAyV5Ce7iHYdF5AZkudGaMHzxrKurXy9aYaT/t
         IX7NWdRL8bUzZSxOfkZyGJH9RQvmGz5ewgsk6fksGFjXdSgGDqY4x471OPSulwlmujXr
         Ck+a1qPNtdjNAu64DqY4f/MWDQyX2Aeoo+OHH8AfO3ZMvaa3/obYIjYUNYsnLCZfej0c
         RZWyitn9qduxDsMNMenCEm7okJc6FuShpjn/06A8+KsPiW3Wb7+4Y/VwzBLNKTZbdOfF
         Fp3wwHfra9DBhzMKo4qd4Jm1a4Lb3qZaNUZ8eo0wEKf9Z6WwsjAmhQDQsjXefnXGZS/N
         xvgQ==
X-Gm-Message-State: AOAM530x0kU6kBGfWwwPHdqiCd2mU3CVWbtN5RidpPCwdF4xd8HTwaXq
        IEA8w/+cmOGRDfRaX9uzn2A=
X-Google-Smtp-Source: ABdhPJwvyEj3+VEzAI0oUjM8eefWBF20GcPknci9niqcJP6tVJNWVUaDuIwiD5j3OyWhRq0BXKwv2g==
X-Received: by 2002:a17:90a:64c7:: with SMTP id i7mr5324860pjm.95.1617226697273;
        Wed, 31 Mar 2021 14:38:17 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:9107:b184:4a71:45d0])
        by smtp.gmail.com with ESMTPSA id fh19sm3171017pjb.33.2021.03.31.14.38.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Mar 2021 14:38:16 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH net-next] ipv6: remove extra dev_hold() for fallback tunnels
Date:   Wed, 31 Mar 2021 14:38:11 -0700
Message-Id: <20210331213811.847054-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

My previous commits added a dev_hold() in tunnels ndo_init(),
but forgot to remove it from special functions setting up fallback tunnels.

Fallback tunnels do call their respective ndo_init()

This leads to various reports like :

unregister_netdevice: waiting for ip6gre0 to become free. Usage count = 2

Fixes: 48bb5697269a ("ip6_tunnel: sit: proper dev_{hold|put} in ndo_[un]init methods")
Fixes: 6289a98f0817 ("sit: proper dev_{hold|put} in ndo_[un]init methods")
Fixes: 40cb881b5aaa ("ip6_vti: proper dev_{hold|put} in ndo_[un]init methods")
Fixes: 7f700334be9a ("ip6_gre: proper dev_{hold|put} in ndo_[un]init methods")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/ipv6/ip6_gre.c    | 3 ---
 net/ipv6/ip6_tunnel.c | 1 -
 net/ipv6/ip6_vti.c    | 1 -
 net/ipv6/sit.c        | 1 -
 4 files changed, 6 deletions(-)

diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index 9689bf9f46f347562330a4d8630c0b0b13a411fc..bc224f917bbd53beb9b8af5bdef3fb9794b8ee44 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -387,7 +387,6 @@ static struct ip6_tnl *ip6gre_tunnel_locate(struct net *net,
 	if (!(nt->parms.o_flags & TUNNEL_SEQ))
 		dev->features |= NETIF_F_LLTX;
 
-	dev_hold(dev);
 	ip6gre_tunnel_link(ign, nt);
 	return nt;
 
@@ -1539,8 +1538,6 @@ static void ip6gre_fb_tunnel_init(struct net_device *dev)
 	strcpy(tunnel->parms.name, dev->name);
 
 	tunnel->hlen		= sizeof(struct ipv6hdr) + 4;
-
-	dev_hold(dev);
 }
 
 static struct inet6_protocol ip6gre_protocol __read_mostly = {
diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index 67ee9d58ec5efcc81e8b27406bd4f57a0caea70b..07a0a06a9b52bc9974e2f36b1477c341c952f94a 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1925,7 +1925,6 @@ static int __net_init ip6_fb_tnl_dev_init(struct net_device *dev)
 	struct ip6_tnl_net *ip6n = net_generic(net, ip6_tnl_net_id);
 
 	t->parms.proto = IPPROTO_IPV6;
-	dev_hold(dev);
 
 	rcu_assign_pointer(ip6n->tnls_wc[0], t);
 	return 0;
diff --git a/net/ipv6/ip6_vti.c b/net/ipv6/ip6_vti.c
index a018afdb3e062c9e664d4ca424176a859f0a332c..856e46ad0895b47b58896852afee3d4a398b139e 100644
--- a/net/ipv6/ip6_vti.c
+++ b/net/ipv6/ip6_vti.c
@@ -963,7 +963,6 @@ static int __net_init vti6_fb_tnl_dev_init(struct net_device *dev)
 	struct vti6_net *ip6n = net_generic(net, vti6_net_id);
 
 	t->parms.proto = IPPROTO_IPV6;
-	dev_hold(dev);
 
 	rcu_assign_pointer(ip6n->tnls_wc[0], t);
 	return 0;
diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index 488d3181aec3a5558dbefb6145400627535df761..ff2ca2e7c7f5045663069ea572560d58abee2970 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -1470,7 +1470,6 @@ static void __net_init ipip6_fb_tunnel_init(struct net_device *dev)
 	iph->ihl		= 5;
 	iph->ttl		= 64;
 
-	dev_hold(dev);
 	rcu_assign_pointer(sitn->tunnels_wc[0], tunnel);
 }
 
-- 
2.31.0.291.g576ba9dcdaf-goog

