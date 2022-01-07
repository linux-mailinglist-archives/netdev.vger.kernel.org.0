Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E92DF48796F
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 16:01:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348019AbiAGPBe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 10:01:34 -0500
Received: from mail-am6eur05on2056.outbound.protection.outlook.com ([40.107.22.56]:26369
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1347994AbiAGPBX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jan 2022 10:01:23 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fwt7cmmiPLVNl42yHH06zrO+4Ply0SY5Xyq2Fdde1dkWuvuGikNGutSLMA0LkqM5CQ8fPsjmosB7hCA6KGUHcVo+zbkNGu/ehTWWFrK3aVr6xj7EWTxIUcX3T32F/1yagvw67tiHSe7+BHRzxSXSBZPkjum25lUslGDg1vjCZkNJJO9Iw/c83wmUpPdctLb577Dzk2aj/VguCsGq0Lot70SvKE71qYR0jx22F3MaAOuo8K5DISTXAbr/vkE+TcFIqup4a+W2STuVVq+NsdJlLH5KClLq7SWPaG1KA770vCYtqwz6ss7BLK4j8rVxAO4f8Lc4ZYGpOiJcTmGgi2fnbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4yxIoFwOPXqJ0tMuwEdxcuEVKnjyvrqgot0Mir0yBhw=;
 b=aRLFbzD+uFLp0R6pmciMbR+ZT8hNJCD8eetgNXMdha++FE9XzYa/b8utD3SBd7W5U0lYsjboasR50fmFs71ILM1NahhiVDq+DxuPqhjd+hFzeD9IUTQW7dz0mSM+BYRjr9KFmU9wbHyH1U73SVN5vDqVZTzmzjaV17mGgAd3i693AKqBi5rlwOTnamdhNTys94QbEbeOz6B17fyGR6GEaLRMfyJoUhQu8mtpnf79WXDAVdpZGDotoEQ26mTzjohypRrrD+NFQAQNR2VHciqR/PA/mqNEyEFgR0677kt02eBX+4F76uNOW1CNqmajwePFIy2aKpdHM0WSdysBlnxPRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4yxIoFwOPXqJ0tMuwEdxcuEVKnjyvrqgot0Mir0yBhw=;
 b=IPtW8qjGsUPbOxBmvXBcH/RxzoJqDkRBZ5vElIlJDK2u+3eYoCuS0xJ6oT071GHISfT98oY6oCsKHRNTx8+lj4ooXL4x19Oop74T0ntuUZ8CpjhheTllfWhhDEYrFByliuqn3pFPdgb9Ce6v+DlnFcPdANNFeblmsEH2SyvtNW8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3408.eurprd04.prod.outlook.com (2603:10a6:803:9::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Fri, 7 Jan
 2022 15:01:11 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4844.017; Fri, 7 Jan 2022
 15:01:11 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        DENG Qingfang <dqfext@gmail.com>
Subject: [RFC PATCH net-next 05/12] net: dsa: mv88e6xxx: use dsa_switch_for_each_port in mv88e6xxx_lag_sync_masks
Date:   Fri,  7 Jan 2022 17:00:49 +0200
Message-Id: <20220107150056.250437-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220107150056.250437-1-vladimir.oltean@nxp.com>
References: <20220107150056.250437-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0059.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:49::7) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f0a71f46-bce5-4792-9609-08d9d1ee8ade
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3408:EE_
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3408A3A14DA23DD3D33FBD38E04D9@VI1PR0402MB3408.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ixAWbJG7r9pqln0hj39iFo+nJ1jRhW9FDFnzI9gnB+44C3NVA2yxZcUHPz98Q7P8ONr/mOVofDyTgbN/S56Yt30T+ZS65UXx4wKqVQDFwvAuVTwYESdO+fmDmNiIk3hd+08nDLV/ziIj6Tr1ixTahxJhCpbKVqW6m3XNoWw4W831uwJ3Q1u/oRHcsILDK/6CrbuWTCmoKymiaOnz9dZvrt3IH1YRYMuKeHemqM/kfzo5x270CRvDtrsRsPk5FUSILeb+9KV93sugTwybKkaHpJqe83jj9Q6sWkpMEUq8WRkC9E6GUSACymFPqV1EgdK0myQlL6P7gkU6cAZqfXsUh80zNkQAeZPd2EM1V7wvz9VZk4q41Sk0mCI/E2Vc6DvNmz33HM9s1E/+NVXbjrioeY7TsN6APPmG1+lCns3mhNXpOgcWXnc6kGe7OZ7t5XDy/ODHumvslczEXIWUQ9uVYp6iHQlJPu8X8AT6jhVu97Ig/Skc7KbW++ojWtn2d9re7j5+DmZEtChbSLGvoJn5boKCN0XoDeIam8CAiwQPnnA0dOOWC5B4IJUKIHXwYGBHYImQr+Ts4fGH9TaS+iqwoIQic1OWkcZAnqgc1axGQhcjmWF/VHq49mqm10EUggY+wLC4sxcmrPv/UamuoJ9KvI7tK5NnBrH4DyDHAdjACHcICKCykQPJKvtWtdB+pxhOTywuZv4AUxdEAl/Llp0low==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(26005)(5660300002)(1076003)(8936002)(6512007)(8676002)(2906002)(44832011)(4326008)(86362001)(4744005)(38100700002)(316002)(2616005)(36756003)(6916009)(6666004)(83380400001)(54906003)(508600001)(6486002)(186003)(6506007)(52116002)(66556008)(66476007)(66946007)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UafVZuD+IRzi1Rw1ZVWnhwgYwruDJ7fIEqtIYLFGH8c+k5AlELY5KvUtH7oW?=
 =?us-ascii?Q?mjlPOR5P+9k8f+9plH9jPt5lAoT1aQsk3FKclSwtmXuwbFCBWKeROL1bNOjE?=
 =?us-ascii?Q?zeKZGvOLKj9Bun7KVSrzpMfx5ejobzfE/xOYFgl3Apu6jLN+Pphq7zs4vFsJ?=
 =?us-ascii?Q?BUZXOF+vIsqgcPonlz9bj8q/7Il4c+GEdwNfbH8HgiYJfYvvUqz/uBhYf7d8?=
 =?us-ascii?Q?4pRF6ecFj9zbtqZoOSdc9pZa4/QC8Qoub9YVmjTyKaIFp1X4FMG+7V6s9WaD?=
 =?us-ascii?Q?4II+s6QqN1Mv4ZZscheC88aiysL1QZ7mhGYS4+4WcmASIh69WChZU+Ix7/we?=
 =?us-ascii?Q?NsX5x9x77RHPyorl6On9QCQD2NShY1ORvm9lTlKA3ELByJ/ZiPYMe4/2vRZT?=
 =?us-ascii?Q?uVQ8XYZFHUdK/aQHMpLVBafr2R0LHZ2G9T2je6Bu59qc+rid4zOBXwfMKkrd?=
 =?us-ascii?Q?/G7+/gqbMONjLh5tI4m7o5AOVEHaLxwkZ0uNkevBHCvC+yjUq1AKO2kk+Mg1?=
 =?us-ascii?Q?mYTPy1dwfu39cbURPM16dKCFSHkq5cEBUam0yUwCWl8Koxlzk78mi0i6kmA2?=
 =?us-ascii?Q?NoSVl8MDhI8mEetliDohf6Y6bSiHVxEhewVEEX/BeRErV/V1/PDaC4dNyh7q?=
 =?us-ascii?Q?G+byleaUZTcN9dbCXSZ4PLwYpnaquhIS2fjnGnNXSk0uRANYqZVFpBskxhIr?=
 =?us-ascii?Q?aaDbddUywGpbp6Nv7M5THyF0hshv7z+Ve81RkDMozV5n2Lij5941bqPnIlRO?=
 =?us-ascii?Q?UW4qJfZFfoTu62WAB/UbSK0UDxAQkXDcqHqyNKQlQlg33I6FLrwYZodHIIXV?=
 =?us-ascii?Q?eMKE8qF30s1BS/Nq+2f8KJv176UpaspRUVAGV6J/8dFM5T65emgCEK+G9GWu?=
 =?us-ascii?Q?x3eBjrILn+d+3keYsjqAZITuM3UO29EZ/pIhWnrdxUcmR3yz5eJXdQHcFuu5?=
 =?us-ascii?Q?DcxTGCslm+C3nFljbpEWAvbf1xWzEIo0Lg1r20yx6BgXrikRcyB3NvvZjHDa?=
 =?us-ascii?Q?MyKYjPP935K9UzHfu49c5B3dWGFb8+UfNONIKrCl1QXy5sJYww0LrK/3vNh+?=
 =?us-ascii?Q?4bfG95wubW7jp+bAMS8+cfEvUCfXANxy0FxVgY8rM8oC8m+l1n884hYoZ8Gf?=
 =?us-ascii?Q?cYeqxFoh++Xq6AYd+T2szMEZF5t++ChI+qQVt51Z96iuyS9SbhhH6qBu00rW?=
 =?us-ascii?Q?0usgfSaUVtn/NEMX6w1jKh1N/1vhxY3u3HoJeXzw1ygNC+bdY6E2aIWDqgEw?=
 =?us-ascii?Q?Dayhjp7TNMljtDOrnt0A7G0ZY3qdvOn+hrkKJKweYpjzuGVZGFDbUZjhyxSv?=
 =?us-ascii?Q?ygM2DzZ4Su3zrnEFAmrAzXFFwu7MNSUr3lrJd4wTaSQJORQA9TNZ4DbiNy9h?=
 =?us-ascii?Q?yxG5Up/dwZJ0+M9OQ5i1PZLdrjSRD0CjeVUP3BQmJ+mVMKqWyjBKoj897/ru?=
 =?us-ascii?Q?eQyo5W4O8c9LVjk/FiJ6u3HHZHYWeT/w7Bn3G4kiTA2RsvGbU77PzgGKD0zR?=
 =?us-ascii?Q?2MoWZ/dbjsdwaH1aYWxs9bBknUfRXidSRpv5qUs6iS9hDSrm15o46YgqdwV4?=
 =?us-ascii?Q?4S6jsB2NEQw8vopmPlX1I24RT+prrKKTm+DAzS1tP/Y7ybpZ7nt3n8l4EC0K?=
 =?us-ascii?Q?h8XbdToWlfch9gr6qWZhm2Q=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0a71f46-bce5-4792-9609-08d9d1ee8ade
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2022 15:01:11.3931
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G3nmiJOrflIEyTuNSal5rgohwdzYKb0eUEfKtw2/QllcsbkP5+fQfxCtpGrUHZ27VY+clLFK9siiG4zvTrTmKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3408
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make the intent of the code more clear by using the dedicated helper for
iterating over the ports of a switch.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 365a03d0f251..8d248842feb0 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -6051,8 +6051,8 @@ static int mv88e6xxx_lag_sync_masks(struct dsa_switch *ds)
 	ivec = BIT(mv88e6xxx_num_ports(chip)) - 1;
 
 	/* Disable all masks for ports that _are_ members of a LAG. */
-	list_for_each_entry(dp, &ds->dst->ports, list) {
-		if (!dp->lag_dev || dp->ds != ds)
+	dsa_switch_for_each_port(dp, ds) {
+		if (!dp->lag_dev)
 			continue;
 
 		ivec &= ~BIT(dp->index);
-- 
2.25.1

