Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0B4822E868
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 11:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727858AbgG0JGY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 05:06:24 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:53724 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727864AbgG0JGV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 05:06:21 -0400
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1595840779;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qCfbcMWraFBRP/yZfPoPLMvG8cwiV1+8wOi/c5uvpMM=;
        b=ZvTGMP7Os4LnKhuYmwjM90XxENhObOs4n2lcLDqwhHOAnkFsyUlB9SkHTsvq2LGhIVbCQm
        3YCr/zavUfi8OHjOLIStYHGm+uXcHNu3lkfQWAxmc5myad1QWEnTM9vfOnUq2LK7sHFXXq
        ih6NF0+q+5qD9tjGO+6O7YBG9wr0YACzjai6xj77WkRbJhbf043BHs04NqE2NKDXQCvxwn
        g09bRRp50REWCkIrrQiyrRuOvZZc99K2D4C5Nrs2i05TmWlegvxPt6lg4zx0PI+w7Y58XW
        oqB82p6yZEJtHD4ElVnnv0wNmca/UC1h/UGq4mhbCa5meXsmyuhSSNy/WLAq+g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1595840779;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qCfbcMWraFBRP/yZfPoPLMvG8cwiV1+8wOi/c5uvpMM=;
        b=+bVIOtsQHkjA65AYwC2jwcTuejlJij/SOUHvQ/9bbqcXVbrMXHlH4XsnOZ+eGV9CGyNaq2
        TFuqMQf0h1tSTjCg==
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
Subject: [PATCH v2 8/9] ptp: ptp_ines: Use generic helper function
Date:   Mon, 27 Jul 2020 11:06:00 +0200
Message-Id: <20200727090601.6500-9-kurt@linutronix.de>
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
 drivers/ptp/ptp_ines.c | 88 ++++++++++++------------------------------
 1 file changed, 25 insertions(+), 63 deletions(-)

diff --git a/drivers/ptp/ptp_ines.c b/drivers/ptp/ptp_ines.c
index 7711651ff19e..d726c589edda 100644
--- a/drivers/ptp/ptp_ines.c
+++ b/drivers/ptp/ptp_ines.c
@@ -93,9 +93,6 @@ MODULE_LICENSE("GPL");
 #define TC_E2E_PTP_V2		2
 #define TC_P2P_PTP_V2		3
 
-#define OFF_PTP_CLOCK_ID	20
-#define OFF_PTP_PORT_NUM	28
-
 #define PHY_SPEED_10		0
 #define PHY_SPEED_100		1
 #define PHY_SPEED_1000		2
@@ -443,57 +440,41 @@ static void ines_link_state(struct mii_timestamper *mii_ts,
 static bool ines_match(struct sk_buff *skb, unsigned int ptp_class,
 		       struct ines_timestamp *ts, struct device *dev)
 {
-	u8 *msgtype, *data = skb_mac_header(skb);
-	unsigned int offset = 0;
-	__be16 *portn, *seqid;
-	__be64 *clkid;
+	struct ptp_header *hdr;
+	u16 portn, seqid;
+	u8 msgtype;
+	u64 clkid;
 
 	if (unlikely(ptp_class & PTP_CLASS_V1))
 		return false;
 
-	if (ptp_class & PTP_CLASS_VLAN)
-		offset += VLAN_HLEN;
-
-	switch (ptp_class & PTP_CLASS_PMASK) {
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
-		return false;
-	}
-
-	if (skb->len + ETH_HLEN < offset + OFF_PTP_SEQUENCE_ID + sizeof(*seqid))
+	hdr = ptp_parse_header(skb, ptp_class);
+	if (!hdr)
 		return false;
 
-	msgtype = data + offset;
-	clkid = (__be64 *)(data + offset + OFF_PTP_CLOCK_ID);
-	portn = (__be16 *)(data + offset + OFF_PTP_PORT_NUM);
-	seqid = (__be16 *)(data + offset + OFF_PTP_SEQUENCE_ID);
+	msgtype = ptp_get_msgtype(hdr, ptp_class);
+	clkid = be64_to_cpup((__be64 *)&hdr->source_port_identity.clock_identity.id[0]);
+	portn = be16_to_cpu(hdr->source_port_identity.port_number);
+	seqid = be16_to_cpu(hdr->sequence_id);
 
-	if (tag_to_msgtype(ts->tag & 0x7) != (*msgtype & 0xf)) {
+	if (tag_to_msgtype(ts->tag & 0x7) != msgtype) {
 		dev_dbg(dev, "msgtype mismatch ts %hhu != skb %hhu\n",
-			  tag_to_msgtype(ts->tag & 0x7), *msgtype & 0xf);
+			tag_to_msgtype(ts->tag & 0x7), msgtype);
 		return false;
 	}
-	if (cpu_to_be64(ts->clkid) != *clkid) {
+	if (ts->clkid != clkid) {
 		dev_dbg(dev, "clkid mismatch ts %llx != skb %llx\n",
-			  cpu_to_be64(ts->clkid), *clkid);
+			ts->clkid, clkid);
 		return false;
 	}
-	if (ts->portnum != ntohs(*portn)) {
+	if (ts->portnum != portn) {
 		dev_dbg(dev, "portn mismatch ts %hu != skb %hu\n",
-			  ts->portnum, ntohs(*portn));
+			ts->portnum, portn);
 		return false;
 	}
-	if (ts->seqid != ntohs(*seqid)) {
+	if (ts->seqid != seqid) {
 		dev_dbg(dev, "seqid mismatch ts %hu != skb %hu\n",
-			  ts->seqid, ntohs(*seqid));
+			ts->seqid, seqid);
 		return false;
 	}
 
@@ -694,35 +675,16 @@ static void ines_txtstamp_work(struct work_struct *work)
 
 static bool is_sync_pdelay_resp(struct sk_buff *skb, int type)
 {
-	u8 *data = skb->data, *msgtype;
-	unsigned int offset = 0;
-
-	if (type & PTP_CLASS_VLAN)
-		offset += VLAN_HLEN;
+	struct ptp_header *hdr;
+	u8 msgtype;
 
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
-
-	if (skb->len < offset + 1)
-		return 0;
+	hdr = ptp_parse_header(skb, type);
+	if (!hdr)
+		return false;
 
-	msgtype = data + offset;
+	msgtype = ptp_get_msgtype(hdr, type);
 
-	switch ((*msgtype & 0xf)) {
+	switch ((msgtype & 0xf)) {
 	case SYNC:
 	case PDELAY_RESP:
 		return true;
-- 
2.20.1

