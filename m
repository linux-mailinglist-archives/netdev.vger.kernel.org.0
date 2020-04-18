Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83B371AF516
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 23:11:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728259AbgDRVLv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 17:11:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728228AbgDRVLs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Apr 2020 17:11:48 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13D0DC061A0F
        for <netdev@vger.kernel.org>; Sat, 18 Apr 2020 14:11:48 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id v8so7615741wma.0
        for <netdev@vger.kernel.org>; Sat, 18 Apr 2020 14:11:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xlnkouHUp6gHoKxyK0YDwBi2RvT79b8CsXIyAxDPz4A=;
        b=QuEQrWlFfKfBdf6b+F4bgka3dwuw/73XszuZIQO483t5zeyj7V1Fih+rwl4n4vDBif
         LTqYnerkwTc0MJHD7X/Y0YRNiT0NgIhiGRyNBHNe/Ijrnr4f7VSbm35Ad9NwTIgktZ/4
         9FqvJCj+OB89+1MP4WXmivrgyTnuuB1EVq9N/AdZa0HQj8giNxU5flyuJjgEIIIfsxtL
         cQuvlK/M8FEQxIzTKj0pXBgfkHnWOszK6XcoSzxieQf8UTEGo80Ev5TTOzC9rFUyeTGr
         22KBqlNUs2I1DbOknIRZXYeNS4FbSHk09WBIDTlh8LBfYncec6Z4JU/spQ1M/TyW1WC2
         +fKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xlnkouHUp6gHoKxyK0YDwBi2RvT79b8CsXIyAxDPz4A=;
        b=mBq18dwbrRPHGIixGwHglNINnonUaxfCkKLS+64IUVPIwybXXacGhmFka5tYFhIk1z
         RECzqljCzP1V89jfKAD8c34Si1xINQ7vvMfIOcurDxSJkjLl9106mhvCn6oBG1WP6D0S
         gDWI5AvDsBRXPtVX3tU7OiNrIkIwBt59juKicMWvPWaaKbHip+O7laQSJA/YsoiFieu7
         eHPWr9ZOPjGqw2imEliKDeKBFnYIPYhj/384niEq55Wnteq9NAgLqZ6zd7Ed81SnVk0K
         mBEWglR2IuItZZ8kRVPnEeSdVNxHizb1Zba9amoLjm1i3AOI2uBjS2k8XWCX3b+nPynY
         R2gg==
X-Gm-Message-State: AGi0PuarqCAY2oK86Kvt4QHPKOOKibouNufqe8HbabeIIRMb6YQ1ugkd
        nbR8a3VVjKnJdmEk0ungccCmzUsK
X-Google-Smtp-Source: APiQypJTIwR0UjtyCAi9tv4Xu5f9zner8pHDVXKJ6pk3hPtdSKKXXFnKlzdB4THsLvrcVXn87MmdZg==
X-Received: by 2002:a1c:9a16:: with SMTP id c22mr8407828wme.38.1587244306611;
        Sat, 18 Apr 2020 14:11:46 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:939:e10c:14c5:fe9f? (p200300EA8F2960000939E10C14C5FE9F.dip0.t-ipconnect.de. [2003:ea:8f29:6000:939:e10c:14c5:fe9f])
        by smtp.googlemail.com with ESMTPSA id j17sm1058178wrb.46.2020.04.18.14.11.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Apr 2020 14:11:46 -0700 (PDT)
Subject: [PATCH net-next 4/6] r8169: use rtl8169_set_features in
 rtl8169_init_one
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <f7c53dc0-768c-7eb9-ffc0-b2e39b1ddfa4@gmail.com>
Message-ID: <bdc71403-08ba-669e-5e91-989eb886ff28@gmail.com>
Date:   Sat, 18 Apr 2020 23:10:03 +0200
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

At that place in rtl_init_one() we can safely use rtl8169_set_features()
to configure the chip according to the default features.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index af10b6398..e4bb6f36c 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -5444,10 +5444,6 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	dev->vlan_features = NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_TSO;
 	dev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
 
-	tp->cp_cmd |= RxChkSum;
-	/* RTL8125 uses register RxConfig for VLAN offloading config */
-	if (!rtl_is_8125(tp))
-		tp->cp_cmd |= RxVlan;
 	/*
 	 * Pretend we are using VLANs; This bypasses a nasty bug where
 	 * Interrupts stop flowing on high load on 8110SCd controllers.
@@ -5479,6 +5475,9 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	dev->hw_features |= NETIF_F_RXALL;
 	dev->hw_features |= NETIF_F_RXFCS;
 
+	/* configure chip for default features */
+	rtl8169_set_features(dev, dev->features);
+
 	jumbo_max = rtl_jumbo_max(tp);
 	if (jumbo_max)
 		dev->max_mtu = jumbo_max;
-- 
2.26.1


