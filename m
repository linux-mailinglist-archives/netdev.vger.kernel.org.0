Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B90D940BD99
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 04:16:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235994AbhIOCSG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 22:18:06 -0400
Received: from smtp.emailarray.com ([69.28.212.198]:53830 "EHLO
        smtp2.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230037AbhIOCSB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 22:18:01 -0400
Received: (qmail 33941 invoked by uid 89); 15 Sep 2021 02:16:43 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21ANzEuMjEyLjEzOC4zOQ==) (POLARISLOCAL)  
  by smtp2.emailarray.com with SMTP; 15 Sep 2021 02:16:43 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     kuba@kernel.org, davem@davemloft.net, richardcochran@gmail.com
Cc:     netdev@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH net-next 05/18] ptp: ocp: Report error if resource registration fails.
Date:   Tue, 14 Sep 2021 19:16:23 -0700
Message-Id: <20210915021636.153754-6-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210915021636.153754-1-jonathan.lemon@gmail.com>
References: <20210915021636.153754-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If a resource could not be registered, report the name of
the resource and the error code.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/ptp/ptp_ocp.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index ad8b794fa7e6..1f86e878ccba 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -1158,8 +1158,12 @@ ptp_ocp_register_resources(struct ptp_ocp *bp, kernel_ulong_t driver_data)
 		if (!ptp_ocp_allow_irq(bp, r))
 			continue;
 		err = r->setup(bp, r);
-		if (err)
+		if (err) {
+			dev_err(&bp->pdev->dev,
+				"Could not register %s: err %d\n",
+				r->name, err);
 			break;
+		}
 	}
 	return err;
 }
-- 
2.31.1

