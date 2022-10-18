Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5404602E24
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 16:19:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbiJROTe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 10:19:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230281AbiJROTb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 10:19:31 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2064.outbound.protection.outlook.com [40.107.104.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03A7E65A5;
        Tue, 18 Oct 2022 07:19:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KYip421we8bcoQr7zlfVqzuaKww+dcDYd5VjbISuIp9oOPvCqyWnwyKCfgHI3YahshRRHj3GoecEy1+oV3cXebL4zVhDwXAdh3ZPA2isFOxmYC1toEbn9VzFHNg3O0OIkdpc/SUgFPfcOSHca1ulw2pNnsfPaAOI9UZEjzr6ZrCzTsK8Tp7E8cFmJTmiz5LW+m7MVzq/we9Gdwipv/URat7UokMH/6DEVPpCQeBhcRST+asm/PEZ/x5wpITt2OuchT9SpaCUHUNQayBzyMp+TZXuu+DZD24bddH1b4UVpgexG5z8+fn6BK7wAs0TeXm+Ivg7WgePQkZygNHTmiJrXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9Sk//kBhbjTM80Mb8T9+VmQKyM/lqCSmyxbahVmAc+8=;
 b=G4SSIIvyxZj0fLuD96w1EDc1WvLVd7LizSEokFeayiiROeGZDWjZ0EhgV0lqTcDEoe8xOvniB/NIRZJYiyWu1WjHdeB+cI0Sl7i2Z7iYerEUvfuq3JWRxsY4RvkjpvltdGeOSSnrCkHJZwTewpTAwtdlFDY8EqhvdMtEaw/RKXi8DVzLDff9D2LYAbuS93BejAoQZfmZln4ruviRmPqHx9mB5Cdzow7YwPdGs0zW21YGS/srYvoII0FXdCidyq+yVCtDa9khxJB0HARVeeagaH+mZVamCnpkEZ5lm8uYPRvIFfUtGXBxdhzJi6MFR6KFj8LFhb+b25V97NANWhXDtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9Sk//kBhbjTM80Mb8T9+VmQKyM/lqCSmyxbahVmAc+8=;
 b=Ise8fY70nqreb44sg1YnSDmqAB/d15+VW8tnE5OBo8yk7d+pj/NzrXjjyks/AXTX77pO82x+8u1j5i5cI8oWcuP4MW99a961s/8O9nmtHt8CFMsQhKCJ86Oa5hR5vZH64hSqnOJ9aaaPgo7XnssD2qf/4IWxuHqadsL8JlQz0nY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com (2603:10a6:150:1e::22)
 by DBAPR04MB7478.eurprd04.prod.outlook.com (2603:10a6:10:1b3::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.30; Tue, 18 Oct
 2022 14:19:26 +0000
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::84a:2f01:9d76:3ff7]) by GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::84a:2f01:9d76:3ff7%7]) with mapi id 15.20.5723.033; Tue, 18 Oct 2022
 14:19:26 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org
Subject: [PATCH net-next v3 00/12] net: dpaa2-eth: AF_XDP zero-copy support
Date:   Tue, 18 Oct 2022 17:18:49 +0300
Message-Id: <20221018141901.147965-1-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4PR10CA0002.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:5dc::19) To GV1PR04MB9055.eurprd04.prod.outlook.com
 (2603:10a6:150:1e::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV1PR04MB9055:EE_|DBAPR04MB7478:EE_
X-MS-Office365-Filtering-Correlation-Id: 27b5fd95-caa9-4931-3209-08dab113c33b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /vtYQ+FGAk4B5dk4CPnzQYNy7qQzblwhP09eMTIDolATWg8LHqp1nJaF7vsVYTO0hKDCfnkTfMj5xAVDwJkAAEc8bYpkf/xxw9Ie4dnvF2BkHt6PF9bdod0YeJB3kLs8tcvELWHkbGxmakkT96cpCuGHkXiHCTSgMwP2xjUR0/CU16jhA/hr+id0k20r76AwLewchcK4ta1jcc0Lna6YhfIezVgUXhuTFtlldLwMkz81HdwupPJgVMyKEURoYko6dFN3drlkTyqp0L5pEe0z3gdA3PPlaIdaEjHk0+harjiCuxr2NskIeNj5vYQdtPLdCCxT34mA7m/DRLLZJtHoExfgsegPL0Jnj55pcr67s8s5zWRTDQYBDO1OMlqwVMgSbr0Br8l8J2B1KGqinHZw5Rz+f3e9UjYeP9iIrvcki4JRHUaBgQrCBmxKkqDefNByVjrZ9gT6ueXIO7OT+Luk89TlQeSGWZ6X7Ffv8Uu8axA0qbgxXZz9PtbOppBCERr2vFbuQ0nroFBNwdTEnEM9u1WLQztrNJQ7FsgXZedqHz6YY5TUAfxS66G0uDY2NfbGi6GWQzgqyI4nh7KHvrx4WUXpmSAqpuXKVTHnxQq1wL3orReUPoyuPucluMa5GwfbUNvCMbMmoz9kyJ+PL0THsv+LYmiUXjHMUW5JPlI8TXokX6rz7mOYMgdY8qH63PaEXnk6rTOAg0bxLFWCUyLdl/m9Cknd8aDoEp3L83K+yBwIAVz+zw0xixNG89QM5AZwwzkx7gLPJuW/7qHEJAyROg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR04MB9055.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(366004)(396003)(346002)(39860400002)(451199015)(44832011)(7416002)(5660300002)(2906002)(8936002)(316002)(41300700001)(54906003)(66556008)(110136005)(6506007)(478600001)(6666004)(8676002)(66946007)(6486002)(66476007)(36756003)(4326008)(83380400001)(38100700002)(86362001)(52116002)(6512007)(186003)(38350700002)(1076003)(26005)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SfznwEQCS3OP9qfZYUxRpliX1Pd5ixQK5f/xBHj5jCquloZKwRwKCvfPgrGQ?=
 =?us-ascii?Q?5ydyFxO5Lr5gZBeTTvSyE1BDFIrtW7WJIzsZazJSFKqoF9RXfCLEBeJz8aCk?=
 =?us-ascii?Q?DY4SFAPA0ifoOpL+9Qk14XAV8LRYSPJR1im6w8XgR+lxNbXE0FbVIO5f1Kv+?=
 =?us-ascii?Q?imbyqOncaWubw90Yl/zKOQdAaajcnRV2JtUang06xBsMPlTzicMNAqb0fzZO?=
 =?us-ascii?Q?bhHVy5pJJREeiEhIY3RUAXQN2LA/FQ6XXH5RTBFNcOelsiGQwxY/uWiCE/WG?=
 =?us-ascii?Q?GScvxK9BH0pRSqqxkjlRCF3gREtSkz+vD6iu0ortG1vgdOfxLbQekCGpSs/m?=
 =?us-ascii?Q?otEJe2K2Z8oqVJ9uG6IWpqJMKmEZXWuTsWuqmp3mMrCB7QqRDMor6OsR48zA?=
 =?us-ascii?Q?iT1+N3IO92+y5CWyms631SGZlTPh7V7pTTL3dsbqueKPhORHRaTNw+6K/ZZ2?=
 =?us-ascii?Q?eDbkKJ/czDt1X7JZ+yGP3L9LwZli2EZS9DFlwANi48DEJWYfypMzyKbAR8Hu?=
 =?us-ascii?Q?8bex32a1yPBdBXG+u081vLMyRbV6Hz5BJOqbSY2lNyJCctAEbqK5ySxb98QA?=
 =?us-ascii?Q?Cf0ysycrQqbuTmvxcImJ4Kf3k1hvQHN4TJse+nB9B5so8/MNDBpqJwaUnFXB?=
 =?us-ascii?Q?h6rSDBV4qBWZzXM2/Hst/Ll7TzqaGbtOUmSJaALmw9AwL+ZY6/jWAOH92uGw?=
 =?us-ascii?Q?pN0swTlGqf4xM/BF/0g0wK18VH/uk2KFmbyQGbxC93ubXLZWLoUJhpheM76K?=
 =?us-ascii?Q?7LLkEM5ZwDTJnfLhkyIcgoGN53Y1BuLtyFlg1LSWAatH3wDV98a9ickpH38Q?=
 =?us-ascii?Q?Ngm1UhbMDyY8iBOWLD91vnSku/C8FKcdpkSdjIpJ4c/1xiEAZwbL3CgwtEk5?=
 =?us-ascii?Q?Y/4SdXlZsUpI7RqPlGLV3AUDACTMwILt2ksIuOLL9KVSeINbOxqpMwrrQ1fc?=
 =?us-ascii?Q?h031oJ4na+5ucKAm2NLs8zAFmE8EYmd6moE6FPW+SLpmrmIf412MCzBBqPe8?=
 =?us-ascii?Q?JV188wbSDii3S5+Ai/2dL5cfZofKzIB4h4y0SnJkN35UHe0mIpNy71+WeyTR?=
 =?us-ascii?Q?X85QtsrizGer6RCeyasPoLiuDq5rFeeHQlrtbs81Jnq+XqqWpMuvsWLF6lr7?=
 =?us-ascii?Q?oFy8BqVUqhDyFGZaCl20naIoiMUjIDMQ0M7tUnrkFOjfCzrC3YmOVLYIrC7s?=
 =?us-ascii?Q?Uff+cxys1x9WA3lJ1uOLyyTEZ/62anvqxZKtaJBUICBQuPaZSXKgbOCNysOz?=
 =?us-ascii?Q?3D/PWOA4uO86JFiY5Zw8GOXZa69iZRRoOk3F8w/29tQFmXXdAnox+se1UpiP?=
 =?us-ascii?Q?cQplB4cF85UZMAA+CAcejtcJwSW9nnV8Nsc7YmJ4v9Up/RHWTWQcxMokpJmd?=
 =?us-ascii?Q?s0hZnNLKjOCDeL+b43VhkRrEGV7Zee+xROftEA6q8DPw5HLcZmN7IKpRPlXh?=
 =?us-ascii?Q?96o8bvoyQrApFHu76VKqgBaJtkWiRLlhogbTWj57aqQ7IlS46osYYEQ0hkCA?=
 =?us-ascii?Q?/b207zq2ObF7d9Hyv4FcDKKOvefcsEFB5jA085mD/OOxAcWVrwBZvAikzKzF?=
 =?us-ascii?Q?NCkztAE4/V9AqCelCMXkHjaVynWsoYnf8aoreGMIdGJtx13uQjcAYl7DR4y7?=
 =?us-ascii?Q?6w=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27b5fd95-caa9-4931-3209-08dab113c33b
X-MS-Exchange-CrossTenant-AuthSource: GV1PR04MB9055.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2022 14:19:26.6777
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wmjkNwPTQeSaqXj97GwJaXp6p1itqrIsC3uem548YMpabBh2UTGE5oRk1k+NwF8Cp/7DxfY4a3Iuu3wRMyCiMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7478
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
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

Changes in v3:
 - 3/12: fix leaking of bp on error path

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
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  | 487 ++++++++++++------
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.h  | 101 +++-
 .../ethernet/freescale/dpaa2/dpaa2-ethtool.c  |  58 ++-
 .../net/ethernet/freescale/dpaa2/dpaa2-xsk.c  | 454 ++++++++++++++++
 .../net/ethernet/freescale/dpaa2/dpni-cmd.h   |  19 +-
 drivers/net/ethernet/freescale/dpaa2/dpni.c   |   6 +-
 drivers/net/ethernet/freescale/dpaa2/dpni.h   |   9 +
 11 files changed, 1094 insertions(+), 242 deletions(-)
 create mode 100644 drivers/net/ethernet/freescale/dpaa2/dpaa2-xsk.c

-- 
2.25.1

