Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CB5535711C
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 17:54:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347409AbhDGPyb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 11:54:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353970AbhDGPy0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 11:54:26 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B715C061756
        for <netdev@vger.kernel.org>; Wed,  7 Apr 2021 08:54:12 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id u5-20020a7bcb050000b029010e9316b9d5so1450786wmj.2
        for <netdev@vger.kernel.org>; Wed, 07 Apr 2021 08:54:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=efbz/GwThlVr8RRLmY0y4aySzgCVx2n3UbGV1TUmSjg=;
        b=AdL8tjOKi/4kiORc2IpcNa3nNHvJI/KyVILaal+Gi2fb5J4oJ0iqTtnc6at+f+WmPL
         30p6PviENeQ3BKlwAdLn+2QoF+uJcgHScmbCtSgbUWs2dRsST5K8u1ezSHwGNa0nFNRR
         P7SlNmMjKV7DJ9dROER4FWY4d1DCpRY7O5vLsrz/7yr6XH4e5n8lokFq/mnxKGkkIE9y
         Bj6l9DWrCxek28L1D6tw61k7nEVvoUK4jjObQQPBggkzXO6wOGGUbGNec2+Ba3ClW+iq
         7tJ5v9sX0/NglS5US4fV9KNz7PBrat9+f5J86iij6yaZAoJIg1PnaVK9kSM2UegAKjXA
         +5gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=efbz/GwThlVr8RRLmY0y4aySzgCVx2n3UbGV1TUmSjg=;
        b=KrkspAVotRxKR52NIcMUIhf075t3GhCcwAXVnaCCrO2BmEeLepOCQ/ZII2qFUd0b00
         ldEME2JrU7bHgVXtLv54jKKHlLNMOVhALJObMd7YEZm20XPJBmA+iafp/j/m0vwJ7+2U
         z7ULd6u9Es/MqXKsv8Xc/U75XxjYEj8y9l2VZIrL5GKj51dr6hDE0mRAKfKLXtYLM9R2
         F81kFC0B+t0FdMv4ctLMzumTZnc87LThUZu9L43RxJCDb8ak9ACjnxrkmUU3xUrYPMmE
         pPKEo8PgxR4AORAbIt/HEAznYdlB3uvdurZAvflnyltQZdps9jXglUjHFT37QS948cHL
         6KTA==
X-Gm-Message-State: AOAM531AnMFb7WuqixFJriN+a6FpamhKMMtaruowvmepws/FziNQAqul
        9EGS/Wg4T9o7MbiJ0wBpjCvSGUnkZr4=
X-Google-Smtp-Source: ABdhPJwe9jORt9X+z8ZfOt1ojJ8h5Jw1LHFAiH2uxJ6OD8zrrwHWqsXGmSdyRu5OF9KOanmsIpTQNw==
X-Received: by 2002:a05:600c:35c1:: with SMTP id r1mr3679661wmq.60.1617810850874;
        Wed, 07 Apr 2021 08:54:10 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f38:4600:15f8:68c8:25bd:c1f8? (p200300ea8f38460015f868c825bdc1f8.dip0.t-ipconnect.de. [2003:ea:8f38:4600:15f8:68c8:25bd:c1f8])
        by smtp.googlemail.com with ESMTPSA id x12sm30791143wrr.7.2021.04.07.08.54.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Apr 2021 08:54:10 -0700 (PDT)
Subject: [PATCH net-next 3/3] r8169: use mac-managed PHY PM
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Fugang Duan <fugang.duan@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>
References: <9e695411-ab1d-34fe-8b90-3e8192ab84f6@gmail.com>
Message-ID: <c6d71530-3880-03e7-a5c8-05c078ea68f8@gmail.com>
Date:   Wed, 7 Apr 2021 17:53:52 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <9e695411-ab1d-34fe-8b90-3e8192ab84f6@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the new mac_managed_pm flag to indicate that the driver takes care
of PHY power management.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index a838187b9..eb6da93ac 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4646,6 +4646,7 @@ static void rtl8169_down(struct rtl8169_private *tp)
 static void rtl8169_up(struct rtl8169_private *tp)
 {
 	pci_set_master(tp->pci_dev);
+	phy_init_hw(tp->phydev);
 	phy_resume(tp->phydev);
 	rtl8169_init_phy(tp);
 	napi_enable(&tp->napi);
@@ -5071,6 +5072,8 @@ static int r8169_mdio_register(struct rtl8169_private *tp)
 		return -EUNATCH;
 	}
 
+	tp->phydev->mac_managed_pm = 1;
+
 	/* PHY will be woken up in rtl_open() */
 	phy_suspend(tp->phydev);
 
-- 
2.31.1


