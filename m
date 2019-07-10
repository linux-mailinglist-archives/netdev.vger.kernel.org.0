Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3767F6458D
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 13:03:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727180AbfGJLDf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 07:03:35 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:54915 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725994AbfGJLDe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 07:03:34 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from tariqt@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 10 Jul 2019 14:03:30 +0300
Received: from dev-l-vrt-206-006.mtl.labs.mlnx (dev-l-vrt-206-006.mtl.labs.mlnx [10.134.206.6])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x6AB3URx020650;
        Wed, 10 Jul 2019 14:03:30 +0300
From:   Tariq Toukan <tariqt@mellanox.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, moshe@mellanox.com, ayal@mellanox.com,
        Tariq Toukan <tariqt@mellanox.com>
Subject: [PATCH iproute2 master 1/3] devlink: Change devlink health dump show command to dumpit
Date:   Wed, 10 Jul 2019 14:03:19 +0300
Message-Id: <1562756601-19171-2-git-send-email-tariqt@mellanox.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1562756601-19171-1-git-send-email-tariqt@mellanox.com>
References: <1562756601-19171-1-git-send-email-tariqt@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

Although devlink health dump show command is given per reporter, it
returns large amounts of data. Trying to use the doit cb results in
OUT-OF-BUFFER error. This complementary patch raises the DUMP flag in
order to invoke the dumpit cb. We're safe as no existing drivers
implement the dump health reporter option yet.

Fixes: 041e6e651a8e ("devlink: Add devlink health dump show command")
Signed-off-by: Aya Levin <ayal@mellanox.com>
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
---
 devlink/devlink.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index ac8c0fb149b6..e3e1e27ab312 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -6078,13 +6078,13 @@ static int cmd_fmsg_object_cb(const struct nlmsghdr *nlh, void *data)
 	return MNL_CB_OK;
 }
 
-static int cmd_health_object_common(struct dl *dl, uint8_t cmd)
+static int cmd_health_object_common(struct dl *dl, uint8_t cmd, uint16_t flags)
 {
 	struct fmsg_cb_data data;
 	struct nlmsghdr *nlh;
 	int err;
 
-	nlh = mnlg_msg_prepare(dl->nlg, cmd,  NLM_F_REQUEST | NLM_F_ACK);
+	nlh = mnlg_msg_prepare(dl->nlg, cmd, flags | NLM_F_REQUEST | NLM_F_ACK);
 
 	err = dl_argv_parse_put(nlh, dl,
 				DL_OPT_HANDLE | DL_OPT_HEALTH_REPORTER_NAME, 0);
@@ -6099,12 +6099,16 @@ static int cmd_health_object_common(struct dl *dl, uint8_t cmd)
 
 static int cmd_health_dump_show(struct dl *dl)
 {
-	return cmd_health_object_common(dl, DEVLINK_CMD_HEALTH_REPORTER_DUMP_GET);
+	return cmd_health_object_common(dl,
+					DEVLINK_CMD_HEALTH_REPORTER_DUMP_GET,
+					NLM_F_DUMP);
 }
 
 static int cmd_health_diagnose(struct dl *dl)
 {
-	return cmd_health_object_common(dl, DEVLINK_CMD_HEALTH_REPORTER_DIAGNOSE);
+	return cmd_health_object_common(dl,
+					DEVLINK_CMD_HEALTH_REPORTER_DIAGNOSE,
+					0);
 }
 
 static int cmd_health_recover(struct dl *dl)
-- 
1.8.3.1

