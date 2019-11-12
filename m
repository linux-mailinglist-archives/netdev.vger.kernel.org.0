Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E08B3F8F45
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 13:08:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726697AbfKLMIQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 07:08:16 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:58227 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726979AbfKLMIP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 07:08:15 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from ayal@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 12 Nov 2019 14:08:08 +0200
Received: from dev-l-vrt-210.mtl.labs.mlnx (dev-l-vrt-210.mtl.labs.mlnx [10.134.210.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id xACC88aF029872;
        Tue, 12 Nov 2019 14:08:08 +0200
Received: from dev-l-vrt-210.mtl.labs.mlnx (localhost [127.0.0.1])
        by dev-l-vrt-210.mtl.labs.mlnx (8.15.2/8.15.2/Debian-8ubuntu1) with ESMTP id xACC882J004244;
        Tue, 12 Nov 2019 14:08:08 +0200
Received: (from ayal@localhost)
        by dev-l-vrt-210.mtl.labs.mlnx (8.15.2/8.15.2/Submit) id xACC88sU004243;
        Tue, 12 Nov 2019 14:08:08 +0200
From:   Aya Levin <ayal@mellanox.com>
To:     David Miller <davem@davemloft.net>, Jiri Pirko <jiri@mellanox.com>
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@mellanox.com>
Subject: [PATCH net-next 4/4] selftests: Add a test of large binary to devlink health test
Date:   Tue, 12 Nov 2019 14:07:52 +0200
Message-Id: <1573560472-4187-5-git-send-email-ayal@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1573560472-4187-1-git-send-email-ayal@mellanox.com>
References: <1573560472-4187-1-git-send-email-ayal@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a test of 2 PAGEs size (exceeds devlink previous length limitation)
of binary data on a 'devlink health dump show' command. Set binary length
to 8192, issue a dump show command and clear it.

Signed-off-by: Aya Levin <ayal@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 tools/testing/selftests/drivers/net/netdevsim/devlink.sh | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
index 753c5b6abe0a..025a84c2ab5a 100755
--- a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
+++ b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
@@ -431,6 +431,15 @@ dummy_reporter_test()
 
 	check_reporter_info dummy healthy 3 3 10 true
 
+	echo 8192> $DEBUGFS_DIR/health/binary_len
+	check_fail $? "Failed set dummy reporter binary len to 8192"
+
+	local dump=$(devlink health dump show $DL_HANDLE reporter dummy -j)
+	check_err $? "Failed show dump of dummy reporter"
+
+	devlink health dump clear $DL_HANDLE reporter dummy
+	check_err $? "Failed clear dump of dummy reporter"
+
 	log_test "dummy reporter test"
 }
 
-- 
2.14.1

