Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13BC248C9E7
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 18:39:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241141AbiALRiW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 12:38:22 -0500
Received: from mx0d-0054df01.pphosted.com ([67.231.150.19]:52557 "EHLO
        mx0d-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238250AbiALRiS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 12:38:18 -0500
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20CGT6xZ010893;
        Wed, 12 Jan 2022 12:37:58 -0500
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2050.outbound.protection.outlook.com [104.47.61.50])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3dj2j2g1av-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Jan 2022 12:37:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j6TeKvFhX5HO1q6YhA1mXVrd0TAds/8W6TE0w57azSsbE8/ITI8lJjHmVEq9PZ4IjMdlsGSmCAySjXnR5zjnXdAWTYqJ0+8uCfPqQ2cWgiPScrXgr1o6guJQulPFoEzdk/Pis2nhS29K4msTAtADkLxVNqKk5OmodTxqwQdYcd2RWpc8jzpx9S0wVQuDYsDjH76eK+6jopyLl6F9jVLcmm0nDYntc7ZDJrpX8xwUSXx7HITdsP905flG6N0yX0JaPZ/XhyNGJOQD+VL6NbJfKD+P/a/Qgo5y6hM4T99z5+kiRu3EHdOvKFNt3IV2f9pupDfPlEwOqNrr2J+ywbW6oA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z3dMQGQgmqY6i5JsM9S5Mxn4i/H77WfgCoxjpWZxTMc=;
 b=nmp+qd/kbrfwakFz4v+CM1YvHjK2SyA7CcCDy84A/LzgwG6E6CYmhbGovCwxRZxli8aZcstXMG3WwgslCCUrwJwMkbc77Bh+iArPwlP0kVEeRxKIYyc8wJtZkSYBnnhrD0l9Vdiwdaw6wBPWRnu2d6rLDCD6r7HizjOClrTc5ch9ellmi6ed/j7AF0NdtzkcAnedzg9G4nkaPZkD6uO9FD8iAmw04odbwYJHUrXmh7PR2FGiIq4/mu/KgneZ5IdNyfvNC5kM3W1EJo1S21CTrZseB4/Ff1Bi3jLuBDSgoqrR4ifF3w0EpjE6U7cIJpM8N8I9K0O1fAlaFv9lNXS0LA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z3dMQGQgmqY6i5JsM9S5Mxn4i/H77WfgCoxjpWZxTMc=;
 b=zfne/pnwJE2wUkyToWJkPRGwpL1utO6eTfW5ZFQy4fb7CbS7Qwas51j/BzOyaTayhrclNZbg8/PsubzVSWszsybgPNwBW74Hj8a2IliNmiRXW4qO7WPJhK0G8Il8Cj+kunZdt+4knDCYqR6UHVWVHCIDmh0/ifIZqaWQrmr3fc4=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YT2PR01MB5789.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:55::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.10; Wed, 12 Jan
 2022 17:37:57 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8%2]) with mapi id 15.20.4888.010; Wed, 12 Jan 2022
 17:37:57 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     radhey.shyam.pandey@xilinx.com, davem@davemloft.net,
        kuba@kernel.org, linux-arm-kernel@lists.infradead.org,
        michal.simek@xilinx.com, ariane.keller@tik.ee.ethz.ch,
        daniel@iogearbox.net, Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net v2 3/9] net: axienet: reset core on initialization prior to MDIO access
Date:   Wed, 12 Jan 2022 11:36:54 -0600
Message-Id: <20220112173700.873002-4-robert.hancock@calian.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220112173700.873002-1-robert.hancock@calian.com>
References: <20220112173700.873002-1-robert.hancock@calian.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CO2PR05CA0061.namprd05.prod.outlook.com
 (2603:10b6:102:2::29) To YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:6a::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1c2b12c8-e3da-4742-77fa-08d9d5f2456d
X-MS-TrafficTypeDiagnostic: YT2PR01MB5789:EE_
X-Microsoft-Antispam-PRVS: <YT2PR01MB57897369139980521E018CC9EC529@YT2PR01MB5789.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JMS5Sm7HUAodhLKcveoCtyQtV0q4gK9bPJ5r6BWIlp3x+06wS5RuVP8O7P0ONFQ40F7n+09uLLEjxkf+cZ7EOWCqVFU5dCLLgnjqaLtfiAQhpz21osonDzUaP1O2GS/R5eHkCltCP+Vo3n12vZv0uqvFxICzueTGIBJNZQehLpCGcThiLBmlbvwdnHypk93yCX5g/5jD4rzLf+GhHYZXbIQM002uJAn+uFzzWDAmDueP40RNu3C5gzG9IoOhRPOGV7CDmHUaC7flYAL3pTn4mfhov0dibIVdpwrVBygnKxjxIe8ZED7zQCnTdaDDuY1mifZ7Jdho+O65Sq78FIPJpSmqTnDwHGjOFg8ywpdSJmQseNTNjmVRcp6ZpkJaN5Rfv9JwhN5CzVbDOBZn3AjyoBPJSiyzHfs69JPE8AP8glq9WbvHQB1/uxtjKbFtt0vpalj0EgQRsWeMdIuEuijrIBbcHRsNqc/ayQ5qMPUhwhhD0cJ0bzTfRJPkyYZLb8yCXTJVnSxTroNWI+zdR+a3J7jpFIdomqRB2LjTKMf/2QTJx7MNvfTvgm2yhkzrfs6ryoI/B4CfY5gMurmaFzeBDy87WbXhipuHjCt6vUUlglXAckwyW1YlCoYCT5mOAC7se5a2yZEkf3WisQw9gK/roboD7EPTLmpjKbQR+Abrp1CaontSITFAgb4S0TtMXBiTesFvgvtN8IQndX4Ixzs/mQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(38100700002)(66556008)(66476007)(5660300002)(38350700002)(44832011)(86362001)(316002)(83380400001)(36756003)(6666004)(2906002)(2616005)(6506007)(8676002)(186003)(6512007)(1076003)(6916009)(4326008)(508600001)(107886003)(8936002)(52116002)(26005)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GERs7Xp9R4QLgVEgvysJSICAlVH71XiQWw3NnXEnQiuXiARETAwangqNoOrl?=
 =?us-ascii?Q?sfJb+s73fLjcf7LcP+ENWVEbc8mVNgSazM4HlJ5ReHPzo9RN8KjAZE5IL5tz?=
 =?us-ascii?Q?LO/macTYyq1aomqpfP4yIQ2NhwjH9D7edR4+qJpZKtLqo4MqJkb44l4p4NZd?=
 =?us-ascii?Q?4BLEvk+nDFqzsWSRJFqDCqhuCbYJdaZGKUtV29pEj56PT6mhipKeA6n2XXFX?=
 =?us-ascii?Q?SArdRoRZ1Nyxdcf9pu1PcDtfFK+huemP1a7v+vp+xrVZHk0NqiA1MTAtzbIy?=
 =?us-ascii?Q?ef4Hik9Owwy6Hnj7LaGK3Y3AOV4I2SB5ZQCCA5/lHzxId+MVfYziTEvv8pUg?=
 =?us-ascii?Q?VNfuwfJVb9bhPmvc9yc1R1BB2TJY6UkRQcYRrrdQCwv6kL/TTxz8+tWo173z?=
 =?us-ascii?Q?ELqPu7hTZaUTkk/LWWcvT49EVN69RSYPgC14SFAKi0eXT2DPLFBFyypfKJGf?=
 =?us-ascii?Q?4H0da9CxzMWDYuhCLovhXW4p09SjeodeYtX0SZR5I58Z7GoqkkG+wQio5xIX?=
 =?us-ascii?Q?aLRnWCD3I6lZmRfNwTr+ZTtzdqh//uQSGPICEdSpNrvkjAJdlGLQS/cMdQ3A?=
 =?us-ascii?Q?6HvbGF7hjcOej0cpzvlLPl4N9dtQjyeYfQjiUz5MHAkQuIfYQdTRfrXL/PEL?=
 =?us-ascii?Q?SV2SJx0+XoMbF+COxDasN+cw3MCuzhPhRxfrPykZwhkNPUouwVW2IbZscm7/?=
 =?us-ascii?Q?9i8iQUV9Cx48YSe6HxiAaw29hMo3wCAfqUBz3lnUWR82j2bfvKvNXQO+HdDv?=
 =?us-ascii?Q?p43bQDzwhpdOsJf1zIavK2cGUuZxOLRgFvSKao5oPWQKKGpcAtntEF5nnPNm?=
 =?us-ascii?Q?H/+FIEPf4pYirtbvfMM2+iXP0fgebwjS2KqnQOhRwPjQUKTnSaLPVoM7pfFm?=
 =?us-ascii?Q?gLqgOwxRnaf31UXD//W2drCpv2DUGHNWRQ28dvnDkGIa5MN+jEkSM5xOAXDB?=
 =?us-ascii?Q?96S89aeBhYh7kB3gbwQwtBlpC7gijH9yvpfRdKFgXenV7yT1y/ht7JSVQfD/?=
 =?us-ascii?Q?wUhwMwhO9NqKGB7QnB87gJxhpCOhVjxkv9dRS7Wquwh3vBW1LrzrfJaIzguv?=
 =?us-ascii?Q?b0VwF+Lyp9lTDGhqvUzPh31gkHJqB3QRBlNVGGrELXlG5H1LGpoK2hCscngO?=
 =?us-ascii?Q?jCt8vsSx82I2H86wogKbcmByccnbprvuuF8cC/afrd2zGbsKSKOAiRCJ4c9u?=
 =?us-ascii?Q?3VZgAQyohqW7Vbte+7y2cGQOwYonP0Qazs2IIvhVkLeE/G5pWcsC0MfErxwe?=
 =?us-ascii?Q?JZGTE8YVQExuQLpIRTofHaLnmNakAD4B5xHpPthDOwFp5V5qijlTcFWovtqj?=
 =?us-ascii?Q?l6UzFvFtBRQYEm29IeekBiR9xbyA0EDSsiqYOkOWTmA0jqPeDnJJFiyLLcmQ?=
 =?us-ascii?Q?tIVZ7dIatoCOsFukJcf2AQdI2C6N8cMEi4TBNMibwmpEH4Ji/22g3it7cBtv?=
 =?us-ascii?Q?Upu+3KLlAZXv4aLaN5mP6UetrWc8yaiIvn9OVxC81KJTv0jiO12WiSjCn/1h?=
 =?us-ascii?Q?qV99cAiwtHCWZrFd+xto0lxrj6TAd0hP9+o3wxfhUPfmXve5aD2tkku1euQY?=
 =?us-ascii?Q?SiOUJSnJgGf854QaYcCsXOFnX8byoQ9mfSJIOpqp9P8doD/OFfOn5iKrF9pa?=
 =?us-ascii?Q?ojXjxGMFMIkrKwodpH49vZB5CrzzyacmbINdrn/yyeRfuVXal071Jv5s8bqU?=
 =?us-ascii?Q?2mTV/K8kvhd3h86DMQlb9Qdyd1A=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c2b12c8-e3da-4742-77fa-08d9d5f2456d
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2022 17:37:57.4659
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oX6UeHp7GNBbpDtQ79x7pb/o8FGRvf5nYuoT+2VMlpze0ZTvqBwjQ1zUmZ0q4a3gI54/HAi1RZLumUuxVWgZQW6SK61RHt2pezD9ji8iHVI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT2PR01MB5789
X-Proofpoint-GUID: D3RHLHVFxfa3iW4LtEqW_OUg832yskmY
X-Proofpoint-ORIG-GUID: D3RHLHVFxfa3iW4LtEqW_OUg832yskmY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-12_05,2022-01-11_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 malwarescore=0 bulkscore=0 priorityscore=1501 mlxlogscore=999
 lowpriorityscore=0 spamscore=0 phishscore=0 adultscore=0 suspectscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201120107
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In some cases where the Xilinx Ethernet core was used in 1000Base-X or
SGMII modes, which use the internal PCS/PMA PHY, and the MGT
transceiver clock source for the PCS was not running at the time the
FPGA logic was loaded, the core would come up in a state where the
PCS could not be found on the MDIO bus. To fix this, the Ethernet core
(including the PCS) should be reset after enabling the clocks, prior to
attempting to access the PCS using of_mdio_find_device.

Fixes: 1a02556086fc (net: axienet: Properly handle PCS/PMA PHY for 1000BaseX mode)
Signed-off-by: Robert Hancock <robert.hancock@calian.com>
---
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index f425a8404a9b..f4ae035bed35 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -2055,6 +2055,11 @@ static int axienet_probe(struct platform_device *pdev)
 	lp->coalesce_count_rx = XAXIDMA_DFT_RX_THRESHOLD;
 	lp->coalesce_count_tx = XAXIDMA_DFT_TX_THRESHOLD;
 
+	/* Reset core now that clocks are enabled, prior to accessing MDIO */
+	ret = __axienet_device_reset(lp);
+	if (ret)
+		goto cleanup_clk;
+
 	lp->phy_node = of_parse_phandle(pdev->dev.of_node, "phy-handle", 0);
 	if (lp->phy_node) {
 		ret = axienet_mdio_setup(lp);
-- 
2.31.1

