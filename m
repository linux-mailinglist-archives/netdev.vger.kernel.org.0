Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0386E665F3E
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 16:37:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235124AbjAKPhB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 10:37:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232691AbjAKPg6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 10:36:58 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2075.outbound.protection.outlook.com [40.107.8.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B0A0BF77
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 07:36:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nsh8FUZTa7ls0QMplAseAOJM9HN5VLzxyr1oHOwL+TQtmnUPcSJyj5zFHXwCpLthlQH8kFbu+WhjcUcc4WsVKJyWcolOJg7KV446CXd468xuz7h7Riw80n+qElDgJLJakvl9YaMgIm68jV5s7q/6zHzbPGXNSsjxBQdnaZJMni/m5OFIvoozvfRm9zptGNgIZI1Y+Acc9Mc1r6Z9K3Wd9rjE4CPHDMuI6gTckIKPllkNHl6C/yO76zjBOqk0AyZ9j8BHyaoby2gdu5UFYQ7TSFRaLHmNNxN9EDbEPl2qSlBlPrFGuvgm103ndg25STnkiy0df4G1YH+g18AmmuLcug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u1Ds1GMVPXjIDg0qKmGQllk3nvftlSBoorLji++0ujM=;
 b=Xlr7EcT8K2nJDbcBd5ZaJHB4cyNNwei1uxx2mHYaDYz+kp5Xn279wfSHP/nVwYTDaV+Mlb2oBJLhQ5n6yJm+CCOt8xcvYhQPoPfTcNZOQKEPTB47xyCgspnGbVxOty3RIXd4YU6iqqoTedDAadjw3VZcVOknqdWsqyW9oli+kBgerAGLW6CHlBc3tUyKOSrDxTPHl5LIwYPTcgG+IA74sqD7HmCj3TZyIrHyiTbdcoQf+JYB/4rbo3tL9dWTLLdGf+Zi8jOfzSzU2+ovA/iY3P00AsGhcuscsf0McdztTen2gq3tM59piHX3AmRlvkU/0oVYsEMOBqaMrXlopA9Cmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u1Ds1GMVPXjIDg0qKmGQllk3nvftlSBoorLji++0ujM=;
 b=RrWxW1EgZuKsoQ8k5m3KfLoni3hbz4t/RwE3a7bIrTGYQeME824dfJxz6KbTFajT41pXo+xxg7jYBt0+bFkeVxP23FTj8OUn0h8Tfi9uu5E5UghJ/L8+T/7ItvcIIs5QbVlebHsXLwrKqQoD1wNvJiZOoCs/SKq2K4CDpAi2fl8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM8PR04MB7219.eurprd04.prod.outlook.com (2603:10a6:20b:1d3::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Wed, 11 Jan
 2023 15:36:55 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.5986.018; Wed, 11 Jan 2023
 15:36:55 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Michal Kubecek <mkubecek@suse.cz>,
        Jakub Kicinski <kuba@kernel.org>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>
Subject: [PATCH ethtool 2/5] netlink: add support for MAC Merge layer
Date:   Wed, 11 Jan 2023 17:36:35 +0200
Message-Id: <20230111153638.1454687-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230111153638.1454687-1-vladimir.oltean@nxp.com>
References: <20230111153638.1454687-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0090.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:78::14) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM8PR04MB7219:EE_
X-MS-Office365-Filtering-Correlation-Id: e040b851-e813-4004-25a3-08daf3e9ab10
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4Rflbtjnc1dNCHL0m9qzIzCaWvpOsgzXRRsHGRXhoJIGZqcpweGiltd3KLHZE0bYazzlRMUb6/Ti7m/xJMGMFgFnkwP943biZhqR/xgWVvj5d9Ha2FB7jeOAx4UPa9Zf8RV71aHljTVnplQCg6KYUoUJ/QzPY9WaLIdCR3cMUNRa2Sr6w4whblEVN0/q71KptAtl1ur5PQPPC32OlcDZvGCqd7pk3oUptG76z+v9yiczHHIIPA2PcFv8ojY7kKstHsKmAXB1XbmngCUL0lWd2m9IfMrvKyc14ZIjAhMmlTtUIvjkk0iVftfsJK1cOUW9seg33tCZ6X0hmAGfAuz75179kWlTs6YeAu2R9auCVpwAOrDGJzFe1HvS/4ixkSKq3d8Al/W6nZPJ1wsEh0hdBfW3zebwP+6NhxDRAuAAioH5RCspwuuXBH7viDf7DouRP3iQRJO8qk/Dm5960FQ5CEE4HoVRuA0ZctLsW8jvJrK66qEciTblA/QW96I2RhJMNsys9VEh/O459JgpObwM8o5XjuopSaie50SBereHUhpAVov2qZM9QE1Exmzpp/OfBYZrYbOnDhvbESszIDQzq95xx8A4Y+109lrSoeKLVXcY8JWkYfUiearNdvr/zEcDTktmc6YVi0cpHWv63pj4WaCqdU5R3H7XKYkhmu4RuBwVOSaguwIYmnKxb5Pvf6gO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(366004)(136003)(39860400002)(396003)(451199015)(8936002)(2906002)(5660300002)(41300700001)(45080400002)(44832011)(52116002)(4326008)(316002)(66556008)(8676002)(6916009)(66476007)(66946007)(30864003)(54906003)(26005)(6512007)(1076003)(38100700002)(2616005)(86362001)(38350700002)(186003)(83380400001)(36756003)(6506007)(6666004)(478600001)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xY6q8WyT4JlMZusfatoYMc+ymLEEDyYjqEEww5lyjwryo8Ktq66vBdAGyINS?=
 =?us-ascii?Q?/OyJXrbl8RfmQH7jw9TkwqWxm9XMppU2L3Q5bqHO8yfQjDCDWsIbyipCUdV8?=
 =?us-ascii?Q?8SlF27WqMXuuQYn5I3ZPjKffbG3IKpezUMG+NouqdLEj2++P4WW8wW+5HwXf?=
 =?us-ascii?Q?9qNz2mcT7HO9keUc0qUje9KpITqEh9UzoQ7ZoMOEU/wpEOSGId+vRpZpkAqV?=
 =?us-ascii?Q?Qk01XPu/NAhQHasc1hog37+CdaujN1hKAyF3oWdJrblcfonLOpQnH5UZIqMo?=
 =?us-ascii?Q?nCQ7tFU8t2uL9AxqbM4u9aoiGwt2uM9+8I1BeOz1yweQii3lVAbHgxwwAR5h?=
 =?us-ascii?Q?V2V8hpZ7qaHFSj47Y+HTwsHAktIn7Axl5+e/Yqv8qp1Qb6A6e+FdlEjrKbah?=
 =?us-ascii?Q?xWSUT1LGesbphPU7xMB1+R13hbcUulmFJFt2bp8gPPV63EoSlWO5KorXM6iy?=
 =?us-ascii?Q?noTnf2dY78faF6zJSTmvmFXArIQ7oEHxj4eFJof+0R8tIMtzuEZc6gM7Kzku?=
 =?us-ascii?Q?ug/fdCLOFfta5c8S4W0DFEAB+FRc2RQybIzBwJN+bFnJW0X2RNcG3edFlnfD?=
 =?us-ascii?Q?y4yZQinhkdNuDFPjBWhDJaQY6wlkOFXxzD6fnBMMZV3n26Z2yc6t5FkHN0rq?=
 =?us-ascii?Q?pctd9eDWWP1dgD3WwhR2UDpYOdVKep/ry4XujLJCIEE879saf9x4J8sf8jBx?=
 =?us-ascii?Q?ILx2TUjOeXEXqSvTLB8wzsyfQtenATRA2Q34Gxqpm+f7262NdwtVJU2SmKUh?=
 =?us-ascii?Q?vqbn/yp93ejImNxIf/MgVixCTa12tpLrw8y3/CCE2UC5CY9rWt5pMMXxgusY?=
 =?us-ascii?Q?FblJi4aDg0sy1pP/F8u387OGoCijsO9Zr3ROJ3SGsu5xEcSxug3pInmxX1gi?=
 =?us-ascii?Q?AbDBJRQ9nK2hU+g74wrn6oIwXTHRdP4/vUpTk/jHIYPvu9Lutd5JjWKnmZ9J?=
 =?us-ascii?Q?UjKw8iEWo4lRfLF9drnlF38wU2ygG0dUJ4v2Vkyr0vKGl3BkcptiQ3bnE0bP?=
 =?us-ascii?Q?h8rhHKIr/mNY/b4edJkl9HH9iaD1NgaG4T9r/QHh2/QLqnPdVNzEPxvNnwEC?=
 =?us-ascii?Q?4Ge5BZ14WZwoaA6nXvbwmNiNvfNqTlQLQnx8lFgzfkg3eBOP9Yw/J59DJ1H8?=
 =?us-ascii?Q?mA7cWntAVNNjjsUaJG2puJyAsVluRWNMG1B/uTW/B5yZhlSsH6aoIgcOCkcE?=
 =?us-ascii?Q?GT6T5xl5EXKoALXVmgKSjAM4d8F9d2EnKpQEKn87kqYEoiIOH85mfAcTBiOO?=
 =?us-ascii?Q?1W41Siu0cFrp4pOVAg2qk4VJwub75nMS3kRUQqDolsJinYwE/JIQnEElsGqj?=
 =?us-ascii?Q?9zQj6JJCwFyEjzagOcXQ5pvZIItyN4dUhOCmz1tSRklUCFFunoAhSJsWNbKP?=
 =?us-ascii?Q?bXC8P8mR5n9a3j0CyTx+IYMU5RSSbtAOSlE8U5su2qxcpVSvichyeU6Dc46x?=
 =?us-ascii?Q?wUxZH82ldOLPFYqjtCKR91lthdn0VHuUca9/H+9bK9urtH5cI6LCbLIHtzNc?=
 =?us-ascii?Q?EPyASm83p9IYAZmzS1I2ijeam6AdKi24IfrnlnHrPbfC7JaIn/tIrmNw0jYg?=
 =?us-ascii?Q?JQ12ahRdGTrljsf9QN5rBqeK+PTJXUFqtPhWB3ilKa29vO+usJBtlaDKH+M9?=
 =?us-ascii?Q?WQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e040b851-e813-4004-25a3-08daf3e9ab10
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2023 15:36:55.2206
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iRHHYf7+aaTDjhIadr5PF+1ikKMt0IkpIlu/yE32s9JlnjAqkTf1JcMyVkM+UbVXQjQONHZZxBO8nKdnAT3ELw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7219
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

$ ethtool --include-statistics --show-mm eno0
MAC merge layer state for eno0:
MAC merge supported: on
pMAC enabled: on
TX enabled: on
TX active: on
addFragSize: 60
Verify enabled: off
Verify time: 127 ms
Max verify time: 127 ms
Verification status: SUCCEEDED
Statistics:
  MACMergeFrameAssErrorCount: 0
  MACMergeFrameSmdErrorCount: 0
  MACMergeFrameAssOkCount: 0
  MACMergeFragCountRx: 0
  MACMergeFragCountTx: 0
  MACMergeHoldCount: 0

$ ethtool --include-statistics --json --show-mm eno0
[ {
        "ifname": "eno0",
        "supported": true,
        "pmac-enabled": true,
        "tx-enabled": true,
        "tx-active": true,
        "add-frag-size": 60,
        "verify-enabled": true,
        "verify-time": 127,
        "max-verify-time": 127,
        "verify-status": "SUCCEEDED",
        "statistics": {
            "MACMergeFrameAssErrorCount": 0,
            "MACMergeFrameSmdErrorCount": 0,
            "MACMergeFrameAssOkCount": 0,
            "MACMergeFragCountRx": 0,
            "MACMergeFragCountTx": 0,
            "MACMergeHoldCount": 0
        }
    } ]

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 Makefile.am            |   2 +-
 ethtool.c              |  14 +++
 json_print.c           |   4 +-
 netlink/desc-ethtool.c |  29 +++++
 netlink/extapi.h       |   4 +
 netlink/mm.c           | 270 +++++++++++++++++++++++++++++++++++++++++
 netlink/netlink.h      |  34 ++++++
 netlink/parser.c       |   6 +-
 netlink/parser.h       |   4 +
 9 files changed, 361 insertions(+), 6 deletions(-)
 create mode 100644 netlink/mm.c

diff --git a/Makefile.am b/Makefile.am
index 663f40a07b7d..2c02e8182955 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -37,7 +37,7 @@ ethtool_SOURCES += \
 		  netlink/features.c netlink/privflags.c netlink/rings.c \
 		  netlink/channels.c netlink/coalesce.c netlink/pause.c \
 		  netlink/eee.c netlink/tsinfo.c netlink/fec.c \
-		  netlink/stats.c \
+		  netlink/stats.c netlink/mm.c \
 		  netlink/desc-ethtool.c netlink/desc-genlctrl.c \
 		  netlink/module-eeprom.c netlink/module.c \
 		  netlink/desc-rtnl.c netlink/cable_test.c netlink/tunnels.c \
diff --git a/ethtool.c b/ethtool.c
index 60da8aff407d..6edb84457aa9 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -6096,6 +6096,20 @@ static const struct option args[] = {
 		.help	= "Set transceiver module settings",
 		.xhelp	= "		[ power-mode-policy high|auto ]\n"
 	},
+	{
+		.opts	= "--show-mm",
+		.json	= true,
+		.nlfunc	= nl_get_mm,
+		.help	= "Show MAC merge layer state",
+	},
+	{
+		.opts	= "--set-mm",
+		.nlfunc	= nl_set_mm,
+		.help	= "Set MAC merge layer parameters",
+			  "		[ verify-disable on|off ]\n"
+			  "		[ enabled on|off ]\n"
+			  "		[ add-frag-size 0|1|2|3 ]\n"
+	},
 	{
 		.opts	= "-h|--help",
 		.no_dev	= true,
diff --git a/json_print.c b/json_print.c
index 4f62767bdbc9..ab747eeaf023 100644
--- a/json_print.c
+++ b/json_print.c
@@ -81,7 +81,7 @@ void open_json_array(const char *key, const char *str)
 		if (key)
 			jsonw_name(_jw, key);
 		jsonw_start_array(_jw);
-	} else {
+	} else if (str) {
 		printf("%s", str);
 	}
 }
@@ -93,7 +93,7 @@ void close_json_array(const char *delim)
 {
 	if (is_json_context())
 		jsonw_end_array(_jw);
-	else
+	else if (delim)
 		printf("%s", delim);
 }
 
diff --git a/netlink/desc-ethtool.c b/netlink/desc-ethtool.c
index b3ac64d1e593..c4e9ccb23673 100644
--- a/netlink/desc-ethtool.c
+++ b/netlink/desc-ethtool.c
@@ -442,6 +442,31 @@ static const struct pretty_nla_desc __pse_desc[] = {
 	NLATTR_DESC_U32_ENUM(ETHTOOL_A_PODL_PSE_PW_D_STATUS, pse_pw_d_status),
 };
 
+static const struct pretty_nla_desc __mm_stats_desc[] = {
+	NLATTR_DESC_BINARY(ETHTOOL_A_MM_STAT_PAD),
+	NLATTR_DESC_U64(ETHTOOL_A_MM_STAT_REASSEMBLY_ERRORS),
+	NLATTR_DESC_U64(ETHTOOL_A_MM_STAT_SMD_ERRORS),
+	NLATTR_DESC_U64(ETHTOOL_A_MM_STAT_REASSEMBLY_OK),
+	NLATTR_DESC_U64(ETHTOOL_A_MM_STAT_RX_FRAG_COUNT),
+	NLATTR_DESC_U64(ETHTOOL_A_MM_STAT_TX_FRAG_COUNT),
+	NLATTR_DESC_U64(ETHTOOL_A_MM_STAT_HOLD_COUNT),
+};
+
+static const struct pretty_nla_desc __mm_desc[] = {
+	NLATTR_DESC_INVALID(ETHTOOL_A_MM_UNSPEC),
+	NLATTR_DESC_NESTED(ETHTOOL_A_MM_HEADER, header),
+	NLATTR_DESC_U8(ETHTOOL_A_MM_VERIFY_STATUS),
+	NLATTR_DESC_U8(ETHTOOL_A_MM_VERIFY_ENABLED),
+	NLATTR_DESC_U32(ETHTOOL_A_MM_VERIFY_TIME),
+	NLATTR_DESC_U32(ETHTOOL_A_MM_MAX_VERIFY_TIME),
+	NLATTR_DESC_U8(ETHTOOL_A_MM_SUPPORTED),
+	NLATTR_DESC_U8(ETHTOOL_A_MM_TX_ENABLED),
+	NLATTR_DESC_U8(ETHTOOL_A_MM_TX_ACTIVE),
+	NLATTR_DESC_U8(ETHTOOL_A_MM_PMAC_ENABLED),
+	NLATTR_DESC_U32(ETHTOOL_A_MM_ADD_FRAG_SIZE),
+	NLATTR_DESC_NESTED(ETHTOOL_A_MM_STATS, mm_stats),
+};
+
 const struct pretty_nlmsg_desc ethnl_umsg_desc[] = {
 	NLMSG_DESC_INVALID(ETHTOOL_MSG_USER_NONE),
 	NLMSG_DESC(ETHTOOL_MSG_STRSET_GET, strset),
@@ -481,6 +506,8 @@ const struct pretty_nlmsg_desc ethnl_umsg_desc[] = {
 	NLMSG_DESC(ETHTOOL_MSG_MODULE_SET, module),
 	NLMSG_DESC(ETHTOOL_MSG_PSE_GET, pse),
 	NLMSG_DESC(ETHTOOL_MSG_PSE_SET, pse),
+	NLMSG_DESC(ETHTOOL_MSG_MM_GET, mm),
+	NLMSG_DESC(ETHTOOL_MSG_MM_SET, mm),
 };
 
 const unsigned int ethnl_umsg_n_desc = ARRAY_SIZE(ethnl_umsg_desc);
@@ -524,6 +551,8 @@ const struct pretty_nlmsg_desc ethnl_kmsg_desc[] = {
 	NLMSG_DESC(ETHTOOL_MSG_MODULE_GET_REPLY, module),
 	NLMSG_DESC(ETHTOOL_MSG_MODULE_NTF, module),
 	NLMSG_DESC(ETHTOOL_MSG_PSE_GET_REPLY, pse),
+	NLMSG_DESC(ETHTOOL_MSG_MM_GET_REPLY, mm),
+	NLMSG_DESC(ETHTOOL_MSG_MM_NTF, mm),
 };
 
 const unsigned int ethnl_kmsg_n_desc = ARRAY_SIZE(ethnl_kmsg_desc);
diff --git a/netlink/extapi.h b/netlink/extapi.h
index 1bb580a889a8..50464c7c920c 100644
--- a/netlink/extapi.h
+++ b/netlink/extapi.h
@@ -47,6 +47,8 @@ int nl_gmodule(struct cmd_context *ctx);
 int nl_smodule(struct cmd_context *ctx);
 int nl_monitor(struct cmd_context *ctx);
 int nl_getmodule(struct cmd_context *ctx);
+int nl_get_mm(struct cmd_context *ctx);
+int nl_set_mm(struct cmd_context *ctx);
 
 void nl_monitor_usage(void);
 
@@ -114,6 +116,8 @@ nl_get_eeprom_page(struct cmd_context *ctx __maybe_unused,
 #define nl_getmodule		NULL
 #define nl_gmodule		NULL
 #define nl_smodule		NULL
+#define nl_get_mm		NULL
+#define nl_set_mm		NULL
 
 #endif /* ETHTOOL_ENABLE_NETLINK */
 
diff --git a/netlink/mm.c b/netlink/mm.c
new file mode 100644
index 000000000000..2c10325776df
--- /dev/null
+++ b/netlink/mm.c
@@ -0,0 +1,270 @@
+/*
+ * mm.c - netlink implementation of MAC merge layer settings
+ *
+ * Implementation of "ethtool --show-mm <dev>" and "ethtool --set-mm <dev> ..."
+ */
+
+#include <errno.h>
+#include <inttypes.h>
+#include <string.h>
+#include <stdio.h>
+
+#include "../internal.h"
+#include "../common.h"
+#include "netlink.h"
+#include "bitset.h"
+#include "parser.h"
+
+/* MM_GET */
+
+static const char *
+mm_verify_state_to_string(enum ethtool_mm_verify_status state)
+{
+	switch (state) {
+	case ETHTOOL_MM_VERIFY_STATUS_INITIAL:
+		return "INITIAL";
+	case ETHTOOL_MM_VERIFY_STATUS_VERIFYING:
+		return "VERIFYING";
+	case ETHTOOL_MM_VERIFY_STATUS_SUCCEEDED:
+		return "SUCCEEDED";
+	case ETHTOOL_MM_VERIFY_STATUS_FAILED:
+		return "FAILED";
+	case ETHTOOL_MM_VERIFY_STATUS_DISABLED:
+		return "DISABLED";
+	default:
+		return "UNKNOWN";
+	}
+}
+
+static int show_mm_stats(const struct nlattr *nest)
+{
+	const struct nlattr *tb[ETHTOOL_A_MM_STAT_MAX + 1] = {};
+	DECLARE_ATTR_TB_INFO(tb);
+	static const struct {
+		unsigned int attr;
+		char *name;
+	} stats[] = {
+		{ ETHTOOL_A_MM_STAT_REASSEMBLY_ERRORS, "MACMergeFrameAssErrorCount" },
+		{ ETHTOOL_A_MM_STAT_SMD_ERRORS, "MACMergeFrameSmdErrorCount" },
+		{ ETHTOOL_A_MM_STAT_REASSEMBLY_OK, "MACMergeFrameAssOkCount" },
+		{ ETHTOOL_A_MM_STAT_RX_FRAG_COUNT, "MACMergeFragCountRx" },
+		{ ETHTOOL_A_MM_STAT_TX_FRAG_COUNT, "MACMergeFragCountTx" },
+		{ ETHTOOL_A_MM_STAT_HOLD_COUNT, "MACMergeHoldCount" },
+	};
+	bool header = false;
+	unsigned int i;
+	size_t n;
+	int ret;
+
+	ret = mnl_attr_parse_nested(nest, attr_cb, &tb_info);
+	if (ret < 0)
+		return ret;
+
+	open_json_object("statistics");
+	for (i = 0; i < ARRAY_SIZE(stats); i++) {
+		char fmt[64];
+
+		if (!tb[stats[i].attr])
+			continue;
+
+		if (!header && !is_json_context()) {
+			printf("Statistics:\n");
+			header = true;
+		}
+
+		if (mnl_attr_validate(tb[stats[i].attr], MNL_TYPE_U64)) {
+			fprintf(stderr, "malformed netlink message (statistic)\n");
+			goto err_close_stats;
+		}
+
+		n = snprintf(fmt, sizeof(fmt), "  %s: %%" PRIu64 "\n",
+			     stats[i].name);
+		if (n >= sizeof(fmt)) {
+			fprintf(stderr, "internal error - malformed label\n");
+			continue;
+		}
+
+		print_u64(PRINT_ANY, stats[i].name, fmt,
+			  mnl_attr_get_u64(tb[stats[i].attr]));
+	}
+	close_json_object();
+
+	return 0;
+
+err_close_stats:
+	close_json_object();
+	return -1;
+}
+
+int mm_reply_cb(const struct nlmsghdr *nlhdr, void *data)
+{
+	const struct nlattr *tb[ETHTOOL_A_MM_MAX + 1] = {};
+	struct nl_context *nlctx = data;
+	DECLARE_ATTR_TB_INFO(tb);
+	bool silent;
+	int err_ret;
+	int ret;
+
+	silent = nlctx->is_dump || nlctx->is_monitor;
+	err_ret = silent ? MNL_CB_OK : MNL_CB_ERROR;
+	ret = mnl_attr_parse(nlhdr, GENL_HDRLEN, attr_cb, &tb_info);
+	if (ret < 0)
+		return err_ret;
+	nlctx->devname = get_dev_name(tb[ETHTOOL_A_MM_HEADER]);
+	if (!dev_ok(nlctx))
+		return err_ret;
+
+	if (silent)
+		print_nl();
+
+	open_json_object(NULL);
+
+	print_string(PRINT_ANY, "ifname", "MAC merge layer state for %s:\n",
+		     nlctx->devname);
+
+	show_bool("supported", "MAC merge supported: %s\n",
+		  tb[ETHTOOL_A_MM_SUPPORTED]);
+	show_bool("pmac-enabled", "pMAC enabled: %s\n",
+		  tb[ETHTOOL_A_MM_PMAC_ENABLED]);
+	show_bool("tx-enabled", "TX enabled: %s\n",
+		  tb[ETHTOOL_A_MM_TX_ENABLED]);
+	show_bool("tx-active", "TX active: %s\n", tb[ETHTOOL_A_MM_TX_ACTIVE]);
+	show_u32_json("add-frag-size", "addFragSize: %u\n",
+		      tb[ETHTOOL_A_MM_ADD_FRAG_SIZE]);
+	show_bool("verify-enabled", "Verify enabled: %s\n",
+		  tb[ETHTOOL_A_MM_VERIFY_ENABLED]);
+	show_u32_json("verify-time", "Verify time: %u ms\n",
+		      tb[ETHTOOL_A_MM_VERIFY_TIME]);
+	show_u32_json("max-verify-time", "Max verify time: %u ms\n",
+		      tb[ETHTOOL_A_MM_MAX_VERIFY_TIME]);
+
+	if (tb[ETHTOOL_A_MM_VERIFY_STATUS]) {
+		u8 val = mnl_attr_get_u8(tb[ETHTOOL_A_MM_VERIFY_STATUS]);
+
+		print_string(PRINT_ANY, "verify-status", "Verification status: %s\n",
+			     mm_verify_state_to_string(val));
+	}
+
+	if (tb[ETHTOOL_A_MM_STATS]) {
+		ret = show_mm_stats(tb[ETHTOOL_A_MM_STATS]);
+		if (ret) {
+			fprintf(stderr, "Failed to print stats: %d\n", ret);
+			goto err;
+		}
+	}
+
+	if (!silent)
+		print_nl();
+
+	close_json_object();
+
+	return MNL_CB_OK;
+
+err:
+	close_json_object();
+	return err_ret;
+}
+
+int nl_get_mm(struct cmd_context *ctx)
+{
+	struct nl_context *nlctx = ctx->nlctx;
+	struct nl_socket *nlsk = nlctx->ethnl_socket;
+	u32 flags;
+	int ret;
+
+	if (netlink_cmd_check(ctx, ETHTOOL_MSG_MM_GET, true))
+		return -EOPNOTSUPP;
+	if (ctx->argc > 0) {
+		fprintf(stderr, "ethtool: unexpected parameter '%s'\n",
+			*ctx->argp);
+		return 1;
+	}
+
+	flags = get_stats_flag(nlctx, ETHTOOL_MSG_MM_GET, ETHTOOL_A_MM_HEADER);
+	ret = nlsock_prep_get_request(nlsk, ETHTOOL_MSG_MM_GET,
+				      ETHTOOL_A_MM_HEADER, flags);
+	if (ret)
+		return ret;
+
+	new_json_obj(ctx->json);
+	ret = nlsock_send_get_request(nlsk, mm_reply_cb);
+	delete_json_obj();
+	return ret;
+}
+
+/* MM_SET */
+
+static const struct param_parser mm_set_params[] = {
+	{
+		.arg		= "verify-enabled",
+		.type		= ETHTOOL_A_MM_VERIFY_ENABLED,
+		.handler	= nl_parse_u8bool,
+		.min_argc	= 1,
+	},
+	{
+		.arg		= "verify-time",
+		.type		= ETHTOOL_A_MM_VERIFY_TIME,
+		.handler	= nl_parse_direct_u32,
+		.min_argc	= 1,
+	},
+	{
+		.arg		= "tx-enabled",
+		.type		= ETHTOOL_A_MM_TX_ENABLED,
+		.handler	= nl_parse_u8bool,
+		.min_argc	= 1,
+	},
+	{
+		.arg		= "pmac-enabled",
+		.type		= ETHTOOL_A_MM_PMAC_ENABLED,
+		.handler	= nl_parse_u8bool,
+		.min_argc	= 1,
+	},
+	{
+		.arg		= "add-frag-size",
+		.type		= ETHTOOL_A_MM_ADD_FRAG_SIZE,
+		.handler	= nl_parse_direct_u32,
+		.min_argc	= 1,
+	},
+	{}
+};
+
+int nl_set_mm(struct cmd_context *ctx)
+{
+	struct nl_context *nlctx = ctx->nlctx;
+	struct nl_msg_buff *msgbuff;
+	struct nl_socket *nlsk;
+	int ret;
+
+	if (netlink_cmd_check(ctx, ETHTOOL_MSG_MM_SET, false))
+		return -EOPNOTSUPP;
+
+	nlctx->cmd = "--set-mm";
+	nlctx->argp = ctx->argp;
+	nlctx->argc = ctx->argc;
+	nlctx->devname = ctx->devname;
+	nlsk = nlctx->ethnl_socket;
+	msgbuff = &nlsk->msgbuff;
+
+	ret = msg_init(nlctx, msgbuff, ETHTOOL_MSG_MM_SET,
+		       NLM_F_REQUEST | NLM_F_ACK);
+	if (ret)
+		return ret;
+
+	if (ethnla_fill_header(msgbuff, ETHTOOL_A_MM_HEADER,
+			       ctx->devname, 0))
+		return -EMSGSIZE;
+
+	ret = nl_parser(nlctx, mm_set_params, NULL, PARSER_GROUP_NONE, NULL);
+	if (ret)
+		return ret;
+
+	ret = nlsock_sendmsg(nlsk, NULL);
+	if (ret < 0)
+		return ret;
+
+	ret = nlsock_process_reply(nlsk, nomsg_reply_cb, nlctx);
+	if (ret)
+		return nlctx->exit_code;
+
+	return 0;
+}
diff --git a/netlink/netlink.h b/netlink/netlink.h
index 3240fca74f0d..01201aacc73e 100644
--- a/netlink/netlink.h
+++ b/netlink/netlink.h
@@ -100,6 +100,40 @@ int dump_link_modes(struct nl_context *nlctx, const struct nlattr *bitset,
 		    const char *between, const char *after,
 		    const char *if_none);
 
+static inline void show_u8_val(const char *key, const char *fmt, uint8_t *val)
+{
+	if (is_json_context()) {
+		if (val)
+			print_uint(PRINT_JSON, key, NULL, *val);
+	} else {
+		if (val)
+			print_uint(PRINT_FP, NULL, fmt, *val);
+	}
+}
+
+static inline void show_u8(const char *key, const char *fmt,
+			   const struct nlattr *attr)
+{
+	show_u8_val(key, fmt, attr ? mnl_attr_get_payload(attr) : NULL);
+}
+
+static inline void show_u32_val(const char *key, const char *fmt, uint32_t *val)
+{
+	if (is_json_context()) {
+		if (val)
+			print_uint(PRINT_JSON, key, NULL, *val);
+	} else {
+		if (val)
+			print_uint(PRINT_FP, NULL, fmt, *val);
+	}
+}
+
+static inline void show_u32_json(const char *key, const char *fmt,
+				 const struct nlattr *attr)
+{
+	show_u32_val(key, fmt, attr ? mnl_attr_get_payload(attr) : NULL);
+}
+
 static inline void show_u32(const char *key,
 			    const char *fmt,
 			    const struct nlattr *attr)
diff --git a/netlink/parser.c b/netlink/parser.c
index f982f229a040..d6090915ec48 100644
--- a/netlink/parser.c
+++ b/netlink/parser.c
@@ -37,7 +37,7 @@ static void parser_err_min_argc(struct nl_context *nlctx, unsigned int min_argc)
 			nlctx->cmd, nlctx->param, min_argc);
 }
 
-static void parser_err_invalid_value(struct nl_context *nlctx, const char *val)
+void parser_err_invalid_value(struct nl_context *nlctx, const char *val)
 {
 	fprintf(stderr, "ethtool (%s): invalid value '%s' for parameter '%s'\n",
 		nlctx->cmd, val, nlctx->param);
@@ -136,8 +136,8 @@ static int lookup_u32(const char *arg, uint32_t *result,
 	return -EINVAL;
 }
 
-static int lookup_u8(const char *arg, uint8_t *result,
-		     const struct lookup_entry_u8 *tbl)
+int lookup_u8(const char *arg, uint8_t *result,
+	      const struct lookup_entry_u8 *tbl)
 {
 	if (!arg)
 		return -EINVAL;
diff --git a/netlink/parser.h b/netlink/parser.h
index 8a4e8afa410b..a3c73138b9f2 100644
--- a/netlink/parser.h
+++ b/netlink/parser.h
@@ -99,6 +99,10 @@ struct char_bitset_parser_data {
 
 int parse_u32(const char *arg, uint32_t *result);
 
+int lookup_u8(const char *arg, uint8_t *result,
+	      const struct lookup_entry_u8 *tbl);
+void parser_err_invalid_value(struct nl_context *nlctx, const char *val);
+
 /* parser handlers to use as param_parser::handler */
 
 /* NLA_FLAG represented by on | off */
-- 
2.34.1

