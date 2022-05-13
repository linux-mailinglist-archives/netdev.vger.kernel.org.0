Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37292526D8F
	for <lists+netdev@lfdr.de>; Sat, 14 May 2022 01:47:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbiEMXrQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 19:47:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiEMXrO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 19:47:14 -0400
Received: from EUR03-VE1-obe.outbound.protection.outlook.com (mail-eopbgr50079.outbound.protection.outlook.com [40.107.5.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4434C3731B1;
        Fri, 13 May 2022 16:36:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ArgbjvX3nSbul8QEk75iI4Ef4eGSUmIii3CiLqE6c2RtbFyOwRUkdya3sbLHnEgjLkBECSDT/VVlGRkcOhd1NSjy8khW+DpmhAjA0bSbpPG3/TKkXqPjYTO5NC0YdZsobCzA3LnRZpAlsB30hk4UbtbpeTW4dhQwGRPz9Msoo8o00cb/sn/GmsaUuutjiPeY+ddBjoQ75/Ho1ve+pbCWBSz5o2I7HgxWYwnFnmIbacCvod558ll7ZAec0yTDeyCBEujLPOF+0nI3ykbRqoU9n08E0uro4T/3HDrELi4bDv/n/WP74vqI3oEioPsMRUzzswgc/XBySKFEUP5You6Mdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bXOPANpBNjnOyKkHgo456XUMdbWCu+obzivZ6tLsZpE=;
 b=kSZ3LyZSPcsRW32MLU6VPGPzQIjWRtMzN2p6rhKRuCMfJg+lnDy+ddsgSBDQNCBihDraEUAVUpW33C31s94s+IO1Yj0GH+YesbexQhdT+T68QqfazABBKjvRPAt6Q7bC4twqXTXZdmRkq9TV4ruMbGkm6URq1Js8lzYBFY8Nu4qdhn9ss9/ypKNNQAC6X/Md0X+tf5f2e2P4DlyxpSiijsqSbYOauITbUfh8/m5sima5g+remqnOE6v70zGEiTDi+/iOPKuBGl5o7lEWxoCQoEzY3oNRgfDPugEkw2QL2niWmBDz2T1lXKV3Mnp7KjMPF/HrKmgxWzRTGmu07AB4ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bXOPANpBNjnOyKkHgo456XUMdbWCu+obzivZ6tLsZpE=;
 b=J9vDTe6b6Q2JXX9oyOyWtzUuc42BNT8rjXEbxeoA/WjXp0OW4V+bCc2DAP6SNzQWo5uhhj/DIx/96vviLS7JwUhIiEdblsFWnu2CyxSrpDKr30zIrKZQxbIe2BevqTnJ9CM/UdccgalPxq1MPkhtPASHzoLcvTGYPvMow1xzfhw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB7PR04MB4972.eurprd04.prod.outlook.com (2603:10a6:10:1c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.17; Fri, 13 May
 2022 23:36:55 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5%5]) with mapi id 15.20.5250.014; Fri, 13 May 2022
 23:36:55 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Saravana Kannan <saravanak@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        John Stultz <jstultz@google.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: [RFC PATCH net 0/2] Make phylink and DSA wait for PHY driver that defers probe
Date:   Sat, 14 May 2022 02:36:38 +0300
Message-Id: <20220513233640.2518337-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6PR08CA0027.eurprd08.prod.outlook.com
 (2603:10a6:20b:c0::15) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b9c15b0f-0c3b-4304-5102-08da3539768f
X-MS-TrafficTypeDiagnostic: DB7PR04MB4972:EE_
X-Microsoft-Antispam-PRVS: <DB7PR04MB4972C30D00FBBA858390503FE0CA9@DB7PR04MB4972.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PqoGby/kig92F9Y8xCQmzBi/VWXaA96EhSFzYUYfvy7hguUHqP6y7FdrUNP1BPvWoYFIUy3Xjcms2iUwDpQDtAjc/4u3RiEK40rzj4AQtBVwUIyXDxUk/2b9rgWHT9veLnEyH3r4yw6R116T5Ct6ZKOvwDryj6/27QtcBeHh0F+TDNpNQTmJ14Cxg0oZmo6vGtxgg+WenIMvuuFJ/BnYPE8Qk+oRHCgrRNMccvak2MXUJ0f6+kRLMXMo/UCyAT+NsKJmaS4YlLv3bUEhfEOw/IUSwV/u5zON2vmNl82hXRd5rY4mijfRnP8p5l+svmB87k+VT0UTYQCX2uul8FxnFTed7b7uDMnW7A3QN7ZCj7qf+55Oo6PJoYxeMWeSaZNK5fSWsjWdxp3Ku0i2xzAaB5lBuv/H4L+HwI+LHDhtpJfD4PY5K76O/jGcHL/P4XLwjkao3flZGKpNnOjAcg17FO7FKv63pbpWTzR9U3M45SfosA1qd2EoXfWvV4w6gokwo9lpyuyyzLJzm98YbaKakJFSJgk8q4PuDl2GtJDQZf0yhhbyy5h9IsUXRiZz/oNd/U4kkl6kaM1Ydl/o2QQp95n7JNcS0eLWbVWnGTbGj5wJX2n5Z54+Q1MObEApPlcqVejdUgZ7OGDvzVF9+/hp66a8qj0XRQdB6yCWvD0eLaHmHXSq2HrMrLiJ9j2EMlDAtXhpqAhwTgSevcdLgNepHiw+znpAlQezSdprGoQxwgTE1A8NKyHxGdzs+XvHXVLrcpkFObT2EDusGQeuVBGRKGOIvyl7NVnCqqqxa0z9tb8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66476007)(508600001)(38100700002)(38350700002)(6486002)(66556008)(8676002)(66946007)(966005)(4326008)(6916009)(83380400001)(54906003)(86362001)(186003)(316002)(1076003)(2616005)(6666004)(6506007)(52116002)(26005)(6512007)(36756003)(2906002)(5660300002)(7416002)(44832011)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uQ2ikYvS1QXgyCrX1eFXNjiT+yXArbqodxvdOnqtT08gvMj9Acgd+YXs6MTj?=
 =?us-ascii?Q?GUShpurP2AdR+paoaOR6C6VkZG/NdfDbHN3n4KqXBz4l455mLkVPIsGqRMTM?=
 =?us-ascii?Q?MVHEVutt1uLxBejTUKRDGNWtuMma3PD4tnrqQdMDJEMVs3BWTETfskv2STCs?=
 =?us-ascii?Q?FQCTQwtFK4CIE7HMF8Qi9PwTaHx3m/Pm9RRjOwAZsOQ7aY1bZKegG+9JlmhE?=
 =?us-ascii?Q?MG9RHcl6LcWpkgAfIsxW/mqW18d7z2kEvypczkmsnVOwNeF92VFh9fv8xBe1?=
 =?us-ascii?Q?dREVv56Oc8b3Q4ZNsGIISXx20F2PQYr0HaiOW/dULVxOpHA78r+KLFKSHuxp?=
 =?us-ascii?Q?GtwGOBPSBNefYipyzm5cpQbhvTllfbXYakn7H7ARzwTKF2BlqxrgRXz1zRU3?=
 =?us-ascii?Q?utxufElejaTunPrYpfq3BD3Z3MtVSJ/zPunPQ1M7Hd1GWjYr6SI4qjwBxqnF?=
 =?us-ascii?Q?W5eH4DArpMoiYj8nVcIEPw+jt89LGg4RexkjrTLWYdZyoRkdv3wqZDgy1W6L?=
 =?us-ascii?Q?u7hb8tZUXzvzaBIWuFm0i2H4n1edwXLRdrc483zUf0tfM1j8dIaDdBPRS1QR?=
 =?us-ascii?Q?33hcD//XTt6iDg6RzQRC9SbNBP8zLf80nlPixtNP4a83jWtyerYqvCi37/LA?=
 =?us-ascii?Q?86ewxR2XsDw8uW20h4bLfgx6m3YQBZ6BEkyuPLuzQsBCE3mDMyWTVRtCe1y9?=
 =?us-ascii?Q?Cz2V5QvEOnTKmmKyiSJSa2jBoZfIs2sqe5i3zVRmAAbsCz+ZMxLfoVjfx+IM?=
 =?us-ascii?Q?OM3DLxvtpJkRJ/VejVGCHt6ZDpCMxwsTQp9B64b9p/ijl0jJEPj9UcmXYeV/?=
 =?us-ascii?Q?qmZwLJukz/ukXqUUwjlmpG2cL9POP/xpHNP0TtEW7FY0SUP4mlEyN6dUlhnv?=
 =?us-ascii?Q?SDFei1Og8F9q9g+BDH0M8M7PqHjexcv2BittFah80VUlaWox7v0TpteMPwwI?=
 =?us-ascii?Q?U4GJx+v4e3xFBNRqDYV3Q74dZYnepRx9HDXEtr0nCdItv82w+QcIURotZagi?=
 =?us-ascii?Q?rXLhdEtIcnlr5SWvDNJNCM0/H2X9PkF5LBLX0RMxl9iscjQvlMPbyxeWL7kK?=
 =?us-ascii?Q?ijb76m5J3DrJFni5jgdldWRWNY3VXtINHuFc2fd7yF4Xx9/wUPZ6/DU/CJlv?=
 =?us-ascii?Q?0HOh+9aAVKqnachTaqUMIUWneQ7cX8thoBip9IzuJRZTjDRdh2LqHOs1Y5SA?=
 =?us-ascii?Q?8usqDJRJTC6hGFwtq25xgbeihodO6IMMrO7hWUncQo5J23rUc7prADKlrtL5?=
 =?us-ascii?Q?SIdJYvDkQr/sYf/tu9OARljnkCeezLJCIbMKqJrjKtWYNWQ/ISd0QLGPdtQX?=
 =?us-ascii?Q?iGOM7u2ho5WdiwsaVLa1X3VEm0e7v6yFH4OGiJhIrym9IX4BFM2IuUv1RNIw?=
 =?us-ascii?Q?N4tOQcJp1r0Ap2FFi7MG87OSjFRUgLASWKx7XXHs3vmfbpTtIq++GD/wAKVG?=
 =?us-ascii?Q?JAwdxpDGReHG3+GpiTDlFM5JuQTy9cIJ6o0YxHaZUjSf9GCQ6YJm2QQCNI9y?=
 =?us-ascii?Q?77YAJ1ZZC0qp6Hg49Dsww42cp9B9RhqFxcP2sFf8c3VidXptoGHEOFROqF4O?=
 =?us-ascii?Q?jmr1xsbYPBPdIKvRdxXT90q6N5HzY/Mzauo5oBB0dOE8ek5yF92hD4BFptiV?=
 =?us-ascii?Q?gBUV2geLvYX9ItqvnTt/dxAEPZYZkv/KA31i1HMMPtzNzxShVMweBwiWaphp?=
 =?us-ascii?Q?BUVHjdzYroKyvKUzDpA97/mbXJRkxjnIiyW1yNr1N78TprmxDUKuPFAKKGJf?=
 =?us-ascii?Q?uYUws7HFSeE6RjqaIRqE4jWgB3UQFdk=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9c15b0f-0c3b-4304-5102-08da3539768f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2022 23:36:55.1732
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RrantO96apQNRRZmV2Uw3LovxiHXDokjmEpNMOoQfAds/Xrm9/sGFTaVvSWg0NvtNh0C3lb47NSTLeZ/+n8c6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4972
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set completes the picture described by
'[RFC,devicetree] of: property: mark "interrupts" as optional for fw_devlink'
https://patchwork.kernel.org/project/netdevbpf/patch/20220513201243.2381133-1-vladimir.oltean@nxp.com/

I've CCed non-networking maintainers just in case they want to gain a
better understanding. If not, apologies and please ignore the rest.



My use case is to migrate a PHY driver from poll mode to interrupt mode
without breaking compatibility between new device trees and old kernels
which did not have a driver for that IRQ parent, and therefore (for
things to work) did not even have that interrupt listed in the "vintage
correct" DT blobs. Note that current kernels as of today are also
"old kernels" in this description.

Creating some degree of compatibility has multiple components.

1. A PHY driver must eventually give up waiting for an IRQ provider,
   since the dependency is optional and it can fall back to poll mode.
   This is currently supported thanks to commit 74befa447e68 ("net:
   mdio: don't defer probe forever if PHY IRQ provider is missing").

2. Before it finally gives up, the PHY driver has a transient phase of
   returning -EPROBE_DEFER. That transient phase causes some breakage
   which is handled by this patch set, details below.

3. PHY device probing and Ethernet controller finding it and connecting
   to it are async events. When both happen during probing, the problem
   is that finding the PHY fails if the PHY defers probe, which results
   in a missing PHY rather than waiting for it. Unfortunately there is
   no universal way to address this problem, because the majority of
   Ethernet drivers do not connect to the PHY during probe. So the
   problem is fixed only for the driver that is of interest to me in
   this context, DSA, and with special API exported by phylink
   specifically for this purpose, to limit the impact on other drivers.

Note that drivers that connect to the PHY at ndo_open are superficially
"fixed" by the patch at step 1 alone, and therefore don't need the
mechanism introduced in phylink here. This is because of the larger span
of time between PHY probe and opening the network interface (typically
initiated by user space). But this is the catch, nfsroot and other
in-kernel networking users can also open the net device, and this will
still expose the EPROBE_DEFER as a hard error for this second kind of
drivers. I don't know how to fix that. From this POV, it's better to do
what DSA does (connect to the PHY on probe).

Vladimir Oltean (2):
  net: phylink: allow PHY driver to defer probe when connecting via OF
    node
  net: dsa: wait for PHY to defer probe

 drivers/net/phy/phylink.c | 73 ++++++++++++++++++++++++++++++---------
 include/linux/phylink.h   |  2 ++
 net/dsa/dsa2.c            |  2 ++
 net/dsa/port.c            |  6 ++--
 net/dsa/slave.c           | 10 +++---
 5 files changed, 70 insertions(+), 23 deletions(-)

-- 
2.25.1

