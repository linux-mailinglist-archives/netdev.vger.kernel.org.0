Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9DAF5E7FE5
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 18:34:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230047AbiIWQeU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 12:34:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233014AbiIWQdw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 12:33:52 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60063.outbound.protection.outlook.com [40.107.6.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73DAE13F297;
        Fri, 23 Sep 2022 09:33:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZPmZ02PR8yWm/pIljTa16j6igOVuXU4K/90e7Pj7rdwW1X81EQdHavxbVAME0e2LQQAHVGuWZk+ks9OK2jZq8Mc5wfs5ZVnfW2UVnikKT5BbgreEDQEYTF6c60lljr5tVx7de47fAmfOMwcAPDq7NmSdF24zJUJCuIzjI/gssQIU0f21JyTP8OZML3v3f4A/LU4SugCxoAFtrP8aDPyZcDg/mHix6Q2SJIsT0szQjNGrg0yLhQBoYHVqwSIzEg2+y/wP75h3KRky6pkIzGdveUlYOcq9MT1pX+rCYO/lLDeuvZlU6PQHKO7hnDu+Aq49EAPzexqVQjnRTwrthbRn6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ULs5UWzpCq/TwMw2VmeCQlqwqkj6AWDuS6XYrkc8JqM=;
 b=U3HLjkrFY3ZeVOEHsiwLNLwiQ4CzsKVLrRpFQIxW87V/MJ7gXmR8/0FhFtSZiHJ7SlLky/fsrtyXnoS7eBKJOC5nJBgUvJUYJLg2c2dwoFKfks8P0zqOHW4NtLhWOxDwCSQVSLvpso8irv1bBZr8JfeciSOQp/nnzJzG3sY0kGti4NrRVZ6L0LKCX2NqvbSNyqdRVSdJzv11YRU2VANVsblM0HNbNPf3bYHXTXEwQYWhSZbdapa118qYEI7qx5w7yaYRDzDFUYXoapYHvyyw56xIzzPuE7QQMfEktyKtMvdMwiwBdH4I0bt2zC9hsXEY/OtTJNCFO0E0NbQhXfJyBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ULs5UWzpCq/TwMw2VmeCQlqwqkj6AWDuS6XYrkc8JqM=;
 b=ELtippDpBvSst7rpc4O6deK9CChQCokQmj/hl3knGiWsJV5I0tmTEpi/gYKILL9SZaNc8euViflERshREhEIgSDycZ1tL5yHURzDEjTSKjb3Dd24oKsmhEPyVRdIwDviLQDCMGDUsB2JpzmVn7AT/Hse5xeoq6JfhvZtkefNJ/s=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB7023.eurprd04.prod.outlook.com (2603:10a6:800:12f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.17; Fri, 23 Sep
 2022 16:33:48 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5632.021; Fri, 23 Sep 2022
 16:33:48 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Rui Sousa <rui.sousa@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Michael Walle <michael@walle.cc>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Colin Foster <colin.foster@in-advantage.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 net-next 09/12] net: dsa: hellcreek: Offload per-tc max SDU from tc-taprio
Date:   Fri, 23 Sep 2022 19:33:07 +0300
Message-Id: <20220923163310.3192733-10-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220923163310.3192733-1-vladimir.oltean@nxp.com>
References: <20220923163310.3192733-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR10CA0029.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:17c::39) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|VI1PR04MB7023:EE_
X-MS-Office365-Filtering-Correlation-Id: 44256b45-28f1-4441-ff99-08da9d8163e6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Jfkk18pB9+niOao40TjhFaQBIowQA4f2cxXcWiuIX8Cx2uCEX+DhD202DNHtomEem1IVQ7YMsTHhaUQtr7CCdIS/hpr9YiDOHr0tUvRYj6U07ntGoBKjOj4Vx9mgpn49fP1OzgFt4EjJmpIGeqdOaKp0pUft5+7dCLNpkLZtiIi/cnENRWTArnZej54ChuX/xsDqv8siFjNQqSxmxSZt0ifNs70rZxrjfxWVu6yH9/ytj/Y3MR8zFbDh4U8yTd4LD+mffrUceLUWcOui3n3m/1+R1X7qIQHI8rDN8+Hy3NxIsyqZl/qv51z2JFhGLDE1qPl2pDRna37JWSwgUSJtUNA9X9RKFM/OIEYHLlfhzYhPCjrePuNs2Rd4ew9zsBKlyF++vB/Vx0At2YOZZpQZV9r8EezsdDzRvFbCFGqmHi5pY7wzmNDxW/GXsZK1sxTSFf+I3LO9jRywKzE2qGdumRGOL9fEunGLE4hRQWiQS8wNitNnjXZny63xuMcXFowXyBpYuP27mknwD4tJPwBAK0lmpAlprp0TVTxURTmb8llKw8d3daYlANnplbSHFc21Q78Ekbr7xzFkc6e3ZAdHJg27k0YWeQQ9WDlZlN9abr29xapr6+CXZVMBaqY3BeCDb/ms4oGv4o8FNlKIQHW9u14ficBmriHpm6O22qilZlPq882I02DDhGHLbB7FfOXNKa6x8BO479aR3ESlQURGn1Vpn3qwxU8iZrefyzpEC1N0lrQTnQ6aA1HV0l2mhimNww4bYVy+RiAnfZQTI89VcQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(346002)(39860400002)(136003)(376002)(396003)(451199015)(478600001)(6486002)(54906003)(4326008)(66556008)(66946007)(6512007)(6506007)(8936002)(66476007)(41300700001)(6666004)(26005)(7416002)(44832011)(8676002)(316002)(5660300002)(36756003)(6916009)(186003)(2906002)(2616005)(86362001)(52116002)(83380400001)(38350700002)(38100700002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?b47pZ3JV3Mug4ZoxZPudwQz+nFDNODFsMTTSSLcVXr1aMFl8VQAbNgRRUeGg?=
 =?us-ascii?Q?MFSHxXIttJTt5YgI8As65g/J21z7ZsIsxkVnnjk0mCv0vCFc2C8BU7IVwpx3?=
 =?us-ascii?Q?l5Hqhg2mHQOrlMMWuuz4nxPeycVM0CeaL45e+g6Q82mqvxCPJW71LuOkwLP9?=
 =?us-ascii?Q?MoHhMOvDK7pYMGHl+mtKzBLnPUMYCp0p/CF2EoYbTc9s6/w7My0Q8SV1XueU?=
 =?us-ascii?Q?FcdqNakp3fy6wX3H8vbnKSsav9sEzDPjeeI7JXQVttvFSn23IxXRmrClqiAI?=
 =?us-ascii?Q?uMLamH1CgeCsyMSeuCHssKVWDlURAMckMANfPHMpCPpKKlZ/uHteY+VDojtZ?=
 =?us-ascii?Q?xO9orGzv4kY3nuExcmkH8i3A8ZRyZ489Yk172Ws9GxkC4kI/GYzIff6hELYl?=
 =?us-ascii?Q?GahyIB69KEypWR9hE8tMgz8BR+m2k5LYg8dczQ7IkXrTgBvxpBnwitWpzlFF?=
 =?us-ascii?Q?J9cQ6+Minguo4fPpZmZYQ3haJHsBmQDXSN75km9gq3wjVHh7zoFvWC4zRxzp?=
 =?us-ascii?Q?qXptpLV4MlXO6EGpbrZNPt6OMcyb3IEBPoC1j6wuzyaTRTxCjz6cMN/DqJgM?=
 =?us-ascii?Q?NReK14C90qB0NW/lZzI01DxyaFk2L98HmuTIO8TeL81KD+ed1Y+NF5w3tV3F?=
 =?us-ascii?Q?NxI30k0oe6KqNiS4Cihae0hCZE7cxwItFTvFyzXWlnj3iluEADZr6f3sSlQa?=
 =?us-ascii?Q?yhPAYw+wDZUIZY40We4zzQta9qpT/n0fmoewfqAadqMzMB/cJbzRHH2/WUiI?=
 =?us-ascii?Q?yMv4o8LmblKfvNe6C2DGbnVUxg9+Fufxf8pKH0UhdNFO1+xYQLKzYEm6mFnU?=
 =?us-ascii?Q?XX8gdu1V6R3xfj9wy64diRjTVQ8K6XLzGztXXl9fU/bF6rfI801kRB8WTZvu?=
 =?us-ascii?Q?bDCHrfid9+/MwuOtzOojpfBgbn1ki9gIMNT4MydDRRXWAPXo2Ac9Mi5hmWYD?=
 =?us-ascii?Q?ahAy4SSKECJdMkdexRzo2HB4cxBzyZjn8ZZIEaHda0mKWTm3NvniHbM5VXar?=
 =?us-ascii?Q?jjlLOXzRzla3BcemPIn+AmGa1yE8v+Ni2vKNR57FWttaZnS5hdU/KEkWYfUo?=
 =?us-ascii?Q?CydqMFVrkgn5nC20N8V9/NLcasjxk3FzRwcXpP0XUx2sRNrpz4cstx1cIBC/?=
 =?us-ascii?Q?y1sT5Jlh/NZBNEuK7nOoP29iluh3Wc5GtNV1TZBxek1rrE4LDlFellAvZTBJ?=
 =?us-ascii?Q?Mu/AVsJvAQaJUN83KgVNq01MYOHBOGB16m36V65hlrVZQlMAxYed9W8U31dQ?=
 =?us-ascii?Q?1lkFm1wR3PvIrgF8a5sShj+RLlekYNX0WcAiRVaYyzlcRC64f+xKvzmcB/ry?=
 =?us-ascii?Q?B+0JiyvNjiymD0C51aAXy9sL6QYcRXz6GAJa/82r3XuGp9R5HfCZfj/ODMLD?=
 =?us-ascii?Q?xmwlxtOFxG4+UiDwG/nH9XhEd6sczy5PwWWNmn8p9ZW34UyQkVroJITp6VV8?=
 =?us-ascii?Q?h8wYTEUUxO1rsDvTiNq4Pou0fY6jO0RQcNi5zgcYdrDM2HSfP98JYQw5XPsq?=
 =?us-ascii?Q?kqSC3muMsYAM9S7fo0k1TK5AFX+vPtdJ1Fk4RWPVnZuTxhpBUNWhtzo7TK7R?=
 =?us-ascii?Q?byBzM+plShBQ3RyGtzAPBz9y5df7yLqpEfEOjzGL47qCH1KFEyiEv2JFYHOy?=
 =?us-ascii?Q?iQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44256b45-28f1-4441-ff99-08da9d8163e6
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2022 16:33:48.0490
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pEfq/CHTx06WJpb+tukl9VWDtFDON+sImw2tjRKGCYqSKfT68Nbl1ytfXIlXojRrjQByFXgdAPkB3kMrxQePfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7023
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kurt Kanzenbach <kurt@linutronix.de>

Add support for configuring the max SDU per priority and per port. If not
specified, keep the default.

Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: replace my patch that rejects custom queueMaxSDU values with
Kurt's patch that acts upon them

 drivers/net/dsa/hirschmann/hellcreek.c | 59 +++++++++++++++++++++++++-
 drivers/net/dsa/hirschmann/hellcreek.h |  7 +++
 2 files changed, 64 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/hirschmann/hellcreek.c b/drivers/net/dsa/hirschmann/hellcreek.c
index eac6ace7c5f9..ed0bdf0ea6bf 100644
--- a/drivers/net/dsa/hirschmann/hellcreek.c
+++ b/drivers/net/dsa/hirschmann/hellcreek.c
@@ -128,6 +128,16 @@ static void hellcreek_select_prio(struct hellcreek *hellcreek, int prio)
 	hellcreek_write(hellcreek, val, HR_PSEL);
 }
 
+static void hellcreek_select_port_prio(struct hellcreek *hellcreek, int port,
+				       int prio)
+{
+	u16 val = port << HR_PSEL_PTWSEL_SHIFT;
+
+	val |= prio << HR_PSEL_PRTCWSEL_SHIFT;
+
+	hellcreek_write(hellcreek, val, HR_PSEL);
+}
+
 static void hellcreek_select_counter(struct hellcreek *hellcreek, int counter)
 {
 	u16 val = counter << HR_CSEL_SHIFT;
@@ -1537,6 +1547,45 @@ hellcreek_port_prechangeupper(struct dsa_switch *ds, int port,
 	return ret;
 }
 
+static void hellcreek_setup_maxsdu(struct hellcreek *hellcreek, int port,
+				   const struct tc_taprio_qopt_offload *schedule)
+{
+	int tc;
+
+	for (tc = 0; tc < 8; ++tc) {
+		u32 max_sdu = schedule->max_sdu[tc] + VLAN_ETH_HLEN - ETH_FCS_LEN;
+		u16 val;
+
+		if (!schedule->max_sdu[tc])
+			continue;
+
+		dev_dbg(hellcreek->dev, "Configure max-sdu %u for tc %d on port %d\n",
+			max_sdu, tc, port);
+
+		hellcreek_select_port_prio(hellcreek, port, tc);
+
+		val = (max_sdu & HR_PTPRTCCFG_MAXSDU_MASK) << HR_PTPRTCCFG_MAXSDU_SHIFT;
+
+		hellcreek_write(hellcreek, val, HR_PTPRTCCFG);
+	}
+}
+
+static void hellcreek_reset_maxsdu(struct hellcreek *hellcreek, int port)
+{
+	int tc;
+
+	for (tc = 0; tc < 8; ++tc) {
+		u16 val;
+
+		hellcreek_select_port_prio(hellcreek, port, tc);
+
+		val = (HELLCREEK_DEFAULT_MAX_SDU & HR_PTPRTCCFG_MAXSDU_MASK)
+			<< HR_PTPRTCCFG_MAXSDU_SHIFT;
+
+		hellcreek_write(hellcreek, val, HR_PTPRTCCFG);
+	}
+}
+
 static void hellcreek_setup_gcl(struct hellcreek *hellcreek, int port,
 				const struct tc_taprio_qopt_offload *schedule)
 {
@@ -1720,7 +1769,10 @@ static int hellcreek_port_set_schedule(struct dsa_switch *ds, int port,
 	}
 	hellcreek_port->current_schedule = taprio_offload_get(taprio);
 
-	/* Then select port */
+	/* Configure max sdu */
+	hellcreek_setup_maxsdu(hellcreek, port, hellcreek_port->current_schedule);
+
+	/* Select tdg */
 	hellcreek_select_tgd(hellcreek, port);
 
 	/* Enable gating and keep defaults */
@@ -1772,7 +1824,10 @@ static int hellcreek_port_del_schedule(struct dsa_switch *ds, int port)
 		hellcreek_port->current_schedule = NULL;
 	}
 
-	/* Then select port */
+	/* Reset max sdu */
+	hellcreek_reset_maxsdu(hellcreek, port);
+
+	/* Select tgd */
 	hellcreek_select_tgd(hellcreek, port);
 
 	/* Disable gating and return to regular switching flow */
diff --git a/drivers/net/dsa/hirschmann/hellcreek.h b/drivers/net/dsa/hirschmann/hellcreek.h
index 9e303b8ab13c..4a678f7d61ae 100644
--- a/drivers/net/dsa/hirschmann/hellcreek.h
+++ b/drivers/net/dsa/hirschmann/hellcreek.h
@@ -37,6 +37,7 @@
 #define HELLCREEK_VLAN_UNTAGGED_MEMBER	0x1
 #define HELLCREEK_VLAN_TAGGED_MEMBER	0x3
 #define HELLCREEK_NUM_EGRESS_QUEUES	8
+#define HELLCREEK_DEFAULT_MAX_SDU	1536
 
 /* Register definitions */
 #define HR_MODID_C			(0 * 2)
@@ -72,6 +73,12 @@
 #define HR_PRTCCFG_PCP_TC_MAP_SHIFT	0
 #define HR_PRTCCFG_PCP_TC_MAP_MASK	GENMASK(2, 0)
 
+#define HR_PTPRTCCFG			(0xa9 * 2)
+#define HR_PTPRTCCFG_SET_QTRACK		BIT(15)
+#define HR_PTPRTCCFG_REJECT		BIT(14)
+#define HR_PTPRTCCFG_MAXSDU_SHIFT	0
+#define HR_PTPRTCCFG_MAXSDU_MASK	GENMASK(10, 0)
+
 #define HR_CSEL				(0x8d * 2)
 #define HR_CSEL_SHIFT			0
 #define HR_CSEL_MASK			GENMASK(7, 0)
-- 
2.34.1

