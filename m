Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A413262ABF
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 10:45:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729161AbgIIIpi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 04:45:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726688AbgIIIph (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 04:45:37 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4493DC061755
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 01:45:37 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id mm21so989788pjb.4
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 01:45:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wkFNCHkXFbUQFDKpuxUzXcFQM0Sq+fAy0e/aPm972Q8=;
        b=bSyd86ko5ILgmYCJ3txrZiuRzbcGJDxFZdKl1JSOBM2f9nmMGIiwxaD6Sn7jw6rwVy
         uCQLIhu4HfYqky3oHZ36c1FRSKE0EmKSTF3LSlOil79SP5KZpxXCEzb/hJboZMVIl9vF
         3Zk4Pe1SjW8PAft5ZwTC00Xp6qa/BkHwwgL2vEadJ6/nEulEaWZ4YjUUX3TDGi2MJ+6g
         7uGk2TBwFPjwfH4IKZQNNIb4rSoRwjcCQcz6nFxMHmsZEytZv39WcFKg9nruMgfOi6Z7
         IhkRFH1Lk9b9fXEPEdLCwJx2YyUGiEWVa2d1zG0sz5wa8hliP6cRVHdHBlLOHUN+bvVa
         ET4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wkFNCHkXFbUQFDKpuxUzXcFQM0Sq+fAy0e/aPm972Q8=;
        b=mpMhEH/d+Pa9NbcCTmc4KH4m0amxrAtrzcSAdKycKVlgDOYR+oCF5dAoB1TTkpcl+O
         /e7WlHiWdFaI0pIqV87UAEwTeNnSduKvZXUyzN8AdEXVWNLdXrf+LeLuVJ2uU5FWRRAG
         bE3BR2fRsNfK0tMW1TT8YZDm1xmup6HhJbHktX4DjmmSnyB5LeOi1oC9HqquBkuaF3Iq
         Opsk1AEPquxMHCCDGIjrgBojQ15nayONCINyRbIHjxfqkiAtQ3Eu10WB7oXKFopqi0rs
         5vP3oaLCsaiSTHXqDHZCO/wzd4HvvosvinNzEa3Ut6wtly3QsFOcU3kBK+yqm65ffFUZ
         h9fQ==
X-Gm-Message-State: AOAM5332acOPXxc9de/RWSDQt/plW+n54vtlqXg6OYbMj/DM7in/jDpf
        rpQDSuvILHbYKWDHOjC4OLQ=
X-Google-Smtp-Source: ABdhPJznv55N5zzj8JrYJv2MxQB6bfCAbLPfy3ob+/YA0yFI8qdWdKqRWIMNeyo5QIYOHv8y9LkuAw==
X-Received: by 2002:a17:90a:e64e:: with SMTP id ep14mr2780890pjb.173.1599641136796;
        Wed, 09 Sep 2020 01:45:36 -0700 (PDT)
Received: from localhost.localdomain ([49.207.214.52])
        by smtp.gmail.com with ESMTPSA id u21sm1468355pjn.27.2020.09.09.01.45.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 01:45:36 -0700 (PDT)
From:   Allen Pais <allen.lkml@gmail.com>
To:     davem@davemloft.net
Cc:     jes@trained-monkey.org, kuba@kernel.org, dougmill@linux.ibm.com,
        cooldavid@cooldavid.org, mlindner@marvell.com,
        stephen@networkplumber.org, borisp@mellanox.com,
        netdev@vger.kernel.org, Allen Pais <allen.lkml@gmail.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [PATCH v2 04/20] ethernet: cadence: convert tasklets to use new tasklet_setup() API
Date:   Wed,  9 Sep 2020 14:14:54 +0530
Message-Id: <20200909084510.648706-5-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200909084510.648706-1-allen.lkml@gmail.com>
References: <20200909084510.648706-1-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for unconditionally passing the
struct tasklet_struct pointer to all tasklet
callbacks, switch to using the new tasklet_setup()
and from_tasklet() to pass the tasklet pointer explicitly.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <allen.lkml@gmail.com>
---
 drivers/net/ethernet/cadence/macb_main.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 6761f404b8aa..830c537bc08c 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -1466,9 +1466,9 @@ static int macb_poll(struct napi_struct *napi, int budget)
 	return work_done;
 }
 
-static void macb_hresp_error_task(unsigned long data)
+static void macb_hresp_error_task(struct tasklet_struct *t)
 {
-	struct macb *bp = (struct macb *)data;
+	struct macb *bp = from_tasklet(bp, t, hresp_err_tasklet);
 	struct net_device *dev = bp->dev;
 	struct macb_queue *queue;
 	unsigned int q;
@@ -4560,8 +4560,7 @@ static int macb_probe(struct platform_device *pdev)
 		goto err_out_unregister_mdio;
 	}
 
-	tasklet_init(&bp->hresp_err_tasklet, macb_hresp_error_task,
-		     (unsigned long)bp);
+	tasklet_setup(&bp->hresp_err_tasklet, macb_hresp_error_task);
 
 	netdev_info(dev, "Cadence %s rev 0x%08x at 0x%08lx irq %d (%pM)\n",
 		    macb_is_gem(bp) ? "GEM" : "MACB", macb_readl(bp, MID),
-- 
2.25.1

