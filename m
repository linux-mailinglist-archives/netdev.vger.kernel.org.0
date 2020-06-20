Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA51120266D
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 22:41:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728880AbgFTUlP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jun 2020 16:41:15 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:51594 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728855AbgFTUlJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Jun 2020 16:41:09 -0400
Received: by mail-wm1-f68.google.com with SMTP id x16so2340230wmj.1
        for <netdev@vger.kernel.org>; Sat, 20 Jun 2020 13:41:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1mFGAevaOziKUxusTk65XDNlCLx7cz1xEFvDPmZeIvo=;
        b=lTp7V2Dm4MyCBFdFtd/nPPylluEMLMqVguIA8udFJmPqYam6vOaGoePhPx4uoptb8S
         sYvD1AFsJi4hEwJX5G2MiUdmV7qFIs/YjHqrne7W5Ti+J4hG4gNXxhsxrTeQTyTV9H0Z
         ddIrqsJzyOKRFVP8UuNRbwzgk2Hsj/Ltk5c4yTtBWOTJHYgzl82JkQmOB3FA+OmVAFT6
         eVIIvSKn+WImAseohrwlN4vSG6SC0UuUOUopu+M94ueKNnDMu2sx3ysdP1Omrrw0didB
         OEO4GyQZUD3YIwkXYdjbT98LIpZHObWowS3tJ4gi08FTIFoQ6wT+SGEkr30UocijhZr+
         YNEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1mFGAevaOziKUxusTk65XDNlCLx7cz1xEFvDPmZeIvo=;
        b=HXOLZBvNOoTpeqffgtef9snIfFn6OTIwbARKNehuZVP0tU8VOkZ3UJmbQa7tsN2gUZ
         Tyb291MFgZ02pW910hkqychJ2D2kzrGfTJAEZOfCu+bMneQWnu5Yu/iUy2At8RzhbpSc
         n5zPPxTYgy67zTDy7MFb0/W5aedozNpx5PtZ8oyUX7Yb1vHzGJ8gpyEloQZBCLuEve0u
         huYKTIijZimPipb8SY9Lfm/utuKXwIQYKJT/UphXb/keUCg3R7bE+Ik9cFRINT+YUOlb
         Fvm54tWQF0wYOKA/tVU5LTFCq5/485y3hMKMB4PqS1OHqhGQB82gkIl8yOZadYFwSIqF
         b/Hw==
X-Gm-Message-State: AOAM532Qh/c3M0gOF0GOrFsWlKQJrsSHAMUm9LJQ9SpGpSHgtDoad5a1
        GBGvxkXXutLhuBNOFf7j+MZlO86Q
X-Google-Smtp-Source: ABdhPJwj4V2T42/eGcJXetJZExemTrimlvO9mEjRvvh/2ZO2FDMwtcxXmTmJFy7BdMI891UDIgPt0g==
X-Received: by 2002:a1c:96ce:: with SMTP id y197mr10678628wmd.55.1592685607068;
        Sat, 20 Jun 2020 13:40:07 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:5700:b4cc:8098:204b:37c5? (p200300ea8f235700b4cc8098204b37c5.dip0.t-ipconnect.de. [2003:ea:8f23:5700:b4cc:8098:204b:37c5])
        by smtp.googlemail.com with ESMTPSA id v7sm11676684wrp.45.2020.06.20.13.40.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 20 Jun 2020 13:40:06 -0700 (PDT)
Subject: [PATCH net-next 7/7] r8169: improve rtl8169_runtime_resume
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <2e68df85-4f64-d45b-3c4c-bb8cb9a4411d@gmail.com>
Message-ID: <7b0a78b3-98cb-9755-a93e-c189c82ce994@gmail.com>
Date:   Sat, 20 Jun 2020 22:39:35 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <2e68df85-4f64-d45b-3c4c-bb8cb9a4411d@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simplify rtl8169_runtime_resume() by calling rtl8169_resume().

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index e09732c9d..247fad1c6 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4761,13 +4761,13 @@ static int __maybe_unused rtl8169_suspend(struct device *device)
 	return 0;
 }
 
-static int __maybe_unused rtl8169_resume(struct device *device)
+static int rtl8169_resume(struct device *device)
 {
 	struct rtl8169_private *tp = dev_get_drvdata(device);
 
 	rtl_rar_set(tp, tp->dev->dev_addr);
 
-	if (netif_running(tp->dev))
+	if (tp->TxDescArray)
 		rtl8169_up(tp);
 
 	netif_device_attach(tp->dev);
@@ -4796,16 +4796,9 @@ static int rtl8169_runtime_resume(struct device *device)
 {
 	struct rtl8169_private *tp = dev_get_drvdata(device);
 
-	rtl_rar_set(tp, tp->dev->dev_addr);
-
 	__rtl8169_set_wol(tp, tp->saved_wolopts);
 
-	if (tp->TxDescArray)
-		rtl8169_up(tp);
-
-	netif_device_attach(tp->dev);
-
-	return 0;
+	return rtl8169_resume(device);
 }
 
 static int rtl8169_runtime_idle(struct device *device)
-- 
2.27.0


