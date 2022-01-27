Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CFD249D6C3
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 01:34:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233910AbiA0AeI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 19:34:08 -0500
Received: from mx0d-0054df01.pphosted.com ([67.231.150.19]:34474 "EHLO
        mx0d-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229724AbiA0AeH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 19:34:07 -0500
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20QK9o09002635;
        Wed, 26 Jan 2022 19:33:57 -0500
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2050.outbound.protection.outlook.com [104.47.61.50])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3dud3cr3s1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Jan 2022 19:33:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eR1AVHOpW2QalU2BoC9JZtLKLfP9ZIdOqRvngK3JGkBysIB/O/kjsludJ/GAKYPhUiGbcBCC+4qjLzqyPMPz2AA/uoId2DDZjNUuWOt+1J6FVFMmOqNBPSIKVpyqopoz8ap7fU5bExcpBBP7M/LPYdpcTYo0g+jBOUIPkjsheLi/1Fh9av7swFV5H3jtThMpbU4cpsautk5zTaqBHRbuAg5f8qwFbo/KNMVRVyzGOmjqM4QDjb2iOfpUuDLVFD97PHtaEbEmpooz4n04hWZjm4SApL0ZqlXlj5ddjduXeyIXX5zJWr/itx3Xi+o5bWQZrxUHyr6vSoRkdwW1aa8dTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HvQnjQDd/H2hn1GOTB0diJzXB40AgYZUY2C94Bw2j7M=;
 b=DRdCd4pGcKOuzIqNU2ICqIlKsRtpLnViR+KSpdeIj+ePqORyYunfwbOySA3DILlaKeuOfIm+DESgVhFycFlDXbm0NIkDzg5nj2FHXX8MYvwaZ1JJdkhkheKGaOUMh0MpaAOJZX2E3i94qkVnmsJyOgsGuiDsAFNiX2ISNXeK75FPh1ahTQVp9vO+S/fnj3QzP6jW5LthcbzqZUYuOzBxH5S+FKqEaXRa8Q60t2AX5hmMiNiyAJ7IUEZjtNk+x/5eCoAOx3HTf3AiYAsgJLHIa3GFkUpK9XFRgoIEZDmZQHADQdg7QKN22qaYG0zu8r4YI5XWCNuk4xPNh3VHlA1nbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HvQnjQDd/H2hn1GOTB0diJzXB40AgYZUY2C94Bw2j7M=;
 b=m0Q3RcgvtBZAGU8JO+4Oy+sRxh3kzG/B2NCTLcTJFRfEiFkD0BfIF3FqroRNEnB0+JXQQeGy1/I4HxNWHwDDk30+0aH4SGFpvyCt/JO8yoDBc4S6pe7kKqPlOo0in72xI2loNm6/KfRL3oRSuj8Sa3VhIKn1MJ7YPWnBHcv8tkE=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YT3PR01MB6084.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:69::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Thu, 27 Jan
 2022 00:33:56 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8%2]) with mapi id 15.20.4888.020; Thu, 27 Jan 2022
 00:33:56 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        robh+dt@kernel.org, marex@denx.de, devicetree@vger.kernel.org,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next v3 2/2] net: dsa: microchip: Add property to disable reference clock
Date:   Wed, 26 Jan 2022 18:33:18 -0600
Message-Id: <20220127003318.3633212-3-robert.hancock@calian.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220127003318.3633212-1-robert.hancock@calian.com>
References: <20220127003318.3633212-1-robert.hancock@calian.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0091.namprd03.prod.outlook.com
 (2603:10b6:610:cd::6) To YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:6a::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9a0aea4b-df16-42e1-6514-08d9e12cb323
X-MS-TrafficTypeDiagnostic: YT3PR01MB6084:EE_
X-Microsoft-Antispam-PRVS: <YT3PR01MB608450E52AA0A86C1F17FF54EC219@YT3PR01MB6084.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:2000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TKNzM52QeFqipZk+0ceXPiquKcjbTs9trweRRC9MgUGSwSspakVWRCOKRo22i0+z9LMcV0Ht2bJwP7Ltv78+A0cbxAJlHH3puw0lGtWL+6ltHrmLjKIUc3Ef+HmNUrj7Kby0JMBbbsFcb5btgy51OOaSkeMJD6P322EK5mZjOzd0KS6jPiiZCix2YLfQwKO40L0vLVTXaQ/1PB3ZYVTJulz+NPTlt1YCCdZcfphTq96xFpNIb71067CvVpWGm9Jrk9emVipEONnvV0FA+yf3W3GrbGinTLi+jUT5i5l7JJFxcr/dhSSGLx+Dwpp9t62c2qnghoUHbjXaZL5DLu0HIwWUZjZeAHk95xkEz4tNsgTg4cELFu3yYFD3GXQEtG/Eoace6Yf/yOZyElP5EDwAfW/R1wlgIHCqUXX696mlgNvLKtZOMR0JUmrYv+FoEQwmFxKk3G3D3GLwOjRh3mDmfg4ZibsHNjqP78fGfnoi7qbFOm51R+J6L+Zq2ordc1E1ATmlC//c9H5+nyFirmP44kgIfQjbc1H5xtXBXB5TZPaydCpC0KDxYoYDg1ujtUVI98jNyDGpwC+qtsfCw9EMqSTx8ms5Y1uBgl1JtGnqJFdR3STnx4/86JTPHA9RuYIrY+8fol2a6XK93IWDWJDUoNNeaX01ixGKrxPyqN8kTM6cIdOW6csWdIGIJidUR3DOTnNCfohKasae+HVWiTNjHg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(52116002)(107886003)(38350700002)(38100700002)(44832011)(2906002)(7416002)(86362001)(6506007)(6512007)(5660300002)(6666004)(6486002)(66946007)(66476007)(316002)(26005)(36756003)(6916009)(8676002)(4326008)(8936002)(66556008)(1076003)(2616005)(186003)(83380400001)(20210929001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?q6Cuk/ThJa7TrgcCVSG2KLHFaqcn1GgpRCBqp7LVEmAJFdGA/QPZ6i7cNBZI?=
 =?us-ascii?Q?sN2Ey3Tv5qQSxCE9cDk7awO63W0c8q/TVoT7mXdna7E7GXfJMBtRsiPx/83q?=
 =?us-ascii?Q?RF0/ukifaK1BiQjhzODqJqADFBHtDalKTW39BUj9Q08Gvj+IAD5Y9Xbw2QVG?=
 =?us-ascii?Q?0XwuP9cRFNw4BNZ6Vbfl8eHtCRHaYtU8UWBMdpptL4Sx+lK33S0mvSa4X2Oe?=
 =?us-ascii?Q?drSimRr7F3VLCHajFisRZeE+jHEVOm2gPZl4q5ilHGomYDbj22UQIv/ukD/E?=
 =?us-ascii?Q?Z8mVfvKbDmubXjeZgggRPt7p7y99L3+AEZpGXqdn1GeK3by0JOmRKcKmMkTJ?=
 =?us-ascii?Q?6zFLV/12lFw9DNMuB+yw6D7CxfOfHWE0lgpViZNBjQhStQJj1J9e+sbYQl8D?=
 =?us-ascii?Q?Daz047y3XNTLMRq8HeMVCf8DLKk3AZM2S+losnVL9zOIz6x5VGQqPMjzeh1+?=
 =?us-ascii?Q?Aig0yLG6yLozR0qgZaPNYUJ2UjdcsXmqvUzKwz/6oMgL4BrGu2W86PYoGLOB?=
 =?us-ascii?Q?CBY/1Axr427XWzV89PtWuP3Pm+SlfQpwMNbEkyO44uGzsoW0r0w5nWzzbSxq?=
 =?us-ascii?Q?ezLdOZEhix/Xj8BFCA8EKubXGWr/Gkn+rZdJx5bA+fyfxm1nH2coqax3SD5+?=
 =?us-ascii?Q?34IHZ6yJDW6dtU//c0Xy1XeNmnYMquSKbF6SHNkmWWWlSKQOHbiLl5ExTVaX?=
 =?us-ascii?Q?cqkABEYgyxQclyjLphWfzLGfNqhCHE7NFs6YjBsJsA+gt4SBmZHnzMuordeG?=
 =?us-ascii?Q?Q1mziyGSjy+IDErrSyS/lfyZAIz7iXYzT1pIkHhlpm5L7RVi9XzuiqNpdVbt?=
 =?us-ascii?Q?4SIzzb9hBJecFZJiX9QCqi1GfF7zzQNqh/1+hYMZ5pQESeCz57n2CNGL9v5p?=
 =?us-ascii?Q?hKKdmk0CanoiB3inkK82WsWXg0Y3H69MyvIvcUqRzxifUN3okt71yVv3YM0j?=
 =?us-ascii?Q?GuHAQPq9H4DP4x/MOeo9de1wVgSiEVMu4SEQ4cE8bYUitvPW2FY49SzwPo8+?=
 =?us-ascii?Q?kF2R4AzWejcjym5VehGtx9MBtarxZXtSDMKmH83adYaiukAQRkS7Npg61Yat?=
 =?us-ascii?Q?62Qk1+8581uR4QRalU05KT7I72JuEnKSAg6xnej1W8Y2ACULSkpegTB4Tama?=
 =?us-ascii?Q?O5T7lGjaCl5cIWqBYCuUF5+dTFzSP+GsU1EuSHn63VKzmM+OfRowoB3pYwiq?=
 =?us-ascii?Q?Jg8wpvYsecfiNP8/hfAfKfydc4kWYdFOiYnZYC7Tpj2ByDDboTR6IWp0eHtv?=
 =?us-ascii?Q?4hGFaEvllsJj/DhtA9Gm/NmS8omKMmeUjMK75a7ZM5hKCj6T6fxLjNWbIwIR?=
 =?us-ascii?Q?oo5odo6tV/vrQ+W4h1Nj+4TSG8I0cpCgD+poZYRd6IHlh+ijropOqYEliw7L?=
 =?us-ascii?Q?+dd5YBcY9Hbu+4pSKO1rNj7+tfAW6rbmwTWLp6HvqgDKClpFktVYA6gB5vDG?=
 =?us-ascii?Q?Wl/g5fZ397e1LopTAa/4mvUvneG+vZb4NACBv84IBphp0jpq66oljvoGErzA?=
 =?us-ascii?Q?OPatPgsoY3bJtJndWozVPfiGGnWl8pbW2adYPlJW92X5gKPyHmeoW452H6Lz?=
 =?us-ascii?Q?/xjfiy5+BFzhHyre0BZOvAMo7I3e2a6/68oOIb163wcR0KHhSl3YCisGjoWr?=
 =?us-ascii?Q?RVGbiusV0+ddqPG21aSQsBSPsetB+p27EQ6uI1W3jB3AZEMBJjv3UMdPmN41?=
 =?us-ascii?Q?2+j4QfPQhGEkKIsTrPDoMSLYnCM=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a0aea4b-df16-42e1-6514-08d9e12cb323
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2022 00:33:56.2558
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zaXYRlgcx09mOI0Lq80fsupbkYei7IKWw5+sGRuhTPhWoKW9skkLPReBJtn96C//1BjeyTptTEUVHirUHLul+S7mF8ixFtUG08gP8MqhDms=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT3PR01MB6084
X-Proofpoint-ORIG-GUID: qFLe_ENTZM9BGxcLJEOXR2Brq9HP7qcc
X-Proofpoint-GUID: qFLe_ENTZM9BGxcLJEOXR2Brq9HP7qcc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-26_09,2022-01-26_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 malwarescore=0
 bulkscore=0 mlxlogscore=674 spamscore=0 lowpriorityscore=0 clxscore=1015
 mlxscore=0 impostorscore=0 phishscore=0 suspectscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2201270000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new microchip,synclko-disable property which can be specified
to disable the reference clock output from the device if not required
by the board design.

Signed-off-by: Robert Hancock <robert.hancock@calian.com>
---
 drivers/net/dsa/microchip/ksz9477.c    | 7 ++++++-
 drivers/net/dsa/microchip/ksz_common.c | 6 ++++++
 drivers/net/dsa/microchip/ksz_common.h | 1 +
 3 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 353b5f981740..33d52050cd68 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -222,9 +222,14 @@ static int ksz9477_reset_switch(struct ksz_device *dev)
 			   (BROADCAST_STORM_VALUE *
 			   BROADCAST_STORM_PROT_RATE) / 100);
 
-	if (dev->synclko_125)
+	if (dev->synclko_disable)
+		ksz_write8(dev, REG_SW_GLOBAL_OUTPUT_CTRL__1, 0);
+	else if (dev->synclko_125)
 		ksz_write8(dev, REG_SW_GLOBAL_OUTPUT_CTRL__1,
 			   SW_ENABLE_REFCLKO | SW_REFCLKO_IS_125MHZ);
+	else
+		ksz_write8(dev, REG_SW_GLOBAL_OUTPUT_CTRL__1,
+			   SW_ENABLE_REFCLKO);
 
 	return 0;
 }
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 55dbda04ea62..7e33ec73f803 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -434,6 +434,12 @@ int ksz_switch_register(struct ksz_device *dev,
 			}
 		dev->synclko_125 = of_property_read_bool(dev->dev->of_node,
 							 "microchip,synclko-125");
+		dev->synclko_disable = of_property_read_bool(dev->dev->of_node,
+							     "microchip,synclko-disable");
+		if (dev->synclko_125 && dev->synclko_disable) {
+			dev_err(dev->dev, "inconsistent synclko settings\n");
+			return -EINVAL;
+		}
 	}
 
 	ret = dsa_register_switch(dev->ds);
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index df8ae59c8525..3db63f62f0a1 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -75,6 +75,7 @@ struct ksz_device {
 	u32 regs_size;
 	bool phy_errata_9477;
 	bool synclko_125;
+	bool synclko_disable;
 
 	struct vlan_table *vlan_cache;
 
-- 
2.31.1

