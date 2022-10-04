Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D756C5F4295
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 14:00:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbiJDMAx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 08:00:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230006AbiJDMAt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 08:00:49 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150082.outbound.protection.outlook.com [40.107.15.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A96B654C87
        for <netdev@vger.kernel.org>; Tue,  4 Oct 2022 05:00:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UP2JBdTt+m8Vs/WGwCkXWv0/AEflC8W99V2NnuWxBgSOKydZRHrlApSN1eDcefXX1plQkx6WCKM82T76w65nEQ2wKP7xY7o+7HMgiyW0yILeGgKBy/qsU2I4pLKlo0dNQRSTItFb2GqnxJwWyaMLeTp6cQF7jfGn3Z7eN4WWqYJfN1iJTOeV0LaPxn/ClAXVCG5o8z5+lPDwsqkMThXxUmFbaUBYwIhdMxHP3dmqBwrzNS2f+79ZgP83MDmm/+6Q5Mrye8YruWD/sL5Fu18pwpofujH59QPdto/H7i8DHLKvtlzNFVvo26DCbM8WNwyU1VyWbCWyFTCOi27gWeNGhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7DeYU4Jry2GyzLsO9tfzzVt6clMikELKhNthgWWprIs=;
 b=DbE5uLXsCFAbh7Im86yRnekYdnF5OEHUMDkjOh1j+J5dEv2g+apKGusg1OWECs3mbRBPvFp0f9YnaYK+B1xxzZHZqyze5h/SvJE0OMb30kaVJnfsj8ms93n2SqZY8gdXhTzB1L77WsTo/57EQlW4DJUfpT5TmbzuYw+Vjs6TDh+9aPn9P/zjRzAGemyVqHylGImtwrt8vRNO/sjwccH+A0zAgvO67wbTxTT7se4XH9FTJ04r4ADSYBIfZcNEnzTkHHZRlRlzTVqiC4SMR85rFbsvz5D7p2X4fepIK2n0aGYOFqEQDhJZRvHBJX0GvK6xsCWToxxi3ks9ExFDJnIcSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7DeYU4Jry2GyzLsO9tfzzVt6clMikELKhNthgWWprIs=;
 b=IsDypnUGekD/TxeZsdba837LhNiZcuepbP74q7Vx9+KSLGm7QwhNpzukLP8kBhrYFCNRXlX1GvXHiwvyJ2MuUx8UDZuYuTDVjjolq96KGmjqkVn6bSDYR3qXjrvjdNVBcTcHWw70b2Y35pGhXE5Rpono4fv3I00dWxl/aVj2J6s=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by AM9PR04MB8454.eurprd04.prod.outlook.com (2603:10a6:20b:412::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.23; Tue, 4 Oct
 2022 12:00:45 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::fd20:a2fe:1a4d:344f]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::fd20:a2fe:1a4d:344f%4]) with mapi id 15.20.5676.028; Tue, 4 Oct 2022
 12:00:45 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: [PATCH v2 iproute2-next 1/2] taprio: don't print the clockid if invalid
Date:   Tue,  4 Oct 2022 15:00:27 +0300
Message-Id: <20221004120028.679586-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P194CA0021.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:800:be::31) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB5121:EE_|AM9PR04MB8454:EE_
X-MS-Office365-Filtering-Correlation-Id: b43465da-a85c-4606-b072-08daa600119b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XhNgQV2s+/cUGn/TKIPdaD+311B/52fCZOERl1w72jKk9Y/NAyG1xst7WMv9/35wIAxdCboI+RoDK2oTOaRs/YPjXpwx7Kj2Fwe8UiEsvaUMBniHXRcSalHhgFeC1v9ZsJ8p7ikHDAI10cQ5vyFESscb808ThyvJ+XbvST1u/Iv2prJHfmq8UHMM1tpwx2KrTe1xiJiGn9l/xEDa3RZnL6u8cNnzKxQ0hwExhTQIh4AOhyFMRjX+klH4Ia++v663iUoubCZvQaLnt9Jj018wGxgY1/hzws0r5CafRnCUdo28ggCOKdvlu9xpi4tJJzZaU6mU45H1FMPwtvWvuzzsj6pgn4fsRv2vKjQd+2rNejkAFw4GqERGlWykH40JJnv9D/Ex/ggK9egu3mosFSnMfbg8XPC3gNQb3PZ+iKxqf2Y1vSBHhkLliX+8B5Rgd11pPmPd65XdozK/EZZZYD9akCXBZTkfjUoGQaa073IhoH7S92AS2u04ywHiuLD/hEM7cTKqfqhEJd6rxMUkcDSA0RBOMhKRpcyu53dd5uYt+V8riADm/zTzrj9LaMXtFmdRgj+inGdMFrLKPAyZZAhOt7/OF1DsRqtekDw6jXexBJ1Hz/YB9H8JFXWQWOycsCkji9lDqSwyRfq97EKvNfSTn5q+p8v9NWGEZvaL315x1s68KWuVX/8DQhkJfmEnx4aiv5QDUEzD01RZaMdcmj8M1RvcisxJxuKfiHEmfthcCDbEh68wL4+Ofv7yidbi+t8aqwPAflE2sbTB/MyleAvyXg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(136003)(346002)(396003)(376002)(39860400002)(451199015)(41300700001)(6666004)(4326008)(66556008)(6506007)(38100700002)(66946007)(38350700002)(36756003)(2616005)(1076003)(8936002)(2906002)(66476007)(86362001)(83380400001)(6512007)(186003)(44832011)(6486002)(26005)(52116002)(5660300002)(478600001)(8676002)(6916009)(54906003)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AESSMGgvfxj5g+mdk3le3V005g5PPu4rYgFTDQ2k0PNpNolf7lxUE5YxXUqS?=
 =?us-ascii?Q?R/cLGOtTvge01W9UjdLuWymPkHfwGFITENO12MNS7qm814vaImrdfS9S1AJ0?=
 =?us-ascii?Q?e9IgulCznft4ob1QhtYJQXWv1pXKgXkLXdcOJqZTGAVTEUY70jo/cyXfftZj?=
 =?us-ascii?Q?0vGGLUz60ZVGCD7QFRw7onyLLbWidakxYXFUOrFwFINMUozbPwE9nonG8aA+?=
 =?us-ascii?Q?Rw7JMSrfK4bu6DAEu2/wGHkQhR7IVmot3jAXC2GgbTN3JITO6JHJcLfGLuZt?=
 =?us-ascii?Q?mn8GverxFN1J3i6M399G7hu0h8VdRhHS8nC4OyWNEiqV8pmYII1JQtroDx/L?=
 =?us-ascii?Q?9FE5uD1YFiFLpxprBftjm2oOHHCtAatWpNUx+t6OAEvweCVeLPgTOy7ZkSA/?=
 =?us-ascii?Q?Tz6ssQUVzDsOTZGFeDK71GLp0wipeKM39wCYBSpEJgBPDoLkBLRyb2UGp6h1?=
 =?us-ascii?Q?/AydlJO3Qx+72If3aruTMjRNgYyCzG7by1FRys26aeIBPrI+nXip7H537biL?=
 =?us-ascii?Q?r8UCselxLyG/sbsQPzR4E9MxPJBLLtEwLNfcciiAq9LNLF8uXJYhmZpRLxA3?=
 =?us-ascii?Q?zN6JF0PbcIBjR1XeSyr6qCtHzYTtFGMbzDEZe/ExXHHRXXrcPepzQYLIcDVn?=
 =?us-ascii?Q?A0Dc514fS61EoHjDJfR8BJHJ8E4Km4em54+2VQHkNRFtytn2s5wLL4NJsEg/?=
 =?us-ascii?Q?L0pzAKYNJNAQT2tAWCDDXh/5nlpY6aT9LksXFj6FUZzPtEH+3VATTB18SK7h?=
 =?us-ascii?Q?T9KGZ/RF4lsIVbxQlR5vPKbO3ITZ/lJPsEQwTS8xpctNmUa5HEokWgHYM/bB?=
 =?us-ascii?Q?2iKnV859PgxiXwYtp6AaywuNOLi6H10m3ozJ5zbvBK9C0BuDbOB0oxprq5Kv?=
 =?us-ascii?Q?LkepLOhK/L1p0yXXaUPwo2K1ciRyMqyeR9wwPzU2itKL8jdqfvFPcgmxzWg+?=
 =?us-ascii?Q?Kf45e1YdVraR+RMEtMlr6+AJ+UE9W+hNeGrzDYnl6sCDm0SgktOzW/hUIQdk?=
 =?us-ascii?Q?1hiQY5G/E8W9XGoH7OI31VBGPC2ACweB9Mlc3+64sRmiyfFju4/PDuH4JfeP?=
 =?us-ascii?Q?TVgXXdbnjP4BI2lpubzu3vBjCuDbD09W3rKEbV5b/hZg2UYXN9sfQFkIXVDu?=
 =?us-ascii?Q?LdGx66b7907L9OR7V6GNOQSn/7A9WgoSI81eRomDdokNCGpUCcrYv1/Le8n0?=
 =?us-ascii?Q?vAHQfozMI6Fy1fjSyIhELMiaN6dsoC24sCrlCpBv0KKcEtmdJKjGT3SfWfiT?=
 =?us-ascii?Q?4udJX0RTR0GMoNsxXsI9rX9lyaiUKgtusm7dhw4Pc4oORsEKNXtSzeSufFTB?=
 =?us-ascii?Q?sY3k3JsOmxx+5JBHgN0blExbDfxBOSHJEoFwUBbJ5If/saI2xJ+0nCoUmEy5?=
 =?us-ascii?Q?PFrhePwnSOvVnFQOaRrPl1apMqFXMmxEqpOuQZtJ8HdSEfCeb2h0CVj2TXHy?=
 =?us-ascii?Q?IQelJtEI9ZSTU8hauZvoCL0zTUVPLgfYIUX+/AG9Mngq75rTdEwjfRL7fu1C?=
 =?us-ascii?Q?gGDExODtOnNLo2MuJ8f8kAw1C5H8Gm6FshuIf8jMUafdzSji6w4w6+GUCt2Y?=
 =?us-ascii?Q?IFgj/IO0OgFRQEsrOyiLTlyIngo77onC8qIlbrOjqIJCEDLJJvuKc0J+fUHS?=
 =?us-ascii?Q?cg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b43465da-a85c-4606-b072-08daa600119b
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2022 12:00:45.3535
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KxqGnVOWw1kZntfl8rLmCQELLi+/9KxG728tun/bDT4OUmZMzBeoxYigGe0G01OW6gfZOr3LaOnjD+ORLYjKLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8454
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The clockid will not be reported by the kernel if the qdisc is fully
offloaded, since it is implicitly the PTP Hardware Clock of the device.

Currently "tc qdisc show" points us to a "clockid invalid" for a qdisc
created with "flags 0x2", let's hide that attribute instead.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: patch is new

 tc/q_taprio.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/tc/q_taprio.c b/tc/q_taprio.c
index e43db9d0e952..e3af3f3fa047 100644
--- a/tc/q_taprio.c
+++ b/tc/q_taprio.c
@@ -434,7 +434,6 @@ static int taprio_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 {
 	struct rtattr *tb[TCA_TAPRIO_ATTR_MAX + 1];
 	struct tc_mqprio_qopt *qopt = 0;
-	__s32 clockid = CLOCKID_INVALID;
 	int i;
 
 	if (opt == NULL)
@@ -467,10 +466,13 @@ static int taprio_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 
 	print_nl();
 
-	if (tb[TCA_TAPRIO_ATTR_SCHED_CLOCKID])
-		clockid = rta_getattr_s32(tb[TCA_TAPRIO_ATTR_SCHED_CLOCKID]);
+	if (tb[TCA_TAPRIO_ATTR_SCHED_CLOCKID]) {
+		__s32 clockid;
 
-	print_string(PRINT_ANY, "clockid", "clockid %s", get_clock_name(clockid));
+		clockid = rta_getattr_s32(tb[TCA_TAPRIO_ATTR_SCHED_CLOCKID]);
+		print_string(PRINT_ANY, "clockid", "clockid %s",
+			     get_clock_name(clockid));
+	}
 
 	if (tb[TCA_TAPRIO_ATTR_FLAGS]) {
 		__u32 flags;
-- 
2.34.1

