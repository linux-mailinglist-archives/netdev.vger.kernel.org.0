Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85AA842ED03
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 11:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236176AbhJOJDy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 05:03:54 -0400
Received: from mail-eopbgr70088.outbound.protection.outlook.com ([40.107.7.88]:52805
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229656AbhJOJDy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Oct 2021 05:03:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=caKmbzKs2yQMJwrZc8yn7PFhLFaLJzNIsx+j/juvz6Q2idrehy2OSvhnHBtKudNAjPbuU8FtiHAiCdxbdajpk6FVsejDXSWfqMv66dCJwGn7HnQaizm4+M3agUaPRs87gMaYuz9+wsW2lSGmwrgPf1h1DSddO2oaLV6sjeoCVpbVs8NnmWIUuv4+4eLHuzyYlBDUv9/u0Z+Q0LYZSTSnHfYDHs5Sm03EWowCO574RV2F3xrphnHvqhvfZVJ8APiprhlPAsiR3QY8FmzF0EKb+lgFQ2npjQg+FD7bVnnbZMYgjivUrqwejpKqbk2JldQcQxyJdyz+0YPOe7ucJVk6yQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fmXP7lyjZivB0Xu+4WdYXwHNLMu2LyrloFeLCLrKDXA=;
 b=ViJL8k0yOLhrNaavJDbmjqnn1n0Czp1F6DlgThhKDZ7KfpyO0WjbzonpwVDJZnYRWsLHyYf8+CmHNVmgqR0rtHdGtnZbXDv/V3PR2npt2YmW0PCjMg8ImYn0YkhuIKXhpgH6hqKJkzzxAOtgU6iQcO5euCXLtyozkDDAwEsEp4A5josHqlbJYf13lYxZMf/rkb+xc2geuoEYS7AHYsRvyFR7O+2Y4IcD/gDi/nfI+0yp1saipF4xwma2aaSs4fGpclLONYKjnx2F7bEZkSV3LHTnmApizh2K7cK5/wIRrYpRtFRx5ewbV7APaOSi+esYyoAvz/v5yFKpvTa6l7EAzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fmXP7lyjZivB0Xu+4WdYXwHNLMu2LyrloFeLCLrKDXA=;
 b=O/PmXKbZVU2XqkWac/Oga3Q9/hjcckvmRXbNdIcISopadKea/hcf9qaZlrzjrrSQfmBa6F9Qfiwm9lHziKpgY37U50BsnV8BhrtDRaJPkqccIaxnUYkYfD6isM4ea3qqqsFSRaJbanbN7+9+Pru3QByiD4BbCb3GgmzpSFxYsBc=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from AM4PR0401MB2308.eurprd04.prod.outlook.com
 (2603:10a6:200:4f::13) by AM0PR04MB5988.eurprd04.prod.outlook.com
 (2603:10a6:208:11b::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15; Fri, 15 Oct
 2021 09:01:46 +0000
Received: from AM4PR0401MB2308.eurprd04.prod.outlook.com
 ([fe80::6476:5ddb:7bf2:e726]) by AM4PR0401MB2308.eurprd04.prod.outlook.com
 ([fe80::6476:5ddb:7bf2:e726%8]) with mapi id 15.20.4587.031; Fri, 15 Oct 2021
 09:01:46 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     youri.querry_1@nxp.com, leoyang.li@nxp.com, netdev@vger.kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH v2 net-next 0/5] dpaa2-eth: add support for IRQ coalescing
Date:   Fri, 15 Oct 2021 12:01:22 +0300
Message-Id: <20211015090127.241910-1-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM8P190CA0018.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:219::23) To AM4PR0401MB2308.eurprd04.prod.outlook.com
 (2603:10a6:200:4f::13)
MIME-Version: 1.0
Received: from yoga-910.localhost (188.26.184.231) by AM8P190CA0018.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:219::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend Transport; Fri, 15 Oct 2021 09:01:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ac1d44dd-588d-4aec-fe4f-08d98fba6a46
X-MS-TrafficTypeDiagnostic: AM0PR04MB5988:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB5988D82189CBFDB4DF14651AE0B99@AM0PR04MB5988.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2sn1fc2YcGPepn26TTRbg04WaLhBjVeUMEM5bqLrtnaDpZKfbAg0SgOqee1ss4JoziwDhdnsuRZqeZX0oeQOIpT1OUgIOpA3IB5mPVKdv12cSbzEr0BwC/SxvWNnirtlLo3TvDoOfe8KJW90hexhbFghB0gM/hKCHeo9/O2kc8yJj5VJjSRng3/MyYxap7828wo7ocUFD0FM3ry226J38J6X/LQSczuP8ZF2PJpOg5Bwel9/CmVt0kymr+dzezYi/LQm0j9KvnrCYtlncaiKjxvJOZnCf3AMf4fplWsGkbrHFS1blgCeKbPi97bOrqDNkZM80evusjnS9cuvgmF3ZeKU8EUKfJAhwiMG2kbLCdnQtEjHQsAzpHSV0DJ1t6pM70WAtlsYpJTLd62YjwO5giBpsQnDOD3jZnlQ01zrmRpR+6QgCQMp3xi2/Mvnfko2CDqs+9QDYeAODQ+V/1ABLB/s5sV+JGRNCN0rFgD/+LFJwk44nhYEzzudZnrM/xbW869J8+wUwoHmdlmy81sXOJGV61LpxclMjUrqiv6MLera75+ulNsuSGpuDXVsloiA5DPF9NbiSl4LgInHu+Tn5hyyAuNy2lzp4wRbE442xulaZ7MdeAdIlYAkzCS7FP74Q67YRHbUsN//48bJ/9ZEK4ctkdcdyYijxJV7cp3dyVB7g4bKi0PGSaqMpTNfz9+dPijLdpM93rQBAfYFMWCZWA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM4PR0401MB2308.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(2616005)(956004)(4326008)(44832011)(6486002)(8936002)(36756003)(8676002)(86362001)(2906002)(6506007)(186003)(66946007)(66476007)(66556008)(26005)(1076003)(52116002)(38100700002)(38350700002)(6666004)(508600001)(6512007)(83380400001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?e78T5fEzVHgyyAHti1Uk3GW5QbBchivCDDApcamAyfcr3Rn+VBWphOc/qMNU?=
 =?us-ascii?Q?MKrMdXmgh/YlEse1klhTC0icu4AhiE+SLpe/Lku2wIC+k+1UTvJo1wvg1rwl?=
 =?us-ascii?Q?Sw+O/v6dqcZ3OZDRQQj71tKmasrW+KVDMTJKUfc1PchefrSX1p4h1srsk6Rq?=
 =?us-ascii?Q?7ZT39mCIxVCzZ7mZALy5n5cmFW2eYwak46k4/1hMDhKGi52DwviwODVW9Juq?=
 =?us-ascii?Q?0NatoSuV7fEt8hRzfmcv03a/t2cyv3Kl4MvQ98RgVgm4BE+e3pCNb/sxdian?=
 =?us-ascii?Q?ULxJFYM0oZC7DVdM+FQ3+SKpePYi1ITkn+a5uFxy+IfBk8IMWLbo35Gt5+3v?=
 =?us-ascii?Q?YNWfKB4BfPyT0Q6nkWlVroF+m54wGaAf0JC+09eHNLegvOUcwj56/bDC/D9+?=
 =?us-ascii?Q?vIBskAzF3FHcKJSSWIrTLXQn3wsJh8/uNqJjM88ppJSMCDFrqrWqkhpYb231?=
 =?us-ascii?Q?A0dWQ8U2DuZ44THoS8XX8BGEzEprEbnxIaQZ2KhcZdCZ3yEfW/YJ6AxWMgLU?=
 =?us-ascii?Q?WF5DQPdE6EJ2ztjQblGwFCJlDD3lkMxlkgKcMlX1PoHSMLdtwQjCTVRWtH1h?=
 =?us-ascii?Q?/OSgw1hq9bHIFsg3wBIrlrSJ/BsXODImw3QSPB3NQYzni7i3jiPH7qtoFb+s?=
 =?us-ascii?Q?h5s9yLAzDm402ybscqO97/lNoqZWdSE8xxfSTu9P3nT4Pjv5ZEu5Z8hbUHCR?=
 =?us-ascii?Q?wiPdfvxExC9qEb6vVqF0JTCXpFxLE5IzELIKRoLVSvTSC79HeRNenRwu4ji5?=
 =?us-ascii?Q?OS+rw5U30h4cnJY4/xU8GCfRxyxP8zdumIWoCIwdYwsxlxbOUEL9P52BrYI6?=
 =?us-ascii?Q?wBPj8ihjNMc7ktp1SNwPX1lMqmZXOfJOJsdMX99RV4S6lfiuXFHigb+Fgb7s?=
 =?us-ascii?Q?3H1SvrNvxW6OPIjpI+PDbZvkk+PJkzN0uvUly/CmSmqcSW1vUhyxayxOEMvX?=
 =?us-ascii?Q?zlD8Bjr1442TUuiVQiN3vthCWnevZ2VWs4/MSNXoVNvdIhG2WjTadvLB36nn?=
 =?us-ascii?Q?ht44wMaMdlbH6w4y/arlLJ91Vo1G+fBIyBAGxjTQJZO1R+P6hq7pvhiC2F+m?=
 =?us-ascii?Q?aieHNlTcN0NfR2A0BrE+0jPUxjMCCESOr4u3N8x4A060ibPdmafQJe29+tWe?=
 =?us-ascii?Q?ISjo6czPZTwBAhQQBQLYVxfpOVkVXBEngGK3gVz8CIbbhXQvlB3TQzQfdN3A?=
 =?us-ascii?Q?s3aBvZWi0j6TNqZo/m/UXG9XMH6yst6DFne0yYBxtxjdpgwrELKnDmWlw8Nq?=
 =?us-ascii?Q?Xq/PUUZR6hpurTbkBdg4rlgdqpb+LqRkxfBC1sC/tk4Om4LhEmqREqHw1leT?=
 =?us-ascii?Q?vxxaXk/tfk7g6RzQgVMEo1J8?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac1d44dd-588d-4aec-fe4f-08d98fba6a46
X-MS-Exchange-CrossTenant-AuthSource: AM4PR0401MB2308.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2021 09:01:46.1111
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pOTNyn0M4QoWwEMQVG7cdwpYU76zYMs9Y6DpQ9W9ZyhF/cMaxOES/F7UowHdGsG6Pw/F/AuYZqN9kjQe1wbFvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5988
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set adds support for interrupts coalescing in dpaa2-eth.
The first patches add support for the hardware level configuration of
the IRQ coalescing in the dpio driver, while the ones that touch the
dpaa2-eth driver are responsible for the ethtool user interraction.

With the adaptive IRQ coalescing in place and enabled we have observed
the following changes in interrupt rates on one A72 core @2.2GHz
(LX2160A) while running a Rx TCP flow.  The TCP stream is sent on a
10Gbit link and the only cpu that does Rx is fully utilized.
                                IRQ rate (irqs / sec)
before:   4.59 Gbits/sec                24k
after:    5.67 Gbits/sec                1.3k

Changes in v2:
 - documented the new qman_clk field

Ioana Ciornei (5):
  soc: fsl: dpio: extract the QBMAN clock frequency from the attributes
  soc: fsl: dpio: add support for irq coalescing per software portal
  net: dpaa2: add support for manual setup of IRQ coalesing
  soc: fsl: dpio: add Net DIM integration
  net: dpaa2: add adaptive interrupt coalescing

 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  |  11 +-
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.h  |   2 +
 .../ethernet/freescale/dpaa2/dpaa2-ethtool.c  |  58 +++++++++
 drivers/soc/fsl/Kconfig                       |   1 +
 drivers/soc/fsl/dpio/dpio-cmd.h               |   3 +
 drivers/soc/fsl/dpio/dpio-driver.c            |   1 +
 drivers/soc/fsl/dpio/dpio-service.c           | 117 ++++++++++++++++++
 drivers/soc/fsl/dpio/dpio.c                   |   1 +
 drivers/soc/fsl/dpio/dpio.h                   |   2 +
 drivers/soc/fsl/dpio/qbman-portal.c           |  59 +++++++++
 drivers/soc/fsl/dpio/qbman-portal.h           |  13 ++
 include/soc/fsl/dpaa2-io.h                    |   9 ++
 12 files changed, 276 insertions(+), 1 deletion(-)

-- 
2.31.1

