Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F22FB1B86CE
	for <lists+netdev@lfdr.de>; Sat, 25 Apr 2020 15:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726118AbgDYNkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Apr 2020 09:40:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726087AbgDYNkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Apr 2020 09:40:17 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91F9AC09B04B;
        Sat, 25 Apr 2020 06:40:17 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id 18so5013317pfv.8;
        Sat, 25 Apr 2020 06:40:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=u7erXItqduG4J9xeJjAnKDGo1ffse9a+ZFsfbSrURyE=;
        b=PsG/d2K/x/lFUqBKTSnjftACJ2hAinKNQkSC9RxL16xI0b6kseOdVUH06RLO5kyOOL
         J58FwmQjnquuhez0LaGVYin0OZRZDRL7u7Alz39WsXznmZgd0A4U+jWdsO188h5+3hAx
         zhf4TkVKw2VfKKHggc79Mlzy9QHqnLFcpLtwtJXfgH8VAvdUS0G+0Hj1TtSZT1cNnLar
         zJ11tSTwkzEiwd0MUx6OO+27Ry1TciqY6wTzGo1Qtkn95SLakvJnkROL/e0D8T7Ltsaw
         /4wyPeZ4LuRvhOV/QUEQxoTal2eoEmd2nlT78Z7rQzOBcn0nh3MieaSdrYghuz6wBGSt
         IVJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=u7erXItqduG4J9xeJjAnKDGo1ffse9a+ZFsfbSrURyE=;
        b=mYveP8kIULH08Gg00EjtLPPH4yjEjwoUbSHkARxBfeZqubdD6d+oroaAORfDYEwRSm
         egqzJI/vZucbnrmUx7aWhqL16PeXJuv5xFXWbd9bSqEuCBLfw04Ihw658b/nFXekLEFi
         4KPNuThEG4qF1zrke/GWkz9E+Rh1sviwjDfBA60EfMLp8LnskgABx9YMkKz5qy4Q3aJn
         w81yQ4joCO4jWFMu1cTsohnFrdOI5dOquiiiFprkiT1KiMI6bF+dGq8em1ZF62sTrYgg
         HuJqlhaSeAcx6vJIx4qIHDbqvf+6AswBKN82nOguuolCDhL+zgE8SVTEyXqXsOFoV/XM
         gllg==
X-Gm-Message-State: AGi0PuYI6GtDfAS/S7rYuhdPxZZkeA2jnYPdbH/a5D5GC9Pcim2XEgjm
        0mDCwbVD0p2GFqAidam1JNU=
X-Google-Smtp-Source: APiQypK0cDjCyCWFJm9l8EMQFRgOCczUZXjONvIs7N1VaO3PJzhVxE3s+JCBGUiXKg2RlH1MbkYwbQ==
X-Received: by 2002:a63:2403:: with SMTP id k3mr13907764pgk.295.1587822017072;
        Sat, 25 Apr 2020 06:40:17 -0700 (PDT)
Received: from localhost ([176.122.158.64])
        by smtp.gmail.com with ESMTPSA id l64sm7359212pjb.44.2020.04.25.06.40.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 25 Apr 2020 06:40:16 -0700 (PDT)
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     davem@davemloft.net, jes@trained-monkey.org,
        linux-acenic@sunsite.dk, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Dejin Zheng <zhengdejin5@gmail.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCH net v1] net: acenic: fix an issue about leak related system resources
Date:   Sat, 25 Apr 2020 21:40:07 +0800
Message-Id: <20200425134007.15843-1-zhengdejin5@gmail.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

the function ace_allocate_descriptors() and ace_init() can fail in
the acenic_probe_one(), The related system resources were not
released then. so change the error handling to fix it.

Fixes: 1da177e4c3f41524e8 ("Linux-2.6.12-rc2")
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
---
 drivers/net/ethernet/alteon/acenic.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/alteon/acenic.c b/drivers/net/ethernet/alteon/acenic.c
index 5d192d551623..32f9e68dd323 100644
--- a/drivers/net/ethernet/alteon/acenic.c
+++ b/drivers/net/ethernet/alteon/acenic.c
@@ -568,7 +568,7 @@ static int acenic_probe_one(struct pci_dev *pdev,
 #endif
 
 	if (ace_allocate_descriptors(dev))
-		goto fail_free_netdev;
+		goto fail_uninit;
 
 #ifdef MODULE
 	if (boards_found >= ACE_MAX_MOD_PARMS)
@@ -580,7 +580,7 @@ static int acenic_probe_one(struct pci_dev *pdev,
 #endif
 
 	if (ace_init(dev))
-		goto fail_free_netdev;
+		goto fail_uninit;
 
 	if (register_netdev(dev)) {
 		printk(KERN_ERR "acenic: device registration failed\n");
-- 
2.25.0

