Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E7B44636DA
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 15:36:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236345AbhK3Oji (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 09:39:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231570AbhK3Ojh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 09:39:37 -0500
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 328F0C061574;
        Tue, 30 Nov 2021 06:36:18 -0800 (PST)
Received: by mail-lj1-x229.google.com with SMTP id 207so41446812ljf.10;
        Tue, 30 Nov 2021 06:36:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EEa2SWS6B6mcdcA3Bj4MK8Wfpmi4Iz2Z4/pNdQbGwyA=;
        b=GBQPnMu3ywYgUV8Xb39wJ/ihX/tOOZmrT86JeUnf5u5Dm3MwMA+eZaKlKgVNcxhVPB
         QYsMpYvFLYq0wjcxDBg5y8N9AfUk1vuisl2V/jPVX5SogCy3NqIzE10nGC/+9gYAq8FO
         gIGv8HVimWJxJw7ZnIsRFjwScccyqazCumkfIMgLE8AqV3dF/TYZJVCfn09YwZ/lPpKg
         pD6x8SN3duq5zgoGJUo056TKdWU5DwCS/QNQE8sJhIC7yafIopFfoJ86jBFkm7b7FFnA
         khmB0mM1oa5LGr1ukZy6F7BvljXJtBQi2MUs5YfmksJfgxc7fhYC9cPQeXAH6k6Gm2/W
         8x0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EEa2SWS6B6mcdcA3Bj4MK8Wfpmi4Iz2Z4/pNdQbGwyA=;
        b=1EhfWXaLtCq3fAKea78jt/POVZ5r/Xkk6eOOK7VVgs2t3sgrXSAuhOzysHJNaTYeYq
         kDiQQ+nHeAyt+vekg82S/Wp1HzxvJtwg3JrV6FZ4tvTV/itUYPzA928w5HT7LUIs3o9x
         49Nc8rTVHTGnws9AodbLGXcGSWQzj8uKvvrmKny5aIOC0pxsgZA+pU5c3XqWrFFPWH1f
         Br6ncoRGxKoPPprHQpeyyTqPFmWHSDOBtWg28+1Ankr7JWoQtyrpa3Pm3YEK1PTbXCil
         77SOwrWX0eVyjY5/fzUYGbaLgOuprWHBuKzzIuHnrTMJeRl/U0V/dqkEVN/DFt/8VZl9
         zyKQ==
X-Gm-Message-State: AOAM530+1yKis1qpr3kyFfE7HYZglPU0N8qvR/D9IoDBOtYMPTDOUqrq
        orG6Cg5PLGv0rSR+ti6UsfwPDK/lTDj4lQ==
X-Google-Smtp-Source: ABdhPJwtuzvyNmm+a0X743uFT38Lfbj0hu8MT8lCzgZjKjSDM2vP6Lo5PY6HUifiZfrm8du4QNlmdg==
X-Received: by 2002:a2e:5c46:: with SMTP id q67mr31136329ljb.271.1638282976166;
        Tue, 30 Nov 2021 06:36:16 -0800 (PST)
Received: from octofox.metropolis ([5.18.187.11])
        by smtp.gmail.com with ESMTPSA id q4sm831045lfh.277.2021.11.30.06.36.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 06:36:15 -0800 (PST)
From:   Max Filippov <jcmvbkbc@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Max Filippov <jcmvbkbc@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH] net: natsemi: fix hw address initialization for jazz and xtensa
Date:   Tue, 30 Nov 2021 06:36:00 -0800
Message-Id: <20211130143600.31970-1-jcmvbkbc@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use eth_hw_addr_set function instead of writing the address directly to
net_device::dev_addr.

Fixes: adeef3e32146 ("net: constify netdev->dev_addr")
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/natsemi/jazzsonic.c | 6 ++++--
 drivers/net/ethernet/natsemi/xtsonic.c   | 6 ++++--
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/natsemi/jazzsonic.c b/drivers/net/ethernet/natsemi/jazzsonic.c
index d74a80f010c5..3f371faeb6d0 100644
--- a/drivers/net/ethernet/natsemi/jazzsonic.c
+++ b/drivers/net/ethernet/natsemi/jazzsonic.c
@@ -114,6 +114,7 @@ static int sonic_probe1(struct net_device *dev)
 	struct sonic_local *lp = netdev_priv(dev);
 	int err = -ENODEV;
 	int i;
+	unsigned char addr[ETH_ALEN];
 
 	if (!request_mem_region(dev->base_addr, SONIC_MEM_SIZE, jazz_sonic_string))
 		return -EBUSY;
@@ -143,9 +144,10 @@ static int sonic_probe1(struct net_device *dev)
 	SONIC_WRITE(SONIC_CEP,0);
 	for (i=0; i<3; i++) {
 		val = SONIC_READ(SONIC_CAP0-i);
-		dev->dev_addr[i*2] = val;
-		dev->dev_addr[i*2+1] = val >> 8;
+		addr[i*2] = val;
+		addr[i*2+1] = val >> 8;
 	}
+	eth_hw_addr_set(dev, addr);
 
 	lp->dma_bitmode = SONIC_BITMODE32;
 
diff --git a/drivers/net/ethernet/natsemi/xtsonic.c b/drivers/net/ethernet/natsemi/xtsonic.c
index ca4686094701..7d51bcb1b918 100644
--- a/drivers/net/ethernet/natsemi/xtsonic.c
+++ b/drivers/net/ethernet/natsemi/xtsonic.c
@@ -127,6 +127,7 @@ static int __init sonic_probe1(struct net_device *dev)
 	unsigned int base_addr = dev->base_addr;
 	int i;
 	int err = 0;
+	unsigned char addr[ETH_ALEN];
 
 	if (!request_mem_region(base_addr, 0x100, xtsonic_string))
 		return -EBUSY;
@@ -163,9 +164,10 @@ static int __init sonic_probe1(struct net_device *dev)
 
 	for (i=0; i<3; i++) {
 		unsigned int val = SONIC_READ(SONIC_CAP0-i);
-		dev->dev_addr[i*2] = val;
-		dev->dev_addr[i*2+1] = val >> 8;
+		addr[i*2] = val;
+		addr[i*2+1] = val >> 8;
 	}
+	eth_hw_addr_set(dev, addr);
 
 	lp->dma_bitmode = SONIC_BITMODE32;
 
-- 
2.20.1

