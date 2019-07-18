Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F0E76C4B8
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 03:52:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729812AbfGRBuy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 21:50:54 -0400
Received: from mx2.suse.de ([195.135.220.15]:34998 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727658AbfGRBuy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jul 2019 21:50:54 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 489D3AD7B;
        Thu, 18 Jul 2019 01:50:53 +0000 (UTC)
From:   Benjamin Poirier <bpoirier@suse.com>
To:     David Miller <davem@davemloft.net>
Cc:     Sathya Perla <sathya.perla@broadcom.com>,
        Ajit Khaparde <ajit.khaparde@broadcom.com>,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
        Somnath Kotur <somnath.kotur@broadcom.com>,
        Firo Yang <fyang@suse.com>,
        Saeed Mahameed <saeedm@mellanox.com>, netdev@vger.kernel.org
Subject: [PATCH net] be2net: Synchronize be_update_queues with dev_watchdog
Date:   Thu, 18 Jul 2019 10:42:18 +0900
Message-Id: <20190718014218.16610-1-bpoirier@suse.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As pointed out by Firo Yang, a netdev tx timeout may trigger just before an
ethtool set_channels operation is started. be_tx_timeout(), which dumps
some queue structures, is not written to run concurrently with
be_update_queues(), which frees/allocates those queues structures. Add some
synchronization between the two.

Message-id: <CH2PR18MB31898E033896F9760D36BFF288C90@CH2PR18MB3189.namprd18.prod.outlook.com>
Signed-off-by: Benjamin Poirier <bpoirier@suse.com>
---
 drivers/net/ethernet/emulex/benet/be_main.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/emulex/benet/be_main.c b/drivers/net/ethernet/emulex/benet/be_main.c
index b7a246b33599..2edb86ec9fe9 100644
--- a/drivers/net/ethernet/emulex/benet/be_main.c
+++ b/drivers/net/ethernet/emulex/benet/be_main.c
@@ -4698,8 +4698,13 @@ int be_update_queues(struct be_adapter *adapter)
 	int status;
 
 	if (netif_running(netdev)) {
+		/* be_tx_timeout() must not run concurrently with this
+		 * function, synchronize with an already-running dev_watchdog
+		 */
+		netif_tx_lock_bh(netdev);
 		/* device cannot transmit now, avoid dev_watchdog timeouts */
 		netif_carrier_off(netdev);
+		netif_tx_unlock_bh(netdev);
 
 		be_close(netdev);
 	}
-- 
2.22.0

