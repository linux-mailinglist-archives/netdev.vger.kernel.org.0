Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 910091E941C
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 00:00:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729401AbgE3WAZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 18:00:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729399AbgE3WAX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 May 2020 18:00:23 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47A0DC08C5CA
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 15:00:23 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id y17so7641054wrn.11
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 15:00:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=L3sJ9UAFiPIPJqL6wgaAS1RvHsBnhVoNYb2cuGsmZb4=;
        b=DFVdjpHNDczoMZcBdF1v8R6yVEbc7QTEw/HB+MZfjPFdYL0fpkzvA0x00xlcf4tmJF
         pYPNdtpJo4j2sKyi5x8SVWgCjyRvbRAEhIsH5zcu+EACUxSLKhcku3mkCFWlq8mx2BXF
         d1MxwPVEyiMP69S6s6N8LNTr4zTwf3n0ivsCkYPH0q7ZhzXQZxYb817UiXdZWOUHI9q1
         MIdfx+agS7wKc1d8YvobykpeGgY1VTajJsZ4mT1Vaxk2/qk3t8w2kLKDa8h2zD9KFoex
         H3WMxXfyGExsjzZyW+4drpJxS9eLpPMe5zXlRNTqSsNvflvpcQ47DIelkEVVBcRJ/HGr
         AqDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=L3sJ9UAFiPIPJqL6wgaAS1RvHsBnhVoNYb2cuGsmZb4=;
        b=baetqlyGRKBZzt+DhGu5dtaw9IdUKDEmZ4f/Mg45atDcL6SN+GLwW/vMfJSjnGuttW
         2EEqt8q7Fnd82dfkUMjVPPPBQKEwF2o84XgWeoSKUDi+zaNIm2v0Da7nL2qSVziHOpc4
         I+L+KNjJQ7s0ftoKHwVy/xM0IILH8DJu4z45vxC2sRClQBVJOjpUvN2nUO8O5bMNmDBO
         FVvJDzj18wGZjTyM9LMu0sTfvlVTufCW3V6X4MnHcM3XFSt+VHPdUjaNr5jWA3NNcD06
         ixcmNKf6M0dFMKNLjxMlpQiQdbDcASntKVli1iPhGk8oaI8QSkPG+e8RR37mHZlQSQ6u
         CLMQ==
X-Gm-Message-State: AOAM530Ses85QXM9M1x/FRynU+tZW6OXgvNFjkghetki0n9ONM5WY4W7
        3oZ7LKIc89vZmV+sN2JY7DzkzmQo
X-Google-Smtp-Source: ABdhPJx/ISOSGdH/yGEE4TvOMWy+xRcUmeUOLx0W4879nlzAG9yzjEg18DdarV/0Xn0brwJ1oc9FDw==
X-Received: by 2002:a5d:4c81:: with SMTP id z1mr16110217wrs.371.1590876021822;
        Sat, 30 May 2020 15:00:21 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:5700:8c73:80e5:b6ba:d8b0? (p200300ea8f2357008c7380e5b6bad8b0.dip0.t-ipconnect.de. [2003:ea:8f23:5700:8c73:80e5:b6ba:d8b0])
        by smtp.googlemail.com with ESMTPSA id 5sm4780599wmz.16.2020.05.30.15.00.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 May 2020 15:00:21 -0700 (PDT)
Subject: [PATCH net-next 6/6] r8169: improve handling power management ops
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <443c14ac-24b8-58ba-05aa-3803f1e5f4ab@gmail.com>
Message-ID: <95e94fdd-3b51-6a76-0b54-3a53150b3ba8@gmail.com>
Date:   Sat, 30 May 2020 23:59:58 +0200
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

Simplify handling the power management callbacks.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 28 ++++++++---------------
 1 file changed, 9 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index fd93377f9..4d2ec9742 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4821,7 +4821,7 @@ static void rtl8169_net_suspend(struct rtl8169_private *tp)
 
 #ifdef CONFIG_PM
 
-static int rtl8169_suspend(struct device *device)
+static int __maybe_unused rtl8169_suspend(struct device *device)
 {
 	struct rtl8169_private *tp = dev_get_drvdata(device);
 
@@ -4847,7 +4847,7 @@ static void __rtl8169_resume(struct rtl8169_private *tp)
 	rtl_unlock_work(tp);
 }
 
-static int rtl8169_resume(struct device *device)
+static int __maybe_unused rtl8169_resume(struct device *device)
 {
 	struct rtl8169_private *tp = dev_get_drvdata(device);
 
@@ -4909,24 +4909,12 @@ static int rtl8169_runtime_idle(struct device *device)
 }
 
 static const struct dev_pm_ops rtl8169_pm_ops = {
-	.suspend		= rtl8169_suspend,
-	.resume			= rtl8169_resume,
-	.freeze			= rtl8169_suspend,
-	.thaw			= rtl8169_resume,
-	.poweroff		= rtl8169_suspend,
-	.restore		= rtl8169_resume,
-	.runtime_suspend	= rtl8169_runtime_suspend,
-	.runtime_resume		= rtl8169_runtime_resume,
-	.runtime_idle		= rtl8169_runtime_idle,
+	SET_SYSTEM_SLEEP_PM_OPS(rtl8169_suspend, rtl8169_resume)
+	SET_RUNTIME_PM_OPS(rtl8169_runtime_suspend, rtl8169_runtime_resume,
+			   rtl8169_runtime_idle)
 };
 
-#define RTL8169_PM_OPS	(&rtl8169_pm_ops)
-
-#else /* !CONFIG_PM */
-
-#define RTL8169_PM_OPS	NULL
-
-#endif /* !CONFIG_PM */
+#endif /* CONFIG_PM */
 
 static void rtl_wol_shutdown_quirk(struct rtl8169_private *tp)
 {
@@ -5458,7 +5446,9 @@ static struct pci_driver rtl8169_pci_driver = {
 	.probe		= rtl_init_one,
 	.remove		= rtl_remove_one,
 	.shutdown	= rtl_shutdown,
-	.driver.pm	= RTL8169_PM_OPS,
+#ifdef CONFIG_PM
+	.driver.pm	= &rtl8169_pm_ops,
+#endif
 };
 
 module_pci_driver(rtl8169_pci_driver);
-- 
2.26.2


