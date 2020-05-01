Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A8E31C1BA4
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 19:26:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729143AbgEAR0g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 13:26:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728933AbgEAR0f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 13:26:35 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15DEAC061A0E
        for <netdev@vger.kernel.org>; Fri,  1 May 2020 10:26:35 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id x17so12269173wrt.5
        for <netdev@vger.kernel.org>; Fri, 01 May 2020 10:26:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Oj+OOVN2501NgEOQLlWuQZ6wcEbqpjKhjWanig+Crek=;
        b=Q1a7Mz+3hozdG8oEiokf+DoEdj0SO8+fQJ/+mgrCtZCyp0DpOTkGbxydnvqXpYuz7T
         OmY80ps09Z+8shc8vV6IFwMDcaseXFm0vIL3xsxOcaAXIXIiLjJy+QBAyKKvR0Uzcm2A
         swpzMKNnGaxLntrxclv88yLR69W3f2zAxTV/K/2oIpUyVnC/nIADznz9B56Ft6klf7n1
         xU27BEhTr25AOksUZGyPPK5Bn19o6z2xEn9gv/rIhrvbihpwsdJ2fwaDlIMJy67/Ufia
         BtjhE4zR9Ryl9KKXzdl+aD8W56kXHw0ww9rpnDcRGtrYyyII5Ipbmq7/T/nCUtM+KTAm
         7cGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Oj+OOVN2501NgEOQLlWuQZ6wcEbqpjKhjWanig+Crek=;
        b=HcGwmO9gFtLpOHIW3a/SriaG0R/9MybRRDB3dwEYrxSPprsYZFpCRwX6neh9CvNTJz
         YnmDusfrPQdpBTWDOLuqHkkW6pliAba7m6TFcH8O0Z936T+gQPgD6XqpRinqtktjKomX
         chWzkPpruAmyBLtCYuS7z2EX1lr4r2efxS/5uDLNIcuQ4TpAsluVan0PhlQ9JTokhNQu
         yXzZ1diVHxfFZdtnDJH+ZmtSJ3vn2ctgTaJPZ0me75qYj2kkjIyYQV2nEyrpAocUxU1B
         7YN4wkbgzjt8qf+Fnc7HZYIEIH8MMZ+mUryJBVqqe25qs2ksgpKmeOGJjk3ufX8X8BXl
         GD5w==
X-Gm-Message-State: AGi0Pub8jvm/dLMhjU1NI/PZCKS5tWRL3gutHWuVCArhHdd9MApaRMYx
        4UMCnzCHwALZnU72DNl9962gUDuf
X-Google-Smtp-Source: APiQypIZE0DHfQKR18EzCc9aWSPzD1ohI5GCLmpHmT2R3OB185KNflSXWF0rJX1zn3X3MsiB/RXhqA==
X-Received: by 2002:adf:aad4:: with SMTP id i20mr4850372wrc.47.1588353993468;
        Fri, 01 May 2020 10:26:33 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f06:ee00:54e4:3086:385e:b03b? (p200300EA8F06EE0054E43086385EB03B.dip0.t-ipconnect.de. [2003:ea:8f06:ee00:54e4:3086:385e:b03b])
        by smtp.googlemail.com with ESMTPSA id 2sm732081wre.25.2020.05.01.10.26.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 May 2020 10:26:33 -0700 (PDT)
Subject: [PATCH net-next 2/4] r8169: simplify counter handling
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <0e2ab257-5564-f16a-92f9-d0635e140837@gmail.com>
Message-ID: <60f2357b-cb6b-8939-e6d1-0431b6243eb3@gmail.com>
Date:   Fri, 1 May 2020 19:23:36 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <0e2ab257-5564-f16a-92f9-d0635e140837@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The counter handling functions can only fail if rtl8169_do_counters()
times out. In the poll function we emit an error message in case of
timeout, therefore we don't have to propagate the timeout all the
way up just to print another message basically saying the same.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 38 ++++++++---------------
 1 file changed, 13 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index bfa199b36..1c2ea7506 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -1625,7 +1625,7 @@ DECLARE_RTL_COND(rtl_counters_cond)
 	return RTL_R32(tp, CounterAddrLow) & (CounterReset | CounterDump);
 }
 
-static bool rtl8169_do_counters(struct rtl8169_private *tp, u32 counter_cmd)
+static void rtl8169_do_counters(struct rtl8169_private *tp, u32 counter_cmd)
 {
 	dma_addr_t paddr = tp->counters_phys_addr;
 	u32 cmd;
@@ -1636,22 +1636,20 @@ static bool rtl8169_do_counters(struct rtl8169_private *tp, u32 counter_cmd)
 	RTL_W32(tp, CounterAddrLow, cmd);
 	RTL_W32(tp, CounterAddrLow, cmd | counter_cmd);
 
-	return rtl_udelay_loop_wait_low(tp, &rtl_counters_cond, 10, 1000);
+	rtl_udelay_loop_wait_low(tp, &rtl_counters_cond, 10, 1000);
 }
 
-static bool rtl8169_reset_counters(struct rtl8169_private *tp)
+static void rtl8169_reset_counters(struct rtl8169_private *tp)
 {
 	/*
 	 * Versions prior to RTL_GIGA_MAC_VER_19 don't support resetting the
 	 * tally counters.
 	 */
-	if (tp->mac_version < RTL_GIGA_MAC_VER_19)
-		return true;
-
-	return rtl8169_do_counters(tp, CounterReset);
+	if (tp->mac_version >= RTL_GIGA_MAC_VER_19)
+		rtl8169_do_counters(tp, CounterReset);
 }
 
-static bool rtl8169_update_counters(struct rtl8169_private *tp)
+static void rtl8169_update_counters(struct rtl8169_private *tp)
 {
 	u8 val = RTL_R8(tp, ChipCmd);
 
@@ -1659,16 +1657,13 @@ static bool rtl8169_update_counters(struct rtl8169_private *tp)
 	 * Some chips are unable to dump tally counters when the receiver
 	 * is disabled. If 0xff chip may be in a PCI power-save state.
 	 */
-	if (!(val & CmdRxEnb) || val == 0xff)
-		return true;
-
-	return rtl8169_do_counters(tp, CounterDump);
+	if (val & CmdRxEnb && val != 0xff)
+		rtl8169_do_counters(tp, CounterDump);
 }
 
-static bool rtl8169_init_counter_offsets(struct rtl8169_private *tp)
+static void rtl8169_init_counter_offsets(struct rtl8169_private *tp)
 {
 	struct rtl8169_counters *counters = tp->counters;
-	bool ret = false;
 
 	/*
 	 * rtl8169_init_counter_offsets is called from rtl_open.  On chip
@@ -1686,22 +1681,16 @@ static bool rtl8169_init_counter_offsets(struct rtl8169_private *tp)
 	 */
 
 	if (tp->tc_offset.inited)
-		return true;
-
-	/* If both, reset and update fail, propagate to caller. */
-	if (rtl8169_reset_counters(tp))
-		ret = true;
+		return;
 
-	if (rtl8169_update_counters(tp))
-		ret = true;
+	rtl8169_reset_counters(tp);
+	rtl8169_update_counters(tp);
 
 	tp->tc_offset.tx_errors = counters->tx_errors;
 	tp->tc_offset.tx_multi_collision = counters->tx_multi_collision;
 	tp->tc_offset.tx_aborted = counters->tx_aborted;
 	tp->tc_offset.rx_missed = counters->rx_missed;
 	tp->tc_offset.inited = true;
-
-	return ret;
 }
 
 static void rtl8169_get_ethtool_stats(struct net_device *dev,
@@ -4759,8 +4748,7 @@ static int rtl_open(struct net_device *dev)
 
 	rtl_hw_start(tp);
 
-	if (!rtl8169_init_counter_offsets(tp))
-		netif_warn(tp, hw, dev, "counter reset/update failed\n");
+	rtl8169_init_counter_offsets(tp);
 
 	phy_start(tp->phydev);
 	netif_start_queue(dev);
-- 
2.26.2


