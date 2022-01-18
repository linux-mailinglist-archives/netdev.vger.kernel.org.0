Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5484493013
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 22:44:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349613AbiARVm4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 16:42:56 -0500
Received: from mx0d-0054df01.pphosted.com ([67.231.150.19]:5990 "EHLO
        mx0d-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233335AbiARVmr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 16:42:47 -0500
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20IBseYb030788;
        Tue, 18 Jan 2022 16:42:29 -0500
Received: from can01-qb1-obe.outbound.protection.outlook.com (mail-qb1can01lp2052.outbound.protection.outlook.com [104.47.60.52])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3dnbdu0rta-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 16:42:29 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RCgxDYu5HCBltRIHkfD5jkKRKr+pbWUdhaZeEenSRfKoSOzQiFmgixBjvLry3yds5ZePGxepKW1U7t/gaGX5X1qI2sdGJpXa2IOKaqxYpSmv8ElBWewRsZCnavTqiV0hscpj+wmHVBczLhbVvXclV6c3w+52xO2p5xTBwIWnq/SJTViE3knc3ZdPFQHjh8/4lwJA1xdlIbdfPhFam8n7CTJZaOJKHK9ySpk40Fx8vlGMSmT38tQQ8lbmFbDpMNMwjny7ZqIfubNZlX6QVGbeNNOqy4iRUMRzt0jjcgBs9OK8EKjeYnahxPHvrPKZ2ahiqdjCjube7YvC6X7TdtT85A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4PR0lm+N0anKi1GoxabW0olSDZIV43dwjQfIwSvvyP0=;
 b=LJpOCLQpIbQGZI56GgGhi942mPa1HLzs1SJrShrNoeSpCseE162Tx/P5KQr8mftIoqSN9/M1PkzqEbILtPdRsnPjdesizHk65yC850Y0ZT5swmO4c349DqYbIxtDw9U7+EG2Mi3EEFQbKVjEm1CBurB5yREG86XYZg2DsOr550vFtOJ1cSDy06qgS7XNZECMiX1oM5TZ8fhUINMYxpv5efE6oWUxKG56ztFDkKk7PzKRrS1On8RY8zIWk2I/pexloiB9/8f1GNo4SYyIHIqYZ3nsqrPzv4uwEUMNSQBDSZDETOmcoBA0xMwl2C5Df6E2nl7wOtzSP1cjJK+j1TNiAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4PR0lm+N0anKi1GoxabW0olSDZIV43dwjQfIwSvvyP0=;
 b=I6uS4bHs4Ar4xibTFifTCXuLysPGK6v7u7Q1wrZM0CLtskjY1TAxwpRS/0gSaMlehoZ7/SZ8RXZ9lYHn8pyuOHdWlfvBXaeusAFNf2tXbjvbwCJAVLXszK9eU4zj8aSXoNn2SN1/tj/DfXih3pb5BGb2BqkFU2d2A7o7bSqNdI4=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YT2PR01MB6579.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.11; Tue, 18 Jan
 2022 21:42:28 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8%2]) with mapi id 15.20.4888.014; Tue, 18 Jan 2022
 21:42:28 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     radhey.shyam.pandey@xilinx.com, davem@davemloft.net,
        kuba@kernel.org, linux-arm-kernel@lists.infradead.org,
        michal.simek@xilinx.com, daniel@iogearbox.net, andrew@lunn.ch,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net v3 5/9] net: axienet: limit minimum TX ring size
Date:   Tue, 18 Jan 2022 15:41:28 -0600
Message-Id: <20220118214132.357349-6-robert.hancock@calian.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220118214132.357349-1-robert.hancock@calian.com>
References: <20220118214132.357349-1-robert.hancock@calian.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR03CA0009.namprd03.prod.outlook.com
 (2603:10b6:300:117::19) To YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:6a::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 415c3a15-8a03-4524-a66d-08d9dacb6c3f
X-MS-TrafficTypeDiagnostic: YT2PR01MB6579:EE_
X-Microsoft-Antispam-PRVS: <YT2PR01MB65798FF55D800A01E166EDE1EC589@YT2PR01MB6579.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F/NGnDupz2HVaPj6ZHIXzISppYU1PWjsGkoaRYzmQYTS2HoIpbUtcNxNrLaUNaJNn9pxgXcl//fkjvGLblVqt/P4xQhl2BAT91PtW8p3dBJiCFBaChyzqH/Ns7UlH/mX2GjHszWpCPAbjCinEwm3NUC2yfrJID8pAPsNZGdawJ5b5i/BmDiDtomvi3gnqxFOoIipHKzjz/sp5ivPwpK15hvCKxC3SWCI4g22pHRcrYRCl4XrrryVOLsN2pI+Co2uxkv1KZEn5P/UV6lNgEKXK3vDU7euSLFN8MygWnkoOsXSvKn0VYN4bF9CIFMu+2XxWhYwYT138aHNXdqcmteue2R7Gwq2YIL4aJwx1Lpsq0MD3F/NJdME+Zj8ngOpGrEPnNoDofM1kgG/Co5SPoO/x/rsc1Ts8T7J+Udtn7N1shHI1n5R3rG6B7tYpB8ZDgched30T05mg7MGPEZ4PCBwC6KvlKVPQUwfWvbSpNPMEAtEw3qH2mgVsmk7dZ0tOTHFHhDw+wbG7Ksew0SfpiFGecxqFD5NRqXxhtiT/ReszL/RZGM/znSScylHrNO6mr4byl87KudrjwRNizXyXjCZuWxmuZx3d9dtNSdTGP3U3TBxulZoJROkda9mQtPoXcsTHbjs4tvVFEXCME+p9ufCtsD9V1RNV4y6GdK8h3ZO89rlLIwHajeVSxTAL3FEkKKA98pGhS0n0z05YcADor0g1A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(66476007)(5660300002)(2906002)(66556008)(4326008)(66946007)(86362001)(6486002)(44832011)(316002)(52116002)(6512007)(1076003)(83380400001)(26005)(6506007)(107886003)(6916009)(508600001)(38350700002)(8936002)(186003)(2616005)(38100700002)(36756003)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PTFK0qoBQNC6ncGcPATM/PUPEpV8QfDY2ive+RvmZR2cETBKZi0thtw42QKA?=
 =?us-ascii?Q?ng6M25j8hGyTFX5ikvBgBJIPBTI7PKzWZlKbjHFSHfY/7fr1lzu3I883OIaX?=
 =?us-ascii?Q?vlSiNUsx22uJ8Zd35RFf+Bh7dweW8NgEyD5azYDiKSra6TGrk+22Ox61XZNs?=
 =?us-ascii?Q?tIomT754URUKlvvJ7nwunlTrxN+x5Zl8xo6w73vgCiMwawhyhXI42fAUvdhC?=
 =?us-ascii?Q?5JnxBoTCt6WcYwWDhs9fEukU2Rq3Qc6siBywa8jUaTTOnclvEOalV9GL55K/?=
 =?us-ascii?Q?ab7Zcy7ik7CY4AlKO4oaeVTmddSS2bdvKDohiVtltnbdFM1Y2AFgZvdE7E9p?=
 =?us-ascii?Q?zjyWispQd3BdWN+oEWmLaNIEcXfT5DUa/A0LAHIsLPj4lDxSKM+PS8nqEzRn?=
 =?us-ascii?Q?dDKaglaQtfFkNgiV/NxvshWHRaSDf1OKrd992aJ6eBuq8+TUMuPIxn8vXYpw?=
 =?us-ascii?Q?jOB5a2XCKet/7ipR1Y/JvjvHSjmE8YGwjKhUPTLGzzyT9TCbd0N90IoKTh4z?=
 =?us-ascii?Q?bu8olf+U2ziAk4huIz6WSleV0JWZPY7gMEmEgg6DLy+a5/Nrrnnme2mVuJOj?=
 =?us-ascii?Q?emfsj+4KzPj9mvwurJp/C3y5IGwkBBA0cXPkgSQq8b9ulP0/pJ35l9AHlcMV?=
 =?us-ascii?Q?3vWIKslonVb/V5FJTAffBlJZTufBj/P+A8MHCfSKKB7tYDYSXivLyPubT9v/?=
 =?us-ascii?Q?1lkg5MkkyJDVK013EqOPQPmv1oEmeOp0dxTfwwV8OJuHMoP40XUvTFgGjWkj?=
 =?us-ascii?Q?eBxG/4EQjsWYiTwXLuf3ILwlWJd7ZBjsWWyDk0QmqFH7IHDh7gCwfqmrTO2k?=
 =?us-ascii?Q?sESUcl4GV4YRiiLRuJTLmM8ujxu8JeGHpDp5p9EexRIr2cLjpcdH4rhdvxkA?=
 =?us-ascii?Q?NrXGObLQHiuoRUAu95TIncyKoe997/NCrAbE8axV3LoGNOolf3CrZD20+cKe?=
 =?us-ascii?Q?mYZJQeyr0dKGyCEN4hPK/mAfagMxMo7/3fZCfKdjgNbAjDsqQehNcl19jMzT?=
 =?us-ascii?Q?6bb5XdZpZFmmV1Uo1yKGaPzEeSKh0fuJYZC8tSYcINctXJprpqJ848Iqr5Eb?=
 =?us-ascii?Q?IfztTtJp8r33kcen8s0WoGU+id4ax4NNnDHKMbMuPGTc98G61aKjoNotYDSr?=
 =?us-ascii?Q?coK+aAbmiTy/wpAcnvUpPjEWnV2GflBFJuQ5XlokkPtJOH6kTg1Nme2QYaFM?=
 =?us-ascii?Q?6q2hhYoFJCM89RzPakJUoHpzYAAucADCcnJ+3tsWmqCdmz1iYZhCCxTO5ejS?=
 =?us-ascii?Q?EAlX97Lwx4R/OaciY/qfscdYT5LDEeoxO6bAlZmZI+0RQwgoAH/M6h5wD+QG?=
 =?us-ascii?Q?feYKcEcpUATIitX2go7FZTvaBOGNET1eyiwWYQDmfqOp6j8yoF7n9rV3Zvs6?=
 =?us-ascii?Q?jkNs7hnPpmiYkbI1bjM4JWtkfkIYmIfs3NfL86LjeJBY4sgDsnjGoQMvM1BQ?=
 =?us-ascii?Q?nwPKrfBHlRt37mUjI5oC3WQe5I3sOgXWREOLyR2xcK6roB4+Hgth1lOGx+89?=
 =?us-ascii?Q?Ro0cahPTWc+WOrVIRS8FT7Q8lHpXZvC4ILyWJu9vJstYaBfR1uqbCo2r1CqX?=
 =?us-ascii?Q?hIquU8qj7oXXYYoDcfLf7d34bwCkbwRuEkbvfVxKciPooUFWjqhtPwv5qtdf?=
 =?us-ascii?Q?nEeNmmDdpfLiVZnfiaE4X3z5Mfq1VG1bA59JKRPsCi3KQ/3rWmTPtCPnsJ57?=
 =?us-ascii?Q?JyoNimTYD6UC+fQ7sQOLov840ug=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 415c3a15-8a03-4524-a66d-08d9dacb6c3f
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2022 21:42:28.0680
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ecfA/arVNgX4UreO5vh2tvlxQt+NQ9FzJbXqChqEZQVL7ENRHyPBq1dRkDXZDO+xZdEf5RlMsLxmiRpPQ1GQu/sTNhn+6GNU6U6EVgeeke0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT2PR01MB6579
X-Proofpoint-ORIG-GUID: pd-tQOmTWjIdauqfc9op67-dRXyncCFL
X-Proofpoint-GUID: pd-tQOmTWjIdauqfc9op67-dRXyncCFL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-18_05,2022-01-18_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 suspectscore=0 impostorscore=0 lowpriorityscore=0 mlxlogscore=700
 clxscore=1015 priorityscore=1501 malwarescore=0 bulkscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201180122
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver will not work properly if the TX ring size is set to below
MAX_SKB_FRAGS + 1 since it needs to hold at least one full maximally
fragmented packet in the TX ring. Limit setting the ring size to below
this value.

Fixes: 8b09ca823ffb4 ("net: axienet: Make RX/TX ring sizes configurable")
Signed-off-by: Robert Hancock <robert.hancock@calian.com>
---
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index fb486a457c76..3f92001bacaf 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -43,6 +43,7 @@
 /* Descriptors defines for Tx and Rx DMA */
 #define TX_BD_NUM_DEFAULT		64
 #define RX_BD_NUM_DEFAULT		1024
+#define TX_BD_NUM_MIN			(MAX_SKB_FRAGS + 1)
 #define TX_BD_NUM_MAX			4096
 #define RX_BD_NUM_MAX			4096
 
@@ -1370,7 +1371,8 @@ axienet_ethtools_set_ringparam(struct net_device *ndev,
 	if (ering->rx_pending > RX_BD_NUM_MAX ||
 	    ering->rx_mini_pending ||
 	    ering->rx_jumbo_pending ||
-	    ering->rx_pending > TX_BD_NUM_MAX)
+	    ering->tx_pending < TX_BD_NUM_MIN ||
+	    ering->tx_pending > TX_BD_NUM_MAX)
 		return -EINVAL;
 
 	if (netif_running(ndev))
-- 
2.31.1

