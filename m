Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 224E867A09
	for <lists+netdev@lfdr.de>; Sat, 13 Jul 2019 13:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727706AbfGMLz5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Jul 2019 07:55:57 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:38443 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727489AbfGMLz5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Jul 2019 07:55:57 -0400
Received: by mail-wm1-f68.google.com with SMTP id s15so11094997wmj.3
        for <netdev@vger.kernel.org>; Sat, 13 Jul 2019 04:55:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=mSeAEbFGFSOPZHITLmB52DlOfoii3Iy6uukfzBlTHrU=;
        b=ksN43EaKGTnoMlO/bocV2GeiKWJQZ9H1RVSE7O0QW7kW3bWS5lilCiN3yqXLQcA757
         lyDdJ6xkS0tEE0Ote89mMH+nT03Gy3hcT9MBv1oAy5D00fLK2WDu3DFuzRmnA46Od+8R
         3Oi0JULdGE+9KmMfzWmzuhKPcjxujDrYa655UrowYiYwhEdXMQnzlt5bsOBfGwYCS5On
         3j8F45/hfQexPl6MCZTT/5o2kNPQ6zPW+10oxT5GlQ57CVKo2WYMylXjRfjlptclTyy6
         Zc13a5JvXzV2gX+4Adn+8e6ZNNW60bq+MCxYPsW0MFPJ7MES0P7t443xBYyCYksrnXxv
         mryg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=mSeAEbFGFSOPZHITLmB52DlOfoii3Iy6uukfzBlTHrU=;
        b=owJkVfxO4LOm1ZVBABCKGPbjWy8CbGnzxy5zUaFotpYunb0u4S8Hx+ZswsUrDOCum6
         QIiYB5of8CAXWPB8j+L3a/CNgCXz1ARLwGsfowFilwRDaSMeDghjPliqUhKozD7MWzs4
         hXamaagoPY7Nz8ilAHG4KnM3+15whfGdsyCIFK5glqtFJuqXsGiCW1R70URUVAk7sMEX
         5A6l7UvtIG28XTNXbjJ9yLHMRK9IYF3vnUjcFCcqf9pB7npzuQvyQO21nK8eoo4OhqRW
         xXDxTZ2V3A8LCmfeAdxeoDhjKat4PuTo9w1kWpQQjw77+H1nxXz2ktBAMYc0rWkczqC6
         9anA==
X-Gm-Message-State: APjAAAXjS8DyiWyl/vBa6dCleWyWHCnrBnJAeDUD/D29JNUyDeBjz5xm
        XAEZvnJvX8RGu3DnzWXeJRQ=
X-Google-Smtp-Source: APXvYqzPwyR5v3vDGIfylQ1MYzA/y6yIlYCY8Gti1t5GdJ03oVHfl/C5J9svl4nzttqgyZvlP1ThQA==
X-Received: by 2002:a7b:c4c1:: with SMTP id g1mr15153575wmk.14.1563018954149;
        Sat, 13 Jul 2019 04:55:54 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bd6:c00:9c47:80d8:6d49:f2a9? (p200300EA8BD60C009C4780D86D49F2A9.dip0.t-ipconnect.de. [2003:ea:8bd6:c00:9c47:80d8:6d49:f2a9])
        by smtp.googlemail.com with ESMTPSA id l9sm10374904wmh.36.2019.07.13.04.55.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 13 Jul 2019 04:55:53 -0700 (PDT)
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net] r8169: fix issue with confused RX unit after PHY
 power-down on RTL8411b
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ionut Radu <ionut.radu@gmail.com>
Message-ID: <58682c9d-3253-ca24-d91e-ca47b7ca0d93@gmail.com>
Date:   Sat, 13 Jul 2019 13:55:45 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On RTL8411b the RX unit gets confused if the PHY is powered-down.
This was reported in [0] and confirmed by Realtek. Realtek provided
a sequence to fix the RX unit after PHY wakeup.

The issue itself seems to have been there longer, the Fixes tag
refers to where the fix applies properly.

[0] https://bugzilla.redhat.com/show_bug.cgi?id=1692075

Fixes: a99790bf5c7f ("r8169: Reinstate ASPM Support")
Tested-by: Ionut Radu <ionut.radu@gmail.com>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
This patch is for versions up to 5.2. On versions before 5.2 there
may be little fuzz when applying because rtl_ephy_init used to have
one parameter more.
---
 drivers/net/ethernet/realtek/r8169.c | 137 +++++++++++++++++++++++++++
 1 file changed, 137 insertions(+)

diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
index d06a61f00..96637fcbe 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -5157,6 +5157,143 @@ static void rtl_hw_start_8411_2(struct rtl8169_private *tp)
 	/* disable aspm and clock request before access ephy */
 	rtl_hw_aspm_clkreq_enable(tp, false);
 	rtl_ephy_init(tp, e_info_8411_2);
+
+	/* The following Realtek-provided magic fixes an issue with the RX unit
+	 * getting confused after the PHY having been powered-down.
+	 */
+	r8168_mac_ocp_write(tp, 0xFC28, 0x0000);
+	r8168_mac_ocp_write(tp, 0xFC2A, 0x0000);
+	r8168_mac_ocp_write(tp, 0xFC2C, 0x0000);
+	r8168_mac_ocp_write(tp, 0xFC2E, 0x0000);
+	r8168_mac_ocp_write(tp, 0xFC30, 0x0000);
+	r8168_mac_ocp_write(tp, 0xFC32, 0x0000);
+	r8168_mac_ocp_write(tp, 0xFC34, 0x0000);
+	r8168_mac_ocp_write(tp, 0xFC36, 0x0000);
+	mdelay(3);
+	r8168_mac_ocp_write(tp, 0xFC26, 0x0000);
+
+	r8168_mac_ocp_write(tp, 0xF800, 0xE008);
+	r8168_mac_ocp_write(tp, 0xF802, 0xE00A);
+	r8168_mac_ocp_write(tp, 0xF804, 0xE00C);
+	r8168_mac_ocp_write(tp, 0xF806, 0xE00E);
+	r8168_mac_ocp_write(tp, 0xF808, 0xE027);
+	r8168_mac_ocp_write(tp, 0xF80A, 0xE04F);
+	r8168_mac_ocp_write(tp, 0xF80C, 0xE05E);
+	r8168_mac_ocp_write(tp, 0xF80E, 0xE065);
+	r8168_mac_ocp_write(tp, 0xF810, 0xC602);
+	r8168_mac_ocp_write(tp, 0xF812, 0xBE00);
+	r8168_mac_ocp_write(tp, 0xF814, 0x0000);
+	r8168_mac_ocp_write(tp, 0xF816, 0xC502);
+	r8168_mac_ocp_write(tp, 0xF818, 0xBD00);
+	r8168_mac_ocp_write(tp, 0xF81A, 0x074C);
+	r8168_mac_ocp_write(tp, 0xF81C, 0xC302);
+	r8168_mac_ocp_write(tp, 0xF81E, 0xBB00);
+	r8168_mac_ocp_write(tp, 0xF820, 0x080A);
+	r8168_mac_ocp_write(tp, 0xF822, 0x6420);
+	r8168_mac_ocp_write(tp, 0xF824, 0x48C2);
+	r8168_mac_ocp_write(tp, 0xF826, 0x8C20);
+	r8168_mac_ocp_write(tp, 0xF828, 0xC516);
+	r8168_mac_ocp_write(tp, 0xF82A, 0x64A4);
+	r8168_mac_ocp_write(tp, 0xF82C, 0x49C0);
+	r8168_mac_ocp_write(tp, 0xF82E, 0xF009);
+	r8168_mac_ocp_write(tp, 0xF830, 0x74A2);
+	r8168_mac_ocp_write(tp, 0xF832, 0x8CA5);
+	r8168_mac_ocp_write(tp, 0xF834, 0x74A0);
+	r8168_mac_ocp_write(tp, 0xF836, 0xC50E);
+	r8168_mac_ocp_write(tp, 0xF838, 0x9CA2);
+	r8168_mac_ocp_write(tp, 0xF83A, 0x1C11);
+	r8168_mac_ocp_write(tp, 0xF83C, 0x9CA0);
+	r8168_mac_ocp_write(tp, 0xF83E, 0xE006);
+	r8168_mac_ocp_write(tp, 0xF840, 0x74F8);
+	r8168_mac_ocp_write(tp, 0xF842, 0x48C4);
+	r8168_mac_ocp_write(tp, 0xF844, 0x8CF8);
+	r8168_mac_ocp_write(tp, 0xF846, 0xC404);
+	r8168_mac_ocp_write(tp, 0xF848, 0xBC00);
+	r8168_mac_ocp_write(tp, 0xF84A, 0xC403);
+	r8168_mac_ocp_write(tp, 0xF84C, 0xBC00);
+	r8168_mac_ocp_write(tp, 0xF84E, 0x0BF2);
+	r8168_mac_ocp_write(tp, 0xF850, 0x0C0A);
+	r8168_mac_ocp_write(tp, 0xF852, 0xE434);
+	r8168_mac_ocp_write(tp, 0xF854, 0xD3C0);
+	r8168_mac_ocp_write(tp, 0xF856, 0x49D9);
+	r8168_mac_ocp_write(tp, 0xF858, 0xF01F);
+	r8168_mac_ocp_write(tp, 0xF85A, 0xC526);
+	r8168_mac_ocp_write(tp, 0xF85C, 0x64A5);
+	r8168_mac_ocp_write(tp, 0xF85E, 0x1400);
+	r8168_mac_ocp_write(tp, 0xF860, 0xF007);
+	r8168_mac_ocp_write(tp, 0xF862, 0x0C01);
+	r8168_mac_ocp_write(tp, 0xF864, 0x8CA5);
+	r8168_mac_ocp_write(tp, 0xF866, 0x1C15);
+	r8168_mac_ocp_write(tp, 0xF868, 0xC51B);
+	r8168_mac_ocp_write(tp, 0xF86A, 0x9CA0);
+	r8168_mac_ocp_write(tp, 0xF86C, 0xE013);
+	r8168_mac_ocp_write(tp, 0xF86E, 0xC519);
+	r8168_mac_ocp_write(tp, 0xF870, 0x74A0);
+	r8168_mac_ocp_write(tp, 0xF872, 0x48C4);
+	r8168_mac_ocp_write(tp, 0xF874, 0x8CA0);
+	r8168_mac_ocp_write(tp, 0xF876, 0xC516);
+	r8168_mac_ocp_write(tp, 0xF878, 0x74A4);
+	r8168_mac_ocp_write(tp, 0xF87A, 0x48C8);
+	r8168_mac_ocp_write(tp, 0xF87C, 0x48CA);
+	r8168_mac_ocp_write(tp, 0xF87E, 0x9CA4);
+	r8168_mac_ocp_write(tp, 0xF880, 0xC512);
+	r8168_mac_ocp_write(tp, 0xF882, 0x1B00);
+	r8168_mac_ocp_write(tp, 0xF884, 0x9BA0);
+	r8168_mac_ocp_write(tp, 0xF886, 0x1B1C);
+	r8168_mac_ocp_write(tp, 0xF888, 0x483F);
+	r8168_mac_ocp_write(tp, 0xF88A, 0x9BA2);
+	r8168_mac_ocp_write(tp, 0xF88C, 0x1B04);
+	r8168_mac_ocp_write(tp, 0xF88E, 0xC508);
+	r8168_mac_ocp_write(tp, 0xF890, 0x9BA0);
+	r8168_mac_ocp_write(tp, 0xF892, 0xC505);
+	r8168_mac_ocp_write(tp, 0xF894, 0xBD00);
+	r8168_mac_ocp_write(tp, 0xF896, 0xC502);
+	r8168_mac_ocp_write(tp, 0xF898, 0xBD00);
+	r8168_mac_ocp_write(tp, 0xF89A, 0x0300);
+	r8168_mac_ocp_write(tp, 0xF89C, 0x051E);
+	r8168_mac_ocp_write(tp, 0xF89E, 0xE434);
+	r8168_mac_ocp_write(tp, 0xF8A0, 0xE018);
+	r8168_mac_ocp_write(tp, 0xF8A2, 0xE092);
+	r8168_mac_ocp_write(tp, 0xF8A4, 0xDE20);
+	r8168_mac_ocp_write(tp, 0xF8A6, 0xD3C0);
+	r8168_mac_ocp_write(tp, 0xF8A8, 0xC50F);
+	r8168_mac_ocp_write(tp, 0xF8AA, 0x76A4);
+	r8168_mac_ocp_write(tp, 0xF8AC, 0x49E3);
+	r8168_mac_ocp_write(tp, 0xF8AE, 0xF007);
+	r8168_mac_ocp_write(tp, 0xF8B0, 0x49C0);
+	r8168_mac_ocp_write(tp, 0xF8B2, 0xF103);
+	r8168_mac_ocp_write(tp, 0xF8B4, 0xC607);
+	r8168_mac_ocp_write(tp, 0xF8B6, 0xBE00);
+	r8168_mac_ocp_write(tp, 0xF8B8, 0xC606);
+	r8168_mac_ocp_write(tp, 0xF8BA, 0xBE00);
+	r8168_mac_ocp_write(tp, 0xF8BC, 0xC602);
+	r8168_mac_ocp_write(tp, 0xF8BE, 0xBE00);
+	r8168_mac_ocp_write(tp, 0xF8C0, 0x0C4C);
+	r8168_mac_ocp_write(tp, 0xF8C2, 0x0C28);
+	r8168_mac_ocp_write(tp, 0xF8C4, 0x0C2C);
+	r8168_mac_ocp_write(tp, 0xF8C6, 0xDC00);
+	r8168_mac_ocp_write(tp, 0xF8C8, 0xC707);
+	r8168_mac_ocp_write(tp, 0xF8CA, 0x1D00);
+	r8168_mac_ocp_write(tp, 0xF8CC, 0x8DE2);
+	r8168_mac_ocp_write(tp, 0xF8CE, 0x48C1);
+	r8168_mac_ocp_write(tp, 0xF8D0, 0xC502);
+	r8168_mac_ocp_write(tp, 0xF8D2, 0xBD00);
+	r8168_mac_ocp_write(tp, 0xF8D4, 0x00AA);
+	r8168_mac_ocp_write(tp, 0xF8D6, 0xE0C0);
+	r8168_mac_ocp_write(tp, 0xF8D8, 0xC502);
+	r8168_mac_ocp_write(tp, 0xF8DA, 0xBD00);
+	r8168_mac_ocp_write(tp, 0xF8DC, 0x0132);
+
+	r8168_mac_ocp_write(tp, 0xFC26, 0x8000);
+
+	r8168_mac_ocp_write(tp, 0xFC2A, 0x0743);
+	r8168_mac_ocp_write(tp, 0xFC2C, 0x0801);
+	r8168_mac_ocp_write(tp, 0xFC2E, 0x0BE9);
+	r8168_mac_ocp_write(tp, 0xFC30, 0x02FD);
+	r8168_mac_ocp_write(tp, 0xFC32, 0x0C25);
+	r8168_mac_ocp_write(tp, 0xFC34, 0x00A9);
+	r8168_mac_ocp_write(tp, 0xFC36, 0x012D);
+
 	rtl_hw_aspm_clkreq_enable(tp, true);
 }
 
-- 
2.22.0

