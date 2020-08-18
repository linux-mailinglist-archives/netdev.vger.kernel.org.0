Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B719C24830F
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 12:33:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726681AbgHRKdj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 06:33:39 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:58260 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726336AbgHRKd0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 06:33:26 -0400
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1597746805;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=n5vUlGIhwo18BoJiDcSAL6IV5clgAspCMT49T7NhZrI=;
        b=mQzBFtfhE+8Lz2EsNGPyJPk5cxriTHMIBAHd8KEiadtgclIU4Toik3DzO9bBTr4yauF4Sz
        pfezv4Bhw0WCpKl0qG/LYXFnoCDmyLKRLN29hCla39LfQAJLJXQCi4BtqfhFzD5agWgPeP
        IHVvzFn0EFlf7Gpw4dkvZEcSO32KPTskQy4yO0y/stMSVOcEnoUU1/02A1s8636POPpGho
        5WtUVJF3IVGbNWPpZCW7Iqw8GlZVpGD/xmR35vvePQNGwWUJgf6ZVzqhGFq9bJO5EtSgiZ
        r5bqaGpLC7T0K+y8qCv7ZiuTBHU4IjSjInSXgL/k0u/A+BH57APgMybrScGmCg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1597746805;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=n5vUlGIhwo18BoJiDcSAL6IV5clgAspCMT49T7NhZrI=;
        b=xVpC9uZm2ri434pnnf2/5s1jDdZTqBbgrehjlnDVymIOLagyKJ7xYPNfK6wxtLpXARC3Tf
        aD5PE/suGy/NjnCg==
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
Subject: [PATCH v4 2/9] ptp: Add generic ptp message type function
Date:   Tue, 18 Aug 2020 12:32:44 +0200
Message-Id: <20200818103251.20421-3-kurt@linutronix.de>
In-Reply-To: <20200818103251.20421-1-kurt@linutronix.de>
References: <20200818103251.20421-1-kurt@linutronix.de>
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
Reviewed-by: Richard Cochran <richardcochran@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 include/linux/ptp_classify.h | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/include/linux/ptp_classify.h b/include/linux/ptp_classify.h
index 996f31e8f35d..39bad015d1d6 100644
--- a/include/linux/ptp_classify.h
+++ b/include/linux/ptp_classify.h
@@ -96,6 +96,31 @@ unsigned int ptp_classify_raw(const struct sk_buff *skb);
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
+	if (unlikely(type & PTP_CLASS_V1)) {
+		/* msg type is located at the control field for ptp v1 */
+		msgtype = hdr->control;
+	} else {
+		msgtype = hdr->tsmt & 0x0f;
+	}
+
+	return msgtype;
+}
+
 void __init ptp_classifier_init(void);
 #else
 static inline void ptp_classifier_init(void)
-- 
2.20.1

