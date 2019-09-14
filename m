Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5699B2A36
	for <lists+netdev@lfdr.de>; Sat, 14 Sep 2019 08:58:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726811AbfING6B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Sep 2019 02:58:01 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46669 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726738AbfING6B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Sep 2019 02:58:01 -0400
Received: by mail-wr1-f66.google.com with SMTP id o18so2820340wrv.13
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 23:58:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5Ljn3fg1n4bqgy98/FYlaAjhq0nzbilFlGsPQjPh+p0=;
        b=L/YNptlrTpLSy5NwAs1y1JQsWX0+aUCQhvsavnLwghAAEMSZbwGDMj+1PjO1MOrEnW
         qp5OoJK3sWaQyHD9e7yboRoxg035tkW6xBdSS2jHyBGIAbm+WOZ99aWzlTVM0aI36UE0
         cyJi7i72zXvN3krPEhBDDG3GAv3oXl5D98kO3hogLLAVsV0I1oCpwMOidqw8ktrwBc3g
         TivUEvzh3EpTVFLY7+U5cK9Bxhdyg0yHYEkQiVWjtUhP87/OAU9cq1/Ox0i0zm5DFrM5
         sAmtpR1xPFRwrgtaNl9P7G8PZPKAaUafgJ97/jEELj7oeUblS3PW1ldilbG6bn+9k2Yh
         Z+6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5Ljn3fg1n4bqgy98/FYlaAjhq0nzbilFlGsPQjPh+p0=;
        b=Ypa163BZqZRJMZDy8P/oINXKHJ/tdHayBJV4gtFHbAPH78QBPKIpnX8sZISxgoCv8i
         pFWXrBmJYtdxxYcuLIvp0U5URT51UWxDFaCFd+2gsAXG7Qm1HVLHbrmRxyV4DBTVvi2z
         1rXafcGSkaNwwVPeQtXY5TlqB9PUTZBCcPjEsBcQPO7e4c0cIB5mUGtvvRg3BFep0Wvg
         HdUhIKbGjyC4TJuWUZJpVu5zqnaTwvSQtTEi6fFAgo1yz3wYtAKegl7/u58Gn64i7QA3
         muzG9nhijxGVV4vPK6pSAPWODJVpJ3HCiH+Htd3dPPPuxe+ohiPJ8AWoZ/gb5fEFXDww
         1a0g==
X-Gm-Message-State: APjAAAU6hvxnZIB29SwdKFLxu2hZ4c6qwVfjmD/QSu1Sa+mFw9zy721O
        cf/l2E+jH2nqMzyPpUkim34b2eXFoJU=
X-Google-Smtp-Source: APXvYqx5NDD0PszFhfhZUSuKHXmKmo0RyiuCJXYr9WUNEHKSXjv+tzv5WkQUt3M5KLQVp2RsjKAnfA==
X-Received: by 2002:a5d:6288:: with SMTP id k8mr41560302wru.209.1568444279291;
        Fri, 13 Sep 2019 23:57:59 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id f18sm6990236wrv.38.2019.09.13.23.57.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Sep 2019 23:57:59 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, idosch@mellanox.com, dsahern@gmail.com,
        jakub.kicinski@netronome.com, tariqt@mellanox.com,
        saeedm@mellanox.com, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        shuah@kernel.org, mlxsw@mellanox.com
Subject: [patch iproute2-next 2/2] devlink: extend reload command to add support for network namespace change
Date:   Sat, 14 Sep 2019 08:57:57 +0200
Message-Id: <20190914065757.27295-2-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190914064608.26799-1-jiri@resnulli.us>
References: <20190914064608.26799-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
v3->v4:
- rebased on top of trap patches
- moved netns change to reload command instead of set
---
 devlink/devlink.c            | 31 +++++++++++++++++++++++++++----
 include/uapi/linux/devlink.h |  4 ++++
 man/man8/devlink-dev.8       | 12 ++++++++++++
 3 files changed, 43 insertions(+), 4 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 8020d76dd7f7..6a28a7aa58a4 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -237,6 +237,7 @@ static void ifname_map_free(struct ifname_map *ifname_map)
 #define DL_OPT_TRAP_NAME		BIT(29)
 #define DL_OPT_TRAP_ACTION		BIT(30)
 #define DL_OPT_TRAP_GROUP_NAME		BIT(31)
+#define DL_OPT_NETNS	BIT(32)
 
 struct dl_opts {
 	uint64_t present; /* flags of present items */
@@ -276,6 +277,8 @@ struct dl_opts {
 	const char *trap_name;
 	const char *trap_group_name;
 	enum devlink_trap_action trap_action;
+	bool netns_is_pid;
+	uint32_t netns;
 };
 
 struct dl {
@@ -1412,6 +1415,22 @@ static int dl_argv_parse(struct dl *dl, uint64_t o_required,
 			if (err)
 				return err;
 			o_found |= DL_OPT_TRAP_ACTION;
+		} else if (dl_argv_match(dl, "netns") &&
+			(o_all & DL_OPT_NETNS)) {
+			const char *netns_str;
+
+			dl_arg_inc(dl);
+			err = dl_argv_str(dl, &netns_str);
+			if (err)
+				return err;
+			opts->netns = netns_get_fd(netns_str);
+			if (opts->netns < 0) {
+				err = dl_argv_uint32_t(dl, &opts->netns);
+				if (err)
+					return err;
+				opts->netns_is_pid = true;
+			}
+			o_found |= DL_OPT_NETNS;
 		} else {
 			pr_err("Unknown option \"%s\"\n", dl_argv(dl));
 			return -EINVAL;
@@ -1534,7 +1553,11 @@ static void dl_opts_put(struct nlmsghdr *nlh, struct dl *dl)
 	if (opts->present & DL_OPT_TRAP_ACTION)
 		mnl_attr_put_u8(nlh, DEVLINK_ATTR_TRAP_ACTION,
 				opts->trap_action);
-
+	if (opts->present & DL_OPT_NETNS)
+		mnl_attr_put_u32(nlh,
+				 opts->netns_is_pid ? DEVLINK_ATTR_NETNS_PID :
+						      DEVLINK_ATTR_NETNS_FD,
+				 opts->netns);
 }
 
 static int dl_argv_parse_put(struct nlmsghdr *nlh, struct dl *dl,
@@ -1595,7 +1618,7 @@ static void cmd_dev_help(void)
 	pr_err("       devlink dev eswitch show DEV\n");
 	pr_err("       devlink dev param set DEV name PARAMETER value VALUE cmode { permanent | driverinit | runtime }\n");
 	pr_err("       devlink dev param show [DEV name PARAMETER]\n");
-	pr_err("       devlink dev reload DEV\n");
+	pr_err("       devlink dev reload DEV [ netns { PID | NAME | ID } ]\n");
 	pr_err("       devlink dev info [ DEV ]\n");
 	pr_err("       devlink dev flash DEV file PATH [ component NAME ]\n");
 }
@@ -2671,7 +2694,7 @@ static int cmd_dev_show(struct dl *dl)
 
 static void cmd_dev_reload_help(void)
 {
-	pr_err("Usage: devlink dev reload [ DEV ]\n");
+	pr_err("Usage: devlink dev reload DEV [ netns { PID | NAME | ID } ]\n");
 }
 
 static int cmd_dev_reload(struct dl *dl)
@@ -2687,7 +2710,7 @@ static int cmd_dev_reload(struct dl *dl)
 	nlh = mnlg_msg_prepare(dl->nlg, DEVLINK_CMD_RELOAD,
 			       NLM_F_REQUEST | NLM_F_ACK);
 
-	err = dl_argv_parse_put(nlh, dl, DL_OPT_HANDLE, 0);
+	err = dl_argv_parse_put(nlh, dl, DL_OPT_HANDLE, DL_OPT_NETNS);
 	if (err)
 		return err;
 
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index d63cf9723f57..f2608cfc9706 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -412,6 +412,10 @@ enum devlink_attr {
 
 	DEVLINK_ATTR_RELOAD_FAILED,			/* u8 0 or 1 */
 
+	DEVLINK_ATTR_NETNS_FD,			/* u32 */
+	DEVLINK_ATTR_NETNS_PID,			/* u32 */
+	DEVLINK_ATTR_NETNS_ID,			/* u32 */
+
 	/* add new attributes above here, update the policy in devlink.c */
 
 	__DEVLINK_ATTR_MAX,
diff --git a/man/man8/devlink-dev.8 b/man/man8/devlink-dev.8
index 1804463b2321..0e1a5523fa7b 100644
--- a/man/man8/devlink-dev.8
+++ b/man/man8/devlink-dev.8
@@ -25,6 +25,13 @@ devlink-dev \- devlink device configuration
 .ti -8
 .B devlink dev help
 
+.ti -8
+.BR "devlink dev set"
+.IR DEV
+.RI "[ "
+.BI "netns { " PID " | " NAME " | " ID " }
+.RI "]"
+
 .ti -8
 .BR "devlink dev eswitch set"
 .IR DEV
@@ -92,6 +99,11 @@ Format is:
 .in +2
 BUS_NAME/BUS_ADDRESS
 
+.SS devlink dev set  - sets devlink device attributes
+
+.TP
+.BI "netns { " PID " | " NAME " | " ID " }
+
 .SS devlink dev eswitch show - display devlink device eswitch attributes
 .SS devlink dev eswitch set  - sets devlink device eswitch attributes
 
-- 
2.21.0

