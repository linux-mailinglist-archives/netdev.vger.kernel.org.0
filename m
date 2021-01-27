Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62DBC30537F
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 07:52:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231737AbhA0Guj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 01:50:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231281AbhA0GrK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 01:47:10 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60C00C0613ED
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 22:46:30 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id v15so738779wrx.4
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 22:46:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=A/7d7YSuSp8J0hMlcyCOBp4xKTPYSVpfVld8DVd8XwA=;
        b=UgEQQQdalfvX65QzJIQpFYGEE2zbk5BTePXRGLCQgD3Q4uHEoBVS8Jpz4d+TBtYDYm
         AJyy/1PAxE5CQZ5szqfZSD4/Ww5qWXv/vpR0GRd+rDRvug64dRccE3ATKOqJ9+9ILTtr
         uyeIq/0Jg4jd2mKTJHEDXGj70UfaJsRa7akYhcEdhM7RA6F8D+hMtyW0MOa+GSZym5Sm
         CbLuSMhf5zd6GUDwh+zi85jMYVn8NrnBfUVTIVfFwjm0tbXMirrijhfk8PZaCH0Tru0o
         3KZItBocyBPYqG0BHP24IFhwHCJa8+jAvKqov4giX0riELI9bVpf7AZwQKG7+3Z/fP9N
         qJUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=A/7d7YSuSp8J0hMlcyCOBp4xKTPYSVpfVld8DVd8XwA=;
        b=pRqZbNSAS3Vf02l8bHCIQBzdoH55z/e4ATRBqRNzloW5F+kZitaQIQU+cZrPey1VYA
         cOY4wnqaJGpXuwubn89l+F6B7/VoF6ZJChZc47kIqitInRwcaTaxusSbxlDJ6HQXeL+4
         c8ivqLkJ+lJQKF22lcb2V/B4O45a3pcBiCTXy3yFZg5BDs5HHu9S5yPYrGLo90YgQMXL
         Aq7Cr3VIQQI16pzpfKPuNcPjjFqjreLjLBjFZguMl4Bc3D6+Dj7tMSYoWoGGUSSVbRlc
         b7qB6QmoD3+Da89fVStZhEn1aJRPepffaQ30KcjjQrHcnv0LOmNbrVsT6te1ynRIU86z
         j4hQ==
X-Gm-Message-State: AOAM532CWBmf2VLWYI8kKS7oxXoWpzvOJixKkqKVz0qAqqDa3LFOQoe8
        Tdntr/B3FNZ6IZPqerV3CF+2AaSo2GQ=
X-Google-Smtp-Source: ABdhPJzYoO639mSPpHoOv8b3zpXPyeTgivIKiqz19CgC2ttVwmZ3kww9lZDP4QO2JB7FUWJc1G03PA==
X-Received: by 2002:adf:ffce:: with SMTP id x14mr9869150wrs.390.1611729988948;
        Tue, 26 Jan 2021 22:46:28 -0800 (PST)
Received: from ?IPv6:2003:ea:8f1f:ad00:b9df:6985:25af:fab5? (p200300ea8f1fad00b9df698525affab5.dip0.t-ipconnect.de. [2003:ea:8f1f:ad00:b9df:6985:25af:fab5])
        by smtp.googlemail.com with ESMTPSA id n16sm1539900wrj.26.2021.01.26.22.46.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jan 2021 22:46:28 -0800 (PST)
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH v2 net] r8169: work around RTL8125 UDP hw bug
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Message-ID: <f41cd049-4341-70bc-e1bb-453f9e44a892@gmail.com>
Date:   Wed, 27 Jan 2021 07:46:09 +0100
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
v2:
- rebased to net
---
 drivers/net/ethernet/realtek/r8169_main.c | 64 ++++++++++++++++++++---
 1 file changed, 58 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index a569abe7f..886406349 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -28,6 +28,7 @@
 #include <linux/bitfield.h>
 #include <linux/prefetch.h>
 #include <linux/ipv6.h>
+#include <linux/ptp_classify.h>
 #include <net/ip6_checksum.h>
 
 #include "r8169.h"
@@ -4046,17 +4047,64 @@ static int rtl8169_xmit_frags(struct rtl8169_private *tp, struct sk_buff *skb,
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
@@ -4128,9 +4176,10 @@ static bool rtl8169_tso_csum_v2(struct rtl8169_private *tp,
 
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
@@ -4307,6 +4356,9 @@ static netdev_features_t rtl8169_features_check(struct sk_buff *skb,
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

