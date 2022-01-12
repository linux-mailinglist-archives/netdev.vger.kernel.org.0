Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DE5F48C9E8
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 18:39:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240910AbiALRiY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 12:38:24 -0500
Received: from mx0d-0054df01.pphosted.com ([67.231.150.19]:52666 "EHLO
        mx0d-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240441AbiALRiU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 12:38:20 -0500
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20CGT6xX010893;
        Wed, 12 Jan 2022 12:37:55 -0500
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2050.outbound.protection.outlook.com [104.47.61.50])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3dj2j2g1at-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Jan 2022 12:37:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T19R4hfnrcUS4SC/RTDc1HRLLqEKXY8DpcSPN2zwGivtROT2TEwgbxM+puXZDbl7v/2KnkatHsXXhGe+lCHoCBN6Pl/k+YaOv3oPI6YRNYQfHQguFeIoTIX7lVgnENLBJBijVWbhlbjyLAaEq17EbpBDGCjV3EV4Uk/XLgpEcXTwGCIuFSt+2ajJ7OJk8EBuISDO859r0JucfTR6N/3ehP8zOudUYSGd225kuBgNeWIKogK4DyDdwBAzXtNqPyGIT5XmqjCLgdMEJqlViwM/aPQL1wJTgt5zBmrlnKEDUR1UW2NPkvecpLwwVIxOL2RNCAq55u7IjIkD5WIT4ZtkTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S/ZIYLlPx8+KrZzqkOVzwEJUKDWTgmOWEpHuWQE+wCY=;
 b=ZHTOtKBOm/M8DN6N9ILsiNgYopTuSh8ECBLxOgI6EGbOvLuXOaGV49WlsgFLGm7VpxF3hWPZNx4/VOPPdOY5Snlf2M+FdhEX2poVnytRZBRnfe/wKuEKrFUXvm7phSpfkdXaOGJ4ip/x3ozk5Kd7CVqoc/C91gK0WpjZStDhK3USZnVn84t5qn6fuSftvGbNRzas1qvP8aSKaNqXx/Cfvei0Z7J9ugqCvkAJy/fIi4gRBYYlnKz27Xf7nqfvlbrOtQy0xV0kwIAuCtvuI+LeCrPhrRpd/ctN1x3tq1c484qc8e0g+4jWDnHeuzrnYbajO9PTkNwhb8oSZbzoBfo6dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S/ZIYLlPx8+KrZzqkOVzwEJUKDWTgmOWEpHuWQE+wCY=;
 b=cYQQ8QQt/FoWGY5piCbAiE8X2AdsXp4Dc5UQl/LmhhuaUjQbmGx44t0W/NZH0TYPtWOSrVzqJQP2D+/aPf/JymgJvzmbK216BPOY+r9qoFr1vNvWFcevinvqfeWSeQyK+mqiIT6bksUvM77KkpYWiO10JgK73wKa75MUcB/yCrc=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YT2PR01MB5789.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:55::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.10; Wed, 12 Jan
 2022 17:37:53 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8%2]) with mapi id 15.20.4888.010; Wed, 12 Jan 2022
 17:37:53 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     radhey.shyam.pandey@xilinx.com, davem@davemloft.net,
        kuba@kernel.org, linux-arm-kernel@lists.infradead.org,
        michal.simek@xilinx.com, ariane.keller@tik.ee.ethz.ch,
        daniel@iogearbox.net, Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net v2 0/9] Xilinx axienet fixes
Date:   Wed, 12 Jan 2022 11:36:51 -0600
Message-Id: <20220112173700.873002-1-robert.hancock@calian.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CO2PR05CA0061.namprd05.prod.outlook.com
 (2603:10b6:102:2::29) To YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:6a::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7f4ca6bd-0af4-4476-920a-08d9d5f24276
X-MS-TrafficTypeDiagnostic: YT2PR01MB5789:EE_
X-Microsoft-Antispam-PRVS: <YT2PR01MB57891F5D8D1B25BD2FCF05A3EC529@YT2PR01MB5789.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:513;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GaF7xt4O4Hlqb+mXeuPYFRXTLNWz4AgZgZ6Cy+44K6sMurL9WauGA70F+y9Xzq7onmz72yYhvOzCpPWh11QiRZxoC0SyJ8mlNgtaghycUdD3seqJOqKB1eXf+uxR3Z8Mkv5UHPJn56Tj5jPKCpIJ7BnuCuyOFjnfPsQdqtySluTAKEneIomnjLNW5wrcDrPW+L1R5JtFK7aWK5oB8YQnlnf+0p7oBSl8f7qe2uv0ReBIwKk9uqFS8Tu35BAXg3lBe23VA7EzJZYglJ583HsY8uDVBdmhFcHEOgLBQIVevdOuP0EURPanILxWKqTr4IbqIcsFgFBj2Pdf0e3wQusiusz+NruH6UX7AqO8UQeJsYDk26gQBdzdho7jCcpQSJV5dtGLlzGFa20XHI5mh2Iyg4H6w3eOrv/ICaU3s5GicP3CDOdm+8/1fQvB86YH+5KURr+yjST72oNVnsPN262x6XShS6ANHS3uWYScHi4GCAXnlS8l+KEgw+PMZrRVVSkf44cgdZrwyyElHOondrgPlZZcwnNI2QxZ8aJBDp7FLW0b90IWuYarC49Szcj0ytuemJHKarBJa/Klm4T9uuSsX489p2vASS2ec3i9P6bPtGKt+pTMFhJCiT0+0UxLlecDXrjuKWPaOFk93hYFEbFXqlKw+Y3jqvem1v0ZkDidMsKhixOZ7CVvov0s3BiRscNZ8tEGPyWT6DGQwMQapRzQAQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(38100700002)(66556008)(66476007)(5660300002)(38350700002)(44832011)(86362001)(316002)(83380400001)(36756003)(2906002)(2616005)(6506007)(8676002)(186003)(6512007)(1076003)(4744005)(6916009)(4326008)(508600001)(107886003)(8936002)(52116002)(26005)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ETCaJmpnSRqfti8zZe5BBjrWXKu1uXlrnFCV7bgyvFxFGaTNtuXzr+agycBz?=
 =?us-ascii?Q?T8Wiyz7m/i2Sp+Wnt+WdLSgJ6VZw0xOSce32PuSfmio3w0LQTfM6dSsA2eMV?=
 =?us-ascii?Q?2GiNw108+onNTLWXey7q57WlyDY3Rd3d0nWdbdp5abramCA3QpSTonA4znb5?=
 =?us-ascii?Q?LbrTzyrLVdw38/y6/r3UfOkjN8mcFXIOWz0Texij9GBQTyY6dI1pejZoR7ce?=
 =?us-ascii?Q?RAHdJVHqQ7RZfokCKka/31BVln7t+GzqjQAj5eO6cGj374WKLVMqA1Fo92Ni?=
 =?us-ascii?Q?gaC5cggG0szFWyWnwcC16uxS/MnuKzOMUWpORazx0taepXnXiPqLWJy8hEkS?=
 =?us-ascii?Q?g6RGsFhBcZ/cCjOjael6/IhUrZ6JabPZZe9C9sSKM5jf63YWRaNro2bgDWaG?=
 =?us-ascii?Q?w5Cfomy1WPEkoy4o8wv0NvPdphUlmbWF5KYpGRVe0ql021PgdwqLJFhJrQOL?=
 =?us-ascii?Q?ZFAhgSdhoN/mrAy/xLxpMNIUr8+WQfK4VJKZvNtCM5eotBejaAVpby8w+b1D?=
 =?us-ascii?Q?uMpMNssLsTP5yxePcEk+Q1i467+tPbP+F6wmn17HiStQ0VodzQ11O+6DbLcp?=
 =?us-ascii?Q?WOYwpySVp+mX6QSIrOw/wDYirvO1wSM1uKX27Dlr33HcuGLDFxpPlT8tYjXQ?=
 =?us-ascii?Q?VaPXrXexN4XqqGppwocTWyysJOevE3q0qbM9kzd50nZ0EWCLLx48HZy6b8Kd?=
 =?us-ascii?Q?xsIYstc3uJGcZo9LRjnsrYeTPGCcXxLgYcEJPxnV+QA1qcmm82yF6UTtaR66?=
 =?us-ascii?Q?dhMS1xmd5sj7fuHaSUXKM0cl3588g9K2DODvQH3uHqCDQavFXceLR3eBuVdr?=
 =?us-ascii?Q?X9eMTIgKJHIUE6Ufl3pqngQOHnWfmOGyZ5s7N8VHOaJDtHsHMpwRMf/iT3bm?=
 =?us-ascii?Q?R0sZOwkFqkWanZQ5nMkM2XkkxnrWtYaPGHdszhgrJmydzQgs+OkR716Kzl5Z?=
 =?us-ascii?Q?lGkQKoEX506W1OkIHOxwTKo1ivXrnpCTgpFwelc4+ek0R4hJdmOsshW/lPqR?=
 =?us-ascii?Q?LyEbl1AvMY4aYxlwd67k4MKFXVtBu8gHwrnUfRqKpkrUzonyD/y7HW+ISK13?=
 =?us-ascii?Q?JF74morG7E8fv5AcFj44RBzg8bDOu3FwF2PDF32MdYgyZrzwjTEWbgPx7SXK?=
 =?us-ascii?Q?0MkeLlqflb6+DR28uqj/WeO46pQmfPdzZ6dZb/+N8XLcEJM4ctzy0H4hiSg0?=
 =?us-ascii?Q?Zf2UKCQFcNMWB834bXvP4aQ4hfgmY5/Nlvu6SNyqljGhuDHSz4p4dldJcpNn?=
 =?us-ascii?Q?Hrb+WZuXMP4bRygm+Rz7aGlWHKli+Ntle5/Aege4shti6c9QjMtQq1rBpYkq?=
 =?us-ascii?Q?QRqGQ2s+YpF4qBRf3wFqoFDWam+dPT/VzXbNe06McFOBeyX92vXV9PbLiv96?=
 =?us-ascii?Q?/ahF+sxI2kM4rq00oEAl9rfmUhoQGhrSVZy3kinQ3W3IDM0PqMBs+BWkeSgH?=
 =?us-ascii?Q?txQOUV5UbUG/0c4P/zJ5U1E0OMCyckV7fr/HM1QtTd+K4SQAW3KiCYCdqsZD?=
 =?us-ascii?Q?NZ6enHek0Io5jNsyC5XcZBAyR6+IRubxV1tsGLr1/ypxZDEWSZUNPqMYFaey?=
 =?us-ascii?Q?WOhU/D0v3Z11ckFH+Uh043LGTYpOTK4W2BXRXenC2Lg3yebPs4zbxGZTOSdB?=
 =?us-ascii?Q?MA2Zhq6fF/OGvyNOCxyIPIaWTt4RzBUQlIyyMC/ULiBan2/RKl0bwNZ/AUKi?=
 =?us-ascii?Q?b9qzbArp5ODwWdI0MHSpfkKemJE=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f4ca6bd-0af4-4476-920a-08d9d5f24276
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2022 17:37:52.5691
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9eJBHQge8yAprc0FnBCianzgck4/V93ew+aZG83OZcnTVvRS8CqcfEUBskx76Qx42nUTtHllJ2YDBeUjoyhvCZaplHfD434ADbLFA6Coqyw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT2PR01MB5789
X-Proofpoint-GUID: 84LbLKguGc0NRiwW-F5eJJvJrgBYs0iT
X-Proofpoint-ORIG-GUID: 84LbLKguGc0NRiwW-F5eJJvJrgBYs0iT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-12_05,2022-01-11_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 malwarescore=0 bulkscore=0 priorityscore=1501 mlxlogscore=904
 lowpriorityscore=0 spamscore=0 phishscore=0 adultscore=0 suspectscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201120107
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Various fixes for the Xilinx AXI Ethernet driver.

Changed since v1:
-corrected a Fixes tag to point to mainline commit
-split up reset changes into 3 patches
-added ratelimit on netdev_warn in TX busy case

Robert Hancock (9):
  net: axienet: increase reset timeout
  net: axienet: Wait for PhyRstCmplt after core reset
  net: axienet: reset core on initialization prior to MDIO access
  net: axienet: add missing memory barriers
  net: axienet: limit minimum TX ring size
  net: axienet: Fix TX ring slot available check
  net: axienet: fix number of TX ring slots for available check
  net: axienet: fix for TX busy handling
  net: axienet: increase default TX ring size to 128

 .../net/ethernet/xilinx/xilinx_axienet_main.c | 135 +++++++++++-------
 1 file changed, 84 insertions(+), 51 deletions(-)

-- 
2.31.1

