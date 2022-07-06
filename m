Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7235D56831F
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 11:17:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232270AbiGFJPP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 05:15:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233015AbiGFJPJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 05:15:09 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC662F17;
        Wed,  6 Jul 2022 02:15:08 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 962B0200F2;
        Wed,  6 Jul 2022 09:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1657098907; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=CXJq7nxPtJXCl52sDj16G3uNZaeTHITEWJQPlk31mnY=;
        b=jaN+0bB43w4/B3ixFu4OYWOcNc8bExxYcHzTJkfUSnSK3YT8ThS+vsS0Bc0qB49I3+jt7I
        Gha941h3RPwT9+0AfgKYTBfScTDg3pY2ynvK1cnoa6IoaxJTE5gz5B6FCWMfyoMJj4VIjU
        xzFYbgSvTGnv7umWgjnEQVTtsTtDX10=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5AD8313A7D;
        Wed,  6 Jul 2022 09:15:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 7dmIFJtSxWLBOAAAMHmgww
        (envelope-from <oneukum@suse.com>); Wed, 06 Jul 2022 09:15:07 +0000
From:   Oliver Neukum <oneukum@suse.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org
Cc:     Oliver Neukum <oneukum@suse.com>
Subject: [PATCH] usbnet: modern method to get random MAC
Date:   Wed,  6 Jul 2022 11:15:04 +0200
Message-Id: <20220706091504.15306-1-oneukum@suse.com>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The old method had the bug of issuing the same
random MAC over and over even to two devices at the
same time. Instead of fixing that, this does as
Jakub suggested and moves to the modern method.

This bug is as old as the driver.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
---
 drivers/net/usb/usbnet.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index c70def1a87ca..715cc8b66776 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -61,9 +61,6 @@
 
 /*-------------------------------------------------------------------------*/
 
-// randomly generated ethernet address
-static u8	node_id [ETH_ALEN];
-
 /* use ethtool to change the level for any given device */
 static int msg_level = -1;
 module_param (msg_level, int, 0);
@@ -1725,7 +1722,6 @@ usbnet_probe (struct usb_interface *udev, const struct usb_device_id *prod)
 
 	dev->net = net;
 	strscpy(net->name, "usb%d", sizeof(net->name));
-	eth_hw_addr_set(net, node_id);
 
 	/* rx and tx sides can use different message sizes;
 	 * bind() should set rx_urb_size in that case.
@@ -1793,9 +1789,13 @@ usbnet_probe (struct usb_interface *udev, const struct usb_device_id *prod)
 		goto out4;
 	}
 
-	/* let userspace know we have a random address */
-	if (ether_addr_equal(net->dev_addr, node_id))
-		net->addr_assign_type = NET_ADDR_RANDOM;
+	/*
+	 * if the device does not come with a MAC
+	 * we ask the network core to generate us one
+	 * and flag the device accordingly
+	 */
+	if (!is_valid_ether_addr(net->dev_addr))
+		eth_hw_addr_random(net);
 
 	if ((dev->driver_info->flags & FLAG_WLAN) != 0)
 		SET_NETDEV_DEVTYPE(net, &wlan_type);
@@ -2205,7 +2205,6 @@ static int __init usbnet_init(void)
 	BUILD_BUG_ON(
 		sizeof_field(struct sk_buff, cb) < sizeof(struct skb_data));
 
-	eth_random_addr(node_id);
 	return 0;
 }
 module_init(usbnet_init);
-- 
2.35.3

