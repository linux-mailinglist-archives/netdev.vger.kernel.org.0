Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 566A9516FB3
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 14:41:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384884AbiEBMpM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 08:45:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379648AbiEBMpL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 08:45:11 -0400
X-Greylist: delayed 171 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 02 May 2022 05:41:42 PDT
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D61B13E19;
        Mon,  2 May 2022 05:41:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1651495114;
    s=strato-dkim-0002; d=goldelico.com;
    h=Message-Id:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=Z49oEEdIYwZXRaAbptW7GvAdjNwZrbaxQ4jJIY0qqw8=;
    b=IpNRoEtObH2IrY+dl9kVj6NFIGtXjC1fJSKUiU4sHorbFUxYj+dPPELsbbraW9IQpI
    fOl+m3E+CIhtq4EX33clVFgTt9SFk4ErI0txAE/5tM2DGEhzCHtojOMYgL//rXJVEaBm
    Wrffm8UUgDd6kLDw6MMWA76pGTjpyj1LIXL2sJECZNs7zwnrv1gAvieZt1gn9Cko258i
    qVjmbq0ixiMkjsv0CvoHoq6OVwuVMJQSRMMgjiLHLWz98rwQNpQD/DpJBHpyYmxqxtn3
    KtFDLww8/mE1SPL1z8fgXEcvhWfecibi5/DB+arcsZhIUQAoiQOh+m1BCUebWrim5Z79
    s03w==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":JGIXVUS7cutRB/49FwqZ7WcJeFKiMhflhwDubTJ9o1KHeBQyh+ITDDFqZQ=="
X-RZG-CLASS-ID: mo00
Received: from iMac.fritz.box
    by smtp.strato.de (RZmta 47.42.2 DYNA|AUTH)
    with ESMTPSA id k708cfy42CcXVKe
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Mon, 2 May 2022 14:38:33 +0200 (CEST)
From:   "H. Nikolaus Schaller" <hns@goldelico.com>
To:     arnd@arndb.de, tony@atomide.com, Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "H. Nikolaus Schaller" <hns@goldelico.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, letux-kernel@openphoenux.org,
        kernel@pyra-handheld.com, linux-omap@vger.kernel.org
Subject: [PATCH] wl1251: dynamically allocate memory used for DMA
Date:   Mon,  2 May 2022 14:38:32 +0200
Message-Id: <1676021ae8b6d7aada0b1806fed99b1b8359bdc4.1651495112.git.hns@goldelico.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With introduction of vmap'ed stacks, stack parameters can no
longer be used for DMA and now leads to kernel panic.

It happens at several places for the wl1251 (e.g. when
accessed through SDIO) making it unuseable on e.g. the
OpenPandora.

We solve this by allocating temporary buffers or use wl1251_read32().

Tested on v5.18-rc5 with OpenPandora.

Fixes: a1c510d0adc6 ("ARM: implement support for vmap'ed stacks")
Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
---
 drivers/net/wireless/ti/wl1251/event.c | 22 ++++++++++++++--------
 drivers/net/wireless/ti/wl1251/io.c    | 20 ++++++++++++++------
 drivers/net/wireless/ti/wl1251/tx.c    | 15 +++++++++++----
 3 files changed, 39 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/ti/wl1251/event.c b/drivers/net/wireless/ti/wl1251/event.c
index e6d426edab56b..e945aafd88ee5 100644
--- a/drivers/net/wireless/ti/wl1251/event.c
+++ b/drivers/net/wireless/ti/wl1251/event.c
@@ -169,11 +169,9 @@ int wl1251_event_wait(struct wl1251 *wl, u32 mask, int timeout_ms)
 		msleep(1);
 
 		/* read from both event fields */
-		wl1251_mem_read(wl, wl->mbox_ptr[0], &events_vector,
-				sizeof(events_vector));
+		events_vector = wl1251_mem_read32(wl, wl->mbox_ptr[0]);
 		event = events_vector & mask;
-		wl1251_mem_read(wl, wl->mbox_ptr[1], &events_vector,
-				sizeof(events_vector));
+		events_vector = wl1251_mem_read32(wl, wl->mbox_ptr[1]);
 		event |= events_vector & mask;
 	} while (!event);
 
@@ -202,7 +200,7 @@ void wl1251_event_mbox_config(struct wl1251 *wl)
 
 int wl1251_event_handle(struct wl1251 *wl, u8 mbox_num)
 {
-	struct event_mailbox mbox;
+	struct event_mailbox *mbox;
 	int ret;
 
 	wl1251_debug(DEBUG_EVENT, "EVENT on mbox %d", mbox_num);
@@ -210,12 +208,20 @@ int wl1251_event_handle(struct wl1251 *wl, u8 mbox_num)
 	if (mbox_num > 1)
 		return -EINVAL;
 
+	mbox = kmalloc(sizeof(*mbox), GFP_KERNEL);
+	if (!mbox) {
+		wl1251_error("can not allocate mbox buffer");
+		return -ENOMEM;
+	}
+
 	/* first we read the mbox descriptor */
-	wl1251_mem_read(wl, wl->mbox_ptr[mbox_num], &mbox,
-			    sizeof(struct event_mailbox));
+	wl1251_mem_read(wl, wl->mbox_ptr[mbox_num], mbox,
+			sizeof(*mbox));
 
 	/* process the descriptor */
-	ret = wl1251_event_process(wl, &mbox);
+	ret = wl1251_event_process(wl, mbox);
+	kfree(mbox);
+
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/net/wireless/ti/wl1251/io.c b/drivers/net/wireless/ti/wl1251/io.c
index 5ebe7958ed5c7..e8d567af74b4b 100644
--- a/drivers/net/wireless/ti/wl1251/io.c
+++ b/drivers/net/wireless/ti/wl1251/io.c
@@ -121,7 +121,13 @@ void wl1251_set_partition(struct wl1251 *wl,
 			  u32 mem_start, u32 mem_size,
 			  u32 reg_start, u32 reg_size)
 {
-	struct wl1251_partition partition[2];
+	struct wl1251_partition_set *partition;
+
+	partition = kmalloc(sizeof(*partition), GFP_KERNEL);
+	if (!partition) {
+		wl1251_error("can not allocate partition buffer");
+		return;
+	}
 
 	wl1251_debug(DEBUG_SPI, "mem_start %08X mem_size %08X",
 		     mem_start, mem_size);
@@ -164,10 +170,10 @@ void wl1251_set_partition(struct wl1251 *wl,
 			     reg_start, reg_size);
 	}
 
-	partition[0].start = mem_start;
-	partition[0].size  = mem_size;
-	partition[1].start = reg_start;
-	partition[1].size  = reg_size;
+	partition->mem.start = mem_start;
+	partition->mem.size  = mem_size;
+	partition->reg.start = reg_start;
+	partition->reg.size  = reg_size;
 
 	wl->physical_mem_addr = mem_start;
 	wl->physical_reg_addr = reg_start;
@@ -176,5 +182,7 @@ void wl1251_set_partition(struct wl1251 *wl,
 	wl->virtual_reg_addr = mem_size;
 
 	wl->if_ops->write(wl, HW_ACCESS_PART0_SIZE_ADDR, partition,
-		sizeof(partition));
+		sizeof(*partition));
+
+	kfree(partition);
 }
diff --git a/drivers/net/wireless/ti/wl1251/tx.c b/drivers/net/wireless/ti/wl1251/tx.c
index 98cd39619d579..e9dc3c72bb110 100644
--- a/drivers/net/wireless/ti/wl1251/tx.c
+++ b/drivers/net/wireless/ti/wl1251/tx.c
@@ -443,19 +443,25 @@ static void wl1251_tx_packet_cb(struct wl1251 *wl,
 void wl1251_tx_complete(struct wl1251 *wl)
 {
 	int i, result_index, num_complete = 0, queue_len;
-	struct tx_result result[FW_TX_CMPLT_BLOCK_SIZE], *result_ptr;
+	struct tx_result *result, *result_ptr;
 	unsigned long flags;
 
 	if (unlikely(wl->state != WL1251_STATE_ON))
 		return;
 
+	result = kmalloc_array(FW_TX_CMPLT_BLOCK_SIZE, sizeof(*result), GFP_KERNEL);
+	if (!result) {
+		wl1251_error("can not allocate result buffer");
+		return;
+	}
+
 	/* First we read the result */
-	wl1251_mem_read(wl, wl->data_path->tx_complete_addr,
-			    result, sizeof(result));
+	wl1251_mem_read(wl, wl->data_path->tx_complete_addr, result,
+			FW_TX_CMPLT_BLOCK_SIZE * sizeof(*result));
 
 	result_index = wl->next_tx_complete;
 
-	for (i = 0; i < ARRAY_SIZE(result); i++) {
+	for (i = 0; i < FW_TX_CMPLT_BLOCK_SIZE; i++) {
 		result_ptr = &result[result_index];
 
 		if (result_ptr->done_1 == 1 &&
@@ -538,6 +544,7 @@ void wl1251_tx_complete(struct wl1251 *wl)
 
 	}
 
+	kfree(result);
 	wl->next_tx_complete = result_index;
 }
 
-- 
2.33.0

