Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F859376C3C
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 00:12:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230114AbhEGWM7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 18:12:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:59474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230113AbhEGWMv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 May 2021 18:12:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0872461157;
        Fri,  7 May 2021 22:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620425511;
        bh=+A8VF6/YLLVZtHfI0InfFULYrSxtxYtufbUrU8xRDtk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hlyJjwh7qEunOffqjOOGVduvXwgOaykl4KDohI1T/8pwMkkdix/3dNtEz55QF9OnG
         0G/zTpIKdgYUHq12Pbekj+ENDpO2lV6OiN5Zuu2FW3G0IFmZ2UhMKNX+pR13k+rTiG
         vY/N+FAUxj0bTXw+RJRHQL1hqL5v0+gONh8hesc8GEFSVI1ALm7dQfyoEFHQDNcIVm
         ksIir3wRy5KjZFPPcVLQKf1zvJcJq6v19QGtjPEYaHuCBbAkendeuAXgbjmMR8Bimi
         WMx2HhaQSgpCPEzb08BbbodutFA/4EJcOet7MRqvr5aEPvAUZyMTAWrTYMZ/sevaya
         gDW2W157/Whjg==
From:   Arnd Bergmann <arnd@kernel.org>
To:     linux-arch@vger.kernel.org
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Vineet Gupta <vgupta@synopsys.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC 11/12] netpoll: avoid put_unaligned() on single character
Date:   Sat,  8 May 2021 00:07:56 +0200
Message-Id: <20210507220813.365382-12-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210507220813.365382-1-arnd@kernel.org>
References: <20210507220813.365382-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

With a planned cleanup, using put_unaligned() on a single character
results in a harmless warning:

In file included from ./arch/x86/include/generated/asm/unaligned.h:1,
                 from include/linux/etherdevice.h:24,
                 from net/core/netpoll.c:18:
net/core/netpoll.c: In function 'netpoll_send_udp':
include/asm-generic/unaligned.h:23:9: error: 'packed' attribute ignored for field of type 'unsigned char' [-Werror=attributes]
net/core/netpoll.c:431:3: note: in expansion of macro 'put_unaligned'
  431 |   put_unaligned(0x60, (unsigned char *)ip6h);
      |   ^~~~~~~~~~~~~
include/asm-generic/unaligned.h:23:9: error: 'packed' attribute ignored for field of type 'unsigned char' [-Werror=attributes]
net/core/netpoll.c:459:3: note: in expansion of macro 'put_unaligned'
  459 |   put_unaligned(0x45, (unsigned char *)iph);
      |   ^~~~~~~~~~~~~

Replace this with an open-coded pointer dereference.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 net/core/netpoll.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/netpoll.c b/net/core/netpoll.c
index c310c7c1cef7..9c49a38fa315 100644
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -428,7 +428,7 @@ void netpoll_send_udp(struct netpoll *np, const char *msg, int len)
 		ip6h = ipv6_hdr(skb);
 
 		/* ip6h->version = 6; ip6h->priority = 0; */
-		put_unaligned(0x60, (unsigned char *)ip6h);
+		*(unsigned char *)ip6h = 0x60;
 		ip6h->flow_lbl[0] = 0;
 		ip6h->flow_lbl[1] = 0;
 		ip6h->flow_lbl[2] = 0;
@@ -456,7 +456,7 @@ void netpoll_send_udp(struct netpoll *np, const char *msg, int len)
 		iph = ip_hdr(skb);
 
 		/* iph->version = 4; iph->ihl = 5; */
-		put_unaligned(0x45, (unsigned char *)iph);
+		*(unsigned char *)iph = 0x45;
 		iph->tos      = 0;
 		put_unaligned(htons(ip_len), &(iph->tot_len));
 		iph->id       = htons(atomic_inc_return(&ip_ident));
-- 
2.29.2

