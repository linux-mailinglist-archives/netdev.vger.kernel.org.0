Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B7AB1E941D
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 00:00:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729412AbgE3WA0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 18:00:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729394AbgE3WAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 May 2020 18:00:22 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61F6BC03E969
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 15:00:22 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id j10so7655561wrw.8
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 15:00:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HVsMpGoGIHGR133lf3XM6reFNWpHA57wOr0SnKR8xrs=;
        b=VaIHU7wkiGFwl9KR7hjnFcuJ4jo8Q9XKGokgwiHIxJ5qBgn6Bx4/2f7fYbG8CO1T0n
         ex1SlE9KXFSK4SMMnlqlkpqM+pFPt+LyLyeWmm/TMWNZkBrzBm7iCtwYiimjocvOmu/x
         cNWx8LR6OJednJgVKbPe3VVXUsm+Z5VYnFiByFO5CfqDvuCSLxVdp8cuqJXAHZfjAtCm
         olCEKp/zh+AzOElG/8JJ/VySSuFKlTKJBQZ3UmhihgQh/lVkPwSGTYyEKsl5KopmTvST
         shUfRo1qP3OyULMCa3gQG9tTYEVTWDBqV/ysRhl3z4YVoo2ZvaRdmYvtavqXZi7cNIjN
         Wv/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HVsMpGoGIHGR133lf3XM6reFNWpHA57wOr0SnKR8xrs=;
        b=Us8NtVqv301kZ8A+nEQ0XOkwt8OAGNf5k9Vv/zu1QM5Ewls0nHKtX+kP0eFXppBNn1
         eLmSY+7cify2uQVwUkLH5KXABvdW5UQbPrE17Tl9DifjkSQUdB/ZKADF8bSbzo+uvUx4
         aujDSjQ6tQkujeYtI1PeRXPOCsozs68HEsjyenLfgHwrTGwfXWmTAd1mI4NkmZCR+ufd
         t8dQ6cEAvCy1Nx5blUjhEwUY4Lls4kchxnYH9UimRne63EXy6aPx7Aojz0wBDAjB1Xj4
         MF8Kp+9VzF1YqZYKWAi/bUaHl14DdUQ0danCbqTpwpqlqAzSBUfoDrCAWTOPlQIQWoIb
         2zXQ==
X-Gm-Message-State: AOAM532mMLYHIzMKU1t9XAm704o577+zjCUvmjB+8vh+jhRQTMLNa0vL
        ayJAzwXmptETEx5XTv3Rx34gYc3e
X-Google-Smtp-Source: ABdhPJxqsbBE5XNAXTY83kKVn8H3wsqGL48x/Bjvip664l4jwH8fYKAy4Wm4xb7zHZLa6RS6Xy5gow==
X-Received: by 2002:adf:ed01:: with SMTP id a1mr16109763wro.271.1590876020826;
        Sat, 30 May 2020 15:00:20 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:5700:8c73:80e5:b6ba:d8b0? (p200300ea8f2357008c7380e5b6bad8b0.dip0.t-ipconnect.de. [2003:ea:8f23:5700:8c73:80e5:b6ba:d8b0])
        by smtp.googlemail.com with ESMTPSA id o15sm5561161wmm.31.2020.05.30.15.00.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 May 2020 15:00:20 -0700 (PDT)
Subject: [PATCH net-next 5/6] r8169: make rtl8169_down central chip quiesce
 function
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <443c14ac-24b8-58ba-05aa-3803f1e5f4ab@gmail.com>
Message-ID: <9acbefbd-1542-c1b5-14ae-8a98eb5d8390@gmail.com>
Date:   Sat, 30 May 2020 23:58:35 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <443c14ac-24b8-58ba-05aa-3803f1e5f4ab@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Functionality for quiescing the chip is spread across different
functions currently. Move it to rtl8169_down().

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 33 ++++++++---------------
 1 file changed, 11 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 5f3c50fb0..fd93377f9 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4627,20 +4627,21 @@ static int r8169_phy_connect(struct rtl8169_private *tp)
 	return 0;
 }
 
-static void rtl8169_down(struct net_device *dev)
+static void rtl8169_down(struct rtl8169_private *tp)
 {
-	struct rtl8169_private *tp = netdev_priv(dev);
+	rtl_lock_work(tp);
 
-	phy_stop(tp->phydev);
+	/* Clear all task flags */
+	bitmap_zero(tp->wk.flags, RTL_FLAG_MAX);
 
+	phy_stop(tp->phydev);
 	napi_disable(&tp->napi);
-	netif_stop_queue(dev);
 
 	rtl8169_hw_reset(tp);
 
-	rtl8169_rx_clear(tp);
-
 	rtl_pll_power_down(tp);
+
+	rtl_unlock_work(tp);
 }
 
 static int rtl8169_close(struct net_device *dev)
@@ -4653,12 +4654,9 @@ static int rtl8169_close(struct net_device *dev)
 	/* Update counters before going down */
 	rtl8169_update_counters(tp);
 
-	rtl_lock_work(tp);
-	/* Clear all task flags */
-	bitmap_zero(tp->wk.flags, RTL_FLAG_MAX);
-
-	rtl8169_down(dev);
-	rtl_unlock_work(tp);
+	netif_stop_queue(dev);
+	rtl8169_down(tp);
+	rtl8169_rx_clear(tp);
 
 	cancel_work_sync(&tp->wk.work);
 
@@ -4817,17 +4815,8 @@ static void rtl8169_net_suspend(struct rtl8169_private *tp)
 	if (!netif_running(tp->dev))
 		return;
 
-	phy_stop(tp->phydev);
 	netif_device_detach(tp->dev);
-
-	rtl_lock_work(tp);
-	napi_disable(&tp->napi);
-	/* Clear all task flags */
-	bitmap_zero(tp->wk.flags, RTL_FLAG_MAX);
-
-	rtl_unlock_work(tp);
-
-	rtl_pll_power_down(tp);
+	rtl8169_down(tp);
 }
 
 #ifdef CONFIG_PM
-- 
2.26.2


