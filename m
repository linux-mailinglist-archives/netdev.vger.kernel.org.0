Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C512C2B0856
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 16:25:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728570AbgKLPZT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 10:25:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727822AbgKLPZT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 10:25:19 -0500
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F450C0613D1;
        Thu, 12 Nov 2020 07:25:19 -0800 (PST)
Received: by mail-qk1-x744.google.com with SMTP id y197so5541790qkb.7;
        Thu, 12 Nov 2020 07:25:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=oF5Wh7P+oRrquR6KUXu2p6XiVm+Wzsg2M5qKrcerhsg=;
        b=W22ZYKa5nMtAfWIMYxtyvCPp6xl8VWzGp75P8Dql+2AEM8Pl9lKbcFCACooQNpi/rM
         IPpfSj4REpmeAN8WLpbLWKLENLnSHzmrY2NRYgtuR8aks5JxkBw/AlEbMAo8eS1TStON
         xMaqfyKWlOksNflTBADnjRxIpl8T0P+Vkbm9kIfuijmx4E35BMZZfUciIVA/VsJ3IrNN
         3sQUNtq7HkAa0m4QuxUFqc4crgGbxcQE8WpP5l7ej4C5AehnSYpLxndocZT7ZEAm9cY1
         s6MCvKlWWuZhXEsIdopjXVGDBIPouV5l6rRyAwtIs6ASRCQaEOUvB/J7pA4EnWBEw1LF
         6Nog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=oF5Wh7P+oRrquR6KUXu2p6XiVm+Wzsg2M5qKrcerhsg=;
        b=XM1XQvxyH7hezZHvEe+rorLejwTFZ5zPywdBWpuLU7vfD8dDd6RhwpCXqhaLHt43tS
         TSf4YjTIr/6Y7VVgvYrfEd63SitTtsKZqnDfzhm6+tWC+5UuaJonAiTr8KwqAAEDIXDL
         VPeFyQ5Xg1oT3hFRO1AB7SrVKsQSaUSTAL0F7d8irx2Y1yZNaeJG0ni7/zzaEa/FLucN
         nM2yedxtOAwby/McIjKpgCh2CXUglqmSknYVcck+n78m9SZJGfu/ehASvErm6wAE3c97
         5ksY//pMesM29Gi7M0kzSeWhkXhCR8hwubYS2zPT32mG4hF1YkAeAZMN9rRx6VbE0koU
         envQ==
X-Gm-Message-State: AOAM5329y3KwBgIEJj3YSVAUoCOwP6oMQKiLBfDdQwuDj32i7qOq8dpp
        gSkdlvygmlKodIoNxqq6O5Q=
X-Google-Smtp-Source: ABdhPJyr2e/npL9QyKK+HcbhXebOEHj/YQj4xW726y5VbBJp5wlj01dho4YN50jezVx1/XO6INPENA==
X-Received: by 2002:a37:6fc5:: with SMTP id k188mr223183qkc.317.1605194718178;
        Thu, 12 Nov 2020 07:25:18 -0800 (PST)
Received: from localhost.localdomain ([198.52.185.246])
        by smtp.gmail.com with ESMTPSA id h6sm4578150qtm.68.2020.11.12.07.25.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 07:25:17 -0800 (PST)
From:   Sven Van Asbroeck <thesven73@gmail.com>
X-Google-Original-From: Sven Van Asbroeck <TheSven73@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        David S Miller <davem@davemloft.net>
Cc:     Sven Van Asbroeck <thesven73@gmail.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net v1] lan743x: fix use of uninitialized variable
Date:   Thu, 12 Nov 2020 10:25:13 -0500
Message-Id: <20201112152513.1941-1-TheSven73@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Van Asbroeck <thesven73@gmail.com>

When no devicetree is present, the driver will use an
uninitialized variable.

Fix by initializing this variable.

Fixes: 902a66e08cea ("lan743x: correctly handle chips with internal PHY")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Sven Van Asbroeck <thesven73@gmail.com>
---
Tree: git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git # 52755b66ddce

To: Jakub Kicinski <kuba@kernel.org>
To: Bryan Whitehead <bryan.whitehead@microchip.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

 drivers/net/ethernet/microchip/lan743x_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index 54d721ef3084..0c9b938ee0ea 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -1014,8 +1014,8 @@ static void lan743x_phy_close(struct lan743x_adapter *adapter)
 static int lan743x_phy_open(struct lan743x_adapter *adapter)
 {
 	struct lan743x_phy *phy = &adapter->phy;
+	struct phy_device *phydev = NULL;
 	struct device_node *phynode;
-	struct phy_device *phydev;
 	struct net_device *netdev;
 	int ret = -EIO;
 
-- 
2.17.1

