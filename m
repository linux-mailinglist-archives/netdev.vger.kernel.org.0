Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF2042F03FA
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 23:02:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726216AbhAIWCB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jan 2021 17:02:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726062AbhAIWCB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Jan 2021 17:02:01 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9778EC061786
        for <netdev@vger.kernel.org>; Sat,  9 Jan 2021 14:01:20 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id g185so11444696wmf.3
        for <netdev@vger.kernel.org>; Sat, 09 Jan 2021 14:01:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=A58bqbte09j/S6kQElqfLXG75xD/nuBPe8OvUZ9+gnk=;
        b=uh1xxdmKLnSMP9DnKhQ/3irJDFbd2jhfmpr/wrkofMWTNwOup/n+YxRBQtXvQYc90N
         8XIrBD9lb0Vv3f6WvKuKPrBjaC6qmQ8u1yGmC4yZxmcgSxeiD7hxZ6otUMJyHbAwDjFb
         L/yUQpeMaHxaUrAYUvu/DVf5i3tku1QkEq9OK9VsZGI0420WKAd3Eyqw7Mlj+1Wte9TD
         1sOTw2WQpfHkQfYxJq2xT40zWqr6leJxF+coktcoQlZBAaHwDGyyZIMvB6QDDTCurpwf
         vYhesgm4qRo3zOZIUwMyKxpMER9OIa5yyzsvKJY8onYOHg/KaMUNc268PhMnP2kVAMFu
         xRSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=A58bqbte09j/S6kQElqfLXG75xD/nuBPe8OvUZ9+gnk=;
        b=H6safMxgi99vOzbotedCA91TknObcIXs04xCZiTYNZQjnDKjhODCkabc6KaxYTWaNz
         wAvAA4/CCFtJ+ede2GGSWcqEDULti1UQF1RKk8RK1YK+n7QTT+Co0Mjj2Pu1jELcvNh0
         vXGBn9cO2AfBVlW7YI8F+3V0nE8WO2Xv4Jl2eClmh7xtnepxP2wDCul4fa4PAZ1wQdeo
         KXRuc+ZR/fZjDQTRHCvzTUC2AH1uEsJCcC6et3LWwmH/rqY9uzeohHJW0HTzy1AL/9dG
         KgwVOE/N+YNurcsPQUHnqT7j+/QDpJROYtw+Fb/W6K0TeKcphrZJn2eTxoSi3Xux7CDI
         WOUw==
X-Gm-Message-State: AOAM530VrLfF0ew53CTSTEB5F9E15a22/1ao1vTnbM2svxiSP5pEfZLj
        TmLrzy2QL+87FvPIt51tH4ufWNaaWe0=
X-Google-Smtp-Source: ABdhPJymMdf7rMdt1dROr2NA/geIO09lMtvUMKh3da+9qi3K8hTQPr6J0iRRUFC6OfNrZYUo2b19qg==
X-Received: by 2002:a05:600c:2306:: with SMTP id 6mr8584483wmo.53.1610229679054;
        Sat, 09 Jan 2021 14:01:19 -0800 (PST)
Received: from ?IPv6:2003:ea:8f06:5500:a584:5efe:3c65:46c1? (p200300ea8f065500a5845efe3c6546c1.dip0.t-ipconnect.de. [2003:ea:8f06:5500:a584:5efe:3c65:46c1])
        by smtp.googlemail.com with ESMTPSA id l16sm18610798wrx.5.2021.01.09.14.01.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 09 Jan 2021 14:01:18 -0800 (PST)
Subject: [PATCH net-next 2/2] r8169: tweak max read request size for newer
 chips also in jumbo mtu mode
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <1dd337a0-ff5a-3fa0-91f5-45e86c0fce58@gmail.com>
Message-ID: <1b681298-33ff-8ff0-ffc8-aa8110d3d1fc@gmail.com>
Date:   Sat, 9 Jan 2021 23:01:18 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <1dd337a0-ff5a-3fa0-91f5-45e86c0fce58@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

So far we don't increase the max read request size if we switch to
jumbo mode before bringing up the interface for the first time.
Let's change this.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 8336f1434..6e4c60185 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -2315,13 +2315,14 @@ static void r8168b_1_hw_jumbo_disable(struct rtl8169_private *tp)
 static void rtl_jumbo_config(struct rtl8169_private *tp)
 {
 	bool jumbo = tp->dev->mtu > ETH_DATA_LEN;
+	int readrq = 4096;
 
 	rtl_unlock_config_regs(tp);
 	switch (tp->mac_version) {
 	case RTL_GIGA_MAC_VER_12:
 	case RTL_GIGA_MAC_VER_17:
 		if (jumbo) {
-			pcie_set_readrq(tp->pci_dev, 512);
+			readrq = 512;
 			r8168b_1_hw_jumbo_enable(tp);
 		} else {
 			r8168b_1_hw_jumbo_disable(tp);
@@ -2329,7 +2330,7 @@ static void rtl_jumbo_config(struct rtl8169_private *tp)
 		break;
 	case RTL_GIGA_MAC_VER_18 ... RTL_GIGA_MAC_VER_26:
 		if (jumbo) {
-			pcie_set_readrq(tp->pci_dev, 512);
+			readrq = 512;
 			r8168c_hw_jumbo_enable(tp);
 		} else {
 			r8168c_hw_jumbo_disable(tp);
@@ -2352,8 +2353,8 @@ static void rtl_jumbo_config(struct rtl8169_private *tp)
 	}
 	rtl_lock_config_regs(tp);
 
-	if (!jumbo && pci_is_pcie(tp->pci_dev) && tp->supports_gmii)
-		pcie_set_readrq(tp->pci_dev, 4096);
+	if (pci_is_pcie(tp->pci_dev) && tp->supports_gmii)
+		pcie_set_readrq(tp->pci_dev, readrq);
 }
 
 DECLARE_RTL_COND(rtl_chipcmd_cond)
-- 
2.30.0


