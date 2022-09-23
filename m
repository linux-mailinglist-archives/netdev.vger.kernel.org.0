Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C3FF5E7EE1
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 17:47:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232788AbiIWPrU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 11:47:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232743AbiIWPqn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 11:46:43 -0400
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-eopbgr140041.outbound.protection.outlook.com [40.107.14.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0ECE13A971;
        Fri, 23 Sep 2022 08:46:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bH08max3tAP/Havzx+7Prjdxm5U83ZrNUCTY+fM2lQfsNnpJ8wKKiMOn97kiKCoplGourePcOy5D+zwVc0VQuWeE+a9NJbE/hG5g6y8u7ixwzdCKDnk93I1qlFsclnqwwu3yseQv0+c4tBR4b34rqXVfXlsDH/nEukGZniJQP3ZU8gYOmcf8DdXPrzUZ2gbTFhgSU9DSHooNPqujgOTJ81RvFoXXvAFBfBNJd0Md4xhB8IldMspUY7hiu3UlQhy5JqC0mxHZbVMHLWmdrsQbcpAoM0tI8OcLDFqK0hmfj52H3K1T+tzATlFM5SLcDEyxhUcRO48BhkemGP8AHb7K0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C7ap+Zz8ampTLUeZCVAP/J9UHcUJqdIvO5pZ0yVTHhI=;
 b=Y4CZYwV2uJQVhru4aks8kpq6wPCn/IzZb4xY3i9t1oGoGSEUdjBpAzDqLZwZ+zD+W082eYq9luyE2OqE+tQfWXAr2uIZGAUyPIuMvHl+KxaScISd3ndCphvOonHe1cDjfKJVLog9dBoKrjC1EGtKEavviH7bH2DPXdLrk1nCPHVosGMTFm8jhAYiyq/co2cuaCUPHS8VXg5zJ8y2U7Ku5jZXbHKT/sK8o2iWQBuJlblgbdeRN8/X0h8Oqrz90I2dKMcWvK3lekbc9KDp2/2eAJBNK2IjBzM7/1RE2J6eprGWIuAr42CxhkCi1Gwk3hEvl/OIoMLqmwmmnWkCFBYFrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C7ap+Zz8ampTLUeZCVAP/J9UHcUJqdIvO5pZ0yVTHhI=;
 b=C4viNrQdYCTJVBPaIABPMcx5vXBsVSIjD9xwT2amhcwRTY+ov7zoI/qfLYi6CQm2cPD86bqkHkb+FHrgaL7Us2m1h2E1DhT3xgpjvzLGiZxGYEuVerhp4hY43v4UPcDr+fzFVVpIeg6ngTXo7ErlSGzynn5eLacHMc47wqwbfjE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com (2603:10a6:150:1e::22)
 by AS8PR04MB8996.eurprd04.prod.outlook.com (2603:10a6:20b:42f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.20; Fri, 23 Sep
 2022 15:46:38 +0000
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::dd0b:d481:bc5a:9f15]) by GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::dd0b:d481:bc5a:9f15%4]) with mapi id 15.20.5654.018; Fri, 23 Sep 2022
 15:46:38 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org
Subject: [PATCH net-next v2 00/12] net: dpaa2-eth: AF_XDP zero-copy support
Date:   Fri, 23 Sep 2022 18:45:44 +0300
Message-Id: <20220923154556.721511-1-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR05CA0152.eurprd05.prod.outlook.com
 (2603:10a6:207:3::30) To GV1PR04MB9055.eurprd04.prod.outlook.com
 (2603:10a6:150:1e::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV1PR04MB9055:EE_|AS8PR04MB8996:EE_
X-MS-Office365-Filtering-Correlation-Id: c2bf5c6a-6dca-4c10-24b6-08da9d7acd42
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x16PLuoNZSAXM5yrngfbcWmFNXuvR40nMD5ipYaPuMe/xh/YNVMOLkKl+oNQyEEIKG+exWz8MYy75gxqm9cZz4tJl2bpts30COngdlbELKZj1Wqjp3g1i4x7tDjpVWFFhoyA6uebsCCrn4Rbp9boUGuedthrNj+t+Wffmcpymcdn2OXLPtvzcQh/LYcL8Aw7hPvejKMN32ZqPsn+fMJJwbbsArWWFnJjlmJO0xsTzwJcnnd6zBf2m9Sk8dI9yK1fodHnvb0kwFAuYCtHEIEeP7lE7+muKJXYyq/dDPl4M1uz13GE+7DMZrcZvM/m6uajQt8RmiGDmpj8m+aozsTprsF/qHb9K2D9BaFSqUP9T8ses0wyuphDhdHZcXo1q8qg6kRplMRLnYrsYiNgPOlQGMgy67sZwCmC+aFkgSXmy602BnEm/YcDs7SdB6CfXFLWL/knDFRiV5RwjalLjzULBfC2Y5/ebbGwf2gDGABOSqkJmunozWqaCnixbXMeZkYnrgT4+K/XsZYJraO2XN8YgPpm7O1uwuxSm+86LvEuGyU+nS5MBmLnJO3zlsecim6gO9+IfkdBn6yVYLCgfu18pGPVplrohM9KoWE6GSnZabO2RIfSLCNhqKKWkXw1YloSo8Tl4sTXrlGsfcAr8GoVn1JuUWCdRJDklw/aPJcN/A+DHhC7d0zXXXMWkEOxw7M7zsRu/ih+rTQa5xrEHwW4gyqjb4Cmy6nU8DXxHcK6H7N6J/JXgVzctsZnSQ4RdolB4chIngzfrn6PacPMXT2T5w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR04MB9055.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(346002)(376002)(366004)(39860400002)(451199015)(6486002)(36756003)(316002)(54906003)(2616005)(4326008)(38350700002)(1076003)(38100700002)(6512007)(26005)(86362001)(52116002)(66476007)(110136005)(186003)(6506007)(83380400001)(6666004)(66946007)(2906002)(66556008)(478600001)(8676002)(41300700001)(5660300002)(44832011)(8936002)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Vea8LibtXUZUmyVDO4zSjIpMiiv7ApTsklTXlVQRWghtTtyshmydqsSRg5T3?=
 =?us-ascii?Q?uK0c6aIjCiuuEtoXYT/9LLeT6q1P80LlvX/xULMF9fM862g6OdTr0hOfZJdU?=
 =?us-ascii?Q?DIN/dt1NIEEkL7YqLBZopIwyLitmB9c0irm554nbkqdj9O73sUj9xZA1Aoco?=
 =?us-ascii?Q?EEMzdtwrzV/rNvsB43TrcpiJ5vNR4A39tgv7oFGeVq4Ui/5csEbxxUTL+6yx?=
 =?us-ascii?Q?BWIB4VrrBekZSr6BLBZFYYkaalhoF5uqFWzXyjpL8fMbG2GXu9+2YTONpAFo?=
 =?us-ascii?Q?VLtATHYL83TBpglqK91HYTRz3/Db0N/A2O4ai+6WRY5SbCK2UNagMEFuzesY?=
 =?us-ascii?Q?pJbPHWAmgkio6YDpD/ntyrcSOQ/NjzK8F596GBJhulMFFEk8VdEz9CmpoqO3?=
 =?us-ascii?Q?qUVeEPzNbMF/hcvrOIktXcCLoN1qw34umpRSPEQDPEU8HEaBUCYI/GuPQAeK?=
 =?us-ascii?Q?owiCIsN/XyzfaHsHgb0dqe0lwSx6vgS0Krrlt6SePgINvzfe9NYAKz1OIlm6?=
 =?us-ascii?Q?Houozx3ZIyluoQZXIdWoJBWfMQ9WDstyee8jaZT9guIS4dRQMWcQuN1w8RMo?=
 =?us-ascii?Q?DBGWCeK+obtjcbPvoRfyDcrlhiJV+6G4tD1HAYmgbfJ9SNxCm4qJe1LUmZ4K?=
 =?us-ascii?Q?7f5MmqraQ/LtCe2U+YFEXWnaU/RDJkShVRzclKaXHRRy+akTVGdcMAM5FPCn?=
 =?us-ascii?Q?ixS5iNVM0l+d1iJQOLTx5UFyXGc6nhHlrn6V+mXkURutksGWsgn5ZHYm9TP7?=
 =?us-ascii?Q?g8PbmEcfKoFWX2EX5AwJ0Xmh8dE/8p6egDMeQxuhR2aATvfFdguuBsHYw7TZ?=
 =?us-ascii?Q?KGVYfIqBGds73emJQW+BR5FoTRzQFx7gGoTMIJPGclOkQyKp4MW1v2mX22Ib?=
 =?us-ascii?Q?bMDnh6C6NaOAp6Y518IrHcEdQbcnIRPJEKnVb0NjbOt6D4bvm7BThLzWIoSD?=
 =?us-ascii?Q?GIttwG5xaW9f+TM/W97Q0xbstcQ1MZBbHbg8TE8RfRM16PE/8yELFOJGKtqR?=
 =?us-ascii?Q?L7p6qHkhYSZ6IIr3guiKAq5O96XEwqpvnvEqt7v6Z1v957dFN/elaoSEukm+?=
 =?us-ascii?Q?3Kz6f2tRr3c0XcPKy9sgKq9mnWYN/Kp60eN84zO0DRFORWnbBrkq03Kf03j9?=
 =?us-ascii?Q?JkuHmw4feOAogFSbdqwlcL1SygEhYmzsnT2G56seWfMba02YIUDIgvsFAsDQ?=
 =?us-ascii?Q?NQw6f0CkZGYKt6dWg2qZMZ5m2QZtSfUlDdg+ods7I+ogv1X60Az3+Cww9N+c?=
 =?us-ascii?Q?8BDUhRnKrMcq32rycJIHyLk7GtTm7sk4Z1QMWyqtbEMUI68pO0KKkQbkcfKi?=
 =?us-ascii?Q?JLTADZc1eSI76DCiS1QncA06aqFsHlHfzlIBoBZEd/qqrg2NRh6s1q5deXFR?=
 =?us-ascii?Q?pVIIQymt/EIVgI0TKb1k1+gfkua9IQ+iQQKYTaEpaSMkruyWEdk8sIuoQ9uF?=
 =?us-ascii?Q?oJLV4PbTGeXC545VQvEzHO8YjQjd81t9ZaYjdnV3qMnD3w6UO4rnGdLMG4so?=
 =?us-ascii?Q?l3Lj+Vzo9FpKmLgBwOUAyXpmtbQN5onNF/onZ/GhMJoGQoldZcCrnHXnjKAb?=
 =?us-ascii?Q?sdISeg7uzF8haRgs9xrS/CONLyRPhsxdZxN2uLLDyvEd8YQtFUU6JAjM9yUo?=
 =?us-ascii?Q?YA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2bf5c6a-6dca-4c10-24b6-08da9d7acd42
X-MS-Exchange-CrossTenant-AuthSource: GV1PR04MB9055.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2022 15:46:38.3769
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bcP/xk/bLYstDi9UXuxjjUhJQ/Po6SZ6mZmgBcmaaJypmVBMEEuBQsO48vVArc4dPeacWOY325nBvlReXMdw4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8996
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set adds support for AF_XDP zero-copy in the dpaa2-eth
driver. The support is available on the LX2160A SoC and its variants and
only on interfaces (DPNIs) with a maximum of 8 queues (HW limitations
are the root cause).

We are first implementing the .get_channels() callback since this a
dependency for further work.

Patches 2-3 are working on making the necessary changes for multiple
buffer pools on a single interface. By default, without an AF_XDP socket
attached, only a single buffer pool will be used and shared between all
the queues. The changes in the functions are made in this patch, but the
actual allocation and setup of a new BP is done in patch#10.

Patches 4-5 are improving the information exposed in debugfs. We are
exposing a new file to show which buffer pool is used by what channels
and how many buffers it currently has.

The 6th patch updates the dpni_set_pools() firmware API so that we are
capable of setting up a different buffer per queue in later patches.

In the 7th patch the generic dev_open/close APIs are used instead of the
dpaa2-eth internal ones.

Patches 8-9 are rearranging the existing code in dpaa2-eth.c in order to
create new functions which will be used in the XSK implementation in
dpaa2-xsk.c

Finally, the last 3 patches are adding the actual support for both the
Rx and Tx path of AF_XDP zero-copy and some associated tracepoints.
Details on the implementation can be found in the actual patch.

Changes in v2:
 - 3/12:  Export dpaa2_eth_allocate_dpbp/dpaa2_eth_free_dpbp in this
   patch to avoid a build warning. The functions will be used in next
   patches.
 - 6/12:  Use __le16 instead of u16 for the dpbp_id field.
 - 12/12: Use xdp_buff->data_hard_start when tracing the BP seeding.

Ioana Ciornei (4):
  net: dpaa2-eth: rearrange variable in dpaa2_eth_get_ethtool_stats
  net: dpaa2-eth: export the CH#<index> in the 'ch_stats' debug file
  net: dpaa2-eth: export buffer pool info into a new debugfs file
  net: dpaa2-eth: use dev_close/open instead of the internal functions

Robert-Ionut Alexa (8):
  net: dpaa2-eth: add support to query the number of queues through
    ethtool
  net: dpaa2-eth: add support for multiple buffer pools per DPNI
  net: dpaa2-eth: update the dpni_set_pools() API to support per QDBIN
    pools
  net: dpaa2-eth: create and export the dpaa2_eth_alloc_skb function
  net: dpaa2-eth: create and export the dpaa2_eth_receive_skb() function
  net: dpaa2-eth: AF_XDP RX zero copy support
  net: dpaa2-eth: AF_XDP TX zero copy support
  net: dpaa2-eth: add trace points on XSK events

 MAINTAINERS                                   |   1 +
 drivers/net/ethernet/freescale/dpaa2/Makefile |   2 +-
 .../freescale/dpaa2/dpaa2-eth-debugfs.c       |  57 +-
 .../freescale/dpaa2/dpaa2-eth-trace.h         | 142 +++--
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  | 486 ++++++++++++------
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.h  | 101 +++-
 .../ethernet/freescale/dpaa2/dpaa2-ethtool.c  |  58 ++-
 .../net/ethernet/freescale/dpaa2/dpaa2-xsk.c  | 454 ++++++++++++++++
 .../net/ethernet/freescale/dpaa2/dpni-cmd.h   |  19 +-
 drivers/net/ethernet/freescale/dpaa2/dpni.c   |   6 +-
 drivers/net/ethernet/freescale/dpaa2/dpni.h   |   9 +
 11 files changed, 1093 insertions(+), 242 deletions(-)
 create mode 100644 drivers/net/ethernet/freescale/dpaa2/dpaa2-xsk.c

-- 
2.25.1

