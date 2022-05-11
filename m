Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F12C5522FEC
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 11:52:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235635AbiEKJuq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 05:50:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232388AbiEKJuh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 05:50:37 -0400
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-eopbgr20077.outbound.protection.outlook.com [40.107.2.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1449353A47
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 02:50:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gkPKE91PDoFf2z9qQAiga9pC2nSvv3TRpeQmyTATeGs061dcjm5awj8zqW+SMCYZMiZ/3JcBjV6A8OULQYwGlwVr0wIAJMhzEF6hFTSs3+5uiPnsNG97sMLERRrDV8kW5D/3OUNdwj7S2NF9RyzxRCldySdG5vebOpGEopBuEZPMKQZHkA76XKj+fi6WfS96/NTyAgNY9VTxXd8nIOfgbz9vdAmD+h6hK091SHIjECJzdB0tpRPQtfSl0kMzP4jQosBMUbJcBluANQJl2wts88u1BOCe3PKmDoCoeeHLD+h1Cu86NBPcNFCe6DWcyeKkBK2bzYhCjH3uNntqnoXQLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dHzhrLKdDEq8KIq9ngV+gd2GkrWhevmOu2fnqWOy67Q=;
 b=jz4gbxjO3D/WalyQSCiw826xq510wAppOOaIZfsOyZe0fDyJ3SWhHtrjzxZeSub67/MgtHeE9nod/+gMhKKVb9tx7oRRkPxSwySq/7zvmp1nwILQzrRchc3u3xXgx3wTQutIAsn/NQp9mLHtGNEv7WGfC1oogika2PpGzJVWdK1SRqcFZsHavB6zQQs06A9rwfzstgTALXRTWIuR0twTWhchep8+XUYexOvb8Ug3jV0Rlbg26YXlKJDLxHbgPR1qQ2SvZDPhAcSIIvY7c0fUI8S+eXLR9wszlCSkdk7NCcs+LGqv7lxVu1DqLObHpWb/yYBjVEIWdJwwT7tjU+OKbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dHzhrLKdDEq8KIq9ngV+gd2GkrWhevmOu2fnqWOy67Q=;
 b=a3weWuET1OGK4J3R5e8yntEIOaqgg7cj5N+OtmMSJNsggZWucBqZv/Ui3G/o7/S5BtcxH2wzeX4T2XpD6iywr48nKVicwS9lViZnj003ZaIxtFyL+iK7RNRrDnP+U5LMcawf1hEVx4V3GigZzPH3XlWwh4WxatUAet5etUnRAL8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB9155.eurprd04.prod.outlook.com (2603:10a6:102:22e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.27; Wed, 11 May
 2022 09:50:34 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5%5]) with mapi id 15.20.5250.013; Wed, 11 May 2022
 09:50:34 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Colin Foster <colin.foster@in-advantage.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: [PATCH v2 net-next 1/8] net: dsa: felix: program host FDB entries towards PGID_CPU for tag_8021q too
Date:   Wed, 11 May 2022 12:50:13 +0300
Message-Id: <20220511095020.562461-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220511095020.562461-1-vladimir.oltean@nxp.com>
References: <20220511095020.562461-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS9PR06CA0158.eurprd06.prod.outlook.com
 (2603:10a6:20b:45c::16) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 82dcf6be-bc9c-4a2d-83ad-08da3333b1a6
X-MS-TrafficTypeDiagnostic: PAXPR04MB9155:EE_
X-Microsoft-Antispam-PRVS: <PAXPR04MB9155F217B09432225C776C4DE0C89@PAXPR04MB9155.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: riRpSWmUwTDQRB5gtELTd+GBsKSi5Zs1PJWgWAtYC2AO06riBjA+PoBKbm8cY6iHRwqtjJrfbi/5q3ti8sUQ35HOb6SgzTKm4dJjDm6HtjTv6I+uv6AHkpJhFHErVaOZ/749bkmxYdUA7s8PChgHkx27oMu064r99z3rBAUxghAUvJXjmCza8iSD9vuhf2eaCwbvFLdrPecYS9tV5aqwtCHQj8Ek9vEHvzHm7n4Z1qicHJwV058y3lp2+4kt+qokf2MaZ+HbZmn2rVRprLEyXZrSRFu/7/mof+GTeRkPkHer3M9V8vKA+QG809hFfK6CD9r65HrOuQn+zmUU53SgCKTj889wjjRDRsE417HiZzLi4BOIRMv6G2pLx75KJ4I/dZzdI9AqFn1Gdfcf/QibgOMUeZlqsXISLlHbd5/Rtbj7IYE2bVcxlirfwDqvHuM2/iHarRij21NqX1c31HOTyUZlCY5KcmWlE/bdTzasbdu0RZPUXNqa52NJlpTwMQ5tUyehEpMO32/XDISX3m4iUPH7WoimOMFURuDXKlURSK1TaxLgooOJNavZg50L9Zx6pZk+PtCl5LOxxXIp1KZPBkp+bu8tiyqSgupZV9UlAUcbnjPNMGXPP3BW6D5mbCchrE+XDv7osaiKJmGFBo8nmGb6UZyhCsJPD1Bo2Ex4sAwgJWcc45COKfuvXAaPrcS+CMhfXcGIIo8hfUu442ID4g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(186003)(38100700002)(38350700002)(1076003)(7416002)(2906002)(44832011)(5660300002)(8936002)(36756003)(2616005)(8676002)(6506007)(6666004)(66556008)(66946007)(54906003)(4326008)(66476007)(6916009)(52116002)(316002)(26005)(6512007)(6486002)(508600001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?w1fuXiqLT3e+TWw9Tp/b1YzL8x8t5d94boodbXo3GW+LJRLBb5NYssU2qOC0?=
 =?us-ascii?Q?zF3C8iTPG6KNoCpF+Hgg/2WyDtn+qBc9otnZYrTWI1OqtAng6dhH9JLeWvua?=
 =?us-ascii?Q?1MW5whkHZZwOLlH9bfkYrm6G6W2+6eL5dxlzpniI71x9JUh0YjkAMfyMZHz4?=
 =?us-ascii?Q?e1g5vSRGkcZx5X9gMeaEEbysqa9q+UMzKsttNOmdabEWQFNG7pEbpFrrHGZP?=
 =?us-ascii?Q?uwd+aihD3/9qA5WdTOCl0J/Zh5E6mCHrkPx49ezUyz0jHAey7LZdiPHmvQmw?=
 =?us-ascii?Q?7NyNt8xTHcsE8v9+BM5hUR6UL57odukh+C69DKHKsjbC4lXFyfRjBPo37/iI?=
 =?us-ascii?Q?j2QkM9HXn8WfO6uDWmWh6P8XsQQsvJCcdWOA6srCvhlKxVfwJ223yVAVlBh9?=
 =?us-ascii?Q?v4vNEG+hamiswqeGxVBRriBWxcnJ/qcOZ9YdvuIBLe4dJ3M4Th3FeK2OovHV?=
 =?us-ascii?Q?wRdFwPYrFfMLMJkqbUSudFWSI81TDjswGSzx2qCwvTe+7z41RzQSx4GXj91A?=
 =?us-ascii?Q?83UlWeVd2o59BxQNvYLMjIlIDiOqr1H0A2+6MFwVxCrIcQCRmrWUb+2R79sK?=
 =?us-ascii?Q?1fwkiMIhWA1/ekxJj51sURNq2SNE57bPTiBqCcuIDFPNBH7xipOp3yUxw5GO?=
 =?us-ascii?Q?H+q/4sHR+1mBR6TgYM+pQCMkmXM8Bsj1T/Ozmyk1j1yUgIxAAaopDbdajRc/?=
 =?us-ascii?Q?/PEPBiCS9solobkd3Ym7yNarXM3jLMFRZHrTri4Csk/3AUX+YZbSzYMn8GJW?=
 =?us-ascii?Q?dH8/tRLDSo7K/LbHXI9DFZ+m4rQu6VsXIkg6w6FruRVTLEegaGNYd8kD2H1f?=
 =?us-ascii?Q?t3M2ynGe5+wiUHLPIt1BMqvmOFzHgHrx5P8/LlPTBlw3AWvyr8ycGPxgntbn?=
 =?us-ascii?Q?h1VtiZwhbiMMof/g+IFWe9syByiffBq40/IDam/VfaXvsnblJlzfosawAbAo?=
 =?us-ascii?Q?rOS7H5VoZidGk69WvOnmw4ms6pAjJ0LZO2X1+IqzsgHuAKVXYwBQFUUS9Z6t?=
 =?us-ascii?Q?og6wKFMMggvGiFp37UiBGc+q00SXNunRDXY6Xvr3/ACdip0Z6tU0SRya3K+d?=
 =?us-ascii?Q?PrvJ37DgBPKzM+Fp+7DglmgaNA6nt8ooLQwuX8As56ODZcMiPEKgw8tAn/E6?=
 =?us-ascii?Q?hXWjcZZDytyh/s/b830M/5hZS9LEuwJAGYEgiHu5T+wRNhnrdkDyML4h/yZN?=
 =?us-ascii?Q?HdFXTId4pLRgiNKeBG6awE/cGXio5tu0ay7wnDwMgp2MBjVSuSPwZs9azLdt?=
 =?us-ascii?Q?hSRmpyy4fV7021dROLau5DUwHsmjv2DPV9ygdVRGxlEk/Nar7SrsoO4MQF5j?=
 =?us-ascii?Q?ChnzLE9Vi3HfbDi88QMXvh4fi0ae6K2tieiWmwy4MDNfV7k0dv/+Nvtyasxl?=
 =?us-ascii?Q?BrXlDR5WLtEqskjb6DMlC5g4lZZoY7eff3ZIV29Xe/NnQTWzJXlXALFdfEtj?=
 =?us-ascii?Q?xAvSJtbbjsKcePpRkpd0eej4Csr8I1ZAeLWplqlUsoG+9QEiAV5ki+c3NGs3?=
 =?us-ascii?Q?3qiGlrdUmtfy7UFJ5b5q2lUZ2kigdpAYxUDKhyAzimcEpxTG6ima2JJ+hlLr?=
 =?us-ascii?Q?KfnMU+gFm6PM7Ki1v9u7wawaPPnkTi+MArI071uUqD+Udy1A8g1qfQe96e+X?=
 =?us-ascii?Q?zfWGJ/vU4pUfopUrADsF9Cpa72lHVh4OWUDTPEtG60BClhPL60RCB7f+wUBJ?=
 =?us-ascii?Q?A/+Y85HhM17QZ/2oSkieuN5MUNCSK3CqiEfN6SIwLMBNygvzbf0qA3ZASEKT?=
 =?us-ascii?Q?y4ySJhdtsacHqLQIAi7OiHdLDw3eVdg=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82dcf6be-bc9c-4a2d-83ad-08da3333b1a6
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2022 09:50:34.5206
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 48am8hgsyYLIANJ1XJaAsW8Sqf++QwEq1wuLAOCr58B/iKc0LUQ1C0AgUf6MOExNcYnGzANUhFzFA1mDTnE9gA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9155
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I remembered why we had the host FDB migration procedure in place.

It is true that host FDB entry migration can be done by changing the
value of PGID_CPU, but the problem is that only host FDB entries learned
while operating in NPI mode go to PGID_CPU. When the CPU port operates
in tag_8021q mode, the FDB entries are learned towards the unicast PGID
equal to the physical port number of this CPU port, bypassing the
PGID_CPU indirection.

So host FDB entries learned in tag_8021q mode are not migrated any
longer towards the NPI port.

Fix this by extracting the NPI port -> PGID_CPU redirection from the
ocelot switch lib, moving it to the Felix DSA driver, and applying it
for any CPU port regardless of its kind (NPI or tag_8021q).

Fixes: 51349ba7f2f0 ("net: dsa: felix: stop migrating FDBs back and forth on tag proto change")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: none

 drivers/net/dsa/ocelot/felix.c     | 12 ++++++++++--
 drivers/net/ethernet/mscc/ocelot.c |  7 +------
 2 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index a23781d9a15c..5af4f9b3ee32 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -668,15 +668,19 @@ static int felix_fdb_add(struct dsa_switch *ds, int port,
 			 struct dsa_db db)
 {
 	struct net_device *bridge_dev = felix_classify_db(db);
+	struct dsa_port *dp = dsa_to_port(ds, port);
 	struct ocelot *ocelot = ds->priv;
 
 	if (IS_ERR(bridge_dev))
 		return PTR_ERR(bridge_dev);
 
-	if (dsa_is_cpu_port(ds, port) && !bridge_dev &&
+	if (dsa_port_is_cpu(dp) && !bridge_dev &&
 	    dsa_fdb_present_in_other_db(ds, port, addr, vid, db))
 		return 0;
 
+	if (dsa_port_is_cpu(dp))
+		port = PGID_CPU;
+
 	return ocelot_fdb_add(ocelot, port, addr, vid, bridge_dev);
 }
 
@@ -685,15 +689,19 @@ static int felix_fdb_del(struct dsa_switch *ds, int port,
 			 struct dsa_db db)
 {
 	struct net_device *bridge_dev = felix_classify_db(db);
+	struct dsa_port *dp = dsa_to_port(ds, port);
 	struct ocelot *ocelot = ds->priv;
 
 	if (IS_ERR(bridge_dev))
 		return PTR_ERR(bridge_dev);
 
-	if (dsa_is_cpu_port(ds, port) && !bridge_dev &&
+	if (dsa_port_is_cpu(dp) && !bridge_dev &&
 	    dsa_fdb_present_in_other_db(ds, port, addr, vid, db))
 		return 0;
 
+	if (dsa_port_is_cpu(dp))
+		port = PGID_CPU;
+
 	return ocelot_fdb_del(ocelot, port, addr, vid, bridge_dev);
 }
 
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 5f81938c58a9..7a9ee91c8427 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1349,15 +1349,10 @@ EXPORT_SYMBOL(ocelot_drain_cpu_queue);
 int ocelot_fdb_add(struct ocelot *ocelot, int port, const unsigned char *addr,
 		   u16 vid, const struct net_device *bridge)
 {
-	int pgid = port;
-
-	if (port == ocelot->npi)
-		pgid = PGID_CPU;
-
 	if (!vid)
 		vid = ocelot_vlan_unaware_pvid(ocelot, bridge);
 
-	return ocelot_mact_learn(ocelot, pgid, addr, vid, ENTRYTYPE_LOCKED);
+	return ocelot_mact_learn(ocelot, port, addr, vid, ENTRYTYPE_LOCKED);
 }
 EXPORT_SYMBOL(ocelot_fdb_add);
 
-- 
2.25.1

