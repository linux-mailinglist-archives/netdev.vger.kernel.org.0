Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 209E935292C
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 11:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234459AbhDBJ5N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Apr 2021 05:57:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234361AbhDBJ5K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Apr 2021 05:57:10 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6B29C0613E6
        for <netdev@vger.kernel.org>; Fri,  2 Apr 2021 02:57:09 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id kk2-20020a17090b4a02b02900c777aa746fso2352187pjb.3
        for <netdev@vger.kernel.org>; Fri, 02 Apr 2021 02:57:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KTZN4TM0TtROVLYP2klLnJVfOC45nICO3UWfC7ev+zU=;
        b=XNT1bSxlIUNaRPeHtXBIX5hNP25AOvni9Idw4/A51N/m8QWjzwaSLSUGFGNocQ+Rrz
         7+Td2Fga982RNfYUan8EVrmvewlNBzAtqKNAGOYIrgI8fsRjZD9Lf6/d9xTM4ufOONjw
         asO/SXe5KgIkhABI7wTGRCzyM8+H39sqrSvO5GKBnE6V2aAIBOxkvvztVbz/lxtqLPm/
         dpWRkDtcOSq76COf5qzf+VPMIjqVAud0jXX6v03Yoi8jJBYLuMa0GpI2+Pc2+RzVuZxz
         WIcoZIG0X9qOI/n3QECdIh/X+dx9uq6AJypHnzzcm984g5fBgRDQfyLJ+KCmnN9gvLt8
         NcTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KTZN4TM0TtROVLYP2klLnJVfOC45nICO3UWfC7ev+zU=;
        b=Tt5+yt1mIeQSH5FAfhH85GWSvIkxHEoluOF5TssiJ75Yj3gZHKKlQwEZWaZs8BI3bD
         fRM3uSwzhHdlbQ/OrUYNtf5GC8bvs7480fz6Msc5yXXEE3KlkbKoh+7czJUHjNRYh19k
         fVuM2ksVdmT5ejMywMdS/um1PjXbo+7WgnEcYkcjTLHlBKw4M1qsDSc8Usa4xdwp5Utk
         H/yf6nS3ddPCa8rRp0qtWnXoCuD8fvRMjg2ZAI1Aay+dY4K7L0Z6xJT9Zzmak7KUseZc
         LvwbOlbkazxigF2lNebEIkcROaI4LvYrVBCr/0mzzTMQ6Tk9mkFJRebwPQ8+po4usAvI
         8TgA==
X-Gm-Message-State: AOAM531g2wdjZseZemK0b6yyvsbeRJGqoDMSiDM/JXCdWEOhbu8bi8c7
        9hXxh4V5dtjkVsHMrTX/eyo=
X-Google-Smtp-Source: ABdhPJwPlLwLlLSinwrCSPB8n4fgTBhMHTQAhhgq59N7E9DLxFL1i9X1pwBuer1Z/131z3Y30Lvg1w==
X-Received: by 2002:a17:90b:ed0:: with SMTP id gz16mr13180749pjb.106.1617357429343;
        Fri, 02 Apr 2021 02:57:09 -0700 (PDT)
Received: from yoga-910.localhost (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id d13sm8009505pgb.6.2021.04.02.02.57.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Apr 2021 02:57:08 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ruxandra.radulescu@nxp.com, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v2 2/3] dpaa2-eth: add rx copybreak support
Date:   Fri,  2 Apr 2021 12:55:31 +0300
Message-Id: <20210402095532.925929-3-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210402095532.925929-1-ciorneiioana@gmail.com>
References: <20210402095532.925929-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

DMA unmapping, allocating a new buffer and DMA mapping it back on the
refill path is really not that efficient. Proper buffer recycling (page
pool, flipping the page and using the other half) cannot be done for
DPAA2 since it's not a ring based controller but it rather deals with
multiple queues which all get their buffers from the same buffer pool on
Rx.

To circumvent these limitations, add support for Rx copybreak. For small
sized packets instead of creating a skb around the buffer in which the
frame was received, allocate a new sk buffer altogether, copy the
contents of the frame and release the initial page back into the buffer
pool.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v2:
 - properly marked dpaa2_eth_copybreak as static

 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  | 37 +++++++++++++++++--
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.h  |  2 +
 2 files changed, 36 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index f545cb99388a..535b9079943c 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -418,6 +418,34 @@ static u32 dpaa2_eth_run_xdp(struct dpaa2_eth_priv *priv,
 	return xdp_act;
 }
 
+static struct sk_buff *dpaa2_eth_copybreak(struct dpaa2_eth_channel *ch,
+					   const struct dpaa2_fd *fd,
+					   void *fd_vaddr)
+{
+	u16 fd_offset = dpaa2_fd_get_offset(fd);
+	u32 fd_length = dpaa2_fd_get_len(fd);
+	struct sk_buff *skb = NULL;
+	unsigned int skb_len;
+
+	if (fd_length > DPAA2_ETH_DEFAULT_COPYBREAK)
+		return NULL;
+
+	skb_len = fd_length + dpaa2_eth_needed_headroom(NULL);
+
+	skb = napi_alloc_skb(&ch->napi, skb_len);
+	if (!skb)
+		return NULL;
+
+	skb_reserve(skb, dpaa2_eth_needed_headroom(NULL));
+	skb_put(skb, fd_length);
+
+	memcpy(skb->data, fd_vaddr + fd_offset, fd_length);
+
+	dpaa2_eth_recycle_buf(ch->priv, ch, dpaa2_fd_get_addr(fd));
+
+	return skb;
+}
+
 /* Main Rx frame processing routine */
 static void dpaa2_eth_rx(struct dpaa2_eth_priv *priv,
 			 struct dpaa2_eth_channel *ch,
@@ -459,9 +487,12 @@ static void dpaa2_eth_rx(struct dpaa2_eth_priv *priv,
 			return;
 		}
 
-		dma_unmap_page(dev, addr, priv->rx_buf_size,
-			       DMA_BIDIRECTIONAL);
-		skb = dpaa2_eth_build_linear_skb(ch, fd, vaddr);
+		skb = dpaa2_eth_copybreak(ch, fd, vaddr);
+		if (!skb) {
+			dma_unmap_page(dev, addr, priv->rx_buf_size,
+				       DMA_BIDIRECTIONAL);
+			skb = dpaa2_eth_build_linear_skb(ch, fd, vaddr);
+		}
 	} else if (fd_format == dpaa2_fd_sg) {
 		WARN_ON(priv->xdp_prog);
 
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
index 9ba31c2706bb..f8d2b4769983 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
@@ -489,6 +489,8 @@ struct dpaa2_eth_trap_data {
 	struct dpaa2_eth_priv *priv;
 };
 
+#define DPAA2_ETH_DEFAULT_COPYBREAK	512
+
 /* Driver private data */
 struct dpaa2_eth_priv {
 	struct net_device *net_dev;
-- 
2.30.0

