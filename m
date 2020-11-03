Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0A072A4D7F
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 18:52:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728809AbgKCRwZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 12:52:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728690AbgKCRwZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 12:52:25 -0500
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDDD0C0613D1
        for <netdev@vger.kernel.org>; Tue,  3 Nov 2020 09:52:24 -0800 (PST)
Received: by mail-wm1-x343.google.com with SMTP id h62so162070wme.3
        for <netdev@vger.kernel.org>; Tue, 03 Nov 2020 09:52:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=e+0jR+QQ65f9mmp7Mm7WjlSL4O1pCjuDPMTZwyibTBk=;
        b=NV8tNuh59p8lOW2Dg2wtHt9VxTG1FGD6FzA72vIKA+/HO0VTqzkwobiTh+7fd91j0s
         SozwVoz9oO+Yr3GFZAsL95ehaiG6Vr9lot1tCuVZlElfUUuDM3j5UCailpDnBEm36tgG
         W0FWGqXHsPsfKmpUTz6eMJdjQN0kgrb4goq5Mo2B7+cNHg5JurIvYE2yrHlvbPlXkUKo
         Luz59OY4DZ6FB/DGipAe5fsjWXMXDMB7dcXLPQ6AqPhmxozE737KuWorHYmmx+1WZ7CO
         1wOEkjnkAhkCx6EeqaSlkpvdqg+lUSyWV088AtFZBTn/15ymC+WqJuor7jAiOrIPvljj
         nZzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=e+0jR+QQ65f9mmp7Mm7WjlSL4O1pCjuDPMTZwyibTBk=;
        b=qyLsHx1zqg4EZ4jR8eR/o8qSa8gIzSiSUL8WiQ1XEeKtOmFmiyjS+NWhD9FpCBXutb
         B0EUzpvNHgSLn0+/uRht8smLYm4D/lua2ISjPxgmGL8Xfr2P4A83Jtkuhvt8Lcl0xu9G
         gv/YNXwvifMhvX8TjV8Vit75SOjHpheF25zrDdqaW0gnvLFU/vC7NyrGQ/msYOQPXTEd
         3vyifI3KCB0uvf/PB2ri8fEi+u46rJmIJdK88RMST0ZzJC4aabzx/Pdr4RpDRFt2EcrI
         GuF0456m7B97yxofRDjg2QUvY+fmlr+NPJPVon67smAb1iCBhWQ5wAokkn6lz/OU2XVG
         Jw9g==
X-Gm-Message-State: AOAM533MBLQ4jK5Ou3gLSsJB14Ycx79hK8CYrOLvfjyGZJ6klaNCp5mF
        JPJ4gIsT4IaLJdCIAO1UNLOGLav4nUjGNA==
X-Google-Smtp-Source: ABdhPJwXj+1PUnFo5XpWZX2bZkK5YaXUqVTwdYVyNgC0gMzxxYCEZ1IaBFa7pMAdLh8jB4tSZZITHQ==
X-Received: by 2002:a1c:bdc4:: with SMTP id n187mr295492wmf.185.1604425943621;
        Tue, 03 Nov 2020 09:52:23 -0800 (PST)
Received: from ?IPv6:2003:ea:8f23:2800:a5f9:d289:8ac7:4785? (p200300ea8f232800a5f9d2898ac74785.dip0.t-ipconnect.de. [2003:ea:8f23:2800:a5f9:d289:8ac7:4785])
        by smtp.googlemail.com with ESMTPSA id u195sm3753387wmu.18.2020.11.03.09.52.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Nov 2020 09:52:23 -0800 (PST)
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Maxim Plotnikov <wgh@torlan.ru>
Subject: [PATCH net] r8169: work around short packet hw bug on RTL8125
Message-ID: <8002c31a-60b9-58f1-f0dd-8fd07239917f@gmail.com>
Date:   Tue, 3 Nov 2020 18:52:18 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Network problems with RTL8125B have been reported [0] and with help
from Realtek it turned out that this chip version has a hw problem
with short packets (similar to RTL8168evl). Having said that activate
the same workaround as for RTL8168evl.
Realtek suggested to activate the workaround for RTL8125A too, even
though they're not 100% sure yet which RTL8125 versions are affected.

[0] https://bugzilla.kernel.org/show_bug.cgi?id=209839

Fixes: 0439297be951 ("r8169: add support for RTL8125B")
Reported-by: Maxim Plotnikov <wgh@torlan.ru>
Tested-by: Maxim Plotnikov <wgh@torlan.ru>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 7e0947e29..07d197141 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4051,9 +4051,17 @@ static int rtl8169_xmit_frags(struct rtl8169_private *tp, struct sk_buff *skb,
 	return -EIO;
 }
 
-static bool rtl_test_hw_pad_bug(struct rtl8169_private *tp, struct sk_buff *skb)
+static bool rtl_test_hw_pad_bug(struct rtl8169_private *tp)
 {
-	return skb->len < ETH_ZLEN && tp->mac_version == RTL_GIGA_MAC_VER_34;
+	switch (tp->mac_version) {
+	case RTL_GIGA_MAC_VER_34:
+	case RTL_GIGA_MAC_VER_60:
+	case RTL_GIGA_MAC_VER_61:
+	case RTL_GIGA_MAC_VER_63:
+		return true;
+	default:
+		return false;
+	}
 }
 
 static void rtl8169_tso_csum_v1(struct sk_buff *skb, u32 *opts)
@@ -4125,7 +4133,7 @@ static bool rtl8169_tso_csum_v2(struct rtl8169_private *tp,
 
 		opts[1] |= transport_offset << TCPHO_SHIFT;
 	} else {
-		if (unlikely(rtl_test_hw_pad_bug(tp, skb)))
+		if (unlikely(skb->len < ETH_ZLEN && rtl_test_hw_pad_bug(tp)))
 			return !eth_skb_pad(skb);
 	}
 
-- 
2.29.2


