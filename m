Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 468D04846C3
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 18:14:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234359AbiADROv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 12:14:51 -0500
Received: from mail-eopbgr150045.outbound.protection.outlook.com ([40.107.15.45]:22762
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234561AbiADROi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jan 2022 12:14:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d4qQVQAmWD0FxQp7HuvXacfjdmz2+Hhr7aaUveX24djwddl9RAHvm6nMBUB9yiK2tSD6qkrSeafByLcmo8waI+VEJ9S8+qbad88u2q4DPNUqlj3Wd8zunHJ/nZs3K2VCrN2NkOG0H6ljiz3mHI2hYXvSuVdslGJYlkEnkr44OctQaZOfdR6Xgu7fcJhJm8ghDrKVzvV+X8sq1zPvO+ozXFOB7FB2HczscOgu2yzuChdaGHvweELlHAYTDGVdnJd6zXSH0NuLKg95MAEgDWa4ADFfXLOpULpbAzVw1f1sqYhlRxqzN4WjO4B+LxJNdsRplCZtB5k972t3Qb6r6b6MQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HaRSNNiMBiIhexsZdIJXTpbjavnD6hm4BOBeFKlTttI=;
 b=SoIRBXbyPU4rGemMeh9A5N6uOkfBn3mJpaqKJM2YC0AUchl6MA4cKlxCVSVNTVGj6bb6rqiXTLAE+56TDB0XudLFleMhoRxCDUNKjmDKxY1wvP35z7+yj7CNvt9uJG8S9hXj6PdqVGMr88YA7m7LFL4YHH715+WOaIsOKPgSueoRlu0oLxebhfZokUYIX+eS9aQ3k278mH8ujKa4Djsc+H5OWpZmWQZUd5BY8EVA2kLNiaGd5cvgUs4JX3Gp2Rn3uer2kS3rJ20wi1FjVTva2xnKbmxhUdVhuGp/bnXBS6FDWDwIep1NTuaUwp4l/0lZ5cz5ucMXLbNZIz66Q2NgXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HaRSNNiMBiIhexsZdIJXTpbjavnD6hm4BOBeFKlTttI=;
 b=IjP+xSZxahhCfA4+QBr0NXmYkT/1lq+VTYf4Y/DanYluRplopi9EOEF6A5zozmogTA7rpXonDHyTc3vkBB8mMCw47LgZAexSW+rpDvHKlNumkuCmHfpc0A1IVJyd+SWip+8IDrMHNPDERKVoPtOIx3ZPP9K0EynkFBA3qrm72rk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB7104.eurprd04.prod.outlook.com (2603:10a6:800:126::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Tue, 4 Jan
 2022 17:14:34 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4844.016; Tue, 4 Jan 2022
 17:14:34 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH net-next 04/15] net: dsa: hold rtnl_mutex when calling dsa_master_{setup,teardown}
Date:   Tue,  4 Jan 2022 19:14:02 +0200
Message-Id: <20220104171413.2293847-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220104171413.2293847-1-vladimir.oltean@nxp.com>
References: <20220104171413.2293847-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0192.eurprd02.prod.outlook.com
 (2603:10a6:20b:28e::29) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 855b5ee5-ab5a-4508-20d6-08d9cfa5ad9d
X-MS-TrafficTypeDiagnostic: VI1PR04MB7104:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB71047C4FDD3384082A33B42EE04A9@VI1PR04MB7104.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sX8/f2gFCxNWOGMun3J9ZPolci9plfj1zCVMCabYCaI+P3ni9EseW5QEfu9EQCbgTNufhFv8CSZTgQjHA9Lq3ujmB7ofsceIoF/Ky6gfM3Hox6lmDdwk8VtU2BHbbpdwTKfGzyJsDBzmRzvBF08sI1hTRjisbHnvIplc47VWnUclpK5Ddu21AjaaoM30G4dJ/j3c19d6YbEMzEwB0kysN5zRNOc5LtzEECZy48Et55IRyn1kV5HWxkY4DaNyTLfQVtclMIYLk+9Zxli+JvsSIfmkmFszut9H1mKUznNhRqWX3Z7227DqNTyoW8kc9QNz9GMMOfKxwh0YNgjVKgvg2BHqsAQIVfSglRvzuNVrJYKk9b5vEiulk7cZzCZh09WgdsUDnNZ2F58yXxlm7CfBBs9a+rZkNon++5CYveLgWt45SXymiyowM+C7sQ4/DYk65ORZp4IFSmFPZCCIj2fgeQsscN/MoUbSp9SQokgFSazh46anmbF6aWxznrAAgkt9u/CBRbeINbgzr7qFGn9i8VmIvbV9zia+oB5IRqeYq+pCzF4JxRg0kbBcN2Ry21LSR/uNaPIzRCtQAqfFLy/G0xGvhbg86lmIRdA2XS/xeYST1PDLr+78ywXVrUAh1Wva3oHQzJPMmdtNglzpp4DEGscpZmR9gAIahRCYTsvleH5PL6cnyth/G2IbNV2dYTg2VbwMkrAHuQbyFmkTF2VM4Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(54906003)(86362001)(8936002)(8676002)(5660300002)(66946007)(6506007)(52116002)(186003)(6486002)(26005)(6916009)(66476007)(66556008)(4326008)(508600001)(38350700002)(38100700002)(6666004)(36756003)(1076003)(2906002)(83380400001)(316002)(6512007)(2616005)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wKkF/tOg8b5506EmkfbORRfEvnpI9k0RxwOZ/FZC9jqFqFIPDTliw08UG8kc?=
 =?us-ascii?Q?pybzgmUZOEM87/QuXc1/PqbPcOEJHTsOzpHGFJSsMNqNCH7Xeku/ns1E83Dh?=
 =?us-ascii?Q?xVHYJcrMcv7135WIdJnyhTxx8fS0zuRAt30IOCw7Irdkd6Ggas1c1lfZ2eNL?=
 =?us-ascii?Q?91k2l8UdEJYwy3IF2qRP4Z2zdsW009t8k4MCG5AaOr2o+JUrcoGbPYblltYE?=
 =?us-ascii?Q?Tj88bR9CBKgA4t5jUssPDeOMGNZaUFsq6AWhXOuT0NUL5MHbkklxagb8sAul?=
 =?us-ascii?Q?bCARr6713DVV4f9jkqWJLsM41JkCldUPwhbCCUzGQ+EMvkMW9ckFU1fr2C87?=
 =?us-ascii?Q?Wa3wHf7nJt1uKQUudIIh063wsjGdCQEm30OD+93ucryvZ7TNgFzSVKMJbGND?=
 =?us-ascii?Q?PqCev3dxQAjcbNzJke3QF++mt45zEYHWng+z9Wb3nbPgOsj33Q2vhUngyLfa?=
 =?us-ascii?Q?ExIvTKeRlAP4muvET0oZeWIxLo1Ka+9CGPs8Q0JJX9h8u7BrCwLD3BDvOSI6?=
 =?us-ascii?Q?XSKELQ/zzhZcn31bp5Ijl/u0APix7AgGjUbJsSfSvNesSRkp6/bRmwRPh8Hz?=
 =?us-ascii?Q?qOiTCNmH4pZUQ7n5PIPMSs09v7xecrowZZKLr7MkXO6oyvBaDgjWWBGR0J7p?=
 =?us-ascii?Q?OJBcGhm/FwAwPtu9pENuxmpnqoAccpXHWq8QAtE8mvUNjJWYrhTJpvh8YT9B?=
 =?us-ascii?Q?a6M75brzlX2fbNC0qwWbOUbtsTgnPMoObE1gd/d8tcr97Ok916QUDwM/bKNF?=
 =?us-ascii?Q?6rCkPJ6pTPS0da6oS8rYXRifu7EBwvbbdHmsjognTUoS7UgUFAUyGPQnaktD?=
 =?us-ascii?Q?BuKyKiKYyM08oymlno29/WT96kWFcv96Vf58hIeLqKJbiTMxubyK9cYSzClb?=
 =?us-ascii?Q?EuQETgNn0Zri3dr3VgmidjiUq3gNI0j1mW5Ad0f24ZvlEiqW0HzdLmoqLJ4K?=
 =?us-ascii?Q?whYlepmOZzi856tGCKE5gbjQPyPab+XNh4DQFhwYzy56cGq5Z8MO2Q8Naewo?=
 =?us-ascii?Q?DtOMXJDM7QN91vAeSXSQfygES4kCO0GOy+52VIc8H28ux55pX8k48K7NrFL4?=
 =?us-ascii?Q?oRMYdx5shuQ3gzPMfzW+JV0TS9O7QJ1dwNnKVaq5UJNlezVv7uomRcV4LBPN?=
 =?us-ascii?Q?2nA71epjAk53i2Ad6DYcWytJCYakEMVCVglA2eYt7vQYMOYRJyagNgPFOn9u?=
 =?us-ascii?Q?TNnNi85R5th1yV/17EXXdCtB61MTyGwVHOP013PA2o/9IOaZaHcbnWqmIFbk?=
 =?us-ascii?Q?i2oB5UcNi5rNp3cfnNCSZNmG9ruu7EvCQ3GWI8SIglOJAV4t1dvv8cL25R3l?=
 =?us-ascii?Q?ZMPEzc1lK573Jio4yIeouD9r7uHyJLCE98cXxPcUtaaYxwV0FyXZlyH7ULiW?=
 =?us-ascii?Q?G1ddABdnMwxOirfHI00QyL5lMO0DlB+FS3wjjb+NRibQqdPXLFHmu2b5Wzf7?=
 =?us-ascii?Q?TbI2BJVP5nyhSKXzo4LqphBcDaKdbyqfLqhNar+tD8eIF0kBQvuBw58RIf87?=
 =?us-ascii?Q?LTiUdVCg4qizgftDO/V0ub7gbgsIdTbIRBmOd4MOSC+WgM+xfEOHeaOOA82d?=
 =?us-ascii?Q?dca4kNuBS3Mob3pklqTmPSlDC0oObz8XPFwgKdQOnkoYUeMRvXW/Fvuz/DQT?=
 =?us-ascii?Q?FX/3dbaVgrre1LyAN5X88TM=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 855b5ee5-ab5a-4508-20d6-08d9cfa5ad9d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jan 2022 17:14:34.0351
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qlHaQBm2kRWoG7wzep7Np18La/UQYzNcHR5pAba+8mxGoiLMJwrerR89rg/NPSMSigeaaLdV/sIPhkz5coLPtw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7104
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DSA needs to simulate master tracking events when a binding is first
with a DSA master established and torn down, in order to give drivers
the simplifying guarantee that ->master_state_change calls are made
only when the master's readiness state to pass traffic changes.
master_state_change() provide a operational bool that DSA driver can use
to understand if DSA master is operational or not.
To avoid races, we need to block the reception of
NETDEV_UP/NETDEV_CHANGE/NETDEV_GOING_DOWN events in the netdev notifier
chain while we are changing the master's dev->dsa_ptr (this changes what
netdev_uses_dsa(dev) reports).

The dsa_master_setup() and dsa_master_teardown() functions optionally
require the rtnl_mutex to be held, if the tagger needs the master to be
promiscuous, these functions call dev_set_promiscuity(). Move the
rtnl_lock() from that function and make it top-level.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 net/dsa/dsa2.c   | 8 ++++++++
 net/dsa/master.c | 4 ++--
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index c18b22c0bf55..f044136f3625 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -1038,6 +1038,8 @@ static int dsa_tree_setup_master(struct dsa_switch_tree *dst)
 	struct dsa_port *dp;
 	int err;
 
+	rtnl_lock();
+
 	list_for_each_entry(dp, &dst->ports, list) {
 		if (dsa_port_is_cpu(dp)) {
 			err = dsa_master_setup(dp->master, dp);
@@ -1046,6 +1048,8 @@ static int dsa_tree_setup_master(struct dsa_switch_tree *dst)
 		}
 	}
 
+	rtnl_unlock();
+
 	return 0;
 }
 
@@ -1053,9 +1057,13 @@ static void dsa_tree_teardown_master(struct dsa_switch_tree *dst)
 {
 	struct dsa_port *dp;
 
+	rtnl_lock();
+
 	list_for_each_entry(dp, &dst->ports, list)
 		if (dsa_port_is_cpu(dp))
 			dsa_master_teardown(dp->master);
+
+	rtnl_unlock();
 }
 
 static int dsa_tree_setup_lags(struct dsa_switch_tree *dst)
diff --git a/net/dsa/master.c b/net/dsa/master.c
index f4efb244f91d..2199104ca7df 100644
--- a/net/dsa/master.c
+++ b/net/dsa/master.c
@@ -267,9 +267,9 @@ static void dsa_master_set_promiscuity(struct net_device *dev, int inc)
 	if (!ops->promisc_on_master)
 		return;
 
-	rtnl_lock();
+	ASSERT_RTNL();
+
 	dev_set_promiscuity(dev, inc);
-	rtnl_unlock();
 }
 
 static ssize_t tagging_show(struct device *d, struct device_attribute *attr,
-- 
2.25.1

