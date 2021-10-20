Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B702A43515B
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 19:34:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230354AbhJTRgZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 13:36:25 -0400
Received: from mail-eopbgr70089.outbound.protection.outlook.com ([40.107.7.89]:55299
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230031AbhJTRgZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 13:36:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sisn0iDexjNKkeK7O0Ct6hamaN6uB+dlVXBuctUVlp4VcPXv3/OIbLqzaEBu8aBq4rBHYDEfN5f188QY6lhHm1VcvOKQ1C3BThu/A8An5QsXwMGIyOY3uXENK1ZhoCUsyLkkkYkON/rRJTt7/ITItVSoHKsgkcW4VTKE4IjfgzNyhhGx5HLneCUkikSYKyHBfSns+UUCKYk0nu8F7EXI+IjXn/0MdVdoVJfQJiAOsRvP8Z3cX79cRf0L1RPvJCfFMAH4jbbnWlfUl+zXbmT4vJ3KCto8YqSyfsZPV6CrTrP1ArS4gZIriSQyUWNDps9VDaudPWvHn1n89xOz1lo+6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5+F+FTR+auUbc+hPwtmeNvo+LFRzixbj3PqkpkFrOdU=;
 b=QTj3CdEoGRmt+W9gAWR4McZf975Njpx6bS/Xk8lsb5vaqZ9+5apXZ7ShHgahZMb1qKypiwscxqsu7wt0NmS/JQ1F60MiDzy0nXW+7Q6Q5sOQJIsk1jdefQNbZYGnWd5HAZ4U0T1UihHBFYb6Rib1uDMORGrnQtv3AuND10gZ6eswA9xiHBRLMsN/YHE/T0w7ZRf9ZHdHXDKyvFiL2zkxwF1fmwCChamCa3pNlBlhfjCRGoqNxHKo4n0EM1iOj9XepbqB2kxrlQeHh9UDDsZIZ1hlRAuInA8z9ECXYbbBYlidNtBsjGeSEqqvzIPQV8O2uOLAmGF9SVhKERy5sjxbgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5+F+FTR+auUbc+hPwtmeNvo+LFRzixbj3PqkpkFrOdU=;
 b=SYz2EZqiztRZ8Hc6XqdpBV8mGIi50h5dl1mhMzeYmLbduBEgZJ4rqX7FoaG3T3isFtITcK73Glznqw9hUYl5okDw+vo9EVqGtki2CmBNCsvJvSBN65kHmbm2K3jj6J329SQW9qj9DQOQmROJWY86PEp//Djy8NdQ5ZJBV2Bczy0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB6511.eurprd04.prod.outlook.com (2603:10a6:803:11f::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16; Wed, 20 Oct
 2021 17:34:08 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4608.018; Wed, 20 Oct 2021
 17:34:08 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        Camelia Groza <camelia.groza@nxp.com>, Po Liu <po.liu@nxp.com>
Subject: [PATCH net] net: enetc: make sure all traffic classes can send large frames
Date:   Wed, 20 Oct 2021 20:33:40 +0300
Message-Id: <20211020173340.1089992-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0022.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::35) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM0PR02CA0022.eurprd02.prod.outlook.com (2603:10a6:208:3e::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.18 via Frontend Transport; Wed, 20 Oct 2021 17:34:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f248ed2b-6a7c-4cf4-3e50-08d993efd226
X-MS-TrafficTypeDiagnostic: VE1PR04MB6511:
X-Microsoft-Antispam-PRVS: <VE1PR04MB651100C0EFB0F3FB91128C1CE0BE9@VE1PR04MB6511.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h2lDYDHIr+dbbcocjSjXpontnBk52Cotybuhn7WFLhS3gmuQy6gq0Y8YVI3kjhr/xxKwEadX+ih0+7aB8KYAMu5Mohuk+YjDft0bZLMDh7dcAsuQDDkgP+I7ZkLCCUFJfjjSqY+pwvPHp5uRhmlpueTukn3hN7MWsPl9kWsN7U0d7AMTNy53NHen9/WabYR7B7aiGwlkV+lRT7y/tvfba5ekfhJ7au33qWom1Ln9/mSYKSea7BSBWLYOZhBYs5YbptF8Mn/+qeS5MTl2O6ctRMvQo/xNVt2fvDfGUq2K8reNCT62BWvVgUOmnF/ASRwZlhrOnc8q9DBWQ/A7Cse4iXFlbbwe3s5kGJ8ohdvwRbHqcMJEzfnc6v2bPHwZPik3NwUzGXkdD+ZYSPZiafuGhezh8ZHTPDEsUmo41PY5Lq3eD7J3cKPARTxSd3jVg8psBut0rHiUz0xnkySMz/0kHNQmR20aYyeJ2Jg7hECuoWRpz8ELMPVt9qT8MU27hC564aGjsiqWrp7adrpuXA2vOoJkOBcjGnSPszHs9dQY83g0VLY5tfkbb0HO7hvrbYQpxDx9gJA33NAaozmPc9U/8PxpIf2KDJ1jzHoaE11ImHnc+DWHhmMAMkdQD/N0R5TpFfcaKGlLRqDvz1qeTzgTvj83ywP6VPk8tn+y8dKWCkD3IJ+IOFcRv9S7Wb7l2Y8hD0WXFWIsbTUOG0lrpIIXLw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(956004)(26005)(38350700002)(4326008)(6666004)(316002)(2616005)(54906003)(38100700002)(66476007)(66946007)(508600001)(66556008)(1076003)(6506007)(36756003)(2906002)(86362001)(110136005)(44832011)(8936002)(8676002)(5660300002)(83380400001)(6486002)(52116002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wM07HLsrJsSkfzSjRajrpoE7Ixrl7mpmaC4rNzG3TS5ARS+Am7EEp1xaARGP?=
 =?us-ascii?Q?uzizX9PA0bOYg2GOH8l+E8DRv2+gW4mt281UaLRVprRcaotyp8dwLwRMBlXK?=
 =?us-ascii?Q?kcfKjloPPK/HofVdm/w2o+ASIFZUHGLrBpSzsaWRKFwXe8dw2MLuEISyhp5z?=
 =?us-ascii?Q?n15qdA0IoDwVUTkfFiZwZBNXqNqwl8Qhx76PCziusY46QtvgOV+8Y10xr5en?=
 =?us-ascii?Q?P9vax4MjJm/JuvlC4onJlmTkABxbueIwqq4UOLqmEiimYqfJUL57zm4X4QtY?=
 =?us-ascii?Q?fgrlkPi6OUHrKeNaVfhGnD/FdjW/1xRttuknTLiVHvdoyVlpdMtWXl0CJiyQ?=
 =?us-ascii?Q?xGD+aQOrB0pDILC0uUqaDXdzNBBkk6R2/pY7Xtn9xSgyW4+HVyJCD4NkHfsd?=
 =?us-ascii?Q?LBIB6GuFT8gWXLc4gVwFyx6h/6Orbdu2nOYQJ5WJRGi1vi18+HrC4VAYZcJS?=
 =?us-ascii?Q?s5x/ZVd4p02CK8oxWr2C0EMJzSrEBQFfWiZIB2DX2yv8cAhf1T4p78TMDXle?=
 =?us-ascii?Q?C3pmJbYztZWKbJpiBaFhD6NGeGOqGltz60d+uuEYTy9UGaAJqW6kFMacRU4F?=
 =?us-ascii?Q?Lh5MY3/TYfgBga+ak0ryZvLD2N4EIL4BLIIqkLFq0PdhYOra1M4d7zxJz6wn?=
 =?us-ascii?Q?iq+Y+VvJfyowJqvv0FMXiOFkQ1t78nISEmO6iQvPSiYX9znDw+zwyFdKPoKX?=
 =?us-ascii?Q?W8iVo1IPyl0DTz3fddFnhlQR6iYU8E135678adGNYJcqVFL3EN/VMiq2WTRB?=
 =?us-ascii?Q?JyIAfDqC1bBssnzr8Tzt7h7JVCzZM0TFXpxHjnR1pl6MIlIcsl0oc1j6r1G9?=
 =?us-ascii?Q?ZLx8063PwsfflYN/hY7NEBy8qj+hQVC7bxHfJCHqJ2ylK/JgeJKQRCQekRxJ?=
 =?us-ascii?Q?g7DqtiGmw6zNHu4fxCb/tZfwxl8Pvig4kKVm4tWqCc+fm3DYbEkhQN6QcV3x?=
 =?us-ascii?Q?8A33G6Nq0Mk32+M5dVhCYE/UyYypp4OAkkeOAdC2pR0Tkgdu97tLfdklxA9z?=
 =?us-ascii?Q?cHDAeAoe4Cx9CuELRJDS7EwQF25EocjLhkDPMF2z0uUZd20RgMZJwKyAiq6J?=
 =?us-ascii?Q?vgyXKjiIEzb0Q/bfOPx8T0iCPwZ6DGaW/DBCbqMJAS7hO1Ep1OhfqxAiz6XV?=
 =?us-ascii?Q?JLF7Sh8z33uEiQxhQGVRR9YmWNPy3fNBB5vquiNzAxlkJZo24V5k/wPX8+0S?=
 =?us-ascii?Q?eBYneUmMMr4GSkwzyBD8A/7NVo8X8JT3WXidCh4ruUEk6+lfad/oiDT9LQOy?=
 =?us-ascii?Q?mK0qyB6LD4adzmvn03WWZusqiyj0YAy6ZE9SmEk1MlGBHtn4z7hynjaal0GC?=
 =?us-ascii?Q?KTfO3dKTFCeuwvCGfwHISMevmR7Re1aXL6ZHzVfPwiE7r2CmU+14eX3z1ZHA?=
 =?us-ascii?Q?yATyWupUjh2VmRyvETkQjC6edbFsZT09QLMsWjmbBXvhnc7YtEmLAg3ttZDI?=
 =?us-ascii?Q?3DfhC6lSl066zyXUDnc3RYBwSCuILLIZr/l+b4JM+MiNbSsaqZdARy8/JW3U?=
 =?us-ascii?Q?aAYR043RRxtO6yK9ysIlNfDw0gdSBluVuI5JCjEN9FoUA0NJ8ybhCfvvsVYP?=
 =?us-ascii?Q?opnCTGABlfNBztlpFV/aQTP3aaWPsuhzYopbon3s+lUQESwwPgX1M9x3UuvS?=
 =?us-ascii?Q?nGfzotSNG+XoIxHVGhDCQIY=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f248ed2b-6a7c-4cf4-3e50-08d993efd226
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2021 17:34:08.3553
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pPQE3PlkHdo5AXDY/9JCpbvLkezHhnmHkKuuEp9GX28oBWPKs7v7Top5lhxkbP9FrwpHSDjwVwinArDDSBiyHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6511
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The enetc driver does not implement .ndo_change_mtu, instead it
configures the MAC register field PTC{Traffic Class}MSDUR[MAXSDU]
statically to a large value during probe time.

The driver used to configure only the max SDU for traffic class 0, and
that was fine while the driver could only use traffic class 0. But with
the introduction of mqprio, sending a large frame into any other TC than
0 is broken.

This patch fixes that by replicating per traffic class the static
configuration done in enetc_configure_port_mac().

Fixes: cbe9e835946f ("enetc: Enable TC offloading with mqprio")
Reported-by: Richie Pearn <richard.pearn@nxp.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc_pf.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index ead2b93bf614..64f92770691f 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -517,10 +517,13 @@ static void enetc_port_si_configure(struct enetc_si *si)
 
 static void enetc_configure_port_mac(struct enetc_hw *hw)
 {
+	int tc;
+
 	enetc_port_wr(hw, ENETC_PM0_MAXFRM,
 		      ENETC_SET_MAXFRM(ENETC_RX_MAXFRM_SIZE));
 
-	enetc_port_wr(hw, ENETC_PTCMSDUR(0), ENETC_MAC_MAXFRM_SIZE);
+	for (tc = 0; tc < 8; tc++)
+		enetc_port_wr(hw, ENETC_PTCMSDUR(tc), ENETC_MAC_MAXFRM_SIZE);
 
 	enetc_port_wr(hw, ENETC_PM0_CMD_CFG, ENETC_PM0_CMD_PHY_TX_EN |
 		      ENETC_PM0_CMD_TXP	| ENETC_PM0_PROMISC);
-- 
2.25.1

