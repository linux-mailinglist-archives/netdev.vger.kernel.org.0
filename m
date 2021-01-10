Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3F422F096A
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 20:53:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726720AbhAJTvu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 14:51:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726263AbhAJTvt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jan 2021 14:51:49 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CC8CC061786
        for <netdev@vger.kernel.org>; Sun, 10 Jan 2021 11:51:09 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id t16so14318149wra.3
        for <netdev@vger.kernel.org>; Sun, 10 Jan 2021 11:51:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=r8VJQNB2damptOcW1CZIDYyXVOcv08MPY/PIrsZ61r4=;
        b=Y1rQH5cknTqsm6seBvTG6fFZtRUqWi+PDZJ15E72xY4ipza7qxbhTgHTcpto8IZ92o
         KyzA4rMhpFXJ/e7Er/ddtFdc/ukcaEYBP9zRE+TMxVynp0hdjv9w3MmnqLoKDB+i7hNg
         VlyyxcLXrQC75SeCd1NefFY1WUqikXiL0fH612Iy7Gx9dKgz1Q6zByfl32yhecag1EuG
         llVbNfX5REQdHnqH47cmkUr8TQADtZcQV6yp/BVePCq861dCRBjEOfp1eLK6VRUaEMdR
         21aLffaHl4rAHOkJsCwX9LMiSI8tobzWa7/Tcbd6fzdVTDMWbvKRSQvkLZduaSde17L+
         5pCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=r8VJQNB2damptOcW1CZIDYyXVOcv08MPY/PIrsZ61r4=;
        b=c2ltQOc9chb8qima4SP1zMUaZEHHGVi7/KgvD3O7YQEagZV9XuPbhCMnWrhAR0Ch8A
         IBt8hRcKfmN72RGNva+eYr9iInbdMVujxyT+z/b3VrqW21PR6RDmC3KEJ6eklNla/qpi
         Co08iv5xrFZp6N+y2/kD/FeycnzXPGVfLC8wRcs2eE7XCYZKFM/w4FXFG5tJ9YZYpBRD
         eqf63ZwiQ1ETLj2qd9O0WN3ow9V38Ba6tozGJZAgcLlTH1HbIY2xX6nJJgCPs1kgGILd
         cOGzp6YSfZQN+PBdY3kHHWvbzochZG6F4kibbtyjlmhgu2vDSOZFbCq5uVsU5v1nBsbt
         al2w==
X-Gm-Message-State: AOAM531AHM6F9C2a6EcVVT85f0oBUzglQjI4AOp+YnBfLRxVLeFNl6rh
        scHDblRbZs58W7Cew+SRAqM80qZOGYQ=
X-Google-Smtp-Source: ABdhPJyPckT/sa5akgZf8U6kmYNfH/PTWMJmoug/5iQOoaszhryFwp+Lyo+LX500KZ2PW0xJD92jjA==
X-Received: by 2002:adf:8503:: with SMTP id 3mr13380873wrh.56.1610308267717;
        Sun, 10 Jan 2021 11:51:07 -0800 (PST)
Received: from ?IPv6:2003:ea:8f06:5500:5449:e139:28a3:e114? (p200300ea8f0655005449e13928a3e114.dip0.t-ipconnect.de. [2003:ea:8f06:5500:5449:e139:28a3:e114])
        by smtp.googlemail.com with ESMTPSA id o8sm21690646wrm.17.2021.01.10.11.51.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 10 Jan 2021 11:51:07 -0800 (PST)
Subject: [PATCH net-next 1/3] r8169: enable PLL power-down for chip versions
 34, 35, 36, 42
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <1608dfa3-c4a5-0e92-31f7-76674b3c173a@gmail.com>
Message-ID: <cfbda357-20f8-bbd5-e998-2f87b43c6a76@gmail.com>
Date:   Sun, 10 Jan 2021 20:48:40 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <1608dfa3-c4a5-0e92-31f7-76674b3c173a@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There's no known reason why PLL powerdown on D3 shouldn't be enabled
on chip versions 34, 35, 36, and 42. At least the vendor driver doesn't
exclude any of these chip versions.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index dbf0c2909..9c87fb9f1 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -2226,10 +2226,8 @@ static void rtl_pll_power_down(struct rtl8169_private *tp)
 
 	switch (tp->mac_version) {
 	case RTL_GIGA_MAC_VER_25 ... RTL_GIGA_MAC_VER_26:
-	case RTL_GIGA_MAC_VER_32 ... RTL_GIGA_MAC_VER_33:
-	case RTL_GIGA_MAC_VER_37:
-	case RTL_GIGA_MAC_VER_39 ... RTL_GIGA_MAC_VER_41:
-	case RTL_GIGA_MAC_VER_43 ... RTL_GIGA_MAC_VER_63:
+	case RTL_GIGA_MAC_VER_32 ... RTL_GIGA_MAC_VER_37:
+	case RTL_GIGA_MAC_VER_39 ... RTL_GIGA_MAC_VER_63:
 		RTL_W8(tp, PMCH, RTL_R8(tp, PMCH) & ~0x80);
 		break;
 	default:
@@ -2241,13 +2239,12 @@ static void rtl_pll_power_up(struct rtl8169_private *tp)
 {
 	switch (tp->mac_version) {
 	case RTL_GIGA_MAC_VER_25 ... RTL_GIGA_MAC_VER_26:
-	case RTL_GIGA_MAC_VER_32 ... RTL_GIGA_MAC_VER_33:
-	case RTL_GIGA_MAC_VER_37:
+	case RTL_GIGA_MAC_VER_32 ... RTL_GIGA_MAC_VER_37:
 	case RTL_GIGA_MAC_VER_39:
 	case RTL_GIGA_MAC_VER_43:
 		RTL_W8(tp, PMCH, RTL_R8(tp, PMCH) | 0x80);
 		break;
-	case RTL_GIGA_MAC_VER_40 ... RTL_GIGA_MAC_VER_41:
+	case RTL_GIGA_MAC_VER_40 ... RTL_GIGA_MAC_VER_42:
 	case RTL_GIGA_MAC_VER_44 ... RTL_GIGA_MAC_VER_63:
 		RTL_W8(tp, PMCH, RTL_R8(tp, PMCH) | 0xc0);
 		break;
-- 
2.30.0


