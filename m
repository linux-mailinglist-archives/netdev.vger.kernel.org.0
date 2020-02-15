Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 737BC15FEB6
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 14:54:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726486AbgBONyp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Feb 2020 08:54:45 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:56243 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726129AbgBONyn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Feb 2020 08:54:43 -0500
Received: by mail-wm1-f65.google.com with SMTP id q9so12875315wmj.5
        for <netdev@vger.kernel.org>; Sat, 15 Feb 2020 05:54:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=s70Fx1J7f/kNFsSusTDk60ncywYX+PBPyd+kpayAtm4=;
        b=O9gyzNvzIQxmB7pb0FJ9vAChOb0ptM0TnaQjTxnU2FcZ8i6F0zuuIue8d/wYERAW3G
         g8+gnf6KcW9wnsyoHe1AZkUlnh3K3bk3TH26o4Pm8VLep5uhEdDvtu10qdOpbJA0YIUs
         ixG51Qvk+7VwcHVXyqaMe5saFKfzZe4QGH+YUPmJW8jy3zlNkzrlIWNBIjhd5SZ/Qz8s
         qaCuG91tKIM+5tFvdBLCk8Qos+PNVTGLFtAEGXBAboIutMcDK/Am5IxmfBOKLABjxI2t
         fDw5Ser6Hj83qM+TS4+uC3pQPMuJsyst2Ip2jBLNeUTW/WH+9nym4YUzjyivejm3hSCD
         Wkew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=s70Fx1J7f/kNFsSusTDk60ncywYX+PBPyd+kpayAtm4=;
        b=kFPRke5bSNP5pFJ/roz/JbuZFQ081+YIk50xUnux5jcG86TbNh/Whaq2V2/D3AcQes
         86z7FxE8ZDFftgvfYngC4cr2eIj3PqXELdcs8PiXIg6xpPyt3OGirsvv/lHIXTURDtKb
         5OTIY8RyeizUJK8hHO3V8s+cd7c6TokP2lQNvXq9uht+XNXlOGUXok53moysGELppfqx
         rHfbYdM+1H7ciiBZ90dpQ1IE7LSQZGQWEJUro+hXlvzP8SrjotodZDOt1IjTsJmBUkXJ
         zhWN9dyxiqFAvpr3GHqC/qflCqIdI+0QD8tAczAwqryTzhGak9QwVxv/4/fRCRQn3Eq6
         FdXA==
X-Gm-Message-State: APjAAAU4BjPfi/SnGYVxp1ukoVSP10a929llHWujAhStnt5UR3Ojswus
        gT6XzQkz6wp9qSasEbkFGOMFvu8b
X-Google-Smtp-Source: APXvYqw4uO/6GUHn1tKv2JEf8hylNCf3SBXwbqm/nRzW1HciNnMzxA+WoP+OcU69Qu/KA+sFu7ux2A==
X-Received: by 2002:a1c:a1c3:: with SMTP id k186mr11099948wme.179.1581774880834;
        Sat, 15 Feb 2020 05:54:40 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:1ddf:2e8f:533:981f? (p200300EA8F2960001DDF2E8F0533981F.dip0.t-ipconnect.de. [2003:ea:8f29:6000:1ddf:2e8f:533:981f])
        by smtp.googlemail.com with ESMTPSA id a6sm11606800wrm.69.2020.02.15.05.54.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 15 Feb 2020 05:54:40 -0800 (PST)
Subject: [PATCH net-next 7/7] r8169: improve statistics of missed rx packets
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <bd37db86-a725-57b3-4618-527597752798@gmail.com>
Message-ID: <58a0685d-f7d2-ce1e-7b13-7e6ce2a59a50@gmail.com>
Date:   Sat, 15 Feb 2020 14:54:14 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <bd37db86-a725-57b3-4618-527597752798@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Register RxMissed exists on few early chip versions only, however all
chip versions have the number of missed RX packets in the hardware
counters. Therefore remove using RxMissed and get the number of missed
RX packets from the hardware stats.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 29 ++++-------------------
 1 file changed, 4 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index ce4cb7d7b..ad4bb5ac6 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -212,7 +212,6 @@ enum rtl_registers {
 					/* Unlimited maximum PCI burst. */
 #define	RX_DMA_BURST			(7 << RXCFG_DMA_SHIFT)
 
-	RxMissed	= 0x4c,
 	Cfg9346		= 0x50,
 	Config0		= 0x51,
 	Config1		= 0x52,
@@ -576,6 +575,7 @@ struct rtl8169_tc_offsets {
 	__le64	tx_errors;
 	__le32	tx_multi_collision;
 	__le16	tx_aborted;
+	__le16	rx_missed;
 };
 
 enum rtl_flag {
@@ -1690,6 +1690,7 @@ static bool rtl8169_init_counter_offsets(struct rtl8169_private *tp)
 	tp->tc_offset.tx_errors = counters->tx_errors;
 	tp->tc_offset.tx_multi_collision = counters->tx_multi_collision;
 	tp->tc_offset.tx_aborted = counters->tx_aborted;
+	tp->tc_offset.rx_missed = counters->rx_missed;
 	tp->tc_offset.inited = true;
 
 	return ret;
@@ -3837,8 +3838,6 @@ static void rtl_hw_start_8169(struct rtl8169_private *tp)
 
 	rtl8169_set_magic_reg(tp, tp->mac_version);
 
-	RTL_W32(tp, RxMissed, 0);
-
 	/* disable interrupt coalescing */
 	RTL_W16(tp, IntrMitigate, 0x0000);
 }
@@ -4681,17 +4680,6 @@ static int rtl8169_poll(struct napi_struct *napi, int budget)
 	return work_done;
 }
 
-static void rtl8169_rx_missed(struct net_device *dev)
-{
-	struct rtl8169_private *tp = netdev_priv(dev);
-
-	if (tp->mac_version > RTL_GIGA_MAC_VER_06)
-		return;
-
-	dev->stats.rx_missed_errors += RTL_R32(tp, RxMissed) & 0xffffff;
-	RTL_W32(tp, RxMissed, 0);
-}
-
 static void r8169_phylink_handler(struct net_device *ndev)
 {
 	struct rtl8169_private *tp = netdev_priv(ndev);
@@ -4741,12 +4729,6 @@ static void rtl8169_down(struct net_device *dev)
 	netif_stop_queue(dev);
 
 	rtl8169_hw_reset(tp);
-	/*
-	 * At this point device interrupts can not be enabled in any function,
-	 * as netif_running is not true (rtl8169_interrupt, rtl8169_reset_task)
-	 * and napi is disabled (rtl8169_poll).
-	 */
-	rtl8169_rx_missed(dev);
 
 	/* Give a racing hard_start_xmit a few cycles to complete. */
 	synchronize_rcu();
@@ -4891,9 +4873,6 @@ rtl8169_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats)
 
 	pm_runtime_get_noresume(&pdev->dev);
 
-	if (netif_running(dev) && pm_runtime_active(&pdev->dev))
-		rtl8169_rx_missed(dev);
-
 	do {
 		start = u64_stats_fetch_begin_irq(&tp->rx_stats.syncp);
 		stats->rx_packets = tp->rx_stats.packets;
@@ -4912,7 +4891,6 @@ rtl8169_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats)
 	stats->rx_errors	= dev->stats.rx_errors;
 	stats->rx_crc_errors	= dev->stats.rx_crc_errors;
 	stats->rx_fifo_errors	= dev->stats.rx_fifo_errors;
-	stats->rx_missed_errors = dev->stats.rx_missed_errors;
 	stats->multicast	= dev->stats.multicast;
 
 	/*
@@ -4932,6 +4910,8 @@ rtl8169_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats)
 		le32_to_cpu(tp->tc_offset.tx_multi_collision);
 	stats->tx_aborted_errors = le16_to_cpu(counters->tx_aborted) -
 		le16_to_cpu(tp->tc_offset.tx_aborted);
+	stats->rx_missed_errors = le16_to_cpu(counters->rx_missed) -
+		le16_to_cpu(tp->tc_offset.rx_missed);
 
 	pm_runtime_put_noidle(&pdev->dev);
 }
@@ -5017,7 +4997,6 @@ static int rtl8169_runtime_suspend(struct device *device)
 	rtl8169_net_suspend(dev);
 
 	/* Update counters before going runtime suspend */
-	rtl8169_rx_missed(dev);
 	rtl8169_update_counters(tp);
 
 	return 0;
-- 
2.25.0


