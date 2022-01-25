Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5698349B967
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 17:58:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1586488AbiAYQ5N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 11:57:13 -0500
Received: from mx0d-0054df01.pphosted.com ([67.231.150.19]:56684 "EHLO
        mx0d-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237131AbiAYQzG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 11:55:06 -0500
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20PBfHPi020266;
        Tue, 25 Jan 2022 11:54:40 -0500
Received: from can01-qb1-obe.outbound.protection.outlook.com (mail-qb1can01lp2054.outbound.protection.outlook.com [104.47.60.54])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3dsyrhrj15-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jan 2022 11:54:40 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=moIFgqgr7azZheWIdNiEYf+9Bvs2BfS5qVywwbWgk+mIF1A3wjPDDN2aUpMIMi6vV/wviWnOmWndg6jLgTyVCRCLSNK2kzNExYSgA2434rj1e1Ag8yU241FICavtqDKJVh10Obk1EhoOvxvC3TVmLus1TiX484751pammp1m/gAo8ui6iHxGuJsIgbIjIDod5xYd8iRnjgy6+W1WletJdRcq2OzhxKnTd5bWXEhySHm4iBqV0V7wcP7c/7+WO7232tD7cXS5rjVvbrP4QsyrwYtX1NyzSjEF+tMlTVZzXv92xbI0Pa4osfzMNTfndEoLXwA2WKE8MThrH+wvT0Pn0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7PMOcvq/RJSohh4g5+J7bO9/fUMk03CiM3MUABB3JrY=;
 b=avasUk/4Y4LrZzVds+Qe2cR/5vCyqMc+r5elr16nvbGzhIPqSz5q8HER9E4QVN5X1pZLtuAsAy/zFpzOKhUlt206kImC0GjmOX9fLL4rTkpFgjati7IUqy6cZUCNtQ5C/lh1FaiHnict7fO7x5suJv0lLESgz4jZtWS7dxaAfA3/fZLFJWBvT3uTy128Co2iSSIygO88ylDrRaiYGDk8EMPL0YbVBLJwZkyfu2zpMjWzvftuXOjpd2Fy/ytsT2JlSPcBb/Q8Cv3l0i+0TkP/sd5s8l2zyVhH1dtkDIEiPbOclx2xPZZchdnq9E1Td7uweUfBcxEH0uy4q0xihrkzTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7PMOcvq/RJSohh4g5+J7bO9/fUMk03CiM3MUABB3JrY=;
 b=2YjhjgizZPA6/JLxu7Ww56sr4Ao+vKHFM0p+cyCMapav+15zTmonHAXO5axxp0uu733xNxLou5xuKfx2MkJ4kgWLN0IBMcz6YEt2tkag6nyPV3h6n08Hs/BbJTxuO9pQCkU46gOYNUJdHjezeRln5aPhA5ShOdSyN1Qu4/0jdp0=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YT2PR01MB8631.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:b6::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.8; Tue, 25 Jan
 2022 16:54:39 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8%2]) with mapi id 15.20.4888.020; Tue, 25 Jan 2022
 16:54:39 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, mail@david-bauer.net,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next v4 3/3] net: phy: at803x: Support downstream SFP cage
Date:   Tue, 25 Jan 2022 10:54:10 -0600
Message-Id: <20220125165410.252903-4-robert.hancock@calian.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220125165410.252903-1-robert.hancock@calian.com>
References: <20220125165410.252903-1-robert.hancock@calian.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0193.namprd03.prod.outlook.com
 (2603:10b6:303:b8::18) To YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:6a::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e03fd901-7184-40b5-78ee-08d9e023603a
X-MS-TrafficTypeDiagnostic: YT2PR01MB8631:EE_
X-Microsoft-Antispam-PRVS: <YT2PR01MB86311FC4DA809F0FEF59FCF9EC5F9@YT2PR01MB8631.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 24O/us7n8guQ/WLXhQcYlr9yZGOnhOcTj0jGp62CaRbJX5CS09j+gzdW8zGuy+dysQjJm4USH3y77oQyxLC/btELj4k5Nfu00bGz+mOLxvcoGqTKK8sRu+eRTNks620u/yyihASmy+aNX3n9YNA78PgfpfrylJyOz1lrSfvj5oM4zrsUPuAHTkY8pNYZXUw7VC8S2lmzj/1cZ885f1zUQkic1a0fErCD70PL5Ycexg37L4kFFso34E10r/LWKdf/WzDhN/7EttyYmC5hoY0Bg8jOlYVvLhZmdLHYm5tplpw80MOHGjDoPdgElVLLzxd14xlQ4vW8cfSlU8Wg1zwmTYRerDTIPa4xy2BzlD35QQSUOCdhBr/eWfNcCu2DTwe2zL6QnBl55Nu1iir4kKsJsI51clOLVXPbavPlpi1z8IPvXT3mS57LU4fLF/Qqw4oSsVZvS56GMLwctE6FmiA76+yoxRJ0eb9gC2t/46uUMF0Cl/VD9z0iprYWd9cMHKZBuM7cLd7F76qTTBX5t02ZWZR1Ym9SeIFv5I/llc/huRLv3PU6q6ysN5+hZaVviM4C7rovRkfVRWPYosRGhi8+XTJB61qwLr20aTL6MW4e61d9fSgyjt8PxzA7h2Sk8TgJ2cxL7CDvceLvb5LFZJmIUwOBjkNYJmsYUwNtacNNqL/BNSfJXUJlR/+zCZb49w7ya6D96QqzhyzNTV/eVrrYGg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(6666004)(52116002)(6512007)(86362001)(66556008)(66476007)(6486002)(6916009)(2616005)(5660300002)(316002)(66946007)(44832011)(1076003)(38350700002)(2906002)(83380400001)(4326008)(38100700002)(26005)(508600001)(8936002)(36756003)(8676002)(6506007)(107886003)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XQeLn9c1WvKAS2SxysYPI0pSeG7NYvQ6FbvJL9Qci9z+0ij9ksiJc88ErAPI?=
 =?us-ascii?Q?O928RtBD9wV5VbcSp9JyHUldJNzgf/aKgetYc1L0VMnTqLfEYA371/trPr7d?=
 =?us-ascii?Q?soyU5tqiimBMxWJ4K2F4P960QTv1bSGmlHtzkwLYZOrX0lJHg5KD9V9YTQ+T?=
 =?us-ascii?Q?RkVBbZmG3uwUnUt8utU9uRhSDV6Vne4CSESWZeC387OPbKB4wPc2Vqr8HLpn?=
 =?us-ascii?Q?mvPYDKossw9/iKsNx67IRDk6zLTSfBeijjJ04tKQAkSQVHsVuGOHdKxd6Fby?=
 =?us-ascii?Q?at96ZMDwxLfzLkt9IK7ET+kQ4Zdc/9brhEVFJoT2rTByCKeAgNjm9deQCeCp?=
 =?us-ascii?Q?Agsa/kDpd7jmKvJu2l4ZB/VZjzo2uJ0DaRZuBLNNIBNByZ5Yqj08u+64H9iV?=
 =?us-ascii?Q?vrxdLsQ+58ZV0+u3WdxVWKon8VU6PR8ztRTlhrrCkwsfAKILqJuvjV7ulSKx?=
 =?us-ascii?Q?KBEc1hs6A6bVopLwrN7JAKipHGs47xrIj9Mlbz/AqJgKRgzdf77iMlGW3VJD?=
 =?us-ascii?Q?70tyo+vfOTVzX4WxBuRD7wyqDCw3cbKtG2gmTwMYojs+Pv6jBsSxihzFWhle?=
 =?us-ascii?Q?FHWGicuglLl8UZOoMiOjw7L1R+sxJ2Lp96s4i+PRvF/PVdlyGc5r7YiKcNwJ?=
 =?us-ascii?Q?d61P4iVfdAXk/e5lXdzwqa6L28mSwOHg4jqCqdIufFJqlamJCr/N6phTyY/y?=
 =?us-ascii?Q?VKJMlOKl+wFfhEyVSx2bsmbWym2/8PbWJID2TDUu7LIJlVYuwT2Q/Cih5wMy?=
 =?us-ascii?Q?INXflbL+5PXYAVw+3v3JrNSKnXF8sofTyj21+N8wfOQKIqhWvB3Br+xkVa1O?=
 =?us-ascii?Q?OYUHhnGnGY0udphu4W6YVG1rqVxC/blmj9hN/90yW25wfo0/LADh4fQI29Vl?=
 =?us-ascii?Q?YIY3ZDameZb1NbWYglnbV/9rYwz2EFw0TT79JV7xBHMSpoIuB6yQcXriVYRb?=
 =?us-ascii?Q?YOtS1j/8Rd2XeJQchu+Fbj5bltHFiqzHkDL3liVTwupsD98KOgYzZF6kjkRP?=
 =?us-ascii?Q?oE590OGWZwHShr29OP+fTe+HyDq1Jt+C7bf7MqZS7ONMTIgC7ER6xejDMct1?=
 =?us-ascii?Q?KjuSv/iL2XwFJohYdE2Qo3VHZP9BqF5UydSBkRNQNgCEckRc9KaD39n8v8OP?=
 =?us-ascii?Q?sgFnNXjrDZbJry5MwaG7uNf3xHCsS0SLjFh+IRZsl6MkBjSLomgZ1UIbMuMm?=
 =?us-ascii?Q?PVdharCyN5GyNtlvYM4HxdVmrsiUZMHMp+e67CWd4QguEwn+2CiKXJXWqKIK?=
 =?us-ascii?Q?0Ms/Elg6fa+TniQHWoybGZvBU0f+I7ZMvXPX9SzSikna1vEmXggONUnq/p/8?=
 =?us-ascii?Q?pisFRjL13tTImuyKb4EICeJZZq62ppYMgUpfxF3YM6hOaTYEKXjKtDvZMUiY?=
 =?us-ascii?Q?n1Vy4twc7rLe1GfBVVIZrcSJV4QKF6PnM6ZHScbeK2fp1OW9xQp6xJat+e8g?=
 =?us-ascii?Q?kVH4DOOc/IefxrZJOG8/YKFlXLPSRVx3/O4yK3E0DT+puCIITxf9uxKMhj/j?=
 =?us-ascii?Q?Xb41OM53nRhjvSUbESmCLP/aJHmQ560jmw4WNGG/jvFS/9ss1AUY5e1DOkd/?=
 =?us-ascii?Q?tBNGNyf2SirPtS3+GPa1+mXFRNiDHFSkS2S1THHtV0cO1vBetHFllrosn5Cb?=
 =?us-ascii?Q?LRg3D/5NnQjUSEtcvN+iwDc01sBmRw/Om790S4iJmbVkXQsE9RRjoQ1cyMFP?=
 =?us-ascii?Q?r1k+eVUGdlu+qzTK7aSarSvGn2M=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e03fd901-7184-40b5-78ee-08d9e023603a
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2022 16:54:39.3964
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XaSvmxc68BzyicE3pMRvR/sLZNDedpmnphoAS0nEX0kor0gESUo19fbKaHspxRWir6XwsYkINTsLBSNBSuVTwv/yKY119CRkbIeTaRlchCY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT2PR01MB8631
X-Proofpoint-ORIG-GUID: XFy3i8BlDj23LPAHQE27xsDNROPKuL-7
X-Proofpoint-GUID: XFy3i8BlDj23LPAHQE27xsDNROPKuL-7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-25_03,2022-01-25_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 lowpriorityscore=0 suspectscore=0 mlxlogscore=999 clxscore=1015
 phishscore=0 bulkscore=0 priorityscore=1501 adultscore=0 impostorscore=0
 mlxscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201250106
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for downstream SFP cages for AR8031 and AR8033. This is
primarily intended for fiber modules or direct-attach cables, however
copper modules which work in 1000Base-X mode may also function. Such
modules are allowed with a warning.

Signed-off-by: Robert Hancock <robert.hancock@calian.com>
---
 drivers/net/phy/at803x.c | 56 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index 3f3d4c164df4..f504fe536fe4 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -19,6 +19,8 @@
 #include <linux/regulator/of_regulator.h>
 #include <linux/regulator/driver.h>
 #include <linux/regulator/consumer.h>
+#include <linux/phylink.h>
+#include <linux/sfp.h>
 #include <dt-bindings/net/qca-ar803x.h>
 
 #define AT803X_SPECIFIC_FUNCTION_CONTROL	0x10
@@ -664,6 +666,55 @@ static int at8031_register_regulators(struct phy_device *phydev)
 	return 0;
 }
 
+static int at803x_sfp_insert(void *upstream, const struct sfp_eeprom_id *id)
+{
+	struct phy_device *phydev = upstream;
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(phy_support);
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(sfp_support);
+	phy_interface_t iface;
+
+	linkmode_zero(phy_support);
+	phylink_set(phy_support, 1000baseX_Full);
+	phylink_set(phy_support, 1000baseT_Full);
+	phylink_set(phy_support, Autoneg);
+	phylink_set(phy_support, Pause);
+	phylink_set(phy_support, Asym_Pause);
+
+	linkmode_zero(sfp_support);
+	sfp_parse_support(phydev->sfp_bus, id, sfp_support);
+	/* Some modules support 10G modes as well as others we support.
+	 * Mask out non-supported modes so the correct interface is picked.
+	 */
+	linkmode_and(sfp_support, phy_support, sfp_support);
+
+	if (linkmode_empty(sfp_support)) {
+		dev_err(&phydev->mdio.dev, "incompatible SFP module inserted\n");
+		return -EINVAL;
+	}
+
+	iface = sfp_select_interface(phydev->sfp_bus, sfp_support);
+
+	/* Only 1000Base-X is supported by AR8031/8033 as the downstream SerDes
+	 * interface for use with SFP modules.
+	 * However, some copper modules detected as having a preferred SGMII
+	 * interface do default to and function in 1000Base-X mode, so just
+	 * print a warning and allow such modules, as they may have some chance
+	 * of working.
+	 */
+	if (iface == PHY_INTERFACE_MODE_SGMII)
+		dev_warn(&phydev->mdio.dev, "module may not function if 1000Base-X not supported\n");
+	else if (iface != PHY_INTERFACE_MODE_1000BASEX)
+		return -EINVAL;
+
+	return 0;
+}
+
+static const struct sfp_upstream_ops at803x_sfp_ops = {
+	.attach = phy_sfp_attach,
+	.detach = phy_sfp_detach,
+	.module_insert = at803x_sfp_insert,
+};
+
 static int at803x_parse_dt(struct phy_device *phydev)
 {
 	struct device_node *node = phydev->mdio.dev.of_node;
@@ -771,6 +822,11 @@ static int at803x_parse_dt(struct phy_device *phydev)
 			phydev_err(phydev, "failed to get VDDIO regulator\n");
 			return PTR_ERR(priv->vddio);
 		}
+
+		/* Only AR8031/8033 support 1000Base-X for SFP modules */
+		ret = phy_sfp_probe(phydev, &at803x_sfp_ops);
+		if (ret < 0)
+			return ret;
 	}
 
 	return 0;
-- 
2.31.1

