Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34FF110614B
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 06:55:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727946AbfKVFzX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 00:55:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:58768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728713AbfKVFwy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 00:52:54 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB04A2075E;
        Fri, 22 Nov 2019 05:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574401973;
        bh=XWGD5FnpioMR5ta8+wtIT9CfYIjrrA31YwBBRXFFIKQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PBVrful9rxQa+j21/+kmsWivxUDdi8NHMSVYP/sPSDAAYssrtYKrQ5WCVQPrMI4ro
         KR4sI+/ZWNLdR2UpcoYUqiB8fqu37WcA9BjhQ/CymzOwPQfc3u0iwlzJ5ahTQ64zOo
         IM4sOlk+zjkrZXUDfptJQPYvof+QON9Y8ZHuR/qU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 193/219] net: ip6_gre: do not report erspan_ver for ip6gre or ip6gretap
Date:   Fri, 22 Nov 2019 00:48:45 -0500
Message-Id: <20191122054911.1750-186-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122054911.1750-1-sashal@kernel.org>
References: <20191122054911.1750-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>

[ Upstream commit 103d0244d29fcaf38f1339d4538919bbbc051490 ]

Report erspan version field to userspace in ip6gre_fill_info just for
erspan_v6 tunnels. Moreover report IFLA_GRE_ERSPAN_INDEX only for
erspan version 1.
The issue can be triggered with the following reproducer:

$ip link add name gre6 type ip6gre local 2001::1 remote 2002::2
$ip link set gre6 up
$ip -d link sh gre6
14: grep6@NONE: <POINTOPOINT,NOARP,UP,LOWER_UP> mtu 1448 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/gre6 2001::1 peer 2002::2 promiscuity 0 minmtu 0 maxmtu 0
    ip6gre remote 2002::2 local 2001::1 hoplimit 64 encaplimit 4 tclass 0x00 flowlabel 0x00000 erspan_index 0 erspan_ver 0 addrgenmode eui64

Fixes: 94d7d8f29287 ("ip6_gre: add erspan v2 support")
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ip6_gre.c | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index dee4113f21a9a..8fd28edd6ac57 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -2135,9 +2135,23 @@ static int ip6gre_fill_info(struct sk_buff *skb, const struct net_device *dev)
 	struct __ip6_tnl_parm *p = &t->parms;
 	__be16 o_flags = p->o_flags;
 
-	if ((p->erspan_ver == 1 || p->erspan_ver == 2) &&
-	    !p->collect_md)
-		o_flags |= TUNNEL_KEY;
+	if (p->erspan_ver == 1 || p->erspan_ver == 2) {
+		if (!p->collect_md)
+			o_flags |= TUNNEL_KEY;
+
+		if (nla_put_u8(skb, IFLA_GRE_ERSPAN_VER, p->erspan_ver))
+			goto nla_put_failure;
+
+		if (p->erspan_ver == 1) {
+			if (nla_put_u32(skb, IFLA_GRE_ERSPAN_INDEX, p->index))
+				goto nla_put_failure;
+		} else {
+			if (nla_put_u8(skb, IFLA_GRE_ERSPAN_DIR, p->dir))
+				goto nla_put_failure;
+			if (nla_put_u16(skb, IFLA_GRE_ERSPAN_HWID, p->hwid))
+				goto nla_put_failure;
+		}
+	}
 
 	if (nla_put_u32(skb, IFLA_GRE_LINK, p->link) ||
 	    nla_put_be16(skb, IFLA_GRE_IFLAGS,
@@ -2152,8 +2166,7 @@ static int ip6gre_fill_info(struct sk_buff *skb, const struct net_device *dev)
 	    nla_put_u8(skb, IFLA_GRE_ENCAP_LIMIT, p->encap_limit) ||
 	    nla_put_be32(skb, IFLA_GRE_FLOWINFO, p->flowinfo) ||
 	    nla_put_u32(skb, IFLA_GRE_FLAGS, p->flags) ||
-	    nla_put_u32(skb, IFLA_GRE_FWMARK, p->fwmark) ||
-	    nla_put_u32(skb, IFLA_GRE_ERSPAN_INDEX, p->index))
+	    nla_put_u32(skb, IFLA_GRE_FWMARK, p->fwmark))
 		goto nla_put_failure;
 
 	if (nla_put_u16(skb, IFLA_GRE_ENCAP_TYPE,
@@ -2171,19 +2184,6 @@ static int ip6gre_fill_info(struct sk_buff *skb, const struct net_device *dev)
 			goto nla_put_failure;
 	}
 
-	if (nla_put_u8(skb, IFLA_GRE_ERSPAN_VER, p->erspan_ver))
-		goto nla_put_failure;
-
-	if (p->erspan_ver == 1) {
-		if (nla_put_u32(skb, IFLA_GRE_ERSPAN_INDEX, p->index))
-			goto nla_put_failure;
-	} else if (p->erspan_ver == 2) {
-		if (nla_put_u8(skb, IFLA_GRE_ERSPAN_DIR, p->dir))
-			goto nla_put_failure;
-		if (nla_put_u16(skb, IFLA_GRE_ERSPAN_HWID, p->hwid))
-			goto nla_put_failure;
-	}
-
 	return 0;
 
 nla_put_failure:
-- 
2.20.1

