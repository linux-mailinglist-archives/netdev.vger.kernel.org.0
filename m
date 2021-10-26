Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86A1E43AF80
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 11:53:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234777AbhJZJzk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 05:55:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:58232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233662AbhJZJzk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 05:55:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E54561074;
        Tue, 26 Oct 2021 09:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635241996;
        bh=5Kjj92OAxcYzSBaJWYZyRkbxJVmWOj10eLL8DwNGxak=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=flGfxM41C7RvkKpC8A340v+CRDotEaOtf+/7+tlsgzZhJII5sgP++DMH2rxrJJk53
         xr/aTSWjBjiqqWHTrNtBHdUxC3w+zKVlxxtI1L9VdaKQBLRyY4s53OrkI7N1GkJjVM
         w/hCk1fc/iRtZvpECXrEE7fev+8uCCrOSmF5h57IsCPocz8Ru+SW0YCAy48nWDXs7/
         XIhn0T87kM/DTTh6NN48eRT51a+0W2+wWAMheNyvRCqaY+H8xP8q6WQnm8eA9l2Sb9
         o95Uhw8mUoZtKbrV8O6oTuNfwWwJXhdw292tDQClMiRYtj66/wVxF/7TCelLUPMt7Q
         Jpoej/5dExAYw==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1mfJ8e-0006sW-4j; Tue, 26 Oct 2021 11:53:00 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Sharvari Harisangam <sharvari.harisangam@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>, stable@vger.kernel.org,
        Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 3/3] mwifiex: fix division by zero in fw download path
Date:   Tue, 26 Oct 2021 11:52:14 +0200
Message-Id: <20211026095214.26375-3-johan@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211026095214.26375-1-johan@kernel.org>
References: <20211026095214.26375-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the missing endpoint max-packet sanity check to probe() to avoid
division by zero in mwifiex_write_data_sync() in case a malicious device
has broken descriptors (or when doing descriptor fuzz testing).

Note that USB core will reject URBs submitted for endpoints with zero
wMaxPacketSize but that drivers doing packet-size calculations still
need to handle this (cf. commit 2548288b4fb0 ("USB: Fix: Don't skip
endpoint descriptors with maxpacket=0")).

Fixes: 4daffe354366 ("mwifiex: add support for Marvell USB8797 chipset")
Cc: stable@vger.kernel.org      # 3.5
Cc: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/net/wireless/marvell/mwifiex/usb.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/usb.c b/drivers/net/wireless/marvell/mwifiex/usb.c
index 426e39d4ccf0..2826654907d9 100644
--- a/drivers/net/wireless/marvell/mwifiex/usb.c
+++ b/drivers/net/wireless/marvell/mwifiex/usb.c
@@ -502,6 +502,9 @@ static int mwifiex_usb_probe(struct usb_interface *intf,
 			atomic_set(&card->tx_cmd_urb_pending, 0);
 			card->bulk_out_maxpktsize =
 					le16_to_cpu(epd->wMaxPacketSize);
+			/* Reject broken descriptors. */
+			if (card->bulk_out_maxpktsize == 0)
+				return -ENODEV;
 		}
 	}
 
-- 
2.32.0

