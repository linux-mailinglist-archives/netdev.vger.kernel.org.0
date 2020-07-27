Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D17E522E86A
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 11:06:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727893AbgG0JG3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 05:06:29 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:53792 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727861AbgG0JGU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 05:06:20 -0400
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1595840778;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3KVqULQgDBBQavit3YP1GIzDOmOOSvIFIOOkmVMmyvY=;
        b=hPButknuPCMI/1/CgmZNvb1KmaP8BE9Z2d42zqdso84w1uM//khjk3SjTp26A9RbmdAGzb
        7CSwuJASUVlc8vn44DT6dYxbGzm6GvJOKynEACcFRIctJX3YsrdiFRAT6yjDNVfjoxZBYu
        aVHCVFyuS3SCMiV47BAskwjrQFLjdPPYll5ydltZUo2o8J/yjVUAinDEP+VNbdgxOlHvKZ
        NA8REV8okAmAriJyqU1MJR5P+7G08BA+cSve4gaAyBXG10aafVNOOgtrAvTxeREzhNntZD
        1504xz9lu1gDGUrou/s2ftxfaQFk5spQT0gXelNqB/CXxvZQpPc2bNyltPwTqw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1595840778;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3KVqULQgDBBQavit3YP1GIzDOmOOSvIFIOOkmVMmyvY=;
        b=itCtxE4XAy74qLN0wxBLoVv7Vr+REcABtG4ZywYhb+ZjwqyKPFWM8pNISsS8uC7C5nydyT
        QFHabFnOAs0q31Bg==
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
Subject: [PATCH v2 7/9] net: phy: dp83640: Use generic helper function
Date:   Mon, 27 Jul 2020 11:05:59 +0200
Message-Id: <20200727090601.6500-8-kurt@linutronix.de>
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

