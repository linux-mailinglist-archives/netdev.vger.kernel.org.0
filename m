Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FBD8248311
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 12:33:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726611AbgHRKdx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 06:33:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726357AbgHRKd1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 06:33:27 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01B0EC061389
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 03:33:26 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1597746803;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7G/FKsJTVAainV3L7DVpyEq0nwFjy23Xz759YCMNG1o=;
        b=Bjv6Xasgwl9kHj7psP2YlQ8Hx0+UZGUYtkyjOXEpSxJl0cEiNMHZBy+Sk/4HZmtYxYozqT
        zFkuexMGR7F2H0dz458EqHsYzP6NnoGid9ZNML0kGGBjrqBJ62pNMGgxKrgrT2slgvOdaO
        1PPIIeJOVO32d79srLbwMKoVKp4zU5Gf+3mlH5nT1XCJM62YWcAGOu0ajlMaCyxtcH5sNE
        jfGcsQbXdlrDggA1eiYOSvzfyY6LXQBG8dsTn1uZgzubKGJ7zlRqJ2TP/b4GVf2doE+OxD
        h+9ul+a9JvbBztz8GPsxgbJkEzykmfZlgpU+hT5lcVnc32ttMn3sCwIMx/cJjw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1597746803;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7G/FKsJTVAainV3L7DVpyEq0nwFjy23Xz759YCMNG1o=;
        b=W1h5j0oZeTmGMyqltAsl4iifdhnFLLwRhse4l4TXXmJClgrTRORh8oqslf6JCV+IlHxpkS
        K6P9ctiIztCupsAQ==
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
        Kurt Kanzenbach <kurt@linutronix.de>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH v4 1/9] ptp: Add generic ptp v2 header parsing function
Date:   Tue, 18 Aug 2020 12:32:43 +0200
Message-Id: <20200818103251.20421-2-kurt@linutronix.de>
In-Reply-To: <20200818103251.20421-1-kurt@linutronix.de>
References: <20200818103251.20421-1-kurt@linutronix.de>
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
Reviewed-by: Richard Cochran <richardcochran@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 include/linux/ptp_classify.h | 44 ++++++++++++++++++++++++++++++++++++
 net/core/ptp_classifier.c    | 30 ++++++++++++++++++++++++
 2 files changed, 74 insertions(+)

diff --git a/include/linux/ptp_classify.h b/include/linux/ptp_classify.h
index dd00fa41f7e7..996f31e8f35d 100644
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
@@ -57,6 +81,21 @@
  */
 unsigned int ptp_classify_raw(const struct sk_buff *skb);
 
+/**
+ * ptp_parse_header - Get pointer to the PTP v2 header
+ * @skb: packet buffer
+ * @type: type of the packet (see ptp_classify_raw())
+ *
+ * This function takes care of the VLAN, UDP, IPv4 and IPv6 headers. The length
+ * is checked.
+ *
+ * Note, internally skb_mac_header() is used. Make sure, that the @skb is
+ * initialized accordingly.
+ *
+ * Return: Pointer to the ptp v2 header or NULL if not found
+ */
+struct ptp_header *ptp_parse_header(struct sk_buff *skb, unsigned int type);
+
 void __init ptp_classifier_init(void);
 #else
 static inline void ptp_classifier_init(void)
@@ -66,5 +105,10 @@ static inline unsigned int ptp_classify_raw(struct sk_buff *skb)
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
index d964a5147f22..e33fde06d528 100644
--- a/net/core/ptp_classifier.c
+++ b/net/core/ptp_classifier.c
@@ -107,6 +107,36 @@ unsigned int ptp_classify_raw(const struct sk_buff *skb)
 }
 EXPORT_SYMBOL_GPL(ptp_classify_raw);
 
+struct ptp_header *ptp_parse_header(struct sk_buff *skb, unsigned int type)
+{
+	u8 *ptr = skb_mac_header(skb);
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

