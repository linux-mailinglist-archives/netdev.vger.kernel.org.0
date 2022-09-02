Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4C005ABA64
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 23:57:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbiIBV5X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 17:57:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbiIBV5U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 17:57:20 -0400
Received: from EUR02-DB5-obe.outbound.protection.outlook.com (mail-db5eur02on2054.outbound.protection.outlook.com [40.107.249.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CA0EF54B6;
        Fri,  2 Sep 2022 14:57:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RjPVYeUZAEmhwmnFwePg1g//r+urYEj8w/BCzYcblvWek2ysz09T6Yvq9G+6pXeB6kWI5w1JImtCIEfml9itCvfbNSJgfTnnkYwEt7nnP7+URs6dZ0BLf3EJbY20dOxiXbXR/M6AdX+N/IvZu/SwM1D8v9VoAiyux1j8n3mIStaBlF9l3SSd48xpKc0fBB0S4gIzWfMticNfhEy8jsgeu91XSzaT4NtCUhgSf0Ie53AnwwflpRe31g5BsAESg+iqDznQvYnCpDw397zcykxpoZW0/drgKWr7dq9I5wOImxwgd5Y1T+Gu/qL3mOmT4OP/gpwMYN24t1PcVJKbCrglNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gCPw1SOenx51GS+Pp/yEG6FEQsVAkXCbC+wj72ef+pc=;
 b=Gt/vz7rBGUo4dgeDLtZR8vxClNQOstdKWqolo91/w31/O+GxSJQQaznR8NVlg4k1IX13R2uKfV6hIAolj9TcLB45efUuiBV1zZNMhYguAXkKQ5pDkWepog4jHv0u2wYdl8DgQCO7L9AvJco1+arTq/1cNKnRF//w3VEagC5W3fuOsDabq/z3l2XE9zc6Xby/FhnYwQYLfZ2CCSOcV9US0+O0go/z+ClRAGgXIOv5WRXHll9Rh2/2CB6w3soSHuOjqlHwRl7ixuIF2shGVB81i6Hl+EVXUXqPqZjzl+tKUJWvpLXDpVjrdXYDKdOwSaLnne9C1pOWxWcWR43x0MhlfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gCPw1SOenx51GS+Pp/yEG6FEQsVAkXCbC+wj72ef+pc=;
 b=dHhH/m3bqLZT4VTHoMdyK8IeGwHvl7sriNKeTqAUfdJXUhrEX0PV9mKijU4zw2wiPSo3daOsq4EpNZo363bXSKx1oc7BcFRCr4Nx6V5LTWL7hKyy9/xf8ZjHNf8CpVToMrPXowbjs8B+NrvuJbAMl/GS2Hw+fpLvDHbLmXltDP4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4576.eurprd04.prod.outlook.com (2603:10a6:803:74::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.21; Fri, 2 Sep
 2022 21:57:14 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3%5]) with mapi id 15.20.5588.010; Fri, 2 Sep 2022
 21:57:14 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Michael Walle <michael@walle.cc>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Colin Foster <colin.foster@in-advantage.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net 0/3] Fixes for Felix DSA driver calculation of tc-taprio guard bands
Date:   Sat,  3 Sep 2022 00:56:59 +0300
Message-Id: <20220902215702.3895073-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE0P281CA0013.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:a::23) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 40fe3f4f-d216-49ab-8b34-08da8d2e1861
X-MS-TrafficTypeDiagnostic: VI1PR04MB4576:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oRmGeujuGKoVgqZHNZXQ63Ilgv2UwrVZo6qITVBUjW5mIjx1NX0czvWgCe3u2AcCKYK/5qiPeYBDVxBwj/cOjp2mjqvdYi3ncQ4JppAFghZhobYOvDwSuZQ7Th5TfoB2icGAbXF8oczRwnTvb/d+Fsiqa/HjJIyE0XXC5jiAuLf6WAUa/QyWSjxpZFhp7tXeXRKCRjjdWd5KNRH77ND71i737bnsKKiBkn3v7HuDXoiScAestMp2B42YXG5auO9c/OwmD8rOSjBDnL02Wiaxp9qht5oWSlUuXpOidnJftU7k/63b/VBWonOK1FPH8V4Ox17gsgLX2sI3Ta1UPjupHfTZUlAmLChmY+uEy6XF5oCUVBPGZqmSoILIgy2T1AO4P3ILIe5PvZiYZIpP9BuZ1lWLGKU1b1NW22W7HxdShGV5oCj1Pd6KQgtoYlwxUusCx7nNNK61W51+IxqhB7Elu/roayRvscvpWdVHEqz4e/Hz/OTTVqCfmJ6js1PCmBeA5kRBwIuWteuJxDx79nETU+Kum69kP5J+YK3GhAVjUhUa64TKKD1qafJ5WmXlveMZahkvrjFMTa13A7M04YeTDMbO1VS+W1VDybFAWD4CVXK66X2yTZd8O3iBglN5MwJGn2gfxQ4EdScpGoxoUk+MX24obICZKV+7a2f9VVYAhni/LA+s/BgNsqx+UPiFXkZ/Q/O09lsqK++849NNZEsvmY1b5/+w8aGg7rz0FRNyX4UDy9/0GM8qt7O5mq/oSOZ0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(39860400002)(136003)(396003)(366004)(346002)(6916009)(36756003)(316002)(54906003)(38350700002)(186003)(38100700002)(1076003)(2616005)(86362001)(52116002)(2906002)(83380400001)(41300700001)(66556008)(66946007)(478600001)(4326008)(66476007)(6666004)(8676002)(6486002)(8936002)(7416002)(44832011)(6512007)(6506007)(5660300002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qHofrv4RToULxLBby8x1rEEmq/x/q6Epqn/Gx88wfO/ShAHF4ueJhnRH/62v?=
 =?us-ascii?Q?bcHonCuAt9KBBfc3mobVbzOBg+01i79wVgDKXwkGDBmVrql04yecDB51+7OS?=
 =?us-ascii?Q?+HlM7SKkwlXrkKUasicXyXD5l5N7BXtpOIs2QKj1BtpaMG93mJ2w8GbfkHbR?=
 =?us-ascii?Q?rkFRXxta9J8lBxwnE5RpwCILIWVBwculP3hsTbzWXIEueaGDuYoLy97AFXf9?=
 =?us-ascii?Q?bElCrUcKrEczHtxwV0GKgCi1lzxe6aiWBQDi91ovodykpBeW3BtsreEWsA7B?=
 =?us-ascii?Q?vIY/6VpBPjAuhjJ4h0BDVQi+9dUiEX0rdMc+K7QKWtgxHJdhThyti2fdYvQ6?=
 =?us-ascii?Q?bCEkYf0soQWEQOmJv8xLiQiTG3aLP6dygKGA3Jdy+8EN/AdfB0vtI94joo7L?=
 =?us-ascii?Q?39izC+GgPnY3X2BERCaB1JFbxCfmH0zLEGGywQVYmbPFoyJMmR+7vk1mXCya?=
 =?us-ascii?Q?PoU0xaFmpwp4jW62zYAglw5l058kXsj2u4d9bEEPEApGsCA1Jl8k/dKVxlDV?=
 =?us-ascii?Q?D2rxOiCafMqm43pfdffv7YOPNPq0jKiuR5NABUirU8dt0Qqqn6G6zbEG5uxq?=
 =?us-ascii?Q?ZlpiUJbzoXVi4gz+zn1aXDYKoKNS6iXKEqIV4K5K6trO296fRtTR/bHnLrNy?=
 =?us-ascii?Q?iGnF3QM2Tzn3nKAV0aQy6N66EXF5P93R94acxho9QIAwnpOGlkLL2XUDGUmL?=
 =?us-ascii?Q?8XsY+TlwtSCf/f3DRK7wMyQ1AlZSUENlavn16a5fdIfEi7XG/OcGcCM7fOJc?=
 =?us-ascii?Q?/nJjJU5Nf8THoq7XQ6IYsdGTIUDgio11arTtPmZSx9vuorUKSNUOM2my9NOI?=
 =?us-ascii?Q?EFQyA9ITZSsxxlgrcB4GSC+TO3/CsDtf16T7kZjQ0gqT4l0GhwUMpKFv1nK/?=
 =?us-ascii?Q?cJ7RzhlGs4Xu6D5sZbtDNKpqFfvujfUmoE8//7cF9p+CFSPq6V1t6QBYEfVg?=
 =?us-ascii?Q?ce66McT5p10Me42iQz5+WAQg0wxvy0wlna63sd6wrY/fvssetRzhBZnGU4KZ?=
 =?us-ascii?Q?428FY1cIJC4Ho+1bFTfbqAQaII9eSmAeGR/rTDHSFiwvxp8a3/VvC3hdnfyb?=
 =?us-ascii?Q?hXeiZXv3zb2hMrfpb4Tk776TqnyjseL3qpRajoOSe8Moj9N7GwIp7YrUJeTl?=
 =?us-ascii?Q?JaTuCYSG3Qmb64mo9NWDLj0tJ0xcwrkmLJQTtWg3baonCPgOts0dSQTbztPE?=
 =?us-ascii?Q?NgbUUOYXeTWLSmtJLpL3T+whNIF3ks3ZDK0wLTYKZ21GcUcIGxp2d9kkYNhm?=
 =?us-ascii?Q?yO/388z2js3fiJXZ+uDC1kbYuPII3AzT9fgmSsWVqwJLxWiytQ1RCzzj1kxJ?=
 =?us-ascii?Q?be/g8tl79OEUCmrAbY5H2B0J3lKADQ/Qa8elMwBnHCgPJ9pktXQpGdsVDA7E?=
 =?us-ascii?Q?pr5BGtmYiFr81kbMjIOSvTRWmj0/54KX1S4tZr1SlADkvsVBAArG1QX87tvD?=
 =?us-ascii?Q?Hz1ii+HhGv1XqoyA4cBOVhEviBj+ZHQCCawk9ZKqfp67lQtKtlwtkV6hzgXa?=
 =?us-ascii?Q?zg4GL+yOQQRyqeNkn3Awu1U5T/uDY/8dp1BPl6pEUdWuPBpi5YRACEPX2LLm?=
 =?us-ascii?Q?btD3aHyS2SR8DpXfOK7OuH3ApTqKcXFtCbeS4+jzA40+vS+WUiEy+B3MUPrr?=
 =?us-ascii?Q?Mw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40fe3f4f-d216-49ab-8b34-08da8d2e1861
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2022 21:57:14.5904
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0NsIYyMez8GBnS1xNAOYzW0M5sd9ytc4EUM+quaCtaJhDhKEBcoYvJoihD9OWDcaCv+THP9Iax5ktIVt5iTrYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4576
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series fixes some bugs which are not quite new, but date from v5.13
when static guard bands were enabled by Michael Walle to prevent
tc-taprio overruns.

The investigation started when Xiaoliang asked privately what is the
expected max SDU for a traffic class when its minimum gate interval is
10 us. The answer, as it turns out, is not an L1 size of 1250 octets,
but half of that, since otherwise, the switch will not consider frames
for egress scheduling, because the static guard band is larger than the
time interval.

The fix for that (patch 1/3) is relatively small, but during testing, it
became apparent that cut-through forwarding prevents oversized frame
dropping from working properly. This is solved through the larger patch
2/3. Finally, patch 3/3 fixes one more tc-taprio locking problem found
through code inspection.

Vladimir Oltean (3):
  net: dsa: felix: allow small tc-taprio windows to send at least some
    packets
  net: dsa: felix: disable cut-through forwarding for frames oversized
    for tc-taprio
  net: dsa: felix: access QSYS_TAG_CONFIG under tas_lock in
    vsc9959_sched_speed_set

 drivers/net/dsa/ocelot/felix_vsc9959.c | 141 ++++++++++++++++---------
 1 file changed, 93 insertions(+), 48 deletions(-)

-- 
2.34.1

