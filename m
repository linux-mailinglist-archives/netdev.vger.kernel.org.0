Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 666BA268E9F
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 16:58:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbgINOvs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 10:51:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726870AbgINOut (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 10:50:49 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED00EC06174A;
        Mon, 14 Sep 2020 07:50:48 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id jw11so5506464pjb.0;
        Mon, 14 Sep 2020 07:50:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=d8JhAydeJgefGcMif2aqEmRa87zNidg2BYdeV5TRysU=;
        b=rEBAJXIPgWFeFv48z0G034XmF5qyYKI8w77dhSIioMYD0pB360QUqSbkUQx7/dYyIN
         1ogo1Q6N57fvdPlu3yZGGg92mTxLQ0i699CUJPJ27kghAF4R65/0inCaQYXbiXKXhPh/
         rW79P8oaCpADUhmqjmhiGQW09r/BUxlZ2Y1N4KgsYyyRs34UFViXF1X59vieEtIQrmZT
         ouwgTMFbbkCFbNIXgLST6W1mIUH1nn1B71LACxpdfhlaCv+c3E/eafuf6sPdZEU78/ix
         S57ft4z2iJkabHUV3YEDgDE6TjwXx0M55oQvokxP3250YfcoHI6uktbDIsFLvG9nF9F0
         xrig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=d8JhAydeJgefGcMif2aqEmRa87zNidg2BYdeV5TRysU=;
        b=BC4vAvlPt+QvNc6luAF5wcUcQwjAsVMF3UhRDfsw8K7+BClmcm9CpBOe7PopbFsJJi
         gW/YlA1jRyKh5ySUoAKYGSOHhl2deZFSLvuKMV0jfbh8D5uAiGAf4vA1WJKODOt6MAVO
         wLPtmXaIy+AlxDU2ogdfRi/LDEpMpm6VWh1oN/BWvSxXXYosUxsQcjrmzhzFcmfsSX01
         frLhYkP7AJEKUHJPrqLeWkDR/bzLTKPrEzp7QqwJQEUXzGz5bHUGMo3FwVBhTpSxpyDA
         Lty7yeTbDzB776WDlaupfbVBUWiLN7TvukXaPM3sNPX1sYjd/kO94WZI1HgtMQVy9zc9
         0c8A==
X-Gm-Message-State: AOAM530IbHxSout9orkZmgaVvBazgD45AYF8HeYNcUdTLCwbLdZ4t35j
        QW0nCfttkui/7QW4Ab8Uvy3zjxR+Oh2ev29D
X-Google-Smtp-Source: ABdhPJwRbGVDmXvZPWplKpXl+DdNNzdc86yp+kBxIACMjdMnl7ZNd48lPTfj4zv024y73ghGOGD1PA==
X-Received: by 2002:a17:90a:1903:: with SMTP id 3mr14332402pjg.74.1600095048554;
        Mon, 14 Sep 2020 07:50:48 -0700 (PDT)
Received: from VM.ger.corp.intel.com ([192.55.55.43])
        by smtp.gmail.com with ESMTPSA id q7sm8608849pgg.10.2020.09.14.07.50.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 14 Sep 2020 07:50:48 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com
Cc:     bpf@vger.kernel.org
Subject: [PATCH bpf-next] xsk: fix refcount warning in xp_dma_map
Date:   Mon, 14 Sep 2020 16:50:36 +0200
Message-Id: <1600095036-23868-1-git-send-email-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Fix a potential refcount warning that a zero value is increased to one
in xp_dma_map, by initializing the refcount to one to start with,
instead of zero plus a refcount_inc().

Fixes: 921b68692abb ("xsk: Enable sharing of dma mappings")
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 net/xdp/xsk_buff_pool.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
index 5b00bc5..e63fadd 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -296,7 +296,7 @@ static struct xsk_dma_map *xp_create_dma_map(struct device *dev, struct net_devi
 	dma_map->dev = dev;
 	dma_map->dma_need_sync = false;
 	dma_map->dma_pages_cnt = nr_pages;
-	refcount_set(&dma_map->users, 0);
+	refcount_set(&dma_map->users, 1);
 	list_add(&dma_map->list, &umem->xsk_dma_list);
 	return dma_map;
 }
@@ -369,7 +369,6 @@ static int xp_init_dma_info(struct xsk_buff_pool *pool, struct xsk_dma_map *dma_
 	pool->dev = dma_map->dev;
 	pool->dma_pages_cnt = dma_map->dma_pages_cnt;
 	pool->dma_need_sync = dma_map->dma_need_sync;
-	refcount_inc(&dma_map->users);
 	memcpy(pool->dma_pages, dma_map->dma_pages,
 	       pool->dma_pages_cnt * sizeof(*pool->dma_pages));
 
@@ -390,6 +389,7 @@ int xp_dma_map(struct xsk_buff_pool *pool, struct device *dev,
 		if (err)
 			return err;
 
+		refcount_inc(&dma_map->users);
 		return 0;
 	}
 
-- 
2.7.4

