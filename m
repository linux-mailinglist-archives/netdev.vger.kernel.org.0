Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C18A067386A
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 13:29:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230215AbjASM26 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 07:28:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230146AbjASM15 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 07:27:57 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on2079.outbound.protection.outlook.com [40.107.14.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB30978A9F;
        Thu, 19 Jan 2023 04:27:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HO5Jl6CHBhdUT3DqxBE2/+3cYljIWMj+vQA5yNWsOeuNcRe1xy97+ccH2Mz8VWFno3OkKpoLDOCby47u1O3qevL/eyySvMPMbtHbmHTWIsdQIhIJplVZFQ6bRbOz7sNxWyCr6ogzhyPP3OBAOabNjf0Z7cDQfiz8qwXzxjutCZI5tAboK7+vz/TWZorFDOLEw0kLWJ2FCBw08qTuZJQC+Bo9gHcS2wolnCnPmrP6m5Y8z468zkb+tMhlz2vCh0N+zDHP5uNk5z0bNT1ZiDY7QZ58jBga4j+SxCAao2nlDVBMkP4H0NgcIAkA6lJQ+cCnsvkHDQP3Y8OnxgMZtt0Rog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pDXQTGJqz7UX0bvcFlBJAOVkcTZxBZfCbVcX3m8xa6o=;
 b=LCQppRp+bWO57YC/sEUGNkQY5+l9vnc4Zmw2MHWhnmkzg9ujyxxvhu7v62mvCuHXyyPH8N99H8D7DgApfHt6iARBK3S0HTGa3yYL65dJFG+OuO+UM7uKlN+vnHIzcXJPu8F7A5+Ktzs1MLACoiMZb6tRFmnsrdu/kBp9n+piDKX7ZckupkM0QHW06lv53AIaC87RlCx3UKq9b/LdYv1ahcCNzTS+xFDCzmpnP+WDCPaZmwbKRmeUWwuqorStsYgoYUUSiDvSHD4Kkbo+XasfVQk3txzr0/ml86RI5Cayv7gkaHExymAjzYGyUpbzCq9QGTZuUOP6cRiXezgXD3JtKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pDXQTGJqz7UX0bvcFlBJAOVkcTZxBZfCbVcX3m8xa6o=;
 b=FU/qbN8gEcHKganwzFWy8iP1lXgXI1h/KJwRcvgwXHWHuy4t9hngEdmxkkgSCdXKqewhmQicm8LaZgeySp2UOhIeYmQZ4Gl37BQkdZyGDSB83vTU9m+OH3S/hZTx32NN6vwHLyEZtCOIrtCwSgKcIQjXYxWXjRZFtUsm6ZHSVLY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB9376.eurprd04.prod.outlook.com (2603:10a6:102:2b2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24; Thu, 19 Jan
 2023 12:27:42 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.6002.024; Thu, 19 Jan 2023
 12:27:42 +0000
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
Subject: [PATCH v4 net-next 02/12] net: ethtool: add support for MAC Merge layer
Date:   Thu, 19 Jan 2023 14:26:54 +0200
Message-Id: <20230119122705.73054-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230119122705.73054-1-vladimir.oltean@nxp.com>
References: <20230119122705.73054-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM8P189CA0020.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:218::25) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PAXPR04MB9376:EE_
X-MS-Office365-Filtering-Correlation-Id: 20a1e63e-c63a-4a5c-ff77-08dafa188f77
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OQatFh/1cUu0KoseYP123LMoZ5wGY2VozBEftpdN4vMNFQneGfpb2jnZwwPBuTAHbb3+Z9ebdn9AH8PJWe9qgWommvkFElZyp9IRlkITwfJYzs8nDjajkG2GIRdx9kWIEv3Uw68xd0rxNA1jO0jSo8hrApuKez+dybOGiOeA6+JYuIKYZKn9XbHi7F42zSlos9m1tUtD6asPm9xQ8vD7bNBVE6RI8ndZgNAgUGU8N8wzY2YK9yK4Xe4T5uKFK0dEVPwfqlwdEV9HgLDB+cfhyPSHn4l5JQxiYJQiTitWF2OIcOG+VE8QsUFOEylvM9Kv+QylKhY5RK3Ovv7FYIlPILhQw1E5xkD2OhZ38BAqgNShOgvk+qwdeBetgRXufKLLNBsp5Xng80Q/5VQQK92waQnoSo8kvkk0qfAcNXdQKzWwEQOaw0YuA+PCC3oHyubSg5696+XVRFcus6qTbXPYo1PgnJdbXHlijqCMfcrohRCln0BACp6IRDS/QcOVUEttwG9H8CAvcB0H9RF4RaWbWm4lRN3NKhGlG5ejmHfwzvaQcpc9Q2sHs1841shHRFk7tVLdIzCNLNVyuLOEQROLgZ8dt+wfkIlXXopOMAir3NYruSVRBvS6ds+5VdoBjOsnj3vsoKNwkBqCsLS8OJA+2GL/eDQP3ApWZFaealb9AqzCWt6GiSV8cADw+trDx/ukOl47bd+A1nI6aUCoe1ZRASSayr1B4rXrb5Kxzq2s/Ao=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(376002)(136003)(346002)(366004)(451199015)(6506007)(66899015)(66946007)(66476007)(44832011)(30864003)(66556008)(7416002)(8936002)(5660300002)(2906002)(38350700002)(38100700002)(316002)(6666004)(54906003)(52116002)(86362001)(36756003)(4326008)(6486002)(478600001)(6916009)(41300700001)(8676002)(26005)(1076003)(6512007)(186003)(83380400001)(2616005)(134885004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qdlem1iYWE3mGHZJiM7TdqTM1IHezoiGSVOVCpBQDhxK7o7JipNucKm9Mn8m?=
 =?us-ascii?Q?DyAwnfyvu6OSEm6q4yBc1NY6MU7Iw153dVm3VkXbP95yFzMB+VpDmoHzKSJT?=
 =?us-ascii?Q?/JivKF7xaV9dVXj7aJCurNy4eL92K3lMHiPqOWDjgtbK7PAcQfDJKd6E8LRk?=
 =?us-ascii?Q?oX8bAGgd6KqjjcUTzncamC6WWXon2Xl7FaM5vWMQVHuj28TXEdG/k6OyAkiL?=
 =?us-ascii?Q?U9X28EEZQVFouAb5jsJo0kZDXTeXEM2wnlgMVd8Q1Sr7XrugVoUZNlgdRFLh?=
 =?us-ascii?Q?/rQnVMpyyP9Y/KDuMz1Zyf0/R8ddpS1jC7wGQ/2DEqzU83PeRhuNznPCpfXF?=
 =?us-ascii?Q?rXW/+uVXmlh3P84K/cUhE8F7rFj2vSpX9cTOE6CS30MrotYbhtXNJk1wzrMr?=
 =?us-ascii?Q?73TfOjAJDmaQAHaCfgQBXuquelrhznpAmGdm48G6CIdJqOF1X/BZ/O7GGAO3?=
 =?us-ascii?Q?wxX0f/PHndmAnD6mdqhNE9x/jjqyIJ7rkt5es29AdKyIBF3QvsMUoXCF7tk+?=
 =?us-ascii?Q?r3swXus0yokpu323fv/ph/EzOkYyxCPHT3LB4YR8riQHVMKhzDf4MGxyYYqD?=
 =?us-ascii?Q?sYRPCGfmpCD1J6lDypYfvB90teopsitfjNnTsGQcwRL8dtllJf+JrEPSZpnr?=
 =?us-ascii?Q?3VRBoVhnwgeNuzy8XH5FYPV/aLecgvmcM4pFuHzeWrgMKT6lwfS/YOEDTRZZ?=
 =?us-ascii?Q?16H8AMJtDSm6Kwhn51jvE0qddgXqYVW4qnfSwLfaxgRE4SH2mNG6ddzgW3ke?=
 =?us-ascii?Q?NRTu2zAGGaBoOtH0MwrqElEXuxMnZKBppsUNjPBm9qIMzRG7OBs0rgyeD/HZ?=
 =?us-ascii?Q?8HAmxAdtBY/iptR3XQ96LTVDfFkfqG5jxBAGPZC0s76RuhQ2hGj1C+SlWMXX?=
 =?us-ascii?Q?BZd/G+9fv8pDwm6i1yJ/zBHPPyLaDEwkLgSEcbjlVe4Gly0kT0wrOISX5/jl?=
 =?us-ascii?Q?srfJFBCGn6K7BCbJUG/ZA43fz60CxFPnowasTKopwFFR+9lnbRszTLIBLi9X?=
 =?us-ascii?Q?1L2pDB9y4QuDCqNEU/i/ZQGHrvmMJ8VAoouv0tjeKGLzZqguYyS5fPpq3zpf?=
 =?us-ascii?Q?QUQu6k/IkbELe/u9skSSa8xmUy5AYsDvZw8uxQrGHEK98dH4OJ0qWCV+fi1z?=
 =?us-ascii?Q?MBhFb8AY2LTGw2ivc3s7qa01RRM701GhEMP13VL6gAYHBPmCq0KP0R+cD0Tc?=
 =?us-ascii?Q?2/85HsyiNHkqywAZVaHDdMQMB8pEabQZ3WP4LiecwMFWewsItXll58+xtEbM?=
 =?us-ascii?Q?vf9u4Y+o7dyQ5g2GtQzJhRJGZDvMh9hr+4TliOHJFceQfuGNq9F+W3P2D/Nk?=
 =?us-ascii?Q?EeX6Bkq+y7eoqow/w9JgoSESp8XQbaDEONfaE72gbAuNMxwbg8gyfxfhsQw/?=
 =?us-ascii?Q?AaRECUXeVzuDzfYud/052SqI2ND/8erT7ch+U+sjFjdDgt9HiKDKpsIfZmxF?=
 =?us-ascii?Q?nrdWpdGSHIU7ai0+eraBdumGhHB4BzG48IwsALiXC3pU/xDL+bdidcJRRl/N?=
 =?us-ascii?Q?nbEUsOsdGVFCoiJUGVbiN75/bkhG6BRsUlX0i8pqkYzJ8SYfiDC4KohPcTjj?=
 =?us-ascii?Q?RJYyJkzzENluD3XluJTReUDZ9V6cr4pTn5erLnE/WcMKCxWFp5pNQW1GnLCE?=
 =?us-ascii?Q?/A=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20a1e63e-c63a-4a5c-ff77-08dafa188f77
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 12:27:42.5761
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2RR35y+5RTka7TYYLn9mVv85SNNM8PO9kIYF595GhuwBprl2vRmjgng/SNc++jluQAIRgpv0Q1oA2Qed5Fvk3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9376
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
v3->v4:
- moved cfg.verify_time range checking so that it actually takes place
  for the updated rather than old value
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
index 000000000000..76b209ad53d2
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
+	if (cfg.verify_time > state.max_verify_time) {
+		NL_SET_ERR_MSG_ATTR(extack, tb[ETHTOOL_A_MM_VERIFY_TIME],
+				    "verifyTime exceeds device maximum");
+		ret = -ERANGE;
+		goto out_complete;
+	}
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

