Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92B3B488DE7
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 02:06:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbiAJBGf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 20:06:35 -0500
Received: from mail-mw2nam12on2111.outbound.protection.outlook.com ([40.107.244.111]:13017
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229571AbiAJBGe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 9 Jan 2022 20:06:34 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W56z1ysuczLywuT5yGd90nDRg/H3Tvggv9bxrh9DHiBqNmpoyEGEtjyxlzKoyuhnaagv/stk7CoOyw9ET5Go90hV4TYMp26o6t9PHvSOYU/pZia80IFdvJQB7vVvDDcJ/9478Jvq6laaLqk4RgNbOa9P28P6cclMoCdLjgG3bm1+eINtbKh4C9DrIv1NydY9qozQ5twLp7X2+0sgun031gvY3KJyu5ryIAliFclOMDsrKq+ccP4A2GO0vVlMV/m+H9MLE2USrMGGU21zv0t19nUr/TGEllTq1ZdKYvmhlsuz4Ymm8QnU2QUcpDEw0axkuV6Bk1T25ScR3IMGF+pPCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ARssdXaCwjOnz4bbBeISOqM2dw8dkjfb8SKF5mWKFng=;
 b=odGPFqbPgSvxc1EpIU+LtZByl4w+XPc8HydGnWJWR7mZbdYV0P1zYyJ1AlYUxlXUPXrud9alEzenqF/iNGU20OjrjQAyP704nMi4TuU+/IwgNIW1N3YLelN/xSZamwPuydI67JTC8ekNvMDbW2uF4lxtNBA/IQxC+qrd5QCNjwxm192Bz1gVkHpMkTQ/v9KTwFAt03+Ty/05hZahKxbF6+7Bsegig/6kia97/xwmFz/MH+JiTNmpSuLOXECn7h94DCa2qw2CSKlo2IawRwwn3PuHlezvlxNnKxiG2kz2QVvlew9nq35zVc208H06LWNAoF0fdnA2OWENM2rmcaLWDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ARssdXaCwjOnz4bbBeISOqM2dw8dkjfb8SKF5mWKFng=;
 b=ymuJw2uQV/ye648VszayZtaDp048A3g7NPEsAzNxy5gF0q5IXJsuUZc4dp2TLoFZAS9c7ONkt4pS2LMcfmuTgYj/ZIBkV88XsNclMDmquP31WpM/TAnG0JFUdPlEapS3nAI7sZgbEr6ubsSEuZ9tDPdNg4mXdAAOXzRahrzIrsA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MW4PR10MB5810.namprd10.prod.outlook.com
 (2603:10b6:303:186::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.16; Mon, 10 Jan
 2022 01:06:31 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f%4]) with mapi id 15.20.4867.011; Mon, 10 Jan 2022
 01:06:31 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH v1 net-next 0/2] use bulk reads for ocelot statistics
Date:   Sun,  9 Jan 2022 17:06:16 -0800
Message-Id: <20220110010618.428927-1-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4P223CA0027.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:303:80::32) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 07bf75e5-9c2c-41be-9b5a-08d9d3d5700c
X-MS-TrafficTypeDiagnostic: MW4PR10MB5810:EE_
X-Microsoft-Antispam-PRVS: <MW4PR10MB58109DC952E3E5643FB8743DA4509@MW4PR10MB5810.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0/D6X7ay4jh0To8QAhor23O1UMs6szGZDOJw6mWrqYrIHausuHI5vfu7M0vmbfOaxNd4rCPrmqnjRMDie8hF7VavmTEJxbndQrpm73v8iQn9UZTbE5VNpWMpvipq3k6BvBSKi4xhQVwOMRPrsV0WewZh3UMVgSJkgCzLnRk+XnpWZqUW1Cm/iCFbE5juMmy6kwz5rF5E7++i1exdnlF0HwQmVBQ9HmaItg3t/NkMdsvRT1/7C+IJXMjzTgnLa+jKMp5mt5DzGRntu0MMyY9UVANXhxfOQMKjYzVu8mnxA7SMHxCh/J4hYJUNfL9rdhNBscuqJmr+fVrNKQ6J7Ii1Z43SUbrLyPdG0Yb8l4pqepmYp7l4merIya8VlU/oSCXkxPdQjpwvhc5q381x8uR8lIRb2TkoaNAkcDYoIwjcUddptYZIwjyJ//dOvS+tibsvrngLejdu+FYw7k1oO7MSA4OnjskOscOxPZJengkzp1j8vFpUpU8YRKKLdg57H/Nps2L07A63Sa2qihhM2jxooREBVUuXGM/+TOKvKJb+QzDqg7CBE9aLEcgCAtfpskMs7Vp0u78TO+eYFMmQwVk3qntHx3q0h35mYACbiuBLf9UDEMDDDoET3wQZhjf6N/9UYlBWl+rfc2zuKkCIhsBX855RrqApzFElNcjG8H/7Brsb28CFx1DIH5Sgcw/okWOEcE7MDWfhhvchGjIwyE6OfA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(136003)(396003)(39830400003)(42606007)(376002)(83380400001)(52116002)(54906003)(8936002)(6506007)(5660300002)(316002)(2616005)(6486002)(66476007)(6666004)(44832011)(2906002)(508600001)(26005)(4326008)(66556008)(4744005)(66946007)(1076003)(186003)(38350700002)(86362001)(6512007)(38100700002)(8676002)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3cgWppXfckMZGLJte7oydP5TvKWugVZO5o5TUyxlAJsAdan4kWMeOFfAU2Te?=
 =?us-ascii?Q?MAnQDtu53LnWCbP8qGiVsmISKzChDnPeVFDq82oGp6bblQsLIjDFSbgQg+op?=
 =?us-ascii?Q?dqxdyzjXTQIEI5mPbiCj/lEscI9OPda7e5VcTIkN4bQeijbSV9GNbN4854Y4?=
 =?us-ascii?Q?Um7mdAe++tgasxrG6HXvjPh3xYetLmSaJeoClPXbsXfgEHbad5Na5784me0U?=
 =?us-ascii?Q?71w8KC8nMG8lzOZIT1OHU+cTjHBisAPyzOb73tQfQ7RJ+rz+paXrz+XwiIJV?=
 =?us-ascii?Q?w79uGzuW+aD88h3nFXePiPXf6itDHEB6GowPu3VHW5rl2tg/c7ahIEiE6POU?=
 =?us-ascii?Q?XyPQf1qQBTrvrHBNx/3zLiUnl8sBWUlDLn9cMyqC9K9Eyn2Obu69Vio4EgYt?=
 =?us-ascii?Q?oReRUorE5pJo8EBehw7ZRpiWL3tKHQo0RxJl1vmGePvqIZ+SlnZV6sePc0nz?=
 =?us-ascii?Q?DhGQhxYB0wSwmfezl/F0JSdv1rGUs75KUHpp+b4TBdstOjHz0BvoX2L9HyYH?=
 =?us-ascii?Q?Y8hwPWixEAjFNoa52QOdSLTbj7RlRjPQS7GAds/WTiui6jyCMdvritD6Vfq3?=
 =?us-ascii?Q?S+ANPl+WzS9DKAG+bY+dfMP+ScE/+8TPtAS9IkGu+k8ar3NYm28cKbR87ThP?=
 =?us-ascii?Q?mS/JBnPQKkSI3GaouOQG8U7ip3VJ0MOlQDQCE8VIgqXEuy+Oka3Xwo6UDw3a?=
 =?us-ascii?Q?mLnq7tzbJBbaa/ehFlWWAkywttJ3Qa112ZFIf/y61cKe92FRYXgIRSLiLV3y?=
 =?us-ascii?Q?3PukxyhSgjfE2+Pb72wDxJCQ5RKS/WXZ2qGJWMExTCYWpejdXLTq1uu/OU6S?=
 =?us-ascii?Q?PjKdyWLjEuP8h0CO8R4syCouSS4wjav0B14iezgDicwtpJ5DmPu7iXnjSTbk?=
 =?us-ascii?Q?TVCPXhl0sRk6MJ3pd9kiqNM2i9rukX0Df64A3tdZZOXiGHr8S8/K7UUB05/K?=
 =?us-ascii?Q?TbFWYXiJ1y1TTCxPaE7uzLAktLuQHXY0jDih4WFslYrbdC260cmLhYjlCnbd?=
 =?us-ascii?Q?ifpXzKdfJid5lD8Y44ndKCihirTNfp6g6egkLGeIii2PJ9h+9s7gmI8g0tna?=
 =?us-ascii?Q?nHnrQB06PdhO3FfHH71sPtqwaafrrSsEliScX90i1Xc6YlUho3fKBG7v4j0V?=
 =?us-ascii?Q?WQk4i3HO65/si+Y8+iHT5iuFK2JIpRqIS1Bq9yzofNYKi6KkXyayy2nOVLm/?=
 =?us-ascii?Q?uvbka+8nYC4X68MH1z7hKrKFwHZPYix95IB/YrWVY3Ohnadmmtu92ZeSqCfO?=
 =?us-ascii?Q?aAXbqpGcRM1A+wbJuNW9h/3ZOjPS0CWz+oeS3eGpIC/1X0ium/58i4trgr6w?=
 =?us-ascii?Q?JrPcE2YW1AhMk6w5Kyvigj5wHB2RPj2LURs2cMspKu56zE4wH/qJ0+5gXafB?=
 =?us-ascii?Q?ezt4Cto3h7Z81vUnRzxuZS7HGw18YyR9O/G2pRuw6C4GqbcKSx7QiD2XvEmy?=
 =?us-ascii?Q?/9FQmnLqAs4A3MLS1uxS+Etb7jYJQCwQx7CCtxeA4IDbsqHTSBceIbA+Gyrx?=
 =?us-ascii?Q?6eeRmKI5rxMUoR0h9RlpkfYSaeLZguk2j4s/DAziNbQ8/eaE+9rL/0SuCRtz?=
 =?us-ascii?Q?2rd2QbUkwNThfBxtqoxDLOzcH7BlvvPVnkTUM8YbrQeun2wnxNMRysronlqz?=
 =?us-ascii?Q?K80U6S6p5qh9WylvjFtvJ9VtaL2we6JgVwgXgz1rSVB4zjK33kMJaAlkLcBe?=
 =?us-ascii?Q?s3Q6SA=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07bf75e5-9c2c-41be-9b5a-08d9d3d5700c
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2022 01:06:31.3348
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8yoCbHToH/fT4L44mR/RkX+xgSDc2Kha+AKlnqkKhT2h7gQ93IB8p4G8/0WlAbjUNzC9jltktYTRN6Szm6dwxP1hcgI51Kjl9Fm5dgxaXwc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5810
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ocelot loops over memory regions to gather stats on different ports.
These regions are mostly continuous, and are ordered. This patch set
uses that information to break the stats reads into regions that can get
read in bulk.

The motiviation is for general cleanup, but also for SPI. Performing two
back-to-back reads on a SPI bus require toggling the CS line, holding,
re-toggling the CS line, sending 3 address bytes, sending N padding
bytes, then actually performing the read. Bulk reads could reduce almost
all of that overhead, but require that the reads are performed via
regmap_bulk_read.

Colin Foster (2):
  net: mscc: ocelot: add ability to perform bulk reads
  net: mscc: ocelot: use bulk reads for stats

 drivers/net/ethernet/mscc/ocelot.c    | 76 ++++++++++++++++++++++-----
 drivers/net/ethernet/mscc/ocelot_io.c | 13 +++++
 include/soc/mscc/ocelot.h             | 12 +++++
 3 files changed, 88 insertions(+), 13 deletions(-)

-- 
2.25.1

