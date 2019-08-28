Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54F13A0B89
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 22:30:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727059AbfH1U3n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 16:29:43 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:36198 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726961AbfH1U33 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 16:29:29 -0400
Received: by mail-wr1-f67.google.com with SMTP id y19so1127162wrd.3
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 13:29:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SH09Ek+ColuRMDrFrC/atuCbkMFA4SeE1Yb2H1oDIuA=;
        b=mwkoHb96FW0pCFPmZZqmNMNfEqVIbxQlmqVh+aYjr+CxIqcsofYVOkwiz/+GGTIR3X
         ZlL/xT+rtUShBleCYYjPmDsETliTugMbodp6F8WTX5/U3Mq9I4J1GxtuuO8dqqZ56ABL
         zrXlXTZ4yjbWwHfxYNlE3q3fPPFc0muf0PWUecPF6TXc974PrbGPx3Z82ZhZt2vWTArz
         E+ERZtwiaor5dQkgTsMNVurZwNbdm622Lv8WiK1YYCGolS1C7EpIrTtPP6JmZlWegIKA
         +WXnHgtob1YRs/RTpetLpo4o9BN4uPVG2loJ3O8GERpJeVKa1UKP6gSCd3OgptSMz/9+
         dCOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SH09Ek+ColuRMDrFrC/atuCbkMFA4SeE1Yb2H1oDIuA=;
        b=qTzaTgrzi+lWjZNQeXZPSjThtVXB9wWftAS0wtschmCrXQu73zLGY3OCk2u498PhdC
         uyc7qHicsiJEmi1hE+msIrRvj/RDpZFcWkiDcYxQRXviclm0aRKIYp+pNw5oJE6O2l4Y
         pQg+JdQO1ooj2a0122SZJE0by7T/9VKJNSRO26BrT6u0Y4ltANhCMVcwlr9kG8ISUA0p
         tT+S9Iipf0/3xUyDSsoaHdP0jtB5wXQBE9REm0zie5FldT4EpmZIgXMRQXG4uXH0VYzr
         8UIfnJyXIizU6/ZxTCZ0IBK8Aq70ZI6cEzjL1UNryXO1mnLbRAo+OM/RJLNl/Hi1ng9r
         nyCg==
X-Gm-Message-State: APjAAAWLp9bemvAY1meAb8DMahoxI9wz9bdZWNVWBmr/DOC4QnbhxO5m
        rXSeNly8oSQNP0yya3h5lIM=
X-Google-Smtp-Source: APXvYqwKq6nmyWUq87jwkQ7d39ZiK4KO7bm1Eilyg/7qgg/+w3UxmZQdHx4X1LTCyL1CP56yRQB2SQ==
X-Received: by 2002:adf:8b13:: with SMTP id n19mr6516825wra.203.1567024167391;
        Wed, 28 Aug 2019 13:29:27 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f04:7c00:ac08:eff5:e9d6:77a9? (p200300EA8F047C00AC08EFF5E9D677A9.dip0.t-ipconnect.de. [2003:ea:8f04:7c00:ac08:eff5:e9d6:77a9])
        by smtp.googlemail.com with ESMTPSA id b18sm389457wro.34.2019.08.28.13.29.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 28 Aug 2019 13:29:26 -0700 (PDT)
Subject: [PATCH net-next v2 4/9] r8169: move disabling interrupt coalescing to
 RTL8169/RTL8168 init
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Chun-Hao Lin <hau@realtek.com>
References: <8181244b-24ac-73e2-bac7-d01f644ebb3f@gmail.com>
Message-ID: <de461aca-0b84-4055-d4dc-e3980cb677db@gmail.com>
Date:   Wed, 28 Aug 2019 22:26:13 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <8181244b-24ac-73e2-bac7-d01f644ebb3f@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RTL8125 doesn't support the same coalescing registers, therefore move
this initialization to the 8168/6169-specific init.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 7d89826cb..dc799528f 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -5087,6 +5087,9 @@ static void rtl_hw_start_8168(struct rtl8169_private *tp)
 		RTL_W8(tp, MaxTxPacketSize, TxPacketMax);
 
 	rtl_hw_config(tp);
+
+	/* disable interrupt coalescing */
+	RTL_W16(tp, IntrMitigate, 0x0000);
 }
 
 static void rtl_hw_start_8169(struct rtl8169_private *tp)
@@ -5110,6 +5113,9 @@ static void rtl_hw_start_8169(struct rtl8169_private *tp)
 	rtl8169_set_magic_reg(tp, tp->mac_version);
 
 	RTL_W32(tp, RxMissed, 0);
+
+	/* disable interrupt coalescing */
+	RTL_W16(tp, IntrMitigate, 0x0000);
 }
 
 static void rtl_hw_start(struct  rtl8169_private *tp)
@@ -5128,8 +5134,6 @@ static void rtl_hw_start(struct  rtl8169_private *tp)
 	rtl_set_rx_tx_desc_registers(tp);
 	rtl_lock_config_regs(tp);
 
-	/* disable interrupt coalescing */
-	RTL_W16(tp, IntrMitigate, 0x0000);
 	/* Initially a 10 us delay. Turned it into a PCI commit. - FR */
 	RTL_R8(tp, IntrMask);
 	RTL_W8(tp, ChipCmd, CmdTxEnb | CmdRxEnb);
-- 
2.23.0


