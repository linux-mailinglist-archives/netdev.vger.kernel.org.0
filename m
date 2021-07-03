Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 522D73BA899
	for <lists+netdev@lfdr.de>; Sat,  3 Jul 2021 13:58:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230263AbhGCMBR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Jul 2021 08:01:17 -0400
Received: from mail-eopbgr20063.outbound.protection.outlook.com ([40.107.2.63]:47491
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230257AbhGCMBK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 3 Jul 2021 08:01:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pjj69hrcgj87/Mh5yJsgomjKQho/d26HOtv/jav43H1H7nNZsculf9tpreVs9A21UyoHyuPWxidFGiU/T277z3uhTu+HWvUrNV1SRTT/rRrehmzXXdtB3nFA6nBZAQ+/K5TxsYzspt4Kcb5FUl2zmJkFOJivHQdQucArekizCIlSgw+wO2XwgjGcFtOkoRtdubnjbOemDRqZ8nmC0E96WerUb8cgxuEe3EqY8+PouiCq7ZK/HNvxe4PnUJeLJhpO7jDkOQ9AOnc+gbP21/tOh+wzyrwfpZfOUni0JNcFlyhezYciYC+vi17yQVJNZcvDLXrIupg5IiWjE/PQo3QfMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tdrmZRU0Q37EP78FtXBrjURVRoxh9R2XUtsYeAyE8XM=;
 b=JkHiXBI173Dsp1+sDWXDLr2rXVvljYc7YWqCyG/Zi3appSTClhxpIgm2V/x4IDuTNNtH0cc6FT92GLEqf4+A6ytSZX9YQM5/BBXxVGR/TU3dC0PyDBC7r6JpHnfJBmmteRUyCvXYO5bpXQJgC4ZCdQQt3pfniJIkjp5eqY2SWwONHrdpz9fVWdJCaBBEtMNkEsEcjI1UeFquP9hv2HdgeNST7wXltDIPYJUmZyd0aKaONthGvPTx8B+9veq8v9Zp0lSPFcYPBfFzzp8UFA+26T/Lt2JpuU/m98gfbpo775ZkSOTHOfLMjVDq3MYKRLfBDmVdF/6PIQvgMFUgwfK+uQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tdrmZRU0Q37EP78FtXBrjURVRoxh9R2XUtsYeAyE8XM=;
 b=UGHdQghISd2IvCvLLHDKUWCf3tq/Op8H+TK3twnw+TjCwHBEYlwa+Y835DSieZFT2m9dWJ5Cqdqhq5yY00/MXJ+ntU5dx5KJbEyfyxLJ0AjCGIOGmQeBOWK3WJfjb9GM034hBS8y3SUhCQkBjnw1S8jfpZ5Qt7spnTM137Dc6rk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2509.eurprd04.prod.outlook.com (2603:10a6:800:56::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.22; Sat, 3 Jul
 2021 11:58:33 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab%7]) with mapi id 15.20.4287.031; Sat, 3 Jul 2021
 11:58:33 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        bridge@lists.linux-foundation.org,
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: [RFC PATCH v2 net-next 05/10] net: extract helpers for binding a subordinate device to TX queues
Date:   Sat,  3 Jul 2021 14:57:00 +0300
Message-Id: <20210703115705.1034112-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210703115705.1034112-1-vladimir.oltean@nxp.com>
References: <20210703115705.1034112-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.26.224.68]
X-ClientProxiedBy: PR3P189CA0081.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:102:b4::26) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.26.224.68) by PR3P189CA0081.EURP189.PROD.OUTLOOK.COM (2603:10a6:102:b4::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.23 via Frontend Transport; Sat, 3 Jul 2021 11:58:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 68f8265a-71c0-4113-ed45-08d93e19e1d6
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2509:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB250983591CDA0649C1C47C42E01E9@VI1PR0401MB2509.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Wh44hv8aDm2gMTn5HpRk7BwmbhudMOsUrH9Yhx6Q/tq9Vs4h7TNaklRkjJdWs3JMHUaSUor2WuNS6p+MiE7GrGeuj+H0V3MRCOXgb6+cZD5Q/m0Xu5seexKVfr/6JFgOVAhpxO8WnrviqUSu4ccmS13vcyJyHZ84PfvY56v2BtGd8B1eHYKycU7p3y0deEWg79KnYbFtXEpUZTq9mdOorUA+mgFzTARaO3WZruuK6wamvLyuimoo9GKOPN5ypSOSoKdNtYrzATyHxxr5j4sspmmenFbBYN7fqlkOPzZ5kyIwOnAb36YzfMdFm2vUhv7XYEJkwOuqao9niGFoM1MD6sm5XxO7FSAgER+rFIbqkhizQgN+HnUgXqJri6O78ubr3FiUmG8kPxc5/l/MPCNlbNQoPgnJ4SfqWk78J28Hh8trdvkiWAY8w3EQc4hYRibiuZqHY6TkpRPQHk6nsvHdr176jwBDaDscVjEzZYVWZrNkfsmt9XpvjqQFjboZiyoR8i3W+ZUxlbKT/0q12Fe4hRkH56Jyq1u/gctuPTZqCr9dKKlmSxz9iTlEhg7Zw5Fzre6NZyoaCdzO6Qraz2UKktwogrs7stSrlGXvtZkYjBIh4auJhCbWksIrT3tWV+lnpv0r5L8AcU5cHa/qKvC1QivbpWttnR0HH1bhMsLXuWXWbgo8KZEZiedBNxrT5Ejiq+Go2QKCev/BypobXtV4DZq5D4Ux3iyyH5MokYaKaow6hdhYZpC2M/WgXHoJ9FWG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(366004)(346002)(136003)(39850400004)(6506007)(2906002)(4326008)(36756003)(2616005)(44832011)(956004)(6666004)(478600001)(7416002)(5660300002)(110136005)(66946007)(26005)(52116002)(1076003)(8676002)(8936002)(316002)(54906003)(66476007)(66556008)(6486002)(38100700002)(16526019)(38350700002)(186003)(83380400001)(86362001)(6512007)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?38GSF9kvT0iL88mkp0qzoWe7slaIGte2RLozogRF8EFBaf4+54FdIzOWoUNe?=
 =?us-ascii?Q?gGN+N/+rupuguRTC/yqFFvA4frr1JVGse78+iHrP9kVrEVroJy3hJNeozMh6?=
 =?us-ascii?Q?LatAYD9QoZUAiCmdNbBh8wmIGpmgnfy96DncmhU43MfxKP9z+EA6wh6x5LTc?=
 =?us-ascii?Q?V2y7ZbX1qjeeaBXLj98+NBdgsn0Pke5XMClAXeIRdMkov90dUzxBdhJSMWd2?=
 =?us-ascii?Q?MRP1Xe27zgtdVVBYOwnCQ0pUxFEDOFmY0rmaADi7FPDwvccmdoQ/cKJxh9cU?=
 =?us-ascii?Q?Rcw08cL0kpRDyGcisV2y4WCfdSKySATYX2m+iDRVMcCMQPRHe9BSed/EKzcT?=
 =?us-ascii?Q?mpQrM0Ta2pq+uLwGWfIukIiCpLJIxEXq9W96/eJ5//96Xt1E6ePGwgD1JU27?=
 =?us-ascii?Q?KUE8LgQB1/F8oV464BmwhQu76Cv5K8g1vP6cl1zOwXjT2Vu8zA3aV4HORtDh?=
 =?us-ascii?Q?7uzhJ59rkunZEX994jCbi3pKytPuqrRY9WE/7FW8RSf5Ao1ysByoqN4rP7eO?=
 =?us-ascii?Q?7INiOcmPfpxULaALUdScEBDtDBkvOJfKVcECSgPPKL5T+yWcr+gORuudRvJR?=
 =?us-ascii?Q?jdxR+4bZ2EzzxkiYMP+NtkVX5bL8XD9L4tx8rPtDLHuMEQXxIe3scV66Lx5y?=
 =?us-ascii?Q?rHZ8/tW17ye1xPH79nP6DUzMsPO6+jx2laGYQGJdt6hcT4vdcSsQLa/eIuOS?=
 =?us-ascii?Q?w8TKez0suVCPpSFkAihqFcj3OWh/u9rt7tiTXfrhcQpcE4mo3L7TjQOjPP3x?=
 =?us-ascii?Q?PvKUI9doH1kXeDgE9Iztj7CR1bizqbIfX1K/NGHsU7AMG7zXZOEJVWtU3djj?=
 =?us-ascii?Q?gTA8KeUIjIU421G9vipyX/pjsBYMTv2xdn1LNOTHQGeJBn4Ya/hO724T4inc?=
 =?us-ascii?Q?LUUXMPdHo+G/NuJsYvg0D9JAxGi1e0aaLgi0VIqJ+o05vWSJBTKxUjIjYUbA?=
 =?us-ascii?Q?p9QXWJeK7xdmScEWU1yjUM5rD1hHqY3imjo/3AQXdLU7cnsYd2b80nErTd+P?=
 =?us-ascii?Q?pB3R5fVxtoyxiKcpaHtqpH6IWj4jhN9IT2eIlnNcrKIOTfpP4MuCaVIJ9XkY?=
 =?us-ascii?Q?ugMP6o01CJbqSKSdMD964Gtzj2y/900WhsBzrDTA3slAzWVDpty6ksBw+34+?=
 =?us-ascii?Q?5zX5NGdhMYCk67yHwoC6t+B77r5y4C9s3KlxnA6ZAFXQUSf9CDgE8iDGC5Ru?=
 =?us-ascii?Q?J1PRTptbMiqMEbXLj7JGLaChl1HKJev7VXTCFPplfmyEKD3sPyGWkPRrQlfo?=
 =?us-ascii?Q?BMC03k4tD7M1dj+jd1M37kUcl5TevjmEmbjWyWTFic9RZKmpdP61DgRqezKt?=
 =?us-ascii?Q?lqDQXoTK/nf4VZJsSCVy5J76?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68f8265a-71c0-4113-ed45-08d93e19e1d6
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2021 11:58:33.5438
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IYvNMaogPc+CwWUm2VD6OqhyheNUw2cFuJPHKfWy+JXT6wFQje5werwFelDc9ukgWtL0Xw1LZ18HEH0wurWeXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2509
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, the acceleration scheme for offloading the data plane of
upper devices to hardware is geared towards a single topology: that of
macvlan interfaces, where there is a lower interface with many uppers.

We would like to use the same acceleration framework for the bridge data
plane, but there we have a single upper interface with many lowers.

This matters because commit ffcfe25bb50f ("net: Add support for
subordinate device traffic classes") has pulled some logic out of
ixgbe_select_queue() and moved it into net/core/dev.c as if it was
generic enough to do so. In particular, it created a scheme where:

- ixgbe calls netdev_set_sb_channel() on the macvlan interface, which
  changes the macvlan's dev->num_tc to a negative value (-channel).
  The value itself is not used anywhere in any relevant manner, it only
  matters that it's negative, because:
- when ixgbe calls netdev_bind_sb_channel_queue(), the macvlan is
  checked for being configured as a subordinate channel (its num_tc must
  be smaller than zero) and its tc_to_txq guts are being scavenged to
  hold what ixgbe puts in it (for each traffic class, a mapping is
  recorded towards an ixgbe TX ring dedicated to that macvlan). This is
  safe because "we can pretty much guarantee that the tc_to_txq mappings
  and XPS maps for the upper device are unused".
- when a packet is to be transmitted on the ixgbe interface on behalf of
  a macvlan upper and a TX queue is to be selected, netdev_pick_tx() ->
  skb_tx_hash() looks at the tc_to_txq array of the macvlan sb_dev,
  which was populated by ixgbe. The packet reaches the dedicated TX ring.

Fun, but netdev hierarchies with one upper and many lowers cannot do
this, because if multiple lowers tried to lay their eggs into the same
tc_to_txq array of the same upper, they would have to coordinate somehow.
So it doesn't quite work.

But nonetheless, to make sure of the subordinate device concept, we need
access to the sb_dev in the ndo_start_xmit() method, and the only place
we can retrieve it from is:

	netdev_get_tx_queue(dev, skb_get_queue_mapping(skb))->sb_dev

So we need that pointer populated and not much else.

Refactor the code which assigns the subordinate device pointer per lower
interface TX queue into a dedicated set of helpers and export it.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/linux/netdevice.h |  7 +++++++
 net/core/dev.c            | 31 +++++++++++++++++++++++--------
 2 files changed, 30 insertions(+), 8 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index eaf5bb008aa9..16c88e416693 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2301,6 +2301,13 @@ static inline void net_prefetchw(void *p)
 #endif
 }
 
+void netdev_bind_tx_queues_to_sb_dev(struct net_device *dev,
+				     struct net_device *sb_dev,
+				     u16 count, u16 offset);
+
+void netdev_unbind_tx_queues_from_sb_dev(struct net_device *dev,
+					 struct net_device *sb_dev);
+
 void netdev_unbind_sb_channel(struct net_device *dev,
 			      struct net_device *sb_dev);
 int netdev_bind_sb_channel_queue(struct net_device *dev,
diff --git a/net/core/dev.c b/net/core/dev.c
index c253c2aafe97..02e3a6941381 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2957,21 +2957,37 @@ int netdev_set_num_tc(struct net_device *dev, u8 num_tc)
 }
 EXPORT_SYMBOL(netdev_set_num_tc);
 
-void netdev_unbind_sb_channel(struct net_device *dev,
-			      struct net_device *sb_dev)
+void netdev_bind_tx_queues_to_sb_dev(struct net_device *dev,
+				     struct net_device *sb_dev,
+				     u16 count, u16 offset)
+{
+	while (count--)
+		netdev_get_tx_queue(dev, count + offset)->sb_dev = sb_dev;
+}
+EXPORT_SYMBOL_GPL(netdev_bind_tx_queues_to_sb_dev);
+
+void netdev_unbind_tx_queues_from_sb_dev(struct net_device *dev,
+					 struct net_device *sb_dev)
 {
 	struct netdev_queue *txq = &dev->_tx[dev->num_tx_queues];
 
+	while (txq-- != &dev->_tx[0]) {
+		if (txq->sb_dev == sb_dev)
+			txq->sb_dev = NULL;
+	}
+}
+EXPORT_SYMBOL_GPL(netdev_unbind_tx_queues_from_sb_dev);
+
+void netdev_unbind_sb_channel(struct net_device *dev,
+			      struct net_device *sb_dev)
+{
 #ifdef CONFIG_XPS
 	netif_reset_xps_queues_gt(sb_dev, 0);
 #endif
 	memset(sb_dev->tc_to_txq, 0, sizeof(sb_dev->tc_to_txq));
 	memset(sb_dev->prio_tc_map, 0, sizeof(sb_dev->prio_tc_map));
 
-	while (txq-- != &dev->_tx[0]) {
-		if (txq->sb_dev == sb_dev)
-			txq->sb_dev = NULL;
-	}
+	netdev_unbind_tx_queues_from_sb_dev(dev, sb_dev);
 }
 EXPORT_SYMBOL(netdev_unbind_sb_channel);
 
@@ -2994,8 +3010,7 @@ int netdev_bind_sb_channel_queue(struct net_device *dev,
 	/* Provide a way for Tx queue to find the tc_to_txq map or
 	 * XPS map for itself.
 	 */
-	while (count--)
-		netdev_get_tx_queue(dev, count + offset)->sb_dev = sb_dev;
+	netdev_bind_tx_queues_to_sb_dev(dev, sb_dev, count, offset);
 
 	return 0;
 }
-- 
2.25.1

