Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 447F61ED762
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 22:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726255AbgFCU3O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 16:29:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726087AbgFCU3O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 16:29:14 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA806C08C5C0
        for <netdev@vger.kernel.org>; Wed,  3 Jun 2020 13:29:13 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id g10so3148813wmh.4
        for <netdev@vger.kernel.org>; Wed, 03 Jun 2020 13:29:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=IuHM7k1phXqc85mitxdMXeoaRKh49HDRoEHc0hsByJo=;
        b=kDFVBigxNhA8rDP1zbhkDZu4KWOTuittepFio2AMQL9WGxTUjSjyjWiaeHexCZhxwH
         yw0hp3DFP/eBnGCfaWgLvjq3B2wiNmim9o2kpzVOXQFkMrkaUtEIVuoOgEUtcXHF5Vqp
         wQzAEBfCcgjDDFTwkQXfjy2XfvepJ6C3KmWdSmYKz/DwqFHd0IBhR+UVL+IswPCxLhIl
         PivpZ4i/AcBCeIR+qGo/JvQ48A96Lejl6/J/OwdPPi2sRA+oklekgwhRF35hxpcyt1gt
         AiUxnI5wBLn0rfhdoObyfSvBrZbSM1LBJvhSFmgu8Fw1DOBt2JSfnSP1FgZzUA8+eF+4
         ZUsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=IuHM7k1phXqc85mitxdMXeoaRKh49HDRoEHc0hsByJo=;
        b=INhubsxaY35xGsl+F+P0ALQ73A2yF/9Cwsv8h35p6opqZeAvEWCnuE1mP6g9M74zdH
         h6wEqOM5LQBvdzp7I3Ay16OivHbdqg/la9+4TukwaL4qo997j/nu+eNKwQt3Nu/OfIYf
         tRva2mVYP22DEslEVeW/Z21PXbGvouHsoRiMZNSL5PJlId7XxIavmhYIG/AXIjlOb78N
         BVEkHtSwO6Tc2bcqSvdTr4xyPr90mF06Zr0mqkGu8aXyUG4B/fQHiyY93UdA1Q1jskMk
         t/6rl8X9FyPyZ66X+kkxYrYuugtnYzG2wsGiyyzW1jVJtOWhVks8qDZ/bY90KUtkmEg6
         gbng==
X-Gm-Message-State: AOAM533+acXGw+LPYGhxNFULChGnAOJX4dekBtVTBwOuyGzuacn/GIFN
        MmHqYXGQ1hbXCHHGRUHB5E2qgyS8
X-Google-Smtp-Source: ABdhPJzNRK3x7JxOootcfpZBhBqU9sV2Vgixb+CoonYpRp9rXga4Dk8HVHHJFj9AQeN7Vb2GoUHkrw==
X-Received: by 2002:a1c:5541:: with SMTP id j62mr762318wmb.64.1591216152233;
        Wed, 03 Jun 2020 13:29:12 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:5700:7165:d336:c1fe:9e7a? (p200300ea8f2357007165d336c1fe9e7a.dip0.t-ipconnect.de. [2003:ea:8f23:5700:7165:d336:c1fe:9e7a])
        by smtp.googlemail.com with ESMTPSA id y80sm4788235wmc.34.2020.06.03.13.29.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Jun 2020 13:29:11 -0700 (PDT)
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH v2 net-next] r8169: fix failing WoL
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Message-ID: <a5dc6fc0-6fa5-662d-22f9-50440b116df9@gmail.com>
Date:   Wed, 3 Jun 2020 22:29:06 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Th referenced change added an extra hw reset to rtl8169_net_suspend()
what makes WoL fail on few chip versions. Therefore skip the extra
reset if we're going down and WoL is enabled.
In rtl_shutdown() rtl8169_hw_reset() is called by rtl8169_net_suspend()
already if needed, therefore avoid issues issue by removing the extra
call. The fix was tested on a system with RTL8168g.

Meanwhile rtl8169_hw_reset() does more than a hw reset and should be
renamed. But that's net-next material.

Fixes: 8ac8e8c64b53 ("r8169: make rtl8169_down central chip quiesce function")
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
Uups, first version was cc'ed to Majordomo instead of the netdev mailing list.
---
 drivers/net/ethernet/realtek/r8169_main.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 4d2ec9742..dad84ecf5 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -3928,7 +3928,7 @@ static void rtl8169_tx_clear(struct rtl8169_private *tp)
 	netdev_reset_queue(tp->dev);
 }
 
-static void rtl8169_hw_reset(struct rtl8169_private *tp)
+static void rtl8169_hw_reset(struct rtl8169_private *tp, bool going_down)
 {
 	/* Give a racing hard_start_xmit a few cycles to complete. */
 	synchronize_rcu();
@@ -3938,6 +3938,9 @@ static void rtl8169_hw_reset(struct rtl8169_private *tp)
 
 	rtl_rx_close(tp);
 
+	if (going_down && tp->dev->wol_enabled)
+		goto no_reset;
+
 	switch (tp->mac_version) {
 	case RTL_GIGA_MAC_VER_27:
 	case RTL_GIGA_MAC_VER_28:
@@ -3959,7 +3962,7 @@ static void rtl8169_hw_reset(struct rtl8169_private *tp)
 	}
 
 	rtl_hw_reset(tp);
-
+no_reset:
 	rtl8169_tx_clear(tp);
 	rtl8169_init_ring_indexes(tp);
 }
@@ -3972,7 +3975,7 @@ static void rtl_reset_work(struct rtl8169_private *tp)
 	napi_disable(&tp->napi);
 	netif_stop_queue(dev);
 
-	rtl8169_hw_reset(tp);
+	rtl8169_hw_reset(tp, false);
 
 	for (i = 0; i < NUM_RX_DESC; i++)
 		rtl8169_mark_to_asic(tp->RxDescArray + i);
@@ -4637,7 +4640,7 @@ static void rtl8169_down(struct rtl8169_private *tp)
 	phy_stop(tp->phydev);
 	napi_disable(&tp->napi);
 
-	rtl8169_hw_reset(tp);
+	rtl8169_hw_reset(tp, true);
 
 	rtl_pll_power_down(tp);
 
@@ -4942,8 +4945,6 @@ static void rtl_shutdown(struct pci_dev *pdev)
 	/* Restore original MAC address */
 	rtl_rar_set(tp, tp->dev->perm_addr);
 
-	rtl8169_hw_reset(tp);
-
 	if (system_state == SYSTEM_POWER_OFF) {
 		if (tp->saved_wolopts) {
 			rtl_wol_suspend_quirk(tp);
-- 
2.27.0

