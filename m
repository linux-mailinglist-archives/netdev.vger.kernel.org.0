Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34AAE2EF1B8
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 13:01:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726749AbhAHMBI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 07:01:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725791AbhAHMBH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 07:01:07 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD020C0612F5
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 04:00:26 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id 190so7616998wmz.0
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 04:00:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vPQAq5rL2RT0Kb9F+IBKUZ7s46kdUygloMmy2B3StMk=;
        b=lC3jQsSJesUYE0+OaMONHV5dgYG/n/NH5UE/+Tz10DIKloiTgqAZs8tjw5U/OzXy56
         MCJZCiGQ1eMVFAzAinWJXQEet5BYsBfyz1OSqGGcFCtkK0P1Nn7YfdJFeV3tm7DEcgN3
         Jb+50SFOWB8CjUuxuei2DAh0X20DfNz3hBf2GrcGCyNJ15b6b/BDdjcMBJE0xHhHiNbq
         a9CyMWNwXj/mgE2IXH5B8722JJBxr66abhSsT3Yrz2LUhzmCpM3NexjAMJ+vJJ4Zp2xb
         99rL5a2XNmi43BMFtH4vRagt0NF8PF49eM0587Qt9i9aszVyPBqVYSXhPJpWKVeXYjeR
         Apyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vPQAq5rL2RT0Kb9F+IBKUZ7s46kdUygloMmy2B3StMk=;
        b=nDenZb1WHyhleVa+o1ns1d+eKWKEl1S3k+eLwyWd8+0wYjqR05n2fkXcIjM58mAbHc
         68QsHJaqetMWR9xzP6Age+RN7p4bcFSKcDJgmSqOYkxTiYgz7PqUGl8RCul9eOzSuT5U
         sEM/mwZuUUHRuvtwNDMwjd4KiJaz/YWbvM+y3Ks2QsKUO9B4ul/e1BYzBmdO4XArbKEp
         QU3UDCm2guIKxrJ6bN/l7rAl9Nl8lvgltV4T5sz8WAYSYMWXWH0Vv8LHeseTLRgLUtT2
         ZSCFxFkt6szX3j9TM/k/ByBS2on4nB3zQeUKby4pQA4VU+TsQjk/j1ZZGwrc4lzfe07S
         JxmQ==
X-Gm-Message-State: AOAM533hD5H/mtVdJ6kAUm4+3lb4W81Rjs/CTtwmlz6f7vw2giRi+pE+
        4zhzG/pmQYB2mln62P1XPmQGoYH5gGE=
X-Google-Smtp-Source: ABdhPJxgzeDOCkx4hcpYPg9j6u4A3E+wn29nJNwVoOMepXr3gi3l/a9oojPD1pHmHtWlE1z9OozAIA==
X-Received: by 2002:a1c:790f:: with SMTP id l15mr2773250wme.188.1610107225367;
        Fri, 08 Jan 2021 04:00:25 -0800 (PST)
Received: from ?IPv6:2003:ea:8f06:5500:6dbb:aa76:4e1a:5cc4? (p200300ea8f0655006dbbaa764e1a5cc4.dip0.t-ipconnect.de. [2003:ea:8f06:5500:6dbb:aa76:4e1a:5cc4])
        by smtp.googlemail.com with ESMTPSA id s12sm11847874wmh.29.2021.01.08.04.00.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Jan 2021 04:00:24 -0800 (PST)
Subject: [PATCH net-next v2 2/3] r8169: improve rtl_ocp_reg_failure
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <938caef4-8a0b-bbbd-66aa-76f758ff877a@gmail.com>
Message-ID: <502d3af4-bef0-c6c3-0858-5156124df7ac@gmail.com>
Date:   Fri, 8 Jan 2021 12:58:54 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <938caef4-8a0b-bbbd-66aa-76f758ff877a@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use WARN_ONCE here to get a call trace in case of a problem.
This facilitates finding the offending code part.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 9af048ad0..6005d37b6 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -810,14 +810,9 @@ static void rtl_eri_clear_bits(struct rtl8169_private *tp, int addr, u32 m)
 	rtl_w0w1_eri(tp, addr, 0, m);
 }
 
-static bool rtl_ocp_reg_failure(struct rtl8169_private *tp, u32 reg)
+static bool rtl_ocp_reg_failure(u32 reg)
 {
-	if (reg & 0xffff0001) {
-		if (net_ratelimit())
-			netdev_err(tp->dev, "Invalid ocp reg %x!\n", reg);
-		return true;
-	}
-	return false;
+	return WARN_ONCE(reg & 0xffff0001, "Invalid ocp reg %x!\n", reg);
 }
 
 DECLARE_RTL_COND(rtl_ocp_gphy_cond)
@@ -827,7 +822,7 @@ DECLARE_RTL_COND(rtl_ocp_gphy_cond)
 
 static void r8168_phy_ocp_write(struct rtl8169_private *tp, u32 reg, u32 data)
 {
-	if (rtl_ocp_reg_failure(tp, reg))
+	if (rtl_ocp_reg_failure(reg))
 		return;
 
 	RTL_W32(tp, GPHY_OCP, OCPAR_FLAG | (reg << 15) | data);
@@ -837,7 +832,7 @@ static void r8168_phy_ocp_write(struct rtl8169_private *tp, u32 reg, u32 data)
 
 static int r8168_phy_ocp_read(struct rtl8169_private *tp, u32 reg)
 {
-	if (rtl_ocp_reg_failure(tp, reg))
+	if (rtl_ocp_reg_failure(reg))
 		return 0;
 
 	RTL_W32(tp, GPHY_OCP, reg << 15);
@@ -848,7 +843,7 @@ static int r8168_phy_ocp_read(struct rtl8169_private *tp, u32 reg)
 
 static void r8168_mac_ocp_write(struct rtl8169_private *tp, u32 reg, u32 data)
 {
-	if (rtl_ocp_reg_failure(tp, reg))
+	if (rtl_ocp_reg_failure(reg))
 		return;
 
 	RTL_W32(tp, OCPDR, OCPAR_FLAG | (reg << 15) | data);
@@ -856,7 +851,7 @@ static void r8168_mac_ocp_write(struct rtl8169_private *tp, u32 reg, u32 data)
 
 static u16 r8168_mac_ocp_read(struct rtl8169_private *tp, u32 reg)
 {
-	if (rtl_ocp_reg_failure(tp, reg))
+	if (rtl_ocp_reg_failure(reg))
 		return 0;
 
 	RTL_W32(tp, OCPDR, reg << 15);
-- 
2.30.0



