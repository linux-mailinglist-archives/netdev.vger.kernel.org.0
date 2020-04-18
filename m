Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 160511AF515
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 23:11:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728251AbgDRVLt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 17:11:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726014AbgDRVLr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Apr 2020 17:11:47 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27832C061A0C
        for <netdev@vger.kernel.org>; Sat, 18 Apr 2020 14:11:47 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id t14so7222648wrw.12
        for <netdev@vger.kernel.org>; Sat, 18 Apr 2020 14:11:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=eoJvnCZ18FXzPLy1PF9pAf+TX6PSbIFPFpBqeJgLPU0=;
        b=h5U/nQ6Upnm1YsEBzqZI84DhVTx/9s4ZY9yPCuZrYZfwDKIGfaQiDjLiYoeqq5VgJG
         VwJmPJgmF4yCaGinNF6uM0utyy2pHSwC3GuTxyn8asYYSGxa5XbCc+rTnMc6Br0Evz4h
         SXEJcTolmtNx6FRynSd1YrmAuYi4yAMAHys7SP0xUbY+vGsukNttwvKyrWGZ044ioZtt
         aB6ueF2XM6zMtNKeqZMXjST7LY9tkkJv+ys8HfbMN3dPlGDDIyilBzhY8xkStotIMRDD
         YYPAoopzVC2R1hzPUkmOP5s39CKCDviacT+B2DlZ8/KTUvQrciV1FJq1dG/0b5xEEGf1
         bKLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eoJvnCZ18FXzPLy1PF9pAf+TX6PSbIFPFpBqeJgLPU0=;
        b=T9ZmuxtIFol76wyso4fcj/Y8W1EQVb/rC1WkYekb0/ngWXRmbAh+T710qQ4ab7HNHr
         yMxgri3TMuWcev1PAbuaQj3ws0APfCFGddhxAu2HEdhjvGH6iDmrqDKlezRs2HvLPGm2
         gJDKt0i5AsTmOtIMIW5rX2wM3tYpigDGjhfo93KHBEVwGQV3Dzcx+xAHtB71yHwjZvT6
         ysIwUjgmsImWX6qhh6FXgTyzJpTEvqem7u/7BoNAkPz2b1bS3E2oqXNdDhwKwhgawK0Q
         W8ivZ7CLt1U6z5PiCCSwGcN2bIuSdye7y5TgjjchrkvW1ea/q8Aiei9oPKIJCybWfmea
         qNFQ==
X-Gm-Message-State: AGi0PubN3JG7Kw7tsGxZYgRAEcZyWW+3BqE8Dy1eWYX9rMeo/BOPGDtc
        zSKv0mGBSzimABJ49i9uXNyMJfnJ
X-Google-Smtp-Source: APiQypLum/iC6pLbVToYcXzpdZcGjjl3X5on0kSTCg1Z6zXAQt9VKDRwnajvUjqujsAGXg2Mf+fuUg==
X-Received: by 2002:adf:b344:: with SMTP id k4mr10242842wrd.76.1587244305687;
        Sat, 18 Apr 2020 14:11:45 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:939:e10c:14c5:fe9f? (p200300EA8F2960000939E10C14C5FE9F.dip0.t-ipconnect.de. [2003:ea:8f29:6000:939:e10c:14c5:fe9f])
        by smtp.googlemail.com with ESMTPSA id e15sm36539365wrt.16.2020.04.18.14.11.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Apr 2020 14:11:45 -0700 (PDT)
Subject: [PATCH net-next 3/6] r8169: preserve VLAN setting on RTL8125 in
 rtl_init_rxcfg
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <f7c53dc0-768c-7eb9-ffc0-b2e39b1ddfa4@gmail.com>
Message-ID: <19acd6ee-a070-1707-8b1c-e3433c3a683e@gmail.com>
Date:   Sat, 18 Apr 2020 23:08:43 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <f7c53dc0-768c-7eb9-ffc0-b2e39b1ddfa4@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

So far we set RX_VLAN_8125 unconditionally, even if
NETIF_F_HW_VLAN_CTAG_RX may not be set. Don't touch these bits,
and let only rtl8169_set_features() control them.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 2e4353071..af10b6398 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -2395,6 +2395,8 @@ static void rtl_pll_power_up(struct rtl8169_private *tp)
 
 static void rtl_init_rxcfg(struct rtl8169_private *tp)
 {
+	u32 vlan;
+
 	switch (tp->mac_version) {
 	case RTL_GIGA_MAC_VER_02 ... RTL_GIGA_MAC_VER_06:
 	case RTL_GIGA_MAC_VER_10 ... RTL_GIGA_MAC_VER_17:
@@ -2409,8 +2411,9 @@ static void rtl_init_rxcfg(struct rtl8169_private *tp)
 		RTL_W32(tp, RxConfig, RX128_INT_EN | RX_MULTI_EN | RX_DMA_BURST | RX_EARLY_OFF);
 		break;
 	case RTL_GIGA_MAC_VER_60 ... RTL_GIGA_MAC_VER_61:
-		RTL_W32(tp, RxConfig, RX_FETCH_DFLT_8125 | RX_VLAN_8125 |
-				      RX_DMA_BURST);
+		/* VLAN flags are controlled by NETIF_F_HW_VLAN_CTAG_RX */
+		vlan = RTL_R32(tp, RxConfig) & RX_VLAN_8125;
+		RTL_W32(tp, RxConfig, vlan | RX_FETCH_DFLT_8125 | RX_DMA_BURST);
 		break;
 	default:
 		RTL_W32(tp, RxConfig, RX128_INT_EN | RX_DMA_BURST);
-- 
2.26.1


