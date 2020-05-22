Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AFE61DEA33
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 16:54:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731171AbgEVOwC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 10:52:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:54220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731162AbgEVOwA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 May 2020 10:52:00 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A92C4221FF;
        Fri, 22 May 2020 14:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590159120;
        bh=zh+hjr+eJIQBo26ohfepRYxTdhIc+nP1ysNKviD1wAQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xRv0LOwxKNPhSmby2q3rbp2TB2tU2ne32JPuT7bo8BJSyfYXZ7qsYLyqNvIVSd6za
         qQe1bHSVjwC1/Ay2SsQX5cC6yo263xPoltPBcPXbY4tmoKjyZDdieWjeS6cA0AgeGx
         E5p5WZvnDDBOHLXc99UhYmovRrXoNQnpwP5ZoJ2M=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chuhong Yuan <hslester96@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 2/8] net: microchip: encx24j600: add missed kthread_stop
Date:   Fri, 22 May 2020 10:51:51 -0400
Message-Id: <20200522145157.435215-2-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200522145157.435215-1-sashal@kernel.org>
References: <20200522145157.435215-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chuhong Yuan <hslester96@gmail.com>

[ Upstream commit ff8ce319e9c25e920d994cc35236f0bb32dfc8f3 ]

This driver calls kthread_run() in probe, but forgets to call
kthread_stop() in probe failure and remove.
Add the missed kthread_stop() to fix it.

Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/encx24j600.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microchip/encx24j600.c b/drivers/net/ethernet/microchip/encx24j600.c
index b14f0305aa31..ad661d1979c7 100644
--- a/drivers/net/ethernet/microchip/encx24j600.c
+++ b/drivers/net/ethernet/microchip/encx24j600.c
@@ -1058,7 +1058,7 @@ static int encx24j600_spi_probe(struct spi_device *spi)
 	if (unlikely(ret)) {
 		netif_err(priv, probe, ndev, "Error %d initializing card encx24j600 card\n",
 			  ret);
-		goto out_free;
+		goto out_stop;
 	}
 
 	eidled = encx24j600_read_reg(priv, EIDLED);
@@ -1076,6 +1076,8 @@ static int encx24j600_spi_probe(struct spi_device *spi)
 
 out_unregister:
 	unregister_netdev(priv->ndev);
+out_stop:
+	kthread_stop(priv->kworker_task);
 out_free:
 	free_netdev(ndev);
 
@@ -1088,6 +1090,7 @@ static int encx24j600_spi_remove(struct spi_device *spi)
 	struct encx24j600_priv *priv = dev_get_drvdata(&spi->dev);
 
 	unregister_netdev(priv->ndev);
+	kthread_stop(priv->kworker_task);
 
 	free_netdev(priv->ndev);
 
-- 
2.25.1

