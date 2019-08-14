Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC2638C718
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 04:22:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729608AbfHNCTB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 22:19:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:49908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729588AbfHNCS7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Aug 2019 22:18:59 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2EA672084D;
        Wed, 14 Aug 2019 02:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565749138;
        bh=/gJJeJ8vYa7uoBni5qb8RxQkNy0sO6Fbd2ouTRdwYA4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YjaKZy9n2GiwP6/zGrrJNFYQjlZIqNqeixtoyGRESYhWN8fAp/KTOS1H/xezghGjF
         dkV5tz5rG/DSyD1hKXpQ54cJT6ZRNn7J8t02imY6CV1e1lmPCuOMBctRuCKfdSvG/D
         Ha4am6QaxtlFn7+nbWJBasSDgP/UNzMYayBnJ3jk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jia-Ju Bai <baijiaju1990@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 15/44] isdn: mISDN: hfcsusb: Fix possible null-pointer dereferences in start_isoc_chain()
Date:   Tue, 13 Aug 2019 22:18:04 -0400
Message-Id: <20190814021834.16662-15-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190814021834.16662-1-sashal@kernel.org>
References: <20190814021834.16662-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jia-Ju Bai <baijiaju1990@gmail.com>

[ Upstream commit a0d57a552b836206ad7705a1060e6e1ce5a38203 ]

In start_isoc_chain(), usb_alloc_urb() on line 1392 may fail
and return NULL. At this time, fifo->iso[i].urb is assigned to NULL.

Then, fifo->iso[i].urb is used at some places, such as:
LINE 1405:    fill_isoc_urb(fifo->iso[i].urb, ...)
                  urb->number_of_packets = num_packets;
                  urb->transfer_flags = URB_ISO_ASAP;
                  urb->actual_length = 0;
                  urb->interval = interval;
LINE 1416:    fifo->iso[i].urb->...
LINE 1419:    fifo->iso[i].urb->...

Thus, possible null-pointer dereferences may occur.

To fix these bugs, "continue" is added to avoid using fifo->iso[i].urb
when it is NULL.

These bugs are found by a static analysis tool STCheck written by us.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/isdn/hardware/mISDN/hfcsusb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/isdn/hardware/mISDN/hfcsusb.c b/drivers/isdn/hardware/mISDN/hfcsusb.c
index 35983c7c31375..163bc482b2a78 100644
--- a/drivers/isdn/hardware/mISDN/hfcsusb.c
+++ b/drivers/isdn/hardware/mISDN/hfcsusb.c
@@ -1402,6 +1402,7 @@ start_isoc_chain(struct usb_fifo *fifo, int num_packets_per_urb,
 				printk(KERN_DEBUG
 				       "%s: %s: alloc urb for fifo %i failed",
 				       hw->name, __func__, fifo->fifonum);
+				continue;
 			}
 			fifo->iso[i].owner_fifo = (struct usb_fifo *) fifo;
 			fifo->iso[i].indx = i;
-- 
2.20.1

