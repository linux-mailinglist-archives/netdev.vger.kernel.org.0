Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 927A1610414
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 23:12:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236801AbiJ0VLh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 17:11:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236640AbiJ0VLQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 17:11:16 -0400
Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02on2058.outbound.protection.outlook.com [40.107.247.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E2E510D3
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 14:08:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FUQfREV3rWi+v8gB3OVGjn93l3GhwlD5kfio/HZ109+q75pcN01g8LnpSBqrOcq0eIJorcj0nGAtR2hY6IfN0R0c5DePqOO7/S0toFA4Qu9v4TqwpbSduLYakx6bue/VfjoSsUJy79yx8BkmsweH1UvNwt2x7IILxpU73LZqkaNzKIF0aDMx74NTVKvOFcYgkZVOeMMkmcDINbtqUKTjhcw5TbezfbAZd9zFK+FggKgj1ZlYT4aMGSjl4S7ACJHIXMaXWJtb+6l3cgEvQzLgmEAODB0v78qfL6UTmO2vGO/BnCVa3P39QRHa8UpHZMdiD9l6Xos7kY1WbXJaY7kGuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UKzo2tdthqAKr/956COI6+FEfegIuXqj+F8JQlb2dKk=;
 b=AJFsa+RLpTQxyGD9/VLYqJSIgnQ+hsL/dacy2SRAKmRlB23AvGlnjufogcglyy063dnAJhb7bFj2QzDvE3xxR5chu7HLBh37XiZmZUsptDtQerxn/tBVRWkGzuOo6WKcjiwrd2SqpG7VuXxocY8lTN5mi4TJkHZ7V8h9K4+xCUkTF9w8+S3c0w1xY35TIEbRpNKLFiJq5z3ewxhoIqe/xdztd/0jhH0z1z0Et1ccDjwRBj/p0hHWPuGQqGK9ggnBHSQThVzSZi6FuvgI1QacI+FeaJDo0ahzCaARRfN5D2tHIxEKpmf/WtOE3EF+f5VEdqx0nTKbtulIEzzgs3OpPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UKzo2tdthqAKr/956COI6+FEfegIuXqj+F8JQlb2dKk=;
 b=jTlto+Rvn+nwZcFIrv6ROb5Y4vHoYdr95TuhmIlwSBe//nizC20dSU6MzjjWzGs3FhyeSBHolgZ1CFEaLfIP4NKS0xwICdxcIF7h37iRpiOywqHQETViZD/CLf9ttzlz5eWufTnoIWH6kQhA4FTLUCG9tIGkXAyR9PN8fX+VBX0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB8575.eurprd04.prod.outlook.com (2603:10a6:102:216::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.14; Thu, 27 Oct
 2022 21:08:42 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::6710:c5fd:bc88:2035]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::6710:c5fd:bc88:2035%6]) with mapi id 15.20.5746.028; Thu, 27 Oct 2022
 21:08:42 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michael Walle <michael@walle.cc>,
        Heiko Thiery <heiko.thiery@gmail.com>
Subject: [RFC PATCH net-next 0/3] Autoload DSA tagging driver when dynamically changing protocol
Date:   Fri, 28 Oct 2022 00:08:27 +0300
Message-Id: <20221027210830.3577793-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4P190CA0002.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:200:56::12) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PAXPR04MB8575:EE_
X-MS-Office365-Filtering-Correlation-Id: 224a9ddc-d6e4-4ad5-387a-08dab85f6d12
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PoYt7SBEO3q92eiwJDD5B63MnwWgr1bTlcF/m9MZ/+ESS4jn6YyoGE65GKrYRLUnLTpk2kPQStO1j7l8Byvi49eVuqLoAoLYHBM9oNmL529MSwrn+h6IJcfexmCWExYF2w8kgf4X1XPozAoVaNDddlkxO9HHfg+XgMio+HF7wGazj9FrTJn4oS6TmZvgxRJ0ZpuV3nDSsRwfJgg/+AhLjffUnCGMtopU7NKk1PerHMbhegiQjLsbfLbgqSuCuip2mtQ+nbbAGMnEkE65teSBrOl3iJRwQz5vZkG4f7Ow6YuNDKweeX7cl73LkhqMLsVfQOvK8aQlfYZMpdUVPrpuJFvnHBh2yJrQDTIJQdIZPkIflTWQ31H5UaXXKGETcWtjnznoBXcAUElGLijaGfxZ6++55DAlyOBFUn5GOTc0toOwYv8GQ2BnfyGtKnmgAJV7BLcKBDdx+AOdK+LLIdUGFUYOu5cyLbVg4jr2+84o6DFNECSpdiNGddip9jertWB9dG5qVfRaSBeBdWggI5U34KFU7T4rRE1l780mJpgBzkqXZV/TM6eEq6jR0yrywmOXiPWS9mZvERp2MZ/2uizZvJr3yUavYmzY9d11hPgC1Xbjp1oWQ/zVWxVdcDZJxTCOnDsrWBteH17fR+W58WzQEOReVHAo5ytZUc+rGAUyyG/Z7/Kmlds/bbOJDwICTZlivupYcBmY76k06FG/x6J8IPNMToPjBoC64xp+TrnUB+IUPgTTrorV3yXrf9heNmEMce+NNxxjy4VWdxk7mNH8AwojBjbuEF/UVZFc/g4yGXxfr/M76rx9pERmd/wlxuLTY074xvzAeQeFigXVLCFaDw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(366004)(376002)(396003)(136003)(451199015)(83380400001)(41300700001)(86362001)(38100700002)(6512007)(38350700002)(7416002)(5660300002)(2906002)(4326008)(66946007)(66556008)(66476007)(8936002)(44832011)(6506007)(52116002)(6666004)(478600001)(2616005)(186003)(54906003)(26005)(1076003)(316002)(8676002)(966005)(6486002)(6916009)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hib6CKK19GWiN4Ha5RZ9Ef2hnh6+hoL39aLyTwS/wydFb5PuaHQjNy172dc3?=
 =?us-ascii?Q?1cD7JKkUdm4eAdXWTWVjqDxxjb9RKQXn44/4mXyeuczYWN+6jz+2tsNMBz0N?=
 =?us-ascii?Q?Bq+0MirSWWzugj/J3q586rurM9TblZ3rpxBtgIVx9gqaP3oZ+BA7lGPNg13X?=
 =?us-ascii?Q?Eh75yR0t1NnMxhkC/PgiUVvL6WebyAOYFEQfvKYMtfgiuYF34LrjwEfs7oC/?=
 =?us-ascii?Q?9ywfDRkPTK1LzYhoJurfo6zai+fIeSLuAbL32v+CG7rQrk3OqbYIsoz0e1HD?=
 =?us-ascii?Q?6fPVDAfQpi9fmp4sks1JXTGEWZeuZzuhELPZQL3XNXSsUEMwa+rKYlDgKCnW?=
 =?us-ascii?Q?oDhhBPCNoC18Scncux7NccbkPPCdyplYmWx3NQka6mZcpZu+mBIF4UNLCPsG?=
 =?us-ascii?Q?wu6XuhmVbqkeva7IxZy2IczEMHBRfNKcmlUhInbEuEBxVGuTA0nuyxkwA0iS?=
 =?us-ascii?Q?aIeYHnPErltSOPKc/KAAxGOXybc+B43y/eNdZLAhMGeTl28bpciLNmjayGkf?=
 =?us-ascii?Q?z6o/bBbZzK3HiXfQTWhsztbEtTj7ybqSdteJdm83fpAyGC2nYI0eP5TTxWdn?=
 =?us-ascii?Q?lel/4lQQ3BVERlSPJdmk/w/49VQdv+vFXmVbuGb5P3peYtVJXCzvG5m+aep6?=
 =?us-ascii?Q?o+gQXHPFTsfPAXKN7NuHpOULcK+o2n7+Dk+Tc8t3IeGbNxB/VViYP31TCGPh?=
 =?us-ascii?Q?uyxLlixVXqtti8v/eYrgB2sejZYlKhMH6H0XprVib5FtkFadvDUVG0ikWxBS?=
 =?us-ascii?Q?kItVK2V1G0ItgPfDDPFjtuhLqFrG45etqvRuuV5y80G1Z6pr4qCC+m8xpbEz?=
 =?us-ascii?Q?33+6ZZ2raPfgWpXHDl2XZmWqaxY2keugNLfiB+17yeklivEJ8drvCeki/phg?=
 =?us-ascii?Q?1VJjAqGSN611rXLceAVzZaQxps64MK4FRYXFoywUFxgVf3yiTYd6/WWE7YsY?=
 =?us-ascii?Q?M4zOVmJsSUuNiwVTMJP9gN6a9su0XO3jcL7jAwyhn9Azjn1D/iBZJI9WtJaf?=
 =?us-ascii?Q?z+Vb5DDZSTbOnBEGxpDJs1y+8zd0OM6GYeR2WFiIGdac5h6MJeybJNxk0ufH?=
 =?us-ascii?Q?qa9gNFjO4t6zj4+sNDsiV4uC923jQKmwDwr4KD4EqLtcgPlklNAEDyKR/DKB?=
 =?us-ascii?Q?QA2JKgt4dZzKfLXHxo9ITEj1WN4EVK+2icfC3Ln4GiVM31+rjSGKKsIQ7tCc?=
 =?us-ascii?Q?l7til9nFiXgIpPKt6Vfpfc3MEZE/vEnDyBS4/k/iyps7JuYY3d6rCepZJHaz?=
 =?us-ascii?Q?hQvucSFZJmDc8XHOm5aRy7XcM2kxYURua5T7kKSRjhed0RVc0BSFuCW1FHcE?=
 =?us-ascii?Q?rpyk3gi5xLYhOdpaHPBgcVUDNbf0SqOzWSjAd6VRjvOuveK3I3tCMr/uEqt9?=
 =?us-ascii?Q?9juYa/oJ//9u45q+hSUJJJ6rbBUZ9FBL/sdsVyI22PJRxfLS/mSPmDRCEcrq?=
 =?us-ascii?Q?JFWKor69RIxJYfUOKfkqmRfIXxGPSGxc9TZQWtoe3niBO9+84av0zH9KkMAV?=
 =?us-ascii?Q?W3n4EHLYAZAlSvhu4xbfGkjaJ2OdlmIOXu2YER/IJiQtAz+LJyKg80yRFFaU?=
 =?us-ascii?Q?1rjonX3ChqLmCBvcwn2FEU/dzQiVQLImOyIpO/2yOjYcRv/0Z1jIF+gbe+py?=
 =?us-ascii?Q?lg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 224a9ddc-d6e4-4ad5-387a-08dab85f6d12
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2022 21:08:41.9848
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bQlAks9rjrxN3Wj6sOfJrKJ0LcdBwyTFZhToI99EjFQ17pA3RVNBhIHsc2n7HVhsfivGNKSSfzzJ5mvnw9lp1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8575
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set solves the issue reported by Michael and Heiko here:
https://lore.kernel.org/lkml/20221027113248.420216-1-michael@walle.cc/
making full use of Michael's suggestion of having two modaliases: one
gets used for loading the tagging protocol when it's the default one
reported by the switch driver, the other gets loaded at user's request,
by name.

  # modinfo tag_ocelot_8021q
  filename:       /lib/modules/6.1.0-rc2+/kernel/net/dsa/tag_ocelot_8021q.ko
  alias:          dsa_tag-ocelot-8021q
  alias:          dsa_tag-20
  license:        GPL v2
  depends:        dsa_core
  intree:         Y
  name:           tag_ocelot_8021q
  vermagic:       6.1.0-rc2+ SMP preempt mod_unload modversions aarch64

Tested on NXP LS1028A-RDB with the following device tree addition:

&mscc_felix_port4 {
	dsa-tag-protocol = "ocelot-8021q";
};

&mscc_felix_port5 {
	dsa-tag-protocol = "ocelot-8021q";
};

CONFIG_NET_DSA and everything that depends on it is built as module.
Everything auto-loads, and "cat /sys/class/net/eno2/dsa/tagging" shows
"ocelot-8021q". Traffic works as well.

Note: I included patch 1/3 because I secretly want to see if the
patchwork build tests pass :) But I also submitted it separately to
"net" already, and without it, patch 3/3 doesn't apply to current net-next.
So if you want to leave comments on 1/3, make sure to leave them here:
https://patchwork.kernel.org/project/netdevbpf/patch/20221027145439.3086017-1-vladimir.oltean@nxp.com/

Vladimir Oltean (3):
  net: dsa: fall back to default tagger if we can't load the one from DT
  net: dsa: provide a second modalias to tag proto drivers based on
    their name
  net: dsa: autoload tag driver module on tagging protocol change

 include/net/dsa.h          |  5 +++--
 net/dsa/dsa.c              |  8 +++++---
 net/dsa/dsa2.c             | 15 +++++++++++----
 net/dsa/dsa_priv.h         |  4 ++--
 net/dsa/master.c           |  4 ++--
 net/dsa/tag_ar9331.c       |  6 ++++--
 net/dsa/tag_brcm.c         | 16 ++++++++++------
 net/dsa/tag_dsa.c          | 11 +++++++----
 net/dsa/tag_gswip.c        |  6 ++++--
 net/dsa/tag_hellcreek.c    |  6 ++++--
 net/dsa/tag_ksz.c          | 21 +++++++++++++--------
 net/dsa/tag_lan9303.c      |  6 ++++--
 net/dsa/tag_mtk.c          |  6 ++++--
 net/dsa/tag_ocelot.c       | 11 +++++++----
 net/dsa/tag_ocelot_8021q.c |  6 ++++--
 net/dsa/tag_qca.c          |  6 ++++--
 net/dsa/tag_rtl4_a.c       |  6 ++++--
 net/dsa/tag_rtl8_4.c       |  7 +++++--
 net/dsa/tag_rzn1_a5psw.c   |  6 ++++--
 net/dsa/tag_sja1105.c      | 11 +++++++----
 net/dsa/tag_trailer.c      |  6 ++++--
 net/dsa/tag_xrs700x.c      |  6 ++++--
 22 files changed, 116 insertions(+), 63 deletions(-)

-- 
2.34.1

