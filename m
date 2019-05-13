Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C3411B4AB
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 13:15:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729413AbfEMLPc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 07:15:32 -0400
Received: from mx2.suse.de ([195.135.220.15]:49006 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728906AbfEMLPa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 May 2019 07:15:30 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 3AAB5AD7C;
        Mon, 13 May 2019 11:15:29 +0000 (UTC)
From:   Thomas Bogendoerfer <tbogendoerfer@suse.de>
To:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net] net: seeq: fix crash caused by not set dev.parent
Date:   Mon, 13 May 2019 13:15:17 +0200
Message-Id: <20190513111517.14780-1-tbogendoerfer@suse.de>
X-Mailer: git-send-email 2.13.7
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The old MIPS implementation of dma_cache_sync() didn't use the dev argument,
but commit c9eb6172c328 ("dma-mapping: turn dma_cache_sync into a
dma_map_ops method") changed that, so we now need to set dev.parent.

Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
---
 drivers/net/ethernet/seeq/sgiseeq.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/seeq/sgiseeq.c b/drivers/net/ethernet/seeq/sgiseeq.c
index 70cce63a6081..696037d5ac3d 100644
--- a/drivers/net/ethernet/seeq/sgiseeq.c
+++ b/drivers/net/ethernet/seeq/sgiseeq.c
@@ -735,6 +735,7 @@ static int sgiseeq_probe(struct platform_device *pdev)
 	}
 
 	platform_set_drvdata(pdev, dev);
+	SET_NETDEV_DEV(dev, &pdev->dev);
 	sp = netdev_priv(dev);
 
 	/* Make private data page aligned */
-- 
2.13.7

