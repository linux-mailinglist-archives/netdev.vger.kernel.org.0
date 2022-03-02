Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCA3B4CAE67
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 20:15:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244960AbiCBTP4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 14:15:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244969AbiCBTPw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 14:15:52 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70073.outbound.protection.outlook.com [40.107.7.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE1A4574A7
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 11:14:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KkWsSMoM+AjbSUjYznlwm0apXYnarOyFbzfWRC1e9Tc5I125H1gaOuu95L2/FELoweI3Lo4Qf6BzZ2unum8Ta+w/HRnNMfJqnokN5oog/zwOmy4KHEM2mXKYypEvLNXdhkFivdo7wOnIWKeFn9CcsXlymIZebQiTREyyH2qPW4lTSC7F4BjlJlgW30S5o+UIt0JlVcErmxvf/OelwwhSTbrW6wO/fdxc2+CxT8PglIjVOFCvxRF+fwQAycbC2puo/QehTHwrqS802owqnHt48rXNL84GpmByTEri+xIh0J6BCo+UtTPT/4VFJBqNoMtn5IkYkrYQdkYqYk8folGs+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QK62JF+qX1J5cE0yb6ru2fqr0AL2uR6hRAINSe8nTwM=;
 b=axaD2bZnjEiOZJEf2Hh2CXI77Bv/pVAhwl829IL1YWpxH652aeCAELDbNVMuWiGgfQNM1u73JlrlU69H2FuWxzsfKD3ng4V3y8S0kmCvDBwAf878U/jO7gpE7FtYB2EIRLqCJUf4YpIQqYBR5oRrF+LelhIv+S36ByN5j4LM+GclvICbsJXbjlMnI0CD9rhSM/qoM2r7D+IsZXGxJY0ubrPsMvSn7twtZdtSIhMEUhbCgVuhhjQ+xoupqfTd+mHi2BB8D96dCERzJY8dUZSvpvAgVhlvLqZxfc6btJLvdoVnIi+ViClRQPVNxFRvtSASvU1idiyVKz3GxgTBuLi+Zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QK62JF+qX1J5cE0yb6ru2fqr0AL2uR6hRAINSe8nTwM=;
 b=NVce2mT/uN8MxZ2XwxYAIRhM2ZHYNG3MxyNVY6ueLXMuJrrelT0RiSKG2IbmzpxCCCBTOHCMnsUcdgXh08GbipZdLchEDEmgMdWOKnKtJzNpFArhOsDC2ya9IiDe01duJKhZUDYcllVxrWryfC8QTU9K6glnHC5xNTPK8R6J52Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB2911.eurprd04.prod.outlook.com (2603:10a6:800:b8::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.26; Wed, 2 Mar
 2022 19:14:54 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36%4]) with mapi id 15.20.5017.027; Wed, 2 Mar 2022
 19:14:54 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 03/10] net: dsa: install secondary unicast and multicast addresses as host FDB/MDB
Date:   Wed,  2 Mar 2022 21:14:10 +0200
Message-Id: <20220302191417.1288145-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220302191417.1288145-1-vladimir.oltean@nxp.com>
References: <20220302191417.1288145-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6PR05CA0030.eurprd05.prod.outlook.com
 (2603:10a6:20b:2e::43) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0d941dcb-df50-4dfe-2e03-08d9fc80ef0d
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2911:EE_
X-Microsoft-Antispam-PRVS: <VI1PR0402MB29115F9F25BAB1A3963321F0E0039@VI1PR0402MB2911.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lZRObMdPtovqZWKtSkrAqlVeSSXzxboFwHUmbOM3IuzIV22g53Z/7CnBJTC8ti4/BkgzgQbg4b/4IWpa332oiQpirpCcZjLnfRKqPXyGSowrt2I6CkH72YhOYi7hCup7C3md6UcvDuFpRLu+RW6GYScMWi9Gg8vZF/BYyJ9oIqdimgglcOMGnKeaVFO9wGbwKPL+1qt5ih/DdbLdLTklEUnc5BHWpY3MMAF4Lcc2Z1Rubfv9Z51gNB7tuhdVg7d+G1zYO8TOXgsbKWosmQUIAS6eBxb7XobTCgbeqJlynOr5w066JKYSwk018EvNJotLgSdvawo+nVklF6TQHQuYv11f6MZXx8AQmHETmImo5ltoO9hcelDp0jjHNY4rjxdmwJycXtFnayLrRc7mLoUDjnV6/NqyaGjuf62Q7StdgpsqoOddfJmUdQWM8N8xQ9TJWIxHNIDGNB8CuaViMEN3gWY1RKFEcuaUFDthGi3KS3N3trII1javf0QYfHeFoNj3bazKDrTlRhfU3WylXDz3M+P3k+rykL4NNzrNHDDvU121sYSuFzAzjnyFMw2D/SfkilgH1t4n33FqoZ3H8IEvhj+cr9TGl+IJY9pMDZR6jZwBrI5iTbEgWzvdPzWzGCisK1cN7CMPmx8ulTQIHH0Uap8merIbtYBYmJx9dn2d5vMjUeznT6fVznbLNOHNyTSwW/HLtZOdYanxTZRU0bmPgg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(316002)(6916009)(83380400001)(5660300002)(8676002)(4326008)(7416002)(66556008)(66476007)(44832011)(30864003)(36756003)(54906003)(66946007)(52116002)(8936002)(38100700002)(6506007)(6512007)(6666004)(38350700002)(1076003)(2616005)(26005)(186003)(508600001)(6486002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?o1kcJtDwJN4HMSZw1sonKwq5w4REtWnSwmQxaMC6LPw7szQ6wqYck4UizJoW?=
 =?us-ascii?Q?qFR9T7syyYgYyiJ/7QFbadZKLnW3Vj11FMt4EZMSg4obmyQvtu6B92tv/6k/?=
 =?us-ascii?Q?/QMQdyZVdbAvB9ZNebN5DMVKqsSrXXesqQRIA7zkJ6yqmrgBcfsGtLnS2w0Z?=
 =?us-ascii?Q?bB/BXMpNm6p5S12E85HkEnJej3yxKRkg0UWWg6BsKQme27Egch08TU+T1eX0?=
 =?us-ascii?Q?m8eGyY22cPdXNLc5XQagDu/NzG1kQHPhO597oEOvi/Jt9LfgUsDKvk7qEoUm?=
 =?us-ascii?Q?yhqFP7AQi2uQKZzr5DHcl/+yy2Q+ueChNw16oVRCrIhCwnqWD1w4iVSD/grq?=
 =?us-ascii?Q?hbzl2pMy/guWe0916j9lGHJAwyDtUdCraW0oZqt2ZTi0vWA8kGordwUHoUj3?=
 =?us-ascii?Q?23iTpIGtf9JIg4THFTEDC+cQfj0rosfJMzI7m/nfpr31ghpOIjVuViTxXh4a?=
 =?us-ascii?Q?RLKxjIEt9eQ957zFusUqRKa3yzK/lXq5SJ2jvRC5EHjZO+On48535GYQZeJZ?=
 =?us-ascii?Q?xbR/s1+r03SV0cRYz4t99PDtVlup2ESj9z/tDAMUSegkavwf7g72pLoWOx+C?=
 =?us-ascii?Q?x6zXwXvTt7YTKjtV7AmySyZOcxE1YnOjnw7Vpbzc5WJB/W66cmFo5gTgJ04J?=
 =?us-ascii?Q?u1j+Q4wQtK8OumDW1NTFNOL3phXW6nLIANH9SvyEZxc4EjQq4B+PHJJss66t?=
 =?us-ascii?Q?r2xua/txukUyh8kqn42o08fGFFKX+kisjQteb7C4k48vyThvRElR2qmpV1cN?=
 =?us-ascii?Q?Cj/xWupaGwCTHzQchVDrNXNGVux6GMH5wStfmEgh59pi+8SApDIp0yh56m5N?=
 =?us-ascii?Q?urxJaLCSM+Uh1kSarUAAKSdyX8Dou/owAFW1McJiOKMICPS28FpGhhV0dpXI?=
 =?us-ascii?Q?G1T1zcNNXcueKa8rt6YfEJceiFoB6H/eTCjONETjGtZNO+1N3MMFDkZcLqF6?=
 =?us-ascii?Q?ok61ZBtdpqd5qkqnA2G9PVesXJkkrmMDmVAbpS+BeFWO+8GPZGklDRSzPl2E?=
 =?us-ascii?Q?1zKjtWsb4dzWdJWPrZvusu7+B5+jpjo5k7GgbtjgjQsJwVJsgoNgbSTcAeAX?=
 =?us-ascii?Q?O/nZldt6LlMQFxkEJCqVpIVACD1KeIncICJMMQEdmi1Ksux7UU/f5lW9UnfC?=
 =?us-ascii?Q?g+32AltoxMmTeLODBmIgXyc1NihNWA3dIH/0vvGFaEebZeROXRUAltZPWM4z?=
 =?us-ascii?Q?8HDfH64dF8QGJPk5YYp2k7cyrXOMWhOe1FhTpASmrW69CogEF4hzzVCDiVhX?=
 =?us-ascii?Q?f8pse5nIWXqHrP+1agSmgDwDGsA3gKTwJ53zEZ7SyU4b36rNIv06q4ZftpO6?=
 =?us-ascii?Q?XPGo3Bhw1D1apuBiRGvCq6/i9FiH6GzoPxBK0vHMtmvBu/Yew2xuEr1hL5FU?=
 =?us-ascii?Q?F3KvJ5lxJbJ3sqw0yQhDJViLRXUvwa/O89ScXlHWeCEMmtSvsYd+NU2DH3u7?=
 =?us-ascii?Q?NJ5auBQXEBThIXNCC/I52xl5VJRei9ByCnHa/50tXbjSjQB/WW249lEAm1XW?=
 =?us-ascii?Q?N4VY/9yYT2qJZS777dASLIJaHnXNpPztWxF7r3WN76VyL18TVGvq0Ppd68P7?=
 =?us-ascii?Q?bzW8C31JtHPsVH0KB3MKU+9dAgAyewekM47J8kkcn6mK31YrCRtp7rJrLRvl?=
 =?us-ascii?Q?LhMZIgNmmMkX6J/3VwrHgAU=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d941dcb-df50-4dfe-2e03-08d9fc80ef0d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2022 19:14:54.7986
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v17WxnCcSYBxdaXHkBkY8iVkOM+/OKfrKl+MwzgZPJOzG+lJDj8i5gnFhWhRbho7iqqI2rFiefsE8FdVu+wY5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2911
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation of disabling flooding towards the CPU in standalone ports
mode, identify the addresses requested by upper interfaces and use the
new API for DSA FDB isolation to request the hardware driver to offload
these as FDB or MDB objects. The objects belong to the user port's
database, and are installed pointing towards the CPU port.

Because dev_uc_add()/dev_mc_add() is VLAN-unaware, we offload to the
port standalone database addresses with VID 0 (also VLAN-unaware).
So this excludes switches with global VLAN filtering from supporting
unicast filtering, because there, it is possible for a port of a switch
to join a VLAN-aware bridge, and this changes the VLAN awareness of
standalone ports, requiring VLAN-aware standalone host FDB entries.
For the same reason, hellcreek, which requires VLAN awareness in
standalone mode, is also exempted from unicast filtering.

We create "standalone" variants of dsa_port_host_fdb_add() and
dsa_port_host_mdb_add() (and the _del coresponding functions).

We also create a separate work item type for handling deferred
standalone host FDB/MDB entries compared to the switchdev one.
This is done for the purpose of clarity - the procedure for offloading a
bridge FDB entry is different than offloading a standalone one, and
the switchdev event work handles only FDBs anyway, not MDBs.
Deferral is needed for standalone entries because ndo_set_rx_mode runs
in atomic context. We could probably optimize things a little by first
queuing up all entries that need to be offloaded, and scheduling the
work item just once, but the data structures that we can pass through
__dev_uc_sync() and __dev_mc_sync() are limiting (there is nothing like
a void *priv), so we'd have to keep the list of queued events somewhere
in struct dsa_switch, and possibly a lock for it. Too complicated for
now.

Adding the address to the master is handled by dev_uc_sync(), adding it
to the hardware is handled by __dev_uc_sync(). So this is the reason why
dsa_port_standalone_host_fdb_add() does not call dev_uc_add(). Not that
it had the rtnl_mutex anyway - ndo_set_rx_mode has it, but is atomic.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/dsa_priv.h |  37 +++++++++++
 net/dsa/port.c     | 160 +++++++++++++++++++++++++++++++++------------
 net/dsa/slave.c    | 116 ++++++++++++++++++++++++++++++++
 3 files changed, 273 insertions(+), 40 deletions(-)

diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 2e05c863d4b4..c3c7491ace72 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -144,6 +144,21 @@ struct dsa_switchdev_event_work {
 	bool host_addr;
 };
 
+enum dsa_standalone_event {
+	DSA_UC_ADD,
+	DSA_UC_DEL,
+	DSA_MC_ADD,
+	DSA_MC_DEL,
+};
+
+struct dsa_standalone_event_work {
+	struct work_struct work;
+	struct net_device *dev;
+	enum dsa_standalone_event event;
+	unsigned char addr[ETH_ALEN];
+	u16 vid;
+};
+
 struct dsa_slave_priv {
 	/* Copy of CPU port xmit for faster access in slave transmit hot path */
 	struct sk_buff *	(*xmit)(struct sk_buff *skb,
@@ -223,6 +238,10 @@ int dsa_port_fdb_add(struct dsa_port *dp, const unsigned char *addr,
 		     u16 vid);
 int dsa_port_fdb_del(struct dsa_port *dp, const unsigned char *addr,
 		     u16 vid);
+int dsa_port_standalone_host_fdb_add(struct dsa_port *dp,
+				     const unsigned char *addr, u16 vid);
+int dsa_port_standalone_host_fdb_del(struct dsa_port *dp,
+				     const unsigned char *addr, u16 vid);
 int dsa_port_bridge_host_fdb_add(struct dsa_port *dp, const unsigned char *addr,
 				 u16 vid);
 int dsa_port_bridge_host_fdb_del(struct dsa_port *dp, const unsigned char *addr,
@@ -236,6 +255,10 @@ int dsa_port_mdb_add(const struct dsa_port *dp,
 		     const struct switchdev_obj_port_mdb *mdb);
 int dsa_port_mdb_del(const struct dsa_port *dp,
 		     const struct switchdev_obj_port_mdb *mdb);
+int dsa_port_standalone_host_mdb_add(const struct dsa_port *dp,
+				     const struct switchdev_obj_port_mdb *mdb);
+int dsa_port_standalone_host_mdb_del(const struct dsa_port *dp,
+				     const struct switchdev_obj_port_mdb *mdb);
 int dsa_port_bridge_host_mdb_add(const struct dsa_port *dp,
 				 const struct switchdev_obj_port_mdb *mdb);
 int dsa_port_bridge_host_mdb_del(const struct dsa_port *dp,
@@ -502,6 +525,20 @@ static inline void *dsa_etype_header_pos_tx(struct sk_buff *skb)
 int dsa_switch_register_notifier(struct dsa_switch *ds);
 void dsa_switch_unregister_notifier(struct dsa_switch *ds);
 
+static inline bool dsa_switch_supports_uc_filtering(struct dsa_switch *ds)
+{
+	return ds->ops->port_fdb_add && ds->ops->port_fdb_del &&
+	       ds->fdb_isolation && !ds->vlan_filtering_is_global &&
+	       !ds->needs_standalone_vlan_filtering;
+}
+
+static inline bool dsa_switch_supports_mc_filtering(struct dsa_switch *ds)
+{
+	return ds->ops->port_mdb_add && ds->ops->port_mdb_del &&
+	       ds->fdb_isolation && !ds->vlan_filtering_is_global &&
+	       !ds->needs_standalone_vlan_filtering;
+}
+
 /* dsa2.c */
 void dsa_lag_map(struct dsa_switch_tree *dst, struct dsa_lag *lag);
 void dsa_lag_unmap(struct dsa_switch_tree *dst, struct dsa_lag *lag);
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 4fb282ae049c..58291df14cdb 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -835,20 +835,43 @@ int dsa_port_fdb_del(struct dsa_port *dp, const unsigned char *addr,
 	return dsa_port_notify(dp, DSA_NOTIFIER_FDB_DEL, &info);
 }
 
-int dsa_port_bridge_host_fdb_add(struct dsa_port *dp, const unsigned char *addr,
-				 u16 vid)
+static int dsa_port_host_fdb_add(struct dsa_port *dp,
+				 const unsigned char *addr, u16 vid,
+				 struct dsa_db db)
 {
 	struct dsa_notifier_fdb_info info = {
 		.sw_index = dp->ds->index,
 		.port = dp->index,
 		.addr = addr,
 		.vid = vid,
-		.db = {
-			.type = DSA_DB_BRIDGE,
-			.bridge = *dp->bridge,
-		},
+		.db = db,
+	};
+
+	if (!dp->ds->fdb_isolation)
+		info.db.bridge.num = 0;
+
+	return dsa_port_notify(dp, DSA_NOTIFIER_HOST_FDB_ADD, &info);
+}
+
+int dsa_port_standalone_host_fdb_add(struct dsa_port *dp,
+				     const unsigned char *addr, u16 vid)
+{
+	struct dsa_db db = {
+		.type = DSA_DB_PORT,
+		.dp = dp,
 	};
+
+	return dsa_port_host_fdb_add(dp, addr, vid, db);
+}
+
+int dsa_port_bridge_host_fdb_add(struct dsa_port *dp,
+				 const unsigned char *addr, u16 vid)
+{
 	struct dsa_port *cpu_dp = dp->cpu_dp;
+	struct dsa_db db = {
+		.type = DSA_DB_BRIDGE,
+		.bridge = *dp->bridge,
+	};
 	int err;
 
 	/* Avoid a call to __dev_set_promiscuity() on the master, which
@@ -861,26 +884,46 @@ int dsa_port_bridge_host_fdb_add(struct dsa_port *dp, const unsigned char *addr,
 			return err;
 	}
 
-	if (!dp->ds->fdb_isolation)
-		info.db.bridge.num = 0;
-
-	return dsa_port_notify(dp, DSA_NOTIFIER_HOST_FDB_ADD, &info);
+	return dsa_port_host_fdb_add(dp, addr, vid, db);
 }
 
-int dsa_port_bridge_host_fdb_del(struct dsa_port *dp, const unsigned char *addr,
-				 u16 vid)
+static int dsa_port_host_fdb_del(struct dsa_port *dp,
+				 const unsigned char *addr, u16 vid,
+				 struct dsa_db db)
 {
 	struct dsa_notifier_fdb_info info = {
 		.sw_index = dp->ds->index,
 		.port = dp->index,
 		.addr = addr,
 		.vid = vid,
-		.db = {
-			.type = DSA_DB_BRIDGE,
-			.bridge = *dp->bridge,
-		},
+		.db = db,
+	};
+
+	if (!dp->ds->fdb_isolation)
+		info.db.bridge.num = 0;
+
+	return dsa_port_notify(dp, DSA_NOTIFIER_HOST_FDB_DEL, &info);
+}
+
+int dsa_port_standalone_host_fdb_del(struct dsa_port *dp,
+				     const unsigned char *addr, u16 vid)
+{
+	struct dsa_db db = {
+		.type = DSA_DB_PORT,
+		.dp = dp,
 	};
+
+	return dsa_port_host_fdb_del(dp, addr, vid, db);
+}
+
+int dsa_port_bridge_host_fdb_del(struct dsa_port *dp,
+				 const unsigned char *addr, u16 vid)
+{
 	struct dsa_port *cpu_dp = dp->cpu_dp;
+	struct dsa_db db = {
+		.type = DSA_DB_BRIDGE,
+		.bridge = *dp->bridge,
+	};
 	int err;
 
 	if (cpu_dp->master->priv_flags & IFF_UNICAST_FLT) {
@@ -889,10 +932,7 @@ int dsa_port_bridge_host_fdb_del(struct dsa_port *dp, const unsigned char *addr,
 			return err;
 	}
 
-	if (!dp->ds->fdb_isolation)
-		info.db.bridge.num = 0;
-
-	return dsa_port_notify(dp, DSA_NOTIFIER_HOST_FDB_DEL, &info);
+	return dsa_port_host_fdb_del(dp, addr, vid, db);
 }
 
 int dsa_port_lag_fdb_add(struct dsa_port *dp, const unsigned char *addr,
@@ -982,54 +1022,94 @@ int dsa_port_mdb_del(const struct dsa_port *dp,
 	return dsa_port_notify(dp, DSA_NOTIFIER_MDB_DEL, &info);
 }
 
-int dsa_port_bridge_host_mdb_add(const struct dsa_port *dp,
-				 const struct switchdev_obj_port_mdb *mdb)
+static int dsa_port_host_mdb_add(const struct dsa_port *dp,
+				 const struct switchdev_obj_port_mdb *mdb,
+				 struct dsa_db db)
 {
 	struct dsa_notifier_mdb_info info = {
 		.sw_index = dp->ds->index,
 		.port = dp->index,
 		.mdb = mdb,
-		.db = {
-			.type = DSA_DB_BRIDGE,
-			.bridge = *dp->bridge,
-		},
+		.db = db,
+	};
+
+	if (!dp->ds->fdb_isolation)
+		info.db.bridge.num = 0;
+
+	return dsa_port_notify(dp, DSA_NOTIFIER_HOST_MDB_ADD, &info);
+}
+
+int dsa_port_standalone_host_mdb_add(const struct dsa_port *dp,
+				     const struct switchdev_obj_port_mdb *mdb)
+{
+	struct dsa_db db = {
+		.type = DSA_DB_PORT,
+		.dp = dp,
 	};
+
+	return dsa_port_host_mdb_add(dp, mdb, db);
+}
+
+int dsa_port_bridge_host_mdb_add(const struct dsa_port *dp,
+				 const struct switchdev_obj_port_mdb *mdb)
+{
 	struct dsa_port *cpu_dp = dp->cpu_dp;
+	struct dsa_db db = {
+		.type = DSA_DB_BRIDGE,
+		.bridge = *dp->bridge,
+	};
 	int err;
 
 	err = dev_mc_add(cpu_dp->master, mdb->addr);
 	if (err)
 		return err;
 
-	if (!dp->ds->fdb_isolation)
-		info.db.bridge.num = 0;
-
-	return dsa_port_notify(dp, DSA_NOTIFIER_HOST_MDB_ADD, &info);
+	return dsa_port_host_mdb_add(dp, mdb, db);
 }
 
-int dsa_port_bridge_host_mdb_del(const struct dsa_port *dp,
-				 const struct switchdev_obj_port_mdb *mdb)
+static int dsa_port_host_mdb_del(const struct dsa_port *dp,
+				 const struct switchdev_obj_port_mdb *mdb,
+				 struct dsa_db db)
 {
 	struct dsa_notifier_mdb_info info = {
 		.sw_index = dp->ds->index,
 		.port = dp->index,
 		.mdb = mdb,
-		.db = {
-			.type = DSA_DB_BRIDGE,
-			.bridge = *dp->bridge,
-		},
+		.db = db,
+	};
+
+	if (!dp->ds->fdb_isolation)
+		info.db.bridge.num = 0;
+
+	return dsa_port_notify(dp, DSA_NOTIFIER_HOST_MDB_DEL, &info);
+}
+
+int dsa_port_standalone_host_mdb_del(const struct dsa_port *dp,
+				     const struct switchdev_obj_port_mdb *mdb)
+{
+	struct dsa_db db = {
+		.type = DSA_DB_PORT,
+		.dp = dp,
 	};
+
+	return dsa_port_host_mdb_del(dp, mdb, db);
+}
+
+int dsa_port_bridge_host_mdb_del(const struct dsa_port *dp,
+				 const struct switchdev_obj_port_mdb *mdb)
+{
 	struct dsa_port *cpu_dp = dp->cpu_dp;
+	struct dsa_db db = {
+		.type = DSA_DB_BRIDGE,
+		.bridge = *dp->bridge,
+	};
 	int err;
 
 	err = dev_mc_del(cpu_dp->master, mdb->addr);
 	if (err)
 		return err;
 
-	if (!dp->ds->fdb_isolation)
-		info.db.bridge.num = 0;
-
-	return dsa_port_notify(dp, DSA_NOTIFIER_HOST_MDB_DEL, &info);
+	return dsa_port_host_mdb_del(dp, mdb, db);
 }
 
 int dsa_port_vlan_add(struct dsa_port *dp,
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index f0d8f2f5d923..1402f93b1de2 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -23,6 +23,114 @@
 
 #include "dsa_priv.h"
 
+static void dsa_slave_standalone_event_work(struct work_struct *work)
+{
+	struct dsa_standalone_event_work *standalone_work =
+		container_of(work, struct dsa_standalone_event_work, work);
+	const unsigned char *addr = standalone_work->addr;
+	struct net_device *dev = standalone_work->dev;
+	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct switchdev_obj_port_mdb mdb;
+	struct dsa_switch *ds = dp->ds;
+	u16 vid = standalone_work->vid;
+	int err;
+
+	switch (standalone_work->event) {
+	case DSA_UC_ADD:
+		err = dsa_port_standalone_host_fdb_add(dp, addr, vid);
+		if (err) {
+			dev_err(ds->dev,
+				"port %d failed to add %pM vid %d to fdb: %d\n",
+				dp->index, addr, vid, err);
+			break;
+		}
+		break;
+
+	case DSA_UC_DEL:
+		err = dsa_port_standalone_host_fdb_del(dp, addr, vid);
+		if (err) {
+			dev_err(ds->dev,
+				"port %d failed to delete %pM vid %d from fdb: %d\n",
+				dp->index, addr, vid, err);
+		}
+
+		break;
+	case DSA_MC_ADD:
+		ether_addr_copy(mdb.addr, addr);
+		mdb.vid = vid;
+
+		err = dsa_port_standalone_host_mdb_add(dp, &mdb);
+		if (err) {
+			dev_err(ds->dev,
+				"port %d failed to add %pM vid %d to mdb: %d\n",
+				dp->index, addr, vid, err);
+			break;
+		}
+		break;
+	case DSA_MC_DEL:
+		ether_addr_copy(mdb.addr, addr);
+		mdb.vid = vid;
+
+		err = dsa_port_standalone_host_mdb_del(dp, &mdb);
+		if (err) {
+			dev_err(ds->dev,
+				"port %d failed to delete %pM vid %d from mdb: %d\n",
+				dp->index, addr, vid, err);
+		}
+
+		break;
+	}
+
+	kfree(standalone_work);
+}
+
+static int dsa_slave_schedule_standalone_work(struct net_device *dev,
+					      enum dsa_standalone_event event,
+					      const unsigned char *addr,
+					      u16 vid)
+{
+	struct dsa_standalone_event_work *standalone_work;
+
+	standalone_work = kzalloc(sizeof(*standalone_work), GFP_ATOMIC);
+	if (!standalone_work)
+		return -ENOMEM;
+
+	INIT_WORK(&standalone_work->work, dsa_slave_standalone_event_work);
+	standalone_work->event = event;
+	standalone_work->dev = dev;
+
+	ether_addr_copy(standalone_work->addr, addr);
+	standalone_work->vid = vid;
+
+	dsa_schedule_work(&standalone_work->work);
+
+	return 0;
+}
+
+static int dsa_slave_sync_uc(struct net_device *dev,
+			     const unsigned char *addr)
+{
+	return dsa_slave_schedule_standalone_work(dev, DSA_UC_ADD, addr, 0);
+}
+
+static int dsa_slave_unsync_uc(struct net_device *dev,
+			       const unsigned char *addr)
+{
+	return dsa_slave_schedule_standalone_work(dev, DSA_UC_DEL, addr, 0);
+}
+
+static int dsa_slave_sync_mc(struct net_device *dev,
+			     const unsigned char *addr)
+{
+	return dsa_slave_schedule_standalone_work(dev, DSA_MC_ADD, addr, 0);
+}
+
+static int dsa_slave_unsync_mc(struct net_device *dev,
+			       const unsigned char *addr)
+{
+	return dsa_slave_schedule_standalone_work(dev, DSA_MC_DEL, addr, 0);
+}
+
 /* slave mii_bus handling ***************************************************/
 static int dsa_slave_phy_read(struct mii_bus *bus, int addr, int reg)
 {
@@ -122,9 +230,15 @@ static void dsa_slave_change_rx_flags(struct net_device *dev, int change)
 static void dsa_slave_set_rx_mode(struct net_device *dev)
 {
 	struct net_device *master = dsa_slave_to_master(dev);
+	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct dsa_switch *ds = dp->ds;
 
 	dev_mc_sync(master, dev);
 	dev_uc_sync(master, dev);
+	if (dsa_switch_supports_mc_filtering(ds))
+		__dev_mc_sync(dev, dsa_slave_sync_mc, dsa_slave_unsync_mc);
+	if (dsa_switch_supports_uc_filtering(ds))
+		__dev_uc_sync(dev, dsa_slave_sync_uc, dsa_slave_unsync_uc);
 }
 
 static int dsa_slave_set_mac_address(struct net_device *dev, void *a)
@@ -1919,6 +2033,8 @@ int dsa_slave_create(struct dsa_port *port)
 	else
 		eth_hw_addr_inherit(slave_dev, master);
 	slave_dev->priv_flags |= IFF_NO_QUEUE;
+	if (dsa_switch_supports_uc_filtering(ds))
+		slave_dev->priv_flags |= IFF_UNICAST_FLT;
 	slave_dev->netdev_ops = &dsa_slave_netdev_ops;
 	if (ds->ops->port_max_mtu)
 		slave_dev->max_mtu = ds->ops->port_max_mtu(ds, port->index);
-- 
2.25.1

