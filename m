Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C07A251C50E
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 18:23:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381909AbiEEQ0O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 12:26:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381892AbiEEQ0L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 12:26:11 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70043.outbound.protection.outlook.com [40.107.7.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85DFB5BE53
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 09:22:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ui/aRk/FjzTafqFogI3nX6qTk1Ae0Q/gEJWP4e4Q4qlEknP84x8i8iXNue3Ixbq8AAfWNmgaAsaVOcR/zL5vb7/L90AliIl4IIxUOp62mcz/U4S3XkFzqT1MGc8Vu+FkZF/9wJ7yNmaoecqY2WY5dkMhSekxocvUTfoPD/8uFYe+WazYG9ZRTyl2mDv/BxKE7inwYorGKu9n2Il6exgf9wqZdit+psUz8kgxZ9oqQeVgJrr/y56YDLByx1B+6Zf102LEaLY32DgCqukSFzgcACFcCUAQXIGFLd1opmJWAvt7Mk+qBuwDX2DfJCI5Cx2aWJBDFA7o2aG+8EJjhqvv/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RqRsV7FQZO3a3epj9wu5gVdh3taaYLqwDKmsatnu0yw=;
 b=Wujn9okN9BXKYZ8NKsefmJmbNqmEmECUzEsVg0nyyVx5RbLmYIgr6eOZHUAcpyQEvw3FTMSf3U0zfVPva/DJTRueMzp2V58ul3ebquhN1lSGM3RcifO37s2oEdW/LdUJXbDyRV9VsYLH6xBNenBv0M1/W73w9vTkWpn3O8vElNp/M1FeToORROABUw68em5tkE2ojj2ZCoaJqHIJ/lMbcfWT4WN+7++jaCPyj4thbOi5K6qlyiVuURnwu14CAaa9zJkNOdcMldVHR/+6bn7dlrtYisV4MkAyYrEM13Qzi+baMpILcZvk7iwbPVnh4zTXkiTp25LmkTm8v1bmNnk+Nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RqRsV7FQZO3a3epj9wu5gVdh3taaYLqwDKmsatnu0yw=;
 b=OsJAxfOis45SfSHNTYTssgwXUEsX9mre7ZYixTUSGY5BJB6bKo5n+Q7uCS+h+SAZEHmfWtixtf4nuLKbPgGZtB9nT9SJ7P4iyf1zAeXr/kEu0ZK8tnVmYTgOlELcDGzCeyy/csWfzaBAAYKDDuO880Opi/Nkd2KVx7QBHXhst0Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB5522.eurprd04.prod.outlook.com (2603:10a6:208:116::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Thu, 5 May
 2022 16:22:28 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::d94f:b885:c587:5cd4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::d94f:b885:c587:5cd4%6]) with mapi id 15.20.5206.025; Thu, 5 May 2022
 16:22:28 +0000
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
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Colin Foster <colin.foster@in-advantage.com>
Subject: [PATCH net-next 1/4] net: dsa: felix: use PGID_CPU for FDB entry migration on NPI port
Date:   Thu,  5 May 2022 19:22:10 +0300
Message-Id: <20220505162213.307684-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220505162213.307684-1-vladimir.oltean@nxp.com>
References: <20220505162213.307684-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR03CA0021.eurprd03.prod.outlook.com
 (2603:10a6:208:14::34) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fc4a427f-f63d-4548-f914-08da2eb37248
X-MS-TrafficTypeDiagnostic: AM0PR04MB5522:EE_
X-Microsoft-Antispam-PRVS: <AM0PR04MB55229BA80EB938FB5D4948FDE0C29@AM0PR04MB5522.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Rg4NxCb4eKFYLoswWsdFLN8BYy38ao/Uz5fnOsZlRKYqapjtlI4XcP5jC/S+lKvyrmpRJsg7ag0sik3/BOwuCfvVI/ryFFpRySkdsTMN7A8/eUGS+pFuFslwzLoOb0YSiG1lUXPxjkO3KBd1mPhScrDpKtq6pfvDU4JC1wuxXONgWi02vZghtBv7uCG3M5Yby4T90UqJQQ7p2/GPeI6TTWvjSiJW3Iw0/w8Rxm9Ra+Te9iRhuXMZBgzClzPEVf5uhmrWdnjr7UPC2rrvv0ideY27p1kYzhcKGeCrp4ssRzKhUXvnfWyjaeexj4XX+ZEmEqcPttIf6bNBIQ79uN/Jdpd4YNtYHdQvpIwjI6xw5ieZAnh6OTPBq7TUBkbZaBkOgJFOjnIpHasGrBQ8qGPAzoii+7IpbUWjjCIAg9HnJffCnUWiHbCKwjN3X/tQiTSDwEbexlDTpcHfEOtBSfn5VEVysvqGQ1dMaxbGXe3KiZesK703UzQ77OB0Zw0m/sedgtTYsgy6dayIDaxOp6m5lSPjX9yXRt/kGL5FZAZR/DH3PRBWvEeDJeuvHaqf7fh7ClpXxIvDXTeZpXnubHqdzSJ6ZkKx0v4fxTp6cPHCR5nmxptX2+3RtLOP9nGvnq2XH9IEy7gH9PQJau3JzajcGKBwUqr7lAWdZ5RE6bFp+AORmALemGb+njrlyWNmYlzMC7hqF6kzzdUALJwgBFJhSA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(5660300002)(7416002)(508600001)(8936002)(6506007)(6916009)(2616005)(52116002)(54906003)(186003)(6666004)(6512007)(26005)(36756003)(6486002)(44832011)(83380400001)(66946007)(4326008)(8676002)(66476007)(86362001)(66556008)(1076003)(2906002)(38100700002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?G4ULvTRdIXvNijdrv3HW9WQBCH11hyly88NsbCUUI9Kxn4Un7RsMVWl51zvG?=
 =?us-ascii?Q?i6iUjwZrqcZ+Ch68fOdTjBnyup9SMcaQcBsvgHu6/P1eBS0gqmPYexV3Uea7?=
 =?us-ascii?Q?IdZ3HtvSbFzo2yPnsw88Ir3LB2WYxpBA+mpeG3A8zLZrQjg/9BrflhUMBS5e?=
 =?us-ascii?Q?wfj0dIWuiWW/usKkb6xiZ0wtCnCSvyKX1Izb0o/dp32wEF489A8hJPrUgbuf?=
 =?us-ascii?Q?18nVAvBfFSY0m9+reSQoFrmk4RDLUyXww/JeeTuhBjxFvnruIscsKX0UScjb?=
 =?us-ascii?Q?8FygFpJtsn4GmEwVCfhEBrpgoYe+Ud5t33gmN5kx2JySqXTM+CK0THwVe0VW?=
 =?us-ascii?Q?cIYJo2cM7wDareepMPCTNmA25TT+Xgt2YcHCc/rAe/13LDeKzzWkgCkJEy4j?=
 =?us-ascii?Q?ijeM76P0vG3E77rTb7USjx97D5MHBcH90JA8fnveAX0gWDa0VH21Um0w6Ucq?=
 =?us-ascii?Q?DvsaiP0vmIjm+6SsnG/V55WAMfboR603X+k/KFcJkI1RtadPH4EuMzdHMKpc?=
 =?us-ascii?Q?/PtJeMlZI2G95mcXFAIFlSQGKc6FsqC89RyNmXDYGmC+ZyfZmyY2ULGOdAHz?=
 =?us-ascii?Q?fU6VRgBIi0cUYrRmfDzo8yg3Xz6uT/+lkuJRJOB2JJhUBunaYcuLxEeB/8//?=
 =?us-ascii?Q?yCzb2aol873/Rd7MizZanrqRWe+1D7Vl1eaM+IgItI2OvpMAj5JOKnAfNW0D?=
 =?us-ascii?Q?kzkBUs4eVMWP8oXGlov+54I0Gmu64h/n9KbAXJQ4DQHIEFsNdwMU9yo4XatZ?=
 =?us-ascii?Q?y6bwpZgJa5TwztvU+9Rbau7CAf1ugcWXCRQ28mCQ8RlcfL2ZbY+LHgze8TFx?=
 =?us-ascii?Q?mLshl1c0MfPj7B5Y1Wmqn2PDrdLdaQx1Eopn9YnJ0w6xQGW8Mj0tdgwb+2yA?=
 =?us-ascii?Q?SNf39PIkknHbmbhkKeAWNDPkobUfkaCIyay3eG1+OSZ0hnoI2woOVwL03DSC?=
 =?us-ascii?Q?qF5iagq5T7a7Ht+atI1z6VEI3vValw6ZNMhUH9HvXUOQ51dclAzus3o78TZc?=
 =?us-ascii?Q?y5MEFR5nUJNBW4iYAfOb6sfzxRqMrZqnbblFI0UO9HfjFVtzfFnYTz88soIt?=
 =?us-ascii?Q?NN5eFWuWByVS1sCSnfXDme9k2gXWOy/wlo2Rta6vhJJS4JGBDMFP0XtxCAOJ?=
 =?us-ascii?Q?xbWzezD2YZZE8MxnhKp2SV8G81MSMnnKNXcpD0TKBYckMtRV6MWVSuKclSqQ?=
 =?us-ascii?Q?fNAxge2ITHI32mCcqfrEIbgGZ0LeC8f2uL3Lol5yVXs8XzDApyYEjuaIEqJL?=
 =?us-ascii?Q?f4BU7LRCe4b+1uizhUK0SadeISukWxgfAZXQuRoURQcdJcmEu8l4dTQY70j+?=
 =?us-ascii?Q?vhLOS1HpD5e72pWkAwVERMDky42c+yOP/bKtjxaRdg46LvQveetRXRh8yR0Q?=
 =?us-ascii?Q?SVzKjgAI8BZOfSxnxuM6qRPVKh2Wmh5ekx9kPclHeywysKREX0vIH4nDDwkq?=
 =?us-ascii?Q?nwxgSAZPDXZPWA2qb2R9tLyYnratotEoXwcEvFgUQR45p48YhyKuauaZD8iy?=
 =?us-ascii?Q?m83OPx8s+s/JBb6WqM/izbhxFm3sylSblWjdA6ml9dAfYJbditEqvNq91ujy?=
 =?us-ascii?Q?FTCn5dYFaGrxnnw/m94QIIN0lkSZj7cehVdq/l3b9yvreVgYtNkjAKeD2lsS?=
 =?us-ascii?Q?oYdVZ+qeRoeo70ClETZdVInawkRtKJDs3I3L+ev7bqmTcvqZcvsu4YXrHaKK?=
 =?us-ascii?Q?Y5Bbwlu5cr015KoaNdcIxJyTEau9dc+SRjX5b95El69WJNnOqRy7URqGMxe1?=
 =?us-ascii?Q?pbHsqzTslcnyOg/TIfrTmoR80nEHKK0=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc4a427f-f63d-4548-f914-08da2eb37248
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2022 16:22:28.6348
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bOAZIkuIs4e9Kr8UiLoTqUD6zIkJupImA3NljuiqZ4Z7OGdI+Rt8iYv11UVisRAhX64SZp6isU2z3OpndOlsfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5522
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ocelot_fdb_add() redirects FDB entries installed on the NPI port towards
the special reserved PGID_CPU used for host-filtered addresses. PGID_CPU
contains BIT(ocelot->num_phys_ports) in the destination port mask, which
is code name for the CPU port module.

Whereas felix_migrate_fdbs_to_*_port() uses the ocelot->num_phys_ports
PGID directly, and it appears that this works too. Even if this PGID is
set to zero, apparently its number is special and packets still reach
the CPU port module.

Nonetheless, in the end, these addresses end up in the same place
regardless of whether they go through an extra indirection layer or not.
Use PGID_CPU across to have more uniformity.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index a1b6c2df96c2..6bb10a0aa11c 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -49,14 +49,13 @@ static int felix_migrate_fdbs_to_npi_port(struct dsa_switch *ds, int port,
 {
 	struct net_device *bridge_dev = felix_classify_db(db);
 	struct ocelot *ocelot = ds->priv;
-	int cpu = ocelot->num_phys_ports;
 	int err;
 
 	err = ocelot_fdb_del(ocelot, port, addr, vid, bridge_dev);
 	if (err)
 		return err;
 
-	return ocelot_fdb_add(ocelot, cpu, addr, vid, bridge_dev);
+	return ocelot_fdb_add(ocelot, PGID_CPU, addr, vid, bridge_dev);
 }
 
 static int felix_migrate_mdbs_to_npi_port(struct dsa_switch *ds, int port,
@@ -128,10 +127,9 @@ felix_migrate_fdbs_to_tag_8021q_port(struct dsa_switch *ds, int port,
 {
 	struct net_device *bridge_dev = felix_classify_db(db);
 	struct ocelot *ocelot = ds->priv;
-	int cpu = ocelot->num_phys_ports;
 	int err;
 
-	err = ocelot_fdb_del(ocelot, cpu, addr, vid, bridge_dev);
+	err = ocelot_fdb_del(ocelot, PGID_CPU, addr, vid, bridge_dev);
 	if (err)
 		return err;
 
-- 
2.25.1

