Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 145BC10509C
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 11:37:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbfKUKhX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 05:37:23 -0500
Received: from mx2.suse.de ([195.135.220.15]:43356 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726165AbfKUKhX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Nov 2019 05:37:23 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 33F22AF8A;
        Thu, 21 Nov 2019 10:37:22 +0000 (UTC)
From:   Oliver Neukum <oneukum@suse.com>
To:     allison@lohutok.net, alexios.zavras@intel.com, davem@davemloft.net,
        netdev@vger.kernel.org
Cc:     Oliver Neukum <oneukum@suse.com>
Subject: [PATCH] nfc: port100: handle command failure cleanly
Date:   Thu, 21 Nov 2019 11:37:10 +0100
Message-Id: <20191121103710.28204-1-oneukum@suse.com>
X-Mailer: git-send-email 2.16.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If starting the transfer of a command suceeds but the transfer for the reply
fails, it is not enough to initiate killing the transfer for the
command may still be running. You need to wait for the killing to finish
before you can reuse URB and buffer.

Reported-and-tested-by: syzbot+711468aa5c3a1eabf863@syzkaller.appspotmail.com
Signed-off-by: Oliver Neukum <oneukum@suse.com>
---
 drivers/nfc/port100.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nfc/port100.c b/drivers/nfc/port100.c
index 145ddf3f0a45..604dba4f18af 100644
--- a/drivers/nfc/port100.c
+++ b/drivers/nfc/port100.c
@@ -783,7 +783,7 @@ static int port100_send_frame_async(struct port100 *dev, struct sk_buff *out,
 
 	rc = port100_submit_urb_for_ack(dev, GFP_KERNEL);
 	if (rc)
-		usb_unlink_urb(dev->out_urb);
+		usb_kill_urb(dev->out_urb);
 
 exit:
 	mutex_unlock(&dev->out_urb_lock);
-- 
2.16.4

