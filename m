Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13D481BE968
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 22:59:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727785AbgD2U7k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 16:59:40 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:36243 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726852AbgD2U7h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Apr 2020 16:59:37 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id ac728bec;
        Wed, 29 Apr 2020 20:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-type:content-transfer-encoding; s=mail; bh=rjkHXMSR1MAw
        pig9vaE6l7lmDqc=; b=fn0a2M+PVPXz24zyWAawllxpMHsd5bfcUnkkoj/S9lWp
        +RHo98nb0NRNARGf5rP9hb0wpMc/h3Fw4jiOgFwf/NO7eSw27U9nePRZOrBky0c/
        hjrQdF8HSkFOL0npVKrj9g1r3JUOZHA6/2fAHCMpOYMYkgDY3SBIetvhzrmVz6AK
        oHIlak1Dz8zAJWrDk7VcTLrN5sLZEy07gibk4ypJDrlRPZtgn+hzSZXNHguKoyFU
        KFLPW/xIF+7uMhWy95jLR6uu4/ibbIYaBlc1ka/wEFhXDYU7wv5uiz7KVkbhH8Zk
        pIXPnscnq+G7S1sO7xEuUIGVrakiUoPvr4y3EyaLMg==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id d2a627ff (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Wed, 29 Apr 2020 20:47:45 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Olivier Tilmans <olivier.tilmans@nokia-bell-labs.com>,
        Dave Taht <dave.taht@gmail.com>,
        "Rodney W . Grimes" <ietf@gndrsh.dnsmgr.net>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net 3/3] wireguard: receive: use tunnel helpers for decapsulating ECN markings
Date:   Wed, 29 Apr 2020 14:59:22 -0600
Message-Id: <20200429205922.295361-4-Jason@zx2c4.com>
In-Reply-To: <20200429205922.295361-1-Jason@zx2c4.com>
References: <20200429205922.295361-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

WireGuard currently only propagates ECN markings on tunnel decap according
to the old RFC3168 specification. However, the spec has since been updated
in RFC6040 to recommend slightly different decapsulation semantics. This
was implemented in the kernel as a set of common helpers for ECN
decapsulation, so let's just switch over WireGuard to using those, so it
can benefit from this enhancement and any future tweaks. We do not drop
packets with invalid ECN marking combinations, because WireGuard is
frequently used to work around broken ISPs, which could be doing that.

Fixes: e7096c131e51 ("net: WireGuard secure network tunnel")
Reported-by: Olivier Tilmans <olivier.tilmans@nokia-bell-labs.com>
Cc: Dave Taht <dave.taht@gmail.com>
Cc: Rodney W. Grimes <ietf@gndrsh.dnsmgr.net>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/net/wireguard/receive.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireguard/receive.c b/drivers/net/wireguard/receive.c
index da3b782ab7d3..267f202f1931 100644
--- a/drivers/net/wireguard/receive.c
+++ b/drivers/net/wireguard/receive.c
@@ -393,13 +393,11 @@ static void wg_packet_consume_data_done(struct wg_peer *peer,
 		len = ntohs(ip_hdr(skb)->tot_len);
 		if (unlikely(len < sizeof(struct iphdr)))
 			goto dishonest_packet_size;
-		if (INET_ECN_is_ce(PACKET_CB(skb)->ds))
-			IP_ECN_set_ce(ip_hdr(skb));
+		INET_ECN_decapsulate(skb, PACKET_CB(skb)->ds, ip_hdr(skb)->tos);
 	} else if (skb->protocol == htons(ETH_P_IPV6)) {
 		len = ntohs(ipv6_hdr(skb)->payload_len) +
 		      sizeof(struct ipv6hdr);
-		if (INET_ECN_is_ce(PACKET_CB(skb)->ds))
-			IP6_ECN_set_ce(skb, ipv6_hdr(skb));
+		INET_ECN_decapsulate(skb, PACKET_CB(skb)->ds, ipv6_get_dsfield(ipv6_hdr(skb)));
 	} else {
 		goto dishonest_packet_type;
 	}
-- 
2.26.2

