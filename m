Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8213822E865
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 11:06:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727867AbgG0JGU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 05:06:20 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:53724 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727843AbgG0JGS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 05:06:18 -0400
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1595840775;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=i2kXL4jLvZsgWK6ZVbx1j1SeUZGLYcPkHfVgwCo/FwQ=;
        b=eeLa5JQjZe4fQv1RMi7vVLpMMlIO7RWHPoaD1YLswpylhpF4DweJJthIn6TG+sO1o01/QR
        qyYfXK0hLw9/hD6PTLc/QLW/KKyG6o+w8FIGj0wQ9i75ELcaerd5eMrq5nRbmgbX4T3Zwt
        maiDkC0++AQdJJVg/BfFvDU3najyLjFYhfxt968GnX5HzkrOFY3mlBLmUfYj6GGiifqzxX
        NgBq1SZGOI3JRx3wqdJONLU0xlDGI+gFwYA/JLOD6wdoeV0GOVbmDbEkqwlZMFy+LRatzv
        eAWsALYBdkE8jBeyTgPi44dDdfNmkNEwFRazxfQCpOl+3TE3JfnaKOcjd759cg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1595840775;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=i2kXL4jLvZsgWK6ZVbx1j1SeUZGLYcPkHfVgwCo/FwQ=;
        b=HIq9Mk6ekByFQPwBzBEbKk5mp1VcXEblBh3zWAu4Pp3mg9+OIWLbYL64Z+CQedplfHbxq6
        mDvjK84HxfKBjeDw==
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
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH v2 3/9] net: dsa: mv88e6xxx: Use generic helper function
Date:   Mon, 27 Jul 2020 11:05:55 +0200
Message-Id: <20200727090601.6500-4-kurt@linutronix.de>
In-Reply-To: <20200727090601.6500-1-kurt@linutronix.de>
References: <20200727090601.6500-1-kurt@linutronix.de>
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
 drivers/net/dsa/mv88e6xxx/hwtstamp.c | 59 ++++++----------------------
 1 file changed, 13 insertions(+), 46 deletions(-)

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

