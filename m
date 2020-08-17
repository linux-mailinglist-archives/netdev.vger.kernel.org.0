Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDB79245FEE
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 10:27:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728140AbgHQI0X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 04:26:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726777AbgHQI0G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 04:26:06 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22EF5C061388;
        Mon, 17 Aug 2020 01:26:05 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id d4so7338233pjx.5;
        Mon, 17 Aug 2020 01:26:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=cL9JEmBEHVr7j+h/t21HJyCd1D6huw3HDaRf1+0pC7c=;
        b=FPU+w3NDPol567vC+h/ZbTlRf2kz8vO1fFt9hvJys9Ppxj1YeH8QP1vbGeucslM6P0
         Im1necIo+mxJGaKwhjo+ScTY3KUflAYspI4/wzqj1sWuvWLhM6e9CoyKQjR3vWs1ikX2
         PJ3SFrUqKBN7RrjeFJC5ScMlVN4+/BGn0dqN80T1Cm4XmoQT/wlra+F7rGPNWJAiesRI
         ArrrkVKF8Uu38hcYnKkiFG0HM1hqETjnLfmDrVnENXPGFquqETDot1namxUVLPK7p2Dj
         0l319BCnw7iS/FBOzZeUsQrgv1jRKBX8OLhkOu5HWCW7yfhayCha6zoXqXzv0eMxW7Fo
         m8EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=cL9JEmBEHVr7j+h/t21HJyCd1D6huw3HDaRf1+0pC7c=;
        b=iwmD+PIuEo1aQITUyQ5odq+UtZby8yrZLOqvOwp9lpldt7MMLy4ArgxW2S6eMuGj0u
         uHfgpf9//zX2yNcV647ZB33PJBBMDSem4/etxegLjD5CRJcVXwQKGL/GNuLGYZFymYXT
         HO8Mlztm2LXVs7Amz0bXwbkm2A9tSgwuswoi2PmtEhN6bEH4HKybLMqzTERb8V51gS6M
         yUCicmnUDkCK/CoWvHzznXgA+uAHor9eIgpgKAHIQ6ksVWLP7F3xtkApoN71u/PWs2x6
         2i3HWfXlSv0818kjrhYAy9juhjvBGDQ3zt6Y2iNomabGjBZDE6iWw4aTyys5LgKDO49k
         4g6Q==
X-Gm-Message-State: AOAM530qLkXtLAlheIv+33TJoHVVu3mH07B/kEAsPt3q6iZoKJrTT4LQ
        2jCgUZ4fWnpn/5pWvJOxebA=
X-Google-Smtp-Source: ABdhPJwIeOMMqSxIZ7onJbrSMiRju8pATc7y+zI7a+Unpdh2nCA4eorIzXR73r8269HMrnvzGnz7Cg==
X-Received: by 2002:a17:90a:8589:: with SMTP id m9mr11878650pjn.109.1597652764728;
        Mon, 17 Aug 2020 01:26:04 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id r186sm19928482pfr.162.2020.08.17.01.25.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 01:26:04 -0700 (PDT)
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
Subject: [PATCH 12/20] ethernet: marvell: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 13:54:26 +0530
Message-Id: <20200817082434.21176-14-allen.lkml@gmail.com>
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
 drivers/net/ethernet/marvell/skge.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/skge.c b/drivers/net/ethernet/marvell/skge.c
index b792f6306a64..55fe901d3562 100644
--- a/drivers/net/ethernet/marvell/skge.c
+++ b/drivers/net/ethernet/marvell/skge.c
@@ -3338,9 +3338,9 @@ static void skge_error_irq(struct skge_hw *hw)
  * because accessing phy registers requires spin wait which might
  * cause excess interrupt latency.
  */
-static void skge_extirq(unsigned long arg)
+static void skge_extirq(struct tasklet_struct *t)
 {
-	struct skge_hw *hw = (struct skge_hw *) arg;
+	struct skge_hw *hw = from_tasklet(hw, t, phy_task);
 	int port;
 
 	for (port = 0; port < hw->ports; port++) {
@@ -3927,7 +3927,7 @@ static int skge_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	hw->pdev = pdev;
 	spin_lock_init(&hw->hw_lock);
 	spin_lock_init(&hw->phy_lock);
-	tasklet_init(&hw->phy_task, skge_extirq, (unsigned long) hw);
+	tasklet_setup(&hw->phy_task, skge_extirq);
 
 	hw->regs = ioremap(pci_resource_start(pdev, 0), 0x4000);
 	if (!hw->regs) {
-- 
2.17.1

