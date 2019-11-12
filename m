Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F50EF8E95
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 12:29:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726376AbfKLL2u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 06:28:50 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:37215 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725834AbfKLL2u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 06:28:50 -0500
Received: by mail-pf1-f195.google.com with SMTP id p24so13159778pfn.4;
        Tue, 12 Nov 2019 03:28:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oT7NRAnyWQZcqS8AZQGXhNMhZCid5Elpr5j+vrnZHcU=;
        b=lYkJbcXPDdsi7jkKZGkeVZiExzVguF/ZPSqgZSlTY+l9kqmuYUTbaQMEnFKbSfDQBt
         CbOPc4nWtfOUsf5HymN5KnawVbboJh+p0h35SMpaotcIZPhH3skBMDtB8Nhwle2j5xv3
         TyGPQZ2MgTFuNbDIUWKPQj3a613j6aqIrGPGeGXEZM3I22zqXnaho9cP0we8IwJiXoul
         Myc9souDNDHVIN1I5XijI8OQuDjTodID4uq0Stnc3PLwV1r7lwN+wD+3t69aWJ+gawEp
         pgt/jisP73JZIGB7SOMBP5hd9/qJUNCd4+aq/qwWnJ9+bgeHUqw72745mCVahb+Zp0hI
         grnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oT7NRAnyWQZcqS8AZQGXhNMhZCid5Elpr5j+vrnZHcU=;
        b=GhhNkCHzrfBGU2WTppdUk5BxUK0V180fdOMDuJfHNnYlW0eiq9GshbmEJR/h66NGXi
         Hb5mzGYmes5JvvbRgpLQF5hu4sglQPH0JyzTzgfTdLLPUWX3m12GnEgsxlDfPy7Am0WH
         ePwmA32hMXROypK5kXekxzcqH03kjnEWOs+Y5OOuhOWfFDmdsitzx5raZQdW3Vp8HYMW
         NGlfS/nT4KYEa9OXul2cmH5UmCGuQJI5HouJCD0MAt96QbkthXfQSu7951j6rdkD+D+f
         DVArZI6BLHe8x4NK8QZnE4Ta+jbGJDqjR5luZOGkHDJi9i6sCyWRFbWGdTnFrGEL6qoQ
         fklQ==
X-Gm-Message-State: APjAAAV8YwDl1oeZsNrJotuxFAj/DIx+ZH6zs1DNqM1kIRAy1kvLcxxL
        ixHrRGEVP/JL2bXvz1GDlOw=
X-Google-Smtp-Source: APXvYqymsjHT/w3t33EfC2KpLRIRSqzElbdl0GKlJ/vpN8hBO5y8qeRVeFRiRbK4P9p/QhS0tKMb5A==
X-Received: by 2002:aa7:90d5:: with SMTP id k21mr24209947pfk.178.1573558129598;
        Tue, 12 Nov 2019 03:28:49 -0800 (PST)
Received: from suzukaze.ipads-lab.se.sjtu.edu.cn ([202.120.40.82])
        by smtp.gmail.com with ESMTPSA id c9sm29569778pfb.114.2019.11.12.03.28.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2019 03:28:48 -0800 (PST)
From:   Chuhong Yuan <hslester96@gmail.com>
Cc:     Fugang Duan <fugang.duan@nxp.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>
Subject: [PATCH net v2] net: fec: add a check for CONFIG_PM to avoid clock count mis-match
Date:   Tue, 12 Nov 2019 19:28:30 +0800
Message-Id: <20191112112830.27561-1-hslester96@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If CONFIG_PM is enabled, runtime pm will work and call runtime_suspend
automatically to disable clks.
Therefore, remove only needs to disable clks when CONFIG_PM is disabled.
Add this check to avoid clock count mis-match caused by double-disable.

Fixes: c43eab3eddb4 ("net: fec: add missed clk_disable_unprepare in remove")
Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
---
Changes in v2:
  - Add fixes tag.

 drivers/net/ethernet/freescale/fec_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index a9c386b63581..696550f4972f 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -3645,8 +3645,10 @@ fec_drv_remove(struct platform_device *pdev)
 		regulator_disable(fep->reg_phy);
 	pm_runtime_put(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
+#ifndef CONFIG_PM
 	clk_disable_unprepare(fep->clk_ahb);
 	clk_disable_unprepare(fep->clk_ipg);
+#endif
 	if (of_phy_is_fixed_link(np))
 		of_phy_deregister_fixed_link(np);
 	of_node_put(fep->phy_node);
-- 
2.23.0

