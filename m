Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 184A91273D8
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 04:26:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727231AbfLTD0E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 22:26:04 -0500
Received: from mail-pf1-f171.google.com ([209.85.210.171]:47008 "EHLO
        mail-pf1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727110AbfLTD0E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 22:26:04 -0500
Received: by mail-pf1-f171.google.com with SMTP id y14so4413277pfm.13
        for <netdev@vger.kernel.org>; Thu, 19 Dec 2019 19:26:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZsMCdqUX7VuEOo6HR5kBj4pUSPx86z7sKU6GXvdf59Q=;
        b=IJB0zccngxYH6UZ/pVkcUNi8fmJsGun+loiZYDMFv15KG3b+3nYYI+qcU+Or9cD4bd
         NY/JPrjMJ1+Oua5xQc+rMXtJeBJQ1hUM2A76hAi0qa1S5/ZoP2FbShPC84DDhRZXiJoP
         mDBAMxmOJitCSUKGK3PrnLgXkClmyQXlW3tODOU1Jk8+Az/940K9cYLjRY5NpNBghTqN
         wY4Ho/ZMiB+jT8vauVRfp7Ai+mQHXBdSENgtAbbw7LmtEFF2oFrBakWK5tsRhW1xqQYn
         URg7ULjAyo2RCIJjCHv2qBWyvnhoe73y1crbaV/yFLmuEmxntT6Bo+3+R+7cCw2D1MP5
         ZDPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZsMCdqUX7VuEOo6HR5kBj4pUSPx86z7sKU6GXvdf59Q=;
        b=XDVk5P/HCbz6UJyfp7RhwPWdsUKqELR0551m5vNdVRNVfJGtN583fcQgp8V8gXOrdL
         Dm50YIi6xTDw+NOV5dx69Mob/HkG9rwCJQqBBA1GmpVJ1UEBClj/cLHp+Z0eIK3yHvP7
         zvdv8iEjhIzPaJzBG/oCx5cdNqmGtJdYdOSf7Z4AzdvcBw8BRo9ZRhEC5zf3XwpSMvXA
         hoMjkhLl+vIm08dTfI6a4iHGoyOKyJOtiv8j9vSeUuvurhqcGv21kDhy/18uh+owvpBA
         YcWsTfuhPaDftaXROX7dSha7PXAIkuiT/V/H4m0bxHKPr2C2Ker3RC/zVmKj+s4OvCwe
         NiKg==
X-Gm-Message-State: APjAAAWm3SRDIWrhnd9geEBItiW0mdl/V+mmHSNPnKPebvF3yfZ7v/46
        +2nDciJCo8CHifWkXwO5EU/Px5pfzw8=
X-Google-Smtp-Source: APXvYqx1oI9vYUOlMSO4wMdGt3puAt5fJtRfhb8OFxAsia4XFgAlh8QyGXNOMFmHRqO7If3zda4giA==
X-Received: by 2002:a63:4287:: with SMTP id p129mr12485115pga.122.1576812362870;
        Thu, 19 Dec 2019 19:26:02 -0800 (PST)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id gc1sm7954265pjb.20.2019.12.19.19.25.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Dec 2019 19:26:02 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Julian Anastasov <ja@ssi.bg>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Guillaume Nault <gnault@redhat.com>,
        David Miller <davem@davemloft.net>,
        Pablo Neira <pablo@netfilter.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Alexey Kodanev <alexey.kodanev@oracle.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv4 net 5/8] tunnel: do not confirm neighbor when do pmtu update
Date:   Fri, 20 Dec 2019 11:25:22 +0800
Message-Id: <20191220032525.26909-6-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20191220032525.26909-1-liuhangbin@gmail.com>
References: <20191218115313.19352-1-liuhangbin@gmail.com>
 <20191220032525.26909-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When do tunnel PMTU update and calls __ip6_rt_update_pmtu() in the end,
we should not call dst_confirm_neigh() as there is no two-way communication.

v4: Update commit description
v3: Do not remove dst_confirm_neigh, but add a new bool parameter in
    dst_ops.update_pmtu to control whether we should do neighbor confirm.
    Also split the big patch to small ones for each area.
v2: Remove dst_confirm_neigh in __ip6_rt_update_pmtu.

Fixes: 0dec879f636f ("net: use dst_confirm_neigh for UDP, RAW, ICMP, L2TP")
Reviewed-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 net/ipv4/ip_tunnel.c  | 2 +-
 net/ipv6/ip6_tunnel.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/ip_tunnel.c b/net/ipv4/ip_tunnel.c
index 38c02bb62e2c..0fe2a5d3e258 100644
--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -505,7 +505,7 @@ static int tnl_update_pmtu(struct net_device *dev, struct sk_buff *skb,
 		mtu = skb_valid_dst(skb) ? dst_mtu(skb_dst(skb)) : dev->mtu;
 
 	if (skb_valid_dst(skb))
-		skb_dst_update_pmtu(skb, mtu);
+		skb_dst_update_pmtu_no_confirm(skb, mtu);
 
 	if (skb->protocol == htons(ETH_P_IP)) {
 		if (!skb_is_gso(skb) &&
diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index 754a484d35df..2f376dbc37d5 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -640,7 +640,7 @@ ip4ip6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 		if (rel_info > dst_mtu(skb_dst(skb2)))
 			goto out;
 
-		skb_dst_update_pmtu(skb2, rel_info);
+		skb_dst_update_pmtu_no_confirm(skb2, rel_info);
 	}
 
 	icmp_send(skb2, rel_type, rel_code, htonl(rel_info));
@@ -1132,7 +1132,7 @@ int ip6_tnl_xmit(struct sk_buff *skb, struct net_device *dev, __u8 dsfield,
 	mtu = max(mtu, skb->protocol == htons(ETH_P_IPV6) ?
 		       IPV6_MIN_MTU : IPV4_MIN_MTU);
 
-	skb_dst_update_pmtu(skb, mtu);
+	skb_dst_update_pmtu_no_confirm(skb, mtu);
 	if (skb->len - t->tun_hlen - eth_hlen > mtu && !skb_is_gso(skb)) {
 		*pmtu = mtu;
 		err = -EMSGSIZE;
-- 
2.19.2

