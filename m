Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7639FC3CB
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 11:16:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbfKNKQN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 05:16:13 -0500
Received: from mx2.suse.de ([195.135.220.15]:55100 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725977AbfKNKQM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Nov 2019 05:16:12 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 1693AAF59;
        Thu, 14 Nov 2019 10:16:11 +0000 (UTC)
From:   Oliver Neukum <oneukum@suse.com>
To:     tglx@linutronix.de, allison@lohutok.net, swinslow@gmail.com,
        netdev@vger.kernel.org, davem@davemloft.net
Cc:     Oliver Neukum <oneukum@suse.com>
Subject: [PATCH] ax88172a: fix information leak on short answers
Date:   Thu, 14 Nov 2019 11:16:01 +0100
Message-Id: <20191114101601.31734-1-oneukum@suse.com>
X-Mailer: git-send-email 2.16.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If a malicious device gives a short MAC it can elicit up to
5 bytes of leaked memory out of the driver. We need to check for
ETH_ALEN instead.

Reported-by: syzbot+a8d4acdad35e6bbca308@syzkaller.appspotmail.com
Signed-off-by: Oliver Neukum <oneukum@suse.com>
---
 drivers/net/usb/ax88172a.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/usb/ax88172a.c b/drivers/net/usb/ax88172a.c
index 011bd4cb546e..af3994e0853b 100644
--- a/drivers/net/usb/ax88172a.c
+++ b/drivers/net/usb/ax88172a.c
@@ -196,7 +196,7 @@ static int ax88172a_bind(struct usbnet *dev, struct usb_interface *intf)
 
 	/* Get the MAC address */
 	ret = asix_read_cmd(dev, AX_CMD_READ_NODE_ID, 0, 0, ETH_ALEN, buf, 0);
-	if (ret < 0) {
+	if (ret < ETH_ALEN) {
 		netdev_err(dev->net, "Failed to read MAC address: %d\n", ret);
 		goto free;
 	}
-- 
2.16.4

