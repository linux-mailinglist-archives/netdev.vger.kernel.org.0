Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54C6377811
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 12:05:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728782AbfG0KFt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 06:05:49 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45759 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728407AbfG0KFt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jul 2019 06:05:49 -0400
Received: by mail-wr1-f67.google.com with SMTP id f9so56780129wre.12
        for <netdev@vger.kernel.org>; Sat, 27 Jul 2019 03:05:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=V7x08oMX/uVA8w+3v+3F/4+4yYHzFnDaLpKoEnlvRO8=;
        b=p5rWINzB1Irq8RDdvHzww5/0Ebn5+SHvZ/JPibeN4aXF+xw3PBrcGMzZsB/VX0Pc6C
         MFP7eWrqzj0ldgjbXCM1182zV38cm3vDrv1M57nVutblyaXRC6Xvd3NdTPzThwRmGzMj
         E2gEsM2SOL4wPRR0hc/PBdy8O35Sw4BTMEYgMrEQ7isnPW2kcXjH/iqVCgyVeMecA+NH
         GL83tIBADVpzBklfZX+tDLjjmypc0irUl0jecyO1V/dz2yZ3AnhprJH9YxbRW6ih840v
         drq3cy+lXFlXrjr9na4OnmhptnN7EjhFYXvNpcEB7Oo4Uo8l6xiHRWLT0djjgEQ0/Ubq
         H+xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=V7x08oMX/uVA8w+3v+3F/4+4yYHzFnDaLpKoEnlvRO8=;
        b=BWi/87YyDVK1o0wbQfHZKDVqLBIRtzLkl/IWqp4uM99RauXp05u4XYkXhymgys5oAJ
         d41VbT253vyfYO66qxa4Ial9v8HfDJQMG7VleLRBogHAO+S4qcAaRdd4TKpJxibE2zxl
         2cs7Gmfci0CTp28Ibf/rl42N7/pUa8/BzVMzCjNThWtVrqLA07fTUH4cEefIhL986qEc
         eNsJVlmmJCdZjyO1RHQhth8rHhp1yrvC3dWizsDg+ngu5+v9uNptnZ/VxdGNvvlQKQhQ
         3bnIR0WYlLUj+xe4qZj85aw/b/VSt0jK7idq34hi9NwrMhG34JzI62DKShqdcgAuYcc/
         eIXQ==
X-Gm-Message-State: APjAAAWbbmlXmIWZXv5fgqFgUdOFf+yiYoha5fugadFGV6xTEbafNuAd
        SyCsyH0Q1g7ytOQEDJ79Fgu8EbKj
X-Google-Smtp-Source: APXvYqzQHEM1JlE0xYAovQIMbH4KiQWrmwWI9dXqB5hx+NTdhnoZeFpo1rYz2MvgNbrFKzu6lFYdQQ==
X-Received: by 2002:adf:ed0e:: with SMTP id a14mr108854992wro.259.1564221946386;
        Sat, 27 Jul 2019 03:05:46 -0700 (PDT)
Received: from localhost (ip-78-102-222-119.net.upcbroadband.cz. [78.102.222.119])
        by smtp.gmail.com with ESMTPSA id b203sm69906002wmd.41.2019.07.27.03.05.46
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sat, 27 Jul 2019 03:05:46 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        sthemmin@microsoft.com, dsahern@gmail.com, mlxsw@mellanox.com
Subject: [patch iproute2 2/2] devlink: add support for network namespace change
Date:   Sat, 27 Jul 2019 12:05:44 +0200
Message-Id: <20190727100544.28649-2-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190727094459.26345-1-jiri@resnulli.us>
References: <20190727094459.26345-1-jiri@resnulli.us>
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

