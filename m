Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2398262AD1
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 10:47:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730150AbgIIIqp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 04:46:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729942AbgIIIqV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 04:46:21 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C924BC061755
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 01:46:20 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id d9so1565523pfd.3
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 01:46:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=V98z1XdNgV3xiHLIER3LFRw7DRi8WlFUlQ/WCZLIUTo=;
        b=jNS21Ndt/jcqzlodixMAEFFSK5DFDmaI7A+f0tbhlcpBV7Tz9O2RdYDDHVu0unr4J2
         nempAtvq+Z+m0grZKT2qS2yYJrvAA6B2AcBjb0kHjrt5MUMDYYSrcriN2Q1sFlOZtHZ5
         qVVQDOfsPjcGgIOBImK9cEw4kIkygaHx6Qba3QTT/IbOPEv0gRcHySuPdIcjn2c1P2fD
         I4XCE71QWW0MHzgnxom8lCJwg2QmuYHyvCt0O7PHLzOGDLW2yB9KIQYZ1EsJ2bzPort4
         vmAKh8Dlmfb0Q8BUEQbeEXFnH+Ev4l16BAa06BoPazQIowfquI9F1OLPhs9zetdKWuWo
         5w5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=V98z1XdNgV3xiHLIER3LFRw7DRi8WlFUlQ/WCZLIUTo=;
        b=tk7WkHdDEPcpA406QdxgFAt3VpqMnSgjwgsLyi1eC+MZLyd3YJPIAUIotnZEhjfm7E
         rSEyEaDuoRHkFb8LREnbW22+D1KUSjGMr7C+QeW2mpmGRC+RKlQpRoZDvHLazNOF6zBV
         wMbniAKDOF/KE6vcice9PV+M3XBvRwd7t4z3Jfm+g7+6L/9II7TaFKoZHaY6tn7XIQOK
         UUAWO7FnR3yLaqBqbU/9g/VRgXBvwUX1zGqu+KXD7zsd6KDyEqoyHOtm8/cNgUMUDi3T
         y8hHYygGRtyEkp1FzuvI6q+bppWxyqCWoIc6N94Sk9gMT6Mu6zRt1gmMn08J9wwJCA8q
         1D2A==
X-Gm-Message-State: AOAM531EcELZodROZP4UEyHeYm1DTTOHKmxNZgA0b4puas+5UXI7LDpt
        W3y2yvxBoMfHxECG0vvQbSY=
X-Google-Smtp-Source: ABdhPJy4+E2ukbzMDPQsE8rOx6oQZhS/Cy8n8p2vIVvGU5Tn22QkIobOi3SxLRdR94m8SyjMz8XAwQ==
X-Received: by 2002:a63:4902:: with SMTP id w2mr2222597pga.311.1599641180372;
        Wed, 09 Sep 2020 01:46:20 -0700 (PDT)
Received: from localhost.localdomain ([49.207.214.52])
        by smtp.gmail.com with ESMTPSA id u21sm1468355pjn.27.2020.09.09.01.46.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 01:46:19 -0700 (PDT)
From:   Allen Pais <allen.lkml@gmail.com>
To:     davem@davemloft.net
Cc:     jes@trained-monkey.org, kuba@kernel.org, dougmill@linux.ibm.com,
        cooldavid@cooldavid.org, mlindner@marvell.com,
        stephen@networkplumber.org, borisp@mellanox.com,
        netdev@vger.kernel.org, Allen Pais <allen.lkml@gmail.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [PATCH v2 16/20] ethernet: netronome: convert tasklets to use new tasklet_setup() API
Date:   Wed,  9 Sep 2020 14:15:06 +0530
Message-Id: <20200909084510.648706-17-allen.lkml@gmail.com>
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
 drivers/net/ethernet/netronome/nfp/nfp_net_common.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index 21ea22694e47..b150da43adb2 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -2287,9 +2287,9 @@ static bool nfp_ctrl_rx(struct nfp_net_r_vector *r_vec)
 	return budget;
 }
 
-static void nfp_ctrl_poll(unsigned long arg)
+static void nfp_ctrl_poll(struct tasklet_struct *t)
 {
-	struct nfp_net_r_vector *r_vec = (void *)arg;
+	struct nfp_net_r_vector *r_vec = from_tasklet(r_vec, t, tasklet);
 
 	spin_lock(&r_vec->lock);
 	nfp_net_tx_complete(r_vec->tx_ring, 0);
@@ -2337,8 +2337,7 @@ static void nfp_net_vecs_init(struct nfp_net *nn)
 
 			__skb_queue_head_init(&r_vec->queue);
 			spin_lock_init(&r_vec->lock);
-			tasklet_init(&r_vec->tasklet, nfp_ctrl_poll,
-				     (unsigned long)r_vec);
+			tasklet_setup(&r_vec->tasklet, nfp_ctrl_poll);
 			tasklet_disable(&r_vec->tasklet);
 		}
 
-- 
2.25.1

