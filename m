Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 674FB131E18
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 04:44:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727578AbgAGDoI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 22:44:08 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:38704 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727559AbgAGDoE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jan 2020 22:44:04 -0500
Received: by mail-pf1-f195.google.com with SMTP id x185so27908187pfc.5
        for <netdev@vger.kernel.org>; Mon, 06 Jan 2020 19:44:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=2hIMHWRkoNrhFsVDHwx2o3lYku7ksdqRfvz4mH1P854=;
        b=ZtsHtqLl72LjxlqRpu4wZtDIOZlOl/QTaU69JzB0V7UKOe/6NDBY7sAp580m1oFVn0
         Kzr2TEB6k1AMPitjeMXGwGOOkagQBNWTlwcqaRn9lH5xZmnq7MX2kQJe1xbkoGUgZAIE
         Bn4hQbBT5Gti8obOHtLjdMmPWUHTG1idv+y1cJC8vGZTvc6WkSlfpCjRVqBFVfH+sZHu
         MAAVf23RgRrux4gbFRPMK343u/6jYO/VHsqsK8CZxbm2cUMtXiG5Zyb5HXI2wmq+gGXk
         HPpTaEDHM9qfeOjKv/bpwaU/OiDamZh3P3lWpMIYy+TLmIJp56/+6CrNDo/OUwC4m6l5
         WLfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=2hIMHWRkoNrhFsVDHwx2o3lYku7ksdqRfvz4mH1P854=;
        b=l32A0p41K4f2TBTDuJryY5/yXcjjvS6Gn1IiW6yaGoWBg/V2b/RI8YjYgDQKQRuHPw
         6juo4Qjk1PRlF6yhybMre+rwKpHPIDJ9v0KG3Aa2DmSR49Ywe+0jSKSdThGnSXLykVF2
         yVMvS2/JE/RmFfDh5g3JrKXulK6IXQWy6yxSAohNZh1IUDyR8P1hiNxC2pm9shQYcyuf
         NLjce0B0PNcffQ8xoEyhRgXV5ycWjRdGOiMkVzXtdU6HJLko8DMelwhIUeccBtTmlaD1
         NoJBFBgTGn6M80IKkmkiWvqwOlYMvoBNXow9Zr3/SiaKvCAaIqxJdRc69z3hJJTr81C1
         TSTw==
X-Gm-Message-State: APjAAAX0mznf0YEPef8kAQlFy+jx98zLsqCahqa/GXhHF9eqUWodR8m9
        FVtSRxFHBdKh0Dv3kD/1wpCWlOEeQHc=
X-Google-Smtp-Source: APXvYqybUCuKWY7ImBADFCd9Z1NHeEH6JX8ml4LZtd5WLyVq0lqR9fT3wXjSpc3IMRveP0l+fkUvJA==
X-Received: by 2002:a62:ee11:: with SMTP id e17mr95725818pfi.48.1578368643329;
        Mon, 06 Jan 2020 19:44:03 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id a22sm85262959pfk.108.2020.01.06.19.44.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 06 Jan 2020 19:44:02 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net-next 3/4] ionic: restrict received packets to mtu size
Date:   Mon,  6 Jan 2020 19:43:48 -0800
Message-Id: <20200107034349.59268-4-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200107034349.59268-1-snelson@pensando.io>
References: <20200107034349.59268-1-snelson@pensando.io>
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

