Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 348F65B4B23
	for <lists+netdev@lfdr.de>; Sun, 11 Sep 2022 03:09:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230114AbiIKBJm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Sep 2022 21:09:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230043AbiIKBI6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Sep 2022 21:08:58 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2087.outbound.protection.outlook.com [40.107.104.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 763964F676;
        Sat, 10 Sep 2022 18:08:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ksjJAF/cx2Mwvk6eVYejMjlAlCjsQN7bc9ckcXsI8o1U1oh2ENw5lvRIZ4Cu6nJzep7DItobLE/eExi3PhdWOGSFoIGGK+Z2WIo5sx1YMq3nuH5TmHpjRRG39eGkzrFFyRL4RB0upg9h6TLZiusmQtCvGIqIZPsLpj+uWws/cB+kYEVttm9LcCIVVWdj5FQ82yNuucqJ5GtAOrtC55pIq6zQ3pIRZiRmoJyNq36wfHpCePDOC3/ilxEz7YLCpWlh7y42/vIoMcgQ1dCP3Qo/p0ytzYnHyu5PQ8qKRpeIhY1ZmyIat9eYSfHvrd4JihXrWKT1lDD78i4AR9lXeD1alQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kqIkS28II0oI7SpGH2sWhIpjVyzVXKK8ibSRySzaOsk=;
 b=iEC8Ma0e3PPe3VESXIJmmXv+3MXqM/zy2+XWjX/Ub7oubGWPvWpr6hED0GrYMT5H4fXVH3hOoaO3xvfle0zKyKRO6aMFBSmlFQmRnxANAZGXkdHPDjQtHOVWDkLgaceick8iKiwcQ22e1zcHZ95+bKz71qK9yR1UtMwDWxojwEQ0yuzqSJcayapBnSkxTvW6IuzXgtctRzNJv+J1OvCODdoLQc/iy6B18w4nOAOBTFtXbRe1YnhvuRpw5te7NNgu6u+gGGMkws/mYXTxKBAntuK8NUW7kf/GKHY65rAjNRNG8XUdpLmc4rZMC7W5t6wQfLcFowAFmCKCFeYJw8Wcjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kqIkS28II0oI7SpGH2sWhIpjVyzVXKK8ibSRySzaOsk=;
 b=OpirSGCVR+/y21hOwyaMEZlfw7/L/7lIfQBM3XyRP/xZQ+FLize8uASKhdYJXwiUiQqsq7S56m5gverYNNNHFxEzdfry740zOPZ9K7mO48Tfvr97ptn1fhqyrz9AHvNxEmFGAI/opuwXB0ReNxKOI/scQ5uvvRSZz9hYa6QeK88=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com (2603:10a6:208:c1::16)
 by DBBPR04MB7739.eurprd04.prod.outlook.com (2603:10a6:10:1eb::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Sun, 11 Sep
 2022 01:08:04 +0000
Received: from AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::5d3b:4f24:dbeb:e292]) by AM0PR04MB5121.eurprd04.prod.outlook.com
 ([fe80::5d3b:4f24:dbeb:e292%5]) with mapi id 15.20.5612.020; Sun, 11 Sep 2022
 01:08:04 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Colin Foster <colin.foster@in-advantage.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH v2 net-next 09/10] docs: net: dsa: update information about multiple CPU ports
Date:   Sun, 11 Sep 2022 04:07:05 +0300
Message-Id: <20220911010706.2137967-10-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220911010706.2137967-1-vladimir.oltean@nxp.com>
References: <20220911010706.2137967-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0129.eurprd08.prod.outlook.com
 (2603:10a6:800:d4::31) To AM0PR04MB5121.eurprd04.prod.outlook.com
 (2603:10a6:208:c1::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB5121:EE_|DBBPR04MB7739:EE_
X-MS-Office365-Filtering-Correlation-Id: 516e7ce0-1e92-41d9-6c6e-08da9392145e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hvriRilXF5LoWXFB8/Ml3R8wwr0N7gk1FUxTUqJQYJi2r9NWppYIUCSB0gPufTAyRwnK1oHhdoQj04oLcFgx0NTo32ZXAYzmTeuMvdIgaId9iyh2NLI+Vj1ZNwqt5dTD9rJiRvmUqAtVWKXfDO5INChF8PSV+upaeTWDguYM5do2B3Vv8+SanU+ZAZnih4pWH0X/OeA/xTPtTTSLtpS0NhNwZRZ5qF91v0ldV+9UJwIXaUrntLjfwdbEXcDFMENBorUFbFGMMfvcvlpa4opMJrZ1GmB9SwzL34AYUh270l3EUlqedqqGM6taP2QixTIs/Nxedwz2NlHyvdTGgehQxDmCXbahaIv0qba74yyrcUYAxDdvxDrEeBUB4aiybwpph/MoxhdFOZCv/Ut0U1Ns5KOVLNHtkk5BAt90NdFDPnGbRe0TahiIvtIn1+eVTBKvqQwRYv/8kNgAQcZvQkxaAvjGW85eG7UUUcsxRV4rIkT8A5uDsndwOkt2VtijU4s8ZBVwEyhnQibiZhZ2OcoFFmZJkdonMXhmnRfvlZWmhgLTeauE2/lfRDR6m4D22OPwoMH4uhXMV8J8EeCHtt3MfUTPKlVqaow0luRYK2YwxyCWO4oF0P+bQNpU1FVDxQI5zlcB57qr4LdnH6sTkaXqz8XkTqxqBCU0tqCdQi4Ca8Oov6drM83LNr/b35KRH8+d8JjoUeyu+LWxzJpsuNUC6TsdBUaj2VPvpSLfFuYpwK/IXYpoPprLv2gO4HwfCQYIA0532uX7s4N3/Jvu0MFmKOkPMxG/2+h7zStUTazKsFo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5121.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(376002)(39860400002)(396003)(366004)(38100700002)(38350700002)(2906002)(15650500001)(44832011)(83380400001)(2616005)(186003)(1076003)(316002)(66476007)(66556008)(4326008)(8936002)(66946007)(8676002)(54906003)(6916009)(36756003)(7416002)(5660300002)(478600001)(41300700001)(52116002)(6486002)(966005)(26005)(6512007)(86362001)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Cx3HMqFFGOZeWMV9H3YWbBRMfNMOyxUTkuiMRKqhPmAnkX+WcnjOx0l4A1mY?=
 =?us-ascii?Q?GIM24aMdOTXyXYRFY8YItCfgtIXGtOb+0WxYIzE1EfZbmbXdGBkuuKQ7gM59?=
 =?us-ascii?Q?1zQwl2sxTB2ZX/picQLqLmAcnioqjvOcEQhnSpdZgjSdvPHFQ7i+x4dLNSxi?=
 =?us-ascii?Q?xe3Vh3eWJg09YgJg4bGkStTOd3ecmKsBn4i0yPpRFI57fZKD+jTvrMv6W+lk?=
 =?us-ascii?Q?aaQhx8cWo48XdbG+AngMv4qPviYQH1KL+hmOG1uYpHkTct9HBsZ+rIytYN0U?=
 =?us-ascii?Q?OAZ7CSqgrb7Nf0+iSi/4DV/XGaUW7GhKkdpAE7iFE7GuRUbGYq+Z8trOqq8g?=
 =?us-ascii?Q?dQFhZs8GcW896ek4ARcOZnbqp8XXYG92DK1iGzSAH8OethkFxHYpOhwckbcG?=
 =?us-ascii?Q?ixE0x703L6l+Aoga3w2nZph8KhXh8MBtVi3nDqKTEJF9tM7kgUAzZ9A+F74h?=
 =?us-ascii?Q?ijf3+jHVxjCVjZ4/HzSEj5vfdh7TJsnrn9dVgvQI5VvMsL69yRfwmqNGp7c7?=
 =?us-ascii?Q?xdVdL7/R/JqIfoYrtDhoFXkQTKLomseYUOOahTXzguh5Sj7IfqVeQSY3ZCsS?=
 =?us-ascii?Q?URjLo3foB1ml8XfvENFpvv/0pkqsrKtS18NtwmhC87bcRnFMAim4qYOv/jzV?=
 =?us-ascii?Q?xsdYOjkdoCpzL0bqWf0BZX4vqESbk3zzB4lkaCX9zh3w2wLMKJB3tSWRZsCf?=
 =?us-ascii?Q?tk/FizojNDl9+WUazRFPexPCp7+tR/eFks6jFjXEc7SU3ybutr2qK1grC7z3?=
 =?us-ascii?Q?GrwrINldPW4hbVYRzABvl3plEMcM+3jS/qWu2IU75a5AknWk2feSRUN24tFt?=
 =?us-ascii?Q?iTKMJoHNDYPXirUxJBQ0hfqjFXlD5IzUKpQ3Sp24aHJMvqAerWGqqv7dAfhI?=
 =?us-ascii?Q?N8TO5gg1VQVyqNoXqMaxMmEIHLE5jVjswX7FRYNHdBcGFPY3UOT40zI7ryAA?=
 =?us-ascii?Q?sTx1m7HQrCBtHUm/O8fjc/J5tXaD8OYBwo7j7RsulMiu3BR0UFCTsw+kbqd+?=
 =?us-ascii?Q?xEEIud3Ga9BSt1hiFSHwrdB0oXFMYZDVeHopRYyHubTg9t0qYUEu1yMFEbW8?=
 =?us-ascii?Q?/3sXI5WFtO0iOh42dVPBuFWd9/wWak2dpJgZr6tukS2Z7alVXm3VwBREOp/X?=
 =?us-ascii?Q?Pvg6GtJxDKDiYaSRdhwW8NhMt0NxeUIfKw/zIUbFgMowdu4js4KZj016yOr5?=
 =?us-ascii?Q?Mv57lugpT3LJpZc/aRdMo7QC1fD1/K34MGWM7LhzPbk3UF5RuSdBjMPD+Koi?=
 =?us-ascii?Q?1dF+rwTRA8JjcSECLlOf7Jj3eSiVKs/4RXK8gwiJ6sVNAmMzja9HbdqQUV5v?=
 =?us-ascii?Q?fhuhWWNUdSpdWmND2vBn0xVDMehZBspY9B6IppIiF8im/WR7ke8HLRp0aiy9?=
 =?us-ascii?Q?VhmikMDp6H2PtZXIc42xLIo0MR2P9hBrKCp56v0YnOrddwBtYDCKRdaH1V7Z?=
 =?us-ascii?Q?Lx3k0BKxpqvAc+BW6wkyEjOrOL50ds0k8U9tcC7BFE+4roGD8VKgk1OP2xW+?=
 =?us-ascii?Q?2d2j/1OgpThDi+wH4HNp/WNapKbidicoTjVSfufNUda+9iuxcn/Xt7fwKexD?=
 =?us-ascii?Q?EOjYwTFgYrWtMV3wAOinA+CVSZdd5bQiAGP+eSrwZw8o1UpjRQp4HgSCQVZt?=
 =?us-ascii?Q?uQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 516e7ce0-1e92-41d9-6c6e-08da9392145e
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5121.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2022 01:08:04.3837
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ugS/BLk47vC/WtLLWmFeE6VgAiqH6HulWY1Mkot1HABmfxzARnHAvyiB5g1rssGapy3d6qwtJAvWGoAQy31/gw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7739
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DSA now supports multiple CPU ports, explain the use cases that are
covered, the new UAPI, the permitted degrees of freedom, the driver API,
and remove some old "hanging fruits".

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: provide alternate description of how to put CPU ports in a LAG

 .../networking/dsa/configuration.rst          | 96 +++++++++++++++++++
 Documentation/networking/dsa/dsa.rst          | 38 ++++++--
 2 files changed, 128 insertions(+), 6 deletions(-)

diff --git a/Documentation/networking/dsa/configuration.rst b/Documentation/networking/dsa/configuration.rst
index 2b08f1a772d3..827701f8cbfe 100644
--- a/Documentation/networking/dsa/configuration.rst
+++ b/Documentation/networking/dsa/configuration.rst
@@ -49,6 +49,9 @@ In this documentation the following Ethernet interfaces are used:
 *eth0*
   the master interface
 
+*eth1*
+  another master interface
+
 *lan1*
   a slave interface
 
@@ -360,3 +363,96 @@ the ``self`` flag) has been removed. This results in the following changes:
 
 Script writers are therefore encouraged to use the ``master static`` set of
 flags when working with bridge FDB entries on DSA switch interfaces.
+
+Affinity of user ports to CPU ports
+-----------------------------------
+
+Typically, DSA switches are attached to the host via a single Ethernet
+interface, but in cases where the switch chip is discrete, the hardware design
+may permit the use of 2 or more ports connected to the host, for an increase in
+termination throughput.
+
+DSA can make use of multiple CPU ports in two ways. First, it is possible to
+statically assign the termination traffic associated with a certain user port
+to be processed by a certain CPU port. This way, user space can implement
+custom policies of static load balancing between user ports, by spreading the
+affinities according to the available CPU ports.
+
+Secondly, it is possible to perform load balancing between CPU ports on a per
+packet basis, rather than statically assigning user ports to CPU ports.
+This can be achieved by placing the DSA masters under a LAG interface (bonding
+or team). DSA monitors this operation and creates a mirror of this software LAG
+on the CPU ports facing the physical DSA masters that constitute the LAG slave
+devices.
+
+To make use of multiple CPU ports, the firmware (device tree) description of
+the switch must mark all the links between CPU ports and their DSA masters
+using the ``ethernet`` reference/phandle. At startup, only a single CPU port
+and DSA master will be used - the numerically first port from the firmware
+description which has an ``ethernet`` property. It is up to the user to
+configure the system for the switch to use other masters.
+
+DSA uses the ``rtnl_link_ops`` mechanism (with a "dsa" ``kind``) to allow
+changing the DSA master of a user port. The ``IFLA_DSA_MASTER`` u32 netlink
+attribute contains the ifindex of the master device that handles each slave
+device. The DSA master must be a valid candidate based on firmware node
+information, or a LAG interface which contains only slaves which are valid
+candidates.
+
+Using iproute2, the following manipulations are possible:
+
+  .. code-block:: sh
+
+    # See the DSA master in current use
+    ip -d link show dev swp0
+        (...)
+        dsa master eth0
+
+    # Static CPU port distribution
+    ip link set swp0 type dsa master eth1
+    ip link set swp1 type dsa master eth0
+    ip link set swp2 type dsa master eth1
+    ip link set swp3 type dsa master eth0
+
+    # CPU ports in LAG, using explicit assignment of the DSA master
+    ip link add bond0 type bond mode balance-xor && ip link set bond0 up
+    ip link set eth1 down && ip link set eth1 master bond0
+    ip link set swp0 type dsa master bond0
+    ip link set swp1 type dsa master bond0
+    ip link set swp2 type dsa master bond0
+    ip link set swp3 type dsa master bond0
+    ip link set eth0 down && ip link set eth0 master bond0
+    ip -d link show dev swp0
+        (...)
+        dsa master bond0
+
+    # CPU ports in LAG, relying on implicit migration of the DSA master
+    ip link add bond0 type bond mode balance-xor && ip link set bond0 up
+    ip link set eth0 down && ip link set eth0 master bond0
+    ip link set eth1 down && ip link set eth1 master bond0
+    ip -d link show dev swp0
+        (...)
+        dsa master bond0
+
+Notice that in the case of CPU ports under a LAG, the use of the
+``IFLA_DSA_MASTER`` netlink attribute is not strictly needed, but rather, DSA
+reacts to the ``IFLA_MASTER`` attribute change of its present master (``eth0``)
+and migrates all user ports to the new upper of ``eth0``, ``bond0``. Similarly,
+when ``bond0`` is destroyed using ``RTM_DELLINK``, DSA migrates the user ports
+that were assigned to this interface to the first physical DSA master which is
+eligible, based on the firmware description (it effectively reverts to the
+startup configuration).
+
+In a setup with more than 2 physical CPU ports, it is therefore possible to mix
+static user to CPU port assignment with LAG between DSA masters. It is not
+possible to statically assign a user port towards a DSA master that has any
+upper interfaces (this includes LAG devices - the master must always be the LAG
+in this case).
+
+Live changing of the DSA master (and thus CPU port) affinity of a user port is
+permitted, in order to allow dynamic redistribution in response to traffic.
+
+Physical DSA masters are allowed to join and leave at any time a LAG interface
+used as a DSA master; however, DSA will reject a LAG interface as a valid
+candidate for being a DSA master unless it has at least one physical DSA master
+as a slave device.
diff --git a/Documentation/networking/dsa/dsa.rst b/Documentation/networking/dsa/dsa.rst
index d742ba6bd211..a94ddf83348a 100644
--- a/Documentation/networking/dsa/dsa.rst
+++ b/Documentation/networking/dsa/dsa.rst
@@ -303,6 +303,20 @@ These frames are then queued for transmission using the master network device
 Ethernet switch will be able to process these incoming frames from the
 management interface and deliver them to the physical switch port.
 
+When using multiple CPU ports, it is possible to stack a LAG (bonding/team)
+device between the DSA slave devices and the physical DSA masters. The LAG
+device is thus also a DSA master, but the LAG slave devices continue to be DSA
+masters as well (just with no user port assigned to them; this is needed for
+recovery in case the LAG DSA master disappears). Thus, the data path of the LAG
+DSA master is used asymmetrically. On RX, the ``ETH_P_XDSA`` handler, which
+calls ``dsa_switch_rcv()``, is invoked early (on the physical DSA master;
+LAG slave). Therefore, the RX data path of the LAG DSA master is not used.
+On the other hand, TX takes place linearly: ``dsa_slave_xmit`` calls
+``dsa_enqueue_skb``, which calls ``dev_queue_xmit`` towards the LAG DSA master.
+The latter calls ``dev_queue_xmit`` towards one physical DSA master or the
+other, and in both cases, the packet exits the system through a hardware path
+towards the switch.
+
 Graphical representation
 ------------------------
 
@@ -629,6 +643,24 @@ Switch configuration
   PHY cannot be found. In this case, probing of the DSA switch continues
   without that particular port.
 
+- ``port_change_master``: method through which the affinity (association used
+  for traffic termination purposes) between a user port and a CPU port can be
+  changed. By default all user ports from a tree are assigned to the first
+  available CPU port that makes sense for them (most of the times this means
+  the user ports of a tree are all assigned to the same CPU port, except for H
+  topologies as described in commit 2c0b03258b8b). The ``port`` argument
+  represents the index of the user port, and the ``master`` argument represents
+  the new DSA master ``net_device``. The CPU port associated with the new
+  master can be retrieved by looking at ``struct dsa_port *cpu_dp =
+  master->dsa_ptr``. Additionally, the master can also be a LAG device where
+  all the slave devices are physical DSA masters. LAG DSA masters also have a
+  valid ``master->dsa_ptr`` pointer, however this is not unique, but rather a
+  duplicate of the first physical DSA master's (LAG slave) ``dsa_ptr``. In case
+  of a LAG DSA master, a further call to ``port_lag_join`` will be emitted
+  separately for the physical CPU ports associated with the physical DSA
+  masters, requesting them to create a hardware LAG associated with the LAG
+  interface.
+
 PHY devices and link management
 -------------------------------
 
@@ -1095,9 +1127,3 @@ capable hardware, but does not enforce a strict switch device driver model. On
 the other DSA enforces a fairly strict device driver model, and deals with most
 of the switch specific. At some point we should envision a merger between these
 two subsystems and get the best of both worlds.
-
-Other hanging fruits
---------------------
-
-- allowing more than one CPU/management interface:
-  http://comments.gmane.org/gmane.linux.network/365657
-- 
2.34.1

