Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F2BE3B94B5
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 18:34:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230015AbhGAQgs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 12:36:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37668 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbhGAQgr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Jul 2021 12:36:47 -0400
Received: from 111-240-144-27.dynamic-ip.hinet.net ([111.240.144.27] helo=localhost.localdomain)
        by youngberry.canonical.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <chris.chiu@canonical.com>)
        id 1lyzdj-0000i1-Tp; Thu, 01 Jul 2021 16:34:12 +0000
From:   chris.chiu@canonical.com
To:     Jes.Sorensen@gmail.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org, code@reto-schneider.ch
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chris Chiu <chris.chiu@canonical.com>
Subject: [PATCH] rtl8xxxu: disable interrupt_in transfer for 8188cu and 8192cu
Date:   Fri,  2 Jul 2021 00:33:54 +0800
Message-Id: <20210701163354.118403-1-chris.chiu@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chris Chiu <chris.chiu@canonical.com>

There will be crazy numbers of interrupts triggered by 8188cu and
8192cu module, around 8000~10000 interrupts per second, on the usb
host controller. Compare with the vendor driver source code, it's
mapping to the configuration CONFIG_USB_INTERRUPT_IN_PIPE and it is
disabled by default.

Since the interrupt transfer is neither used for TX/RX nor H2C
commands. Disable it to avoid the confusing interrupts for the
8188cu and 8192cu module which I only have for verification.

Signed-off-by: Chris Chiu <chris.chiu@canonical.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index 03c6ed7efe06..6a3dfa71b27f 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -1670,7 +1670,7 @@ static int rtl8xxxu_identify_chip(struct rtl8xxxu_priv *priv)
 			priv->rf_paths = 2;
 			priv->rx_paths = 2;
 			priv->tx_paths = 2;
-			priv->usb_interrupts = 1;
+			priv->usb_interrupts = 0;
 			priv->rtl_chip = RTL8192C;
 		}
 		priv->has_wifi = 1;
@@ -1680,7 +1680,7 @@ static int rtl8xxxu_identify_chip(struct rtl8xxxu_priv *priv)
 		priv->rx_paths = 1;
 		priv->tx_paths = 1;
 		priv->rtl_chip = RTL8188C;
-		priv->usb_interrupts = 1;
+		priv->usb_interrupts = 0;
 		priv->has_wifi = 1;
 	}
 
-- 
2.20.1

