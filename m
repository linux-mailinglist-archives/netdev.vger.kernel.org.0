Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82EBB27F618
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 01:41:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731858AbgI3XlX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 19:41:23 -0400
Received: from mga06.intel.com ([134.134.136.31]:11464 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731302AbgI3XlO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 19:41:14 -0400
IronPort-SDR: xBZnvIxetGbO5xwAG9J+kf4YLthM/Z/2gnhWbyZiFXUO8Y//9UJHJneshNlOfHy1zwSFZoRdlv
 xqmQnRbRQ9Gg==
X-IronPort-AV: E=McAfee;i="6000,8403,9760"; a="224180240"
X-IronPort-AV: E=Sophos;i="5.77,322,1596524400"; 
   d="scan'208";a="224180240"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2020 16:41:11 -0700
IronPort-SDR: sEfyVpP3So6aqtU2pE9fD6xYlyDtuJcYdJaEaQc+ECmlW+3ZqaD6QPS2ZNrdOspWpurCqvXwUX
 agdgaV2qsFgA==
X-IronPort-AV: E=Sophos;i="5.77,322,1596524400"; 
   d="scan'208";a="385310992"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.4])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2020 16:41:10 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Shannon Nelson <snelson@pensando.io>
Cc:     Jacob Keller <jacob.e.keller@intel.com>
Subject: [iproute2-next v2 1/1] devlink: display elapsed time during flash update
Date:   Wed, 30 Sep 2020 16:40:12 -0700
Message-Id: <20200930234012.137020-1-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.28.0.497.g54e85e7af1ac
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For some devices, updating the flash can take significant time during
operations where no status can meaningfully be reported. This can be
somewhat confusing to a user who sees devlink appear to hang on the
terminal waiting for the device to update.

Recent changes to the kernel interface allow such long running commands
to provide a timeout value indicating some upper bound on how long the
relevant action could take.

Provide a ticking counter of the time elapsed since the previous status
message in order to make it clear that the program is not simply stuck.

Display this message whenever the status message from the kernel
indicates a timeout value. Additionally also display the message if
we've received no status for more than couple of seconds. If we elapse
more than the timeout provided by the status message, replace the
timeout display with "timeout reached".

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---

Changes since v1
* update last status time only when the message changes, allowing an elapsed
  time to represent the full operation of downloading or programming the
  image.
* Use "\b \b" to erase the elapsed time message properly even when we will
  not be printing new text over it. This ensures that the messages disappear
  as intended when we move to a new line.

Because this is a bit confusing to understand the behavior when looking
purely at text logs, I captured video of an update with this patch set and
have posted it at [1] in case reviewers would like to actually see behavior
in action

[1] https://youtu.be/aeVuQzK0Lo8

 devlink/devlink.c | 99 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 98 insertions(+), 1 deletion(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 0374175eda3d..aae5055e2c71 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -33,6 +33,7 @@
 #include <sys/select.h>
 #include <sys/socket.h>
 #include <sys/types.h>
+#include <sys/time.h>
 #include <rt_names.h>
 
 #include "version.h"
@@ -3066,6 +3067,9 @@ static int cmd_dev_info(struct dl *dl)
 
 struct cmd_dev_flash_status_ctx {
 	struct dl *dl;
+	struct timeval time_of_last_status;
+	uint64_t status_msg_timeout;
+	size_t elapsed_time_msg_len;
 	char *last_msg;
 	char *last_component;
 	uint8_t not_first:1,
@@ -3083,6 +3087,16 @@ static int nullstrcmp(const char *str1, const char *str2)
 	return str1 ? 1 : -1;
 }
 
+static void cmd_dev_flash_clear_elapsed_time(struct cmd_dev_flash_status_ctx *ctx)
+{
+	int i;
+
+	for (i = 0; i < ctx->elapsed_time_msg_len; i++)
+		pr_out_tty("\b \b");
+
+	ctx->elapsed_time_msg_len = 0;
+}
+
 static int cmd_dev_flash_status_cb(const struct nlmsghdr *nlh, void *data)
 {
 	struct cmd_dev_flash_status_ctx *ctx = data;
@@ -3095,6 +3109,8 @@ static int cmd_dev_flash_status_cb(const struct nlmsghdr *nlh, void *data)
 	const char *bus_name;
 	const char *dev_name;
 
+	cmd_dev_flash_clear_elapsed_time(ctx);
+
 	if (genl->cmd != DEVLINK_CMD_FLASH_UPDATE_STATUS &&
 	    genl->cmd != DEVLINK_CMD_FLASH_UPDATE_END)
 		return MNL_CB_STOP;
@@ -3124,12 +3140,19 @@ static int cmd_dev_flash_status_cb(const struct nlmsghdr *nlh, void *data)
 		done = mnl_attr_get_u64(tb[DEVLINK_ATTR_FLASH_UPDATE_STATUS_DONE]);
 	if (tb[DEVLINK_ATTR_FLASH_UPDATE_STATUS_TOTAL])
 		total = mnl_attr_get_u64(tb[DEVLINK_ATTR_FLASH_UPDATE_STATUS_TOTAL]);
+	if (tb[DEVLINK_ATTR_FLASH_UPDATE_STATUS_TIMEOUT])
+		ctx->status_msg_timeout = mnl_attr_get_u64(tb[DEVLINK_ATTR_FLASH_UPDATE_STATUS_TIMEOUT]);
+	else
+		ctx->status_msg_timeout = 0;
 
 	if (!nullstrcmp(msg, ctx->last_msg) &&
 	    !nullstrcmp(component, ctx->last_component) &&
 	    ctx->last_pc && ctx->not_first) {
 		pr_out_tty("\b\b\b\b\b"); /* clean percentage */
 	} else {
+		/* only update the last status timestamp if the message changed */
+		gettimeofday(&ctx->time_of_last_status, NULL);
+
 		if (ctx->not_first)
 			pr_out("\n");
 		if (component) {
@@ -3155,11 +3178,72 @@ static int cmd_dev_flash_status_cb(const struct nlmsghdr *nlh, void *data)
 	return MNL_CB_STOP;
 }
 
+static void cmd_dev_flash_time_elapsed(struct cmd_dev_flash_status_ctx *ctx)
+{
+	struct timeval now, res;
+
+	gettimeofday(&now, NULL);
+	timersub(&now, &ctx->time_of_last_status, &res);
+
+	/* Only begin displaying an elapsed time message if we've waited a few
+	 * seconds with no response, or the status message included a timeout
+	 * value.
+	 */
+	if (res.tv_sec > 2 || ctx->status_msg_timeout) {
+		uint64_t elapsed_m, elapsed_s;
+		char msg[128];
+		size_t len;
+
+		/* clear the last elapsed time message, if we have one */
+		cmd_dev_flash_clear_elapsed_time(ctx);
+
+		elapsed_m = res.tv_sec / 60;
+		elapsed_s = res.tv_sec % 60;
+
+		/**
+		 * If we've elapsed a few seconds without receiving any status
+		 * notification from the device, we display a time elapsed
+		 * message. This has a few possible formats:
+		 *
+		 * 1) just time elapsed, when no timeout was provided
+		 *    " ( Xm Ys )"
+		 * 2) time elapsed out of a timeout that came from the device
+		 *    driver via DEVLINK_CMD_FLASH_UPDATE_STATUS_TIMEOUT
+		 *    " ( Xm Ys : Am Ys)"
+		 * 3) time elapsed if we still receive no status after
+		 *    reaching the provided timeout.
+		 *    " ( Xm Ys : timeout reached )"
+		 */
+		if (!ctx->status_msg_timeout) {
+			len = snprintf(msg, sizeof(msg),
+				       " ( %lum %lus )", elapsed_m, elapsed_s);
+		} else if (res.tv_sec <= ctx->status_msg_timeout) {
+			uint64_t timeout_m, timeout_s;
+
+			timeout_m = ctx->status_msg_timeout / 60;
+			timeout_s = ctx->status_msg_timeout % 60;
+
+			len = snprintf(msg, sizeof(msg),
+				       " ( %lum %lus : %lum %lus )",
+				       elapsed_m, elapsed_s, timeout_m, timeout_s);
+		} else {
+			len = snprintf(msg, sizeof(msg),
+				       " ( %lum %lus : timeout reached )", elapsed_m, elapsed_s);
+		}
+
+		ctx->elapsed_time_msg_len = len;
+
+		pr_out_tty("%s", msg);
+		fflush(stdout);
+	}
+}
+
 static int cmd_dev_flash_fds_process(struct cmd_dev_flash_status_ctx *ctx,
 				     struct mnlg_socket *nlg_ntf,
 				     int pipe_r)
 {
 	int nlfd = mnlg_socket_get_fd(nlg_ntf);
+	struct timeval timeout;
 	fd_set fds[3];
 	int fdmax;
 	int i;
@@ -3174,7 +3258,14 @@ static int cmd_dev_flash_fds_process(struct cmd_dev_flash_status_ctx *ctx,
 	if (nlfd >= fdmax)
 		fdmax = nlfd + 1;
 
-	while (select(fdmax, &fds[0], &fds[1], &fds[2], NULL) < 0) {
+	/* select only for a short while (1/10th of a second) in order to
+	 * allow periodically updating the screen with an elapsed time
+	 * indicator.
+	 */
+	timeout.tv_sec = 0;
+	timeout.tv_usec = 100000;
+
+	while (select(fdmax, &fds[0], &fds[1], &fds[2], &timeout) < 0) {
 		if (errno == EINTR)
 			continue;
 		pr_err("select() failed\n");
@@ -3196,6 +3287,7 @@ static int cmd_dev_flash_fds_process(struct cmd_dev_flash_status_ctx *ctx,
 			return err2;
 		ctx->flash_done = 1;
 	}
+	cmd_dev_flash_time_elapsed(ctx);
 	return 0;
 }
 
@@ -3256,6 +3348,11 @@ static int cmd_dev_flash(struct dl *dl)
 	}
 	close(pipe_w);
 
+	/* initialize starting time to allow comparison for when to begin
+	 * displaying a time elapsed message.
+	 */
+	gettimeofday(&ctx.time_of_last_status, NULL);
+
 	do {
 		err = cmd_dev_flash_fds_process(&ctx, nlg_ntf, pipe_r);
 		if (err)
-- 
2.28.0.497.g54e85e7af1ac

