Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D26A1C724F
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 16:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728792AbgEFOAI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 10:00:08 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:47761 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728629AbgEFOAI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 10:00:08 -0400
X-Originating-IP: 90.76.143.236
Received: from localhost (lfbn-tou-1-1075-236.w90-76.abo.wanadoo.fr [90.76.143.236])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id E123A60013;
        Wed,  6 May 2020 14:00:02 +0000 (UTC)
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     davem@davemloft.net
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>, sd@queasysnail.net,
        mstarovoitov@marvell.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net] net: macsec: fix rtnl locking issue
Date:   Wed,  6 May 2020 15:58:30 +0200
Message-Id: <20200506135830.587297-1-antoine.tenart@bootlin.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

netdev_update_features() must be called with the rtnl lock taken. Not
doing so triggers a warning, as ASSERT_RTNL() is used in
__netdev_update_features(), the first function called by
netdev_update_features(). Fix this.

Fixes: c850240b6c41 ("net: macsec: report real_dev features when HW offloading is enabled")
Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 drivers/net/macsec.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index d4034025c87c..d0d31cb99180 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -2641,11 +2641,12 @@ static int macsec_upd_offload(struct sk_buff *skb, struct genl_info *info)
 	if (ret)
 		goto rollback;
 
-	rtnl_unlock();
 	/* Force features update, since they are different for SW MACSec and
 	 * HW offloading cases.
 	 */
 	netdev_update_features(dev);
+
+	rtnl_unlock();
 	return 0;
 
 rollback:
-- 
2.26.2

