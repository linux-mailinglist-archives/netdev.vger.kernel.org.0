Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D32795A922
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 07:23:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726813AbfF2FXh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jun 2019 01:23:37 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:55360 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726788AbfF2FXg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jun 2019 01:23:36 -0400
Received: by mail-wm1-f68.google.com with SMTP id a15so10950512wmj.5
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 22:23:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=O425yuwbY1vP41J00+b+tBAP0Y03QYkt8HmN5cg10+Q=;
        b=j6fYgNnPOfDlxP8gfYq8K9Wtv3Eu0BkhDmSWoogh8QANnsuBIxgYGT0sk8tc7dt8JR
         uMqI4P6ajir7cSkOmUtWEcZtlIAWC4rOtR6dmb41TEKXP0WbHyDgiXYeMZgk0pHVdglb
         YmMXDVE9YkI9MoWwbU4jGyZ2nTVc2cZKj8CRHShv+e4npCU/2zPbNyLTBMStcDhirmKr
         OXfLOFyk71xfNIEzUPL3UAcyYr7jZdjrZTQvePtpxbZQuBW9vlXh2oXXkLTgxcaB4vjr
         2LSX6rMAl+7QYVuodXtTn4KrEjTNiaWAEmy6OBxZ0iuGftpgU4gB6pPbiztSvjjqwyFo
         3k7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=O425yuwbY1vP41J00+b+tBAP0Y03QYkt8HmN5cg10+Q=;
        b=kIFWf2xAGZGopMajPpcXKXx08Z+xmMA02PXT7Qdvi2PFTUCiscAszm/INqOUmVmjG3
         EgSOOz2CJCYrhNBc73JDa5wAcLnj0E+IQf0U9uIne3ck9EU7n75lZ9rdiPyIbo8MwxZ6
         4B/YOqmvXKj01ZswlN0tbkctRbVc3Xqn3DXyYZ044JJRKuXT7Ru2Df6a9l8xvgEvt1hJ
         nLw2kE9J9DjVGsJUDbN2c2inYfBrbC33/FREedLpIwsmLdQwPr1JXoSyJiFsbp1oqBdn
         vfKnJHMBPELDMHs250E3R5bwBrNbRBdCGYsJDtshxUNlGrVWs8hMx9gShQvUlGHB/SAl
         VZNg==
X-Gm-Message-State: APjAAAWygSysiPTCMs2FL6GhHmesTKMPfqV+2ZmDrW/WUu4VVAXoha4E
        tAvp7g+XNCcoJQPJ7UEfrcfF4zhJZ/g=
X-Google-Smtp-Source: APXvYqzgUM1wDbWdgRXYrAIiwi9Z6Hv11Z2tehU1zvRMy7HijCHvtPTSxcmJut8sNT+UL9Y2Ps/J5g==
X-Received: by 2002:a1c:7e14:: with SMTP id z20mr9158261wmc.83.1561785813852;
        Fri, 28 Jun 2019 22:23:33 -0700 (PDT)
Received: from apalos.lan (athedsl-4461147.home.otenet.gr. [94.71.2.75])
        by smtp.gmail.com with ESMTPSA id g131sm2768887wmf.37.2019.06.28.22.23.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 28 Jun 2019 22:23:33 -0700 (PDT)
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     netdev@vger.kernel.org, jaswinder.singh@linaro.org
Cc:     ard.biesheuvel@linaro.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com, brouer@redhat.com, daniel@iogearbox.net,
        ast@kernel.org, makita.toshiaki@lab.ntt.co.jp,
        jakub.kicinski@netronome.com, john.fastabend@gmail.com,
        davem@davemloft.net, maciejromanfijalkowski@gmail.com,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Subject: [net-next, PATCH 2/3, v2] net: page_pool: add helper function for retrieving dma direction
Date:   Sat, 29 Jun 2019 08:23:24 +0300
Message-Id: <1561785805-21647-3-git-send-email-ilias.apalodimas@linaro.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1561785805-21647-1-git-send-email-ilias.apalodimas@linaro.org>
References: <1561785805-21647-1-git-send-email-ilias.apalodimas@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the dma direction is stored in page pool params, offer an API
helper for driver that choose not to keep track of it locally

Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 include/net/page_pool.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/net/page_pool.h b/include/net/page_pool.h
index f07c518ef8a5..ee9c871d2043 100644
--- a/include/net/page_pool.h
+++ b/include/net/page_pool.h
@@ -112,6 +112,15 @@ static inline struct page *page_pool_dev_alloc_pages(struct page_pool *pool)
 	return page_pool_alloc_pages(pool, gfp);
 }
 
+/* get the stored dma direction. A driver might decide to treat this locally and
+ * avoid the extra cache line from page_pool to determine the direction
+ */
+static
+inline enum dma_data_direction page_pool_get_dma_dir(struct page_pool *pool)
+{
+	return pool->p.dma_dir;
+}
+
 struct page_pool *page_pool_create(const struct page_pool_params *params);
 
 void __page_pool_free(struct page_pool *pool);
-- 
2.20.1

