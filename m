Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 176854361AB
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 14:29:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231582AbhJUMcF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 08:32:05 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:57202 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230190AbhJUMcE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 08:32:04 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 2EDAD218CE;
        Thu, 21 Oct 2021 12:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1634819388; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=LFZzhVTh10t2kLD4eGJur+YesRpUD6SmDnaXLC5J03I=;
        b=DRPflQtX8mNt2dGslXymUK0VGP+t/N/37CWwCpxmOauu71NI0MPmN/M2jSVEImmFHfDBKX
        91bBA6HRbjtiJj5iVP88LkECkV5LZpmr/IzXv9pL2st3F0RdqhIxzEQfNXsk6SpWcSbg5n
        Si/fkizecqf7F0kBdYwd6h72splgVo4=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C0849133A6;
        Thu, 21 Oct 2021 12:29:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id CGGqLDtdcWGGAwAAMHmgww
        (envelope-from <oneukum@suse.com>); Thu, 21 Oct 2021 12:29:47 +0000
From:   Oliver Neukum <oneukum@suse.com>
To:     syzkaller-bugs@googlegroups.com, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     Oliver Neukum <oneukum@suse.com>,
        syzbot+76bb1d34ffa0adc03baa@syzkaller.appspotmail.com
Subject: [PATCHv2] usbnet: sanity check for maxpacket
Date:   Thu, 21 Oct 2021 14:29:44 +0200
Message-Id: <20211021122944.21816-1-oneukum@suse.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

maxpacket of 0 makes no sense and oopses as we need to divide
by it. Give up.

V2: fixed typo in log and stylistic issues

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Reported-by: syzbot+76bb1d34ffa0adc03baa@syzkaller.appspotmail.com
---
 drivers/net/usb/usbnet.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index 840c1c2ab16a..80432ee0ce69 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -1788,6 +1788,10 @@ usbnet_probe (struct usb_interface *udev, const struct usb_device_id *prod)
 	if (!dev->rx_urb_size)
 		dev->rx_urb_size = dev->hard_mtu;
 	dev->maxpacket = usb_maxpacket (dev->udev, dev->out, 1);
+	if (dev->maxpacket == 0) {
+		/* that is a broken device */
+		goto out4;
+	}
 
 	/* let userspace know we have a random address */
 	if (ether_addr_equal(net->dev_addr, node_id))
-- 
2.26.2

