Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A1A96D37E2
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 14:38:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230350AbjDBMie (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 08:38:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjDBMiY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 08:38:24 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2073.outbound.protection.outlook.com [40.107.20.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71CEF1B368
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 05:38:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b/2pFjBrlr9Wv9wv2tn7xeTVRTo2yMpHikxGSr4jTpoeJRNEe1s0DvWLMVfr/KXt+q0pbelxJ5HtEZp7yMhOvZwidXyfK8gKRH2uZFD+CsImP8fhFQM0q+60O2kkHnmYBBIYdLIvFpC6sQL7FhfaKpopHj3clZ/s7YzaqN6sY7WHdmbASO8bbwebOF6QC8OeifCfP4K/mmQW6W64cF0gVZhnutTMud/eKLgUnxsdxGDzk2IVy+/Xlr5D1OmRYmsCK3w0n9FlyhXpEY/N8mxBDq0gpW9qMcqypdjZxSK8N+U2Xk+qg+9oJQTc0JQBCrrIqI7i+vLCYYHBuD0GGCr+mQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9Fje+wdwt/MLubd8R3uVtOO49MpN5KL/YruQyK+mjHA=;
 b=h6pUPQ6d7VYD0vzlmTTlBWwaSJOk9X34aFFaBghCAMYpKasAjLrx6t5xagXAUidg2X982kQOzEWfxt+9ES047toOc4WZaOnqeLHfEmaUwm9U1zr6J6JqbIWsWhssNrnjrWxAU7xWfqFCFnsWjBQvNkZ+28I0jykG84DNC4izxgZHcfGyUeahO+FuX26ikfPt6aiF5B4NdwhrBgL5JvRedVFcjeAxGhh7gAomsxc6eXeXmgjwUB9hCgreQnaxluPGwJsUjbkK9MgeIC2qbeD/onnN0L002Wgf7YVyrU+girVkgIxBAEtPqRm58um9VNQmBCtru/Qk4QNAloWPk58t8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9Fje+wdwt/MLubd8R3uVtOO49MpN5KL/YruQyK+mjHA=;
 b=huSXMCk7n/8chET1dt8NJ0zBK2JqkeHQOHBZtd24EejLi06o3zcwkqzSuaPO0Fgt6wrCrMkHXgLlazClRPevKtQnmZPnzB4eUVi470IEQ2ZMiMoqXihiZadb/Btf+xaoNdOKzhVMJVcdv2fgjFHgIN/qIIf9OEzrcNAWB0E0raU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by VI1PR04MB10052.eurprd04.prod.outlook.com (2603:10a6:800:1db::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.28; Sun, 2 Apr
 2023 12:38:15 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::dfa2:5d65:fad:a2a5%3]) with mapi id 15.20.6254.026; Sun, 2 Apr 2023
 12:38:15 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Maxim Georgiev <glipus@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        =?UTF-8?q?K=C3=B6ry=20Maincent?= <kory.maincent@bootlin.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>
Subject: [PATCH net-next 7/7] net: create a netdev notifier for DSA to reject PTP on DSA master
Date:   Sun,  2 Apr 2023 15:37:55 +0300
Message-Id: <20230402123755.2592507-8-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230402123755.2592507-1-vladimir.oltean@nxp.com>
References: <20230402123755.2592507-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0018.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::28) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|VI1PR04MB10052:EE_
X-MS-Office365-Filtering-Correlation-Id: e8d82cd6-64d7-485d-8b66-08db33772116
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Q8tJ9/7C9Avy1fWfvg8GFSFxCOLiSS2LQNG14URI/cRFDWRXgsA5AVoepwiGOEtKVGHBu3audprUGlAzK4JjxNc7Rre4F6PnpHvzyb4M4bZM5TlpHy1IJEb5giZ5hjPwtx2a8ncrowFax5RPBn2mLAGbYmAUnLQKetuA/TRlL+qQmRCVaNESt48M0DsXR/nMKK9gxpDyVQdnVtxniKA3X18dImKiIOQEXbKKlhTOrp/SGAI0+H+R9UJmjro8ASgTw4lHnA20yjDZj08d/9rtJyXON3usGMtZLOBCzsKWpM7yOKvbYepVIZRHTx2i7iW+DWlF42+FbCwuvyx/7H6wZyWK2tZKXIcw/mZhpVS7iPOlQnxM4cAZu0AmUVMCificBBADDL7IRa++9DQtfbhjvZl9oWsYY3MhZWYJC0TTT6Vzn5eEU3bFVIy1lPkCQHlazmLrqpKgkqV+AEZdfc0hkAXiRyR+iZPMCaG3GcBFtmwaolf4WYr0kuH/MpIL6fqqJ/36ljigR6bK3aMSnIRv7gO6rFLvyNJzdLacdN4yN+PXGqrplk9HFA7QvJUEetdxFmJWjwQzklirLehgbIZsXHihv8tzVf06Q9Zjikc/vnBjH3a0wvIcET8l+NO7Nfgl21QdRIW8M/wLVuSSDhNy3A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39850400004)(396003)(136003)(376002)(366004)(346002)(451199021)(66476007)(86362001)(36756003)(83380400001)(52116002)(41300700001)(316002)(66946007)(54906003)(6486002)(966005)(4326008)(66556008)(6916009)(8676002)(478600001)(7416002)(30864003)(5660300002)(44832011)(2906002)(38100700002)(38350700002)(186003)(6506007)(6666004)(1076003)(26005)(6512007)(2616005)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4uwFmgRM2Sz+Yk62uTlhQRIer6R7JGtJXhWkpMmuOUwtXMlcPGaVFoQK5W1t?=
 =?us-ascii?Q?rxJBfhwalxvO3PMrbXmn8isekvo66hcEaWWQfFSKGZNoBW9KAil2XovgeQnN?=
 =?us-ascii?Q?wIiu88ofrpFYRQj1K9qqkmOHISq6wDl5uv/F9nxEuRrEzO3KbU4ULRA1oXBg?=
 =?us-ascii?Q?REtG8m2tz3T0GuvdK5dCXMxjmOjopqDRyoaFXjclUDRn1GnC4meAzZOnkHB2?=
 =?us-ascii?Q?ajjhgeLhy0QGa+q/TgW7cChRPDCXIBQMFIb19usIx9NzcOoGrCGUb95NB6S7?=
 =?us-ascii?Q?1DEewGgwXJtDTKh/fohayx8/XPGS+hCsO4IGRw2wLnSIjA/lLNA4/mSumYns?=
 =?us-ascii?Q?qdeztkjSEfrhYw/S2FHRbe7rVC2wYaqeUL0Hia9zK4wWoqx6zakX6UzKejlm?=
 =?us-ascii?Q?JXyDaM2eBU0Txnip6VOPagBOChf+czEDfwcYqs85IIEuRCsDMLF8KrXd5QRV?=
 =?us-ascii?Q?biuoVh8W/WsaL0se6S7ngpfTuaiDDf6XOT8iGA4W40wsZednDkhxe1mDrOtf?=
 =?us-ascii?Q?L3eyCwZv4A6OpyKktT6GyhQRvbn3rDd6e9VjTebcKcmGIQjTcFZBNhyCT/JR?=
 =?us-ascii?Q?XxftUNV5RKtGeIOYUugP2GtLfq4NaDh/DnzPpZLyrysn/G8nQ3wnhSYc6YJw?=
 =?us-ascii?Q?oB9P7PmVMdMxR0gn01B3ZPLLttSiZziX0nAj2H1ipLrQBqi0pSo4Xq3vvSUG?=
 =?us-ascii?Q?7CuqvxO3Ja/B1a6SU2H0RjiINijBpVkvEjCixKjy+Q2yrH1OWgkFlYgn9Jrw?=
 =?us-ascii?Q?oD95UpzDDui71I9d/JEtiAWPje9ZkLH9XRTbl5zatynnVFa31Uu4eT6neURW?=
 =?us-ascii?Q?+gKvdIEf1N0SvcefVJLV8mFSt9KTWBaxkv7pRl1EwZjQzMPZLmf4VEHuqOgo?=
 =?us-ascii?Q?r7sT3cLuZYDEag87qxToYoAWWue4K5WWFondJMMYnVIKEPAyP4nAIiJlgLTQ?=
 =?us-ascii?Q?zfh2DczrdS5rcdkoAg25yLqa1CTCLpM+eRk0A4htXtZqXvNoCJSZga3s+YPS?=
 =?us-ascii?Q?F2yhUFjQw/un39QrCEIZ0WFJSMq/j8+Er8nxnVjNQsXoQBBGUMFkHD2OrehF?=
 =?us-ascii?Q?Be3ebL8cJ7GRO5p2rvymnMRyz2K0ucA9LBZ/pz3XpfMhNjhPsqxdeu0kZnyG?=
 =?us-ascii?Q?hRXBfBkKrky8QEO2uXpx2qE7ZqXW6TD3d2z8C9jir1Kcdu5pTXKCLFMETImj?=
 =?us-ascii?Q?tAojzQEz+oeJzs8B+h+JV/KqGlMHVZLlP7ud9wsglPSgq5mmvtbIUgi8IegG?=
 =?us-ascii?Q?J9oFl0LRbhTX4BIZ+1Xi/WAdvPoaZwf+epE1UroV098I9QzYpTyffN+Kc9lV?=
 =?us-ascii?Q?+y0JY+khWAQQOm7oQ1FPDMWTjuFrkQ3zWX2MG66cEHUzEQPyvEcc3q7EvDhk?=
 =?us-ascii?Q?chiH6y4DIDYLqg6Qpy3Lgrz6Nkp6LlVN9z9SO6ZtWmOJGPnGpk1tEjx21tMj?=
 =?us-ascii?Q?hxEKlkskjvr6SBTbTo0+77CoYFmum/GcnnUHYxEUl8YCmd5W2jrDbiVFEEXg?=
 =?us-ascii?Q?3neEtapnWfyBVA/qFH/blMuxLZPbNpfTXNjFp4SWNCAdL5pd2uA8+pMlfUYp?=
 =?us-ascii?Q?nItgTJxO2AZvV4yp6n+dUVML/0Mk0wuRqpSwNXPbvPxPV37Mw+KU+shnl1bP?=
 =?us-ascii?Q?6g=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8d82cd6-64d7-485d-8b66-08db33772116
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2023 12:38:15.4183
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ljo+FTVilU+xrte0YWnuTOUKObXlBZcuNgik+9S2WNap1drfzVkbnvjlFkf1+5t8N8VWlE3Lw85QFminiWfFRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB10052
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The fact that PTP 2-step TX timestamping is broken on DSA switches if
the master also timestamps the same packets is documented by commit
f685e609a301 ("net: dsa: Deny PTP on master if switch supports it").
We attempt to help the users avoid shooting themselves in the foot by
making DSA reject the timestamping ioctls on an interface that is a DSA
master, and the switch tree beneath it contains switches which are aware
of PTP.

The only problem is that there isn't an established way of intercepting
ndo_eth_ioctl calls, so DSA creates avoidable burden upon the network
stack by creating a struct dsa_netdevice_ops with overlaid function
pointers that are manually checked from the relevant call sites. There
used to be 2 such dsa_netdevice_ops, but now, ndo_eth_ioctl is the only
one left.

There is an ongoing effort to migrate driver-visible hardware timestamping
control from the ndo_eth_ioctl() based API to a new ndo_hwtstamp_set()
model, but DSA actively prevents that migration, since dsa_master_ioctl()
is currently coded to manually call the master's legacy ndo_eth_ioctl(),
and so, whenever a network device driver would be converted to the new
API, DSA's restrictions would be circumvented, because any device could
be used as a DSA master.

The established way for unrelated modules to react on a net device event
is via netdevice notifiers. So we create a new notifier which gets
called whenever there is an attempt to change hardware timestamping
settings on a device.

Finally, there is another reason why a netdev notifier will be a good
idea, besides strictly DSA, and this has to do with PHY timestamping.

With ndo_eth_ioctl(), all MAC drivers must manually call
phy_has_hwtstamp() before deciding whether to act upon SIOCSHWTSTAMP,
otherwise they must pass this ioctl to the PHY driver via
phy_mii_ioctl().

With the new ndo_hwtstamp_set() API, it will be desirable to simply not
make any calls into the MAC device driver when timestamping should be
performed at the PHY level.

But there exist drivers, such as the lan966x switch, which need to
install packet traps for PTP regardless of whether they are the layer
that provides the hardware timestamps, or the PHY is. That would be
impossible to support with the new API.

The proposal there, too, is to introduce a netdev notifier which acts as
a better cue for switching drivers to add or remove PTP packet traps,
than ndo_hwtstamp_set(). The one introduced here "almost" works there as
well, except for the fact that packet traps should only be installed if
the PHY driver succeeded to enable hardware timestamping, whereas here,
we need to deny hardware timestamping on the DSA master before it
actually gets enabled. This is why this notifier is called "PRE_", and
the notifier that would get used for PHY timestamping and packet traps
would be called NETDEV_CHANGE_HWTSTAMP. This isn't a new concept, for
example NETDEV_CHANGEUPPER and NETDEV_PRECHANGEUPPER do the same thing.

In expectation of future netlink UAPI, we also pass a non-NULL extack
pointer to the netdev notifier, and we make DSA populate it with an
informative reason for the rejection. To avoid making it go to waste, we
make the ioctl-based dev_set_hwtstamp() create a fake extack and print
the message to the kernel log.

Link: https://lore.kernel.org/netdev/20230401191215.tvveoi3lkawgg6g4@skbuf/
Link: https://lore.kernel.org/netdev/20230310164451.ls7bbs6pdzs4m6pw@skbuf/
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/linux/netdevice.h |  9 ++++++-
 include/net/dsa.h         | 51 ---------------------------------------
 net/core/dev.c            |  8 +++---
 net/core/dev_ioctl.c      | 16 ++++++++++--
 net/dsa/master.c          | 50 ++++++++++++--------------------------
 net/dsa/master.h          |  3 +++
 net/dsa/slave.c           | 11 +++++++++
 7 files changed, 54 insertions(+), 94 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index c8c634091a65..336c62e5df3b 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2877,6 +2877,7 @@ enum netdev_cmd {
 	NETDEV_OFFLOAD_XSTATS_REPORT_USED,
 	NETDEV_OFFLOAD_XSTATS_REPORT_DELTA,
 	NETDEV_XDP_FEAT_CHANGE,
+	NETDEV_PRE_CHANGE_HWTSTAMP,
 };
 const char *netdev_cmd_to_name(enum netdev_cmd cmd);
 
@@ -2927,6 +2928,11 @@ struct netdev_notifier_pre_changeaddr_info {
 	const unsigned char *dev_addr;
 };
 
+struct netdev_notifier_hwtstamp_info {
+	struct netdev_notifier_info info; /* must be first */
+	struct kernel_hwtstamp_config *config;
+};
+
 enum netdev_offload_xstats_type {
 	NETDEV_OFFLOAD_XSTATS_TYPE_L3 = 1,
 };
@@ -2983,7 +2989,8 @@ netdev_notifier_info_to_extack(const struct netdev_notifier_info *info)
 }
 
 int call_netdevice_notifiers(unsigned long val, struct net_device *dev);
-
+int call_netdevice_notifiers_info(unsigned long val,
+				  struct netdev_notifier_info *info);
 
 extern rwlock_t				dev_base_lock;		/* Device list lock */
 
diff --git a/include/net/dsa.h b/include/net/dsa.h
index a15f17a38eca..8903053fa5aa 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -109,16 +109,6 @@ struct dsa_device_ops {
 	bool promisc_on_master;
 };
 
-/* This structure defines the control interfaces that are overlayed by the
- * DSA layer on top of the DSA CPU/management net_device instance. This is
- * used by the core net_device layer while calling various net_device_ops
- * function pointers.
- */
-struct dsa_netdevice_ops {
-	int (*ndo_eth_ioctl)(struct net_device *dev, struct ifreq *ifr,
-			     int cmd);
-};
-
 struct dsa_lag {
 	struct net_device *dev;
 	unsigned int id;
@@ -317,11 +307,6 @@ struct dsa_port {
 	 */
 	const struct ethtool_ops *orig_ethtool_ops;
 
-	/*
-	 * Original copy of the master netdev net_device_ops
-	 */
-	const struct dsa_netdevice_ops *netdev_ops;
-
 	/* List of MAC addresses that must be forwarded on this port.
 	 * These are only valid on CPU ports and DSA links.
 	 */
@@ -1339,42 +1324,6 @@ static inline void dsa_tag_generic_flow_dissect(const struct sk_buff *skb,
 #endif
 }
 
-#if IS_ENABLED(CONFIG_NET_DSA)
-static inline int __dsa_netdevice_ops_check(struct net_device *dev)
-{
-	int err = -EOPNOTSUPP;
-
-	if (!dev->dsa_ptr)
-		return err;
-
-	if (!dev->dsa_ptr->netdev_ops)
-		return err;
-
-	return 0;
-}
-
-static inline int dsa_ndo_eth_ioctl(struct net_device *dev, struct ifreq *ifr,
-				    int cmd)
-{
-	const struct dsa_netdevice_ops *ops;
-	int err;
-
-	err = __dsa_netdevice_ops_check(dev);
-	if (err)
-		return err;
-
-	ops = dev->dsa_ptr->netdev_ops;
-
-	return ops->ndo_eth_ioctl(dev, ifr, cmd);
-}
-#else
-static inline int dsa_ndo_eth_ioctl(struct net_device *dev, struct ifreq *ifr,
-				    int cmd)
-{
-	return -EOPNOTSUPP;
-}
-#endif
-
 void dsa_unregister_switch(struct dsa_switch *ds);
 int dsa_register_switch(struct dsa_switch *ds);
 void dsa_switch_shutdown(struct dsa_switch *ds);
diff --git a/net/core/dev.c b/net/core/dev.c
index 0c4b21291348..7ce5985be84b 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -160,8 +160,6 @@ struct list_head ptype_base[PTYPE_HASH_SIZE] __read_mostly;
 struct list_head ptype_all __read_mostly;	/* Taps */
 
 static int netif_rx_internal(struct sk_buff *skb);
-static int call_netdevice_notifiers_info(unsigned long val,
-					 struct netdev_notifier_info *info);
 static int call_netdevice_notifiers_extack(unsigned long val,
 					   struct net_device *dev,
 					   struct netlink_ext_ack *extack);
@@ -1614,7 +1612,7 @@ const char *netdev_cmd_to_name(enum netdev_cmd cmd)
 	N(SVLAN_FILTER_PUSH_INFO) N(SVLAN_FILTER_DROP_INFO)
 	N(PRE_CHANGEADDR) N(OFFLOAD_XSTATS_ENABLE) N(OFFLOAD_XSTATS_DISABLE)
 	N(OFFLOAD_XSTATS_REPORT_USED) N(OFFLOAD_XSTATS_REPORT_DELTA)
-	N(XDP_FEAT_CHANGE)
+	N(XDP_FEAT_CHANGE) N(PRE_CHANGE_HWTSTAMP)
 	}
 #undef N
 	return "UNKNOWN_NETDEV_EVENT";
@@ -1919,8 +1917,8 @@ static void move_netdevice_notifiers_dev_net(struct net_device *dev,
  *	are as for raw_notifier_call_chain().
  */
 
-static int call_netdevice_notifiers_info(unsigned long val,
-					 struct netdev_notifier_info *info)
+int call_netdevice_notifiers_info(unsigned long val,
+				  struct netdev_notifier_info *info)
 {
 	struct net *net = dev_net(info->dev);
 	int ret;
diff --git a/net/core/dev_ioctl.c b/net/core/dev_ioctl.c
index c532ef4d5dff..6d772837eb3f 100644
--- a/net/core/dev_ioctl.c
+++ b/net/core/dev_ioctl.c
@@ -259,7 +259,11 @@ static int dev_get_hwtstamp(struct net_device *dev, struct ifreq *ifr)
 
 static int dev_set_hwtstamp(struct net_device *dev, struct ifreq *ifr)
 {
+	struct netdev_notifier_hwtstamp_info info = {
+		.info.dev = dev,
+	};
 	struct kernel_hwtstamp_config kernel_cfg;
+	struct netlink_ext_ack extack = {};
 	struct hwtstamp_config cfg;
 	int err;
 
@@ -272,9 +276,17 @@ static int dev_set_hwtstamp(struct net_device *dev, struct ifreq *ifr)
 	if (err)
 		return err;
 
-	err = dsa_ndo_eth_ioctl(dev, ifr, SIOCSHWTSTAMP);
-	if (err != -EOPNOTSUPP)
+	info.info.extack = &extack;
+	info.config = &kernel_cfg;
+
+	err = call_netdevice_notifiers_info(NETDEV_PRE_CHANGE_HWTSTAMP,
+					    &info.info);
+	err = notifier_to_errno(err);
+	if (err) {
+		if (extack._msg)
+			netdev_err(dev, "%s\n", extack._msg);
 		return err;
+	}
 
 	return dev_eth_ioctl(dev, ifr, SIOCSHWTSTAMP);
 }
diff --git a/net/dsa/master.c b/net/dsa/master.c
index e397641382ca..c2cabe6248b1 100644
--- a/net/dsa/master.c
+++ b/net/dsa/master.c
@@ -195,38 +195,31 @@ static void dsa_master_get_strings(struct net_device *dev, uint32_t stringset,
 	}
 }
 
-static int dsa_master_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
+/* Deny PTP operations on master if there is at least one switch in the tree
+ * that is PTP capable.
+ */
+int dsa_master_pre_change_hwtstamp(struct net_device *dev,
+				   const struct kernel_hwtstamp_config *config,
+				   struct netlink_ext_ack *extack)
 {
 	struct dsa_port *cpu_dp = dev->dsa_ptr;
 	struct dsa_switch *ds = cpu_dp->ds;
 	struct dsa_switch_tree *dst;
-	int err = -EOPNOTSUPP;
 	struct dsa_port *dp;
 
 	dst = ds->dst;
 
-	switch (cmd) {
-	case SIOCGHWTSTAMP:
-	case SIOCSHWTSTAMP:
-		/* Deny PTP operations on master if there is at least one
-		 * switch in the tree that is PTP capable.
-		 */
-		list_for_each_entry(dp, &dst->ports, list)
-			if (dsa_port_supports_hwtstamp(dp))
-				return -EBUSY;
-		break;
+	list_for_each_entry(dp, &dst->ports, list) {
+		if (dsa_port_supports_hwtstamp(dp)) {
+			NL_SET_ERR_MSG(extack,
+				       "HW timestamping not allowed on DSA master when switch supports the operation");
+			return -EBUSY;
+		}
 	}
 
-	if (dev->netdev_ops->ndo_eth_ioctl)
-		err = dev->netdev_ops->ndo_eth_ioctl(dev, ifr, cmd);
-
-	return err;
+	return 0;
 }
 
-static const struct dsa_netdevice_ops dsa_netdev_ops = {
-	.ndo_eth_ioctl = dsa_master_ioctl,
-};
-
 static int dsa_master_ethtool_setup(struct net_device *dev)
 {
 	struct dsa_port *cpu_dp = dev->dsa_ptr;
@@ -267,15 +260,6 @@ static void dsa_master_ethtool_teardown(struct net_device *dev)
 	cpu_dp->orig_ethtool_ops = NULL;
 }
 
-static void dsa_netdev_ops_set(struct net_device *dev,
-			       const struct dsa_netdevice_ops *ops)
-{
-	if (netif_is_lag_master(dev))
-		return;
-
-	dev->dsa_ptr->netdev_ops = ops;
-}
-
 /* Keep the master always promiscuous if the tagging protocol requires that
  * (garbles MAC DA) or if it doesn't support unicast filtering, case in which
  * it would revert to promiscuous mode as soon as we call dev_uc_add() on it
@@ -414,16 +398,13 @@ int dsa_master_setup(struct net_device *dev, struct dsa_port *cpu_dp)
 	if (ret)
 		goto out_err_reset_promisc;
 
-	dsa_netdev_ops_set(dev, &dsa_netdev_ops);
-
 	ret = sysfs_create_group(&dev->dev.kobj, &dsa_group);
 	if (ret)
-		goto out_err_ndo_teardown;
+		goto out_err_ethtool_teardown;
 
 	return ret;
 
-out_err_ndo_teardown:
-	dsa_netdev_ops_set(dev, NULL);
+out_err_ethtool_teardown:
 	dsa_master_ethtool_teardown(dev);
 out_err_reset_promisc:
 	dsa_master_set_promiscuity(dev, -1);
@@ -433,7 +414,6 @@ int dsa_master_setup(struct net_device *dev, struct dsa_port *cpu_dp)
 void dsa_master_teardown(struct net_device *dev)
 {
 	sysfs_remove_group(&dev->dev.kobj, &dsa_group);
-	dsa_netdev_ops_set(dev, NULL);
 	dsa_master_ethtool_teardown(dev);
 	dsa_master_reset_mtu(dev);
 	dsa_master_set_promiscuity(dev, -1);
diff --git a/net/dsa/master.h b/net/dsa/master.h
index 3fc0e610b5b5..80842f4e27f7 100644
--- a/net/dsa/master.h
+++ b/net/dsa/master.h
@@ -15,5 +15,8 @@ int dsa_master_lag_setup(struct net_device *lag_dev, struct dsa_port *cpu_dp,
 			 struct netlink_ext_ack *extack);
 void dsa_master_lag_teardown(struct net_device *lag_dev,
 			     struct dsa_port *cpu_dp);
+int dsa_master_pre_change_hwtstamp(struct net_device *dev,
+				   const struct kernel_hwtstamp_config *config,
+				   struct netlink_ext_ack *extack);
 
 #endif
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 165bb2cb8431..8abc1658ac47 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -3289,6 +3289,7 @@ static int dsa_master_changeupper(struct net_device *dev,
 static int dsa_slave_netdevice_event(struct notifier_block *nb,
 				     unsigned long event, void *ptr)
 {
+	struct netlink_ext_ack *extack = netdev_notifier_info_to_extack(ptr);
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
 
 	switch (event) {
@@ -3418,6 +3419,16 @@ static int dsa_slave_netdevice_event(struct notifier_block *nb,
 
 		return NOTIFY_OK;
 	}
+	case NETDEV_PRE_CHANGE_HWTSTAMP: {
+		struct netdev_notifier_hwtstamp_info *info = ptr;
+		int err;
+
+		if (!netdev_uses_dsa(dev))
+			return NOTIFY_DONE;
+
+		err = dsa_master_pre_change_hwtstamp(dev, info->config, extack);
+		return notifier_from_errno(err);
+	}
 	default:
 		break;
 	}
-- 
2.34.1

