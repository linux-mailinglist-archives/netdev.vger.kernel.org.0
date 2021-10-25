Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C64D43958D
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 14:06:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232699AbhJYMIP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 08:08:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:48754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231501AbhJYMIL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 08:08:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 49FCA60F9D;
        Mon, 25 Oct 2021 12:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635163549;
        bh=mi2YBgOVXZK98qc5s25s+ODSzvYGuyAGSaDUbDTLRq4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IVMfPD9LjVVUFVxAnyH6u4a3mIDrvFPSHcQSpl2gKvzLO8VRTJDa8RwOiouGQt5zJ
         MlqJJE6u3n0HRwxsl8rX/BoLl+KT/qLk5lUqNi8i4yIhBMopZHDruHeTAULOxX1lxI
         wNemlNYxFM5I0jKcjazScwGgCBmNVUEt+bBOGXF3lootoLGWoyf8kKqMTBSzcI9lU1
         2zHwiemSjSNVwI8097L4bezkGXxm2x3bQ1fSarJKlpEIULGJpbEerqETb4+PNjdjzv
         eqksDktL5zlWqr6agwgKKbqPtcFw2EFuP06cayrRXSo2R2Ic9Eq/WXuFyftJmQJ0NC
         gNqWllaYUGt4g==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1meyjL-0001aV-Vq; Mon, 25 Oct 2021 14:05:32 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Herton Ronaldo Krzesinski <herton@canonical.com>,
        Hin-Tak Leung <htl10@users.sourceforge.net>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Siva Rebbagondla <siva8118@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>, stable@vger.kernel.org
Subject: [PATCH 3/4] rtl8187: fix control-message timeouts
Date:   Mon, 25 Oct 2021 14:05:21 +0200
Message-Id: <20211025120522.6045-4-johan@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211025120522.6045-1-johan@kernel.org>
References: <20211025120522.6045-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

USB control-message timeouts are specified in milliseconds and should
specifically not vary with CONFIG_HZ.

Fixes: 605bebe23bf6 ("[PATCH] Add rtl8187 wireless driver")
Cc: stable@vger.kernel.org      # 2.6.23
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 .../net/wireless/realtek/rtl818x/rtl8187/rtl8225.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl818x/rtl8187/rtl8225.c b/drivers/net/wireless/realtek/rtl818x/rtl8187/rtl8225.c
index 585784258c66..4efab907a3ac 100644
--- a/drivers/net/wireless/realtek/rtl818x/rtl8187/rtl8225.c
+++ b/drivers/net/wireless/realtek/rtl818x/rtl8187/rtl8225.c
@@ -28,7 +28,7 @@ u8 rtl818x_ioread8_idx(struct rtl8187_priv *priv,
 	usb_control_msg(priv->udev, usb_rcvctrlpipe(priv->udev, 0),
 			RTL8187_REQ_GET_REG, RTL8187_REQT_READ,
 			(unsigned long)addr, idx & 0x03,
-			&priv->io_dmabuf->bits8, sizeof(val), HZ / 2);
+			&priv->io_dmabuf->bits8, sizeof(val), 500);
 
 	val = priv->io_dmabuf->bits8;
 	mutex_unlock(&priv->io_mutex);
@@ -45,7 +45,7 @@ u16 rtl818x_ioread16_idx(struct rtl8187_priv *priv,
 	usb_control_msg(priv->udev, usb_rcvctrlpipe(priv->udev, 0),
 			RTL8187_REQ_GET_REG, RTL8187_REQT_READ,
 			(unsigned long)addr, idx & 0x03,
-			&priv->io_dmabuf->bits16, sizeof(val), HZ / 2);
+			&priv->io_dmabuf->bits16, sizeof(val), 500);
 
 	val = priv->io_dmabuf->bits16;
 	mutex_unlock(&priv->io_mutex);
@@ -62,7 +62,7 @@ u32 rtl818x_ioread32_idx(struct rtl8187_priv *priv,
 	usb_control_msg(priv->udev, usb_rcvctrlpipe(priv->udev, 0),
 			RTL8187_REQ_GET_REG, RTL8187_REQT_READ,
 			(unsigned long)addr, idx & 0x03,
-			&priv->io_dmabuf->bits32, sizeof(val), HZ / 2);
+			&priv->io_dmabuf->bits32, sizeof(val), 500);
 
 	val = priv->io_dmabuf->bits32;
 	mutex_unlock(&priv->io_mutex);
@@ -79,7 +79,7 @@ void rtl818x_iowrite8_idx(struct rtl8187_priv *priv,
 	usb_control_msg(priv->udev, usb_sndctrlpipe(priv->udev, 0),
 			RTL8187_REQ_SET_REG, RTL8187_REQT_WRITE,
 			(unsigned long)addr, idx & 0x03,
-			&priv->io_dmabuf->bits8, sizeof(val), HZ / 2);
+			&priv->io_dmabuf->bits8, sizeof(val), 500);
 
 	mutex_unlock(&priv->io_mutex);
 }
@@ -93,7 +93,7 @@ void rtl818x_iowrite16_idx(struct rtl8187_priv *priv,
 	usb_control_msg(priv->udev, usb_sndctrlpipe(priv->udev, 0),
 			RTL8187_REQ_SET_REG, RTL8187_REQT_WRITE,
 			(unsigned long)addr, idx & 0x03,
-			&priv->io_dmabuf->bits16, sizeof(val), HZ / 2);
+			&priv->io_dmabuf->bits16, sizeof(val), 500);
 
 	mutex_unlock(&priv->io_mutex);
 }
@@ -107,7 +107,7 @@ void rtl818x_iowrite32_idx(struct rtl8187_priv *priv,
 	usb_control_msg(priv->udev, usb_sndctrlpipe(priv->udev, 0),
 			RTL8187_REQ_SET_REG, RTL8187_REQT_WRITE,
 			(unsigned long)addr, idx & 0x03,
-			&priv->io_dmabuf->bits32, sizeof(val), HZ / 2);
+			&priv->io_dmabuf->bits32, sizeof(val), 500);
 
 	mutex_unlock(&priv->io_mutex);
 }
@@ -183,7 +183,7 @@ static void rtl8225_write_8051(struct ieee80211_hw *dev, u8 addr, __le16 data)
 	usb_control_msg(priv->udev, usb_sndctrlpipe(priv->udev, 0),
 			RTL8187_REQ_SET_REG, RTL8187_REQT_WRITE,
 			addr, 0x8225, &priv->io_dmabuf->bits16, sizeof(data),
-			HZ / 2);
+			500);
 
 	mutex_unlock(&priv->io_mutex);
 
-- 
2.32.0

