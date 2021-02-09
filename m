Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42753314D2C
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 11:35:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230492AbhBIKfV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 05:35:21 -0500
Received: from mail-eopbgr30109.outbound.protection.outlook.com ([40.107.3.109]:62255
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231945AbhBIKdC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Feb 2021 05:33:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZjP4LrynMUEpeSpWJLOb33+/su/M6A5HE2V8mE/nlDDBg63PbywFhQrfoqaQUmelhgb1AqLWlmjd4+NBBn31k7aWKrrHtumk9UBPu4TX6J9aGZ+O0Tw2qAIR3W/b/9Is3LjbGRbWaDZszYbHoyrPpQ2PMtcOfhxlJaYzYHGgWPwUvL/L+WHLujr5TQSIj4s1lE91Ldm40eTO7UvmKCiHUkhdYMW3N4INEbq/48wzetbV9hYQ89/hgaeCZSGv00fzOpNTsCrPA77Ochi+uwuI3Yog42T4cVH4yW6EkpPA0Pv+2s8tQSff3hK3i9vwwJoOiBb20Nnohglaa4/AqrFlDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PKA6Gp7O9kII8MTH9A28hJkG2bpb/otoHB7qCZJZ2sY=;
 b=MNjxmb2UJvSwhTb+9GsqofKKdRDFLv4L/Bc+icex5ZihXF/n+e/ls+015hVMMVrddvn2tBFgrDRcSMNG89QI1TG8saoSMoH45+x1o0jUhepfj8uoozAz33xEWry3S8BbTQTqQ9L2KbNDKWSeTYqm54JuiAOQGXrFgVssVtvrD4Eq+apYnAZoEsUO+GlI1J+nSiOzksYPdLCsNyePq361vvdzKsMjiYM/YV1LISoo2WH5tYPFkD1EkVR6e3QH2BLjVG10zgyMY10oJWrm/CdP0g6pyXIRuC5do0hxcA8NFpi2KamgZ+bPStX/KWmxR9TVDcU+a5KVPPn1LOEBJXWP1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PKA6Gp7O9kII8MTH9A28hJkG2bpb/otoHB7qCZJZ2sY=;
 b=C/F6Lgo8d1XAFAp+WLr+QBG7QZXWJtBN2yyxrDQjyP4J3jldDM3Iwc7hCE0dPnT6cbSYRJOCuEccvl526FBhZb8weguVN1HjF/r5rb8A6SryabVSdcRFLpUdUz/MOtYj3ofvWDOlASyp8yjWOTsiMMlA0uhHCxgheUFy7vs1bHQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=plvision.eu;
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:19b::9)
 by AM0P190MB0689.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:198::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.30; Tue, 9 Feb
 2021 10:32:09 +0000
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::3011:87e8:b505:d066]) by AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::3011:87e8:b505:d066%9]) with mapi id 15.20.3825.030; Tue, 9 Feb 2021
 10:32:09 +0000
From:   Oleksandr Mazur <oleksandr.mazur@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     oleksandr.mazur@plvision.eu, dsahern@gmail.com, jiri@nvidia.com,
        davem@davemloft.net, linux-kernel@vger.kernel.org, kuba@kernel.org
Subject: [PATCH iproute2-next V4] devlink: add support for port params get/set
Date:   Tue,  9 Feb 2021 12:31:51 +0200
Message-Id: <20210209103151.2696-1-oleksandr.mazur@plvision.eu>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: AM6P192CA0002.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:209:83::15) To AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:19b::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from omazur.x.ow.s (217.20.186.93) by AM6P192CA0002.EURP192.PROD.OUTLOOK.COM (2603:10a6:209:83::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19 via Frontend Transport; Tue, 9 Feb 2021 10:32:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a5b17855-e231-4247-e0b7-08d8cce5f408
X-MS-TrafficTypeDiagnostic: AM0P190MB0689:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0P190MB0689E2F9305B5B71C3F5A6C6E48E9@AM0P190MB0689.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:247;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: See2+tG81vAWWRT1rb8hNe/4w5Ts4UJF3XGMS4tVk+D0II08tcSQpFwTV1nt90kjdqDrIPF3NqMxOP0AzuBaSRLhATpk1yjDRt6t/HF3kABXPhlQE/uI1DKIcWWdWsnOJx+3I368H25tqrB6JXLEf64NkPYhktFBygIsQzqF+vuuta8IobUqu7udHAOHMVMJBAEv5gF/cNo48Gvi4cWGGMRq1kEoStKvMp1Ry4que0z4/IAHWjs0LsLsIN69bECC7/FgogSLW0gFI/pRf9xb6Z7KA9iZrr4WWKubpC8qx6T0FEOJhNifyt0g7JXm0TG2+8I5ODsVIMYvwe3hnlxe0/HI5zNuZoLi/x5vlT/udc7NdbhfjjQqJ0Im+gRBqHTGlAoZQZI2ukfPendNebk0hsvPL7juMVmIe1aqBPgnKIBpzocxKFIvJCmuL2kZrEUlhmk4AkwJg7ZkSYU7oU1eHkAZpOMk1xHrgd4nETVV3YwECjRJ+1djrhbpBly3BzK9BdFrK0ynQe7qMkRy57Ywow==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0P190MB0738.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(136003)(376002)(396003)(346002)(39830400003)(366004)(2906002)(4326008)(52116002)(26005)(1076003)(5660300002)(36756003)(2616005)(44832011)(8936002)(16526019)(478600001)(186003)(316002)(66946007)(956004)(6506007)(6512007)(83380400001)(66476007)(66556008)(6666004)(6916009)(86362001)(8676002)(6486002)(30864003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?aizojzfpaGbXKKttZrK/nr475tJvydhSL4cpWGj+wkVrxKkIbrTXigHlC5Ro?=
 =?us-ascii?Q?YU9KXopUZjJnL41lJVLeYAZtQ2x3DP4kZpxsgjHE1xtASZ6wftFCtGeAHJd4?=
 =?us-ascii?Q?1SMx/qWyi+n4tXU1HEbg7sWFmX+5WvmXAdCf9s/30kp53fLUji0X52LDTLfj?=
 =?us-ascii?Q?OjmPHibuKXlbQMuCa/uKNSEtLk6Cyx1/rvZSTKoevUvHmscGJ3+CpjyH/sF8?=
 =?us-ascii?Q?LhTrC/hwEb056jyKsVNQWLP+vflNJU/4K9T/bxBXN/HqQEC8zAZ7arcgJCOe?=
 =?us-ascii?Q?kpSSniXAv2v3ObaG2cm38T7JlQ1XGThGrEoTsY5eFEyDAWtOhTk2D/NcoeWj?=
 =?us-ascii?Q?u2ldpAVdx+59TrPbNdnDy0ltGk3dKawNF4hR+cEv49HNfcfY5FUROtp3GeTg?=
 =?us-ascii?Q?16xmom1XNktnKH7w25ONzwuYCpF8cUSR1ITLkCsfVNFWw/LbyDIGuS/n+5xE?=
 =?us-ascii?Q?KDPFioIbvKwHckU2/MNOazAV7tNqqnycCyB2DCzAedVEnKpx53YYPLYj20u7?=
 =?us-ascii?Q?U0uqaaAjo3v5f9v3q31WtLTXT7TtjGQTLKpzga9JP21i7WJGIr4kOHJUs9s2?=
 =?us-ascii?Q?03yk2IoQ1AptK7V0qgkKyyxEu+9Ry0/A9p3RBP51bMI/O1Pla3SoIKtCxBrp?=
 =?us-ascii?Q?eMM9iAmubrdtZrUG+qvB1scOXywQb5MXPoDrtmuBAkEzuZzpp5q+01Kc+okg?=
 =?us-ascii?Q?60twYgzpkM2tiQV/nPg2ljxyeddYJH83W+VS3hNYRYBtvYIy3CaYbxMgVC1V?=
 =?us-ascii?Q?UuU+FkRtEzb+8u9zRsab5rfMOxR+rJik5QXVn9OOCGMRlMWYCFTC06uk0Qcg?=
 =?us-ascii?Q?vq/R7evNdPU/haOC4UWUXaAHPVDJoNw+L46y/LA2i7/cav5AnJK8i/cNqNeT?=
 =?us-ascii?Q?9zwOXlrrej4HVFf4sfZom4RS0nn2bNHoOoDRFgGXFp9NbTWwU4PGAjMFeQ2I?=
 =?us-ascii?Q?hOv/q7hvnqaN1jSqK+kkFzJwm8kqd+8dtWpyu5rjlkAqvj/ZmSdxdlA1tu8C?=
 =?us-ascii?Q?1XusAQaYF1Lt05IjxHOahNSQ/lJa0DGa8Ksrij+fbLYzeaGhYWevzNoIumdn?=
 =?us-ascii?Q?JYUyapVsNeY0c3WLSO3261mYNbOBS5tGs+gOoT59/U8XpQJU1yrxEaI5OVyQ?=
 =?us-ascii?Q?Ehd51+gK3u/AjL720V5hCRROcQSlUBD4Z82BpR6u35z7qumrShQQYDTDVYhZ?=
 =?us-ascii?Q?5r/dsAL7TStdSoxD3w6B9p8KVnw4OLn5fhgHOqkpPBRRMZ+RHjIbOHrx87+B?=
 =?us-ascii?Q?yUPf3+MfoIKIaSRDstRyb37YhV/ku0ZWNGeB4OMTvBMNkxW6O0fKfSfusQu7?=
 =?us-ascii?Q?0I4ZpmNfhxdxX7357s6db7Vf?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: a5b17855-e231-4247-e0b7-08d8cce5f408
X-MS-Exchange-CrossTenant-AuthSource: AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2021 10:32:09.1075
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iZkOkPZHGJmPszg8Bb+hRJcg33mnmGOKEGJ+u6lvDUMEteiKouMwj5SYefqDeBfIfTyoJqh1qV0ySRdzJFCaXxX+3VfWGY3K8YjVgu8Ydag=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0P190MB0689
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add implementation for the port parameters
getting/setting.
Add bash completion for port param.
Add man description for port param.

Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
---
V4:
    1) Rebase on top of master;
    2) Add missed space in after else-if-clause bracket;
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
index 10398f77..c6e85ff9 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -2808,7 +2808,8 @@ static void pr_out_param_value(struct dl *dl, const char *nla_name,
 	}
 }
 
-static void pr_out_param(struct dl *dl, struct nlattr **tb, bool array)
+static void pr_out_param(struct dl *dl, struct nlattr **tb, bool array,
+			 bool is_port_param)
 {
 	struct nlattr *nla_param[DEVLINK_ATTR_MAX + 1] = {};
 	struct nlattr *param_value_attr;
@@ -2825,9 +2826,15 @@ static void pr_out_param(struct dl *dl, struct nlattr **tb, bool array)
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
 
@@ -2847,7 +2854,10 @@ static void pr_out_param(struct dl *dl, struct nlattr **tb, bool array)
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
@@ -2860,7 +2870,7 @@ static int cmd_dev_param_show_cb(const struct nlmsghdr *nlh, void *data)
 	if (!tb[DEVLINK_ATTR_BUS_NAME] || !tb[DEVLINK_ATTR_DEV_NAME] ||
 	    !tb[DEVLINK_ATTR_PARAM])
 		return MNL_CB_ERROR;
-	pr_out_param(dl, tb, true);
+	pr_out_param(dl, tb, true, false);
 	return MNL_CB_OK;
 }
 
@@ -3058,6 +3068,21 @@ err_param_value_parse:
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
@@ -3803,6 +3828,8 @@ static void cmd_port_help(void)
 	pr_err("       devlink port split DEV/PORT_INDEX count COUNT\n");
 	pr_err("       devlink port unsplit DEV/PORT_INDEX\n");
 	pr_err("       devlink port function set DEV/PORT_INDEX [ hw_addr ADDR ] [ state STATE ]\n");
+	pr_err("       devlink port param set DEV/PORT_INDEX name PARAMETER value VALUE cmode { permanent | driverinit | runtime }\n");
+	pr_err("       devlink port param show [DEV/PORT_INDEX name PARAMETER]\n");
 	pr_err("       devlink port health show [ DEV/PORT_INDEX reporter REPORTER_NAME ]\n");
 	pr_err("       devlink port add DEV/PORT_INDEX flavour FLAVOUR pfnum PFNUM [ sfnum SFNUM ]\n");
 	pr_err("       devlink port del DEV/PORT_INDEX\n");
@@ -4065,6 +4092,31 @@ static int cmd_port_unsplit(struct dl *dl)
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
 	pr_err("Usage: devlink port function set DEV/PORT_INDEX [ hw_addr ADDR ] [ state STATE ]\n");
@@ -4089,6 +4141,205 @@ static int cmd_port_function_set(struct dl *dl)
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
@@ -4175,6 +4426,9 @@ static int cmd_port(struct dl *dl)
 	} else if (dl_argv_match(dl, "unsplit")) {
 		dl_arg_inc(dl);
 		return cmd_port_unsplit(dl);
+	} else if (dl_argv_match(dl, "param")) {
+		dl_arg_inc(dl);
+		return cmd_port_param(dl);
 	} else if (dl_argv_match(dl, "function")) {
 		dl_arg_inc(dl);
 		return cmd_port_function(dl);
@@ -4996,6 +5250,10 @@ static const char *cmd_name(uint8_t cmd)
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
@@ -5034,6 +5292,10 @@ static const char *cmd_obj(uint8_t cmd)
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
@@ -5176,7 +5438,7 @@ static int cmd_mon_show_cb(const struct nlmsghdr *nlh, void *data)
 		    !tb[DEVLINK_ATTR_PARAM])
 			return MNL_CB_ERROR;
 		pr_out_mon_header(genl->cmd);
-		pr_out_param(dl, tb, false);
+		pr_out_param(dl, tb, false, false);
 		pr_out_mon_footer();
 		break;
 	case DEVLINK_CMD_REGION_GET: /* fall through */
diff --git a/man/man8/devlink-port.8 b/man/man8/devlink-port.8
index 55f1cce6..563c5833 100644
--- a/man/man8/devlink-port.8
+++ b/man/man8/devlink-port.8
@@ -70,6 +70,23 @@ devlink-port \- devlink port configuration
 .BR "state"
 .RI "STATE }"
 
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
 
@@ -185,6 +202,44 @@ port type is Ethernet.
 .B "DEV/PORT_INDEX"
 - specifies the devlink port to delete.
 
+.ti -8
+.SS devlink port param set  - set new value to devlink port configuration parameter
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
@@ -262,6 +317,16 @@ Configure hardware address and also active the function. When a function is
 activated together with other configuration in a single command, all the
 configuration is applied first before changing the state to active.
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

