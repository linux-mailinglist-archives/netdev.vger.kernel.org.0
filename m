Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FEA512A54A
	for <lists+netdev@lfdr.de>; Wed, 25 Dec 2019 01:58:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbfLYA55 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Dec 2019 19:57:57 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:40261 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726245AbfLYA54 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Dec 2019 19:57:56 -0500
Received: by mail-wm1-f66.google.com with SMTP id t14so3500789wmi.5;
        Tue, 24 Dec 2019 16:57:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6qx3JuRWucxWSZ+edEqkzvKfjwC/qHMJGDM4MA7mRVg=;
        b=WAwEyf9Z6R6RPOxZ66EqNRQZQ/elC7tzeA/mn5bIOlxp8yZz+nS/BxDaKgYaFwfrwf
         9b6O3XYC0Z6/4CSU1raIO9xqGyG0UXjUsvZuz6PihpBJc3JyAT76iT76Xxv2PhW+F69E
         YcBYqaIDmNM3HZZmTC6kLjY9vQng9uwX75RxEuhAKlrNji9btuO8khgsADSUsGWlB08p
         vSaG//6exaCwKeBBy5q29SFW4ugGU7isTDy0weKFZJ2ZD3TinNdcT22uPYuDz3fjjH2s
         EpO7/UY1LUXPzIiFg9eku7VkHkUjW4p/bJZX8DogDpQOAYAdMwbZHgKZZz03BQx5YKlu
         L57g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6qx3JuRWucxWSZ+edEqkzvKfjwC/qHMJGDM4MA7mRVg=;
        b=WNtrRoVAAW8HgUxR6ko5mMGyEyuNfn12/+n+B/HjZMMLthMKr8XWBAey102Adhm/4z
         22Zc32q0vSiOzYaZQvhT8byD2Vv+xcHV0Y5QqAwV1peU561ZlJmY7Hbvu8fjhfXsh+v9
         3VI6Yf+a/W7AilK/QUXdy1ZjIaFrHNthJzCpq4UZ5HAoxM9GyKms5oF7qQCdVtaeC8j7
         NT7LkISQmCJk3g4bdMvHOwze8f0pE5f0PAmG4oPcC/+AKRBLmM38MkKdIJu69Su+X+7z
         u8+1pCaMQ4CgVjDqeUdvzebPRT74Z/Evmmf8NImyrTxmkQKd/itCBQpW4JUCAhIlz2qv
         3g4g==
X-Gm-Message-State: APjAAAUz2wtgu21ojdsrlu/aoRTXYodjJUBulrCfMSpiaDikEeTX/XPc
        atlrOVA9Oovq028N5SxYrCI=
X-Google-Smtp-Source: APXvYqxXWv43UCTkk1HCYbZEh4PBsUSaBygIx+bAc3UIAf86L9GvuTHsdSzps77k73Ih82tygfr34w==
X-Received: by 2002:a7b:c957:: with SMTP id i23mr6473304wml.49.1577235474370;
        Tue, 24 Dec 2019 16:57:54 -0800 (PST)
Received: from localhost.localdomain (p200300F1373A1900428D5CFFFEB99DB8.dip0.t-ipconnect.de. [2003:f1:373a:1900:428d:5cff:feb9:9db8])
        by smtp.googlemail.com with ESMTPSA id e18sm26034448wrw.70.2019.12.24.16.57.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Dec 2019 16:57:53 -0800 (PST)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-amlogic@lists.infradead.org, netdev@vger.kernel.org,
        davem@davemloft.net, khilman@baylibre.com
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        balbes-150@yandex.ru, ingrassia@epigenesys.com,
        jbrunet@baylibre.com, linus.luessing@c0d3.blue,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH 1/3] net: stmmac: dwmac-meson8b: Fix the RGMII TX delay on Meson8b/8m2 SoCs
Date:   Wed, 25 Dec 2019 01:56:53 +0100
Message-Id: <20191225005655.1502037-2-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191225005655.1502037-1-martin.blumenstingl@googlemail.com>
References: <20191225005655.1502037-1-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

GXBB and newer SoCs use the fixed FCLK_DIV2 (1GHz) clock as input for
the m250_sel clock. Meson8b and Meson8m2 use MPLL2 instead, whose rate
can be adjusted at runtime.

So far we have been running MPLL2 with ~250MHz (and the internal
m250_div with value 1), which worked enough that we could transfer data
with an TX delay of 4ns. Unfortunately there is high packet loss with
an RGMII PHY when transferring data (receiving data works fine though).
Odroid-C1's u-boot is running with a TX delay of only 2ns as well as
the internal m250_div set to 2 - no lost (TX) packets can be observed
with that setting in u-boot.

Manual testing has shown that the TX packet loss goes away when using
the following settings in Linux:
- MPLL2 clock set to ~500MHz
- m250_div set to 2
- TX delay set to 2ns

Update the m250_div divider settings to only accept dividers greater or
equal 2. This will allow the Meson8 and Meson8m2 .dts to be updated to
use a TX delay of 2ns (instead of 4ns) to fix the TX packet loss.

iperf3 results before the change:
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-10.00  sec   182 MBytes   153 Mbits/sec  514      sender
[  5]   0.00-10.00  sec   182 MBytes   152 Mbits/sec           receiver

iperf3 results after the change (including an updated TX delay of 2ns):
[ ID] Interval           Transfer     Bitrate         Retr  Cwnd
[  5]   0.00-10.00  sec   927 MBytes   778 Mbits/sec    0      sender
[  5]   0.00-10.01  sec   927 MBytes   777 Mbits/sec           receiver

Fixes: 4f6a71b84e1afd ("net: stmmac: dwmac-meson8b: fix internal RGMII clock configuration")
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 .../net/ethernet/stmicro/stmmac/dwmac-meson8b.c    | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
index bd6c01004913..0e2fa14f1423 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-meson8b.c
@@ -112,6 +112,14 @@ static int meson8b_init_rgmii_tx_clk(struct meson8b_dwmac *dwmac)
 	struct device *dev = dwmac->dev;
 	const char *parent_name, *mux_parent_names[MUX_CLK_NUM_PARENTS];
 	struct meson8b_dwmac_clk_configs *clk_configs;
+	static const struct clk_div_table div_table[] = {
+		{ .div = 2, .val = 2, },
+		{ .div = 3, .val = 3, },
+		{ .div = 4, .val = 4, },
+		{ .div = 5, .val = 5, },
+		{ .div = 6, .val = 6, },
+		{ .div = 7, .val = 7, },
+	};
 
 	clk_configs = devm_kzalloc(dev, sizeof(*clk_configs), GFP_KERNEL);
 	if (!clk_configs)
@@ -146,9 +154,9 @@ static int meson8b_init_rgmii_tx_clk(struct meson8b_dwmac *dwmac)
 	clk_configs->m250_div.reg = dwmac->regs + PRG_ETH0;
 	clk_configs->m250_div.shift = PRG_ETH0_CLK_M250_DIV_SHIFT;
 	clk_configs->m250_div.width = PRG_ETH0_CLK_M250_DIV_WIDTH;
-	clk_configs->m250_div.flags = CLK_DIVIDER_ONE_BASED |
-				CLK_DIVIDER_ALLOW_ZERO |
-				CLK_DIVIDER_ROUND_CLOSEST;
+	clk_configs->m250_div.table = div_table;
+	clk_configs->m250_div.flags = CLK_DIVIDER_ALLOW_ZERO |
+				      CLK_DIVIDER_ROUND_CLOSEST;
 	clk = meson8b_dwmac_register_clk(dwmac, "m250_div", &parent_name, 1,
 					 &clk_divider_ops,
 					 &clk_configs->m250_div.hw);
-- 
2.24.1

