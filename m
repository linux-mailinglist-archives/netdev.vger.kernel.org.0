Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 608401FD688
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 22:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727058AbgFQU4z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 16:56:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727048AbgFQU4w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 16:56:52 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C00A1C06174E
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 13:56:50 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id p5so3816495wrw.9
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 13:56:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DTk0I20UQ7yspLP05CLDNIqZpARjF4aIs6OK5NNTg94=;
        b=UrKo7autLuE6iYgpB0EbdCwD+dnX9LBuPOu4/gpPbn0xb/mshmx6cfRTJFLQB81PyD
         Ng1dSHQlGlyAhI0HqVz0PNTg7Q1FBphd3OXIq3Ju01tAJnUDtBgHZXzIsJxFce9vTRCf
         wabWVGjdG4tCEhQHvb1flo0GeiiIIX49D08f1kBXhwEJMPf8mJFHui1VCx3m3rHWa9Om
         bPxYyGJldqofobH5/MWhusBSK8ibqVZSa02AUDOON0umk+GGUkglqt6A6pKhM6Pk/lUI
         XEaBe2tMSINoQK3LNsc+ND7cetg6fEQKtSzOkESeQs+64ZgzGa/q++BKov6xczEUMHer
         gMog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DTk0I20UQ7yspLP05CLDNIqZpARjF4aIs6OK5NNTg94=;
        b=pQ16O8JfEwYLy7Fc1KGHUzv57369Ghxiu956qCcSrn/rSM6MVoBqMZGrdAbJTknXcB
         YOeVoLeXbjZb2H4yX5oG78h4/W5N1rm+jyPCYMKbxIPoHZArtut1nEtVnjrrXcQj/BIJ
         7J3qFphw7/GkwmM1sf76m3PaEDYVcZuqqt1QYLE7tmyylU6YkimWetxjQAutlSZDwRDO
         KnFpRNfOHiLbAITi18v4a4O4C7P5e0B+pqMmPVXrMrpqAcuAcrB8DWSxDMnkNISVM4NQ
         uXt8486TAmLjbcRLpkO7hEMoGDsVk01AUb0ufmRvDb6qKxOEu1GmuhDmM7fkuGDd3+JT
         /RcA==
X-Gm-Message-State: AOAM532RM9Y56jwKci2B2E2hrC4m8FvmOfuIqbg8WJsxquo+4rYr4Ih6
        2JfH1hWJ77Ib5/YvD6ghbk7ac3uq
X-Google-Smtp-Source: ABdhPJz2CUPINsXvl0lCMAM3fLIEo6ykhsuu3kbZfUJ/FPE/MshI5nx9ZbDGmxA3ZGAhS6cxq/lLWw==
X-Received: by 2002:adf:ed51:: with SMTP id u17mr973550wro.285.1592427409237;
        Wed, 17 Jun 2020 13:56:49 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:5700:c06e:b26:fa7c:aab? (p200300ea8f235700c06e0b26fa7c0aab.dip0.t-ipconnect.de. [2003:ea:8f23:5700:c06e:b26:fa7c:aab])
        by smtp.googlemail.com with ESMTPSA id e15sm1044209wme.9.2020.06.17.13.56.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Jun 2020 13:56:48 -0700 (PDT)
Subject: [PATCH net-next 7/8] r8169: move switching optional clock on/off to
 pll power functions
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <ef2a4cd4-1492-99d8-f94f-319eeb129137@gmail.com>
Message-ID: <750b9207-bd03-52b1-b951-67b4ce9be345@gmail.com>
Date:   Wed, 17 Jun 2020 22:55:40 +0200
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

Relevant chip clocks are disabled in rtl_pll_power_down(), therefore
move calling clk_disable_unprepare() there. Similar for enabling the
clock.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 9f99b3f07..d55bf2cd2 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -2292,10 +2292,14 @@ static void rtl_pll_power_down(struct rtl8169_private *tp)
 	default:
 		break;
 	}
+
+	clk_disable_unprepare(tp->clk);
 }
 
 static void rtl_pll_power_up(struct rtl8169_private *tp)
 {
+	clk_prepare_enable(tp->clk);
+
 	switch (tp->mac_version) {
 	case RTL_GIGA_MAC_VER_25 ... RTL_GIGA_MAC_VER_33:
 	case RTL_GIGA_MAC_VER_37:
@@ -4826,7 +4830,6 @@ static int __maybe_unused rtl8169_suspend(struct device *device)
 	struct rtl8169_private *tp = dev_get_drvdata(device);
 
 	rtl8169_net_suspend(tp);
-	clk_disable_unprepare(tp->clk);
 
 	return 0;
 }
@@ -4853,8 +4856,6 @@ static int __maybe_unused rtl8169_resume(struct device *device)
 
 	rtl_rar_set(tp, tp->dev->dev_addr);
 
-	clk_prepare_enable(tp->clk);
-
 	if (netif_running(tp->dev))
 		__rtl8169_resume(tp);
 
-- 
2.27.0


