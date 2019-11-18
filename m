Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 327E8100E5E
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 22:51:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727498AbfKRVuL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 16:50:11 -0500
Received: from correo.us.es ([193.147.175.20]:45714 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727047AbfKRVtc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Nov 2019 16:49:32 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2D2A6EB493
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 22:49:28 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1E9FFDA4D0
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 22:49:28 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 1431DDA8E8; Mon, 18 Nov 2019 22:49:28 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 45287DA72F;
        Mon, 18 Nov 2019 22:49:23 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 18 Nov 2019 22:49:23 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 16CBC42EE38F;
        Mon, 18 Nov 2019 22:49:23 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 03/18] netfilter: nft_payload: simplify vlan header handling
Date:   Mon, 18 Nov 2019 22:48:59 +0100
Message-Id: <20191118214914.142794-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191118214914.142794-1-pablo@netfilter.org>
References: <20191118214914.142794-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the offset is within the ethernet + vlan header size boundary, then
rebuild the ethernet + vlan header and use it to copy the bytes to the
register. Otherwise, subtract the vlan header size from the offset and
fall back to use skb_copy_bits().

There is one corner case though: If the offset plus the length of the
payload instruction goes over the ethernet + vlan header boundary, then,
fetch as many bytes as possible from the rebuilt ethernet + vlan header
and fall back to copy the remaining bytes through skb_copy_bits().

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Acked-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_payload.c | 28 +++++++++-------------------
 1 file changed, 9 insertions(+), 19 deletions(-)

diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index 5cb2d8908d2a..247799801165 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -28,17 +28,22 @@ static bool
 nft_payload_copy_vlan(u32 *d, const struct sk_buff *skb, u8 offset, u8 len)
 {
 	int mac_off = skb_mac_header(skb) - skb->data;
-	u8 vlan_len, *vlanh, *dst_u8 = (u8 *) d;
+	u8 *vlanh, *dst_u8 = (u8 *) d;
 	struct vlan_ethhdr veth;
 
 	vlanh = (u8 *) &veth;
-	if (offset < ETH_HLEN) {
-		u8 ethlen = min_t(u8, len, ETH_HLEN - offset);
+	if (offset < VLAN_ETH_HLEN) {
+		u8 ethlen = len;
 
 		if (skb_copy_bits(skb, mac_off, &veth, ETH_HLEN))
 			return false;
 
 		veth.h_vlan_proto = skb->vlan_proto;
+		veth.h_vlan_TCI = htons(skb_vlan_tag_get(skb));
+		veth.h_vlan_encapsulated_proto = skb->protocol;
+
+		if (offset + len > VLAN_ETH_HLEN)
+			ethlen -= offset + len - VLAN_ETH_HLEN;
 
 		memcpy(dst_u8, vlanh + offset, ethlen);
 
@@ -48,25 +53,10 @@ nft_payload_copy_vlan(u32 *d, const struct sk_buff *skb, u8 offset, u8 len)
 
 		dst_u8 += ethlen;
 		offset = ETH_HLEN;
-	} else if (offset >= VLAN_ETH_HLEN) {
+	} else {
 		offset -= VLAN_HLEN;
-		goto skip;
 	}
 
-	veth.h_vlan_TCI = htons(skb_vlan_tag_get(skb));
-	veth.h_vlan_encapsulated_proto = skb->protocol;
-
-	vlanh += offset;
-
-	vlan_len = min_t(u8, len, VLAN_ETH_HLEN - offset);
-	memcpy(dst_u8, vlanh, vlan_len);
-
-	len -= vlan_len;
-	if (!len)
-		return true;
-
-	dst_u8 += vlan_len;
- skip:
 	return skb_copy_bits(skb, offset + mac_off, dst_u8, len) == 0;
 }
 
-- 
2.11.0

