Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94E3DC9B18
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 11:53:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729400AbfJCJvT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 05:51:19 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38566 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729103AbfJCJvT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 05:51:19 -0400
Received: by mail-wr1-f65.google.com with SMTP id w12so2241729wro.5
        for <netdev@vger.kernel.org>; Thu, 03 Oct 2019 02:51:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+sGSeiq6M+4Q0J4lpDwAsVEooTbxBn8OQfpxTpaQJJc=;
        b=lJFcbYyi5Q4KWHr9EfbW+sopQj6cv2zvRUAL1F0GjOjygBiog64A32OB9P4cgElSCF
         qy0XyuDC7yC88BcWQA1z3o9ulE0gbRALlgwGpdBLpUbobnsxAGUVAUre48N/UGNP/uXw
         mjnoHfHRrSfwGeoe6bSjHW5cHtAirSqxdAUquPCKwPGFdOSG5AOiEJYx3vzQWu7+cGJj
         XeuafdBLW6oywXFSFE3wZr43aG2NbmAhvPOunTDRaUY7t2y7ldNNlbqwwJ2CRx0NIend
         VfkmsBy7FC5Gj2GYFqpmeoMiCu5C98EInsSDCDPApLIPic6gknXXjK81jh3CuGLHO/ZV
         EXXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+sGSeiq6M+4Q0J4lpDwAsVEooTbxBn8OQfpxTpaQJJc=;
        b=d5+SThxz5+E/cTZ8EYIpLqedKvaIYmOaPkxER3UoaEIuGujd3zALtf4+TX24apRkc+
         vohPueV/S55vpc61ZqI/HzueIXoLSgRq55Wjxcys3nHybHTaDKUXQqZesfw/jiHY9+oi
         ZmJQnYto6Cn4doIEashmKdWDYSxbKAMLETunYRrqrRIA7WQopM9icw+FU9FSVxRvmbrA
         hJ9exx1UgEwHfvPQHl8Xc8Vscz/1G3F04uZ01SdscCXdNcaQEzzOqzlDp8Y+1x+5baz8
         4i5Fd+VYMPsA51YNUNHkO0jrliwm7fiH0VGvocv1RF/9gsnwV+9ltovtEO5kLX/T546V
         zGSg==
X-Gm-Message-State: APjAAAVBgx2R2HyOXw1flSZQQBkYaHOAI6cBwP2qExUfjtzDPQmHrzRo
        q8Qejk/dwH6RqNi8d1q7y5XMmCzPdUU=
X-Google-Smtp-Source: APXvYqx8uTVj3ldGFVoqwIjlrnpXR8JjfYBZb/Rrii0Tzr5IKJ3OMq7r+54CfC4INxsqNFZmNubJKg==
X-Received: by 2002:adf:db0f:: with SMTP id s15mr6463559wri.120.1570096277093;
        Thu, 03 Oct 2019 02:51:17 -0700 (PDT)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id h17sm3274410wme.6.2019.10.03.02.51.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Oct 2019 02:51:16 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, idosch@mellanox.com, dsahern@gmail.com,
        jakub.kicinski@netronome.com, tariqt@mellanox.com,
        saeedm@mellanox.com, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        shuah@kernel.org, mlxsw@mellanox.com
Subject: [patch iproute2-next v3 2/2] devlink: extend reload command to add support for network namespace change
Date:   Thu,  3 Oct 2019 11:51:15 +0200
Message-Id: <20191003095115.10098-2-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191003094940.9797-1-jiri@resnulli.us>
References: <20191003094940.9797-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Extend existing devlink reload command by adding option "netns" by which
user can instruct kernel to reload the devlink instance into specified
network namespace.

Example:

$ ip netns add testns1
$ devlink dev reload netdevsim/netdevsim10 netns testns1

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
v1->v2:
- fixed manpage
- added patch description
---
 devlink/devlink.c            | 31 +++++++++++++++++++++++++++----
 include/uapi/linux/devlink.h |  4 ++++
 man/man8/devlink-dev.8       |  7 +++++++
 3 files changed, 38 insertions(+), 4 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 852e2257cb64..a0cd6a47d26f 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -261,6 +261,7 @@ static void ifname_map_free(struct ifname_map *ifname_map)
 #define DL_OPT_TRAP_NAME		BIT(30)
 #define DL_OPT_TRAP_ACTION		BIT(31)
 #define DL_OPT_TRAP_GROUP_NAME		BIT(32)
+#define DL_OPT_NETNS	BIT(33)
 
 struct dl_opts {
 	uint64_t present; /* flags of present items */
@@ -300,6 +301,8 @@ struct dl_opts {
 	const char *trap_name;
 	const char *trap_group_name;
 	enum devlink_trap_action trap_action;
+	bool netns_is_pid;
+	uint32_t netns;
 };
 
 struct dl {
@@ -1440,6 +1443,22 @@ static int dl_argv_parse(struct dl *dl, uint64_t o_required,
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
@@ -1562,7 +1581,11 @@ static void dl_opts_put(struct nlmsghdr *nlh, struct dl *dl)
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
@@ -1623,7 +1646,7 @@ static void cmd_dev_help(void)
 	pr_err("       devlink dev eswitch show DEV\n");
 	pr_err("       devlink dev param set DEV name PARAMETER value VALUE cmode { permanent | driverinit | runtime }\n");
 	pr_err("       devlink dev param show [DEV name PARAMETER]\n");
-	pr_err("       devlink dev reload DEV\n");
+	pr_err("       devlink dev reload DEV [ netns { PID | NAME | ID } ]\n");
 	pr_err("       devlink dev info [ DEV ]\n");
 	pr_err("       devlink dev flash DEV file PATH [ component NAME ]\n");
 }
@@ -2724,7 +2747,7 @@ static int cmd_dev_show(struct dl *dl)
 
 static void cmd_dev_reload_help(void)
 {
-	pr_err("Usage: devlink dev reload [ DEV ]\n");
+	pr_err("Usage: devlink dev reload DEV [ netns { PID | NAME | ID } ]\n");
 }
 
 static int cmd_dev_reload(struct dl *dl)
@@ -2740,7 +2763,7 @@ static int cmd_dev_reload(struct dl *dl)
 	nlh = mnlg_msg_prepare(dl->nlg, DEVLINK_CMD_RELOAD,
 			       NLM_F_REQUEST | NLM_F_ACK);
 
-	err = dl_argv_parse_put(nlh, dl, DL_OPT_HANDLE, 0);
+	err = dl_argv_parse_put(nlh, dl, DL_OPT_HANDLE, DL_OPT_NETNS);
 	if (err)
 		return err;
 
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index 79e1405db67c..ab09b3b83675 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -421,6 +421,10 @@ enum devlink_attr {
 
 	DEVLINK_ATTR_RELOAD_FAILED,			/* u8 0 or 1 */
 
+	DEVLINK_ATTR_NETNS_FD,			/* u32 */
+	DEVLINK_ATTR_NETNS_PID,			/* u32 */
+	DEVLINK_ATTR_NETNS_ID,			/* u32 */
+
 	/* add new attributes above here, update the policy in devlink.c */
 
 	__DEVLINK_ATTR_MAX,
diff --git a/man/man8/devlink-dev.8 b/man/man8/devlink-dev.8
index 1021ee8d064c..2c6acbd3af69 100644
--- a/man/man8/devlink-dev.8
+++ b/man/man8/devlink-dev.8
@@ -62,6 +62,9 @@ devlink-dev \- devlink device configuration
 .ti -8
 .BR "devlink dev reload"
 .IR DEV
+.RI "[ "
+.BI "netns { " PID " | " NAME " | " ID " }
+.RI "]"
 
 .ti -8
 .BR "devlink dev info"
@@ -167,6 +170,10 @@ If this argument is omitted all parameters supported by devlink devices are list
 .I "DEV"
 - Specifies the devlink device to reload.
 
+.BR netns
+.BI { " PID " | " NAME " | " ID " }
+- Specifies the network namespace to reload into, either by pid, name or id.
+
 .SS devlink dev info - display device information.
 Display device information provided by the driver. This command can be used
 to query versions of the hardware components or device components which
-- 
2.21.0

