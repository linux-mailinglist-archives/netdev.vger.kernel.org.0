Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC69C642851
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 13:22:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231785AbiLEMW1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 07:22:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231786AbiLEMWV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 07:22:21 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AFD6F591
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 04:22:05 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id b2so27327069eja.7
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 04:22:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FvBheTdn78ggx6RbF/uAUm6CDSl9Cfu8oxfP9Ra6sFw=;
        b=5kA+a/MS+JzXdcrAjUXvG6y6Q3VuV79+zSKDffahP5fDkJKj1WHXE1MpJnN/+mPlmD
         cNQhJi/zXVFkrxnk0BRvoHvlrZfJv6FTpq6158D0NyJ/9XmfJQD9FsbU/N9FfGyXmt92
         KlRWckjViRH4DUxe44AxsmsPTooVXr12S4w9iF73GE72VdrutFaV37bbOUeF4j+AFcHF
         YJe1F6MMS+Fv3bB+FNejF957bWbp1kchOCbVhVtzL4HSJw84hGXRPlTaGCbkELoxMwFF
         NtyYSPke9N6ZG8ggMFFrkwhAbX8qTfeOTaP9fZuuN7nNjEzymtU3ldP6q7P9wsdFINy1
         +W/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FvBheTdn78ggx6RbF/uAUm6CDSl9Cfu8oxfP9Ra6sFw=;
        b=bc2IjPBCfiB97YV/QhvKVZO5nddRodUGIsFScpgbP0T2F5cIstaom5b8rjn2L3mKQl
         0kuiRhPIxFe4IzZaDhh+kkfPD095XSf9NHUo+eaAH2fSw/ExW37a0eFJH+l7GzUTGkK3
         Q4BgbyHQ9jlAbaihItdz2iT6wgutDIBKK+BWgAHJ7Mfmukbd/vRWPBmWFb8dPXj0KzYX
         18wt5TiPJCOst9viN0aiVkxQBpGP3T86JX4dIzz1jbUfuH4/pwbJ4WIbfhx/F7WEma4m
         udO2XjpEpvSa81u1dTpejlDRp0UuTJHYj00TR7wXdXBvdHv8dDutDDAICoqDM6Zmx9d0
         fajQ==
X-Gm-Message-State: ANoB5pnLzJyjspfsfp9gTQZjKnUiUmsWXUc1k6K0GaZlz1Ko/qIEq/+v
        HnaH2a75AwroKQb94o03hd0Mfg0WwWGR5fuOcO0=
X-Google-Smtp-Source: AA0mqf5fUZoCw+c9/5Hg2T5v+/Hx5QDDcIpvJN1Wm0fK5UyNs5r5D/BSr3o5l1sCjj5btFz7dQfJeg==
X-Received: by 2002:a17:906:bcda:b0:7c0:80b0:7f67 with SMTP id lw26-20020a170906bcda00b007c080b07f67mr27017330ejb.462.1670242923595;
        Mon, 05 Dec 2022 04:22:03 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id dt13-20020a170906b78d00b0078d3f96d293sm6208301ejb.30.2022.12.05.04.22.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 04:22:03 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com, kuba@kernel.org,
        moshe@nvidia.com, saeedm@nvidia.com
Subject: [patch iproute2/net-next 2/4] devlink: get devlink port for ifname using RTNL get link command
Date:   Mon,  5 Dec 2022 13:21:56 +0100
Message-Id: <20221205122158.437522-3-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221205122158.437522-1-jiri@resnulli.us>
References: <20221205122158.437522-1-jiri@resnulli.us>
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
 devlink/devlink.c | 96 ++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 91 insertions(+), 5 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index d224655cd0e9..80c18d690c10 100644
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
@@ -797,6 +799,81 @@ static void ifname_map_del(struct ifname_map *ifname_map)
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
@@ -842,11 +919,20 @@ static void ifname_map_init(struct dl *dl)
 	INIT_LIST_HEAD(&dl->ifname_map_list);
 }
 
-static int ifname_map_load(struct dl *dl)
+static int ifname_map_load(struct dl *dl, const char *ifname)
 {
 	struct nlmsghdr *nlh;
 	int err;
 
+	if (ifname) {
+		err = ifname_map_rtnl_init(dl, ifname);
+		if (!err)
+			return 0;
+		/* In case kernel does not support devlink port info passed over
+		 * RT netlink, fall-back to ports dump.
+		 */
+	}
+
 	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_PORT_GET,
 			       NLM_F_REQUEST | NLM_F_ACK | NLM_F_DUMP);
 
@@ -858,14 +944,14 @@ static int ifname_map_load(struct dl *dl)
 	return 0;
 }
 
-static int ifname_map_check_load(struct dl *dl)
+static int ifname_map_check_load(struct dl *dl, const char *ifname)
 {
 	int err;
 
 	if (dl->map_loaded)
 		return 0;
 
-	err = ifname_map_load(dl);
+	err = ifname_map_load(dl, ifname);
 	if (err) {
 		pr_err("Failed to create index map\n");
 		return err;
@@ -882,7 +968,7 @@ static int ifname_map_lookup(struct dl *dl, const char *ifname,
 	struct ifname_map *ifname_map;
 	int err;
 
-	err = ifname_map_check_load(dl);
+	err = ifname_map_check_load(dl, ifname);
 	if (err)
 		return err;
 
@@ -905,7 +991,7 @@ static int ifname_map_rev_lookup(struct dl *dl, const char *bus_name,
 
 	int err;
 
-	err = ifname_map_check_load(dl);
+	err = ifname_map_check_load(dl, NULL);
 	if (err)
 		return err;
 
-- 
2.37.3

