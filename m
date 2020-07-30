Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECE4B232CC8
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 10:01:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729002AbgG3IBG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 04:01:06 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:48628 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728865AbgG3IA7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 04:00:59 -0400
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1596096057;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3KVqULQgDBBQavit3YP1GIzDOmOOSvIFIOOkmVMmyvY=;
        b=oXQmIQM3J6eo4ywCCZF8Wngo6ITAY9qYM2FRAEVaMA4RV46ZukAhXhuUVeLkzmbKG3zdGJ
        ffW4+Vm+9fsYIT6RvJrC1yW1B4w2INhtGu5at4GwKzuuKO61Wi5a5SIoy+T7vjmWkkWhLI
        rHxoCSe3rbxgoUI49KsPoJHdxQH5HBNSH78J/gD0152080wPuC5DuE5FyBhkdEgjUrTpJv
        E8Dc3muDBQeeehZrECgPtpsHlGzM7bXoWQrHEub35WMhOhLQzqpHK1XmSAtbSbY/g4PlzX
        bDsNDMxLYDYGSQSNosNW5zDDz5RaNOvp4CaaxVnhBOmtXQB2aL6rAv6hqZkg3A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1596096057;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3KVqULQgDBBQavit3YP1GIzDOmOOSvIFIOOkmVMmyvY=;
        b=CJmpOGGqfhXkQdxrpSImIsjUXV/gaX2FfRC0X55e5azuiGORDAP6Fz/6SZ8UTz21OxP1XP
        /EXdo9tk+wpK5aBA==
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Samuel Zou <zou_wei@huawei.com>, netdev@vger.kernel.org,
        Petr Machata <petrm@mellanox.com>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH v3 7/9] net: phy: dp83640: Use generic helper function
Date:   Thu, 30 Jul 2020 10:00:46 +0200
Message-Id: <20200730080048.32553-8-kurt@linutronix.de>
In-Reply-To: <20200730080048.32553-1-kurt@linutronix.de>
References: <20200730080048.32553-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to reduce code duplication between ptp drivers, generic helper
functions were introduced. Use them.

Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
---
 drivers/net/phy/dp83640.c | 69 +++++++++------------------------------
 1 file changed, 16 insertions(+), 53 deletions(-)

diff --git a/drivers/net/phy/dp83640.c b/drivers/net/phy/dp83640.c
index 50fb7d16b75a..1cd987e3d0f2 100644
--- a/drivers/net/phy/dp83640.c
+++ b/drivers/net/phy/dp83640.c
@@ -803,46 +803,28 @@ static int decode_evnt(struct dp83640_private *dp83640,
 
 static int match(struct sk_buff *skb, unsigned int type, struct rxts *rxts)
 {
-	unsigned int offset = 0;
-	u8 *msgtype, *data = skb_mac_header(skb);
-	__be16 *seqid;
+	struct ptp_header *hdr;
+	u8 msgtype;
+	u16 seqid;
 	u16 hash;
 
 	/* check sequenceID, messageType, 12 bit hash of offset 20-29 */
 
-	if (type & PTP_CLASS_VLAN)
-		offset += VLAN_HLEN;
-
-	switch (type & PTP_CLASS_PMASK) {
-	case PTP_CLASS_IPV4:
-		offset += ETH_HLEN + IPV4_HLEN(data + offset) + UDP_HLEN;
-		break;
-	case PTP_CLASS_IPV6:
-		offset += ETH_HLEN + IP6_HLEN + UDP_HLEN;
-		break;
-	case PTP_CLASS_L2:
-		offset += ETH_HLEN;
-		break;
-	default:
+	hdr = ptp_parse_header(skb, type);
+	if (!hdr)
 		return 0;
-	}
 
-	if (skb->len + ETH_HLEN < offset + OFF_PTP_SEQUENCE_ID + sizeof(*seqid))
-		return 0;
+	msgtype = ptp_get_msgtype(hdr, type);
 
-	if (unlikely(type & PTP_CLASS_V1))
-		msgtype = data + offset + OFF_PTP_CONTROL;
-	else
-		msgtype = data + offset;
-	if (rxts->msgtype != (*msgtype & 0xf))
+	if (rxts->msgtype != (msgtype & 0xf))
 		return 0;
 
-	seqid = (__be16 *)(data + offset + OFF_PTP_SEQUENCE_ID);
-	if (rxts->seqid != ntohs(*seqid))
+	seqid = be16_to_cpu(hdr->sequence_id);
+	if (rxts->seqid != seqid)
 		return 0;
 
 	hash = ether_crc(DP83640_PACKET_HASH_LEN,
-			 data + offset + DP83640_PACKET_HASH_OFFSET) >> 20;
+			 (unsigned char *)&hdr->source_port_identity) >> 20;
 	if (rxts->hash != hash)
 		return 0;
 
@@ -982,35 +964,16 @@ static void decode_status_frame(struct dp83640_private *dp83640,
 
 static int is_sync(struct sk_buff *skb, int type)
 {
-	u8 *data = skb->data, *msgtype;
-	unsigned int offset = 0;
-
-	if (type & PTP_CLASS_VLAN)
-		offset += VLAN_HLEN;
-
-	switch (type & PTP_CLASS_PMASK) {
-	case PTP_CLASS_IPV4:
-		offset += ETH_HLEN + IPV4_HLEN(data + offset) + UDP_HLEN;
-		break;
-	case PTP_CLASS_IPV6:
-		offset += ETH_HLEN + IP6_HLEN + UDP_HLEN;
-		break;
-	case PTP_CLASS_L2:
-		offset += ETH_HLEN;
-		break;
-	default:
-		return 0;
-	}
-
-	if (type & PTP_CLASS_V1)
-		offset += OFF_PTP_CONTROL;
+	struct ptp_header *hdr;
+	u8 msgtype;
 
-	if (skb->len < offset + 1)
+	hdr = ptp_parse_header(skb, type);
+	if (!hdr)
 		return 0;
 
-	msgtype = data + offset;
+	msgtype = ptp_get_msgtype(hdr, type);
 
-	return (*msgtype & 0xf) == 0;
+	return (msgtype & 0xf) == 0;
 }
 
 static void dp83640_free_clocks(void)
-- 
2.20.1

