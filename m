Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBA5A2BC75E
	for <lists+netdev@lfdr.de>; Sun, 22 Nov 2020 18:05:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728285AbgKVRED (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Nov 2020 12:04:03 -0500
Received: from smtp05.smtpout.orange.fr ([80.12.242.127]:53024 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728145AbgKVRED (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Nov 2020 12:04:03 -0500
Received: from localhost.localdomain ([81.185.166.181])
        by mwinf5d28 with ME
        id vV3y2300E3v9GFD03V3y5W; Sun, 22 Nov 2020 18:03:59 +0100
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 22 Nov 2020 18:03:59 +0100
X-ME-IP: 81.185.166.181
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        erik.stromdahl@gmail.com
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH 2/2] ath10k: Release some resources in an error handling path
Date:   Sun, 22 Nov 2020 18:03:58 +0100
Message-Id: <20201122170358.1346065-1-christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Should an error occur after calling 'ath10k_usb_create()', it should be
undone by a corresponding 'ath10k_usb_destroy()' call

Fixes: 4db66499df91 ("ath10k: add initial USB support")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
This patch is speculative and compile tested only.
---
 drivers/net/wireless/ath/ath10k/usb.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/usb.c b/drivers/net/wireless/ath/ath10k/usb.c
index 0b47c3a09794..19b9c27e30e2 100644
--- a/drivers/net/wireless/ath/ath10k/usb.c
+++ b/drivers/net/wireless/ath/ath10k/usb.c
@@ -1011,7 +1011,7 @@ static int ath10k_usb_probe(struct usb_interface *interface,
 	ret = ath10k_core_register(ar, &bus_params);
 	if (ret) {
 		ath10k_warn(ar, "failed to register driver core: %d\n", ret);
-		goto err;
+		goto err_usb_destroy;
 	}
 
 	/* TODO: remove this once USB support is fully implemented */
@@ -1019,6 +1019,9 @@ static int ath10k_usb_probe(struct usb_interface *interface,
 
 	return 0;
 
+err_usb_destroy:
+	ath10k_usb_destroy(ar);
+
 err:
 	ath10k_core_destroy(ar);
 
-- 
2.27.0

