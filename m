Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3997027B8E0
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 02:29:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726930AbgI2A3u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 20:29:50 -0400
Received: from mga17.intel.com ([192.55.52.151]:48272 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726421AbgI2A3u (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Sep 2020 20:29:50 -0400
IronPort-SDR: KTIxbfH6uNpk5p6tDCEnJThzOHMSP/Dya4byYzSCpXOHnFqMvBzfCdWBmEb7VXMwSjH+Bn10x1
 5kABuz7M8WPw==
X-IronPort-AV: E=McAfee;i="6000,8403,9758"; a="142099530"
X-IronPort-AV: E=Sophos;i="5.77,315,1596524400"; 
   d="scan'208";a="142099530"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 16:50:43 -0700
IronPort-SDR: Sg28NC//OtE6J+EO0fImHvJP2xejQTSVeK4IXt23C/m1J48n8+bCnJ6A/eb9Ze4M8cJzebjtPn
 ib0uKsOvrjcw==
X-IronPort-AV: E=Sophos;i="5.77,315,1596524400"; 
   d="scan'208";a="350915764"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.4])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 16:50:42 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kubakici@wp.pl>, snelson@pensando.io,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [RFC iproute2-next] devlink: display elapsed time during flash update
Date:   Mon, 28 Sep 2020 16:49:45 -0700
Message-Id: <20200928234945.3417905-1-jacob.e.keller@intel.com>
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

Provide a ticking counter of the time elapsed since the previous status
message in order to make it clear that the program is not simply stuck.

Do not display this message unless a few seconds have passed since the
last status update. Additionally, if the previous status notification
included a timeout, display this as part of the message. If we do not
receive an error or a new status without that time out, replace it with
the text "timeout reached".

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---

Sending this as an RFC because I doubt this is the best implementation. For
one, I get a weird display issue where the cursor doesn't always end up on
the end of line in my shell.. The % display works properly, so I'm not sure
what's wrong here.

Second, even though select should be timing out every 1/10th of a second for
screen updates, I don't seem to get that behavior in my test. It takes about
8 to 10 seconds for the first elapsed time message to be displayed, and it
updates really slowly. Is select just not that precise? I even tried using a
timeout of zero, but this means we refresh way too often and it looks bad. I
am not sure what is wrong here...

 devlink/devlink.c | 89 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 88 insertions(+), 1 deletion(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 0374175eda3d..7fb4b5ef1ebe 100644
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
+	struct timeval last_status_msg;
+	char timeout_msg[128];
+	uint64_t timeout;
 	char *last_msg;
 	char *last_component;
 	uint8_t not_first:1,
@@ -3083,6 +3087,14 @@ static int nullstrcmp(const char *str1, const char *str2)
 	return str1 ? 1 : -1;
 }
 
+static void cmd_dev_flash_clear_elapsed_time(struct cmd_dev_flash_status_ctx *ctx)
+{
+	int i;
+
+	for (i = 0; i < strlen(ctx->timeout_msg); i++)
+		pr_out_tty("\b");
+}
+
 static int cmd_dev_flash_status_cb(const struct nlmsghdr *nlh, void *data)
 {
 	struct cmd_dev_flash_status_ctx *ctx = data;
@@ -3116,6 +3128,11 @@ static int cmd_dev_flash_status_cb(const struct nlmsghdr *nlh, void *data)
 		return MNL_CB_STOP;
 	}
 
+	cmd_dev_flash_clear_elapsed_time(ctx);
+	gettimeofday(&ctx->last_status_msg, NULL);
+	ctx->timeout_msg[0] = '\0';
+	ctx->timeout = 0;
+
 	if (tb[DEVLINK_ATTR_FLASH_UPDATE_STATUS_MSG])
 		msg = mnl_attr_get_str(tb[DEVLINK_ATTR_FLASH_UPDATE_STATUS_MSG]);
 	if (tb[DEVLINK_ATTR_FLASH_UPDATE_COMPONENT])
@@ -3124,6 +3141,8 @@ static int cmd_dev_flash_status_cb(const struct nlmsghdr *nlh, void *data)
 		done = mnl_attr_get_u64(tb[DEVLINK_ATTR_FLASH_UPDATE_STATUS_DONE]);
 	if (tb[DEVLINK_ATTR_FLASH_UPDATE_STATUS_TOTAL])
 		total = mnl_attr_get_u64(tb[DEVLINK_ATTR_FLASH_UPDATE_STATUS_TOTAL]);
+	if (tb[DEVLINK_ATTR_FLASH_UPDATE_STATUS_TIMEOUT])
+		ctx->timeout = mnl_attr_get_u64(tb[DEVLINK_ATTR_FLASH_UPDATE_STATUS_TIMEOUT]);
 
 	if (!nullstrcmp(msg, ctx->last_msg) &&
 	    !nullstrcmp(component, ctx->last_component) &&
@@ -3155,11 +3174,66 @@ static int cmd_dev_flash_status_cb(const struct nlmsghdr *nlh, void *data)
 	return MNL_CB_STOP;
 }
 
+static void cmd_dev_flash_time_elapsed(struct cmd_dev_flash_status_ctx *ctx)
+{
+	struct timeval now, res;
+
+	gettimeofday(&now, NULL);
+	timersub(&now, &ctx->last_status_msg, &res);
+
+	/* Don't start displaying a timeout message until we've elapsed a few
+	 * seconds...
+	 */
+	if (res.tv_sec > 3) {
+		uint elapsed_m, elapsed_s;
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
+		if (!ctx->timeout) {
+			snprintf(ctx->timeout_msg, sizeof(ctx->timeout_msg),
+				 " ( %um %us )", elapsed_m, elapsed_s);
+		} else if (res.tv_sec <= ctx->timeout) {
+			uint timeout_m, timeout_s;
+
+			timeout_m = ctx->timeout / 60;
+			timeout_s = ctx->timeout % 60;
+
+			snprintf(ctx->timeout_msg, sizeof(ctx->timeout_msg),
+				 " ( %um %us : %um %us )",
+				 elapsed_m, elapsed_s, timeout_m, timeout_s);
+		} else {
+			snprintf(ctx->timeout_msg, sizeof(ctx->timeout_msg),
+				 " ( %um %us : timeout reached )", elapsed_m, elapsed_s);
+		}
+
+		pr_out_tty("%s", ctx->timeout_msg);
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
@@ -3174,7 +3248,14 @@ static int cmd_dev_flash_fds_process(struct cmd_dev_flash_status_ctx *ctx,
 	if (nlfd >= fdmax)
 		fdmax = nlfd + 1;
 
-	while (select(fdmax, &fds[0], &fds[1], &fds[2], NULL) < 0) {
+	/* select only for a short while (1/20th of a second) in order to
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
@@ -3196,6 +3277,7 @@ static int cmd_dev_flash_fds_process(struct cmd_dev_flash_status_ctx *ctx,
 			return err2;
 		ctx->flash_done = 1;
 	}
+	cmd_dev_flash_time_elapsed(ctx);
 	return 0;
 }
 
@@ -3256,6 +3338,11 @@ static int cmd_dev_flash(struct dl *dl)
 	}
 	close(pipe_w);
 
+	/* initialize starting time to allow comparison for when to begin
+	 * displaying a time elapsed message.
+	 */
+	gettimeofday(&ctx.last_status_msg, NULL);
+
 	do {
 		err = cmd_dev_flash_fds_process(&ctx, nlg_ntf, pipe_r);
 		if (err)

base-commit: b8663da04939dd5de223ca0de23e466ce0a372f7
-- 
2.28.0.497.g54e85e7af1ac

