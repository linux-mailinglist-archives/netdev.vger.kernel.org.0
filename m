Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B34B3E1F78
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 01:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240307AbhHEXpV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 19:45:21 -0400
Received: from mga18.intel.com ([134.134.136.126]:24949 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232947AbhHEXpU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Aug 2021 19:45:20 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10067"; a="201462939"
X-IronPort-AV: E=Sophos;i="5.84,296,1620716400"; 
   d="scan'208";a="201462939"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2021 16:45:05 -0700
X-IronPort-AV: E=Sophos;i="5.84,296,1620716400"; 
   d="scan'208";a="459198193"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.4])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2021 16:45:05 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kubakici@wp.pl>, Jiri Pirko <jiri@resnulli.us>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH iproute2] devlink: fix infinite loop on flash update for drivers without status
Date:   Thu,  5 Aug 2021 16:44:59 -0700
Message-Id: <20210805234459.4011587-1-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.31.1.331.gb0c09ab8796f
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When processing device flash update, cmd_dev_flash function waits until
the flash process has completed. This requires the following two
conditions to both be true:

a) we've received an exit status from the child process
b) we've received the DEVLINK_CMD_FLASH_UPDATE_END *or*
   we haven't received any status notifications from the driver.

The original devlink flash status monitoring code in 9b13cddfe268
("devlink: implement flash status monitoring") was written assuming that
a driver will either send no status updates, or it will send at least
one DEVLINK_CMD_FLASH_UPDATE_STATUS before DEVLINK_CMD_FLASH_UPDATE_END.

Newer versions of the kernel since commit 52cc5f3a166a ("devlink: move flash
end and begin to core devlink") in v5.10 moved handling of the
DEVLINK_CMD_FLASH_UPDATE_END into the core stack, and will send this
regardless of whether or not the driver sends any of its own status
notifications.

The handling of DEVLINK_CMD_FLASH_UPDATE_END in cmd_dev_flash_status_cb
has an additional condition that it must not be the first message.
Otherwise, it falls back to treating it like
a DEVLINK_CMD_FLASH_UPDATE_STATUS.

This is wrong because it can lead to an infinite loop if a driver does
not send any status updates.

In this case, the kernel will send DEVLINK_CMD_FLASH_UPDATE_END without
any DEVLINK_CMD_FLASH_UPDATE_STATUS. The devlink application will see
that ctx->not_first is false, and will treat this like any other status
message. Thus, ctx->not_first will be set to 1.

The loop condition to exit flash update will thus never be true, since
we will wait forever, because ctx->not_first is true, and
ctx->received_end is false.

This leads to the application appearing to process the flash update, but
it will never exit.

Fix this by simply always treating DEVLINK_CMD_FLASH_UPDATE_END the same
regardless of whether its the first message or not.

This is obviously the correct thing to do: once we've received the
DEVLINK_CMD_FLASH_UPDATE_END the flash update must be finished. For new
kernels this is always true, because we send this message in the core
stack after the driver flash update routine finishes.

For older kernels, some drivers may not have sent any
DEVLINK_CMD_FLASH_UPDATE_STATUS or DEVLINK_CMD_FLASH_UPDATE_END. This is
handled by the while loop conditional that exits if we get a return
value from the child process without having received any status
notifications.

An argument could be made that we should exit immediately when we get
either the DEVLINK_CMD_FLASH_UPDATE_END or an exit code from the child
process. However, at a minimum it makes no sense to ever process
DEVLINK_CMD_FLASH_UPDATE_END as if it were a DEVLINK_CMD_FLASH_UPDATE_STATUS.

This is easy to test as it is triggered by the selftests for the
netdevsim driver, which has a test case for both with and without status
notifications.

Fixes: 9b13cddfe268 ("devlink: implement flash status monitoring")
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
 devlink/devlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index b294fcd8f053..9d3acc188396 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -3700,7 +3700,7 @@ static int cmd_dev_flash_status_cb(const struct nlmsghdr *nlh, void *data)
 	    strcmp(dev_name, opts->dev_name))
 		return MNL_CB_ERROR;
 
-	if (genl->cmd == DEVLINK_CMD_FLASH_UPDATE_END && ctx->not_first) {
+	if (genl->cmd == DEVLINK_CMD_FLASH_UPDATE_END) {
 		pr_out("\n");
 		free(ctx->last_msg);
 		free(ctx->last_component);
-- 
2.31.1.331.gb0c09ab8796f

