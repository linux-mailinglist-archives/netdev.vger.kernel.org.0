Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0DF6706E2
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 19:27:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731644AbfGVR1Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 13:27:24 -0400
Received: from sauhun.de ([88.99.104.3]:42428 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731509AbfGVR0g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jul 2019 13:26:36 -0400
Received: from localhost (p54B33E22.dip0.t-ipconnect.de [84.179.62.34])
        by pokefinder.org (Postfix) with ESMTPSA id 895C74A1497;
        Mon, 22 Jul 2019 19:26:35 +0200 (CEST)
From:   Wolfram Sang <wsa+renesas@sang-engineering.com>
To:     linux-i2c@vger.kernel.org
Cc:     Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Solarflare linux maintainers <linux-net-drivers@solarflare.com>,
        Edward Cree <ecree@solarflare.com>,
        Martin Habets <mhabets@solarflare.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: sfc: falcon: convert to i2c_new_dummy_device
Date:   Mon, 22 Jul 2019 19:26:35 +0200
Message-Id: <20190722172635.4535-1-wsa+renesas@sang-engineering.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move from i2c_new_dummy() to i2c_new_dummy_device(). So, we now get an
ERRPTR which we use in error handling.

Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
---

Only build tested. Part of a tree-wide move to deprecate
i2c_new_dummy().

 drivers/net/ethernet/sfc/falcon/falcon_boards.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/sfc/falcon/falcon_boards.c b/drivers/net/ethernet/sfc/falcon/falcon_boards.c
index 839189dab98e..189ce9b9dfa7 100644
--- a/drivers/net/ethernet/sfc/falcon/falcon_boards.c
+++ b/drivers/net/ethernet/sfc/falcon/falcon_boards.c
@@ -454,13 +454,13 @@ static int sfe4001_init(struct ef4_nic *efx)
 
 #if IS_ENABLED(CONFIG_SENSORS_LM90)
 	board->hwmon_client =
-		i2c_new_device(&board->i2c_adap, &sfe4001_hwmon_info);
+		i2c_new_client_device(&board->i2c_adap, &sfe4001_hwmon_info);
 #else
 	board->hwmon_client =
-		i2c_new_dummy(&board->i2c_adap, sfe4001_hwmon_info.addr);
+		i2c_new_dummy_device(&board->i2c_adap, sfe4001_hwmon_info.addr);
 #endif
-	if (!board->hwmon_client)
-		return -EIO;
+	if (IS_ERR(board->hwmon_client))
+		return PTR_ERR(board->hwmon_client);
 
 	/* Raise board/PHY high limit from 85 to 90 degrees Celsius */
 	rc = i2c_smbus_write_byte_data(board->hwmon_client,
@@ -468,9 +468,9 @@ static int sfe4001_init(struct ef4_nic *efx)
 	if (rc)
 		goto fail_hwmon;
 
-	board->ioexp_client = i2c_new_dummy(&board->i2c_adap, PCA9539);
-	if (!board->ioexp_client) {
-		rc = -EIO;
+	board->ioexp_client = i2c_new_dummy_device(&board->i2c_adap, PCA9539);
+	if (IS_ERR(board->ioexp_client)) {
+		rc = PTR_ERR(board->ioexp_client);
 		goto fail_hwmon;
 	}
 
-- 
2.20.1

