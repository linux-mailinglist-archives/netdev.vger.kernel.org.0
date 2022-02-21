Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71FE84BEC93
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 22:24:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234723AbiBUVYw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 16:24:52 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234814AbiBUVYs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 16:24:48 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2053.outbound.protection.outlook.com [40.107.21.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D3C212A83
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 13:24:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JYcesWyPmPDe/5CYKIcBfhsuwhmiji7rHV4yOvEZ+jy41j1fe9JvrFB4oYc2BKMuEQsUSKnObC+s9ENC4lPpnfp1NwnI5QxFbf8mia9yxAQ8piE7l66SrSotB68xiDfSU+iiQRnThXcmiu7M6p+NgqoNFWddfJSU7Kl8mWs//oUp+Fy+vZR8uuOPBVlnTNyfZ4A7oYivQdaFHf3O+bc6c1gAGWb/LVQ85Yrj5GZII5JnjK4QZIfxLXv8DkjkeXERwehzj7LvQMMtgJb6m97MlV6vl84mxK16/YxVfR5JxCweLDQrpATw+HH0S1y47M0D1ifKKvYSv7syKou7RRMzlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ItjHBz/tV4U5/qy9O8coHpd4/Pt39E/IKpXgXinY1U8=;
 b=HZ/FHwJq9UEGPTbYmm68b3FIBHuDXbbvd3NX/zjlnB3qnGubd0RB4nlOqMv7emaziK06hvDrIDxHUNaoPJAb/GLAaLditBftTQX2RGTepNhoR04wWXVrLUjN1lEnSmkASJ8trzwq3zIzlFqhpaBzd5/X9J5qy4kzdI6f5OPQpjyh9M42ZmRYcP3XrpOcmNHgBNm0h5zBn2QrGl+0wW3QW2zaf5yimqyEF/CdqV/fKrl35iMIGGotm5Z9VLQsWOl24aPb+WaNnmhpqoh7e2wz83tbAkAVuHiLtWPuWVeAwT22RE0o5dhG7J0T6ZTonjklDQONYeUEB1lxpybQJAkbrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ItjHBz/tV4U5/qy9O8coHpd4/Pt39E/IKpXgXinY1U8=;
 b=GTpJfKcpSiwJSDFfun4++U5XkuR6sCmBh+mAPlnuJ+aqTvRFRQltmrhXhiUC9aOa+LsSzsUUFhcrgVBRKciL21kciitF+RzfBAN7lGcfGFHIB3a7/vAqveLl6/OS7y1ni6G1f4fjNYQ7hrjYyblXBybNp362fRlgOHA39OExMSk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5645.eurprd04.prod.outlook.com (2603:10a6:803:df::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.27; Mon, 21 Feb
 2022 21:24:16 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Mon, 21 Feb 2022
 21:24:16 +0000
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
        Ivan Vecera <ivecera@redhat.com>
Subject: [PATCH v4 net-next 10/11] net: dsa: support FDB events on offloaded LAG interfaces
Date:   Mon, 21 Feb 2022 23:23:36 +0200
Message-Id: <20220221212337.2034956-11-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220221212337.2034956-1-vladimir.oltean@nxp.com>
References: <20220221212337.2034956-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM5PR0701CA0017.eurprd07.prod.outlook.com
 (2603:10a6:203:51::27) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a29c8405-3600-4b07-c927-08d9f5808396
X-MS-TrafficTypeDiagnostic: VI1PR04MB5645:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB56459C368D00FA37D78A2D6EE03A9@VI1PR04MB5645.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QMikb2KFtuRmvFsbmPzGfmNapBnypNyjdcMJVGzVs271Y3jXUilYokPMCNb1G8JUO0fi7xsq+5wWx8UnwF0f9aP39v2jZTar2YB6DK590pVG11pI53Ddhx1ljhRea4ZlU8sWzsN0JuSxWnxWbYAuu9kb09pT61X+qOCZwodmRH4WLftJWvJN/1wPS57mKKYxV7Un0EqrHoCi1LF+tcBCYA6PTO64B9NrpVpiLbffE4miDXSM4J7wXGx/FhP83aLHjWdPJn3/QNi/xtcE6EGqyDVog/ijjaYEXHIm81X6QTNNUsdv23Rj89MrkYoVVs9TmBkf+0V3fjYIMRVPx2HwXeBDT89yUbVzgfAC/0dK97dp3+H1NOvmqEX55i4wj3h+2pYo/pva6qv8YNuiCq62VkNy4XFqiPJZxqVd1lRir7W11Dgb7OQNRyoJihHvRE58EuXPKcjOdAlCQ7hdQ4BQskroSQqEE/iSW8GI1cXqMkkSVurpQmO/Vl7Qca90D2+MKDeO4yAGralOe+pthD3n4AbHviI9KIPiyHrrwN5iroc0L4MHApku1pAd8yqLTmwtsc9KsXVRgToHjTo03YKOAZIx501tCHwJRx9pcN1PJIPG9fXXdRMey/uWCtwG2xXSsyK8f9eyDwBfU6Fa20JhT3m/yQ5RbTmgXepKuUlilSI4N7nMqhyGR6nszG6SxWxEOUGedPTtfx5tZOb8N6lisQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8676002)(4326008)(66476007)(1076003)(66556008)(26005)(186003)(66946007)(6486002)(2616005)(508600001)(316002)(6512007)(38350700002)(38100700002)(86362001)(83380400001)(2906002)(44832011)(6506007)(54906003)(7416002)(30864003)(6916009)(8936002)(5660300002)(36756003)(52116002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cQ0YlWtbRhwDRe6w2o8fec4R7ZeWk5dr5Atvf1AHaNO7apFgZRhXx40reBSm?=
 =?us-ascii?Q?8vVaysRXFdLCygevXA32zBjaPsJy1dBWTgcIiySkuqpudC5X3qofpRM52twX?=
 =?us-ascii?Q?jd/cwQ8BRczUAUD3YJ6DVrhrQ/2RZsPWG/XkzPju4NhKlBtDtiDAaXOqFkPI?=
 =?us-ascii?Q?hoMhgcTxGfp5KUryJVDUTzlUsysL9fN/XuCKQCb9PKXYGEQZmugBOfborfjR?=
 =?us-ascii?Q?SR0oGbBNF0P4y73NnOyG1VeuhUAVibLnLwhzSVcUxXJS5vejpKtHZkCj7Ow+?=
 =?us-ascii?Q?lOCJjNnU1W7L5lrzpfNhYP1DeREwWuw8+LIdlkNPry6V1q2Gbu8f1MQhy+ib?=
 =?us-ascii?Q?/Wsqhy9E7GkqBug4CnU7MU38SpTB60wU3+mOGcCOQtiUDNEaE4CXlsUB395u?=
 =?us-ascii?Q?ToEUsUdY9LbzKdQpi1lacYOuJ/9I3utnZL/7hwFFReiIy+yoL369vzt9Fbel?=
 =?us-ascii?Q?BpOkTSTOX/1UQ6nFlyR2xHacLNWRLBx0EKpcPQwi4tBAv/HeHykv8kk9dEpA?=
 =?us-ascii?Q?1AV6yBQXJDwtf2Cs1xvI2EwUsncpOfDDH7LTpni2gjwvLs/paiDK0VS0m/Wt?=
 =?us-ascii?Q?kwyRYoN0YkV/qY2uogOzfUKkSsAIe78fUpLMKOd9fK4jvKSh9QfN1ZU6YJ2A?=
 =?us-ascii?Q?umJ7xxpaQ8bGLeodpRGGmC3qOio+thMcWksaTpPbVTEiZaHkHSrF+AiAaXKX?=
 =?us-ascii?Q?s3erpgKCJlv1Vm2a18sicf3u/HO4TiXVSC65usgD+Ve1VhcBo+NyLXYGbOIy?=
 =?us-ascii?Q?ruhxRp3K/IRntCw+0KL0U4ZN6TTsrFcIHYEHZvZ6rRtC4EaPjh5ZUih3m7e1?=
 =?us-ascii?Q?utYfmee4cIR0HM3bcXa6dh4xA+fbPp7GHU+mYwMad4re+qq24TFVluRmx1Aq?=
 =?us-ascii?Q?Zmen2us7UgM3QTW76dzCoZXOICNQk1BhSURCPyFV/VSA6K9g226VqiVRsX9W?=
 =?us-ascii?Q?/jvugw4gAqLjV85K9D8kvpjhSHPPjChFvvcL2SQVw9syO0oCN5EWGiW3txnu?=
 =?us-ascii?Q?/XCbFgtJ/x7lGWU8l8c1fuuGa6CK3XpBftWMo8a5Tx2UPvw8hvwUsAARoYQE?=
 =?us-ascii?Q?z9+YxIaVG7llX6VG6tF0AbIPGN6etDMrYQDosY3N+AiOGk19QVJGQfUrkKCE?=
 =?us-ascii?Q?95flXqZjx2qAOAvv9fIinuu9P/Jjh9XAXhW05MgMgAKcT3FhLJ4/I2qjf5pX?=
 =?us-ascii?Q?FFBFZvxgZ6lzSf8rHN4HiJ8eBSSfDRwEHK/vgD6/cH477kj8zwBySs82NVJr?=
 =?us-ascii?Q?2M/IkaTEonv4pPzmIfu+krScd8XehiEycY9tnoAC6SkstiZuMAnGMHnroIxa?=
 =?us-ascii?Q?mZlvE8AN84Gzi4oaf7ETS61nQTqjhP+v9yzmKZ+Gx3pkmKDUhXoYMx0oa+FG?=
 =?us-ascii?Q?Vq8I29q1vtYBemzu1dou1ORTOd6uLSQ3820TAFVcJMUX6ltEmMqW/eYH0IW4?=
 =?us-ascii?Q?iYBvAb+T302nmZvlrTFHOap20v5DKDMm9VL55xQyQTvjg9sWFFYeYMPOW3zd?=
 =?us-ascii?Q?VpBKc9aFIoGK9fynXTzDVdmsVmAm9Eczv9qKH/EWMd4d7s9TV1XzPrdpxKxk?=
 =?us-ascii?Q?WU4nFu/E/k3Iv8mI1dejmrrIosLnvreodI2asAdu40Ixzvp8XHG0GTbvuGG/?=
 =?us-ascii?Q?vb53Sn629tuy/8YmVmWatcY=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a29c8405-3600-4b07-c927-08d9f5808396
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2022 21:24:16.3983
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 72VYWvJeCES6B/liDCFuHpH2hjDnobQxdec1yiv3yO/uEE+qJGxymAXH5jnchPRJ3XB+HRP5kpNfHYFOPtjcEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5645
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change introduces support for installing static FDB entries towards
a bridge port that is a LAG of multiple DSA switch ports, as well as
support for filtering towards the CPU local FDB entries emitted for LAG
interfaces that are bridge ports.

Conceptually, host addresses on LAG ports are identical to what we do
for plain bridge ports. Whereas FDB entries _towards_ a LAG can't simply
be replicated towards all member ports like we do for multicast, or VLAN.
Instead we need new driver API. Hardware usually considers a LAG to be a
"logical port", and sets the entire LAG as the forwarding destination.
The physical egress port selection within the LAG is made by hashing
policy, as usual.

To represent the logical port corresponding to the LAG, we pass by value
a copy of the dsa_lag structure to all switches in the tree that have at
least one port in that LAG.

To illustrate why a refcounted list of FDB entries is needed in struct
dsa_lag, it is enough to say that:
- a LAG may be a bridge port and may therefore receive FDB events even
  while it isn't yet offloaded by any DSA interface
- DSA interfaces may be removed from a LAG while that is a bridge port;
  we don't want FDB entries lingering around, but we don't want to
  remove entries that are still in use, either

For all the cases below to work, the idea is to always keep an FDB entry
on a LAG with a reference count equal to the DSA member ports. So:
- if a port joins a LAG, it requests the bridge to replay the FDB, and
  the FDB entries get created, or their refcount gets bumped by one
- if a port leaves a LAG, the FDB replay deletes or decrements refcount
  by one
- if an FDB is installed towards a LAG with ports already present, that
  entry is created (if it doesn't exist) and its refcount is bumped by
  the amount of ports already present in the LAG

echo "Adding FDB entry to bond with existing ports"
ip link del bond0
ip link add bond0 type bond mode 802.3ad
ip link set swp1 down && ip link set swp1 master bond0 && ip link set swp1 up
ip link set swp2 down && ip link set swp2 master bond0 && ip link set swp2 up
ip link del br0
ip link add br0 type bridge
ip link set bond0 master br0
bridge fdb add dev bond0 00:01:02:03:04:05 master static

ip link del br0
ip link del bond0

echo "Adding FDB entry to empty bond"
ip link del bond0
ip link add bond0 type bond mode 802.3ad
ip link del br0
ip link add br0 type bridge
ip link set bond0 master br0
bridge fdb add dev bond0 00:01:02:03:04:05 master static
ip link set swp1 down && ip link set swp1 master bond0 && ip link set swp1 up
ip link set swp2 down && ip link set swp2 master bond0 && ip link set swp2 up

ip link del br0
ip link del bond0

echo "Adding FDB entry to empty bond, then removing ports one by one"
ip link del bond0
ip link add bond0 type bond mode 802.3ad
ip link del br0
ip link add br0 type bridge
ip link set bond0 master br0
bridge fdb add dev bond0 00:01:02:03:04:05 master static
ip link set swp1 down && ip link set swp1 master bond0 && ip link set swp1 up
ip link set swp2 down && ip link set swp2 master bond0 && ip link set swp2 up

ip link set swp1 nomaster
ip link set swp2 nomaster
ip link del br0
ip link del bond0

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v3->v4:
- remove the "void *ctx" left over in struct dsa_switchdev_event_work
- make sure the dp->lag assignment is last in dsa_port_lag_create()
v2->v3:
- leave iteration among DSA slave interfaces that are members of
  the LAG bridge port to switchdev_handle_fdb_event_to_device()
- reorder some checks that previously resulted in the access of an
  uninitialized "ds" pointer

 include/net/dsa.h  |   6 +++
 net/dsa/dsa_priv.h |  13 ++++++
 net/dsa/port.c     |  27 +++++++++++
 net/dsa/slave.c    |  43 +++++++++++-------
 net/dsa/switch.c   | 109 +++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 183 insertions(+), 15 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 81ed34998416..01faba89c987 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -119,6 +119,8 @@ struct dsa_netdevice_ops {
 struct dsa_lag {
 	struct net_device *dev;
 	unsigned int id;
+	struct mutex fdb_lock;
+	struct list_head fdbs;
 	refcount_t refcount;
 };
 
@@ -944,6 +946,10 @@ struct dsa_switch_ops {
 				const unsigned char *addr, u16 vid);
 	int	(*port_fdb_dump)(struct dsa_switch *ds, int port,
 				 dsa_fdb_dump_cb_t *cb, void *data);
+	int	(*lag_fdb_add)(struct dsa_switch *ds, struct dsa_lag lag,
+			       const unsigned char *addr, u16 vid);
+	int	(*lag_fdb_del)(struct dsa_switch *ds, struct dsa_lag lag,
+			       const unsigned char *addr, u16 vid);
 
 	/*
 	 * Multicast database
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index f2364c5adc04..1ba93afdc874 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -25,6 +25,8 @@ enum {
 	DSA_NOTIFIER_FDB_DEL,
 	DSA_NOTIFIER_HOST_FDB_ADD,
 	DSA_NOTIFIER_HOST_FDB_DEL,
+	DSA_NOTIFIER_LAG_FDB_ADD,
+	DSA_NOTIFIER_LAG_FDB_DEL,
 	DSA_NOTIFIER_LAG_CHANGE,
 	DSA_NOTIFIER_LAG_JOIN,
 	DSA_NOTIFIER_LAG_LEAVE,
@@ -67,6 +69,13 @@ struct dsa_notifier_fdb_info {
 	u16 vid;
 };
 
+/* DSA_NOTIFIER_LAG_FDB_* */
+struct dsa_notifier_lag_fdb_info {
+	struct dsa_lag *lag;
+	const unsigned char *addr;
+	u16 vid;
+};
+
 /* DSA_NOTIFIER_MDB_* */
 struct dsa_notifier_mdb_info {
 	const struct switchdev_obj_port_mdb *mdb;
@@ -214,6 +223,10 @@ int dsa_port_host_fdb_add(struct dsa_port *dp, const unsigned char *addr,
 			  u16 vid);
 int dsa_port_host_fdb_del(struct dsa_port *dp, const unsigned char *addr,
 			  u16 vid);
+int dsa_port_lag_fdb_add(struct dsa_port *dp, const unsigned char *addr,
+			 u16 vid);
+int dsa_port_lag_fdb_del(struct dsa_port *dp, const unsigned char *addr,
+			 u16 vid);
 int dsa_port_fdb_dump(struct dsa_port *dp, dsa_fdb_dump_cb_t *cb, void *data);
 int dsa_port_mdb_add(const struct dsa_port *dp,
 		     const struct switchdev_obj_port_mdb *mdb);
diff --git a/net/dsa/port.c b/net/dsa/port.c
index bf30ceaf39f4..9ca9673c9198 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -465,6 +465,8 @@ static int dsa_port_lag_create(struct dsa_port *dp,
 		return -ENOMEM;
 
 	refcount_set(&lag->refcount, 1);
+	mutex_init(&lag->fdb_lock);
+	INIT_LIST_HEAD(&lag->fdbs);
 	lag->dev = lag_dev;
 	dsa_lag_map(ds->dst, lag);
 	dp->lag = lag;
@@ -482,6 +484,7 @@ static void dsa_port_lag_destroy(struct dsa_port *dp)
 	if (!refcount_dec_and_test(&lag->refcount))
 		return;
 
+	WARN_ON(!list_empty(&lag->fdbs));
 	dsa_lag_unmap(dp->ds->dst, lag);
 	kfree(lag);
 }
@@ -860,6 +863,30 @@ int dsa_port_host_fdb_del(struct dsa_port *dp, const unsigned char *addr,
 	return dsa_port_notify(dp, DSA_NOTIFIER_HOST_FDB_DEL, &info);
 }
 
+int dsa_port_lag_fdb_add(struct dsa_port *dp, const unsigned char *addr,
+			 u16 vid)
+{
+	struct dsa_notifier_lag_fdb_info info = {
+		.lag = dp->lag,
+		.addr = addr,
+		.vid = vid,
+	};
+
+	return dsa_port_notify(dp, DSA_NOTIFIER_LAG_FDB_ADD, &info);
+}
+
+int dsa_port_lag_fdb_del(struct dsa_port *dp, const unsigned char *addr,
+			 u16 vid)
+{
+	struct dsa_notifier_lag_fdb_info info = {
+		.lag = dp->lag,
+		.addr = addr,
+		.vid = vid,
+	};
+
+	return dsa_port_notify(dp, DSA_NOTIFIER_LAG_FDB_DEL, &info);
+}
+
 int dsa_port_fdb_dump(struct dsa_port *dp, dsa_fdb_dump_cb_t *cb, void *data)
 {
 	struct dsa_switch *ds = dp->ds;
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 4aeb3e092dd6..089616206b11 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2398,6 +2398,9 @@ static void dsa_slave_switchdev_event_work(struct work_struct *work)
 		if (switchdev_work->host_addr)
 			err = dsa_port_host_fdb_add(dp, switchdev_work->addr,
 						    switchdev_work->vid);
+		else if (dp->lag)
+			err = dsa_port_lag_fdb_add(dp, switchdev_work->addr,
+						   switchdev_work->vid);
 		else
 			err = dsa_port_fdb_add(dp, switchdev_work->addr,
 					       switchdev_work->vid);
@@ -2415,6 +2418,9 @@ static void dsa_slave_switchdev_event_work(struct work_struct *work)
 		if (switchdev_work->host_addr)
 			err = dsa_port_host_fdb_del(dp, switchdev_work->addr,
 						    switchdev_work->vid);
+		else if (dp->lag)
+			err = dsa_port_lag_fdb_del(dp, switchdev_work->addr,
+						   switchdev_work->vid);
 		else
 			err = dsa_port_fdb_del(dp, switchdev_work->addr,
 					       switchdev_work->vid);
@@ -2457,25 +2463,20 @@ static int dsa_slave_fdb_event(struct net_device *dev,
 	bool host_addr = fdb_info->is_local;
 	struct dsa_switch *ds = dp->ds;
 
-	if (dp->lag)
-		return -EOPNOTSUPP;
-
 	if (ctx && ctx != dp)
 		return 0;
 
-	if (!ds->ops->port_fdb_add || !ds->ops->port_fdb_del)
-		return -EOPNOTSUPP;
-
-	if (dsa_slave_dev_check(orig_dev) &&
-	    switchdev_fdb_is_dynamically_learned(fdb_info))
-		return 0;
+	if (switchdev_fdb_is_dynamically_learned(fdb_info)) {
+		if (dsa_port_offloads_bridge_port(dp, orig_dev))
+			return 0;
 
-	/* FDB entries learned by the software bridge should be installed as
-	 * host addresses only if the driver requests assisted learning.
-	 */
-	if (switchdev_fdb_is_dynamically_learned(fdb_info) &&
-	    !ds->assisted_learning_on_cpu_port)
-		return 0;
+		/* FDB entries learned by the software bridge or by foreign
+		 * bridge ports should be installed as host addresses only if
+		 * the driver requests assisted learning.
+		 */
+		if (!ds->assisted_learning_on_cpu_port)
+			return 0;
+	}
 
 	/* Also treat FDB entries on foreign interfaces bridged with us as host
 	 * addresses.
@@ -2483,6 +2484,18 @@ static int dsa_slave_fdb_event(struct net_device *dev,
 	if (dsa_foreign_dev_check(dev, orig_dev))
 		host_addr = true;
 
+	/* Check early that we're not doing work in vain.
+	 * Host addresses on LAG ports still require regular FDB ops,
+	 * since the CPU port isn't in a LAG.
+	 */
+	if (dp->lag && !host_addr) {
+		if (!ds->ops->lag_fdb_add || !ds->ops->lag_fdb_del)
+			return -EOPNOTSUPP;
+	} else {
+		if (!ds->ops->port_fdb_add || !ds->ops->port_fdb_del)
+			return -EOPNOTSUPP;
+	}
+
 	switchdev_work = kzalloc(sizeof(*switchdev_work), GFP_ATOMIC);
 	if (!switchdev_work)
 		return -ENOMEM;
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index 0bb3987bd4e6..0c2961cbc105 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -385,6 +385,75 @@ static int dsa_port_do_fdb_del(struct dsa_port *dp, const unsigned char *addr,
 	return err;
 }
 
+static int dsa_switch_do_lag_fdb_add(struct dsa_switch *ds, struct dsa_lag *lag,
+				     const unsigned char *addr, u16 vid)
+{
+	struct dsa_mac_addr *a;
+	int err = 0;
+
+	mutex_lock(&lag->fdb_lock);
+
+	a = dsa_mac_addr_find(&lag->fdbs, addr, vid);
+	if (a) {
+		refcount_inc(&a->refcount);
+		goto out;
+	}
+
+	a = kzalloc(sizeof(*a), GFP_KERNEL);
+	if (!a) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	err = ds->ops->lag_fdb_add(ds, *lag, addr, vid);
+	if (err) {
+		kfree(a);
+		goto out;
+	}
+
+	ether_addr_copy(a->addr, addr);
+	a->vid = vid;
+	refcount_set(&a->refcount, 1);
+	list_add_tail(&a->list, &lag->fdbs);
+
+out:
+	mutex_unlock(&lag->fdb_lock);
+
+	return err;
+}
+
+static int dsa_switch_do_lag_fdb_del(struct dsa_switch *ds, struct dsa_lag *lag,
+				     const unsigned char *addr, u16 vid)
+{
+	struct dsa_mac_addr *a;
+	int err = 0;
+
+	mutex_lock(&lag->fdb_lock);
+
+	a = dsa_mac_addr_find(&lag->fdbs, addr, vid);
+	if (!a) {
+		err = -ENOENT;
+		goto out;
+	}
+
+	if (!refcount_dec_and_test(&a->refcount))
+		goto out;
+
+	err = ds->ops->lag_fdb_del(ds, *lag, addr, vid);
+	if (err) {
+		refcount_set(&a->refcount, 1);
+		goto out;
+	}
+
+	list_del(&a->list);
+	kfree(a);
+
+out:
+	mutex_unlock(&lag->fdb_lock);
+
+	return err;
+}
+
 static int dsa_switch_host_fdb_add(struct dsa_switch *ds,
 				   struct dsa_notifier_fdb_info *info)
 {
@@ -451,6 +520,40 @@ static int dsa_switch_fdb_del(struct dsa_switch *ds,
 	return dsa_port_do_fdb_del(dp, info->addr, info->vid);
 }
 
+static int dsa_switch_lag_fdb_add(struct dsa_switch *ds,
+				  struct dsa_notifier_lag_fdb_info *info)
+{
+	struct dsa_port *dp;
+
+	if (!ds->ops->lag_fdb_add)
+		return -EOPNOTSUPP;
+
+	/* Notify switch only if it has a port in this LAG */
+	dsa_switch_for_each_port(dp, ds)
+		if (dsa_port_offloads_lag(dp, info->lag))
+			return dsa_switch_do_lag_fdb_add(ds, info->lag,
+							 info->addr, info->vid);
+
+	return 0;
+}
+
+static int dsa_switch_lag_fdb_del(struct dsa_switch *ds,
+				  struct dsa_notifier_lag_fdb_info *info)
+{
+	struct dsa_port *dp;
+
+	if (!ds->ops->lag_fdb_del)
+		return -EOPNOTSUPP;
+
+	/* Notify switch only if it has a port in this LAG */
+	dsa_switch_for_each_port(dp, ds)
+		if (dsa_port_offloads_lag(dp, info->lag))
+			return dsa_switch_do_lag_fdb_del(ds, info->lag,
+							 info->addr, info->vid);
+
+	return 0;
+}
+
 static int dsa_switch_lag_change(struct dsa_switch *ds,
 				 struct dsa_notifier_lag_info *info)
 {
@@ -904,6 +1007,12 @@ static int dsa_switch_event(struct notifier_block *nb,
 	case DSA_NOTIFIER_HOST_FDB_DEL:
 		err = dsa_switch_host_fdb_del(ds, info);
 		break;
+	case DSA_NOTIFIER_LAG_FDB_ADD:
+		err = dsa_switch_lag_fdb_add(ds, info);
+		break;
+	case DSA_NOTIFIER_LAG_FDB_DEL:
+		err = dsa_switch_lag_fdb_del(ds, info);
+		break;
 	case DSA_NOTIFIER_LAG_CHANGE:
 		err = dsa_switch_lag_change(ds, info);
 		break;
-- 
2.25.1

