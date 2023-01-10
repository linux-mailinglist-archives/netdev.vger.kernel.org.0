Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0678C664C9C
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 20:37:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231879AbjAJThX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 14:37:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232398AbjAJThR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 14:37:17 -0500
X-Greylist: delayed 601 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 10 Jan 2023 11:37:10 PST
Received: from netgeek.ovh (ks.netgeek.ovh [37.187.103.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9111F59522;
        Tue, 10 Jan 2023 11:37:10 -0800 (PST)
Received: from quaddy.sgn (unknown [IPv6:2a01:cb19:83f8:d500:21d:60ff:fedb:90ab])
        by ks.netgeek.ovh (Postfix) with ESMTPSA id 5A6F7282;
        Tue, 10 Jan 2023 20:20:20 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=netgeek.ovh;
        s=default; t=1673378420;
        bh=Nsili5B2oH3H+XD0KDMN6VzmJ6TVJTAgZN/YbIOyWKo=;
        h=From:To:Cc:Subject:Date;
        b=YAluGyVzARTxLTuRR+zM0F9yN03yYiQJ2GA0nKreSoTayHZx+WEALTHsQjKQtBykH
         eBg9H+m4ncCPd3qWREUuusCZANVU5wexI9hU8ZfdZ25t07exKyUijzhnaTBH9XTUy8
         wPVMIIlSKIdqnVHD5omPgiBBryRuGJPDX+frA10Ke8CEu8Xr+3SDx3XMzgnAxMdqS4
         /etKv8UaEOW7GzAIY3h7WgwBaIVJNQDTTu4AGJSitqOmtnOCOjfEBdCIekxTPrQ29S
         5JeEUu/uBkDFPivKq3KhXamL9VA98skCFOD4hVk5qFIGOyvXmvaxgU8lcNuk243wcv
         g5aHBI/IHUEEg==
From:   =?UTF-8?q?Herv=C3=A9=20Boisse?= <admin@netgeek.ovh>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Herv=C3=A9=20Boisse?= <admin@netgeek.ovh>
Subject: [PATCH net 1/2] net/af_packet: fix tx skb protocol on SOCK_PACKET sockets
Date:   Tue, 10 Jan 2023 20:17:24 +0100
Message-Id: <20230110191725.22675-1-admin@netgeek.ovh>
X-Mailer: git-send-email 2.38.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.7 required=5.0 tests=BAYES_05,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 75c65772c3d1 ("net/packet: Ask driver for protocol if not provided
by user") introduces packet_parse_headers() to extract protocol for
SOCK_RAW sockets.
But, SOCK_PACKET sockets which provide similar behaviour are not considered
so far and packets sent by those sockets will have their protocol unset.

Extract the skb protocol value from the packet for SOCK_PACKET sockets, as
currently done for SOCK_RAW sockets.

Fixes: 75c65772c3d1 ("net/packet: Ask driver for protocol if not provided by user")
Signed-off-by: Hervé Boisse <admin@netgeek.ovh>
---
 net/packet/af_packet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index b5ab98ca2511..c18274f65b17 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -1928,7 +1928,7 @@ static void packet_parse_headers(struct sk_buff *skb, struct socket *sock)
 	int depth;
 
 	if ((!skb->protocol || skb->protocol == htons(ETH_P_ALL)) &&
-	    sock->type == SOCK_RAW) {
+	    (sock->type == SOCK_RAW || sock->type == SOCK_PACKET)) {
 		skb_reset_mac_header(skb);
 		skb->protocol = dev_parse_header_protocol(skb);
 	}
-- 
2.38.2

