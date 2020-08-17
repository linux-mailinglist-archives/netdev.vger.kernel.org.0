Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BC98245FDF
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 10:27:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728444AbgHQI0f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 04:26:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728036AbgHQI0b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 04:26:31 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C187C061389;
        Mon, 17 Aug 2020 01:26:31 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id k13so7122010plk.13;
        Mon, 17 Aug 2020 01:26:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=sk5rpeS55SBVIoCz+MRV7vl3Lfu/wV4G0MR5a0P4VHA=;
        b=R1csLVhAJxc3yHfRuiOVfIM1K1da22Ewqk4d+S/8PeGJ+32fz7zhRbnJDPHJJDKTdz
         0HXIvVZM3am+i1sKz3hJwGy+Hli5AXl4Fb58zCp5uP0o3pJy80XMhYkUYI8bKRzc0a0o
         x2TKcQ+dmZMMxwrb2J5ATfaA13xUGsPJruvFtyp4VyUwo47tTFqIxVatUxhNaH4YQfv/
         mLR9OJhnOIPZ1lAuRwbu8D8nldBsUf/goYQQw3AvOSROT7WNe/UrLkPwTGNuZWTZULaS
         LEE21diiOErwWO2gIY0BjuOb8+ndEMhUNA/J5gB5GjdJoiJkQeHR/akuo2r5p+ATFRRP
         5D4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=sk5rpeS55SBVIoCz+MRV7vl3Lfu/wV4G0MR5a0P4VHA=;
        b=XaJrdYSQwl96jOBU6ce+kj6GENjm3nEv8l8xZnkL6Yg/4nhxsW2OJeEGnbxNXw8yiA
         4u178yeR4k9urCe3DVw19yhlfD6QphQRsa2UP+qKaS40pwjIiNGl7HNHq0dCfOAZEtrQ
         Di1vBKVYz8llo19/PZW7G8wRJXTqyTXLW8FxOM2RWNlAYmi5szGeP2pOQ3RNMl/DUES5
         n4wAqDbv1Ndg9/cJ0+h6veMBokBAPiofZNWUOn5NJQKyNJAlUYNi3/jXL0JIKa8bTCfF
         PxUig3j4y53A1YXlQ7jeBEp5C0he0OwTT2LFoy4sCPkpk0DmKILBZpnVOu0m+/q9fvxK
         oRsw==
X-Gm-Message-State: AOAM531IiBJx28HeZi5hes0JRao5JCj1TRqvFj0vxVMbRiWmijIIbhb8
        1cX2YLkZgnO5Tu5IuiWK7n0=
X-Google-Smtp-Source: ABdhPJxel0tdqet5sG9IVVMDhmbxE47JSymBZcwF/5VCrNzd2cjfx/50fzzPWqn2s+vAy5zva75SdQ==
X-Received: by 2002:a17:90b:3197:: with SMTP id hc23mr11408391pjb.110.1597652790990;
        Mon, 17 Aug 2020 01:26:30 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id r186sm19928482pfr.162.2020.08.17.01.26.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 01:26:30 -0700 (PDT)
From:   Allen Pais <allen.lkml@gmail.com>
To:     jes@trained-monkey.org, davem@davemloft.net, kuba@kernel.org,
        kda@linux-powerpc.org, dougmill@linux.ibm.com,
        cooldavid@cooldavid.org, mlindner@marvell.com, borisp@mellanox.com
Cc:     keescook@chromium.org, linux-acenic@sunsite.dk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, linux-rdma@vger.kernel.org,
        oss-drivers@netronome.com, Allen Pais <allen.lkml@gmail.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [PATCH 16/20] ethernet: netronome: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 13:54:30 +0530
Message-Id: <20200817082434.21176-18-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200817082434.21176-1-allen.lkml@gmail.com>
References: <20200817082434.21176-1-allen.lkml@gmail.com>
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
index 39ee23e8c0bf..1dcd24d899f5 100644
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
2.17.1

