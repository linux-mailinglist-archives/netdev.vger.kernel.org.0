Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2028253564
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 18:49:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728185AbgHZQtd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 12:49:33 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:58003 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727833AbgHZQt0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 12:49:26 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 7EF6B5C00CE;
        Wed, 26 Aug 2020 12:49:25 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 26 Aug 2020 12:49:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=1ysbNdcIfogXc7bFLB+V2q2ohat4t4tAY02xYeQpakg=; b=unY0RK4c
        Otq18Ce1CsEN2jUYjrVRR1Xm/l/vrj/4f5oZR1gYu4EAbAase/TAcU0FCW7l7xuP
        HhcWVIIyZXsSG28xhbuVgxkwGHctLA357OGmLW52KM3Kmwf7MVWr54wQvhDyEQXq
        Z+RGHJ6aAnyuiWQc21jOoNI8JDeAmJjiZWkmoSKdTxRqX4b41miTx7K1OfAiiypA
        X6l/N+m+P+TLtw+AUkvEWmvyMzkXgcVaI96HeUsjA2nSJ3XELkkqB3UdckyoNlq4
        dqOf4Wmu/8DBCeZQ+xJ4ZrMv4zGqm68SqfFXzVkuymSjWSzUEN/AlgdyK3hV+yNY
        pii+1TcBWMkTTA==
X-ME-Sender: <xms:lZJGXxM-PcZ-ELllUVoMNxKCDjmIJiKm0b6AxTrBVnFAQWkitIDcfg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddvvddguddtfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdefjedrudei
    keenucevlhhushhtvghrufhiiigvpedvnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:lZJGXz-cUmldx1BT0-ppv2Pj96Qwf6jgXVZnPWEC-mWer8dRaYZw7Q>
    <xmx:lZJGXwR5AbTwX1JMbEGRLcmmN5ga5gmwchvdWsm0efJ3uojkFb59-g>
    <xmx:lZJGX9uK7UMf20UrM28sssAFfWVSHO72wAhu6DzLsHMBCPweSuVHQA>
    <xmx:lZJGX5H22nw8D6apqohoFiR5EJ7sxZSRpPdig2fDsBntiWdiwVK8Lw>
Received: from shredder.mtl.com (igld-84-229-37-168.inter.net.il [84.229.37.168])
        by mail.messagingengine.com (Postfix) with ESMTPA id A75833280059;
        Wed, 26 Aug 2020 12:49:23 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 3/7] ipv4: nexthop: Remove unnecessary rtnl_dereference()
Date:   Wed, 26 Aug 2020 19:48:53 +0300
Message-Id: <20200826164857.1029764-4-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200826164857.1029764-1-idosch@idosch.org>
References: <20200826164857.1029764-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

The pointer is not RCU protected, so remove the unnecessary
rtnl_dereference(). This suppresses the following warning:

net/ipv4/nexthop.c:1101:24: error: incompatible types in comparison expression (different address spaces):
net/ipv4/nexthop.c:1101:24:    struct rb_node [noderef] __rcu *
net/ipv4/nexthop.c:1101:24:    struct rb_node *

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 net/ipv4/nexthop.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 0823643a7dec..1b736e3e1baa 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -1098,7 +1098,7 @@ static int insert_nexthop(struct net *net, struct nexthop *new_nh,
 	while (1) {
 		struct nexthop *nh;
 
-		next = rtnl_dereference(*pp);
+		next = *pp;
 		if (!next)
 			break;
 
-- 
2.26.2

