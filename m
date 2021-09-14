Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C43E40A8E7
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 10:09:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231976AbhINIKs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 04:10:48 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:60066 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230384AbhINIJp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 04:09:45 -0400
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1631606907;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VPFtXk9zgPFdsFoa+TMu+4lql0yJlSvrdlqa2T6Fv+A=;
        b=rtSplDVVH0CTKQqMpgbAvWqYNnVgXqayf734MfeHIWty2B4/RysvD72nKh1Y9Odhfp0xsp
        5G66IA+5Ai9MfDuDRDH3CMHufBTd7OPUaz6fKIt2l7JQfebSManAaRc/W8JY4wLQSatzNG
        OlmqRnFOzvfS3ZpvLYW6SANEiwGNEnmRz8+RMRQv+CqifvIxB2k4JNITK0CgxbpGBOBfMc
        O7lqiAcEwyLMHOCCRyPjYQ0wk/2O6kb/5WWqGXBK9w/Q6ojABRBpONbhxRdMiCutwrBikG
        UAlxO6VPeYCao34K9iEIEzVkl8gUK5ebYBJgQMwrHIuB6PxgkSmaHfanjFmijQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1631606907;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VPFtXk9zgPFdsFoa+TMu+4lql0yJlSvrdlqa2T6Fv+A=;
        b=87SfjU90ZJ7Wv1Z2ho9VEWI+5ci+JnNsyFCisenIsJ3nU3urMes9yOo3eKDJSWI54wftGl
        WLYvOVTdpNMUzIBg==
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        George McCollister <george.mccollister@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>
Subject: Re: [RFC PATCH net 3/5] net: dsa: hellcreek: be compatible with
 masters which unregister on shutdown
In-Reply-To: <20210912120932.993440-4-vladimir.oltean@nxp.com>
References: <20210912120932.993440-1-vladimir.oltean@nxp.com>
 <20210912120932.993440-4-vladimir.oltean@nxp.com>
Date:   Tue, 14 Sep 2021 10:08:26 +0200
Message-ID: <874kan1sw5.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

On Sun Sep 12 2021, Vladimir Oltean wrote:
> Since commit 2f1e8ea726e9 ("net: dsa: link interfaces with the DSA
> master to get rid of lockdep warnings"), DSA gained a requirement which
> it did not fulfill, which is to unlink itself from the DSA master at
> shutdown time.
>
> Since the hellcreek driver was introduced after the bad commit, it has
> never worked with DSA masters which decide to unregister their
> net_device on shutdown, effectively hanging the reboot process.
>
> Hellcreek is a platform device driver, so we probably cannot have the
> oddities of ->shutdown and ->remove getting both called for the exact
> same struct device. But to be in line with the pattern from the other
> device drivers which are on slow buses, implement the same "if this then
> not that" pattern of either running the ->shutdown or the ->remove hook.
> The driver's current ->remove implementation makes that very easy
> because it already zeroes out its device_drvdata on ->remove.
>
> Fixes: e4b27ebc780f ("net: dsa: Add DSA driver for Hirschmann Hellcreek switches")
> Link: https://lore.kernel.org/netdev/20210909095324.12978-1-LinoSanfilippo@gmx.de/
> Reported-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Acked-by: Kurt Kanzenbach <kurt@linutronix.de>

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAmFAWHoTHGt1cnRAbGlu
dXRyb25peC5kZQAKCRB5KluBy5jwpsxRD/9ANtJRKndzoSp2shelf4V/aCarmfLF
GWf7nqLf5GsK0dl7bKUD8EM2OH647C7F1Qan0Ch4EVjw3OKxz7+J84x2QzZQ6u0C
lEGrHDrrkCXp4oCqV8aZoX5wLhXXjoto4LBJK/oobKzdAqPRBu171acXH357bd94
x7YjHTlnohSv6Q8RsjGQ4ba4qPjJ69cEhYKBKydsoTBSUnRzyzzgVtxz9GqpEKXa
lO8uyPzgqfB/ivLKWOJ8/Ugt8xaNBiH0+K1Me516e3Ui+3XBiKFr8uSYpdK2HSKl
sAugTY64Dd1mgYfVZ2FWhphcGU5YpbUmdYNpyny8swWkSjd9oUvW8ZDBva/TBRN8
KQzfrAqrCGGuYeYrNfFVoOkcQdNAWI2CuUhaLr+6tbnVo8KO8f5PhvoQWcIh2IqP
eeR3w/5m4sSYBsZlOG/VbEscT525R9y8oZvNjcVtbWeMf9J3jFZI9hgXcMvQXP93
NR9WihCzM8dHF8tSZTfUttZLXuYmzBBm0jxgvhUfu4gMp9bGUXtWZcS8vYTO7XED
CC7ipYT3aU2/qNyqodWYMfs1cZynJEeZl2QID2QAj5xtnRH527KhwMVQAkZVxDkb
PR7T4Iu4/XPkPztHLS2U59Dxa/uPikXpxdabfPo5ScshHyPDp5gTEiFGMIeIhb+O
GbkqtdvJEuFa2g==
=A1oq
-----END PGP SIGNATURE-----
--=-=-=--
