Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 886CA131A0F
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 22:05:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727134AbgAFVFZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 16:05:25 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:45328 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727105AbgAFVFX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jan 2020 16:05:23 -0500
Received: by mail-pf1-f196.google.com with SMTP id 2so27488439pfg.12
        for <netdev@vger.kernel.org>; Mon, 06 Jan 2020 13:05:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=2hIMHWRkoNrhFsVDHwx2o3lYku7ksdqRfvz4mH1P854=;
        b=nNpu6RRLSnTQ5onTUQV3gqp6y4tabZ8GyKSpGpA/OknI2PC87eC2PDZuY3V5UNhwPq
         uylcdYs42i+wgROjRft5361MNyT9BtTGZhKXUeJ77QTIzZxf1jenyRCYA7fQyGj2exW8
         1VKXR/H7+QYUeYKWmcVY7HQfiXeQVTKCqS53zPzaWf/1bi8HRyDkicZuJ4fLEKhUGje/
         HDWH4hvJbnqdTjn1nVPB0PgT72AnHhzuuOdFVlNCJzWj0h8iFYN6lifxY4MplxpGV2qA
         oqxOoPAwXGbE9c1s9DDZlZNIw9f4NLtxDa7S2RGeEAc1+J8glDOct6a9CXiv8GPFBjkZ
         iioA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=2hIMHWRkoNrhFsVDHwx2o3lYku7ksdqRfvz4mH1P854=;
        b=fmtWtQUA+W+0uF/vhvc6px0EcXmDPux7BFpMohfyJiwSBlmGGoLhitn8LYeuCxz4WO
         /bBevUlXh6yxmxwu/0IP0NjyvHIEOam/w4vgUwkDTCxdhidjazZbMXWpp8UnIa45/yH+
         epPcKyWu4dmBXZxOUz0NnUgt4U+IrpFP1G3MvCoCRjwwKIpnxBCl4coDe7XK5l99BOUj
         JFA9OeTfh5v0ZbfoV+aRqTSZ4DTiPaoqX4sl0Y/ehCMVfCFG3xBupNYg6h9P98zNoIR3
         g3Oa9+4o9wlvlEgnzu4wzPhd76S7sZUSYAGh7aQhYi3VcvdYJZJN/VJYUD5pLQ5483F0
         RRLg==
X-Gm-Message-State: APjAAAUBMmaGEyE3cJTY81G97oES5iGW4bzXvi0dHumnlehP7FdAChWi
        i8r5CNmw2K1ExciRbtSo3c0JlVlI2yw=
X-Google-Smtp-Source: APXvYqz2d0xvMwB0sY/KsbVqjum1v5qu1DTdgfsvpMn489dM5Gn1YEU0bOQDSw8xZLzflyuSzfkt6g==
X-Received: by 2002:a65:68ca:: with SMTP id k10mr115134625pgt.222.1578344722487;
        Mon, 06 Jan 2020 13:05:22 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id p16sm63183003pfq.184.2020.01.06.13.05.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 06 Jan 2020 13:05:21 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 4/4] ionic: restrict received packets to mtu size
Date:   Mon,  6 Jan 2020 13:05:12 -0800
Message-Id: <20200106210512.34244-5-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200106210512.34244-1-snelson@pensando.io>
References: <20200106210512.34244-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make sure the NIC drops packets that are larger than the
specified MTU.

The front end of the NIC will accept packets larger than MTU and
will copy all the data it can to fill up the driver's posted
buffers - if the buffers are not long enough the packet will
then get dropped.  With the Rx SG buffers allocagted as full
pages, we are currently setting up more space than MTU size
available and end up receiving some packets that are larger
than MTU, up to the size of buffers posted.  To be sure the
NIC doesn't waste our time with oversized packets we need to
lie a little in the SG descriptor about how long is the last
SG element.

At dealloc time, we know the allocation was a page, so the
deallocation doesn't care about what length we put in the
descriptor.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_txrx.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
index a009bbe9f9be..e452f4242ba0 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
@@ -343,6 +343,8 @@ void ionic_rx_fill(struct ionic_queue *q)
 	struct ionic_rxq_sg_desc *sg_desc;
 	struct ionic_rxq_sg_elem *sg_elem;
 	struct ionic_rxq_desc *desc;
+	unsigned int remain_len;
+	unsigned int seg_len;
 	unsigned int nfrags;
 	bool ring_doorbell;
 	unsigned int i, j;
@@ -352,6 +354,7 @@ void ionic_rx_fill(struct ionic_queue *q)
 	nfrags = round_up(len, PAGE_SIZE) / PAGE_SIZE;
 
 	for (i = ionic_q_space_avail(q); i; i--) {
+		remain_len = len;
 		desc_info = q->head;
 		desc = desc_info->desc;
 		sg_desc = desc_info->sg_desc;
@@ -375,7 +378,9 @@ void ionic_rx_fill(struct ionic_queue *q)
 			return;
 		}
 		desc->addr = cpu_to_le64(page_info->dma_addr);
-		desc->len = cpu_to_le16(PAGE_SIZE);
+		seg_len = min_t(unsigned int, PAGE_SIZE, len);
+		desc->len = cpu_to_le16(seg_len);
+		remain_len -= seg_len;
 		page_info++;
 
 		/* fill sg descriptors - pages[1..n] */
@@ -391,7 +396,9 @@ void ionic_rx_fill(struct ionic_queue *q)
 				return;
 			}
 			sg_elem->addr = cpu_to_le64(page_info->dma_addr);
-			sg_elem->len = cpu_to_le16(PAGE_SIZE);
+			seg_len = min_t(unsigned int, PAGE_SIZE, remain_len);
+			sg_elem->len = cpu_to_le16(seg_len);
+			remain_len -= seg_len;
 			page_info++;
 		}
 
-- 
2.17.1

