Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E9A020266C
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 22:41:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728875AbgFTUlO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jun 2020 16:41:14 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:42520 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728852AbgFTUlJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Jun 2020 16:41:09 -0400
Received: by mail-wr1-f65.google.com with SMTP id o11so5247378wrv.9
        for <netdev@vger.kernel.org>; Sat, 20 Jun 2020 13:41:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SpaZV1YCSt3jeu+jmAY4g0P9iqD7BbLIXZJ2ro7kUSg=;
        b=c7GTmwTmFTp4uuPLXjp0KgDPXIox1X0i2IYTPVv7Sy1h++05Lbtomz5cGrRZV9B5Wa
         fjgcZEfuKFePrKAaeNVT/QdYTNkWe8KYgPVos0VixwL64irBoLhbtXKjmUxAHcS0d2X+
         +O/f1rqwpk7dUlwiin9oxUei2tLrzH7d6ArJ6cUXIT3Ls/GBNTNy96WpKspwhR/jjXVo
         ncHO9bWWv2Oee+N8ayrKtW+eI4P1jClE2IQdoQ2Vlg05Gh2qXJxRa4X0g0ewn2cq7pRl
         041zkvrmkI+JnCQE8JkBeanrXcM1NQ4W9DlJYpK/8Lmd6nByaxVVUgij/TH8tb5Dt0Iq
         1obA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SpaZV1YCSt3jeu+jmAY4g0P9iqD7BbLIXZJ2ro7kUSg=;
        b=qqN7Ea9mXS4O3ZXqK246ENz6DBf/HObgcfyJPOfKGjXVr0Sj6pu88xyeRkzt0lCaXw
         Op9Ei+8IqnwC+aLqU/RpX0SXBllqQ6J5dFugjth2qxmVSWSBrxRo/tuSWsepnSNyvHI5
         FlyD0t0H8w5vc14lTV8N0Gak9jW643JUjbmro+7DWnVk4PBYkq7Tszg40RHidlvqHWFK
         bwKoqZtBVacMpOL50xrjSM/plaa9J4jf97lqV3y5/7QqUd6awzjdEKZecfr1aTVR/xp7
         TOpwi6x9D4zWBpfpzPyh6h+hIgOLntuX0I7Gvee0i0voRqQW/pOBP23YPXsPUh6/yZ6N
         Mxig==
X-Gm-Message-State: AOAM533ruWff5EmwJ612+sU/R5YaZa7k884p3h3DJjqBjHoTIUlwVh3e
        N+ac3gqaUQ02xvG4jt3fA29NiIpN
X-Google-Smtp-Source: ABdhPJyRp3e8qo7n/x9B4k5kPvcDzVy3Q5n9VAWOjswFB4sZufvJ8HS50JWUD7gMbJPOLtE9n9SLzQ==
X-Received: by 2002:adf:aad3:: with SMTP id i19mr10789240wrc.359.1592685606100;
        Sat, 20 Jun 2020 13:40:06 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:5700:b4cc:8098:204b:37c5? (p200300ea8f235700b4cc8098204b37c5.dip0.t-ipconnect.de. [2003:ea:8f23:5700:b4cc:8098:204b:37c5])
        by smtp.googlemail.com with ESMTPSA id e2sm9428996wrt.76.2020.06.20.13.40.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 20 Jun 2020 13:40:05 -0700 (PDT)
Subject: [PATCH net-next 6/7] r8169: remove driver-specific mutex
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <2e68df85-4f64-d45b-3c4c-bb8cb9a4411d@gmail.com>
Message-ID: <90cb5574-1d39-3902-de6e-7b84c06c4a61@gmail.com>
Date:   Sat, 20 Jun 2020 22:38:55 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <2e68df85-4f64-d45b-3c4c-bb8cb9a4411d@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that the critical sections are protected with RTNL lock, we don't
need a separate mutex any longer.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 45 -----------------------
 1 file changed, 45 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index e70797311..e09732c9d 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -611,7 +611,6 @@ struct rtl8169_private {
 
 	struct {
 		DECLARE_BITMAP(flags, RTL_FLAG_MAX);
-		struct mutex mutex;
 		struct work_struct work;
 	} wk;
 
@@ -663,16 +662,6 @@ static inline struct device *tp_to_dev(struct rtl8169_private *tp)
 	return &tp->pci_dev->dev;
 }
 
-static void rtl_lock_work(struct rtl8169_private *tp)
-{
-	mutex_lock(&tp->wk.mutex);
-}
-
-static void rtl_unlock_work(struct rtl8169_private *tp)
-{
-	mutex_unlock(&tp->wk.mutex);
-}
-
 static void rtl_lock_config_regs(struct rtl8169_private *tp)
 {
 	RTL_W8(tp, Cfg9346, Cfg9346_Lock);
@@ -1348,10 +1337,8 @@ static void rtl8169_get_wol(struct net_device *dev, struct ethtool_wolinfo *wol)
 {
 	struct rtl8169_private *tp = netdev_priv(dev);
 
-	rtl_lock_work(tp);
 	wol->supported = WAKE_ANY;
 	wol->wolopts = tp->saved_wolopts;
-	rtl_unlock_work(tp);
 }
 
 static void __rtl8169_set_wol(struct rtl8169_private *tp, u32 wolopts)
@@ -1426,13 +1413,9 @@ static int rtl8169_set_wol(struct net_device *dev, struct ethtool_wolinfo *wol)
 	if (wol->wolopts & ~WAKE_ANY)
 		return -EINVAL;
 
-	rtl_lock_work(tp);
-
 	tp->saved_wolopts = wol->wolopts;
 	__rtl8169_set_wol(tp, tp->saved_wolopts);
 
-	rtl_unlock_work(tp);
-
 	return 0;
 }
 
@@ -1495,8 +1478,6 @@ static int rtl8169_set_features(struct net_device *dev,
 {
 	struct rtl8169_private *tp = netdev_priv(dev);
 
-	rtl_lock_work(tp);
-
 	rtl_set_rx_config_features(tp, features);
 
 	if (features & NETIF_F_RXCSUM)
@@ -1514,8 +1495,6 @@ static int rtl8169_set_features(struct net_device *dev,
 	RTL_W16(tp, CPlusCmd, tp->cp_cmd);
 	rtl_pci_commit(tp);
 
-	rtl_unlock_work(tp);
-
 	return 0;
 }
 
@@ -1541,10 +1520,8 @@ static void rtl8169_get_regs(struct net_device *dev, struct ethtool_regs *regs,
 	u32 *dw = p;
 	int i;
 
-	rtl_lock_work(tp);
 	for (i = 0; i < R8169_REGS_SIZE; i += 4)
 		memcpy_fromio(dw++, data++, 4);
-	rtl_unlock_work(tp);
 }
 
 static const char rtl8169_gstrings[][ETH_GSTRING_LEN] = {
@@ -1860,8 +1837,6 @@ static int rtl_set_coalesce(struct net_device *dev, struct ethtool_coalesce *ec)
 	units = DIV_ROUND_UP(ec->rx_coalesce_usecs * 1000U, scale);
 	w |= FIELD_PREP(RTL_COALESCE_RX_USECS, units);
 
-	rtl_lock_work(tp);
-
 	RTL_W16(tp, IntrMitigate, w);
 
 	/* Meaning of PktCntrDisable bit changed from RTL8168e-vl */
@@ -1877,8 +1852,6 @@ static int rtl_set_coalesce(struct net_device *dev, struct ethtool_coalesce *ec)
 	RTL_W16(tp, CPlusCmd, tp->cp_cmd);
 	rtl_pci_commit(tp);
 
-	rtl_unlock_work(tp);
-
 	return 0;
 }
 
@@ -2165,8 +2138,6 @@ static void rtl8169_init_phy(struct rtl8169_private *tp)
 
 static void rtl_rar_set(struct rtl8169_private *tp, u8 *addr)
 {
-	rtl_lock_work(tp);
-
 	rtl_unlock_config_regs(tp);
 
 	RTL_W32(tp, MAC4, addr[4] | addr[5] << 8);
@@ -2179,8 +2150,6 @@ static void rtl_rar_set(struct rtl8169_private *tp, u8 *addr)
 		rtl_rar_exgmac_set(tp, addr);
 
 	rtl_lock_config_regs(tp);
-
-	rtl_unlock_work(tp);
 }
 
 static int rtl_set_mac_address(struct net_device *dev, void *p)
@@ -4528,7 +4497,6 @@ static void rtl_task(struct work_struct *work)
 		container_of(work, struct rtl8169_private, wk.work);
 
 	rtnl_lock();
-	rtl_lock_work(tp);
 
 	if (!netif_running(tp->dev) ||
 	    !test_bit(RTL_FLAG_TASK_ENABLED, tp->wk.flags))
@@ -4539,7 +4507,6 @@ static void rtl_task(struct work_struct *work)
 		netif_wake_queue(tp->dev);
 	}
 out_unlock:
-	rtl_unlock_work(tp);
 	rtnl_unlock();
 }
 
@@ -4602,8 +4569,6 @@ static int r8169_phy_connect(struct rtl8169_private *tp)
 
 static void rtl8169_down(struct rtl8169_private *tp)
 {
-	rtl_lock_work(tp);
-
 	/* Clear all task flags */
 	bitmap_zero(tp->wk.flags, RTL_FLAG_MAX);
 
@@ -4614,13 +4579,10 @@ static void rtl8169_down(struct rtl8169_private *tp)
 	rtl8169_cleanup(tp, true);
 
 	rtl_pll_power_down(tp);
-
-	rtl_unlock_work(tp);
 }
 
 static void rtl8169_up(struct rtl8169_private *tp)
 {
-	rtl_lock_work(tp);
 	rtl_pll_power_up(tp);
 	rtl8169_init_phy(tp);
 	napi_enable(&tp->napi);
@@ -4628,7 +4590,6 @@ static void rtl8169_up(struct rtl8169_private *tp)
 	rtl_reset_work(tp);
 
 	phy_start(tp->phydev);
-	rtl_unlock_work(tp);
 }
 
 static int rtl8169_close(struct net_device *dev)
@@ -4824,10 +4785,7 @@ static int rtl8169_runtime_suspend(struct device *device)
 	}
 
 	rtnl_lock();
-	rtl_lock_work(tp);
 	__rtl8169_set_wol(tp, WAKE_PHY);
-	rtl_unlock_work(tp);
-
 	rtl8169_net_suspend(tp);
 	rtnl_unlock();
 
@@ -4840,9 +4798,7 @@ static int rtl8169_runtime_resume(struct device *device)
 
 	rtl_rar_set(tp, tp->dev->dev_addr);
 
-	rtl_lock_work(tp);
 	__rtl8169_set_wol(tp, tp->saved_wolopts);
-	rtl_unlock_work(tp);
 
 	if (tp->TxDescArray)
 		rtl8169_up(tp);
@@ -5299,7 +5255,6 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		return rc;
 	}
 
-	mutex_init(&tp->wk.mutex);
 	INIT_WORK(&tp->wk.work, rtl_task);
 	u64_stats_init(&tp->rx_stats.syncp);
 	u64_stats_init(&tp->tx_stats.syncp);
-- 
2.27.0


