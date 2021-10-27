Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D85943C4C4
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 10:12:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240847AbhJ0IOv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 04:14:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:46468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240787AbhJ0IOo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 04:14:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E85B1610A5;
        Wed, 27 Oct 2021 08:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635322339;
        bh=7IGUs5zBZQaPqlnohFXICy0HDLEn9Ux9E9JxKQ/UU7Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qg9CRHNl0+/AA6u/+gYSJ9xcpQdAe+BZU+xBdaaByltKipueylMMMXT282EUa6kYl
         nRHN8PTCFCbqSFGOzz5DbrTnX88zPzV7TaDycbWpIJc4yaJeP+VQzA9XxJzameC/rj
         Fg9LW+8Ax5oixOQPtMEJ3SaWJKRql2sa02QZMo+mtMQZpTpBcf6K10EREIYHCfuMn2
         gr2UoyJjYTKsx0fQHkLduc+nkoHvJqMg4ln3tfAD+w9yVm2+S+UKSAgMUsU+nLaQaI
         D95ahlTxxOgYpmMRRZSakmel1yIQyJw8LVnvr4/I3iLpnamKYR1Zsap4ChCa+63V7w
         hjBdL0+VtcoDQ==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1mfe2S-0001lk-Vr; Wed, 27 Oct 2021 10:12:01 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Sharvari Harisangam <sharvari.harisangam@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Brian Norris <briannorris@chromium.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>, stable@vger.kernel.org,
        Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH v2 3/3] mwifiex: fix division by zero in fw download path
Date:   Wed, 27 Oct 2021 10:08:19 +0200
Message-Id: <20211027080819.6675-4-johan@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211027080819.6675-1-johan@kernel.org>
References: <20211027080819.6675-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the missing endpoint sanity checks to probe() to avoid division by
zero in mwifiex_write_data_sync() in case a malicious device has broken
descriptors (or when doing descriptor fuzz testing).

Only add checks for the firmware-download boot stage, which require both
command endpoints, for now. The driver looks like it will handle a
missing endpoint during normal operation without oopsing, albeit not
very gracefully as it will try to submit URBs to the default pipe and
fail.

Note that USB core will reject URBs submitted for endpoints with zero
wMaxPacketSize but that drivers doing packet-size calculations still
need to handle this (cf. commit 2548288b4fb0 ("USB: Fix: Don't skip
endpoint descriptors with maxpacket=0")).

Fixes: 4daffe354366 ("mwifiex: add support for Marvell USB8797 chipset")
Cc: stable@vger.kernel.org      # 3.5
Cc: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/net/wireless/marvell/mwifiex/usb.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/usb.c b/drivers/net/wireless/marvell/mwifiex/usb.c
index 426e39d4ccf0..9736aa0ab7fd 100644
--- a/drivers/net/wireless/marvell/mwifiex/usb.c
+++ b/drivers/net/wireless/marvell/mwifiex/usb.c
@@ -505,6 +505,22 @@ static int mwifiex_usb_probe(struct usb_interface *intf,
 		}
 	}
 
+	switch (card->usb_boot_state) {
+	case USB8XXX_FW_DNLD:
+		/* Reject broken descriptors. */
+		if (!card->rx_cmd_ep || !card->tx_cmd_ep)
+			return -ENODEV;
+		if (card->bulk_out_maxpktsize == 0)
+			return -ENODEV;
+		break;
+	case USB8XXX_FW_READY:
+		/* Assume the driver can handle missing endpoints for now. */
+		break;
+	default:
+		WARN_ON(1);
+		return -ENODEV;
+	}
+
 	usb_set_intfdata(intf, card);
 
 	ret = mwifiex_add_card(card, &card->fw_done, &usb_ops,
-- 
2.32.0

