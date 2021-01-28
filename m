Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12DE43080E4
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 23:03:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231546AbhA1WCn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 17:02:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231425AbhA1WCm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 17:02:42 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6123FC061573
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 14:02:02 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id d16so6893063wro.11
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 14:02:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=d7l7YxeKqaUJbq32cHS9rjSkzi/dqxPe1LAyjpqlT3A=;
        b=OhY3sFcmJyrTEwgQriECcLDWB4RktSViuC7dSw7neGnWw9FVRjg3tjUROPYtnyzLsC
         9BJ3fHR/TiXmrXLqZyMKJsd2Wc67ToDaC9RXA9z2ixAI0wCiamCkG5hyjp9QICtgeYOK
         3Sy2jUtsoqnLyPWPSAP8+UbfbKGKJ9D07asqmL+5q/J+i/CT+HGCP9SZF2e1iv7PKFHA
         xd/k6oJbxQ+MxkK1YjeAusogi2b8cdbci2yNqUY3J6n9CUPwZEOhfx34r8f9BRQLZPMN
         o4A68HgeU2tNESeKgawlcFmGZtGRyfvB5eAbSN4XOnJv6ny4R8r5fbYMWyQQmQBmTx+9
         5YeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=d7l7YxeKqaUJbq32cHS9rjSkzi/dqxPe1LAyjpqlT3A=;
        b=r5MpUa1dxGiYk5WAXdLjaSUOyF+dQuPjL5yhD4PQniJ5qHYFOZ7dwt6ZWXmlpiGLNY
         Cc12aUqy15OuZddRqX0vA3UndcoHO8O03a26epQRyqn+EzrFDDYiczV7mXMPL1OLQ76J
         9Hxaek4Jppy8TBAebdpTbiigdKG0W+MhkqC70WozzRaFLV0/ENZMnymh/rI1rGbik31U
         yWlRzhfLMweFtHG88yi/akmn7sqBkn1Bcsq8HiyyjOqBxjwoXdgskArQW7IK52VyiPK+
         Vw/5T/xEYgjyxV/kbafBEmt3X/Hmi1erKDoYWSqk8R3NgDIQIpyI9dDwTSYCdzQ12+5a
         rLVw==
X-Gm-Message-State: AOAM532CksFHY9oRBD0HeRatuoI+KMlzm7O9sIx1GfQHwp+vq/CCoYYH
        iUqjEZ/aIvh0LtjnuDRl5ZZgOFpYP50=
X-Google-Smtp-Source: ABdhPJzQNP7Tatjyyw44Oh+N6UkKrpeB4UK6GsPmuzevHIX0s04ykwNtEbr/oKqwG440hvgzdvmiBQ==
X-Received: by 2002:a5d:6041:: with SMTP id j1mr1153160wrt.155.1611871321182;
        Thu, 28 Jan 2021 14:02:01 -0800 (PST)
Received: from ?IPv6:2003:ea:8f1f:ad00:e93a:3209:70cb:a1d3? (p200300ea8f1fad00e93a320970cba1d3.dip0.t-ipconnect.de. [2003:ea:8f1f:ad00:e93a:3209:70cb:a1d3])
        by smtp.googlemail.com with ESMTPSA id f13sm3314341wmf.1.2021.01.28.14.01.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jan 2021 14:02:00 -0800 (PST)
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: [PATCH v4 net] r8169: work around RTL8125 UDP hw bug
Message-ID: <6e453d49-1801-e6de-d5f7-d7e6c7526c8f@gmail.com>
Date:   Thu, 28 Jan 2021 23:01:54 +0100
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
v4:
- remove dependency on ptp_classify.h
- replace magic number with offsetof(struct udphdr, len)

Fixes: f1bce4ad2f1c ("r8169: add support for RTL8125")
Tested-by: xplo <xplo.bn@gmail.com>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 71 +++++++++++++++++++++--
 1 file changed, 65 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index a569abe7f..f2269c9f5 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4046,17 +4046,72 @@ static int rtl8169_xmit_frags(struct rtl8169_private *tp, struct sk_buff *skb,
 	return -EIO;
 }
 
-static bool rtl_test_hw_pad_bug(struct rtl8169_private *tp)
+static bool rtl_skb_is_udp(struct sk_buff *skb)
+{
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
+
+/* see rtl8125_get_patch_pad_len() in r8125 vendor driver */
+static unsigned int rtl8125_quirk_udp_padto(struct rtl8169_private *tp,
+					    struct sk_buff *skb)
 {
+	unsigned int padto = 0, len = skb->len;
+
+	if (rtl_is_8125(tp) && len < 128 + RTL_MIN_PATCH_LEN &&
+	    rtl_skb_is_udp(skb) && skb_transport_header_was_set(skb)) {
+		unsigned int trans_data_len = skb_tail_pointer(skb) -
+					      skb_transport_header(skb);
+
+		if (trans_data_len >= offsetof(struct udphdr, len) &&
+		    trans_data_len < RTL_MIN_PATCH_LEN) {
+			u16 dest = ntohs(udp_hdr(skb)->dest);
+
+			/* dest is a standard PTP port */
+			if (dest == 319 || dest == 320)
+				padto = len + RTL_MIN_PATCH_LEN - trans_data_len;
+		}
+
+		if (trans_data_len < sizeof(struct udphdr))
+			padto = max_t(unsigned int, padto,
+				      len + sizeof(struct udphdr) - trans_data_len);
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
@@ -4128,9 +4183,10 @@ static bool rtl8169_tso_csum_v2(struct rtl8169_private *tp,
 
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
@@ -4307,6 +4363,9 @@ static netdev_features_t rtl8169_features_check(struct sk_buff *skb,
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

