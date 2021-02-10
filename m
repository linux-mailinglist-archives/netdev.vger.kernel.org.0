Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23BE7316935
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 15:34:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229888AbhBJOeP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 09:34:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbhBJOeK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 09:34:10 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EA42C061574
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 06:33:29 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id l12so2861076wry.2
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 06:33:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=ByKIRdPayKyWDAST0h2lWLd7C+av6edE4z3enHXE4N4=;
        b=vX9dn0xrPyGRWFONQM11nE3+KBOjjlv2sPhvkusLqDKaiA7/PHuDyVPEsDi8XevOSL
         MKPQaODR7u6B+k1kP8IHp35yDrUU3QQqz/gWiaLM6Ylvp+SULEGAhNCJa2oJpaqx1vpI
         5JX5idrD07REUm/5LkTR83LuOh2YdjXqGdHkExvcERN/uUzI+/s7l5oqAZRPD8ELww24
         2G8kWRW8ylWTyAEzjb93hJeJYwP+m+lMK/lxngb5m/anFXoK7NmY1eR31mq1IjpbyoxJ
         /SVStXJu9nqb8hPg8GAWMEf1d+3nzZ4piRh8Xs7mhYXMi7+1CG9Uxs8elBWLBrBMenzI
         ID7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=ByKIRdPayKyWDAST0h2lWLd7C+av6edE4z3enHXE4N4=;
        b=AfuLZeTaDpy7WboxMDckaQXEpTpMFGNb9We9HWPsSdjW1OPPQgkfh99iRiYTugtWt2
         E+lBTsu0jQoehcVsM265/OaxOJ6g24e5tPmpZX83m0tPc08GYJEl86/27Ar56kS9UB18
         +v8WdXleZqNwKSWA0aNcxyZEvrs2qhuMKnU6WBwOiTo5uaUFvgjnoxDMW/ThDshxhEgF
         jACn7Z1LdQhZu6F/B3U3IeAphp0KkW/MD4rHeR8P4QgfUO0JvQX/gksTsjNHnmYBnU3X
         ZalsikKT0ga0pL6QW3PaPZSuQyoeUIB0oiby+sn++vPvu5pkVDsTLqMooIfd15zgyh5R
         nbig==
X-Gm-Message-State: AOAM530ODdXSVGiEbsBH0RS68U/AEi1z1cb5QQ7q9OuzZQCFr1d9s260
        ieK2IhnvIzfzrpCRCIUXtU2LHeh8Y1Eq1A==
X-Google-Smtp-Source: ABdhPJwvDlJ5CXaDNgpkI1n2oH2Ygg41V/TYDvhOzKjFeb100DrRoe8MFSrK/MLbH2GqYpg2aP5O2w==
X-Received: by 2002:a05:6000:1379:: with SMTP id q25mr3867921wrz.89.1612967607629;
        Wed, 10 Feb 2021 06:33:27 -0800 (PST)
Received: from ?IPv6:2003:ea:8f1f:ad00:b0ff:e539:9460:c978? (p200300ea8f1fad00b0ffe5399460c978.dip0.t-ipconnect.de. [2003:ea:8f1f:ad00:b0ff:e539:9460:c978])
        by smtp.googlemail.com with ESMTPSA id k11sm3446148wrl.84.2021.02.10.06.33.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Feb 2021 06:33:26 -0800 (PST)
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [PATCH net-next] r8169: re-configure WOL settings on resume from
 hibernation
Message-ID: <7b756293-35ec-d8bd-928c-1e00ded60328@gmail.com>
Date:   Wed, 10 Feb 2021 15:33:20 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

So far we don't re-configure WOL-related register bits when waking up
from hibernation. I'm not aware of any problem reports, but better
play safe and call __rtl8169_set_wol() in the resume() path too.
To achieve this move calling __rtl8169_set_wol() to
rtl8169_net_resume() and rename the function to rtl8169_runtime_resume().

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 376dfd011..bc588cde8 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4805,9 +4805,12 @@ static void rtl8169_net_suspend(struct rtl8169_private *tp)
 
 #ifdef CONFIG_PM
 
-static int rtl8169_net_resume(struct rtl8169_private *tp)
+static int rtl8169_runtime_resume(struct device *dev)
 {
+	struct rtl8169_private *tp = dev_get_drvdata(dev);
+
 	rtl_rar_set(tp, tp->dev->dev_addr);
+	__rtl8169_set_wol(tp, tp->saved_wolopts);
 
 	if (tp->TxDescArray)
 		rtl8169_up(tp);
@@ -4841,7 +4844,7 @@ static int __maybe_unused rtl8169_resume(struct device *device)
 	if (tp->mac_version == RTL_GIGA_MAC_VER_37)
 		rtl_init_rxcfg(tp);
 
-	return rtl8169_net_resume(tp);
+	return rtl8169_runtime_resume(device);
 }
 
 static int rtl8169_runtime_suspend(struct device *device)
@@ -4861,15 +4864,6 @@ static int rtl8169_runtime_suspend(struct device *device)
 	return 0;
 }
 
-static int rtl8169_runtime_resume(struct device *device)
-{
-	struct rtl8169_private *tp = dev_get_drvdata(device);
-
-	__rtl8169_set_wol(tp, tp->saved_wolopts);
-
-	return rtl8169_net_resume(tp);
-}
-
 static int rtl8169_runtime_idle(struct device *device)
 {
 	struct rtl8169_private *tp = dev_get_drvdata(device);
-- 
2.30.1

