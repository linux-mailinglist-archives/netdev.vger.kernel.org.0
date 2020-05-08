Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EE301CB9DB
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 23:33:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727898AbgEHVdG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 17:33:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726811AbgEHVdF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 17:33:05 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C760C061A0C
        for <netdev@vger.kernel.org>; Fri,  8 May 2020 14:33:05 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id z8so3588413wrw.3
        for <netdev@vger.kernel.org>; Fri, 08 May 2020 14:33:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HnexJduuyxX/q1yelru7QeqBQyTSFXqwvFwr4ShZP2A=;
        b=DQx+vA+uihRr/LmzZ/cBFFfuo4DTxSIX8VryqlExMgNcPn0XPbE+tFkeLzHAo12+WU
         R8ZVd/J+xqeMgUr+eSSnxYbOFsxw9pE2gKWm/dJeqfzTggiXvzda3vj1P+DWt2bbtEQu
         A/v3VdvXgUAta67HbsqrGYqTSE8gY6LippFw8GnP1W8EvKcGMSSHChMpuJi3Y5nse32o
         UHh77tMORFuJUEZ6/BT6lZAjQTN55hp2jOPhoUxzDVu92MBhhrZnlI54MjYf+nopgwIh
         rgf3cgohrWBNDcc+tL3P4dpo+BCdsXpWwkOqiHawhf8sBDDdeRFViCUHo3Ge2y9pVaXM
         UqFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HnexJduuyxX/q1yelru7QeqBQyTSFXqwvFwr4ShZP2A=;
        b=e2qEgIsK/Q3ynbHrsIhJv6MsxPrY5v47lqv/78lsLKAElVUd1F030aCrY5hKD4+WP8
         5G07yZBWrlnf029B5CbNofesSbZ8p8kKQn24bCPiQCCH4JlEiu1xnevejIrLHipRvM5f
         Vl/7ok2Zzm21cubUJHwaVrxsd09xeSgk3tx8ZKRb1p/b6AtNwQsLxxgyTO3WHhJyRd24
         ZcY7ixm3JZA6ISxUWszFQioFDkcvmbV6uHfPUzjB12Jl0dDwi0j/lGuqajwleklXj9KU
         4jgKMOeQCsket9c+vgBLW19UUmghuktIFUG0EZ0qEWR7UThcaCPDlsubNViGitE5iFd+
         O7LQ==
X-Gm-Message-State: AGi0PuZDnBb0HUe3kFA9dwbfSJqe+qN3uP/ZHgSDvildp3JCCqjw3eNk
        F8972sSilkcg+OTNOuCqyPGv317O
X-Google-Smtp-Source: APiQypLhtdwAbtic5BQHucR5GBphADxhf1kjjXTJ8kzSxXcuuZA18TboCQyQGf7N2aBHC8bCUklIjQ==
X-Received: by 2002:adf:e586:: with SMTP id l6mr5030158wrm.184.1588973583858;
        Fri, 08 May 2020 14:33:03 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f28:5200:b9ec:f867:184c:fa95? (p200300EA8F285200B9ECF867184CFA95.dip0.t-ipconnect.de. [2003:ea:8f28:5200:b9ec:f867:184c:fa95])
        by smtp.googlemail.com with ESMTPSA id p14sm4948742wmg.36.2020.05.08.14.33.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 May 2020 14:33:03 -0700 (PDT)
Subject: [PATCH net-next 3/4] r8169: add helper rtl_wait_txrx_fifo_empty
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <ae5fb819-26e4-d796-2783-2ed5212d0146@gmail.com>
Message-ID: <6cb4dbe3-ae7f-ef56-39d9-149a2802832a@gmail.com>
Date:   Fri, 8 May 2020 23:31:46 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <ae5fb819-26e4-d796-2783-2ed5212d0146@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a helper for waiting for FIFO's to be empty, again the name is
borrowed from the vendor driver.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 35 ++++++++++++++---------
 1 file changed, 21 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index eb26c3477..7ea58bd9b 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -2496,10 +2496,31 @@ DECLARE_RTL_COND(rtl_txcfg_empty_cond)
 	return RTL_R32(tp, TxConfig) & TXCFG_EMPTY;
 }
 
+DECLARE_RTL_COND(rtl_rxtx_empty_cond)
+{
+	return (RTL_R8(tp, MCU) & RXTX_EMPTY) == RXTX_EMPTY;
+}
+
+static void rtl_wait_txrx_fifo_empty(struct rtl8169_private *tp)
+{
+	switch (tp->mac_version) {
+	case RTL_GIGA_MAC_VER_40 ... RTL_GIGA_MAC_VER_52:
+		rtl_loop_wait_high(tp, &rtl_txcfg_empty_cond, 100, 42);
+		rtl_loop_wait_high(tp, &rtl_rxtx_empty_cond, 100, 42);
+		break;
+	case RTL_GIGA_MAC_VER_60 ... RTL_GIGA_MAC_VER_61:
+		rtl_loop_wait_high(tp, &rtl_rxtx_empty_cond, 100, 42);
+		break;
+	default:
+		break;
+	}
+}
+
 static void rtl_enable_rxdvgate(struct rtl8169_private *tp)
 {
 	RTL_W32(tp, MISC, RTL_R32(tp, MISC) | RXDV_GATED_EN);
 	fsleep(2000);
+	rtl_wait_txrx_fifo_empty(tp);
 }
 
 static void rtl8169_hw_reset(struct rtl8169_private *tp)
@@ -5068,11 +5089,6 @@ static void r8168g_wait_ll_share_fifo_ready(struct rtl8169_private *tp)
 	rtl_loop_wait_high(tp, &rtl_link_list_ready_cond, 100, 42);
 }
 
-DECLARE_RTL_COND(rtl_rxtx_empty_cond)
-{
-	return (RTL_R8(tp, MCU) & RXTX_EMPTY) == RXTX_EMPTY;
-}
-
 static int r8169_mdio_read_reg(struct mii_bus *mii_bus, int phyaddr, int phyreg)
 {
 	struct rtl8169_private *tp = mii_bus->priv;
@@ -5141,12 +5157,6 @@ static void rtl_hw_init_8168g(struct rtl8169_private *tp)
 {
 	rtl_enable_rxdvgate(tp);
 
-	if (!rtl_loop_wait_high(tp, &rtl_txcfg_empty_cond, 100, 42))
-		return;
-
-	if (!rtl_loop_wait_high(tp, &rtl_rxtx_empty_cond, 100, 42))
-		return;
-
 	RTL_W8(tp, ChipCmd, RTL_R8(tp, ChipCmd) & ~(CmdTxEnb | CmdRxEnb));
 	msleep(1);
 	RTL_W8(tp, MCU, RTL_R8(tp, MCU) & ~NOW_IS_OOB);
@@ -5162,9 +5172,6 @@ static void rtl_hw_init_8125(struct rtl8169_private *tp)
 {
 	rtl_enable_rxdvgate(tp);
 
-	if (!rtl_loop_wait_high(tp, &rtl_rxtx_empty_cond, 100, 42))
-		return;
-
 	RTL_W8(tp, ChipCmd, RTL_R8(tp, ChipCmd) & ~(CmdTxEnb | CmdRxEnb));
 	msleep(1);
 	RTL_W8(tp, MCU, RTL_R8(tp, MCU) & ~NOW_IS_OOB);
-- 
2.26.2


