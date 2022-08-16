Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADE3459657F
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 00:30:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238003AbiHPW3f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 18:29:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237983AbiHPW3e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 18:29:34 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60064.outbound.protection.outlook.com [40.107.6.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC53F760C0
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 15:29:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jjQJZyMjyRJqGPHkY3Q4P37IKPOlRJfC8susVY+VcU39/89Y+BH54FhsRLsXQ9ZncpNZau/C60wUQONbTjxM6Eitmr0znhsOty2BcjUHoHEbND8369Jaa2H3OEoBvzHK0hyUcSZQ4U4W0sXsKurIn8fQdDJwbAm9Xumv0kI/rVAyQO4hoLcNucsLlGBnO4rIan3DNa8hkf/JTg5MD6d+cHnql2cE6fM3eHFyrjo0r12rJjyH/SONPH27VC7qd6G5Cz3NysT7+p023gIOvrvof+M1GmQQ9xl7jCy/wwUyj6VeBY+R6jgCpB0Cv/APz58ib3YP7bOHXVwhwekgjxSHfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zZlLFmmz7HkrpnSEIvEDbWxV7PZs4eDpQHxDIzxSjO4=;
 b=Cqds3vTuGYq1T7HQSM/GnAzPC04mtDlxxfGnf/zMoA7zOrzD1ek9gDJrLBSwnNGtL37U5w3ViBPk9A/OGzh3NdFflbvG6GAChrW1tBDRHMT01iBcqKAGDRRQaZFhCZOMXJ6zvelB5ayy1V3nNBTb1b/GZjNl4/Oc06tT+xc8xp9xGjF7xhSNDh3s4m05EkjvAHQrUqYQOfH35wXXY0K68LCPXd8rXW0oXgUNaaq878ZC+nhs+U8yiv7z92nKKqn25Ge47D8w+uTVXSfoU4E6NoAFwzQ/v0UNsHkqLM2j5Kp0xN6iP/2qM9d8jbH2jeBbc0yH2lt0Z0j5dLK7lORMMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zZlLFmmz7HkrpnSEIvEDbWxV7PZs4eDpQHxDIzxSjO4=;
 b=efECRJ/X7mWT2BYC2y/hqyICtysNy2AGAMSUgCNcWh4G27Pk7uxLHMlYTWx4bjpkApNKJFvXzLIAk4oyOyvbrrB9Lo4Jl+sXCSHP/5Ka8UsjI7znxTS0NDZaevIcygnGaYzJsyEkvWalRazIWRybta+/MKLLljote8KzZ24FKWk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM9PR04MB8618.eurprd04.prod.outlook.com (2603:10a6:20b:439::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.10; Tue, 16 Aug
 2022 22:29:30 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5525.011; Tue, 16 Aug 2022
 22:29:30 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Rui Sousa <rui.sousa@nxp.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>
Subject: [RFC PATCH net-next 0/7] 802.1Q Frame Preemption and 802.3 MAC Merge support via ethtool
Date:   Wed, 17 Aug 2022 01:29:13 +0300
Message-Id: <20220816222920.1952936-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0501CA0021.eurprd05.prod.outlook.com
 (2603:10a6:800:92::31) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 81bfaac9-376d-4742-7f62-08da7fd6c8eb
X-MS-TrafficTypeDiagnostic: AM9PR04MB8618:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iR/mCHs2T2K9moATRxWedC2VFGghp2Hegyc5JeQWZgEPLF8osYBEZ42+vjA20stWZaNuxtNo23xtkqaz1nlC5nyKMhV3gGsB+7CXgHtjbNFQ40LSwLyNJUerellYSLNaj5Ovj9jEIElouIUw1C+RtyVJSLjCm+OgbnD3w0ZMGp0u8+EUosELfKaJhKW1EbY8B4LH6DQ56NcRCtGTd8udzsUocSJb7DBo4KcJdKMKIblq1Dwk5+2GTdh31AG8Xsq4CjyYaWbZBNHr3jlOqk2c5tf8oJn2VRj2A05Esekvq1fFtMa8xyMlsCCfLYLDvyE8wX+oaj0eKvLBlS+3K3LsiGPR6f31w+/y2cuWoEmQSNISeobg6CZlcrGp4qmteYdLAgB84IZ1CmJvbtvWTKRXDmR2zF6WmwH4N/CgZ1IrZ7yS1/fM2FT2KYbcwElNDavl0x47cK4V1ZzMIQPDeZox5zJA2jreILtxQeJM1FvZdTcsEY1ZTaMrnB4RI6UrsUhkWQ4t/gnKkl60wT6m1ka/tmI7GafoK+6nhPqzeHvfSbjfEIsps8pC1HwcEwQ6CXMMRrsBOGwU0uDQO8G4Tl/PI7nMhOZNIwQ2pIKi1x01JGwpKM8vCw3tFczKil+3HJtCh2F+EAh1xZlLSTqTe/uURzCHnIUlPDOmouHutt1/BY+zNS3UHIorvsi/srnQysPnt4fsVahruouO33mVqGciNosFoybxgdI7mK7fQVYOm68IbQykI7kGf9rxp+T2+94DQnYfNkSGbiNVIGzG3rRRIBfezdqhoDFJwi8WUxb8y99O6rGg64fHbGPnxsQwTgIcj2nx826U0KtlUFPfZ+oAAg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(136003)(366004)(346002)(39860400002)(376002)(66946007)(44832011)(316002)(1076003)(66556008)(8676002)(83380400001)(41300700001)(6666004)(6916009)(4326008)(2906002)(36756003)(54906003)(186003)(2616005)(38100700002)(26005)(38350700002)(6506007)(6512007)(66476007)(6486002)(8936002)(86362001)(478600001)(52116002)(5660300002)(966005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dshjKJIVNw2GBSov0/3PKQOP4G5hN+n/aILNFY5F96/OPuszCav4g/W6fzVh?=
 =?us-ascii?Q?6h7TAULiKYj/4yxmA+0aM/hlBMqn/SEvXTpkPFDh9qrWTdzKtFuTV8ArtkdA?=
 =?us-ascii?Q?PdidyPM/9qBcxnn+P1IwjoVTeNH5BfUQ6tgWpNwWQyhC9oV3TVXc3KpMjpqS?=
 =?us-ascii?Q?4W5QIWc13ohTwT842fUKzt03AXunGupVwbbwV19wDmjGseMFOgLD2aaaQVGl?=
 =?us-ascii?Q?26x8kNtZUJx25WDONJjEIzVEYmAOpMQUrqbkSjbKKo16lsj/1eMppgkr47v6?=
 =?us-ascii?Q?7knHGqg3DALoxhvUgXHq5VPPeVZAvKwQuGj7AKXd4meutPt/i7ZaRCjxsUa3?=
 =?us-ascii?Q?82Z5tBhbejNwb9FIvl1JXF5Y2BWdkcs/yzjCUKRYdO/3L5ccs7ZO52Z/JrbD?=
 =?us-ascii?Q?HV/CJHLi7ABzLD79t9XdO1kuba9ADYKpxAddY5J2OzrExcgQONZqXteJJVsP?=
 =?us-ascii?Q?pdcrTy12XKu0EWXp8F73bRIUu7tvDqP4Pcvda229xCIKS3VRL1GV8L1uYRVb?=
 =?us-ascii?Q?+tHpFLAp7mersCP8rjooj9Y10Qv2JJb1c6oHtYcEIv0fhHw6tQYJdGQzSb+D?=
 =?us-ascii?Q?PraV2LP/KnpRc+rqgub8ftcVC7fQ6kHwO/B65WZoFzgTxxH78KU4cKLN9aF4?=
 =?us-ascii?Q?j0h7LrSQx3iX/kPAM8+4Lvm54rDAULoFzeM1Z0uNYhFDr+6VK3ySW68kjd7z?=
 =?us-ascii?Q?ICrcKqUI3dLWtjo8QpxiOisU1tJPPPVVvS/1NYelffFS6fnPLqlndkepF65N?=
 =?us-ascii?Q?mziUJaGOKzVGlE9xoAWCvj45qZ1Ex2aCozyCdWH/tAUWhk11SY5GxntzJ3/U?=
 =?us-ascii?Q?1QkYivddXrasOBf6U736udzbnhH+U9a1VnwHUTbNU8HK7SiruGGRKe7kqNS8?=
 =?us-ascii?Q?A47fwBMDwUK4Vv6RGnbO00BTAl7DSU3eXGS6OTlKilFffhMMHi1CeXY1k9QE?=
 =?us-ascii?Q?FTRNyQYKckwEqDnKN1xb2eo5uiL390NLnR29yltLDKsn8YVsA/4EHClxk0ZR?=
 =?us-ascii?Q?zdqrtYT+ewYMA95IACaRG7zD83Nf6F4/ssGrXk/ktUUFv71PKZpYGb4UOH8z?=
 =?us-ascii?Q?aEaxzAvRzNcdIk0ejh5G2NvYHK7p3hxoYt8pis9Tb1XXZzMqMIr46ODH6zbg?=
 =?us-ascii?Q?Y8MQ3LKTMPECi3IGiwYjOfCXKZ2gky0VzdaT573mMTQUiA20zFMQhBmnGuYQ?=
 =?us-ascii?Q?R4KIL9Re+CRr6G337vC9Gcxi/9hWq9Ug2+3Upk5NbvPuYHVQJR59ln1gXCxw?=
 =?us-ascii?Q?jPg1JgearvcYieM7G1dvNtg1Ou6jyQGA1wcFVj85rnoe6+1rqhvCZi5WeUe4?=
 =?us-ascii?Q?ZcfnSH/jtIC882DguwhyxMfAjPSHeQBLJtgtcTAc0+0l7Ck4OekniST3cvBS?=
 =?us-ascii?Q?j+jHk2L0PIuVv06O0ZwpMVj6lyrSKTbqZjwInOWQ5QAnztPbh8zImJMTB3DA?=
 =?us-ascii?Q?J70pofPo5mID4N81qNKzX1CSZTgilIarkPXeSdPpmVWphedyvxP76T76kWpt?=
 =?us-ascii?Q?nkpPwzJYgo6uK4AxlMvlsLYJnNTcXwWJiy9tDoGRvzgK6+GSDa8EiMHegZFL?=
 =?us-ascii?Q?CsC98ruQTIiCrCCuUW/saFhUMpRyNZIHTBWrhH+dPFLL2BHu3Qvg/HsjIq0j?=
 =?us-ascii?Q?AQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81bfaac9-376d-4742-7f62-08da7fd6c8eb
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2022 22:29:30.0233
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PcllEvJ2w4gwHc5YRGmJjqslSybhhlDoyvUxua+e9S/Vdu3g/Gl+hBEsGrJDoSFWb0DXw0KHaeVlHESVfQnbGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8618
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vinicius' progress on upstreaming frame preemption support for Intel I226
seemed to stall, so I decided to give it a go using my own view as well.
https://patchwork.kernel.org/project/netdevbpf/cover/20220520011538.1098888-1-vinicius.gomes@intel.com/

Please don't take this patch set too seriously; I spent only a few
days working on this, and I'm only posting it as RFC to inform others
I've started doing this, before I spend too much time to risk colliding
with someone else's active work.

Compared to Vinicius' previous patches, this is basically a new
implementation, with the following differences:

- The MAC Merge (mm) and Frame Preemption (fp) settings are split like
  they were in Vinicius' proposal to have fp as part of tc-taprio. But
  in my proposal, the fp portion is still part of ethtool, like mm.

- We have statistics, actually 2 kinds. First we have MAC merge layer
  stats, which are exposed as protocol-specific stats:

  ethtool --json --include-statistics --show-mm eno2
  [ {
          "ifname": "eno2",
          "verify-status": "SUCCEEDED",
          "verify-time": 10,
          "supported": true,
          "enabled": true,
          "active": true,
          "add-frag-size": 0,
          "statistics": {
              "MACMergeFrameAssErrorCount": 0,
              "MACMergeFrameSmdErrorCount": 0,
              "MACMergeFrameAssOkCount": 0,
              "MACMergeFragCountRx": 0,
              "MACMergeFragCountTx": 0,
              "MACMergeHoldCount": 0
          }
      } ]

  and then we also have the usual standardized statistics counters, but
  replicated for the pMAC:

  ethtool -S eno0 --groups pmac-rmon
  Standard stats for eno0:
  pmac-rmon-etherStatsUndersizePkts: 0
  pmac-rmon-etherStatsOversizePkts: 0
  pmac-rmon-etherStatsFragments: 0
  pmac-rmon-etherStatsJabbers: 0
  rx-pmac-rmon-etherStatsPkts64to64Octets: 0
  rx-pmac-rmon-etherStatsPkts65to127Octets: 0
  rx-pmac-rmon-etherStatsPkts128to255Octets: 0
  rx-pmac-rmon-etherStatsPkts256to511Octets: 0
  rx-pmac-rmon-etherStatsPkts512to1023Octets: 0
  rx-pmac-rmon-etherStatsPkts1024to1522Octets: 0
  rx-pmac-rmon-etherStatsPkts1523to9000Octets: 0
  tx-pmac-rmon-etherStatsPkts64to64Octets: 0
  tx-pmac-rmon-etherStatsPkts65to127Octets: 0
  tx-pmac-rmon-etherStatsPkts128to255Octets: 0
  tx-pmac-rmon-etherStatsPkts256to511Octets: 0
  tx-pmac-rmon-etherStatsPkts512to1023Octets: 0
  tx-pmac-rmon-etherStatsPkts1024to1522Octets: 0
  tx-pmac-rmon-etherStatsPkts1523to9000Octets: 0

  ethtool -S eno0 --groups eth-pmac-mac
  Standard stats for eno0:
  eth-pmac-mac-FramesTransmittedOK: 0
  eth-pmac-mac-SingleCollisionFrames: 0
  eth-pmac-mac-MultipleCollisionFrames: 0
  eth-pmac-mac-FramesReceivedOK: 0
  eth-pmac-mac-FrameCheckSequenceErrors: 0
  eth-pmac-mac-AlignmentErrors: 0
  eth-pmac-mac-OctetsTransmittedOK: 0
  eth-pmac-mac-FramesWithDeferredXmissions: 0
  eth-pmac-mac-LateCollisions: 0
  eth-pmac-mac-FramesAbortedDueToXSColls: 0
  eth-pmac-mac-FramesLostDueToIntMACXmitError: 0
  eth-pmac-mac-CarrierSenseErrors: 0
  eth-pmac-mac-OctetsReceivedOK: 0
  eth-pmac-mac-FramesLostDueToIntMACRcvError: 0
  eth-pmac-mac-MulticastFramesXmittedOK: 0
  eth-pmac-mac-BroadcastFramesXmittedOK: 0
  eth-pmac-mac-MulticastFramesReceivedOK: 0
  eth-pmac-mac-BroadcastFramesReceivedOK: 0

  ethtool -S eno0 --groups eth-pmac-ctrl
  Standard stats for eno0:
  eth-pmac-ctrl-MACControlFramesTransmitted: 0
  eth-pmac-ctrl-MACControlFramesReceived: 0

  What also exists but is not exported here are PAUSE stats for the
  pMAC. Since those are also protocol-specific stats, I'm not sure how
  to mix the 2 (MAC Merge layer + PAUSE). Maybe just extend
  ETHTOOL_A_PAUSE_STAT_TX_FRAMES and ETHTOOL_A_PAUSE_STAT_RX_FRAMES with
  the pMAC variants?

- Finally, the hardware I'm working with (here, the test vehicle is the
  NXP ENETC from LS1028A, although I have patches for the Felix switch
  as well, but those need a bit of a revolution in the driver to go in
  first). This hardware is not without its flaws, but at least allows me
  to concentrate on the UAPI portions for this series.

I also have a kselftest written, but it's for the Felix switch (covers
forwarding latency) and so it's not included here.

Are there objections in exposing the UAPI for this new feature in this way?

Also, there is no documentation associated with this patch set, other
than the code. Life is too short to write documentation for an RFC, sorry.
I may get kdoc related kernel bot warnings because I copy-pasted ethtool
structure definitions from here and there, but I didn't fill in the
descriptions of all their fields. All those fields are as truthful to
the standards as possible rather than my own variables or names, so
please refer to those specs for now.

Vladimir Oltean (7):
  net: ethtool: netlink: introduce ethnl_update_bool()
  net: ethtool: add support for Frame Preemption and MAC Merge layer
  net: ethtool: stats: make stats_put_stats() take input from multiple
    sources
  net: ethtool: stats: replicate standardized counters for the pMAC
  net: enetc: parameterize port MAC stats to also cover the pMAC
  net: enetc: expose some standardized ethtool counters
  net: enetc: add support for Frame Preemption and MAC Merge layer

 .../ethernet/freescale/enetc/enetc_ethtool.c  | 399 +++++++++++++++---
 .../net/ethernet/freescale/enetc/enetc_hw.h   | 132 +++---
 include/linux/ethtool.h                       |  68 +++
 include/uapi/linux/ethtool.h                  |  15 +
 include/uapi/linux/ethtool_netlink.h          |  86 ++++
 net/ethtool/Makefile                          |   3 +-
 net/ethtool/fp.c                              | 295 +++++++++++++
 net/ethtool/mm.c                              | 228 ++++++++++
 net/ethtool/netlink.c                         |  38 ++
 net/ethtool/netlink.h                         |  34 ++
 net/ethtool/stats.c                           | 218 +++++++---
 11 files changed, 1338 insertions(+), 178 deletions(-)
 create mode 100644 net/ethtool/fp.c
 create mode 100644 net/ethtool/mm.c

-- 
2.34.1

