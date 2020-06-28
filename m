Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C293920CAB7
	for <lists+netdev@lfdr.de>; Sun, 28 Jun 2020 23:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726409AbgF1VRW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jun 2020 17:17:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726080AbgF1VRW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jun 2020 17:17:22 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D837AC03E979
        for <netdev@vger.kernel.org>; Sun, 28 Jun 2020 14:17:21 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id d16so4567874edz.12
        for <netdev@vger.kernel.org>; Sun, 28 Jun 2020 14:17:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lgTkJrZYnYucEuzzaY+tYoplgI4Vt+hvydnAhKPINxk=;
        b=mHoOQp/gwPep7YU/Rjh2u2dpFcXMJv6pjdPvjLooo/pMtInSZIqwpgc7TCHO8mrNIw
         icaLUSjgMnKjSijYnL7fHXfQzc6scmn6AixkP7FxVEGewo1wVEEY2XYuTeT2dBWI/Vy0
         zTY3MTmdkW2anlQB9NS93mdJsHkx3khPuipQN5lLgYscAPcGxM/UOqbqnmw1gkuBraGy
         ef/qQLbe22mYsAk7rEfmdvPLkZI7EeP1LG9Nrk1tpgLPs9Wg75KTxsDPeSzh7lrE3Ha4
         ks8246k+j27IsNDymx5GkPnuDXGSFvkuGM62DckaPSSi8oScKKXOtdQSxSDQlFyeEErY
         KrNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lgTkJrZYnYucEuzzaY+tYoplgI4Vt+hvydnAhKPINxk=;
        b=gxVrK8An64Kog/BMoIhydAAhDrgTf1pNCob1lRMWc9VMiKQ0B8lBwZWedWdrH6+8nf
         FK4nSnz9Vit7i+Cg63yBYU+imZ8o2U2dBWNslZN3OClNGSxGu6izrmdBmWj9Foipyumf
         8l3O2p6Hct5g2T3AJvLk2Fto+ThydCmV9V6kpPbBda1M9ck4hUfcFh5cqeElknMTzSeJ
         qSf0ZNEgitdfNmZOb/2yYZPwq0JFa7H/wZvITfixVwZwoUXnu0Zx4C9iP3g+Y4kKCepS
         yULFDdqH/auUAX3h6Ivi64xJX1W3Qlz9nEeSBjet6+TMpiP/2J2HFOLBSCD3baCjN1Fd
         Tpyw==
X-Gm-Message-State: AOAM530uD9Dpx5wXtZzf9VSUmab6gSmpdDJ1u+1dry1pmyM1/fMS5/5G
        4fsqS5yOkOgbOKDdkD28Se3/MoRS
X-Google-Smtp-Source: ABdhPJx4HkWJODXXT1QzdhWlbpGg59CZWIfb0yGCV728gwHXkskZfz/2s8HcTmD7PGXallvLUTKMXw==
X-Received: by 2002:a05:6402:13d0:: with SMTP id a16mr14353403edx.269.1593379040300;
        Sun, 28 Jun 2020 14:17:20 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:5700:ed55:9d81:4812:8269? (p200300ea8f235700ed559d8148128269.dip0.t-ipconnect.de. [2003:ea:8f23:5700:ed55:9d81:4812:8269])
        by smtp.googlemail.com with ESMTPSA id b17sm1395025ejc.82.2020.06.28.14.17.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 28 Jun 2020 14:17:19 -0700 (PDT)
Subject: [PATCH net-next 1/2] r8169: merge handling of RTL8101e and RTL8100e
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <29ba5d31-9a0f-05c4-1472-5b15330f6408@gmail.com>
Message-ID: <a76bd0cd-97f9-0a09-b0d9-70f7dcb7b87e@gmail.com>
Date:   Sun, 28 Jun 2020 23:15:45 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <29ba5d31-9a0f-05c4-1472-5b15330f6408@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Chip versions 13, 14, 15 are treated the same by the driver, therefore
let's merge them.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169.h            |  2 --
 drivers/net/ethernet/realtek/r8169_main.c       | 10 +++-------
 drivers/net/ethernet/realtek/r8169_phy_config.c |  2 --
 3 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169.h b/drivers/net/ethernet/realtek/r8169.h
index 22a6a057b..afefdec9d 100644
--- a/drivers/net/ethernet/realtek/r8169.h
+++ b/drivers/net/ethernet/realtek/r8169.h
@@ -25,8 +25,6 @@ enum mac_version {
 	RTL_GIGA_MAC_VER_11,
 	RTL_GIGA_MAC_VER_12,
 	RTL_GIGA_MAC_VER_13,
-	RTL_GIGA_MAC_VER_14,
-	RTL_GIGA_MAC_VER_15,
 	RTL_GIGA_MAC_VER_16,
 	RTL_GIGA_MAC_VER_17,
 	RTL_GIGA_MAC_VER_18,
diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 226205099..124827b19 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -105,9 +105,7 @@ static const struct {
 	[RTL_GIGA_MAC_VER_10] = {"RTL8101e"				},
 	[RTL_GIGA_MAC_VER_11] = {"RTL8168b/8111b"			},
 	[RTL_GIGA_MAC_VER_12] = {"RTL8168b/8111b"			},
-	[RTL_GIGA_MAC_VER_13] = {"RTL8101e"				},
-	[RTL_GIGA_MAC_VER_14] = {"RTL8100e"				},
-	[RTL_GIGA_MAC_VER_15] = {"RTL8100e"				},
+	[RTL_GIGA_MAC_VER_13] = {"RTL8101e/RTL8100e"			},
 	[RTL_GIGA_MAC_VER_16] = {"RTL8101e"				},
 	[RTL_GIGA_MAC_VER_17] = {"RTL8168b/8111b"			},
 	[RTL_GIGA_MAC_VER_18] = {"RTL8168cp/8111cp"			},
@@ -2009,8 +2007,8 @@ static enum mac_version rtl8169_get_mac_version(u16 xid, bool gmii)
 		{ 0x7c8, 0x248,	RTL_GIGA_MAC_VER_09 },
 		{ 0x7c8, 0x340,	RTL_GIGA_MAC_VER_16 },
 		/* FIXME: where did these entries come from ? -- FR */
-		{ 0xfc8, 0x388,	RTL_GIGA_MAC_VER_15 },
-		{ 0xfc8, 0x308,	RTL_GIGA_MAC_VER_14 },
+		{ 0xfc8, 0x388,	RTL_GIGA_MAC_VER_13 },
+		{ 0xfc8, 0x308,	RTL_GIGA_MAC_VER_13 },
 
 		/* 8110 family. */
 		{ 0xfc8, 0x980,	RTL_GIGA_MAC_VER_06 },
@@ -3616,8 +3614,6 @@ static void rtl_hw_config(struct rtl8169_private *tp)
 		[RTL_GIGA_MAC_VER_11] = rtl_hw_start_8168b,
 		[RTL_GIGA_MAC_VER_12] = rtl_hw_start_8168b,
 		[RTL_GIGA_MAC_VER_13] = NULL,
-		[RTL_GIGA_MAC_VER_14] = NULL,
-		[RTL_GIGA_MAC_VER_15] = NULL,
 		[RTL_GIGA_MAC_VER_16] = NULL,
 		[RTL_GIGA_MAC_VER_17] = rtl_hw_start_8168b,
 		[RTL_GIGA_MAC_VER_18] = rtl_hw_start_8168cp_1,
diff --git a/drivers/net/ethernet/realtek/r8169_phy_config.c b/drivers/net/ethernet/realtek/r8169_phy_config.c
index 0cf4893e5..a0c2b3330 100644
--- a/drivers/net/ethernet/realtek/r8169_phy_config.c
+++ b/drivers/net/ethernet/realtek/r8169_phy_config.c
@@ -1261,8 +1261,6 @@ void r8169_hw_phy_config(struct rtl8169_private *tp, struct phy_device *phydev,
 		[RTL_GIGA_MAC_VER_11] = rtl8168bb_hw_phy_config,
 		[RTL_GIGA_MAC_VER_12] = rtl8168bef_hw_phy_config,
 		[RTL_GIGA_MAC_VER_13] = NULL,
-		[RTL_GIGA_MAC_VER_14] = NULL,
-		[RTL_GIGA_MAC_VER_15] = NULL,
 		[RTL_GIGA_MAC_VER_16] = NULL,
 		[RTL_GIGA_MAC_VER_17] = rtl8168bef_hw_phy_config,
 		[RTL_GIGA_MAC_VER_18] = rtl8168cp_1_hw_phy_config,
-- 
2.27.0


