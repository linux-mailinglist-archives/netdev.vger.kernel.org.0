Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B05542AD893
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 15:20:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732170AbgKJOUi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 09:20:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730059AbgKJOUi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 09:20:38 -0500
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 327D6C0613CF;
        Tue, 10 Nov 2020 06:20:38 -0800 (PST)
Received: by mail-qk1-x741.google.com with SMTP id h15so11485031qkl.13;
        Tue, 10 Nov 2020 06:20:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=oJx9xQKc52ebOodjQ1LDvOG8BVuJTChcS2sdwxrpBsY=;
        b=f1D9kNtV1Xe5AbRNdk82ZhouiPlBOEaxMlksIuXiflWbZuQ7D0pMnWLRs3SBDGq3vT
         rqEpemlORRYRAB1juT3hZqgamDISa/mtB3qWmWN7O5sQeZdChsZNzuYpD3Mie/hZZ6j7
         DwXPTmo+k6bCsoYwMCs9WYZCkAEFR+mSWPmj7MQB2ABrzfDFp9MnjgAXZzTQgoYasG72
         Z7WWS3jD3SBKl8Z3szg6LPGQHYKEQ9AT7DqbBJidQidA6bAz7A1vtJHGWPv2jyWKcQ21
         CFxZUpCjjMilnoZoQIqKD25cDm1eEiJ9ct/Td3heQrick/OvL6lXsW1BtfQlJQVUTtEm
         OiGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=oJx9xQKc52ebOodjQ1LDvOG8BVuJTChcS2sdwxrpBsY=;
        b=ht/9dDu2jIcySvF2T2gcCwRzIMy8nLasRyPoaXRxhyc9NSqRbnQfwkmipTGdR4tDi1
         9OQH37T/EcizkETFom4eF8cVKxd/dYdu5gV4Hg+BPcZMjMnjHxlCodeed+rz2uunrkqU
         XeLVUWV8jqJRpFmvvl3B+jzSRcsRfayMsmkYSd74JsO2Pt9G/97NnfzSA30ZoB9h36EP
         Ge7Fu+0L5OkXu7/ARF2he9IM2Qkv7VTGoU/RTKEanTFHfC9lxRoGtaR5axlm7RdrT4t2
         eeVVq8HFKia3fbxt+7HIA8LW1o3sgRKXqIHMO5YAwMrBbZjgY/hJL0PlkIbuFCbpXxE5
         WgeQ==
X-Gm-Message-State: AOAM530Zni99hKAGMUdBy1kTGTYTNMxSMRTg811vhPzlpyJGgcbZMTqh
        6UoGrfoeD/wwVwUgBcLORNs=
X-Google-Smtp-Source: ABdhPJzSdQzvYsv4MjhvHeoiKsBktwTCINCy3aruXB7KC2rEvml2fggDY9qbhNun3v/ix/5DrNVcKw==
X-Received: by 2002:a37:4e57:: with SMTP id c84mr19132583qkb.394.1605018037188;
        Tue, 10 Nov 2020 06:20:37 -0800 (PST)
Received: from localhost.localdomain ([198.52.185.246])
        by smtp.gmail.com with ESMTPSA id h6sm6858534qtm.68.2020.11.10.06.20.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2020 06:20:36 -0800 (PST)
From:   Sven Van Asbroeck <thesven73@gmail.com>
X-Google-Original-From: Sven Van Asbroeck <TheSven73@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Sven Van Asbroeck <thesven73@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Frederic LAMBERT <frdrc66@gmail.com>,
        Gabor Juhos <juhosg@openwrt.org>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        linux-spi@vger.kernel.org
Subject: [PATCH net v2] net: phy: spi_ks8995: Do not overwrite SPI mode flags
Date:   Tue, 10 Nov 2020 09:20:32 -0500
Message-Id: <20201110142032.24071-1-TheSven73@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Van Asbroeck <thesven73@gmail.com>

This driver makes sure the underlying SPI bus is set to "mode 0"
by assigning SPI_MODE_0 to spi->mode. Which overwrites all other
SPI mode flags.

In some circumstances, this can break the underlying SPI bus driver.
For example, if SPI_CS_HIGH is set on the SPI bus, the driver
will clear that flag, which results in a chip-select polarity issue.

Fix by changing only the SPI_MODE_N bits, i.e. SPI_CPHA and SPI_CPOL.

Fixes: a8e510f682fe ("phy: Micrel KS8995MA 5-ports 10/100 managed Ethernet switch support added")
Fixes: f3186dd87669 ("spi: Optionally use GPIO descriptors for CS GPIOs")
Link: https://patchwork.kernel.org/project/spi-devel-general/patch/20201106150706.29089-1-TheSven73@gmail.com/#23747737
Signed-off-by: Sven Van Asbroeck <thesven73@gmail.com>
---

Tree: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git # 989ef49bdf10

To be followed by a proposed spi helper function. Submit to net-next after net
gets merged into net-next.

# large number of people, from get_maintainer.pl
To: Andrew Lunn <andrew@lunn.ch>
To: Heiner Kallweit <hkallweit1@gmail.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

Cc: Mark Brown <broonie@kernel.org>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Frederic LAMBERT <frdrc66@gmail.com>
Cc: Gabor Juhos <juhosg@openwrt.org>
Cc: Jonathan Cameron <jonathan.cameron@huawei.com>

# Cc SPI group, suggested by Jakub Kicinski
Cc: linux-spi@vger.kernel.org

 drivers/net/phy/spi_ks8995.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/spi_ks8995.c b/drivers/net/phy/spi_ks8995.c
index 4b198399bfa2..3c6c87a09b03 100644
--- a/drivers/net/phy/spi_ks8995.c
+++ b/drivers/net/phy/spi_ks8995.c
@@ -491,7 +491,9 @@ static int ks8995_probe(struct spi_device *spi)
 
 	spi_set_drvdata(spi, ks);
 
-	spi->mode = SPI_MODE_0;
+	/* use SPI_MODE_0 without changing any other mode flags */
+	spi->mode &= ~(SPI_CPHA | SPI_CPOL);
+	spi->mode |= SPI_MODE_0;
 	spi->bits_per_word = 8;
 	err = spi_setup(spi);
 	if (err) {
-- 
2.17.1

