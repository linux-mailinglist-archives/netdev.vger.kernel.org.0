Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63E841AF518
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 23:11:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728134AbgDRVLy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 17:11:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726014AbgDRVLu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Apr 2020 17:11:50 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D19F7C061A0C
        for <netdev@vger.kernel.org>; Sat, 18 Apr 2020 14:11:49 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id k1so7283332wrx.4
        for <netdev@vger.kernel.org>; Sat, 18 Apr 2020 14:11:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DT1QEYOu5YK/RKkatYhiwNxOlaA/RyTK0Yjx0E6mkyo=;
        b=bDaQcFvCngICsZ4NFILyK87XAUaBfpYsngRSAVDIPwSh+IMmgrGMZ2+Jsrhzm7OC4T
         h82eOWWDsATMq/9caDjzyHmrIGI22MVM2SIlXwxOpARfHDBlkM6qODPlWFUsgLzZMP8f
         zTOcsZQHjNcnOg4zUvUhZDc40zgCv3+BeU+1PjHP0StvLN7Uzqmvy3/MImjPjK4sKcrU
         GJX3o9PvKcojIDnozGiz1D2NVnnc4FByF7OtbS5jzBtkbfJdnbCr/0wmQcKZPj96fDBn
         ifltAMF1xi/ifGFtORfpsNq5Kk6pQdZ7U03NALTuKSyjFNBF8sJL5XCxbwQKw8fuiskt
         cTiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DT1QEYOu5YK/RKkatYhiwNxOlaA/RyTK0Yjx0E6mkyo=;
        b=Rk/GFPS78Vu55PFDt6guTrbdEVklwnqWQBG+0vSuyDDM72dmoYNpPFjB3MWimVUx5U
         VfgVHnDDaXSxR0GOc4XNm8Gdpb8pbzLuFBt0g5zEaPMA3umnFmR00Lxu6mHSMGlkVpRP
         P6tPbe7hHMUVYW8rLHcflWy4Bs8k/zAKmqw+rPVTt6Z83lNHirarc0mx4GaNRF7Uvze5
         7+FVV1lHTNollgb83nSZSc4EHAleyUpKnCBRZP/ovuFCn6ML7RzednfXy+xljRAtsmIX
         g+VPJ7ru08yf3yoJQXLlSclfd0mqlrP9aF2Br+b7K0zud1vZgYX0wl15eJAZN+1NjmRb
         9uHA==
X-Gm-Message-State: AGi0Pub0LmwfAH9C7KLjDPeRw0eduNVUKe7Uvt6BG6xpOzNlQdb6usnH
        TbujcY8SeQ3Zoepb6bW0+YGT2xyR
X-Google-Smtp-Source: APiQypINoct+MZmuu8nrZ1fYEaJ0rLrp1wbi2jZDucMit1JDQy969gWbeoc8PedfmSONhxRRw2MkzQ==
X-Received: by 2002:adf:f282:: with SMTP id k2mr10215559wro.133.1587244308405;
        Sat, 18 Apr 2020 14:11:48 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:939:e10c:14c5:fe9f? (p200300EA8F2960000939E10C14C5FE9F.dip0.t-ipconnect.de. [2003:ea:8f29:6000:939:e10c:14c5:fe9f])
        by smtp.googlemail.com with ESMTPSA id a20sm15484036wra.26.2020.04.18.14.11.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Apr 2020 14:11:48 -0700 (PDT)
Subject: [PATCH net-next 6/6] r8169: add workaround for RTL8168evl TSO hw
 issues
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <f7c53dc0-768c-7eb9-ffc0-b2e39b1ddfa4@gmail.com>
Message-ID: <d1efe35c-3755-8981-cfe7-0ebfa4babc30@gmail.com>
Date:   Sat, 18 Apr 2020 23:11:32 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <f7c53dc0-768c-7eb9-ffc0-b2e39b1ddfa4@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add workaround for hw issues with TSO on RTL8168evl. This workaround is
based on information I got from Realtek, and *should* allow to safely
enable TSO on this chip version.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 34 +++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index c7d9325f4..1bc415d00 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4304,6 +4304,37 @@ static netdev_tx_t rtl8169_start_xmit(struct sk_buff *skb,
 	return NETDEV_TX_BUSY;
 }
 
+static unsigned int rtl_last_frag_len(struct sk_buff *skb)
+{
+	struct skb_shared_info *info = skb_shinfo(skb);
+	unsigned int nr_frags = info->nr_frags;
+
+	if (!nr_frags)
+		return UINT_MAX;
+
+	return skb_frag_size(info->frags + nr_frags - 1);
+}
+
+/* Workaround for hw issues with TSO on RTL8168evl */
+static netdev_features_t rtl8168evl_fix_tso(struct sk_buff *skb,
+					    netdev_features_t features)
+{
+	/* IPv4 header has options field */
+	if (vlan_get_protocol(skb) == htons(ETH_P_IP) &&
+	    ip_hdrlen(skb) > sizeof(struct iphdr))
+		features &= ~NETIF_F_ALL_TSO;
+
+	/* IPv4 TCP header has options field */
+	else if (skb_shinfo(skb)->gso_type & SKB_GSO_TCPV4 &&
+		 tcp_hdrlen(skb) > sizeof(struct tcphdr))
+		features &= ~NETIF_F_ALL_TSO;
+
+	else if (rtl_last_frag_len(skb) <= 6)
+		features &= ~NETIF_F_ALL_TSO;
+
+	return features;
+}
+
 static netdev_features_t rtl8169_features_check(struct sk_buff *skb,
 						struct net_device *dev,
 						netdev_features_t features)
@@ -4312,6 +4343,9 @@ static netdev_features_t rtl8169_features_check(struct sk_buff *skb,
 	struct rtl8169_private *tp = netdev_priv(dev);
 
 	if (skb_is_gso(skb)) {
+		if (tp->mac_version == RTL_GIGA_MAC_VER_34)
+			features = rtl8168evl_fix_tso(skb, features);
+
 		if (transport_offset > GTTCPHO_MAX &&
 		    rtl_chip_supports_csum_v2(tp))
 			features &= ~NETIF_F_ALL_TSO;
-- 
2.26.1


