Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18FBD3C2670
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 16:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232327AbhGIPBh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 11:01:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231963AbhGIPBg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Jul 2021 11:01:36 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31815C0613DD;
        Fri,  9 Jul 2021 07:58:53 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id n14so23771767lfu.8;
        Fri, 09 Jul 2021 07:58:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cJvuiT7RJb/MpwYGcTkgXJIxkkLos3Plfb9q7juAC20=;
        b=lUA8Mku+kNKCmnbGejdw4+Ja2PJ7ShzrpgXbNEacxNCbx6hJO/nCZa7OBJ8+s+ZnSC
         eKaIDRzr0Lev8RxtfxwyheaW5UhK3FnTulWdRS9wpUu6+eSiiyFAx3Z3TXOeiwSxDVf3
         E/lRCKZ4+dX6kqcQ8igHbRpJhpJNs8fjGxz9I7VZB3lgmZQ80BVnrX21UvhdpE1LlFG9
         d6kZfuRhXy8/BCSAauC3oN9ptsrMacsB06oThrHM/vqB/oG71OeIerDJHQ2Co1ylfz1U
         rMaWsywmEZqNi0bHvVLwtbZvTyohS2h96su9tXqPDrk31oZ2m+6/ZprNic1qomU6zqn1
         1Aww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cJvuiT7RJb/MpwYGcTkgXJIxkkLos3Plfb9q7juAC20=;
        b=QrnQpy163kGUMI1LYvcYVO/PJXG04MKznRWld7gtJotf9ljW3Q7fRtNSlDXPg080oC
         /mbdDnwhgQ3Xro12ifKKVp67ijFSOOFeuTA2aU3TJlIZN1WZicyzjZ62CO+lZq+XlEay
         vXfs+OAccxZuHCqnLX/LvX0odjrkTUO3nVvADZFEqmTtMifXfTsp5CD8jIo+2C3VO6PB
         61ben2ZmBFGJNDV6lfTmHO2mXk+GAXkBGAXqDd7V45bZlexLXJBsx+9qwaVz6eo0tY9G
         ra3eiddEvvmwxVWkpIAfxttm/RR0/ZXeVGFq9Hq/fCM8InnDUi4qkrbdo9a369XikHU0
         vKBA==
X-Gm-Message-State: AOAM530DoH1V1UQkoiKr1FDl6xX1BrdiEJWGzpHHka5gNJs1Tw0NiaWq
        bD8VvaQuw18NWgIBbuyG598=
X-Google-Smtp-Source: ABdhPJy4OiCVA/vWcL9s/QWVexCMlNiEiI6EICYNkCECzsSL5mzp3ZlC1k2nMYqxQhOpyI74pU0dSw==
X-Received: by 2002:a05:6512:203a:: with SMTP id s26mr3779578lfs.251.1625842731513;
        Fri, 09 Jul 2021 07:58:51 -0700 (PDT)
Received: from localhost.localdomain ([94.103.225.155])
        by smtp.gmail.com with ESMTPSA id bn30sm581320ljb.87.2021.07.09.07.58.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jul 2021 07:58:51 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     chessman@tux.org, davem@davemloft.net, kuba@kernel.org,
        devendra.aaru@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>
Subject: [PATCH] net: ti: fix UAF in tlan_remove_one
Date:   Fri,  9 Jul 2021 17:58:29 +0300
Message-Id: <20210709145829.3335-1-paskripkin@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

priv is netdev private data and it cannot be
used after free_netdev() call. Using priv after free_netdev()
can cause UAF bug. Fix it by moving free_netdev() at the end of the
function.

Fixes: 1e0a8b13d355 ("tlan: cancel work at remove path")
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---
 drivers/net/ethernet/ti/tlan.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/ti/tlan.c b/drivers/net/ethernet/ti/tlan.c
index 0b2ce4bdc2c3..e0cb713193ea 100644
--- a/drivers/net/ethernet/ti/tlan.c
+++ b/drivers/net/ethernet/ti/tlan.c
@@ -313,9 +313,8 @@ static void tlan_remove_one(struct pci_dev *pdev)
 	pci_release_regions(pdev);
 #endif
 
-	free_netdev(dev);
-
 	cancel_work_sync(&priv->tlan_tqueue);
+	free_netdev(dev);
 }
 
 static void tlan_start(struct net_device *dev)
-- 
2.32.0

