Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8985194A23
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 22:12:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728001AbgCZVLx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 17:11:53 -0400
Received: from sauhun.de ([88.99.104.3]:54390 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727873AbgCZVKD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Mar 2020 17:10:03 -0400
Received: from localhost (p54B3331F.dip0.t-ipconnect.de [84.179.51.31])
        by pokefinder.org (Postfix) with ESMTPSA id 4A9982C1F8F;
        Thu, 26 Mar 2020 22:10:02 +0100 (CET)
From:   Wolfram Sang <wsa+renesas@sang-engineering.com>
To:     linux-i2c@vger.kernel.org
Cc:     Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Solarflare linux maintainers <linux-net-drivers@solarflare.com>,
        Edward Cree <ecree@solarflare.com>,
        Martin Habets <mhabets@solarflare.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] sfc: falcon: convert to use i2c_new_client_device()
Date:   Thu, 26 Mar 2020 22:10:00 +0100
Message-Id: <20200326211001.13171-3-wsa+renesas@sang-engineering.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200326211001.13171-1-wsa+renesas@sang-engineering.com>
References: <20200326211001.13171-1-wsa+renesas@sang-engineering.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move away from the deprecated API and return the shiny new ERRPTR where
useful.

Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
---
 drivers/net/ethernet/sfc/falcon/falcon_boards.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/sfc/falcon/falcon_boards.c b/drivers/net/ethernet/sfc/falcon/falcon_boards.c
index 605f486fa675..729a05c1b0cf 100644
--- a/drivers/net/ethernet/sfc/falcon/falcon_boards.c
+++ b/drivers/net/ethernet/sfc/falcon/falcon_boards.c
@@ -88,11 +88,11 @@ static int ef4_init_lm87(struct ef4_nic *efx, const struct i2c_board_info *info,
 			 const u8 *reg_values)
 {
 	struct falcon_board *board = falcon_board(efx);
-	struct i2c_client *client = i2c_new_device(&board->i2c_adap, info);
+	struct i2c_client *client = i2c_new_client_device(&board->i2c_adap, info);
 	int rc;
 
-	if (!client)
-		return -EIO;
+	if (IS_ERR(client))
+		return PTR_ERR(client);
 
 	/* Read-to-clear alarm/interrupt status */
 	i2c_smbus_read_byte_data(client, LM87_REG_ALARMS1);
-- 
2.20.1

