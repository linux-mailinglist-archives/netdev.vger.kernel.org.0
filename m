Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0371A1CE6F1
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 23:06:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732551AbgEKVFA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 17:05:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731855AbgEKVE6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 17:04:58 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6059C061A0E
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 14:04:57 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id k19so4434176pll.9
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 14:04:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=2rj7fFH6ZI7q1RrlMYmdHqpqWBjXcLGhutBTftaqZG4=;
        b=qtMS0IAswtcXmbvi/v4F5y17nSEkAbzSSdA2bFIsLebBA33zG1X63k18I80XKi9Vsc
         Z8KpKnvO95hBd9Np0n9Muaf0f6z8pD2red4l8md5rgncHGxEuw8D1spMC3HhST4W23CQ
         GOoUjtPezc7v/OgL35Faqo46FbR41b7Gj6G3QDaUmakV7jIOWAe3vuVDVbW1/xsjg6y2
         gIBsYIjgS3mPbeIFbjQr0lP+3TqDA4oNu0V2J/oMPelBDrP1iuL8Kv4KAXbJ77HzDqLW
         JwgE0AIUTdqu6ftaLxDehm8XIuI7s0uxYS2Nirev/yNK+V1nY2ToZZzxD+A2xQ9msYuE
         /z1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=2rj7fFH6ZI7q1RrlMYmdHqpqWBjXcLGhutBTftaqZG4=;
        b=aD3TjwgZJjMjUVOVYSAdSXzx6QNBY9LrOb8p6jbBNbnXtPBc215WNjr+CwWsSeY0CG
         ZV/E/Y3aaX56rasxruuAVk5P2iSOzjs1bSaaKRuNVvOLAH40VZtF9+C6XM2mm+MooY+R
         YpwnMWHATbw800OKufU3gZT6/7ITIf7vqtU4afRx4x5GkD7di5JcoL1wm87PUOyzoSjc
         HSmClfm/5/q9VjIYMIAWWJCIyOx/MvKg4np5zfGiiWUzWlt8lYZjbbisxvYzYl/yCEuB
         5NwaxvgsuFjuSfu/X1FizgSpQdZqFFIKtOULbuNvpRZp5IiBk3clJX2ZZpIfHg0NZf17
         3pLg==
X-Gm-Message-State: AGi0Pubq4D9NzV+NX/xXmnZs2GJ24Zx3bz3qvkeDTgd51uJUHdl3CELD
        vscD+gQxteNsqTm4ziLW9IB1n6cbv/w=
X-Google-Smtp-Source: APiQypL94I/ZwOepsRwhdzLXWBaavVdMSdwsRvAj9cfFi+S5U9onqv/w/vzDc6v++y5REoswH5xo2Q==
X-Received: by 2002:a17:902:b685:: with SMTP id c5mr17810431pls.154.1589231097101;
        Mon, 11 May 2020 14:04:57 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id c2sm6325048pgj.93.2020.05.11.14.04.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 May 2020 14:04:56 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net 2/2] ionic: call ionic_port_init after fw-upgrade
Date:   Mon, 11 May 2020 14:04:45 -0700
Message-Id: <20200511210445.2144-3-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200511210445.2144-1-snelson@pensando.io>
References: <20200511210445.2144-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the fw has been re-inited, we need to refresh the port
information dma address so we can see fresh port information.
Let's call ionic_port_init again, and tweak it to allow for
a call to simply refresh the existing dma address.

Fixes: c672412f6172 ("ionic: remove lifs on fw reset")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_lif.c    |  1 +
 .../net/ethernet/pensando/ionic/ionic_main.c   | 18 +++++++++---------
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index f8c626444da0..f8a9c1bcffc9 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -2118,6 +2118,7 @@ static void ionic_lif_handle_fw_up(struct ionic_lif *lif)
 	dev_info(ionic->dev, "FW Up: restarting LIFs\n");
 
 	ionic_init_devinfo(ionic);
+	ionic_port_init(ionic);
 	err = ionic_qcqs_alloc(lif);
 	if (err)
 		goto err_out;
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
index 588c62e9add7..3344bc1f7671 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -509,16 +509,16 @@ int ionic_port_init(struct ionic *ionic)
 	size_t sz;
 	int err;
 
-	if (idev->port_info)
-		return 0;
-
-	idev->port_info_sz = ALIGN(sizeof(*idev->port_info), PAGE_SIZE);
-	idev->port_info = dma_alloc_coherent(ionic->dev, idev->port_info_sz,
-					     &idev->port_info_pa,
-					     GFP_KERNEL);
 	if (!idev->port_info) {
-		dev_err(ionic->dev, "Failed to allocate port info, aborting\n");
-		return -ENOMEM;
+		idev->port_info_sz = ALIGN(sizeof(*idev->port_info), PAGE_SIZE);
+		idev->port_info = dma_alloc_coherent(ionic->dev,
+						     idev->port_info_sz,
+						     &idev->port_info_pa,
+						     GFP_KERNEL);
+		if (!idev->port_info) {
+			dev_err(ionic->dev, "Failed to allocate port info\n");
+			return -ENOMEM;
+		}
 	}
 
 	sz = min(sizeof(ident->port.config), sizeof(idev->dev_cmd_regs->data));
-- 
2.17.1

