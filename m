Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2ADA1C1F9E
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 23:29:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbgEAV3b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 17:29:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726519AbgEAV30 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 17:29:26 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21C86C061A0E;
        Fri,  1 May 2020 14:29:26 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id e26so1156579wmk.5;
        Fri, 01 May 2020 14:29:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Vg2cI5L0CSv1niRJJZ7QFparC38Hkc3gZK9I9i6oR+I=;
        b=Knjdf0Q1vB7HIcpE9pJYwI4KcEnhgE5D8GwTplS148evOJYeLONgaJJUC7gajTXQck
         g+y+IcyzjH8ONYiUq5sAqXFhSYtVQCoYrzbvPuZLfnE/XjlO8hEucqN5pR9HRj0dKBM0
         C0AwLGNR3pyewuFsZ2+oXMS6TCsK2SoMoUlMrc55j9aoSkAamxSdcnVKkapwUEUsrE1/
         EB2Jm2MQFFFj4ADkZFAqzgJYyUneRvOY1BpUNSUsqWomha5nrSg3nMYU6a+ltsRbN7iN
         gNm0w4+HQ+CizgojMHATRTtAbawcC7Ym9W11BRayMDHh5ZfNxcQ6vWeV1LFJ+1DmpMSD
         o56w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Vg2cI5L0CSv1niRJJZ7QFparC38Hkc3gZK9I9i6oR+I=;
        b=mXi5BCOPoAwFY8BCRYW5+ynmqYVkAxk7iB/q816NPO3K+WzpZtOv3ZyJPQDTM3NRv/
         BvSWfEq4/GqVQu5sutdLYChlWWYT/Nj85UkHjvW9GgdEeVFX9DmiT+1CAD6x4Idkwn75
         1qL1JCdPff5b2UA2IXcLD6Q3Zq/omvZ9yRUGyzNk308QWkQVNNSxCFmi3iQXXaNbN+nH
         e2tgjCqK0oP5qcwuFha6NCK3cxq8VFl3vtCdWfj2MF0ZV710MKaWiMCkF33M1n/Kbvdf
         0QDyqrrIRypiVu56kgbtx1yfocCZKHLX2KM/hbeX9RJVx1aEg+uuQafKhPMGrYizSrS+
         Whuw==
X-Gm-Message-State: AGi0PuYEw3fde1+zHi5XnQGPUwfC7AdlHbhAgF83KjRlKs7Cruq7stT9
        HIv2yQBi5fqK9jEgXESop/pY9mr5
X-Google-Smtp-Source: APiQypIJQmxGpcpzEpKfEHPuqPYIGoY54hCZdQuVFNxn/iwfvWDYIH69VMpqRnhbOIAWSqBCzuuTHg==
X-Received: by 2002:a1c:5448:: with SMTP id p8mr1349675wmi.173.1588368564336;
        Fri, 01 May 2020 14:29:24 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f06:ee00:bcdf:534e:d44f:409? (p200300EA8F06EE00BCDF534ED44F0409.dip0.t-ipconnect.de. [2003:ea:8f06:ee00:bcdf:534e:d44f:409])
        by smtp.googlemail.com with ESMTPSA id h2sm6751625wro.9.2020.05.01.14.29.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 May 2020 14:29:23 -0700 (PDT)
Subject: [PATCH net-next 2/2] r8169: use fsleep in polling functions
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Jonathan Corbet <corbet@lwn.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-doc@vger.kernel.org
References: <8e3c56ca-b43f-3877-0104-a1a279d5a6c5@gmail.com>
Message-ID: <1a0ff46e-e650-7a1f-5b9b-a51487597167@gmail.com>
Date:   Fri, 1 May 2020 23:29:12 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <8e3c56ca-b43f-3877-0104-a1a279d5a6c5@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use new flexible sleep function fsleep() to merge the udelay and msleep
polling functions. We can safely do this because no polling function
is used in atomic context in this driver.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 108 +++++++++-------------
 1 file changed, 44 insertions(+), 64 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 8b665f2ec..64cce92f5 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -725,55 +725,35 @@ struct rtl_cond {
 	const char *msg;
 };
 
-static void rtl_udelay(unsigned int d)
-{
-	udelay(d);
-}
-
 static bool rtl_loop_wait(struct rtl8169_private *tp, const struct rtl_cond *c,
-			  void (*delay)(unsigned int), unsigned int d, int n,
-			  bool high)
+			  unsigned long usecs, int n, bool high)
 {
 	int i;
 
 	for (i = 0; i < n; i++) {
 		if (c->check(tp) == high)
 			return true;
-		delay(d);
+		fsleep(usecs);
 	}
 
 	if (net_ratelimit())
-		netdev_err(tp->dev, "%s == %d (loop: %d, delay: %d).\n",
-			   c->msg, !high, n, d);
+		netdev_err(tp->dev, "%s == %d (loop: %d, delay: %lu).\n",
+			   c->msg, !high, n, usecs);
 	return false;
 }
 
-static bool rtl_udelay_loop_wait_high(struct rtl8169_private *tp,
-				      const struct rtl_cond *c,
-				      unsigned int d, int n)
-{
-	return rtl_loop_wait(tp, c, rtl_udelay, d, n, true);
-}
-
-static bool rtl_udelay_loop_wait_low(struct rtl8169_private *tp,
-				     const struct rtl_cond *c,
-				     unsigned int d, int n)
-{
-	return rtl_loop_wait(tp, c, rtl_udelay, d, n, false);
-}
-
-static bool rtl_msleep_loop_wait_high(struct rtl8169_private *tp,
-				      const struct rtl_cond *c,
-				      unsigned int d, int n)
+static bool rtl_loop_wait_high(struct rtl8169_private *tp,
+			       const struct rtl_cond *c,
+			       unsigned long d, int n)
 {
-	return rtl_loop_wait(tp, c, msleep, d, n, true);
+	return rtl_loop_wait(tp, c, d, n, true);
 }
 
-static bool rtl_msleep_loop_wait_low(struct rtl8169_private *tp,
-				     const struct rtl_cond *c,
-				     unsigned int d, int n)
+static bool rtl_loop_wait_low(struct rtl8169_private *tp,
+			      const struct rtl_cond *c,
+			      unsigned long d, int n)
 {
-	return rtl_loop_wait(tp, c, msleep, d, n, false);
+	return rtl_loop_wait(tp, c, d, n, false);
 }
 
 #define DECLARE_RTL_COND(name)				\
@@ -808,7 +788,7 @@ static void r8168_phy_ocp_write(struct rtl8169_private *tp, u32 reg, u32 data)
 
 	RTL_W32(tp, GPHY_OCP, OCPAR_FLAG | (reg << 15) | data);
 
-	rtl_udelay_loop_wait_low(tp, &rtl_ocp_gphy_cond, 25, 10);
+	rtl_loop_wait_low(tp, &rtl_ocp_gphy_cond, 25, 10);
 }
 
 static int r8168_phy_ocp_read(struct rtl8169_private *tp, u32 reg)
@@ -818,7 +798,7 @@ static int r8168_phy_ocp_read(struct rtl8169_private *tp, u32 reg)
 
 	RTL_W32(tp, GPHY_OCP, reg << 15);
 
-	return rtl_udelay_loop_wait_high(tp, &rtl_ocp_gphy_cond, 25, 10) ?
+	return rtl_loop_wait_high(tp, &rtl_ocp_gphy_cond, 25, 10) ?
 		(RTL_R32(tp, GPHY_OCP) & 0xffff) : -ETIMEDOUT;
 }
 
@@ -896,7 +876,7 @@ static void r8169_mdio_write(struct rtl8169_private *tp, int reg, int value)
 {
 	RTL_W32(tp, PHYAR, 0x80000000 | (reg & 0x1f) << 16 | (value & 0xffff));
 
-	rtl_udelay_loop_wait_low(tp, &rtl_phyar_cond, 25, 20);
+	rtl_loop_wait_low(tp, &rtl_phyar_cond, 25, 20);
 	/*
 	 * According to hardware specs a 20us delay is required after write
 	 * complete indication, but before sending next command.
@@ -910,7 +890,7 @@ static int r8169_mdio_read(struct rtl8169_private *tp, int reg)
 
 	RTL_W32(tp, PHYAR, 0x0 | (reg & 0x1f) << 16);
 
-	value = rtl_udelay_loop_wait_high(tp, &rtl_phyar_cond, 25, 20) ?
+	value = rtl_loop_wait_high(tp, &rtl_phyar_cond, 25, 20) ?
 		RTL_R32(tp, PHYAR) & 0xffff : -ETIMEDOUT;
 
 	/*
@@ -933,7 +913,7 @@ static void r8168dp_1_mdio_access(struct rtl8169_private *tp, int reg, u32 data)
 	RTL_W32(tp, OCPAR, OCPAR_GPHY_WRITE_CMD);
 	RTL_W32(tp, EPHY_RXER_NUM, 0);
 
-	rtl_udelay_loop_wait_low(tp, &rtl_ocpar_cond, 1000, 100);
+	rtl_loop_wait_low(tp, &rtl_ocpar_cond, 1000, 100);
 }
 
 static void r8168dp_1_mdio_write(struct rtl8169_private *tp, int reg, int value)
@@ -950,7 +930,7 @@ static int r8168dp_1_mdio_read(struct rtl8169_private *tp, int reg)
 	RTL_W32(tp, OCPAR, OCPAR_GPHY_READ_CMD);
 	RTL_W32(tp, EPHY_RXER_NUM, 0);
 
-	return rtl_udelay_loop_wait_high(tp, &rtl_ocpar_cond, 1000, 100) ?
+	return rtl_loop_wait_high(tp, &rtl_ocpar_cond, 1000, 100) ?
 		RTL_R32(tp, OCPDR) & OCPDR_DATA_MASK : -ETIMEDOUT;
 }
 
@@ -1036,7 +1016,7 @@ static void rtl_ephy_write(struct rtl8169_private *tp, int reg_addr, int value)
 	RTL_W32(tp, EPHYAR, EPHYAR_WRITE_CMD | (value & EPHYAR_DATA_MASK) |
 		(reg_addr & EPHYAR_REG_MASK) << EPHYAR_REG_SHIFT);
 
-	rtl_udelay_loop_wait_low(tp, &rtl_ephyar_cond, 10, 100);
+	rtl_loop_wait_low(tp, &rtl_ephyar_cond, 10, 100);
 
 	udelay(10);
 }
@@ -1045,7 +1025,7 @@ static u16 rtl_ephy_read(struct rtl8169_private *tp, int reg_addr)
 {
 	RTL_W32(tp, EPHYAR, (reg_addr & EPHYAR_REG_MASK) << EPHYAR_REG_SHIFT);
 
-	return rtl_udelay_loop_wait_high(tp, &rtl_ephyar_cond, 10, 100) ?
+	return rtl_loop_wait_high(tp, &rtl_ephyar_cond, 10, 100) ?
 		RTL_R32(tp, EPHYAR) & EPHYAR_DATA_MASK : ~0;
 }
 
@@ -1061,7 +1041,7 @@ static void _rtl_eri_write(struct rtl8169_private *tp, int addr, u32 mask,
 	RTL_W32(tp, ERIDR, val);
 	RTL_W32(tp, ERIAR, ERIAR_WRITE_CMD | type | mask | addr);
 
-	rtl_udelay_loop_wait_low(tp, &rtl_eriar_cond, 100, 100);
+	rtl_loop_wait_low(tp, &rtl_eriar_cond, 100, 100);
 }
 
 static void rtl_eri_write(struct rtl8169_private *tp, int addr, u32 mask,
@@ -1074,7 +1054,7 @@ static u32 _rtl_eri_read(struct rtl8169_private *tp, int addr, int type)
 {
 	RTL_W32(tp, ERIAR, ERIAR_READ_CMD | type | ERIAR_MASK_1111 | addr);
 
-	return rtl_udelay_loop_wait_high(tp, &rtl_eriar_cond, 100, 100) ?
+	return rtl_loop_wait_high(tp, &rtl_eriar_cond, 100, 100) ?
 		RTL_R32(tp, ERIDR) : ~0;
 }
 
@@ -1107,7 +1087,7 @@ static void rtl_eri_clear_bits(struct rtl8169_private *tp, int addr, u32 mask,
 static u32 r8168dp_ocp_read(struct rtl8169_private *tp, u8 mask, u16 reg)
 {
 	RTL_W32(tp, OCPAR, ((u32)mask & 0x0f) << 12 | (reg & 0x0fff));
-	return rtl_udelay_loop_wait_high(tp, &rtl_ocpar_cond, 100, 20) ?
+	return rtl_loop_wait_high(tp, &rtl_ocpar_cond, 100, 20) ?
 		RTL_R32(tp, OCPDR) : ~0;
 }
 
@@ -1121,7 +1101,7 @@ static void r8168dp_ocp_write(struct rtl8169_private *tp, u8 mask, u16 reg,
 {
 	RTL_W32(tp, OCPDR, data);
 	RTL_W32(tp, OCPAR, OCPAR_FLAG | ((u32)mask & 0x0f) << 12 | (reg & 0x0fff));
-	rtl_udelay_loop_wait_low(tp, &rtl_ocpar_cond, 100, 20);
+	rtl_loop_wait_low(tp, &rtl_ocpar_cond, 100, 20);
 }
 
 static void r8168ep_ocp_write(struct rtl8169_private *tp, u8 mask, u16 reg,
@@ -1169,7 +1149,7 @@ DECLARE_RTL_COND(rtl_ocp_tx_cond)
 static void rtl8168ep_stop_cmac(struct rtl8169_private *tp)
 {
 	RTL_W8(tp, IBCR2, RTL_R8(tp, IBCR2) & ~0x01);
-	rtl_msleep_loop_wait_high(tp, &rtl_ocp_tx_cond, 50, 2000);
+	rtl_loop_wait_high(tp, &rtl_ocp_tx_cond, 50000, 2000);
 	RTL_W8(tp, IBISR0, RTL_R8(tp, IBISR0) | 0x20);
 	RTL_W8(tp, IBCR0, RTL_R8(tp, IBCR0) & ~0x01);
 }
@@ -1177,7 +1157,7 @@ static void rtl8168ep_stop_cmac(struct rtl8169_private *tp)
 static void rtl8168dp_driver_start(struct rtl8169_private *tp)
 {
 	r8168dp_oob_notify(tp, OOB_CMD_DRIVER_START);
-	rtl_msleep_loop_wait_high(tp, &rtl_dp_ocp_read_cond, 10, 10);
+	rtl_loop_wait_high(tp, &rtl_dp_ocp_read_cond, 10000, 10);
 }
 
 static void rtl8168ep_driver_start(struct rtl8169_private *tp)
@@ -1185,7 +1165,7 @@ static void rtl8168ep_driver_start(struct rtl8169_private *tp)
 	r8168ep_ocp_write(tp, 0x01, 0x180, OOB_CMD_DRIVER_START);
 	r8168ep_ocp_write(tp, 0x01, 0x30,
 			  r8168ep_ocp_read(tp, 0x01, 0x30) | 0x01);
-	rtl_msleep_loop_wait_high(tp, &rtl_ep_ocp_read_cond, 10, 10);
+	rtl_loop_wait_high(tp, &rtl_ep_ocp_read_cond, 10000, 10);
 }
 
 static void rtl8168_driver_start(struct rtl8169_private *tp)
@@ -1208,7 +1188,7 @@ static void rtl8168_driver_start(struct rtl8169_private *tp)
 static void rtl8168dp_driver_stop(struct rtl8169_private *tp)
 {
 	r8168dp_oob_notify(tp, OOB_CMD_DRIVER_STOP);
-	rtl_msleep_loop_wait_low(tp, &rtl_dp_ocp_read_cond, 10, 10);
+	rtl_loop_wait_low(tp, &rtl_dp_ocp_read_cond, 10000, 10);
 }
 
 static void rtl8168ep_driver_stop(struct rtl8169_private *tp)
@@ -1217,7 +1197,7 @@ static void rtl8168ep_driver_stop(struct rtl8169_private *tp)
 	r8168ep_ocp_write(tp, 0x01, 0x180, OOB_CMD_DRIVER_STOP);
 	r8168ep_ocp_write(tp, 0x01, 0x30,
 			  r8168ep_ocp_read(tp, 0x01, 0x30) | 0x01);
-	rtl_msleep_loop_wait_low(tp, &rtl_ep_ocp_read_cond, 10, 10);
+	rtl_loop_wait_low(tp, &rtl_ep_ocp_read_cond, 10000, 10);
 }
 
 static void rtl8168_driver_stop(struct rtl8169_private *tp)
@@ -1278,7 +1258,7 @@ u8 rtl8168d_efuse_read(struct rtl8169_private *tp, int reg_addr)
 {
 	RTL_W32(tp, EFUSEAR, (reg_addr & EFUSEAR_REG_MASK) << EFUSEAR_REG_SHIFT);
 
-	return rtl_udelay_loop_wait_high(tp, &rtl_efusear_cond, 100, 300) ?
+	return rtl_loop_wait_high(tp, &rtl_efusear_cond, 100, 300) ?
 		RTL_R32(tp, EFUSEAR) & EFUSEAR_DATA_MASK : ~0;
 }
 
@@ -1615,7 +1595,7 @@ static void rtl8169_do_counters(struct rtl8169_private *tp, u32 counter_cmd)
 	RTL_W32(tp, CounterAddrLow, cmd);
 	RTL_W32(tp, CounterAddrLow, cmd | counter_cmd);
 
-	rtl_udelay_loop_wait_low(tp, &rtl_counters_cond, 10, 1000);
+	rtl_loop_wait_low(tp, &rtl_counters_cond, 10, 1000);
 }
 
 static void rtl8169_reset_counters(struct rtl8169_private *tp)
@@ -2472,7 +2452,7 @@ static void rtl_hw_reset(struct rtl8169_private *tp)
 {
 	RTL_W8(tp, ChipCmd, CmdReset);
 
-	rtl_udelay_loop_wait_low(tp, &rtl_chipcmd_cond, 100, 100);
+	rtl_loop_wait_low(tp, &rtl_chipcmd_cond, 100, 100);
 }
 
 static void rtl_request_firmware(struct rtl8169_private *tp)
@@ -2526,12 +2506,12 @@ static void rtl8169_hw_reset(struct rtl8169_private *tp)
 	case RTL_GIGA_MAC_VER_27:
 	case RTL_GIGA_MAC_VER_28:
 	case RTL_GIGA_MAC_VER_31:
-		rtl_udelay_loop_wait_low(tp, &rtl_npq_cond, 20, 42*42);
+		rtl_loop_wait_low(tp, &rtl_npq_cond, 20, 2000);
 		break;
 	case RTL_GIGA_MAC_VER_34 ... RTL_GIGA_MAC_VER_38:
 	case RTL_GIGA_MAC_VER_40 ... RTL_GIGA_MAC_VER_52:
 		RTL_W8(tp, ChipCmd, RTL_R8(tp, ChipCmd) | StopReq);
-		rtl_udelay_loop_wait_high(tp, &rtl_txcfg_empty_cond, 100, 666);
+		rtl_loop_wait_high(tp, &rtl_txcfg_empty_cond, 100, 666);
 		break;
 	default:
 		RTL_W8(tp, ChipCmd, RTL_R8(tp, ChipCmd) | StopReq);
@@ -2641,7 +2621,7 @@ static void rtl_csi_write(struct rtl8169_private *tp, int addr, int value)
 	RTL_W32(tp, CSIAR, CSIAR_WRITE_CMD | (addr & CSIAR_ADDR_MASK) |
 		CSIAR_BYTE_ENABLE | func << 16);
 
-	rtl_udelay_loop_wait_low(tp, &rtl_csiar_cond, 10, 100);
+	rtl_loop_wait_low(tp, &rtl_csiar_cond, 10, 100);
 }
 
 static u32 rtl_csi_read(struct rtl8169_private *tp, int addr)
@@ -2651,7 +2631,7 @@ static u32 rtl_csi_read(struct rtl8169_private *tp, int addr)
 	RTL_W32(tp, CSIAR, (addr & CSIAR_ADDR_MASK) | func << 16 |
 		CSIAR_BYTE_ENABLE);
 
-	return rtl_udelay_loop_wait_high(tp, &rtl_csiar_cond, 10, 100) ?
+	return rtl_loop_wait_high(tp, &rtl_csiar_cond, 10, 100) ?
 		RTL_R32(tp, CSIDR) : ~0;
 }
 
@@ -3606,7 +3586,7 @@ static void rtl_hw_start_8125_common(struct rtl8169_private *tp)
 
 	r8168_mac_ocp_write(tp, 0xe098, 0xc302);
 
-	rtl_udelay_loop_wait_low(tp, &rtl_mac_ocp_e00e_cond, 1000, 10);
+	rtl_loop_wait_low(tp, &rtl_mac_ocp_e00e_cond, 1000, 10);
 
 	rtl8125_config_eee_mac(tp);
 
@@ -5149,10 +5129,10 @@ static void rtl_hw_init_8168g(struct rtl8169_private *tp)
 {
 	RTL_W32(tp, MISC, RTL_R32(tp, MISC) | RXDV_GATED_EN);
 
-	if (!rtl_udelay_loop_wait_high(tp, &rtl_txcfg_empty_cond, 100, 42))
+	if (!rtl_loop_wait_high(tp, &rtl_txcfg_empty_cond, 100, 42))
 		return;
 
-	if (!rtl_udelay_loop_wait_high(tp, &rtl_rxtx_empty_cond, 100, 42))
+	if (!rtl_loop_wait_high(tp, &rtl_rxtx_empty_cond, 100, 42))
 		return;
 
 	RTL_W8(tp, ChipCmd, RTL_R8(tp, ChipCmd) & ~(CmdTxEnb | CmdRxEnb));
@@ -5161,19 +5141,19 @@ static void rtl_hw_init_8168g(struct rtl8169_private *tp)
 
 	r8168_mac_ocp_modify(tp, 0xe8de, BIT(14), 0);
 
-	if (!rtl_udelay_loop_wait_high(tp, &rtl_link_list_ready_cond, 100, 42))
+	if (!rtl_loop_wait_high(tp, &rtl_link_list_ready_cond, 100, 42))
 		return;
 
 	r8168_mac_ocp_modify(tp, 0xe8de, 0, BIT(15));
 
-	rtl_udelay_loop_wait_high(tp, &rtl_link_list_ready_cond, 100, 42);
+	rtl_loop_wait_high(tp, &rtl_link_list_ready_cond, 100, 42);
 }
 
 static void rtl_hw_init_8125(struct rtl8169_private *tp)
 {
 	RTL_W32(tp, MISC, RTL_R32(tp, MISC) | RXDV_GATED_EN);
 
-	if (!rtl_udelay_loop_wait_high(tp, &rtl_rxtx_empty_cond, 100, 42))
+	if (!rtl_loop_wait_high(tp, &rtl_rxtx_empty_cond, 100, 42))
 		return;
 
 	RTL_W8(tp, ChipCmd, RTL_R8(tp, ChipCmd) & ~(CmdTxEnb | CmdRxEnb));
@@ -5182,14 +5162,14 @@ static void rtl_hw_init_8125(struct rtl8169_private *tp)
 
 	r8168_mac_ocp_modify(tp, 0xe8de, BIT(14), 0);
 
-	if (!rtl_udelay_loop_wait_high(tp, &rtl_link_list_ready_cond, 100, 42))
+	if (!rtl_loop_wait_high(tp, &rtl_link_list_ready_cond, 100, 42))
 		return;
 
 	r8168_mac_ocp_write(tp, 0xc0aa, 0x07d0);
 	r8168_mac_ocp_write(tp, 0xc0a6, 0x0150);
 	r8168_mac_ocp_write(tp, 0xc01e, 0x5555);
 
-	rtl_udelay_loop_wait_high(tp, &rtl_link_list_ready_cond, 100, 42);
+	rtl_loop_wait_high(tp, &rtl_link_list_ready_cond, 100, 42);
 }
 
 static void rtl_hw_initialize(struct rtl8169_private *tp)
-- 
2.26.2


