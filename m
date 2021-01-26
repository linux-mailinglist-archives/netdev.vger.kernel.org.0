Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2D4F3044C6
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 18:18:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387898AbhAZRMr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 12:12:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390780AbhAZJDt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 04:03:49 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E32DAC061573
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 01:03:08 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id v15so15579667wrx.4
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 01:03:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=LqFTfj3ouyLumB+z+5pG0kcz9O9PRTWEWgkuaChwCGs=;
        b=RuDmBqJPWt/MV6RiKHgrwvNqSos2vkNu0BSZ7IaGNjUj/3CdrskZoJKMDiAg2ZauYI
         KMQrhi2PIDy+k9HcKf5O5mEoqRDXaQMrQfVXQjpulguc53BMV4q5/QpLCk9EWFwfGUTd
         3BQY5rKYC/5lc7BlWJGqe17oVXt71RDMz4EwrRMDBvnes6H34NEFuf2IKXkqodHmTWgj
         dRXbD/O4nAE7mYmOrNXw6AuBblSUDT750fdOqXIhBPnXWzYkMwc7hQSCL6UwCBB7Frk/
         HC6rEFrPHcNCu1Fqlwc/T1mDy3DWa4lBPkvkt6y2Ik7bwm2G1LbadLsSKA3f9PXzzr9J
         doTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=LqFTfj3ouyLumB+z+5pG0kcz9O9PRTWEWgkuaChwCGs=;
        b=hYRpgt03FxzG2XgWN3XadYMuR4A0IsaGxJ01XssIG/qhmPWhAbzWoyI68/2S88sKLb
         g169TwT2I0Dqrq686QSAZeTJYoJM8UC0f6+cSFdSFgdf+SPbGOypZsKBp/lfLCzK4B+9
         7YuRx5oSRlbTDKm0LGcnhyCymTLo0PX0De9fwbLYPNCTeotIJWnTDdhPfEJrxiRKrF/6
         RnPfEnBnlGbAC461Rq4TMBZP69dWOJ6xwOhzGqpPPn77t/DdyS2LGWFQ7/fIqhp9/VOA
         Bfg1CXBkiNsh0mNfSrpr9+ryo1yqXCytP9JZBI2odviJc9mghIB/l9QgZB8fB3FFLVK4
         BWTg==
X-Gm-Message-State: AOAM530gxQRtMBTmP0GV7xZJDx5AjYeqhMdqIhoGckA86NXS7z+BBc+Z
        6BR+jttrHjMUw0FxFPhtFr8=
X-Google-Smtp-Source: ABdhPJxfSgYmrO+753i/A2Uqr9GanjSDwbGxM01ojXUImGTXP8KHAKOQ2KS7zdd0MzO9MAdTYTU1eg==
X-Received: by 2002:a5d:6305:: with SMTP id i5mr4804407wru.314.1611651787699;
        Tue, 26 Jan 2021 01:03:07 -0800 (PST)
Received: from ?IPv6:2003:ea:8f1f:ad00:510a:e145:c422:75a7? (p200300ea8f1fad00510ae145c42275a7.dip0.t-ipconnect.de. [2003:ea:8f1f:ad00:510a:e145:c422:75a7])
        by smtp.googlemail.com with ESMTPSA id r15sm6436452wrj.61.2021.01.26.01.03.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jan 2021 01:03:06 -0800 (PST)
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net] r8169: work around RTL8125 UDP hw bug
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        xplo.bn@gmail.com
Message-ID: <c7fd197f-8ab8-2297-385e-5d2b1d5911d7@gmail.com>
Date:   Tue, 26 Jan 2021 10:02:56 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It was reported that on RTL8125 network breaks under heavy UDP load,
e.g. torrent traffic ([0], from comment 27). Realtek confirmed a hw bug
and provided me with a test version of the r8125 driver including a
workaround. Tests confirmed that the workaround fixes the issue.
I modified the original version of the workaround to meet mainline
code style.

[0] https://bugzilla.kernel.org/show_bug.cgi?id=209839

Fixes: f1bce4ad2f1c ("r8169: add support for RTL8125")
Tested-by: xplo <xplo.bn@gmail.com>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 64 ++++++++++++++++++++---
 1 file changed, 58 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index fb67d8f79..90052033b 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -28,6 +28,7 @@
 #include <linux/bitfield.h>
 #include <linux/prefetch.h>
 #include <linux/ipv6.h>
+#include <linux/ptp_classify.h>
 #include <asm/unaligned.h>
 #include <net/ip6_checksum.h>
 
@@ -4007,17 +4008,64 @@ static int rtl8169_xmit_frags(struct rtl8169_private *tp, struct sk_buff *skb,
 	return -EIO;
 }
 
-static bool rtl_test_hw_pad_bug(struct rtl8169_private *tp)
+static bool rtl_skb_is_udp(struct sk_buff *skb)
 {
+	switch (vlan_get_protocol(skb)) {
+	case htons(ETH_P_IP):
+		return ip_hdr(skb)->protocol == IPPROTO_UDP;
+	case htons(ETH_P_IPV6):
+		return ipv6_hdr(skb)->nexthdr == IPPROTO_UDP;
+	default:
+		return false;
+	}
+}
+
+#define RTL_MIN_PATCH_LEN	47
+#define PTP_GEN_PORT		320
+
+/* see rtl8125_get_patch_pad_len() in r8125 vendor driver */
+static unsigned int rtl8125_quirk_udp_padto(struct rtl8169_private *tp,
+					    struct sk_buff *skb)
+{
+	unsigned int padto = 0, len = skb->len;
+
+	if (rtl_is_8125(tp) && len < 175 && rtl_skb_is_udp(skb) &&
+	    skb_transport_header_was_set(skb)) {
+		unsigned int trans_data_len = skb_tail_pointer(skb) -
+					      skb_transport_header(skb);
+
+		if (trans_data_len > 3 && trans_data_len < RTL_MIN_PATCH_LEN) {
+			u16 dest = ntohs(udp_hdr(skb)->dest);
+
+			if (dest == PTP_EV_PORT || dest == PTP_GEN_PORT)
+				padto = len + RTL_MIN_PATCH_LEN - trans_data_len;
+		}
+
+		if (trans_data_len < UDP_HLEN)
+			padto = max(padto, len + UDP_HLEN - trans_data_len);
+	}
+
+	return padto;
+}
+
+static unsigned int rtl_quirk_packet_padto(struct rtl8169_private *tp,
+					   struct sk_buff *skb)
+{
+	unsigned int padto;
+
+	padto = rtl8125_quirk_udp_padto(tp, skb);
+
 	switch (tp->mac_version) {
 	case RTL_GIGA_MAC_VER_34:
 	case RTL_GIGA_MAC_VER_60:
 	case RTL_GIGA_MAC_VER_61:
 	case RTL_GIGA_MAC_VER_63:
-		return true;
+		padto = max_t(unsigned int, padto, ETH_ZLEN);
 	default:
-		return false;
+		break;
 	}
+
+	return padto;
 }
 
 static void rtl8169_tso_csum_v1(struct sk_buff *skb, u32 *opts)
@@ -4089,9 +4137,10 @@ static bool rtl8169_tso_csum_v2(struct rtl8169_private *tp,
 
 		opts[1] |= transport_offset << TCPHO_SHIFT;
 	} else {
-		if (unlikely(skb->len < ETH_ZLEN && rtl_test_hw_pad_bug(tp)))
-			/* eth_skb_pad would free the skb on error */
-			return !__skb_put_padto(skb, ETH_ZLEN, false);
+		unsigned int padto = rtl_quirk_packet_padto(tp, skb);
+
+		/* skb_padto would free the skb on error */
+		return !__skb_put_padto(skb, padto, false);
 	}
 
 	return true;
@@ -4268,6 +4317,9 @@ static netdev_features_t rtl8169_features_check(struct sk_buff *skb,
 		if (skb->len < ETH_ZLEN)
 			features &= ~NETIF_F_CSUM_MASK;
 
+		if (rtl_quirk_packet_padto(tp, skb))
+			features &= ~NETIF_F_CSUM_MASK;
+
 		if (transport_offset > TCPHO_MAX &&
 		    rtl_chip_supports_csum_v2(tp))
 			features &= ~NETIF_F_CSUM_MASK;
-- 
2.30.0

