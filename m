Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64C873DF4C6
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 20:33:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238994AbhHCSeA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 14:34:00 -0400
Received: from h4.fbrelay.privateemail.com ([131.153.2.45]:59560 "EHLO
        h4.fbrelay.privateemail.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233681AbhHCSd7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 14:33:59 -0400
Received: from MTA-08-3.privateemail.com (mta-08-1.privateemail.com [68.65.122.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by h3.fbrelay.privateemail.com (Postfix) with ESMTPS id 858C2809D1;
        Tue,  3 Aug 2021 14:33:46 -0400 (EDT)
Received: from mta-08.privateemail.com (localhost [127.0.0.1])
        by mta-08.privateemail.com (Postfix) with ESMTP id 37AE7180019F;
        Tue,  3 Aug 2021 14:33:45 -0400 (EDT)
Received: from localhost.localdomain (unknown [10.20.151.225])
        by mta-08.privateemail.com (Postfix) with ESMTPA id 9DA5618000A1;
        Tue,  3 Aug 2021 14:33:43 -0400 (EDT)
From:   Jordy Zomer <jordy@pwning.systems>
To:     netdev@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jordy Zomer <jordy@pwning.systems>,
        Chas Williams <3chas3@gmail.com>,
        linux-atm-general@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] atm: [nicstar] make drain_scq explicitly unsigned
Date:   Tue,  3 Aug 2021 20:33:37 +0200
Message-Id: <20210803183337.927053-1-jordy@pwning.systems>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The drain_scq function used to take a signed integer as a pos parameter.
The only caller of this function passes an unsigned integer to it.
Therefore to make it obviously safe, let's just make this an unsgined
integer as this is used in pointer arithmetics.

Signed-off-by: Jordy Zomer <jordy@pwning.systems>
---
To make this patch build I added the correct function prototype.

 drivers/atm/nicstar.c | 2 +-
 1 file changed, 6 insertion(+), 6 deletion(-)

diff --git a/drivers/atm/nicstar.c b/drivers/atm/nicstar.c
index 530683972f16..96f53dc2df79 100644
--- a/drivers/atm/nicstar.c
+++ b/drivers/atm/nicstar.c
@@ -134,7 +134,7 @@ static int ns_send_bh(struct atm_vcc *vcc, struct sk_buff *skb);
 static int push_scqe(ns_dev * card, vc_map * vc, scq_info * scq, ns_scqe * tbd,
 		     struct sk_buff *skb, bool may_sleep);
 static void process_tsq(ns_dev * card);
-static void drain_scq(ns_dev * card, scq_info * scq, int pos);
+static void drain_scq(ns_dev * card, scq_info * scq, unsigned int pos);
 static void process_rsq(ns_dev * card);
 static void dequeue_rx(ns_dev * card, ns_rsqe * rsqe);
 static void recycle_rx_buf(ns_dev * card, struct sk_buff *skb);
@@ -1917,14 +1917,14 @@ static void process_tsq(ns_dev * card)
 		       card->membase + TSQH);
 }
 
-static void drain_scq(ns_dev * card, scq_info * scq, int pos)
+static void drain_scq(ns_dev *card, scq_info *scq, unsigned int pos)
 {
 	struct atm_vcc *vcc;
 	struct sk_buff *skb;
-	int i;
+	unsigned int i;
 	unsigned long flags;
 
-	XPRINTK("nicstar%d: drain_scq() called, scq at 0x%p, pos %d.\n",
+	XPRINTK("nicstar%d: drain_scq() called, scq at 0x%p, pos %u.\n",
 		card->index, scq, pos);
 	if (pos >= scq->num_entries) {
 		printk("nicstar%d: Bad index on drain_scq().\n", card->index);
@@ -1932,12 +1932,12 @@ static void drain_scq(ns_dev * card, scq_info * scq, int pos)
 	}
 
 	spin_lock_irqsave(&scq->lock, flags);
-	i = (int)(scq->tail - scq->base);
+	i = (unsigned int)(scq->tail - scq->base);
 	if (++i == scq->num_entries)
 		i = 0;
 	while (i != pos) {
 		skb = scq->skb[i];
-		XPRINTK("nicstar%d: freeing skb at 0x%p (index %d).\n",
+		XPRINTK("nicstar%d: freeing skb at 0x%p (index %u).\n",
 			card->index, skb, i);
 		if (skb != NULL) {
 			dma_unmap_single(&card->pcidev->dev,
-- 
2.27.0

