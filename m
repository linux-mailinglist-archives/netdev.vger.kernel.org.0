Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6122A381B58
	for <lists+netdev@lfdr.de>; Sun, 16 May 2021 00:14:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235218AbhEOWP6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 18:15:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:46806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235212AbhEOWPt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 15 May 2021 18:15:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1AA9F6135C;
        Sat, 15 May 2021 22:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621116875;
        bh=Thy3xh0aPPD4aGsyyWrTD32Yur4vUloVpUXX/JJXgWY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fbVEe/DGhS8d5Qv/oEkgSM5JApOmsgtbPRaGoKUnS/1pnw3O6mFa+WLuoJ0fFRYxA
         2pieWtDuy63d0yUaYRhoHgwCbjoq9lQgonVrKAQOFHpMLJoso7ybTxkRNVuo8iifNa
         XEdVUs2f+jqnqsct2GyczVdq4wLi+qUj2kr4vVoE7jLh521nMZ/aE/XlgwJVqrr2Ap
         4elrazHohuE0dDYLmjF64bmdU9LJw8IVZ6VGaEFsf4iTTg1AfuuYen4caOawMZHigm
         /X4jn/TFJbupdMh37NjdUIDbix3WGeRTSxAjwQcgoq09XpEpcrNgVW5RB2MB3wZLtO
         uBAZaGjIU1sEA==
From:   Arnd Bergmann <arnd@kernel.org>
To:     netdev@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "Maciej W. Rozycki" <macro@orcam.me.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sam Creasey <sammy@sammy.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Finn Thain <fthain@telegraphics.com.au>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        linux-kernel@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com
Subject: [RFC 02/13] [net-next] natsemi: sonic: stop calling netdev_boot_setup_check
Date:   Sun, 16 May 2021 00:13:09 +0200
Message-Id: <20210515221320.1255291-3-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210515221320.1255291-1-arnd@kernel.org>
References: <20210515221320.1255291-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The data from the kernel command line is no longer used since the
probe function gets it from the platform device resources instead.

The jazz version was changed to be like this in 2007, the xtensa
version apparently copied the code from there.

Fixes: ed9f0e0bf3ce ("remove setup of platform device from jazzsonic.c")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ethernet/natsemi/jazzsonic.c | 2 --
 drivers/net/ethernet/natsemi/xtsonic.c   | 1 -
 2 files changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/natsemi/jazzsonic.c b/drivers/net/ethernet/natsemi/jazzsonic.c
index ce3eca5d152b..d74a80f010c5 100644
--- a/drivers/net/ethernet/natsemi/jazzsonic.c
+++ b/drivers/net/ethernet/natsemi/jazzsonic.c
@@ -193,8 +193,6 @@ static int jazz_sonic_probe(struct platform_device *pdev)
 	SET_NETDEV_DEV(dev, &pdev->dev);
 	platform_set_drvdata(pdev, dev);
 
-	netdev_boot_setup_check(dev);
-
 	dev->base_addr = res->start;
 	dev->irq = platform_get_irq(pdev, 0);
 	err = sonic_probe1(dev);
diff --git a/drivers/net/ethernet/natsemi/xtsonic.c b/drivers/net/ethernet/natsemi/xtsonic.c
index 28d9e98db81a..ca4686094701 100644
--- a/drivers/net/ethernet/natsemi/xtsonic.c
+++ b/drivers/net/ethernet/natsemi/xtsonic.c
@@ -215,7 +215,6 @@ int xtsonic_probe(struct platform_device *pdev)
 	lp->device = &pdev->dev;
 	platform_set_drvdata(pdev, dev);
 	SET_NETDEV_DEV(dev, &pdev->dev);
-	netdev_boot_setup_check(dev);
 
 	dev->base_addr = resmem->start;
 	dev->irq = resirq->start;
-- 
2.29.2

