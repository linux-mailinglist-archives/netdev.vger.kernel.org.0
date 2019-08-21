Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B1D496F40
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 04:10:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727102AbfHUCKS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 22:10:18 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:40195 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726193AbfHUCKR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 22:10:17 -0400
Received: by mail-pl1-f194.google.com with SMTP id h3so431651pls.7
        for <netdev@vger.kernel.org>; Tue, 20 Aug 2019 19:10:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TOxyTkeyWvW+Z2XuIQq2B6PeWCL2xAMUFAYSPLfMCkU=;
        b=hesyDT0Zvcq382M7beQCQUG3zUxUzyJlVuvxPWqNWIDG90L3W5hl3YjLTGBUOSqt+0
         69PSU3/4wJjwGAt8zHVaxgZI7yNyleLAmEE+wZ5K8DhcSnvktuCIWplhkp1MFOcQAsWq
         mlB9RfvKFYp0onlnvNuOPTRe0Nj7ZKqw/iAnOv4pCYfo5zL4WAX4WhHrAxHQrrUyb/Ls
         6bctiFpFyhdbTIUmky9nFe5hGbXIN3xJTEpEiwhXsu8jT67j1GFHUEZ9eOGD6hpCNQ7N
         EcfUe+tywK7a/v4I5ZLQCw0feHasA7W32G95/gQOUKoxG6WuIpiX9TlHfgOc9xmRv655
         OWww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TOxyTkeyWvW+Z2XuIQq2B6PeWCL2xAMUFAYSPLfMCkU=;
        b=twLKmKD+tDohkJdmyoZ3MyQdLvAW73h0pXELbIb7ThDAuv/Qfv0yD75w7yjNJXGJqE
         rsRq8QhqY7NsjxKgHgk6hpJXekzurPFRLGngIdsofWiM6+o/Y7XAlIbD6n/et2Upuou3
         uoC5zEcjywQmRJreRT87ZS8IPGVj2YMhMUCM18jY7TWA9eDJzPHWYn4laKqlZhLIr7yO
         y2WZ+I0B4s/ZC+Tw+RtdCN4FpRMi8ZqoM77ExosDJf3qzAf2LCFZoyBiOC/jkTSzbQQI
         i8NAk7FJKNchrJuFlNozH6geDF1gdgFjGPCGs3dqEQOPsnqbWIVazb7oy9Oue6ajEG3i
         XyFA==
X-Gm-Message-State: APjAAAVPFNRb69/6g/K7R9dSt9THSxD7IOcW2DnqMA0XvZUTmyYfPpFJ
        aSps4AQaA+f0p+dbLThKd7+DyNrbLa0=
X-Google-Smtp-Source: APXvYqz9LzE2UZ3ipWUygaD6Ih7ap29JJHA/7ribkz/fBzWLiCGsw07lcsjCe2q6KVHg8m9y20rxuA==
X-Received: by 2002:a17:902:8a93:: with SMTP id p19mr31830746plo.106.1566353416411;
        Tue, 20 Aug 2019 19:10:16 -0700 (PDT)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id k3sm36717073pfg.23.2019.08.20.19.10.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Aug 2019 19:10:15 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Stefano Brivio <sbrivio@redhat.com>, wenxu <wenxu@ucloud.cn>,
        Alexei Starovoitov <ast@fb.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv3 1/2] ipv4/icmp: fix rt dst dev null pointer dereference
Date:   Wed, 21 Aug 2019 10:09:53 +0800
Message-Id: <20190821020954.21165-2-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190821020954.21165-1-liuhangbin@gmail.com>
References: <20190815060904.19426-1-liuhangbin@gmail.com>
 <20190821020954.21165-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In __icmp_send() there is a possibility that the rt->dst.dev is NULL,
e,g, with tunnel collect_md mode, which will cause kernel crash.
Here is what the code path looks like, for GRE:

- ip6gre_tunnel_xmit
  - ip6gre_xmit_ipv4
    - __gre6_xmit
      - ip6_tnl_xmit
        - if skb->len - t->tun_hlen - eth_hlen > mtu; return -EMSGSIZE
    - icmp_send
      - net = dev_net(rt->dst.dev); <-- here

The reason is __metadata_dst_init() init dst->dev to NULL by default.
We could not fix it in __metadata_dst_init() as there is no dev supplied.
On the other hand, the reason we need rt->dst.dev is to get the net.
So we can just get it from skb->dev, just like commit 8d9336704521
("ipv6: make icmp6_send() robust against null skb->dev") did.

Fixes: c8b34e680a09 ("ip_tunnel: Add tnl_update_pmtu in ip_md_tunnel_xmit")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 net/ipv4/icmp.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index 1510e951f451..5f00c9d18b02 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -582,7 +582,10 @@ void __icmp_send(struct sk_buff *skb_in, int type, int code, __be32 info,
 
 	if (!rt)
 		goto out;
-	net = dev_net(rt->dst.dev);
+
+	if (!skb_in->dev)
+		goto out;
+	net = dev_net(skb_in->dev);
 
 	/*
 	 *	Find the original header. It is expected to be valid, of course.
-- 
2.19.2

