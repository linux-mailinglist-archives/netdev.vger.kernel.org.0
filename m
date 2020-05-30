Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A31E1E941B
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 00:00:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728741AbgE3WAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 18:00:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729361AbgE3WAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 May 2020 18:00:21 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FAF9C03E969
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 15:00:21 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id h5so1747942wrc.7
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 15:00:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ieWtCakj/v4SpzQWaaN0FVFlpC/V1OHkYE8bfoCFu/U=;
        b=WpGwjJXJv/cuY/qJ9ajoLy8xmOgYCScoTyIG7Zqo2PUcWZHSyu9xt4BCXvu7bSU/Cv
         1ZOtvDwLwy10PE1gwt81ycvBmwFYxJBt+34c6elOR/qxl5qobod5Z+i+PqhRm8vK1F+k
         Skj9ZB5ygrjM+HqhbPz2vAiIt8H8yssmbCpJOHHEapuaNE94i+jlY/rcYtyj3/IGaV8+
         9A5/dS24CGY/pEFGhzpufYLVctQ13ku9lToB6Xj1X3avuCDdl9S8y+tL5FX4f/EB/3Lq
         cfbUMAp5NX4R9fmKAbuVBmlV0C27/a9D7iZCetU55A6PTmiRspXzoCw06l9oo1YHzQyn
         s1gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ieWtCakj/v4SpzQWaaN0FVFlpC/V1OHkYE8bfoCFu/U=;
        b=sM94dmoiiinMFlyos7QXI9vx5Vv5DzaRp2t3bcjkdD3aBLM9C8wl+wUd0fTF2lWW8X
         PZJj+3+Sl5x1zwE5k/Jx17K9TvLUbOBhOlOTfMLl/u/jGG8cZbfSYcepJvrgM6qLhnWb
         TgWqtT45aTB4UJWdDi0/wo+ExJYP2L0+UwmBdEjyYvLAw58/c97LFNHZmmFiiP+wNdV0
         LeyF8IhofigbEg5s0lwd9Gc0OktI0ozK/SyMwdn2u3/jk++puiwELGyybxJlgI76BwEQ
         1fLpiVuNyJK5HyGbOCvP1FJ/Yhdtk5VHu3OYQMPNddb6c+TaxMmOgrcTqkNo3O5FXfXb
         5w+Q==
X-Gm-Message-State: AOAM530Qd5DXZwqRzm5D2VYH7ElaGfIECVg8OtulUBfnPYbh7m+/2s9z
        vuTgurfB4/l7c5N+p7wgaqSxPv2h
X-Google-Smtp-Source: ABdhPJyktxnht8cwjbHMZh5l69dSK1n62Wh2MLofbBNc0QeIEjRP41C6xlCDPEDUGHGp3dXQeCJd5Q==
X-Received: by 2002:adf:e744:: with SMTP id c4mr16032350wrn.71.1590876019820;
        Sat, 30 May 2020 15:00:19 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:5700:8c73:80e5:b6ba:d8b0? (p200300ea8f2357008c7380e5b6bad8b0.dip0.t-ipconnect.de. [2003:ea:8f23:5700:8c73:80e5:b6ba:d8b0])
        by smtp.googlemail.com with ESMTPSA id j5sm15200684wrm.57.2020.05.30.15.00.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 May 2020 15:00:19 -0700 (PDT)
Subject: [PATCH net-next 4/6] r8169: move some calls to rtl8169_hw_reset
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <443c14ac-24b8-58ba-05aa-3803f1e5f4ab@gmail.com>
Message-ID: <ed7bc852-df26-80e7-0a39-55b909463098@gmail.com>
Date:   Sat, 30 May 2020 23:57:10 +0200
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

Move calls that are needed before and after calling rtl8169_hw_reset()
into this function. This requires to move the function in the code.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 75 +++++++++++------------
 1 file changed, 36 insertions(+), 39 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 43652c450..5f3c50fb0 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -2530,36 +2530,6 @@ static void rtl_enable_rxdvgate(struct rtl8169_private *tp)
 	rtl_wait_txrx_fifo_empty(tp);
 }
 
-static void rtl8169_hw_reset(struct rtl8169_private *tp)
-{
-	/* Disable interrupts */
-	rtl8169_irq_mask_and_ack(tp);
-
-	rtl_rx_close(tp);
-
-	switch (tp->mac_version) {
-	case RTL_GIGA_MAC_VER_27:
-	case RTL_GIGA_MAC_VER_28:
-	case RTL_GIGA_MAC_VER_31:
-		rtl_loop_wait_low(tp, &rtl_npq_cond, 20, 2000);
-		break;
-	case RTL_GIGA_MAC_VER_34 ... RTL_GIGA_MAC_VER_38:
-		RTL_W8(tp, ChipCmd, RTL_R8(tp, ChipCmd) | StopReq);
-		rtl_loop_wait_high(tp, &rtl_txcfg_empty_cond, 100, 666);
-		break;
-	case RTL_GIGA_MAC_VER_40 ... RTL_GIGA_MAC_VER_61:
-		rtl_enable_rxdvgate(tp);
-		fsleep(2000);
-		break;
-	default:
-		RTL_W8(tp, ChipCmd, RTL_R8(tp, ChipCmd) | StopReq);
-		udelay(100);
-		break;
-	}
-
-	rtl_hw_reset(tp);
-}
-
 static void rtl_set_tx_config_registers(struct rtl8169_private *tp)
 {
 	u32 val = TX_DMA_BURST << TxDMAShift |
@@ -3958,6 +3928,42 @@ static void rtl8169_tx_clear(struct rtl8169_private *tp)
 	netdev_reset_queue(tp->dev);
 }
 
+static void rtl8169_hw_reset(struct rtl8169_private *tp)
+{
+	/* Give a racing hard_start_xmit a few cycles to complete. */
+	synchronize_rcu();
+
+	/* Disable interrupts */
+	rtl8169_irq_mask_and_ack(tp);
+
+	rtl_rx_close(tp);
+
+	switch (tp->mac_version) {
+	case RTL_GIGA_MAC_VER_27:
+	case RTL_GIGA_MAC_VER_28:
+	case RTL_GIGA_MAC_VER_31:
+		rtl_loop_wait_low(tp, &rtl_npq_cond, 20, 2000);
+		break;
+	case RTL_GIGA_MAC_VER_34 ... RTL_GIGA_MAC_VER_38:
+		RTL_W8(tp, ChipCmd, RTL_R8(tp, ChipCmd) | StopReq);
+		rtl_loop_wait_high(tp, &rtl_txcfg_empty_cond, 100, 666);
+		break;
+	case RTL_GIGA_MAC_VER_40 ... RTL_GIGA_MAC_VER_61:
+		rtl_enable_rxdvgate(tp);
+		fsleep(2000);
+		break;
+	default:
+		RTL_W8(tp, ChipCmd, RTL_R8(tp, ChipCmd) | StopReq);
+		fsleep(100);
+		break;
+	}
+
+	rtl_hw_reset(tp);
+
+	rtl8169_tx_clear(tp);
+	rtl8169_init_ring_indexes(tp);
+}
+
 static void rtl_reset_work(struct rtl8169_private *tp)
 {
 	struct net_device *dev = tp->dev;
@@ -3965,16 +3971,12 @@ static void rtl_reset_work(struct rtl8169_private *tp)
 
 	napi_disable(&tp->napi);
 	netif_stop_queue(dev);
-	synchronize_rcu();
 
 	rtl8169_hw_reset(tp);
 
 	for (i = 0; i < NUM_RX_DESC; i++)
 		rtl8169_mark_to_asic(tp->RxDescArray + i);
 
-	rtl8169_tx_clear(tp);
-	rtl8169_init_ring_indexes(tp);
-
 	napi_enable(&tp->napi);
 	rtl_hw_start(tp);
 	netif_wake_queue(dev);
@@ -4636,11 +4638,6 @@ static void rtl8169_down(struct net_device *dev)
 
 	rtl8169_hw_reset(tp);
 
-	/* Give a racing hard_start_xmit a few cycles to complete. */
-	synchronize_rcu();
-
-	rtl8169_tx_clear(tp);
-
 	rtl8169_rx_clear(tp);
 
 	rtl_pll_power_down(tp);
-- 
2.26.2


