Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 993FBD17E1
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 20:56:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731254AbfJISz6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 14:55:58 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:32847 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729535AbfJISz6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 14:55:58 -0400
Received: by mail-wr1-f65.google.com with SMTP id b9so4334595wrs.0
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 11:55:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=NsIy+5QS8MAvmTxwvKkgNcoLMQSoEdntxipLS8fbbIw=;
        b=XK8U58XOAkcKMQUxRJBIdJJYgEe/h+C/A4TpZgbviCZwbfDS9xlR/3btjogdoXEebR
         XU5l74DLQ/T2Nej9n3ppdXALmDMpQVcbpX0vfAhmbe574PLi7+OIvXRFNQo8dDYFfYJd
         rbpQR531huJC/rxYOY6QDPviHp8ZCnArBrOla0hb531knL9g6U6MfDgQmvHl6MzFYh0c
         SZlqO0DWfNamPbiH3l6iadfLgRfMVpoVqoVLrA1Ky5f4et9edi2eLaQAaeg0r2fLZE+h
         Wdy1ZoxhnTONUBz4G285g94k+h3bl/640pLhrErq+73FWYXw8pkN5oq3nS/G0rJOjLWx
         TU1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=NsIy+5QS8MAvmTxwvKkgNcoLMQSoEdntxipLS8fbbIw=;
        b=RjoIWNpsdNV9r1jA4LNxVDFYAVsFSPjIfbcZ0e34cEtfic4Il3nslV/AJ37E+kaRfl
         gNStiGRXeP+PbmELOr4U39BB7wyVuuhYTAl0Uj3kJpGC8saTotCVpLC1r3SoSuecg/OE
         sguDtXMA51ftVWSEVWIjQTpLRNcLou2obe7GxamHzhGtRvcRa2ijCIpL9XEA/rwmfugC
         Ic2EVRuO/HMrB5ekO4w69lIfc5WpSwYhZMDpG4/iV6rSKETIqZVaRIaVjbFSEN2E2aoV
         mOWJgK1U0i1ivuSECHCTDrzGljV50grJe8guOhPaFzaXVfdjHcjN6twdCBMFSLoPl1n2
         vtkg==
X-Gm-Message-State: APjAAAWx9oDVMFqo/HOsaALp0kkJ7qgtYRn+7Wy6lm36Itt3pQ+V7HX9
        Ro5TJYd6EOaCjCfaSQgVCFx0n3Ls
X-Google-Smtp-Source: APXvYqwnhxjIavMpiTJtoRyli3xhUxa8sBz9zAGH3H2UwtZARnntRGeT24uTY8v1lCcJJAz/CSt6NQ==
X-Received: by 2002:adf:b219:: with SMTP id u25mr4018080wra.327.1570647355433;
        Wed, 09 Oct 2019 11:55:55 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f26:6400:7498:ba13:ecb8:b47c? (p200300EA8F2664007498BA13ECB8B47C.dip0.t-ipconnect.de. [2003:ea:8f26:6400:7498:ba13:ecb8:b47c])
        by smtp.googlemail.com with ESMTPSA id v6sm5671665wma.24.2019.10.09.11.55.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 09 Oct 2019 11:55:54 -0700 (PDT)
To:     David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Mariusz Bialonczyk <manio@skyboo.net>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net] r8169: fix jumbo packet handling on resume from suspend
Message-ID: <05ef825e-6ab2-cc25-be4e-54d52acd752f@gmail.com>
Date:   Wed, 9 Oct 2019 20:55:48 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mariusz reported that invalid packets are sent after resume from
suspend if jumbo packets are active. It turned out that his BIOS
resets chip settings to non-jumbo on resume. Most chip settings are
re-initialized on resume from suspend by calling rtl_hw_start(),
so let's add configuring jumbo to this function.
There's nothing wrong with the commit marked as fixed, it's just
the first one where the patch applies cleanly.

Fixes: 7366016d2d4c ("r8169: read common register for PCI commit")
Reported-by: Mariusz Bialonczyk <manio@skyboo.net>
Tested-by: Mariusz Bialonczyk <manio@skyboo.net>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 35 +++++++----------------
 1 file changed, 11 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 74f81fe03..350b0d949 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4146,6 +4146,14 @@ static void rtl_hw_jumbo_disable(struct rtl8169_private *tp)
 	rtl_lock_config_regs(tp);
 }
 
+static void rtl_jumbo_config(struct rtl8169_private *tp, int mtu)
+{
+	if (mtu > ETH_DATA_LEN)
+		rtl_hw_jumbo_enable(tp);
+	else
+		rtl_hw_jumbo_disable(tp);
+}
+
 DECLARE_RTL_COND(rtl_chipcmd_cond)
 {
 	return RTL_R8(tp, ChipCmd) & CmdReset;
@@ -4442,11 +4450,6 @@ static void rtl8168g_set_pause_thresholds(struct rtl8169_private *tp,
 static void rtl_hw_start_8168bb(struct rtl8169_private *tp)
 {
 	RTL_W8(tp, Config3, RTL_R8(tp, Config3) & ~Beacon_en);
-
-	if (tp->dev->mtu <= ETH_DATA_LEN) {
-		rtl_tx_performance_tweak(tp, PCI_EXP_DEVCTL_READRQ_4096B |
-					 PCI_EXP_DEVCTL_NOSNOOP_EN);
-	}
 }
 
 static void rtl_hw_start_8168bef(struct rtl8169_private *tp)
@@ -4462,9 +4465,6 @@ static void __rtl_hw_start_8168cp(struct rtl8169_private *tp)
 
 	RTL_W8(tp, Config3, RTL_R8(tp, Config3) & ~Beacon_en);
 
-	if (tp->dev->mtu <= ETH_DATA_LEN)
-		rtl_tx_performance_tweak(tp, PCI_EXP_DEVCTL_READRQ_4096B);
-
 	rtl_disable_clock_request(tp);
 }
 
@@ -4490,9 +4490,6 @@ static void rtl_hw_start_8168cp_2(struct rtl8169_private *tp)
 	rtl_set_def_aspm_entry_latency(tp);
 
 	RTL_W8(tp, Config3, RTL_R8(tp, Config3) & ~Beacon_en);
-
-	if (tp->dev->mtu <= ETH_DATA_LEN)
-		rtl_tx_performance_tweak(tp, PCI_EXP_DEVCTL_READRQ_4096B);
 }
 
 static void rtl_hw_start_8168cp_3(struct rtl8169_private *tp)
@@ -4503,9 +4500,6 @@ static void rtl_hw_start_8168cp_3(struct rtl8169_private *tp)
 
 	/* Magic. */
 	RTL_W8(tp, DBG_REG, 0x20);
-
-	if (tp->dev->mtu <= ETH_DATA_LEN)
-		rtl_tx_performance_tweak(tp, PCI_EXP_DEVCTL_READRQ_4096B);
 }
 
 static void rtl_hw_start_8168c_1(struct rtl8169_private *tp)
@@ -4611,9 +4605,6 @@ static void rtl_hw_start_8168e_1(struct rtl8169_private *tp)
 
 	rtl_ephy_init(tp, e_info_8168e_1);
 
-	if (tp->dev->mtu <= ETH_DATA_LEN)
-		rtl_tx_performance_tweak(tp, PCI_EXP_DEVCTL_READRQ_4096B);
-
 	rtl_disable_clock_request(tp);
 
 	/* Reset tx FIFO pointer */
@@ -4636,9 +4627,6 @@ static void rtl_hw_start_8168e_2(struct rtl8169_private *tp)
 
 	rtl_ephy_init(tp, e_info_8168e_2);
 
-	if (tp->dev->mtu <= ETH_DATA_LEN)
-		rtl_tx_performance_tweak(tp, PCI_EXP_DEVCTL_READRQ_4096B);
-
 	rtl_eri_write(tp, 0xc0, ERIAR_MASK_0011, 0x0000);
 	rtl_eri_write(tp, 0xb8, ERIAR_MASK_0011, 0x0000);
 	rtl_set_fifo_size(tp, 0x10, 0x10, 0x02, 0x06);
@@ -5485,6 +5473,8 @@ static void rtl_hw_start(struct  rtl8169_private *tp)
 	rtl_set_rx_tx_desc_registers(tp);
 	rtl_lock_config_regs(tp);
 
+	rtl_jumbo_config(tp, tp->dev->mtu);
+
 	/* Initially a 10 us delay. Turned it into a PCI commit. - FR */
 	RTL_R16(tp, CPlusCmd);
 	RTL_W8(tp, ChipCmd, CmdTxEnb | CmdRxEnb);
@@ -5498,10 +5488,7 @@ static int rtl8169_change_mtu(struct net_device *dev, int new_mtu)
 {
 	struct rtl8169_private *tp = netdev_priv(dev);
 
-	if (new_mtu > ETH_DATA_LEN)
-		rtl_hw_jumbo_enable(tp);
-	else
-		rtl_hw_jumbo_disable(tp);
+	rtl_jumbo_config(tp, new_mtu);
 
 	dev->mtu = new_mtu;
 	netdev_update_features(dev);
-- 
2.23.0

