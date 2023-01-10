Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57A7F664C9D
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 20:37:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232187AbjAJThZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 14:37:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232392AbjAJThR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 14:37:17 -0500
Received: from netgeek.ovh (ks.netgeek.ovh [37.187.103.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14C7359523;
        Tue, 10 Jan 2023 11:37:10 -0800 (PST)
Received: from quaddy.sgn (unknown [IPv6:2a01:cb19:83f8:d500:21d:60ff:fedb:90ab])
        by ks.netgeek.ovh (Postfix) with ESMTPSA id 5858D47E3;
        Tue, 10 Jan 2023 20:20:29 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=netgeek.ovh;
        s=default; t=1673378429;
        bh=FvQE1db+ky2tN/uATevM6yCtd/HD9qxAeZruPo6gE9M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=WaTFuEJyW+bHOPccg5rvAUaxT4laXvcnwFddiKIIB/C7VeOWun9CIQO9OFZ+SpWRT
         WcCfJlUQKzW/p9i0YuphdNcLAX/yxQI3Q6YQXBA14WGmqM6PlbDmTNmLUyUUk8pwE9
         elfZK4TCN0EOp299rp+zBQeLYsiSsAJWlBOUVUmAsvJV2SkjtsiwiqjWFK1RXoAOSb
         HRJi4hhGFAXU2SADszRSDJSw1HxkR09GyOPd9oLMbQDpBsVnp26fLdQW07CTeU9cDq
         Pk6BSxOGN51ecQGn46IsamItiR1GcuUWKVAQr8M+s15IinavfC1eCJW/kXbON7g3S+
         3s2n26edXkmWQ==
From:   =?UTF-8?q?Herv=C3=A9=20Boisse?= <admin@netgeek.ovh>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Herv=C3=A9=20Boisse?= <admin@netgeek.ovh>
Subject: [PATCH net 2/2] net/af_packet: fix tx skb network header on SOCK_RAW sockets over VLAN device
Date:   Tue, 10 Jan 2023 20:17:25 +0100
Message-Id: <20230110191725.22675-2-admin@netgeek.ovh>
X-Mailer: git-send-email 2.38.2
In-Reply-To: <20230110191725.22675-1-admin@netgeek.ovh>
References: <20230110191725.22675-1-admin@netgeek.ovh>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When an application sends a packet on a SOCK_RAW socket over a VLAN device,
there is a possibility that the skb network header is incorrectly set.

The issue happens when the device used to send the packet is a VLAN device
whose underlying device has no VLAN tx hardware offloading support.
In that case, the VLAN driver reports a LL header size increased by 4 bytes
to take into account the tag that will be added in software.

However, the socket user has no clue about that and still provides a normal
LL header without tag.
This results in the network header of the skb being shifted 4 bytes too far
in the packet. This shift makes tc classifiers fail as they point to
incorrect data.

Move network header right after underlying VLAN device LL header size
without tag, regardless of hardware offloading support. That is, the
expected LL header size from socket user.

Signed-off-by: Hervé Boisse <admin@netgeek.ovh>
---
 net/packet/af_packet.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index c18274f65b17..be892fd498a6 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -1933,6 +1933,18 @@ static void packet_parse_headers(struct sk_buff *skb, struct socket *sock)
 		skb->protocol = dev_parse_header_protocol(skb);
 	}
 
+	/* VLAN device may report bigger LL header size due to reserved room for
+	 * tag on devices without hardware offloading support
+	 */
+	if (is_vlan_dev(skb->dev) &&
+	    (sock->type == SOCK_RAW || sock->type == SOCK_PACKET)) {
+		struct net_device *real_dev = vlan_dev_real_dev(skb->dev);
+
+		depth = real_dev->hard_header_len;
+		if (pskb_may_pull(skb, depth))
+			skb_set_network_header(skb, depth);
+	}
+
 	/* Move network header to the right position for VLAN tagged packets */
 	if (likely(skb->dev->type == ARPHRD_ETHER) &&
 	    eth_type_vlan(skb->protocol) &&
-- 
2.38.2

