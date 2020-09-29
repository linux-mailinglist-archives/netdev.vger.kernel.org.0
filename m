Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0DF727DB3E
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 23:58:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728291AbgI2V6A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 17:58:00 -0400
Received: from mga07.intel.com ([134.134.136.100]:54494 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728074AbgI2V57 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 17:57:59 -0400
IronPort-SDR: czwefkBbGVDRQulgN+CvIK8NR57JSXHOVrL1wIpeAadxKtIMgL8TL9sBoV4EW+eDNUt6c6W0k8
 5XeFNO6TpD5Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9759"; a="226448344"
X-IronPort-AV: E=Sophos;i="5.77,320,1596524400"; 
   d="scan'208";a="226448344"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2020 14:57:58 -0700
IronPort-SDR: d/lGvOvK941z2yihPbpjuw5QU4M0pm0qJYc/v438bunXMYnAjB4e7/NKsMKARHdSRqi23xpL9g
 N1niLL2DQa+Q==
X-IronPort-AV: E=Sophos;i="5.77,320,1596524400"; 
   d="scan'208";a="324822023"
Received: from jekeller-desk.amr.corp.intel.com ([10.166.241.4])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2020 14:57:58 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kubakici@wp.pl>, snelson@pensando.io,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [iproute2-next v1] devlink: display elapsed time during flash update
Date:   Tue, 29 Sep 2020 14:56:51 -0700
Message-Id: <20200929215651.3538844-1-jacob.e.keller@intel.com>
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

This is a respin of an RFC at [1] based on feedback. This version works as I
would expect, 

Changes since RFC
* Add fflush, fixing jittery output
* Since we're only comparing the seconds value, use "> 2" instead of "> 3"
  so that we begin displaying the elapsed time at 3 seconds rather than 4
  seconds.
* store only the string length instead of the full message in the context
* Rename some variables for clarity
* If we have a timeout, always display the elapsed time, instead of waiting
  for a few seconds.
* Fix a typo in a comment referring to 1/20th when the code used 1/10th of a
  second timeout.

 devlink/devlink.c | 95 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 94 insertions(+), 1 deletion(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 0374175eda3d..7f3bd45c9a6e 100644
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
@@ -3083,6 +3087,14 @@ static int nullstrcmp(const char *str1, const char *str2)
 	return str1 ? 1 : -1;
 }
 
+static void cmd_dev_flash_clear_elapsed_time(struct cmd_dev_flash_status_ctx *ctx)
+{
+	int i;
+
+	for (i = 0; i < ctx->elapsed_time_msg_len; i++)
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
+	gettimeofday(&ctx->time_of_last_status, NULL);
+	ctx->status_msg_timeout = 0;
+	ctx->elapsed_time_msg_len = 0;
+
 	if (tb[DEVLINK_ATTR_FLASH_UPDATE_STATUS_MSG])
 		msg = mnl_attr_get_str(tb[DEVLINK_ATTR_FLASH_UPDATE_STATUS_MSG]);
 	if (tb[DEVLINK_ATTR_FLASH_UPDATE_COMPONENT])
@@ -3124,6 +3141,8 @@ static int cmd_dev_flash_status_cb(const struct nlmsghdr *nlh, void *data)
 		done = mnl_attr_get_u64(tb[DEVLINK_ATTR_FLASH_UPDATE_STATUS_DONE]);
 	if (tb[DEVLINK_ATTR_FLASH_UPDATE_STATUS_TOTAL])
 		total = mnl_attr_get_u64(tb[DEVLINK_ATTR_FLASH_UPDATE_STATUS_TOTAL]);
+	if (tb[DEVLINK_ATTR_FLASH_UPDATE_STATUS_TIMEOUT])
+		ctx->status_msg_timeout = mnl_attr_get_u64(tb[DEVLINK_ATTR_FLASH_UPDATE_STATUS_TIMEOUT]);
 
 	if (!nullstrcmp(msg, ctx->last_msg) &&
 	    !nullstrcmp(component, ctx->last_component) &&
@@ -3155,11 +3174,72 @@ static int cmd_dev_flash_status_cb(const struct nlmsghdr *nlh, void *data)
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
@@ -3174,7 +3254,14 @@ static int cmd_dev_flash_fds_process(struct cmd_dev_flash_status_ctx *ctx,
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
@@ -3196,6 +3283,7 @@ static int cmd_dev_flash_fds_process(struct cmd_dev_flash_status_ctx *ctx,
 			return err2;
 		ctx->flash_done = 1;
 	}
+	cmd_dev_flash_time_elapsed(ctx);
 	return 0;
 }
 
@@ -3256,6 +3344,11 @@ static int cmd_dev_flash(struct dl *dl)
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

base-commit: d2be31d9b671ec0b3e32f56f9c913e249ed048bd
-- 
2.28.0.497.g54e85e7af1ac

