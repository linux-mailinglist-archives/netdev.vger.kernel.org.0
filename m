Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AB732BC75A
	for <lists+netdev@lfdr.de>; Sun, 22 Nov 2020 18:05:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728199AbgKVRDx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Nov 2020 12:03:53 -0500
Received: from smtp05.smtpout.orange.fr ([80.12.242.127]:16497 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728163AbgKVRDw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Nov 2020 12:03:52 -0500
Received: from localhost.localdomain ([81.185.166.181])
        by mwinf5d28 with ME
        id vV3j230033v9GFD03V3j3k; Sun, 22 Nov 2020 18:03:47 +0100
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 22 Nov 2020 18:03:47 +0100
X-ME-IP: 81.185.166.181
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        erik.stromdahl@gmail.com
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH 1/2] ath10k: Fix an error handling path
Date:   Sun, 22 Nov 2020 18:03:42 +0100
Message-Id: <20201122170342.1346011-1-christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If 'ath10k_usb_create()' fails, we should release some resources and report
an error instead of silently continuing.

Fixes: 4db66499df91 ("ath10k: add initial USB support")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/wireless/ath/ath10k/usb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/usb.c b/drivers/net/wireless/ath/ath10k/usb.c
index 05a620ff6fe2..0b47c3a09794 100644
--- a/drivers/net/wireless/ath/ath10k/usb.c
+++ b/drivers/net/wireless/ath/ath10k/usb.c
@@ -997,6 +997,8 @@ static int ath10k_usb_probe(struct usb_interface *interface,
 
 	ar_usb = ath10k_usb_priv(ar);
 	ret = ath10k_usb_create(ar, interface);
+	if (ret)
+		goto err;
 	ar_usb->ar = ar;
 
 	ar->dev_id = product_id;
-- 
2.27.0

