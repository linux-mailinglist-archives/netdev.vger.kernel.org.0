Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A6D23E1D1D
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 21:59:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243087AbhHET75 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 15:59:57 -0400
Received: from smtp5.emailarray.com ([65.39.216.39]:49297 "EHLO
        smtp5.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242910AbhHET7v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 15:59:51 -0400
Received: (qmail 83248 invoked by uid 89); 5 Aug 2021 19:52:56 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21ANzEuMjEyLjEzOC4zOQ==) (POLARISLOCAL)  
  by smtp5.emailarray.com with SMTP; 5 Aug 2021 19:52:56 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, richardcochran@gmail.com
Cc:     netdev@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH net-next 6/6] ptp: ocp: Remove pending_image indicator from devlink
Date:   Thu,  5 Aug 2021 12:52:48 -0700
Message-Id: <20210805195248.35665-7-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210805195248.35665-1-jonathan.lemon@gmail.com>
References: <20210805195248.35665-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After writing an image blob to the flash memory, a reboot is required
to reload the FPGA.  There is no versioning prsent in the FPGA image
file, so only a running version is available.  The 'stored version'
was set to 'pending' in order to indicate a reboot was needed.

This isn't reliable, as the module could be unloaded/loaded, losing
the "reboot needed" indicator.  Also, the devlink 'stored version'
information is designed to refer to the actual image version.

Unfortunately, there is no method to determine the flash image version
other than booting it, so remove the devlink stored version setting.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/ptp/ptp_ocp.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index 1412015fd261..6b9c14586987 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -171,7 +171,6 @@ struct ptp_ocp {
 	u8			serial[6];
 	int			flash_start;
 	bool			has_serial;
-	bool			pending_image;
 };
 
 struct ocp_resource {
@@ -836,8 +835,6 @@ ptp_ocp_devlink_flash_update(struct devlink *devlink,
 	msg = err ? "Flash error" : "Flash complete";
 	devlink_flash_update_status_notify(devlink, msg, NULL, 0, 0);
 
-	bp->pending_image = true;
-
 	put_device(dev);
 	return err;
 }
@@ -854,13 +851,6 @@ ptp_ocp_devlink_info_get(struct devlink *devlink, struct devlink_info_req *req,
 	if (err)
 		return err;
 
-	if (bp->pending_image) {
-		err = devlink_info_version_stored_put(req,
-						      "timecard", "pending");
-		if (err)
-			return err;
-	}
-
 	if (bp->image) {
 		u32 ver = ioread32(&bp->image->version);
 
-- 
2.31.1

