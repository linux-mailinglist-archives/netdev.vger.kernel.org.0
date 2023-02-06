Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1257D68B971
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 11:09:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbjBFKJB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 05:09:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbjBFKJA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 05:09:00 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2087.outbound.protection.outlook.com [40.107.20.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 252BC1043F;
        Mon,  6 Feb 2023 02:08:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y5novYCuty08EAGwBltdZaCKVAxzXrLPMZM+mWDEtpCB82GBEIVVvaHQ0EafFmBc6impbtXKgHz1ifioSwKmjYupJfqwtGm6GMlKX1YPhopyVIvLjGjfGT77wyiKUZfqf0Yt4vIrpcybmLnNYwohWiY9SM2IVL0djALM6wiwKNxYuaDXDfUZdVJFYWIiqNGPiuG9FO0ff9gbijVCSOk9DnLHX/j9tv4qfiJJkA68bkkPxs4RbyAYGB+sXLfj3LVtIFUJRSD70jvRB4RUY8/QgW/U6L3rZkCyJL1rbyPk9KW17xLMqzCM8faqjGDWwPfqWTj9VoRAElje61smRgcbaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DiXX4eniqOJLKvp++w8g4EOvCT/FBmZVf6lByc9HJKY=;
 b=cay7k1PcDNYKs0h6EQidykCpXt5lRUrhPPSLO2lB7oFlqSog1LznmGv6hvPEIFln1eA/jw9qxllcfmuO7VjNUM3Y8+gNGFuU2u6lGgZMPFVZb1BH30DUejI/2+0fo4eL84jY8qcaNPYHQPOW+/aEg3UlQ4ldsvxUKLljnnhPH7TAm7vM62iKlPQ0FTHiXghCS7RaQFT2whH3jz8AUmOJKMjxn3mh+IENZ051pMUd+ZbfmUjAfBPNYlFBBCO0u3lSFeGaoYT63lQBWSGEnMKimra0iRSCs8TeybTq32hXmFhzUAMXChFsScLihzIZy2jlEQT8YyNlkDYNCVKtwK2/Rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DiXX4eniqOJLKvp++w8g4EOvCT/FBmZVf6lByc9HJKY=;
 b=ZJ3ZTmqlh9bcp2Kbz7NJ5iiOrtV6VLlXlDZUSVQ4pby4qlgg3OFRTT68hy7/rnLEcs7adkYM3jN7RM6CokgUjgpv/RPaSqfpiJHzC1Wj9jOf4cPDCbVWmcX1NxCwUo6Ab+7CG9UKD0B8y2kryzj/LJyx3Sjq5XwOsfV59eqq+Ls=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM9PR04MB8421.eurprd04.prod.outlook.com (2603:10a6:20b:3ee::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Mon, 6 Feb
 2023 10:08:57 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%5]) with mapi id 15.20.6064.034; Mon, 6 Feb 2023
 10:08:56 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH net-next 00/11] NXP ENETC AF_XDP zero-copy sockets
Date:   Mon,  6 Feb 2023 12:08:26 +0200
Message-Id: <20230206100837.451300-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4PR10CA0019.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d8::19) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM9PR04MB8421:EE_
X-MS-Office365-Filtering-Correlation-Id: bed9b52a-906c-4a40-fd33-08db082a288a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zlkrAhfSjbVmAfai0ZWc4tOz0bJnfjFW9DHgFbcOYElnBhCGewZdaL9A0afRPwPZE9OTAYqCLYRVLoaPS9tudV5+Ywh4QA/dftUzPtyZJrWE22IZQQJto03Q85kk+eEHzzXorZXiTjA5I35JMqL7TtnQFRZq0gXgvCrsfnRrWcHGqSQBJme5IJ6FbMZv1MHPI02+FBymHfDxkhlU6ijWEBgq9DgOh6yLpUfrRcp75xYlkK2Tiw7taORZJSU4ALKt4uEcFE4a9w1PO9SM9mnLQqL7hBuvAX8ulwPa2zrxkvdJk5tzZaLu55vs+PL2aMwreun3d1CniiO0un55oqhJzD9Wd+Iqz8vN0JuKs0Q1EP1LypJAy1QsCnkIE4/aOx8btTGqXBuC2dwJXKBmsTeAjp5/JOl0cXSuTZpUs2nCExlGFUnIEwiOG0QAkKyzdXcVbSm4vlxRKvWnLAYCI2BIxuE0ZbG/gN/wEYGn4mMiwBm47nsWO5z9xA7cFqhemZzJF9ABL2FE5IO+mbYrTbPGSydxa29MR/aNwP4uCvx0wBdenS35y+jwr//SippOZxChnfFDbJ7IzSZDdVZhSm8nMOyQZLlyaE7aYgTwSsrs0XpLR/0m2eTEbth0qKICQEA59EL96iL2NbG2jEEuZoIDYHqvDNcDpe/S4k9+F+fFz/NIaleVopmzP5stggD19Lv5gkYsgluT3W6ILpBZGRncDw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(39860400002)(366004)(346002)(396003)(451199018)(86362001)(2906002)(36756003)(8676002)(66556008)(83380400001)(52116002)(1076003)(6512007)(6506007)(186003)(26005)(6666004)(2616005)(5660300002)(6486002)(8936002)(38100700002)(7416002)(38350700002)(41300700001)(478600001)(44832011)(54906003)(6916009)(66476007)(66946007)(4326008)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4UWlyu+ZiGazLjcPXXp2v6t6Qjw54JVVdSb5G20R1BsWrWooKZBHYh38Jmbi?=
 =?us-ascii?Q?mIAXi7pca2M5jcSLWRhwtk2afNBqapwvoB0zl7aGa910hGw+OyFi/yrgBWwR?=
 =?us-ascii?Q?SqeunrO/Zv0VcV4GsgO/vWmwetdlkTN8WTRjX+DL0z0F524WImYqexRgzSRc?=
 =?us-ascii?Q?FDYPHdq6LPz6LlwdmKSS/kPnbHQGSZxj9USNaW+OXmhpu1ujd/CrN17JcuK3?=
 =?us-ascii?Q?s1Nca5fy2/pRQ2RgVIiK+y25XPDB2sebMIhCVBlxEZBtPTvwqKd+swtTexAh?=
 =?us-ascii?Q?d2M8XmNGCNUip5bemxvkP91ezeKwHWVWWber7aX3GAu78mFHfPS170my0TR/?=
 =?us-ascii?Q?y8kzLqSj3e6pEd8zzAR1H2agB+Wxru8aka5YfXy/97hkh/+a8t87UtL8lc/O?=
 =?us-ascii?Q?g3FCDnbx3qspSZ6LUpVUMk2ZGEWg5IlAsh48425dEEkwyKUwNi5m7Rj/uAGY?=
 =?us-ascii?Q?o2Q3rfDZ4fcuRYUz693wJsa6KQIqQ//Brp7F2IKBKT8YSPYzaSPC+X3A+hI3?=
 =?us-ascii?Q?0h0vEHeOAwtzTi16V3dmk4RrNLQwI5xfR20aivSpj84YqODPhe0R0IEAK5Vd?=
 =?us-ascii?Q?RwUnJCMOrCephv74DGzCExWbeUOEycK1qEuL+ouPnLRMLRGgPsY/k1s8YMFP?=
 =?us-ascii?Q?Lt968oEFtjzOiuR5ET91APveXoqbho5iHpRVnQTxUlHLSGr+q/gCOv2EqB01?=
 =?us-ascii?Q?ya+BXdXv4tiWckS5n7HOjJBK21o6a9Mn27WNUKDIgmUMoeBeDmVgE9DMKnmu?=
 =?us-ascii?Q?T1zePpVompkJ4/0d0dzX4lZd7tcjTHshHvLjk/ZBi+txiUNj0qG5Q/G6ovEw?=
 =?us-ascii?Q?Q7yGhVVwuAJyBC6zNRNZ/4QD33eCEXWUDlVtE1q71oJkYhxW9e1b7QDPdffE?=
 =?us-ascii?Q?sFZc97H0Z0JrJ2PKGhU50hG0ltTzBXhD9qslkkLVcgwG1HIFQ2mQJ/FgWTVU?=
 =?us-ascii?Q?BwHw38FM2gX0MuvgwUvrfFqiheUtk517y8PiyU4xfuKhpjDL/tgzJ+exnnuX?=
 =?us-ascii?Q?rXkzVqrGPkmFkyrmXixWYGpRhD//65+/u7g1Z4r/whp7AOfP5QeDX35XYTFq?=
 =?us-ascii?Q?MTDb9rukIyR486z0o+a/J2P3WvCsQamIFRKMhEoBzNjITXYUL4AS9+2Z78Ge?=
 =?us-ascii?Q?FQVkSMsWIAwMewnlLdSv5mfDW0s7bPq44qKTPryRi5Vwvm4khlg7x5GYdBwF?=
 =?us-ascii?Q?524n+9Xbstyq194Zh0JE2tHUQ8vpHcZggWI2qxVo0xOugepb4znZ+4ATGKOm?=
 =?us-ascii?Q?6tMsTtPbarb/NJWK3aItTWORuGbCzy94zQBIAfiUxPpRrGzCkjkjF+1i/2FP?=
 =?us-ascii?Q?mMVimb0lyFwXQEtQrxxiWXKe9Htor6WeI56WJgNpU0UbKVrYX3eXciwobLw1?=
 =?us-ascii?Q?yQZQLhp9AyTJr0HguvOYWszeGkKwBxwblkkcHdr0uQJh7iMmOrLffEAev7qC?=
 =?us-ascii?Q?9Z3o/prSAuU3AXjlf0zX7DCp8Egi0yoQbnJWj56EliOe24It8uUO3bPh9hDA?=
 =?us-ascii?Q?hVD8lQ/W4R0+58Pj6oKgskx7XjjDkeRVx3E6U71xDfjcGCex1BPyvQJmDB56?=
 =?us-ascii?Q?zhLFak052Spq3v2f+HSAZkPD5eGb5Vkchc7okjnxVwUpkE6XqwcySFNtvvZD?=
 =?us-ascii?Q?DA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bed9b52a-906c-4a40-fd33-08db082a288a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 10:08:56.6778
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uPf4aO7sQW5TQece+xDlFSshlYPU+RhQzZ77eyZ2FEXon7M5S1/mZWiZwy1B9q5ZN7P1sonthHEIfztW6fQ/Ug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8421
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is RFC because I have a few things I'm not 100% certain about.
I've tested this with the xdpsock test application, I don't have very
detailed knowledge about the internals of AF_XDP sockets.

Patches where I'd appreciate if people took a look are 02/11, 05/11,
10/11 and 11/11.

Vladimir Oltean (11):
  net: enetc: optimize struct enetc_rx_swbd layout
  net: enetc: perform XDP RX queue registration at enetc_setup_bpf()
    time
  net: enetc: rename "cleaned_cnt" to "buffs_missing"
  net: enetc: continue NAPI processing on frames with RX errors
  net: enetc: add support for ethtool --show-channels
  net: enetc: consolidate rx_swbd freeing
  net: enetc: rename enetc_free_tx_frame() to enetc_free_tx_swbd()
  net: enetc: increment rx_byte_cnt for XDP data path
  net: enetc: move setting of ENETC_TXBD_FLAGS_F flag to
    enetc_xdp_map_tx_buff()
  net: enetc: add RX support for zero-copy XDP sockets
  net: enetc: add TX support for zero-copy XDP sockets

 drivers/net/ethernet/freescale/enetc/enetc.c  | 676 +++++++++++++++---
 drivers/net/ethernet/freescale/enetc/enetc.h  |   9 +-
 .../ethernet/freescale/enetc/enetc_ethtool.c  |  10 +
 .../net/ethernet/freescale/enetc/enetc_pf.c   |   1 +
 4 files changed, 606 insertions(+), 90 deletions(-)

-- 
2.34.1

