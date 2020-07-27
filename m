Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 150BB22E864
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 11:06:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727855AbgG0JGR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 05:06:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727844AbgG0JGQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 05:06:16 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CA7FC061794
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 02:06:16 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1595840775;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=twoFF5IjqtbADNVDp0i4bjM6fDsPvbIANELIKsGVcaA=;
        b=g++g4nCSxpohXnxvoHRSbvH/1+EpKvzNcyZMN+2P41K3H7DTf8Qu2C5agpGOrpeu6Upq4D
        S0hqlXU7chT23YYhwSoTK6n+biDgQ2MJs5IFOs2lKMWgPFw8kur2M1xBe5ZKw/9Y1NAWM0
        nx3H0tj9s9uWkmoW6Pf44dTFeO0xiYMFA/EePoecM7m6ZKvDwnzWOb3MWlrBv2mGPvDBWJ
        AD8Zz+7Pr3/UavrHWqkP8XZEpLgetwL6HiUIjjrYYAIR9JvAE7GL9TOArZZgWaUdJYrCI9
        uCr75mmA75kB/mi00gtTxMh7t6Z0KJ521PYLXMFa2hZr6K9CJfisyDIiZ5HWpA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1595840775;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=twoFF5IjqtbADNVDp0i4bjM6fDsPvbIANELIKsGVcaA=;
        b=RXU4M+dY1W8CSKfJ+m0s4fOxPUajpoei6YQQG0YzyB9HXHuVFIELhTenYw9BInsKIWbXkc
        UlqMwl4RnRsZQSAw==
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
Subject: [PATCH v2 2/9] ptp: Add generic ptp message type function
Date:   Mon, 27 Jul 2020 11:05:54 +0200
Message-Id: <20200727090601.6500-3-kurt@linutronix.de>
In-Reply-To: <20200727090601.6500-1-kurt@linutronix.de>
References: <20200727090601.6500-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The message type is located at different offsets within the ptp header depending
on the ptp version (v1 or v2). Therefore, drivers which also deal with ptp v1
have some code for it.

Extract this into a helper function for drivers to be used.

Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
---
 include/linux/ptp_classify.h | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/include/linux/ptp_classify.h b/include/linux/ptp_classify.h
index 26fd38a4bd67..e13f9c6150ad 100644
--- a/include/linux/ptp_classify.h
+++ b/include/linux/ptp_classify.h
@@ -90,6 +90,30 @@ unsigned int ptp_classify_raw(const struct sk_buff *skb);
  */
 struct ptp_header *ptp_parse_header(struct sk_buff *skb, unsigned int type);
 
+/**
+ * ptp_get_msgtype - Extract ptp message type from given header
+ * @hdr: ptp header
+ * @type: type of the packet (see ptp_classify_raw())
+ *
+ * This function returns the message type for a given ptp header. It takes care
+ * of the different ptp header versions (v1 or v2).
+ *
+ * Return: The message type
+ */
+static inline u8 ptp_get_msgtype(const struct ptp_header *hdr,
+				 unsigned int type)
+{
+	u8 msgtype;
+
+	if (unlikely(type & PTP_CLASS_V1))
+		/* msg type is located @ offset 20 for ptp v1 */
+		msgtype = hdr->source_port_identity.clock_identity.id[0];
+	else
+		msgtype = hdr->tsmt & 0x0f;
+
+	return msgtype;
+}
+
 void __init ptp_classifier_init(void);
 #else
 static inline void ptp_classifier_init(void)
-- 
2.20.1

