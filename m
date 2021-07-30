Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EF0B3DBD93
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 19:18:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbhG3RSw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 13:18:52 -0400
Received: from mail-eopbgr130043.outbound.protection.outlook.com ([40.107.13.43]:45569
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229953AbhG3RSu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Jul 2021 13:18:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aP22nUjuUvDJzgCjGdW3IkBiwGJfaqAalymZ5NY6jFsu7uFkOdb6UvbBNtvBE3Dkcm7f/q+i/uM4ks8RGKs9VUjHPXh3Z7yUGGR4E3bziHUf3RLZF/FNVbJ7qj3mNAgALLi01x43CsCft5w39VwZdYiNzjN8sKb4eNQZ4GfKR7MRHzRpIz7ohw4s6yCOl3bj/mZWqHUj1TrvSfu6sL63CLkmInC3OS07d6M7qq8ktx87/zX94B6hLt6VGRJ16PSLgSXLRyyAC/AeL7Enf1bOuijL0GcuxM/M/wHtel4G2/HoZmbWLNVaE577MQ+LkCz9IhMP+rgOLovzDdWqtTzY5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=thfhnqk1nzamhsLZzBgflLeZb8oStp2ZYMO7t5Mw87I=;
 b=TNa0FHDO7YQckFk6BKKDj7YRFt0y/sSZ53kz3c91aWoleIc1rXe7LERzNCVOahVf7/c0gV4Twj9WT7d8NQMQRJEjt9dtB9Q2hthYeXEt8JiQ58Z3ZYNqDAsLr80Qc1jQd+nJ+rUpsybiZMBX/C5c+sZ7+3dIz/MMu2lBaUiffXS/n25wQuCQvCu/85WisFqY2eUHPuazUT7cEs8jMp+ymZq10Cr37mDiCrUM17VXfipD944qQVyn39Bdowa9b3yBQjfAQle8eRYQAAQlasjNUjLVuKxYqtjzgc8kk82jnIgIT9Yl5BuXb7dTxnJL2cbIvzCNIVZv7V5fMPc2Bm590A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=thfhnqk1nzamhsLZzBgflLeZb8oStp2ZYMO7t5Mw87I=;
 b=HbivenGhr10LDMB1fN65vo3fFrL0uX1Gizgp7aTn/2fmWUmaT4dP7JJahohYK4/l31ZAZx67AOFaVMgBfCwfReKFx0G+noKq4R1vo5KnsObhCh0MzkZhMCJSz0eUAhUvdgYKCkTIUu5Db2xIbFM+oBaz0PTbqKV9LIwZqD9x8rk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB3967.eurprd04.prod.outlook.com (2603:10a6:803:4c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.25; Fri, 30 Jul
 2021 17:18:42 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4373.025; Fri, 30 Jul 2021
 17:18:42 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net 2/6] net: dsa: sja1105: overwrite dynamic FDB entries with static ones in .port_fdb_add
Date:   Fri, 30 Jul 2021 20:18:11 +0300
Message-Id: <20210730171815.1773287-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210730171815.1773287-1-vladimir.oltean@nxp.com>
References: <20210730171815.1773287-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0202CA0008.eurprd02.prod.outlook.com
 (2603:10a6:200:89::18) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by AM4PR0202CA0008.eurprd02.prod.outlook.com (2603:10a6:200:89::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.17 via Frontend Transport; Fri, 30 Jul 2021 17:18:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fa8e0e0f-2805-49b4-657a-08d9537e142a
X-MS-TrafficTypeDiagnostic: VI1PR04MB3967:
X-Microsoft-Antispam-PRVS: <VI1PR04MB3967536C2B4659C7C9B153C8E0EC9@VI1PR04MB3967.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7EDmc+cx/9TWtb/PCarnjauoGDP0yYory/nO4VId6AOfq+pu4W0YwmcKbozAsG4SM7UwGMZ4/WkgiGTsV60CrRj7HOrYg8Ndn9zgD1VSBfGrZflFrve8H6w5UMJ3slTM3jSawdmj7B7HBczrWRMiBd1QAbAz4y0AmjKt90X6cE+h2YDiTghwk5pLrcr6u0Zs8ljxm5KEkgaVEnnykpqLotpofTTg6YD/rGusdUwans8hG9Y31JiLoIT29G7vhOjr+38l/cmDUQ33oPfHLGBHxJoxuUDaygBbqLEHOFOwpgQ6LPCylxq/IAmGdQ6oY5ZlaJjclf+yuc+8cq7OQhRgSHYEOGoaskyUCmCkhCOGbH7fvViWlbLq8OlutYgexxmAHTGmzFKSecENYMho50QMUEPKZ+nGQfatT0PIrPUatBN8Oa5Xz1qOSIU00lYqN1kpR0wKxt6pVHuq0Q74lC0hBH6IewdI1dIpBVKO76jHO7IpLOR9xDCQKJPP7s+/hb8CdtIHAGAy7yq3XonWCM0/RBTRkeM5dh1GxG3tX4wsIFE862f4KmtiJYFLRmbm9RAyhLMk4d0Hvphxfa2zzD1YkCUVzlDGgsxt3eQo0Y/gNn3SfbTs3Y18R9OmgHr3J++5/ehlIncyJPeYwO/uGBS0nN3noT4007Ek3iL1AfDRIp6gzBRiI09H/A/tQ3mQzR6SI7+634hS4QIZV4nVLJVkHH5O+RBanY+563W7CbTWAxI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(396003)(376002)(39850400004)(366004)(2906002)(86362001)(6512007)(6506007)(478600001)(956004)(83380400001)(2616005)(316002)(38100700002)(36756003)(6666004)(38350700002)(6486002)(44832011)(52116002)(186003)(4326008)(26005)(66476007)(8936002)(66556008)(5660300002)(110136005)(1076003)(8676002)(54906003)(66946007)(142923001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?J0M8fxbXkm1R1lYaXCFhh0f4UEk9ONyRnns/0VWQsBDV5JdPUp6KP6byNkWT?=
 =?us-ascii?Q?p2DF5TG8ntYJs3dKZwU4s2RkT/QMuaB+hursT5KEkdBneFbGdq61w6K6//UY?=
 =?us-ascii?Q?RJ/dUSYFsKphXjsOpgSHem0ROwG2oJ9tJhEo3aYSHaeSfjOsWV1d/yCWNiRL?=
 =?us-ascii?Q?S2WKc+iQBmSzCNAmMyuk3oH5SiPuDwJpE2Pk84bSYpuvzQbv3OgjfvSPIMM5?=
 =?us-ascii?Q?8suB4hEpFL8BH7VXHUa/mKA9DkDRFXrm+oe+ljjWKvS7g/VvM91q/oDv2mP4?=
 =?us-ascii?Q?jQb7VOpaENFToMsH1VOwBZh4Cb4mXUiGh26ca/QiX+5LMydroqBgx+tEVVIZ?=
 =?us-ascii?Q?w5JzCvmECG3AeKMoSMXUBlXwKbxcEl5VBAuTEKl28lWCa6jmUDwu8MIv1+G4?=
 =?us-ascii?Q?CgRmGXUk/k57vnZuITdHtrHRusd9CuWFC/dTFvQoqbWIMJlgdVwqHsnlyDi1?=
 =?us-ascii?Q?NHHEGM9MbFdSS6YVutTWZzKxYjgq4F66qFdDb721NbMSnoCmNI/v5NA8N5sY?=
 =?us-ascii?Q?D6Cf1/mG2imrsJCcIfgQUWP2PoN+D9GTMo7q53+KmYObpYUlvh/LZCbyLVq1?=
 =?us-ascii?Q?4E5cow1qD7HMuyDoidNzyKwzPxUtdErsP8sze9MZAMZuUwQyVzAHjXLHDEXz?=
 =?us-ascii?Q?UjNkOzDsr6bGKvyct0lAtfoLyv5GV2bovx2sV0wfvZGuzi7wCJHmldJ0cqkl?=
 =?us-ascii?Q?4+/MIKiFz+bJYY/HEF3SLk60HmMdmVCeYhhUbS/Tx3HMsWLNuSHjWsZF6SR0?=
 =?us-ascii?Q?5WIFMqVz9718gjMFfmj8e7QOF/5j0f94gdS3iKnvs5zGNuxVzZle7MaphR5V?=
 =?us-ascii?Q?Y1L8+FMjSlgVbq3HPUKwdclug3jKQWMPJ14UsCFz1VfCmMUx0a605gWRKIGX?=
 =?us-ascii?Q?KrhCeE9wxCfVHT0e1mDboEdZhT8eom1cRkIW0oUsaK3/yRoBQX1omTTLKytK?=
 =?us-ascii?Q?zrLFfjcPa4Od3DOAUYvskT68XQB515XexDpFytEqvOpKPh37T+ky11b6Sy/9?=
 =?us-ascii?Q?L95xOeYyl5YegvpWM+ezQh9JAGyP8vJfB7OXZ5kzuLpoTh2mDnR6U1g2xRND?=
 =?us-ascii?Q?4h52Av7neM3WUnZIVGngu7ecy/+8LcUb8C+i/kUmxpRsUs920CTyybPToLe0?=
 =?us-ascii?Q?cElHxTgeQUyM8Tet7KW66KwgQBDCcv9el6SN1Zb7j0k40zx0EDPNs8hpNEDO?=
 =?us-ascii?Q?ux8S8KB5vwg51PIRscxPPGDEYkwQeTbNSOmowb3ZEVrKazBJxy8SNjMs4EgY?=
 =?us-ascii?Q?FkgPWYRXppMUXp9E7P6PZoPSS0SWMql7J/S81UNE/DiwsjOX8INrtCw1pnNA?=
 =?us-ascii?Q?otWT0JcQhTTG+56XtXYVGnkU?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa8e0e0f-2805-49b4-657a-08d9537e142a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2021 17:18:42.1421
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mVRqeHg7ixnpHrLBBOHtKQAD3hcAYPCkAXLrL5jBoAxlFqvmlHWoh2ROAwOW5YykcKxhPkTuGA8TrIZKtZZ6gw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3967
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The SJA1105 switch family leaves it up to software to decide where
within the FDB to install a static entry, and to concatenate destination
ports for already existing entries (the FDB is also used for multicast
entries), it is not as simple as just saying "please add this entry".

This means we first need to search for an existing FDB entry before
adding a new one. The driver currently manages to fool itself into
thinking that if an FDB entry already exists, there is nothing to be
done. But that FDB entry might be dynamically learned, case in which it
should be replaced with a static entry, but instead it is left alone.

This patch checks the LOCKEDS ("locked/static") bit from found FDB
entries, and lets the code "goto skip_finding_an_index;" if the FDB
entry was not static. So we also need to move the place where we set
LOCKEDS = true, to cover the new case where a dynamic FDB entry existed
but was dynamic.

Fixes: 291d1e72b756 ("net: dsa: sja1105: Add support for FDB and MDB management")
Fixes: 1da73821343c ("net: dsa: sja1105: Add FDB operations for P/Q/R/S series")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index e2dc997580a8..cc4a22ee1474 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1333,7 +1333,7 @@ int sja1105et_fdb_add(struct dsa_switch *ds, int port,
 		 * mask? If yes, we need to do nothing. If not, we need
 		 * to rewrite the entry by adding this port to it.
 		 */
-		if (l2_lookup.destports & BIT(port))
+		if ((l2_lookup.destports & BIT(port)) && l2_lookup.lockeds)
 			return 0;
 		l2_lookup.destports |= BIT(port);
 	} else {
@@ -1364,6 +1364,7 @@ int sja1105et_fdb_add(struct dsa_switch *ds, int port,
 						     index, NULL, false);
 		}
 	}
+	l2_lookup.lockeds = true;
 	l2_lookup.index = sja1105et_fdb_index(bin, way);
 
 	rc = sja1105_dynamic_config_write(priv, BLK_IDX_L2_LOOKUP,
@@ -1434,10 +1435,10 @@ int sja1105pqrs_fdb_add(struct dsa_switch *ds, int port,
 	rc = sja1105_dynamic_config_read(priv, BLK_IDX_L2_LOOKUP,
 					 SJA1105_SEARCH, &l2_lookup);
 	if (rc == 0) {
-		/* Found and this port is already in the entry's
+		/* Found a static entry and this port is already in the entry's
 		 * port mask => job done
 		 */
-		if (l2_lookup.destports & BIT(port))
+		if ((l2_lookup.destports & BIT(port)) && l2_lookup.lockeds)
 			return 0;
 		/* l2_lookup.index is populated by the switch in case it
 		 * found something.
@@ -1460,10 +1461,11 @@ int sja1105pqrs_fdb_add(struct dsa_switch *ds, int port,
 		dev_err(ds->dev, "FDB is full, cannot add entry.\n");
 		return -EINVAL;
 	}
-	l2_lookup.lockeds = true;
 	l2_lookup.index = i;
 
 skip_finding_an_index:
+	l2_lookup.lockeds = true;
+
 	rc = sja1105_dynamic_config_write(priv, BLK_IDX_L2_LOOKUP,
 					  l2_lookup.index, &l2_lookup,
 					  true);
-- 
2.25.1

