Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2578B22AA07
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 09:50:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727859AbgGWHup (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 03:50:45 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:55928 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726603AbgGWHun (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 03:50:43 -0400
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1595490641;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YsxNfI9ThCCy8NI8e3vdNLXtuNrsksklUaXTlwtOxxA=;
        b=luIJcVzcKIgZkJjQYPUDzNmQoV3Sf+D6NSR2YdUo/j3BErhdhNTJeGNFalcFwzc76cYjqw
        6cEJp8bnApMkUXgSh3BH+nNn6i2jjOhJAQW/UV66lVBFiV2TEaSqIe1PJUZ0Df7pJEyuRY
        0t0AS8FyiLELr0r5DXsVf05Vm8RzefO17Mzv/wxYRzGnMr5FsjENyEbydWitr3t0Gh9zmV
        h4jiidE23I+cDWeMJ/nSnYXTxNn/RgRF25ucJ1qO3WmGj2evxmfsRKCNOEWLv2Oz5TFRR0
        uSNXFTFeKzp8LfModqgyEJ0Oh15RiYflyAoLdPtE2hZcwZQOWp++idCHo7ACrQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1595490641;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YsxNfI9ThCCy8NI8e3vdNLXtuNrsksklUaXTlwtOxxA=;
        b=4tyMIbsRkZ/vk1DXLJPagKERMVSStVhReyc9UkCOwHse+hZFFIne2lWYXi9ThttLYpOAmR
        DVMUEUeGLuB2i2BQ==
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH v1 1/2] ptp: Add generic ptp v2 header parsing function
Date:   Thu, 23 Jul 2020 09:49:45 +0200
Message-Id: <20200723074946.14253-2-kurt@linutronix.de>
In-Reply-To: <20200723074946.14253-1-kurt@linutronix.de>
References: <20200723074946.14253-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reason: A lot of the ptp drivers - which implement hardware time stamping - need
specific fields such as the sequence id from the ptp v2 header. Currently all
drivers implement that themselves.

Introduce a generic function to retrieve a pointer to the start of the ptp v2
header.

Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
---
 include/linux/ptp_classify.h | 38 ++++++++++++++++++++++++++++++++++++
 net/core/ptp_classifier.c    | 30 ++++++++++++++++++++++++++++
 2 files changed, 68 insertions(+)

diff --git a/include/linux/ptp_classify.h b/include/linux/ptp_classify.h
index dd00fa41f7e7..3370f402a503 100644
--- a/include/linux/ptp_classify.h
+++ b/include/linux/ptp_classify.h
@@ -44,6 +44,30 @@
 #define OFF_IHL		14
 #define IPV4_HLEN(data) (((struct iphdr *)(data + OFF_IHL))->ihl << 2)
 
+struct clock_identity {
+	u8 id[8];
+} __packed;
+
+struct port_identity {
+	struct clock_identity	clock_identity;
+	__be16			port_number;
+} __packed;
+
+struct ptp_header {
+	u8			tsmt;  /* transportSpecific | messageType */
+	u8			ver;   /* reserved          | versionPTP  */
+	__be16			message_length;
+	u8			domain_number;
+	u8			reserved1;
+	u8			flag_field[2];
+	__be64			correction;
+	__be32			reserved2;
+	struct port_identity	source_port_identity;
+	__be16			sequence_id;
+	u8			control;
+	u8			log_message_interval;
+} __packed;
+
 #if defined(CONFIG_NET_PTP_CLASSIFY)
 /**
  * ptp_classify_raw - classify a PTP packet
@@ -57,6 +81,15 @@
  */
 unsigned int ptp_classify_raw(const struct sk_buff *skb);
 
+/**
+ * ptp_parse_header - Get pointer to the PTP v2 header
+ * @skb: packet buffer
+ * @type: type of the packet (see ptp_classify_raw())
+ *
+ * Return: Pointer to the ptp v2 header or NULL if not found
+ */
+struct ptp_header *ptp_parse_header(struct sk_buff *skb, unsigned int type);
+
 void __init ptp_classifier_init(void);
 #else
 static inline void ptp_classifier_init(void)
@@ -66,5 +99,10 @@ static inline unsigned int ptp_classify_raw(struct sk_buff *skb)
 {
 	return PTP_CLASS_NONE;
 }
+static struct ptp_header *ptp_parse_header(struct sk_buff *skb,
+					   unsigned int type)
+{
+	return NULL;
+}
 #endif
 #endif /* _PTP_CLASSIFY_H_ */
diff --git a/net/core/ptp_classifier.c b/net/core/ptp_classifier.c
index d964a5147f22..dc12338bf3cd 100644
--- a/net/core/ptp_classifier.c
+++ b/net/core/ptp_classifier.c
@@ -107,6 +107,36 @@ unsigned int ptp_classify_raw(const struct sk_buff *skb)
 }
 EXPORT_SYMBOL_GPL(ptp_classify_raw);
 
+struct ptp_header *ptp_parse_header(struct sk_buff *skb, unsigned int type)
+{
+	u8 *data = skb_mac_header(skb);
+	unsigned int offset = 0;
+
+	if (type & PTP_CLASS_VLAN)
+		offset += VLAN_HLEN;
+
+	switch (type & PTP_CLASS_PMASK) {
+	case PTP_CLASS_IPV4:
+		offset += ETH_HLEN + IPV4_HLEN(data + offset) + UDP_HLEN;
+		break;
+	case PTP_CLASS_IPV6:
+		offset += ETH_HLEN + IP6_HLEN + UDP_HLEN;
+		break;
+	case PTP_CLASS_L2:
+		offset += ETH_HLEN;
+		break;
+	default:
+		return NULL;
+	}
+
+	/* Ensure that the entire header is present in this packet. */
+	if (skb->len + ETH_HLEN < offset + sizeof(struct ptp_header))
+		return NULL;
+
+	return (struct ptp_header *)(data + offset);
+}
+EXPORT_SYMBOL_GPL(ptp_parse_header);
+
 void __init ptp_classifier_init(void)
 {
 	static struct sock_filter ptp_filter[] __initdata = {
-- 
2.20.1

