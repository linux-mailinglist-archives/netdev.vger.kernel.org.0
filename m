Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E10C836D758
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 14:30:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236884AbhD1MbT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 08:31:19 -0400
Received: from mail-eopbgr70044.outbound.protection.outlook.com ([40.107.7.44]:28549
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232569AbhD1MbS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Apr 2021 08:31:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lo0cQN4nqtgUXiqW0AkQcrVWe4PI99iDRAbm0exOSp/Zd3rPfUgFNLOyH28jvBSsuxW4SAzflJP473xwVtrsqctRjYHINmztByXFqnx+rmPZAMiYH76rDEhGcjGWnCCTT7CSCEDfDdbOln3k4WlOEYd7Zq5bHu1RlsdC0JTLuiZRLfgsKuCkTDWfLCW9vHAHoBiTGk4HCBmduYharyRugOQI2tj+wt4XHdQOik4RYhBmJxf46L5cBnF09NiTxCebP57SGLoP0YsKIMNQD5PHV1eNHIuNHKibTPkmeA4y5cTA9d6J92xO5Clj7jQssQHLraxv+KeC5Gl5uDXbgu/olg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mj01yvVJSfvazpK9F0K5qJudaljHpE5urOqfFUMb16w=;
 b=dvYzBTgLW6FbN34jB2nRcYeevbdR4nv/D+wygvLEBvyM0NN7s7yys1K/7lkYLniySedjEmeZ357FpIZPVODwrOxeZzHMfrxZmyqHbf1W8FR148o952g8O0eBydj4g8uKq+sta/j1KvlI45mujiMyg3XD0DknI9GXuPVxJDYtLaYM7u5hVbQTS+BMiPdR8BqpZHG6avcSmGtrq63HVgRLKkPOsYoT/rXl/44sMWO6ccKLmBllwahjqJKu7vgxN8xTkG/t9ekzPew+QqTD/d9qqzkFUXCpqsmsZYQh4as48B/tpENZgDiKE+Ehs1Jz1gF9oOSCKtluIif00bHsanrVBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mj01yvVJSfvazpK9F0K5qJudaljHpE5urOqfFUMb16w=;
 b=bVc047hvf95HdD74/BNI+i3K8oZoxAL8BhPUL3f/cDig04ded12FDMjWaTfFNtQuiIA+O5mavMKtx0Cu1JphwXYuo79jnSQ+UHVeSKyw5KyJdY06AAni8rVBeppwYJcGRYR4WN6e3Mkgd7lecqjQlZ65xWN7ySAQVACz0+wGj1Y=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=oss.nxp.com;
Received: from VI1PR04MB5101.eurprd04.prod.outlook.com (2603:10a6:803:5f::31)
 by VI1PR04MB4512.eurprd04.prod.outlook.com (2603:10a6:803:69::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.23; Wed, 28 Apr
 2021 12:30:29 +0000
Received: from VI1PR04MB5101.eurprd04.prod.outlook.com
 ([fe80::1d18:6e9:995c:1945]) by VI1PR04MB5101.eurprd04.prod.outlook.com
 ([fe80::1d18:6e9:995c:1945%6]) with mapi id 15.20.4065.027; Wed, 28 Apr 2021
 12:30:29 +0000
From:   "Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, richardcochran@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
Subject: [PATCH v1 0/2] Add PTP support for TJA1103
Date:   Wed, 28 Apr 2021 15:30:11 +0300
Message-Id: <20210428123013.127571-1-radu-nicolae.pirea@oss.nxp.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [89.45.21.213]
X-ClientProxiedBy: AM4PR0302CA0023.eurprd03.prod.outlook.com
 (2603:10a6:205:2::36) To VI1PR04MB5101.eurprd04.prod.outlook.com
 (2603:10a6:803:5f::31)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (89.45.21.213) by AM4PR0302CA0023.eurprd03.prod.outlook.com (2603:10a6:205:2::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.27 via Frontend Transport; Wed, 28 Apr 2021 12:30:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0883dd3b-0620-4301-0d0e-08d90a416875
X-MS-TrafficTypeDiagnostic: VI1PR04MB4512:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB45122E3AB2D03F771B553F029F409@VI1PR04MB4512.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SasYzBbOWYX0USdC10BPQeaHq/FBBUaPm8yjjVe6ggtlsHhUPk8sg51K9EKwZXDKXA+CevWpADifYgrDkO2HSWpJsR09T+bv4lXzhrBIHSO/8hrmBm+3gmSCjs/Y5Nww2VcRMipFXnO+oFfo9oeeilmCH9dxTGdYj9Ju9Cz+ozPnEfPMwXUTRiku/1ZNLzUKYvsYThXqXEa48nAV+j8Ykcbupbs713PR/QFrBXx/0HkIc0lDIhAl+SOPNc609dEI3rlIthyR42Drsc4XDdnhiH0SDcAgDzKsQMsuy4SiI+6dzh4TZl04OHk8MmVchLkipSJznEbbPuCCgMAEsy2hQPmTWz9yEf4sqvj01ZYbzoSKGrUUwrtJ8Z/+rp/moTCLo4+PNUAwPvqhnu9mU5AAZmKKVx3LbVeUdmyk3X42NVbyzMC/6TL3pYu+B6ieqlJf+tN22uYQ1hBXctM4c65OfSa2ECiK7lRFBcAwoxAkzwfCjABA7ZoiY9TwFmfzI5zAQVEXXjYggsHILht+DFLKTMDN1Le2rXQzTQ1GlMYfg/6JdOqwuj1oGD6c8RpsNDqEwoSWdYV6oNk5QkdzFDVwIhUZbmOz41POwghbZSSk0eWzlhiCrp3msQJeVDZUzA+EXzn5L02hvzetWzMBItxBVRrGzbs9jZ7+5PLeChBoeuAy+omcMaNTAAaOfK4j8Ayu9Gc2sDIE/i/N+5bKkY6xAA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5101.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(376002)(39860400002)(366004)(396003)(478600001)(316002)(6666004)(52116002)(956004)(6512007)(26005)(2906002)(186003)(4326008)(16526019)(8936002)(2616005)(1076003)(38100700002)(8676002)(83380400001)(5660300002)(4744005)(6506007)(66556008)(86362001)(66476007)(66946007)(6486002)(38350700002)(69590400013)(41350200001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?5MSuQcecW9a5oXSn2tGd1TwavIggpP3P9/o/aDqUVw4sHD7h2TezJ+oxAXp1?=
 =?us-ascii?Q?jam/S3LD4/fJ6VgzOJ554YolLpM4SlNVGJ8aLhThVRVXZAizEMtZKptFfEIq?=
 =?us-ascii?Q?hhd/WcmwbgCYIRblApUulJKni9mxQYQAWVLHw2TyEbxWRLep/8sQu4rPajzx?=
 =?us-ascii?Q?Tha/JirXu8vN0byNo146gflbCIv75js7appKTlXITd9rGKTXbssQaaS5dH7r?=
 =?us-ascii?Q?xG4+wVuNRQsqdxPyi5+BFoRCYdepnCIyPv5Wl44nqYJzmgYKqDD39dxPrxBY?=
 =?us-ascii?Q?xym+SmOJItd5l23RblkT7vqR8pRcYZODH0WTPTvs/2tlzlGZKHdiJ9wwV7fJ?=
 =?us-ascii?Q?tu7NBhklkIPg1PcMW+vQZYcoap0RJwIevZyRUYAw264OOTVF92wLne8ZlFKd?=
 =?us-ascii?Q?q87ZZedncbKNgc/rXplCPFq5/t7l+3Mas2TC5N0MmqCQwCON5AOb6kfIDM52?=
 =?us-ascii?Q?fgpIm8vbINUxkvrf65a7FAU9DPO0+Qwu07llkxVwcfndzUqXdegbB9gKqpnI?=
 =?us-ascii?Q?1AfWL2T8fc7iJbvYJa6GFNelt3w/FpCGbhlA/T7AgZedWCYV+F8FuC5wOpS6?=
 =?us-ascii?Q?Dyde1rswC8RcC5l5hZ72yG6SiHMDCJXUEyFln8LVxXMnNWDBsjKN/TNjnONC?=
 =?us-ascii?Q?ruZAOxkAGBBmU9Td6yCxEP88r/uK9C/lgh97Uj+3CY5JIpzN+jex5DwAaf8F?=
 =?us-ascii?Q?Uine6GomIrJfTQv7hDJrSofdcxyOnNMiLJcif8bA2AZUoz6fYh+ETYP1lNVH?=
 =?us-ascii?Q?1st3ha8+IEJFk6gNYars+w0LYmqOG+rKSz1Ho7spjXKLELkTPNNeZms8Y+GH?=
 =?us-ascii?Q?OJiOEa71pFlVcTPk67WcZgVaTQytb743+EcUdOp/NqDlbp0iNixhGbSoIGbd?=
 =?us-ascii?Q?HOFifdJ7YHjrr9FxU6tUJhIruorz5Aun3KOPzbibeOwvSofr1hoS0pw8Fr6t?=
 =?us-ascii?Q?QWxNwpmDyoerzhcIz8oZmhR3RPZpPcsAHFILQjvEf0npfZWCljEnUQ/sjPcB?=
 =?us-ascii?Q?igTOCLsMZHxiVrkW0wfCI0+t9gDemBXjfa+miVq766Os5yavvbN6IrRf5X0H?=
 =?us-ascii?Q?R2A70Awa2bsAM9QZ9IBHMD6Yf4vUifk4wwyFin2JP4WSbVQFZ2EryRcDI4SS?=
 =?us-ascii?Q?azdojse2JsgbQsThJHrqS81PewaN3nieSUUYpMCmiixl95Xze5xH+RanYWGv?=
 =?us-ascii?Q?5N/K8QPVm8uyEjK2YeZXi0g53wJLrj9h3ClxD4rR/duFVEgp+u5fyD48neSl?=
 =?us-ascii?Q?6QJkzyOo537ocJOifk20bBayhikyEx1WfnY3ESkU8qXO9TsqfyI0jR2W+j01?=
 =?us-ascii?Q?uoMjzd08pHET4Gn9fkxppjVo?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0883dd3b-0620-4301-0d0e-08d90a416875
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5101.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2021 12:30:29.4467
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e0njqhXbB0kUzhGGZkNbWc7Kpa6QeBvTpSyXfO2nqMMI4LdwPUcrXXxIuexk1FflsrfolyUwB14CjmrVVKm7FY78K5uDJ7SHSr3Ge1NRYKg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4512
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This is the PTP support for TJA1103.
The RX timestamp is found in the reserved2 field of the PTP package.
The TX timestamp has to be read from the phy registers. Reading of the
timestamp works with interrupts or with polling(that starts when
.nxp_c45_txtstamp is called).
The implementation of .adjtime is done by read modify write because there
is no way to atomically add/subtract a constant from the clock value.

I've moved scaled_ppm_to_ppb function from ptp_clock.c to
ptp_clock_kernel.h in  order to be able to build the driver without
PTP_1588_CLOCK=y.

Radu P.

Radu Pirea (NXP OSS) (2):
  ptp: ptp_clock: make scaled_ppm_to_ppb static inline
  phy: nxp-c45-tja11xx: add timestamping support

 drivers/net/phy/nxp-c45-tja11xx.c | 505 +++++++++++++++++++++++++++++-
 drivers/ptp/ptp_clock.c           |  21 --
 include/linux/ptp_clock_kernel.h  |  34 +-
 3 files changed, 530 insertions(+), 30 deletions(-)

-- 
2.31.1

