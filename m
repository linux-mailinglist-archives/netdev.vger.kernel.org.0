Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAFA82F096C
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 20:53:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbhAJTv4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 14:51:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726787AbhAJTvw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jan 2021 14:51:52 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7016C06179F
        for <netdev@vger.kernel.org>; Sun, 10 Jan 2021 11:51:11 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id q18so14326253wrn.1
        for <netdev@vger.kernel.org>; Sun, 10 Jan 2021 11:51:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tRGptG015vaeyBcd/HPDPV0KrZI/mabDIvjI1IPzRPA=;
        b=qG8CBSrHrkBDPPF7vL4Z1NKk5u/DNqqBKRw4sdMDxuHmqztbv7zVzfwx4ZMXJFt48H
         i8qHFwYYJAf03P0fHslSRFaIA9o1S6dNAbY99iRYXewOl2cDacijd/zWubHqa91vE2RH
         SKyciiiw4UzLmsrSxRNvytHsNEJRGQw/kkAc4gDrwdC6m1CURyejVbz7twmrhiN9mwQ+
         WNYyrLzYuiRPPPI0/eZG2TWkvfc2uP4VDOUqKTDexLYnnWw0V0PIHaQAepesi+KCL5iA
         sRimdlWPH52nMsHum77eLeUphBb86KeNqSk2/sMq2JaPbmN2upMkvTzsc9/VdR8PAZDL
         gEQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tRGptG015vaeyBcd/HPDPV0KrZI/mabDIvjI1IPzRPA=;
        b=edpjrmrQHV5HKIAWyxSNvDjfbPNqQEzD3lUAjhrqdtpbXZSc5SLm3FtGzz0R40ejHr
         YNO1FxN8v1k9Vyz2XE3rAS/jZqt0GArp7nOTI45Hoz27gBaZmLGLl5xefKb8gvE3PyBP
         wcvgYBVuWaVJ4YyaItG5Ri00IYLx5UotR1/i5wlDqRPeSEEmRUIXQM4MXU8Q4e4fuDaF
         xYj3sEMH91klbiWH4WxS8ib4jSGDZvQihC9jQ1KiPeMxmKhIafqX/xhWYcR/K2mJqmpo
         S0OPFPF8+5cdFxNCYmlGyzqVJ1YO8ejOglEvwhY8LYgFZ5KI/NZkFl5gZpp8tuaC5W+R
         98lQ==
X-Gm-Message-State: AOAM530iLfmBKkx0mD/8VfLQwuPfGvTrSvHVgzjhVF+9wshCdT5daDJS
        HzN0oBA782Gesk3ff9jRtjHdzCTZKus=
X-Google-Smtp-Source: ABdhPJxBNWXkKXBxfX3/BLVdxy/U7P5vKL0zAIyYLJgxsHIAez9DTQjPe5vOvZCiU0tyBEKZDQDlIg==
X-Received: by 2002:adf:8290:: with SMTP id 16mr12790640wrc.27.1610308270263;
        Sun, 10 Jan 2021 11:51:10 -0800 (PST)
Received: from ?IPv6:2003:ea:8f06:5500:5449:e139:28a3:e114? (p200300ea8f0655005449e13928a3e114.dip0.t-ipconnect.de. [2003:ea:8f06:5500:5449:e139:28a3:e114])
        by smtp.googlemail.com with ESMTPSA id o8sm21690758wrm.17.2021.01.10.11.51.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 10 Jan 2021 11:51:09 -0800 (PST)
Subject: [PATCH net-next 3/3] r8169: clean up rtl_pll_power_down/up functions
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <1608dfa3-c4a5-0e92-31f7-76674b3c173a@gmail.com>
Message-ID: <45350b9c-f90e-fc1e-0796-6e71c43cecfc@gmail.com>
Date:   Sun, 10 Jan 2021 20:50:57 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <1608dfa3-c4a5-0e92-31f7-76674b3c173a@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clean up the remainings of rtl_pll_power_down/up and rename
rtl_pll_power_down() to rtl_prepare_power_down().

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 64fdc168f..33336098b 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -2229,7 +2229,7 @@ static void rtl_wol_suspend_quirk(struct rtl8169_private *tp)
 	}
 }
 
-static void rtl_pll_power_down(struct rtl8169_private *tp)
+static void rtl_prepare_power_down(struct rtl8169_private *tp)
 {
 	if (r8168_check_dash(tp))
 		return;
@@ -2244,11 +2244,6 @@ static void rtl_pll_power_down(struct rtl8169_private *tp)
 	}
 }
 
-static void rtl_pll_power_up(struct rtl8169_private *tp)
-{
-	phy_resume(tp->phydev);
-}
-
 static void rtl_init_rxcfg(struct rtl8169_private *tp)
 {
 	switch (tp->mac_version) {
@@ -4604,12 +4599,12 @@ static void rtl8169_down(struct rtl8169_private *tp)
 
 	rtl8169_cleanup(tp, true);
 
-	rtl_pll_power_down(tp);
+	rtl_prepare_power_down(tp);
 }
 
 static void rtl8169_up(struct rtl8169_private *tp)
 {
-	rtl_pll_power_up(tp);
+	phy_resume(tp->phydev);
 	rtl8169_init_phy(tp);
 	napi_enable(&tp->napi);
 	set_bit(RTL_FLAG_TASK_ENABLED, tp->wk.flags);
-- 
2.30.0


