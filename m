Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0ABD232CC4
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 10:01:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728826AbgG3IA4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 04:00:56 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:48602 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726287AbgG3IAz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 04:00:55 -0400
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1596096054;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1t4y2N6HKjAv6a/LdlcDy0zwrL1j61Kl789tc3VQTG4=;
        b=XmzTcdCLe+/cRQZ7Q2Vfj5mBalmPZP6IR27wDSWbQ7oAEs367D6NrlQr2nNYIbtiVVZg0W
        WklkdaBAa1UFvR+9QFgpIpKZGq5+knTKGp5k7q7LAeluvVIxIdnzCLMCjqMS4jgqDVfUyC
        o+Uqt0poXZrFbSe0jhQ0pyCx512wRdCkic5/ZBanx7VBAh8LbTaXsBBnRoOmvxuL0IWaZk
        zj8D+L/MjaltzVfUXpxR0zJiSvV+xuUubI0eDwyAumPJcryxhSViZrNTcCiDrwUTLs8fKq
        l4P/7qd4ImDb+IXiNhMG8a8CFmtYd04YUkwyFUzkr5jyObJF5bnnV95nc+M5KA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1596096054;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1t4y2N6HKjAv6a/LdlcDy0zwrL1j61Kl789tc3VQTG4=;
        b=V/H9UZ8ZSyN1GoOCznaYv7BWWP5YilrlqnZYQTs9I6Nousr4kr6kTCgTEvC7VTJAuHIf+s
        u+TjM/mBByUEHZBw==
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
Subject: [PATCH v3 2/9] ptp: Add generic ptp message type function
Date:   Thu, 30 Jul 2020 10:00:41 +0200
Message-Id: <20200730080048.32553-3-kurt@linutronix.de>
In-Reply-To: <20200730080048.32553-1-kurt@linutronix.de>
References: <20200730080048.32553-1-kurt@linutronix.de>
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
index 26fd38a4bd67..f4dd42fddc0c 100644
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
+		/* msg type is located at the control field for ptp v1 */
+		msgtype = hdr->control;
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

