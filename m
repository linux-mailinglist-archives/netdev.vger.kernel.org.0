Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48A4D3DC243
	for <lists+netdev@lfdr.de>; Sat, 31 Jul 2021 03:17:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234326AbhGaBRw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 21:17:52 -0400
Received: from novek.ru ([213.148.174.62]:60132 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231337AbhGaBRw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Jul 2021 21:17:52 -0400
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 460B1503930;
        Sat, 31 Jul 2021 04:15:11 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 460B1503930
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1627694112; bh=rZ9CPTlAMUrYr5SqX2IEA+Ttry54YSLImCdL1jglF18=;
        h=From:To:Cc:Subject:Date:From;
        b=H753jvUvQra+DwA3B5nJl9Z7kHNiHjyKk8Jm9TEY1UcXopKzbKmOAnATIzB2/msXh
         z7PzHkCUaBmEPp6PmFWIAPzfK2T43OobHU5SzcbgsHhRBuyTjS80U4jLFMLqlpVG+L
         noudChuRQTEJ2z3V6/P0b2qFLYGBX53Ewid4Eykg=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     David Ahern <dsahern@kernel.org>
Cc:     Willem de Bruijn <willemb@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Vadim Fedorenko <vfedorenko@novek.ru>
Subject: [PATCH net] net: ipv4: fix path MTU for multi path routes
Date:   Sat, 31 Jul 2021 04:17:29 +0300
Message-Id: <20210731011729.4357-1-vfedorenko@novek.ru>
X-Mailer: git-send-email 2.18.4
X-Spam-Status: No, score=0.0 required=5.0 tests=UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.1
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bug 213729 showed that MTU check could be used against route that
will not be used in actual transmit if source ip is not specified.
But path MTU update is always done on route with defined source ip.
Fix route selection by updating flow info in case when source ip
is not explicitly defined in raw and udp sockets.

Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
---
 net/ipv4/raw.c | 11 +++++++++++
 net/ipv4/udp.c | 13 +++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index bb446e60cf58..e4008416dfc1 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -640,6 +640,17 @@ static int raw_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 			goto done;
 	}
 
+	if (!saddr) {
+		rt = __ip_route_output_key(net, &fl4);
+		if (IS_ERR(rt)) {
+			err = PTR_ERR(rt);
+			rt = NULL;
+			goto done;
+		}
+		ip_rt_put(rt);
+		flowi4_update_output(&fl4, ipc.oif, tos, fl4.daddr, fl4.saddr);
+	}
+
 	security_sk_classify_flow(sk, flowi4_to_flowi_common(&fl4));
 	rt = ip_route_output_flow(net, &fl4, sk);
 	if (IS_ERR(rt)) {
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 1a742b710e54..c6db5c3aa294 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1215,6 +1215,19 @@ int udp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 				   faddr, saddr, dport, inet->inet_sport,
 				   sk->sk_uid);
 
+		if (!saddr) {
+			rt = __ip_route_output_key(net, fl4);
+			if (IS_ERR(rt)) {
+				err = PTR_ERR(rt);
+				rt = NULL;
+				if (err == -ENETUNREACH)
+					IP_INC_STATS(net, IPSTATS_MIB_OUTNOROUTES);
+				goto out;
+			}
+			ip_rt_put(rt);
+			flowi4_update_output(fl4, ipc.oif, tos, fl4->daddr, fl4->saddr);
+		}
+
 		security_sk_classify_flow(sk, flowi4_to_flowi_common(fl4));
 		rt = ip_route_output_flow(net, fl4, sk);
 		if (IS_ERR(rt)) {
-- 
2.18.4

