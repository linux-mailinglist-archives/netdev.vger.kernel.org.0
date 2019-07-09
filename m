Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA10163B7C
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 20:57:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728673AbfGIS4l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 14:56:41 -0400
Received: from mout.kundenserver.de ([212.227.126.135]:49835 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726491AbfGIS4k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 14:56:40 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue012 [212.227.15.129]) with ESMTPA (Nemesis) id
 1MyNoa-1ih2kD1m0a-00yj1f; Tue, 09 Jul 2019 20:56:29 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Pawel Dembicki <paweldembicki@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [net-next] net: dsa: vsc73xx: fix NET_DSA and OF dependencies
Date:   Tue,  9 Jul 2019 20:55:55 +0200
Message-Id: <20190709185626.3275510-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:B23ZNL92t9F/IUnyQGFh8/+hX2SO/gVgPJMR323zJSPmPOxQdzA
 6Xuj/fq/GzYC5z5ff2E7aTX/JaXm2JVV2AADZBFm38pUrBOQ3VWAi8pRj9kUOd/OcArxXYc
 U4K2IqcyxYF1ENBiFTwWvyUwTAPFaOwpeg5JmmQREucjGE8ARGnQ7xM8d94H1w3RMKg1enE
 /Bqrm1Wrp++RAMpq4RRdQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:cPjMJwBK140=:MJaLkyHabLEIhuoC4AdLJx
 S3wPkPOnP1UYfmGk7SXx37JiJCTq5LYimH6GIsXICDndTqnhjjbnUEINmsT/X6k5LVYq1uCGK
 FQQ2jhrem59XqYKc8UZh3KxAJbbBtb4lpW39rTUob1NXWPsJZnspWCpYK6fnhFtGFHohc31XA
 iLbQpQ587nU7iUGV9nbZhFRzf4J5S+tx9sM9oRsaEJN2BLl3YtZkKDCkj7pkLdFPj8Qzl7dAE
 pnoi5XURl2+gqzuNjlBMlDDt2FKYcbkhKSHemXtsAn7z0ich5f85Loyynnq2+nlhWZwkzVS4W
 PalilIND2pWh5ywXrSh/xlSCOot5bSCwIwwdnjDFTVr3c8w4Uzm4zIzOwxuTu+S9fng1DZG9D
 4gePICIKJLtREdfLH4XGqTZN7sVUGjhdEG3sOkHwPIE6yPJcA3kC3iPNmUx9fFpW51iMfsjYJ
 AquRV0ajCteO9PQHhGRD9w9ROz8GM/5kKWaKKew8Ryqa0OTBHH3NuxL+4zhpndeX//zPHibYb
 YKsTVdSFMIm5BrydYyIvmnisSRVnC+O8D9pARssnAE//gopknmwSaUraq3jrWyU0onW0dfOyo
 PUkHRK7OLHCkeBK8uoSvkgfoVdShTCEELr3qwI5Il3s5b+6OdtAtLSj5xw23mcAsyN/rBnixr
 L5w8J5rFpZqYWRzusHXH51r1shK8iJzZHa/1/IyoUGdQXq/BpCugCmxFwzZvzcGxW6jcrPKcR
 u5iIRQRJPlSWxgIL3re2WSVGEja32HOv5sUNcw==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The restructuring of the driver got the dependencies wrong: without
CONFIG_NET_DSA we get this build failure:

WARNING: unmet direct dependencies detected for NET_DSA_VITESSE_VSC73XX
  Depends on [n]: NETDEVICES [=y] && HAVE_NET_DSA [=y] && OF [=y] && NET_DSA [=n]
  Selected by [m]:
  - NET_DSA_VITESSE_VSC73XX_PLATFORM [=m] && NETDEVICES [=y] && HAVE_NET_DSA [=y] && HAS_IOMEM [=y]

ERROR: "dsa_unregister_switch" [drivers/net/dsa/vitesse-vsc73xx-core.ko] undefined!
ERROR: "dsa_switch_alloc" [drivers/net/dsa/vitesse-vsc73xx-core.ko] undefined!
ERROR: "dsa_register_switch" [drivers/net/dsa/vitesse-vsc73xx-core.ko] undefined!

Add the appropriate dependencies.

Fixes: 95711cd5f0b4 ("net: dsa: vsc73xx: Split vsc73xx driver")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/dsa/Kconfig | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/dsa/Kconfig b/drivers/net/dsa/Kconfig
index cf9dbd15dd2d..f6232ce8481f 100644
--- a/drivers/net/dsa/Kconfig
+++ b/drivers/net/dsa/Kconfig
@@ -111,6 +111,8 @@ config NET_DSA_VITESSE_VSC73XX
 
 config NET_DSA_VITESSE_VSC73XX_SPI
 	tristate "Vitesse VSC7385/7388/7395/7398 SPI mode support"
+	depends on OF
+	depends on NET_DSA
 	depends on SPI
 	select NET_DSA_VITESSE_VSC73XX
 	---help---
@@ -119,6 +121,8 @@ config NET_DSA_VITESSE_VSC73XX_SPI
 
 config NET_DSA_VITESSE_VSC73XX_PLATFORM
 	tristate "Vitesse VSC7385/7388/7395/7398 Platform mode support"
+	depends on OF
+	depends on NET_DSA
 	depends on HAS_IOMEM
 	select NET_DSA_VITESSE_VSC73XX
 	---help---
-- 
2.20.0

