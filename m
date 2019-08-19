Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6C9C91E55
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 09:53:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbfHSHxr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 03:53:47 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:45383 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725790AbfHSHxq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 03:53:46 -0400
Received: by mail-pf1-f194.google.com with SMTP id w26so684987pfq.12
        for <netdev@vger.kernel.org>; Mon, 19 Aug 2019 00:53:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TOxyTkeyWvW+Z2XuIQq2B6PeWCL2xAMUFAYSPLfMCkU=;
        b=PbjmwXxdRImOQGlF3VL7U1mVbhFggCNWKITSF3dfTPkTUHiKkidivHGAS15lEfBGcd
         Ghgv/2uZIAkMLye0sBwahET/nA3fu7vjfY9IKEBJfM4e4wyqXRA/hQo5rz1uNCgJtj7S
         iyoraEKsaCIxJC0mHHqc8RBau71RgMZEK7+/WkgZYQnxGg6FztzeNxmnDd5tKwRvllTp
         zfmweHFx7B7YvB72FtSL5P+iIESCljbfNOzvlsf03rMLu+cYl5W1iSNyGbZ1nGvXwt5T
         pHlEqXg0DOuA8I90wrk7Q61E2JOkEAMBLRud4UvjjtS0F/yRcBdyT6vznwygo5cUEfBg
         m0dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TOxyTkeyWvW+Z2XuIQq2B6PeWCL2xAMUFAYSPLfMCkU=;
        b=oIkrMmDli6/ebGmJLJxxNj+tBZXnfWmVla5QA+ZrrytAMaEddKkOtTq4Qtt0I65Lgz
         Q2LgAzBFF/lum6FD/2qslhZfZXabj3wGygb7XcL3to8Lbx0BPDohgpPLXHUN4ldYBMYU
         5LP85Xpt48Bv23z9WwOjJcv4aPGjMGXJz/g5LDMrxn/JLJ+buXL6VQRdetw8i9jk8AjX
         l/DkmIuGcpuvBFAOgXbKfH04ShI29/Ow5/1OyOrNx5ygOWU/Ojo70bza6VhiFeZjcrqD
         UbdWDYhG1mvvP+8YX4sN7MYr1jSOWyb1C6ai5KwJ93tPWjX99TmVK7IgZme83Db83CK4
         CDzQ==
X-Gm-Message-State: APjAAAXABcUtfrykLItgoGmtEdraBMTBpcWqCLM4zxMKJXjqMe2PNXRa
        ggCTGFOcesnS9xNBrt4kM8IG7NI9TfM=
X-Google-Smtp-Source: APXvYqwN7QOEsl9uUaNS/yDWKghYWdRuC/XBUW5Ws9+nfdaz0UsameAUF7RUDuAXkINHWYN335xn4g==
X-Received: by 2002:aa7:9e0a:: with SMTP id y10mr22545564pfq.93.1566201225638;
        Mon, 19 Aug 2019 00:53:45 -0700 (PDT)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y188sm16941270pfb.115.2019.08.19.00.53.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Aug 2019 00:53:45 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Stefano Brivio <sbrivio@redhat.com>, wenxu <wenxu@ucloud.cn>,
        Alexei Starovoitov <ast@fb.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH 1/2] ipv4/icmp: fix rt dst dev null pointer dereference
Date:   Mon, 19 Aug 2019 15:53:26 +0800
Message-Id: <20190819075327.32412-2-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190819075327.32412-1-liuhangbin@gmail.com>
References: <20190815060904.19426-1-liuhangbin@gmail.com>
 <20190819075327.32412-1-liuhangbin@gmail.com>
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

