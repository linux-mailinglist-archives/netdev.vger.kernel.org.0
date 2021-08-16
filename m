Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E30DE3EDFBF
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 00:14:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233981AbhHPWOZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 18:14:25 -0400
Received: from smtp3.emailarray.com ([65.39.216.17]:11138 "EHLO
        smtp3.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232269AbhHPWOS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 18:14:18 -0400
Received: (qmail 44380 invoked by uid 89); 16 Aug 2021 22:13:39 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21ANzEuMjEyLjEzOC4zOQ==) (POLARISLOCAL)  
  by smtp3.emailarray.com with SMTP; 16 Aug 2021 22:13:39 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     kuba@kernel.org, davem@davemloft.net, richardcochran@gmail.com
Cc:     kernel-team@fb.com, netdev@vger.kernel.org
Subject: [PATCH net-next v2 1/4] ptp: ocp: Fix uninitialized variable warning spotted by clang.
Date:   Mon, 16 Aug 2021 15:13:34 -0700
Message-Id: <20210816221337.390645-2-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210816221337.390645-1-jonathan.lemon@gmail.com>
References: <20210816221337.390645-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If attempting to flash the firmware with a blob of size 0,
the entire write loop is skipped and the uninitialized err
is returned.  Fix by setting to 0 first.

Fixes: 773bda964921 ("ptp: ocp: Expose various resources on the
timecard.")
Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/ptp/ptp_ocp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index 92edf772feed..9e4317d1184f 100644
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
-- 
2.31.1

