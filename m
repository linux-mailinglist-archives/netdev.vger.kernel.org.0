Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AA90619463
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 11:23:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231612AbiKDKXl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 06:23:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230074AbiKDKXg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 06:23:36 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C4616162
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 03:23:35 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id i21so6879186edj.10
        for <netdev@vger.kernel.org>; Fri, 04 Nov 2022 03:23:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OwXl5pgP6sVQEObxvQRF+gbBJfLMgwBdfHpVPPa//hc=;
        b=xS8S+tQXgnoYsDjvh1lWGJwAbwd2I3cyuGQhpy0eLoRv0GB+YgeA6Enk/QdmiS30Ov
         vn9ZoCqZoGN2t1kzF4iNlWYPUp75YAsnRuBDRRygjCTPMiNCEYGcf2bAQom7eiIQRYdt
         8c6A0SxUC69LSNJO7PctdyPfYb9lh+VmjhYyD1bMhG7JKAglWfUKfoA1OYdWWZQuF3yl
         WSzgoWUOuLO7scdZdKi3K8zV1oIQmOPWV0sWJrIMrJmhp4Hq2LbCzpwhbiC97aA33ssx
         oc2jDlt/aeX3uu0WMmHyu4jhEyKXj10UrMCOmNHu5adgL9z8CbknERKKI+UopkZEwzda
         bQfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OwXl5pgP6sVQEObxvQRF+gbBJfLMgwBdfHpVPPa//hc=;
        b=1XnuWyeHRpH9HOQAWVTcRqggkyMK34cJj+l1k2i48ZQ7gCgD5y/gChxqhWQQDQ29XW
         cMmDDPU7qrbWgzABQP/HGYuLy3iQCBDzFZ3zfD310m6yJb+goMuAThUcDLJTaONcCSxJ
         sFuIfiheudLNt4+M3ZUoJx3v7r1S+FlA172PN4JpqH3hsQ6Ty7BsFK8wE1T4k/N2iY7y
         SNRmJBRF5/wTX5+KVRHTg/9sm8sfBJY6Jf81pj6Q5cSHpg+LumVg5Kdzsp2vBVHrrpCG
         FnphHV3lxJlJa5gsbHFI3Y6ywhiPLwOGyDRhhTiOn/zltFcUFWZuwLAm3bMwPHRz7UxH
         pcOg==
X-Gm-Message-State: ACrzQf2I+W08ptXxphi7flB9lNJYom80ldRBi99vY7tSadOjJaid+W1/
        Ts7SM51Of6hZB/IWPgT/hZ6M7Mz5sLGswTlF
X-Google-Smtp-Source: AMsMyM55jeMuUt5Klhyy/ndJRk3RJ239J/g1RevePqRPOTU7YHvTbElENv3PYiThgWH1LUMuLRobCw==
X-Received: by 2002:a05:6402:144a:b0:461:8e34:d07b with SMTP id d10-20020a056402144a00b004618e34d07bmr35633815edx.426.1667557414175;
        Fri, 04 Nov 2022 03:23:34 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id kw16-20020a170907771000b007822196378asm1628568ejc.176.2022.11.04.03.23.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Nov 2022 03:23:33 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     sthemmin@microsoft.com, dsahern@gmail.com, kuba@kernel.org,
        moshe@nvidia.com, aeedm@nvidia.com
Subject: [patch iproute2-next 3/3] devlink: get devlink port for ifname using RTNL get link command
Date:   Fri,  4 Nov 2022 11:23:27 +0100
Message-Id: <20221104102327.770260-4-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221104102327.770260-1-jiri@resnulli.us>
References: <20221104102327.770260-1-jiri@resnulli.us>
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
index 6e8e03aa14b7..f656d0a7c514 100644
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

