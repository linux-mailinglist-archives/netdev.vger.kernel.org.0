Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 029CA2AC501
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 20:31:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730793AbgKITbW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 14:31:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726691AbgKITbW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 14:31:22 -0500
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F588C0613CF;
        Mon,  9 Nov 2020 11:31:22 -0800 (PST)
Received: by mail-qt1-x842.google.com with SMTP id t5so6862306qtp.2;
        Mon, 09 Nov 2020 11:31:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=wP9KXoUMsiUhA5JKW0pkbm1QMKgjwIQX0z6JW9kJa6s=;
        b=Zho3QB6MQnSmLfAsGEY74Ebt3PidB9Zz/Oo6q5S0iHVO/2XCci5p0MTGmpNJjcFF+a
         jZbVSGOhnESX7VObw1jujOz340ZnROHw/SXJhDzeUeKKQG7MLcTd+QcCpDi+1Ta2QR93
         m2pwuKQ7nDG+yT+Ng+1uEqtHqYYYfhwlGKP7HJy3BeBhQoDUnb0VR2I26Ace7NmsPAye
         mx788G9pRFcZFrc7ZzS9mCSNuuW0DL2m4txNZZWR0/vaj+AFKQw7k6/zCl2jCHKuH/kk
         xwiF5XLL8/HCtZhcGpT4lzwDoqVJtIhmDYj7foY+pJHSulkQx9mmq5853wRS95gP2dZr
         +xLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=wP9KXoUMsiUhA5JKW0pkbm1QMKgjwIQX0z6JW9kJa6s=;
        b=jJiDW2IcSYTcS4rMfQrw5ahTyRT2PeMfOqIRW1IMI9N+iwMk5q3Fe3mbzrKvG23h1O
         8YQyPP2tvYGHyNcv2paxrEuJ8CDkHWgOO+35oW9iJZXbmZvxAvEy5HikYhZv48OelvBb
         NIjPudYchi24PDH+Ga7oZNN5lRch78FNSCpDmmuQ3h61qf85ft9zifQ7sQoGie48bWm6
         dlzPNxZ57sNqi5NonhkAX7zHr/+WhmNO2kFdmji7ASYcZseKhP1o9iaA1qCvugYFYYUs
         RpOO8mb7PYVoOCLoDf9+4UDHquTobBFcwXIoMNibwU6236sGZirGrEdhK3Jjjg5MiVQu
         beVA==
X-Gm-Message-State: AOAM5336t9g7Iej9I4tOJLXIi76LcLFvUG0sinImCNQWB0hPOVzDavcW
        haWttlik2UtDM3cP/letzU4=
X-Google-Smtp-Source: ABdhPJw6UtAn+o1nNr0oOLN9c0kEcMPx8IxBgAj4Mdys5B2HF6Dugu9LtC8cN/uBrs7Izt0QDYY4lA==
X-Received: by 2002:ac8:46cf:: with SMTP id h15mr13644007qto.99.1604950281415;
        Mon, 09 Nov 2020 11:31:21 -0800 (PST)
Received: from svens-asus.arcx.com ([184.94.50.30])
        by smtp.gmail.com with ESMTPSA id o14sm6585172qto.16.2020.11.09.11.31.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2020 11:31:20 -0800 (PST)
From:   Sven Van Asbroeck <thesven73@gmail.com>
X-Google-Original-From: Sven Van Asbroeck <TheSven73@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Sven Van Asbroeck <thesven73@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v1] net: phy: spi_ks8995: Do not overwrite SPI mode flags
Date:   Mon,  9 Nov 2020 14:31:17 -0500
Message-Id: <20201109193117.2017-1-TheSven73@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Van Asbroeck <thesven73@gmail.com>

This driver makes sure the underlying SPI bus is set to "mode 0"
by assigning SPI_MODE_0 to spi->mode. This overwrites all other
SPI mode flags.

In some circumstances, this can break the underlying SPI bus driver.
For example, if SPI_CS_HIGH is set on the SPI bus, the driver
will clear that flag, which results in a chip-select polarity issue.

Fix by changing only the SPI_MODE_N bits, i.e. SPI_CPHA and SPI_CPOL.

Signed-off-by: Sven Van Asbroeck <thesven73@gmail.com>
---

Tree: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git # bff6f1db91e3

To: Andrew Lunn <andrew@lunn.ch>
To: Heiner Kallweit <hkallweit1@gmail.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

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

