Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C24447A383
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 11:00:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731242AbfG3I75 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 04:59:57 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38607 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730702AbfG3I74 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 04:59:56 -0400
Received: by mail-wm1-f67.google.com with SMTP id s15so34519191wmj.3
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 01:59:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=V7x08oMX/uVA8w+3v+3F/4+4yYHzFnDaLpKoEnlvRO8=;
        b=sHjqi2lNhRuRrm7xMwOSvoQTqixOuq3esEGU37s5NizCVd4a7TTVDbeSV/U4RXn9Op
         4giSaT4AnM6Ij7lYSogsVFoKJ1aVvGrQbncqawedUiHXIVCwXAKsJ9bEGRgBAshP7H8l
         YWxMXp+vp2Dq7ZyJiU8p8Me5a1IXOkwZI+N2UQArSidv0GDPz56ZVCC/4RT0e1/LkHfv
         CfagIJpGEhKIVXnOsDDDDolgy6zLNOlBcQmnBjezse+of0+dpe2cjMivFruKw+4lMM5Y
         LOino+OZn+6P6i9+leeQM1e7Kgazh77t7ZWince6GFMWOCGAJZWWOcNK8i9SDS/3kiC/
         3uow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=V7x08oMX/uVA8w+3v+3F/4+4yYHzFnDaLpKoEnlvRO8=;
        b=JAVeSXMINnMnZLZjxv4SNoMusawjtk4UArrV/eW15EnhH8SrLvqJmAOWPjvyYVUSbd
         0+LI45z4oImhr9KyNqy+yV2k/N2k2bypS+08VrTW12hHOsxIQA3sUsHa4pJg5rwOZOJH
         HPOHPl3EKScIM3yH5LRSppU1M5mWbLBFfiKnMTZZyZ3ZowA5QhRRuJ9I5dGoDibz9ii2
         s316P3S82mUqjY1T+UDQLiQdSJYiAkm6gbIjfeQs5nPAx3slhXxkYYa6/Q3kX3eUlzUb
         KfJ7KlxrOAZWtUK5CSoZd9lHVvR4sbcwaDEhkB0kYrigjf3T78DUMS3sLfhKbbkMCdJB
         HfBQ==
X-Gm-Message-State: APjAAAXmVqezZLZKJKybZPd1XziX4tNnDj08Ci4dWuacmUvCqAeT4zMg
        nF+56S8gUk9SqoetXFbKVaXT6hN3
X-Google-Smtp-Source: APXvYqwyXF4H6zoFFTzMQTGWYsoK0sSUMN8ZlBJbaE8tVyVRiCumuLp5+fGqI1gr1w4PMd6h3SqaOQ==
X-Received: by 2002:a1c:720e:: with SMTP id n14mr23325585wmc.53.1564477193570;
        Tue, 30 Jul 2019 01:59:53 -0700 (PDT)
Received: from localhost (mail.chocen-mesto.cz. [85.163.43.2])
        by smtp.gmail.com with ESMTPSA id n1sm48110684wrx.39.2019.07.30.01.59.53
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 30 Jul 2019 01:59:53 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        sthemmin@microsoft.com, dsahern@gmail.com, mlxsw@mellanox.com
Subject: [patch iproute2-next v2 2/2] devlink: add support for network namespace change
Date:   Tue, 30 Jul 2019 10:59:51 +0200
Message-Id: <20190730085951.31738-2-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190730085734.31504-1-jiri@resnulli.us>
References: <20190730085734.31504-1-jiri@resnulli.us>
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
index 9242cc05ad0c..a39bd8771d8b 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -235,6 +235,7 @@ static void ifname_map_free(struct ifname_map *ifname_map)
 #define DL_OPT_HEALTH_REPORTER_NAME	BIT(27)
 #define DL_OPT_HEALTH_REPORTER_GRACEFUL_PERIOD	BIT(27)
 #define DL_OPT_HEALTH_REPORTER_AUTO_RECOVER	BIT(28)
+#define DL_OPT_NETNS	BIT(29)
 
 struct dl_opts {
 	uint32_t present; /* flags of present items */
@@ -271,6 +272,8 @@ struct dl_opts {
 	const char *reporter_name;
 	uint64_t reporter_graceful_period;
 	bool reporter_auto_recover;
+	bool netns_is_pid;
+	uint32_t netns;
 };
 
 struct dl {
@@ -1331,6 +1334,22 @@ static int dl_argv_parse(struct dl *dl, uint32_t o_required,
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
@@ -1444,7 +1463,11 @@ static void dl_opts_put(struct nlmsghdr *nlh, struct dl *dl)
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
@@ -1499,6 +1522,7 @@ static bool dl_dump_filter(struct dl *dl, struct nlattr **tb)
 static void cmd_dev_help(void)
 {
 	pr_err("Usage: devlink dev show [ DEV ]\n");
+	pr_err("       devlink dev set DEV netns { PID | NAME | ID }\n");
 	pr_err("       devlink dev eswitch set DEV [ mode { legacy | switchdev } ]\n");
 	pr_err("                               [ inline-mode { none | link | network | transport } ]\n");
 	pr_err("                               [ encap { disable | enable } ]\n");
@@ -2551,6 +2575,31 @@ static int cmd_dev_show(struct dl *dl)
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
@@ -2747,6 +2796,9 @@ static int cmd_dev(struct dl *dl)
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

