Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93A0C1FD684
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 22:57:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727037AbgFQU4s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 16:56:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726758AbgFQU4r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 16:56:47 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7011C06174E
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 13:56:46 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id t194so3464305wmt.4
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 13:56:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4Oeovuqi32l3hxjPHw0Y0M/5WDKUegRwr7348TdN6HY=;
        b=StKtprcAjTKQtc2t16H3FruSITde86BVN3V+yRkhlGLyU2/UrPdma1AOL9fztcyFOr
         DH6i5twbVvGxuASXz5H8uRgoWtb+2omsOQ11dS3RUad4mhumVwy1hAlfJvRFRL8lS8ww
         Ocr51A2NkQVRd77em39bzU3y5Tn/nvGqk+2LVvZxIYa7oilkkyvMFlJXvi84fmMHU34g
         2kOU4pkYVWvhLeAwV/CLHspJpaJBf7zG7E1hh9RUZgj7WhgaEsNNF1CatWVMf3uRhibw
         z4obkQ0vl4Koly3KZ/L27D/lnzmaKaxyqqr2yfg3zpJR+GR9nJoeshnkgrukt+J0SPJO
         gNdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4Oeovuqi32l3hxjPHw0Y0M/5WDKUegRwr7348TdN6HY=;
        b=F1rR7ds5v4P7llhZhvhxlYEsGP9yBWC+XKF5l2lV2gI/yznfIoAdkTcfIi/5w1lzQv
         i4nh14S4mLjYymQJoMjprL+vihAcUD3GeyjK8n+kAwXY8Jn5gJTXKxBdUjQYQ4urU5PA
         7DSQNKT34atzd03k3KOboUdwRCavBUfPgxIDLpdt8kPsS+Ig2oM2FRXcCtFD7LTN107W
         v7alMzMOWLG4cbG7RYVqmsHBFuzj6RMeo+KtmMMFT2e+zXsbXfdXrGARryfZ4vPCjZMX
         Li48Pc4+HRE4YIldrCbL2F3b4okrB71GKV8s85IVtNYXZEOOsERe/CLGP1L8T/1e00rE
         ttvQ==
X-Gm-Message-State: AOAM531466AEN5P83lnSE85NDN0R8eXwJUPYqJjXY7HnSua+pOpD6e4G
        gXk35J/TCDCNtptZtSvUiDHP6VfG
X-Google-Smtp-Source: ABdhPJw9NnSLq3o1Ny0wMxNSQMMWMwe53HYk4pR0XctItGlV4B+Jymhuv0m/crTUox7lpBBWMhl/8g==
X-Received: by 2002:a1c:6a13:: with SMTP id f19mr588065wmc.142.1592427405179;
        Wed, 17 Jun 2020 13:56:45 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:5700:c06e:b26:fa7c:aab? (p200300ea8f235700c06e0b26fa7c0aab.dip0.t-ipconnect.de. [2003:ea:8f23:5700:c06e:b26:fa7c:aab])
        by smtp.googlemail.com with ESMTPSA id c143sm8285107wmd.1.2020.06.17.13.56.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Jun 2020 13:56:44 -0700 (PDT)
Subject: [PATCH net-next 3/8] r8169: improve setting WoL on runtime-resume
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <ef2a4cd4-1492-99d8-f94f-319eeb129137@gmail.com>
Message-ID: <5130b4ec-9de8-3c1a-8ef7-99be9084c93b@gmail.com>
Date:   Wed, 17 Jun 2020 22:52:47 +0200
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

In the following scenario WoL isn't configured properly:
- Driver is loaded, interface isn't brought up within 10s, so driver
  runtime-suspends.
- WoL is set.
- Interface is brought up, stored WoL setting isn't applied.

It has always been like that, but the scenario seems to be quite
theoretical as I haven't seen any bug report yet. Therefore treat
the change as an improvement.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 4bc6c5529..bd95c0ae6 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4887,14 +4887,12 @@ static int rtl8169_runtime_resume(struct device *device)
 
 	rtl_rar_set(tp, tp->dev->dev_addr);
 
-	if (!tp->TxDescArray)
-		return 0;
-
 	rtl_lock_work(tp);
 	__rtl8169_set_wol(tp, tp->saved_wolopts);
 	rtl_unlock_work(tp);
 
-	__rtl8169_resume(tp);
+	if (tp->TxDescArray)
+		__rtl8169_resume(tp);
 
 	return 0;
 }
-- 
2.27.0


