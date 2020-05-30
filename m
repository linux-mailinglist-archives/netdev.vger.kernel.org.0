Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 059421E8D37
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 04:42:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728723AbgE3CmD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 22:42:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728349AbgE3CmC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 22:42:02 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9F6FC03E969;
        Fri, 29 May 2020 19:42:01 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id n15so721836pfd.0;
        Fri, 29 May 2020 19:42:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=fGrrWjcEntb5vKbrRUSp/FxAelb8+WaMzkd+FIBilnQ=;
        b=RuqGs6ZvSIz8rrZMxPc5kzHpPZgS1zAwqs5crioiQHe7rJvPcO5cFH2kWptgmbAvTX
         hbwK+8SaxhuIDWYnyAikNW8lPWxDo6e1NKaikOuO83JZtrz1amL4xLgG+BxcOb6PbtyA
         hMEMuP1Z1QYoWycNZiUwSUvwC7jrae0asf4y+ed+VlD9JxnK1lp3xGImo0kHk/pL6Fgv
         fHczYpEt7foV/KvG62jjmtx4MX8dddUW5IRciqfbTxWJUzVcxJoqw+AkYypaQ0Is3Jbr
         +s2oxqzlsjvQMVCPZuCwqmK/00kdV53X9Z9V0J+vPCpS06nEEnYz0kEUCKmY3PkhVQ0l
         Fcug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=fGrrWjcEntb5vKbrRUSp/FxAelb8+WaMzkd+FIBilnQ=;
        b=hru6+uEJHpCB/s6Cob5nl511IaCifpl535d4yzGPCKIn+EglGMTgLgdlNe5Rl/fRLZ
         Wts/fawHTyQC+3ianYGxFujp8T/fkagk04YZdqEiStfdC6AnjwlsdkSXlCXnjXmRrV8N
         89ocusFZZAmLMKF/eikkxN00oCdcJxy0y46/GVv1xt/SsYOoBEsUEie/+xa5tPdkK/Di
         nTQAYYl8yG7WVg4CZ/mZ0EyoK20qThb9vPc8zVEn0ZAlBzPvmaP2D5Dmun0oarXHCvJj
         hnmdCJ1F+6tNboaJL6ymYoG4WKA5vmTUKGBrTOh5icRxvWD9iypZyveVa8U6G/CaofUD
         t5Vw==
X-Gm-Message-State: AOAM531cdDTRvX9zkDXxhqh4QeGQsL8wX87TMTR23tb/3R1uGTMGpWCd
        v454ATVwIh1oho6T+J5rd8g=
X-Google-Smtp-Source: ABdhPJyXCP9+QXCV55ssSejQI/Q2GACI+ixL7ro7XhDFEHCmln2tW1VOO7gqpD/yHTYot8n6o4aDdA==
X-Received: by 2002:a63:5d62:: with SMTP id o34mr10724012pgm.420.1590806521211;
        Fri, 29 May 2020 19:42:01 -0700 (PDT)
Received: from oslab.tsinghua.edu.cn ([166.111.139.172])
        by smtp.gmail.com with ESMTPSA id e19sm8316474pfn.17.2020.05.29.19.41.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2020 19:42:00 -0700 (PDT)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     doshir@vmware.com, pv-drivers@vmware.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] net: vmxnet3: fix possible buffer overflow caused by bad DMA value in vmxnet3_get_rss()
Date:   Sat, 30 May 2020 10:41:50 +0800
Message-Id: <20200530024150.27308-1-baijiaju1990@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The value adapter->rss_conf is stored in DMA memory, and it is assigned
to rssConf, so rssConf->indTableSize can be modified at anytime by
malicious hardware. Because rssConf->indTableSize is assigned to n,
buffer overflow may occur when the code "rssConf->indTable[n]" is
executed.

To fix this possible bug, n is checked after being used.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/net/vmxnet3/vmxnet3_ethtool.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/vmxnet3/vmxnet3_ethtool.c b/drivers/net/vmxnet3/vmxnet3_ethtool.c
index 6528940ce5f3..b53bb8bcd47f 100644
--- a/drivers/net/vmxnet3/vmxnet3_ethtool.c
+++ b/drivers/net/vmxnet3/vmxnet3_ethtool.c
@@ -700,6 +700,8 @@ vmxnet3_get_rss(struct net_device *netdev, u32 *p, u8 *key, u8 *hfunc)
 		*hfunc = ETH_RSS_HASH_TOP;
 	if (!p)
 		return 0;
+	if (n > UPT1_RSS_MAX_IND_TABLE_SIZE)
+		return 0;
 	while (n--)
 		p[n] = rssConf->indTable[n];
 	return 0;
-- 
2.17.1

