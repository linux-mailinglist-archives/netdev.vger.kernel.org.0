Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B73810C213
	for <lists+netdev@lfdr.de>; Thu, 28 Nov 2019 03:00:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728626AbfK1CAg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 21:00:36 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:46408 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728608AbfK1CAg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 21:00:36 -0500
Received: by mail-pg1-f193.google.com with SMTP id k1so3696606pga.13;
        Wed, 27 Nov 2019 18:00:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1NWy/8kAMX+v65QvJYYfXEV09Sd7DFbVQpWA/O3VSdM=;
        b=ZDQPuq5TBYpZoGzPhNGoHNbKKdXKxiCMMo601ZnEkkrmtx2u070725swBJXCqMCIgz
         3LuimkszMxVGsLjMqO2UvAumaTNCGn8WhuwEa7k6pMaQisr75y8Oc7enPCWk3WYQzdGr
         XXspDtLuA4K0Bny5rW/Y3DURJF37ZbHf8o3rPiaAVJHY81IdLFcFPW+TQM2n1hIi2YEV
         N7moVQG/JEKQi1E30iPUzRCNdqyecCUsVzDig6/gxmwFLqLwFrLTSZ/iFRHWq9nRADQt
         z9hDXDdaMUWFdQXl64g+aHn8A5fL/9PoCZPiZ9vwl+ZOR+S9If4E1HA2k+fDseJcBI4B
         hsIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1NWy/8kAMX+v65QvJYYfXEV09Sd7DFbVQpWA/O3VSdM=;
        b=iC1S056egVUWrkMC9gR36DB2UmSd60Infl/Y9PjquaGGJrbj+7lv9yTpf6c8293OXh
         6esUZnXtDsXlg7jaiZkxiDQ+zMdaUkApDs5HSSxyCUnLSzKeL5bjHwJuf68Vo5QuOe9F
         7sJJts0foGoZgqc7g2p78KSVh+rwTVhLCwtS4la1Fi+lmtGIkdYyEWclFqt5dueqUfE1
         mCxB82TW1GyMTjH6kooEI9ZxDy8dbuavouJwc44ColIYsJbA5QaujLBqCzNcfFNGi0S+
         r5NF+2QjHCLcl7EG2pvkqT2nkvnqc82DRaY9qrzEk+FdVDZbe59jcvGXEgtc/P9o7KW6
         i1Kg==
X-Gm-Message-State: APjAAAVBs5IYIDDy4WGYlixv/95a79zGju8yuKRQZT1xDTb0IWhkxtHL
        xiZrGrxLKQfOmKTLN41pw70=
X-Google-Smtp-Source: APXvYqy/8U61avG9uOn9PWYfv+bT9v34GayzyHYrcWi8xfRCZ3hYaXwujSgokK2MAY4WhpNKrB0NYg==
X-Received: by 2002:aa7:9d9c:: with SMTP id f28mr30916321pfq.20.1574906435782;
        Wed, 27 Nov 2019 18:00:35 -0800 (PST)
Received: from suzukaze.ipads-lab.se.sjtu.edu.cn ([202.120.40.82])
        by smtp.gmail.com with ESMTPSA id a19sm18387016pfn.144.2019.11.27.18.00.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Nov 2019 18:00:35 -0800 (PST)
From:   Chuhong Yuan <hslester96@gmail.com>
Cc:     Nicolas Ferre <nicolas.ferre@microchip.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>
Subject: [PATCH net v4] net: macb: add missed tasklet_kill
Date:   Thu, 28 Nov 2019 10:00:21 +0800
Message-Id: <20191128020021.23761-1-hslester96@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This driver forgets to kill tasklet in remove.
Add the call to fix it.

Fixes: 032dc41ba6e2 ("net: macb: Handle HRESP error")
Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
---
Changes in v4:
  - Put tasklet_kill after unregister_netdev to ensure
    IRQs are disabled when killing tasklet.

 drivers/net/ethernet/cadence/macb_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index d5ae2e1e0b0e..9c767ee252ac 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -4422,6 +4422,7 @@ static int macb_remove(struct platform_device *pdev)
 		mdiobus_free(bp->mii_bus);
 
 		unregister_netdev(dev);
+		tasklet_kill(&bp->hresp_err_tasklet);
 		pm_runtime_disable(&pdev->dev);
 		pm_runtime_dont_use_autosuspend(&pdev->dev);
 		if (!pm_runtime_suspended(&pdev->dev)) {
-- 
2.24.0

