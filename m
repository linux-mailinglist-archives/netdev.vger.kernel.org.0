Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A36683604C7
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 10:47:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231772AbhDOIrv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 04:47:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:38580 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231143AbhDOIru (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 04:47:50 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1lWxel-0000fq-88; Thu, 15 Apr 2021 08:47:23 +0000
From:   Colin King <colin.king@canonical.com>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Arunachalam Santhanam <arunachalam.santhanam@in.bosch.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] can: etas_es58x: Fix missing null check on netdev pointer
Date:   Thu, 15 Apr 2021 09:47:23 +0100
Message-Id: <20210415084723.1807935-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There is an assignment to *netdev that is can potentially be null but the
null check is checking netdev and not *netdev as intended. Fix this by
adding in the missing * operator.

Addresses-Coverity: ("Dereference before null check")
Fixes: 8537257874e9 ("can: etas_es58x: add core support for ETAS ES58X CAN USB interfaces")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/can/usb/etas_es58x/es58x_core.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/usb/etas_es58x/es58x_core.h b/drivers/net/can/usb/etas_es58x/es58x_core.h
index 5f4e7dc5be35..fcf219e727bf 100644
--- a/drivers/net/can/usb/etas_es58x/es58x_core.h
+++ b/drivers/net/can/usb/etas_es58x/es58x_core.h
@@ -625,7 +625,7 @@ static inline int es58x_get_netdev(struct es58x_device *es58x_dev,
 		return -ECHRNG;
 
 	*netdev = es58x_dev->netdev[channel_idx];
-	if (!netdev || !netif_device_present(*netdev))
+	if (!*netdev || !netif_device_present(*netdev))
 		return -ENODEV;
 
 	return 0;
-- 
2.30.2

