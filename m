Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB58D4C14F7
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 15:01:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241329AbiBWOCG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 09:02:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241328AbiBWOBp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 09:01:45 -0500
Received: from EUR03-AM5-obe.outbound.protection.outlook.com (mail-eopbgr30086.outbound.protection.outlook.com [40.107.3.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBEECB0EB6
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 06:01:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YUTluWRdzh+O0GmOj/UQmH2OmyVGhqOntyDJOckbhp8nArreMZqJXKjB4abfbBHYK6uwbn12CfTqSnKJ5vz6DmPLYFbsKdBWL0Ct7cheB3Sw5kXz1W0SD3MQdqt7bUeEWsAfCK2NE+rw2S/7xrdFHeRRplkO1xiuLtWoOjZh7Gx2sCRqzZzghswAMiak+NmZPRaTW9e+azOw4XWFBjlEGerHovPWxPvNr5t7loiZgwdpZRwLKjlM1KYujzV4HozIgY1q5ciB8WGXm62CR72WaZye1lVB2lvO2giUxoJSZUnD2rt49L33p0z3y2mhgEl3OxZl/M9XWgZw0dm9aOXmSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4t/MI7v/9zYTMVmp2lyjD5Y3fq78cJlMkVdjiAltAOE=;
 b=c7PW67qQQOl/M6Nue/kav+k4eizWOMD5JjvbHWqnd0XDUPcG/GOmPb4Qnb3KSGwf3kG1NTiFiJey4j2u42Va+Xe+U0orbgJuHaoKyemLidUFSOgH/CpA8t7J1BPt8S7oEbrCZ+UjDYg99vVeFatE6iDr+3LcbCePbOlVg3QxX98Gqs56k/Xwt1i30bGwNWOO29e5gYN7QA/1To/TrIKX08n1WnLgQ6r1B2I+wALsUpEVwXbKJ294FV4L4jReRLrSgaLjvDLkqg5AfgnJuWykIgka/5qiuFsB5p+ncTbRlDh+a48SvCtlHchp/S1PRCrJuR4wNCc91CUgO8Y2/IhInQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4t/MI7v/9zYTMVmp2lyjD5Y3fq78cJlMkVdjiAltAOE=;
 b=ZgjuFiTxTQjm8z8d5yldKIb9OdDE2favpppObZp5fWCidd3odDXa420owXLdNPJAsK6iXVXZvk60w4tUhFza3MowOtamrHp2BIIXUXUupal6mUxlx9EyZCpjaCWCe0GC4uTRbQ+ss026LdxdNSF5dbOC6DfGbYoZmapty8yihGM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB7PR04MB5164.eurprd04.prod.outlook.com (2603:10a6:10:1e::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Wed, 23 Feb
 2022 14:01:14 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Wed, 23 Feb 2022
 14:01:14 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH v5 net-next 07/11] net: switchdev: remove lag_mod_cb from switchdev_handle_fdb_event_to_device
Date:   Wed, 23 Feb 2022 16:00:50 +0200
Message-Id: <20220223140054.3379617-8-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220223140054.3379617-1-vladimir.oltean@nxp.com>
References: <20220223140054.3379617-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR05CA0096.eurprd05.prod.outlook.com
 (2603:10a6:207:1::22) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b2d3aa31-df09-4b47-a9d1-08d9f6d4f47e
X-MS-TrafficTypeDiagnostic: DB7PR04MB5164:EE_
X-Microsoft-Antispam-PRVS: <DB7PR04MB5164A3B49304E62D58DAC054E03C9@DB7PR04MB5164.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LkmsEUkN7tFlJsWDxiCSxAmbQpsTc5LhcvOWp8i4RYUMDMt0gF6WzG3oFuprcUnhhGWQqzysaedaFk+aSRKAPeJxmdH0jrpHYNZO7XOQhpqvlHRt/C8WP8cK7EGBxOBBmSluSs+Gd6g/faRVsFC71v2Z0QJKrFLyM2pmO0Jpm2bMs/ZVxmitM+B3j1uKEwmkApcoA39tQ74p4OYRWYcrIG9H/RulfQf9OQ0v07I4NzqSMi3tgmhvVoArqCVh1ug+/rn2G8UMuXn5l3Rx2cMxzojBwQXkRpSv4ekc1EEaEAdgLmTdNKBXTtVMcUzf2r69QNr6HBDlVNPEdqP3wAdDp+cVHj9a0ZJT8yu/KldGT9sMReH9MCPRMmFxV+UPs2BUCFe47Xj+bx4l9rpSzhUkjpROkz6UryhIdPXfrgFW0ssHBotWiqQuAJzT5/55U/aELnSUb7pnWe5G8VkOogU7QygleIsRqPdIXZ5CdyX5gty7pAUjBfyRRuF0i+fmlO62iuLm8JSMr8hUdZ264/WtV0RsdsQyr4IoEbtu0So/OL9w46G8q0F5TSU8o+b57OEkARX6kEY0RYCwPMztszu2qfYVSCDYLFtEAfvEFBxrNRmT6olAsYE3DZMy3l6sNA7nnu7AwsXmsZlC0r/hCAegvae27dMqm9/F9tY3HrnzelpUG4TIfmkY3qZqyFM9yPIeOQNlbLPvdPOngGRO1ecu3Z6H7TkKZkRYuEXdw/u+pCTg6rdi5Nb6iGN3tXmtCPvnAVM+ZzjwT7vCnk3ItxX3zTig9r01Wq3IefV34W6o+/o=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8676002)(38100700002)(66556008)(316002)(6916009)(66946007)(66476007)(508600001)(54906003)(966005)(6486002)(36756003)(86362001)(38350700002)(4326008)(1076003)(186003)(26005)(83380400001)(6666004)(7416002)(6512007)(6506007)(2616005)(44832011)(5660300002)(30864003)(8936002)(52116002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5GxGWPagI9bqIy4KeCgya4ULtpmIWEkRyw02gAovCDo0HNQW5unKmaSbFQaZ?=
 =?us-ascii?Q?FRAPI6dIVFY75S1EW7zHxkBbIaiw246Qfs8ZE1Nksrvctr/ED4HbUtgW4pnc?=
 =?us-ascii?Q?iPlAWQ2y+4CI2fmH3Rrv2WgLKqGb7PcpXFVceowf5pJ4rJ98hoL8UvwALliI?=
 =?us-ascii?Q?0eSoTtUwt10DoSCPfNSn8wMJ6mjKFvi9HrzsDtSIgeelVuez11Ui32Ka4i7C?=
 =?us-ascii?Q?yYZQJcmF3diqy8b6oxhQ7awvTtT31zQAMb7jTqH1P60WiR2R8DVvrr1UfbLW?=
 =?us-ascii?Q?yPBNDnDN1ZIEElowTIi2aQgpKc7/QJiRjH7nDKyV7s8tdwJ3jrBRfTTtTQB6?=
 =?us-ascii?Q?GZ/dyKSLdE3irRdbxY+60Xm1l6kYfgbngphN/ypW0AUMuh4hg46zdaEx+s8P?=
 =?us-ascii?Q?qf9hHoGIj6P0IemW69XZAZE1N0hMWklCP+OO9gGCqc8RXvQLIvszP3WJFT2m?=
 =?us-ascii?Q?sa6mUsfJLXbcpvDuHRsz3Hoou0TjBCpQYHikNxKB0dUtLfQe4baX0ZR3FQFd?=
 =?us-ascii?Q?2i7hw1dfNiHc7c4VOXzs1SZ4xrra0PwdoTxltAxxc3i1cCyRl95LtBEhOg6d?=
 =?us-ascii?Q?zVy7TN2pihT1ZsjJ6vDSzbL6M9JbwEPqxT0f/VVZ/pqqWP71eZfzLeioIRIT?=
 =?us-ascii?Q?VZtvmyRfJ1KcSCike2HZ2cntePlX40GClxvSEgRBr1ilUjEbhIcacS5rh30b?=
 =?us-ascii?Q?ofpY4kcqBvxWxj0UUkjq16dXjYMOP0DbICtETiqV9XWzZkjNBxDJFdiEh7uf?=
 =?us-ascii?Q?+JFKCpyMpqIqoV7UKCvx+6durBgbG0u3M3GrYjhY+25P0pxqI2zCnsYmb3yT?=
 =?us-ascii?Q?30dk92x1oqAjNIw/wHZEDaw2vTOkjhhRqqhMhmBMr04q3DlOzg12+WE3STON?=
 =?us-ascii?Q?9ndWG9X2rF/IQH4WCY1UYfkotCRNyJRZhR+LNFU9z8udYoptMq5k1XiBYsx+?=
 =?us-ascii?Q?N56eyfhTKv7l9fyO9LeZHx24325ywqZYDXb33onuZGSqFOt4Xj0fDSRvv0Y1?=
 =?us-ascii?Q?ag9qpSm2mv0U/GUFMYR05oFyM9AgIxn87ziCHjZJRL7SAY4LgtaXPoK4cUfp?=
 =?us-ascii?Q?EefDTLvVDNOrM3PkNVizvXe/J/XBv4fBI4829z0BDJTEUwNDAtQIDNXJhztT?=
 =?us-ascii?Q?Di2bjOBfs+RroZ+svITkUJqVSXONTpmLnTOLX3AsDnnjO+xswUqVcnpMHdp2?=
 =?us-ascii?Q?KVOTNCheg2xfwKOfxJvBrZ7qGhxiAQvO8pyXkxvydHBdU7sKry1PlupKwVnv?=
 =?us-ascii?Q?/2CyajfX3RlDsYh89x2D8iSEkCRhB49Pst+o38vjr9U1locJEi9pLWyJZqi8?=
 =?us-ascii?Q?G1T00/OxYVAjWy7zk71ayR6Pn3pU7NAA4qIbMr8fcUcvUA6+s1hmiSY0ogfF?=
 =?us-ascii?Q?kc8MaZFkWh43EcKrr4jnYJkPONYqbUeulXypBNNp2IxXqPF1pEYdPFyGKZWD?=
 =?us-ascii?Q?yxIQ7mM4ZRx2fHwhLD5SKnt5ib/Qh4QwmbSmqSSNR0EegZRk76fZKBRSSHJJ?=
 =?us-ascii?Q?DGCfz03ad4vaf/ukPClGGX42pzBpjMbt7eUtxfYL7G/0hHRARrGJVHJVOvxB?=
 =?us-ascii?Q?2VHTdHJ4ybZZeZK0ARkYbzYly8ld4r8IG6QlM/broZXV9rBL0NUN8/V7YGxV?=
 =?us-ascii?Q?vV2xc9flY03chsDdjdGYZFM=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2d3aa31-df09-4b47-a9d1-08d9f6d4f47e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2022 14:01:14.7108
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jpT33kOwVuzWiPxHvc6inwrXSzYz3p9NB4LRJcUWGnc6I10T/kCqK1KzeohVY83dz4iQ/vmR+RIxlzdoJRMFmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5164
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the switchdev_handle_fdb_event_to_device() event replication helper
was created, my original thought was that FDB events on LAG interfaces
should most likely be special-cased, not just replicated towards all
switchdev ports beneath that LAG. So this replication helper currently
does not recurse through switchdev lower interfaces of LAG bridge ports,
but rather calls the lag_mod_cb() if that was provided.

No switchdev driver uses this helper for FDB events on LAG interfaces
yet, so that was an assumption which was yet to be tested. It is
certainly usable for that purpose, as my RFC series shows:

https://patchwork.kernel.org/project/netdevbpf/cover/20220210125201.2859463-1-vladimir.oltean@nxp.com/

however this approach is slightly convoluted because:

- the switchdev driver gets a "dev" that isn't its own net device, but
  rather the LAG net device. It must call switchdev_lower_dev_find(dev)
  in order to get a handle of any of its own net devices (the ones that
  pass check_cb).

- in order for FDB entries on LAG ports to be correctly refcounted per
  the number of switchdev ports beneath that LAG, we haven't escaped the
  need to iterate through the LAG's lower interfaces. Except that is now
  the responsibility of the switchdev driver, because the replication
  helper just stopped half-way.

So, even though yes, FDB events on LAG bridge ports must be
special-cased, in the end it's simpler to let switchdev_handle_fdb_*
just iterate through the LAG port's switchdev lowers, and let the
switchdev driver figure out that those physical ports are under a LAG.

The switchdev_handle_fdb_event_to_device() helper takes a
"foreign_dev_check" callback so it can figure out whether @dev can
autonomously forward to @foreign_dev. DSA fills this method properly:
if the LAG is offloaded by another port in the same tree as @dev, then
it isn't foreign. If it is a software LAG, it is foreign - forwarding
happens in software.

Whether an interface is foreign or not decides whether the replication
helper will go through the LAG's switchdev lowers or not. Since the
lan966x doesn't properly fill this out, FDB events on software LAG
uppers will get called. By changing lan966x_foreign_dev_check(), we can
suppress them.

Whereas DSA will now start receiving FDB events for its offloaded LAG
uppers, so we need to return -EOPNOTSUPP, since we currently don't do
the right thing for them.

Cc: Horatiu Vultur <horatiu.vultur@microchip.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
v3->v5: none
v2->v3: patch is new, logically replaces previous patch "net: switchdev:
        export switchdev_lower_dev_find"

 .../microchip/lan966x/lan966x_switchdev.c     | 12 +--
 include/net/switchdev.h                       | 10 +--
 net/dsa/slave.c                               |  6 +-
 net/switchdev/switchdev.c                     | 80 +++++++------------
 4 files changed, 42 insertions(+), 66 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c b/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
index 85099a51d4c7..e3555c94294d 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
@@ -419,6 +419,9 @@ static int lan966x_netdevice_event(struct notifier_block *nb,
 	return notifier_from_errno(ret);
 }
 
+/* We don't offload uppers such as LAG as bridge ports, so every device except
+ * the bridge itself is foreign.
+ */
 static bool lan966x_foreign_dev_check(const struct net_device *dev,
 				      const struct net_device *foreign_dev)
 {
@@ -426,10 +429,10 @@ static bool lan966x_foreign_dev_check(const struct net_device *dev,
 	struct lan966x *lan966x = port->lan966x;
 
 	if (netif_is_bridge_master(foreign_dev))
-		if (lan966x->bridge != foreign_dev)
-			return true;
+		if (lan966x->bridge == foreign_dev)
+			return false;
 
-	return false;
+	return true;
 }
 
 static int lan966x_switchdev_event(struct notifier_block *nb,
@@ -449,8 +452,7 @@ static int lan966x_switchdev_event(struct notifier_block *nb,
 		err = switchdev_handle_fdb_event_to_device(dev, event, ptr,
 							   lan966x_netdevice_check,
 							   lan966x_foreign_dev_check,
-							   lan966x_handle_fdb,
-							   NULL);
+							   lan966x_handle_fdb);
 		return notifier_from_errno(err);
 	}
 
diff --git a/include/net/switchdev.h b/include/net/switchdev.h
index c32e1c8f79ec..3e424d40fae3 100644
--- a/include/net/switchdev.h
+++ b/include/net/switchdev.h
@@ -313,10 +313,7 @@ int switchdev_handle_fdb_event_to_device(struct net_device *dev, unsigned long e
 					     const struct net_device *foreign_dev),
 		int (*mod_cb)(struct net_device *dev, struct net_device *orig_dev,
 			      unsigned long event, const void *ctx,
-			      const struct switchdev_notifier_fdb_info *fdb_info),
-		int (*lag_mod_cb)(struct net_device *dev, struct net_device *orig_dev,
-				  unsigned long event, const void *ctx,
-				  const struct switchdev_notifier_fdb_info *fdb_info));
+			      const struct switchdev_notifier_fdb_info *fdb_info));
 
 int switchdev_handle_port_obj_add(struct net_device *dev,
 			struct switchdev_notifier_port_obj_info *port_obj_info,
@@ -443,10 +440,7 @@ switchdev_handle_fdb_event_to_device(struct net_device *dev, unsigned long event
 					     const struct net_device *foreign_dev),
 		int (*mod_cb)(struct net_device *dev, struct net_device *orig_dev,
 			      unsigned long event, const void *ctx,
-			      const struct switchdev_notifier_fdb_info *fdb_info),
-		int (*lag_mod_cb)(struct net_device *dev, struct net_device *orig_dev,
-				  unsigned long event, const void *ctx,
-				  const struct switchdev_notifier_fdb_info *fdb_info))
+			      const struct switchdev_notifier_fdb_info *fdb_info))
 {
 	return 0;
 }
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index e31c7710fee9..4ea6e0fd4b99 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2461,6 +2461,9 @@ static int dsa_slave_fdb_event(struct net_device *dev,
 	bool host_addr = fdb_info->is_local;
 	struct dsa_switch *ds = dp->ds;
 
+	if (dp->lag)
+		return -EOPNOTSUPP;
+
 	if (ctx && ctx != dp)
 		return 0;
 
@@ -2526,8 +2529,7 @@ static int dsa_slave_switchdev_event(struct notifier_block *unused,
 		err = switchdev_handle_fdb_event_to_device(dev, event, ptr,
 							   dsa_slave_dev_check,
 							   dsa_foreign_dev_check,
-							   dsa_slave_fdb_event,
-							   NULL);
+							   dsa_slave_fdb_event);
 		return notifier_from_errno(err);
 	default:
 		return NOTIFY_DONE;
diff --git a/net/switchdev/switchdev.c b/net/switchdev/switchdev.c
index 28d2ccfe109c..474f76383033 100644
--- a/net/switchdev/switchdev.c
+++ b/net/switchdev/switchdev.c
@@ -458,63 +458,40 @@ static int __switchdev_handle_fdb_event_to_device(struct net_device *dev,
 					     const struct net_device *foreign_dev),
 		int (*mod_cb)(struct net_device *dev, struct net_device *orig_dev,
 			      unsigned long event, const void *ctx,
-			      const struct switchdev_notifier_fdb_info *fdb_info),
-		int (*lag_mod_cb)(struct net_device *dev, struct net_device *orig_dev,
-				  unsigned long event, const void *ctx,
-				  const struct switchdev_notifier_fdb_info *fdb_info))
+			      const struct switchdev_notifier_fdb_info *fdb_info))
 {
 	const struct switchdev_notifier_info *info = &fdb_info->info;
-	struct net_device *br, *lower_dev;
+	struct net_device *br, *lower_dev, *switchdev;
 	struct list_head *iter;
 	int err = -EOPNOTSUPP;
 
 	if (check_cb(dev))
 		return mod_cb(dev, orig_dev, event, info->ctx, fdb_info);
 
-	if (netif_is_lag_master(dev)) {
-		if (!switchdev_lower_dev_find_rcu(dev, check_cb, foreign_dev_check_cb))
-			goto maybe_bridged_with_us;
-
-		/* This is a LAG interface that we offload */
-		if (!lag_mod_cb)
-			return -EOPNOTSUPP;
-
-		return lag_mod_cb(dev, orig_dev, event, info->ctx, fdb_info);
-	}
-
 	/* Recurse through lower interfaces in case the FDB entry is pointing
-	 * towards a bridge device.
+	 * towards a bridge or a LAG device.
 	 */
-	if (netif_is_bridge_master(dev)) {
-		if (!switchdev_lower_dev_find_rcu(dev, check_cb, foreign_dev_check_cb))
-			return 0;
-
-		/* This is a bridge interface that we offload */
-		netdev_for_each_lower_dev(dev, lower_dev, iter) {
-			/* Do not propagate FDB entries across bridges */
-			if (netif_is_bridge_master(lower_dev))
-				continue;
-
-			/* Bridge ports might be either us, or LAG interfaces
-			 * that we offload.
-			 */
-			if (!check_cb(lower_dev) &&
-			    !switchdev_lower_dev_find_rcu(lower_dev, check_cb,
-							  foreign_dev_check_cb))
-				continue;
-
-			err = __switchdev_handle_fdb_event_to_device(lower_dev, orig_dev,
-								     event, fdb_info, check_cb,
-								     foreign_dev_check_cb,
-								     mod_cb, lag_mod_cb);
-			if (err && err != -EOPNOTSUPP)
-				return err;
-		}
+	netdev_for_each_lower_dev(dev, lower_dev, iter) {
+		/* Do not propagate FDB entries across bridges */
+		if (netif_is_bridge_master(lower_dev))
+			continue;
 
-		return 0;
+		/* Bridge ports might be either us, or LAG interfaces
+		 * that we offload.
+		 */
+		if (!check_cb(lower_dev) &&
+		    !switchdev_lower_dev_find_rcu(lower_dev, check_cb,
+						  foreign_dev_check_cb))
+			continue;
+
+		err = __switchdev_handle_fdb_event_to_device(lower_dev, orig_dev,
+							     event, fdb_info, check_cb,
+							     foreign_dev_check_cb,
+							     mod_cb);
+		if (err && err != -EOPNOTSUPP)
+			return err;
 	}
 
-maybe_bridged_with_us:
 	/* Event is neither on a bridge nor a LAG. Check whether it is on an
 	 * interface that is in a bridge with us.
 	 */
@@ -522,12 +499,16 @@ static int __switchdev_handle_fdb_event_to_device(struct net_device *dev,
 	if (!br || !netif_is_bridge_master(br))
 		return 0;
 
-	if (!switchdev_lower_dev_find_rcu(br, check_cb, foreign_dev_check_cb))
+	switchdev = switchdev_lower_dev_find_rcu(br, check_cb, foreign_dev_check_cb);
+	if (!switchdev)
 		return 0;
 
+	if (!foreign_dev_check_cb(switchdev, dev))
+		return err;
+
 	return __switchdev_handle_fdb_event_to_device(br, orig_dev, event, fdb_info,
 						      check_cb, foreign_dev_check_cb,
-						      mod_cb, lag_mod_cb);
+						      mod_cb);
 }
 
 int switchdev_handle_fdb_event_to_device(struct net_device *dev, unsigned long event,
@@ -537,16 +518,13 @@ int switchdev_handle_fdb_event_to_device(struct net_device *dev, unsigned long e
 					     const struct net_device *foreign_dev),
 		int (*mod_cb)(struct net_device *dev, struct net_device *orig_dev,
 			      unsigned long event, const void *ctx,
-			      const struct switchdev_notifier_fdb_info *fdb_info),
-		int (*lag_mod_cb)(struct net_device *dev, struct net_device *orig_dev,
-				  unsigned long event, const void *ctx,
-				  const struct switchdev_notifier_fdb_info *fdb_info))
+			      const struct switchdev_notifier_fdb_info *fdb_info))
 {
 	int err;
 
 	err = __switchdev_handle_fdb_event_to_device(dev, dev, event, fdb_info,
 						     check_cb, foreign_dev_check_cb,
-						     mod_cb, lag_mod_cb);
+						     mod_cb);
 	if (err == -EOPNOTSUPP)
 		err = 0;
 
-- 
2.25.1

