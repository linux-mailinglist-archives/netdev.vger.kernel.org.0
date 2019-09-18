Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73729B62A4
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 14:02:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729416AbfIRMCE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 08:02:04 -0400
Received: from canardo.mork.no ([148.122.252.1]:53945 "EHLO canardo.mork.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726565AbfIRMCD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Sep 2019 08:02:03 -0400
Received: from miraculix.mork.no ([IPv6:2a02:2121:345:8091:f053:4dff:fe21:2003])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id x8IC1wUT005544
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Wed, 18 Sep 2019 14:01:59 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1568808119; bh=Uz0TZqm4Ho48Zs6Xrr3RgUGa9V3UICLeLfojVeuHbNE=;
        h=From:To:Cc:Subject:Date:Message-Id:From;
        b=lL2ZQyXK7L4rEYe0KLi5BGmp+SPxd5rI8qwR6Vj1jgKLwSuaIGEuNRFUKe5cCzr0b
         fOG4QW2qaX6q/MqcqPbl/twyCAuxcvPriZzmyKfNe99HgJEqHvKr8GmlUUQYbjfv7V
         1zqdcYCqT42bKM13p3FlADYbMrCDXi1Se/rvuWs0=
Received: from bjorn by miraculix.mork.no with local (Exim 4.92)
        (envelope-from <bjorn@miraculix.mork.no>)
        id 1iAYed-0001Bb-Vk; Wed, 18 Sep 2019 14:01:51 +0200
From:   =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
To:     netdev@vger.kernel.org
Cc:     linux-usb@vger.kernel.org, Oliver Neukum <oliver@neukum.org>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        syzbot+ce366e2b8296e25d84f5@syzkaller.appspotmail.com
Subject: [PATCH net,stable] cdc_ncm: fix divide-by-zero caused by invalid wMaxPacketSize
Date:   Wed, 18 Sep 2019 14:01:46 +0200
Message-Id: <20190918120147.4520-1-bjorn@mork.no>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.101.4 at canardo
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Endpoints with zero wMaxPacketSize are not usable for transferring
data. Ignore such endpoints when looking for valid in, out and
status pipes, to make the driver more robust against invalid and
meaningless descriptors.

The wMaxPacketSize of the out pipe is used as divisor. So this change
fixes a divide-by-zero bug.

Reported-by: syzbot+ce366e2b8296e25d84f5@syzkaller.appspotmail.com
Signed-off-by: Bjørn Mork <bjorn@mork.no>
---
#syz test: https://github.com/google/kasan.git f0df5c1b

 drivers/net/usb/cdc_ncm.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
index 50c05d0f44cb..00cab3f43a4c 100644
--- a/drivers/net/usb/cdc_ncm.c
+++ b/drivers/net/usb/cdc_ncm.c
@@ -681,8 +681,12 @@ cdc_ncm_find_endpoints(struct usbnet *dev, struct usb_interface *intf)
 	u8 ep;
 
 	for (ep = 0; ep < intf->cur_altsetting->desc.bNumEndpoints; ep++) {
-
 		e = intf->cur_altsetting->endpoint + ep;
+
+		/* ignore endpoints which cannot transfer data */
+		if (!usb_endpoint_maxp(&e->desc))
+			continue;
+
 		switch (e->desc.bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) {
 		case USB_ENDPOINT_XFER_INT:
 			if (usb_endpoint_dir_in(&e->desc)) {
-- 
2.20.1

