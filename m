Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69CCB48CABB
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 19:13:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356073AbiALSNU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 13:13:20 -0500
Received: from mx0c-0054df01.pphosted.com ([67.231.159.91]:34132 "EHLO
        mx0c-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1356091AbiALSNG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 13:13:06 -0500
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20CE6jBi020242;
        Wed, 12 Jan 2022 13:12:59 -0500
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2051.outbound.protection.outlook.com [104.47.61.51])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3dj0fcg5xw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Jan 2022 13:12:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mkmqtsMH7BUAvXuaamnBxzRrNSvWhyGiWQA1U715SwEiky+erRQLR2YzqezEcw7mkCWlimA05uL3zQXXJCpq2ClnPV0McsUFl4s4qJA4nNUfpTzfNSoN7Uo5UVaADjet8B+NhRWJMj+uCE3mOKbifjyR2MJf9h4urcf3DaBWOPs1mihcOy5jGFq8BrAwc5MMDVbQzBYcAtC9Uny8psRhM4jRi5uGySdFQvaIq6dbYGPhkv3iPk00Px7a3BK3MtoMJr29s/rcb1+jKOuQ5Xbm04ZwV0owKBcrOE4nBVI5cQU3WEnI8yie8V8g+4hjUnDtEqpD0ch7CBvlGwgexJ3jPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m97m9plP0SMWFGgtAwFGG3kjSAqZMgme5CBUazC9zW0=;
 b=LlyZsEWRxbomfmrvJGwgFYanmLqTs3PDjRyQiTeZCLJX5aZC4tkprepMZSzgULOT9fYusqHkS5B8WFTZYafdgBpVIj1z+OsV+DZta1VOrPjVD12G7at+TTCeiguqa6nI8rC+dstvneeashb1hNw5iQIO3JnjzIr46y7OyDPZ+Gxk9rcXmKqBG9GlgTGbvvi3/7V+nNg97f/d7+nNfp2jNcD5td+xwrIdwGo4pssF9uaUrhwXq8TB5SIBAOZUiedtWbaF57FjaCRMMuVa8x3L8CrB0fmIP1XqO94D36sgOrS2iWqiy2kXfkJbo5PlcFaHwUGBR1cHx76+nIcx3KiFbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m97m9plP0SMWFGgtAwFGG3kjSAqZMgme5CBUazC9zW0=;
 b=3Y7uNMlWgbs18TZDCEkgl7ZFi2h1g0H116QAuxnulgi65eIYpF7jUbCvrhdOBKiB9IbwX4NObkRXw2RMRfXW88g2/7xjvZH5f+wCPgCcgRPYu9X+cKsGJx/XXTMIzoo1yEt1yibUk5ZVukBDxtZ54wenF06LTj5DWtGqNRV0U18=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YT1PR01MB3516.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Wed, 12 Jan
 2022 18:12:57 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8%2]) with mapi id 15.20.4888.010; Wed, 12 Jan 2022
 18:12:57 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        michal.simek@xilinx.com, nicolas.ferre@microchip.com,
        claudiu.beznea@microchip.com, devicetree@vger.kernel.org,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next 2/3] net: macb: Added ZynqMP-specific initialization
Date:   Wed, 12 Jan 2022 12:11:12 -0600
Message-Id: <20220112181113.875567-3-robert.hancock@calian.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220112181113.875567-1-robert.hancock@calian.com>
References: <20220112181113.875567-1-robert.hancock@calian.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CO2PR05CA0092.namprd05.prod.outlook.com
 (2603:10b6:104:1::18) To YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:6a::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c51ca951-5b9a-4a25-80b2-08d9d5f7293c
X-MS-TrafficTypeDiagnostic: YT1PR01MB3516:EE_
X-Microsoft-Antispam-PRVS: <YT1PR01MB3516773D0299CA8C0D99E20AEC529@YT1PR01MB3516.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D69FWGS/8/cVnA5gf5iXvT96FLnUbhOLE4xty6le1wz5c/L7hdnJUnRzz8pZ+w+SORcFMFcSi+4UvvcihNEYpnPAYR8SzOUar9aHUwB32eIF5JkIpZhl9keRTo3PZjGEhXUbjAvMupwGGOiz3DAg5+RUvSKBb7YBXp/e96vZNCTkKfk7EjDrHGbYMX6XBgo7GFuiPSuEqwshpDv7I/Exw62g5ruD5Rzx8movcoZDz57wnfFn5OVKNpLbNoZI9aDzZYbnQcbDyDRAInbsDumCW0Zxm+BMAt7HJfB66bowTmnxd60RvajEVYpGGotO5jC5xkn6Oezb1CtuYHauqkEw32VZzrIWnQMKl07tXfcEYJC+7PaF9W3TQx32gAuaYu6LB3c9cx++ySlCAj2WXzomwK56zcZRV4gXZAEz3yWGm14OdQ8CNrItFkEZVTLCNL9z8Q6BSGIEf0mfZ+t1sMFEBx/yN2+Qvg8iPfvwciVHfRQjaPVC1kpd/+mRCzcWoNjQlGL6b/vZ2umyXFNwx6yKqCd7CQS8aj1rSZ2QAgB0xNM5LlZhPJHukowFw1w+4BXdDfnb+9S7vgBz5sOOzp40WHoguoLXwgnrUaVWZOwAtW22wI13kbBTfY1ddcy0JwWepLst09PbNnPsI3vznZWBrl2wL3v9MyK20N8QOW5pU8HHASEq4qgYdPzAX6WacC1n16SyhILRioBKzAmGhhR1VQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(44832011)(186003)(8936002)(38350700002)(6512007)(38100700002)(8676002)(66946007)(4326008)(2906002)(2616005)(107886003)(26005)(6916009)(83380400001)(508600001)(1076003)(86362001)(5660300002)(66556008)(66476007)(52116002)(36756003)(6506007)(6486002)(316002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iRTf8msiuTHt63n9iYYMyiOrI8XkhGYqFcLjpCvymsJvYnozJsBnZL1h0qJV?=
 =?us-ascii?Q?RKfmp4yESPoHkS8baLnDd9qjEzUjRFPNUe41aOURv8Rjqw4wzDjNqAsW1dJg?=
 =?us-ascii?Q?ADgMyMsGnruw34tQj2127eq8HI5Bfz4podwl/zWIHc/MRo6gCa8XNlnpxHvm?=
 =?us-ascii?Q?+C2NnKMvXhOjVYBdsOp5RSzGI/bn6slAjJwHHtuwVkoGQojKgur/7Dgc/TmX?=
 =?us-ascii?Q?Szm1C8jCvOLnKaaG0geUY0P53C7I9RYzVuWwY0aCcXF//Get2yf/KdI5J/aF?=
 =?us-ascii?Q?xEEEn4SIVpS4wg2RkpcpyebBZ/JU9mOEsEWCndsSMavYQHHsxDZH/QDR2I9E?=
 =?us-ascii?Q?pc20qzy0MLvCun4lrilrB3I1pUyZ90WATDY5E+XNaehxOak84cOaCT1/2pRL?=
 =?us-ascii?Q?BJ3G87kr9Kvt9RInsshh7P3czQM1zjhym4hTVWs4IhJwNajxXi0Afu2DNJRk?=
 =?us-ascii?Q?5IEmZZDDETXoktTXDR69ciNV7r4RJDM13bQYlEeuKWagcqLtovHXEgYJdqya?=
 =?us-ascii?Q?P2jk4Jo3KFY9SmCT/ZY6ys9OyTy2VQuQZK7paXTb9jZe9LJNX933mOBdZzuY?=
 =?us-ascii?Q?nYsJK/w+okMGur5MGFJSK9i+76/meNbJkQZoSItc0XiY1gL5/u7xaEXPkRCJ?=
 =?us-ascii?Q?8o1w7hzVHFHWMzcN/dfsTB279unoSvwSz+BKroLINewYeLdEZp1Nji9wDhzR?=
 =?us-ascii?Q?//ARhv31IxpgzNQFcNMUDp/eParrU8Tj5PHAj4HZMhdlwVOAUL0B7bpQi/tF?=
 =?us-ascii?Q?9BngJxVIUTYleSPa87FXI8rYbPyQbTCvkZC5Ut/tHPt8Sx3r1yOobuLjSc/Q?=
 =?us-ascii?Q?QPy7PC6NTmgAq7S5Znb9mg4i4SD0eOnSOw+TapxNHpCAYhwD0wXEZ2iVgyBL?=
 =?us-ascii?Q?X8J/55D4b7+bElx7TsLS3ZNySp0duVdHGAKla1nUXQbchxnaoNj6TbPC73dF?=
 =?us-ascii?Q?mtj1SXvJvnOkJzc+pwIukEmiHkLpnWUifXVp8KDFpadqZk9SG6bwoqhsDldM?=
 =?us-ascii?Q?0sSda0qH7a9BujCOMZpMYzdIjNXKdEdMdJBp/rCJtdKpwgRjwI/UWVNg2460?=
 =?us-ascii?Q?D8mFcRPvUEMja21JFSeFHRtxL0CFfWOY6HrdsYsaKqQmE0aWH8JmtFytUTaU?=
 =?us-ascii?Q?LxQCXXO6E7SUae1C0YBUxLsj0YPgweefUWgCVzZRp56z2AS9eDhS5W8hvwIT?=
 =?us-ascii?Q?mHd28GGVXt91X/9RRmzBdDUyzlBDW0JiceOiw/BICIyi3PyWWe6BuMSNaoJ5?=
 =?us-ascii?Q?ntR3vIr3GSm35RBlXRPow4TPdBdwv5zDLIYVu7p5VZqyvHVHkdnivdkFYWdS?=
 =?us-ascii?Q?a7Ckl3Vw5ItKESFuaD/B7ADduMd4xiIuZpgJO1BCfQFpCE/K+fViJnxicZBb?=
 =?us-ascii?Q?EZl6xbkZm2Cm941sqqV/3Jm39cIEbxOHg2xekrZ7WlGp5DT9l2Sy4wUMXH+x?=
 =?us-ascii?Q?tB/hirM/bIeOZDSY4fG6yzZ5UdQfOCzIhJHbiTZVl9cET2qqPsb9b+VRTOqS?=
 =?us-ascii?Q?/S19TbcdaEQGlXufD6cDgcvosZVuTAtR5nr6N/0tP7gZfuI/BBZoQudHgp45?=
 =?us-ascii?Q?+WcBOd3PyeLUKggmTyLjD1+ggn1nmG5zvkUtQk7hhRt9MSNV1G1c1/VismPn?=
 =?us-ascii?Q?b/XadeUNgtfvskaq8lR8OLfotenNfsER2mNHA7sP7mdR0K2G32o07EPEOpdI?=
 =?us-ascii?Q?oiCl6C8yiyN3ULKYRe63Hsn5mKU=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c51ca951-5b9a-4a25-80b2-08d9d5f7293c
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2022 18:12:57.6667
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dlGW2XkLPxjOzqEnMubRQuk4iaEh3mHPND8dnzm0p1h/5E5uM+JpYDduSU8YkubcwwvIlZATTK7At7Xuwk1F0ohkyRzsnFH4ZE6RfKooIWo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT1PR01MB3516
X-Proofpoint-GUID: lv-U6aMQohG7c9mezpMHr0FNMsR5yWpu
X-Proofpoint-ORIG-GUID: lv-U6aMQohG7c9mezpMHr0FNMsR5yWpu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-12_05,2022-01-11_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 spamscore=0
 mlxscore=0 adultscore=0 malwarescore=0 bulkscore=0 lowpriorityscore=0
 suspectscore=0 impostorscore=0 priorityscore=1501 phishscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201120110
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The GEM controllers on ZynqMP were missing some initialization steps which
are required in some cases when using SGMII mode, which uses the PS-GTR
transceivers managed by the phy-zynqmp driver.

The GEM core appears to need a hardware-level reset in order to work
properly in SGMII mode in cases where the GT reference clock was not
present at initial power-on. This can be done using a reset mapped to
the zynqmp-reset driver in the device tree.

Also, when in SGMII mode, the GEM driver needs to ensure the PHY is
initialized and powered on when it is initializing.

Signed-off-by: Robert Hancock <robert.hancock@calian.com>
---
 drivers/net/ethernet/cadence/macb_main.c | 47 +++++++++++++++++++++++-
 1 file changed, 46 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index a363da928e8b..65b0360c487a 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -34,7 +34,9 @@
 #include <linux/udp.h>
 #include <linux/tcp.h>
 #include <linux/iopoll.h>
+#include <linux/phy/phy.h>
 #include <linux/pm_runtime.h>
+#include <linux/reset.h>
 #include "macb.h"
 
 /* This structure is only used for MACB on SiFive FU540 devices */
@@ -4455,6 +4457,49 @@ static int fu540_c000_init(struct platform_device *pdev)
 	return macb_init(pdev);
 }
 
+static int zynqmp_init(struct platform_device *pdev)
+{
+	struct net_device *dev = platform_get_drvdata(pdev);
+	struct macb *bp = netdev_priv(dev);
+	int ret;
+
+	/* Fully reset GEM controller at hardware level using zynqmp-reset driver,
+	 * if mapped in device tree.
+	 */
+	ret = device_reset(&pdev->dev);
+	if (ret) {
+		dev_err_probe(&pdev->dev, ret, "failed to reset controller");
+		return ret;
+	}
+
+	if (bp->phy_interface == PHY_INTERFACE_MODE_SGMII) {
+		/* Ensure PS-GTR PHY device used in SGMII mode is ready */
+		struct phy *sgmii_phy = devm_phy_get(&pdev->dev, "sgmii-phy");
+
+		if (IS_ERR(sgmii_phy)) {
+			ret = PTR_ERR(sgmii_phy);
+			dev_err_probe(&pdev->dev, ret,
+				      "failed to get PS-GTR PHY\n");
+			return ret;
+		}
+
+		ret = phy_init(sgmii_phy);
+		if (ret) {
+			dev_err(&pdev->dev, "failed to init PS-GTR PHY: %d\n",
+				ret);
+			return ret;
+		}
+
+		ret = phy_power_on(sgmii_phy);
+		if (ret) {
+			dev_err(&pdev->dev, "failed to power on PS-GTR PHY: %d\n",
+				ret);
+			return ret;
+		}
+	}
+	return macb_init(pdev);
+}
+
 static const struct macb_usrio_config sama7g5_usrio = {
 	.mii = 0,
 	.rmii = 1,
@@ -4550,7 +4595,7 @@ static const struct macb_config zynqmp_config = {
 			MACB_CAPS_GEM_HAS_PTP | MACB_CAPS_BD_RD_PREFETCH,
 	.dma_burst_length = 16,
 	.clk_init = macb_clk_init,
-	.init = macb_init,
+	.init = zynqmp_init,
 	.jumbo_max_len = 10240,
 	.usrio = &macb_default_usrio,
 };
-- 
2.31.1

