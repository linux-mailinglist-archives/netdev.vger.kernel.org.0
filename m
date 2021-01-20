Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 321842FC7AF
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 03:23:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728567AbhATCU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 21:20:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:48240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730829AbhATB3o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 20:29:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 042B823730;
        Wed, 20 Jan 2021 01:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611106088;
        bh=5yK5Fi0PTZ04fL2md8C6mizLSxtI95KJPCXu9GfAxsM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X7vJ6QoPCRPrBIvPwh+ZYiOCcoYHYqyAJuwMO2lFeUOLexYSqOgc9c4O5OjvZ6LO1
         UXEARl25V7zQF3SVBa2Z+B5k0kjVhBQs7/jPzPIADs33P7I/rm0ERKAtOWnGD8WhHi
         YG5Pmmeu4jCghydHJ3UC18agpKLqRvfPL2SLKjG/psHkfm6CttXfdD6hDF508h4h7L
         X5mCZrhDoM7T4kwbPguG981lQ2l6uagwxB1pc59EzPyV/OCH1zBS7oHpOit0Et/Iv0
         pCKOwfup660pe2NjhCDTZBF1uDys/HhFVIJrX0Fs/nlj6nSlS4Z0wHM6yyDyRi+ZEJ
         Uy9cIyrdCH7AQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Leon Schuermann <leon@is.currently.online>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 4/9] r8152: Add Lenovo Powered USB-C Travel Hub
Date:   Tue, 19 Jan 2021 20:27:57 -0500
Message-Id: <20210120012802.770525-4-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210120012802.770525-1-sashal@kernel.org>
References: <20210120012802.770525-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Schuermann <leon@is.currently.online>

[ Upstream commit cb82a54904a99df9e8f9e9d282046055dae5a730 ]

This USB-C Hub (17ef:721e) based on the Realtek RTL8153B chip used to
use the cdc_ether driver. However, using this driver, with the system
suspended the device constantly sends pause-frames as soon as the
receive buffer fills up. This causes issues with other devices, where
some Ethernet switches stop forwarding packets altogether.

Using the Realtek driver (r8152) fixes this issue. Pause frames are no
longer sent while the host system is suspended.

Signed-off-by: Leon Schuermann <leon@is.currently.online>
Tested-by: Leon Schuermann <leon@is.currently.online>
Link: https://lore.kernel.org/r/20210111190312.12589-2-leon@is.currently.online
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/cdc_ether.c | 7 +++++++
 drivers/net/usb/r8152.c     | 1 +
 2 files changed, 8 insertions(+)

diff --git a/drivers/net/usb/cdc_ether.c b/drivers/net/usb/cdc_ether.c
index f3def96d35d42..8c9eae5f30722 100644
--- a/drivers/net/usb/cdc_ether.c
+++ b/drivers/net/usb/cdc_ether.c
@@ -800,6 +800,13 @@ static const struct usb_device_id	products[] = {
 	.driver_info = 0,
 },
 
+/* Lenovo Powered USB-C Travel Hub (4X90S92381, based on Realtek RTL8153) */
+{
+	USB_DEVICE_AND_INTERFACE_INFO(LENOVO_VENDOR_ID, 0x721e, USB_CLASS_COMM,
+			USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
+	.driver_info = 0,
+},
+
 /* ThinkPad USB-C Dock Gen 2 (based on Realtek RTL8153) */
 {
 	USB_DEVICE_AND_INTERFACE_INFO(LENOVO_VENDOR_ID, 0xa387, USB_CLASS_COMM,
diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index e30792380812a..bd91d4bad49b2 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -5337,6 +5337,7 @@ static const struct usb_device_id rtl8152_table[] = {
 	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x7205)},
 	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x720c)},
 	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x7214)},
+	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x721e)},
 	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0xa387)},
 	{REALTEK_USB_DEVICE(VENDOR_ID_LINKSYS, 0x0041)},
 	{REALTEK_USB_DEVICE(VENDOR_ID_NVIDIA,  0x09ff)},
-- 
2.27.0

