Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07CCF2FC901
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 04:35:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732010AbhATC3r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 21:29:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:47300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730650AbhATB3A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 20:29:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 908B9233A2;
        Wed, 20 Jan 2021 01:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611106040;
        bh=DsoZY31YmaqOqDRU1mKE+CZPITeJVU24fOvHlE+DHt0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W42tCqz09CfkclyXU5Njnlwvfdgbt0cinoQEOueqSDUYqeYza5bmU5OaCVa9z1HpF
         QCadpYPaJPMOKV6Tc7YYQ0dRRzpC7uJFzvDvAB/EtDUla2YTfpZ2FF+VmDv+cYl0I+
         4dInWtk7ES7HJlZoHIhr7xmtQwLUEKip3F6HZbfHpqz7sLIoeTYktf2TzEWX98gYAE
         0kR7EyG0fEYdUiMYlIGdyqnzEBRceGkCXzd/AZlnc/gvHlNh3WAhP/2jRflbOWcwBQ
         RCE6CSCw24jQj926ejCAHtGQJ6c8Glv4j7bijjrOKT430VflCfYBwE0+IOppIqnfj2
         Ne1rDknGjtZDA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Leon Schuermann <leon@is.currently.online>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 12/26] r8152: Add Lenovo Powered USB-C Travel Hub
Date:   Tue, 19 Jan 2021 20:26:49 -0500
Message-Id: <20210120012704.770095-12-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210120012704.770095-1-sashal@kernel.org>
References: <20210120012704.770095-1-sashal@kernel.org>
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
index 9bb37ac99a108..8325f6d65dccc 100644
--- a/drivers/net/usb/cdc_ether.c
+++ b/drivers/net/usb/cdc_ether.c
@@ -787,6 +787,13 @@ static const struct usb_device_id	products[] = {
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
index cd1a07175e111..22f093797f417 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -5845,6 +5845,7 @@ static const struct usb_device_id rtl8152_table[] = {
 	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x7205)},
 	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x720c)},
 	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x7214)},
+	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x721e)},
 	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0xa387)},
 	{REALTEK_USB_DEVICE(VENDOR_ID_LINKSYS, 0x0041)},
 	{REALTEK_USB_DEVICE(VENDOR_ID_NVIDIA,  0x09ff)},
-- 
2.27.0

