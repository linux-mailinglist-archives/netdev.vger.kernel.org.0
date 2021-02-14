Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B835231B148
	for <lists+netdev@lfdr.de>; Sun, 14 Feb 2021 17:40:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbhBNQjU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Feb 2021 11:39:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbhBNQjT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Feb 2021 11:39:19 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 617C8C061756
        for <netdev@vger.kernel.org>; Sun, 14 Feb 2021 08:38:39 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id l12so5878758wry.2
        for <netdev@vger.kernel.org>; Sun, 14 Feb 2021 08:38:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=6Wy7hDerQkYDJPMpomsvFsTrnOCeyzsmzGJvvT6M4yk=;
        b=a0psWmkD3vuphOTlVuvSgQzQLi8RRzFrH730jiahrU3g78kdkyEbKatjOs+bo13OqB
         lgSkd9Huf4uD5MHstG54+mwlRPWE+O6JHb20M/vDjvpVi0iLLPeFQnQP0p/KHyTtagJM
         j36f7gOxxmLCv27Kj5wuEw9g3sE6XLX2FBZosSBpuHTdSc4WEcFERkNqe0C3SEzcc/ph
         1UJlZdkqAH3x3ugnIPe4Ad6j7U1jcw/H/mLLHZ3XDzpJ3tyFMCo3Hun5NUuCTW1L7BjN
         eqbP2kF4zVaMqzQhYhqaAAwkjklFafiNaCaEgIWCYPwMSTKM10DdJjYK8tsYsmaPLq3v
         HxPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=6Wy7hDerQkYDJPMpomsvFsTrnOCeyzsmzGJvvT6M4yk=;
        b=DKQBeODitapXlUZzE7yTOvjSEOOVSE6c0iu2ODkxUqX+TxD8UHYN5DuPYbdkw2ZwXE
         BwYn9LAv6goB9jAbUQvcvXSrLoLN+GvzxL6UpDt1BoFDA6Hx8U5aXNDaqr/C1Pok0FtK
         F/sWxIs+/aYGDS/KyCcU+TgKQTKj1sAwdZrEaH7CPcOIhVV+xG3G/889Pgy5Exo97AA0
         TcdSwxmec4o9nUSKekBhMjHZ4ZpF/A5+jRmoAu+tJM9Rl1nr/ufnCmtJ3Rq1ScDU7l5b
         mwA6Dhzvp1uQqmb00slga4JnOCwEILOjd8V/IGRH4uUSwyM5TsqYCWQ0O71PWRBG059s
         DXbA==
X-Gm-Message-State: AOAM532Lyhl0UBQvY0v/R20mn6FvrXvj5vCem8ukZ7190kwVlm6pc7tf
        lmvIHzzYq1E0nPpokKS9MwGVS/EDwbSqWA==
X-Google-Smtp-Source: ABdhPJxYUUPLhdcVrPkSo9iFuhAytkSO5Bt9m/pGSP6mrzLfUyAyXGpQ/imLtBYj3QYexPYDq/1DTA==
X-Received: by 2002:adf:8547:: with SMTP id 65mr13167627wrh.269.1613320717940;
        Sun, 14 Feb 2021 08:38:37 -0800 (PST)
Received: from ?IPv6:2003:ea:8f39:5b00:59b:23b9:f1a6:60c? (p200300ea8f395b00059b23b9f1a6060c.dip0.t-ipconnect.de. [2003:ea:8f39:5b00:59b:23b9:f1a6:60c])
        by smtp.googlemail.com with ESMTPSA id o18sm20378043wmp.19.2021.02.14.08.38.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 14 Feb 2021 08:38:37 -0800 (PST)
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [PATCH net] r8169: fix resuming from suspend on RTL8105e if machine
 runs on battery
Message-ID: <fd32cc1a-b098-026d-7e29-42779af662bd@gmail.com>
Date:   Sun, 14 Feb 2021 17:36:44 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Armin reported that after referenced commit his RTL8105e is dead when
resuming from suspend and machine runs on battery. This patch has been
confirmed to fix the issue.

Fixes: e80bd76fbf56 ("r8169: work around power-saving bug on some chip versions")
Reported-by: Armin Wolf <W_Armin@gmx.de>
Tested-by: Armin Wolf <W_Armin@gmx.de>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
- This fix will not apply on net-next. I submit a separate patch for net-next.
---
 drivers/net/ethernet/realtek/r8169_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 0d78408b4..e7a59dc5f 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -2208,6 +2208,7 @@ static void rtl_pll_power_down(struct rtl8169_private *tp)
 
 	switch (tp->mac_version) {
 	case RTL_GIGA_MAC_VER_25 ... RTL_GIGA_MAC_VER_26:
+	case RTL_GIGA_MAC_VER_29 ... RTL_GIGA_MAC_VER_30:
 	case RTL_GIGA_MAC_VER_32 ... RTL_GIGA_MAC_VER_33:
 	case RTL_GIGA_MAC_VER_37:
 	case RTL_GIGA_MAC_VER_39:
@@ -2235,6 +2236,7 @@ static void rtl_pll_power_up(struct rtl8169_private *tp)
 {
 	switch (tp->mac_version) {
 	case RTL_GIGA_MAC_VER_25 ... RTL_GIGA_MAC_VER_26:
+	case RTL_GIGA_MAC_VER_29 ... RTL_GIGA_MAC_VER_30:
 	case RTL_GIGA_MAC_VER_32 ... RTL_GIGA_MAC_VER_33:
 	case RTL_GIGA_MAC_VER_37:
 	case RTL_GIGA_MAC_VER_39:
-- 
2.30.0

