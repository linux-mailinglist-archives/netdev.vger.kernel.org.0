Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF1BD3DEC5B
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 13:41:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235894AbhHCLlc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 07:41:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:33000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235823AbhHCLl0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 07:41:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AFEDB60EE7;
        Tue,  3 Aug 2021 11:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627990875;
        bh=Thy3xh0aPPD4aGsyyWrTD32Yur4vUloVpUXX/JJXgWY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R767e3tfwtgVNR/UpjhGi7A8Q/+DCMDwU7yDhAw0Ot+vBvoTkj6kWlbc4f4C+dh9f
         Q87859jnN+oOAv2K6GSEkkrJl23k3hOD4eV9vMbHRRE7fgklOhRR1EGgbfDJ8jev7W
         ixbq9HIAZgSQGgudq1P5dmfOF2j+EhAFIeY268bulut5jLn6eZUWg3kt74tbBSQFSA
         1icpaPmu3wdWPuFXiSnzj40CWSUuOSfIQu8OfzY2S5ScZq05EsE07qk5NBwH8e6eH9
         NglrHoUVTWesrrtFVnbco/8T5zFNMEyGXDxHqR+PqKSPQchVFN4V5VKR0mnvuLne3t
         tpqSB9cv5LmPg==
From:   Arnd Bergmann <arnd@kernel.org>
To:     netdev@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        "Maciej W. Rozycki" <macro@orcam.me.uk>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>, Andrii Nakryiko <andriin@fb.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Doug Berger <opendmb@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Finn Thain <fthain@telegraphics.com.au>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Jakub Kicinski <kuba@kernel.org>, Jessica Yu <jeyu@kernel.org>,
        Michael Schmitz <schmitzmic@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Sam Creasey <sammy@sammy.net>, linux-kernel@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com
Subject: [PATCH v2 02/14] [net-next] natsemi: sonic: stop calling netdev_boot_setup_check
Date:   Tue,  3 Aug 2021 13:40:39 +0200
Message-Id: <20210803114051.2112986-3-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210803114051.2112986-1-arnd@kernel.org>
References: <20210803114051.2112986-1-arnd@kernel.org>
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

