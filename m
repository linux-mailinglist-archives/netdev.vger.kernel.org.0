Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FAAB51EE86
	for <lists+netdev@lfdr.de>; Sun,  8 May 2022 17:28:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234776AbiEHPbZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 11:31:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234692AbiEHPbW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 11:31:22 -0400
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10053.outbound.protection.outlook.com [40.107.1.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B675B87
        for <netdev@vger.kernel.org>; Sun,  8 May 2022 08:27:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ifojmx0iXa2WW5i/8UEiE3creYOZjqWY6G9c5lY1DQjvYXPGfBrhvXBpZzFJF0ZpWwYJg6vAjl82HNxhFxaxOhn2Lr/y9jMyJvtHu8IHIhuakEGAYQ5Yd2fUrRTh73korewSh7yL20jCKZfvT2Cv5CnfFqBllbvIsueMl55s5XGlR/pISi1iVGt6eNtLCQz8Li0AIU4Slr27VGG6S9N56nhU6Yu/lCYTaB8Uez5sQDhQx8JkNUuFrvGJn0Fbx3Zf2R/9Oz6v79tOs6fGMxjHdWCnddDPuQxpV7YXQOs8cBCiDgvdw+EueUHQ//HkHUV/KSUtnrafiAgoBTqyy+uCdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mkUDeRx/lQkOUQ9Kjd4o8j+lRRfj24+9s9WIi03Zvjk=;
 b=W00IjnQgCTkgGA74gLr1qgVuLTGPqhlowdN3HzBYPoVPbi89nWpHRRrGm/FX9vNjIQMay8RuwIHpboCtI/7y183Ufepun98/hGjNYc4sg4+d14kMFFYV9GGmCWzi0unf5g969tby/1ycZCvx54gzcciU82EEzakRHMDq7hA0ilEWDIoNshYbC55HD7GGyBQrfxjd68QhKxl7CU/h5eLcVcuD/Gu5IVLLAfJLuiI9HtvywsD1k7aMivmMPsB3U4NKKIQw98fKw3Uue7fiuepZU67/dzaY0hNOeLrmWtOqm6qYLcruQNmPtl1v+pPXCULveVWzbi6tLm5Uu7/JGFlDmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mkUDeRx/lQkOUQ9Kjd4o8j+lRRfj24+9s9WIi03Zvjk=;
 b=rmIcZryUXnYft65f7wOuA9WWOE1wiyOE3SceUZoDu5x8gYTgJ1q5fkgF04tirzl6QwsCrLsWBhjijo12x8/jHlZZd05QH3m96rdm5VSfPjPcs/RmrrBwhy1Rv3pQRBMm1rRCBIgFZ8teYtZyA94fSBWGrPK3rwbc9CbtvCNe3+o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by DB6PR0402MB2806.eurprd04.prod.outlook.com (2603:10a6:4:97::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.22; Sun, 8 May
 2022 15:27:28 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::d42:c23c:780e:78eb]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::d42:c23c:780e:78eb%4]) with mapi id 15.20.5227.022; Sun, 8 May 2022
 15:27:28 +0000
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
        Tobias Waldekranz <tobias@waldekranz.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Colin Foster <colin.foster@in-advantage.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [RFC PATCH net-next 0/8] DSA changes for multiple CPU ports (part 1)
Date:   Sun,  8 May 2022 18:27:05 +0300
Message-Id: <20220508152713.2704662-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS8PR04CA0205.eurprd04.prod.outlook.com
 (2603:10a6:20b:2f3::30) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: adc10bcd-7a6d-43f8-5c96-08da310742e4
X-MS-TrafficTypeDiagnostic: DB6PR0402MB2806:EE_
X-Microsoft-Antispam-PRVS: <DB6PR0402MB2806447E75CD2610E417EEE3E0C79@DB6PR0402MB2806.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kegKF50EajWHnXDX3fZjR9redTa9WED64M862IeU0w6sLo08VrhaNJEKU+44RizKRiue7phOZ79wiT34n/odP8kYlBz/ExdDHkyhGnJ/2qLePoKWBskYBgG1T10ht88p7jWtVZ5u5Fuv3fEEUNUJzgTm0fVRJ4St9xI+6n5Q5Q5GSmoGmgTaq1AsfIuaMWuxX9hkH6h9w5BkPrc6Fhdg3kTn8ECRzA6+irVi4ThCy9XZp3GhmD+p9AIJs/TSCU/cc9widALrsyU3UbxnyptZ8KK14/BsBg7/IPzCnavC3T9KmuIX5ZBkJm0pymuHwS3OrbufP9z5EC4Ns2toe0Ft0Pyh2f5oKJ1l6xhVdTMEMZTZYPfEak6S6llvFaddkFmV5Srv78aDyg1b6cBbdiA4itb21MYKsdwBSHwPld6Ql1fDXGCFtzX0AgIHlSyid9gzr9ssz9L5nTF8MfLgWs2e4aX0ZMMOuY/N4oxJrdUzo/gz29QVFvLLNntrLabRGX8nFs6sCjzA2ZduY7q8I/puYLKVRSwcCqRHTEULUft6Y1VGWtZAYtmFFjxLQPDBdNT+ca9Y7NTW7n4drBNX14o/oaIUCPJFJ8hGPsbeVEiPk3O++YkUjvgft44hU8NFzj42o8xKAhQb7sMshttsfGPT6HQYEpHS9iJ9W5gvM1HSDLBqKzokc0kSlA4GA6p2vuhV6w+Nx5Q/Nze3qNIIX8k+PR+fgbPOAtzvRMn7dp0OgQ2JBEEorifxNAfZgRvLC+5afqMaZOKzuO9OZRT+wEzw14ogpgGsuKvFSt4iq3UMhLk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(52116002)(6666004)(6506007)(36756003)(186003)(508600001)(6486002)(966005)(2906002)(38100700002)(38350700002)(5660300002)(6916009)(66946007)(26005)(1076003)(44832011)(7416002)(8936002)(54906003)(66556008)(8676002)(4326008)(83380400001)(86362001)(66476007)(6512007)(2616005)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZKZx/mcIeF+x+TNEJx1ECtEdu6BXefuw0oY7c9kE9AereEZUo8vG7tXSE/Vk?=
 =?us-ascii?Q?QGEDbhRU+ZCrIVLI7zfEZB0rkGIP+HDEsfpINQXNRgSk/D5sT4C1fzzD1iLI?=
 =?us-ascii?Q?GSBcR9wbiqu+Uv69o7XisSCzZ7n3VMjcYSprcLuis1OBJxSq4d8E04oQsRah?=
 =?us-ascii?Q?sTMpimfb+F4Kh3nNzo/ytuLhtI5lP8QXt/3B5xpkKY7dNJCUH7AYZ5FRLs6S?=
 =?us-ascii?Q?8QZ7F0ChEYkr4C0NozAnGsKR9uE6g51yKlQZxU7xqDO+kVYBg6KMz7vpa119?=
 =?us-ascii?Q?8ThfSFKMh8S1yBSI+HYO+7jTjOLbOiq4NVsF3uq8e8caGrXW4/8mcxpc0zia?=
 =?us-ascii?Q?GMDIYiXZL7EhamtPcAQUDhPiBCoQg36jOKKuWxFA6EID5RsAgsKfYI2VxvVA?=
 =?us-ascii?Q?JJvdq7yXRomG4epNLtinASg2cqGBpnJZzic9t2wxvDjItmrzq/eg6rsXAVyA?=
 =?us-ascii?Q?wLOAmdIOJIo3x8bp/ho5dG2WQNGbSbkIYJb6uxTdGx90wKOhLLUa/BuZUaSZ?=
 =?us-ascii?Q?DWBbVLtw8Rrwuh2tB/N7L1RnkQdk7pUB1HlxTaGEolCo1pRtzqMXPy7QoFzg?=
 =?us-ascii?Q?qV6dxxEvMstC+KR7zY3Yw/5srRbojJeWN6RmJVhzb+ig/VGHLnNoHsaENKKO?=
 =?us-ascii?Q?LGF7SeW6mclbvBZtZNXOrqnWvIp/gVxRIWoG/f5mUWjse7kH1AerG5Jf52Dz?=
 =?us-ascii?Q?EcGJGzykNkNYkbXJyC6wLiMsJNoLbRl3ptmUaHfwdxHSQQNyzZZIIBP82WpE?=
 =?us-ascii?Q?o6hRdKrJETzZxT5Z/tsVaqGqHs8qppJfDJPBINakT3uwX1y8/3A1THO8V8PM?=
 =?us-ascii?Q?kc9NsJiOlgxdXJZBak+50xuK8J0EM1b5FtnqkpYW9+TBz1m3hasw7Gv2Nr9+?=
 =?us-ascii?Q?LXptdtpp7aBk3LATxlDza4yaDy51H/eRspbfe3cCKsPVCFLiPFn3zDejq7pf?=
 =?us-ascii?Q?aZqfXEkP2N8se1zYdW0XVZU6SBQO5wtOZHItrd69m+ZJFD12b7qBuyeiAhOp?=
 =?us-ascii?Q?dzWQxzJz1SVVVKEJIeQ5uqcAXOjFGlJV8yqrr/Mx8huSUucTO3sJ4/BoFEWx?=
 =?us-ascii?Q?z+Q09MUo6zd0CkZzfKPEwGQ7IO1in3SBPIFTUuPkusr8kC9qTTCz0KCYCi9u?=
 =?us-ascii?Q?6mMtxWm1e1CC2etCRiWjfWmampiG6TpSDzSrGemWI75VP37cVuKIvv7xcScC?=
 =?us-ascii?Q?W+9zQec/xR5d0t4xIgLf2nytRZD/VokDKATvXsKfa59iAgFXuECJD7mxwFg6?=
 =?us-ascii?Q?TPuS5MX936apa5x58N4sXlNbm4tu6syCfV/aI1H/dMZ1yvMi4mlkpnoUcMxQ?=
 =?us-ascii?Q?biShOIb+xI5DXZRkrUwY5oi9I60eA3C8t05wbamUj0Vd2RSqwYSrarD3CONV?=
 =?us-ascii?Q?9lhiuf1VHtXiatj8OLoYW+RcNt03abkYw9UkG0H4/SgPCdHd7Qwv1TGI3iGX?=
 =?us-ascii?Q?n74U5qa3O0GlbrrQqI6T6mT/sNVFYHsTNXU7Idz6j5dUpCOixf+s62fbyvwC?=
 =?us-ascii?Q?j5+wfzf3azOok3j6zqZXTbTRmMVQsMwusmY9DtYDRCbE2UEtfrQV+weleQ5J?=
 =?us-ascii?Q?Hb5NEL6+DgGrigcRyXCF/F3Wwi7td6YiaBRb+FPg0bM+qxzzpEg6UoD2n8Qi?=
 =?us-ascii?Q?LYXpn6DDMh/QD0BxLl7v6C/+rD+ZSSLXXL5xiTiI1LYN8v2OHfzxeKzIqIKt?=
 =?us-ascii?Q?oh8spG26Sa5JDHLfWYMBVsgS9B3bcszmima5QTOId7a15qOmJ5lC6dqqSXVc?=
 =?us-ascii?Q?wJHmrCxT9KUbHC3vCcL2AcuQsulGPb8=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: adc10bcd-7a6d-43f8-5c96-08da310742e4
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2022 15:27:28.5953
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: usNsLNZ4DPpy5r+TfRn2G7x4niWDx9JlHj+CNYLkdrR4SZCmsI4/uXAW3uIGBmtgcOFI/Jqil1cn/SCjJ8t6cw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0402MB2806
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some may know that I am trying to enable the second internal port pair
from the NXP LS1028A Felix switch for DSA-tagged traffic via "ocelot-8021q".

This series represents part 1 (of an unknown number) of that effort.
It does some preparation work, like managing host flooding in DSA via a
dedicated method, and removing the CPU port as argument from the tagging
protocol change procedure.

In terms of driver-specific changes, it reworks the 2 tag protocol
implementations in the Felix driver to have a structured data format.
It enables host flooding towards all tag_8021q CPU ports. It dynamically
updates the tag_8021q CPU port used for traps. It also fixes a bug
introduced by a previous refactoring/oversimplification commit in
net-next.

For those interested, I've pushed my WIP branch here:
https://github.com/vladimiroltean/linux/commits/dsa-multiple-cpu-ports
It shows the more complete picture, but I haven't tested it nearly
enough, it just shows the rough shape of where I'd like to bring things.
Feedback is welcome.

Vladimir Oltean (8):
  net: dsa: felix: program host FDB entries towards PGID_CPU for
    tag_8021q too
  net: dsa: felix: bring the NPI port indirection for host MDBs to
    surface
  net: dsa: felix: bring the NPI port indirection for host flooding to
    surface
  net: dsa: introduce the dsa_cpu_ports() helper
  net: dsa: felix: manage host flooding using a specific driver callback
  net: dsa: remove port argument from ->change_tag_protocol()
  net: dsa: felix: dynamically determine tag_8021q CPU port for traps
  net: dsa: felix: reimplement tagging protocol change with function
    pointers

 drivers/net/dsa/mv88e6xxx/chip.c    |  22 +-
 drivers/net/dsa/ocelot/felix.c      | 469 +++++++++++++++-------------
 drivers/net/dsa/ocelot/felix.h      |  16 +
 drivers/net/dsa/realtek/rtl8365mb.c |   2 +-
 drivers/net/ethernet/mscc/ocelot.c  |  16 +-
 include/net/dsa.h                   |  19 +-
 net/dsa/dsa2.c                      |  18 +-
 net/dsa/dsa_priv.h                  |   1 +
 net/dsa/port.c                      |   8 +
 net/dsa/slave.c                     |  36 +--
 net/dsa/switch.c                    |  10 +-
 11 files changed, 337 insertions(+), 280 deletions(-)

-- 
2.25.1

