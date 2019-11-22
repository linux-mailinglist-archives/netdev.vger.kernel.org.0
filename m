Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86D511060E5
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 06:53:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728725AbfKVFwz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 00:52:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:58776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728706AbfKVFwx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 00:52:53 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E60A207FC;
        Fri, 22 Nov 2019 05:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574401972;
        bh=8YOr+nplVL0sHcQdaELPR2NwqO4VVeaDQAo+Wi/u2aA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=liGRPSwNZ+ELLQUn8t63H+Au+2WcfyJjFjpKCqbFRWOf5KUAny21fC0TxIbunTuaC
         2yG2HEu87lxTkUTMe+b0B6sgvwrlXG5PK1zAI0si8ws4aJudH8yC1wndAURlJNxYbg
         oz9tvZQnttUImEicGc6TiurtJRaaZ7HXTJzdvrXI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 192/219] net: ip_gre: do not report erspan_ver for gre or gretap
Date:   Fri, 22 Nov 2019 00:48:44 -0500
Message-Id: <20191122054911.1750-185-sashal@kernel.org>
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

[ Upstream commit 2bdf700e538828d6456150b9319e5f689b062d54 ]

Report erspan version field to userspace in ipgre_fill_info just for
erspan tunnels. The issue can be triggered with the following reproducer:

$ip link add name gre1 type gre local 192.168.0.1 remote 192.168.1.1
$ip link set dev gre1 up
$ip -d link sh gre1
13: gre1@NONE: <POINTOPOINT,NOARP,UP,LOWER_UP> mtu 1476 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/gre 192.168.0.1 peer 192.168.1.1 promiscuity 0 minmtu 0 maxmtu 0
    gre remote 192.168.1.1 local 192.168.0.1 ttl inherit erspan_ver 0 addrgenmode eui64 numtxqueues 1 numrxqueues 1

Fixes: f551c91de262 ("net: erspan: introduce erspan v2 for ip_gre")
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ip_gre.c | 33 +++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)

diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index 758a0f86d499f..1cb6142532536 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -1469,9 +1469,23 @@ static int ipgre_fill_info(struct sk_buff *skb, const struct net_device *dev)
 	struct ip_tunnel_parm *p = &t->parms;
 	__be16 o_flags = p->o_flags;
 
-	if ((t->erspan_ver == 1 || t->erspan_ver == 2) &&
-	    !t->collect_md)
-		o_flags |= TUNNEL_KEY;
+	if (t->erspan_ver == 1 || t->erspan_ver == 2) {
+		if (!t->collect_md)
+			o_flags |= TUNNEL_KEY;
+
+		if (nla_put_u8(skb, IFLA_GRE_ERSPAN_VER, t->erspan_ver))
+			goto nla_put_failure;
+
+		if (t->erspan_ver == 1) {
+			if (nla_put_u32(skb, IFLA_GRE_ERSPAN_INDEX, t->index))
+				goto nla_put_failure;
+		} else {
+			if (nla_put_u8(skb, IFLA_GRE_ERSPAN_DIR, t->dir))
+				goto nla_put_failure;
+			if (nla_put_u16(skb, IFLA_GRE_ERSPAN_HWID, t->hwid))
+				goto nla_put_failure;
+		}
+	}
 
 	if (nla_put_u32(skb, IFLA_GRE_LINK, p->link) ||
 	    nla_put_be16(skb, IFLA_GRE_IFLAGS,
@@ -1507,19 +1521,6 @@ static int ipgre_fill_info(struct sk_buff *skb, const struct net_device *dev)
 			goto nla_put_failure;
 	}
 
-	if (nla_put_u8(skb, IFLA_GRE_ERSPAN_VER, t->erspan_ver))
-		goto nla_put_failure;
-
-	if (t->erspan_ver == 1) {
-		if (nla_put_u32(skb, IFLA_GRE_ERSPAN_INDEX, t->index))
-			goto nla_put_failure;
-	} else if (t->erspan_ver == 2) {
-		if (nla_put_u8(skb, IFLA_GRE_ERSPAN_DIR, t->dir))
-			goto nla_put_failure;
-		if (nla_put_u16(skb, IFLA_GRE_ERSPAN_HWID, t->hwid))
-			goto nla_put_failure;
-	}
-
 	return 0;
 
 nla_put_failure:
-- 
2.20.1

