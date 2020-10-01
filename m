Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0098827F9A0
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 08:44:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725938AbgJAGo3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 02:44:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725883AbgJAGo2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 02:44:28 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9266C0613D0
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 23:44:27 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id g4so4460239edk.0
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 23:44:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=/vbPY+JiGp1PRbnofI1TTORelUAFQOBu28MS4BIy21c=;
        b=e7dF5gXU1i6Aym+o1IMuC16l++oF6fJU+af27GomQNJ095WqlQFQ+vbBwKfEoJQHSb
         yPelaVKBIox60IisNC9rU/En6GxbihXt8JEv2zw8anC6mpDXv4LTwK/atzbmK3AE9zzR
         DZeSuLZBBOpZJiF3wRZ12ci60ke/wMmgVB+dDAiRwrLKdLGnsCNU0W5G/OiUngosxbZn
         ZUb+Tahsv4mw9ASPuCDhRY2pKhTLkRN2MGCPlXjSSfO5YjddCmWt7GtDgZ9fFagPzNZH
         FqKhsdJxqg9CBrtcF/X+xRO+au0tZI0MmCkzowEwqyk/5VOm1afK+Mwkc6KBpaxdHSAZ
         rUNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=/vbPY+JiGp1PRbnofI1TTORelUAFQOBu28MS4BIy21c=;
        b=IbydcMGM0tNeWVpzQlCSbJCeOUjLepcDC2uEFewdROyg3hF5+ecsYW+NehMjd6GKd3
         DuTb+hOcCGSfMqo8rg4az8EJ3epyGona0bC/YhZlUTHh9cNDBQ+RrjE5eWOPQia5xUN2
         Pz58HTYAS7qKxQwK0XCy0pkQLsSPCeHE4ElRUCn83lotkJDy3bl/FizVgPzmCAUuNcds
         5PdJkb/GAsJDrDorQlWpc/D7UrCXzi8RWXoBm/22Qh3LgQ5XCHLkalxgDfYFmjbk38U/
         oP5MYXCDkh4M9CZuI4Qig+YItrva1VnuW1X+Xdz/mkv36XIPp5QN7GPKb9r9FpqmKIbL
         QGIw==
X-Gm-Message-State: AOAM532kOkuk/vseGgoIQ1FbRhMfp37oNe3xKALXp3YASAXjZ9P/AgR7
        qfj5epFLk+8Awuf6paIY+2c=
X-Google-Smtp-Source: ABdhPJyvg65RLpZRA8myIWsYWZLWVgvEDSjGhvXOClkXv0XcLRG9WN8WCSjh0QTDrmzCWVxsxwdUbA==
X-Received: by 2002:a05:6402:12d1:: with SMTP id k17mr6383870edx.323.1601534666613;
        Wed, 30 Sep 2020 23:44:26 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f00:6a00:758b:d2db:8faf:4c9e? (p200300ea8f006a00758bd2db8faf4c9e.dip0.t-ipconnect.de. [2003:ea:8f00:6a00:758b:d2db:8faf:4c9e])
        by smtp.googlemail.com with ESMTPSA id b9sm3250255eje.114.2020.09.30.23.44.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Sep 2020 23:44:26 -0700 (PDT)
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net] r8169: fix handling ether_clk
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Petr Tesarik <ptesarik@suse.cz>,
        Hans de Goede <hdegoede@redhat.com>
Message-ID: <9893d089-9668-258e-d2de-21a93b0486aa@gmail.com>
Date:   Thu, 1 Oct 2020 08:44:19 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Petr reported that system freezes on r8169 driver load on a system
using ether_clk. The original change was done under the assumption
that the clock isn't needed for basic operations like chip register
access. But obviously that was wrong.
Therefore effectively revert the original change, and in addition
leave the clock active when suspending and WoL is enabled. Chip may
not be able to process incoming packets otherwise.

Fixes: 9f0b54cd1672 ("r8169: move switching optional clock on/off to pll power functions")
Reported-by: Petr Tesarik <ptesarik@suse.cz>
Tested-by: Petr Tesarik <ptesarik@suse.cz>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 32 ++++++++++++++---------
 1 file changed, 19 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 6c7c004c2..72351c5b0 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -2236,14 +2236,10 @@ static void rtl_pll_power_down(struct rtl8169_private *tp)
 	default:
 		break;
 	}
-
-	clk_disable_unprepare(tp->clk);
 }
 
 static void rtl_pll_power_up(struct rtl8169_private *tp)
 {
-	clk_prepare_enable(tp->clk);
-
 	switch (tp->mac_version) {
 	case RTL_GIGA_MAC_VER_25 ... RTL_GIGA_MAC_VER_33:
 	case RTL_GIGA_MAC_VER_37:
@@ -4820,29 +4816,39 @@ static void rtl8169_net_suspend(struct rtl8169_private *tp)
 
 #ifdef CONFIG_PM
 
+static int rtl8169_net_resume(struct rtl8169_private *tp)
+{
+	rtl_rar_set(tp, tp->dev->dev_addr);
+
+	if (tp->TxDescArray)
+		rtl8169_up(tp);
+
+	netif_device_attach(tp->dev);
+
+	return 0;
+}
+
 static int __maybe_unused rtl8169_suspend(struct device *device)
 {
 	struct rtl8169_private *tp = dev_get_drvdata(device);
 
 	rtnl_lock();
 	rtl8169_net_suspend(tp);
+	if (!device_may_wakeup(tp_to_dev(tp)))
+		clk_disable_unprepare(tp->clk);
 	rtnl_unlock();
 
 	return 0;
 }
 
-static int rtl8169_resume(struct device *device)
+static int __maybe_unused rtl8169_resume(struct device *device)
 {
 	struct rtl8169_private *tp = dev_get_drvdata(device);
 
-	rtl_rar_set(tp, tp->dev->dev_addr);
-
-	if (tp->TxDescArray)
-		rtl8169_up(tp);
+	if (!device_may_wakeup(tp_to_dev(tp)))
+		clk_prepare_enable(tp->clk);
 
-	netif_device_attach(tp->dev);
-
-	return 0;
+	return rtl8169_net_resume(tp);
 }
 
 static int rtl8169_runtime_suspend(struct device *device)
@@ -4868,7 +4874,7 @@ static int rtl8169_runtime_resume(struct device *device)
 
 	__rtl8169_set_wol(tp, tp->saved_wolopts);
 
-	return rtl8169_resume(device);
+	return rtl8169_net_resume(tp);
 }
 
 static int rtl8169_runtime_idle(struct device *device)
-- 
2.28.0

