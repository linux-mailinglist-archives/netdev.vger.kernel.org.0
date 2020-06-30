Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FDB920FB70
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 20:12:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390635AbgF3SMV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 14:12:21 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:41985 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726831AbgF3SMV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 14:12:21 -0400
Received: by mail-ed1-f67.google.com with SMTP id z17so17098087edr.9;
        Tue, 30 Jun 2020 11:12:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zsPbjoVXLMKo7otPkywLiwQyR35vOhEsRAVtfPQ7uPY=;
        b=DbCLAfANaokVMLcXSIPHJdPkx3sXggTDQ2+SVpmTC+ZW2DLgBY8Tlw6SXFWb0VePv5
         ZJF12n3Tw4MtKJ+2Llj8fmqABqTZ4yZVksDYI13vlrMVrg2nLXddo03NLJieCilVx8+q
         6tlW2px88usxYPrrdbrSFKA75DWYS+HBjbvrp0KDEwQCk2UZVU9WIdYYu1HcyVtuBc1k
         mFFi26mXEK7tQWMADs00B6cySZRvl1iaX5JCvM3q1HuX7JpUkewBGDA0t5Ef4wWGhTxu
         fBcVixZ3NnIPF8w0QxzxaZTluNifTQBNCZCSlKH4OQH87yn6sEavt1s9Bo1vwMWCxrn9
         dltg==
X-Gm-Message-State: AOAM532+9iR+r8NMtR3eCcmI3nz1oJfGb8qGT6/hHd2w4T/eNO8M7xqh
        bRbd5wtpFXNUmGIpnnkeDS25QEgX/POqKw==
X-Google-Smtp-Source: ABdhPJxrAiH+SpkpE10q05cEUE9UfKQlAad8K9TRGDbh31tMzmP3hTDAjpmReDtpFz6tUnrpj3Xq+g==
X-Received: by 2002:aa7:c590:: with SMTP id g16mr25037526edq.5.1593540736863;
        Tue, 30 Jun 2020 11:12:16 -0700 (PDT)
Received: from msft-t490s.lan ([2001:b07:5d26:7f46:d7c1:f090:1563:f81f])
        by smtp.gmail.com with ESMTPSA id d13sm2492313ejj.95.2020.06.30.11.12.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2020 11:12:16 -0700 (PDT)
From:   Matteo Croce <mcroce@linux.microsoft.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        Sven Auhagen <sven.auhagen@voleatech.de>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Stefan Chulski <stefanc@marvell.com>,
        Marcin Wojtas <mw@semihalf.com>, maxime.chevallier@bootlin.com,
        antoine.tenart@bootlin.com, thomas.petazzoni@bootlin.com
Subject: [PATCH net-next 1/4] mvpp2: refactor BM pool init percpu code
Date:   Tue, 30 Jun 2020 20:09:27 +0200
Message-Id: <20200630180930.87506-2-mcroce@linux.microsoft.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200630180930.87506-1-mcroce@linux.microsoft.com>
References: <20200630180930.87506-1-mcroce@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matteo Croce <mcroce@microsoft.com>

In mvpp2_swf_bm_pool_init_percpu(), a reference to a struct
mvpp2_bm_pool is obtained traversing multiple structs, when a
local variable already points to the same object.

Fix it and, while at it, give the variable a meaningful name.

Signed-off-by: Matteo Croce <mcroce@microsoft.com>
---
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 23 +++++++++----------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 212fc3b54310..027de7291f92 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -907,28 +907,27 @@ static int mvpp2_swf_bm_pool_init_shared(struct mvpp2_port *port)
 /* Initialize pools for swf, percpu buffers variant */
 static int mvpp2_swf_bm_pool_init_percpu(struct mvpp2_port *port)
 {
-	struct mvpp2_bm_pool *p;
+	struct mvpp2_bm_pool *bm_pool;
 	int i;
 
 	for (i = 0; i < port->nrxqs; i++) {
-		p = mvpp2_bm_pool_use_percpu(port, MVPP2_BM_SHORT, i,
-					     mvpp2_pools[MVPP2_BM_SHORT].pkt_size);
-		if (!p)
+		bm_pool = mvpp2_bm_pool_use_percpu(port, MVPP2_BM_SHORT, i,
+						   mvpp2_pools[MVPP2_BM_SHORT].pkt_size);
+		if (!bm_pool)
 			return -ENOMEM;
 
-		port->priv->bm_pools[i].port_map |= BIT(port->id);
-		mvpp2_rxq_short_pool_set(port, i, port->priv->bm_pools[i].id);
+		bm_pool->port_map |= BIT(port->id);
+		mvpp2_rxq_short_pool_set(port, i, bm_pool->id);
 	}
 
 	for (i = 0; i < port->nrxqs; i++) {
-		p = mvpp2_bm_pool_use_percpu(port, MVPP2_BM_LONG, i + port->nrxqs,
-					     mvpp2_pools[MVPP2_BM_LONG].pkt_size);
-		if (!p)
+		bm_pool = mvpp2_bm_pool_use_percpu(port, MVPP2_BM_LONG, i + port->nrxqs,
+						   mvpp2_pools[MVPP2_BM_LONG].pkt_size);
+		if (!bm_pool)
 			return -ENOMEM;
 
-		port->priv->bm_pools[i + port->nrxqs].port_map |= BIT(port->id);
-		mvpp2_rxq_long_pool_set(port, i,
-					port->priv->bm_pools[i + port->nrxqs].id);
+		bm_pool->port_map |= BIT(port->id);
+		mvpp2_rxq_long_pool_set(port, i, bm_pool->id);
 	}
 
 	port->pool_long = NULL;
-- 
2.26.2

