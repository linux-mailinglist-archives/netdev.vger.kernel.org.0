Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86B7D248316
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 12:34:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbgHRKeN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 06:34:13 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:58352 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726484AbgHRKdb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 06:33:31 -0400
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1597746809;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6VrCUVZFBnS+GcQdyP/GgwULlg3idhvphFA/Ayk6BXY=;
        b=TTIg/w9OeGQ3ndVY4q1cP+l+pBnty3fwqwcBTEyvhK6ognq98Tbd9C3NeAjO7J5WZosRgx
        vZeCDWMAeBJgYY1e4j02Atu2LsaTeEMyTzP56eueDgvuSmCKi7x/bI12wtFEEZqJcRAwkB
        cBqO6Gm2Ll8wMpt3vAsaAbP+0aVRrurUyqBmIWCfbDWBdUk0z6InxiWpDr8U7O+Avws+v7
        fONlhcTEA3nrS0fPdNj1KATJL8XhUvolfsSAMDftKs3/mG3K16n04mcxMqcocC4XFuQbPF
        HMneNqhv6fIVt9/TPqEjt06D/QPLcjZAG/fma8KZDvykGa44JVfxrESKqj5O/g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1597746809;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6VrCUVZFBnS+GcQdyP/GgwULlg3idhvphFA/Ayk6BXY=;
        b=ZDgHNDvzYbkgtniXueC8a2mPrjP3ORXokuYqKKiTxoGomylGrnZsU0/zapVMzA3+HEJizK
        fUWMpgoBC9eHC9DA==
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
        Samuel Zou <zou_wei@huawei.com>, netdev@vger.kernel.org,
        Petr Machata <petrm@mellanox.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH v4 7/9] net: phy: dp83640: Use generic helper function
Date:   Tue, 18 Aug 2020 12:32:49 +0200
Message-Id: <20200818103251.20421-8-kurt@linutronix.de>
In-Reply-To: <20200818103251.20421-1-kurt@linutronix.de>
References: <20200818103251.20421-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to reduce code duplication between ptp drivers, generic helper
functions were introduced. Use them.

Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Tested-by: Richard Cochran <richardcochran@gmail.com>
---
 drivers/net/phy/dp83640.c | 70 +++++++++------------------------------
 1 file changed, 16 insertions(+), 54 deletions(-)

diff --git a/drivers/net/phy/dp83640.c b/drivers/net/phy/dp83640.c
index 50fb7d16b75a..fc3d747eba55 100644
--- a/drivers/net/phy/dp83640.c
+++ b/drivers/net/phy/dp83640.c
@@ -798,51 +798,32 @@ static int decode_evnt(struct dp83640_private *dp83640,
 	return parsed;
 }
 
-#define DP83640_PACKET_HASH_OFFSET	20
 #define DP83640_PACKET_HASH_LEN		10
 
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
 
@@ -982,35 +963,16 @@ static void decode_status_frame(struct dp83640_private *dp83640,
 
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

