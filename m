Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15F691AF513
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 23:11:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727951AbgDRVLq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 17:11:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726014AbgDRVLp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Apr 2020 17:11:45 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75DD6C061A0C
        for <netdev@vger.kernel.org>; Sat, 18 Apr 2020 14:11:45 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id k11so7269576wrp.5
        for <netdev@vger.kernel.org>; Sat, 18 Apr 2020 14:11:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6WsBh7yC9GGHOCAEQNNmkhM5QJFhiatS38rIa73bN3Y=;
        b=obsWQ0ae3T1yrJByVs/Qtgei9GUlKBN99qoY78U4sw+njjqpShqAXSJGbfCa7nHT9A
         O6MG5ShZhDbbjele9Nxjd7+8pQoAD4JPUZnjvwnU0Q99mfjPDC95nipuYjh/dgp0KRvx
         /cYDvGY+qhChc1BGdJmLNQlnTznqpJAs6Wy5CE1ePRV0hwh26M0NtMVqasTOxmI6E1az
         A5U3CsWNBeaHsOxVZbYPLB0upqFb9N/uPglvUiJsojCiqIdTyb1ZfrjgutskmRBbpwk5
         w2kuzWoICI0Xe8vXxYmSE53Qi9y3us36FRJ31fPsoLM5YFlUx/F4ztUTPvj6v/xbT5I+
         mqTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6WsBh7yC9GGHOCAEQNNmkhM5QJFhiatS38rIa73bN3Y=;
        b=gohv47DuljTcW/4/GJfny1jauREsbcmn+MhnDkZxP1OVRinfO2lPE9NrBWgnMrWfDj
         i3c8K1kf3OaW8PUAvZ/doKLbeJIRLwooepRpIkx39lrO0pdSzjK9AFPIRkx6cas9UIqj
         royY1a1Owc6AQ3KEIqcUNck3GIK+PWIbRZ9PsQ25n64T4MDWroMTaKyO5e0znVKQVFQl
         1+LtnsLmSZx2N9s17ft/60cnylo3eA7TUvQz9GweWiDSGnIWjF/+RZnApwFp/7IssXbL
         oRNh/SnrTARyNDC3VrgFWnI2mP3aw5FWTdkEqvsJ8A/yDSjL+vmgjEHFy+kod1L6vf/r
         ky/Q==
X-Gm-Message-State: AGi0PuZkUlYkXYBpZNSaOIshyR3pYV+c0PSBwB2TY+6iKZ3r2U+6M4j5
        M0vzn5RDttX9JPRNraj2YpKWnlww
X-Google-Smtp-Source: APiQypLQ9QFG/zMkm+66E3udSIoTWfyptE7EjuZ6cO41xa5u02GZGnVSHegOL92OqKvEqVT4KmrnsQ==
X-Received: by 2002:adf:fc92:: with SMTP id g18mr11009860wrr.10.1587244303745;
        Sat, 18 Apr 2020 14:11:43 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:939:e10c:14c5:fe9f? (p200300EA8F2960000939E10C14C5FE9F.dip0.t-ipconnect.de. [2003:ea:8f29:6000:939:e10c:14c5:fe9f])
        by smtp.googlemail.com with ESMTPSA id z10sm35504852wrg.69.2020.04.18.14.11.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Apr 2020 14:11:43 -0700 (PDT)
Subject: [PATCH net-next 1/6] r8169: move setting OCP base to generic init
 code
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <f7c53dc0-768c-7eb9-ffc0-b2e39b1ddfa4@gmail.com>
Message-ID: <7843ebdf-1910-c95a-453b-829e75409669@gmail.com>
Date:   Sat, 18 Apr 2020 23:06:51 +0200
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

Move setting the ocp_base to rtl_init_one(). Where supported the value
is always the same, and if not supported it doesn't hurt.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index cac56bd67..7bb423a0e 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -75,6 +75,8 @@
 #define R8169_TX_RING_BYTES	(NUM_TX_DESC * sizeof(struct TxDesc))
 #define R8169_RX_RING_BYTES	(NUM_RX_DESC * sizeof(struct RxDesc))
 
+#define OCP_STD_PHY_BASE	0xa400
+
 #define RTL_CFG_NO_GBIT	1
 
 /* write/read MMIO register */
@@ -847,8 +849,6 @@ static void r8168_mac_ocp_modify(struct rtl8169_private *tp, u32 reg, u16 mask,
 	r8168_mac_ocp_write(tp, reg, (data & ~mask) | set);
 }
 
-#define OCP_STD_PHY_BASE	0xa400
-
 static void r8168g_mdio_write(struct rtl8169_private *tp, int reg, int value)
 {
 	if (reg == 0x1f) {
@@ -5187,8 +5187,6 @@ static int r8169_mdio_register(struct rtl8169_private *tp)
 
 static void rtl_hw_init_8168g(struct rtl8169_private *tp)
 {
-	tp->ocp_base = OCP_STD_PHY_BASE;
-
 	RTL_W32(tp, MISC, RTL_R32(tp, MISC) | RXDV_GATED_EN);
 
 	if (!rtl_udelay_loop_wait_high(tp, &rtl_txcfg_empty_cond, 100, 42))
@@ -5213,8 +5211,6 @@ static void rtl_hw_init_8168g(struct rtl8169_private *tp)
 
 static void rtl_hw_init_8125(struct rtl8169_private *tp)
 {
-	tp->ocp_base = OCP_STD_PHY_BASE;
-
 	RTL_W32(tp, MISC, RTL_R32(tp, MISC) | RXDV_GATED_EN);
 
 	if (!rtl_udelay_loop_wait_high(tp, &rtl_rxtx_empty_cond, 100, 42))
@@ -5351,6 +5347,7 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	tp->msg_enable = netif_msg_init(debug.msg_enable, R8169_MSG_DEFAULT);
 	tp->supports_gmii = ent->driver_data == RTL_CFG_NO_GBIT ? 0 : 1;
 	tp->eee_adv = -1;
+	tp->ocp_base = OCP_STD_PHY_BASE;
 
 	/* Get the *optional* external "ether_clk" used on some boards */
 	rc = rtl_get_ether_clk(tp);
-- 
2.26.1


