Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1434936050C
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 10:55:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231843AbhDOI4H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 04:56:07 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:38759 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231143AbhDOI4G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 04:56:06 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1lWxmi-00016L-Fb; Thu, 15 Apr 2021 08:55:36 +0000
From:   Colin King <colin.king@canonical.com>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Arunachalam Santhanam <arunachalam.santhanam@in.bosch.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] can: etas_es58x: Fix potential null pointer dereference on pointer cf
Date:   Thu, 15 Apr 2021 09:55:35 +0100
Message-Id: <20210415085535.1808272-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The pointer cf is being null checked earlier in the code, however the
update of the rx_bytes statistics is dereferencing cf without null
checking cf.  Fix this by moving the statement into the following code
block that has a null cf check.

Addresses-Coverity: ("Dereference after null check")
Fixes: 8537257874e9 ("can: etas_es58x: add core support for ETAS ES58X CAN USB interfaces")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/can/usb/etas_es58x/es58x_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/usb/etas_es58x/es58x_core.c b/drivers/net/can/usb/etas_es58x/es58x_core.c
index 7222b3b6ca46..5198e1d6b6ad 100644
--- a/drivers/net/can/usb/etas_es58x/es58x_core.c
+++ b/drivers/net/can/usb/etas_es58x/es58x_core.c
@@ -856,9 +856,10 @@ int es58x_rx_err_msg(struct net_device *netdev, enum es58x_err error,
 	 * consistency.
 	 */
 	netdev->stats.rx_packets++;
-	netdev->stats.rx_bytes += cf->can_dlc;
 
 	if (cf) {
+		netdev->stats.rx_bytes += cf->can_dlc;
+
 		if (cf->data[1])
 			cf->can_id |= CAN_ERR_CRTL;
 		if (cf->data[2] || cf->data[3]) {
-- 
2.30.2

