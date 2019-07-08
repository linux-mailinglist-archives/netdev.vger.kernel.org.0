Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DAAD62B16
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 23:35:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405380AbfGHVfJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 17:35:09 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:42499 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404564AbfGHVel (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 17:34:41 -0400
Received: by mail-lf1-f67.google.com with SMTP id s19so11207769lfb.9
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 14:34:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=3v0QmJrKMd20DJYv0qL4X2BPmLqZG0NxZOJQQTtv7T8=;
        b=ekBNtj2e0yK7B0hx60bsvCHlOLUPqUiNxuff8ENo3o2s1j55tWXtZN3Qc5OwBMp0tB
         sdkN1NBft9+mBCvNbAz8ovJR/TzWO7MwFNk0O5FrtJo+hKWnZhzlfD27KOvzsX4Y2abL
         eprUCZY+PMoMxFrrqXW3KwgBZYWx/hVQOUOR/cT99OH8zuXpFhySkuTCzv5XZ0N6Kna4
         h9K97DHN9Fo7z0/liUdkOzp6txP6XThQKiIh6aRCuj5mbLiyhkPq0fMEAD0sb8k3UtqX
         KcAIWhWtudBiydyH4Vw17+4ohhNav0bIX3bwfOXfLzMINQoXmnxDg2yJi3rhsTdQU/L+
         sMkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=3v0QmJrKMd20DJYv0qL4X2BPmLqZG0NxZOJQQTtv7T8=;
        b=ScOI+PqAx00DG7FG4JBVKt+RUj3K3gUMHVbVhvnA1vIWXCCHg64WqFkEvreg6yQ/M8
         uQLZjDUKrseN5JH6VVAbp3BCUdN/cMWBFhL7D0ce4b7OmDGKc/iGjC0ZgYGQ8CRvsln3
         oUCE42lw/gr+tOklptQ0YAItqaBq/xG/3DATJgb5SxJmaznZ8x/OBUIbH3I9W6H4nsFk
         lhA+/uXz7IrHgU0GTQsvTWjtTO2gI5vzPwkDg8kCe+Zx5/qLpasSHCi4eD/rQ1TfrvHE
         aqeBiMkfpgcXOfQqstgX1g8fCBSnsvdMca6ANnqO577CQkfE+gi/R30VOTfkpt5Z/wXR
         374g==
X-Gm-Message-State: APjAAAUejiB8tRjOORbs78IyQtOUl0sHD9Ol9G5s3DAmUzj6gbLXfv6p
        RNneX3IqMn8vEt6p/19e7epyLQ==
X-Google-Smtp-Source: APXvYqzuSkHbWFqA2+LIaHdQ5RWLN3JjNbYZjNXDuvohUpM0MoprO4NF8B0iTuzm66CN76q5PRkUAQ==
X-Received: by 2002:a19:f24e:: with SMTP id d14mr10233792lfk.184.1562621678441;
        Mon, 08 Jul 2019 14:34:38 -0700 (PDT)
Received: from localhost.localdomain (59-201-94-178.pool.ukrtel.net. [178.94.201.59])
        by smtp.gmail.com with ESMTPSA id o24sm3883096ljg.6.2019.07.08.14.34.37
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 08 Jul 2019 14:34:37 -0700 (PDT)
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     grygorii.strashko@ti.com, hawk@kernel.org, davem@davemloft.net
Cc:     ast@kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, xdp-newbies@vger.kernel.org,
        ilias.apalodimas@linaro.org, netdev@vger.kernel.org,
        daniel@iogearbox.net, jakub.kicinski@netronome.com,
        john.fastabend@gmail.com,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: [PATCH v9 net-next 2/5] net: ethernet: ti: davinci_cpdma: add dma mapped submit
Date:   Tue,  9 Jul 2019 00:34:29 +0300
Message-Id: <20190708213432.8525-3-ivan.khoronzhuk@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190708213432.8525-1-ivan.khoronzhuk@linaro.org>
References: <20190708213432.8525-1-ivan.khoronzhuk@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In case if dma mapped packet needs to be sent, like with XDP
page pool, the "mapped" submit can be used. This patch adds dma
mapped submit based on regular one.

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
---

v8..v9:
- fix warnings on arm64 caused by typos in type casting

 drivers/net/ethernet/ti/davinci_cpdma.c | 89 ++++++++++++++++++++++---
 drivers/net/ethernet/ti/davinci_cpdma.h |  4 ++
 2 files changed, 83 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/ti/davinci_cpdma.c b/drivers/net/ethernet/ti/davinci_cpdma.c
index 5cf1758d425b..4e693c3aab27 100644
--- a/drivers/net/ethernet/ti/davinci_cpdma.c
+++ b/drivers/net/ethernet/ti/davinci_cpdma.c
@@ -139,6 +139,7 @@ struct submit_info {
 	int directed;
 	void *token;
 	void *data;
+	int flags;
 	int len;
 };
 
@@ -184,6 +185,8 @@ static struct cpdma_control_info controls[] = {
 				 (directed << CPDMA_TO_PORT_SHIFT));	\
 	} while (0)
 
+#define CPDMA_DMA_EXT_MAP		BIT(16)
+
 static void cpdma_desc_pool_destroy(struct cpdma_ctlr *ctlr)
 {
 	struct cpdma_desc_pool *pool = ctlr->pool;
@@ -1015,6 +1018,7 @@ static int cpdma_chan_submit_si(struct submit_info *si)
 	struct cpdma_chan		*chan = si->chan;
 	struct cpdma_ctlr		*ctlr = chan->ctlr;
 	int				len = si->len;
+	int				swlen = len;
 	struct cpdma_desc __iomem	*desc;
 	dma_addr_t			buffer;
 	u32				mode;
@@ -1036,16 +1040,22 @@ static int cpdma_chan_submit_si(struct submit_info *si)
 		chan->stats.runt_transmit_buff++;
 	}
 
-	buffer = dma_map_single(ctlr->dev, si->data, len, chan->dir);
-	ret = dma_mapping_error(ctlr->dev, buffer);
-	if (ret) {
-		cpdma_desc_free(ctlr->pool, desc, 1);
-		return -EINVAL;
-	}
-
 	mode = CPDMA_DESC_OWNER | CPDMA_DESC_SOP | CPDMA_DESC_EOP;
 	cpdma_desc_to_port(chan, mode, si->directed);
 
+	if (si->flags & CPDMA_DMA_EXT_MAP) {
+		buffer = (dma_addr_t)si->data;
+		dma_sync_single_for_device(ctlr->dev, buffer, len, chan->dir);
+		swlen |= CPDMA_DMA_EXT_MAP;
+	} else {
+		buffer = dma_map_single(ctlr->dev, si->data, len, chan->dir);
+		ret = dma_mapping_error(ctlr->dev, buffer);
+		if (ret) {
+			cpdma_desc_free(ctlr->pool, desc, 1);
+			return -EINVAL;
+		}
+	}
+
 	/* Relaxed IO accessors can be used here as there is read barrier
 	 * at the end of write sequence.
 	 */
@@ -1055,7 +1065,7 @@ static int cpdma_chan_submit_si(struct submit_info *si)
 	writel_relaxed(mode | len, &desc->hw_mode);
 	writel_relaxed((uintptr_t)si->token, &desc->sw_token);
 	writel_relaxed(buffer, &desc->sw_buffer);
-	writel_relaxed(len, &desc->sw_len);
+	writel_relaxed(swlen, &desc->sw_len);
 	desc_read(desc, sw_len);
 
 	__cpdma_chan_submit(chan, desc);
@@ -1079,6 +1089,32 @@ int cpdma_chan_idle_submit(struct cpdma_chan *chan, void *token, void *data,
 	si.data = data;
 	si.len = len;
 	si.directed = directed;
+	si.flags = 0;
+
+	spin_lock_irqsave(&chan->lock, flags);
+	if (chan->state == CPDMA_STATE_TEARDOWN) {
+		spin_unlock_irqrestore(&chan->lock, flags);
+		return -EINVAL;
+	}
+
+	ret = cpdma_chan_submit_si(&si);
+	spin_unlock_irqrestore(&chan->lock, flags);
+	return ret;
+}
+
+int cpdma_chan_idle_submit_mapped(struct cpdma_chan *chan, void *token,
+				  dma_addr_t data, int len, int directed)
+{
+	struct submit_info si;
+	unsigned long flags;
+	int ret;
+
+	si.chan = chan;
+	si.token = token;
+	si.data = (void *)data;
+	si.len = len;
+	si.directed = directed;
+	si.flags = CPDMA_DMA_EXT_MAP;
 
 	spin_lock_irqsave(&chan->lock, flags);
 	if (chan->state == CPDMA_STATE_TEARDOWN) {
@@ -1103,6 +1139,32 @@ int cpdma_chan_submit(struct cpdma_chan *chan, void *token, void *data,
 	si.data = data;
 	si.len = len;
 	si.directed = directed;
+	si.flags = 0;
+
+	spin_lock_irqsave(&chan->lock, flags);
+	if (chan->state != CPDMA_STATE_ACTIVE) {
+		spin_unlock_irqrestore(&chan->lock, flags);
+		return -EINVAL;
+	}
+
+	ret = cpdma_chan_submit_si(&si);
+	spin_unlock_irqrestore(&chan->lock, flags);
+	return ret;
+}
+
+int cpdma_chan_submit_mapped(struct cpdma_chan *chan, void *token,
+			     dma_addr_t data, int len, int directed)
+{
+	struct submit_info si;
+	unsigned long flags;
+	int ret;
+
+	si.chan = chan;
+	si.token = token;
+	si.data = (void *)data;
+	si.len = len;
+	si.directed = directed;
+	si.flags = CPDMA_DMA_EXT_MAP;
 
 	spin_lock_irqsave(&chan->lock, flags);
 	if (chan->state != CPDMA_STATE_ACTIVE) {
@@ -1140,10 +1202,17 @@ static void __cpdma_chan_free(struct cpdma_chan *chan,
 	uintptr_t			token;
 
 	token      = desc_read(desc, sw_token);
-	buff_dma   = desc_read(desc, sw_buffer);
 	origlen    = desc_read(desc, sw_len);
 
-	dma_unmap_single(ctlr->dev, buff_dma, origlen, chan->dir);
+	buff_dma   = desc_read(desc, sw_buffer);
+	if (origlen & CPDMA_DMA_EXT_MAP) {
+		origlen &= ~CPDMA_DMA_EXT_MAP;
+		dma_sync_single_for_cpu(ctlr->dev, buff_dma, origlen,
+					chan->dir);
+	} else {
+		dma_unmap_single(ctlr->dev, buff_dma, origlen, chan->dir);
+	}
+
 	cpdma_desc_free(pool, desc, 1);
 	(*chan->handler)((void *)token, outlen, status);
 }
diff --git a/drivers/net/ethernet/ti/davinci_cpdma.h b/drivers/net/ethernet/ti/davinci_cpdma.h
index 9343c8c73c1b..0271a20c2e09 100644
--- a/drivers/net/ethernet/ti/davinci_cpdma.h
+++ b/drivers/net/ethernet/ti/davinci_cpdma.h
@@ -77,8 +77,12 @@ int cpdma_chan_stop(struct cpdma_chan *chan);
 
 int cpdma_chan_get_stats(struct cpdma_chan *chan,
 			 struct cpdma_chan_stats *stats);
+int cpdma_chan_submit_mapped(struct cpdma_chan *chan, void *token,
+			     dma_addr_t data, int len, int directed);
 int cpdma_chan_submit(struct cpdma_chan *chan, void *token, void *data,
 		      int len, int directed);
+int cpdma_chan_idle_submit_mapped(struct cpdma_chan *chan, void *token,
+				  dma_addr_t data, int len, int directed);
 int cpdma_chan_idle_submit(struct cpdma_chan *chan, void *token, void *data,
 			   int len, int directed);
 int cpdma_chan_process(struct cpdma_chan *chan, int quota);
-- 
2.17.1

