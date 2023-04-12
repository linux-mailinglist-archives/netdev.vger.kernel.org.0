Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F8336DF61B
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 14:50:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbjDLMub (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 08:50:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229946AbjDLMuR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 08:50:17 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2071.outbound.protection.outlook.com [40.107.22.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 535A29F;
        Wed, 12 Apr 2023 05:49:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jwQVAFCjtwrbnaApOPFK6LFOhqErZw/7pq8kVxub8G7NeDXd+EbbILgT2RnHwxc7Lbjd4td8IBaLtFf9F8FbFbj+xDfllq7ZGHcTxa6Xjyx7XwJiIBAq6Yycypu/b4kLF/Z6vN7ZSxDvztXBbkWhlGn9XehQ/IjmFi+GZhEOs0joKlHb3PO9ctLqKg0UpHjnYu/miu2flrrx5LbA9b0EEPllxPu2XhlzzlM2HL1ftTEIvXA6W7Pu4ojw7f63ooeFwE4XfbdEvV8G4j2I2E8I2NgXgGcqhMx+XpYHHxYjAf0q7jemUBWQh70Vu+pBZ6xa9JapHluAqeM2uMBmdKqANA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x0dzRqtPSO85rjzAqEo8rc0SJ1W5x9A0rEVVF5pPY4M=;
 b=Q6xBlLrddJwcw+XrdVXmSCPrXNvzoecTIxegDOlflIPiMj2etAQhBewoLl6kdxzSC+2lV5QNP6KT5hCPG9PgNTVYRZXlvhdgdV1hzxo6tq8fPi8vH81FbojYLZLuRNNIZtEzVvCloXhemQXGDnJ4M0QyidfTkeQ2i06BRTN+IkzX/xQMS8jC9/gAmoOMj1eajXEgUa1b6fqXwym97lWz3guzBPqGSk1KmglIdv1U20rwP19XqUHSREVdkqngTlQNiACNtBOYsyHyxcWr6qbnIwo0nHT53bqrR1N8hlxQEOaCt0RE/zE9zcsZEfGG0OJWIN7SMlf/+MvCUh6Pd5bhhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x0dzRqtPSO85rjzAqEo8rc0SJ1W5x9A0rEVVF5pPY4M=;
 b=P/wrJAh+dFMmvFN90M1G93o6RIPXvdelEWjYmItZy7oiP08Ngiwu0+7zIS80iv8MvUAqzviYk2Td6t9EVNl0HIz9D48FhM+T1I/l5pjn4hpVhaMILAEFxZIEDmvKkWlUgPbp43RlUXq60m6JhHdFlFjzK5nibugzyTZhcx3k0xM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AM7PR04MB6888.eurprd04.prod.outlook.com (2603:10a6:20b:107::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Wed, 12 Apr
 2023 12:47:59 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b%5]) with mapi id 15.20.6298.028; Wed, 12 Apr 2023
 12:47:59 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Colin Foster <colin.foster@in-advantage.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 7/8] net: mscc: ocelot: strengthen type of "int i" in ocelot_stats.c
Date:   Wed, 12 Apr 2023 15:47:36 +0300
Message-Id: <20230412124737.2243527-8-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230412124737.2243527-1-vladimir.oltean@nxp.com>
References: <20230412124737.2243527-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0701CA0056.eurprd07.prod.outlook.com
 (2603:10a6:800:5f::18) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AM7PR04MB6888:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f8d8014-7a77-4d6c-be60-08db3b54252e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xQlkxqbmf112VmdEIT63tOyXzcG3sJ99GN/6ABkm31zkjXij2B7LKRvEWxXzla6EkXIs6t4n3M4DIRN+82RjbDCok4D9/bcjP5FdrVMqeKdYUm+7RdhDYXLI5I0TZ8lnLRtZYj1Nevt0vK98kWeTIOb09EiY/Rw2D7/Q/biZ+tzQ0AaTbly+T+dm//qOj1GiDqFCLIvPx7XGC/e+YRViMqOHzBvTEX0JVEheS6YA7Z1DYMHV4eJncJs+nKFxXUFWm+qB/adVgu3Iy7ZG+eO2+bLmsJlu/B8mB9GFWyE3l9d2KCgdHzGhZ9RQMh9eTJhErDDGi6RlP++FXSeeeTaH3z0jsRqMHE+3xAUAqxGKz3bnljjvVI5IuvxrT/OZoGNrsJp4RNCNWF2C75qKqDlZu2fC9vADm7X7ToLvBlCAfTf5tx0u7LtcSPgUXrEwYCPMzqfLPozowI/nif6nJWwVaq/elTV/KX3Kw8soNmygnatF40ns7ZF2zhJdtJjoNp/r/Ylk9e1dLjNPSlH5/VzmmtJkr67yXTrQsCLz0SX4YQnyqcelaXh81zmzfNM6MFB3C6aDo89/AclRYOe8yJLA/qacYmtihB/xBZXlzRSUovLOWdFLUSMlU2tCjavWjW9E
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39860400002)(136003)(376002)(346002)(396003)(451199021)(478600001)(52116002)(86362001)(83380400001)(6512007)(36756003)(38350700002)(2616005)(38100700002)(316002)(2906002)(1076003)(6506007)(26005)(54906003)(44832011)(186003)(5660300002)(66476007)(6486002)(6666004)(6916009)(8936002)(66556008)(41300700001)(8676002)(7416002)(66946007)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iVgiBARO8K1FAnB8J8k5WgUB+N2YZ9XSbwMOPCEGw3yJVat1Qy4KsHETJGy4?=
 =?us-ascii?Q?01rk/0Eti9vFD73GpVnj20AcZyQm+1HIdvubt4hx/O160CfJkE0DOlhLi1qo?=
 =?us-ascii?Q?uADAzflMUZ+meEiObxcCOIkTBKqy/n7qZa8h8iyH3WhNcx1X2aRCS0Hx/vKv?=
 =?us-ascii?Q?L4MLj8NBg7dcH4CHjEVXUNsFu1E2aEA367z3oX5iyue+Mz1ZzXxABipUTPux?=
 =?us-ascii?Q?zdIUgzcHyBycfVcJ5MunhvnbksJxCspEQqa67p9ZTp+kjLjMwSzsHua8eJCp?=
 =?us-ascii?Q?VvY6brokHTFVQkL8DwEzMngFCqKMKNMHmjEyMVGDJVbluOndevXmpIIe32fB?=
 =?us-ascii?Q?kXFZaiSXJMQ5qOfMVe4tIV+PXY31HqOHSjq2xpCJj7b6Il5Xls1dEI7mR9R/?=
 =?us-ascii?Q?7TyETIjd2HIONnzzb9jjamOEjNmZUs7wkZS5MCWDaW/ZeqM+K8dfQ4T+Oe0t?=
 =?us-ascii?Q?CmeDaELZEzcxk6NFaC4Pj/mG3PbEZhk5r8U4waXy7daRTB8uYUpj4vwik5MR?=
 =?us-ascii?Q?twR/S8wLo/+CQ7GxwDt+uzniChLcNMSzc6u1PD1CkBdXXEJnYZ7lWQ9NvApN?=
 =?us-ascii?Q?q0kqGC0NklEaylQrAf9BsHcqVSqJ4XDk4l+6rTqX+RKXHYWV4Fsm+gF+wYgM?=
 =?us-ascii?Q?dI6O8Bt3sFjri58QSP1A99H+GAeDs7lTMfIzjBJr6ILabxpu4xOHtjKLNHas?=
 =?us-ascii?Q?wXlisowA/rXWPRam4ydF3tyKcubMOEIXYOkdXMbl0+I0wHY/lblsSbU+boAg?=
 =?us-ascii?Q?SKUzGQZrTaxwVSsCgNds158u7Ukd2yISOWkv67D762XjXZr4dnWTdTmAwqrs?=
 =?us-ascii?Q?7QYJt73T04gxKXHOWfUnp3G7l3n+B4hH3fK4g+VcJRxcBoO5VPKebV1OPFD5?=
 =?us-ascii?Q?+1O7TR7hoI0E/TGryslJN2nrNZlH4Q9Y6WQpuPGPY2lRLE3dliuIu0v2FOZA?=
 =?us-ascii?Q?iJG3txLKaQ3966LWC3lnHl+2dPFqj/+nvy2O6IKaozdmy00M7UqUw3mkcpSl?=
 =?us-ascii?Q?BZty4G8NIVzrEZDPlVL1RDPoXo8L0pBMcS8SGifzXxkkQMPCJXRK40Kq43HG?=
 =?us-ascii?Q?bUwIfH0tVd1+ToIuYh4imkR95C4ZThBHwzT50VWtMAwszVjPuJwK6b+Sov56?=
 =?us-ascii?Q?ynTmCi+DhmdU9V6JZs8J2LFC49gyuIastwJB2urZnL+BhNdxImcgB78Z1QDp?=
 =?us-ascii?Q?CbpBuk8NBnAUB51CscorDsFJFf6UrHEaRbQcNt+oCx0wfNwnFGvAlaHmTkuz?=
 =?us-ascii?Q?dp/BedgqHuDACCm5qVAJLNMQa1HI+Y24xLYj13RxcBG91wdW+jFQYJH9pAGH?=
 =?us-ascii?Q?YWuWWqvvP8bfF7h7Mpa+LhXSzrSC/ioDyREmU+tuBqc8Q6zYoamLsuhdDQUF?=
 =?us-ascii?Q?3QMLm/xUHnwK0xIRROuWG1KS0CdWlhM8D3vk/4AQ8apAfrHpcoU9D56pmwP3?=
 =?us-ascii?Q?Bzs45PEaRiKnqRKASflf6D43y7/aT2id54OgPfnYfUKn2QVHRvWgMAv/yGEu?=
 =?us-ascii?Q?Cna0zuzIJVgscFXUYrQDjTZNZY0skbuxDbG20AJydzEQSgWveiJee8/keDUb?=
 =?us-ascii?Q?Nk85z+KgTArOipn9HOKKpICee3/751loNjyAMEPDVOy2mmW5NeCvYBR0o00u?=
 =?us-ascii?Q?HA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f8d8014-7a77-4d6c-be60-08db3b54252e
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2023 12:47:59.2064
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iaRinoSMQnHBn+96J6O8PhbLgYHZSx/2MzdLdVqEr8Jr8pI2nxc3i6LhjQrmOLruG/5TVSoiiW/Fof0Tc0AS8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB6888
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The "int i" used to index the struct ocelot_stat_layout array actually
has a specific type: enum ocelot_stat. Use it, so that the WARN()
comment from ocelot_prepare_stats_regions() makes more sense.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_stats.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_stats.c b/drivers/net/ethernet/mscc/ocelot_stats.c
index a381e326cb2b..e82c9d9d0ad3 100644
--- a/drivers/net/ethernet/mscc/ocelot_stats.c
+++ b/drivers/net/ethernet/mscc/ocelot_stats.c
@@ -395,7 +395,7 @@ static void ocelot_check_stats_work(struct work_struct *work)
 void ocelot_get_strings(struct ocelot *ocelot, int port, u32 sset, u8 *data)
 {
 	const struct ocelot_stat_layout *layout;
-	int i;
+	enum ocelot_stat i;
 
 	if (sset != ETH_SS_STATS)
 		return;
@@ -442,7 +442,8 @@ static void ocelot_port_stats_run(struct ocelot *ocelot, int port, void *priv,
 int ocelot_get_sset_count(struct ocelot *ocelot, int port, int sset)
 {
 	const struct ocelot_stat_layout *layout;
-	int i, num_stats = 0;
+	enum ocelot_stat i;
+	int num_stats = 0;
 
 	if (sset != ETH_SS_STATS)
 		return -EOPNOTSUPP;
@@ -461,8 +462,8 @@ static void ocelot_port_ethtool_stats_cb(struct ocelot *ocelot, int port,
 					 void *priv)
 {
 	const struct ocelot_stat_layout *layout;
+	enum ocelot_stat i;
 	u64 *data = priv;
-	int i;
 
 	layout = ocelot_get_stats_layout(ocelot);
 
@@ -890,7 +891,7 @@ static int ocelot_prepare_stats_regions(struct ocelot *ocelot)
 	struct ocelot_stats_region *region = NULL;
 	const struct ocelot_stat_layout *layout;
 	enum ocelot_reg last = 0;
-	int i;
+	enum ocelot_stat i;
 
 	INIT_LIST_HEAD(&ocelot->stats_regions);
 
-- 
2.34.1

