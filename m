Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B837F24600E
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 10:28:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728050AbgHQI2r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 04:28:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728104AbgHQIZs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 04:25:48 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC144C061388;
        Mon, 17 Aug 2020 01:25:47 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id y10so5574649plr.11;
        Mon, 17 Aug 2020 01:25:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=D/Mkx0k3buW6nMMz3cj3YWbXhyfw6abwbH3pFqES0j8=;
        b=tSp/51VbeSEu3dHGWXjYT/NQzG6Ptsjimy1nJUoATyHiHCcmg9eo9jc9IaiQERQ5Nb
         iJAIIF6kNiA5Kd5aBC89NdU0cLtr7LWwAU+vRwMSSvoATCgF7tWwsvtG0wOy0xB8tR9/
         uOAPcGvqdMIfqbFOiERkTgq5S7X+z4sS3ug7MnwdPATua5rWEURHlk4bziUaJs2Yjlsb
         vWNz9vVRd5LVHKlFP5bfXX+bJKOEIpgIa0s/1Mg//6L3c221wwHGJElufgvzxMAdDM+e
         EvVviBBP45IMyXnW+2hgOqqTLP6sEvrQhnYgq1S+mB1staPKH7MXoRECZYP4+f3temKw
         OJDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=D/Mkx0k3buW6nMMz3cj3YWbXhyfw6abwbH3pFqES0j8=;
        b=IHwXcZEKTJ8xD21/nljgfBwe/ZWO3WKfVx2p0GU5fe4afsoOm2xlfLfOHBzVIMBlpK
         wBbTHrfGfFrpiXR4gBQ6+5+H6W6MDMI4FHvhvJtU06gi7uAY1iOchyLBhumtyjwkp/6W
         k94q0EjfyB58WAMvl5vSxNFG2xCdIGS7DydY/ry5ZN68VKAZKwwbi8DLo+lJvoNlfUCB
         vVlcCxfJ8p/dmsVRuyPmmXSqPIJYY53GwQCr7pAgILEIA+JzDLUtyB+mFpv/PY803nSY
         BETUol654Qi2v6yJUkZL/WE3/04hO20w09YI9WzALGcqBsAOY2dHrVPe2LXgB4Yk7XN5
         6c7w==
X-Gm-Message-State: AOAM5337sh8b2Kv94GLH+gDPp6K9XeEkust3/EsQ3Q/GIZzzo9tI4bng
        IIZcoGJsTPJ0HSSHezHjQEE=
X-Google-Smtp-Source: ABdhPJzYryo5CXUtCOTUoLLG1O0Nlya6EIJjoKSX670WNzdCiD+322/w/djTW43/04u8aHuCOv3Ndg==
X-Received: by 2002:a17:90b:3197:: with SMTP id hc23mr11406806pjb.110.1597652747547;
        Mon, 17 Aug 2020 01:25:47 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id r186sm19928482pfr.162.2020.08.17.01.25.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 01:25:47 -0700 (PDT)
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
Subject: [PATCH 09/20] ethernet: ehea: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 13:54:23 +0530
Message-Id: <20200817082434.21176-11-allen.lkml@gmail.com>
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
 drivers/net/ethernet/ibm/ehea/ehea_main.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ehea/ehea_main.c b/drivers/net/ethernet/ibm/ehea/ehea_main.c
index 0273fb7a9d01..f3d104fec7e9 100644
--- a/drivers/net/ethernet/ibm/ehea/ehea_main.c
+++ b/drivers/net/ethernet/ibm/ehea/ehea_main.c
@@ -1212,9 +1212,9 @@ static void ehea_parse_eqe(struct ehea_adapter *adapter, u64 eqe)
 	}
 }
 
-static void ehea_neq_tasklet(unsigned long data)
+static void ehea_neq_tasklet(struct tasklet_struct *t)
 {
-	struct ehea_adapter *adapter = (struct ehea_adapter *)data;
+	struct ehea_adapter *adapter = from_tasklet(adapter, t, neq_tasklet);
 	struct ehea_eqe *eqe;
 	u64 event_mask;
 
@@ -3417,8 +3417,7 @@ static int ehea_probe_adapter(struct platform_device *dev)
 		goto out_free_ad;
 	}
 
-	tasklet_init(&adapter->neq_tasklet, ehea_neq_tasklet,
-		     (unsigned long)adapter);
+	tasklet_setup(&adapter->neq_tasklet, ehea_neq_tasklet);
 
 	ret = ehea_create_device_sysfs(dev);
 	if (ret)
-- 
2.17.1

