Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9869F13AC35
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 15:24:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728982AbgANOYC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 09:24:02 -0500
Received: from simonwunderlich.de ([79.140.42.25]:49824 "EHLO
        simonwunderlich.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728874AbgANOX4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 09:23:56 -0500
Received: from kero.packetmixer.de (p200300C5970F1B0095082C17D9AE8553.dip0.t-ipconnect.de [IPv6:2003:c5:970f:1b00:9508:2c17:d9ae:8553])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by simonwunderlich.de (Postfix) with ESMTPSA id 24B9F62070;
        Tue, 14 Jan 2020 15:23:54 +0100 (CET)
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 5/7] batman-adv: Annotate bitwise integer pointer casts
Date:   Tue, 14 Jan 2020 15:23:49 +0100
Message-Id: <20200114142351.26622-6-sw@simonwunderlich.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200114142351.26622-1-sw@simonwunderlich.de>
References: <20200114142351.26622-1-sw@simonwunderlich.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Eckelmann <sven@narfation.org>

The sparse commit 6002ded74587 ("add a flag to warn on casts to/from
bitwise pointers") introduced a check for non-direct casts from/to
restricted datatypes (when -Wbitwise-pointer is enabled).

This triggered various warnings in batman-adv when some (already big
endian) buffer content was casted to/from the corresponding big endian
integer data types. But these were correct and can therefore be marked with
__force to signalize sparse an intended cast from/to a bitwise type.

Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 net/batman-adv/bridge_loop_avoidance.c | 2 +-
 net/batman-adv/distributed-arp-table.c | 8 +++++---
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/batman-adv/bridge_loop_avoidance.c b/net/batman-adv/bridge_loop_avoidance.c
index 663a53b6d36e..0eff33580f95 100644
--- a/net/batman-adv/bridge_loop_avoidance.c
+++ b/net/batman-adv/bridge_loop_avoidance.c
@@ -844,7 +844,7 @@ static bool batadv_handle_announce(struct batadv_priv *bat_priv, u8 *an_addr,
 
 	/* handle as ANNOUNCE frame */
 	backbone_gw->lasttime = jiffies;
-	crc = ntohs(*((__be16 *)(&an_addr[4])));
+	crc = ntohs(*((__force __be16 *)(&an_addr[4])));
 
 	batadv_dbg(BATADV_DBG_BLA, bat_priv,
 		   "%s(): ANNOUNCE vid %d (sent by %pM)... CRC = %#.4x\n",
diff --git a/net/batman-adv/distributed-arp-table.c b/net/batman-adv/distributed-arp-table.c
index b0af3a11d406..5004e38fe792 100644
--- a/net/batman-adv/distributed-arp-table.c
+++ b/net/batman-adv/distributed-arp-table.c
@@ -246,7 +246,7 @@ static u8 *batadv_arp_hw_src(struct sk_buff *skb, int hdr_size)
  */
 static __be32 batadv_arp_ip_src(struct sk_buff *skb, int hdr_size)
 {
-	return *(__be32 *)(batadv_arp_hw_src(skb, hdr_size) + ETH_ALEN);
+	return *(__force __be32 *)(batadv_arp_hw_src(skb, hdr_size) + ETH_ALEN);
 }
 
 /**
@@ -270,7 +270,9 @@ static u8 *batadv_arp_hw_dst(struct sk_buff *skb, int hdr_size)
  */
 static __be32 batadv_arp_ip_dst(struct sk_buff *skb, int hdr_size)
 {
-	return *(__be32 *)(batadv_arp_hw_src(skb, hdr_size) + ETH_ALEN * 2 + 4);
+	u8 *dst = batadv_arp_hw_src(skb, hdr_size) + ETH_ALEN * 2 + 4;
+
+	return *(__force __be32 *)dst;
 }
 
 /**
@@ -287,7 +289,7 @@ static u32 batadv_hash_dat(const void *data, u32 size)
 	const unsigned char *key;
 	u32 i;
 
-	key = (const unsigned char *)&dat->ip;
+	key = (__force const unsigned char *)&dat->ip;
 	for (i = 0; i < sizeof(dat->ip); i++) {
 		hash += key[i];
 		hash += (hash << 10);
-- 
2.20.1

