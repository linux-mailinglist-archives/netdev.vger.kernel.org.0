Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7239E4C349F
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 19:23:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232884AbiBXSXK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 13:23:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232851AbiBXSXH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 13:23:07 -0500
Received: from GBR01-LO2-obe.outbound.protection.outlook.com (mail-lo2gbr01on2090.outbound.protection.outlook.com [40.107.10.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D423B191405;
        Thu, 24 Feb 2022 10:22:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=An1Th6g15XaUY4mUOMZVJQqpXaKZciuHp+kfWiuHV7wlQE9Al2c0z7xuXrvBI7VIjk4VQckv7u8qVlM3rKAzc35AtBvQCN3aavsmYHLhZl2FnjkaE5E7l1MDlGHNtYl9K+JgMzA5eFAyS5XIEQARigkl/+v/wx6kJ9MMr7aQygqDYKsqJ/rD2xoZU2ZEBRxYImmgaEcoXbfG2lEwmxegurk4K/7jK3j/V3cCwBdK7gCt8SlEoxSb9ISNzOPyJITnoMWV0+ucPz12nGTaYTCZ3kGLTKMUNffnGQB7sRpHo2la3FMAgncbt1r2HtR/C/1GV5hHJdqnZBtTqX6eoKplyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9mi3Ncpf5oNcAwHmMJksBHKvgiAgCLZauMix2zpjkkY=;
 b=VlnAZypUo42vZo222zwaZC9tFKAZi6xlxwfjyCfDxB9MXvKn8UK/gXmmqpZFjVVBJUGewmmaVuu/uHoxTXXZEsoL+OeaYgxGL0HHic9I+L9se0FKhHOZ1lGkm54MW6xrB5e61Z5uaFLqN1ZtLMkLXgoFtEN8CT83cVMb95KIFigFJJM11hHacVCLKoZOATFzlhAlIUkzrY7trZkLTOFMkWv2wUT922z0x4QEsE7V3rOic1G9w6kXbiigtgjZ32N8eoyKKVOIV1DY6QbCyH3piLo55BnV4h0EIqU8dOz4TCz1Msa3AOs+jTAQEfsjnD52cKfy72Zbu4Ywzzcou0XEVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=purelifi.com; dmarc=pass action=none header.from=purelifi.com;
 dkim=pass header.d=purelifi.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=purevlc.onmicrosoft.com; s=selector2-purevlc-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9mi3Ncpf5oNcAwHmMJksBHKvgiAgCLZauMix2zpjkkY=;
 b=a2SWbfXEbg+ndU9SM9NvPAyq0PCRUyXc4Uz31LJiWHf8mV4vX4m7yP49OjvfMc8ulr9plp5Rkj8lytBTeOQtMLi3dUlZCZK8zP+kLI0pl8yRePaw2yVLQ5WfLov0BMyDunTMGQqbbRpqLn0fOwQYgVcOiyvyuA4dzCK+C7zWvyI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=purelifi.com;
Received: from LO0P265MB3226.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:15b::5)
 by LO2P265MB4631.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:227::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21; Thu, 24 Feb
 2022 18:22:29 +0000
Received: from LO0P265MB3226.GBRP265.PROD.OUTLOOK.COM
 ([fe80::f9ee:fbdb:b1e3:1a75]) by LO0P265MB3226.GBRP265.PROD.OUTLOOK.COM
 ([fe80::f9ee:fbdb:b1e3:1a75%7]) with mapi id 15.20.5017.024; Thu, 24 Feb 2022
 18:22:29 +0000
From:   Srinivasan Raju <srini.raju@purelifi.com>
Cc:     mostafa.afgani@purelifi.com,
        Srinivasan Raju <srini.raju@purelifi.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-kernel@vger.kernel.org (open list),
        linux-wireless@vger.kernel.org (open list:NETWORKING DRIVERS (WIRELESS)),
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS)
Subject: [PATCH v22 1/2] wireless: Initial driver submission for pureLiFi STA devices
Date:   Thu, 24 Feb 2022 18:20:07 +0000
Message-Id: <20220224182042.132466-3-srini.raju@purelifi.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220224182042.132466-1-srini.raju@purelifi.com>
References: <20200928102008.32568-1-srini.raju@purelifi.com>
 <20220224182042.132466-1-srini.raju@purelifi.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0229.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a6::18) To LO0P265MB3226.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:15b::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 124f8dcf-84dc-4119-df09-08d9f7c29de6
X-MS-TrafficTypeDiagnostic: LO2P265MB4631:EE_
X-Microsoft-Antispam-PRVS: <LO2P265MB46316EE7CD546DB09FEAE764E03D9@LO2P265MB4631.GBRP265.PROD.OUTLOOK.COM>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x2Zd4adMCZrUEogsdk9uoVZVRYfhEEQse8NIu9rmfQpwZFqHkiestYb7Yd45bP7jCJ1hPwTbafFXRNtYMGhEquCUyqfhZ8g+4riTyToVMaVKF0ym0wZGAjy5NcfBZ/lDKdrPOZA2vXjOoQen6kg43Ft0aZNdavVVr8YrPlwjrBlKaUHw9I6a21660zghJPohSCCr2reIhHWjL69h1cbdF+QSXN+hk+dyWM5QrsJpGP3+QaLvAzsXa3Sd88v51zrA0LVzk6DCZ1ha59XhIon4ilBtVH1ULGXYa4bGK//QBjIrR9JPbJqLOBIB5CZvk1ryRQiNNCQeW2MDw+el8DWHSIzSWSlhirLZWMmwQz6RriZ5RjoToyUpFk8HYhxb+28fyVlKJuUN4oUfeOOowoFPKP27mQg7WEfjIucpA5ECIYDLi4WG6DhW68bmBovZEQAwqp4uTP+StdnruAXC7Sn0i5N3B5wL/V6qhRpUu6fH+2srtxTOsH90C7j6S0KF68iv+d6+SqVkE45kUhdjvUwR6Ob1y28KtovMvHpxXlRZSQYlApIk8R5XMK+Ygik5z+Xmn5f7loRYTOM+chzt2lWU3waOOslpxSPw56k/Khs2RhwKYfZvxAu+gg7NGJYk6VpwH6Mq9cDwlM9wQnBCT6L5UiV9r0bTiB1MC0PgarSV+PYGek7A41VC07pEgGdW165tdAJ8qRd46+9WcBD9shmX83/PpPp7xDbHiQrpQIQ+qQ8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LO0P265MB3226.GBRP265.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(6029001)(4636009)(366004)(66946007)(30864003)(36756003)(5660300002)(66556008)(6666004)(8936002)(86362001)(52116002)(2616005)(54906003)(66476007)(4326008)(6506007)(8676002)(316002)(6512007)(1076003)(2906002)(186003)(83380400001)(508600001)(109986005)(26005)(38100700002)(38350700002)(6486002)(266003)(579004)(559001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TM7/ApIa8Pqp7C3/X5HHePfAWEei/nSI/xDW40MoR+1rba5jrLPWs8sGvOEG?=
 =?us-ascii?Q?76F/8WdJeUPoUx3kBpf3h8+DOMgToykhwz+wUqimTn96FSKgVm/f7wrpjvyt?=
 =?us-ascii?Q?ejtK9IAvcScAnKjP0zOBchULMJvH56vKwArSJPjhhJvmGXhNcRz7THaChC/t?=
 =?us-ascii?Q?XBCGZlcptaADMAM5z1ekBXON8Aac+G67zzdWkbWXwnXcC4NUIHhujGzKjBt7?=
 =?us-ascii?Q?yPgb9EWRNH/hiH056ls4LWKZE+Y89jgR2feruUYvzT+mBce0ZQX6yrvyN3zh?=
 =?us-ascii?Q?pb7e899cqOPn7jl/S7CgnDQHKCljOlNskWT37v5veiOWiA+CPWWzQ8waEfTc?=
 =?us-ascii?Q?LUY1OrwPnnCrhRfkWQKyeVhkBuZzs8Qva1eTVl1OfLuJPUVTmC2bDwubUN+h?=
 =?us-ascii?Q?mFwoB0HBYrBq55ulZCQOS5GFIqaAUK7yOBrmdT1UpWYZl74cFgz+ioPIH6uw?=
 =?us-ascii?Q?mM5ZJsWG6mluCJwkj1BkAlRwfaUdeGO9ybI3xgUpi/V6V7VRSv6m817HAW+u?=
 =?us-ascii?Q?JVadf8PgBb/l1B9HcnTAmeL8H/aksO3ShawZtgsxT679FY151u0wG1yAYSpi?=
 =?us-ascii?Q?8kAytyQq+FT86XKH2auvp7Tv9FhllGy0GXdT/WHUo3PEEgMn5SRvNA20pEwE?=
 =?us-ascii?Q?fXQxScJKXppTPSpYwVH/dgrmWXA6st2lbfMpEMo8+k9zdTjuAW5B4cgeqWo+?=
 =?us-ascii?Q?tDJBDJ0xCm7jfl9FMdvpHc4tbhaeMXypFv/Kw18+mFIpGp+8msKL9I7Cg/51?=
 =?us-ascii?Q?P2WDEJcFBihIXL7jATXc+F7oi1PrZ3iivL5kvXfHzndnyiEJqd63djyDZrld?=
 =?us-ascii?Q?tP9Ek72zgTEIe9y3l84vQDAzqpM8LoKncSwcVMVxIwXpxMwwd3+ZQC64dOK3?=
 =?us-ascii?Q?urmlqh9nLgBQkm+rdO0NBbkfUJa4EJcJAK9OfHbBN684LU9BJ/5/MV6ji94D?=
 =?us-ascii?Q?ZM/BGVDbrr2KtO0x/Eod0Xb9lEoYGuGQujQHvDecCnap+1XfMMRV8PkmYI7F?=
 =?us-ascii?Q?bXhuThwt3y0bMGjLXRW2cE/9jTlel4tkoNLs2Bi5buESgVxyXt63TakTBpCv?=
 =?us-ascii?Q?x9v8OLh/pNZDWdPL3bjve+7KpE0CfKBmSLePCyn8sEa7GEZCftF84jWSEtqQ?=
 =?us-ascii?Q?+dxih/ONdSM8tbbzI8BwUeyO7OwD8orSehRjGoNEaGSBbNUUt6U2pfjYp0dk?=
 =?us-ascii?Q?9lmL9EuVx2A7bdq6XAUSIeXXPlHLddiHEouLobsVBwFuFUWdx4U4Kev+YETk?=
 =?us-ascii?Q?iMKjm8lpp1QsVp46oGNcg6z4UHQSs2N24QA1BLN4Rm4o1IOacONqAv1x4LBQ?=
 =?us-ascii?Q?OsUdFv46j9ZjemQ6uIv7PCdocClNRzvIZ5ED7SjIQ7S7r5YAZAhFj9N/CInQ?=
 =?us-ascii?Q?mxivLmLnD1OZSIdw1B33Y6M9o0HbQ6GRW/cAHrCa1UYAF66s/LZMOqDrmcDx?=
 =?us-ascii?Q?IcuZJmibrAJJx0z+0mZKPNvvw1rchv6TxDGtDKHwiMUvwfgSdPN1Q5JkGaPl?=
 =?us-ascii?Q?zLngyOF2qYMdpmMm+LrEKsAyp1Sn1xN7ERfAE7RNkblrCe9yDuZ9BJSHTYPQ?=
 =?us-ascii?Q?uJJ0E1weJFo9pFNhzMpnpSUKkV+gZtdbZEaMoUyEpSBlCxGSx2jj3BkTVbEl?=
 =?us-ascii?Q?r6vBchg0W4H1LkyWAJQRr1g=3D?=
X-OriginatorOrg: purelifi.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 124f8dcf-84dc-4119-df09-08d9f7c29de6
X-MS-Exchange-CrossTenant-AuthSource: LO0P265MB3226.GBRP265.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 18:22:29.6692
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 5cf4eba2-7b8f-4236-bed4-a2ac41f1a6dc
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2IwXnoKFdaPGbOtvAlp8wjIJ+4GsTh4ZjtWK+sDUAi3dGut45wWNOk6mP3DflioSA59W7Kw9uoWJn2R9QjmK8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO2P265MB4631
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This driver implementation has been based on the zd1211rw driver

Driver is based on 802.11 softMAC Architecture and uses
native 802.11 for configuration and management

The driver is compiled and tested in ARM, x86 architectures and
compiled in powerpc architecture

Signed-off-by: Srinivasan Raju <srini.raju@purelifi.com>
---
 MAINTAINERS                                   |   6 +
 drivers/net/wireless/Kconfig                  |   1 +
 drivers/net/wireless/Makefile                 |   1 +
 drivers/net/wireless/purelifi/Kconfig         |  17 +
 drivers/net/wireless/purelifi/Makefile        |   2 +
 drivers/net/wireless/purelifi/plfxlc/Kconfig  |  14 +
 drivers/net/wireless/purelifi/plfxlc/Makefile |   3 +
 drivers/net/wireless/purelifi/plfxlc/chip.c   |  99 ++
 drivers/net/wireless/purelifi/plfxlc/chip.h   |  70 ++
 .../net/wireless/purelifi/plfxlc/firmware.c   | 276 ++++++
 drivers/net/wireless/purelifi/plfxlc/intf.h   |  52 +
 drivers/net/wireless/purelifi/plfxlc/mac.c    | 754 +++++++++++++++
 drivers/net/wireless/purelifi/plfxlc/mac.h    | 184 ++++
 drivers/net/wireless/purelifi/plfxlc/usb.c    | 892 ++++++++++++++++++
 drivers/net/wireless/purelifi/plfxlc/usb.h    | 198 ++++
 15 files changed, 2569 insertions(+)
 create mode 100644 drivers/net/wireless/purelifi/Kconfig
 create mode 100644 drivers/net/wireless/purelifi/Makefile
 create mode 100644 drivers/net/wireless/purelifi/plfxlc/Kconfig
 create mode 100644 drivers/net/wireless/purelifi/plfxlc/Makefile
 create mode 100644 drivers/net/wireless/purelifi/plfxlc/chip.c
 create mode 100644 drivers/net/wireless/purelifi/plfxlc/chip.h
 create mode 100644 drivers/net/wireless/purelifi/plfxlc/firmware.c
 create mode 100644 drivers/net/wireless/purelifi/plfxlc/intf.h
 create mode 100644 drivers/net/wireless/purelifi/plfxlc/mac.c
 create mode 100644 drivers/net/wireless/purelifi/plfxlc/mac.h
 create mode 100644 drivers/net/wireless/purelifi/plfxlc/usb.c
 create mode 100644 drivers/net/wireless/purelifi/plfxlc/usb.h

diff --git a/MAINTAINERS b/MAINTAINERS
index eeb4c70b3d5b..1d271e9e9223 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -15193,6 +15193,12 @@ T:	git git://linuxtv.org/media_tree.git
 F:	Documentation/admin-guide/media/pulse8-cec.rst
 F:	drivers/media/cec/usb/pulse8/
 
+PURELIFI USB DRIVER
+M:	Srinivasan Raju <srini.raju@purelifi.com>
+L:	linux-wireless@vger.kernel.org
+S:	Supported
+F:	drivers/net/wireless/purelifi/
+
 PVRUSB2 VIDEO4LINUX DRIVER
 M:	Mike Isely <isely@pobox.com>
 L:	pvrusb2@isely.net	(subscribers-only)
diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index 7add2002ff4c..404afe574920 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -28,6 +28,7 @@ source "drivers/net/wireless/intersil/Kconfig"
 source "drivers/net/wireless/marvell/Kconfig"
 source "drivers/net/wireless/mediatek/Kconfig"
 source "drivers/net/wireless/microchip/Kconfig"
+source "drivers/net/wireless/purelifi/Kconfig"
 source "drivers/net/wireless/ralink/Kconfig"
 source "drivers/net/wireless/realtek/Kconfig"
 source "drivers/net/wireless/rsi/Kconfig"
diff --git a/drivers/net/wireless/Makefile b/drivers/net/wireless/Makefile
index 80b324499786..e3345893c9c5 100644
--- a/drivers/net/wireless/Makefile
+++ b/drivers/net/wireless/Makefile
@@ -13,6 +13,7 @@ obj-$(CONFIG_WLAN_VENDOR_INTERSIL) += intersil/
 obj-$(CONFIG_WLAN_VENDOR_MARVELL) += marvell/
 obj-$(CONFIG_WLAN_VENDOR_MEDIATEK) += mediatek/
 obj-$(CONFIG_WLAN_VENDOR_MICROCHIP) += microchip/
+obj-$(CONFIG_WLAN_VENDOR_PURELIFI) += purelifi/
 obj-$(CONFIG_WLAN_VENDOR_RALINK) += ralink/
 obj-$(CONFIG_WLAN_VENDOR_REALTEK) += realtek/
 obj-$(CONFIG_WLAN_VENDOR_RSI) += rsi/
diff --git a/drivers/net/wireless/purelifi/Kconfig b/drivers/net/wireless/purelifi/Kconfig
new file mode 100644
index 000000000000..e39afec3dcae
--- /dev/null
+++ b/drivers/net/wireless/purelifi/Kconfig
@@ -0,0 +1,17 @@
+# SPDX-License-Identifier: GPL-2.0-only
+config WLAN_VENDOR_PURELIFI
+	bool "pureLiFi devices"
+	default y
+	help
+	  If you have a pureLiFi device, say Y.
+
+	  Note that the answer to this question doesn't directly affect the
+	  kernel: saying N will just cause the configurator to skip all the
+	  questions about these cards. If you say Y, you will be asked for
+	  your specific card in the following questions.
+
+if WLAN_VENDOR_PURELIFI
+
+source "drivers/net/wireless/purelifi/plfxlc/Kconfig"
+
+endif # WLAN_VENDOR_PURELIFI
diff --git a/drivers/net/wireless/purelifi/Makefile b/drivers/net/wireless/purelifi/Makefile
new file mode 100644
index 000000000000..56ebf96bd298
--- /dev/null
+++ b/drivers/net/wireless/purelifi/Makefile
@@ -0,0 +1,2 @@
+# SPDX-License-Identifier: GPL-2.0-only
+obj-$(CONFIG_PURELIFI_XLC)		:= plfxlc/
diff --git a/drivers/net/wireless/purelifi/plfxlc/Kconfig b/drivers/net/wireless/purelifi/plfxlc/Kconfig
new file mode 100644
index 000000000000..400ab2ee660c
--- /dev/null
+++ b/drivers/net/wireless/purelifi/plfxlc/Kconfig
@@ -0,0 +1,14 @@
+# SPDX-License-Identifier: GPL-2.0-only
+config PURELIFI_XLC
+	tristate "pureLiFi X, XL, XC device support"
+	depends on CFG80211 && MAC80211 && USB
+	help
+	   This option adds support for pureLiFi LiFi wireless USB adapters.
+
+	   The pureLiFi X, XL, XC USB devices are based on 802.11 OFDM PHY.
+
+	   Supports common 802.11 encryption/authentication methods including
+	   Open, WPA, WPA2-Personal and WPA2-Enterprise (802.1X).
+
+	   To compile this driver as a module, choose m here. The module will
+	   be called purelifi_xlc.
diff --git a/drivers/net/wireless/purelifi/plfxlc/Makefile b/drivers/net/wireless/purelifi/plfxlc/Makefile
new file mode 100644
index 000000000000..3d66f485c024
--- /dev/null
+++ b/drivers/net/wireless/purelifi/plfxlc/Makefile
@@ -0,0 +1,3 @@
+# SPDX-License-Identifier: GPL-2.0-only
+obj-$(CONFIG_PURELIFI_XLC)	:= purelifi_xlc.o
+purelifi_xlc-objs 		+= chip.o firmware.o usb.o mac.o
diff --git a/drivers/net/wireless/purelifi/plfxlc/chip.c b/drivers/net/wireless/purelifi/plfxlc/chip.c
new file mode 100644
index 000000000000..a5ec10b66ed5
--- /dev/null
+++ b/drivers/net/wireless/purelifi/plfxlc/chip.c
@@ -0,0 +1,99 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2021 pureLiFi
+ */
+
+#include <linux/kernel.h>
+#include <linux/errno.h>
+
+#include "chip.h"
+#include "mac.h"
+#include "usb.h"
+
+void plfxlc_chip_init(struct plfxlc_chip *chip,
+		      struct ieee80211_hw *hw,
+		      struct usb_interface *intf)
+{
+	memset(chip, 0, sizeof(*chip));
+	mutex_init(&chip->mutex);
+	plfxlc_usb_init(&chip->usb, hw, intf);
+}
+
+void plfxlc_chip_release(struct plfxlc_chip *chip)
+{
+	plfxlc_usb_release(&chip->usb);
+	mutex_destroy(&chip->mutex);
+}
+
+int plfxlc_set_beacon_interval(struct plfxlc_chip *chip, u16 interval,
+			       u8 dtim_period, int type)
+{
+	if (!interval ||
+	    (chip->beacon_set &&
+	     le16_to_cpu(chip->beacon_interval) == interval))
+		return 0;
+
+	chip->beacon_interval = cpu_to_le16(interval);
+	chip->beacon_set = true;
+	return plfxlc_usb_wreq(chip->usb.ez_usb,
+			       &chip->beacon_interval,
+			       sizeof(chip->beacon_interval),
+			       USB_REQ_BEACON_INTERVAL_WR);
+}
+
+int plfxlc_chip_init_hw(struct plfxlc_chip *chip)
+{
+	unsigned char *addr = plfxlc_mac_get_perm_addr(plfxlc_chip_to_mac(chip));
+	struct usb_device *udev = interface_to_usbdev(chip->usb.intf);
+
+	pr_info("plfxlc chip %04x:%04x v%02x %pM %s\n",
+		le16_to_cpu(udev->descriptor.idVendor),
+		le16_to_cpu(udev->descriptor.idProduct),
+		le16_to_cpu(udev->descriptor.bcdDevice),
+		addr,
+		plfxlc_speed(udev->speed));
+
+	return plfxlc_set_beacon_interval(chip, 100, 0, 0);
+}
+
+int plfxlc_chip_switch_radio(struct plfxlc_chip *chip, u16 value)
+{
+	int r;
+	__le16 radio_on = cpu_to_le16(value);
+
+	r = plfxlc_usb_wreq(chip->usb.ez_usb, &radio_on,
+			    sizeof(value), USB_REQ_POWER_WR);
+	if (r)
+		dev_err(plfxlc_chip_dev(chip), "POWER_WR failed (%d)\n", r);
+	return r;
+}
+
+int plfxlc_chip_enable_rxtx(struct plfxlc_chip *chip)
+{
+	plfxlc_usb_enable_tx(&chip->usb);
+	return plfxlc_usb_enable_rx(&chip->usb);
+}
+
+void plfxlc_chip_disable_rxtx(struct plfxlc_chip *chip)
+{
+	u8 value = 0;
+
+	plfxlc_usb_wreq(chip->usb.ez_usb,
+			&value, sizeof(value), USB_REQ_RXTX_WR);
+	plfxlc_usb_disable_rx(&chip->usb);
+	plfxlc_usb_disable_tx(&chip->usb);
+}
+
+int plfxlc_chip_set_rate(struct plfxlc_chip *chip, u8 rate)
+{
+	int r;
+
+	if (!chip)
+		return -EINVAL;
+
+	r = plfxlc_usb_wreq(chip->usb.ez_usb,
+			    &rate, sizeof(rate), USB_REQ_RATE_WR);
+	if (r)
+		dev_err(plfxlc_chip_dev(chip), "RATE_WR failed (%d)\n", r);
+	return r;
+}
diff --git a/drivers/net/wireless/purelifi/plfxlc/chip.h b/drivers/net/wireless/purelifi/plfxlc/chip.h
new file mode 100644
index 000000000000..f087bb364277
--- /dev/null
+++ b/drivers/net/wireless/purelifi/plfxlc/chip.h
@@ -0,0 +1,70 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2021 pureLiFi
+ */
+
+#ifndef _LF_X_CHIP_H
+#define _LF_X_CHIP_H
+
+#include <net/mac80211.h>
+
+#include "usb.h"
+
+enum unit_type {
+	STA = 0,
+	AP = 1,
+};
+
+enum {
+	PLFXLC_RADIO_OFF = 0,
+	PLFXLC_RADIO_ON = 1,
+};
+
+struct plfxlc_chip {
+	struct plfxlc_usb usb;
+	struct mutex mutex; /* lock to protect chip data */
+	enum unit_type unit_type;
+	u16 link_led;
+	u8 beacon_set;
+	u16 beacon_interval;
+};
+
+struct plfxlc_mc_hash {
+	u32 low;
+	u32 high;
+};
+
+#define plfxlc_chip_dev(chip) (&(chip)->usb.intf->dev)
+
+void plfxlc_chip_init(struct plfxlc_chip *chip,
+		      struct ieee80211_hw *hw,
+		      struct usb_interface *intf);
+
+void plfxlc_chip_release(struct plfxlc_chip *chip);
+
+void plfxlc_chip_disable_rxtx(struct plfxlc_chip *chip);
+
+int plfxlc_chip_init_hw(struct plfxlc_chip *chip);
+
+int plfxlc_chip_enable_rxtx(struct plfxlc_chip *chip);
+
+int plfxlc_chip_set_rate(struct plfxlc_chip *chip, u8 rate);
+
+int plfxlc_set_beacon_interval(struct plfxlc_chip *chip, u16 interval,
+			       u8 dtim_period, int type);
+
+int plfxlc_chip_switch_radio(struct plfxlc_chip *chip, u16 value);
+
+static inline struct plfxlc_chip *plfxlc_usb_to_chip(struct plfxlc_usb
+							 *usb)
+{
+	return container_of(usb, struct plfxlc_chip, usb);
+}
+
+static inline void plfxlc_mc_add_all(struct plfxlc_mc_hash *hash)
+{
+	hash->low  = 0xffffffff;
+	hash->high = 0xffffffff;
+}
+
+#endif /* _LF_X_CHIP_H */
diff --git a/drivers/net/wireless/purelifi/plfxlc/firmware.c b/drivers/net/wireless/purelifi/plfxlc/firmware.c
new file mode 100644
index 000000000000..69e08ce5f05c
--- /dev/null
+++ b/drivers/net/wireless/purelifi/plfxlc/firmware.c
@@ -0,0 +1,276 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2021 pureLiFi
+ */
+
+#include <linux/firmware.h>
+#include <linux/bitrev.h>
+
+#include "mac.h"
+#include "usb.h"
+
+static int send_vendor_request(struct usb_device *udev, int request,
+			       unsigned char *buffer, int buffer_size)
+{
+	return usb_control_msg(udev,
+			       usb_rcvctrlpipe(udev, 0),
+			       request, 0xC0, 0, 0,
+			       buffer, buffer_size, PLF_USB_TIMEOUT);
+}
+
+static int send_vendor_command(struct usb_device *udev, int request,
+			       unsigned char *buffer, int buffer_size)
+{
+	return usb_control_msg(udev,
+			       usb_sndctrlpipe(udev, 0),
+			       request, USB_TYPE_VENDOR /*0x40*/, 0, 0,
+			       buffer, buffer_size, PLF_USB_TIMEOUT);
+}
+
+int plfxlc_download_fpga(struct usb_interface *intf)
+{
+	struct usb_device *udev = interface_to_usbdev(intf);
+	unsigned char *fpga_dmabuff = NULL;
+	const struct firmware *fw = NULL;
+	int blk_tran_len = PLF_BULK_TLEN;
+	unsigned char *fw_data;
+	const char *fw_name;
+	int r, actual_length;
+	int fw_data_i = 0;
+
+	if ((le16_to_cpu(udev->descriptor.idVendor) ==
+				PURELIFI_X_VENDOR_ID_0) &&
+	    (le16_to_cpu(udev->descriptor.idProduct) ==
+				PURELIFI_X_PRODUCT_ID_0)) {
+		fw_name = "plfxlc/lifi-x.bin";
+		dev_dbg(&intf->dev, "bin file for X selected\n");
+
+	} else if ((le16_to_cpu(udev->descriptor.idVendor)) ==
+					PURELIFI_XC_VENDOR_ID_0 &&
+		   (le16_to_cpu(udev->descriptor.idProduct) ==
+					PURELIFI_XC_PRODUCT_ID_0)) {
+		fw_name = "plfxlc/lifi-xc.bin";
+		dev_dbg(&intf->dev, "bin file for XC selected\n");
+
+	} else {
+		r = -EINVAL;
+		goto error;
+	}
+
+	r = request_firmware(&fw, fw_name, &intf->dev);
+	if (r) {
+		dev_err(&intf->dev, "request_firmware failed (%d)\n", r);
+		goto error;
+	}
+	fpga_dmabuff = kmalloc(PLF_FPGA_STATUS_LEN, GFP_KERNEL);
+
+	if (!fpga_dmabuff) {
+		r = -ENOMEM;
+		goto error_free_fw;
+	}
+	send_vendor_request(udev, PLF_VNDR_FPGA_SET_REQ,
+			    fpga_dmabuff, PLF_FPGA_STATUS_LEN);
+
+	send_vendor_command(udev, PLF_VNDR_FPGA_SET_CMD, NULL, 0);
+
+	if (fpga_dmabuff[0] != PLF_FPGA_MG) {
+		dev_err(&intf->dev, "fpga_dmabuff[0] is wrong\n");
+		r = -EINVAL;
+		goto error_free_fw;
+	}
+
+	for (fw_data_i = 0; fw_data_i < fw->size;) {
+		int tbuf_idx;
+
+		if ((fw->size - fw_data_i) < blk_tran_len)
+			blk_tran_len = fw->size - fw_data_i;
+
+		fw_data = kmemdup(&fw->data[fw_data_i], blk_tran_len,
+				  GFP_KERNEL);
+		if (!fw_data) {
+			r = -ENOMEM;
+			goto error_free_fw;
+		}
+
+		for (tbuf_idx = 0; tbuf_idx < blk_tran_len; tbuf_idx++) {
+			/* u8 bit reverse */
+			fw_data[tbuf_idx] = bitrev8(fw_data[tbuf_idx]);
+		}
+		r = usb_bulk_msg(udev,
+				 usb_sndbulkpipe(interface_to_usbdev(intf),
+						 fpga_dmabuff[0] & 0xff),
+				 fw_data,
+				 blk_tran_len,
+				 &actual_length,
+				 2 * PLF_USB_TIMEOUT);
+
+		if (r)
+			dev_err(&intf->dev, "Bulk msg failed (%d)\n", r);
+
+		kfree(fw_data);
+		fw_data_i += blk_tran_len;
+	}
+
+	kfree(fpga_dmabuff);
+	fpga_dmabuff = kmalloc(PLF_FPGA_STATE_LEN, GFP_KERNEL);
+	if (!fpga_dmabuff) {
+		r = -ENOMEM;
+		goto error_free_fw;
+	}
+	memset(fpga_dmabuff, 0xff, PLF_FPGA_STATE_LEN);
+
+	send_vendor_request(udev, PLF_VNDR_FPGA_STATE_REQ, fpga_dmabuff,
+			    PLF_FPGA_STATE_LEN);
+
+	dev_dbg(&intf->dev, "%*ph\n", 8, fpga_dmabuff);
+
+	if (fpga_dmabuff[0] != 0) {
+		r = -EINVAL;
+		goto error_free_fw;
+	}
+
+	send_vendor_command(udev, PLF_VNDR_FPGA_STATE_CMD, NULL, 0);
+
+	msleep(PLF_MSLEEP_TIME);
+
+error_free_fw:
+	kfree(fpga_dmabuff);
+	release_firmware(fw);
+error:
+	return r;
+}
+
+int plfxlc_download_xl_firmware(struct usb_interface *intf)
+{
+	struct usb_device *udev = interface_to_usbdev(intf);
+	const struct firmware *fwp = NULL;
+	struct plfxlc_firmware_file file = {0};
+	const char *fw_pack;
+	int s, r;
+	u8 *buf;
+	u32 i;
+
+	r = send_vendor_command(udev, PLF_VNDR_XL_FW_CMD, NULL, 0);
+	msleep(PLF_MSLEEP_TIME);
+
+	if (r) {
+		dev_err(&intf->dev, "vendor command failed (%d)\n", r);
+		return -EINVAL;
+	}
+	/* Code for single pack file download */
+
+	fw_pack = "plfxlc/lifi-xl.bin";
+
+	r = request_firmware(&fwp, fw_pack, &intf->dev);
+	if (r) {
+		dev_err(&intf->dev, "Request_firmware failed (%d)\n", r);
+		return -EINVAL;
+	}
+	file.total_files = get_unaligned_le32(&fwp->data[0]);
+	file.total_size = get_unaligned_le32(&fwp->size);
+
+	dev_dbg(&intf->dev, "XL Firmware (%d, %d)\n",
+		file.total_files, file.total_size);
+
+	buf = kzalloc(PLF_XL_BUF_LEN, GFP_KERNEL);
+	if (!buf) {
+		release_firmware(fwp);
+		return -ENOMEM;
+	}
+
+	if (file.total_files > 10) {
+		dev_err(&intf->dev, "Too many files (%d)\n", file.total_files);
+		release_firmware(fwp);
+		kfree(buf);
+		return -EINVAL;
+	}
+
+	/* Download firmware files in multiple steps */
+	for (s = 0; s < file.total_files; s++) {
+		buf[0] = s;
+		r = send_vendor_command(udev, PLF_VNDR_XL_FILE_CMD, buf,
+					PLF_XL_BUF_LEN);
+
+		if (s < file.total_files - 1)
+			file.size = get_unaligned_le32(&fwp->data[4 + ((s + 1) * 4)])
+				    - get_unaligned_le32(&fwp->data[4 + (s) * 4]);
+		else
+			file.size = file.total_size -
+				    get_unaligned_le32(&fwp->data[4 + (s) * 4]);
+
+		if (file.size > file.total_size || file.size > 60000) {
+			dev_err(&intf->dev, "File size is too large (%d)\n", file.size);
+			break;
+		}
+
+		file.start_addr = get_unaligned_le32(&fwp->data[4 + (s * 4)]);
+
+		if (file.size % PLF_XL_BUF_LEN && s < 2)
+			file.size += PLF_XL_BUF_LEN - file.size % PLF_XL_BUF_LEN;
+
+		file.control_packets = file.size / PLF_XL_BUF_LEN;
+
+		for (i = 0; i < file.control_packets; i++) {
+			memcpy(buf,
+			       &fwp->data[file.start_addr + (i * PLF_XL_BUF_LEN)],
+			       PLF_XL_BUF_LEN);
+			r = send_vendor_command(udev, PLF_VNDR_XL_DATA_CMD, buf,
+						PLF_XL_BUF_LEN);
+		}
+		dev_dbg(&intf->dev, "fw-dw step=%d,r=%d size=%d\n", s, r,
+			file.size);
+	}
+	release_firmware(fwp);
+	kfree(buf);
+
+	/* Code for single pack file download ends fw download finish */
+
+	r = send_vendor_command(udev, PLF_VNDR_XL_EX_CMD, NULL, 0);
+	dev_dbg(&intf->dev, "Download fpga (4) (%d)\n", r);
+
+	return 0;
+}
+
+int upload_mac_and_serial(struct usb_interface *intf,
+			  unsigned char *hw_address,
+			  unsigned char *serial_number)
+{
+	struct usb_device *udev = interface_to_usbdev(intf);
+	unsigned long long firmware_version;
+	unsigned char *dma_buffer = NULL;
+
+	dma_buffer = kmalloc(PLF_SERIAL_LEN, GFP_KERNEL);
+	if (!dma_buffer)
+		return -ENOMEM;
+
+	BUILD_BUG_ON(ETH_ALEN > PLF_SERIAL_LEN);
+	BUILD_BUG_ON(PLF_FW_VER_LEN > PLF_SERIAL_LEN);
+
+	send_vendor_request(udev, PLF_MAC_VENDOR_REQUEST, dma_buffer,
+			    ETH_ALEN);
+
+	memcpy(hw_address, dma_buffer, ETH_ALEN);
+
+	send_vendor_request(udev, PLF_SERIAL_NUMBER_VENDOR_REQUEST,
+			    dma_buffer, PLF_SERIAL_LEN);
+
+	send_vendor_request(udev, PLF_SERIAL_NUMBER_VENDOR_REQUEST,
+			    dma_buffer, PLF_SERIAL_LEN);
+
+	memcpy(serial_number, dma_buffer, PLF_SERIAL_LEN);
+
+	memset(dma_buffer, 0x00, PLF_SERIAL_LEN);
+
+	send_vendor_request(udev, PLF_FIRMWARE_VERSION_VENDOR_REQUEST,
+			    (unsigned char *)dma_buffer, PLF_FW_VER_LEN);
+
+	memcpy(&firmware_version, dma_buffer, PLF_FW_VER_LEN);
+
+	dev_info(&intf->dev, "Firmware Version: %llu\n", firmware_version);
+	kfree(dma_buffer);
+
+	dev_dbg(&intf->dev, "Mac: %pM\n", hw_address);
+
+	return 0;
+}
+
diff --git a/drivers/net/wireless/purelifi/plfxlc/intf.h b/drivers/net/wireless/purelifi/plfxlc/intf.h
new file mode 100644
index 000000000000..5ae89343b579
--- /dev/null
+++ b/drivers/net/wireless/purelifi/plfxlc/intf.h
@@ -0,0 +1,52 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2021 pureLiFi
+ */
+
+#define PURELIFI_BYTE_NUM_ALIGNMENT 4
+#define ETH_ALEN 6
+#define AP_USER_LIMIT 8
+
+#define PLF_VNDR_FPGA_STATE_REQ 0x30
+#define PLF_VNDR_FPGA_SET_REQ 0x33
+#define PLF_VNDR_FPGA_SET_CMD 0x34
+#define PLF_VNDR_FPGA_STATE_CMD 0x35
+
+#define PLF_VNDR_XL_FW_CMD 0x80
+#define PLF_VNDR_XL_DATA_CMD 0x81
+#define PLF_VNDR_XL_FILE_CMD 0x82
+#define PLF_VNDR_XL_EX_CMD 0x83
+
+#define PLF_MAC_VENDOR_REQUEST 0x36
+#define PLF_SERIAL_NUMBER_VENDOR_REQUEST 0x37
+#define PLF_FIRMWARE_VERSION_VENDOR_REQUEST 0x39
+#define PLF_SERIAL_LEN 14
+#define PLF_FW_VER_LEN 8
+
+struct rx_status {
+	__be16 rssi;
+	u8     rate_idx;
+	u8     pad;
+	__be64 crc_error_count;
+} __packed;
+
+enum plf_usb_req_enum {
+	USB_REQ_TEST_WR            = 0,
+	USB_REQ_MAC_WR             = 1,
+	USB_REQ_POWER_WR           = 2,
+	USB_REQ_RXTX_WR            = 3,
+	USB_REQ_BEACON_WR          = 4,
+	USB_REQ_BEACON_INTERVAL_WR = 5,
+	USB_REQ_RTS_CTS_RATE_WR    = 6,
+	USB_REQ_HASH_WR            = 7,
+	USB_REQ_DATA_TX            = 8,
+	USB_REQ_RATE_WR            = 9,
+	USB_REQ_SET_FREQ           = 15
+};
+
+struct plf_usb_req {
+	__be32         id; /* should be plf_usb_req_enum */
+	__be32	       len;
+	u8             buf[512];
+};
+
diff --git a/drivers/net/wireless/purelifi/plfxlc/mac.c b/drivers/net/wireless/purelifi/plfxlc/mac.c
new file mode 100644
index 000000000000..90e552532701
--- /dev/null
+++ b/drivers/net/wireless/purelifi/plfxlc/mac.c
@@ -0,0 +1,754 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2021 pureLiFi
+ */
+
+#include <linux/netdevice.h>
+#include <linux/etherdevice.h>
+#include <linux/slab.h>
+#include <linux/usb.h>
+#include <linux/gpio.h>
+#include <linux/jiffies.h>
+#include <net/ieee80211_radiotap.h>
+
+#include "chip.h"
+#include "mac.h"
+#include "usb.h"
+
+static const struct ieee80211_rate plfxlc_rates[] = {
+	{ .bitrate = 10,
+		.hw_value = PURELIFI_CCK_RATE_1M,
+		.flags = 0 },
+	{ .bitrate = 20,
+		.hw_value = PURELIFI_CCK_RATE_2M,
+		.hw_value_short = PURELIFI_CCK_RATE_2M
+			| PURELIFI_CCK_PREA_SHORT,
+		.flags = IEEE80211_RATE_SHORT_PREAMBLE },
+	{ .bitrate = 55,
+		.hw_value = PURELIFI_CCK_RATE_5_5M,
+		.hw_value_short = PURELIFI_CCK_RATE_5_5M
+			| PURELIFI_CCK_PREA_SHORT,
+		.flags = IEEE80211_RATE_SHORT_PREAMBLE },
+	{ .bitrate = 110,
+		.hw_value = PURELIFI_CCK_RATE_11M,
+		.hw_value_short = PURELIFI_CCK_RATE_11M
+			| PURELIFI_CCK_PREA_SHORT,
+		.flags = IEEE80211_RATE_SHORT_PREAMBLE },
+	{ .bitrate = 60,
+		.hw_value = PURELIFI_OFDM_RATE_6M,
+		.flags = 0 },
+	{ .bitrate = 90,
+		.hw_value = PURELIFI_OFDM_RATE_9M,
+		.flags = 0 },
+	{ .bitrate = 120,
+		.hw_value = PURELIFI_OFDM_RATE_12M,
+		.flags = 0 },
+	{ .bitrate = 180,
+		.hw_value = PURELIFI_OFDM_RATE_18M,
+		.flags = 0 },
+	{ .bitrate = 240,
+		.hw_value = PURELIFI_OFDM_RATE_24M,
+		.flags = 0 },
+	{ .bitrate = 360,
+		.hw_value = PURELIFI_OFDM_RATE_36M,
+		.flags = 0 },
+	{ .bitrate = 480,
+		.hw_value = PURELIFI_OFDM_RATE_48M,
+		.flags = 0 },
+	{ .bitrate = 540,
+		.hw_value = PURELIFI_OFDM_RATE_54M,
+		.flags = 0 }
+};
+
+static const struct ieee80211_channel plfxlc_channels[] = {
+	{ .center_freq = 2412, .hw_value = 1 },
+	{ .center_freq = 2417, .hw_value = 2 },
+	{ .center_freq = 2422, .hw_value = 3 },
+	{ .center_freq = 2427, .hw_value = 4 },
+	{ .center_freq = 2432, .hw_value = 5 },
+	{ .center_freq = 2437, .hw_value = 6 },
+	{ .center_freq = 2442, .hw_value = 7 },
+	{ .center_freq = 2447, .hw_value = 8 },
+	{ .center_freq = 2452, .hw_value = 9 },
+	{ .center_freq = 2457, .hw_value = 10 },
+	{ .center_freq = 2462, .hw_value = 11 },
+	{ .center_freq = 2467, .hw_value = 12 },
+	{ .center_freq = 2472, .hw_value = 13 },
+	{ .center_freq = 2484, .hw_value = 14 },
+};
+
+int plfxlc_mac_preinit_hw(struct ieee80211_hw *hw, const u8 *hw_address)
+{
+	SET_IEEE80211_PERM_ADDR(hw, hw_address);
+	return 0;
+}
+
+int plfxlc_mac_init_hw(struct ieee80211_hw *hw)
+{
+	struct plfxlc_mac *mac = plfxlc_hw_mac(hw);
+	struct plfxlc_chip *chip = &mac->chip;
+	int r;
+
+	r = plfxlc_chip_init_hw(chip);
+	if (r) {
+		dev_warn(plfxlc_mac_dev(mac), "init hw failed (%d)\n", r);
+		return r;
+	}
+
+	dev_dbg(plfxlc_mac_dev(mac), "irq_disabled (%d)\n", irqs_disabled());
+	regulatory_hint(hw->wiphy, "00");
+	return r;
+}
+
+void plfxlc_mac_release(struct plfxlc_mac *mac)
+{
+	plfxlc_chip_release(&mac->chip);
+	lockdep_assert_held(&mac->lock);
+}
+
+int plfxlc_op_start(struct ieee80211_hw *hw)
+{
+	plfxlc_hw_mac(hw)->chip.usb.initialized = 1;
+	return 0;
+}
+
+void plfxlc_op_stop(struct ieee80211_hw *hw)
+{
+	struct plfxlc_mac *mac = plfxlc_hw_mac(hw);
+
+	clear_bit(PURELIFI_DEVICE_RUNNING, &mac->flags);
+}
+
+int plfxlc_restore_settings(struct plfxlc_mac *mac)
+{
+	int beacon_interval, beacon_period;
+	struct sk_buff *beacon;
+
+	spin_lock_irq(&mac->lock);
+	beacon_interval = mac->beacon.interval;
+	beacon_period = mac->beacon.period;
+	spin_unlock_irq(&mac->lock);
+
+	if (mac->type != NL80211_IFTYPE_ADHOC)
+		return 0;
+
+	if (mac->vif) {
+		beacon = ieee80211_beacon_get(mac->hw, mac->vif);
+		if (beacon) {
+			/*beacon is hardcoded in firmware */
+			kfree_skb(beacon);
+			/* Returned skb is used only once and lowlevel
+			 * driver is responsible for freeing it.
+			 */
+		}
+	}
+
+	plfxlc_set_beacon_interval(&mac->chip, beacon_interval,
+				   beacon_period, mac->type);
+
+	spin_lock_irq(&mac->lock);
+	mac->beacon.last_update = jiffies;
+	spin_unlock_irq(&mac->lock);
+
+	return 0;
+}
+
+static void plfxlc_mac_tx_status(struct ieee80211_hw *hw,
+				 struct sk_buff *skb,
+				 int ackssi,
+				 struct tx_status *tx_status)
+{
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	int success = 1;
+
+	ieee80211_tx_info_clear_status(info);
+	if (tx_status)
+		success = !tx_status->failure;
+
+	if (success)
+		info->flags |= IEEE80211_TX_STAT_ACK;
+	else
+		info->flags &= ~IEEE80211_TX_STAT_ACK;
+
+	info->status.ack_signal = 50;
+	ieee80211_tx_status_irqsafe(hw, skb);
+}
+
+void plfxlc_mac_tx_to_dev(struct sk_buff *skb, int error)
+{
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_hw *hw = info->rate_driver_data[0];
+	struct plfxlc_mac *mac = plfxlc_hw_mac(hw);
+	struct sk_buff_head *q = NULL;
+
+	ieee80211_tx_info_clear_status(info);
+	skb_pull(skb, sizeof(struct plfxlc_ctrlset));
+
+	if (unlikely(error ||
+		     (info->flags & IEEE80211_TX_CTL_NO_ACK))) {
+		ieee80211_tx_status_irqsafe(hw, skb);
+		return;
+	}
+
+	q = &mac->ack_wait_queue;
+
+	skb_queue_tail(q, skb);
+	while (skb_queue_len(q)/* > PURELIFI_MAC_MAX_ACK_WAITERS*/) {
+		plfxlc_mac_tx_status(hw, skb_dequeue(q),
+				     mac->ack_pending ?
+				     mac->ack_signal : 0,
+				     NULL);
+		mac->ack_pending = 0;
+	}
+}
+
+static int plfxlc_fill_ctrlset(struct plfxlc_mac *mac, struct sk_buff *skb)
+{
+	unsigned int frag_len = skb->len;
+	struct plfxlc_ctrlset *cs;
+	u32 temp_payload_len = 0;
+	unsigned int tmp;
+	u32 temp_len = 0;
+
+	if (skb_headroom(skb) < sizeof(struct plfxlc_ctrlset)) {
+		dev_dbg(plfxlc_mac_dev(mac), "Not enough hroom(1)\n");
+		return 1;
+	}
+
+	cs = (void *)skb_push(skb, sizeof(struct plfxlc_ctrlset));
+	temp_payload_len = frag_len;
+	temp_len = temp_payload_len +
+		  sizeof(struct plfxlc_ctrlset) -
+		  sizeof(cs->id) - sizeof(cs->len);
+
+	/* Data packet lengths must be multiple of four bytes and must
+	 * not be a multiple of 512 bytes. First, it is attempted to
+	 * append the data packet in the tailroom of the skb. In rare
+	 * occasions, the tailroom is too small. In this case, the
+	 * content of the packet is shifted into the headroom of the skb
+	 * by memcpy. Headroom is allocated at startup (below in this
+	 * file). Therefore, there will be always enough headroom. The
+	 * call skb_headroom is an additional safety which might be
+	 * dropped.
+	 */
+	/* check if 32 bit aligned and align data */
+	tmp = skb->len & 3;
+	if (tmp) {
+		if (skb_tailroom(skb) < (3 - tmp)) {
+			if (skb_headroom(skb) >= 4 - tmp) {
+				u8 len;
+				u8 *src_pt;
+				u8 *dest_pt;
+
+				len = skb->len;
+				src_pt = skb->data;
+				dest_pt = skb_push(skb, 4 - tmp);
+				memmove(dest_pt, src_pt, len);
+			} else {
+				return -ENOBUFS;
+			}
+		} else {
+			skb_put(skb, 4 - tmp);
+		}
+		temp_len += 4 - tmp;
+	}
+
+	/* check if not multiple of 512 and align data */
+	tmp = skb->len & 0x1ff;
+	if (!tmp) {
+		if (skb_tailroom(skb) < 4) {
+			if (skb_headroom(skb) >= 4) {
+				u8 len = skb->len;
+				u8 *src_pt = skb->data;
+				u8 *dest_pt = skb_push(skb, 4);
+
+				memmove(dest_pt, src_pt, len);
+			} else {
+				/* should never happen because
+				 * sufficient headroom was reserved
+				 */
+				return -ENOBUFS;
+			}
+		} else {
+			skb_put(skb, 4);
+		}
+		temp_len += 4;
+	}
+
+	cs->id = cpu_to_be32(USB_REQ_DATA_TX);
+	cs->len = cpu_to_be32(temp_len);
+	cs->payload_len_nw = cpu_to_be32(temp_payload_len);
+
+	return 0;
+}
+
+static void plfxlc_op_tx(struct ieee80211_hw *hw,
+			 struct ieee80211_tx_control *control,
+			 struct sk_buff *skb)
+{
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct plfxlc_header *plhdr = (void *)skb->data;
+	struct plfxlc_mac *mac = plfxlc_hw_mac(hw);
+	struct plfxlc_usb *usb = &mac->chip.usb;
+	unsigned long flags;
+	int r;
+
+	r = plfxlc_fill_ctrlset(mac, skb);
+	if (r)
+		goto fail;
+
+	info->rate_driver_data[0] = hw;
+
+	if (plhdr->frametype  == IEEE80211_FTYPE_DATA) {
+		u8 *dst_mac = plhdr->dmac;
+		u8 sidx;
+		bool found = false;
+		struct plfxlc_usb_tx *tx = &usb->tx;
+
+		for (sidx = 0; sidx < MAX_STA_NUM; sidx++) {
+			if (!(tx->station[sidx].flag & STATION_CONNECTED_FLAG))
+				continue;
+			if (memcmp(tx->station[sidx].mac, dst_mac, ETH_ALEN))
+				continue;
+			found = true;
+			break;
+		}
+
+		/* Default to broadcast address for unknown MACs */
+		if (!found)
+			sidx = STA_BROADCAST_INDEX;
+
+		/* Stop OS from sending packets, if the queue is half full */
+		if (skb_queue_len(&tx->station[sidx].data_list) > 60)
+			ieee80211_stop_queues(plfxlc_usb_to_hw(usb));
+
+		/* Schedule packet for transmission if queue is not full */
+		if (skb_queue_len(&tx->station[sidx].data_list) > 256)
+			goto fail;
+		skb_queue_tail(&tx->station[sidx].data_list, skb);
+		plfxlc_send_packet_from_data_queue(usb);
+
+	} else {
+		spin_lock_irqsave(&usb->tx.lock, flags);
+		r = plfxlc_usb_wreq_async(&mac->chip.usb, skb->data, skb->len,
+					  USB_REQ_DATA_TX, plfxlc_tx_urb_complete, skb);
+		spin_unlock_irqrestore(&usb->tx.lock, flags);
+		if (r)
+			goto fail;
+	}
+	return;
+
+fail:
+	dev_kfree_skb(skb);
+}
+
+static int plfxlc_filter_ack(struct ieee80211_hw *hw, struct ieee80211_hdr *rx_hdr,
+			     struct ieee80211_rx_status *stats)
+{
+	struct plfxlc_mac *mac = plfxlc_hw_mac(hw);
+	struct sk_buff_head *q;
+	int i, position = 0;
+	unsigned long flags;
+	struct sk_buff *skb;
+	bool found = false;
+
+	if (!ieee80211_is_ack(rx_hdr->frame_control))
+		return 0;
+
+	dev_dbg(plfxlc_mac_dev(mac), "ACK Received\n");
+
+	/* code based on zy driver, this logic may need fix */
+	q = &mac->ack_wait_queue;
+	spin_lock_irqsave(&q->lock, flags);
+
+	skb_queue_walk(q, skb) {
+		struct ieee80211_hdr *tx_hdr;
+
+		position++;
+
+		if (mac->ack_pending && skb_queue_is_first(q, skb))
+			continue;
+		if (mac->ack_pending == 0)
+			break;
+
+		tx_hdr = (struct ieee80211_hdr *)skb->data;
+		if (likely(ether_addr_equal(tx_hdr->addr2, rx_hdr->addr1))) {
+			found = 1;
+			break;
+		}
+	}
+
+	if (found) {
+		for (i = 1; i < position; i++)
+			skb = __skb_dequeue(q);
+		if (i == position) {
+			plfxlc_mac_tx_status(hw, skb,
+					     mac->ack_pending ?
+					     mac->ack_signal : 0,
+					     NULL);
+			mac->ack_pending = 0;
+		}
+
+		mac->ack_pending = skb_queue_len(q) ? 1 : 0;
+		mac->ack_signal = stats->signal;
+	}
+
+	spin_unlock_irqrestore(&q->lock, flags);
+	return 1;
+}
+
+int plfxlc_mac_rx(struct ieee80211_hw *hw, const u8 *buffer,
+		  unsigned int length)
+{
+	struct plfxlc_mac *mac = plfxlc_hw_mac(hw);
+	struct ieee80211_rx_status stats;
+	const struct rx_status *status;
+	unsigned int payload_length;
+	struct plfxlc_usb_tx *tx;
+	struct sk_buff *skb;
+	int need_padding;
+	__le16 fc;
+	int sidx;
+
+	/* Packet blockade during disabled interface. */
+	if (!mac->vif)
+		return 0;
+
+	status = (struct rx_status *)buffer;
+
+	memset(&stats, 0, sizeof(stats));
+
+	stats.flag     = 0;
+	stats.freq     = 2412;
+	stats.band     = NL80211_BAND_LC;
+	mac->rssi      = -15 * be16_to_cpu(status->rssi) / 10;
+
+	stats.signal   = mac->rssi;
+
+	if (status->rate_idx > 7)
+		stats.rate_idx = 0;
+	else
+		stats.rate_idx = status->rate_idx;
+
+	mac->crc_errors = be64_to_cpu(status->crc_error_count);
+
+	/* TODO bad frame check for CRC error*/
+	if (plfxlc_filter_ack(hw, (struct ieee80211_hdr *)buffer, &stats) &&
+	    !mac->pass_ctrl)
+		return 0;
+
+	buffer += sizeof(struct rx_status);
+	payload_length = get_unaligned_be32(buffer);
+
+	if (payload_length > 1560) {
+		dev_err(plfxlc_mac_dev(mac), " > MTU %u\n", payload_length);
+		return 0;
+	}
+	buffer += sizeof(u32);
+
+	fc = get_unaligned((__le16 *)buffer);
+	need_padding = ieee80211_is_data_qos(fc) ^ ieee80211_has_a4(fc);
+
+	tx = &mac->chip.usb.tx;
+
+	for (sidx = 0; sidx < MAX_STA_NUM - 1; sidx++) {
+		if (memcmp(&buffer[10], tx->station[sidx].mac, ETH_ALEN))
+			continue;
+		if (tx->station[sidx].flag & STATION_CONNECTED_FLAG) {
+			tx->station[sidx].flag |= STATION_HEARTBEAT_FLAG;
+			break;
+		}
+	}
+
+	if (sidx == MAX_STA_NUM - 1) {
+		for (sidx = 0; sidx < MAX_STA_NUM - 1; sidx++) {
+			if (tx->station[sidx].flag & STATION_CONNECTED_FLAG)
+				continue;
+			memcpy(tx->station[sidx].mac, &buffer[10], ETH_ALEN);
+			tx->station[sidx].flag |= STATION_CONNECTED_FLAG;
+			tx->station[sidx].flag |= STATION_HEARTBEAT_FLAG;
+			break;
+		}
+	}
+
+	switch (buffer[0]) {
+	case IEEE80211_STYPE_PROBE_REQ:
+		dev_dbg(plfxlc_mac_dev(mac), "Probe request\n");
+		break;
+	case IEEE80211_STYPE_ASSOC_REQ:
+		dev_dbg(plfxlc_mac_dev(mac), "Association request\n");
+		break;
+	case IEEE80211_STYPE_AUTH:
+		dev_dbg(plfxlc_mac_dev(mac), "Authentication req\n");
+		break;
+	case IEEE80211_FTYPE_DATA:
+		dev_dbg(plfxlc_mac_dev(mac), "802.11 data frame\n");
+		break;
+	}
+
+	skb = dev_alloc_skb(payload_length + (need_padding ? 2 : 0));
+	if (!skb)
+		return -ENOMEM;
+
+	if (need_padding)
+		/* Make sure that the payload data is 4 byte aligned. */
+		skb_reserve(skb, 2);
+
+	skb_put_data(skb, buffer, payload_length);
+	memcpy(IEEE80211_SKB_RXCB(skb), &stats, sizeof(stats));
+	ieee80211_rx_irqsafe(hw, skb);
+	return 0;
+}
+
+static int plfxlc_op_add_interface(struct ieee80211_hw *hw,
+				   struct ieee80211_vif *vif)
+{
+	struct plfxlc_mac *mac = plfxlc_hw_mac(hw);
+	static const char * const iftype80211[] = {
+		[NL80211_IFTYPE_STATION]	= "Station",
+		[NL80211_IFTYPE_ADHOC]		= "Adhoc"
+	};
+
+	if (mac->type != NL80211_IFTYPE_UNSPECIFIED)
+		return -EOPNOTSUPP;
+
+	if (vif->type == NL80211_IFTYPE_ADHOC ||
+	    vif->type == NL80211_IFTYPE_STATION) {
+		dev_dbg(plfxlc_mac_dev(mac), "%s %s\n", __func__,
+			iftype80211[vif->type]);
+		mac->type = vif->type;
+		mac->vif = vif;
+		return 0;
+	}
+	dev_dbg(plfxlc_mac_dev(mac), "unsupported iftype\n");
+	return -EOPNOTSUPP;
+}
+
+static void plfxlc_op_remove_interface(struct ieee80211_hw *hw,
+				       struct ieee80211_vif *vif)
+{
+	struct plfxlc_mac *mac = plfxlc_hw_mac(hw);
+
+	mac->type = NL80211_IFTYPE_UNSPECIFIED;
+	mac->vif = NULL;
+}
+
+static int plfxlc_op_config(struct ieee80211_hw *hw, u32 changed)
+{
+	return 0;
+}
+
+#define SUPPORTED_FIF_FLAGS \
+	(FIF_ALLMULTI | FIF_FCSFAIL | FIF_CONTROL | \
+	 FIF_OTHER_BSS | FIF_BCN_PRBRESP_PROMISC)
+static void plfxlc_op_configure_filter(struct ieee80211_hw *hw,
+				       unsigned int changed_flags,
+				       unsigned int *new_flags,
+				       u64 multicast)
+{
+	struct plfxlc_mc_hash hash = {
+		.low = multicast,
+		.high = multicast >> 32,
+	};
+	struct plfxlc_mac *mac = plfxlc_hw_mac(hw);
+	unsigned long flags;
+
+	/* Only deal with supported flags */
+	*new_flags &= SUPPORTED_FIF_FLAGS;
+
+	/* If multicast parameter
+	 * (as returned by plfxlc_op_prepare_multicast)
+	 * has changed, no bit in changed_flags is set. To handle this
+	 * situation, we do not return if changed_flags is 0. If we do so,
+	 * we will have some issue with IPv6 which uses multicast for link
+	 * layer address resolution.
+	 */
+	if (*new_flags & (FIF_ALLMULTI))
+		plfxlc_mc_add_all(&hash);
+
+	spin_lock_irqsave(&mac->lock, flags);
+	mac->pass_failed_fcs = !!(*new_flags & FIF_FCSFAIL);
+	mac->pass_ctrl = !!(*new_flags & FIF_CONTROL);
+	mac->multicast_hash = hash;
+	spin_unlock_irqrestore(&mac->lock, flags);
+
+	/* no handling required for FIF_OTHER_BSS as we don't currently
+	 * do BSSID filtering
+	 */
+	/* FIXME: in future it would be nice to enable the probe response
+	 * filter (so that the driver doesn't see them) until
+	 * FIF_BCN_PRBRESP_PROMISC is set. however due to atomicity here, we'd
+	 * have to schedule work to enable prbresp reception, which might
+	 * happen too late. For now we'll just listen and forward them all the
+	 * time.
+	 */
+}
+
+static void plfxlc_op_bss_info_changed(struct ieee80211_hw *hw,
+				       struct ieee80211_vif *vif,
+				       struct ieee80211_bss_conf *bss_conf,
+				       u32 changes)
+{
+	struct plfxlc_mac *mac = plfxlc_hw_mac(hw);
+	int associated;
+
+	dev_dbg(plfxlc_mac_dev(mac), "changes: %x\n", changes);
+
+	if (mac->type != NL80211_IFTYPE_ADHOC) { /* for STATION */
+		associated = is_valid_ether_addr(bss_conf->bssid);
+		goto exit_all;
+	}
+	/* for ADHOC */
+	associated = true;
+	if (changes & BSS_CHANGED_BEACON) {
+		struct sk_buff *beacon = ieee80211_beacon_get(hw, vif);
+
+		if (beacon) {
+			/*beacon is hardcoded in firmware */
+			kfree_skb(beacon);
+			/*Returned skb is used only once and
+			 * low-level driver is
+			 * responsible for freeing it.
+			 */
+		}
+	}
+
+	if (changes & BSS_CHANGED_BEACON_ENABLED) {
+		u16 interval = 0;
+		u8 period = 0;
+
+		if (bss_conf->enable_beacon) {
+			period = bss_conf->dtim_period;
+			interval = bss_conf->beacon_int;
+		}
+
+		spin_lock_irq(&mac->lock);
+		mac->beacon.period = period;
+		mac->beacon.interval = interval;
+		mac->beacon.last_update = jiffies;
+		spin_unlock_irq(&mac->lock);
+
+		plfxlc_set_beacon_interval(&mac->chip, interval,
+					   period, mac->type);
+	}
+exit_all:
+	spin_lock_irq(&mac->lock);
+	mac->associated = associated;
+	spin_unlock_irq(&mac->lock);
+}
+
+static int plfxlc_get_stats(struct ieee80211_hw *hw,
+			    struct ieee80211_low_level_stats *stats)
+{
+	stats->dot11ACKFailureCount = 0;
+	stats->dot11RTSFailureCount = 0;
+	stats->dot11FCSErrorCount   = 0;
+	stats->dot11RTSSuccessCount = 0;
+	return 0;
+}
+
+static const char et_strings[][ETH_GSTRING_LEN] = {
+	"phy_rssi",
+	"phy_rx_crc_err"
+};
+
+static int plfxlc_get_et_sset_count(struct ieee80211_hw *hw,
+				    struct ieee80211_vif *vif, int sset)
+{
+	if (sset == ETH_SS_STATS)
+		return ARRAY_SIZE(et_strings);
+
+	return 0;
+}
+
+static void plfxlc_get_et_strings(struct ieee80211_hw *hw,
+				  struct ieee80211_vif *vif,
+				  u32 sset, u8 *data)
+{
+	if (sset == ETH_SS_STATS)
+		memcpy(data, *et_strings, sizeof(et_strings));
+}
+
+static void plfxlc_get_et_stats(struct ieee80211_hw *hw,
+				struct ieee80211_vif *vif,
+				struct ethtool_stats *stats, u64 *data)
+{
+	struct plfxlc_mac *mac = plfxlc_hw_mac(hw);
+
+	data[0] = mac->rssi;
+	data[1] = mac->crc_errors;
+}
+
+static int plfxlc_set_rts_threshold(struct ieee80211_hw *hw, u32 value)
+{
+	return 0;
+}
+
+static const struct ieee80211_ops plfxlc_ops = {
+	.tx = plfxlc_op_tx,
+	.start = plfxlc_op_start,
+	.stop = plfxlc_op_stop,
+	.add_interface = plfxlc_op_add_interface,
+	.remove_interface = plfxlc_op_remove_interface,
+	.set_rts_threshold = plfxlc_set_rts_threshold,
+	.config = plfxlc_op_config,
+	.configure_filter = plfxlc_op_configure_filter,
+	.bss_info_changed = plfxlc_op_bss_info_changed,
+	.get_stats = plfxlc_get_stats,
+	.get_et_sset_count = plfxlc_get_et_sset_count,
+	.get_et_stats = plfxlc_get_et_stats,
+	.get_et_strings = plfxlc_get_et_strings,
+};
+
+struct ieee80211_hw *plfxlc_mac_alloc_hw(struct usb_interface *intf)
+{
+	struct ieee80211_hw *hw;
+	struct plfxlc_mac *mac;
+
+	hw = ieee80211_alloc_hw(sizeof(struct plfxlc_mac), &plfxlc_ops);
+	if (!hw) {
+		dev_dbg(&intf->dev, "out of memory\n");
+		return NULL;
+	}
+	set_wiphy_dev(hw->wiphy, &intf->dev);
+
+	mac = plfxlc_hw_mac(hw);
+	memset(mac, 0, sizeof(*mac));
+	spin_lock_init(&mac->lock);
+	mac->hw = hw;
+
+	mac->type = NL80211_IFTYPE_UNSPECIFIED;
+
+	memcpy(mac->channels, plfxlc_channels, sizeof(plfxlc_channels));
+	memcpy(mac->rates, plfxlc_rates, sizeof(plfxlc_rates));
+	mac->band.n_bitrates = ARRAY_SIZE(plfxlc_rates);
+	mac->band.bitrates = mac->rates;
+	mac->band.n_channels = ARRAY_SIZE(plfxlc_channels);
+	mac->band.channels = mac->channels;
+	hw->wiphy->bands[NL80211_BAND_LC] = &mac->band;
+	hw->conf.chandef.width = NL80211_CHAN_WIDTH_20;
+
+	ieee80211_hw_set(hw, RX_INCLUDES_FCS);
+	ieee80211_hw_set(hw, SIGNAL_DBM);
+	ieee80211_hw_set(hw, HOST_BROADCAST_PS_BUFFERING);
+	ieee80211_hw_set(hw, MFP_CAPABLE);
+
+	hw->wiphy->interface_modes =
+		BIT(NL80211_IFTYPE_STATION) |
+		BIT(NL80211_IFTYPE_ADHOC);
+	hw->max_signal = 100;
+	hw->queues = 1;
+	/* 4 for 32 bit alignment if no tailroom */
+	hw->extra_tx_headroom = sizeof(struct plfxlc_ctrlset) + 4;
+	/* Tell mac80211 that we support multi rate retries */
+	hw->max_rates = IEEE80211_TX_MAX_RATES;
+	hw->max_rate_tries = 18;   /* 9 rates * 2 retries/rate */
+
+	skb_queue_head_init(&mac->ack_wait_queue);
+	mac->ack_pending = 0;
+
+	plfxlc_chip_init(&mac->chip, hw, intf);
+
+	SET_IEEE80211_DEV(hw, &intf->dev);
+	return hw;
+}
diff --git a/drivers/net/wireless/purelifi/plfxlc/mac.h b/drivers/net/wireless/purelifi/plfxlc/mac.h
new file mode 100644
index 000000000000..ae1ba221e4f1
--- /dev/null
+++ b/drivers/net/wireless/purelifi/plfxlc/mac.h
@@ -0,0 +1,184 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2021 pureLiFi
+ */
+
+#ifndef _PURELIFI_MAC_H
+#define _PURELIFI_MAC_H
+
+#include <linux/kernel.h>
+#include <net/mac80211.h>
+
+#include "chip.h"
+
+#define PURELIFI_CCK                  0x00
+#define PURELIFI_OFDM                 0x10
+#define PURELIFI_CCK_PREA_SHORT       0x20
+
+#define PURELIFI_OFDM_PLCP_RATE_6M	0xb
+#define PURELIFI_OFDM_PLCP_RATE_9M	0xf
+#define PURELIFI_OFDM_PLCP_RATE_12M	0xa
+#define PURELIFI_OFDM_PLCP_RATE_18M	0xe
+#define PURELIFI_OFDM_PLCP_RATE_24M	0x9
+#define PURELIFI_OFDM_PLCP_RATE_36M	0xd
+#define PURELIFI_OFDM_PLCP_RATE_48M	0x8
+#define PURELIFI_OFDM_PLCP_RATE_54M	0xc
+
+#define PURELIFI_CCK_RATE_1M	(PURELIFI_CCK | 0x00)
+#define PURELIFI_CCK_RATE_2M	(PURELIFI_CCK | 0x01)
+#define PURELIFI_CCK_RATE_5_5M	(PURELIFI_CCK | 0x02)
+#define PURELIFI_CCK_RATE_11M	(PURELIFI_CCK | 0x03)
+#define PURELIFI_OFDM_RATE_6M	(PURELIFI_OFDM | PURELIFI_OFDM_PLCP_RATE_6M)
+#define PURELIFI_OFDM_RATE_9M	(PURELIFI_OFDM | PURELIFI_OFDM_PLCP_RATE_9M)
+#define PURELIFI_OFDM_RATE_12M	(PURELIFI_OFDM | PURELIFI_OFDM_PLCP_RATE_12M)
+#define PURELIFI_OFDM_RATE_18M	(PURELIFI_OFDM | PURELIFI_OFDM_PLCP_RATE_18M)
+#define PURELIFI_OFDM_RATE_24M	(PURELIFI_OFDM | PURELIFI_OFDM_PLCP_RATE_24M)
+#define PURELIFI_OFDM_RATE_36M	(PURELIFI_OFDM | PURELIFI_OFDM_PLCP_RATE_36M)
+#define PURELIFI_OFDM_RATE_48M	(PURELIFI_OFDM | PURELIFI_OFDM_PLCP_RATE_48M)
+#define PURELIFI_OFDM_RATE_54M	(PURELIFI_OFDM | PURELIFI_OFDM_PLCP_RATE_54M)
+
+#define PURELIFI_RX_ERROR		0x80
+#define PURELIFI_RX_CRC32_ERROR		0x10
+
+#define PLF_REGDOMAIN_FCC	0x10
+#define PLF_REGDOMAIN_IC	0x20
+#define PLF_REGDOMAIN_ETSI	0x30
+#define PLF_REGDOMAIN_SPAIN	0x31
+#define PLF_REGDOMAIN_FRANCE	0x32
+#define PLF_REGDOMAIN_JAPAN_2	0x40
+#define PLF_REGDOMAIN_JAPAN	0x41
+#define PLF_REGDOMAIN_JAPAN_3	0x49
+
+#define PLF_RX_ERROR		0x80
+#define PLF_RX_CRC32_ERROR	0x10
+
+enum {
+	MODULATION_RATE_BPSK_1_2 = 0,
+	MODULATION_RATE_BPSK_3_4,
+	MODULATION_RATE_QPSK_1_2,
+	MODULATION_RATE_QPSK_3_4,
+	MODULATION_RATE_QAM16_1_2,
+	MODULATION_RATE_QAM16_3_4,
+	MODULATION_RATE_QAM64_1_2,
+	MODULATION_RATE_QAM64_3_4,
+	MODULATION_RATE_AUTO,
+	MODULATION_RATE_NUM
+};
+
+#define plfxlc_mac_dev(mac) plfxlc_chip_dev(&(mac)->chip)
+
+#define PURELIFI_MAC_STATS_BUFFER_SIZE 16
+#define PURELIFI_MAC_MAX_ACK_WAITERS 50
+
+struct plfxlc_ctrlset {
+	/* id should be plf_usb_req_enum */
+	__be32		id;
+	__be32		len;
+	u8		modulation;
+	u8		control;
+	u8		service;
+	u8		pad;
+	__le16		packet_length;
+	__le16		current_length;
+	__le16		next_frame_length;
+	__le16		tx_length;
+	__be32		payload_len_nw;
+} __packed;
+
+/* overlay */
+struct plfxlc_header {
+	struct plfxlc_ctrlset plf_ctrl;
+	u32    frametype;
+	u8    *dmac;
+} __packed;
+
+struct tx_status {
+	u8 type;
+	u8 id;
+	u8 rate;
+	u8 pad;
+	u8 mac[ETH_ALEN];
+	u8 retry;
+	u8 failure;
+} __packed;
+
+struct beacon {
+	struct delayed_work watchdog_work;
+	struct sk_buff *cur_beacon;
+	unsigned long last_update;
+	u16 interval;
+	u8 period;
+};
+
+enum plfxlc_device_flags {
+	PURELIFI_DEVICE_RUNNING,
+};
+
+struct plfxlc_mac {
+	struct ieee80211_hw *hw;
+	struct ieee80211_vif *vif;
+	struct beacon beacon;
+	struct work_struct set_rts_cts_work;
+	struct work_struct process_intr;
+	struct plfxlc_mc_hash multicast_hash;
+	struct sk_buff_head ack_wait_queue;
+	struct ieee80211_channel channels[14];
+	struct ieee80211_rate rates[12];
+	struct ieee80211_supported_band band;
+	struct plfxlc_chip chip;
+	spinlock_t lock; /* lock for mac data */
+	u8 intr_buffer[USB_MAX_EP_INT_BUFFER];
+	char serial_number[PURELIFI_SERIAL_LEN];
+	unsigned char hw_address[ETH_ALEN];
+	u8 default_regdomain;
+	unsigned long flags;
+	bool pass_failed_fcs;
+	bool pass_ctrl;
+	bool ack_pending;
+	int ack_signal;
+	int associated;
+	u8 regdomain;
+	u8 channel;
+	int type;
+	u64 crc_errors;
+	u64 rssi;
+};
+
+static inline struct plfxlc_mac *
+plfxlc_hw_mac(struct ieee80211_hw *hw)
+{
+	return hw->priv;
+}
+
+static inline struct plfxlc_mac *
+plfxlc_chip_to_mac(struct plfxlc_chip *chip)
+{
+	return container_of(chip, struct plfxlc_mac, chip);
+}
+
+static inline struct plfxlc_mac *
+plfxlc_usb_to_mac(struct plfxlc_usb *usb)
+{
+	return plfxlc_chip_to_mac(plfxlc_usb_to_chip(usb));
+}
+
+static inline u8 *plfxlc_mac_get_perm_addr(struct plfxlc_mac *mac)
+{
+	return mac->hw->wiphy->perm_addr;
+}
+
+struct ieee80211_hw *plfxlc_mac_alloc_hw(struct usb_interface *intf);
+void plfxlc_mac_release(struct plfxlc_mac *mac);
+
+int plfxlc_mac_preinit_hw(struct ieee80211_hw *hw, const u8 *hw_address);
+int plfxlc_mac_init_hw(struct ieee80211_hw *hw);
+
+int plfxlc_mac_rx(struct ieee80211_hw *hw, const u8 *buffer,
+		  unsigned int length);
+void plfxlc_mac_tx_failed(struct urb *urb);
+void plfxlc_mac_tx_to_dev(struct sk_buff *skb, int error);
+int plfxlc_op_start(struct ieee80211_hw *hw);
+void plfxlc_op_stop(struct ieee80211_hw *hw);
+int plfxlc_restore_settings(struct plfxlc_mac *mac);
+
+#endif
diff --git a/drivers/net/wireless/purelifi/plfxlc/usb.c b/drivers/net/wireless/purelifi/plfxlc/usb.c
new file mode 100644
index 000000000000..a8a830ad69c1
--- /dev/null
+++ b/drivers/net/wireless/purelifi/plfxlc/usb.c
@@ -0,0 +1,892 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2021 pureLiFi
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/device.h>
+#include <linux/errno.h>
+#include <linux/slab.h>
+#include <linux/skbuff.h>
+#include <linux/usb.h>
+#include <linux/workqueue.h>
+#include <linux/proc_fs.h>
+#include <linux/fs.h>
+#include <linux/string.h>
+#include <linux/module.h>
+#include <net/mac80211.h>
+#include <asm/unaligned.h>
+#include <linux/version.h>
+#include <linux/sysfs.h>
+
+#include "mac.h"
+#include "usb.h"
+#include "chip.h"
+
+static const struct usb_device_id usb_ids[] = {
+	{ USB_DEVICE(PURELIFI_X_VENDOR_ID_0, PURELIFI_X_PRODUCT_ID_0),
+	  .driver_info = DEVICE_LIFI_X },
+	{ USB_DEVICE(PURELIFI_XC_VENDOR_ID_0, PURELIFI_XC_PRODUCT_ID_0),
+	  .driver_info = DEVICE_LIFI_XC },
+	{ USB_DEVICE(PURELIFI_XL_VENDOR_ID_0, PURELIFI_XL_PRODUCT_ID_0),
+	  .driver_info = DEVICE_LIFI_XL },
+	{}
+};
+
+void plfxlc_send_packet_from_data_queue(struct plfxlc_usb *usb)
+{
+	struct plfxlc_usb_tx *tx = &usb->tx;
+	struct sk_buff *skb = NULL;
+	unsigned long flags;
+	u8 last_served_sidx;
+
+	spin_lock_irqsave(&tx->lock, flags);
+	last_served_sidx = usb->sidx;
+	do {
+		usb->sidx = (usb->sidx + 1) % MAX_STA_NUM;
+		if (!(tx->station[usb->sidx].flag & STATION_CONNECTED_FLAG))
+			continue;
+		if (!(tx->station[usb->sidx].flag & STATION_FIFO_FULL_FLAG))
+			skb = skb_peek(&tx->station[usb->sidx].data_list);
+	} while ((usb->sidx != last_served_sidx) && (!skb));
+
+	if (skb) {
+		skb = skb_dequeue(&tx->station[usb->sidx].data_list);
+		plfxlc_usb_wreq_async(usb, skb->data, skb->len, USB_REQ_DATA_TX,
+				      plfxlc_tx_urb_complete, skb);
+		if (skb_queue_len(&tx->station[usb->sidx].data_list) <= 60)
+			ieee80211_wake_queues(plfxlc_usb_to_hw(usb));
+	}
+	spin_unlock_irqrestore(&tx->lock, flags);
+}
+
+static void handle_rx_packet(struct plfxlc_usb *usb, const u8 *buffer,
+			     unsigned int length)
+{
+	plfxlc_mac_rx(plfxlc_usb_to_hw(usb), buffer, length);
+}
+
+static void rx_urb_complete(struct urb *urb)
+{
+	struct plfxlc_usb_tx *tx;
+	struct plfxlc_usb *usb;
+	unsigned int length;
+	const u8 *buffer;
+	u16 status;
+	u8 sidx;
+	int r;
+
+	if (!urb) {
+		pr_err("urb is NULL\n");
+		return;
+	}
+	if (!urb->context) {
+		pr_err("urb ctx is NULL\n");
+		return;
+	}
+	usb = urb->context;
+
+	if (usb->initialized != 1) {
+		pr_err("usb is not initialized\n");
+		return;
+	}
+
+	tx = &usb->tx;
+	switch (urb->status) {
+	case 0:
+		break;
+	case -ESHUTDOWN:
+	case -EINVAL:
+	case -ENODEV:
+	case -ENOENT:
+	case -ECONNRESET:
+	case -EPIPE:
+		dev_dbg(plfxlc_urb_dev(urb), "urb %p error %d\n", urb, urb->status);
+		return;
+	default:
+		dev_dbg(plfxlc_urb_dev(urb), "urb %p error %d\n", urb, urb->status);
+		if (tx->submitted_urbs++ < PURELIFI_URB_RETRY_MAX) {
+			dev_dbg(plfxlc_urb_dev(urb), "urb %p resubmit %d", urb,
+				tx->submitted_urbs++);
+			goto resubmit;
+		} else {
+			dev_dbg(plfxlc_urb_dev(urb), "urb %p  max resubmits reached", urb);
+			tx->submitted_urbs = 0;
+			return;
+		}
+	}
+
+	buffer = urb->transfer_buffer;
+	length = le32_to_cpu(*(__le32 *)(buffer + sizeof(struct rx_status)))
+		 + sizeof(u32);
+
+	if (urb->actual_length != (PLF_MSG_STATUS_OFFSET + 1)) {
+		if (usb->initialized && usb->link_up)
+			handle_rx_packet(usb, buffer, length);
+		goto resubmit;
+	}
+
+	status = buffer[PLF_MSG_STATUS_OFFSET];
+
+	switch (status) {
+	case STATION_FIFO_ALMOST_FULL_NOT_MESSAGE:
+		dev_dbg(&usb->intf->dev,
+			"FIFO full not packet receipt\n");
+		tx->mac_fifo_full = 1;
+		for (sidx = 0; sidx < MAX_STA_NUM; sidx++)
+			tx->station[sidx].flag |= STATION_FIFO_FULL_FLAG;
+		break;
+	case STATION_FIFO_ALMOST_FULL_MESSAGE:
+		dev_dbg(&usb->intf->dev, "FIFO full packet receipt\n");
+
+		for (sidx = 0; sidx < MAX_STA_NUM; sidx++)
+			tx->station[sidx].flag &= STATION_ACTIVE_FLAG;
+
+		plfxlc_send_packet_from_data_queue(usb);
+		break;
+	case STATION_CONNECT_MESSAGE:
+		usb->link_up = 1;
+		dev_dbg(&usb->intf->dev, "ST_CONNECT_MSG packet receipt\n");
+		break;
+	case STATION_DISCONNECT_MESSAGE:
+		usb->link_up = 0;
+		dev_dbg(&usb->intf->dev, "ST_DISCONN_MSG packet receipt\n");
+		break;
+	default:
+		dev_dbg(&usb->intf->dev, "Unknown packet receipt\n");
+		break;
+	}
+
+resubmit:
+	r = usb_submit_urb(urb, GFP_ATOMIC);
+	if (r)
+		dev_dbg(plfxlc_urb_dev(urb), "urb %p resubmit fail (%d)\n", urb, r);
+}
+
+static struct urb *alloc_rx_urb(struct plfxlc_usb *usb)
+{
+	struct usb_device *udev = plfxlc_usb_to_usbdev(usb);
+	struct urb *urb;
+	void *buffer;
+
+	urb = usb_alloc_urb(0, GFP_KERNEL);
+	if (!urb)
+		return NULL;
+
+	buffer = usb_alloc_coherent(udev, USB_MAX_RX_SIZE, GFP_KERNEL,
+				    &urb->transfer_dma);
+	if (!buffer) {
+		usb_free_urb(urb);
+		return NULL;
+	}
+
+	usb_fill_bulk_urb(urb, udev, usb_rcvbulkpipe(udev, EP_DATA_IN),
+			  buffer, USB_MAX_RX_SIZE,
+			  rx_urb_complete, usb);
+	urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
+
+	return urb;
+}
+
+static void free_rx_urb(struct urb *urb)
+{
+	if (!urb)
+		return;
+	usb_free_coherent(urb->dev, urb->transfer_buffer_length,
+			  urb->transfer_buffer, urb->transfer_dma);
+	usb_free_urb(urb);
+}
+
+static int __lf_x_usb_enable_rx(struct plfxlc_usb *usb)
+{
+	struct plfxlc_usb_rx *rx = &usb->rx;
+	struct urb **urbs;
+	int i, r;
+
+	r = -ENOMEM;
+	urbs = kcalloc(RX_URBS_COUNT, sizeof(struct urb *), GFP_KERNEL);
+	if (!urbs)
+		goto error;
+
+	for (i = 0; i < RX_URBS_COUNT; i++) {
+		urbs[i] = alloc_rx_urb(usb);
+		if (!urbs[i])
+			goto error;
+	}
+
+	spin_lock_irq(&rx->lock);
+
+	dev_dbg(plfxlc_usb_dev(usb), "irq_disabled %d\n", irqs_disabled());
+
+	if (rx->urbs) {
+		spin_unlock_irq(&rx->lock);
+		r = 0;
+		goto error;
+	}
+	rx->urbs = urbs;
+	rx->urbs_count = RX_URBS_COUNT;
+	spin_unlock_irq(&rx->lock);
+
+	for (i = 0; i < RX_URBS_COUNT; i++) {
+		r = usb_submit_urb(urbs[i], GFP_KERNEL);
+		if (r)
+			goto error_submit;
+	}
+
+	return 0;
+
+error_submit:
+	for (i = 0; i < RX_URBS_COUNT; i++)
+		usb_kill_urb(urbs[i]);
+	spin_lock_irq(&rx->lock);
+	rx->urbs = NULL;
+	rx->urbs_count = 0;
+	spin_unlock_irq(&rx->lock);
+error:
+	if (urbs) {
+		for (i = 0; i < RX_URBS_COUNT; i++)
+			free_rx_urb(urbs[i]);
+	}
+	return r;
+}
+
+int plfxlc_usb_enable_rx(struct plfxlc_usb *usb)
+{
+	struct plfxlc_usb_rx *rx = &usb->rx;
+	int r;
+
+	mutex_lock(&rx->setup_mutex);
+	r = __lf_x_usb_enable_rx(usb);
+	if (!r)
+		usb->rx_usb_enabled = 1;
+
+	mutex_unlock(&rx->setup_mutex);
+
+	return r;
+}
+
+static void __lf_x_usb_disable_rx(struct plfxlc_usb *usb)
+{
+	struct plfxlc_usb_rx *rx = &usb->rx;
+	unsigned long flags;
+	unsigned int count;
+	struct urb **urbs;
+	int i;
+
+	spin_lock_irqsave(&rx->lock, flags);
+	urbs = rx->urbs;
+	count = rx->urbs_count;
+	spin_unlock_irqrestore(&rx->lock, flags);
+
+	if (!urbs)
+		return;
+
+	for (i = 0; i < count; i++) {
+		usb_kill_urb(urbs[i]);
+		free_rx_urb(urbs[i]);
+	}
+	kfree(urbs);
+	rx->urbs = NULL;
+	rx->urbs_count = 0;
+}
+
+void plfxlc_usb_disable_rx(struct plfxlc_usb *usb)
+{
+	struct plfxlc_usb_rx *rx = &usb->rx;
+
+	mutex_lock(&rx->setup_mutex);
+	__lf_x_usb_disable_rx(usb);
+	usb->rx_usb_enabled = 0;
+	mutex_unlock(&rx->setup_mutex);
+}
+
+void plfxlc_usb_disable_tx(struct plfxlc_usb *usb)
+{
+	struct plfxlc_usb_tx *tx = &usb->tx;
+	unsigned long flags;
+
+	clear_bit(PLF_BIT_ENABLED, &tx->enabled);
+
+	/* kill all submitted tx-urbs */
+	usb_kill_anchored_urbs(&tx->submitted);
+
+	spin_lock_irqsave(&tx->lock, flags);
+	WARN_ON(!skb_queue_empty(&tx->submitted_skbs));
+	WARN_ON(tx->submitted_urbs != 0);
+	tx->submitted_urbs = 0;
+	spin_unlock_irqrestore(&tx->lock, flags);
+
+	/* The stopped state is ignored, relying on ieee80211_wake_queues()
+	 * in a potentionally following plfxlc_usb_enable_tx().
+	 */
+}
+
+void plfxlc_usb_enable_tx(struct plfxlc_usb *usb)
+{
+	struct plfxlc_usb_tx *tx = &usb->tx;
+	unsigned long flags;
+
+	spin_lock_irqsave(&tx->lock, flags);
+	set_bit(PLF_BIT_ENABLED, &tx->enabled);
+	tx->submitted_urbs = 0;
+	ieee80211_wake_queues(plfxlc_usb_to_hw(usb));
+	tx->stopped = 0;
+	spin_unlock_irqrestore(&tx->lock, flags);
+}
+
+void plfxlc_tx_urb_complete(struct urb *urb)
+{
+	struct ieee80211_tx_info *info;
+	struct plfxlc_usb *usb;
+	struct sk_buff *skb;
+
+	skb = urb->context;
+	info = IEEE80211_SKB_CB(skb);
+	/* grab 'usb' pointer before handing off the skb (since
+	 * it might be freed by plfxlc_mac_tx_to_dev or mac80211)
+	 */
+	usb = &plfxlc_hw_mac(info->rate_driver_data[0])->chip.usb;
+
+	switch (urb->status) {
+	case 0:
+		break;
+	case -ESHUTDOWN:
+	case -EINVAL:
+	case -ENODEV:
+	case -ENOENT:
+	case -ECONNRESET:
+	case -EPIPE:
+		dev_dbg(plfxlc_urb_dev(urb), "urb %p error %d\n", urb, urb->status);
+		break;
+	default:
+		dev_dbg(plfxlc_urb_dev(urb), "urb %p error %d\n", urb, urb->status);
+		return;
+	}
+
+	plfxlc_mac_tx_to_dev(skb, urb->status);
+	plfxlc_send_packet_from_data_queue(usb);
+	usb_free_urb(urb);
+}
+
+static inline void init_usb_rx(struct plfxlc_usb *usb)
+{
+	struct plfxlc_usb_rx *rx = &usb->rx;
+
+	spin_lock_init(&rx->lock);
+	mutex_init(&rx->setup_mutex);
+
+	if (interface_to_usbdev(usb->intf)->speed == USB_SPEED_HIGH)
+		rx->usb_packet_size = 512;
+	else
+		rx->usb_packet_size = 64;
+
+	if (rx->fragment_length != 0)
+		dev_dbg(plfxlc_usb_dev(usb), "fragment_length error\n");
+}
+
+static inline void init_usb_tx(struct plfxlc_usb *usb)
+{
+	struct plfxlc_usb_tx *tx = &usb->tx;
+
+	spin_lock_init(&tx->lock);
+	clear_bit(PLF_BIT_ENABLED, &tx->enabled);
+	tx->stopped = 0;
+	skb_queue_head_init(&tx->submitted_skbs);
+	init_usb_anchor(&tx->submitted);
+}
+
+void plfxlc_usb_init(struct plfxlc_usb *usb, struct ieee80211_hw *hw,
+		     struct usb_interface *intf)
+{
+	memset(usb, 0, sizeof(*usb));
+	usb->intf = usb_get_intf(intf);
+	usb_set_intfdata(usb->intf, hw);
+	init_usb_tx(usb);
+	init_usb_rx(usb);
+}
+
+void plfxlc_usb_release(struct plfxlc_usb *usb)
+{
+	plfxlc_op_stop(plfxlc_usb_to_hw(usb));
+	plfxlc_usb_disable_tx(usb);
+	plfxlc_usb_disable_rx(usb);
+	usb_set_intfdata(usb->intf, NULL);
+	usb_put_intf(usb->intf);
+}
+
+const char *plfxlc_speed(enum usb_device_speed speed)
+{
+	switch (speed) {
+	case USB_SPEED_LOW:
+		return "low";
+	case USB_SPEED_FULL:
+		return "full";
+	case USB_SPEED_HIGH:
+		return "high";
+	default:
+		return "unknown";
+	}
+}
+
+int plfxlc_usb_init_hw(struct plfxlc_usb *usb)
+{
+	int r;
+
+	r = usb_reset_configuration(plfxlc_usb_to_usbdev(usb));
+	if (r) {
+		dev_err(plfxlc_usb_dev(usb), "cfg reset failed (%d)\n", r);
+		return r;
+	}
+	return 0;
+}
+
+static void get_usb_req(struct usb_device *udev, void *buffer,
+			u32 buffer_len, enum plf_usb_req_enum usb_req_id,
+			struct plf_usb_req *usb_req)
+{
+	__be32 payload_len_nw = cpu_to_be32(buffer_len + FCS_LEN);
+	const u8 *buffer_src_p = buffer;
+	u8 *buffer_dst = usb_req->buf;
+	u32 temp_usb_len = 0;
+
+	usb_req->id = cpu_to_be32(usb_req_id);
+	usb_req->len  = cpu_to_be32(0);
+
+	/* Copy buffer length into the transmitted buffer, as it is important
+	 * for the Rx MAC to know its exact length.
+	 */
+	if (usb_req->id == cpu_to_be32(USB_REQ_BEACON_WR)) {
+		memcpy(buffer_dst, &payload_len_nw, sizeof(payload_len_nw));
+		buffer_dst += sizeof(payload_len_nw);
+		temp_usb_len += sizeof(payload_len_nw);
+	}
+
+	memcpy(buffer_dst, buffer_src_p, buffer_len);
+	buffer_dst += buffer_len;
+	buffer_src_p += buffer_len;
+	temp_usb_len +=  buffer_len;
+
+	/* Set the FCS_LEN (4) bytes as 0 for CRC checking. */
+	memset(buffer_dst, 0, FCS_LEN);
+	buffer_dst += FCS_LEN;
+	temp_usb_len += FCS_LEN;
+
+	/* Round the packet to be transmitted to 4 bytes. */
+	if (temp_usb_len % PURELIFI_BYTE_NUM_ALIGNMENT) {
+		memset(buffer_dst, 0, PURELIFI_BYTE_NUM_ALIGNMENT -
+		       (temp_usb_len %
+			PURELIFI_BYTE_NUM_ALIGNMENT));
+		buffer_dst += PURELIFI_BYTE_NUM_ALIGNMENT -
+				(temp_usb_len %
+				PURELIFI_BYTE_NUM_ALIGNMENT);
+		temp_usb_len += PURELIFI_BYTE_NUM_ALIGNMENT -
+				(temp_usb_len % PURELIFI_BYTE_NUM_ALIGNMENT);
+	}
+
+	usb_req->len = cpu_to_be32(temp_usb_len);
+}
+
+int plfxlc_usb_wreq_async(struct plfxlc_usb *usb, const u8 *buffer,
+			  int buffer_len, enum plf_usb_req_enum usb_req_id,
+			  usb_complete_t complete_fn,
+			  void *context)
+{
+	struct usb_device *udev = interface_to_usbdev(usb->ez_usb);
+	struct urb *urb = usb_alloc_urb(0, GFP_ATOMIC);
+	int r;
+
+	usb_fill_bulk_urb(urb, udev, usb_sndbulkpipe(udev, EP_DATA_OUT),
+			  (void *)buffer, buffer_len, complete_fn, context);
+
+	r = usb_submit_urb(urb, GFP_ATOMIC);
+	if (r)
+		dev_err(&udev->dev, "Async write submit failed (%d)\n", r);
+
+	return r;
+}
+
+int plfxlc_usb_wreq(struct usb_interface *ez_usb, void *buffer, int buffer_len,
+		    enum plf_usb_req_enum usb_req_id)
+{
+	struct usb_device *udev = interface_to_usbdev(ez_usb);
+	unsigned char *dma_buffer = NULL;
+	struct plf_usb_req usb_req;
+	int usb_bulk_msg_len;
+	int actual_length;
+	int r;
+
+	get_usb_req(udev, buffer, buffer_len, usb_req_id, &usb_req);
+	usb_bulk_msg_len = sizeof(__le32) + sizeof(__le32) +
+			   be32_to_cpu(usb_req.len);
+
+	dma_buffer = kmemdup(&usb_req, usb_bulk_msg_len, GFP_KERNEL);
+
+	if (!dma_buffer) {
+		r = -ENOMEM;
+		goto error;
+	}
+
+	r = usb_bulk_msg(udev,
+			 usb_sndbulkpipe(udev, EP_DATA_OUT),
+			 dma_buffer, usb_bulk_msg_len,
+			 &actual_length, USB_BULK_MSG_TIMEOUT_MS);
+	kfree(dma_buffer);
+error:
+	if (r) {
+		r = -ENOMEM;
+		dev_err(&udev->dev, "usb_bulk_msg failed (%d)\n", r);
+	}
+
+	return r;
+}
+
+static void slif_data_plane_sap_timer_callb(struct timer_list *t)
+{
+	struct plfxlc_usb *usb = from_timer(usb, t, tx.tx_retry_timer);
+
+	plfxlc_send_packet_from_data_queue(usb);
+	timer_setup(&usb->tx.tx_retry_timer,
+		    slif_data_plane_sap_timer_callb, 0);
+	mod_timer(&usb->tx.tx_retry_timer, jiffies + TX_RETRY_BACKOFF_JIFF);
+}
+
+static void sta_queue_cleanup_timer_callb(struct timer_list *t)
+{
+	struct plfxlc_usb *usb = from_timer(usb, t, sta_queue_cleanup);
+	struct plfxlc_usb_tx *tx = &usb->tx;
+	int sidx;
+
+	for (sidx = 0; sidx < MAX_STA_NUM - 1; sidx++) {
+		if (!(tx->station[sidx].flag & STATION_CONNECTED_FLAG))
+			continue;
+		if (tx->station[sidx].flag & STATION_HEARTBEAT_FLAG) {
+			tx->station[sidx].flag ^= STATION_HEARTBEAT_FLAG;
+		} else {
+			memset(tx->station[sidx].mac, 0, ETH_ALEN);
+			tx->station[sidx].flag = 0;
+		}
+	}
+	timer_setup(&usb->sta_queue_cleanup,
+		    sta_queue_cleanup_timer_callb, 0);
+	mod_timer(&usb->sta_queue_cleanup, jiffies + STA_QUEUE_CLEANUP_JIFF);
+}
+
+static int probe(struct usb_interface *intf,
+		 const struct usb_device_id *id)
+{
+	u8 serial_number[PURELIFI_SERIAL_LEN];
+	struct ieee80211_hw *hw = NULL;
+	struct plfxlc_usb_tx *tx;
+	struct plfxlc_chip *chip;
+	struct plfxlc_usb *usb;
+	u8 hw_address[ETH_ALEN];
+	unsigned int i;
+	int r = 0;
+
+	hw = plfxlc_mac_alloc_hw(intf);
+
+	if (!hw) {
+		r = -ENOMEM;
+		goto error;
+	}
+
+	chip = &plfxlc_hw_mac(hw)->chip;
+	usb = &chip->usb;
+	usb->ez_usb = intf;
+	tx = &usb->tx;
+
+	r = upload_mac_and_serial(intf, hw_address, serial_number);
+	if (r) {
+		dev_err(&intf->dev, "MAC and Serial upload failed (%d)\n", r);
+		goto error;
+	}
+
+	chip->unit_type = STA;
+	dev_err(&intf->dev, "Unit type is station");
+
+	r = plfxlc_mac_preinit_hw(hw, hw_address);
+	if (r) {
+		dev_err(&intf->dev, "Init mac failed (%d)\n", r);
+		goto error;
+	}
+
+	r = ieee80211_register_hw(hw);
+	if (r) {
+		dev_err(&intf->dev, "Register device failed (%d)\n", r);
+		goto error;
+	}
+
+	if ((le16_to_cpu(interface_to_usbdev(intf)->descriptor.idVendor) ==
+				PURELIFI_XL_VENDOR_ID_0) &&
+	    (le16_to_cpu(interface_to_usbdev(intf)->descriptor.idProduct) ==
+				PURELIFI_XL_PRODUCT_ID_0)) {
+		r = plfxlc_download_xl_firmware(intf);
+	} else {
+		r = plfxlc_download_fpga(intf);
+	}
+	if (r != 0) {
+		dev_err(&intf->dev, "FPGA download failed (%d)\n", r);
+		goto error;
+	}
+
+	tx->mac_fifo_full = 0;
+	spin_lock_init(&tx->lock);
+
+	msleep(PLF_MSLEEP_TIME);
+	r = plfxlc_usb_init_hw(usb);
+	if (r < 0) {
+		dev_err(&intf->dev, "usb_init_hw failed (%d)\n", r);
+		goto error;
+	}
+
+	msleep(PLF_MSLEEP_TIME);
+	r = plfxlc_chip_switch_radio(chip, PLFXLC_RADIO_ON);
+	if (r < 0) {
+		dev_dbg(&intf->dev, "chip_switch_radio_on failed (%d)\n", r);
+		goto error;
+	}
+
+	msleep(PLF_MSLEEP_TIME);
+	r = plfxlc_chip_set_rate(chip, 8);
+	if (r < 0) {
+		dev_dbg(&intf->dev, "chip_set_rate failed (%d)\n", r);
+		goto error;
+	}
+
+	msleep(PLF_MSLEEP_TIME);
+	r = plfxlc_usb_wreq(usb->ez_usb,
+			    hw_address, ETH_ALEN, USB_REQ_MAC_WR);
+	if (r < 0) {
+		dev_dbg(&intf->dev, "MAC_WR failure (%d)\n", r);
+		goto error;
+	}
+
+	plfxlc_chip_enable_rxtx(chip);
+
+	/* Initialise the data plane Tx queue */
+	for (i = 0; i < MAX_STA_NUM; i++) {
+		skb_queue_head_init(&tx->station[i].data_list);
+		tx->station[i].flag = 0;
+	}
+
+	tx->station[STA_BROADCAST_INDEX].flag |= STATION_CONNECTED_FLAG;
+	for (i = 0; i < ETH_ALEN; i++)
+		tx->station[STA_BROADCAST_INDEX].mac[i] = 0xFF;
+
+	timer_setup(&tx->tx_retry_timer, slif_data_plane_sap_timer_callb, 0);
+	tx->tx_retry_timer.expires = jiffies + TX_RETRY_BACKOFF_JIFF;
+	add_timer(&tx->tx_retry_timer);
+
+	timer_setup(&usb->sta_queue_cleanup,
+		    sta_queue_cleanup_timer_callb, 0);
+	usb->sta_queue_cleanup.expires = jiffies + STA_QUEUE_CLEANUP_JIFF;
+	add_timer(&usb->sta_queue_cleanup);
+
+	plfxlc_mac_init_hw(hw);
+	usb->initialized = true;
+	return 0;
+error:
+	if (hw) {
+		plfxlc_mac_release(plfxlc_hw_mac(hw));
+		ieee80211_unregister_hw(hw);
+		ieee80211_free_hw(hw);
+	}
+	dev_err(&intf->dev, "pureLifi:Device error");
+	return r;
+}
+
+static void disconnect(struct usb_interface *intf)
+{
+	struct ieee80211_hw *hw = plfxlc_intf_to_hw(intf);
+	struct plfxlc_mac *mac;
+	struct plfxlc_usb *usb;
+
+	/* Either something really bad happened, or
+	 * we're just dealing with a DEVICE_INSTALLER.
+	 */
+	if (!hw)
+		return;
+
+	mac = plfxlc_hw_mac(hw);
+	usb = &mac->chip.usb;
+
+	del_timer_sync(&usb->tx.tx_retry_timer);
+	del_timer_sync(&usb->sta_queue_cleanup);
+
+	ieee80211_unregister_hw(hw);
+
+	plfxlc_chip_disable_rxtx(&mac->chip);
+
+	/* If the disconnect has been caused by a removal of the
+	 * driver module, the reset allows reloading of the driver. If the
+	 * reset will not be executed here, the upload of the firmware in the
+	 * probe function caused by the reloading of the driver will fail.
+	 */
+	usb_reset_device(interface_to_usbdev(intf));
+
+	plfxlc_mac_release(mac);
+	ieee80211_free_hw(hw);
+}
+
+static void plfxlc_usb_resume(struct plfxlc_usb *usb)
+{
+	struct plfxlc_mac *mac = plfxlc_usb_to_mac(usb);
+	int r;
+
+	r = plfxlc_op_start(plfxlc_usb_to_hw(usb));
+	if (r < 0) {
+		dev_warn(plfxlc_usb_dev(usb),
+			 "Device resume failed (%d)\n", r);
+
+		if (usb->was_running)
+			set_bit(PURELIFI_DEVICE_RUNNING, &mac->flags);
+
+		usb_queue_reset_device(usb->intf);
+		return;
+	}
+
+	if (mac->type != NL80211_IFTYPE_UNSPECIFIED) {
+		r = plfxlc_restore_settings(mac);
+		if (r < 0) {
+			dev_dbg(plfxlc_usb_dev(usb),
+				"Restore failed (%d)\n", r);
+			return;
+		}
+	}
+}
+
+static void plfxlc_usb_stop(struct plfxlc_usb *usb)
+{
+	plfxlc_op_stop(plfxlc_usb_to_hw(usb));
+	plfxlc_usb_disable_tx(usb);
+	plfxlc_usb_disable_rx(usb);
+
+	usb->initialized = false;
+}
+
+static int pre_reset(struct usb_interface *intf)
+{
+	struct ieee80211_hw *hw = usb_get_intfdata(intf);
+	struct plfxlc_mac *mac;
+	struct plfxlc_usb *usb;
+
+	if (!hw || intf->condition != USB_INTERFACE_BOUND)
+		return 0;
+
+	mac = plfxlc_hw_mac(hw);
+	usb = &mac->chip.usb;
+
+	usb->was_running = test_bit(PURELIFI_DEVICE_RUNNING, &mac->flags);
+
+	plfxlc_usb_stop(usb);
+
+	return 0;
+}
+
+static int post_reset(struct usb_interface *intf)
+{
+	struct ieee80211_hw *hw = usb_get_intfdata(intf);
+	struct plfxlc_mac *mac;
+	struct plfxlc_usb *usb;
+
+	if (!hw || intf->condition != USB_INTERFACE_BOUND)
+		return 0;
+
+	mac = plfxlc_hw_mac(hw);
+	usb = &mac->chip.usb;
+
+	if (usb->was_running)
+		plfxlc_usb_resume(usb);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM
+
+static struct plfxlc_usb *get_plfxlc_usb(struct usb_interface *intf)
+{
+	struct ieee80211_hw *hw = plfxlc_intf_to_hw(intf);
+	struct plfxlc_mac *mac;
+
+	/* Either something really bad happened, or
+	 * we're just dealing with a DEVICE_INSTALLER.
+	 */
+	if (!hw)
+		return NULL;
+
+	mac = plfxlc_hw_mac(hw);
+	return &mac->chip.usb;
+}
+
+static int suspend(struct usb_interface *interface,
+		   pm_message_t message)
+{
+	struct plfxlc_usb *pl = get_plfxlc_usb(interface);
+	struct plfxlc_mac *mac = plfxlc_usb_to_mac(pl);
+
+	if (!pl || !plfxlc_usb_dev(pl))
+		return -ENODEV;
+	if (pl->initialized == 0)
+		return 0;
+	pl->was_running = test_bit(PURELIFI_DEVICE_RUNNING, &mac->flags);
+	plfxlc_usb_stop(pl);
+	return 0;
+}
+
+static int resume(struct usb_interface *interface)
+{
+	struct plfxlc_usb *pl = get_plfxlc_usb(interface);
+
+	if (!pl || !plfxlc_usb_dev(pl))
+		return -ENODEV;
+	if (pl->was_running)
+		plfxlc_usb_resume(pl);
+	return 0;
+}
+
+#endif
+
+static struct usb_driver driver = {
+	.name = KBUILD_MODNAME,
+	.id_table = usb_ids,
+	.probe = probe,
+	.disconnect = disconnect,
+	.pre_reset = pre_reset,
+	.post_reset = post_reset,
+#ifdef CONFIG_PM
+	.suspend = suspend,
+	.resume = resume,
+#endif
+	.disable_hub_initiated_lpm = 1,
+};
+
+static int __init usb_init(void)
+{
+	int r;
+
+	r = usb_register(&driver);
+	if (r) {
+		pr_err("%s usb_register() failed %d\n", driver.name, r);
+		return r;
+	}
+
+	pr_debug("Driver initialized :%s\n", driver.name);
+	return 0;
+}
+
+static void __exit usb_exit(void)
+{
+	usb_deregister(&driver);
+	pr_debug("%s %s\n", driver.name, __func__);
+}
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("USB driver for pureLiFi devices");
+MODULE_AUTHOR("pureLiFi");
+MODULE_VERSION("1.0");
+MODULE_FIRMWARE("plfxlc/lifi-x.bin");
+MODULE_DEVICE_TABLE(usb, usb_ids);
+
+module_init(usb_init);
+module_exit(usb_exit);
diff --git a/drivers/net/wireless/purelifi/plfxlc/usb.h b/drivers/net/wireless/purelifi/plfxlc/usb.h
new file mode 100644
index 000000000000..9b64908e9a97
--- /dev/null
+++ b/drivers/net/wireless/purelifi/plfxlc/usb.h
@@ -0,0 +1,198 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2021 pureLiFi
+ */
+
+#ifndef _PURELIFI_USB_H
+#define _PURELIFI_USB_H
+
+#include <linux/completion.h>
+#include <linux/netdevice.h>
+#include <linux/spinlock.h>
+#include <linux/skbuff.h>
+#include <linux/usb.h>
+
+#include "intf.h"
+
+#define USB_BULK_MSG_TIMEOUT_MS 2000
+
+#define PURELIFI_X_VENDOR_ID_0   0x16C1
+#define PURELIFI_X_PRODUCT_ID_0  0x1CDE
+#define PURELIFI_XC_VENDOR_ID_0  0x2EF5
+#define PURELIFI_XC_PRODUCT_ID_0 0x0008
+#define PURELIFI_XL_VENDOR_ID_0  0x2EF5
+#define PURELIFI_XL_PRODUCT_ID_0 0x000A /* Station */
+
+#define PLF_FPGA_STATUS_LEN 2
+#define PLF_FPGA_STATE_LEN 9
+#define PLF_BULK_TLEN 16384
+#define PLF_FPGA_MG 6 /* Magic check */
+#define PLF_XL_BUF_LEN 64
+#define PLF_MSG_STATUS_OFFSET 7
+
+#define PLF_USB_TIMEOUT 1000
+#define PLF_MSLEEP_TIME 200
+
+#define PURELIFI_URB_RETRY_MAX 5
+
+#define plfxlc_usb_dev(usb) (&(usb)->intf->dev)
+
+/* Tx retry backoff timer (in milliseconds) */
+#define TX_RETRY_BACKOFF_MS 10
+#define STA_QUEUE_CLEANUP_MS 5000
+
+/* Tx retry backoff timer (in jiffies) */
+#define TX_RETRY_BACKOFF_JIFF ((TX_RETRY_BACKOFF_MS * HZ) / 1000)
+#define STA_QUEUE_CLEANUP_JIFF ((STA_QUEUE_CLEANUP_MS * HZ) / 1000)
+
+/* Ensures that MAX_TRANSFER_SIZE is even. */
+#define MAX_TRANSFER_SIZE (USB_MAX_TRANSFER_SIZE & ~1)
+#define plfxlc_urb_dev(urb) (&(urb)->dev->dev)
+
+#define STATION_FIFO_ALMOST_FULL_MESSAGE     0
+#define STATION_FIFO_ALMOST_FULL_NOT_MESSAGE 1
+#define STATION_CONNECT_MESSAGE              2
+#define STATION_DISCONNECT_MESSAGE           3
+
+int plfxlc_usb_wreq(struct usb_interface *ez_usb, void *buffer, int buffer_len,
+		    enum plf_usb_req_enum usb_req_id);
+void plfxlc_tx_urb_complete(struct urb *urb);
+
+enum {
+	USB_MAX_RX_SIZE       = 4800,
+	USB_MAX_EP_INT_BUFFER = 64,
+};
+
+struct plfxlc_usb_interrupt {
+	spinlock_t lock; /* spin lock for usb interrupt buffer */
+	struct urb *urb;
+	void *buffer;
+	int interval;
+};
+
+#define RX_URBS_COUNT 5
+
+struct plfxlc_usb_rx {
+	spinlock_t lock; /* spin lock for rx urb */
+	struct mutex setup_mutex; /* mutex lockt for rx urb */
+	u8 fragment[2 * USB_MAX_RX_SIZE];
+	unsigned int fragment_length;
+	unsigned int usb_packet_size;
+	struct urb **urbs;
+	int urbs_count;
+};
+
+struct plf_station {
+   /*  7...3    |    2      |     1     |     0	    |
+    * Reserved  | Heartbeat | FIFO full | Connected |
+    */
+	unsigned char flag;
+	unsigned char mac[ETH_ALEN];
+	struct sk_buff_head data_list;
+};
+
+struct plfxlc_firmware_file {
+	u32 total_files;
+	u32 total_size;
+	u32 size;
+	u32 start_addr;
+	u32 control_packets;
+} __packed;
+
+#define STATION_CONNECTED_FLAG 0x1
+#define STATION_FIFO_FULL_FLAG 0x2
+#define STATION_HEARTBEAT_FLAG 0x4
+#define STATION_ACTIVE_FLAG    0xFD
+
+#define PURELIFI_SERIAL_LEN 256
+#define STA_BROADCAST_INDEX (AP_USER_LIMIT)
+#define MAX_STA_NUM         (AP_USER_LIMIT + 1)
+
+struct plfxlc_usb_tx {
+	unsigned long enabled;
+	spinlock_t lock; /* spinlock for USB tx */
+	u8 mac_fifo_full;
+	struct sk_buff_head submitted_skbs;
+	struct usb_anchor submitted;
+	int submitted_urbs;
+	bool stopped;
+	struct timer_list tx_retry_timer;
+	struct plf_station station[MAX_STA_NUM];
+};
+
+/* Contains the usb parts. The structure doesn't require a lock because intf
+ * will not be changed after initialization.
+ */
+struct plfxlc_usb {
+	struct timer_list sta_queue_cleanup;
+	struct plfxlc_usb_rx rx;
+	struct plfxlc_usb_tx tx;
+	struct usb_interface *intf;
+	struct usb_interface *ez_usb;
+	u8 req_buf[64]; /* plfxlc_usb_iowrite16v needs 62 bytes */
+	u8 sidx; /* store last served */
+	bool rx_usb_enabled;
+	bool initialized;
+	bool was_running;
+	bool link_up;
+};
+
+enum endpoints {
+	EP_DATA_IN  = 2,
+	EP_DATA_OUT = 8,
+};
+
+enum devicetype {
+	DEVICE_LIFI_X  = 0,
+	DEVICE_LIFI_XC  = 1,
+	DEVICE_LIFI_XL  = 1,
+};
+
+enum {
+	PLF_BIT_ENABLED = 1,
+	PLF_BIT_MAX = 2,
+};
+
+int plfxlc_usb_wreq_async(struct plfxlc_usb *usb, const u8 *buffer,
+			  int buffer_len, enum plf_usb_req_enum usb_req_id,
+			  usb_complete_t complete_fn, void *context);
+
+static inline struct usb_device *
+plfxlc_usb_to_usbdev(struct plfxlc_usb *usb)
+{
+	return interface_to_usbdev(usb->intf);
+}
+
+static inline struct ieee80211_hw *
+plfxlc_intf_to_hw(struct usb_interface *intf)
+{
+	return usb_get_intfdata(intf);
+}
+
+static inline struct ieee80211_hw *
+plfxlc_usb_to_hw(struct plfxlc_usb *usb)
+{
+	return plfxlc_intf_to_hw(usb->intf);
+}
+
+void plfxlc_usb_init(struct plfxlc_usb *usb, struct ieee80211_hw *hw,
+		     struct usb_interface *intf);
+void plfxlc_send_packet_from_data_queue(struct plfxlc_usb *usb);
+void plfxlc_usb_release(struct plfxlc_usb *usb);
+void plfxlc_usb_disable_rx(struct plfxlc_usb *usb);
+void plfxlc_usb_enable_tx(struct plfxlc_usb *usb);
+void plfxlc_usb_disable_tx(struct plfxlc_usb *usb);
+int plfxlc_usb_tx(struct plfxlc_usb *usb, struct sk_buff *skb);
+int plfxlc_usb_enable_rx(struct plfxlc_usb *usb);
+int plfxlc_usb_init_hw(struct plfxlc_usb *usb);
+const char *plfxlc_speed(enum usb_device_speed speed);
+
+/* Firmware declarations */
+int plfxlc_download_xl_firmware(struct usb_interface *intf);
+int plfxlc_download_fpga(struct usb_interface *intf);
+
+int upload_mac_and_serial(struct usb_interface *intf,
+			  unsigned char *hw_address,
+			  unsigned char *serial_number);
+
+#endif
-- 
2.25.1

