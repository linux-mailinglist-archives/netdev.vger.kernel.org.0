Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13115248317
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 12:34:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbgHRKeS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 06:34:18 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:58360 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726588AbgHRKdb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 06:33:31 -0400
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1597746809;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ArVMPE4/H87/mYmqDJXSZhcFMZ0CNN5N3ct4/Md1alM=;
        b=tpbhaBYg6co07LesHKyHRGE1goHYbBYq32Jucw9u9LpiCia0IdvzWnXcwNUVu9/R46soqm
        7pcq42JiAplKh0p5J5/fVRNrfXHw742U2/SnMdJ2Be3fiyDuX3N4x8Wb0WCB7mKA9kI3lK
        MB6QP6fRSl8nVDUJVBjjM47MiCr6NyfKYYnMN2a7sGbjA693bdO99haWlsqavaBh2aunMc
        Ns8an61kYljknFMCDI4EIs+zAw0teoUYDJMKNfXnnAwH5UPwxHj19dmgZUxXMG7iSfMw28
        NDFV1AYJFA5NMPmVqEEbH7DadpKCUf2luQzDWB3PWNaQe2R3XmCO8quhmVZfOw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1597746809;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ArVMPE4/H87/mYmqDJXSZhcFMZ0CNN5N3ct4/Md1alM=;
        b=f6sYlKbSLFG6LbsocOtmifpc+5Bmsu7xx9sslpQbOKY2Y8NB7W6gbdUvXzxd55N2pHckSw
        YPMDZgN2X+UmGeDQ==
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
Subject: [PATCH v4 8/9] ptp: ptp_ines: Use generic helper function
Date:   Tue, 18 Aug 2020 12:32:50 +0200
Message-Id: <20200818103251.20421-9-kurt@linutronix.de>
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

