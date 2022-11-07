Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D8A061FA95
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 17:54:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232215AbiKGQyD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 11:54:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231965AbiKGQxz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 11:53:55 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DF831571D
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 08:53:54 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id p13-20020a05600c468d00b003cf8859ed1bso7545516wmo.1
        for <netdev@vger.kernel.org>; Mon, 07 Nov 2022 08:53:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+oa/Z4Sg26uQ+JGLzWeZKkluudrv80HkwhoihNy24ps=;
        b=y5j4DJHGU5luiSEZPi2ijaChq+R96/hRsDGU6a/C/pDffDM9lDBpKyoU1INx4cg33c
         WhmvJaD1ezumzse2da3TyYhENFig9ChOh38Q41nbTgS++0qXlmqhCMuxt97K64tgy7Bg
         e8faHeJdIcwID3DypwyIvi/lKkMGsgb8y/22Ghjgfw5dY2faz/eqzZjF3Ou4EUMsFBH3
         ocrzShofydWTWgHl/0iCa0tXchOqBBj5NaY3zztw1QhizK3e+AhqCwAnUG35TFkOY/8y
         O0xI3GC6V2Iz805q3rnPpciW4Gn/Bw4ZUPpuE6ic8yL6qyosmmA0bkVPYtBU8hVYnjbS
         cWcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+oa/Z4Sg26uQ+JGLzWeZKkluudrv80HkwhoihNy24ps=;
        b=CNUalXHF7QZUjw2lJbydwzz3Hfi0Zv0wLpsAq5Nc8wAsKTwl+dk/s2+6BbsvdvquYx
         hZNh4+QebB1ZZrrdKLV9S7ZLeT/GY1c27Gp7RuJXMkt7na4jl9C5cV1SPyCxiDjjam65
         JmgKpiYuLw1Pwm2e4ZHhTz7PB1tez/nbxr87v1hLZStCa5NGn3MubE7HiwCXaewOfCMv
         r2rcTFDL7UWaiuhooEZzc58XVqif/wbKIBQb/Di9Bqabz9slAV0lTcJrkCN6C0jKIZWv
         ISd01+sH+WrZrgeHPUn8Xh49g385FqV3hRBHz3W/74tw5OZtCFIu4b3h9rFdKIHvgtXo
         /+yw==
X-Gm-Message-State: ACrzQf2YdHmCvsTRUhKmwl1rBpKEZuCMNE+pfz0YhBTBotFV4s9HfqJ9
        Uf/XIKennAhKlX6dU8VhCYql4rUJULhsjsHyN8g=
X-Google-Smtp-Source: AMsMyM4Kd00qd78NT6sDPte3b49t6s5XnHPE3Uwj+gAvYxXNsaNBs/7C+K7XSgtoy0iU8QcxSY73jA==
X-Received: by 2002:a05:600c:5114:b0:3c7:8eb:fb1c with SMTP id o20-20020a05600c511400b003c708ebfb1cmr43928371wms.204.1667840033034;
        Mon, 07 Nov 2022 08:53:53 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id z2-20020a1cf402000000b003cfb45885bbsm1190042wma.11.2022.11.07.08.53.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Nov 2022 08:53:52 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, kuba@kernel.org, moshe@nvidia.com,
        saeedm@nvidia.com
Subject: [patch iproute2-next 2/2] devlink: get devlink port for ifname using RTNL get link command
Date:   Mon,  7 Nov 2022 17:53:48 +0100
Message-Id: <20221107165348.916092-3-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221107165348.916092-1-jiri@resnulli.us>
References: <20221107165348.916092-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Currently, when user specifies ifname as a handle on command line of
devlink, the related devlink port is looked-up in previously taken dump
of all devlink ports on the system. There are 3 problems with that:
1) The dump iterates over all devlink instances in kernel and takes a
   devlink instance lock for each.
2) Dumping all devlink ports would not scale.
3) Alternative ifnames are not exposed by devlink netlink interface.

Instead, benefit from RTNL get link command extension and get the
devlink port handle info from IFLA_DEVLINK_PORT attribute, if supported.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 devlink/devlink.c | 88 +++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 86 insertions(+), 2 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 308c0dbd1225..dce7d85ea012 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -43,6 +43,8 @@
 #include "json_print.h"
 #include "utils.h"
 #include "namespace.h"
+#include "libnetlink.h"
+#include "../ip/ip_common.h"
 
 #define ESWITCH_MODE_LEGACY "legacy"
 #define ESWITCH_MODE_SWITCHDEV "switchdev"
@@ -793,6 +795,81 @@ static void ifname_map_del(struct ifname_map *ifname_map)
 	ifname_map_free(ifname_map);
 }
 
+static int ifname_map_rtnl_port_parse(struct dl *dl, const char *ifname,
+				      struct rtattr *nest)
+{
+	struct rtattr *tb[DEVLINK_ATTR_MAX + 1];
+	const char *bus_name;
+	const char *dev_name;
+	uint32_t port_index;
+
+	parse_rtattr_nested(tb, DEVLINK_ATTR_MAX, nest);
+	if (!tb[DEVLINK_ATTR_BUS_NAME] || !tb[DEVLINK_ATTR_DEV_NAME] ||
+	    !tb[DEVLINK_ATTR_PORT_INDEX])
+		return -ENOENT;
+
+	bus_name = rta_getattr_str(tb[DEVLINK_ATTR_BUS_NAME]);
+	dev_name = rta_getattr_str(tb[DEVLINK_ATTR_DEV_NAME]);
+	port_index = rta_getattr_u32(tb[DEVLINK_ATTR_PORT_INDEX]);
+	return ifname_map_add(dl, ifname, bus_name, dev_name, port_index);
+}
+
+static int ifname_map_rtnl_init(struct dl *dl, const char *ifname)
+{
+	struct iplink_req req = {
+		.n.nlmsg_len = NLMSG_LENGTH(sizeof(struct ifinfomsg)),
+		.n.nlmsg_flags = NLM_F_REQUEST,
+		.n.nlmsg_type = RTM_GETLINK,
+		.i.ifi_family = AF_UNSPEC,
+	};
+	struct rtattr *tb[IFLA_MAX + 1];
+	struct rtnl_handle rth;
+	struct ifinfomsg *ifi;
+	struct nlmsghdr *n;
+	int len;
+	int err;
+
+	if (rtnl_open(&rth, 0) < 0) {
+		pr_err("Cannot open rtnetlink\n");
+		return -EINVAL;
+	}
+
+	addattr_l(&req.n, sizeof(req),
+		  !check_ifname(ifname) ? IFLA_IFNAME : IFLA_ALT_IFNAME,
+		  ifname, strlen(ifname) + 1);
+
+	if (rtnl_talk(&rth, &req.n, &n) < 0) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	if (n->nlmsg_type != RTM_NEWLINK) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	ifi = NLMSG_DATA(n);
+	len = n->nlmsg_len;
+
+	len -= NLMSG_LENGTH(sizeof(*ifi));
+	if (len < 0) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	parse_rtattr_flags(tb, IFLA_MAX, IFLA_RTA(ifi), len, NLA_F_NESTED);
+	if (!tb[IFLA_DEVLINK_PORT]) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
+	err = ifname_map_rtnl_port_parse(dl, ifname, tb[IFLA_DEVLINK_PORT]);
+
+out:
+	rtnl_close(&rth);
+	return err;
+}
+
 static int ifname_map_cb(const struct nlmsghdr *nlh, void *data)
 {
 	struct nlattr *tb[DEVLINK_ATTR_MAX + 1] = {};
@@ -838,11 +915,18 @@ static void ifname_map_init(struct dl *dl)
 	INIT_LIST_HEAD(&dl->ifname_map_list);
 }
 
-static int ifname_map_load(struct dl *dl)
+static int ifname_map_load(struct dl *dl, const char *ifname)
 {
 	struct nlmsghdr *nlh;
 	int err;
 
+	err = ifname_map_rtnl_init(dl, ifname);
+	if (!err)
+		return 0;
+	/* In case kernel does not support devlink port info passed over
+	 * RT netlink, fall-back to ports dump.
+	 */
+
 	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_PORT_GET,
 			       NLM_F_REQUEST | NLM_F_ACK | NLM_F_DUMP);
 
@@ -862,7 +946,7 @@ static int ifname_map_lookup(struct dl *dl, const char *ifname,
 	int err;
 
 	if (!dl->map_loaded) {
-		err = ifname_map_load(dl);
+		err = ifname_map_load(dl, ifname);
 		if (err) {
 			pr_err("Failed to create index map\n");
 			return err;
-- 
2.37.3

