Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCA1F4347C1
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 11:17:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbhJTJUE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 05:20:04 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:40792 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229977AbhJTJTu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 05:19:50 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id EB9691FD47;
        Wed, 20 Oct 2021 09:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1634721455; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=g+R9ECcr894LWO3oSHMxjA3nZr4l2pEpfIypzba5F2I=;
        b=nbZQoKJEVWuICnzQbxKjPevg8SLPrnELUDuRCzhErN6vBVmRjUwRbOjgkxYCtpaBVH9083
        /XOUUJU/gjcfKd4QCCyMKhNqgJPXl5OdTK557VZq6CqMGl3TXdehfpuRxFZDLA/mNBlB57
        Qaxz+sKW0If1Iksl3FWhF76oT8UGOWQ=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9B1F313F81;
        Wed, 20 Oct 2021 09:17:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id tmYlJK/eb2FcegAAMHmgww
        (envelope-from <oneukum@suse.com>); Wed, 20 Oct 2021 09:17:35 +0000
From:   Oliver Neukum <oneukum@suse.com>
To:     syzkaller-bugs@googlegroups.com, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     Oliver Neukum <oneukum@suse.com>,
        syzbot+76bb1d34ffa0adc03baa@syzkaller.appspotmail.com
Subject: [PATCH] usbnet: sanity check for maxpacket
Date:   Wed, 20 Oct 2021 11:17:33 +0200
Message-Id: <20211020091733.20085-1-oneukum@suse.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

maxpacket of 0 makes no sense and oopdses as we need to divide
by it. Give up.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Reported-by: syzbot+76bb1d34ffa0adc03baa@syzkaller.appspotmail.com
---
 drivers/net/usb/usbnet.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index 840c1c2ab16a..396f5e677bf0 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -1788,6 +1788,9 @@ usbnet_probe (struct usb_interface *udev, const struct usb_device_id *prod)
 	if (!dev->rx_urb_size)
 		dev->rx_urb_size = dev->hard_mtu;
 	dev->maxpacket = usb_maxpacket (dev->udev, dev->out, 1);
+	if (dev->maxpacket == 0)
+		/* that is a broken device */
+		goto out4;
 
 	/* let userspace know we have a random address */
 	if (ether_addr_equal(net->dev_addr, node_id))
-- 
2.26.2

