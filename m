Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5575D2FE8E1
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 12:34:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730518AbhAULdx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 06:33:53 -0500
Received: from mail-am6eur05on2137.outbound.protection.outlook.com ([40.107.22.137]:64736
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730285AbhAULdI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Jan 2021 06:33:08 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EMWvLH9FPB9fbDgULRK5zm8/7AMKJvDal6qGV0X/lfa6A+DV+SyX1AfXfB7qjRi/q7Y3inUq7yaXaT0h6fnfbE0HK2vuZR/sLawdf3PyQfI+PagGTa1qppQDbbTPaUjMNfdpRf1WAeOeebn3vc2ymcPBSIv82tl7PMBe8fU/aIDxJra14J4ajCKGaICRdyGlMg9g++08jV6f9upAzFvQ+QAOX8MY225TghlrGKgcVKEswNg1VhLo3cMPlb7d91uN5AMQFq6sU1XBssvI/JMpbt2N8K5SWzu+bj2SaBMeBsnVqpeLuXdzH2iWIcoeoe1GfKNW+C/BlfV71B7iorac+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oiIKSsDk5D0/lfjklN3xLyqrnezyPqqArAkkHEtSyho=;
 b=h0f80uHWyt8r1iQbqopajwxMEW2+EHv1qz+ZM97jzXF21BLsxaERusx6QaJTMaL4+4On9wX8Z2oSF7Gdwt9EdzjKr79lPJKwZeyWw4cVIakjrzkkuS2JvBNsO3YYVRPBtWAxWw3Bxefx2qDCtsrR5CmIan/O1kT94Wjw1uBP9wjivI17F9tpt9qaLsMtf4f1PZu0rAjz/2OGorH64+Fsye//kxjInC/xdbHWID+S4IVwuuCr3CsiI5RoniSCQQ2Yd32ui9MgQeVzP26WV1PDtoP2VgNTXPz/dgfOd6DhG4Gb9PkxB8CESPbgyEIEqVH0EiA5ptkp2ecA9+ytna74Tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oiIKSsDk5D0/lfjklN3xLyqrnezyPqqArAkkHEtSyho=;
 b=HKjcwLEF8p6xnF748hYfUvEt6sbtrzPPV691px/kbu49FayDj9Ns9Xw/L4Xh9zb7Xg74nJARhlZiK5qw35idnnUv/Kir3s7GXqK0ee+/9DYc9bg+khmbP0Bu1aIp8ERCxyPyxdWf/rukt17izH1golBYwh9/O826o65vwz+yEFM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=plvision.eu;
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:19b::9)
 by AM9P190MB1155.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:26e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12; Thu, 21 Jan
 2021 11:32:17 +0000
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::3011:87e8:b505:d066]) by AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::3011:87e8:b505:d066%9]) with mapi id 15.20.3784.011; Thu, 21 Jan 2021
 11:32:17 +0000
From:   Oleksandr Mazur <oleksandr.mazur@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     jiri@nvidia.com, davem@davemloft.net, linux-kernel@vger.kernel.org,
        kuba@kernel.org, Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Subject: [PATCH iproute2-next] devlink: add support for port params get/set
Date:   Thu, 21 Jan 2021 13:31:58 +0200
Message-Id: <20210121113158.31131-1-oleksandr.mazur@plvision.eu>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [77.222.147.22]
X-ClientProxiedBy: AM0PR04CA0018.eurprd04.prod.outlook.com
 (2603:10a6:208:122::31) To AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:19b::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from omazur.x.ow.s (77.222.147.22) by AM0PR04CA0018.eurprd04.prod.outlook.com (2603:10a6:208:122::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12 via Frontend Transport; Thu, 21 Jan 2021 11:32:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 61c8f457-a220-44e5-631f-08d8be003500
X-MS-TrafficTypeDiagnostic: AM9P190MB1155:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM9P190MB115592F16393DEC5CC0845F3E4A10@AM9P190MB1155.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:93;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nXWH9AybJzTm3FL5A8Z1PYJyXNECn+gSe9Q2C+FUvayfUcA+0EcwsjTpNL6iFxcK1vrETBsl8gL0uo/mfGVWvRHXVoE0m7SaxroZkaV+Tjk7XCiBN+oLwXZYDNTqmUqzzCfOME2vWx5dgFw31chZJX6bYiEmscOEzqvKZTC3YATruTxpxFg0kopgnYHxIaULm70CkPbeML7ERuVFO4KsonBEPEwH+eOPFS1CHgjp50q9kvpDp16iJVsZZWijZbh49bqf+VP5FsJgmhkhg0vLNc7kPz2wjcMOnI6lvuDghCMDfRbDHRbQtl9lriPd5KLjkNT0N2GvimyHChAkZr1TdBiQ68roqFkTzQAWMCzUgcKFGqTxMhdro9PuqaTvE6E3nVIarcG9HIHae4bUN2PSuCMEunIsRo3Av30lAvPm6xp/D9OQn5AmPv1uEwZldEHWMhVeDzkR/4B6C58OyGfRKfzZq2bOZaS6xoYQEY8ezSQw5TJvqT6hq0RJ3L6BkLuiTY34iTHy43fYCG4BrgH9Gg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0P190MB0738.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(366004)(39830400003)(396003)(376002)(346002)(136003)(4326008)(2906002)(6916009)(52116002)(1076003)(6666004)(66946007)(36756003)(8936002)(30864003)(66556008)(478600001)(86362001)(2616005)(956004)(66476007)(5660300002)(44832011)(6506007)(55236004)(316002)(8676002)(6486002)(83380400001)(107886003)(186003)(6512007)(26005)(16526019);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?QBuahyYf/9N6/kRJCH2hbIbmjQxXajnA1AVR7vaBO4UCX7TR/YfnT5MITb6X?=
 =?us-ascii?Q?EFCwS56lF6R3che+8hAxH3KbV8w6kpHZY07c6sVTaExC0NoVZCLjfhS2USlE?=
 =?us-ascii?Q?/d1uj/mnirx4p7AbZByBZOkX6BBKb8qN0Z2IalOLO+IcC+cn7LkrkeaJi3Zl?=
 =?us-ascii?Q?BdJTQE8Ek9cQMYvgukdjdWD2NeA8DJs4JdxpyC4DU+G6Hpi18DSDUOlK8DaQ?=
 =?us-ascii?Q?89Z+0CymTJQVDepoSiWwqOSbEK8XS6HdLFrDEqFpxt1UtB8HLZGI8ru737Hs?=
 =?us-ascii?Q?lhJ0CIAqBc36Xw/9MAFZJEWIdPu2Vi/dOuCw3pWjO4VwgrWbxxENMSGot5S5?=
 =?us-ascii?Q?WTK5xMJCukQAbykXkoxWCZ3xOrwVI2uJzdZrXaTGIBPfRTkwCyvfFUcBn8hV?=
 =?us-ascii?Q?W5GOX7vNjOcHQIZfhULbcftW4Fi2woc84kLISwFB0JurHtr3OFRjkMJU+9od?=
 =?us-ascii?Q?qc6/lt2YXHfyPPlDLiydeHMdraL3ImeAbFqIXs5oyzwwV3tIB6k9I70eipth?=
 =?us-ascii?Q?CZtkwOqKVtjNnDGQ72N9Eteo1gTNg6YXf8ZKoJYAHJG0T7sfsLJQA5/oxa4a?=
 =?us-ascii?Q?/o2xoTpIihVrKEneAiLShiTF+0wVcWcwVtpaFMhYNRWGNw3AZe7o6t09H2eg?=
 =?us-ascii?Q?j7VcEsQlbCqfMFwdsQdEUh9MpSiFFxrJ76avVma0FnA3e+P5ENrIadTEGHnU?=
 =?us-ascii?Q?j4G/zD70cZHzt9A2mhD0KA9tkLNdBh33b73oyXoxODd2s7WayHYPAGrfl1XA?=
 =?us-ascii?Q?lhSQTZ6ABmRAdONHsQJ3YA+QJBUUZHCoaNKJKxXq4PFVp9djfnurX79h7Xc1?=
 =?us-ascii?Q?JfYf2ObIlg3c2vxpDeo57y982gC1MqDLnNrjkdfjwjhynshryeYmazMCgyZ1?=
 =?us-ascii?Q?5IA01SnGJkCEu27s4kkSTDTbMw3kZr7j3ATr6vNHXIXs+N91PgV5uIha0lnH?=
 =?us-ascii?Q?f46jE96+naQlBu2GDJom1d2KS9tly7wIJsNbgxLsHee5Jh0sHQD3pn6Mh8oE?=
 =?us-ascii?Q?aVxu?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 61c8f457-a220-44e5-631f-08d8be003500
X-MS-Exchange-CrossTenant-AuthSource: AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2021 11:32:17.3342
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G168TZK+/Z41XrU5gFdPhZzvhIcXy4L6A8WE2uH6a7eKakjlInTHwSR/uXlQMMcxsz4GKESyV9QUFSJBfHGrfhF6Ewp4MlWhD7d16H8tPpo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9P190MB1155
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add implementation for the port (named) parameters
getting/setting.
Kernel-side already has implemented devlink port params
get / set commands handling.

Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
---
 devlink/devlink.c | 275 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 269 insertions(+), 6 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 77185f7c..6be81e92 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -2708,7 +2708,8 @@ static void pr_out_param_value(struct dl *dl, const char *nla_name,
 	}
 }
 
-static void pr_out_param(struct dl *dl, struct nlattr **tb, bool array)
+static void pr_out_param(struct dl *dl, struct nlattr **tb, bool array,
+			 bool is_port_param)
 {
 	struct nlattr *nla_param[DEVLINK_ATTR_MAX + 1] = {};
 	struct nlattr *param_value_attr;
@@ -2716,6 +2717,7 @@ static void pr_out_param(struct dl *dl, struct nlattr **tb, bool array)
 	int nla_type;
 	int err;
 
+
 	err = mnl_attr_parse_nested(tb[DEVLINK_ATTR_PARAM], attr_cb, nla_param);
 	if (err != MNL_CB_OK)
 		return;
@@ -2725,9 +2727,15 @@ static void pr_out_param(struct dl *dl, struct nlattr **tb, bool array)
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
 
@@ -2747,7 +2755,10 @@ static void pr_out_param(struct dl *dl, struct nlattr **tb, bool array)
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
@@ -2760,7 +2771,7 @@ static int cmd_dev_param_show_cb(const struct nlmsghdr *nlh, void *data)
 	if (!tb[DEVLINK_ATTR_BUS_NAME] || !tb[DEVLINK_ATTR_DEV_NAME] ||
 	    !tb[DEVLINK_ATTR_PARAM])
 		return MNL_CB_ERROR;
-	pr_out_param(dl, tb, true);
+	pr_out_param(dl, tb, true, false);
 	return MNL_CB_OK;
 }
 
@@ -2958,6 +2969,21 @@ err_param_value_parse:
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
@@ -3703,6 +3729,8 @@ static void cmd_port_help(void)
 	pr_err("       devlink port split DEV/PORT_INDEX count COUNT\n");
 	pr_err("       devlink port unsplit DEV/PORT_INDEX\n");
 	pr_err("       devlink port function set DEV/PORT_INDEX [ hw_addr ADDR ]\n");
+	pr_err("       devlink port param set DEV/PORT_INDEX name PARAMETER value VALUE cmode { permanent | driverinit | runtime }\n");
+	pr_err("       devlink port param show [DEV/PORT_INDEX name PARAMETER]\n");
 	pr_err("       devlink port health show [ DEV/PORT_INDEX reporter REPORTER_NAME ]\n");
 }
 
@@ -3937,6 +3965,31 @@ static int cmd_port_unsplit(struct dl *dl)
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
@@ -3956,6 +4009,205 @@ static int cmd_port_function_set(struct dl *dl)
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
@@ -3990,6 +4242,9 @@ static int cmd_port(struct dl *dl)
 	} else if (dl_argv_match(dl, "unsplit")) {
 		dl_arg_inc(dl);
 		return cmd_port_unsplit(dl);
+	}else if (dl_argv_match(dl, "param")) {
+		dl_arg_inc(dl);
+		return cmd_port_param(dl);
 	} else if (dl_argv_match(dl, "function")) {
 		dl_arg_inc(dl);
 		return cmd_port_function(dl);
@@ -4804,6 +5059,10 @@ static const char *cmd_name(uint8_t cmd)
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
@@ -4842,6 +5101,10 @@ static const char *cmd_obj(uint8_t cmd)
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
@@ -4984,7 +5247,7 @@ static int cmd_mon_show_cb(const struct nlmsghdr *nlh, void *data)
 		    !tb[DEVLINK_ATTR_PARAM])
 			return MNL_CB_ERROR;
 		pr_out_mon_header(genl->cmd);
-		pr_out_param(dl, tb, false);
+		pr_out_param(dl, tb, false, false);
 		pr_out_mon_footer();
 		break;
 	case DEVLINK_CMD_REGION_GET: /* fall through */
-- 
2.17.1

