Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BD2522E863
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 11:06:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727849AbgG0JGQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 05:06:16 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:53678 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726151AbgG0JGP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 05:06:15 -0400
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1595840773;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ce4zSUbSioJLpk17RHd8VO3wHB5lWX9bXyATZVrqzsU=;
        b=rnVfjHHiXGu6NFp6kCfhfp65Eay5JKLYFetQxJp2XIZkSHu11fE5kjf9QjO4ii1/o4/SK8
        9vwLhOOaa/71engcwD6l71209Gzr7Su6AFtD3dcis7kd3n0HoXPbVmOdp/crP0zYgdLi8N
        x4R7OOsT7RRPodU5M3pSp+x8io0zN9REEuwbFUjA97DX818cgFkTRrIcul1hgg7yya4vd/
        58yZS2FIghqp/s4w97rOan4oDiVv1BY5V2nrAKFd5OcP8d7hcinBbEfehg7n8llBxi3i/Q
        VoLWHmrVJCKLH7b3cyK50jmSZALyj58/GjGBNLXABr3DQBOnkfH51r5CHWGCEg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1595840773;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ce4zSUbSioJLpk17RHd8VO3wHB5lWX9bXyATZVrqzsU=;
        b=qIw+CkW5gxVI7NmVj1eXROEIhTUtqDWeFBftxj7lF6aEiI/Qx4F5niWgyJit1g7Dp+DoGI
        0DITH5RgJfgsumBA==
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
Subject: [PATCH v2 1/9] ptp: Add generic ptp v2 header parsing function
Date:   Mon, 27 Jul 2020 11:05:53 +0200
Message-Id: <20200727090601.6500-2-kurt@linutronix.de>
In-Reply-To: <20200727090601.6500-1-kurt@linutronix.de>
References: <20200727090601.6500-1-kurt@linutronix.de>
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

