Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3C0D3BCE71
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:26:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233594AbhGFL0H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:26:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:54674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232508AbhGFLS1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:18:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7535E61C66;
        Tue,  6 Jul 2021 11:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570149;
        bh=bCoeEDpeakw8Oebug4Gh/pTMiYMIT4eJH2E2tGUXFGE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kWcBZ/IxVu2u0SHlZu8DV1mfSubKI/X66B1ObOF2wONtL6OSkXisVWU9bakvCHtQu
         Dqa/NixufAEx7GBu/Y29cT6s7kS7VyBVUp/HGwYTkOHkIvw0aw3/G9YJtksHndfCsu
         pIitcOuPjQ8eROcYL3oUkwVjsXKR624+2upNu6We12J4wyQ3lnEeDVs9EKtUP7KfKs
         51Ju2INMumMI8jOPuQ/wrpl8XZ3zI3pXwpEY4+vMf4pOK33Lgy/gkuBNCWKDXn5mV1
         tdJB0dNba67eAOGTD8kmKI1NOz55QykjeKUZ73LfMS3vR6b8EXX2pEjyCLU8Wdvqza
         GVvIg14ZHehWw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andreas Roeseler <andreas.a.roeseler@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 072/189] icmp: fix lib conflict with trinity
Date:   Tue,  6 Jul 2021 07:12:12 -0400
Message-Id: <20210706111409.2058071-72-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111409.2058071-1-sashal@kernel.org>
References: <20210706111409.2058071-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andreas Roeseler <andreas.a.roeseler@gmail.com>

[ Upstream commit e32ea44c7ae476f4c90e35ab0a29dc8ff082bc11 ]

Including <linux/in.h> and <netinet/in.h> in the dependencies breaks
compilation of trinity due to multiple definitions. <linux/in.h> is only
used in <linux/icmp.h> to provide the definition of the struct in_addr,
but this can be substituted out by using the datatype __be32.

Signed-off-by: Andreas Roeseler <andreas.a.roeseler@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/icmp.h | 3 +--
 net/ipv4/icmp.c           | 2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/icmp.h b/include/uapi/linux/icmp.h
index c1da8244c5e1..163c0998aec9 100644
--- a/include/uapi/linux/icmp.h
+++ b/include/uapi/linux/icmp.h
@@ -20,7 +20,6 @@
 
 #include <linux/types.h>
 #include <asm/byteorder.h>
-#include <linux/in.h>
 #include <linux/if.h>
 #include <linux/in6.h>
 
@@ -154,7 +153,7 @@ struct icmp_ext_echo_iio {
 		struct {
 			struct icmp_ext_echo_ctype3_hdr ctype3_hdr;
 			union {
-				struct in_addr	ipv4_addr;
+				__be32		ipv4_addr;
 				struct in6_addr	ipv6_addr;
 			} ip_addr;
 		} addr;
diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index 752e392083e6..0a57f1892e7e 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -1066,7 +1066,7 @@ static bool icmp_echo(struct sk_buff *skb)
 			if (ident_len != sizeof(iio->ident.addr.ctype3_hdr) +
 					 sizeof(struct in_addr))
 				goto send_mal_query;
-			dev = ip_dev_find(net, iio->ident.addr.ip_addr.ipv4_addr.s_addr);
+			dev = ip_dev_find(net, iio->ident.addr.ip_addr.ipv4_addr);
 			break;
 #if IS_ENABLED(CONFIG_IPV6)
 		case ICMP_AFI_IP6:
-- 
2.30.2

