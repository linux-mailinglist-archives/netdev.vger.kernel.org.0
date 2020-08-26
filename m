Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24390253562
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 18:49:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728037AbgHZQt3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 12:49:29 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:46015 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726739AbgHZQtY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 12:49:24 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 75C8A5C00F2;
        Wed, 26 Aug 2020 12:49:23 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 26 Aug 2020 12:49:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=qgPPP+22HNcXHBI2ElY71Qiz6wDOZ8oN2F3Tpjd4SpE=; b=Q0s/4Sjn
        Vf74SCmar91OPcQrpUHo8yP/HXyoGYAp4tU94EFL4SiJr6fCnHbzrVQVxOGBBlIW
        wcnyXjp/HsfPhafNmiNSW1HRS5N/DcBpoR8PumDuSC2BDxLxWkswFX93eDnzBPws
        1sMvwC0uBPmB2rimCQ3syYNiU8kDoYGuTONg/MdRjMGyt3VgJQug2ajXViGZIg5T
        70ot8bS5AgCwhyEWfH3ZMmRMjvWlPaMLBkXpn893NVuUAYL+jPVi6CBsYaQgwi/h
        0mAgPF0+avikezMOFC1lNkPME2LQIN5ImraAAkmI5GA7iMgunquZBCx5Nul0f9ap
        gPkhq2KDKQaVTg==
X-ME-Sender: <xms:k5JGXwyHhxkw5SNeWixIaGiw1Iy24NB4zQbpJ-_m-RfuI2NCdpueUg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddvvddguddtfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdefjedrudei
    keenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:k5JGX0RkD9ElclozMHwaEDHbc-DkE1varwjp6BIktNw05uL61hHA5A>
    <xmx:k5JGXyUhszVtekOS8UjwNfUvkRbPFX1A-0oK7Fu4msImsyCBytB6vg>
    <xmx:k5JGX-jGC7ZuofA4g0HZ_w-PuLVBmFBOG2KHd7PXN4MW6CCSQUcHUw>
    <xmx:k5JGXz7H7brq9t-ShsIoaBqfp4yMVL3TE0uAPRFZdxVYWrNtHxrGqw>
Received: from shredder.mtl.com (igld-84-229-37-168.inter.net.il [84.229.37.168])
        by mail.messagingengine.com (Postfix) with ESMTPA id C0F6C3280059;
        Wed, 26 Aug 2020 12:49:21 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 2/7] ipv4: nexthop: Use nla_put_be32() for NHA_GATEWAY
Date:   Wed, 26 Aug 2020 19:48:52 +0300
Message-Id: <20200826164857.1029764-3-idosch@idosch.org>
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

The code correctly uses nla_get_be32() to get the payload of the
attribute, but incorrectly uses nla_put_u32() to add the attribute to
the payload. This results in the following warning:

net/ipv4/nexthop.c:279:59: warning: incorrect type in argument 3 (different base types)
net/ipv4/nexthop.c:279:59:    expected unsigned int [usertype] value
net/ipv4/nexthop.c:279:59:    got restricted __be32 [usertype] ipv4

Suppress the warning by using nla_put_be32().

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 net/ipv4/nexthop.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index d13730ff9aeb..0823643a7dec 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -276,7 +276,7 @@ static int nh_fill_node(struct sk_buff *skb, struct nexthop *nh,
 	case AF_INET:
 		fib_nh = &nhi->fib_nh;
 		if (fib_nh->fib_nh_gw_family &&
-		    nla_put_u32(skb, NHA_GATEWAY, fib_nh->fib_nh_gw4))
+		    nla_put_be32(skb, NHA_GATEWAY, fib_nh->fib_nh_gw4))
 			goto nla_put_failure;
 		break;
 
-- 
2.26.2

