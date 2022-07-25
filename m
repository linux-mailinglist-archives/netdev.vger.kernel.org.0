Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0555E57F937
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 07:55:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232562AbiGYFz2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 01:55:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232340AbiGYFzL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 01:55:11 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A625F30
        for <netdev@vger.kernel.org>; Sun, 24 Jul 2022 22:55:08 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id f11so9442442pgj.7
        for <netdev@vger.kernel.org>; Sun, 24 Jul 2022 22:55:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=sdzCw5QYBD7+6SeNjHnb+FQsYCZ4HeBFwN+VkR1mKSk=;
        b=fZt1OH5YBu5KLlQkHVUuQL4bykWgb1REoHkoSQ7dn6/TnlxceuGevJzBtsH2cWkrsV
         hVT0pIwKjlciS7MTBjy16J+re6zMdYR1PU9xwS6H8+SGifRTu2zE9A5GxWd0GovEUXbu
         YobBpgGEeS8/hKCF9RuId7h4v3jBfXFc1XItw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=sdzCw5QYBD7+6SeNjHnb+FQsYCZ4HeBFwN+VkR1mKSk=;
        b=Iw+FceROoiOP+kkXoxhOrMk75/sIFjEor2P1WH0PB1gGW3/jePXkc9iV0Wkm87uwzz
         5eqcJ9LPTSlxJ6dIgZ9zsn/0Hb89/JcsT1NjoAh8roOny7b/ul43VxkpAWqvQXCISdxU
         5Tyjig8vWiw+LTQeZ+QsQUzVemuSP1Z0TaDotMf7IwaVGqatUgWonPZxXE/K8BnRSESy
         Ae2BSXrdSWO2LY8isl7DEOhwGijiSiQ8Sz8n8D4JGLnneO6WDn98onrb/o4KOAn1ktgX
         UEs3emrL/fcQYmDx/UqCl2e0In+PfejfwpUWI8Qjqg7dFSPSOfZnPUKCITSlK4GxIrdi
         T75g==
X-Gm-Message-State: AJIora9K9E7+prkXn1fTn1ffp110Nnk7UpSebu1aTLWLz0vvSiuJeSve
        oIo7gvm3DCw8z8F60yGIZLT8hg==
X-Google-Smtp-Source: AGRyM1ssVSBKb6lxdTkbgJiMeJLoT5QYr0eDb8NARuR+t+ea1xP3A5+irMn9DG8CLkQliTjzy7wy/w==
X-Received: by 2002:aa7:9ae3:0:b0:528:d881:9ff with SMTP id y3-20020aa79ae3000000b00528d88109ffmr11394307pfp.66.1658728508289;
        Sun, 24 Jul 2022 22:55:08 -0700 (PDT)
Received: from ubuntu-22.localdomain ([192.19.222.250])
        by smtp.gmail.com with ESMTPSA id m5-20020a170902bb8500b0016c4331e61csm8198910pls.137.2022.07.24.22.55.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Jul 2022 22:55:07 -0700 (PDT)
From:   William Zhang <william.zhang@broadcom.com>
To:     Linux ARM List <linux-arm-kernel@lists.infradead.org>
Cc:     joel.peshkin@broadcom.com, f.fainelli@gmail.com,
        Broadcom Kernel List <bcm-kernel-feedback-list@broadcom.com>,
        dan.beygelman@broadcom.com, anand.gore@broadcom.com,
        kursad.oney@broadcom.com, rafal@milecki.pl,
        krzysztof.kozlowski@linaro.org,
        William Zhang <william.zhang@broadcom.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh@kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        linux-i2c@vger.kernel.org (open list:I2C SUBSYSTEM HOST DRIVERS),
        linux-kernel@vger.kernel.org (open list),
        linux-mtd@lists.infradead.org (open list:MEMORY TECHNOLOGY DEVICES
        (MTD)), netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-pci@vger.kernel.org (open list:PCI NATIVE HOST BRIDGE AND
        ENDPOINT DRIVERS),
        linux-phy@lists.infradead.org (open list:GENERIC PHY FRAMEWORK),
        linux-gpio@vger.kernel.org (open list:PIN CONTROL SUBSYSTEM),
        linux-mips@vger.kernel.org (open list:BROADCOM BMIPS MIPS ARCHITECTURE),
        linux-serial@vger.kernel.org (open list:SERIAL DRIVERS),
        linux-watchdog@vger.kernel.org (open list:WATCHDOG DEVICE DRIVERS)
Subject: [PATCH v2 6/9] arm64: bcmbca: Make BCM4908 drivers depend on ARCH_BCMBCA
Date:   Sun, 24 Jul 2022 22:53:59 -0700
Message-Id: <20220725055402.6013-7-william.zhang@broadcom.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220725055402.6013-1-william.zhang@broadcom.com>
References: <20220725055402.6013-1-william.zhang@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000008a785305e49ad3af"
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000008a785305e49ad3af
Content-Transfer-Encoding: 8bit

With Broadcom Broadband arch ARCH_BCMBCA supported in the kernel, this
patch series migrate the ARCH_BCM4908 symbol to ARCH_BCMBCA. Hence
replace ARCH_BCM4908 with ARCH_BCMBCA in subsystem Kconfig files.

Signed-off-by: William Zhang <william.zhang@broadcom.com>
Acked-by: Guenter Roeck <linux@roeck-us.net> (for watchdog)
Acked-by: Bjorn Helgaas <bhelgaas@google.com> (for drivers/pci)

---

Changes in v2:
- Add Acked-by tags
- Update commit message with more details

 drivers/i2c/busses/Kconfig            | 4 ++--
 drivers/mtd/parsers/Kconfig           | 6 +++---
 drivers/net/ethernet/broadcom/Kconfig | 4 ++--
 drivers/pci/controller/Kconfig        | 2 +-
 drivers/phy/broadcom/Kconfig          | 4 ++--
 drivers/pinctrl/bcm/Kconfig           | 4 ++--
 drivers/reset/Kconfig                 | 2 +-
 drivers/soc/bcm/bcm63xx/Kconfig       | 4 ++--
 drivers/tty/serial/Kconfig            | 4 ++--
 drivers/watchdog/Kconfig              | 2 +-
 10 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index 45a4e9f1b639..fd9a4dd01997 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -487,8 +487,8 @@ config I2C_BCM_KONA
 
 config I2C_BRCMSTB
 	tristate "BRCM Settop/DSL I2C controller"
-	depends on ARCH_BCM2835 || ARCH_BCM4908 || ARCH_BCMBCA || \
-		   ARCH_BRCMSTB || BMIPS_GENERIC || COMPILE_TEST
+	depends on ARCH_BCM2835 || ARCH_BCMBCA || ARCH_BRCMSTB || \
+		   BMIPS_GENERIC || COMPILE_TEST
 	default y
 	help
 	  If you say yes to this option, support will be included for the
diff --git a/drivers/mtd/parsers/Kconfig b/drivers/mtd/parsers/Kconfig
index b43df73927a0..d6db655a1d24 100644
--- a/drivers/mtd/parsers/Kconfig
+++ b/drivers/mtd/parsers/Kconfig
@@ -69,8 +69,8 @@ config MTD_OF_PARTS
 
 config MTD_OF_PARTS_BCM4908
 	bool "BCM4908 partitioning support"
-	depends on MTD_OF_PARTS && (ARCH_BCM4908 || COMPILE_TEST)
-	default ARCH_BCM4908
+	depends on MTD_OF_PARTS && (ARCH_BCMBCA || COMPILE_TEST)
+	default ARCH_BCMBCA
 	help
 	  This provides partitions parser for BCM4908 family devices
 	  that can have multiple "firmware" partitions. It takes care of
@@ -78,7 +78,7 @@ config MTD_OF_PARTS_BCM4908
 
 config MTD_OF_PARTS_LINKSYS_NS
 	bool "Linksys Northstar partitioning support"
-	depends on MTD_OF_PARTS && (ARCH_BCM_5301X || ARCH_BCM4908 || COMPILE_TEST)
+	depends on MTD_OF_PARTS && (ARCH_BCM_5301X || ARCH_BCMBCA || COMPILE_TEST)
 	default ARCH_BCM_5301X
 	help
 	  This provides partitions parser for Linksys devices based on Broadcom
diff --git a/drivers/net/ethernet/broadcom/Kconfig b/drivers/net/ethernet/broadcom/Kconfig
index 56e0fb07aec7..f4e1ca68d831 100644
--- a/drivers/net/ethernet/broadcom/Kconfig
+++ b/drivers/net/ethernet/broadcom/Kconfig
@@ -53,8 +53,8 @@ config B44_PCI
 
 config BCM4908_ENET
 	tristate "Broadcom BCM4908 internal mac support"
-	depends on ARCH_BCM4908 || COMPILE_TEST
-	default y if ARCH_BCM4908
+	depends on ARCH_BCMBCA || COMPILE_TEST
+	default y if ARCH_BCMBCA
 	help
 	  This driver supports Ethernet controller integrated into Broadcom
 	  BCM4908 family SoCs.
diff --git a/drivers/pci/controller/Kconfig b/drivers/pci/controller/Kconfig
index d1c5fcf00a8a..bfd9bac37e24 100644
--- a/drivers/pci/controller/Kconfig
+++ b/drivers/pci/controller/Kconfig
@@ -274,7 +274,7 @@ config VMD
 
 config PCIE_BRCMSTB
 	tristate "Broadcom Brcmstb PCIe host controller"
-	depends on ARCH_BRCMSTB || ARCH_BCM2835 || ARCH_BCM4908 || \
+	depends on ARCH_BRCMSTB || ARCH_BCM2835 || ARCH_BCMBCA || \
 		   BMIPS_GENERIC || COMPILE_TEST
 	depends on OF
 	depends on PCI_MSI_IRQ_DOMAIN
diff --git a/drivers/phy/broadcom/Kconfig b/drivers/phy/broadcom/Kconfig
index 93a6a8ee4716..1d89a2fd9b79 100644
--- a/drivers/phy/broadcom/Kconfig
+++ b/drivers/phy/broadcom/Kconfig
@@ -93,11 +93,11 @@ config PHY_BRCM_SATA
 
 config PHY_BRCM_USB
 	tristate "Broadcom STB USB PHY driver"
-	depends on ARCH_BCM4908 || ARCH_BRCMSTB || COMPILE_TEST
+	depends on ARCH_BCMBCA || ARCH_BRCMSTB || COMPILE_TEST
 	depends on OF
 	select GENERIC_PHY
 	select SOC_BRCMSTB if ARCH_BRCMSTB
-	default ARCH_BCM4908 || ARCH_BRCMSTB
+	default ARCH_BCMBCA || ARCH_BRCMSTB
 	help
 	  Enable this to support the Broadcom STB USB PHY.
 	  This driver is required by the USB XHCI, EHCI and OHCI
diff --git a/drivers/pinctrl/bcm/Kconfig b/drivers/pinctrl/bcm/Kconfig
index 8f4d89806fcb..35b51ce4298e 100644
--- a/drivers/pinctrl/bcm/Kconfig
+++ b/drivers/pinctrl/bcm/Kconfig
@@ -31,13 +31,13 @@ config PINCTRL_BCM2835
 
 config PINCTRL_BCM4908
 	tristate "Broadcom BCM4908 pinmux driver"
-	depends on OF && (ARCH_BCM4908 || COMPILE_TEST)
+	depends on OF && (ARCH_BCMBCA || COMPILE_TEST)
 	select PINMUX
 	select PINCONF
 	select GENERIC_PINCONF
 	select GENERIC_PINCTRL_GROUPS
 	select GENERIC_PINMUX_FUNCTIONS
-	default ARCH_BCM4908
+	default ARCH_BCMBCA
 	help
 	  Driver for BCM4908 family SoCs with integrated pin controller.
 
diff --git a/drivers/reset/Kconfig b/drivers/reset/Kconfig
index f9a7cee01659..7ae71535fe2a 100644
--- a/drivers/reset/Kconfig
+++ b/drivers/reset/Kconfig
@@ -201,7 +201,7 @@ config RESET_SCMI
 
 config RESET_SIMPLE
 	bool "Simple Reset Controller Driver" if COMPILE_TEST || EXPERT
-	default ARCH_ASPEED || ARCH_BCM4908 || ARCH_BITMAIN || ARCH_REALTEK || ARCH_STM32 || (ARCH_INTEL_SOCFPGA && ARM64) || ARCH_SUNXI || ARC
+	default ARCH_ASPEED || ARCH_BCMBCA || ARCH_BITMAIN || ARCH_REALTEK || ARCH_STM32 || (ARCH_INTEL_SOCFPGA && ARM64) || ARCH_SUNXI || ARC
 	help
 	  This enables a simple reset controller driver for reset lines that
 	  that can be asserted and deasserted by toggling bits in a contiguous,
diff --git a/drivers/soc/bcm/bcm63xx/Kconfig b/drivers/soc/bcm/bcm63xx/Kconfig
index 9e501c8ac5ce..355c34482076 100644
--- a/drivers/soc/bcm/bcm63xx/Kconfig
+++ b/drivers/soc/bcm/bcm63xx/Kconfig
@@ -13,8 +13,8 @@ endif # SOC_BCM63XX
 
 config BCM_PMB
 	bool "Broadcom PMB (Power Management Bus) driver"
-	depends on ARCH_BCM4908 || (COMPILE_TEST && OF)
-	default ARCH_BCM4908
+	depends on ARCH_BCMBCA || (COMPILE_TEST && OF)
+	default ARCH_BCMBCA
 	select PM_GENERIC_DOMAINS if PM
 	help
 	  This enables support for the Broadcom's PMB (Power Management Bus) that
diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
index e3279544b03c..f32bb01c3feb 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -1100,8 +1100,8 @@ config SERIAL_TIMBERDALE
 config SERIAL_BCM63XX
 	tristate "Broadcom BCM63xx/BCM33xx UART support"
 	select SERIAL_CORE
-	depends on ARCH_BCM4908 || ARCH_BCMBCA || BCM63XX || BMIPS_GENERIC || COMPILE_TEST
-	default ARCH_BCM4908 || ARCH_BCMBCA || BCM63XX || BMIPS_GENERIC
+	depends on ARCH_BCMBCA || BCM63XX || BMIPS_GENERIC || COMPILE_TEST
+	default ARCH_BCMBCA || BCM63XX || BMIPS_GENERIC
 	help
 	  This enables the driver for the onchip UART core found on
 	  the following chipsets:
diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 32fd37698932..1f85ec8a4b3b 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -1798,7 +1798,7 @@ config BCM7038_WDT
 	tristate "BCM63xx/BCM7038 Watchdog"
 	select WATCHDOG_CORE
 	depends on HAS_IOMEM
-	depends on ARCH_BCM4908 || ARCH_BRCMSTB || BMIPS_GENERIC || BCM63XX || COMPILE_TEST
+	depends on ARCH_BCMBCA || ARCH_BRCMSTB || BMIPS_GENERIC || BCM63XX || COMPILE_TEST
 	help
 	  Watchdog driver for the built-in hardware in Broadcom 7038 and
 	  later SoCs used in set-top boxes.  BCM7038 was made public
-- 
2.34.1


--0000000000008a785305e49ad3af
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
TltlrAeBKRJ1M9O/DY5v7L1Yrs//7XIRg/d2ZPAOSGBQzFYjYTFWwNBiR1s1zP0m2y56DPbS5gwj
fqAN/I4PJHIvTh3zUgHXNKadYoYRiPHXfaTWO9UhzysOpQIDAQABo4IB2zCCAdcwDgYDVR0PAQH/
BAQDAgWgMIGjBggrBgEFBQcBAQSBljCBkzBOBggrBgEFBQcwAoZCaHR0cDovL3NlY3VyZS5nbG9i
YWxzaWduLmNvbS9jYWNlcnQvZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAuY3J0MEEGCCsGAQUF
BzABhjVodHRwOi8vb2NzcC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAy
MDBNBgNVHSAERjBEMEIGCisGAQQBoDIBKAowNDAyBggrBgEFBQcCARYmaHR0cHM6Ly93d3cuZ2xv
YmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wCQYDVR0TBAIwADBJBgNVHR8EQjBAMD6gPKA6hjhodHRw
Oi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNybDAlBgNV
HREEHjAcgRp3aWxsaWFtLnpoYW5nQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAf
BgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUohM5GmNlGWe5wpzDxzIy
+EgzbRswDQYJKoZIhvcNAQELBQADggEBACKu9JSQAYTlmC+JTniO/C/UcXGonATI/muBjWTxtkHc
abZtz0uwzzrRrpV+mbHLGVFFeRbXSLvcEzqHp8VomXifEZlfsE9LajSehzaqhd+np+tmUPz1RlI/
ibZ7vW+1VF18lfoL+wHs2H0fsG6JfoqZldEWYXASXnUrs0iTLgXxvwaQj69cSMuzfFm1X5kWqWCP
W0KkR8025J0L5L4yXfkSO6psD/k4VcTsMJHLN4RfMuaXIT6EM0cNO6h3GypyTuPf1N1X+F6WQPKb
1u+rvdML63P9fX7e7mwwGt5klRnf8aK2VU7mIdYCcrFHaKDTW3fkG6kIgrE1wWSgiZYL400xggJt
MIICaQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYD
VQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgw28eX6TfvsbNfu
SIMwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIPnn0LC862ummW8VbJyCSghDwjKh
DMLEG6A5rOkOdvNdMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIy
MDcyNTA1NTUwOFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsG
CWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFl
AwQCATANBgkqhkiG9w0BAQEFAASCAQCZCRtSNVRRjX1kn5j4WfARgvI155bBuFosXTG/LQUfwsk3
4RayqTF7gVedACcrBTDHgSsp5aMKwqyPfVYLkkla0kICaoC14C43ogig0uirlv7o/mtkq/VKF8HH
9KtmAMxVBZVhPYxIkAe5vNUhlStrLyi+dCbx/6K/kSxBleonB+10V3OX8ukIJNuq3uT4Uf4AZ99x
e4b/yXk/cvaS0kBtLh6daQwMC4RzrimgeJSuUiaeFl4N4VympLi7GXmM/4Zxnagjzfl7aw3WBkSU
4//NVoko3wqXt2kskYNrKY9NbG+qCZttUH7vJ4YsaWKIYGYBTw1KOmH//9nMXGko3XwC
--0000000000008a785305e49ad3af--
