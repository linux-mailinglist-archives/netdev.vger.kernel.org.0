Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC884388E5C
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 14:47:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353469AbhESMtG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 08:49:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:56450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233234AbhESMtE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 May 2021 08:49:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3DEBB611BF;
        Wed, 19 May 2021 12:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621428465;
        bh=jDsQgzBa0hZeYn+cxkntyVgDH6tU89hxn6VnTQMi/K4=;
        h=From:To:Cc:Subject:Date:From;
        b=el/e4kZrAT+ReFKyC317+KgeCxfTuX8FcyB/eXtOSaU0sTX4UD26flNq08/sydEAp
         UJamwLkmHee2bCcOyWTapJC9UQwdqfzTE8vJ1rwdPqSPphNFEUXfk6bjElmlI/Bh4+
         6DKpFb82eK9C/KqtR1JCliefSjEYkp/Kg3mm6yssES7h4nx6JiGCz81ka7v4HF3vrG
         EnW+Bm+ALmmLF1d1O23p1sdT0I4hNEUEM4jpOjtWUayYaAQ+V78xPn9p+D+zT98UIu
         pWCjwryL1xhp7OwhpNX+dynvIGA2RO3CYOxDhJvtNbsCZdJQqs6A0o1MbtRxHGnGU5
         b8SYrQxulgR6w==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1ljLc0-000879-30; Wed, 19 May 2021 14:47:44 +0200
From:   Johan Hovold <johan@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH net] net: hso: bail out on interrupt URB allocation failure
Date:   Wed, 19 May 2021 14:47:17 +0200
Message-Id: <20210519124717.31144-1-johan@kernel.org>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 31db0dbd7244 ("net: hso: check for allocation failure in
hso_create_bulk_serial_device()") recently started returning an error
when the driver fails to allocate resources for the interrupt endpoint
and tiocmget functionality.

For consistency let's bail out from probe also if the URB allocation
fails.

Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/net/usb/hso.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
index 260f850d69eb..b48b2a25210c 100644
--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -2635,14 +2635,14 @@ static struct hso_device *hso_create_bulk_serial_device(
 		}
 
 		tiocmget->urb = usb_alloc_urb(0, GFP_KERNEL);
-		if (tiocmget->urb) {
-			mutex_init(&tiocmget->mutex);
-			init_waitqueue_head(&tiocmget->waitq);
-		} else
-			hso_free_tiomget(serial);
-	}
-	else
+		if (!tiocmget->urb)
+			goto exit;
+
+		mutex_init(&tiocmget->mutex);
+		init_waitqueue_head(&tiocmget->waitq);
+	} else {
 		num_urbs = 1;
+	}
 
 	if (hso_serial_common_create(serial, num_urbs, BULK_URB_RX_SIZE,
 				     BULK_URB_TX_SIZE))
-- 
2.26.3

