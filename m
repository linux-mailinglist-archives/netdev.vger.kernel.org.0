Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66434232CC9
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 10:01:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729006AbgG3IBI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 04:01:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728955AbgG3IA7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 04:00:59 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52B6EC0619D2
        for <netdev@vger.kernel.org>; Thu, 30 Jul 2020 01:00:59 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1596096057;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qCfbcMWraFBRP/yZfPoPLMvG8cwiV1+8wOi/c5uvpMM=;
        b=V72sSEQ0MPOporyGDJeUOFA7yf4AAw/ycAWNZrJMusI+8Rym9cZQvzSLYzbO0xduUqo82z
        IMKIfamu9qseFXt0yF2BZ7TvDsjGUXZA3IShIkAXAFMwkunrNBFs6Ibj4CcrOPfcmqGgB1
        dyPv3j4XgVD7CRngSNR2h60gw0jXjra6ljXEGwakqDSy1vydh9MkuEaZhygszRe89KAVbR
        zw1vgFms3o5gqlva1LklN3urbLuyzDCzM8uEdOheZUCv9DALSm7G9Fc15kxGEAHHQrE41z
        S+9i8d1DWF734sHlUk0sWnCByrsx/Jg4De9lpoLWuIT0Y2bqGVOiO/qqjcvGlQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1596096057;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qCfbcMWraFBRP/yZfPoPLMvG8cwiV1+8wOi/c5uvpMM=;
        b=UfHi9qdId2zOnQTMxT86pRHL7mFmJ+CUSb2q6G+TPQI9Ec0YGTk9txHcHhzdeuLHd5Q3pW
        UrhFaP5owWB6OuBQ==
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
Subject: [PATCH v3 8/9] ptp: ptp_ines: Use generic helper function
Date:   Thu, 30 Jul 2020 10:00:47 +0200
Message-Id: <20200730080048.32553-9-kurt@linutronix.de>
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

