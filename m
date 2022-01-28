Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3344F4A015E
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 21:06:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344406AbiA1UGE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 15:06:04 -0500
Received: from mail-dm6nam12on2138.outbound.protection.outlook.com ([40.107.243.138]:24992
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234277AbiA1UGD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jan 2022 15:06:03 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fktAqssuPmKyMVUz65r6XxsSV2tglx3ofeqp8IlzF8tJZMxKaPD1UHI+xCgZTrGPi1pAlGg+pUT5Z+meCtYrVamqgIL6rqlPfhv7LQzjGsceUJzG2TU/88gYKTC/kYcTAZe7lseg2q8epJAnZhVOIKqRYnG0W9se96qElKdqwn0SWdIc0GsrZjeKHvl98KstSZWwYCJJNJIxNJMPDxntoPwDVvTekANtTGH1Kh29atn1UPLjq4rzUWYoR6TazBhZuu19yjpoVj++6bwIUs1nd6962bTK7+FhWyD23B97fkG6dc9FLcPnPrIqVazfmTSEwSjO4pIRrmR/r8fvTeB5PQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cK/1LA6KEtx1ERaM6rz8b3aJv6RvJWyas2Vmh/LMWRA=;
 b=LBB2arjz6GUWaF1/fDVqv9+Nagtw6yKS+HuE7iNm561NTDkBukkf8/dEyA9kpUMNodCYABdw202uFZZJbgZe4vejLDKnrds9nt1mRuTPRfSeze3iPCbwxKfupri9usQ0DS3kIvbaPCmb1MwbayGT6+uH2CmCFiMIxsVMqdXWhp7iWM+OLRgYKJfZewn+lIplQ1KEC7Y5ldfnHANhXbQ65JK2T68jOPmvRerLJo2qDMwcxncLJdlrHn+zB6tMSAkX4lDDgeaWmz7Bzwr+sR0nC0Soxb4YxRLuiBmLZ7jwRcDIu4LUkQpDhPL5+kNaUtHAyjIyg6bDu+qNYgu7oJsloQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cK/1LA6KEtx1ERaM6rz8b3aJv6RvJWyas2Vmh/LMWRA=;
 b=u6b+2W/hpGKHSZukH+d4Rz7QNtlyZhz1rsQozUAGmAXrOPElf/buoM6Ey2xdGFy9/c70BPJpQQ4erF3zEcaZvn5GeF8cjjlXbNo4po/VYD9CwzSP1izXiq2nM6ii8dsYrpZjqA4OAoihLRdMbUbGXATiB7POrpADlo2GVGDflCA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CH0PR10MB4969.namprd10.prod.outlook.com
 (2603:10b6:610:c8::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Fri, 28 Jan
 2022 20:06:02 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f%4]) with mapi id 15.20.4909.017; Fri, 28 Jan 2022
 20:06:02 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v4 net-next 0/2] use bulk reads for ocelot statistics
Date:   Fri, 28 Jan 2022 12:05:47 -0800
Message-Id: <20220128200549.1634446-1-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0152.namprd03.prod.outlook.com
 (2603:10b6:303:8d::7) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4e190373-36dd-4563-7a7b-08d9e2999b7e
X-MS-TrafficTypeDiagnostic: CH0PR10MB4969:EE_
X-Microsoft-Antispam-PRVS: <CH0PR10MB49695F83BAA45FCB0171F785A4229@CH0PR10MB4969.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1468;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9NO54B7ouH0+pOK9WVNDcwpsW5T5vnnNCn7amW72hADRgNl3evr0y8+27tPrYEDri8ckHt+ufEy4oG92qQzWJrmWWjpDSKk9qHmkb7W8FNCmT/a5Yg+0yIh1wqDW6v6Hqh0aAG8D/HOs8xFo2DZcAj6RgnR/yY2OKH3uF37GPTHw0bohak3mQHd4xQolJvfm8ofw1L+GzyVKJeji0AQv9hGGAMG0Kora2D0TxW3W9Lk2/07ix3FEBy3vgeGKWLCV5IYOtrFQrPxL33T5I+Mz8DedewUb0iF9jEDzQWBmApplNTsL3BJp9hk21x9aYQ75W8/49QLEpaBix1jltKCx/2JCEYOIpRVNV4dYAC3oGjf6PntjKjOXY/EgmyedJTe20QBnBxrsMIjNWBiB/8iQgjogtPvjsUu1m1cyg4pEpv/pqy05Bg/iDK6vGdIVv1vF5tr9mJvej6meFF9nNmsYkvUpHp/Tww2OVg578assSz8A1VIYBUzxsIxRLYboDiQ3xiaosy2vCMiqVWA9bzq+Sbns+xzpcrGNFzDhJbygWtZ1K+b2pjO4zxUjkUXePBH3moiY2NTG4rHuvj2EQZdWE3YUqN3F+w0dmlt34KFBJKWfpbbnsbblkSMzSmLhc3lhMd8VS5AbA8JYHd5J0I24MR3BbIo5u9Wb8s7OCRw1lpug6ekuM0RAa5hPtmpcdkK45+vv8gTEA2GXRlLwXf1qOA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(39830400003)(396003)(376002)(136003)(42606007)(346002)(366004)(83380400001)(2616005)(66556008)(66946007)(66476007)(36756003)(6506007)(6512007)(8676002)(6666004)(4326008)(8936002)(52116002)(38100700002)(38350700002)(26005)(44832011)(54906003)(5660300002)(316002)(508600001)(86362001)(6486002)(2906002)(186003)(1076003)(20210929001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hWKFx4s4s7eS1rPOXb5Zd/e5lfWtgzzH9i8iwIC4EvAO4UGksGLQksxvV9+O?=
 =?us-ascii?Q?zQhB7IwCebnYGN3l2q7BoiT2GtmP/N6to2mUYVu6VP6IxjHg1Dr7jCmcoaGJ?=
 =?us-ascii?Q?XuuWWu2+IFUA2/AlTrr8s+GrVXeguk+XdVOVVu1w3c/gLbN0NfgHh4twRXL1?=
 =?us-ascii?Q?3sQBsHIsC21uibH1V6Qj7BeYXJSt6MSUj15C324/QBc3aIRo777nsh6egjjE?=
 =?us-ascii?Q?9t44a6mT76nNqLUtYOWjDPgBPEkP1RlkuMarLc9q9DhQGwu9zoTgXSF0yi03?=
 =?us-ascii?Q?ccbCUlvJNoLwBq/AV3mQKgA1BXvyz4VYwMTx4x4ugrqspamuH5dHyTFyqE/e?=
 =?us-ascii?Q?gZVcDDmxgE+x5oWJ5v/worb6XMqsKsLrLz3C0va8nEk/XJtMMIt+eIIgh64B?=
 =?us-ascii?Q?Rtcu9tkfDH207c/NjdVRr5x6TB/XXYr5Dne9GxJNpmo+bB1y3dMJjHE7fsIn?=
 =?us-ascii?Q?8GeZ54SOzQB57kL0e2toqzVVIAl9l8RmcfJ2d79M2ojtTUGEIjXsM3fs8V1c?=
 =?us-ascii?Q?GEG4vZF+L0FyQSkIPnx8MnqHSWqEp07dwrbXwg8YuwaCAR2wyX9gtjNqPwgF?=
 =?us-ascii?Q?cffFzakyCWyGN4oUSBhILbaLHISPnfhgcV6F/fG+y9urjPjFKEyI3+hyF6Nw?=
 =?us-ascii?Q?zYqv2oTaN4/fi+33sFr31SgZTb6/0JIwbhAO1cZrVNGpuix48g/Czv7YbWax?=
 =?us-ascii?Q?nvF0vakR8BTGzxwsltTZOCsC2FzdsfRNEYhQ7YXSzHODmXr3Bw7qSaSORR95?=
 =?us-ascii?Q?UJGqP1TdQ3YFFTzGZ51A9wl9RpntazyZ3Q3fKveASA3WfZi0fsmlvNlQmJBd?=
 =?us-ascii?Q?PwhjKuIGMDEpel2JR4LFr40GHYQMurVVDvcxGXWSKu9yZhu+FdWJ/O0F5z0R?=
 =?us-ascii?Q?+KIfqbZVv0EidQtbcKed0QW87Ko9Fri1CpamRWdG97BRxMMWSGBMqv3aI4KT?=
 =?us-ascii?Q?/QbVqclDFLMFuixcmWGMYKKhejx9eN6dgS2x2ftQ+u9BLsCC8qv4ENlyZVIE?=
 =?us-ascii?Q?bvdTo/qeDPWK21YssBN8LprZO0R3YhowveRjRuUvhusT2q/x+aScJ9Q9wi47?=
 =?us-ascii?Q?PsU2N+HySlMp2mn0F2O5vzFsePGl6zlI838tYO1ylZFeSYtnwngLaDr5guD5?=
 =?us-ascii?Q?GziQZQgDDysixSVcaWlltHSGPl1zDFGNjdzZXqjGeLVgISjX9YBcGQPBNqvd?=
 =?us-ascii?Q?mTD/gXam5j8vGexbw537PMit3YrIaPzMpoZfeU9JuXDih6EcJy4U0NJoRmCe?=
 =?us-ascii?Q?+qscBn2qi9gXsW6Gg+KRBGSAE9Zyb+XiBz4Vp0RmD/6XD2Ofq3xBNuFyCYOn?=
 =?us-ascii?Q?h5cVrXwocmahjNyOEVfw4pb1KtPswgV3F+cCd6wRjinATJip1e6um1BlfGjY?=
 =?us-ascii?Q?YLljDHDTLRdDa38T7IBIrgcSBsO4N30GIyHZPHS2i7Ho4kfkW7Par9B3hBqv?=
 =?us-ascii?Q?6NQ1TVsqbAMcXsFJYAdGwhLWs6MDAXvkSd/JtXJT3Us753CDogUJvFgc2bwM?=
 =?us-ascii?Q?MyM+rHxrEqeAo/HguOVJAjfSVhRbsz3Ej/sLUYgBVs8/lC9F8wdho03f+Gbg?=
 =?us-ascii?Q?5vMToD4tEB0AWfmsWDoU5BEZnayx0IAyPBxQj1kL0tOAFUEUmKdlrKlpLk1M?=
 =?us-ascii?Q?46ai39CVvtWB8ooi7X+ATEfWHSVTTWgNGVvgXhOMtSW/fdCnkCXkWnIWvCpE?=
 =?us-ascii?Q?5PtQjA=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e190373-36dd-4563-7a7b-08d9e2999b7e
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2022 20:06:01.9391
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8XWMqUKcMIezHAlG4K7i1chaEhBkYHw0xT4IXfQJrJtzVWQKXWg6AfesOE13vgQYhJL2HVizAjsESi2bz7jad/LpLaUbo4Xo/UmTUwbaviM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4969
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

v1 > v2: reword commit messages
v2 > v3: correctly mark this for net-next when sending
v3 > v4: calloc array instead of zalloc per review

Colin Foster (2):
  net: mscc: ocelot: add ability to perform bulk reads
  net: mscc: ocelot: use bulk reads for stats

 drivers/net/ethernet/mscc/ocelot.c    | 74 ++++++++++++++++++++++-----
 drivers/net/ethernet/mscc/ocelot_io.c | 13 +++++
 include/soc/mscc/ocelot.h             | 12 +++++
 3 files changed, 86 insertions(+), 13 deletions(-)

-- 
2.25.1

