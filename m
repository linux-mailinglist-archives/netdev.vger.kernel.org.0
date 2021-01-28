Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4692E30703B
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 08:54:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232071AbhA1HrL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 02:47:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231725AbhA1HpD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 02:45:03 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0D1BC061574
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 23:44:21 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id c127so3756246wmf.5
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 23:44:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=/VnqiCXJZXBFW0o8txAnlwyH0y8yYe2b43JYCNwk41Y=;
        b=Cv8YVqfKsxgcXndKw/GjoKqLS4T+9bsPxgZ1I/zUXuFKrJm9g3E7gaoewE0Nnz4YCu
         WOdUQ23T821dsoakXElNOJrB79H7aA7NYV8vGFdFJJE2jOBAKKES0dZ8t4wLuHwA31AU
         U2PEx+N4M2TMGcmugJQ6pO0w1TcE0eT7eO8LCe2IhP3u5+sfUB7OsPD08nY0YoKm2TNJ
         c2npH+MrKeQ+MZysEV+q37tfzaP1JuIn42VBL4pO8g8vBRy5t1fAOSgMgZeYlj7n8u2K
         NWl1hqKMynvYKOYnUIIKFQmuoSiaWTYE8/P7tqVl3wOQJbQyt8vQAvZST/05c+G9Ajzv
         UU8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=/VnqiCXJZXBFW0o8txAnlwyH0y8yYe2b43JYCNwk41Y=;
        b=G2mLpM4IpjwBGfN1EFiBIPQ42mnVsO8sfKfEP7VSwAIqMlQTBhk0mZk/i4DZMQ1wqc
         ucv/meLLeSuVGcy0BPeg0UjUAKbkBIw7QXPkOe3wVAl9/DA9LBD+EjhNH2WVoBYynqqd
         c+tlX7e7XzyZI5aaE6iLoaCeyw9hMHTsP3ypmQIgFkeAzBUCVGOmmetHRLr7wzXfwOEo
         ncuX5nSqUplgCWvSTVII3YDS6wnY0w6QHV6KQjXKUWHeAZnH3ybsVqUUWUsF3+fIWI+i
         3Mfm6BmzMoObu7DTM9lrs+HbG8muKt+yrccT0QJH1LdV3cA5j/KETRZ05DVEt2lgYomg
         /mJw==
X-Gm-Message-State: AOAM531GsD95p6dhGW4trOX7U1aEkebpe774KTWS9RTGt5H+DgyW2zfw
        zOuzzqKmZxhqdySL3wFqug83SU4nFiU=
X-Google-Smtp-Source: ABdhPJwHsjoZFeLZwBUTOztHLMQjlDzM4Vp83Iq/9E4eUbkVCIrBtrRAYlqSFB7fh39VNjXVUJF4zA==
X-Received: by 2002:a7b:c188:: with SMTP id y8mr7127928wmi.173.1611819860570;
        Wed, 27 Jan 2021 23:44:20 -0800 (PST)
Received: from ?IPv6:2003:ea:8f1f:ad00:cd65:6d53:f337:be79? (p200300ea8f1fad00cd656d53f337be79.dip0.t-ipconnect.de. [2003:ea:8f1f:ad00:cd65:6d53:f337:be79])
        by smtp.googlemail.com with ESMTPSA id j4sm5697987wru.20.2021.01.27.23.44.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Jan 2021 23:44:20 -0800 (PST)
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: [PATCH v3 net] r8169: work around RTL8125 UDP hw bug
Message-ID: <c8dcb440-a2f5-0ff5-c4a7-854dc655151b@gmail.com>
Date:   Thu, 28 Jan 2021 08:44:12 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
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

v2:
- rebased to net
v3:
- make rtl_skb_is_udp() more robust and use skb_header_pointer()
  to access the ip(v6) header

Fixes: f1bce4ad2f1c ("r8169: add support for RTL8125")
Tested-by: xplo <xplo.bn@gmail.com>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 70 +++++++++++++++++++++--
 1 file changed, 64 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index a569abe7f..457fa1404 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -28,6 +28,7 @@
 #include <linux/bitfield.h>
 #include <linux/prefetch.h>
 #include <linux/ipv6.h>
+#include <linux/ptp_classify.h>
 #include <net/ip6_checksum.h>
 
 #include "r8169.h"
@@ -4046,17 +4047,70 @@ static int rtl8169_xmit_frags(struct rtl8169_private *tp, struct sk_buff *skb,
 	return -EIO;
 }
 
-static bool rtl_test_hw_pad_bug(struct rtl8169_private *tp)
+static bool rtl_skb_is_udp(struct sk_buff *skb)
 {
+	int no = skb_network_offset(skb);
+	struct ipv6hdr *i6h, _i6h;
+	struct iphdr *ih, _ih;
+
+	switch (vlan_get_protocol(skb)) {
+	case htons(ETH_P_IP):
+		ih = skb_header_pointer(skb, no, sizeof(_ih), &_ih);
+		return ih && ih->protocol == IPPROTO_UDP;
+	case htons(ETH_P_IPV6):
+		i6h = skb_header_pointer(skb, no, sizeof(_i6h), &_i6h);
+		return i6h && i6h->nexthdr == IPPROTO_UDP;
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
+	if (rtl_is_8125(tp) && len < 128 + RTL_MIN_PATCH_LEN &&
+	    rtl_skb_is_udp(skb) && skb_transport_header_was_set(skb)) {
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
@@ -4128,9 +4182,10 @@ static bool rtl8169_tso_csum_v2(struct rtl8169_private *tp,
 
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
@@ -4307,6 +4362,9 @@ static netdev_features_t rtl8169_features_check(struct sk_buff *skb,
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

