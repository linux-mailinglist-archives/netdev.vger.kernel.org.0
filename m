Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D1A4232CC5
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 10:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728862AbgG3IA5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 04:00:57 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:48584 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728587AbgG3IAz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 04:00:55 -0400
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1596096053;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9P8gMf8i9C0oXqVy7k9ypbKFNKMeofX74OznxZ2irIM=;
        b=0maAn6XSDn76dRt3ys7gxyGonIQ9/ROg+ZLYS46VjxewNN8VEgwsg2M4zXGUvQCgo3axUJ
        O08LF9awUSixHfC56ap8ZtTPl3c+b74zCaZEJTg3Lh2FfEl+5Ki4F0jJusgN9YLt3J83H7
        vxwa7JcfmlhJOsxkCvC4T2BaW8KD7ahKzf67migh1TJ6qQngEypyiSk24Hg5wpL2If6gXq
        LJtK4wDy88jyMclS8gDK7dSbSh9mRsmqt0UyA+fXGUq820h6H+ib5HhebNEwZ5zyYjt7/V
        eVb0TNCFMiv8dUNSp8Vtid+X7G5wrEm72j8stqulpABQ+qblTAX1EwexQ2Yfxg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1596096053;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9P8gMf8i9C0oXqVy7k9ypbKFNKMeofX74OznxZ2irIM=;
        b=jkBmZ7jGMLSGf8OqEKxSvx7WZ3uMaNNITpBAVrj0HBzz6hQ8bhbbQuG+/HsUHXJZyLUouM
        4CTz4C4VqV9WfWAQ==
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
        Kurt Kanzenbach <kurt@linutronix.de>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH v3 1/9] ptp: Add generic ptp v2 header parsing function
Date:   Thu, 30 Jul 2020 10:00:40 +0200
Message-Id: <20200730080048.32553-2-kurt@linutronix.de>
In-Reply-To: <20200730080048.32553-1-kurt@linutronix.de>
References: <20200730080048.32553-1-kurt@linutronix.de>
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

Suggested-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
---
 include/linux/ptp_classify.h | 38 ++++++++++++++++++++++++++++++++++++
 net/core/ptp_classifier.c    | 31 +++++++++++++++++++++++++++++
 2 files changed, 69 insertions(+)

diff --git a/include/linux/ptp_classify.h b/include/linux/ptp_classify.h
index dd00fa41f7e7..26fd38a4bd67 100644
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
+static inline struct ptp_header *ptp_parse_header(struct sk_buff *skb,
+						  unsigned int type)
+{
+	return NULL;
+}
 #endif
 #endif /* _PTP_CLASSIFY_H_ */
diff --git a/net/core/ptp_classifier.c b/net/core/ptp_classifier.c
index d964a5147f22..41f373477812 100644
--- a/net/core/ptp_classifier.c
+++ b/net/core/ptp_classifier.c
@@ -107,6 +107,37 @@ unsigned int ptp_classify_raw(const struct sk_buff *skb)
 }
 EXPORT_SYMBOL_GPL(ptp_classify_raw);
 
+struct ptp_header *ptp_parse_header(struct sk_buff *skb, unsigned int type)
+{
+	u8 *data = skb_mac_header(skb);
+	u8 *ptr = data;
+
+	if (type & PTP_CLASS_VLAN)
+		ptr += VLAN_HLEN;
+
+	switch (type & PTP_CLASS_PMASK) {
+	case PTP_CLASS_IPV4:
+		ptr += IPV4_HLEN(ptr) + UDP_HLEN;
+		break;
+	case PTP_CLASS_IPV6:
+		ptr += IP6_HLEN + UDP_HLEN;
+		break;
+	case PTP_CLASS_L2:
+		break;
+	default:
+		return NULL;
+	}
+
+	ptr += ETH_HLEN;
+
+	/* Ensure that the entire header is present in this packet. */
+	if (ptr + sizeof(struct ptp_header) > skb->data + skb->len)
+		return NULL;
+
+	return (struct ptp_header *)ptr;
+}
+EXPORT_SYMBOL_GPL(ptp_parse_header);
+
 void __init ptp_classifier_init(void)
 {
 	static struct sock_filter ptp_filter[] __initdata = {
-- 
2.20.1

