Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBC5448C9F0
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 18:39:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241680AbiALRi7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 12:38:59 -0500
Received: from mx0d-0054df01.pphosted.com ([67.231.150.19]:58546 "EHLO
        mx0d-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241271AbiALRi0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 12:38:26 -0500
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20CGT4uN010837;
        Wed, 12 Jan 2022 12:38:06 -0500
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2053.outbound.protection.outlook.com [104.47.61.53])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3dj2j2g1b7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Jan 2022 12:38:06 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mLffMOYXSrSa95ZDUokz7q0eGoHBVhkmsXj1X78u3fiD2cL/9rrIigiKppnxO95KUX6o0cy+hLpoVgTvun7cAcpMipM++9x9mvM+58IMtCdcbqluyewZtZlYuvjIfrXgBGyrOPkTzdgUd02lt2bYK/pLKXwloZir3278ctXEnHIW2McZK2EZxw2O80DK4z5MrX+AwN4zmd7i0alRpXkXUP6i+dSigdO6Knzuudkfxp09KfcjGW6TZYhGUJRX3kz4MCJpOULNr1ykFFOw5tPExpP6P0xlmKD7HKOA8qCimsfoz2XSxoMuLJB/WB03qVyakvw2XiWBNaJu9moovNWvsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HgBfeBPBU0sHw7Q/3UtmHHhCi6TrDK/ghccggs1REW4=;
 b=CExq0eWqQOXwSemyzq+FQWg43R6PODl8pZJWVI72Yah9gWTfkwlZenq7xXl/BqKuUL7QB1zO5cbDC/H8V4G49pErbcwq5KtqPEGFkdaVOB33Nbg55dr5IxF+FATK0GfHGW/8KeUapdVbgMNNF8T3GV9Evc9k6dhj6lQkUf/Rf4tFPnzZlkPn61CT2xo2Mrk/gk1rBK3Z6cj4ab45ssAEJlwY3V0C7F50qpIaCOQJnUzJSAFXyIyzliyw604rYKpWgqvW0BShJYOikfKyV55+NqI0xyo7rBHUx1mnydmuLBbk3B4aYL22H5dhvnzdRZbPDnoTSzS6N00JuH2CTJrV1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HgBfeBPBU0sHw7Q/3UtmHHhCi6TrDK/ghccggs1REW4=;
 b=wfpK+7wQcBMQEo7o5nUTbzLnxGMuWtnNIFFYkyO1PIPCGi0csoAaXOt1DgKmMmPKxXb+bQxwhuhKZqv2KREeLkVSNvstVsvOy3ggh3WYNOLcLgWP5A3DrBW4h7mA9+lJVNU6WnWMOcszE5ys5FvxtYXIFJeFpET64x4Lfy+nn/w=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YT3PR01MB5490.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:62::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.11; Wed, 12 Jan
 2022 17:38:05 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8%2]) with mapi id 15.20.4888.010; Wed, 12 Jan 2022
 17:38:05 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     radhey.shyam.pandey@xilinx.com, davem@davemloft.net,
        kuba@kernel.org, linux-arm-kernel@lists.infradead.org,
        michal.simek@xilinx.com, ariane.keller@tik.ee.ethz.ch,
        daniel@iogearbox.net, Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net v2 9/9] net: axienet: increase default TX ring size to 128
Date:   Wed, 12 Jan 2022 11:37:00 -0600
Message-Id: <20220112173700.873002-10-robert.hancock@calian.com>
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
X-MS-Office365-Filtering-Correlation-Id: e3643171-af13-4ad3-2a85-08d9d5f249f8
X-MS-TrafficTypeDiagnostic: YT3PR01MB5490:EE_
X-Microsoft-Antispam-PRVS: <YT3PR01MB54907554EB68A42DD3209A9CEC529@YT3PR01MB5490.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mk5ox980Ubn6hLgDCW8zLv2Ihd69FRyfJ9nK+d3W6VEWLGg99QArofjCmcCvQ7Ovy8dVVtX3CnSgwbEa/NYooqrQB+MZuICJQGl4d9ljMt1jQx6A7TGUM/KnZZPXwN0cL9WWe/dl5XxKL5x4NoVk6C5p7rtlwVMEw+J1xsunzosdPsJjSIhZsYM3aMxdSCz1MWWBa54VSAaCPQuQ/H8tdpCuvy8kNgRzWeag0yPnkFf9QkMAWtT2l0dLWxDv+HymJz/K9R27vdkaLBxMZcBYj+9RKF74lWLXQs3E710nKmz82N4thKDUKQJv1xZqnuAb7h5VwP7IFt2Hrx3TsTLaOeOHhS/7BeerT9sQ6apAB+oQdBIJhvqbO5RoGDdX/CypnMs/0yVaof/jkn3EUWKZC46BO4qfmJCU0VkbuFvn79zLCJxpt+VRkOV8rLkmyY3kRj1Pmww0rvtt7Rh986sm/vWI5igLiUEiDttFTyRrQZY3KfQAjQ6kcnY77vX9P0IPhuU8JwTKSWPk3Q20kUQEvU4OWzgJeCfQKWX/rC4jW3la1EauaP6Z/GckrvbUXbbZgKWDO2T63K73VcQlH2nZHwi/eyKIe0vie0GE/WZXlLAzx6BIKJshIyJbEOoE2dk9KuDE/iJ0l/2q+A6xaJu2a4qwZ5p4PrJDaRFn0CfGAWQHp0pGhFsro9uX5F8EizrEVX2Vs86/Gson1L9OFsp7rg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(66946007)(66556008)(38350700002)(2906002)(26005)(508600001)(6666004)(83380400001)(66476007)(38100700002)(52116002)(5660300002)(4326008)(86362001)(6512007)(8936002)(8676002)(44832011)(6486002)(36756003)(6916009)(6506007)(107886003)(2616005)(316002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uZ1DATRjSd15EQYzywt1IiWUogqzRGZhdrPHDl/Iv5SXKHMqMw+lJu4Ak8jv?=
 =?us-ascii?Q?NpcsV6gBfBlygYoP5J13WjoZtMD27gGDoaX50fwFX9jMf6R+G4GGB9NFBjNv?=
 =?us-ascii?Q?4aJJ8PMq0xe2fYLsizJD1K/iLrt5Hr8jCdqPCuAYalSD4mGt3epbyXHKY19o?=
 =?us-ascii?Q?/xcjudCGSb0v04PFkKBnQGgQtaGogesMfNfAuEB/dvMAtHYg9gPc0sPuz+1j?=
 =?us-ascii?Q?PefWshSgGi9JWRxDi7RpwFjfbrvSMk1Z/LuY3EAY1zjA4/VafU6XUOsCTXM3?=
 =?us-ascii?Q?x6mlC9LSWSt9KmlIPNlG2GnGsRRLgD5buRR80bExPYq/yvgdM95h6xSBKq52?=
 =?us-ascii?Q?04Fg3o24mI/jftbUYctdmkDj2NpKRhG20nEvXlkYlL7p/N1yJezwpww21dUv?=
 =?us-ascii?Q?nKpclIu3Wl4jiiJnElH4G7gAlU1UG0A91SR034ZJv2iT4oUK20pI/kO9hEn/?=
 =?us-ascii?Q?z07zKT3SkiTZiBnJ0icV5+Pl/iOcZf6iJFHitbXrf7rRrheL13iJlrx5EjMh?=
 =?us-ascii?Q?m3QjqYl1vxvQtUbLA024yT4Fzc4A1Oh6UPukr+rkmW/beHFsODHfqxpEYJCr?=
 =?us-ascii?Q?ePuSWD9kt/JSMFejFTzeKNv9Jw9MnVM8KIPcwCeTOB4npYWthuueWQnuv943?=
 =?us-ascii?Q?gMX9H05KoL+T9v8Q2624bZjg38TbcxBUDBgLoOEbaz4V1KjF6+wGXXZCB9Jr?=
 =?us-ascii?Q?NX/s3TiPD3xR44+X0s3ZH6y92pCfl4Lk5nc3+Da0om9Z4JgGwOb5YCsZleV4?=
 =?us-ascii?Q?oybL/kuXv978BUwb8ceYZIPBPXoiDnx95W1NTgnMHG0JDu6MHMQNts98uhIv?=
 =?us-ascii?Q?mMjnGnv5C7srXAolVU/IgCDrITLrkKgDa8AfCevR2YB12KcvejTfkCNqR9U2?=
 =?us-ascii?Q?3tO/vTuNS9Ev1Bd8EyD7KbZe4fTI4WA79FV7NTraP7zDktcUbPv+jDvWq2Qf?=
 =?us-ascii?Q?X5JZQODLROaYNVX2OJmqUe0a+lFe7dt8bjiWlxy3fmAh6pjYEAuWYKPzISDk?=
 =?us-ascii?Q?foQ0D6li45DM7z9hImSjS5byg4kxiM2AhedZYOoSsmp5ycObLXR9iVgLtRhC?=
 =?us-ascii?Q?MSIqnfw+aygmfplqHtqNSAHXF0aiWCYrT5aLaHYsWczMjhHNnpSH/XACrxsp?=
 =?us-ascii?Q?n1uP3sO6vNa4rZ6ecqnJ5wSkuVIm9twCmaW7+ImZGQB2/J8NAbBJNSvNvKT7?=
 =?us-ascii?Q?pW4y2iKxZXXn73Uiw3RZzSjPcMcuRqUbHa15Ui1U2GOt1agsL+QDgsn5ANDk?=
 =?us-ascii?Q?9WOhMjYb5LErdYb/ptP5Z/V+4YdBE4vkRUMjSx7Ops4MAY1IbuMMCjP2Iemp?=
 =?us-ascii?Q?WgGj+XQDEH6bF2TaPqlBiKccqMugDdStUDtLNE6N5eHU3C5+wHNvhl+IiB82?=
 =?us-ascii?Q?iszgJcFKCsdI3fjxjEjMBDW1mc8zOZgWixrfwY5O55+6sgSADa2hVfGoEdpT?=
 =?us-ascii?Q?JQL+tY1a2SrFDhSmte/3my42KNgM2boJ2xbhcaLsF5QC/E5/rtVzADrINYMj?=
 =?us-ascii?Q?YIj1JYIgNOTaSFHIpZLMI8CeKSVFWp7UnkbCQWki34VIciMrUn0Y8SPeeeuX?=
 =?us-ascii?Q?w3F3wYJKfRtmRER4MB7gWOqeIm+usB9TeQggfNA4Em1uWVhZmt3/mzKumFXq?=
 =?us-ascii?Q?hbN+fbHDhNzsC8vECZyT0cl9MDIOcGTuyYXGbbYUJCZhGJJxvoPPNRRkGUT9?=
 =?us-ascii?Q?zLCsOBiSE2pb5UP1FEyzbWj7S74=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3643171-af13-4ad3-2a85-08d9d5f249f8
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2022 17:38:05.1326
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3pmnsDCnWRzGCIWe+UbDfBlyKTlDykteHEl7To/mzMvv0FljBMy3WHZn1T/JWumiZG/QKpsUZUbY8yDp/B1kj3O1563SkIqv+Tf0UGZKuDs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT3PR01MB5490
X-Proofpoint-GUID: 5kjDNVzKQdKbWL-EZDX1MlTSRBgWpxfz
X-Proofpoint-ORIG-GUID: 5kjDNVzKQdKbWL-EZDX1MlTSRBgWpxfz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-12_05,2022-01-11_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 malwarescore=0 bulkscore=0 priorityscore=1501 mlxlogscore=687
 lowpriorityscore=0 spamscore=0 phishscore=0 adultscore=0 suspectscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201120107
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With previous changes to make the driver handle the TX ring size more
correctly, the default TX ring size of 64 appears to significantly
bottleneck TX performance to around 600 Mbps on a 1 Gbps link on ZynqMP.
Increasing this to 128 seems to bring performance up to near line rate and
shouldn't cause excess bufferbloat (this driver doesn't yet support modern
byte-based queue management).

Fixes: 8a3b7a252dca9 ("drivers/net/ethernet/xilinx: added Xilinx AXI Ethernet driver")
Signed-off-by: Robert Hancock <robert.hancock@calian.com>
---
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 8ac277ef1f99..d5ea093fbd32 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -41,7 +41,7 @@
 #include "xilinx_axienet.h"
 
 /* Descriptors defines for Tx and Rx DMA */
-#define TX_BD_NUM_DEFAULT		64
+#define TX_BD_NUM_DEFAULT		128
 #define RX_BD_NUM_DEFAULT		1024
 #define TX_BD_NUM_MIN			(MAX_SKB_FRAGS + 1)
 #define TX_BD_NUM_MAX			4096
-- 
2.31.1

