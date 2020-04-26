Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBB211B9432
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 23:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726316AbgDZVhF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Apr 2020 17:37:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726225AbgDZVhF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Apr 2020 17:37:05 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA10AC061A0F
        for <netdev@vger.kernel.org>; Sun, 26 Apr 2020 14:37:03 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id y24so18223588wma.4
        for <netdev@vger.kernel.org>; Sun, 26 Apr 2020 14:37:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9jQXyvUbfkHssmamvhtHjjnV6WGgxgnotFCbmg4uPdw=;
        b=XcMIIs59Afo/o1elVZ2wmMflhfONdsSzW1ckRbNoP67Fd5RfozT//GCy9Ll/UlkCKN
         NZJqh/49ZtUy1YM3CmVe1SS5ZuaxB5xqmyPrZ5NzHR0SdzsLWbTMCQbZFp35uHoKrIUZ
         P1RkIz/4DxW4ZPg1eGGLLdHGXUqPbder1Lg4f3dayAmlI+niCaZ/5pRwX8sFC2wDJpdf
         KmZAdxKeyjo4m3f9arRfqA5O0uWKMl/34l0P2F48A8j/LUiZSMN0FBlSgBNc8Kytj4Rd
         6cV/o8GceFKgFKFwnuhofUP3UgoKv0Rpf0MzqzpaECSAtxlFCFgR7oxrSRUu65X5nfaG
         31cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9jQXyvUbfkHssmamvhtHjjnV6WGgxgnotFCbmg4uPdw=;
        b=roWzI4ylgQzY8uZqdYwbqxX0WxYO/ag8aFe47Xy/M1azXDbgDsvugpFmCOXhffdavJ
         2KE70CZ/9fkw8erRwf8vwRKtYcRwf1M6LMzH8ktKIwLZy8oKCZsg6LU5FPOE638CcZ/f
         yikHkPIXQVrkuL8k0doAKpbBWkdyeq7GAMXqHvr4mG3bW5IiOesCh3i++PXATqRIEc38
         24+21GWL996n7sidryiOfTqDOVepNnxa73I14ckWBgtccujAujc07m/FnmgKZMxh7CNd
         Smj42Op8D82S7fKC7hD3AyL7DL8VmIX24IK6OpSDJeKY7zCiguTmDYCwaX3m+wnxbVc8
         9DBA==
X-Gm-Message-State: AGi0PuZ3HVU65S6IFPBOArnZsFAb99AmPaVnQCqo5jUt9SarqYf20uOT
        1Q45kptIJ1s8By5ZKM1G3p4JhjiK
X-Google-Smtp-Source: APiQypLgo/XQqc39xH8slwOBCVEUW7VNP38JDZu5/dp5xUo9z2UhSyr8DdE7141BMrSqf0+gcTpcFw==
X-Received: by 2002:a7b:ce09:: with SMTP id m9mr21990261wmc.156.1587937022135;
        Sun, 26 Apr 2020 14:37:02 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:d1d0:8c1c:405c:5986? (p200300EA8F296000D1D08C1C405C5986.dip0.t-ipconnect.de. [2003:ea:8f29:6000:d1d0:8c1c:405c:5986])
        by smtp.googlemail.com with ESMTPSA id c83sm14226560wmd.23.2020.04.26.14.37.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Apr 2020 14:37:01 -0700 (PDT)
Subject: [PATCH net-next 1/2] r8169: improve handling CPCMD_MASK
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <e076bba2-e4dc-f8ce-d119-5b6735017727@gmail.com>
Message-ID: <9520bbc8-da51-5420-9c7f-dada47e68972@gmail.com>
Date:   Sun, 26 Apr 2020 23:35:59 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <e076bba2-e4dc-f8ce-d119-5b6735017727@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's sufficient to do the masking once in probe() for clearing
unwanted bits that may have been set by the BIOS.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 4c6167018..06a877fe7 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -3845,7 +3845,6 @@ static void rtl_hw_start(struct  rtl8169_private *tp)
 {
 	rtl_unlock_config_regs(tp);
 
-	tp->cp_cmd &= CPCMD_MASK;
 	RTL_W16(tp, CPlusCmd, tp->cp_cmd);
 
 	if (tp->mac_version <= RTL_GIGA_MAC_VER_06)
@@ -5424,7 +5423,7 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	tp->mac_version = chipset;
 
-	tp->cp_cmd = RTL_R16(tp, CPlusCmd);
+	tp->cp_cmd = RTL_R16(tp, CPlusCmd) & CPCMD_MASK;
 
 	if (sizeof(dma_addr_t) > 4 && tp->mac_version >= RTL_GIGA_MAC_VER_18 &&
 	    !dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64)))
-- 
2.26.2


