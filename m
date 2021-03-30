Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8345A34F1D6
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 21:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233290AbhC3Twj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 15:52:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233250AbhC3Tw1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 15:52:27 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA736C061574
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 12:52:27 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id f2-20020a17090a4a82b02900c67bf8dc69so10021657pjh.1
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 12:52:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Hjp36YVQCEN7242R32qoUQEFP1Ou+GKP/PepmS7kURk=;
        b=yoTAgZo+jNjxSGoWOm12m/8bg87JncPigxtUuZMammWqWIwWExHqsGbPZ0fbpSInkh
         pPh0HEWml2pI3X3Ng83ltW8zrZX7fd05Z3MZRPGe+Aetg9S1sTV4tNfn/rPMhGMMizEX
         UlQT2evX3EWJ4O1cMwzXcsHjnUGcNwwu+L/GQlTfUNosYvfeiVo6/FFwC4II/Na4cqez
         fqUcvJDsFIc2Lq+AAiwnUrIZW1+NvnEgJzWh5Of+3Pz6nmeO6mxvA368ilvHuC05783b
         oEvPaun6QqmjLUEKuAhv0GJ9PFMuAAfQnHWLlZRb+4nNNspYaQ4UvXujB5A78VnrR11G
         cBMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Hjp36YVQCEN7242R32qoUQEFP1Ou+GKP/PepmS7kURk=;
        b=EKfe9euvnZBL7zH8O67gHP4VsVFRH79mQVEngURs5VBotmnf/Lc7Fg/69ddkj7Vbve
         N/WqNAiJXkzUpaYGt6fMUjbtWSzxXSapaKQl5+4U/DLGAaoePkOB11n3w9Pzl3KzDNxR
         3V8r3npvNPrj92g68fYvHMZks8Ul8TWBJKkRCJPxGYkG1rtaDphjdJGZxa+KP//QVhCX
         fOVd6Lc2H4btOFy3zK/GUPfr4i38NCyUBynzFxVOVkjScM7sLX1/lduCSaL83ineUfRi
         Tc4bcv2A054eaxdN4p3RIZWnlurnuhl/7AJAtDAS85hghZ79411Zhz1u0XdcFmF7PLGi
         Bmlg==
X-Gm-Message-State: AOAM531n11gtdMqxbnimTQ2lz4Z700Hv1alYbelyPXfMJlbe0MS++r5f
        GmOP2gOElifMUysNkn+3L1okaavfoyQJ3g==
X-Google-Smtp-Source: ABdhPJxBxqorvWLhaqNjxRavH3e1zeAZbip16WKQrv7taN3Vwk+2FwgUkjDBvMivlUDzJccek2X3Nw==
X-Received: by 2002:a17:90a:8c86:: with SMTP id b6mr7095pjo.8.1617133946796;
        Tue, 30 Mar 2021 12:52:26 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id y8sm20433pge.56.2021.03.30.12.52.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Mar 2021 12:52:26 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 1/4] ionic: count dma errors
Date:   Tue, 30 Mar 2021 12:52:07 -0700
Message-Id: <20210330195210.49069-2-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210330195210.49069-1-snelson@pensando.io>
References: <20210330195210.49069-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Increment our dma-error counter in a couple of spots
that were missed before.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_txrx.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
index 5985f7c504a9..42d29cd2ca47 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
@@ -609,6 +609,7 @@ static int ionic_tx_map_skb(struct ionic_queue *q, struct sk_buff *skb,
 			    struct ionic_desc_info *desc_info)
 {
 	struct ionic_buf_info *buf_info = desc_info->bufs;
+	struct ionic_tx_stats *stats = q_to_tx_stats(q);
 	struct device *dev = q->dev;
 	dma_addr_t dma_addr;
 	unsigned int nfrags;
@@ -616,8 +617,10 @@ static int ionic_tx_map_skb(struct ionic_queue *q, struct sk_buff *skb,
 	int frag_idx;
 
 	dma_addr = ionic_tx_map_single(q, skb->data, skb_headlen(skb));
-	if (dma_mapping_error(dev, dma_addr))
+	if (dma_mapping_error(dev, dma_addr)) {
+		stats->dma_map_err++;
 		return -EIO;
+	}
 	buf_info->dma_addr = dma_addr;
 	buf_info->len = skb_headlen(skb);
 	buf_info++;
@@ -626,8 +629,10 @@ static int ionic_tx_map_skb(struct ionic_queue *q, struct sk_buff *skb,
 	nfrags = skb_shinfo(skb)->nr_frags;
 	for (frag_idx = 0; frag_idx < nfrags; frag_idx++, frag++) {
 		dma_addr = ionic_tx_map_frag(q, frag, 0, skb_frag_size(frag));
-		if (dma_mapping_error(dev, dma_addr))
+		if (dma_mapping_error(dev, dma_addr)) {
+			stats->dma_map_err++;
 			goto dma_fail;
+		}
 		buf_info->dma_addr = dma_addr;
 		buf_info->len = skb_frag_size(frag);
 		buf_info++;
-- 
2.17.1

