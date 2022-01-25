Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5823549B966
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 17:58:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377430AbiAYQ5K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 11:57:10 -0500
Received: from mx0c-0054df01.pphosted.com ([67.231.159.91]:44342 "EHLO
        mx0c-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234463AbiAYQzG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 11:55:06 -0500
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20PBNFCH021579;
        Tue, 25 Jan 2022 11:54:37 -0500
Received: from can01-qb1-obe.outbound.protection.outlook.com (mail-qb1can01lp2055.outbound.protection.outlook.com [104.47.60.55])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3dsvtr0xq1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jan 2022 11:54:36 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jKQJVAk/V3hOAPu0MtJ4nlNYa6tTTVqYyVByhUKAWN6FAkJJ+LqWxGzcgJ2xFrGr/VAM6D14b/6CZ/t024PdKrpPjQWMfT8mJNmztTu3EW11WfWvbbyBGnBogQOZwp1sK/IA4DdqZ+TwQ8Y/BaOaYVlpS7hQ1qAkrDZVra1oSIFfJRYUzLrkvtPVCpM1OBt+ZmXHQbr7lqW1Oxdd0NqUu5VEoBYL6ZirQNS5SWoosl/ZK/J0OIMCQrkNWGehHMaTw2lD70+pUxz/kR6vDNzM7ZttaMQY/lsjp8WCUTy3SRS2EliuwpmvvVwEKNNARziZAX71K5s4BrAVdU9BwE/8tQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d3+0EsCkTNx+0iboNdAP514SNdgF0xCS3SEnHwnVnk8=;
 b=JnRgLnkvnCXLZNMv48cLA+6eRRGnCAK9xGMGrO/YMQBsyhsPp8VGZZQNy/2bPv8aBCsXdORISOzrn1t++7fM9CoLMaFkDXEIjhhTk3zTz5N2sC5/ntzdziDTyVgyPs4jHMFuuY1knSt4c2O63vwupaIfL/uuc1Plgll/Yo9ih3QUOylMDW285AXTqelgwmAwxcgLpce082Cq7Z8XaFwhGTRxjOgXEgvZL0yi8hLUgVp168S1fbNu7M/qHW+JR0fx8JLGoA6DQbtqdhYPOCtmb5oAmgIAjhgLv1ujIalWEAkFoqzYw9MzCwHJuGGyqb+tJsbbgFqIDrwJqdPlJeZ0iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d3+0EsCkTNx+0iboNdAP514SNdgF0xCS3SEnHwnVnk8=;
 b=3gcLqYw+SwPAfP8HPY+GGUhN7bARJ82tAD3gRUzpwkYBG/pe9dFSP+7CnTdGpG3m0LBuoKJ4wbDGpcypOqUR+BIc9Ekh2sSIlGwKrKkzvEikqNsGUcdAWDLlppT4r3+bQJ4zL5y/ySBpck938cwM+PxXmu/JmCMSB3Xpcwpochk=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YQXPR01MB6124.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01:29::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.10; Tue, 25 Jan
 2022 16:54:34 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8%2]) with mapi id 15.20.4888.020; Tue, 25 Jan 2022
 16:54:34 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, mail@david-bauer.net,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next v4 0/3] at803x fiber/SFP support
Date:   Tue, 25 Jan 2022 10:54:07 -0600
Message-Id: <20220125165410.252903-1-robert.hancock@calian.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0193.namprd03.prod.outlook.com
 (2603:10b6:303:b8::18) To YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:6a::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1fc7b451-5ec8-4980-f4d0-08d9e0235d62
X-MS-TrafficTypeDiagnostic: YQXPR01MB6124:EE_
X-Microsoft-Antispam-PRVS: <YQXPR01MB6124DACDE4691618B93F0E76EC5F9@YQXPR01MB6124.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 12l+EbmxfsRmiAHUPpQxb9Umv3YteWAp0XZLjfovXVsgohpMKLv/5R4HnfcrOYTNmSwOZOYMgG6QPdZR9zSB3phYKobpwLgi1l/H5XZ0M9885tY9kuRIpNZOgnpBztVFdKphfhClbuHN+mfRpNSRzpZygn/LzxQl6nCuM4qZ5q4O3S0NX3HmiIFpQnTFH6LHTZongIQ4GQtBE6b4gPMJ50fmSr4ya0TK7kH8TxX+BJvrf0F/QCw86xaeh7lwEnHcWgDFBGTroeDOlaFg7Y1oNBbyBsjmXiR0b8ViCYmgw/+DdhsuaLorkhK6b2UulZDDVpHxhA2SDHh4JKRSEhprdCcOah7vwAqc7mazKr+xPoKa3kvqWNB5h/3O3BqCw0n2m17TOoBeEOu4mmrGLgwAj7pFIOI95XeHJNi2RMFJtIIxX6bmdFLecxGO2UjrKqIPUXaQqFHQXr3ci2DX9E8Mfn07XWPJrnMyvlJ7P0JTe85KGZwS/TUTMUX8l17B5E+yzp8oO4BmvczD6qXaICr/8i4owXMSZUv2XFSsC5XWs2i5apTgeeBCir21rVVecMP+kwy8uTOMvl0qfDR+IoB5QQSNooa9OIIVqUN7DgkkvQGJPRibsXm+nNYnyKc8VAMSzPfxLd9jKtbk2xjPakOBLhYLUL/ckrVvd8WWkOmuGn1xcM/xJn+ImZKX2T1+805GGKKd/PBnPBOV3zSI5B5zxw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(26005)(107886003)(8676002)(86362001)(508600001)(6916009)(5660300002)(4744005)(44832011)(186003)(4326008)(52116002)(6506007)(2616005)(83380400001)(38350700002)(38100700002)(36756003)(6666004)(66946007)(6486002)(66476007)(1076003)(8936002)(66556008)(316002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FihNuLrlqgo+DAlDb40ZFydG2onlFxrMIjT2VqetBjrEbIAvDVWvcIlisjXC?=
 =?us-ascii?Q?i50h640actowoeTZE/7llyVUi+YWnelthsTE/IlsJmQUvuq26ED11lXn6HMI?=
 =?us-ascii?Q?+2SNUDMnMpJ4Di5KUOVUfTjum4YCmG1aYCmkCIbZintYSVnZ9MysjQN+a00g?=
 =?us-ascii?Q?lGhYdy/bXHgu1PAOBQbQ+PbSg29odVH+GxTyBz9/Gh6gyIrIw2Nn3tOiQni+?=
 =?us-ascii?Q?9vjybQRDH2HcWvrPIMemMSb2s+luiTS0jNajRHZD5RhzESol4B4kQLZhgv1+?=
 =?us-ascii?Q?BunWrdLgOeNXbZn2BQ95PPpusZB5Zk+V4ZQqXrGl2poVzIqfwXCi+j2B2NHR?=
 =?us-ascii?Q?81bbhAzv/00U0a35xJi/FPNNk0INOAn37OPYYj0BIQ6sbdjajT+2KpdD753T?=
 =?us-ascii?Q?rW/qbcxWNVpr+cu9qZVXPFvyhL3pxkfDAP1fzxEXQdS5Ju5+xfPMZVsX0+uO?=
 =?us-ascii?Q?6NHUn8gtnZD89BCbbSNDVViJQSU7hYGJB6/QuJAxGz0V8quq24kKxqjNyVgJ?=
 =?us-ascii?Q?1bv1pxB2Nh0+ARetJLCZZBjl5178Codb0SMEDB41LyFMacW0mnkN3qD/08VY?=
 =?us-ascii?Q?+/LaWhDcIL74E/qsHINLBnE57sL0pm5AxDzM9FZ9OUbr7MoYiSE1eo/jXHPZ?=
 =?us-ascii?Q?pdgYRVUaASeqMPY1i0BLbgIjfF1+9qr1P7gQ9o6Css0gZ6V2tHsayYfezS0F?=
 =?us-ascii?Q?o2jvm0yOs9eovRCA0QDViDYrQruQTsC6Q9iMmgTRx6xdisSx1VnN300N6E4H?=
 =?us-ascii?Q?QoN6Hqlz9CpaPKDCs0lBPkJ9A7L+qmgYtp3XIc+2QZD/49EVVeIO2frTbDT+?=
 =?us-ascii?Q?3sOQKcLmzYbi9jAlqg0t9XWlVJUvtS8Vf0skNMQ+ZOf0JnpsTdc0ixjmwtdI?=
 =?us-ascii?Q?6LexVBrE2QPTFr438sdcBMQjcm4OeuWuai9Bj6FsVKTCqQKS/40ajHrq6ps+?=
 =?us-ascii?Q?Y/cWsrEoIDVZWSX6WB8CWT7m40B3QK0juVP8AHJaRiigU0waEC/y/ubLsMT/?=
 =?us-ascii?Q?i3h/E3V2OTdfMbfI2SdT3wlqKm6aCRIU72vWWz+II8urDmJtXZOHEPKEWm2z?=
 =?us-ascii?Q?VpR7jTPHa0/F7o1Vl7bA8zqATVXfiu+9+Ivzv1CBhHE66iW2PR3myXCvh2sN?=
 =?us-ascii?Q?9DcLtj7+Rtg2We+GW3Mjj22jYiqOrll5garv4omC0VRDPicu4xdUjGWrjgmG?=
 =?us-ascii?Q?O4t1njAqDwYtMpDUWTTunR07tK0uM62gv6iK6W0H5TY4HHFAUIkL/HR0PQre?=
 =?us-ascii?Q?bBKWQ19ytIIJ/Iw7NlpcQqU/jFDYa8jlqpj6hSp+yHZQcPJmUg1ynpgxktIM?=
 =?us-ascii?Q?yUplXlsEoAxtRfLkBIcRLKpXbSb+aV9sJAR7An/GmpbByx1/FVKC85t4GJ2y?=
 =?us-ascii?Q?TIvtDoK36TACZWUComkRWVZtXHPDeseSa3BMk3GRx3qev1lpVFbyLRKuTRQd?=
 =?us-ascii?Q?bp2vIkujfmrNPmdsHFGubMlvvQUaYGm5ALIvkiDN90GcaqQ+CClfUOXhEE9U?=
 =?us-ascii?Q?oTcZOnKVaiw4VteosuKfbt7iG4W+xCCbRDBn+lYLmqwB3tOqJYiQaABXwAeY?=
 =?us-ascii?Q?9Lcc3PGs9q3BQDa08hcRP01OisP+TaTtRpPhx71JWhL8LuXGEEnQwfm0MG4G?=
 =?us-ascii?Q?zneLR8YbsrSNox2Ses3Hbz3ruviRsOLipyWg/tFV9r6ZBwEbU4nfJ+IMrE0x?=
 =?us-ascii?Q?/eQRvy9B4Vr4Axgp39fn3lXaK1Y=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fc7b451-5ec8-4980-f4d0-08d9e0235d62
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2022 16:54:34.7222
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CeDcYIc4v8MaqSUxVT3sx6fW91BJ932k4XKDs5w2z/LXtykxEMSpG4mEtlptmMb3nXNVjzV/oN8cQX5y8esNN1e/xvqRKKM/VWgk66GYCdA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YQXPR01MB6124
X-Proofpoint-ORIG-GUID: jOs92Kiap9l09gq-yrUiDEdvxTXpRTQS
X-Proofpoint-GUID: jOs92Kiap9l09gq-yrUiDEdvxTXpRTQS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-25_03,2022-01-25_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 clxscore=1015 spamscore=0 adultscore=0 malwarescore=0 mlxlogscore=613
 suspectscore=0 phishscore=0 impostorscore=0 priorityscore=1501
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201250106
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for 1000Base-X fiber modes to the at803x PHY driver, as
well as support for connecting a downstream SFP cage.

Changes since v3:
-Renamed some constants with OHM suffix for clarity

Changes since v2:
-fixed tabs/spaces issue in one patch

Changes since v1:
-moved page selection to config_init so it is handled properly
after suspend/resume
-added explicit check for empty sfp_support bitmask

Robert Hancock (3):
  net: phy: at803x: move page selection fix to config_init
  net: phy: at803x: add fiber support
  net: phy: at803x: Support downstream SFP cage

 drivers/net/phy/at803x.c | 146 +++++++++++++++++++++++++++++++++------
 1 file changed, 126 insertions(+), 20 deletions(-)

-- 
2.31.1

