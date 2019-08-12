Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E78198A018
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 15:51:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727319AbfHLNvs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 09:51:48 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:39427 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727103AbfHLNvs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 09:51:48 -0400
Received: by mail-wm1-f67.google.com with SMTP id u25so11830716wmc.4
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 06:51:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=b8YSxGke5gqlfkES052QWqaNTbmo2Dz5kMHy3TQ4XqQ=;
        b=KZyz3vgG5RabxYFh7YEnTGGsSIFfrA2oU+X9EwOcXiN4D7Q9jki24yXEL8j5G70NnN
         o42TBHRzlmEpCabBnKkR5ByLLgjecpUxXj8q3zhwfp6q0H2fyvvA0qeoryftvgIa0vBH
         RQKQANus1536wo3vQFK1K3CIUWtNDmLEOZ9Cqy29SWJHP0FO+K8zhqib4o/SrsaVhpWr
         LdJqAPCGuoULad9ikl7NCr5oZRZLCHIVz/qfzzBtAwuQaEfpkbKnQaqYEy7x7rZP5TU3
         aULrC+c3PPKIpR9J6qKcuDh+Csdsj+bcCtSd+qtu98JgYx4pBoZCnP4PO1Udd5Q7QzDd
         4R6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=b8YSxGke5gqlfkES052QWqaNTbmo2Dz5kMHy3TQ4XqQ=;
        b=CpZgwt3Zj8Z0Ua93OTU9LU2a+7NtVzaxcSTsZxShGJC3+x80+Igln8HUDUNHMBZuZl
         ic2VD3NWcjlNWTwajyubxYMZyUMOPYrTrGmq3TQ9r22Hq9AJrCFqCjI4MSuDUuKV41Gk
         ed0D6aWa9bfYP0gGP+xtWf3mIeioLietrHtVvg5A/eptgxZrSwNJxZWsYAwtBwUMgn8S
         9qf8MC/eHueELcRC/+648u5wOXHaUfcAyX1+vKWmTeyBHLjve9AU/7KNpVagclPjV473
         +QQTxU2L0f3U2G8pDO2LAszi8J1RYhj9QUtAXoRIaRjN0hqfI+Dnyb5nh5xntNowzsZe
         Mmyg==
X-Gm-Message-State: APjAAAVXNl5iDCjnFU9KNNhgZwMANgy+bfa+5irrAlPygl36v6aTWbKz
        xI6vANZ9kMUekuH/H0OX5slSL69YEbM=
X-Google-Smtp-Source: APXvYqynIW30tpN7m6/hf1PMY6FzEQdBtoCzs4fQwWEFSOpIo2JhSKp02Tk59a5tknKtJE3U90LCgg==
X-Received: by 2002:a05:600c:28c:: with SMTP id 12mr9182138wmk.157.1565617905784;
        Mon, 12 Aug 2019 06:51:45 -0700 (PDT)
Received: from localhost (ip-78-45-163-186.net.upcbroadband.cz. [78.45.163.186])
        by smtp.gmail.com with ESMTPSA id o20sm263860347wrh.8.2019.08.12.06.51.45
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 12 Aug 2019 06:51:45 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        stephen@networkplumber.org, dsahern@gmail.com, mlxsw@mellanox.com
Subject: [patch iproute2-next v3 2/2] devlink: add support for network namespace change
Date:   Mon, 12 Aug 2019 15:51:43 +0200
Message-Id: <20190812135143.31264-2-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190812134751.30838-1-jiri@resnulli.us>
References: <20190812134751.30838-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 devlink/devlink.c            | 54 +++++++++++++++++++++++++++++++++++-
 include/uapi/linux/devlink.h |  4 +++
 man/man8/devlink-dev.8       | 12 ++++++++
 3 files changed, 69 insertions(+), 1 deletion(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 6bda25e92238..42aebb38e67c 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -234,6 +234,7 @@ static void ifname_map_free(struct ifname_map *ifname_map)
 #define DL_OPT_HEALTH_REPORTER_NAME	BIT(27)
 #define DL_OPT_HEALTH_REPORTER_GRACEFUL_PERIOD	BIT(27)
 #define DL_OPT_HEALTH_REPORTER_AUTO_RECOVER	BIT(28)
+#define DL_OPT_NETNS	BIT(29)
 
 struct dl_opts {
 	uint32_t present; /* flags of present items */
@@ -270,6 +271,8 @@ struct dl_opts {
 	const char *reporter_name;
 	uint64_t reporter_graceful_period;
 	bool reporter_auto_recover;
+	bool netns_is_pid;
+	uint32_t netns;
 };
 
 struct dl {
@@ -1330,6 +1333,22 @@ static int dl_argv_parse(struct dl *dl, uint32_t o_required,
 			if (err)
 				return err;
 			o_found |= DL_OPT_HEALTH_REPORTER_AUTO_RECOVER;
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
@@ -1443,7 +1462,11 @@ static void dl_opts_put(struct nlmsghdr *nlh, struct dl *dl)
 	if (opts->present & DL_OPT_HEALTH_REPORTER_AUTO_RECOVER)
 		mnl_attr_put_u8(nlh, DEVLINK_ATTR_HEALTH_REPORTER_AUTO_RECOVER,
 				opts->reporter_auto_recover);
-
+	if (opts->present & DL_OPT_NETNS)
+		mnl_attr_put_u32(nlh,
+				 opts->netns_is_pid ? DEVLINK_ATTR_NETNS_PID :
+						      DEVLINK_ATTR_NETNS_FD,
+				 opts->netns);
 }
 
 static int dl_argv_parse_put(struct nlmsghdr *nlh, struct dl *dl,
@@ -1498,6 +1521,7 @@ static bool dl_dump_filter(struct dl *dl, struct nlattr **tb)
 static void cmd_dev_help(void)
 {
 	pr_err("Usage: devlink dev show [ DEV ]\n");
+	pr_err("       devlink dev set DEV netns { PID | NAME | ID }\n");
 	pr_err("       devlink dev eswitch set DEV [ mode { legacy | switchdev } ]\n");
 	pr_err("                               [ inline-mode { none | link | network | transport } ]\n");
 	pr_err("                               [ encap { disable | enable } ]\n");
@@ -2547,6 +2571,31 @@ static int cmd_dev_show(struct dl *dl)
 	return err;
 }
 
+static void cmd_dev_set_help(void)
+{
+	pr_err("Usage: devlink dev set DEV netns { PID | NAME | ID }\n");
+}
+
+static int cmd_dev_set(struct dl *dl)
+{
+	struct nlmsghdr *nlh;
+	int err;
+
+	if (dl_argv_match(dl, "help") || dl_no_arg(dl)) {
+		cmd_dev_set_help();
+		return 0;
+	}
+
+	nlh = mnlg_msg_prepare(dl->nlg, DEVLINK_CMD_SET,
+			       NLM_F_REQUEST | NLM_F_ACK);
+
+	err = dl_argv_parse_put(nlh, dl, DL_OPT_HANDLE, DL_OPT_NETNS);
+	if (err)
+		return err;
+
+	return _mnlg_socket_sndrcv(dl->nlg, nlh, NULL, NULL);
+}
+
 static void cmd_dev_reload_help(void)
 {
 	pr_err("Usage: devlink dev reload [ DEV ]\n");
@@ -2743,6 +2792,9 @@ static int cmd_dev(struct dl *dl)
 		   dl_argv_match(dl, "list") || dl_no_arg(dl)) {
 		dl_arg_inc(dl);
 		return cmd_dev_show(dl);
+	} else if (dl_argv_match(dl, "set")) {
+		dl_arg_inc(dl);
+		return cmd_dev_set(dl);
 	} else if (dl_argv_match(dl, "eswitch")) {
 		dl_arg_inc(dl);
 		return cmd_dev_eswitch(dl);
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index fc195cbd66f4..bc1869993e20 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -348,6 +348,10 @@ enum devlink_attr {
 	DEVLINK_ATTR_PORT_PCI_PF_NUMBER,	/* u16 */
 	DEVLINK_ATTR_PORT_PCI_VF_NUMBER,	/* u16 */
 
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

