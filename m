Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97ADA43B02D
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 12:37:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234631AbhJZKjk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 06:39:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:52704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234335AbhJZKje (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 06:39:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4287260724;
        Tue, 26 Oct 2021 10:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635244631;
        bh=1lznKj02js2vDcFoN3MOczg+gZYFnPf8Nbk8oFIPFvo=;
        h=From:To:Cc:Subject:Date:From;
        b=dRNqLNpvY3nnnnylgoyhXNjRhLOWXOO6pInn/ZzegNEpIgRqpORFWK1c1e4v0ihHj
         y/7HYIkS/MTiBEGvr/sYSxXwYicpC/iiwP8xcxPGGMkJGmr3Ph446jn5Uc4C541dF0
         3D+2DU4RWX7P5JgphzWQAU3wp9eSaKAPKlaMvF7oamIfsL20g65wJwMK1psNeXJOwV
         aaMT9OCqvRSgjmZODu3HnnlEj3dMHsRs33xEeqN6z1Er9v3FtZwHYu06I1IxSfRQ93
         ez0Q+/b9NmulmNhneY1nvtLo3MwkhFg4lCDLC4APqAHIR1BSRxyW6b1zttBOf9Y+JL
         ugvNRM3NWgA4Q==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1mfJp7-0001Ug-VI; Tue, 26 Oct 2021 12:36:54 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Woojung Huh <woojung.huh@microchip.com>
Cc:     UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>, stable@vger.kernel.org,
        "Woojung . Huh @ microchip . com" <Woojung.Huh@microchip.com>
Subject: [PATCH] net: lan78xx: fix division by zero in send path
Date:   Tue, 26 Oct 2021 12:36:17 +0200
Message-Id: <20211026103617.5686-1-johan@kernel.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the missing endpoint max-packet sanity check to probe() to avoid
division by zero in lan78xx_tx_bh() in case a malicious device has
broken descriptors (or when doing descriptor fuzz testing).

Note that USB core will reject URBs submitted for endpoints with zero
wMaxPacketSize but that drivers doing packet-size calculations still
need to handle this (cf. commit 2548288b4fb0 ("USB: Fix: Don't skip
endpoint descriptors with maxpacket=0")).

Fixes: 55d7de9de6c3 ("Microchip's LAN7800 family USB 2/3 to 10/100/1000 Ethernet device driver")
Cc: stable@vger.kernel.org      # 4.3
Cc: Woojung.Huh@microchip.com <Woojung.Huh@microchip.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/net/usb/lan78xx.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index 793f8fbe0069..63cd72c5f580 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -4122,6 +4122,12 @@ static int lan78xx_probe(struct usb_interface *intf,
 
 	dev->maxpacket = usb_maxpacket(dev->udev, dev->pipe_out, 1);
 
+	/* Reject broken descriptors. */
+	if (dev->maxpacket == 0) {
+		ret = -ENODEV;
+		goto out4;
+	}
+
 	/* driver requires remote-wakeup capability during autosuspend. */
 	intf->needs_remote_wakeup = 1;
 
-- 
2.32.0

