Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D81F50B4CD
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 12:16:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446304AbiDVKSR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 06:18:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233775AbiDVKSO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 06:18:14 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2079.outbound.protection.outlook.com [40.107.104.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC81C1EC58
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 03:15:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fmCGtsnF9qSswV9TDzQK/9bcfLzk7Sl8+Pvlv0iQnTuooiZp955ltsHJb8K11KA8diNkfMhbyTRGSr+Te/W12SRa4TIRJyHenXDb/PqwdrSNq6mZ3ZpyxHRuSHpLV8t3CwNEXyBp6QlDbBQMeuIdBsHG8HPNI/WPyLlkHW5ToZW+5E6nRxI9f8vMBQluBCL41jpORGX3ZZyY8WU0/rSyInNCiaIV8hPgxZzCKHabg1opyUWDEEgGNZ7hzq9WE9n0OYKVIw9imEfcRaFM19oYAmdH7rOtOH6Ey8jD46CN/k1cb+u/O9YJkXG25Ch25Qk5DPu612ItRlQknMq5upIRvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zk6cw08gik0HT7j4tE4PqjxA8wDxTgHgHV7Sw6d82ko=;
 b=SooEGBWovJpk0c4h218/3qW6c1nzqaHHLSL7w4/SVsR1W8rIxccdJ9S8eqpftCY9t4IJ7VlMpyAql8Rr28c3ueg7OTeCBSbRnzWkNIEglXl4eKGq5QD0oFV1cp/REjQyWq/eEbvht1kxN+k9BhC5iB0QOWa58r+TSjWy2Lsy2vT1nzx+ONytaRfSzLBGa3EKjwb3d6jfX4mfmoCm1qgZHNMWkvaCje2ZGJumWkfovcl8ls0bIn3RqSpN8Cmm+6hki+bYkASaI3bHAEcB9ed/75KPaEBh4De9AekmQTcPDiyft9zzApIyw1i7zF50Ln4vli8IR0wOSvZgSn4F17jdfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zk6cw08gik0HT7j4tE4PqjxA8wDxTgHgHV7Sw6d82ko=;
 b=sAdXuShH8OY2ru6PJYFfDE1F69AL24mEFxkvCybi1nALpn7aqajAe2CuW5JySEWwjduHuJM90fMppUp9sVXscvi4pFdmqY4JSpTMU/xZrUW1CX6u+g5Ib5x+NWwu4j99pfMDA0yxMTUt87WJpczxht1b/3d/w58csk1Xc+5s0BM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB6836.eurprd04.prod.outlook.com (2603:10a6:208:187::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Fri, 22 Apr
 2022 10:15:19 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e%3]) with mapi id 15.20.5164.025; Fri, 22 Apr 2022
 10:15:19 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Mattias Forsblad <mattias.forsblad@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Joachim Wiberg <troglobit@gmail.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH net-next 0/8] DSA selftests
Date:   Fri, 22 Apr 2022 13:14:56 +0300
Message-Id: <20220422101504.3729309-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P195CA0057.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:802:5a::46) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 17f1f3d4-9f99-4c61-03aa-08da244900f0
X-MS-TrafficTypeDiagnostic: AM0PR04MB6836:EE_
X-Microsoft-Antispam-PRVS: <AM0PR04MB68366176C85EE293364EF811E0F79@AM0PR04MB6836.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tk2N3NMOqlHEie4SwSncNlroQvzVUb/C/1utGR3csJ5KhuVT8KeTpiY7Tdjo35hnIKuEAKjkl0Y+JhYvxaudGSWUppRff2JIKdj/rYBtIlFJYPjr1hBUYq7l6OPYXTNtpa4iwzkNIEekAMQ9NV2DrjTksjp0N+YcfEDB1LnUzR92Dege/kB/vLTAuLTJDlaLgBQj9SBNbteY3lNqeQYZfIsaTotr0rsYcW+2uOn4EzDl/MtKUCcMeULdWISuC8dGR0x8UaGLVgZTCLWgZrqYY46h2xIkH08wdaRrGrq4imLx/SwgUrCn09UKcpWayoMpInvQxQGg6OWZpCwvn7qMSmq7nvRASY9N0O6hTz2IA1WEcFJpbBV8j8Rfso2dMVjCfGlshS6z7A3qO8A9RQL39NF9KEGBP5MfPY1pk1+G7pAvEUC5psg1sg8ICnip3+eg8z5l6b0/RpFz4u0QLUqf2IW5CVVPNpcQCT3l69h+6pn37S1TEo0y+/raqxdmk0kxq3lGHe8Cj4cnZxNuHC5oe7dk4yEdt0JDVrDw5oIWukA4RvFyD5vwdTN04LzPqz2NzZ/CqwP4tSNw4hXIyJE3hp1LIrKkSMDGAsbrnvvHqlL8FznvWfM181q5yQByUVrY7Es+MhdrB+O1oKS2Bm2yG8c+bwwDM0yEWgZUVDJukTx0kGFujv62Cu100G+7dKVB0YuUPFbeuyjsj6vEZZOvZhePzw4TCzfWqj4qxh4cgQ6Y+bv0T5vhnQHQkrep9PAhkSkR5w/TWF3CjitrzLDJ13+QgdZzWmk6rFw7MuPVbLA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(38100700002)(38350700002)(7416002)(5660300002)(2616005)(52116002)(83380400001)(44832011)(966005)(66946007)(66556008)(4326008)(6512007)(6486002)(2906002)(8936002)(6506007)(66476007)(6666004)(8676002)(86362001)(6916009)(54906003)(186003)(36756003)(26005)(1076003)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?x74U2U3NyHJYNw6QiS7P4WCZzxKk1618FaAVdao6haU4L0iBsGanv0SYHa/b?=
 =?us-ascii?Q?IIj3/DwKM43m54iDaSEOEVRKO1Uy6KLfU8Y9VZ04tjTPVmZWUvV/mDwueMWa?=
 =?us-ascii?Q?ThbbyCk1flMTOS0resXtSN1ueDw9uZn0sERPo4sBhP4jPMQY0CH7Ps5DiX2w?=
 =?us-ascii?Q?EL6N3tanrIkUO/bGD0v3SpQ06s5Jp7GBla97n/q5dhUowu5wNwGMLwdynk2g?=
 =?us-ascii?Q?8op7bSlf81w08VoOdZA65cS0MNheLEwICZzm0UOknIbtphGqvoHEh2PAwBXa?=
 =?us-ascii?Q?EvXpXkYRw4cL98xD65ok9DZzww66uZSlqj5wqFUYlfWMb7vpue5GekeLOu82?=
 =?us-ascii?Q?dBrasIOGi5QgNsW0Kh9TDg8gg5z1uR+x7HDn3lNxFII1kOVVMxeCXQhVGTWZ?=
 =?us-ascii?Q?yvsStVAUEikTxy8wzma0Pt8tPU3SWKzze+tNfnbkERfi/rAHqT3h5GroR6Xm?=
 =?us-ascii?Q?zhoDCfYOaCxLawdueZ+VkWWHOsgU6NKamB3nwNFvKq0pNIXLETNkP0Jn+G/m?=
 =?us-ascii?Q?dyUSErsSkhMwZhHtNPzMMf8gjSpTIxOVvpdf5AYn2w75C6aczxjXKBTdps1p?=
 =?us-ascii?Q?8CNkMz+0Ul2YN+K9MT2yffX3LpjbQYKex63tDn5Y6i9IEa1bDaCTsYJONgAI?=
 =?us-ascii?Q?USQGimF7G6OL8y18cnVyf9mrohQm7eVO/R+0+yrfNUr1jg46VLMfvBYzgZp8?=
 =?us-ascii?Q?fXGjuNgyhsAdj93f69qFTDwKQECv09lLIE5DvVf37e39txvZFlyDvg+nU6GA?=
 =?us-ascii?Q?UtCDXJsng7pCIqQA3QMSyxYuj9nQJ2Kvubc7aiFryMw/p4NfRCM7ccSCkYgN?=
 =?us-ascii?Q?M4xyTrKFLM+Ha/wFhSzSDriyCmnVgBCSwX7q7UqQRSt2zxZ4e6zvGVuEFKO+?=
 =?us-ascii?Q?9u+RSg7JuR4QP52MnN/sZHmn4KBpPLooTHePN9b4yltD0nhWf4OR87NAvQug?=
 =?us-ascii?Q?68pBwh/osy8ukrgpdQis0UtFnIJxGmkOs0zqRXdlIYnmHCLA+yq3yRjLhWth?=
 =?us-ascii?Q?zSVYZCr4cKrL09B8KCj4vgc3gf76JU+Bdr1V83d6mv7lNnbQfNFYXvvNKEzH?=
 =?us-ascii?Q?U+4SO6IvWeKAi0AA97E7pabfLL3SgS3ZW1+hIo7SSwhHlIkGxQy+dtcjzPpQ?=
 =?us-ascii?Q?0QtfiocsSZJMxjTnH5QiftOAneGnBwoKg5N1kA1V2a/YAzNuNtbt6M4gYi5M?=
 =?us-ascii?Q?D3JzKqL4jSDxNcd6BP8CpbZPR5x9ASLnHgx2/MmYoWDrcqMDbxsYedhshUYf?=
 =?us-ascii?Q?9a8FIWOVcdnp8zA6NEcxJJuOrPFanuyxwFik4P/HUbv8EHYzC4pxdLwiFzyC?=
 =?us-ascii?Q?xqUX07Fl+3Fqlwje+4ed4RXXpIrYqYbCRPAOKCcLkGdpb1zZQdBoTcryh8ZQ?=
 =?us-ascii?Q?KqOpMfAHAae+Pm4apyXvPvZYGXpojIc3mAI3QCMMOj11Q8iDhpKgxiSY4ACp?=
 =?us-ascii?Q?WeALL7IGX6ujkdTRxCTWWRaGFLwPhKTash2D0WAbENsjJZ+Kf3bdDnGtby8D?=
 =?us-ascii?Q?nlqiYJiBQIO7TG8N9ZxNnwehAQCjQdM6/Gukf0yNiLm63sxBXWRv8GWhTAF4?=
 =?us-ascii?Q?9/dVLYGZrVDDbMNO6UbEuYKOsDwt/JlVVMWJmZ0rdoY2lmSS5ZNqMSV+RsLk?=
 =?us-ascii?Q?Wr1bl753Nrme0DY+3So1kXC3dkbNm0RFETSzva5fJkphPdhH/GgajcA69sMp?=
 =?us-ascii?Q?uOmbI/nR7/TnHpjms4GN0pPaCSR3dUX9vmPPFm7eJDG3dsJz1PWl6C31iYay?=
 =?us-ascii?Q?vrmc9of21kptygFvZXdDxTFgOMGAqzg=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17f1f3d4-9f99-4c61-03aa-08da244900f0
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2022 10:15:19.5944
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JbVDhlkUj91WPFvmi1q7pvCdos+gSjaQ4Yrq89+vCPdoL4z6/UQ9DRYtxIhiHciUrRc5GNSma63BKCGmX7Huuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6836
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When working on complex new features or reworks it becomes increasingly
difficult to ensure there aren't regressions being introduced, and
therefore it would be nice if we could go over the functionality we
already have and write some tests for it.

Verbally I know from Tobias Waldekranz that he has been working on some
selftests for DSA, yet I have never seen them, so here I am adding some
tests I have written which have been useful for me. The list is by no
means complete (it only covers elementary functionality), but it's still
good to have as a starting point. I also borrowed some refactoring
changes from Joachim Wiberg that he submitted for his "net: bridge:
forwarding of unknown IPv4/IPv6/MAC BUM traffic" series, but not the
entirety of his selftests. I now think that his selftests have some
overlap with bridge_vlan_unaware.sh and bridge_vlan_aware.sh and they
should be more tightly integrated with each other - yet I didn't do that
either :). Another issue I had with his selftests was that they jumped
straight ahead to configure brport flags on br0 (a radical new idea
still at RFC status) while we have bigger problems, and we don't have
nearly enough coverage for the *existing* functionality.

One idea introduced here which I haven't seen before is the symlinking
of relevant forwarding selftests to the selftests/drivers/net/<my-driver>/
folder, plus a forwarding.config file. I think there's some value in
having things structured this way, since the forwarding dir has so many
selftests that aren't relevant to DSA that it is a bit difficult to find
the ones that are.

While searching for applications that I could use for multicast testing
(not my domain of interest/knowledge really), I found Joachim Wiberg's
mtools, mcjoin and omping, and I tried them all with various degrees of
success. In particular, I was going to use mcjoin, but I faced some
issues getting IPv6 multicast traffic to work in a VRF, and I bothered
David Ahern about it here:
https://lore.kernel.org/netdev/97eaffb8-2125-834e-641f-c99c097b6ee2@gmail.com/t/
It seems that the problem is that this application should use
SO_BINDTODEVICE, yet it doesn't.

So I ended up patching the bare-bones mtools (msend, mreceive) forked by
Joachim from the University of Virginia's Multimedia Networks Group to
include IPv6 support, and to use SO_BINDTODEVICE. This is what I'm using
now for IPv6.

Note that mausezahn doesn't appear to do a particularly good job of
supporting IPv6 really, and I needed a program to emit the actual
IP_ADD_MEMBERSHIP calls, for dev_mc_add(), so I could test RX filtering.
Crafting the IGMP/MLD reports by hand doesn't really do the trick.
While extremely bare-bones, the mreceive application now seems to do
what I need it to.

Feedback appreciated, it is very likely that I could have done things in
a better way.

Joachim Wiberg (2):
  selftests: forwarding: add TCPDUMP_EXTRA_FLAGS to lib.sh
  selftests: forwarding: multiple instances in tcpdump helper

Vladimir Oltean (6):
  selftests: forwarding: add option to run tests with stable MAC
    addresses
  selftests: forwarding: add helpers for IP multicast group joins/leaves
  selftests: forwarding: add helper for retrieving IPv6 link-local
    address of interface
  selftests: forwarding: add a no_forwarding.sh test
  selftests: forwarding: add a test for local_termination.sh
  selftests: drivers: dsa: add a subset of forwarding selftests

 .../drivers/net/dsa/bridge_locked_port.sh     |   1 +
 .../selftests/drivers/net/dsa/bridge_mdb.sh   |   1 +
 .../selftests/drivers/net/dsa/bridge_mld.sh   |   1 +
 .../drivers/net/dsa/bridge_vlan_aware.sh      |   1 +
 .../drivers/net/dsa/bridge_vlan_mcast.sh      |   1 +
 .../drivers/net/dsa/bridge_vlan_unaware.sh    |   1 +
 .../drivers/net/dsa/forwarding.config         |   2 +
 .../testing/selftests/drivers/net/dsa/lib.sh  |   1 +
 .../drivers/net/dsa/local_termination.sh      |   1 +
 .../drivers/net/dsa/no_forwarding.sh          |   1 +
 .../drivers/net/ocelot/tc_flower_chains.sh    |  24 +-
 tools/testing/selftests/net/forwarding/lib.sh | 112 ++++++-
 .../net/forwarding/local_termination.sh       | 299 ++++++++++++++++++
 .../selftests/net/forwarding/no_forwarding.sh | 261 +++++++++++++++
 14 files changed, 687 insertions(+), 20 deletions(-)
 create mode 120000 tools/testing/selftests/drivers/net/dsa/bridge_locked_port.sh
 create mode 120000 tools/testing/selftests/drivers/net/dsa/bridge_mdb.sh
 create mode 120000 tools/testing/selftests/drivers/net/dsa/bridge_mld.sh
 create mode 120000 tools/testing/selftests/drivers/net/dsa/bridge_vlan_aware.sh
 create mode 120000 tools/testing/selftests/drivers/net/dsa/bridge_vlan_mcast.sh
 create mode 120000 tools/testing/selftests/drivers/net/dsa/bridge_vlan_unaware.sh
 create mode 100644 tools/testing/selftests/drivers/net/dsa/forwarding.config
 create mode 120000 tools/testing/selftests/drivers/net/dsa/lib.sh
 create mode 120000 tools/testing/selftests/drivers/net/dsa/local_termination.sh
 create mode 120000 tools/testing/selftests/drivers/net/dsa/no_forwarding.sh
 mode change 100644 => 100755 tools/testing/selftests/net/forwarding/lib.sh
 create mode 100755 tools/testing/selftests/net/forwarding/local_termination.sh
 create mode 100755 tools/testing/selftests/net/forwarding/no_forwarding.sh

-- 
2.25.1

