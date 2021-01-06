Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AD332EBEAB
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 14:30:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726477AbhAFNaO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 08:30:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725788AbhAFNaN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 08:30:13 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D69AC06134D
        for <netdev@vger.kernel.org>; Wed,  6 Jan 2021 05:29:33 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id c5so2439764wrp.6
        for <netdev@vger.kernel.org>; Wed, 06 Jan 2021 05:29:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vPQAq5rL2RT0Kb9F+IBKUZ7s46kdUygloMmy2B3StMk=;
        b=qcIVgM5q6DjBWZsspgRGvCLE3aqBeSslFqtcj+UXMfAnmFyNXy20QMmuSN9/qqZp24
         K5Y9VeCEyS1b8nMZNXdsqVPHsQUisg440x9QOBXEsGg4B3KWlabOLqhSlZPfN5wlHU7J
         ssEaBLK5QRfl2rwkxrDfLxCGQACz4uolTns9EJCSockPXNsK1AFwLHhAGE50dsA9uuA4
         RwhjisC/8sQufqN3z6Gn2W1GdOTxuz3RAskaJodgqv25gtSPHs1is/cYqBWgH+EtpvhI
         oYKBkUEWSWYpAyna+AJIJHqXEUbG1tbkY65FypDhx3qjV9qVzKY3+wqfCIvnlAeqyZQK
         gTNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vPQAq5rL2RT0Kb9F+IBKUZ7s46kdUygloMmy2B3StMk=;
        b=VluxTVNoVj0zd4sugacn7coEOyEtU9G7BZHx3chZTIGVXyOLrKReQ3njoIpwmEkq0n
         WsNghETX0XTWCJcGkgDYznKLGZLys5+zsNplcoY6/f1BcU3eQuIahD6B8SvPKYEE2n3m
         AbaBRLZy+lf0tZLtATzbhGF8qVhm+V4YNJDBc2NNMXgRvFsnB0x1HJGoQ+0/bBz/itO5
         ayrNFM9j7L4hr0xeM0Vit+eTrSObTAxdcdqaG7S5T60dODn3voUc+FXCyG4fud99OSTa
         Ct6FZFQhTosmAW7hOQu0EOXYhzmd8KECPEwDRIoUd/26tMiwXhyPKslVFc6ZbuCBbqJg
         cM4A==
X-Gm-Message-State: AOAM533motTguikZWDDg9f/TnPf5Y3KSYYEyWIb7WQ6MsODmeVrfWf0M
        UFwuItO2tfmcmkPY4wzS3Xp21ROQMBc=
X-Google-Smtp-Source: ABdhPJyw3NXbHC561kEz06RMRH07Pix7DwC5+RISwdWw9ZPjpd6skZBhWZc4lAkuH3GZ2DovI6Yk2w==
X-Received: by 2002:a5d:6708:: with SMTP id o8mr4355150wru.64.1609939771592;
        Wed, 06 Jan 2021 05:29:31 -0800 (PST)
Received: from ?IPv6:2003:ea:8f06:5500:e1db:b990:7e09:f1cf? (p200300ea8f065500e1dbb9907e09f1cf.dip0.t-ipconnect.de. [2003:ea:8f06:5500:e1db:b990:7e09:f1cf])
        by smtp.googlemail.com with ESMTPSA id t16sm3316974wmi.3.2021.01.06.05.29.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Jan 2021 05:29:31 -0800 (PST)
Subject: [PATCH net-next 2/3] r8169: improve rtl_ocp_reg_failure
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <f89bf2f3-5324-b635-4253-8a8be316c15b@gmail.com>
Message-ID: <9c543ff7-0ef6-917b-cd71-3e4c28812952@gmail.com>
Date:   Wed, 6 Jan 2021 14:28:41 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <f89bf2f3-5324-b635-4253-8a8be316c15b@gmail.com>
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


