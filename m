Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6D8A301CA
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 20:21:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726563AbfE3SV2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 14:21:28 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:46425 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726786AbfE3SU6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 14:20:58 -0400
Received: by mail-lj1-f196.google.com with SMTP id m15so6974600ljg.13
        for <netdev@vger.kernel.org>; Thu, 30 May 2019 11:20:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ExBErmLKvAHAcEzB9N5VayIpTNJEe2yiC9dz/BkkizE=;
        b=DcysaYWnCA1gnUMQaWDrdM5fQsKXmvdSPN7uBZWkhioCiDLFa/PZca+gwzO2ODZUGu
         BeqQ+XolNN1zZDMTBmlKogUA2ykS1A4uAec4bRAsZhEtEMqU59dDLFjPagim1uxmY0lL
         mYZK46TUMEvcTcJPNwOjwXTifyAGBy+Sf6AWebORVwLTh5xL5ZEd8YUB1gdlmYUz/HUN
         hrG5hxWv80I9c88FHZtuPOuKMIQY+GL7Pf5NNtewzWkmUTEa/0ufXtD0h/glN9glpD6N
         KvdKGzssnzlj4lACSGsq3eQP9WVFBfMKqdFZIwUMep/1p/kimoUqfozrxCBUHF9SNaD+
         WadQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ExBErmLKvAHAcEzB9N5VayIpTNJEe2yiC9dz/BkkizE=;
        b=bVuu6GdIft8YOMev7qdHnR6gKHyaEchLSrunPYweo0kUcdHtTLGUsH/Etn8ghansB3
         iDUfEAyzv3SqG8I3zE55Hgg+lbGS8vgqI9VUfdf+6Se6fQLe2yXAQbelI9UcEkslKCAJ
         nwD58IHJoUggLk9FMPhFNwv+9nQiJl2fwTcgQPTtqSYhyCm1eEkk1sLHza7t0TQna9uR
         vs1Szj809mBQm+1J5AoioybE3o9b9VflyXqdkleYVZsIo0BYyf1brOA/3LwfvKYt1L0S
         dOQJY5MHZLyew5em97dGj1sJEzLBxzcCSqQ5PoMnf42ID6I75nCHBZwITlsz8feRISf1
         bk6w==
X-Gm-Message-State: APjAAAXqEfESyh3czn4q4YPDba0k5M6jDnLZOLy0Y8Rtq+bAZRP2Bzdp
        NmdbtPinNhVLstR67fIWGaPA0g==
X-Google-Smtp-Source: APXvYqybCMzLDu/j6u6rw70BPBf8lJXbao7SvLBHv4ExBZ/aAFxGO8ulZf+NzRyoc28S/5OHUWX0yg==
X-Received: by 2002:a2e:8555:: with SMTP id u21mr2920911ljj.133.1559240456396;
        Thu, 30 May 2019 11:20:56 -0700 (PDT)
Received: from localhost.localdomain (59-201-94-178.pool.ukrtel.net. [178.94.201.59])
        by smtp.gmail.com with ESMTPSA id v7sm388946lfe.11.2019.05.30.11.20.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 May 2019 11:20:55 -0700 (PDT)
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     grygorii.strashko@ti.com, hawk@kernel.org, davem@davemloft.net
Cc:     ast@kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, xdp-newbies@vger.kernel.org,
        ilias.apalodimas@linaro.org, netdev@vger.kernel.org,
        daniel@iogearbox.net, jakub.kicinski@netronome.com,
        john.fastabend@gmail.com,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: [PATCH v2 net-next 5/7] net: ethernet: ti: davinci_cpdma: add dma mapped submit
Date:   Thu, 30 May 2019 21:20:37 +0300
Message-Id: <20190530182039.4945-6-ivan.khoronzhuk@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190530182039.4945-1-ivan.khoronzhuk@linaro.org>
References: <20190530182039.4945-1-ivan.khoronzhuk@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In case if dma mapped packet needs to be sent, like with XDP
page pool, the "mapped" submit can be used. This patch adds dma
mapped submit based on regular one.

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
---
 drivers/net/ethernet/ti/davinci_cpdma.c | 88 ++++++++++++++++++++-----
 drivers/net/ethernet/ti/davinci_cpdma.h |  2 +
 2 files changed, 75 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/ti/davinci_cpdma.c b/drivers/net/ethernet/ti/davinci_cpdma.c
index 35bf14d8e7af..7f89b2299f05 100644
--- a/drivers/net/ethernet/ti/davinci_cpdma.c
+++ b/drivers/net/ethernet/ti/davinci_cpdma.c
@@ -125,6 +125,15 @@ struct cpdma_chan {
 	u32				rate;
 };
 
+struct submit_info {
+	struct cpdma_chan *chan;
+	int directed;
+	void *token;
+	void *data;
+	int flags;
+	int len;
+};
+
 struct cpdma_control_info {
 	u32		reg;
 	u32		shift, mask;
@@ -176,6 +185,8 @@ static struct cpdma_control_info controls[] = {
 				 (directed << CPDMA_TO_PORT_SHIFT));	\
 	} while (0)
 
+#define CPDMA_DMA_EXT_MAP		BIT(16)
+
 static void cpdma_desc_pool_destroy(struct cpdma_ctlr *ctlr)
 {
 	struct cpdma_desc_pool *pool = ctlr->pool;
@@ -1002,10 +1013,12 @@ static void __cpdma_chan_submit(struct cpdma_chan *chan,
 	}
 }
 
-int cpdma_chan_submit(struct cpdma_chan *chan, void *token, void *data,
-		      int len, int directed)
+static int cpdma_chan_submit_si(struct submit_info *si)
 {
+	struct cpdma_chan		*chan = si->chan;
 	struct cpdma_ctlr		*ctlr = chan->ctlr;
+	int				len = si->len;
+	int				swlen = len;
 	struct cpdma_desc __iomem	*desc;
 	dma_addr_t			buffer;
 	unsigned long			flags;
@@ -1037,16 +1050,22 @@ int cpdma_chan_submit(struct cpdma_chan *chan, void *token, void *data,
 		chan->stats.runt_transmit_buff++;
 	}
 
-	buffer = dma_map_single(ctlr->dev, data, len, chan->dir);
-	ret = dma_mapping_error(ctlr->dev, buffer);
-	if (ret) {
-		cpdma_desc_free(ctlr->pool, desc, 1);
-		ret = -EINVAL;
-		goto unlock_ret;
-	}
-
 	mode = CPDMA_DESC_OWNER | CPDMA_DESC_SOP | CPDMA_DESC_EOP;
-	cpdma_desc_to_port(chan, mode, directed);
+	cpdma_desc_to_port(chan, mode, si->directed);
+
+	if (si->flags & CPDMA_DMA_EXT_MAP) {
+		buffer = (dma_addr_t)si->data;
+		dma_sync_single_for_device(ctlr->dev, buffer, len, chan->dir);
+		swlen |= CPDMA_DMA_EXT_MAP;
+	} else {
+		buffer = dma_map_single(ctlr->dev, si->data, len, chan->dir);
+		ret = dma_mapping_error(ctlr->dev, buffer);
+		if (ret) {
+			cpdma_desc_free(ctlr->pool, desc, 1);
+			ret = -EINVAL;
+			goto unlock_ret;
+		}
+	}
 
 	/* Relaxed IO accessors can be used here as there is read barrier
 	 * at the end of write sequence.
@@ -1055,9 +1074,9 @@ int cpdma_chan_submit(struct cpdma_chan *chan, void *token, void *data,
 	writel_relaxed(buffer, &desc->hw_buffer);
 	writel_relaxed(len, &desc->hw_len);
 	writel_relaxed(mode | len, &desc->hw_mode);
-	writel_relaxed((uintptr_t)token, &desc->sw_token);
+	writel_relaxed((uintptr_t)si->token, &desc->sw_token);
 	writel_relaxed(buffer, &desc->sw_buffer);
-	writel_relaxed(len, &desc->sw_len);
+	writel_relaxed(swlen, &desc->sw_len);
 	desc_read(desc, sw_len);
 
 	__cpdma_chan_submit(chan, desc);
@@ -1072,6 +1091,38 @@ int cpdma_chan_submit(struct cpdma_chan *chan, void *token, void *data,
 	return ret;
 }
 
+int cpdma_chan_submit(struct cpdma_chan *chan, void *token, void *data, int len,
+		      int directed)
+{
+	struct submit_info si;
+
+	si.chan = chan;
+	si.token = token;
+	si.data = data;
+	si.len = len;
+	si.directed = directed;
+	si.flags = 0;
+
+	return cpdma_chan_submit_si(&si);
+}
+EXPORT_SYMBOL_GPL(cpdma_chan_submit);
+
+int cpdma_chan_submit_mapped(struct cpdma_chan *chan, void *token,
+			     dma_addr_t data, int len, int directed)
+{
+	struct submit_info si;
+
+	si.chan = chan;
+	si.token = token;
+	si.data = (void *)data;
+	si.len = len;
+	si.directed = directed;
+	si.flags = CPDMA_DMA_EXT_MAP;
+
+	return cpdma_chan_submit_si(&si);
+}
+EXPORT_SYMBOL_GPL(cpdma_chan_submit_mapped);
+
 bool cpdma_check_free_tx_desc(struct cpdma_chan *chan)
 {
 	struct cpdma_ctlr	*ctlr = chan->ctlr;
@@ -1097,10 +1148,17 @@ static void __cpdma_chan_free(struct cpdma_chan *chan,
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
index 10376062dafa..8f6f27185c63 100644
--- a/drivers/net/ethernet/ti/davinci_cpdma.h
+++ b/drivers/net/ethernet/ti/davinci_cpdma.h
@@ -77,6 +77,8 @@ int cpdma_chan_stop(struct cpdma_chan *chan);
 
 int cpdma_chan_get_stats(struct cpdma_chan *chan,
 			 struct cpdma_chan_stats *stats);
+int cpdma_chan_submit_mapped(struct cpdma_chan *chan, void *token,
+			     dma_addr_t data, int len, int directed);
 int cpdma_chan_submit(struct cpdma_chan *chan, void *token, void *data,
 		      int len, int directed);
 int cpdma_chan_process(struct cpdma_chan *chan, int quota);
-- 
2.17.1

