Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6541155CC0C
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:00:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238911AbiF1CDl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 22:03:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243260AbiF1CDd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 22:03:33 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EBA310FEC
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 19:03:17 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-2eb7d137101so92059587b3.12
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 19:03:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=TbUo6qLtXESTFAjobbepx6w7vljxcWK6r0xPksVpHL4=;
        b=tZazYfWqPcug8WNmRossg5oipKgo77iefyCMqnHhTitZ/Sv8YfR95twQm9aK30hdZW
         ua9MdW9VXN0O7tqZRMVlzt5QxiVEotkdX7MtUDdH531h1+43Uf9zHo6TCcYKUvXIHvxJ
         JV2Z8TKtz5IO721EFl27cWPTiWUIsFliEeAdguF6sS7KVsTqHrpdwac+5KfBq1IdCx9z
         rH9CezikHE/fjlfixLHE+xpZd5e7Ey01hNXJ81kPa73u7ek499zLwXaH8hrPh8WsICqy
         bhTTtOC/97yK5CNxSjUi5BQ9tPqkV3122ilIkvGGkWHDMm85vLq1kEkzU4Xu1SwXW5M2
         OkWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=TbUo6qLtXESTFAjobbepx6w7vljxcWK6r0xPksVpHL4=;
        b=PXY17sklgs6hfjNhwQTtLRZT+uTIgMMxt2F/amgYpsL047utlfaWOxHZLoeyv8+hKf
         RE9JTGawtBcqrgqiorTdDYq2wZxI25lcE27bOSE+Zs25vBZtWRn2XZS7pR3qVL4aTIEV
         bAi3+h0ho9XvguhcIwSYT6YjoG23xMnevoe5+juMQI7m15akFyHdSdPDOfmBM/Gymcwx
         eZM7D+Y75ikyByAWKdyU5At6NycEc4ow6t+A6AuG7/YMdGoayn4zc4yAw29SpDH1eEw6
         FOZ9seLdqgfRX6YQsdFQt+OIyRTT/4Q1DCDy37EXFYhJ1xoD0kHciANHqHiFl6qxBUaz
         HMLQ==
X-Gm-Message-State: AJIora9Qd+1ckib6izZTJQ51n2141Y9UXTh1F3SAgvRklVJDEGUWX2vr
        3Sde61XZzb/mw4RNdU/4JZe270Hr0Tc81sg=
X-Google-Smtp-Source: AGRyM1vAtXn/7Fp/6H2tWm79D2E/cuS07Z4vvtV7VYTHWvXhiS3plNYDiH6yd2eO+KsjPlD1xvpzSqGrQp700Gs=
X-Received: from saravanak.san.corp.google.com ([2620:15c:2d:3:1f27:a302:2101:1c82])
 (user=saravanak job=sendgmr) by 2002:a25:da0b:0:b0:66c:850f:1b71 with SMTP id
 n11-20020a25da0b000000b0066c850f1b71mr17529281ybf.336.1656381796780; Mon, 27
 Jun 2022 19:03:16 -0700 (PDT)
Date:   Mon, 27 Jun 2022 19:01:03 -0700
In-Reply-To: <20220628020110.1601693-1-saravanak@google.com>
Message-Id: <20220628020110.1601693-3-saravanak@google.com>
Mime-Version: 1.0
References: <20220628020110.1601693-1-saravanak@google.com>
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
Subject: [PATCH v1 2/2] serial: Set probe_no_timeout for all DT based drivers
From:   Saravana Kannan <saravanak@google.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Joel Stanley <joel@jms.id.au>,
        Andrew Jeffery <andrew@aj.id.au>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Nicolas Saenz Julienne <nsaenz@kernel.org>,
        Al Cooper <alcooperx@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Paul Cercueil <paul@crapouillou.net>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Tobias Klauser <tklauser@distanz.ch>,
        Russell King <linux@armlinux.org.uk>,
        Vineet Gupta <vgupta@kernel.org>,
        Richard Genoud <richard.genoud@gmail.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Alexander Shiyan <shc_work@mail.ru>,
        Baruch Siach <baruch@tkos.co.il>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Karol Gugala <kgugala@antmicro.com>,
        Mateusz Holenko <mholenko@antmicro.com>,
        Gabriel Somlo <gsomlo@gmail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Taichi Sugaya <sugaya.taichi@socionext.com>,
        Takao Orito <orito.takao@socionext.com>,
        Liviu Dudau <liviu.dudau@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Lorenzo Pieralisi <lpieralisi@kernel.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Pali Rohar <pali@kernel.org>,
        Andreas Farber <afaerber@suse.de>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Orson Zhai <orsonzhai@gmail.com>,
        Baolin Wang <baolin.wang7@gmail.com>,
        Chunyan Zhang <zhang.lyra@gmail.com>,
        Patrice Chotard <patrice.chotard@foss.st.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hammer Hsieh <hammerh0314@gmail.com>,
        Peter Korsgaard <jacmet@sunsite.dk>,
        Timur Tabi <timur@kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Saravana Kannan <saravanak@google.com>
Cc:     Rob Herring <robh@kernel.org>, sascha hauer <sha@pengutronix.de>,
        peng fan <peng.fan@nxp.com>, kevin hilman <khilman@kernel.org>,
        ulf hansson <ulf.hansson@linaro.org>,
        len brown <len.brown@intel.com>, pavel machek <pavel@ucw.cz>,
        joerg roedel <joro@8bytes.org>, will deacon <will@kernel.org>,
        andrew lunn <andrew@lunn.ch>,
        heiner kallweit <hkallweit1@gmail.com>,
        eric dumazet <edumazet@google.com>,
        jakub kicinski <kuba@kernel.org>,
        paolo abeni <pabeni@redhat.com>,
        linus walleij <linus.walleij@linaro.org>,
        hideaki yoshifuji <yoshfuji@linux-ipv6.org>,
        david ahern <dsahern@kernel.org>, kernel-team@android.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        iommu@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-gpio@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-serial@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-aspeed@lists.ozlabs.org,
        linux-rpi-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
        linux-mediatek@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-snps-arc@lists.infradead.org,
        linux-amlogic@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-actions@lists.infradead.org,
        linux-unisoc@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-riscv@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        sparclinux@vger.kernel.org, Ahmad Fatoum <a.fatoum@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With commit 71066545b48e ("driver core: Set fw_devlink.strict=1 by
default") the probing of TTY consoles could get delayed if they have
optional suppliers that are listed in DT, but those suppliers don't
probe by the time kernel boot finishes. The console devices will probe
eventually after driver_probe_timeout expires.

However, since consoles are often used for debugging kernel issues, it
does not make sense to delay their probe. So, set the newly added
probe_no_timeout flag for all serial drivers that at DT based. This way,
fw_devlink will know not to delay the probing of the consoles past
kernel boot.

Fixes: 71066545b48e ("driver core: Set fw_devlink.strict=1 by default")
Reported-by: Sascha Hauer <sha@pengutronix.de>
Reported-by: Peng Fan <peng.fan@nxp.com>
Reported-by: Fabio Estevam <festevam@gmail.com>
Reported-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
Signed-off-by: Saravana Kannan <saravanak@google.com>
---
 drivers/tty/ehv_bytechan.c                  | 1 +
 drivers/tty/goldfish.c                      | 1 +
 drivers/tty/hvc/hvc_opal.c                  | 1 +
 drivers/tty/serial/8250/8250_acorn.c        | 1 -
 drivers/tty/serial/8250/8250_aspeed_vuart.c | 1 +
 drivers/tty/serial/8250/8250_bcm2835aux.c   | 1 +
 drivers/tty/serial/8250/8250_bcm7271.c      | 1 +
 drivers/tty/serial/8250/8250_dw.c           | 1 +
 drivers/tty/serial/8250/8250_em.c           | 1 +
 drivers/tty/serial/8250/8250_ingenic.c      | 1 +
 drivers/tty/serial/8250/8250_lpc18xx.c      | 1 +
 drivers/tty/serial/8250/8250_mtk.c          | 1 +
 drivers/tty/serial/8250/8250_of.c           | 1 +
 drivers/tty/serial/8250/8250_omap.c         | 1 +
 drivers/tty/serial/8250/8250_pxa.c          | 1 +
 drivers/tty/serial/8250/8250_tegra.c        | 1 +
 drivers/tty/serial/8250/8250_uniphier.c     | 1 +
 drivers/tty/serial/altera_jtaguart.c        | 1 +
 drivers/tty/serial/altera_uart.c            | 1 +
 drivers/tty/serial/amba-pl011.c             | 1 +
 drivers/tty/serial/apbuart.c                | 1 +
 drivers/tty/serial/ar933x_uart.c            | 1 +
 drivers/tty/serial/arc_uart.c               | 1 +
 drivers/tty/serial/atmel_serial.c           | 1 +
 drivers/tty/serial/bcm63xx_uart.c           | 1 +
 drivers/tty/serial/clps711x.c               | 1 +
 drivers/tty/serial/cpm_uart/cpm_uart_core.c | 1 +
 drivers/tty/serial/digicolor-usart.c        | 1 +
 drivers/tty/serial/fsl_linflexuart.c        | 1 +
 drivers/tty/serial/fsl_lpuart.c             | 1 +
 drivers/tty/serial/imx.c                    | 1 +
 drivers/tty/serial/lantiq.c                 | 1 +
 drivers/tty/serial/liteuart.c               | 1 +
 drivers/tty/serial/lpc32xx_hs.c             | 1 +
 drivers/tty/serial/max310x.c                | 1 +
 drivers/tty/serial/meson_uart.c             | 1 +
 drivers/tty/serial/milbeaut_usio.c          | 1 +
 drivers/tty/serial/mpc52xx_uart.c           | 1 +
 drivers/tty/serial/mps2-uart.c              | 1 +
 drivers/tty/serial/msm_serial.c             | 1 +
 drivers/tty/serial/mvebu-uart.c             | 1 +
 drivers/tty/serial/mxs-auart.c              | 1 +
 drivers/tty/serial/omap-serial.c            | 1 +
 drivers/tty/serial/owl-uart.c               | 1 +
 drivers/tty/serial/pic32_uart.c             | 1 +
 drivers/tty/serial/pmac_zilog.c             | 1 +
 drivers/tty/serial/pxa.c                    | 1 +
 drivers/tty/serial/qcom_geni_serial.c       | 1 +
 drivers/tty/serial/rda-uart.c               | 1 +
 drivers/tty/serial/samsung_tty.c            | 1 +
 drivers/tty/serial/sc16is7xx.c              | 1 +
 drivers/tty/serial/serial-tegra.c           | 1 +
 drivers/tty/serial/sh-sci.c                 | 1 +
 drivers/tty/serial/sifive.c                 | 1 +
 drivers/tty/serial/sprd_serial.c            | 1 +
 drivers/tty/serial/st-asc.c                 | 1 +
 drivers/tty/serial/stm32-usart.c            | 1 +
 drivers/tty/serial/sunhv.c                  | 1 +
 drivers/tty/serial/sunplus-uart.c           | 1 +
 drivers/tty/serial/sunsab.c                 | 1 +
 drivers/tty/serial/sunsu.c                  | 1 +
 drivers/tty/serial/sunzilog.c               | 1 +
 drivers/tty/serial/tegra-tcu.c              | 1 +
 drivers/tty/serial/uartlite.c               | 1 +
 drivers/tty/serial/ucc_uart.c               | 1 +
 drivers/tty/serial/vt8500_serial.c          | 1 +
 drivers/tty/serial/xilinx_uartps.c          | 1 +
 67 files changed, 66 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/ehv_bytechan.c b/drivers/tty/ehv_bytechan.c
index 19d32cb6af84..6de710da99be 100644
--- a/drivers/tty/ehv_bytechan.c
+++ b/drivers/tty/ehv_bytechan.c
@@ -739,6 +739,7 @@ static struct platform_driver ehv_bc_tty_driver = {
 	.driver = {
 		.name = "ehv-bc",
 		.of_match_table = ehv_bc_tty_of_ids,
+		.probe_no_timeout = true,
 		.suppress_bind_attrs = true,
 	},
 	.probe		= ehv_bc_tty_probe,
diff --git a/drivers/tty/goldfish.c b/drivers/tty/goldfish.c
index c7968aecd870..f9760598c836 100644
--- a/drivers/tty/goldfish.c
+++ b/drivers/tty/goldfish.c
@@ -474,6 +474,7 @@ static struct platform_driver goldfish_tty_platform_driver = {
 	.driver = {
 		.name = "goldfish_tty",
 		.of_match_table = goldfish_tty_of_match,
+		.probe_no_timeout = true,
 	}
 };
 
diff --git a/drivers/tty/hvc/hvc_opal.c b/drivers/tty/hvc/hvc_opal.c
index 794c7b18aa06..08202c2f8ead 100644
--- a/drivers/tty/hvc/hvc_opal.c
+++ b/drivers/tty/hvc/hvc_opal.c
@@ -253,6 +253,7 @@ static struct platform_driver hvc_opal_driver = {
 	.driver		= {
 		.name	= hvc_opal_name,
 		.of_match_table	= hvc_opal_match,
+		.probe_no_timeout = true,
 	}
 };
 
diff --git a/drivers/tty/serial/8250/8250_acorn.c b/drivers/tty/serial/8250/8250_acorn.c
index 758c4aa203ab..5a6f2f67de4f 100644
--- a/drivers/tty/serial/8250/8250_acorn.c
+++ b/drivers/tty/serial/8250/8250_acorn.c
@@ -114,7 +114,6 @@ static const struct ecard_id serial_cids[] = {
 static struct ecard_driver serial_card_driver = {
 	.probe		= serial_card_probe,
 	.remove		= serial_card_remove,
-	.id_table	= serial_cids,
 	.drv = {
 		.name	= "8250_acorn",
 	},
diff --git a/drivers/tty/serial/8250/8250_aspeed_vuart.c b/drivers/tty/serial/8250/8250_aspeed_vuart.c
index 9d2a7856784f..ca4b89ae13a4 100644
--- a/drivers/tty/serial/8250/8250_aspeed_vuart.c
+++ b/drivers/tty/serial/8250/8250_aspeed_vuart.c
@@ -592,6 +592,7 @@ static struct platform_driver aspeed_vuart_driver = {
 	.driver = {
 		.name = "aspeed-vuart",
 		.of_match_table = aspeed_vuart_table,
+		.probe_no_timeout = true,
 	},
 	.probe = aspeed_vuart_probe,
 	.remove = aspeed_vuart_remove,
diff --git a/drivers/tty/serial/8250/8250_bcm2835aux.c b/drivers/tty/serial/8250/8250_bcm2835aux.c
index 2a1226a78a0c..6c00ba7a123a 100644
--- a/drivers/tty/serial/8250/8250_bcm2835aux.c
+++ b/drivers/tty/serial/8250/8250_bcm2835aux.c
@@ -223,6 +223,7 @@ static struct platform_driver bcm2835aux_serial_driver = {
 		.name = "bcm2835-aux-uart",
 		.of_match_table = bcm2835aux_serial_match,
 		.acpi_match_table = bcm2835aux_serial_acpi_match,
+		.probe_no_timeout = true,
 	},
 	.probe  = bcm2835aux_serial_probe,
 	.remove = bcm2835aux_serial_remove,
diff --git a/drivers/tty/serial/8250/8250_bcm7271.c b/drivers/tty/serial/8250/8250_bcm7271.c
index 9b878d023dac..7898dcbff07e 100644
--- a/drivers/tty/serial/8250/8250_bcm7271.c
+++ b/drivers/tty/serial/8250/8250_bcm7271.c
@@ -1193,6 +1193,7 @@ static struct platform_driver brcmuart_platform_driver = {
 		.name	= "bcm7271-uart",
 		.pm		= &brcmuart_dev_pm_ops,
 		.of_match_table = brcmuart_dt_ids,
+		.probe_no_timeout = true,
 	},
 	.probe		= brcmuart_probe,
 	.remove		= brcmuart_remove,
diff --git a/drivers/tty/serial/8250/8250_dw.c b/drivers/tty/serial/8250/8250_dw.c
index f57bbd32ef11..616f5197378a 100644
--- a/drivers/tty/serial/8250/8250_dw.c
+++ b/drivers/tty/serial/8250/8250_dw.c
@@ -795,6 +795,7 @@ static struct platform_driver dw8250_platform_driver = {
 		.pm		= &dw8250_pm_ops,
 		.of_match_table	= dw8250_of_match,
 		.acpi_match_table = dw8250_acpi_match,
+		.probe_no_timeout = true,
 	},
 	.probe			= dw8250_probe,
 	.remove			= dw8250_remove,
diff --git a/drivers/tty/serial/8250/8250_em.c b/drivers/tty/serial/8250/8250_em.c
index f8e99995eee9..0dc9a2e45cf2 100644
--- a/drivers/tty/serial/8250/8250_em.c
+++ b/drivers/tty/serial/8250/8250_em.c
@@ -151,6 +151,7 @@ static struct platform_driver serial8250_em_platform_driver = {
 	.driver = {
 		.name		= "serial8250-em",
 		.of_match_table = serial8250_em_dt_ids,
+		.probe_no_timeout = true,
 	},
 	.probe			= serial8250_em_probe,
 	.remove			= serial8250_em_remove,
diff --git a/drivers/tty/serial/8250/8250_ingenic.c b/drivers/tty/serial/8250/8250_ingenic.c
index cff91aa03f29..dc595a4a49a0 100644
--- a/drivers/tty/serial/8250/8250_ingenic.c
+++ b/drivers/tty/serial/8250/8250_ingenic.c
@@ -341,6 +341,7 @@ static struct platform_driver ingenic_uart_platform_driver = {
 	.driver = {
 		.name		= "ingenic-uart",
 		.of_match_table	= of_match,
+		.probe_no_timeout = true,
 	},
 	.probe			= ingenic_uart_probe,
 	.remove			= ingenic_uart_remove,
diff --git a/drivers/tty/serial/8250/8250_lpc18xx.c b/drivers/tty/serial/8250/8250_lpc18xx.c
index 570e25d6f37e..d9c91c57331c 100644
--- a/drivers/tty/serial/8250/8250_lpc18xx.c
+++ b/drivers/tty/serial/8250/8250_lpc18xx.c
@@ -215,6 +215,7 @@ static struct platform_driver lpc18xx_serial_driver = {
 	.driver = {
 		.name = "lpc18xx-uart",
 		.of_match_table = lpc18xx_serial_match,
+		.probe_no_timeout = true,
 	},
 };
 module_platform_driver(lpc18xx_serial_driver);
diff --git a/drivers/tty/serial/8250/8250_mtk.c b/drivers/tty/serial/8250/8250_mtk.c
index 54051ec7b499..85e8a19c0929 100644
--- a/drivers/tty/serial/8250/8250_mtk.c
+++ b/drivers/tty/serial/8250/8250_mtk.c
@@ -671,6 +671,7 @@ static struct platform_driver mtk8250_platform_driver = {
 		.name		= "mt6577-uart",
 		.pm		= &mtk8250_pm_ops,
 		.of_match_table	= mtk8250_of_match,
+		.probe_no_timeout = true,
 	},
 	.probe			= mtk8250_probe,
 	.remove			= mtk8250_remove,
diff --git a/drivers/tty/serial/8250/8250_of.c b/drivers/tty/serial/8250/8250_of.c
index 5a699a1aa79c..580abd22d3c6 100644
--- a/drivers/tty/serial/8250/8250_of.c
+++ b/drivers/tty/serial/8250/8250_of.c
@@ -343,6 +343,7 @@ static struct platform_driver of_platform_serial_driver = {
 	.driver = {
 		.name = "of_serial",
 		.of_match_table = of_platform_serial_table,
+		.probe_no_timeout = true,
 		.pm = &of_serial_pm_ops,
 	},
 	.probe = of_platform_serial_probe,
diff --git a/drivers/tty/serial/8250/8250_omap.c b/drivers/tty/serial/8250/8250_omap.c
index ac8bfa042391..8d83597174b4 100644
--- a/drivers/tty/serial/8250/8250_omap.c
+++ b/drivers/tty/serial/8250/8250_omap.c
@@ -1694,6 +1694,7 @@ static struct platform_driver omap8250_platform_driver = {
 		.name		= "omap8250",
 		.pm		= &omap8250_dev_pm_ops,
 		.of_match_table = omap8250_dt_ids,
+		.probe_no_timeout = true,
 	},
 	.probe			= omap8250_probe,
 	.remove			= omap8250_remove,
diff --git a/drivers/tty/serial/8250/8250_pxa.c b/drivers/tty/serial/8250/8250_pxa.c
index 795e55142d4c..9f7bb52fabbe 100644
--- a/drivers/tty/serial/8250/8250_pxa.c
+++ b/drivers/tty/serial/8250/8250_pxa.c
@@ -165,6 +165,7 @@ static struct platform_driver serial_pxa_driver = {
 		.name	= "pxa2xx-uart",
 		.pm	= &serial_pxa_pm_ops,
 		.of_match_table = serial_pxa_dt_ids,
+		.probe_no_timeout = true,
 	},
 };
 
diff --git a/drivers/tty/serial/8250/8250_tegra.c b/drivers/tty/serial/8250/8250_tegra.c
index e7cddeec9d8e..45630f7d9e98 100644
--- a/drivers/tty/serial/8250/8250_tegra.c
+++ b/drivers/tty/serial/8250/8250_tegra.c
@@ -187,6 +187,7 @@ static struct platform_driver tegra_uart_driver = {
 		.pm = &tegra_uart_pm_ops,
 		.of_match_table = tegra_uart_of_match,
 		.acpi_match_table = ACPI_PTR(tegra_uart_acpi_match),
+		.probe_no_timeout = true,
 	},
 	.probe = tegra_uart_probe,
 	.remove = tegra_uart_remove,
diff --git a/drivers/tty/serial/8250/8250_uniphier.c b/drivers/tty/serial/8250/8250_uniphier.c
index a2978abab0db..7fdf45c4513d 100644
--- a/drivers/tty/serial/8250/8250_uniphier.c
+++ b/drivers/tty/serial/8250/8250_uniphier.c
@@ -297,6 +297,7 @@ static struct platform_driver uniphier_uart_platform_driver = {
 	.driver = {
 		.name	= "uniphier-uart",
 		.of_match_table = uniphier_uart_match,
+		.probe_no_timeout = true,
 		.pm = &uniphier_uart_pm_ops,
 	},
 };
diff --git a/drivers/tty/serial/altera_jtaguart.c b/drivers/tty/serial/altera_jtaguart.c
index cb791c5149a3..548934284691 100644
--- a/drivers/tty/serial/altera_jtaguart.c
+++ b/drivers/tty/serial/altera_jtaguart.c
@@ -493,6 +493,7 @@ static struct platform_driver altera_jtaguart_platform_driver = {
 	.driver	= {
 		.name		= DRV_NAME,
 		.of_match_table	= of_match_ptr(altera_jtaguart_match),
+		.probe_no_timeout = true,
 	},
 };
 
diff --git a/drivers/tty/serial/altera_uart.c b/drivers/tty/serial/altera_uart.c
index 8b749ed557c6..25c834f900eb 100644
--- a/drivers/tty/serial/altera_uart.c
+++ b/drivers/tty/serial/altera_uart.c
@@ -645,6 +645,7 @@ static struct platform_driver altera_uart_platform_driver = {
 	.driver	= {
 		.name		= DRV_NAME,
 		.of_match_table	= of_match_ptr(altera_uart_match),
+		.probe_no_timeout = true,
 	},
 };
 
diff --git a/drivers/tty/serial/amba-pl011.c b/drivers/tty/serial/amba-pl011.c
index 97ef41cb2721..eae866568f14 100644
--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -2912,6 +2912,7 @@ static struct platform_driver arm_sbsa_uart_platform_driver = {
 		.pm	= &pl011_dev_pm_ops,
 		.of_match_table = of_match_ptr(sbsa_uart_of_match),
 		.acpi_match_table = ACPI_PTR(sbsa_uart_acpi_match),
+		.probe_no_timeout = true,
 		.suppress_bind_attrs = IS_BUILTIN(CONFIG_SERIAL_AMBA_PL011),
 	},
 };
diff --git a/drivers/tty/serial/apbuart.c b/drivers/tty/serial/apbuart.c
index 9ef82d870ff2..72c1b7884a3b 100644
--- a/drivers/tty/serial/apbuart.c
+++ b/drivers/tty/serial/apbuart.c
@@ -583,6 +583,7 @@ static struct platform_driver grlib_apbuart_of_driver = {
 	.driver = {
 		.name = "grlib-apbuart",
 		.of_match_table = apbuart_match,
+		.probe_no_timeout = true,
 	},
 };
 
diff --git a/drivers/tty/serial/ar933x_uart.c b/drivers/tty/serial/ar933x_uart.c
index 6269dbf93546..f0013be1a7c7 100644
--- a/drivers/tty/serial/ar933x_uart.c
+++ b/drivers/tty/serial/ar933x_uart.c
@@ -842,6 +842,7 @@ static struct platform_driver ar933x_uart_platform_driver = {
 	.driver		= {
 		.name		= DRIVER_NAME,
 		.of_match_table = of_match_ptr(ar933x_uart_of_ids),
+		.probe_no_timeout = true,
 	},
 };
 
diff --git a/drivers/tty/serial/arc_uart.c b/drivers/tty/serial/arc_uart.c
index 2a09e92ef9ed..7998c285fc6c 100644
--- a/drivers/tty/serial/arc_uart.c
+++ b/drivers/tty/serial/arc_uart.c
@@ -650,6 +650,7 @@ static struct platform_driver arc_platform_driver = {
 	.driver = {
 		.name = DRIVER_NAME,
 		.of_match_table  = arc_uart_dt_ids,
+		.probe_no_timeout = true,
 	 },
 };
 
diff --git a/drivers/tty/serial/atmel_serial.c b/drivers/tty/serial/atmel_serial.c
index dd1c7e4bd1c9..ff74ea97b305 100644
--- a/drivers/tty/serial/atmel_serial.c
+++ b/drivers/tty/serial/atmel_serial.c
@@ -3020,6 +3020,7 @@ static struct platform_driver atmel_serial_driver = {
 	.driver		= {
 		.name			= "atmel_usart_serial",
 		.of_match_table		= of_match_ptr(atmel_serial_dt_ids),
+		.probe_no_timeout = true,
 	},
 };
 
diff --git a/drivers/tty/serial/bcm63xx_uart.c b/drivers/tty/serial/bcm63xx_uart.c
index 53b43174aa40..d91c49c50ac6 100644
--- a/drivers/tty/serial/bcm63xx_uart.c
+++ b/drivers/tty/serial/bcm63xx_uart.c
@@ -890,6 +890,7 @@ static struct platform_driver bcm_uart_platform_driver = {
 	.driver	= {
 		.name  = "bcm63xx_uart",
 		.of_match_table = bcm63xx_of_match,
+		.probe_no_timeout = true,
 	},
 };
 
diff --git a/drivers/tty/serial/clps711x.c b/drivers/tty/serial/clps711x.c
index b9b66ad31a08..b81710802937 100644
--- a/drivers/tty/serial/clps711x.c
+++ b/drivers/tty/serial/clps711x.c
@@ -528,6 +528,7 @@ static struct platform_driver clps711x_uart_platform = {
 	.driver = {
 		.name		= "clps711x-uart",
 		.of_match_table	= of_match_ptr(clps711x_uart_dt_ids),
+		.probe_no_timeout = true,
 	},
 	.probe	= uart_clps711x_probe,
 	.remove	= uart_clps711x_remove,
diff --git a/drivers/tty/serial/cpm_uart/cpm_uart_core.c b/drivers/tty/serial/cpm_uart/cpm_uart_core.c
index db07d6a5d764..ff269637bc28 100644
--- a/drivers/tty/serial/cpm_uart/cpm_uart_core.c
+++ b/drivers/tty/serial/cpm_uart/cpm_uart_core.c
@@ -1470,6 +1470,7 @@ static struct platform_driver cpm_uart_driver = {
 	.driver = {
 		.name = "cpm_uart",
 		.of_match_table = cpm_uart_match,
+		.probe_no_timeout = true,
 	},
 	.probe = cpm_uart_probe,
 	.remove = cpm_uart_remove,
diff --git a/drivers/tty/serial/digicolor-usart.c b/drivers/tty/serial/digicolor-usart.c
index af951e6a2ef4..b2148b48d195 100644
--- a/drivers/tty/serial/digicolor-usart.c
+++ b/drivers/tty/serial/digicolor-usart.c
@@ -524,6 +524,7 @@ static struct platform_driver digicolor_uart_platform = {
 	.driver = {
 		.name		= "digicolor-usart",
 		.of_match_table	= of_match_ptr(digicolor_uart_dt_ids),
+		.probe_no_timeout = true,
 	},
 	.probe	= digicolor_uart_probe,
 	.remove	= digicolor_uart_remove,
diff --git a/drivers/tty/serial/fsl_linflexuart.c b/drivers/tty/serial/fsl_linflexuart.c
index 98bb0c315e13..08514238af36 100644
--- a/drivers/tty/serial/fsl_linflexuart.c
+++ b/drivers/tty/serial/fsl_linflexuart.c
@@ -889,6 +889,7 @@ static struct platform_driver linflex_driver = {
 	.driver		= {
 		.name	= DRIVER_NAME,
 		.of_match_table	= linflex_dt_ids,
+		.probe_no_timeout = true,
 		.pm	= &linflex_pm_ops,
 	},
 };
diff --git a/drivers/tty/serial/fsl_lpuart.c b/drivers/tty/serial/fsl_lpuart.c
index 0d6e62f6bb07..64e969278c72 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -2857,6 +2857,7 @@ static struct platform_driver lpuart_driver = {
 	.driver		= {
 		.name	= "fsl-lpuart",
 		.of_match_table = lpuart_dt_ids,
+		.probe_no_timeout = true,
 		.pm	= &lpuart_pm_ops,
 	},
 };
diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
index 30edb35a6a15..deb2539d0fbc 100644
--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -2604,6 +2604,7 @@ static struct platform_driver imx_uart_platform_driver = {
 	.driver = {
 		.name = "imx-uart",
 		.of_match_table = imx_uart_dt_ids,
+		.probe_no_timeout = true,
 		.pm = &imx_uart_pm_ops,
 	},
 };
diff --git a/drivers/tty/serial/lantiq.c b/drivers/tty/serial/lantiq.c
index a3120c3347dd..279ee1ba6ae1 100644
--- a/drivers/tty/serial/lantiq.c
+++ b/drivers/tty/serial/lantiq.c
@@ -942,6 +942,7 @@ static struct platform_driver lqasc_driver = {
 	.driver		= {
 		.name	= DRVNAME,
 		.of_match_table = ltq_asc_match,
+		.probe_no_timeout = true,
 	},
 };
 
diff --git a/drivers/tty/serial/liteuart.c b/drivers/tty/serial/liteuart.c
index 328b50521f14..e92cf2a1b4cc 100644
--- a/drivers/tty/serial/liteuart.c
+++ b/drivers/tty/serial/liteuart.c
@@ -324,6 +324,7 @@ static struct platform_driver liteuart_platform_driver = {
 	.driver = {
 		.name = "liteuart",
 		.of_match_table = liteuart_of_match,
+		.probe_no_timeout = true,
 	},
 };
 
diff --git a/drivers/tty/serial/lpc32xx_hs.c b/drivers/tty/serial/lpc32xx_hs.c
index 93140cac1ca1..bb655bd7f678 100644
--- a/drivers/tty/serial/lpc32xx_hs.c
+++ b/drivers/tty/serial/lpc32xx_hs.c
@@ -727,6 +727,7 @@ static struct platform_driver serial_hs_lpc32xx_driver = {
 	.driver		= {
 		.name	= MODNAME,
 		.of_match_table	= serial_hs_lpc32xx_dt_ids,
+		.probe_no_timeout = true,
 	},
 };
 
diff --git a/drivers/tty/serial/max310x.c b/drivers/tty/serial/max310x.c
index a0b6ea52d133..09e3cee4e0ce 100644
--- a/drivers/tty/serial/max310x.c
+++ b/drivers/tty/serial/max310x.c
@@ -1504,6 +1504,7 @@ static struct spi_driver max310x_spi_driver = {
 	.driver = {
 		.name		= MAX310X_NAME,
 		.of_match_table	= max310x_dt_ids,
+		.probe_no_timeout = true,
 		.pm		= &max310x_pm_ops,
 	},
 	.probe		= max310x_spi_probe,
diff --git a/drivers/tty/serial/meson_uart.c b/drivers/tty/serial/meson_uart.c
index 4869c0059c98..f0104d85484e 100644
--- a/drivers/tty/serial/meson_uart.c
+++ b/drivers/tty/serial/meson_uart.c
@@ -826,6 +826,7 @@ static  struct platform_driver meson_uart_platform_driver = {
 	.driver		= {
 		.name		= "meson_uart",
 		.of_match_table	= meson_uart_dt_match,
+		.probe_no_timeout = true,
 	},
 };
 
diff --git a/drivers/tty/serial/milbeaut_usio.c b/drivers/tty/serial/milbeaut_usio.c
index 347088bb380e..e175e6e0e7c7 100644
--- a/drivers/tty/serial/milbeaut_usio.c
+++ b/drivers/tty/serial/milbeaut_usio.c
@@ -576,6 +576,7 @@ static struct platform_driver mlb_usio_driver = {
 	.driver         = {
 		.name   = USIO_NAME,
 		.of_match_table = mlb_usio_dt_ids,
+		.probe_no_timeout = true,
 	},
 };
 
diff --git a/drivers/tty/serial/mpc52xx_uart.c b/drivers/tty/serial/mpc52xx_uart.c
index e50f069b5ebb..da9c60baf0ed 100644
--- a/drivers/tty/serial/mpc52xx_uart.c
+++ b/drivers/tty/serial/mpc52xx_uart.c
@@ -1885,6 +1885,7 @@ static struct platform_driver mpc52xx_uart_of_driver = {
 	.driver = {
 		.name = "mpc52xx-psc-uart",
 		.of_match_table = mpc52xx_uart_of_match,
+		.probe_no_timeout = true,
 	},
 };
 
diff --git a/drivers/tty/serial/mps2-uart.c b/drivers/tty/serial/mps2-uart.c
index 5e9429dcc51f..4cb82ebe0ec7 100644
--- a/drivers/tty/serial/mps2-uart.c
+++ b/drivers/tty/serial/mps2-uart.c
@@ -634,6 +634,7 @@ static struct platform_driver mps2_serial_driver = {
 	.driver = {
 		.name = DRIVER_NAME,
 		.of_match_table = of_match_ptr(mps2_match),
+		.probe_no_timeout = true,
 		.suppress_bind_attrs = true,
 	},
 };
diff --git a/drivers/tty/serial/msm_serial.c b/drivers/tty/serial/msm_serial.c
index e676ec761f18..989a5cc8612c 100644
--- a/drivers/tty/serial/msm_serial.c
+++ b/drivers/tty/serial/msm_serial.c
@@ -1890,6 +1890,7 @@ static struct platform_driver msm_platform_driver = {
 		.name = "msm_serial",
 		.pm = &msm_serial_dev_pm_ops,
 		.of_match_table = msm_match_table,
+		.probe_no_timeout = true,
 	},
 };
 
diff --git a/drivers/tty/serial/mvebu-uart.c b/drivers/tty/serial/mvebu-uart.c
index 0429c2a54290..b5b49773fcce 100644
--- a/drivers/tty/serial/mvebu-uart.c
+++ b/drivers/tty/serial/mvebu-uart.c
@@ -1049,6 +1049,7 @@ static struct platform_driver mvebu_uart_platform_driver = {
 	.driver	= {
 		.name  = "mvebu-uart",
 		.of_match_table = of_match_ptr(mvebu_uart_of_match),
+		.probe_no_timeout = true,
 		.suppress_bind_attrs = true,
 #if defined(CONFIG_PM)
 		.pm	= &mvebu_uart_pm_ops,
diff --git a/drivers/tty/serial/mxs-auart.c b/drivers/tty/serial/mxs-auart.c
index 1944daf8593a..8bd871b5f263 100644
--- a/drivers/tty/serial/mxs-auart.c
+++ b/drivers/tty/serial/mxs-auart.c
@@ -1725,6 +1725,7 @@ static struct platform_driver mxs_auart_driver = {
 	.driver = {
 		.name = "mxs-auart",
 		.of_match_table = mxs_auart_dt_ids,
+		.probe_no_timeout = true,
 	},
 };
 
diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-serial.c
index 46f4d4cacb6e..2e61d9cbbecb 100644
--- a/drivers/tty/serial/omap-serial.c
+++ b/drivers/tty/serial/omap-serial.c
@@ -1834,6 +1834,7 @@ static struct platform_driver serial_omap_driver = {
 		.name	= OMAP_SERIAL_DRIVER_NAME,
 		.pm	= &serial_omap_dev_pm_ops,
 		.of_match_table = of_match_ptr(omap_serial_of_match),
+		.probe_no_timeout = true,
 	},
 };
 
diff --git a/drivers/tty/serial/owl-uart.c b/drivers/tty/serial/owl-uart.c
index 44d20e5a7dd3..858223abab9d 100644
--- a/drivers/tty/serial/owl-uart.c
+++ b/drivers/tty/serial/owl-uart.c
@@ -766,6 +766,7 @@ static struct platform_driver owl_uart_platform_driver = {
 	.driver = {
 		.name = "owl-uart",
 		.of_match_table = owl_uart_dt_matches,
+		.probe_no_timeout = true,
 	},
 };
 
diff --git a/drivers/tty/serial/pic32_uart.c b/drivers/tty/serial/pic32_uart.c
index b399aac530fe..3f08ac2f38b4 100644
--- a/drivers/tty/serial/pic32_uart.c
+++ b/drivers/tty/serial/pic32_uart.c
@@ -986,6 +986,7 @@ static struct platform_driver pic32_uart_platform_driver = {
 	.driver		= {
 		.name	= PIC32_DEV_NAME,
 		.of_match_table	= of_match_ptr(pic32_serial_dt_ids),
+		.probe_no_timeout = true,
 		.suppress_bind_attrs = IS_BUILTIN(CONFIG_SERIAL_PIC32),
 	},
 };
diff --git a/drivers/tty/serial/pmac_zilog.c b/drivers/tty/serial/pmac_zilog.c
index 3133446e806c..552efe9eef7b 100644
--- a/drivers/tty/serial/pmac_zilog.c
+++ b/drivers/tty/serial/pmac_zilog.c
@@ -1790,6 +1790,7 @@ static struct macio_driver pmz_driver = {
 		.name 		= "pmac_zilog",
 		.owner		= THIS_MODULE,
 		.of_match_table	= pmz_match,
+		.probe_no_timeout = true,
 	},
 	.probe		= pmz_attach,
 	.remove		= pmz_detach,
diff --git a/drivers/tty/serial/pxa.c b/drivers/tty/serial/pxa.c
index e80ba8e10407..b0b91f69b24c 100644
--- a/drivers/tty/serial/pxa.c
+++ b/drivers/tty/serial/pxa.c
@@ -910,6 +910,7 @@ static struct platform_driver serial_pxa_driver = {
 #endif
 		.suppress_bind_attrs = true,
 		.of_match_table = serial_pxa_dt_ids,
+		.probe_no_timeout = true,
 	},
 };
 
diff --git a/drivers/tty/serial/qcom_geni_serial.c b/drivers/tty/serial/qcom_geni_serial.c
index 4733a233bd0c..c47cfd4a5ea5 100644
--- a/drivers/tty/serial/qcom_geni_serial.c
+++ b/drivers/tty/serial/qcom_geni_serial.c
@@ -1541,6 +1541,7 @@ static struct platform_driver qcom_geni_serial_platform_driver = {
 	.driver = {
 		.name = "qcom_geni_serial",
 		.of_match_table = qcom_geni_serial_match_table,
+		.probe_no_timeout = true,
 		.pm = &qcom_geni_serial_pm_ops,
 	},
 };
diff --git a/drivers/tty/serial/rda-uart.c b/drivers/tty/serial/rda-uart.c
index f556b4955f59..9e7927de0972 100644
--- a/drivers/tty/serial/rda-uart.c
+++ b/drivers/tty/serial/rda-uart.c
@@ -797,6 +797,7 @@ static struct platform_driver rda_uart_platform_driver = {
 	.driver = {
 		.name = "rda-uart",
 		.of_match_table = rda_uart_dt_matches,
+		.probe_no_timeout = true,
 	},
 };
 
diff --git a/drivers/tty/serial/samsung_tty.c b/drivers/tty/serial/samsung_tty.c
index d5ca904def34..e3d77bc2420f 100644
--- a/drivers/tty/serial/samsung_tty.c
+++ b/drivers/tty/serial/samsung_tty.c
@@ -2939,6 +2939,7 @@ static struct platform_driver samsung_serial_driver = {
 		.name	= "samsung-uart",
 		.pm	= SERIAL_SAMSUNG_PM_OPS,
 		.of_match_table	= of_match_ptr(s3c24xx_uart_dt_match),
+		.probe_no_timeout = true,
 	},
 };
 
diff --git a/drivers/tty/serial/sc16is7xx.c b/drivers/tty/serial/sc16is7xx.c
index 8472bf70477c..dfc455850908 100644
--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -1652,6 +1652,7 @@ static struct spi_driver sc16is7xx_spi_uart_driver = {
 	.driver = {
 		.name		= SC16IS7XX_NAME,
 		.of_match_table	= sc16is7xx_dt_ids,
+		.probe_no_timeout = true,
 	},
 	.probe		= sc16is7xx_spi_probe,
 	.remove		= sc16is7xx_spi_remove,
diff --git a/drivers/tty/serial/serial-tegra.c b/drivers/tty/serial/serial-tegra.c
index d942ab152f5a..240166a36569 100644
--- a/drivers/tty/serial/serial-tegra.c
+++ b/drivers/tty/serial/serial-tegra.c
@@ -1653,6 +1653,7 @@ static struct platform_driver tegra_uart_platform_driver = {
 	.driver		= {
 		.name	= "serial-tegra",
 		.of_match_table = tegra_uart_of_match,
+		.probe_no_timeout = true,
 		.pm	= &tegra_uart_pm_ops,
 	},
 };
diff --git a/drivers/tty/serial/sh-sci.c b/drivers/tty/serial/sh-sci.c
index 0075a1420005..ee90562c7e8d 100644
--- a/drivers/tty/serial/sh-sci.c
+++ b/drivers/tty/serial/sh-sci.c
@@ -3396,6 +3396,7 @@ static struct platform_driver sci_driver = {
 		.name	= "sh-sci",
 		.pm	= &sci_dev_pm_ops,
 		.of_match_table = of_match_ptr(of_sci_match),
+		.probe_no_timeout = true,
 	},
 };
 
diff --git a/drivers/tty/serial/sifive.c b/drivers/tty/serial/sifive.c
index c0869b080cc3..a9f3a4562205 100644
--- a/drivers/tty/serial/sifive.c
+++ b/drivers/tty/serial/sifive.c
@@ -1066,6 +1066,7 @@ static struct platform_driver sifive_serial_platform_driver = {
 	.driver		= {
 		.name	= SIFIVE_SERIAL_NAME,
 		.of_match_table = of_match_ptr(sifive_serial_of_match),
+		.probe_no_timeout = true,
 	},
 };
 
diff --git a/drivers/tty/serial/sprd_serial.c b/drivers/tty/serial/sprd_serial.c
index 4329b9c9cbf0..6c01e647bc4d 100644
--- a/drivers/tty/serial/sprd_serial.c
+++ b/drivers/tty/serial/sprd_serial.c
@@ -1278,6 +1278,7 @@ static struct platform_driver sprd_platform_driver = {
 	.driver		= {
 		.name	= "sprd_serial",
 		.of_match_table = of_match_ptr(serial_ids),
+		.probe_no_timeout = true,
 		.pm	= &sprd_pm_ops,
 	},
 };
diff --git a/drivers/tty/serial/st-asc.c b/drivers/tty/serial/st-asc.c
index 1b0da603ab54..a01c10522bb6 100644
--- a/drivers/tty/serial/st-asc.c
+++ b/drivers/tty/serial/st-asc.c
@@ -973,6 +973,7 @@ static struct platform_driver asc_serial_driver = {
 		.name	= DRIVER_NAME,
 		.pm	= &asc_serial_pm_ops,
 		.of_match_table = of_match_ptr(asc_match),
+		.probe_no_timeout = true,
 	},
 };
 
diff --git a/drivers/tty/serial/stm32-usart.c b/drivers/tty/serial/stm32-usart.c
index b7b44f4050d4..5aa01cd6f24f 100644
--- a/drivers/tty/serial/stm32-usart.c
+++ b/drivers/tty/serial/stm32-usart.c
@@ -2019,6 +2019,7 @@ static struct platform_driver stm32_serial_driver = {
 		.name	= DRIVER_NAME,
 		.pm	= &stm32_serial_pm_ops,
 		.of_match_table = of_match_ptr(stm32_match),
+		.probe_no_timeout = true,
 	},
 };
 
diff --git a/drivers/tty/serial/sunhv.c b/drivers/tty/serial/sunhv.c
index eafada8fb6fa..05bf49af8328 100644
--- a/drivers/tty/serial/sunhv.c
+++ b/drivers/tty/serial/sunhv.c
@@ -630,6 +630,7 @@ static struct platform_driver hv_driver = {
 	.driver = {
 		.name = "hv",
 		.of_match_table = hv_match,
+		.probe_no_timeout = true,
 	},
 	.probe		= hv_probe,
 	.remove		= hv_remove,
diff --git a/drivers/tty/serial/sunplus-uart.c b/drivers/tty/serial/sunplus-uart.c
index 60c73662f955..b5b09aedab9c 100644
--- a/drivers/tty/serial/sunplus-uart.c
+++ b/drivers/tty/serial/sunplus-uart.c
@@ -709,6 +709,7 @@ static struct platform_driver sunplus_uart_platform_driver = {
 	.driver = {
 		.name	= "sunplus_uart",
 		.of_match_table = sp_uart_of_match,
+		.probe_no_timeout = true,
 		.pm     = &sunplus_uart_pm_ops,
 	}
 };
diff --git a/drivers/tty/serial/sunsab.c b/drivers/tty/serial/sunsab.c
index 6ea52293d9f3..3d2eea131a67 100644
--- a/drivers/tty/serial/sunsab.c
+++ b/drivers/tty/serial/sunsab.c
@@ -1103,6 +1103,7 @@ static struct platform_driver sab_driver = {
 	.driver = {
 		.name = "sab",
 		.of_match_table = sab_match,
+		.probe_no_timeout = true,
 	},
 	.probe		= sab_probe,
 	.remove		= sab_remove,
diff --git a/drivers/tty/serial/sunsu.c b/drivers/tty/serial/sunsu.c
index fff50b5b82eb..598691174e08 100644
--- a/drivers/tty/serial/sunsu.c
+++ b/drivers/tty/serial/sunsu.c
@@ -1566,6 +1566,7 @@ static struct platform_driver su_driver = {
 	.driver = {
 		.name = "su",
 		.of_match_table = su_match,
+		.probe_no_timeout = true,
 	},
 	.probe		= su_probe,
 	.remove		= su_remove,
diff --git a/drivers/tty/serial/sunzilog.c b/drivers/tty/serial/sunzilog.c
index c14275d83b0b..15dc30f493d9 100644
--- a/drivers/tty/serial/sunzilog.c
+++ b/drivers/tty/serial/sunzilog.c
@@ -1541,6 +1541,7 @@ static struct platform_driver zs_driver = {
 	.driver = {
 		.name = "zs",
 		.of_match_table = zs_match,
+		.probe_no_timeout = true,
 	},
 	.probe		= zs_probe,
 	.remove		= zs_remove,
diff --git a/drivers/tty/serial/tegra-tcu.c b/drivers/tty/serial/tegra-tcu.c
index 4877c54c613d..aa0ba869e590 100644
--- a/drivers/tty/serial/tegra-tcu.c
+++ b/drivers/tty/serial/tegra-tcu.c
@@ -292,6 +292,7 @@ static struct platform_driver tegra_tcu_driver = {
 	.driver = {
 		.name = "tegra-tcu",
 		.of_match_table = tegra_tcu_match,
+		.probe_no_timeout = true,
 	},
 	.probe = tegra_tcu_probe,
 	.remove = tegra_tcu_remove,
diff --git a/drivers/tty/serial/uartlite.c b/drivers/tty/serial/uartlite.c
index 880e2afbb97b..a7f600e57a25 100644
--- a/drivers/tty/serial/uartlite.c
+++ b/drivers/tty/serial/uartlite.c
@@ -919,6 +919,7 @@ static struct platform_driver ulite_platform_driver = {
 	.driver = {
 		.name  = "uartlite",
 		.of_match_table = of_match_ptr(ulite_of_match),
+		.probe_no_timeout = true,
 		.pm = &ulite_pm_ops,
 	},
 };
diff --git a/drivers/tty/serial/ucc_uart.c b/drivers/tty/serial/ucc_uart.c
index 6000853973c1..a2e637876db0 100644
--- a/drivers/tty/serial/ucc_uart.c
+++ b/drivers/tty/serial/ucc_uart.c
@@ -1500,6 +1500,7 @@ static struct platform_driver ucc_uart_of_driver = {
 	.driver = {
 		.name = "ucc_uart",
 		.of_match_table    = ucc_uart_match,
+		.probe_no_timeout = true,
 	},
 	.probe  	= ucc_uart_probe,
 	.remove 	= ucc_uart_remove,
diff --git a/drivers/tty/serial/vt8500_serial.c b/drivers/tty/serial/vt8500_serial.c
index 6f08136ce78a..074b4e8b61b6 100644
--- a/drivers/tty/serial/vt8500_serial.c
+++ b/drivers/tty/serial/vt8500_serial.c
@@ -722,6 +722,7 @@ static struct platform_driver vt8500_platform_driver = {
 	.driver = {
 		.name = "vt8500_serial",
 		.of_match_table = wmt_dt_ids,
+		.probe_no_timeout = true,
 		.suppress_bind_attrs = true,
 	},
 };
diff --git a/drivers/tty/serial/xilinx_uartps.c b/drivers/tty/serial/xilinx_uartps.c
index 9e01fe6c0ab8..7e941c7e819e 100644
--- a/drivers/tty/serial/xilinx_uartps.c
+++ b/drivers/tty/serial/xilinx_uartps.c
@@ -1656,6 +1656,7 @@ static struct platform_driver cdns_uart_platform_driver = {
 	.driver  = {
 		.name = CDNS_UART_NAME,
 		.of_match_table = cdns_uart_of_match,
+		.probe_no_timeout = true,
 		.pm = &cdns_uart_dev_pm_ops,
 		.suppress_bind_attrs = IS_BUILTIN(CONFIG_SERIAL_XILINX_PS_UART),
 		},
-- 
2.37.0.rc0.161.g10f37bed90-goog

