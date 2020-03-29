Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3227196CCD
	for <lists+netdev@lfdr.de>; Sun, 29 Mar 2020 13:06:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728104AbgC2LGE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Mar 2020 07:06:04 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:38083 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727965AbgC2LGC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Mar 2020 07:06:02 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from eranbe@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 29 Mar 2020 14:05:58 +0300
Received: from dev-l-vrt-198.mtl.labs.mlnx (dev-l-vrt-198.mtl.labs.mlnx [10.134.198.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 02TB5wV8006555;
        Sun, 29 Mar 2020 14:05:58 +0300
From:   Eran Ben Elisha <eranbe@mellanox.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>
Cc:     Eran Ben Elisha <eranbe@mellanox.com>
Subject: [PATCH net-next v2 1/3] netdevsim: Change dummy reporter auto recover default
Date:   Sun, 29 Mar 2020 14:05:53 +0300
Message-Id: <1585479955-29828-2-git-send-email-eranbe@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1585479955-29828-1-git-send-email-eranbe@mellanox.com>
References: <1585479955-29828-1-git-send-email-eranbe@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Health reporters should be registered with auto recover set to true.
Align dummy reporter behaviour with that, as in later patch the option to
set auto recover behaviour will be removed.

In addition, align netdevsim selftest to the new default value.

Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
---
 drivers/net/netdevsim/health.c                           | 2 +-
 tools/testing/selftests/drivers/net/netdevsim/devlink.sh | 5 +++++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/netdevsim/health.c b/drivers/net/netdevsim/health.c
index ba8d9ad60feb..9ff345d5524b 100644
--- a/drivers/net/netdevsim/health.c
+++ b/drivers/net/netdevsim/health.c
@@ -278,7 +278,7 @@ int nsim_dev_health_init(struct nsim_dev *nsim_dev, struct devlink *devlink)
 	health->dummy_reporter =
 		devlink_health_reporter_create(devlink,
 					       &nsim_dev_dummy_reporter_ops,
-					       0, false, health);
+					       0, true, health);
 	if (IS_ERR(health->dummy_reporter)) {
 		err = PTR_ERR(health->dummy_reporter);
 		goto err_empty_reporter_destroy;
diff --git a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
index 32cb2a159c70..9f9741444549 100755
--- a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
+++ b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
@@ -377,6 +377,11 @@ dummy_reporter_test()
 {
 	RET=0
 
+	check_reporter_info dummy healthy 0 0 0 true
+
+	devlink health set $DL_HANDLE reporter dummy auto_recover false
+	check_err $? "Failed to dummy reporter auto_recover option"
+
 	check_reporter_info dummy healthy 0 0 0 false
 
 	local BREAK_MSG="foo bar"
-- 
2.17.1

