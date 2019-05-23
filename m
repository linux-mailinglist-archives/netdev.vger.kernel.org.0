Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E454285D9
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 20:22:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731592AbfEWSWZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 14:22:25 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:44911 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731438AbfEWSWH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 14:22:07 -0400
Received: by mail-lf1-f68.google.com with SMTP id n134so5088681lfn.11
        for <netdev@vger.kernel.org>; Thu, 23 May 2019 11:22:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ExBErmLKvAHAcEzB9N5VayIpTNJEe2yiC9dz/BkkizE=;
        b=Jt7Fpt/PNF3rJVbtyZwTEO5En1kS6xwPMi8rxm+kvjTx0YaNdEP90fpTn5S8UqN2GI
         cHhg8f+t3VUw7xaVF2rKqUOuJN67s1dhzPuonwuom5jTwbKnbLeGDUeE/K3ONRS8MDZS
         Hi6qhk3MwbxCyUwhOiw2TnjlfbgM4yq/A2SjIMlBBw62Zqh8qp360MkN9XlAeAj0ggrx
         hW71K8v27oymqy5rtlzb36//GOX8GNMGTZaebKQz+wyYjBniLNAjLH4uITknVDQk2NLv
         fwHHXizcIebDh4VnLStsKgwFHHCQrtL8yUnbKLbKuBoOXDKMtZLrz2iP7EFQwwETks+a
         HuvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ExBErmLKvAHAcEzB9N5VayIpTNJEe2yiC9dz/BkkizE=;
        b=cEeE8PukfHM1USvkXudeQ5hV7TC7MEvUQWvu7ROMb5sBwTpOwfZEYeOkqAOuRjkvCq
         tas3LU8SPZ+Y37/FdhAEqjc+ZXXP9BgMmrMwJY+HljzBlD9tdIXlMRj0oTJeOPYTy1TQ
         1uoL7UKF+lKjJQrOUpZypXo4pS7eibu9kwnG1LTU8kg9+CRdOrRfbMXzfDbnKQb+p/s8
         FuvIQfq4IqkrxIcRVarqmwtih1EPZidTeqKi05w/NwGexLMdWQ8dvF+Tv/i+5MC7Oz0X
         CGAEkONHN0pXfWPnbgV5873+9bVQ/LzUmNz7iEh7kTvvG6CvoFp1aCMoyeAdiJnfmm9i
         mEDA==
X-Gm-Message-State: APjAAAXpG0mJuQZQsuji7JwtOuTLc7RJOhMm7myG/x4h/lsH7xlDhZyk
        FOUv6cHStIs1W00ApytMfQVLRQ==
X-Google-Smtp-Source: APXvYqyuKp+KUf1ANU2TnmMoDCiXOQcu5BOgmmiE2kEc/r5Y2vAaPFJIM2apQHa7OaebirohqJapBQ==
X-Received: by 2002:ac2:51d1:: with SMTP id u17mr7278737lfm.151.1558635724585;
        Thu, 23 May 2019 11:22:04 -0700 (PDT)
Received: from localhost.localdomain (59-201-94-178.pool.ukrtel.net. [178.94.201.59])
        by smtp.gmail.com with ESMTPSA id n26sm59904lfi.90.2019.05.23.11.22.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 May 2019 11:22:04 -0700 (PDT)
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     grygorii.strashko@ti.com, hawk@kernel.org, davem@davemloft.net
Cc:     ast@kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, xdp-newbies@vger.kernel.org,
        ilias.apalodimas@linaro.org, netdev@vger.kernel.org,
        daniel@iogearbox.net, jakub.kicinski@netronome.com,
        john.fastabend@gmail.com,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: [PATCH net-next 1/3] net: ethernet: ti: davinci_cpdma: add dma mapped submit
Date:   Thu, 23 May 2019 21:20:33 +0300
Message-Id: <20190523182035.9283-2-ivan.khoronzhuk@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190523182035.9283-1-ivan.khoronzhuk@linaro.org>
References: <20190523182035.9283-1-ivan.khoronzhuk@linaro.org>
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

