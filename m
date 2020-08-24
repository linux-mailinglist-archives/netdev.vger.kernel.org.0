Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 384F9250261
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 18:31:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727979AbgHXQbi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 12:31:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728213AbgHXQar (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 12:30:47 -0400
Received: from simonwunderlich.de (packetmixer.de [IPv6:2001:4d88:2000:24::c0de])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A3ACC061574
        for <netdev@vger.kernel.org>; Mon, 24 Aug 2020 09:30:47 -0700 (PDT)
Received: from kero.packetmixer.de (p200300c5970d68d0e0160e8a82c5fd76.dip0.t-ipconnect.de [IPv6:2003:c5:970d:68d0:e016:e8a:82c5:fd76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by simonwunderlich.de (Postfix) with ESMTPSA id 92AA76205E;
        Mon, 24 Aug 2020 18:21:14 +0200 (CEST)
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        Sven Eckelmann <sven@narfation.org>,
        syzbot+ab16e463b903f5a37036@syzkaller.appspotmail.com,
        Antonio Quartulli <a@unstable.cc>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 1/3] batman-adv: Avoid uninitialized chaddr when handling DHCP
Date:   Mon, 24 Aug 2020 18:21:09 +0200
Message-Id: <20200824162111.29220-2-sw@simonwunderlich.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200824162111.29220-1-sw@simonwunderlich.de>
References: <20200824162111.29220-1-sw@simonwunderlich.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Eckelmann <sven@narfation.org>

The gateway client code can try to optimize the delivery of DHCP packets to
avoid broadcasting them through the whole mesh. But also transmissions to
the client can be optimized by looking up the destination via the chaddr of
the DHCP packet.

But the chaddr is currently only done when chaddr is fully inside the
non-paged area of the skbuff. Otherwise it will not be initialized and the
unoptimized path should have been taken.

But the implementation didn't handle this correctly. It didn't retrieve the
correct chaddr but still tried to perform the TT lookup with this
uninitialized memory.

Reported-by: syzbot+ab16e463b903f5a37036@syzkaller.appspotmail.com
Fixes: 6c413b1c22a2 ("batman-adv: send every DHCP packet as bat-unicast")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Acked-by: Antonio Quartulli <a@unstable.cc>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 net/batman-adv/gateway_client.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/batman-adv/gateway_client.c b/net/batman-adv/gateway_client.c
index a18dcc686dc3..ef3f85b576c4 100644
--- a/net/batman-adv/gateway_client.c
+++ b/net/batman-adv/gateway_client.c
@@ -703,8 +703,10 @@ batadv_gw_dhcp_recipient_get(struct sk_buff *skb, unsigned int *header_len,
 
 	chaddr_offset = *header_len + BATADV_DHCP_CHADDR_OFFSET;
 	/* store the client address if the message is going to a client */
-	if (ret == BATADV_DHCP_TO_CLIENT &&
-	    pskb_may_pull(skb, chaddr_offset + ETH_ALEN)) {
+	if (ret == BATADV_DHCP_TO_CLIENT) {
+		if (!pskb_may_pull(skb, chaddr_offset + ETH_ALEN))
+			return BATADV_DHCP_NO;
+
 		/* check if the DHCP packet carries an Ethernet DHCP */
 		p = skb->data + *header_len + BATADV_DHCP_HTYPE_OFFSET;
 		if (*p != BATADV_DHCP_HTYPE_ETHERNET)
-- 
2.20.1

