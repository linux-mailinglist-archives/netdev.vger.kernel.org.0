Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 916562685F0
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 09:31:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726140AbgINHbk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 03:31:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726098AbgINHa7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 03:30:59 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D86DC06174A
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 00:30:59 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id jw11so4899728pjb.0
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 00:30:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DSo9JdXLyD5at0Z0OUTEbv2pVB1Ps4z5al7gYJYxtoA=;
        b=rZaeYiYO1dPSwvAPuGIDD2uOUCXx5BfNTSxovdBLU/kVBqe4ubs94HHmAEQO2nGVxa
         HcDIWaqR/c34fm8NQJd/cLXogBi9zoG1fRitbcuqXq2/H3fy6ZwG0q8RwIH3gHOPx+i8
         /CaeYfjgWX06/UWC2M9Q/7kEqt+rAVGMDNxB1Whv5EA+yf58T8sUDuerCrTHspw//uwW
         zr/18l2ZYIznbcjHfaYM+JUMp4jAtCzGz2A78GCHtTPFYwD3KDo6KR9hf6/oPCTgltY3
         Dllpo8H3hkEScgf8+3OWTM08ppSxD3ppUHztERtkUthAZwpPEPr/6e03m2SsOnOiG2Wh
         m2jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DSo9JdXLyD5at0Z0OUTEbv2pVB1Ps4z5al7gYJYxtoA=;
        b=PNuF+L2zWHxYxbZpfcMM1xI1R61V+wIpp3Rmrp4NJbK1P4lEr1Sqkc9PKfGnTLF/tI
         YMmbPLsu4jmnaLQyAS7HU6CKdbRUgn+kt31U4LSqJu6HBBXYj6km04lVWV6TdorJfNSi
         GonLfqlMxfuenHqAOtMmVo1te8CqpzRvrT/F7mESuCtx0wHla+wbtDKD91Hi996Vq0gX
         hdM1bqo70tdGxIyu4DrmqQg+CG92Pgzd+4tqDne6OwLn3clZ3n8Vm+0ud4LWv5vJPq3O
         T5/OBBclT0d83GNIsef+F3x9sDnns4sXckC2QdBJrKC1vPsroRNkZajp4UsmuNWJpyZV
         xCRw==
X-Gm-Message-State: AOAM532YSQy9ITyDdjsXBscDtH81YhDUJvxIgBY9L2pntBf+5VKk458b
        zT1gBHbl2QSGpA12Nggezw8=
X-Google-Smtp-Source: ABdhPJxLC0qoAIduTbbDXkDuZMnC9ZDuHKI62/SidUI6iKxp0XXrk1K+EPqpCHFM5U1a0DC22E8hNw==
X-Received: by 2002:a17:90a:bf92:: with SMTP id d18mr3897530pjs.210.1600068658944;
        Mon, 14 Sep 2020 00:30:58 -0700 (PDT)
Received: from localhost.localdomain ([49.207.192.250])
        by smtp.gmail.com with ESMTPSA id a16sm7609057pgh.48.2020.09.14.00.30.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2020 00:30:58 -0700 (PDT)
From:   Allen Pais <allen.lkml@gmail.com>
To:     davem@davemloft.net
Cc:     jes@trained-monkey.org, kuba@kernel.org, dougmill@linux.ibm.com,
        cooldavid@cooldavid.org, mlindner@marvell.com,
        stephen@networkplumber.org, borisp@mellanox.com,
        netdev@vger.kernel.org, Allen Pais <apais@linux.microsoft.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [net-next v3 17/20] net: nixge: convert tasklets to use new tasklet_setup() API
Date:   Mon, 14 Sep 2020 12:59:36 +0530
Message-Id: <20200914072939.803280-18-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200914072939.803280-1-allen.lkml@gmail.com>
References: <20200914072939.803280-1-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Allen Pais <apais@linux.microsoft.com>

In preparation for unconditionally passing the
struct tasklet_struct pointer to all tasklet
callbacks, switch to using the new tasklet_setup()
and from_tasklet() to pass the tasklet pointer explicitly.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <apais@linux.microsoft.com>
---
 drivers/net/ethernet/ni/nixge.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/ni/nixge.c b/drivers/net/ethernet/ni/nixge.c
index 4075f5e59955..a6861df9904f 100644
--- a/drivers/net/ethernet/ni/nixge.c
+++ b/drivers/net/ethernet/ni/nixge.c
@@ -787,9 +787,9 @@ static irqreturn_t nixge_rx_irq(int irq, void *_ndev)
 	return IRQ_HANDLED;
 }
 
-static void nixge_dma_err_handler(unsigned long data)
+static void nixge_dma_err_handler(struct tasklet_struct *t)
 {
-	struct nixge_priv *lp = (struct nixge_priv *)data;
+	struct nixge_priv *lp = from_tasklet(lp, t, dma_err_tasklet);
 	struct nixge_hw_dma_bd *cur_p;
 	struct nixge_tx_skb *tx_skb;
 	u32 cr, i;
@@ -879,8 +879,7 @@ static int nixge_open(struct net_device *ndev)
 	phy_start(phy);
 
 	/* Enable tasklets for Axi DMA error handling */
-	tasklet_init(&priv->dma_err_tasklet, nixge_dma_err_handler,
-		     (unsigned long)priv);
+	tasklet_setup(&priv->dma_err_tasklet, nixge_dma_err_handler);
 
 	napi_enable(&priv->napi);
 
-- 
2.25.1

