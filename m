Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71AC63DC531
	for <lists+netdev@lfdr.de>; Sat, 31 Jul 2021 10:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232773AbhGaIy6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Jul 2021 04:54:58 -0400
Received: from h2.fbrelay.privateemail.com ([131.153.2.43]:35992 "EHLO
        h2.fbrelay.privateemail.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232716AbhGaIy5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Jul 2021 04:54:57 -0400
Received: from MTA-05-3.privateemail.com (mta-05-1.privateemail.com [198.54.122.55])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by h1.fbrelay.privateemail.com (Postfix) with ESMTPS id EB0D280AAC;
        Sat, 31 Jul 2021 04:54:50 -0400 (EDT)
Received: from mta-05.privateemail.com (localhost [127.0.0.1])
        by mta-05.privateemail.com (Postfix) with ESMTP id A355218001DC;
        Sat, 31 Jul 2021 04:54:49 -0400 (EDT)
Received: from localhost.localdomain (unknown [10.20.151.215])
        by mta-05.privateemail.com (Postfix) with ESMTPA id 25ED218001D2;
        Sat, 31 Jul 2021 04:54:47 -0400 (EDT)
From:   Jordy Zomer <jordy@pwning.systems>
To:     netdev@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jordy Zomer <jordy@pwning.systems>,
        Chas Williams <3chas3@gmail.com>,
        linux-atm-general@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH] atm: [nicstar] make drain_scq explicitly unsigned
Date:   Sat, 31 Jul 2021 10:54:28 +0200
Message-Id: <20210731085429.510245-1-jordy@pwning.systems>
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
 drivers/atm/nicstar.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/atm/nicstar.c b/drivers/atm/nicstar.c
index bc5a6ab6fa4b..530683972f16 100644
--- a/drivers/atm/nicstar.c
+++ b/drivers/atm/nicstar.c
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

