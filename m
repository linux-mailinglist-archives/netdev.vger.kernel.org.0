Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B829D3E97AD
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 20:31:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230055AbhHKScB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 14:32:01 -0400
Received: from smtp.emailarray.com ([69.28.212.198]:27622 "EHLO
        smtp2.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229869AbhHKScA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 14:32:00 -0400
Received: (qmail 22347 invoked by uid 89); 11 Aug 2021 18:31:35 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21ANzEuMjEyLjEzOC4zOQ==) (POLARISLOCAL)  
  by smtp2.emailarray.com with SMTP; 11 Aug 2021 18:31:35 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, richardcochran@gmail.com
Cc:     netdev@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH net-next 1/3] ptp: ocp: Fix uninitialized variable warning spotted by clang.
Date:   Wed, 11 Aug 2021 11:31:31 -0700
Message-Id: <20210811183133.186721-2-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210811183133.186721-1-jonathan.lemon@gmail.com>
References: <20210811183133.186721-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If attempting to flash the firmware with a blob of size 0,
the entire write loop is skipped and the uninitialized err
is returned.  Fix by setting to 0 first.

Also remove a now-unused error handling statement.

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/ptp/ptp_ocp.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index 92edf772feed..9b2ba06ebf97 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -763,7 +763,7 @@ ptp_ocp_devlink_flash(struct devlink *devlink, struct device *dev,
 	size_t off, len, resid, wrote;
 	struct erase_info erase;
 	size_t base, blksz;
-	int err;
+	int err = 0;
 
 	off = 0;
 	base = bp->flash_start;
@@ -847,8 +847,6 @@ ptp_ocp_devlink_info_get(struct devlink *devlink, struct devlink_info_req *req,
 							       "loader",
 							       buf);
 		}
-		if (err)
-			return err;
 	}
 
 	if (!bp->has_serial)
-- 
2.31.1

