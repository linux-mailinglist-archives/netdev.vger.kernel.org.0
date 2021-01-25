Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BB2B30323F
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 03:56:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729109AbhAYNvr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 08:51:47 -0500
Received: from mail-eopbgr30121.outbound.protection.outlook.com ([40.107.3.121]:23749
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728873AbhAYNts (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Jan 2021 08:49:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cFjOTWC5b0LVAW6zQdHyr1n+yCQwzv/RB/wzT93s3F/JSgYfD5nlHnE5eXAKCYvhmNvJIBatU+SbCEKAXRWVOxYSz+AL0cq9YXuz7eC+yqLTYHEJyLyCqOV/Y5v/Lb8v5OAKsEFDwGma9CORxdeEb2HUbyfKW7BGrlZFqj5LsRdS+tCmIQsYCtjohlhHUKNAOwwkYxQep7urGla2Mv7WqkfttpncjSqSOyUI1CInUt3CV5NLqdlkfjmtRJ85ulUPBz+nyQS1Kl4ZyVNkTTvHcpizcIWvIxpc7w9RkU0/0erv9h/oQSvxKkGex9oefwz0NjczDcI1FWsBGWAvDS3qQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N1hSb00FBfe7Y6gNDbahCaPdEzRhS7R2eLh7t3UDguc=;
 b=gs2qojcxSg5jRUsgeyHe4gbkLnb7FuskheefJ4Qt+x+uqv41jHJFi1e2Lewbcw09hGpsGWdFPSqe8smuLkCivkaCXrvkpksC40GssYOrFoW4kcy5j/6X8xJZroxS62+5QM4ex4FcbHDm0MoJaUcwlaHNixhTfvcr501Pvr/pphdZipO3f1rSbK+3xqTFvietH4y/46JX2GrC7/arkBSK8+B2o4FeQohjguP96qX+1CL0wXlmW6m/7lt6xRJFWpO2fCB7G6GPNI0pxKmfwUZ9hEGPQARAt6u2b8kWYuZw0UQPELuCRYzvcw51tRkjxu9XwIQeuLjGVLp4QosOmZDraA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N1hSb00FBfe7Y6gNDbahCaPdEzRhS7R2eLh7t3UDguc=;
 b=hrga3x2VqAr5gwbBeOReP5LFGdwquSer4mUWBTA6TXeBIfvHXQI6jtFJ0u6rgFZ4A16bJ+lyMa9oaNz+Uan1TmRYJS2cLEmzqrWfzi1x1YQAEMZLxPzUt4qSPn+kp1nVOPfAruiHvq4IviTmPtWaPoDaMpohh2XT6J96lyeLkhg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=plvision.eu;
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:19b::9)
 by AM9P190MB1267.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:264::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.13; Mon, 25 Jan
 2021 13:48:56 +0000
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::3011:87e8:b505:d066]) by AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::3011:87e8:b505:d066%9]) with mapi id 15.20.3784.017; Mon, 25 Jan 2021
 13:48:56 +0000
From:   Oleksandr Mazur <oleksandr.mazur@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     jiri@nvidia.com, davem@davemloft.net, linux-kernel@vger.kernel.org,
        kuba@kernel.org, Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Subject: [PATCH iproute-next v2] devlink: add support for port params get/set
Date:   Mon, 25 Jan 2021 15:48:38 +0200
Message-Id: <20210125134838.22439-1-oleksandr.mazur@plvision.eu>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: AM0PR03CA0096.eurprd03.prod.outlook.com
 (2603:10a6:208:69::37) To AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:19b::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from omazur.x.ow.s (217.20.186.93) by AM0PR03CA0096.eurprd03.prod.outlook.com (2603:10a6:208:69::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12 via Frontend Transport; Mon, 25 Jan 2021 13:48:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 56db880d-2932-4fe2-4980-08d8c137f5a2
X-MS-TrafficTypeDiagnostic: AM9P190MB1267:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM9P190MB126723DE8B63D900C228D50FE4BD0@AM9P190MB1267.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:247;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cdBbm3581EbPAun91+O+XcJ/Vv7QKHPreB4slrq8j9/pfkQVFljHkR2MNwshGlM/okEaJuBWEFNuFRGq5IPtmjGuRMekVrimMlhIS1bzpe2IIk38xjQUgkwCajP+/26RSIkImvqDx7SdPvx3l6ewKVT0/nQ066X3bo9Vu6FWn0pzgY46JvoVE5Kp7qXRRfCLJu3L8fWnrDUd/fI+W3f4hqPVkbFAgNFBEaJ1Svf/BeM3VY/CySYM5agfG19zREWYl4BqEMjkEBamUpd0OXPSOTOkPsHfYpciwGzl0ge+nhwxaEVQnn2nv9IVFZe1lxBWjm648Q59LAzydK/+bq8L+oqSf39kYG79+pu/eAz9oTyPdYOijaBZ+xOIe0e5tH3rFtqBk1WPeRRAo+QxD2JhpFNqza4xcUaxHyE3JUm0ZBaA5Ho6RyCrh1kB9UZFJSyjGjgfxS1S1ZyYAc8+vObHbviN9Nj43eGvGn+84j5QnSWiIRclBsh1CdVKI52N6PyzXY6Zl9PjWnF2iSsMnRE/RQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0P190MB0738.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(136003)(376002)(346002)(396003)(366004)(39830400003)(83380400001)(26005)(6486002)(6666004)(6512007)(36756003)(52116002)(2906002)(86362001)(66556008)(66476007)(66946007)(8936002)(44832011)(2616005)(1076003)(8676002)(5660300002)(30864003)(6506007)(107886003)(316002)(186003)(16526019)(478600001)(4326008)(956004)(6916009);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Qeln5qhDQ5anRftxY2W4qOx0ZkmbmCFyCBZ610OzhYhmECBpm4sW9Lw8bDMZ?=
 =?us-ascii?Q?GYYJR1VjrzXIw2Hup016JmplHYw4mLh00F5Nn1ly2AwNWwDxrr4ggoD+9Nkf?=
 =?us-ascii?Q?VGtVIjmol3g94cJA4RoXfPPIneKURIjOT7jAvOTbXLXQTf/8+bZJV0ZwD3+d?=
 =?us-ascii?Q?bOVPXb7MatYNEQZxeSP0DoGHY79DAjk/iAVDtbf8GV3RI9AoKAWa2o3M4Dlc?=
 =?us-ascii?Q?bt11KZb9hQB7jbot1jZ8hNZ04F3ewtA3LLRl62URBLJkKCx0/zOUOl1sDLwr?=
 =?us-ascii?Q?o4YmnicT+wPLAxWsfVH4GvLSQO30Uhm3PqxQhhI8f80AHbqyFZIgnE7j+pBf?=
 =?us-ascii?Q?vuPLnZ+eCmUCWA6cNQJaLIeEQXx0teQP+1mEZAt2lZdMJU0xcgA+ehzot2/O?=
 =?us-ascii?Q?9s99BJRV2et8kRSLtwlGUngzRM4xcy8/smuf+MzkunCIt0k39P/5PJWa6mjC?=
 =?us-ascii?Q?qO9lx/x0WrUkJsKkaH/GvRIEfe4ZjxGa5+D/dsH+TV0+NOWOOEiicm7BKKcZ?=
 =?us-ascii?Q?s7yUJ60hVpfYg+AMdrbIFwJUo+1adVvLIvSjcWar2r3p2zwWNV+dMK0MV/o1?=
 =?us-ascii?Q?VG9T4ipI2a/3OmYvZoOazCPqJK0ZQpqLIDkewbtLlQRM0RdJcupzWYabEZgy?=
 =?us-ascii?Q?VVIuHgfPD5tG5ss/U5w1KvQFq5u3cNYzxP1j4DjZ8pFRcn7aq60Kltk0gWp6?=
 =?us-ascii?Q?d9qG5t+f30Cj9C1uTZGRw6VV+m1lXEvu0aHoaUItgE2KM5kYuA+TIqhqpxYF?=
 =?us-ascii?Q?PTd0PCEqrXGlAzxyAv2ChVWew1f3Ssijfh6moEojZAOx+7P94wky7NM5CM3z?=
 =?us-ascii?Q?PpwWgQG5OiPwS5L6/K9bkQp+L09l8/oEp7yrgPZ0KpiHlVF0eHsPrkhAGU4F?=
 =?us-ascii?Q?NTt1jjrhC+aGSeQbHGNOJ1fqFnFnvZPUPfUMRyDyBAfvWkIongtQmC2G2Oq2?=
 =?us-ascii?Q?+V6DfmQ6Cfh/qvqhGoqBgjMRqPPFa49op8CpBKlVcOjLrVsaF9WHK5klpG7j?=
 =?us-ascii?Q?AYa0Xsw92ygAX8aB8KmflfBdKTbp3oydENrg/JZ3jz1VataOBiMp1SsPy87i?=
 =?us-ascii?Q?iyCeJzL+?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 56db880d-2932-4fe2-4980-08d8c137f5a2
X-MS-Exchange-CrossTenant-AuthSource: AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2021 13:48:56.3152
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xirKCYCMFqwcZpHchoR1RabU6bbf4AOM593hcrCeFBoMp2tHTzynUMuUA6NAkiREfW8IwuBVyoXdPM+jBbfHq/DBkvrFI0lW4m/Cgpjcreg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9P190MB1267
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add implementation for the port parameters getting/setting.
Add bash completion for port param.
Add man description for port param.

Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
---
V2:
    1) Add bash completion for port param;
    2) Add man decsription / examples for port param;

 bash-completion/devlink |  55 ++++++++
 devlink/devlink.c       | 275 +++++++++++++++++++++++++++++++++++++++-
 man/man8/devlink-port.8 |  65 ++++++++++
 3 files changed, 389 insertions(+), 6 deletions(-)

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
index a2e06644..0fc1d4f0 100644
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
@@ -2714,6 +2715,7 @@ static void pr_out_param(struct dl *dl, struct nlattr **tb, bool array)
 	int nla_type;
 	int err;
 
+
 	err = mnl_attr_parse_nested(tb[DEVLINK_ATTR_PARAM], attr_cb, nla_param);
 	if (err != MNL_CB_OK)
 		return;
@@ -2723,9 +2725,15 @@ static void pr_out_param(struct dl *dl, struct nlattr **tb, bool array)
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
 
@@ -2745,7 +2753,10 @@ static void pr_out_param(struct dl *dl, struct nlattr **tb, bool array)
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
@@ -2758,7 +2769,7 @@ static int cmd_dev_param_show_cb(const struct nlmsghdr *nlh, void *data)
 	if (!tb[DEVLINK_ATTR_BUS_NAME] || !tb[DEVLINK_ATTR_DEV_NAME] ||
 	    !tb[DEVLINK_ATTR_PARAM])
 		return MNL_CB_ERROR;
-	pr_out_param(dl, tb, true);
+	pr_out_param(dl, tb, true, false);
 	return MNL_CB_OK;
 }
 
@@ -2956,6 +2967,21 @@ err_param_value_parse:
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
@@ -3701,6 +3727,8 @@ static void cmd_port_help(void)
 	pr_err("       devlink port split DEV/PORT_INDEX count COUNT\n");
 	pr_err("       devlink port unsplit DEV/PORT_INDEX\n");
 	pr_err("       devlink port function set DEV/PORT_INDEX [ hw_addr ADDR ]\n");
+	pr_err("       devlink port param set DEV/PORT_INDEX name PARAMETER value VALUE cmode { permanent | driverinit | runtime }\n");
+	pr_err("       devlink port param show [DEV/PORT_INDEX name PARAMETER]\n");
 	pr_err("       devlink port health show [ DEV/PORT_INDEX reporter REPORTER_NAME ]\n");
 }
 
@@ -3935,6 +3963,31 @@ static int cmd_port_unsplit(struct dl *dl)
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
@@ -3954,6 +4007,205 @@ static int cmd_port_function_set(struct dl *dl)
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
@@ -3988,6 +4240,9 @@ static int cmd_port(struct dl *dl)
 	} else if (dl_argv_match(dl, "unsplit")) {
 		dl_arg_inc(dl);
 		return cmd_port_unsplit(dl);
+	}else if (dl_argv_match(dl, "param")) {
+		dl_arg_inc(dl);
+		return cmd_port_param(dl);
 	} else if (dl_argv_match(dl, "function")) {
 		dl_arg_inc(dl);
 		return cmd_port_function(dl);
@@ -4802,6 +5057,10 @@ static const char *cmd_name(uint8_t cmd)
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
@@ -4840,6 +5099,10 @@ static const char *cmd_obj(uint8_t cmd)
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
@@ -4982,7 +5245,7 @@ static int cmd_mon_show_cb(const struct nlmsghdr *nlh, void *data)
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

