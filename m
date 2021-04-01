Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46B30351C35
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 20:45:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237985AbhDASOH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 14:14:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236924AbhDASLl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 14:11:41 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D4A8C031149
        for <netdev@vger.kernel.org>; Thu,  1 Apr 2021 09:43:20 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id b16so2674377eds.7
        for <netdev@vger.kernel.org>; Thu, 01 Apr 2021 09:43:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BKWqsL3e4gXp+F9sxSIQ2/H/xGExoEj3G1MUBGpuqFY=;
        b=LqiEI7NvPPBr4wtOwhEmndy0k4clOZPMKOpI09X22bX/j1BpOD5TCL+sonqpuGC+i1
         TGPtnGUKiLGSiefAcgGLSr9aljAKWzS2rjxXjuNmPhDBP86TpqVIDUbn3jWLNsY7Zs67
         2vyULX86wGwtAxrWoRxYetURKMZORZufL/ALXWWIp4KrGvTN7MpDTkaYvPsA7mr79k8m
         JcLl/EVSeKh/L3sI3PLlV+UNnbuWLNuJMSaAWsKvG9AsI2B/qlT9V6tLcLZpokTLbv9l
         /AS17PWhdli28CUiN880o01jeP8JBdME7qEmrOKYZYziEIjeJu7uWVehk5+g2DwkNt+M
         dhow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BKWqsL3e4gXp+F9sxSIQ2/H/xGExoEj3G1MUBGpuqFY=;
        b=jxVYEPnM/IVvAcTbEomVlRK+VG/z8HQn2ACDkJgUXWDFyFXzBu/3mfK4vafBqOhkYt
         H/lHcsP74GjPwkYjusJ4H4rfott5wRKBi6mzCr3+1rrSQHfc4IOTo+dJtjJs9h5uDUT2
         vJgzq7ebsQOgYtXbjVAQCIkEi0+DJkgfTSbwLLM8ubrubk7uDLJGLnDMumZpk6ZN8xqJ
         boS0j7PEHuXGi52KY0JFLjWBKOMj4pjOjLqpbj1mY2N8D2dE+0wrrEChEvmAKkGvypUI
         sjyHZwtWCwlzW4xle/wN7RUiPxooLW+KJ825LxlfEuigBJDXf4PC2428VcerO3zwCV/d
         gQwQ==
X-Gm-Message-State: AOAM532x3eG3nbi4nXx/yx7/uMQHEkrqWMX4Y+uI5Ak3K1yzogJqHnMr
        Z0tpaejt0KPJbN5v+j0HJ9A=
X-Google-Smtp-Source: ABdhPJw/RltAeHIP+4Y6XTJ4bG07YJWsapsW0S3V/6e0dcy8m2DQw64SqPlbdzD+wcHbnFowT0qUBw==
X-Received: by 2002:a05:6402:26d3:: with SMTP id x19mr10881259edd.349.1617295399131;
        Thu, 01 Apr 2021 09:43:19 -0700 (PDT)
Received: from yoga-910.localhost (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id w24sm3821270edt.44.2021.04.01.09.43.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 09:43:18 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ruxandra.radulescu@nxp.com, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 2/3] dpaa2-eth: add rx copybreak support
Date:   Thu,  1 Apr 2021 19:39:55 +0300
Message-Id: <20210401163956.766628-3-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210401163956.766628-1-ciorneiioana@gmail.com>
References: <20210401163956.766628-1-ciorneiioana@gmail.com>
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
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  | 36 +++++++++++++++++--
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.h  |  2 ++
 2 files changed, 35 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index f545cb99388a..200831b41078 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -418,6 +418,33 @@ static u32 dpaa2_eth_run_xdp(struct dpaa2_eth_priv *priv,
 	return xdp_act;
 }
 
+struct sk_buff *dpaa2_eth_copybreak(struct dpaa2_eth_channel *ch,
+				    const struct dpaa2_fd *fd, void *fd_vaddr)
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
@@ -459,9 +486,12 @@ static void dpaa2_eth_rx(struct dpaa2_eth_priv *priv,
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

