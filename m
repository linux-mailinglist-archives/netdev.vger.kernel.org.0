Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AEDC30BF04
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 14:06:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231713AbhBBNG0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 08:06:26 -0500
Received: from mail-eopbgr140119.outbound.protection.outlook.com ([40.107.14.119]:36741
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230499AbhBBNGW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 08:06:22 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BcHxk8vKUJO/7r5MhBlDKj5Z2KqBX103bVre4JnitfEH9794SqWKMWey4+75kCJXbA+FbJe4pbtYU8Lu+UVo2dOsCezUbvliEAzwbZxxRgouUnDviqeHMUf1o+7ii8tYo4CKx0KvUUzkDtevCYsAcn6X+DRacdZd66ialtH7kDFJi+JzA2KLDpSqG8lru00m+awIztG+2Akb5t/Mj3hkSJwPPgqk+5BRLEz+1I125X8seKMuJ1UPaAqyawWHen0oqzPQiSN0wgB31OXzqD3S9aGKhqYXvlinC1A1wehcqELabQWa5kuzs1uNLi81jrmT16V8vMm4cHqJhfBa9zddSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VrALxYDr6AF9Lvg91SRzJ/KnTGI6pqvK6eAeTaGC2js=;
 b=YOxa5DzwueJhmehq0QFZY7KQrRu2+TMGniREz+WU/r5dEAX7Yt8kdEozFvEXkqtJekPnf+KcZoI8iSUrXB16D1GpP0VVF4SY2um4AVQNW20h1D8dluKvXra2GPVR+jWDH2OcVI0CIEoavutgm6XkFKQbQ1IfcV1Ogkz+PHaB3Ffz3pbi1byI6nIdOCkhSJjVkBciY3OaAh3sYMbQ9P/sYMf41nHaG5l9fg4Fm9kxyOGjvWZ639F1dtfb4xsOCdyjzm0cdnkPiueJxeo2e81JSD9YQHsj7PEHJUNiTsdDlpvc8syX4cHP4uHus9IdBWfzGnUok1IOokHhh6in3QmKRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VrALxYDr6AF9Lvg91SRzJ/KnTGI6pqvK6eAeTaGC2js=;
 b=Pg3rJZt1fxRuzMeBs4r8wrW929v/yQlNmP/4gZ0KFfHWZ10YUTbktvucJOGl5JmHFbPm/ARZOzsO2Z3MK8OzfyCKe74JVozZDE4J283cJkrwvKkYp9L2zGn1+rT886/N4xx9+LrN904YPThV4VCYidEr5X1Av6RAd298gK2uocU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=plvision.eu;
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:19b::9)
 by AM9P190MB1347.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:262::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17; Tue, 2 Feb
 2021 13:05:29 +0000
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::3011:87e8:b505:d066]) by AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::3011:87e8:b505:d066%9]) with mapi id 15.20.3805.027; Tue, 2 Feb 2021
 13:05:29 +0000
From:   Oleksandr Mazur <oleksandr.mazur@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     oleksandr.mazur@plvision.eu, dsahern@gmail.com, jiri@nvidia.com,
        davem@davemloft.net, linux-kernel@vger.kernel.org, kuba@kernel.org
Subject: [PATCH iproute2-next V3] devlink: add support for port params get/set
Date:   Tue,  2 Feb 2021 15:04:45 +0200
Message-Id: <20210202130445.5950-1-oleksandr.mazur@plvision.eu>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: AM6P193CA0053.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:209:8e::30) To AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:19b::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from omazur.x.ow.s (217.20.186.93) by AM6P193CA0053.EURP193.PROD.OUTLOOK.COM (2603:10a6:209:8e::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17 via Frontend Transport; Tue, 2 Feb 2021 13:05:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e94ec51b-a79b-4f0a-3c79-08d8c77b3720
X-MS-TrafficTypeDiagnostic: AM9P190MB1347:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM9P190MB1347C60BE4BD755CB85D5F2EE4B59@AM9P190MB1347.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:247;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Lj9PSHUZYvOx3CiA2tJgn+lifuEZs3kDD5aGvg2sLYi63aTpa27Dc5WgAsIQ8+kwSB5X3NeDfx/+PL/a89JEM5VFVUHQw7MgKPndZ2ld1iqUCLHvQTSkisGjX2hpfWi9hMFUWkH2LTRETC0oaLbhfn2y2yZ6rIgkZf8EdU/zukW5qeZs8OmtLUhC9dXlxtk9QtDKoi2uE/OiT9khc3s8eItmFYcmucOSa8VkZ1TuTEpXzApZbcS2weHnCCb9R9hka2HIGNW70zjuzBreHtWABTPE8sVa5LdGahpsGIesxRiYJa7QihGG05HXD+2t3PfggDBvskP16g30KWR3+4yydIEgxuE1mqHvXNl57cxKeMvdoMW+1tvrOmXFZu/42HFIhRFqCvSvS+r/DHjj6tSPftcEs78ba3VxQyJ8uxGTwSKk+SgqlRMRShor5PKqOuustGTVrykH/xo0TT5QEBM1UepBPzzfSFlFBUAb2EGkeGXd1AdWRnBhTLv5A8w1UVqRuVntZFFeIsX3SvaHqhykiQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0P190MB0738.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(396003)(346002)(39830400003)(366004)(136003)(376002)(4326008)(6916009)(86362001)(2906002)(30864003)(8676002)(478600001)(956004)(8936002)(5660300002)(66476007)(1076003)(2616005)(66946007)(26005)(6506007)(6666004)(52116002)(186003)(316002)(36756003)(66556008)(83380400001)(44832011)(6486002)(6512007)(16526019);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?CSwC/wg2PYhth+CA/0XqE6pDrPxhh2N0I9lc6JQI410YBMXIf05lF8BQmLpA?=
 =?us-ascii?Q?5QFtqECqO2faottU5ITwITWPSXA4KOdgDgysxA3ZSKIHZN2EDJQYfm9AaZnZ?=
 =?us-ascii?Q?stwiJcqqS2cmy8yshZschPt+au+FcWk3qkFsNEC0Kd8WqRES4Jfm1b0+OIpV?=
 =?us-ascii?Q?JWl0P9+avN3KFWy5QKRHwjNu/l/t5zQ2gzFt1SO1gggtjPCGeMAhtkZINVoH?=
 =?us-ascii?Q?QrkbuwWtT5aQVdCmfmXrWlu/YF9Qns1MUeE/Sk+5qnDvmCEVpvfcw/X2ftxu?=
 =?us-ascii?Q?qSLQkOolnDVoopj/2OVt1kk4+NnjWwiJZYGc1yrSt/ka5Zvw/n3F2E3p0s78?=
 =?us-ascii?Q?szHjN0jMxoRn+m3z30Xe0rJ0ZQyoeZgUk56qYK/d6xfh/EJ2/f9woe8RY6uO?=
 =?us-ascii?Q?gg3S8rzE7mL09wJ8IQdM3e9s08ENFTzsv2IiBY1iN2FMaaG4Ck80cAhvVmXg?=
 =?us-ascii?Q?IVR1UGKc0y3ptxRarz2sRi3vjq0wB+1mouGOdZa++QtdZJCYPeflRhpZZlVW?=
 =?us-ascii?Q?+PLNILhVZlCIF8EgNu0hHwhZTmFHNwbvT8DZg/9yRXgpHieE8mXrtb5G7rSc?=
 =?us-ascii?Q?zf17kRkpHW72mPlEXV5hCGjxKAnAwC+olE92z0Y1Ywn5ZrYNoS+K9lzGyXjm?=
 =?us-ascii?Q?ULabwXiTlNUt/6jS47NxYds+gDishPyt+K/LqqikmX4Qtd1mwwVKFtoAzRCR?=
 =?us-ascii?Q?RzTza2/LZf3lKnjaDYoML6H7MngJsusFDB4dEVmddBQ3yz7QxYomLj50zOL7?=
 =?us-ascii?Q?hEcq1pRDf7F6TB1Q1xHcDbsr97MMsat76rOgjj321oHA8bF2xBdhtwgGhB+d?=
 =?us-ascii?Q?/901NaX6ME653sYDFM4EwgfCjMt2RjD7ZI6mDQDj1soL+bc100aENQIVx+qR?=
 =?us-ascii?Q?+rIJzaUWgJhDmm9cTV9QYBsAUJJZGaPfs6XGqN7sxgcj/HCEZYv+YIOj/ywz?=
 =?us-ascii?Q?IXXnOb9XG2XosiUsAY32Rox4Cnl2IJ354FDDB/nYA2jTv07d79atH/7eEA51?=
 =?us-ascii?Q?95VK2WcIRbKwgHOyJHzlZLEgrSPnPNwbJdVv4+EziCsB8or8gnsnfjyE94P+?=
 =?us-ascii?Q?sMpvmIGJ?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: e94ec51b-a79b-4f0a-3c79-08d8c77b3720
X-MS-Exchange-CrossTenant-AuthSource: AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2021 13:05:29.4581
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pn/OHT4OTFQlA0nqkRCKpZCrX/RONV/lApLQqiP8R4C9CQNOviRcCby7o43mQRyuaWTbp1Yn11XHC4EizCkOHbUPb9R83H6BXl3qN6yaJqg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9P190MB1347
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add implementation for the port parameters
getting/setting.
Add bash completion for port param.
Add man description for port param.

Example:
$ devlink dev param set netdevsim/netdevsim0/0 name test_port_parameter value false cmode runtime

$ devlink port param show netdevsim/netdevsim0/0 name test_port_parameter
netdevsim/netdevsim0/0:
  name test_port_parameter type driver-specific
    values:
      cmode runtime value false

$ devlink port  -jp param show netdevsim/netdevsim0/0 name test_port_parameter
{
    "param": {
        "netdevsim/netdevsim0/0": [ {
                "name": "test_port_parameter",
                "type": "driver-specific",
                "values": [ {
                        "cmode": "runtime",
                        "value": false
                    } ]
            } ]
    }
}

Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
---
V3:
    1) Add usage example;
    2) Remove stray newline in code;
V2:
    1) Add bash completion for port param;
    2) Add man decsription / examples for port param;

 bash-completion/devlink |  55 ++++++++
 devlink/devlink.c       | 274 +++++++++++++++++++++++++++++++++++++++-
 man/man8/devlink-port.8 |  65 ++++++++++
 3 files changed, 388 insertions(+), 6 deletions(-)

diff --git a/bash-completion/devlink b/bash-completion/devlink
index 7395b504..361be9fe 100644
--- a/bash-completion/devlink
+++ b/bash-completion/devlink
@@ -319,6 +319,57 @@ _devlink_port_split()
     esac
 }
 
+# Completion for devlink port param set
+_devlink_port_param_set()
+{
+    case $cword in
+        7)
+            COMPREPLY=( $( compgen -W "value" -- "$cur" ) )
+            return
+            ;;
+        8)
+            # String argument
+            return
+            ;;
+        9)
+            COMPREPLY=( $( compgen -W "cmode" -- "$cur" ) )
+            return
+            ;;
+        10)
+            COMPREPLY=( $( compgen -W "runtime driverinit permanent" -- \
+                "$cur" ) )
+            return
+            ;;
+    esac
+}
+
+# Completion for devlink port param
+_devlink_port_param()
+{
+    case "$cword" in
+        3)
+            COMPREPLY=( $( compgen -W "show set" -- "$cur" ) )
+            return
+            ;;
+        4)
+            _devlink_direct_complete "port"
+            return
+            ;;
+        5)
+            COMPREPLY=( $( compgen -W "name" -- "$cur" ) )
+            return
+            ;;
+        6)
+            _devlink_direct_complete "param_name"
+            return
+            ;;
+    esac
+
+    if [[ "${words[3]}" == "set" ]]; then
+        _devlink_port_param_set
+    fi
+}
+
 # Completion for devlink port
 _devlink_port()
 {
@@ -331,6 +382,10 @@ _devlink_port()
             _devlink_port_split
             return
             ;;
+        param)
+            _devlink_port_param
+            return
+            ;;
         show|unsplit)
             if [[ $cword -eq 3 ]]; then
                 _devlink_direct_complete "port"
diff --git a/devlink/devlink.c b/devlink/devlink.c
index a2e06644..1984ddbb 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -2706,7 +2706,8 @@ static void pr_out_param_value(struct dl *dl, const char *nla_name,
 	}
 }
 
-static void pr_out_param(struct dl *dl, struct nlattr **tb, bool array)
+static void pr_out_param(struct dl *dl, struct nlattr **tb, bool array,
+			 bool is_port_param)
 {
 	struct nlattr *nla_param[DEVLINK_ATTR_MAX + 1] = {};
 	struct nlattr *param_value_attr;
@@ -2723,9 +2724,15 @@ static void pr_out_param(struct dl *dl, struct nlattr **tb, bool array)
 		return;
 
 	if (array)
-		pr_out_handle_start_arr(dl, tb);
+		if (is_port_param)
+			pr_out_port_handle_start_arr(dl, tb, false);
+		else
+			pr_out_handle_start_arr(dl, tb);
 	else
-		__pr_out_handle_start(dl, tb, true, false);
+		if (is_port_param)
+			pr_out_port_handle_start(dl, tb, false);
+		else
+			__pr_out_handle_start(dl, tb, true, false);
 
 	nla_type = mnl_attr_get_u8(nla_param[DEVLINK_ATTR_PARAM_TYPE]);
 
@@ -2745,7 +2752,10 @@ static void pr_out_param(struct dl *dl, struct nlattr **tb, bool array)
 		pr_out_entry_end(dl);
 	}
 	pr_out_array_end(dl);
-	pr_out_handle_end(dl);
+	if (is_port_param)
+		pr_out_port_handle_end(dl);
+	else
+		pr_out_handle_end(dl);
 }
 
 static int cmd_dev_param_show_cb(const struct nlmsghdr *nlh, void *data)
@@ -2758,7 +2768,7 @@ static int cmd_dev_param_show_cb(const struct nlmsghdr *nlh, void *data)
 	if (!tb[DEVLINK_ATTR_BUS_NAME] || !tb[DEVLINK_ATTR_DEV_NAME] ||
 	    !tb[DEVLINK_ATTR_PARAM])
 		return MNL_CB_ERROR;
-	pr_out_param(dl, tb, true);
+	pr_out_param(dl, tb, true, false);
 	return MNL_CB_OK;
 }
 
@@ -2956,6 +2966,21 @@ err_param_value_parse:
 	return err;
 }
 
+static int cmd_port_param_show_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct genlmsghdr *genl = mnl_nlmsg_get_payload(nlh);
+	struct nlattr *tb[DEVLINK_ATTR_MAX + 1] = {};
+	struct dl *dl = data;
+
+	mnl_attr_parse(nlh, sizeof(*genl), attr_cb, tb);
+	if (!tb[DEVLINK_ATTR_BUS_NAME] || !tb[DEVLINK_ATTR_DEV_NAME] ||
+	    !tb[DEVLINK_ATTR_PORT_INDEX] || !tb[DEVLINK_ATTR_PARAM])
+		return MNL_CB_ERROR;
+
+	pr_out_param(dl, tb, true, true);
+	return MNL_CB_OK;
+}
+
 static int cmd_dev_param_show(struct dl *dl)
 {
 	uint16_t flags = NLM_F_REQUEST | NLM_F_ACK;
@@ -3701,6 +3726,8 @@ static void cmd_port_help(void)
 	pr_err("       devlink port split DEV/PORT_INDEX count COUNT\n");
 	pr_err("       devlink port unsplit DEV/PORT_INDEX\n");
 	pr_err("       devlink port function set DEV/PORT_INDEX [ hw_addr ADDR ]\n");
+	pr_err("       devlink port param set DEV/PORT_INDEX name PARAMETER value VALUE cmode { permanent | driverinit | runtime }\n");
+	pr_err("       devlink port param show [DEV/PORT_INDEX name PARAMETER]\n");
 	pr_err("       devlink port health show [ DEV/PORT_INDEX reporter REPORTER_NAME ]\n");
 }
 
@@ -3935,6 +3962,31 @@ static int cmd_port_unsplit(struct dl *dl)
 	return _mnlg_socket_sndrcv(dl->nlg, nlh, NULL, NULL);
 }
 
+static int cmd_port_param_show(struct dl *dl)
+{
+	uint16_t flags = NLM_F_REQUEST | NLM_F_ACK;
+	struct nlmsghdr *nlh;
+	int err;
+
+	if (dl_argc(dl) == 0)
+		flags |= NLM_F_DUMP;
+
+	nlh = mnlg_msg_prepare(dl->nlg, DEVLINK_CMD_PORT_PARAM_GET, flags);
+
+	if (dl_argc(dl) > 0) {
+		err = dl_argv_parse_put(nlh, dl, DL_OPT_HANDLEP |
+					DL_OPT_PARAM_NAME, 0);
+		if (err)
+			return err;
+	}
+
+	pr_out_section_start(dl, "param");
+	err = _mnlg_socket_sndrcv(dl->nlg, nlh, cmd_port_param_show_cb, dl);
+	pr_out_section_end(dl);
+
+	return err;
+}
+
 static void cmd_port_function_help(void)
 {
 	pr_err("Usage: devlink port function set DEV/PORT_INDEX [ hw_addr ADDR ]\n");
@@ -3954,6 +4006,205 @@ static int cmd_port_function_set(struct dl *dl)
 	return _mnlg_socket_sndrcv(dl->nlg, nlh, NULL, NULL);
 }
 
+static int cmd_port_param_set_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct genlmsghdr *genl = mnl_nlmsg_get_payload(nlh);
+	struct nlattr *nla_param[DEVLINK_ATTR_MAX + 1] = {};
+	struct nlattr *tb[DEVLINK_ATTR_MAX + 1] = {};
+	struct nlattr *param_value_attr;
+	enum devlink_param_cmode cmode;
+	struct param_ctx *ctx = data;
+	struct dl *dl = ctx->dl;
+	int nla_type;
+	int err;
+
+	mnl_attr_parse(nlh, sizeof(*genl), attr_cb, tb);
+	if (!tb[DEVLINK_ATTR_BUS_NAME] || !tb[DEVLINK_ATTR_DEV_NAME] ||
+	    !tb[DEVLINK_ATTR_PORT_INDEX] || !tb[DEVLINK_ATTR_PARAM])
+		return MNL_CB_ERROR;
+
+	err = mnl_attr_parse_nested(tb[DEVLINK_ATTR_PARAM], attr_cb, nla_param);
+	if (err != MNL_CB_OK)
+		return MNL_CB_ERROR;
+
+	if (!nla_param[DEVLINK_ATTR_PARAM_TYPE] ||
+	    !nla_param[DEVLINK_ATTR_PARAM_VALUES_LIST])
+		return MNL_CB_ERROR;
+
+	nla_type = mnl_attr_get_u8(nla_param[DEVLINK_ATTR_PARAM_TYPE]);
+	mnl_attr_for_each_nested(param_value_attr,
+				 nla_param[DEVLINK_ATTR_PARAM_VALUES_LIST]) {
+		struct nlattr *nla_value[DEVLINK_ATTR_MAX + 1] = {};
+		struct nlattr *val_attr;
+
+		err = mnl_attr_parse_nested(param_value_attr,
+					    attr_cb, nla_value);
+		if (err != MNL_CB_OK)
+			return MNL_CB_ERROR;
+
+		if (!nla_value[DEVLINK_ATTR_PARAM_VALUE_CMODE] ||
+		    (nla_type != MNL_TYPE_FLAG &&
+		     !nla_value[DEVLINK_ATTR_PARAM_VALUE_DATA]))
+			return MNL_CB_ERROR;
+
+		cmode = mnl_attr_get_u8(nla_value[DEVLINK_ATTR_PARAM_VALUE_CMODE]);
+		if (cmode == dl->opts.cmode) {
+			val_attr = nla_value[DEVLINK_ATTR_PARAM_VALUE_DATA];
+			switch (nla_type) {
+			case MNL_TYPE_U8:
+				ctx->value.vu8 = mnl_attr_get_u8(val_attr);
+				break;
+			case MNL_TYPE_U16:
+				ctx->value.vu16 = mnl_attr_get_u16(val_attr);
+				break;
+			case MNL_TYPE_U32:
+				ctx->value.vu32 = mnl_attr_get_u32(val_attr);
+				break;
+			case MNL_TYPE_STRING:
+				ctx->value.vstr = mnl_attr_get_str(val_attr);
+				break;
+			case MNL_TYPE_FLAG:
+				ctx->value.vbool = val_attr ? true : false;
+				break;
+			}
+			break;
+		}
+	}
+	ctx->nla_type = nla_type;
+	return MNL_CB_OK;
+}
+
+static int cmd_port_param_set(struct dl *dl)
+{
+	struct param_ctx ctx = {};
+	struct nlmsghdr *nlh;
+	bool conv_exists;
+	uint32_t val_u32 = 0;
+	uint16_t val_u16;
+	uint8_t val_u8;
+	bool val_bool;
+	int err;
+
+	err = dl_argv_parse(dl, DL_OPT_HANDLEP |
+			    DL_OPT_PARAM_NAME |
+			    DL_OPT_PARAM_VALUE |
+			    DL_OPT_PARAM_CMODE, 0);
+	if (err)
+		return err;
+
+	/* Get value type */
+	nlh = mnlg_msg_prepare(dl->nlg, DEVLINK_CMD_PORT_PARAM_GET,
+			       NLM_F_REQUEST | NLM_F_ACK);
+	dl_opts_put(nlh, dl);
+
+	ctx.dl = dl;
+	err = _mnlg_socket_sndrcv(dl->nlg, nlh, cmd_port_param_set_cb, &ctx);
+	if (err)
+		return err;
+
+	nlh = mnlg_msg_prepare(dl->nlg, DEVLINK_CMD_PORT_PARAM_SET,
+			       NLM_F_REQUEST | NLM_F_ACK);
+	dl_opts_put(nlh, dl);
+
+	conv_exists = param_val_conv_exists(param_val_conv, PARAM_VAL_CONV_LEN,
+					    dl->opts.param_name);
+
+	mnl_attr_put_u8(nlh, DEVLINK_ATTR_PARAM_TYPE, ctx.nla_type);
+	switch (ctx.nla_type) {
+	case MNL_TYPE_U8:
+		if (conv_exists) {
+			err = param_val_conv_uint_get(param_val_conv,
+						      PARAM_VAL_CONV_LEN,
+						      dl->opts.param_name,
+						      dl->opts.param_value,
+						      &val_u32);
+			val_u8 = val_u32;
+		} else {
+			err = strtouint8_t(dl->opts.param_value, &val_u8);
+		}
+		if (err)
+			goto err_param_value_parse;
+		if (val_u8 == ctx.value.vu8)
+			return 0;
+		mnl_attr_put_u8(nlh, DEVLINK_ATTR_PARAM_VALUE_DATA, val_u8);
+		break;
+	case MNL_TYPE_U16:
+		if (conv_exists) {
+			err = param_val_conv_uint_get(param_val_conv,
+						      PARAM_VAL_CONV_LEN,
+						      dl->opts.param_name,
+						      dl->opts.param_value,
+						      &val_u32);
+			val_u16 = val_u32;
+		} else {
+			err = strtouint16_t(dl->opts.param_value, &val_u16);
+		}
+		if (err)
+			goto err_param_value_parse;
+		if (val_u16 == ctx.value.vu16)
+			return 0;
+		mnl_attr_put_u16(nlh, DEVLINK_ATTR_PARAM_VALUE_DATA, val_u16);
+		break;
+	case MNL_TYPE_U32:
+		if (conv_exists)
+			err = param_val_conv_uint_get(param_val_conv,
+						      PARAM_VAL_CONV_LEN,
+						      dl->opts.param_name,
+						      dl->opts.param_value,
+						      &val_u32);
+		else
+			err = strtouint32_t(dl->opts.param_value, &val_u32);
+		if (err)
+			goto err_param_value_parse;
+		if (val_u32 == ctx.value.vu32)
+			return 0;
+		mnl_attr_put_u32(nlh, DEVLINK_ATTR_PARAM_VALUE_DATA, val_u32);
+		break;
+	case MNL_TYPE_FLAG:
+		err = strtobool(dl->opts.param_value, &val_bool);
+		if (err)
+			goto err_param_value_parse;
+		if (val_bool == ctx.value.vbool)
+			return 0;
+		if (val_bool)
+			mnl_attr_put(nlh, DEVLINK_ATTR_PARAM_VALUE_DATA,
+				     0, NULL);
+		break;
+	case MNL_TYPE_STRING:
+		mnl_attr_put_strz(nlh, DEVLINK_ATTR_PARAM_VALUE_DATA,
+				  dl->opts.param_value);
+		if (!strcmp(dl->opts.param_value, ctx.value.vstr))
+			return 0;
+		break;
+	default:
+		printf("Value type not supported\n");
+		return -ENOTSUP;
+	}
+	return _mnlg_socket_sndrcv(dl->nlg, nlh, NULL, NULL);
+
+err_param_value_parse:
+	pr_err("Value \"%s\" is not a number or not within range\n",
+	       dl->opts.param_value);
+	return err;
+}
+
+static int cmd_port_param(struct dl *dl)
+{
+	if (dl_argv_match(dl, "help")) {
+		cmd_port_help();
+		return 0;
+	} else if (dl_argv_match(dl, "show") ||
+		   dl_argv_match(dl, "list") || dl_no_arg(dl)) {
+		dl_arg_inc(dl);
+		return cmd_port_param_show(dl);
+	} else if (dl_argv_match(dl, "set")) {
+		dl_arg_inc(dl);
+		return cmd_port_param_set(dl);
+	}
+	pr_err("Command \"%s\" not found\n", dl_argv(dl));
+	return -ENOENT;
+}
+
 static int cmd_port_function(struct dl *dl)
 {
 	if (dl_argv_match(dl, "help") || dl_no_arg(dl)) {
@@ -3988,6 +4239,9 @@ static int cmd_port(struct dl *dl)
 	} else if (dl_argv_match(dl, "unsplit")) {
 		dl_arg_inc(dl);
 		return cmd_port_unsplit(dl);
+	}else if (dl_argv_match(dl, "param")) {
+		dl_arg_inc(dl);
+		return cmd_port_param(dl);
 	} else if (dl_argv_match(dl, "function")) {
 		dl_arg_inc(dl);
 		return cmd_port_function(dl);
@@ -4802,6 +5056,10 @@ static const char *cmd_name(uint8_t cmd)
 	case DEVLINK_CMD_REGION_SET: return "set";
 	case DEVLINK_CMD_REGION_NEW: return "new";
 	case DEVLINK_CMD_REGION_DEL: return "del";
+	case DEVLINK_CMD_PORT_PARAM_GET: return "get";
+	case DEVLINK_CMD_PORT_PARAM_SET: return "set";
+	case DEVLINK_CMD_PORT_PARAM_NEW: return "new";
+	case DEVLINK_CMD_PORT_PARAM_DEL: return "del";
 	case DEVLINK_CMD_FLASH_UPDATE: return "begin";
 	case DEVLINK_CMD_FLASH_UPDATE_END: return "end";
 	case DEVLINK_CMD_FLASH_UPDATE_STATUS: return "status";
@@ -4840,6 +5098,10 @@ static const char *cmd_obj(uint8_t cmd)
 	case DEVLINK_CMD_PARAM_SET:
 	case DEVLINK_CMD_PARAM_NEW:
 	case DEVLINK_CMD_PARAM_DEL:
+	case DEVLINK_CMD_PORT_PARAM_GET:
+	case DEVLINK_CMD_PORT_PARAM_SET:
+	case DEVLINK_CMD_PORT_PARAM_NEW:
+	case DEVLINK_CMD_PORT_PARAM_DEL:
 		return "param";
 	case DEVLINK_CMD_REGION_GET:
 	case DEVLINK_CMD_REGION_SET:
@@ -4982,7 +5244,7 @@ static int cmd_mon_show_cb(const struct nlmsghdr *nlh, void *data)
 		    !tb[DEVLINK_ATTR_PARAM])
 			return MNL_CB_ERROR;
 		pr_out_mon_header(genl->cmd);
-		pr_out_param(dl, tb, false);
+		pr_out_param(dl, tb, false, false);
 		pr_out_mon_footer();
 		break;
 	case DEVLINK_CMD_REGION_GET: /* fall through */
diff --git a/man/man8/devlink-port.8 b/man/man8/devlink-port.8
index 966faae6..591ca021 100644
--- a/man/man8/devlink-port.8
+++ b/man/man8/devlink-port.8
@@ -43,6 +43,23 @@ devlink-port \- devlink port configuration
 .B devlink port health
 .RI "{ " show " | " recover " | " diagnose " | " dump " | " set " }"
 
+.ti -8
+.B devlink dev param set
+.I DEV/PORT_INDEX
+.B name
+.I PARAMETER
+.B value
+.I VALUE
+.BR cmode " { " runtime " | " driverinit " | " permanent " } "
+
+.ti -8
+.B devlink dev param show
+[
+.I DEV/PORT_INDEX
+.B name
+.I PARAMETER
+]
+
 .ti -8
 .B devlink port help
 
@@ -99,6 +116,44 @@ If this argument is omitted all ports are listed.
 Is an alias for
 .BR devlink-health (8).
 
+.SS devlink port param set  - set new value to devlink port configuration parameter
+
+.PP
+.B "DEV/PORT_INDEX"
+- specifies the devlink port to operate on.
+
+.TP
+.BI name " PARAMETER"
+Specify parameter name to set.
+
+.TP
+.BI value " VALUE"
+New value to set.
+
+.TP
+.BR cmode " { " runtime " | " driverinit " | " permanent " } "
+Configuration mode in which the new value is set.
+
+.I runtime
+- Set new value while driver is running. This configuration mode doesn't require any reset to apply the new value.
+
+.I driverinit
+- Set new value which will be applied during driver initialization. This configuration mode requires restart driver by devlink reload command to apply the new value.
+
+.I permanent
+- New value is written to device's non-volatile memory. This configuration mode requires hard reset to apply the new value.
+
+.SS devlink port param show - display devlink port supported configuration parameters attributes
+
+.PP
+.B "DEV/PORT_INDEX"
+- specifies the devlink port to operate on.
+
+.B name
+.I PARAMETER
+Specify parameter name to show.
+If this argument, as well as port index, are omitted - all parameters supported by devlink device ports are listed.
+
 .SH "EXAMPLES"
 .PP
 devlink port show
@@ -135,6 +190,16 @@ devlink port health show pci/0000:01:00.0/1 reporter tx
 .RS 4
 Shows status and configuration of tx reporter registered on pci/0000:01:00.0/1 devlink port.
 .RE
+.PP
+devlink dev param show
+.RS 4
+Shows (dumps) all the port parameters across all the devices registered in the devlink.
+.RE
+.PP
+devlink dev param set pci/0000:01:00.0/1 name internal_error_reset value true cmode runtime
+.RS 4
+Sets the parameter internal_error_reset of specified devlink port (#1) to true.
+.RE
 
 .SH SEE ALSO
 .BR devlink (8),
-- 
2.17.1

