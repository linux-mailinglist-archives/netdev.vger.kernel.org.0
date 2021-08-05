Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B42B3E1D18
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 21:59:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240406AbhHET7r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 15:59:47 -0400
Received: from smtp3.emailarray.com ([65.39.216.17]:46444 "EHLO
        smtp3.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229970AbhHET7p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 15:59:45 -0400
Received: (qmail 34857 invoked by uid 89); 5 Aug 2021 19:52:50 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21ANzEuMjEyLjEzOC4zOQ==) (POLARISLOCAL)  
  by smtp3.emailarray.com with SMTP; 5 Aug 2021 19:52:50 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, richardcochran@gmail.com
Cc:     netdev@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH net-next 1/6] ptp: ocp: Fix the error handling path for the class device.
Date:   Thu,  5 Aug 2021 12:52:43 -0700
Message-Id: <20210805195248.35665-2-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210805195248.35665-1-jonathan.lemon@gmail.com>
References: <20210805195248.35665-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the put_device() call to the error handling path, so the
device is released after the .release callback, avoiding a
use-after-free.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/ptp/ptp_ocp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index 039d3a5c2a6f..261713c6e9a7 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -1381,7 +1381,6 @@ ptp_ocp_device_init(struct ptp_ocp *bp, struct pci_dev *pdev)
 	err = device_add(&bp->dev);
 	if (err) {
 		dev_err(&bp->dev, "device add failed: %d\n", err);
-		put_device(&bp->dev);
 		goto out;
 	}
 
@@ -1391,6 +1390,7 @@ ptp_ocp_device_init(struct ptp_ocp *bp, struct pci_dev *pdev)
 
 out:
 	ptp_ocp_dev_release(&bp->dev);
+	put_device(&bp->dev);
 	return err;
 }
 
-- 
2.31.1

