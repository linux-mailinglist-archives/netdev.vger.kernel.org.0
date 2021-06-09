Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AE1A3A1603
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 15:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236643AbhFINuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 09:50:21 -0400
Received: from mail-wm1-f41.google.com ([209.85.128.41]:38423 "EHLO
        mail-wm1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232911AbhFINuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 09:50:16 -0400
Received: by mail-wm1-f41.google.com with SMTP id t4-20020a1c77040000b029019d22d84ebdso4333110wmi.3;
        Wed, 09 Jun 2021 06:48:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ESskJJKWWlduLfjCtKwaFwkDwGwCfUguoy2FpDTie+U=;
        b=ktisJstPHmRLQbwP+cBMho7+TeT7LzqBXyVxdRx3tllWah03ZfzuSZfTSZsiMAp7wB
         CoEHLcHx+B1SOaZVG+t5LE2ucZKHpiUA6vfYhmR0RuX2+JdtQ7u5jjgVZkCvnQF7ZJ5a
         GbvmZoCo+6g/LC2ocIKd0pKhctR9YooHeLZpPIf+XosovcqCgE1RcVQGIz0pPXSfrBfw
         5eoF9lmAuPSOLaMCZcYhlU6hWbkOXwBsLcvL7h5Q4gRJBBbzP4IaT4wPHYKLf8ShoxiI
         hnXazIPUZ4jsOH/SKbEi+Py5NPFZ0Yr6uG+55MfJ8VQ81IGLf8ud3mCeiZJ3tHiVFZlg
         XjDA==
X-Gm-Message-State: AOAM533tSwUmi8IGtik4eKH1d14UAFZrKM8BbBl/iLnUWSpBBmngFQOd
        kDKU3sUZZFbPa2n8v4jzOFsBtzmuzbKksQ==
X-Google-Smtp-Source: ABdhPJzUFqClOwwnV3jDQgDgg8y0vsvrmryRlJh82cCs1Yqy4hfuoAr6jQ8xXMvcRpFt1KdxqvrMIw==
X-Received: by 2002:a05:600c:1c22:: with SMTP id j34mr10239192wms.166.1623246492759;
        Wed, 09 Jun 2021 06:48:12 -0700 (PDT)
Received: from msft-t490s.teknoraver.net (net-37-119-128-179.cust.vodafonedsl.it. [37.119.128.179])
        by smtp.gmail.com with ESMTPSA id o5sm13882351wrw.65.2021.06.09.06.48.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jun 2021 06:48:12 -0700 (PDT)
From:   Matteo Croce <mcroce@linux.microsoft.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sven Auhagen <sven.auhagen@voleatech.de>
Subject: [PATCH net-next 1/2] mvpp2: prefetch right address
Date:   Wed,  9 Jun 2021 15:47:13 +0200
Message-Id: <20210609134714.13715-2-mcroce@linux.microsoft.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210609134714.13715-1-mcroce@linux.microsoft.com>
References: <20210609134714.13715-1-mcroce@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matteo Croce <mcroce@microsoft.com>

In the RX buffer, the received data starts after a headroom used to
align the IP header and to allow prepending headers efficiently.
The prefetch() should take this into account, and prefetch from
the very start of the received data.

We can see that ether_addr_equal_64bits(), which is the first function
to access the data, drops from the top of the perf top output.

prefetch(data):

Overhead  Shared Object     Symbol
  11.64%  [kernel]          [k] eth_type_trans

prefetch(data + MVPP2_MH_SIZE + MVPP2_SKB_HEADROOM):

Overhead  Shared Object     Symbol
  13.42%  [kernel]          [k] build_skb
  10.35%  [mvpp2]           [k] mvpp2_rx
   9.35%  [kernel]          [k] __netif_receive_skb_core
   8.24%  [kernel]          [k] kmem_cache_free
   7.97%  [kernel]          [k] dev_gro_receive
   7.68%  [kernel]          [k] page_pool_put_page
   7.32%  [kernel]          [k] kmem_cache_alloc
   7.09%  [mvpp2]           [k] mvpp2_bm_pool_put
   3.36%  [kernel]          [k] eth_type_trans

Also, move the eth_type_trans() call a bit down, to give the RAM more
time to prefetch the data.

Signed-off-by: Matteo Croce <mcroce@microsoft.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 5663c1b21870..07d8f3e31b52 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -3938,7 +3938,7 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
 			goto err_drop_frame;
 
 		/* Prefetch header */
-		prefetch(data);
+		prefetch(data + MVPP2_MH_SIZE + MVPP2_SKB_HEADROOM);
 
 		if (bm_pool->frag_size > PAGE_SIZE)
 			frag_size = 0;
@@ -4008,8 +4008,8 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
 
 		skb_reserve(skb, MVPP2_MH_SIZE + MVPP2_SKB_HEADROOM);
 		skb_put(skb, rx_bytes);
-		skb->protocol = eth_type_trans(skb, dev);
 		mvpp2_rx_csum(port, rx_status, skb);
+		skb->protocol = eth_type_trans(skb, dev);
 
 		napi_gro_receive(napi, skb);
 		continue;
-- 
2.31.1

