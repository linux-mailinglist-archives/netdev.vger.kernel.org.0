Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FFAC3E97AE
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 20:31:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230143AbhHKScC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 14:32:02 -0400
Received: from smtp.emailarray.com ([69.28.212.198]:27653 "EHLO
        smtp2.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230153AbhHKScB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 14:32:01 -0400
Received: (qmail 22371 invoked by uid 89); 11 Aug 2021 18:31:36 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21ANzEuMjEyLjEzOC4zOQ==) (POLARISLOCAL)  
  by smtp2.emailarray.com with SMTP; 11 Aug 2021 18:31:36 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, richardcochran@gmail.com
Cc:     netdev@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH net-next 2/3] ptp: ocp: Fix error path for pci_ocp_device_init()
Date:   Wed, 11 Aug 2021 11:31:32 -0700
Message-Id: <20210811183133.186721-3-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210811183133.186721-1-jonathan.lemon@gmail.com>
References: <20210811183133.186721-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If ptp_ocp_device_init() fails, pci_disable_device() is skipped.
Fix the error handling so this case is covered.  Update ptp_ocp_remove()
so the normal exit path is identical.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/ptp/ptp_ocp.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index 9b2ba06ebf97..a8d390314897 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -1436,7 +1436,7 @@ ptp_ocp_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	bp = devlink_priv(devlink);
 	err = ptp_ocp_device_init(bp, pdev);
 	if (err)
-		goto out_unregister;
+		goto out_disable;
 
 	/* compat mode.
 	 * Older FPGA firmware only returns 2 irq's.
@@ -1474,8 +1474,9 @@ ptp_ocp_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 out:
 	ptp_ocp_detach(bp);
-	pci_disable_device(pdev);
 	pci_set_drvdata(pdev, NULL);
+out_disable:
+	pci_disable_device(pdev);
 out_unregister:
 	devlink_unregister(devlink);
 out_free:
@@ -1491,8 +1492,8 @@ ptp_ocp_remove(struct pci_dev *pdev)
 	struct devlink *devlink = priv_to_devlink(bp);
 
 	ptp_ocp_detach(bp);
-	pci_disable_device(pdev);
 	pci_set_drvdata(pdev, NULL);
+	pci_disable_device(pdev);
 
 	devlink_unregister(devlink);
 	devlink_free(devlink);
-- 
2.31.1

