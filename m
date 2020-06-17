Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD4301FD689
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 22:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727061AbgFQU47 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 16:56:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727039AbgFQU4u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 16:56:50 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE32FC0613ED
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 13:56:49 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id c71so3185605wmd.5
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 13:56:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=C5DNTnXnkRtABG/Bftdda+H+IOHqLzkfj0xWc+xS8FM=;
        b=XUaemYpP4vDF+pFcDgC2S5vbpFKszZvJWz4nZQYr1/9pc0i7ubq48MZX12babvEa1P
         0sjV7C5ee+DB63nlNLOKjCHuVCdwO4z3LI3U/LDS7YNd8zQXRnrArxQHfwUx3RhCGbej
         kPdzOKU/lb/VOvJz/dQ9GkJOdYNxEnzUg/V2zZ4Qlkh0wz9B94KupVpdRYFLgPt4wDZ0
         y+eTll49Pt2ddNIv38Y61wMD4CUxZFmJo+SBcIICjDym6w17nS32xN5G6jhRf5fAHoZR
         IDYeK+/dqAmypxidHDmOPIfZLABcdn8Sh8vfMNzqsmDT/7zT3LldgvUNRr84EGLGqExQ
         p4kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=C5DNTnXnkRtABG/Bftdda+H+IOHqLzkfj0xWc+xS8FM=;
        b=fTJCroJWMTYBpJuKRBL2k4lgenuPbRQR/ThRdXJfBUHfl9+DZ1HeveuQq+JgTYQRP5
         HwsN1IvGbraj8m+tyv7KCCmlsMl4GjN6e3Urs3qYMz9TGlkAINFu7H0NWvrFIv/Erpav
         MPSbD0oFCFXY31fxLFiWXGcwZJVj9/FKHyxjuWbL/t5M9IMiGXXzxaRquhwwn+cQiyAs
         yXuqLGSCGSzbWuiHIpoYVaXkbl8ECFyTqa1tPoGFzp/KfmsW7fyeNNa2RyRc/kb6IPxq
         2CTQITPRisI81BNczEm0sKRQEmYEp1Gmtafoc0bkagc9sFHdMmKd7ZOEHPuS41/4r55U
         a48w==
X-Gm-Message-State: AOAM530vFhknq/WBlWYbsD6YKHgVYrpayMUqbXkMJDJg1/LQUYRQu4Y/
        XM+pev7kHtI6eOwi5Of3vIxzP6UT
X-Google-Smtp-Source: ABdhPJzt1GnogQcmbjMox2tGVGPyaSuCdELHp6ibSJmHtStqXwWwTXW2sxB2sfoyOlNMRWQWF+uriA==
X-Received: by 2002:a1c:7505:: with SMTP id o5mr549806wmc.164.1592427408270;
        Wed, 17 Jun 2020 13:56:48 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:5700:c06e:b26:fa7c:aab? (p200300ea8f235700c06e0b26fa7c0aab.dip0.t-ipconnect.de. [2003:ea:8f23:5700:c06e:b26:fa7c:aab])
        by smtp.googlemail.com with ESMTPSA id q13sm828851wrn.84.2020.06.17.13.56.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Jun 2020 13:56:47 -0700 (PDT)
Subject: [PATCH net-next 6/8] r8169: move updating counters to rtl8169_down
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <ef2a4cd4-1492-99d8-f94f-319eeb129137@gmail.com>
Message-ID: <acdf4167-28e2-9b5e-84ea-05b2828cdf2d@gmail.com>
Date:   Wed, 17 Jun 2020 22:54:54 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <ef2a4cd4-1492-99d8-f94f-319eeb129137@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Counters are updated whenever we go down, therefore move the call to
rtl8169_down().

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index afcdaace2..9f99b3f07 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4638,6 +4638,8 @@ static void rtl8169_down(struct rtl8169_private *tp)
 
 	phy_stop(tp->phydev);
 
+	rtl8169_update_counters(tp);
+
 	rtl8169_cleanup(tp, true);
 
 	rtl_pll_power_down(tp);
@@ -4652,9 +4654,6 @@ static int rtl8169_close(struct net_device *dev)
 
 	pm_runtime_get_sync(&pdev->dev);
 
-	/* Update counters before going down */
-	rtl8169_update_counters(tp);
-
 	netif_stop_queue(dev);
 	rtl8169_down(tp);
 	rtl8169_rx_clear(tp);
@@ -4875,9 +4874,6 @@ static int rtl8169_runtime_suspend(struct device *device)
 
 	rtl8169_net_suspend(tp);
 
-	/* Update counters before going runtime suspend */
-	rtl8169_update_counters(tp);
-
 	return 0;
 }
 
-- 
2.27.0


