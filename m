Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8897A22AA06
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 09:50:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727880AbgGWHup (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 03:50:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726141AbgGWHuo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 03:50:44 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8853EC0619DC
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 00:50:43 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1595490642;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qUBI66bku2+5vZdpN29f/DZLGmoGDBmOTMiZiAMO6us=;
        b=S1whAMFNpXWtEA9G1YrjygqLx+o2h4toDKir9/h8n9dZXNjkiuE8CzaPK6kMysV2CK04Xa
        UmFVlfBZ21ya14C2MYPBhWQixq1I88LFW/F04q708r5tFGy6NZbFrsW0f008uvaV32s0jG
        nG5VK1D4aMDz2Eg+VW6v0fpSV1sobHBBxiy1GHHqphOl1RhHUNys/Owodw/ABv+jQo1IfX
        vfXqzsDjIlUePoYMoxKaULLZsDkvTP+BMYtEvtnU/q3IQw0CTGAFcEVbPLbMBdY6jqQAad
        1f7a7Dlo1/Ns22q/3eNQJq8JXOp8GqkXSRZP8Tjr1RJSM8wevTT3yojfqNjN+w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1595490642;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qUBI66bku2+5vZdpN29f/DZLGmoGDBmOTMiZiAMO6us=;
        b=vlOYXwwH73JuLlrcUI0ETpewAKPOGPXvH/JZTMt3Iqf1+5fMBCWtFm4w/r3vy5GQZi3tux
        PQnBbGlwK2WM1aBw==
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH v1 2/2] net: dsa: mv88e6xxx: Use generic ptp header parsing function
Date:   Thu, 23 Jul 2020 09:49:46 +0200
Message-Id: <20200723074946.14253-3-kurt@linutronix.de>
In-Reply-To: <20200723074946.14253-1-kurt@linutronix.de>
References: <20200723074946.14253-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

That function is now available within ptp classify. So use it.

Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
---
 drivers/net/dsa/mv88e6xxx/Kconfig    |  1 +
 drivers/net/dsa/mv88e6xxx/hwtstamp.c | 59 ++++++----------------------
 2 files changed, 14 insertions(+), 46 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/Kconfig b/drivers/net/dsa/mv88e6xxx/Kconfig
index 51185e4d7d15..349621fe71cf 100644
--- a/drivers/net/dsa/mv88e6xxx/Kconfig
+++ b/drivers/net/dsa/mv88e6xxx/Kconfig
@@ -26,6 +26,7 @@ config NET_DSA_MV88E6XXX_PTP
 	depends on NET_DSA_MV88E6XXX_GLOBAL2
 	depends on PTP_1588_CLOCK
 	imply NETWORK_PHY_TIMESTAMPING
+	select NET_PTP_CLASSIFY
 	help
 	  Say Y to enable PTP hardware timestamping on Marvell 88E6xxx switch
 	  chips that support it.
diff --git a/drivers/net/dsa/mv88e6xxx/hwtstamp.c b/drivers/net/dsa/mv88e6xxx/hwtstamp.c
index a4c488b12e8f..094d17a1d037 100644
--- a/drivers/net/dsa/mv88e6xxx/hwtstamp.c
+++ b/drivers/net/dsa/mv88e6xxx/hwtstamp.c
@@ -211,49 +211,20 @@ int mv88e6xxx_port_hwtstamp_get(struct dsa_switch *ds, int port,
 		-EFAULT : 0;
 }
 
-/* Get the start of the PTP header in this skb */
-static u8 *parse_ptp_header(struct sk_buff *skb, unsigned int type)
-{
-	u8 *data = skb_mac_header(skb);
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
-		return NULL;
-	}
-
-	/* Ensure that the entire header is present in this packet. */
-	if (skb->len + ETH_HLEN < offset + 34)
-		return NULL;
-
-	return data + offset;
-}
-
 /* Returns a pointer to the PTP header if the caller should time stamp,
  * or NULL if the caller should not.
  */
-static u8 *mv88e6xxx_should_tstamp(struct mv88e6xxx_chip *chip, int port,
-				   struct sk_buff *skb, unsigned int type)
+static struct ptp_header *mv88e6xxx_should_tstamp(struct mv88e6xxx_chip *chip,
+						  int port, struct sk_buff *skb,
+						  unsigned int type)
 {
 	struct mv88e6xxx_port_hwtstamp *ps = &chip->port_hwtstamp[port];
-	u8 *hdr;
+	struct ptp_header *hdr;
 
 	if (!chip->info->ptp_support)
 		return NULL;
 
-	hdr = parse_ptp_header(skb, type);
+	hdr = ptp_parse_header(skb, type);
 	if (!hdr)
 		return NULL;
 
@@ -275,12 +246,11 @@ static int mv88e6xxx_ts_valid(u16 status)
 static int seq_match(struct sk_buff *skb, u16 ts_seqid)
 {
 	unsigned int type = SKB_PTP_TYPE(skb);
-	u8 *hdr = parse_ptp_header(skb, type);
-	__be16 *seqid;
+	struct ptp_header *hdr;
 
-	seqid = (__be16 *)(hdr + OFF_PTP_SEQUENCE_ID);
+	hdr = ptp_parse_header(skb, type);
 
-	return ts_seqid == ntohs(*seqid);
+	return ts_seqid == ntohs(hdr->sequence_id);
 }
 
 static void mv88e6xxx_get_rxts(struct mv88e6xxx_chip *chip,
@@ -357,9 +327,9 @@ static void mv88e6xxx_rxtstamp_work(struct mv88e6xxx_chip *chip,
 				   &ps->rx_queue2);
 }
 
-static int is_pdelay_resp(u8 *msgtype)
+static int is_pdelay_resp(const struct ptp_header *hdr)
 {
-	return (*msgtype & 0xf) == 3;
+	return (hdr->tsmt & 0xf) == 3;
 }
 
 bool mv88e6xxx_port_rxtstamp(struct dsa_switch *ds, int port,
@@ -367,7 +337,7 @@ bool mv88e6xxx_port_rxtstamp(struct dsa_switch *ds, int port,
 {
 	struct mv88e6xxx_port_hwtstamp *ps;
 	struct mv88e6xxx_chip *chip;
-	u8 *hdr;
+	struct ptp_header *hdr;
 
 	chip = ds->priv;
 	ps = &chip->port_hwtstamp[port];
@@ -503,8 +473,7 @@ bool mv88e6xxx_port_txtstamp(struct dsa_switch *ds, int port,
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 	struct mv88e6xxx_port_hwtstamp *ps = &chip->port_hwtstamp[port];
-	__be16 *seq_ptr;
-	u8 *hdr;
+	struct ptp_header *hdr;
 
 	if (!(skb_shinfo(clone)->tx_flags & SKBTX_HW_TSTAMP))
 		return false;
@@ -513,15 +482,13 @@ bool mv88e6xxx_port_txtstamp(struct dsa_switch *ds, int port,
 	if (!hdr)
 		return false;
 
-	seq_ptr = (__be16 *)(hdr + OFF_PTP_SEQUENCE_ID);
-
 	if (test_and_set_bit_lock(MV88E6XXX_HWTSTAMP_TX_IN_PROGRESS,
 				  &ps->state))
 		return false;
 
 	ps->tx_skb = clone;
 	ps->tx_tstamp_start = jiffies;
-	ps->tx_seq_id = be16_to_cpup(seq_ptr);
+	ps->tx_seq_id = be16_to_cpu(hdr->sequence_id);
 
 	ptp_schedule_worker(chip->ptp_clock, 0);
 	return true;
-- 
2.20.1

