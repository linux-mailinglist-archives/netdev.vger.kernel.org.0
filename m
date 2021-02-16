Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D459631C894
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 11:17:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbhBPKRV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 05:17:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbhBPKRU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 05:17:20 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80D6CC061756
        for <netdev@vger.kernel.org>; Tue, 16 Feb 2021 02:16:39 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id o3so9268344edv.4
        for <netdev@vger.kernel.org>; Tue, 16 Feb 2021 02:16:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VTu2kaBkhv3oWRt4z9hloY50JX1dRBf0x/4IhM6WDms=;
        b=UQOuF7X9tEUuj3PZBEEL+3oReG8KIHcaK5zCL4SNVdChM0L2KFVzSJukFSZ4SHFsfA
         2jenXFvbky1HgYVJoGQQFyAuUXe2L8Pok40c5wb2v6AsiJqNnsjIfwU1jTdIMreBgOZQ
         OETlsEMs5JE7Lgz1WQ8OKn6ZRkG52DD3omXCyVLBkbTxNETcPqJfFHscZDhpHNaG73G/
         jWIFaBsMOpXgosCw7u/7FaxU801ipqKfnZFleKeiY7NJZeyxgnybnR6hhjEQ4oC/yhVU
         JXGAHGidQDykL2eI6Iafy4MLFEmAjzATM8vzp9xoZNdwMDO2vhZJU3ijK7EEto4z694Q
         4xLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VTu2kaBkhv3oWRt4z9hloY50JX1dRBf0x/4IhM6WDms=;
        b=YmowyttEKjZF9Xvj/f9DZsSwi7cRVJsIU6Jpg/LIkVpYJS2DWZUoe5ZOFri7fZ1Or6
         Fg1zhoO6rP3skULASGCOc6296itH77IlW6ah7WZqQAxHft4tgnoqURrRr6YkGDn7h1mt
         B4wYkFPvZybDu09SjpyIiEypcLKfi+96lECJgTXM9pPC0HCW34yDiG83jnbx7/4/yAxX
         ryB4oJgZP/LX27Jg3pmSyiv/uJwJ6MSWLjSSoZKUmY92Oi9sK8CuMmsNN6IlVqbUsVCk
         mo1lJ4Wcx6Eh4hvmVEa562Ki+JVh/cW4EuE0psqjXa4byckmr9dS9OUXNJQOPQDJZ532
         Av5Q==
X-Gm-Message-State: AOAM531QlPq6x/6H5wdYlRXSDpxDbsgEjwENHKGD83AO/KTeZbcs2ouj
        w4bBVMsWIOY5qBuRlA83SMc=
X-Google-Smtp-Source: ABdhPJx/DX7By43hzXntDfM4p8T9VQjOQQPdPv2g7IzebpBQ9ethUxEDCrO+DZKJ/X6pS/klgtGJKA==
X-Received: by 2002:aa7:db0c:: with SMTP id t12mr9489396eds.33.1613470598259;
        Tue, 16 Feb 2021 02:16:38 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id b17sm12773147edv.56.2021.02.16.02.16.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Feb 2021 02:16:37 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Michael Walle <michael@walle.cc>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>
Subject: [PATCH net] net: enetc: fix destroyed phylink dereference during unbind
Date:   Tue, 16 Feb 2021 12:16:28 +0200
Message-Id: <20210216101628.2818524-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The following call path suggests that calling unregister_netdev on an
interface that is up will first bring it down.

enetc_pf_remove
-> unregister_netdev
   -> unregister_netdevice_queue
      -> unregister_netdevice_many
         -> dev_close_many
            -> __dev_close_many
               -> enetc_close
                  -> enetc_stop
                     -> phylink_stop

However, enetc first destroys the phylink instance, then calls
unregister_netdev. This is already dissimilar to the setup (and error
path teardown path) from enetc_pf_probe, but more than that, it is buggy
because it is invalid to call phylink_stop after phylink_destroy.

So let's first unregister the netdev (and let the .ndo_stop events
consume themselves), then destroy the phylink instance, then free the
netdev.

Fixes: 71b77a7a27a3 ("enetc: Migrate to PHYLINK and PCS_LYNX")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc_pf.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index 3eb5f1375bd4..515c5b29d7aa 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -1157,14 +1157,15 @@ static void enetc_pf_remove(struct pci_dev *pdev)
 	struct enetc_ndev_priv *priv;
 
 	priv = netdev_priv(si->ndev);
-	enetc_phylink_destroy(priv);
-	enetc_mdiobus_destroy(pf);
 
 	if (pf->num_vfs)
 		enetc_sriov_configure(pdev, 0);
 
 	unregister_netdev(si->ndev);
 
+	enetc_phylink_destroy(priv);
+	enetc_mdiobus_destroy(pf);
+
 	enetc_free_msix(priv);
 
 	enetc_free_si_resources(priv);
-- 
2.25.1

