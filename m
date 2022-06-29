Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B357D560274
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 16:22:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231897AbiF2OV4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 10:21:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229982AbiF2OVz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 10:21:55 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DC741C922;
        Wed, 29 Jun 2022 07:21:54 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 0DD131F8B4;
        Wed, 29 Jun 2022 14:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1656512513; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=aOG9X1b4Ob32haIWwZ2IslSJ0NRUu/DTnEGsmTzdgcg=;
        b=I4IEOOV4hor01P3bk8KCMmAeWp34J9OTzcGqqy6G/k8nXx8H4htcDboJWSw4BzCrMRUVBP
        2f7qLRAJPAdfSK5BiSKoSTOqRfo8djeqoejy9RzC41rAhObdcoz7PnlfVl3J4sVq0r0ua/
        Ypj8KMrGlvTMjEhO5STMRPeQdbKGLl8=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C5F90133D1;
        Wed, 29 Jun 2022 14:21:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id UX7VLQBgvGJ6BwAAMHmgww
        (envelope-from <oneukum@suse.com>); Wed, 29 Jun 2022 14:21:52 +0000
From:   Oliver Neukum <oneukum@suse.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org
Cc:     Oliver Neukum <oneukum@suse.com>
Subject: [PATCH] usbnet: use each random address only once
Date:   Wed, 29 Jun 2022 16:21:49 +0200
Message-Id: <20220629142149.1298-1-oneukum@suse.com>
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

Even random MACs should be unique to a device.
Get a new one each time it is used.

This bug is as old as the driver.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
---
 drivers/net/usb/usbnet.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index 02b915b1e142..a90aece93f4a 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -1797,8 +1797,11 @@ usbnet_probe (struct usb_interface *udev, const struct usb_device_id *prod)
 	}
 
 	/* let userspace know we have a random address */
-	if (ether_addr_equal(net->dev_addr, node_id))
+	if (ether_addr_equal(net->dev_addr, node_id)) {
 		net->addr_assign_type = NET_ADDR_RANDOM;
+		/* next device needs a new one*/
+		eth_random_addr(node_id);
+	}
 
 	if ((dev->driver_info->flags & FLAG_WLAN) != 0)
 		SET_NETDEV_DEVTYPE(net, &wlan_type);
-- 
2.35.3

