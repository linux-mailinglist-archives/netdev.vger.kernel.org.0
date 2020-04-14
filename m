Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 640081A82B0
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 17:28:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439730AbgDNP1c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 11:27:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728767AbgDNP1M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 11:27:12 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0EC7C061A0C
        for <netdev@vger.kernel.org>; Tue, 14 Apr 2020 08:27:11 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id x66so13600917qkd.9
        for <netdev@vger.kernel.org>; Tue, 14 Apr 2020 08:27:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vQ+TIq6pzJ0Q2ozQElbFEKJsOoqImEKXdVft2D9CIIc=;
        b=FHuB3uvgYb+vF5Npw6A4iAgZ0fnWm/dr0UXYiQ85UkYAAg4DMzVkNqeN6hr+GXpcjf
         hIK26qJRbqB7UKG9yW0XX9GBtZL4mhrVaW6/SIgJmHA5/Fg6TgCGrgGCmyBjJ1Av2buN
         Nn60gxAGerslIFcWkgYxMZ9n2s8iE6UOWhS79lQ/qBzBNvleMp5PekYVJgHdyJQ/z7sC
         gcKa/eOD+1zBZgN05Xvl9oy0IlvYHCRwOLcgrY2GqLdmMmDCKZ62YjBlDFPSAZvNHtN6
         quG7bY4VE7uRTH3c0J48ttmOOjcC+zXgXxs2VCQTuElrLPhKdQMRUTKIlkjOqkuNKGne
         JQkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vQ+TIq6pzJ0Q2ozQElbFEKJsOoqImEKXdVft2D9CIIc=;
        b=Jm3WHSUazxGGasnrF4QI7qEhP3uuURT/SF+zL5VKE8aCQtXMWKCzMZxjU6mW5Q95vS
         l8hharvcTzVUWBqA0FxvmUv8DLJN2UMuWHU2PrfPMqXXtsF/RcmLQDj4aV+HSrMO+e79
         Fdb8koozryP41svbAKPWwu/RvBUEATXu2fgLC8aZOxn/Sgy2MT924CwxDpELqEAfnNBc
         18zbCZ48bCoZ+ZEL39pDrtYngyxZ9bZDmms+fdy3blWMfh2FgFCmTEbaYmDexcclMm2P
         JT7E+bv09R9Yg/6ydMB11aXe5gmiOyrS7/GBoG9Hs14jqD0/uvFWoRwHwS2M5BXbrKCw
         /5JA==
X-Gm-Message-State: AGi0PuYWxoR69Kl7kZUnjgDnx43hKmkxLn52Kz0UaITmJvxTW53ssfQJ
        s5fLjDhJKFSwoBGgfdcnHz6hyFy3hUn5jg==
X-Google-Smtp-Source: APiQypJyaQy6OtrtsYIBmLH0v4oPnGBdc7eJumiM1mP6A/bjJws5x4tWe+DSVXtkaK1YF5Rln39U8w==
X-Received: by 2002:a05:620a:102a:: with SMTP id a10mr9954336qkk.214.1586878030828;
        Tue, 14 Apr 2020 08:27:10 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id c27sm11346263qte.49.2020.04.14.08.27.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 14 Apr 2020 08:27:10 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jONSu-0005NR-On; Tue, 14 Apr 2020 12:27:08 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     netdev@vger.kernel.org, Vishal Kulkarni <vishal@chelsio.com>
Subject: [PATCH] net/cxgb4: Check the return from t4_query_params properly
Date:   Tue, 14 Apr 2020 12:27:08 -0300
Message-Id: <0-v1-ee3eeeaf7d2e+e7d-cxgb4_gcc10%jgg@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Gunthorpe <jgg@mellanox.com>

Positive return values are also failures that don't set val,
although this probably can't happen. Fixes gcc 10 warning:

drivers/net/ethernet/chelsio/cxgb4/t4_hw.c: In function ‘t4_phy_fw_ver’:
drivers/net/ethernet/chelsio/cxgb4/t4_hw.c:3747:14: warning: ‘val’ may be used uninitialized in this function [-Wmaybe-uninitialized]
 3747 |  *phy_fw_ver = val;

Fixes: 01b6961410b7 ("cxgb4: Add PHY firmware support for T420-BT cards")
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
---
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
index 239f678a94ed58..2a3480fc1d9149 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
@@ -3742,7 +3742,7 @@ int t4_phy_fw_ver(struct adapter *adap, int *phy_fw_ver)
 		 FW_PARAMS_PARAM_Z_V(FW_PARAMS_PARAM_DEV_PHYFW_VERSION));
 	ret = t4_query_params(adap, adap->mbox, adap->pf, 0, 1,
 			      &param, &val);
-	if (ret < 0)
+	if (ret)
 		return ret;
 	*phy_fw_ver = val;
 	return 0;
-- 
2.26.0

