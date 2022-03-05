Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E8144CE485
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 12:22:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231570AbiCELW4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Mar 2022 06:22:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231565AbiCELWx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Mar 2022 06:22:53 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88CD04C431
        for <netdev@vger.kernel.org>; Sat,  5 Mar 2022 03:22:03 -0800 (PST)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1646479321;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UmHdpLQdC9gCELymJWOCuaaDr/7o88IzL8OY0KJQsVY=;
        b=jaBPa6twSYuwKugnqJdiAsSRWI0OmeM8rRdhLV5fOif1u58uDe1C+lXrv1kDWhAmp4/CDu
        tV9+SlqIa0CQJ2/cMQAdXyBECRe31UtW9ppXC5hl0T3J+558jwDri0A0J0LV6Sgb4rVhRq
        +qb86PamBFMqKiPpS4xIkgsyVvxYaW16e2Nsswshx3pVe9+Zm/fbqB2WGFC9b4XcQY3zP2
        unEPTXqa+SBUPKMBG5M8qSvSlIuEdCQlVWR5Um33WwHoHODPzom5YQWxrKGuC/VHv3Jeak
        7n1MdgmC2F/1OAL3oaTtgfMO830OZdY7RRYqPS+Rx1J5A7Tl7JzHH+DpjkbpUA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1646479321;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UmHdpLQdC9gCELymJWOCuaaDr/7o88IzL8OY0KJQsVY=;
        b=iu2TBHfSospxLuP40oOTJt5lWdaxwE+EhZPuYDO+WTbfibza9dtsWmkgurR8J6IWFXT8Zb
        rkm7Zje6tMW13HDg==
To:     Richard Cochran <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Divya Koppera <Divya.Koppera@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        netdev@vger.kernel.org, Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH net-next 1/3] ptp: Add generic PTP is_sync() function
Date:   Sat,  5 Mar 2022 12:21:25 +0100
Message-Id: <20220305112127.68529-2-kurt@linutronix.de>
In-Reply-To: <20220305112127.68529-1-kurt@linutronix.de>
References: <20220305112127.68529-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PHY drivers such as micrel or dp83640 need to analyze whether a given
skb is a PTP sync message for one step functionality.

In order to avoid code duplication introduce a generic function and
move it to ptp classify.

Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
---
 include/linux/ptp_classify.h | 15 +++++++++++++++
 net/core/ptp_classifier.c    | 12 ++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/include/linux/ptp_classify.h b/include/linux/ptp_classify.h
index 9afd34a2d36c..fefa7790dc46 100644
--- a/include/linux/ptp_classify.h
+++ b/include/linux/ptp_classify.h
@@ -126,6 +126,17 @@ static inline u8 ptp_get_msgtype(const struct ptp_header *hdr,
 	return msgtype;
 }
 
+/**
+ * ptp_msg_is_sync - Evaluates whether the given skb is a PTP Sync message
+ * @skb: packet buffer
+ * @type: type of the packet (see ptp_classify_raw())
+ *
+ * This function evaluates whether the given skb is a PTP Sync message.
+ *
+ * Return: true if sync message, false otherwise
+ */
+bool ptp_msg_is_sync(struct sk_buff *skb, unsigned int type);
+
 void __init ptp_classifier_init(void);
 #else
 static inline void ptp_classifier_init(void)
@@ -148,5 +159,9 @@ static inline u8 ptp_get_msgtype(const struct ptp_header *hdr,
 	 */
 	return PTP_MSGTYPE_SYNC;
 }
+static inline bool ptp_msg_is_sync(struct sk_buff *skb, unsigned int type)
+{
+	return false;
+}
 #endif
 #endif /* _PTP_CLASSIFY_H_ */
diff --git a/net/core/ptp_classifier.c b/net/core/ptp_classifier.c
index dd4cf01d1e0a..598041b0499e 100644
--- a/net/core/ptp_classifier.c
+++ b/net/core/ptp_classifier.c
@@ -137,6 +137,18 @@ struct ptp_header *ptp_parse_header(struct sk_buff *skb, unsigned int type)
 }
 EXPORT_SYMBOL_GPL(ptp_parse_header);
 
+bool ptp_msg_is_sync(struct sk_buff *skb, unsigned int type)
+{
+	struct ptp_header *hdr;
+
+	hdr = ptp_parse_header(skb, type);
+	if (!hdr)
+		return false;
+
+	return ptp_get_msgtype(hdr, type) == PTP_MSGTYPE_SYNC;
+}
+EXPORT_SYMBOL_GPL(ptp_msg_is_sync);
+
 void __init ptp_classifier_init(void)
 {
 	static struct sock_filter ptp_filter[] __initdata = {
-- 
2.30.2

