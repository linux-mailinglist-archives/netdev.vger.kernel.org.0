Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1307F635F09
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 14:12:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238232AbiKWNJe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 08:09:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238092AbiKWNJO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 08:09:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3CF6E873C;
        Wed, 23 Nov 2022 04:51:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0384161CAC;
        Wed, 23 Nov 2022 12:46:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1CDDC433C1;
        Wed, 23 Nov 2022 12:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669207585;
        bh=YNrEhQcdM4+aQIN7dSgQ3r+Lcln3gNBhYT/74CZveGo=;
        h=From:To:Cc:Subject:Date:From;
        b=jgZKZJ1adcojLzUIXTyxsPVZjnl5hgtl/gXp7AMhuMIejh+dUvi0cwObyOKpUvzjd
         z26NMZcCJCCn/Cs3L7a/aFBXjl1xveEGJjQWM+QG8BaIrWW2F1mAE1SJyQYg2u01K5
         FhNdRHBloE3UBfDMN+Ztc0J+t8YnXNw/4sibriP0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Kalle Valo <kvalo@kernel.org>,
        Oleksij Rempel <linux@rempel-privat.de>,
        =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Andrzej Pietrasiewicz <andrzejtp2010@gmail.com>,
        Jacopo Mondi <jacopo@jmondi.org>,
        =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        Ilja Van Sprundel <ivansprundel@ioactive.com>,
        Joseph Tartaro <joseph.tartaro@ioactive.com>
Subject: [PATCH] USB: disable all RNDIS protocol drivers
Date:   Wed, 23 Nov 2022 13:46:20 +0100
Message-Id: <20221123124620.1387499-1-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=4394; i=gregkh@linuxfoundation.org; h=from:subject; bh=YNrEhQcdM4+aQIN7dSgQ3r+Lcln3gNBhYT/74CZveGo=; b=owGbwMvMwCRo6H6F97bub03G02pJDMl1YtKFdnaejBseHIq6stZHZZX4ix4R+dipc073OiT7TZz+ TfdDRywLgyATg6yYIsuXbTxH91ccUvQytD0NM4eVCWQIAxenAEzkcRHD/IxvSivOKu1syeG8MrvyW1 rn+ntGvgwLrvqU7JzFxGUbG+p/zHGhc7SfYnkkAA==
X-Developer-Key: i=gregkh@linuxfoundation.org; a=openpgp; fpr=F4B60CC5BF78C2214A313DCB3147D40DDB2DFB29
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Microsoft RNDIS protocol is, as designed, insecure and vulnerable on
any system that uses it with untrusted hosts or devices.  Because the
protocol is impossible to make secure, just disable all rndis drivers to
prevent anyone from using them again.

Windows only needed this for XP and newer systems, Windows systems older
than that can use the normal USB class protocols instead, which do not
have these problems.

Android has had this disabled for many years so there should not be any
real systems that still need this.

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Kalle Valo <kvalo@kernel.org>
Cc: Oleksij Rempel <linux@rempel-privat.de>
Cc: "Maciej Żenczykowski" <maze@google.com>
Cc: Neil Armstrong <neil.armstrong@linaro.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Andrzej Pietrasiewicz <andrzejtp2010@gmail.com>
Cc: Jacopo Mondi <jacopo@jmondi.org>
Cc: "Łukasz Stelmach" <l.stelmach@samsung.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-usb@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-wireless@vger.kernel.org
Reported-by: Ilja Van Sprundel <ivansprundel@ioactive.com>
Reported-by: Joseph Tartaro <joseph.tartaro@ioactive.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
Note, I'll submit patches removing the individual drivers for later, but
that is more complex as unwinding the interaction between the CDC
networking and RNDIS drivers is tricky.  For now, let's just disable all
of this code as it is not secure.

I can take this through the USB tree if the networking maintainers have
no objection.  I thought I had done this months ago, when the last round
of "there are bugs in the protocol!" reports happened at the end of
2021, but forgot to do so, my fault.

 drivers/net/usb/Kconfig           | 1 +
 drivers/net/wireless/Kconfig      | 1 +
 drivers/usb/gadget/Kconfig        | 4 +---
 drivers/usb/gadget/legacy/Kconfig | 3 +++
 4 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/usb/Kconfig b/drivers/net/usb/Kconfig
index 4402eedb3d1a..83f9c0632642 100644
--- a/drivers/net/usb/Kconfig
+++ b/drivers/net/usb/Kconfig
@@ -401,6 +401,7 @@ config USB_NET_MCS7830
 config USB_NET_RNDIS_HOST
 	tristate "Host for RNDIS and ActiveSync devices"
 	depends on USB_USBNET
+	depends on BROKEN
 	select USB_NET_CDCETHER
 	help
 	  This option enables hosting "Remote NDIS" USB networking links,
diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index cb1c15012dd0..f162b25123d7 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -81,6 +81,7 @@ config USB_NET_RNDIS_WLAN
 	tristate "Wireless RNDIS USB support"
 	depends on USB
 	depends on CFG80211
+	depends on BROKEN
 	select USB_NET_DRIVERS
 	select USB_USBNET
 	select USB_NET_CDCETHER
diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
index 4fa2ddf322b4..2c99d4313064 100644
--- a/drivers/usb/gadget/Kconfig
+++ b/drivers/usb/gadget/Kconfig
@@ -183,9 +183,6 @@ config USB_F_EEM
 config USB_F_SUBSET
 	tristate
 
-config USB_F_RNDIS
-	tristate
-
 config USB_F_MASS_STORAGE
 	tristate
 
@@ -297,6 +294,7 @@ config USB_CONFIGFS_RNDIS
 	bool "RNDIS"
 	depends on USB_CONFIGFS
 	depends on NET
+	depends on BROKEN
 	select USB_U_ETHER
 	select USB_F_RNDIS
 	help
diff --git a/drivers/usb/gadget/legacy/Kconfig b/drivers/usb/gadget/legacy/Kconfig
index 0a7b382fbe27..03d6da63edf7 100644
--- a/drivers/usb/gadget/legacy/Kconfig
+++ b/drivers/usb/gadget/legacy/Kconfig
@@ -153,6 +153,7 @@ config USB_ETH
 config USB_ETH_RNDIS
 	bool "RNDIS support"
 	depends on USB_ETH
+	depends on BROKEN
 	select USB_LIBCOMPOSITE
 	select USB_F_RNDIS
 	default y
@@ -247,6 +248,7 @@ config USB_FUNCTIONFS_ETH
 config USB_FUNCTIONFS_RNDIS
 	bool "Include configuration with RNDIS (Ethernet)"
 	depends on USB_FUNCTIONFS && NET
+	depends on BROKEN
 	select USB_U_ETHER
 	select USB_F_RNDIS
 	help
@@ -427,6 +429,7 @@ config USB_G_MULTI
 config USB_G_MULTI_RNDIS
 	bool "RNDIS + CDC Serial + Storage configuration"
 	depends on USB_G_MULTI
+	depends on BROKEN
 	select USB_F_RNDIS
 	default y
 	help
-- 
2.38.1

