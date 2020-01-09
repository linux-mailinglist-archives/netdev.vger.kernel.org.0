Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79ECE136139
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 20:36:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730764AbgAITfo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 14:35:44 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:38844 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730715AbgAITfn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 14:35:43 -0500
Received: by mail-wr1-f66.google.com with SMTP id y17so8695209wrh.5
        for <netdev@vger.kernel.org>; Thu, 09 Jan 2020 11:35:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+xva+S9PvVmTPFdSjSZgFqgXwif2CbVW6BzAgMrZGkA=;
        b=h/b+CDTklBIC+U2PQbdIDMRUXujL5ESjwwsOURzpmUKI4/XvwRD2vpWm3aiwVPAkTA
         c1Ns+LhLFx282LQnEjAjFuIIKGM0dMVfPbKJcjhn9mt9SJPQNJpNs0cwCjk8zg9XeiMy
         Bljk31IIvjKMd8alFiShZEd8HXkwQ9JAbuaROSLoKe0mcIkD5LUSwWPq3ABE52s9tpiO
         6/+d6P21bRWzKDJ07vX6n83REELKDxwKJKFi4cT5THzSXUrbQFM1TJqOtv/pU+ogy6BN
         QoVHSc/m0HzQcaJjxi3W5glsfOX1tDB+IQEdXyB3P9gw9lNwQsBQmOzHfQVdA6tG/j6C
         08vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+xva+S9PvVmTPFdSjSZgFqgXwif2CbVW6BzAgMrZGkA=;
        b=SGcj9SlYIcS32z15JqA6OV+V1/00LTGzOzJ6WkOJWdOS09TnCtSgaSoSiD27n5OkrW
         9r8B80nBSjboHiiSWdNkMLtlyFlx9lY7VnKHLzdrWa/SLncO9nSF/I5qVnALyIVNf1DJ
         GSH99Lb6eG0b0aJOrTDGxndILb8iUeDgAVj2+/4YDDHh04mEHrgzwuzTaKk4tFqCfSWc
         DOEbux485u65bpjniZSMcMcbTM2wzMNu7ZKbiSBba+hnU0HZ/K6C6iVjEJ08Xd01Hh+U
         pxgJso2vAdodn2rysG6sclS+iQgezZyXRvM2E3Fp7uzUQWe5XctsSVwoKc4xOkrWSZU4
         CWcQ==
X-Gm-Message-State: APjAAAVWskq4CN9FBHouw/gW2BxgAKtfzmNQ1ODBx3PTUE4GpipiZO5/
        bo3tuizt++UOyr3DLIfq6WJMHJMj
X-Google-Smtp-Source: APXvYqxdpbq6nvnDo7s6YP/Lz1WMW1ALrdyYBG+CXuQM8O8aR+31LIwnawlxGBgHQlym1b9IuXLaDA==
X-Received: by 2002:adf:fe90:: with SMTP id l16mr13324891wrr.265.1578598541640;
        Thu, 09 Jan 2020 11:35:41 -0800 (PST)
Received: from [192.168.178.85] (pD9F901D9.dip0.t-ipconnect.de. [217.249.1.217])
        by smtp.googlemail.com with ESMTPSA id k16sm9302680wru.0.2020.01.09.11.35.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jan 2020 11:35:41 -0800 (PST)
Subject: [PATCH net-next 07/15] r8169: move setting ERI register 0x1d0 for
 RTL8106
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <7e03fe05-ba95-c3c0-9a68-306b6450a141@gmail.com>
Message-ID: <63ade2ea-6e83-4f73-03ed-6a9380185239@gmail.com>
Date:   Thu, 9 Jan 2020 20:29:21 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <7e03fe05-ba95-c3c0-9a68-306b6450a141@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Writing this ERI register is a MAC setting, so move it to
rtl_hw_start_8106().

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index dccc5a1d3..d157c971c 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -3425,8 +3425,6 @@ static void rtl8106e_hw_phy_config(struct rtl8169_private *tp,
 
 	rtl_eri_write(tp, 0x1b0, ERIAR_MASK_0011, 0x0000);
 	rtl_writephy_batch(phydev, phy_reg_init);
-
-	rtl_eri_write(tp, 0x1d0, ERIAR_MASK_0011, 0x0000);
 }
 
 static void rtl8125_1_hw_phy_config(struct rtl8169_private *tp,
@@ -4999,6 +4997,8 @@ static void rtl_hw_start_8106(struct rtl8169_private *tp)
 	RTL_W8(tp, MCU, RTL_R8(tp, MCU) | EN_NDP | EN_OOB_RESET);
 	RTL_W8(tp, DLLPR, RTL_R8(tp, DLLPR) & ~PFM_EN);
 
+	rtl_eri_write(tp, 0x1d0, ERIAR_MASK_0011, 0x0000);
+
 	rtl_pcie_state_l2l3_disable(tp);
 	rtl_hw_aspm_clkreq_enable(tp, true);
 }
-- 
2.24.1


