Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09DEB3EDFBD
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 00:14:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233784AbhHPWOX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 18:14:23 -0400
Received: from smtp7.emailarray.com ([65.39.216.66]:22258 "EHLO
        smtp7.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232272AbhHPWOS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 18:14:18 -0400
Received: (qmail 21305 invoked by uid 89); 16 Aug 2021 22:13:40 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21ANzEuMjEyLjEzOC4zOQ==) (POLARISLOCAL)  
  by smtp7.emailarray.com with SMTP; 16 Aug 2021 22:13:40 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     kuba@kernel.org, davem@davemloft.net, richardcochran@gmail.com
Cc:     kernel-team@fb.com, netdev@vger.kernel.org
Subject: [PATCH net-next v2 2/4] ptp: ocp: Fix error path for pci_ocp_device_init()
Date:   Mon, 16 Aug 2021 15:13:35 -0700
Message-Id: <20210816221337.390645-3-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210816221337.390645-1-jonathan.lemon@gmail.com>
References: <20210816221337.390645-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If ptp_ocp_device_init() fails, pci_disable_device() is skipped.
Fix the error handling so this case is covered.  Update ptp_ocp_remove()
so the normal exit path is identical.

Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: 773bda964921 ("ptp: ocp: Expose various resources on the
timecard.")
Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/ptp/ptp_ocp.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index 9e4317d1184f..caf9b37c5eb1 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -1438,7 +1438,7 @@ ptp_ocp_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	bp = devlink_priv(devlink);
 	err = ptp_ocp_device_init(bp, pdev);
 	if (err)
-		goto out_unregister;
+		goto out_disable;
 
 	/* compat mode.
 	 * Older FPGA firmware only returns 2 irq's.
@@ -1476,8 +1476,9 @@ ptp_ocp_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 out:
 	ptp_ocp_detach(bp);
-	pci_disable_device(pdev);
 	pci_set_drvdata(pdev, NULL);
+out_disable:
+	pci_disable_device(pdev);
 out_unregister:
 	devlink_unregister(devlink);
 out_free:
@@ -1493,8 +1494,8 @@ ptp_ocp_remove(struct pci_dev *pdev)
 	struct devlink *devlink = priv_to_devlink(bp);
 
 	ptp_ocp_detach(bp);
-	pci_disable_device(pdev);
 	pci_set_drvdata(pdev, NULL);
+	pci_disable_device(pdev);
 
 	devlink_unregister(devlink);
 	devlink_free(devlink);
-- 
2.31.1

