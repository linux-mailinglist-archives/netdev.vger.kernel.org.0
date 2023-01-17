Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 289A966D923
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 10:02:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236358AbjAQJCP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 04:02:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235952AbjAQJB0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 04:01:26 -0500
Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02on2081.outbound.protection.outlook.com [40.107.247.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67F101D921;
        Tue, 17 Jan 2023 01:00:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZNXzNiHcqTDMCN6xcPxqDLsAWs2g3TjK34kRjGw5JtJfMwpTwGlejj8Vh1LRGyWEP+E7AAfI4f0+GpaE5PLWkaTsXZc4xwWxRcB9B6pHTdqSLhb/0H8pDx0FPLRQ6UdQx4NznYm5Zgg3yjsVLa2yXl5/khdxNX7dyPSTKSWxU4r/Jd462OjGVZichiuNjJtIC7tlqSdAQyhykEvH6Vg7JxVR92BohptHZLe6BRcQLKIZYBGhqwLQdT9hEIo5PDYP008nYv98oKeYWAfSUyEq2iCBITmXLJ4G/0Hm1eYWpgRuuLm/Qdr6TM5U4hdc6XqcG5O7JTPe9K8PgZIPfttTYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6a4OjJVov1G0Xlk+SOasc/WZ6jHKr0GhxWUc5fCHR1M=;
 b=hVARo+m4uo0X0OrErRg0mmmhLDJeyFphPJfiGcjE/cLM6a0eAZ9Org3eDfi4B/OjpKBNONlkqs01mUQ0P50rKBWRfRJEgUgkduUOuynG2y+h1Scd7Ma7NLjmnP+X2OsdqNw2KuMJJLIrFCT9dng2BakSkWS0liyUC6KFDRhPbMwnNMIUMRT71gWwYVZ5onu56ikfw8GZqIg5h/RCm0TBi31+KZZkM0/yUPeiNBBSSMfEeWKroxOEVwuXLCollKJ2uh+KnJupRzIY04Xkg62cmBOdrJgEzC3jKm1ValnNcDn5Rw+2FoJerKiza2kid6bfKJhwBpWNR25NvRjJOXFKEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6a4OjJVov1G0Xlk+SOasc/WZ6jHKr0GhxWUc5fCHR1M=;
 b=bfubTDLBLHbzvAxC7ene5bEMX8DVGlNSm5AHb3QQ5eVVAk91uv0UlemvZ/dp44++dmnWg0Y2rcNqPP3a4ZUzrL+kFnfxdDVqwL3uCTP1CqHsN0XHSTDZOI2T8Jp5TZdJqAwzv0PX5rzmhW7v/P9grK6DUBofJr9k7EmDQy4b4VM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB9304.eurprd04.prod.outlook.com (2603:10a6:102:2b6::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Tue, 17 Jan
 2023 09:00:02 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.5986.023; Tue, 17 Jan 2023
 09:00:02 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Rui Sousa <rui.sousa@nxp.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH v3 net-next 02/12] net: ethtool: add support for MAC Merge layer
Date:   Tue, 17 Jan 2023 10:59:37 +0200
Message-Id: <20230117085947.2176464-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230117085947.2176464-1-vladimir.oltean@nxp.com>
References: <20230117085947.2176464-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0115.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:7b::9) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PAXPR04MB9304:EE_
X-MS-Office365-Filtering-Correlation-Id: 856a09ca-6b10-4fb3-4ddf-08daf86937d0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OPduEVe50KC+1c5S/rqLmKIqLsmXxmfWHLrlCEiLXNy7KwA7ARdgOwry996FQjRibQcFE+MhPwZxqVAU/AaAXAZB895iY20ssRF4F0VrlyFGdlL2DcDBSAHqrKDGLtLvA9w/ZwaqLoigEMBZ1ODPhL0elfjwrHJevjoP1mlP5yz7btwpwVOvYnNR9JaTbp1W/0rUsbPH1ADkZuvw7xsmvwfoWR2mF06HpP/4McE0nnaAm5tgbYk8ybQ95TTSeAkwczFYm0p480IzegZiwxIieOoGWaG86KM8YxU5lyo1OjFNQhWhtBeqI55tB723XARW5zaXGVpPEfhB2E6kO2nwgdMj7g7oqNuEf1mFPquZTLjZWJ+DJw+3z0LgRsQWr/sDkmNWw1llPSeuH5qMWotBOHcFMPSrSAedj94OCjx2Q6lwziu6C25pez9oQ3yCv0iqPKwvGvIMh9esGL7+imvwk1lJ24oYIOkEynK+kcP479XN/JhoCX8trLYaDIrjHroOXGhCrXjS7spjTTF9hgtbDK/U8DbIVKdA7KOo2JsgyoNfxQZN0mXQvPxEBLDbBw6iXKnkh+BUyCjhoUm5sVLYhR1k0qLDKU8Pva0jcPC+sdomrSnUXzc5kKK7jMnOw6oD1CjML0hKE7VqnETfAZ6F5YFZjIFAVFQ80I5A1iubuNCpRPVXlrBHgb+AuaNjCpcz+bWPQnLmX8IHfhjt/Z5GyAe9U4yEU2TKhWxkvgC+8Vo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(376002)(136003)(366004)(39860400002)(451199015)(6486002)(6512007)(478600001)(66899015)(186003)(26005)(6666004)(52116002)(6506007)(66556008)(2616005)(66946007)(66476007)(316002)(54906003)(8676002)(6916009)(4326008)(36756003)(83380400001)(41300700001)(8936002)(44832011)(1076003)(2906002)(30864003)(7416002)(38350700002)(38100700002)(5660300002)(86362001)(134885004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qVbxA2A/PH2pfzDggobwv5WECk/dAzKzRd2S3vXaB9TaD/QwM4goxEHNHIrp?=
 =?us-ascii?Q?QeCWK9Q4+5S11zvhjHoRceflQ+3OGroO0YidQCUQ5mY4hJDsjPJGZHc2gfuZ?=
 =?us-ascii?Q?+Ccb9yGQazk1AEfO4bWJqTRB8YHmvVE9fKVNzOO66B+9+oZYidq/vphNr6FD?=
 =?us-ascii?Q?k7HfZPzCx3PW+WSny1TgNcl2HlWhyqFYcDuKT/gSfT3Wh5C525ax2tnrzQZB?=
 =?us-ascii?Q?ln+gybtNi+ojHmHvu/rKDqE/SDFiJFKfNJwhnNqOu5GckNWY2IVvLR3Rjiy4?=
 =?us-ascii?Q?GdX5vRI4dxG14CWgEhAztwiz9DUbmZq+p9JQ3wuZz6QJJIunu2PEaXa8Y6Om?=
 =?us-ascii?Q?Sh73rKhV5vs3AnNpDHtM599wrW5vk0aZ8XDN1Hxr0q1B+wEKBf75Gc5G3HZC?=
 =?us-ascii?Q?qiaqjCNfKBx0khXmV+Jht1T63rUduXD9la7SAVrTybQPmVcZ+5aGXmta3sHR?=
 =?us-ascii?Q?lAijlu5C/bQAF7dqZHQHALlVkDnQ7SnmyvBXh3RcoKtHYS5aENL4bfRnDLdq?=
 =?us-ascii?Q?G4iww6QZILIroh0Dbk/a6mGqp2gIjJBR9zA1lmR1moR7Dfku5Uw0vZbUBVUx?=
 =?us-ascii?Q?HNkHg/aJii7Uh/DwhXAEgLr5EN6RxI3vfcswqckS4qEtUsCVwGiNfqth1Ub9?=
 =?us-ascii?Q?CW/gfgpq9RH3PYI3k9tpBKs5DbL7PVxFksy6LFINe8q4tytEvbWsGjLbDd8X?=
 =?us-ascii?Q?X87RAQYicZN27jv5rcYikMCWucxl9FI7ohiWlmnqW8Jx/cjznZ/zqV3Siowe?=
 =?us-ascii?Q?krzfguBdnbioRlFHTGufxMZwlX6cLaItwS0jr1F0pK6bryCP1RVvrG249exH?=
 =?us-ascii?Q?5/ry+rwJ7fYEpqkrtrxrRpsCBtHRgWy7N1iJnzpuW9OpAwTxMoVc2UmbahSe?=
 =?us-ascii?Q?4xJOXS5pVosGE9C/rEcaNPQ+a/lgDDaTjApNgJBsmEHkLZMbXISiKbDacq//?=
 =?us-ascii?Q?dstoA+/4YN9UXiwNlTr+NURRob20AP0HqukwYWEECsOo90b+sZbfIk812NVl?=
 =?us-ascii?Q?Z6LiYS2buy/gozBMAdFYoG38bmXZpje0Wz70SRpw472+hH4J5xPVhinjdjqR?=
 =?us-ascii?Q?Pi5qTDDsPkrBRI6mLq2KoMmXnWZXxpsB4s69+C3ek64RP6mwDC8Y7Q/p8XRf?=
 =?us-ascii?Q?8tKL0mr6RE4Bq7o4iOE4SET6EiEAquuq/XFVnLr6BEi/rtpl0OEsdEaDfBRN?=
 =?us-ascii?Q?MpfafkJ8pvlZem76bfHw4HVZXsZkBn5AtgXypxeYHbGrubUf6ZZqgazIg442?=
 =?us-ascii?Q?vtvCVN4vW0GrMpts+/EfvrEbiElwD3421FM+P/bJpFZb3YrSDuM8W4iSG3EC?=
 =?us-ascii?Q?QQFBE8DLThOJBh913Z78xucsMg13NDyA1hbGGRGYJnR/3fcyBjf8xx53ojTa?=
 =?us-ascii?Q?hjqoqIs5M5IcICty8tneqBpzj2B/7xTBcJDxgMVlBx0qGcpkQTIq2pfsCWy/?=
 =?us-ascii?Q?/mL/Ggv8Sb+Z1xg3JA2oJ4QuEfrvHp5Q3hJBab2TGynQ5IQKJolkIDfpBn2u?=
 =?us-ascii?Q?cWo9S8SFMv6obp6I3qKmJKQc9i8NMykQyWXlVSEF/xTIGOLch9CnGcgtyAEx?=
 =?us-ascii?Q?QZRETvVDn4cvtTFe3Mr2R+c+HMM9KmZjLGqdA4AlEYk/CRNdQm6V1d1XRO8m?=
 =?us-ascii?Q?VA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 856a09ca-6b10-4fb3-4ddf-08daf86937d0
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2023 09:00:02.1124
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rsAywcfcT4cKJj7L9Fe0tfUEbjCWjuK1IIuXXtgs9ujCNupAOpdxLofKdgVmjb98sHBKq8WCfOOgfc0rWTQw1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9304
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The MAC merge sublayer (IEEE 802.3-2018 clause 99) is one of 2
specifications (the other being Frame Preemption; IEEE 802.1Q-2018
clause 6.7.2), which work together to minimize latency caused by frame
interference at TX. The overall goal of TSN is for normal traffic and
traffic with a bounded deadline to be able to cohabitate on the same L2
network and not bother each other too much.

The standards achieve this (partly) by introducing the concept of
preemptible traffic, i.e. Ethernet frames that have a custom value for
the Start-of-Frame-Delimiter (SFD), and these frames can be fragmented
and reassembled at L2 on a link-local basis. The non-preemptible frames
are called express traffic, they are transmitted using a normal SFD, and
they can preempt preemptible frames, therefore having lower latency,
which can matter at lower (100 Mbps) link speeds, or at high MTUs (jumbo
frames around 9K). Preemption is not recursive, i.e. a P frame cannot
preempt another P frame. Preemption also does not depend upon priority,
or otherwise said, an E frame with prio 0 will still preempt a P frame
with prio 7.

In terms of implementation, the standards talk about the presence of an
express MAC (eMAC) which handles express traffic, and a preemptible MAC
(pMAC) which handles preemptible traffic, and these MACs are multiplexed
on the same MII by a MAC merge layer.

To support frame preemption, the definition of the SFD was generalized
to SMD (Start-of-mPacket-Delimiter), where an mPacket is essentially an
Ethernet frame fragment, or a complete frame. Stations unaware of an SMD
value different from the standard SFD will treat P frames as error
frames. To prevent that from happening, a negotiation process is
defined.

On RX, packets are dispatched to the eMAC or pMAC after being filtered
by their SMD. On TX, the eMAC/pMAC classification decision is taken by
the 802.1Q spec, based on packet priority (each of the 8 user priority
values may have an admin-status of preemptible or express).

The MAC Merge layer and the Frame Preemption parameters have some degree
of independence in terms of how software stacks are supposed to deal
with them. The activation of the MM layer is supposed to be controlled
by an LLDP daemon (after it has been communicated that the link partner
also supports it), after which a (hardware-based or not) verification
handshake takes place, before actually enabling the feature. So the
process is intended to be relatively plug-and-play. Whereas FP settings
are supposed to be coordinated across a network using something
approximating NETCONF.

The support contained here is exclusively for the 802.3 (MAC Merge)
portions and not for the 802.1Q (Frame Preemption) parts. This API is
sufficient for an LLDP daemon to do its job. The FP adminStatus variable
from 802.1Q is outside the scope of an LLDP daemon.

I have taken a few creative licenses and augmented the Linux kernel UAPI
compared to the standard managed objects recommended by IEEE 802.3.
These are:

- ETHTOOL_A_MM_PMAC_ENABLED: According to Figure 99-6: Receive
  Processing state diagram, a MAC Merge layer is always supposed to be
  able to receive P frames. However, this implies keeping the pMAC
  powered on, which will consume needless power in applications where FP
  will never be used. If LLDP is used, the reception of an Additional
  Ethernet Capabilities TLV from the link partner is sufficient
  indication that the pMAC should be enabled. So my proposal is that in
  Linux, we keep the pMAC turned off by default and that user space
  turns it on when needed.

- ETHTOOL_A_MM_VERIFY_ENABLED: The IEEE managed object is called
  aMACMergeVerifyDisableTx. I opted for consistency (positive logic) in
  the boolean netlink attributes offered, so this is also positive here.
  Other than the meaning being reversed, they correspond to the same
  thing.

- ETHTOOL_A_MM_MAX_VERIFY_TIME: I found it most reasonable for a LLDP
  daemon to maximize the verifyTime variable (delay between SMD-V
  transmissions), to maximize its chances that the LP replies. IEEE says
  that the verifyTime can range between 1 and 128 ms, but the NXP ENETC
  stupidly keeps this variable in a 7 bit register, so the maximum
  supported value is 127 ms. I could have chosen to hardcode this in the
  LLDP daemon to a lower value, but why not let the kernel expose its
  supported range directly.

- ETHTOOL_A_MM_TX_MIN_FRAG_SIZE: the standard managed object is called
  aMACMergeAddFragSize, and expresses the "additional" fragment size
  (on top of ETH_ZLEN), whereas this expresses the absolute value of the
  fragment size.

- ETHTOOL_A_MM_RX_MIN_FRAG_SIZE: there doesn't appear to exist a managed
  object mandated by the standard, but user space clearly needs to know
  what is the minimum supported fragment size of our local receiver,
  since LLDP must advertise a value no lower than that.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v2->v3:
- deleted ETHTOOL_A_MM_SUPPORTED (to be deduced from return value of
  ETHTOOL_MSG_MM_GET)
- made get_mm return int instead of void
- renamed "add_frag_size" to "tx_min_frag_size"
- added "rx_min_frag_size" as a read-only netlink attribute
- rebase on top of PLCA changes
v1->v2:
- added documentation
- introduced pmac_enabled
- transformed verify_disable into verify_enabled
- made add_frag_size take a value in octets
- removed FP params (adminStatus)
- renamed "enabled" to "tx_enabled" and "active" to "tx_active"

 include/linux/ethtool.h              |  99 +++++++++++
 include/uapi/linux/ethtool.h         |  25 +++
 include/uapi/linux/ethtool_netlink.h |  47 +++++
 net/ethtool/Makefile                 |   4 +-
 net/ethtool/mm.c                     | 255 +++++++++++++++++++++++++++
 net/ethtool/netlink.c                |  19 ++
 net/ethtool/netlink.h                |   4 +
 7 files changed, 451 insertions(+), 2 deletions(-)
 create mode 100644 net/ethtool/mm.c

diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 20d197693d34..37eba38da502 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -477,6 +477,98 @@ struct ethtool_module_power_mode_params {
 	enum ethtool_module_power_mode mode;
 };
 
+/**
+ * struct ethtool_mm_state - 802.3 MAC merge layer state
+ * @verify_time:
+ *	wait time between verification attempts in ms (according to clause
+ *	30.14.1.6 aMACMergeVerifyTime)
+ * @max_verify_time:
+ *	maximum accepted value for the @verify_time variable in set requests
+ * @verify_status:
+ *	state of the verification state machine of the MM layer (according to
+ *	clause 30.14.1.2 aMACMergeStatusVerify)
+ * @tx_enabled:
+ *	set if the MM layer is administratively enabled in the TX direction
+ *	(according to clause 30.14.1.3 aMACMergeEnableTx)
+ * @tx_active:
+ *	set if the MM layer is enabled in the TX direction, which makes FP
+ *	possible (according to 30.14.1.5 aMACMergeStatusTx). This should be
+ *	true if MM is enabled, and the verification status is either verified,
+ *	or disabled.
+ * @pmac_enabled:
+ *	set if the preemptible MAC is powered on and is able to receive
+ *	preemptible packets and respond to verification frames.
+ * @verify_enabled:
+ *	set if the Verify function of the MM layer (which sends SMD-V
+ *	verification requests) is administratively enabled (regardless of
+ *	whether it is currently in the ETHTOOL_MM_VERIFY_STATUS_DISABLED state
+ *	or not), according to clause 30.14.1.4 aMACMergeVerifyDisableTx (but
+ *	using positive rather than negative logic). The device should always
+ *	respond to received SMD-V requests as long as @pmac_enabled is set.
+ * @tx_min_frag_size:
+ *	the minimum size of non-final mPacket fragments that the link partner
+ *	supports receiving, expressed in octets. Compared to the definition
+ *	from clause 30.14.1.7 aMACMergeAddFragSize which is expressed in the
+ *	range 0 to 3 (requiring a translation to the size in octets according
+ *	to the formula 64 * (1 + addFragSize) - 4), a value in a continuous and
+ *	unbounded range can be specified here.
+ * @rx_min_frag_size:
+ *	the minimum size of non-final mPacket fragments that this device
+ *	supports receiving, expressed in octets.
+ */
+struct ethtool_mm_state {
+	u32 verify_time;
+	u32 max_verify_time;
+	enum ethtool_mm_verify_status verify_status;
+	bool tx_enabled;
+	bool tx_active;
+	bool pmac_enabled;
+	bool verify_enabled;
+	u32 tx_min_frag_size;
+	u32 rx_min_frag_size;
+};
+
+/**
+ * struct ethtool_mm_cfg - 802.3 MAC merge layer configuration
+ * @verify_time: see struct ethtool_mm_state
+ * @verify_enabled: see struct ethtool_mm_state
+ * @tx_enabled: see struct ethtool_mm_state
+ * @pmac_enabled: see struct ethtool_mm_state
+ * @tx_min_frag_size: see struct ethtool_mm_state
+ */
+struct ethtool_mm_cfg {
+	u32 verify_time;
+	bool verify_enabled;
+	bool tx_enabled;
+	bool pmac_enabled;
+	u32 tx_min_frag_size;
+};
+
+/**
+ * struct ethtool_mm_stats - 802.3 MAC merge layer statistics
+ * @MACMergeFrameAssErrorCount:
+ *	received MAC frames with reassembly errors
+ * @MACMergeFrameSmdErrorCount:
+ *	received MAC frames/fragments rejected due to unknown or incorrect SMD
+ * @MACMergeFrameAssOkCount:
+ *	received MAC frames that were successfully reassembled and passed up
+ * @MACMergeFragCountRx:
+ *	number of additional correct SMD-C mPackets received due to preemption
+ * @MACMergeFragCountTx:
+ *	number of additional mPackets sent due to preemption
+ * @MACMergeHoldCount:
+ *	number of times the MM layer entered the HOLD state, which blocks
+ *	transmission of preemptible traffic
+ */
+struct ethtool_mm_stats {
+	u64 MACMergeFrameAssErrorCount;
+	u64 MACMergeFrameSmdErrorCount;
+	u64 MACMergeFrameAssOkCount;
+	u64 MACMergeFragCountRx;
+	u64 MACMergeFragCountTx;
+	u64 MACMergeHoldCount;
+};
+
 /**
  * struct ethtool_ops - optional netdev operations
  * @cap_link_lanes_supported: indicates if the driver supports lanes
@@ -649,6 +741,9 @@ struct ethtool_module_power_mode_params {
  *	plugged-in.
  * @set_module_power_mode: Set the power mode policy for the plug-in module
  *	used by the network device.
+ * @get_mm: Query the 802.3 MAC Merge layer state.
+ * @set_mm: Set the 802.3 MAC Merge layer parameters.
+ * @get_mm_stats: Query the 802.3 MAC Merge layer statistics.
  *
  * All operations are optional (i.e. the function pointer may be set
  * to %NULL) and callers must take this into account.  Callers must
@@ -787,6 +882,10 @@ struct ethtool_ops {
 	int	(*set_module_power_mode)(struct net_device *dev,
 					 const struct ethtool_module_power_mode_params *params,
 					 struct netlink_ext_ack *extack);
+	int	(*get_mm)(struct net_device *dev, struct ethtool_mm_state *state);
+	int	(*set_mm)(struct net_device *dev, struct ethtool_mm_cfg *cfg,
+			  struct netlink_ext_ack *extack);
+	void	(*get_mm_stats)(struct net_device *dev, struct ethtool_mm_stats *stats);
 };
 
 int ethtool_check_ops(const struct ethtool_ops *ops);
diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index 6389953c32cf..529a93696ab6 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -779,6 +779,31 @@ enum ethtool_podl_pse_pw_d_status {
 	ETHTOOL_PODL_PSE_PW_D_STATUS_ERROR,
 };
 
+/**
+ * enum ethtool_mm_verify_status - status of MAC Merge Verify function
+ * @ETHTOOL_MM_VERIFY_STATUS_UNKNOWN:
+ *	verification status is unknown
+ * @ETHTOOL_MM_VERIFY_STATUS_INITIAL:
+ *	the 802.3 Verify State diagram is in the state INIT_VERIFICATION
+ * @ETHTOOL_MM_VERIFY_STATUS_VERIFYING:
+ *	the Verify State diagram is in the state VERIFICATION_IDLE,
+ *	SEND_VERIFY or WAIT_FOR_RESPONSE
+ * @ETHTOOL_MM_VERIFY_STATUS_SUCCEEDED:
+ *	indicates that the Verify State diagram is in the state VERIFIED
+ * @ETHTOOL_MM_VERIFY_STATUS_FAILED:
+ *	the Verify State diagram is in the state VERIFY_FAIL
+ * @ETHTOOL_MM_VERIFY_STATUS_DISABLED:
+ *	verification of preemption operation is disabled
+ */
+enum ethtool_mm_verify_status {
+	ETHTOOL_MM_VERIFY_STATUS_UNKNOWN,
+	ETHTOOL_MM_VERIFY_STATUS_INITIAL,
+	ETHTOOL_MM_VERIFY_STATUS_VERIFYING,
+	ETHTOOL_MM_VERIFY_STATUS_SUCCEEDED,
+	ETHTOOL_MM_VERIFY_STATUS_FAILED,
+	ETHTOOL_MM_VERIFY_STATUS_DISABLED,
+};
+
 /**
  * struct ethtool_gstrings - string set for data tagging
  * @cmd: Command number = %ETHTOOL_GSTRINGS
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index 83557cae0b87..58af390823b0 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -55,6 +55,8 @@ enum {
 	ETHTOOL_MSG_PLCA_GET_CFG,
 	ETHTOOL_MSG_PLCA_SET_CFG,
 	ETHTOOL_MSG_PLCA_GET_STATUS,
+	ETHTOOL_MSG_MM_GET,
+	ETHTOOL_MSG_MM_SET,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_USER_CNT,
@@ -105,6 +107,8 @@ enum {
 	ETHTOOL_MSG_PLCA_GET_CFG_REPLY,
 	ETHTOOL_MSG_PLCA_GET_STATUS_REPLY,
 	ETHTOOL_MSG_PLCA_NTF,
+	ETHTOOL_MSG_MM_GET_REPLY,
+	ETHTOOL_MSG_MM_NTF,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_KERNEL_CNT,
@@ -922,6 +926,49 @@ enum {
 	ETHTOOL_A_PLCA_MAX = (__ETHTOOL_A_PLCA_CNT - 1)
 };
 
+/* MAC Merge (802.3) */
+
+enum {
+	ETHTOOL_A_MM_STAT_UNSPEC,
+	ETHTOOL_A_MM_STAT_PAD,
+
+	/* aMACMergeFrameAssErrorCount */
+	ETHTOOL_A_MM_STAT_REASSEMBLY_ERRORS,	/* u64 */
+	/* aMACMergeFrameSmdErrorCount */
+	ETHTOOL_A_MM_STAT_SMD_ERRORS,		/* u64 */
+	/* aMACMergeFrameAssOkCount */
+	ETHTOOL_A_MM_STAT_REASSEMBLY_OK,	/* u64 */
+	/* aMACMergeFragCountRx */
+	ETHTOOL_A_MM_STAT_RX_FRAG_COUNT,	/* u64 */
+	/* aMACMergeFragCountTx */
+	ETHTOOL_A_MM_STAT_TX_FRAG_COUNT,	/* u64 */
+	/* aMACMergeHoldCount */
+	ETHTOOL_A_MM_STAT_HOLD_COUNT,		/* u64 */
+
+	/* add new constants above here */
+	__ETHTOOL_A_MM_STAT_CNT,
+	ETHTOOL_A_MM_STAT_MAX = (__ETHTOOL_A_MM_STAT_CNT - 1)
+};
+
+enum {
+	ETHTOOL_A_MM_UNSPEC,
+	ETHTOOL_A_MM_HEADER,			/* nest - _A_HEADER_* */
+	ETHTOOL_A_MM_PMAC_ENABLED,		/* u8 */
+	ETHTOOL_A_MM_TX_ENABLED,		/* u8 */
+	ETHTOOL_A_MM_TX_ACTIVE,			/* u8 */
+	ETHTOOL_A_MM_TX_MIN_FRAG_SIZE,		/* u32 */
+	ETHTOOL_A_MM_RX_MIN_FRAG_SIZE,		/* u32 */
+	ETHTOOL_A_MM_VERIFY_ENABLED,		/* u8 */
+	ETHTOOL_A_MM_VERIFY_STATUS,		/* u8 */
+	ETHTOOL_A_MM_VERIFY_TIME,		/* u32 */
+	ETHTOOL_A_MM_MAX_VERIFY_TIME,		/* u32 */
+	ETHTOOL_A_MM_STATS,			/* nest - _A_MM_STAT_* */
+
+	/* add new constants above here */
+	__ETHTOOL_A_MM_CNT,
+	ETHTOOL_A_MM_MAX = (__ETHTOOL_A_MM_CNT - 1)
+};
+
 /* generic netlink info */
 #define ETHTOOL_GENL_NAME "ethtool"
 #define ETHTOOL_GENL_VERSION 1
diff --git a/net/ethtool/Makefile b/net/ethtool/Makefile
index 563864c1bf5a..504f954a1b28 100644
--- a/net/ethtool/Makefile
+++ b/net/ethtool/Makefile
@@ -7,5 +7,5 @@ obj-$(CONFIG_ETHTOOL_NETLINK)	+= ethtool_nl.o
 ethtool_nl-y	:= netlink.o bitset.o strset.o linkinfo.o linkmodes.o rss.o \
 		   linkstate.o debug.o wol.o features.o privflags.o rings.o \
 		   channels.o coalesce.o pause.o eee.o tsinfo.o cabletest.o \
-		   tunnels.o fec.o eeprom.o stats.o phc_vclocks.o module.o \
-		   pse-pd.o plca.o
+		   tunnels.o fec.o eeprom.o stats.o phc_vclocks.o mm.o \
+		   module.o pse-pd.o plca.o mm.o
diff --git a/net/ethtool/mm.c b/net/ethtool/mm.c
new file mode 100644
index 000000000000..0c8135393c14
--- /dev/null
+++ b/net/ethtool/mm.c
@@ -0,0 +1,255 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright 2022-2023 NXP
+ */
+#include "common.h"
+#include "netlink.h"
+
+struct mm_req_info {
+	struct ethnl_req_info		base;
+};
+
+struct mm_reply_data {
+	struct ethnl_reply_data		base;
+	struct ethtool_mm_state		state;
+	struct ethtool_mm_stats		stats;
+};
+
+#define MM_REPDATA(__reply_base) \
+	container_of(__reply_base, struct mm_reply_data, base)
+
+#define ETHTOOL_MM_STAT_CNT \
+	(__ETHTOOL_A_MM_STAT_CNT - (ETHTOOL_A_MM_STAT_PAD + 1))
+
+const struct nla_policy ethnl_mm_get_policy[ETHTOOL_A_MM_HEADER + 1] = {
+	[ETHTOOL_A_MM_HEADER] = NLA_POLICY_NESTED(ethnl_header_policy_stats),
+};
+
+static int mm_prepare_data(const struct ethnl_req_info *req_base,
+			   struct ethnl_reply_data *reply_base,
+			   struct genl_info *info)
+{
+	struct mm_reply_data *data = MM_REPDATA(reply_base);
+	struct net_device *dev = reply_base->dev;
+	const struct ethtool_ops *ops;
+	int ret;
+
+	ops = dev->ethtool_ops;
+
+	if (!ops->get_mm)
+		return -EOPNOTSUPP;
+
+	ethtool_stats_init((u64 *)&data->stats,
+			   sizeof(data->stats) / sizeof(u64));
+
+	ret = ethnl_ops_begin(dev);
+	if (ret < 0)
+		return ret;
+
+	ret = ops->get_mm(dev, &data->state);
+	if (ret)
+		goto out_complete;
+
+	if (ops->get_mm_stats && (req_base->flags & ETHTOOL_FLAG_STATS))
+		ops->get_mm_stats(dev, &data->stats);
+
+out_complete:
+	ethnl_ops_complete(dev);
+
+	return 0;
+}
+
+static int mm_reply_size(const struct ethnl_req_info *req_base,
+			 const struct ethnl_reply_data *reply_base)
+{
+	int len = 0;
+
+	len += nla_total_size(sizeof(u8)); /* _MM_PMAC_ENABLED */
+	len += nla_total_size(sizeof(u8)); /* _MM_TX_ENABLED */
+	len += nla_total_size(sizeof(u8)); /* _MM_TX_ACTIVE */
+	len += nla_total_size(sizeof(u8)); /* _MM_VERIFY_ENABLED */
+	len += nla_total_size(sizeof(u8)); /* _MM_VERIFY_STATUS */
+	len += nla_total_size(sizeof(u32)); /* _MM_VERIFY_TIME */
+	len += nla_total_size(sizeof(u32)); /* _MM_MAX_VERIFY_TIME */
+	len += nla_total_size(sizeof(u32)); /* _MM_TX_MIN_FRAG_SIZE */
+	len += nla_total_size(sizeof(u32)); /* _MM_RX_MIN_FRAG_SIZE */
+
+	if (req_base->flags & ETHTOOL_FLAG_STATS)
+		len += nla_total_size(0) + /* _MM_STATS */
+		       nla_total_size_64bit(sizeof(u64)) * ETHTOOL_MM_STAT_CNT;
+
+	return len;
+}
+
+static int mm_put_stat(struct sk_buff *skb, u64 val, u16 attrtype)
+{
+	if (val == ETHTOOL_STAT_NOT_SET)
+		return 0;
+	if (nla_put_u64_64bit(skb, attrtype, val, ETHTOOL_A_MM_STAT_PAD))
+		return -EMSGSIZE;
+	return 0;
+}
+
+static int mm_put_stats(struct sk_buff *skb,
+			const struct ethtool_mm_stats *stats)
+{
+	struct nlattr *nest;
+
+	nest = nla_nest_start(skb, ETHTOOL_A_MM_STATS);
+	if (!nest)
+		return -EMSGSIZE;
+
+	if (mm_put_stat(skb, stats->MACMergeFrameAssErrorCount,
+			ETHTOOL_A_MM_STAT_REASSEMBLY_ERRORS) ||
+	    mm_put_stat(skb, stats->MACMergeFrameSmdErrorCount,
+			ETHTOOL_A_MM_STAT_SMD_ERRORS) ||
+	    mm_put_stat(skb, stats->MACMergeFrameAssOkCount,
+			ETHTOOL_A_MM_STAT_REASSEMBLY_OK) ||
+	    mm_put_stat(skb, stats->MACMergeFragCountRx,
+			ETHTOOL_A_MM_STAT_RX_FRAG_COUNT) ||
+	    mm_put_stat(skb, stats->MACMergeFragCountTx,
+			ETHTOOL_A_MM_STAT_TX_FRAG_COUNT) ||
+	    mm_put_stat(skb, stats->MACMergeHoldCount,
+			ETHTOOL_A_MM_STAT_HOLD_COUNT))
+		goto err_cancel;
+
+	nla_nest_end(skb, nest);
+	return 0;
+
+err_cancel:
+	nla_nest_cancel(skb, nest);
+	return -EMSGSIZE;
+}
+
+static int mm_fill_reply(struct sk_buff *skb,
+			 const struct ethnl_req_info *req_base,
+			 const struct ethnl_reply_data *reply_base)
+{
+	const struct mm_reply_data *data = MM_REPDATA(reply_base);
+	const struct ethtool_mm_state *state = &data->state;
+
+	if (nla_put_u8(skb, ETHTOOL_A_MM_TX_ENABLED, state->tx_enabled) ||
+	    nla_put_u8(skb, ETHTOOL_A_MM_TX_ACTIVE, state->tx_active) ||
+	    nla_put_u8(skb, ETHTOOL_A_MM_PMAC_ENABLED, state->pmac_enabled) ||
+	    nla_put_u8(skb, ETHTOOL_A_MM_VERIFY_ENABLED, state->verify_enabled) ||
+	    nla_put_u8(skb, ETHTOOL_A_MM_VERIFY_STATUS, state->verify_status) ||
+	    nla_put_u32(skb, ETHTOOL_A_MM_VERIFY_TIME, state->verify_time) ||
+	    nla_put_u32(skb, ETHTOOL_A_MM_MAX_VERIFY_TIME, state->max_verify_time) ||
+	    nla_put_u32(skb, ETHTOOL_A_MM_TX_MIN_FRAG_SIZE, state->tx_min_frag_size) ||
+	    nla_put_u32(skb, ETHTOOL_A_MM_RX_MIN_FRAG_SIZE, state->rx_min_frag_size))
+		return -EMSGSIZE;
+
+	if (req_base->flags & ETHTOOL_FLAG_STATS &&
+	    mm_put_stats(skb, &data->stats))
+		return -EMSGSIZE;
+
+	return 0;
+}
+
+const struct ethnl_request_ops ethnl_mm_request_ops = {
+	.request_cmd		= ETHTOOL_MSG_MM_GET,
+	.reply_cmd		= ETHTOOL_MSG_MM_GET_REPLY,
+	.hdr_attr		= ETHTOOL_A_MM_HEADER,
+	.req_info_size		= sizeof(struct mm_req_info),
+	.reply_data_size	= sizeof(struct mm_reply_data),
+
+	.prepare_data		= mm_prepare_data,
+	.reply_size		= mm_reply_size,
+	.fill_reply		= mm_fill_reply,
+};
+
+const struct nla_policy ethnl_mm_set_policy[ETHTOOL_A_MM_MAX + 1] = {
+	[ETHTOOL_A_MM_HEADER]		= NLA_POLICY_NESTED(ethnl_header_policy),
+	[ETHTOOL_A_MM_VERIFY_ENABLED]	= NLA_POLICY_MAX(NLA_U8, 1),
+	[ETHTOOL_A_MM_VERIFY_TIME]	= NLA_POLICY_RANGE(NLA_U32, 1, 128),
+	[ETHTOOL_A_MM_TX_ENABLED]	= NLA_POLICY_MAX(NLA_U8, 1),
+	[ETHTOOL_A_MM_PMAC_ENABLED]	= NLA_POLICY_MAX(NLA_U8, 1),
+	[ETHTOOL_A_MM_TX_MIN_FRAG_SIZE]	= NLA_POLICY_RANGE(NLA_U32, 60, 252),
+};
+
+static void mm_state_to_cfg(const struct ethtool_mm_state *state,
+			    struct ethtool_mm_cfg *cfg)
+{
+	/* We could also compare state->verify_status against
+	 * ETHTOOL_MM_VERIFY_STATUS_DISABLED, but state->verify_enabled
+	 * is more like an administrative state which should be seen in
+	 * ETHTOOL_MSG_MM_GET replies. For example, a port with verification
+	 * disabled might be in the ETHTOOL_MM_VERIFY_STATUS_INITIAL
+	 * if it's down.
+	 */
+	cfg->verify_enabled = state->verify_enabled;
+	cfg->verify_time = state->verify_time;
+	cfg->tx_enabled = state->tx_enabled;
+	cfg->pmac_enabled = state->pmac_enabled;
+	cfg->tx_min_frag_size = state->tx_min_frag_size;
+}
+
+int ethnl_set_mm(struct sk_buff *skb, struct genl_info *info)
+{
+	struct netlink_ext_ack *extack = info->extack;
+	struct ethnl_req_info req_info = {};
+	struct ethtool_mm_state state = {};
+	struct nlattr **tb = info->attrs;
+	struct ethtool_mm_cfg cfg = {};
+	const struct ethtool_ops *ops;
+	struct net_device *dev;
+	bool mod = false;
+	int ret;
+
+	ret = ethnl_parse_header_dev_get(&req_info, tb[ETHTOOL_A_MM_HEADER],
+					 genl_info_net(info), extack, true);
+	if (ret)
+		return ret;
+
+	dev = req_info.dev;
+	ops = dev->ethtool_ops;
+
+	if (!ops->get_mm || !ops->set_mm) {
+		ret = -EOPNOTSUPP;
+		goto out_dev_put;
+	}
+
+	rtnl_lock();
+	ret = ethnl_ops_begin(dev);
+	if (ret < 0)
+		goto out_rtnl_unlock;
+
+	ret = ops->get_mm(dev, &state);
+	if (ret)
+		goto out_complete;
+
+	mm_state_to_cfg(&state, &cfg);
+
+	if (cfg.verify_time > state.max_verify_time) {
+		NL_SET_ERR_MSG_ATTR(extack, tb[ETHTOOL_A_MM_VERIFY_TIME],
+				    "verifyTime exceeds device maximum");
+		ret = -ERANGE;
+		goto out_complete;
+	}
+
+	ethnl_update_bool(&cfg.verify_enabled, tb[ETHTOOL_A_MM_VERIFY_ENABLED],
+			  &mod);
+	ethnl_update_u32(&cfg.verify_time, tb[ETHTOOL_A_MM_VERIFY_TIME], &mod);
+	ethnl_update_bool(&cfg.tx_enabled, tb[ETHTOOL_A_MM_TX_ENABLED], &mod);
+	ethnl_update_bool(&cfg.pmac_enabled, tb[ETHTOOL_A_MM_PMAC_ENABLED],
+			  &mod);
+	ethnl_update_u32(&cfg.tx_min_frag_size,
+			 tb[ETHTOOL_A_MM_TX_MIN_FRAG_SIZE], &mod);
+
+	if (!mod)
+		goto out_complete;
+
+	ret = ops->set_mm(dev, &cfg, extack);
+	if (ret)
+		goto out_complete;
+
+	ethtool_notify(dev, ETHTOOL_MSG_MM_NTF, NULL);
+
+out_complete:
+	ethnl_ops_complete(dev);
+out_rtnl_unlock:
+	rtnl_unlock();
+out_dev_put:
+	ethnl_parse_header_dev_put(&req_info);
+	return ret;
+}
diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index 9f924875bba9..6412c4dc663d 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -290,6 +290,7 @@ ethnl_default_requests[__ETHTOOL_MSG_USER_CNT] = {
 	[ETHTOOL_MSG_RSS_GET]		= &ethnl_rss_request_ops,
 	[ETHTOOL_MSG_PLCA_GET_CFG]	= &ethnl_plca_cfg_request_ops,
 	[ETHTOOL_MSG_PLCA_GET_STATUS]	= &ethnl_plca_status_request_ops,
+	[ETHTOOL_MSG_MM_GET]		= &ethnl_mm_request_ops,
 };
 
 static struct ethnl_dump_ctx *ethnl_dump_context(struct netlink_callback *cb)
@@ -606,6 +607,7 @@ ethnl_default_notify_ops[ETHTOOL_MSG_KERNEL_MAX + 1] = {
 	[ETHTOOL_MSG_FEC_NTF]		= &ethnl_fec_request_ops,
 	[ETHTOOL_MSG_MODULE_NTF]	= &ethnl_module_request_ops,
 	[ETHTOOL_MSG_PLCA_NTF]		= &ethnl_plca_cfg_request_ops,
+	[ETHTOOL_MSG_MM_NTF]		= &ethnl_mm_request_ops,
 };
 
 /* default notification handler */
@@ -700,6 +702,7 @@ static const ethnl_notify_handler_t ethnl_notify_handlers[] = {
 	[ETHTOOL_MSG_FEC_NTF]		= ethnl_default_notify,
 	[ETHTOOL_MSG_MODULE_NTF]	= ethnl_default_notify,
 	[ETHTOOL_MSG_PLCA_NTF]		= ethnl_default_notify,
+	[ETHTOOL_MSG_MM_NTF]		= ethnl_default_notify,
 };
 
 void ethtool_notify(struct net_device *dev, unsigned int cmd, const void *data)
@@ -1076,6 +1079,22 @@ static const struct genl_ops ethtool_genl_ops[] = {
 		.policy = ethnl_plca_get_status_policy,
 		.maxattr = ARRAY_SIZE(ethnl_plca_get_status_policy) - 1,
 	},
+	{
+		.cmd	= ETHTOOL_MSG_MM_GET,
+		.doit	= ethnl_default_doit,
+		.start	= ethnl_default_start,
+		.dumpit	= ethnl_default_dumpit,
+		.done	= ethnl_default_done,
+		.policy = ethnl_mm_get_policy,
+		.maxattr = ARRAY_SIZE(ethnl_mm_get_policy) - 1,
+	},
+	{
+		.cmd	= ETHTOOL_MSG_MM_SET,
+		.flags	= GENL_UNS_ADMIN_PERM,
+		.doit	= ethnl_set_mm,
+		.policy = ethnl_mm_set_policy,
+		.maxattr = ARRAY_SIZE(ethnl_mm_set_policy) - 1,
+	},
 };
 
 static const struct genl_multicast_group ethtool_nl_mcgrps[] = {
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index f675f62fe181..60278485b00b 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -375,6 +375,7 @@ extern const struct ethnl_request_ops ethnl_pse_request_ops;
 extern const struct ethnl_request_ops ethnl_rss_request_ops;
 extern const struct ethnl_request_ops ethnl_plca_cfg_request_ops;
 extern const struct ethnl_request_ops ethnl_plca_status_request_ops;
+extern const struct ethnl_request_ops ethnl_mm_request_ops;
 
 extern const struct nla_policy ethnl_header_policy[ETHTOOL_A_HEADER_FLAGS + 1];
 extern const struct nla_policy ethnl_header_policy_stats[ETHTOOL_A_HEADER_FLAGS + 1];
@@ -419,6 +420,8 @@ extern const struct nla_policy ethnl_rss_get_policy[ETHTOOL_A_RSS_CONTEXT + 1];
 extern const struct nla_policy ethnl_plca_get_cfg_policy[ETHTOOL_A_PLCA_HEADER + 1];
 extern const struct nla_policy ethnl_plca_set_cfg_policy[ETHTOOL_A_PLCA_MAX + 1];
 extern const struct nla_policy ethnl_plca_get_status_policy[ETHTOOL_A_PLCA_HEADER + 1];
+extern const struct nla_policy ethnl_mm_get_policy[ETHTOOL_A_MM_HEADER + 1];
+extern const struct nla_policy ethnl_mm_set_policy[ETHTOOL_A_MM_MAX + 1];
 
 int ethnl_set_linkinfo(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_linkmodes(struct sk_buff *skb, struct genl_info *info);
@@ -440,6 +443,7 @@ int ethnl_set_fec(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_module(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_pse(struct sk_buff *skb, struct genl_info *info);
 int ethnl_set_plca_cfg(struct sk_buff *skb, struct genl_info *info);
+int ethnl_set_mm(struct sk_buff *skb, struct genl_info *info);
 
 extern const char stats_std_names[__ETHTOOL_STATS_CNT][ETH_GSTRING_LEN];
 extern const char stats_eth_phy_names[__ETHTOOL_A_STATS_ETH_PHY_CNT][ETH_GSTRING_LEN];
-- 
2.34.1

