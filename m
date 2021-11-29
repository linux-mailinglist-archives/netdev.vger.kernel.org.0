Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B3BA4613B9
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 12:16:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240772AbhK2LTb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 06:19:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236859AbhK2LRX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 06:17:23 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EC36C0619D9
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 02:30:30 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id z5so4395088edd.3
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 02:30:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pqrs.dk; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KX8QCfye58yms3sdgysq4GNHlgEcGIVnlY8KvEWOgUc=;
        b=TmQyp/VnoK+te/voTjScOuGbQglrQfDVrtZMw/Xq/iCKk5l+vN6VL5MoOIloaF+E6/
         Bc4mvYxjrs95Z39ids8NU3+6lfL9FmjqGgdR+cHbCi6Hve5lds1o/mrHDp4s0jhJ7DpW
         P1iJoMhZNwEajRoKaclM4hjTE0TwrZ/V0fypw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KX8QCfye58yms3sdgysq4GNHlgEcGIVnlY8KvEWOgUc=;
        b=3N/z1aYDMzTym7YpL+y9kufBkqwC79DeWJdb/p16nVbp9H1mf0h5t34V7TW0X5VRcw
         P8cNYwC1XAhGAUATbK4n2qJ9FkOqkhXqkSr4q4AwN7W5kWCJC0HgfcktnYZ/BQggt3RO
         ng0A/sMc1F36oGZulkyFQx65NRcmCvG8tr7OH8orH7U9dRbEJgWyoQJVPXfpp6C5w03L
         Y3qBrPlTwkJd9A8dxq4v6PTEfDpc58nrsVa7PxWiAFC5tzSwq5xbjJwrYCtOgZzrzbyu
         XNq7A5jUIOokE3T1RfBSZu++N8pEEoDYkPQLbSuC5PAPbu8XTsL5kkJZ8HGBo/qHZmYT
         UVXg==
X-Gm-Message-State: AOAM533sTbCgDll0yMkHb5LvvIv1PMUNajdUUgWyC++aUm5JW7V8kvT2
        +uOcs4X6Z9SrPMholPM/nPSD0Iyoy9uo41t0
X-Google-Smtp-Source: ABdhPJweWc6cH4Cjup9tDg8G0C+HLhNmhbjo6nFQEexmblDpfcyectJreQBwn/wAXMxTWzf5GoRQzA==
X-Received: by 2002:a17:906:3e83:: with SMTP id a3mr60063753ejj.383.1638181828823;
        Mon, 29 Nov 2021 02:30:28 -0800 (PST)
Received: from capella.. (80.71.142.18.ipv4.parknet.dk. [80.71.142.18])
        by smtp.gmail.com with ESMTPSA id cy26sm9008402edb.7.2021.11.29.02.30.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 02:30:28 -0800 (PST)
From:   =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alvin@pqrs.dk>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linus.walleij@linaro.org,
        andrew@lunn.ch, f.fainelli@gmail.com, olteanv@gmail.com,
        vivien.didelot@gmail.com, hkallweit1@gmail.com,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>
Subject: [PATCH net v2 3/3] net: dsa: rtl8365mb: set RGMII RX delay in steps of 0.3 ns
Date:   Mon, 29 Nov 2021 11:30:19 +0100
Message-Id: <20211129103019.1997018-3-alvin@pqrs.dk>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211129103019.1997018-1-alvin@pqrs.dk>
References: <20211129103019.1997018-1-alvin@pqrs.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alvin Šipraga <alsi@bang-olufsen.dk>

A contact at Realtek has clarified what exactly the units of RGMII RX
delay are. The answer is that the unit of RX delay is "about 0.3 ns".
Take this into account when parsing rx-internal-delay-ps by
approximating the closest step value. Delays of more than 2.1 ns are
rejected.

This obviously contradicts the previous assumption in the driver that a
step value of 4 was "about 2 ns", but Realtek also points out that it is
easy to find more than one RX delay step value which makes RGMII work.

Fixes: 4af2950c50c8 ("net: dsa: realtek-smi: add rtl8365mb subdriver for RTL8365MB-VC")
Cc: Arınç ÜNAL <arinc.unal@arinc9.com>
Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
Acked-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 drivers/net/dsa/rtl8365mb.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

v2: add Arınç's Acked-by

diff --git a/drivers/net/dsa/rtl8365mb.c b/drivers/net/dsa/rtl8365mb.c
index c52225d115d4..bb65576ebf3c 100644
--- a/drivers/net/dsa/rtl8365mb.c
+++ b/drivers/net/dsa/rtl8365mb.c
@@ -760,7 +760,8 @@ static int rtl8365mb_ext_config_rgmii(struct realtek_smi *smi, int port,
 	 *     0 = no delay, 1 = 2 ns delay
 	 *   RX delay:
 	 *     0 = no delay, 7 = maximum delay
-	 *     No units are specified, but there are a total of 8 steps.
+	 *     Each step is approximately 0.3 ns, so the maximum delay is about
+	 *     2.1 ns.
 	 *
 	 * The vendor driver also states that this must be configured *before*
 	 * forcing the external interface into a particular mode, which is done
@@ -771,10 +772,6 @@ static int rtl8365mb_ext_config_rgmii(struct realtek_smi *smi, int port,
 	 * specified. We ignore the detail of the RGMII interface mode
 	 * (RGMII_{RXID, TXID, etc.}), as this is considered to be a PHY-only
 	 * property.
-	 *
-	 * For the RX delay, we assume that a register value of 4 corresponds to
-	 * 2 ns. But this is just an educated guess, so ignore all other values
-	 * to avoid too much confusion.
 	 */
 	if (!of_property_read_u32(dn, "tx-internal-delay-ps", &val)) {
 		val = val / 1000; /* convert to ns */
@@ -787,13 +784,13 @@ static int rtl8365mb_ext_config_rgmii(struct realtek_smi *smi, int port,
 	}
 
 	if (!of_property_read_u32(dn, "rx-internal-delay-ps", &val)) {
-		val = val / 1000; /* convert to ns */
+		val = DIV_ROUND_CLOSEST(val, 300); /* convert to 0.3 ns step */
 
-		if (val == 0 || val == 2)
-			rx_delay = val * 2;
+		if (val <= 7)
+			rx_delay = val;
 		else
 			dev_warn(smi->dev,
-				 "EXT port RX delay must be 0 to 2 ns\n");
+				 "EXT port RX delay must be 0 to 2.1 ns\n");
 	}
 
 	ret = regmap_update_bits(
-- 
2.34.0

