Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C24A4C8B58
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 16:36:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728170AbfJBOf6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 10:35:58 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:38629 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728112AbfJBOf5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 10:35:57 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from tariqt@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 2 Oct 2019 17:35:54 +0300
Received: from dev-l-vrt-207-011.mtl.labs.mlnx. (dev-l-vrt-207-011.mtl.labs.mlnx [10.134.207.11])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x92EZsEc000653;
        Wed, 2 Oct 2019 17:35:54 +0300
From:   Tariq Toukan <tariqt@mellanox.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, Moshe Shemesh <moshe@mellanox.com>,
        Aya Levin <ayal@mellanox.com>, Jiri Pirko <jiri@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: [PATCH V2 iproute2 3/3] devlink: Fix inconsistency between command input and output
Date:   Wed,  2 Oct 2019 17:35:16 +0300
Message-Id: <1570026916-27592-4-git-send-email-tariqt@mellanox.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1570026916-27592-1-git-send-email-tariqt@mellanox.com>
References: <1570026916-27592-1-git-send-email-tariqt@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

In devlink health show command the reporter's name parameter is called
reporter, but in the output the reporter's name is referred to as name

Before this patch:
$ devlink health show pci/0000:04:00.0 reporter tx
pci/0000:04:00.0:
   name tx
     state healthy error 0 recover 0 grace_period 500 auto_recover true

After this patch:
$ devlink health show pci/0000:04:00.0 reporter tx
pci/0000:04:00.0:
   reporter tx
     state healthy error 0 recover 0 grace_period 500 auto_recover true

Reported-by: Jiri Pirko <jiri@mellanox.com>
Fixes: 2f1242efe9d0 ("devlink: Add devlink health show command")
Signed-off-by: Aya Levin <ayal@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
---
 devlink/devlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 50baf82af937..5bbe0bddd910 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -6660,7 +6660,7 @@ static void pr_out_health(struct dl *dl, struct nlattr **tb_health)
 
 	pr_out_handle_start_arr(dl, tb_health);
 
-	pr_out_str(dl, "name",
+	pr_out_str(dl, "reporter",
 		   mnl_attr_get_str(tb[DEVLINK_ATTR_HEALTH_REPORTER_NAME]));
 	if (!dl->json_output) {
 		__pr_out_newline();
-- 
2.21.0

