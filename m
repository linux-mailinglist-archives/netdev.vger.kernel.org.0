Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C19F945EF40
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 14:37:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377550AbhKZNkc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 08:40:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236190AbhKZNib (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 08:38:31 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27C40C061D64
        for <netdev@vger.kernel.org>; Fri, 26 Nov 2021 04:50:31 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id x6so38408563edr.5
        for <netdev@vger.kernel.org>; Fri, 26 Nov 2021 04:50:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pqrs.dk; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dFFmVlCCDpSIEf8sxuu2kx0XFhKoXCPSEl5C6Qt0uzQ=;
        b=UrZuvRQbdHj3soCUT285Ubz4QOvIYDKm5GAVStp9E/BWYuPug1Qbf+NZjLgI9ZdAf3
         RMxh0UwMrxzCCXC9+/UxsrTMNRsy9XoXA9B1RxRw3kil5l3cRzJgKecg8yiRemzDzuT8
         fOPJOnGLjCeK2LLNiLKqRkNUqNdfVAdi9GhHU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dFFmVlCCDpSIEf8sxuu2kx0XFhKoXCPSEl5C6Qt0uzQ=;
        b=sxbmbLIfgYa5a0tAB7+xmto5gJs84QDCUV91OO3HBHnFQmh40D4NrhdJxCs29AkPOO
         IF0bGuf5ixU2OaRM26Hd9ob2oWggj47ygxYGvqNqB2zYwcVhFt20HWA+BQOwNfNWfoYn
         cXvS3/lviR2I3kXyy6+UEg/Ne+YD6FRgx4nllUvLlrmbR95QSu6lq4Jb50zUVtif9wt3
         pynXIjUtRUR4zMYBEkHyM7dMRNuOHd5BUKorD3zfwOPUFwS6Kl/mWXhsOGV9NdRJlZaP
         DF4/Ch1+RMQ7vPmIglvAKGp1ko1dOPnilyfc8dEC7mZqZJ1xUO7aEOjdeLKFxKL7pI+4
         ta5Q==
X-Gm-Message-State: AOAM532TwXUe77RwYUTnDvFhyEmlY26Q2q6REuIYbBJUe9r8DxMjz9aD
        oK0vMVueMOIda6LYu0Fcju4ByA6UGs7kNAF0
X-Google-Smtp-Source: ABdhPJzcZFmUeBNC7+sNCmuETYTubUMt2Syo5FsGxRjro/2tcI0iXf+kzGfTAUB1B/Xo/eR+tPMhJQ==
X-Received: by 2002:a17:906:3157:: with SMTP id e23mr38099837eje.359.1637931029344;
        Fri, 26 Nov 2021 04:50:29 -0800 (PST)
Received: from capella.. (80.71.142.18.ipv4.parknet.dk. [80.71.142.18])
        by smtp.gmail.com with ESMTPSA id b7sm4435378edd.26.2021.11.26.04.50.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Nov 2021 04:50:28 -0800 (PST)
From:   =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alvin@pqrs.dk>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>
Subject: [PATCH net 3/3] net: dsa: rtl8365mb: set RGMII RX delay in steps of 0.3 ns
Date:   Fri, 26 Nov 2021 13:50:07 +0100
Message-Id: <20211126125007.1319946-3-alvin@pqrs.dk>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211126125007.1319946-1-alvin@pqrs.dk>
References: <20211126125007.1319946-1-alvin@pqrs.dk>
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
---
 drivers/net/dsa/rtl8365mb.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

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

