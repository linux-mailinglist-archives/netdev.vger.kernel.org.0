Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 437B623414D
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 10:38:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731374AbgGaIio (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 04:38:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:59380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728437AbgGaIio (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jul 2020 04:38:44 -0400
Received: from lore-desk.redhat.com (unknown [151.48.137.169])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8231F20838;
        Fri, 31 Jul 2020 08:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596184723;
        bh=ifRM/nHEVJ4lUYhitdOBi2F2Kn/1xb4SW12+T//59O8=;
        h=From:To:Cc:Subject:Date:From;
        b=I2BfSerwBkWy7z/i2RiYbPV8oXMxKaU8pioyxktWS+7JE7DkdFQTe7nGNisWDDh38
         U/qXIV+uIas19qZfod5itS8eFw9tL9yK9klg6ttircs3ZUi1tmAZ8Ymwn+ehUR3tXy
         bFcOslq5Ku+J+JGxLaDs680VlKAidVpPDi1MN2UI=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, lorenzo.bianconi@redhat.com, mw@semihalf.com,
        mcroce@microsoft.com
Subject: [PATCH net] net: mvpp2: fix memory leak in mvpp2_rx
Date:   Fri, 31 Jul 2020 10:38:32 +0200
Message-Id: <c1c2f9c0b79d4a84701d374c6e63f69ec3f42098.1596184502.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Release skb memory in mvpp2_rx() if mvpp2_rx_refill routine fails

Fixes: b5015854674b ("net: mvpp2: fix refilling BM pools in RX path")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 24f4d8e0da98..ee72397813d4 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -2981,6 +2981,7 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
 		err = mvpp2_rx_refill(port, bm_pool, pool);
 		if (err) {
 			netdev_err(port->dev, "failed to refill BM pools\n");
+			dev_kfree_skb_any(skb);
 			goto err_drop_frame;
 		}
 
-- 
2.26.2

