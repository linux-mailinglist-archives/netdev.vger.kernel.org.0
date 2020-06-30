Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 147EA20EAA9
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 03:07:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728155AbgF3BGy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 21:06:54 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:60171 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728126AbgF3BGw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jun 2020 21:06:52 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 0907e8c1;
        Tue, 30 Jun 2020 00:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=Xmy6YQJ23F4/CDIjrR9nvLnBL
        T8=; b=E1BIat3KtHtdKTksZkvYg+PDN33dnMfbh0VKPugk3LYYV3tIA0K1PqwQQ
        dvajTKXueWFSyDfmJQfsxJO5md7rI/zKUMxMlgncZow4jsTl2m97zOiVrz4dD9f2
        YSnKsFTyUij4Uo603KgmbVkZg9Pso2n0+P1vhpTdsqjLQ8JCmSi8L2vN2d9pmgvK
        uh5XMqV3UHrtJMt81AsArrB1WxZ5ueVxLZCte/4pCLVjfbY8AFOW67e8rf3t0Jkp
        E3MtLMUfNg42Lo6dC6RrP2h2HLQCuYjLv160KUp0l9opYTJ6fFg8SigarvPBOd3R
        7bltHQBon1n8Dz2MgdbpCzW0NgvcQ==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id d98247d1 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Tue, 30 Jun 2020 00:47:04 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Hans Wippel <ndev@hwipl.net>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: [PATCH net v2 8/8] net: xfrmi: implement header_ops->parse_protocol for AF_PACKET
Date:   Mon, 29 Jun 2020 19:06:25 -0600
Message-Id: <20200630010625.469202-9-Jason@zx2c4.com>
In-Reply-To: <20200630010625.469202-1-Jason@zx2c4.com>
References: <20200630010625.469202-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The xfrm interface uses skb->protocol to determine packet type, and
bails out if it's not set. For AF_PACKET injection, we need to support
its call chain of:

    packet_sendmsg -> packet_snd -> packet_parse_headers ->
      dev_parse_header_protocol -> parse_protocol

Without a valid parse_protocol, this returns zero, and xfrmi rejects the
skb. So, this wires up the ip_tunnel handler for layer 3 packets for
that case.

Reported-by: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 net/xfrm/xfrm_interface.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
index c407ecbc5d46..b615729812e5 100644
--- a/net/xfrm/xfrm_interface.c
+++ b/net/xfrm/xfrm_interface.c
@@ -37,6 +37,7 @@
 #include <net/ip.h>
 #include <net/ipv6.h>
 #include <net/ip6_route.h>
+#include <net/ip_tunnels.h>
 #include <net/addrconf.h>
 #include <net/xfrm.h>
 #include <net/net_namespace.h>
@@ -581,6 +582,7 @@ static const struct net_device_ops xfrmi_netdev_ops = {
 static void xfrmi_dev_setup(struct net_device *dev)
 {
 	dev->netdev_ops 	= &xfrmi_netdev_ops;
+	dev->header_ops		= &ip_tunnel_header_ops;
 	dev->type		= ARPHRD_NONE;
 	dev->mtu		= ETH_DATA_LEN;
 	dev->min_mtu		= ETH_MIN_MTU;
-- 
2.27.0

