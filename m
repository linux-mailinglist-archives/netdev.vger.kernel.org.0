Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5323043CEA1
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 18:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236734AbhJ0QYL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 12:24:11 -0400
Received: from mail-eopbgr80080.outbound.protection.outlook.com ([40.107.8.80]:57505
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232596AbhJ0QYD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 12:24:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gF2+tfJZRAxT2+i5Zqx0MXNT4y3ifqV4bj6uC1+8qKPbSMKRR/cj9XJX1lOTTx3uSlt10Gi9YcuJwIUPxyGbkiKjUdCJwa7Pku8oaSwg2huYxb2DFvgjYsK3lIUIamnA925RrN6OXyeyEL5iyQ5tQDc1CiHktiTXLWvxxHZnC8Qaljb+K3FL7NfWTR6RVfl0kapBs1wGTXbCOU0aUxVlOjpUEgG25OwJsP2aDetV4R3F06iN5lfs/NA1PlzMQm4uW+K8K1Ff4ABGYjPmFAlnn0mibpZBF8aNwp2w6BA1RgxvL5TmQN2YgwR5e6xY51nMrwj8/vgL8QmAZjgeUBZ9GA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pQd7QGbzyRBYdNUNGvV2AYN7S0BBKlUFnCzZAhi763E=;
 b=Mv2d6ZehERDeIOC2U8yOg/QWm0rbacZKjaQx+vEAeNWXXDzA5GI2nVvWJQJy15agL+y9GEzkIDeE3e/BIw8eleDvDxXCFpruWuQma1QmGoXfUpFah+nA5PrbBkcKsUL6bXSfWq5JLb3OD3CPfqjkCBSVe1akjBQ1DUMbQmWMVkVA13onkyO/FAyyKHHfo+TMsp1L5TyvFu3RfkrFsP2RZ/VGu/UiYSVqSUVfP5OmuoIgbwEgC1LxI5D8tFXKnHtGgZj432c5OQOvLxOgOtNee83ep1EvvwcbZ/9CpCwvJ/oBC0OI7mYll75yugVyE2kjuVWh83bkvaBFRbWbN3Vu7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pQd7QGbzyRBYdNUNGvV2AYN7S0BBKlUFnCzZAhi763E=;
 b=ohD8xUpfv3CyN42iYNTxh17y2u1yaEJoyZ6bSWU1PAVKDaygbLraKuFIpG/bzM5734/59EMuDWdl5v4m73a1Vt7mXAZWClXqA+jTQrT96LtViBXOcLFdt/o2u2Y/hfmMpWoRcArtFMuUZRAHLoFD72Lyfvbbt3pK/rxylMyMEMU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6014.eurprd04.prod.outlook.com (2603:10a6:803:c9::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Wed, 27 Oct
 2021 16:21:33 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4628.020; Wed, 27 Oct 2021
 16:21:33 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 4/5] net: bridge: mdb: move all switchdev logic to br_switchdev.c
Date:   Wed, 27 Oct 2021 19:21:18 +0300
Message-Id: <20211027162119.2496321-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211027162119.2496321-1-vladimir.oltean@nxp.com>
References: <20211027162119.2496321-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0501CA0057.eurprd05.prod.outlook.com
 (2603:10a6:200:68::25) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.175.102) by AM4PR0501CA0057.eurprd05.prod.outlook.com (2603:10a6:200:68::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14 via Frontend Transport; Wed, 27 Oct 2021 16:21:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7f7cd8ad-8661-44f1-3092-08d99965d768
X-MS-TrafficTypeDiagnostic: VI1PR04MB6014:
X-Microsoft-Antispam-PRVS: <VI1PR04MB60144CC6C1789E09252CF381E0859@VI1PR04MB6014.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eKUgBiWv8kuYDLc/8sQd1C2HwT1Pni0h29ETIwBWaw7P4mKbYc78wiPW7f+RZ+ZjKcCUefOJgJrCOEDz641WHFBdma9JM7PlSDV/7gct77Mb2pxp1qH1wGpl1vWyW0QJjTjQ7y2dx6hRj2rSFb6XeL8cdbFG+qZ/8znZRITUxmQG7h7DBnDSudS/3JglO0yhkuS4pWKSWbGBgXOEW7miNskjEwSsy++akl8KNDrYkB/JCcez29jjy9daXHAy9aHLn8dNSePyobbkJ65MR0+evB/8WXwcDgg8/x1uK3dW13GKuksnCKHfErwyVkPG4NCPyEYuurRKiJ4i1iCo4n7zR6YkAlZw2eoHoPVhRkuX9zsVpA9/bRNHdD2W5ABh9SYNAjMBIOhOyZEwRcMJBcGO58U/pYnVXWHjq8WvRR7z2SQw87sGjyjJ5YmMhcQOI+5whFPQSWwTzdAybecMlxt/KEAOnAHXQsG9izNGfltuQRmm7Dmh06wJXNoeVWLtF++rRbdmqMAHMTDcnFG+ImHNTqR0QAGOXKCq3Il4QwXAnSH/Son4LdK6/c9lQeZn1i/HHhYIxDUpsfqjc5yohZoJvC83e0TBIWrr63PvqqqEiUsQEP8abt1ft3LUNt3vLSwtdU8CVunB0FrmfV9gdGvb/WAbzvLeONIXxS4UAP2mfCd+6VZTu1qZ3+96JIfPgDKmVeB8MOFM85O1LKl6jRD1Pw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6666004)(66476007)(52116002)(6506007)(2616005)(316002)(86362001)(6512007)(83380400001)(508600001)(26005)(6916009)(4326008)(30864003)(8676002)(66556008)(66946007)(5660300002)(8936002)(186003)(38100700002)(36756003)(54906003)(2906002)(38350700002)(6486002)(956004)(1076003)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mZlo0cR0/aTfCy5+VCrq8R0ITy4pFdIjgRcdOWsLuytu26AO0NUAuj+wY6qa?=
 =?us-ascii?Q?lARVXxf2wn8As5K0hofr7A7VsqaUYVzMctrikFpzEtsynsFcPpcrcJUdEcSX?=
 =?us-ascii?Q?Eg/QdmTjJesklJT5GMXe2Km09r0dUX1b4GYrPRXLX2vHb/Xokd1qj3FyHBQV?=
 =?us-ascii?Q?F5rfNEb4QGt7ECY8V8w0u5AA9jvcNq8hkjnQ7Vn8hsmQUe50ppUC7Mqss5NU?=
 =?us-ascii?Q?contkrHZKBX47sLUsP6iwRRxMfmvNTwGICOzdkTRTApO1vsY2OK4YcCepz/f?=
 =?us-ascii?Q?VTOhSLuSEfCaGGvnj4RvzOq+wKSwCvbFsMtnSnDkpuhKGgKxSXo/45RxQq2/?=
 =?us-ascii?Q?+lm3L+rHzvifZ2UGiEDtxpKOK28qtqu5+/anu7xwEosrSqj2CsrRte5BUuLW?=
 =?us-ascii?Q?A946c/i302742R7pcx8ihZwb4ZVui+Eh3jZO+og2/Bf9kILqOue93os7MEAH?=
 =?us-ascii?Q?e/KZAdf399+PjB5pXNeV+lWH04LtMjkrW57ueTiLBNQ4mi2YGG5zrJnIT/95?=
 =?us-ascii?Q?RtFQM3CFq+Doi64G+g9GFxTRlsWGSopJOTbbxB+9MCSWnngSxszYjhgAL2tr?=
 =?us-ascii?Q?Yrn9I/37ZX8fk23ask3qEf1YaCe8reoyIwRrs8TgVHGJpGL4krbouXEQKJJH?=
 =?us-ascii?Q?Ja0ClgAV993twsQLKVpaq/ctxgKkLXVYLouxhyz9ZNxPR+HUPgc2qQ25V6Y4?=
 =?us-ascii?Q?eNb6hgz86k1+9yJ3Jr82A6p/+ZEkpuaOqbatZ5k6ThOqTweKIYQtLt7UobZI?=
 =?us-ascii?Q?bYeQjK71YBCU5vBHn3sUFUsiL45z+352aa3vsaK2AEiv7R2WsZYFFNdLTyjF?=
 =?us-ascii?Q?xU0X5oEjxXZj6Pz/FGW8/6PRaSFqwv/OJb5jFspkYtFQOFWY7MIXC2aoU93t?=
 =?us-ascii?Q?dH1SYtq7s5+jSOwm1INZBOebC8ZvtmrIO5Ges/yUai8MTsGiEN15IJu2OAO9?=
 =?us-ascii?Q?wrSImKIFi0nX2SrA39LpiLww9ii+pI7GQPPO5/vhuF8FWGJ9T8KJXYKOpSSH?=
 =?us-ascii?Q?iJ+hvGbH299ruGzq2AHZ5ugkLm+fwWbgHE5wKuuJJ/q+yT9ATDCA8AM7gfc8?=
 =?us-ascii?Q?5Fd306AytBtO0VhfMtsS7T8dtQ1QfJK+y7Ffp1xjxBL2ED0t2aZBUtO+6IE1?=
 =?us-ascii?Q?PhgjCt8ELdyMk88i6pLgMJgmy8HbtGPU86UeB/kZGsj0GuDTQXwfB3O0tQ1T?=
 =?us-ascii?Q?AZH5JUFE447cEN5Th7ajyx65bvn7JEsY+b8W8PhG5j7wVFTmVkXsp2sS+i6i?=
 =?us-ascii?Q?mpyCdhiHboiFIzXyPoFcbrtBcR42kUzn7QiBdhM7nPkS6cSQtwlELyj3mssP?=
 =?us-ascii?Q?Mi3HoHbFiHMylFncJmF+RPJ7g8CbvJe7X3MeA26NJ9dd1NAq1WRFObvOBUgA?=
 =?us-ascii?Q?7925TxN4Wq89LncJkGRxa/d2AldD53DYplK4LvW34kL/x1hniP0V8SUV+k76?=
 =?us-ascii?Q?Kf9yzyNwtbFVoq9pFxKmU7d/r0Yq5Hx9CK9ovHza0I0oLimL101OpodXlMZ6?=
 =?us-ascii?Q?QiZeOlfJbLLZuz9G8mvvqRPGP7LlZqmGhm+eW8y/f0hWe+KpBEHFXjSUrlPm?=
 =?us-ascii?Q?g39DMdA5s/0SRgFQTDk1/I38KXyvD2p+KrQ+CQBEdoh1QYQn+Bld1DbHFU0x?=
 =?us-ascii?Q?4QDue6Hg2TrLyFS3vgMPb08=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f7cd8ad-8661-44f1-3092-08d99965d768
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2021 16:21:33.6320
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uFc+xyigynY5Y/DFmmA6PesIIXxxOPDd7DN49DCfLFvxN6nRR6NPYFEuF3oQj4p29knz0IT7UjOVqD/bKYf2uA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6014
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following functions:

br_mdb_complete
br_switchdev_mdb_populate
br_mdb_replay_one
br_mdb_queue_one
br_mdb_replay
br_mdb_switchdev_host_port
br_mdb_switchdev_host
br_switchdev_mdb_notify

are only accessible from code paths where CONFIG_NET_SWITCHDEV is
enabled. So move them to br_switchdev.c, in order for that code to be
compiled out if that config option is disabled.

Note that br_switchdev.c gets build regardless of whether
CONFIG_BRIDGE_IGMP_SNOOPING is enabled or not, whereas br_mdb.c only got
built when CONFIG_BRIDGE_IGMP_SNOOPING was enabled. So to preserve
correct compilation with CONFIG_BRIDGE_IGMP_SNOOPING being disabled, we
must now place an #ifdef around these functions in br_switchdev.c.
The offending bridge data structures that need this are
br->multicast_lock and br->mdb_list, these are also compiled out of
struct net_bridge when CONFIG_BRIDGE_IGMP_SNOOPING is turned off.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/bridge/br_mdb.c       | 244 ------------------------------------
 net/bridge/br_private.h   |  17 +--
 net/bridge/br_switchdev.c | 253 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 262 insertions(+), 252 deletions(-)

diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index 9513f0791c3d..4556d913955b 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -552,250 +552,6 @@ static size_t rtnl_mdb_nlmsg_size(struct net_bridge_port_group *pg)
 	return nlmsg_size;
 }
 
-struct br_mdb_complete_info {
-	struct net_bridge_port *port;
-	struct br_ip ip;
-};
-
-static void br_mdb_complete(struct net_device *dev, int err, void *priv)
-{
-	struct br_mdb_complete_info *data = priv;
-	struct net_bridge_port_group __rcu **pp;
-	struct net_bridge_port_group *p;
-	struct net_bridge_mdb_entry *mp;
-	struct net_bridge_port *port = data->port;
-	struct net_bridge *br = port->br;
-
-	if (err)
-		goto err;
-
-	spin_lock_bh(&br->multicast_lock);
-	mp = br_mdb_ip_get(br, &data->ip);
-	if (!mp)
-		goto out;
-	for (pp = &mp->ports; (p = mlock_dereference(*pp, br)) != NULL;
-	     pp = &p->next) {
-		if (p->key.port != port)
-			continue;
-		p->flags |= MDB_PG_FLAGS_OFFLOAD;
-	}
-out:
-	spin_unlock_bh(&br->multicast_lock);
-err:
-	kfree(priv);
-}
-
-static void br_switchdev_mdb_populate(struct switchdev_obj_port_mdb *mdb,
-				      const struct net_bridge_mdb_entry *mp)
-{
-	if (mp->addr.proto == htons(ETH_P_IP))
-		ip_eth_mc_map(mp->addr.dst.ip4, mdb->addr);
-#if IS_ENABLED(CONFIG_IPV6)
-	else if (mp->addr.proto == htons(ETH_P_IPV6))
-		ipv6_eth_mc_map(&mp->addr.dst.ip6, mdb->addr);
-#endif
-	else
-		ether_addr_copy(mdb->addr, mp->addr.dst.mac_addr);
-
-	mdb->vid = mp->addr.vid;
-}
-
-static int br_mdb_replay_one(struct notifier_block *nb, struct net_device *dev,
-			     const struct switchdev_obj_port_mdb *mdb,
-			     unsigned long action, const void *ctx,
-			     struct netlink_ext_ack *extack)
-{
-	struct switchdev_notifier_port_obj_info obj_info = {
-		.info = {
-			.dev = dev,
-			.extack = extack,
-			.ctx = ctx,
-		},
-		.obj = &mdb->obj,
-	};
-	int err;
-
-	err = nb->notifier_call(nb, action, &obj_info);
-	return notifier_to_errno(err);
-}
-
-static int br_mdb_queue_one(struct list_head *mdb_list,
-			    enum switchdev_obj_id id,
-			    const struct net_bridge_mdb_entry *mp,
-			    struct net_device *orig_dev)
-{
-	struct switchdev_obj_port_mdb *mdb;
-
-	mdb = kzalloc(sizeof(*mdb), GFP_ATOMIC);
-	if (!mdb)
-		return -ENOMEM;
-
-	mdb->obj.id = id;
-	mdb->obj.orig_dev = orig_dev;
-	br_switchdev_mdb_populate(mdb, mp);
-	list_add_tail(&mdb->obj.list, mdb_list);
-
-	return 0;
-}
-
-int br_mdb_replay(struct net_device *br_dev, struct net_device *dev,
-		  const void *ctx, bool adding, struct notifier_block *nb,
-		  struct netlink_ext_ack *extack)
-{
-	const struct net_bridge_mdb_entry *mp;
-	struct switchdev_obj *obj, *tmp;
-	struct net_bridge *br;
-	unsigned long action;
-	LIST_HEAD(mdb_list);
-	int err = 0;
-
-	ASSERT_RTNL();
-
-	if (!nb)
-		return 0;
-
-	if (!netif_is_bridge_master(br_dev) || !netif_is_bridge_port(dev))
-		return -EINVAL;
-
-	br = netdev_priv(br_dev);
-
-	if (!br_opt_get(br, BROPT_MULTICAST_ENABLED))
-		return 0;
-
-	/* We cannot walk over br->mdb_list protected just by the rtnl_mutex,
-	 * because the write-side protection is br->multicast_lock. But we
-	 * need to emulate the [ blocking ] calling context of a regular
-	 * switchdev event, so since both br->multicast_lock and RCU read side
-	 * critical sections are atomic, we have no choice but to pick the RCU
-	 * read side lock, queue up all our events, leave the critical section
-	 * and notify switchdev from blocking context.
-	 */
-	rcu_read_lock();
-
-	hlist_for_each_entry_rcu(mp, &br->mdb_list, mdb_node) {
-		struct net_bridge_port_group __rcu * const *pp;
-		const struct net_bridge_port_group *p;
-
-		if (mp->host_joined) {
-			err = br_mdb_queue_one(&mdb_list,
-					       SWITCHDEV_OBJ_ID_HOST_MDB,
-					       mp, br_dev);
-			if (err) {
-				rcu_read_unlock();
-				goto out_free_mdb;
-			}
-		}
-
-		for (pp = &mp->ports; (p = rcu_dereference(*pp)) != NULL;
-		     pp = &p->next) {
-			if (p->key.port->dev != dev)
-				continue;
-
-			err = br_mdb_queue_one(&mdb_list,
-					       SWITCHDEV_OBJ_ID_PORT_MDB,
-					       mp, dev);
-			if (err) {
-				rcu_read_unlock();
-				goto out_free_mdb;
-			}
-		}
-	}
-
-	rcu_read_unlock();
-
-	if (adding)
-		action = SWITCHDEV_PORT_OBJ_ADD;
-	else
-		action = SWITCHDEV_PORT_OBJ_DEL;
-
-	list_for_each_entry(obj, &mdb_list, list) {
-		err = br_mdb_replay_one(nb, dev, SWITCHDEV_OBJ_PORT_MDB(obj),
-					action, ctx, extack);
-		if (err)
-			goto out_free_mdb;
-	}
-
-out_free_mdb:
-	list_for_each_entry_safe(obj, tmp, &mdb_list, list) {
-		list_del(&obj->list);
-		kfree(SWITCHDEV_OBJ_PORT_MDB(obj));
-	}
-
-	return err;
-}
-
-static void br_mdb_switchdev_host_port(struct net_device *dev,
-				       struct net_device *lower_dev,
-				       struct net_bridge_mdb_entry *mp,
-				       int type)
-{
-	struct switchdev_obj_port_mdb mdb = {
-		.obj = {
-			.id = SWITCHDEV_OBJ_ID_HOST_MDB,
-			.flags = SWITCHDEV_F_DEFER,
-			.orig_dev = dev,
-		},
-	};
-
-	br_switchdev_mdb_populate(&mdb, mp);
-
-	switch (type) {
-	case RTM_NEWMDB:
-		switchdev_port_obj_add(lower_dev, &mdb.obj, NULL);
-		break;
-	case RTM_DELMDB:
-		switchdev_port_obj_del(lower_dev, &mdb.obj);
-		break;
-	}
-}
-
-static void br_mdb_switchdev_host(struct net_device *dev,
-				  struct net_bridge_mdb_entry *mp, int type)
-{
-	struct net_device *lower_dev;
-	struct list_head *iter;
-
-	netdev_for_each_lower_dev(dev, lower_dev, iter)
-		br_mdb_switchdev_host_port(dev, lower_dev, mp, type);
-}
-
-static void br_switchdev_mdb_notify(struct net_device *dev,
-				    struct net_bridge_mdb_entry *mp,
-				    struct net_bridge_port_group *pg,
-				    int type)
-{
-	struct br_mdb_complete_info *complete_info;
-	struct switchdev_obj_port_mdb mdb = {
-		.obj = {
-			.id = SWITCHDEV_OBJ_ID_PORT_MDB,
-			.flags = SWITCHDEV_F_DEFER,
-		},
-	};
-
-	if (!pg)
-		return br_mdb_switchdev_host(dev, mp, type);
-
-	br_switchdev_mdb_populate(&mdb, mp);
-
-	mdb.obj.orig_dev = pg->key.port->dev;
-	switch (type) {
-	case RTM_NEWMDB:
-		complete_info = kmalloc(sizeof(*complete_info), GFP_ATOMIC);
-		if (!complete_info)
-			break;
-		complete_info->port = pg->key.port;
-		complete_info->ip = mp->addr;
-		mdb.obj.complete_priv = complete_info;
-		mdb.obj.complete = br_mdb_complete;
-		if (switchdev_port_obj_add(pg->key.port->dev, &mdb.obj, NULL))
-			kfree(complete_info);
-		break;
-	case RTM_DELMDB:
-		switchdev_port_obj_del(pg->key.port->dev, &mdb.obj);
-		break;
-	}
-}
-
 void br_mdb_notify(struct net_device *dev,
 		   struct net_bridge_mdb_entry *mp,
 		   struct net_bridge_port_group *pg,
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index b16c83e10356..5552c00ed9c4 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -956,9 +956,11 @@ int br_multicast_toggle_vlan_snooping(struct net_bridge *br, bool on,
 				      struct netlink_ext_ack *extack);
 bool br_multicast_toggle_global_vlan(struct net_bridge_vlan *vlan, bool on);
 
-int br_mdb_replay(struct net_device *br_dev, struct net_device *dev,
-		  const void *ctx, bool adding, struct notifier_block *nb,
-		  struct netlink_ext_ack *extack);
+void br_switchdev_mdb_notify(struct net_device *dev,
+			     struct net_bridge_mdb_entry *mp,
+			     struct net_bridge_port_group *pg,
+			     int type);
+
 int br_rports_fill_info(struct sk_buff *skb,
 			const struct net_bridge_mcast *brmctx);
 int br_multicast_dump_querier_state(struct sk_buff *skb,
@@ -1394,12 +1396,11 @@ static inline bool br_multicast_toggle_global_vlan(struct net_bridge_vlan *vlan,
 	return false;
 }
 
-static inline int br_mdb_replay(struct net_device *br_dev,
-				struct net_device *dev, const void *ctx,
-				bool adding, struct notifier_block *nb,
-				struct netlink_ext_ack *extack)
+static inline void br_switchdev_mdb_notify(struct net_device *dev,
+					   struct net_bridge_mdb_entry *mp,
+					   struct net_bridge_port_group *pg,
+					   int type)
 {
-	return -EOPNOTSUPP;
 }
 
 static inline bool
diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index d773d819a867..b7645165143c 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -4,6 +4,7 @@
 #include <linux/netdevice.h>
 #include <linux/rtnetlink.h>
 #include <linux/skbuff.h>
+#include <net/ip.h>
 #include <net/switchdev.h>
 
 #include "br_private.h"
@@ -412,6 +413,258 @@ static int br_vlan_replay(struct net_device *br_dev, struct net_device *dev,
 	return err;
 }
 
+#ifdef CONFIG_BRIDGE_IGMP_SNOOPING
+struct br_mdb_complete_info {
+	struct net_bridge_port *port;
+	struct br_ip ip;
+};
+
+static void br_mdb_complete(struct net_device *dev, int err, void *priv)
+{
+	struct br_mdb_complete_info *data = priv;
+	struct net_bridge_port_group __rcu **pp;
+	struct net_bridge_port_group *p;
+	struct net_bridge_mdb_entry *mp;
+	struct net_bridge_port *port = data->port;
+	struct net_bridge *br = port->br;
+
+	if (err)
+		goto err;
+
+	spin_lock_bh(&br->multicast_lock);
+	mp = br_mdb_ip_get(br, &data->ip);
+	if (!mp)
+		goto out;
+	for (pp = &mp->ports; (p = mlock_dereference(*pp, br)) != NULL;
+	     pp = &p->next) {
+		if (p->key.port != port)
+			continue;
+		p->flags |= MDB_PG_FLAGS_OFFLOAD;
+	}
+out:
+	spin_unlock_bh(&br->multicast_lock);
+err:
+	kfree(priv);
+}
+
+static void br_switchdev_mdb_populate(struct switchdev_obj_port_mdb *mdb,
+				      const struct net_bridge_mdb_entry *mp)
+{
+	if (mp->addr.proto == htons(ETH_P_IP))
+		ip_eth_mc_map(mp->addr.dst.ip4, mdb->addr);
+#if IS_ENABLED(CONFIG_IPV6)
+	else if (mp->addr.proto == htons(ETH_P_IPV6))
+		ipv6_eth_mc_map(&mp->addr.dst.ip6, mdb->addr);
+#endif
+	else
+		ether_addr_copy(mdb->addr, mp->addr.dst.mac_addr);
+
+	mdb->vid = mp->addr.vid;
+}
+
+static void br_mdb_switchdev_host_port(struct net_device *dev,
+				       struct net_device *lower_dev,
+				       struct net_bridge_mdb_entry *mp,
+				       int type)
+{
+	struct switchdev_obj_port_mdb mdb = {
+		.obj = {
+			.id = SWITCHDEV_OBJ_ID_HOST_MDB,
+			.flags = SWITCHDEV_F_DEFER,
+			.orig_dev = dev,
+		},
+	};
+
+	br_switchdev_mdb_populate(&mdb, mp);
+
+	switch (type) {
+	case RTM_NEWMDB:
+		switchdev_port_obj_add(lower_dev, &mdb.obj, NULL);
+		break;
+	case RTM_DELMDB:
+		switchdev_port_obj_del(lower_dev, &mdb.obj);
+		break;
+	}
+}
+
+static void br_mdb_switchdev_host(struct net_device *dev,
+				  struct net_bridge_mdb_entry *mp, int type)
+{
+	struct net_device *lower_dev;
+	struct list_head *iter;
+
+	netdev_for_each_lower_dev(dev, lower_dev, iter)
+		br_mdb_switchdev_host_port(dev, lower_dev, mp, type);
+}
+
+static int br_mdb_replay_one(struct notifier_block *nb, struct net_device *dev,
+			     const struct switchdev_obj_port_mdb *mdb,
+			     unsigned long action, const void *ctx,
+			     struct netlink_ext_ack *extack)
+{
+	struct switchdev_notifier_port_obj_info obj_info = {
+		.info = {
+			.dev = dev,
+			.extack = extack,
+			.ctx = ctx,
+		},
+		.obj = &mdb->obj,
+	};
+	int err;
+
+	err = nb->notifier_call(nb, action, &obj_info);
+	return notifier_to_errno(err);
+}
+
+static int br_mdb_queue_one(struct list_head *mdb_list,
+			    enum switchdev_obj_id id,
+			    const struct net_bridge_mdb_entry *mp,
+			    struct net_device *orig_dev)
+{
+	struct switchdev_obj_port_mdb *mdb;
+
+	mdb = kzalloc(sizeof(*mdb), GFP_ATOMIC);
+	if (!mdb)
+		return -ENOMEM;
+
+	mdb->obj.id = id;
+	mdb->obj.orig_dev = orig_dev;
+	br_switchdev_mdb_populate(mdb, mp);
+	list_add_tail(&mdb->obj.list, mdb_list);
+
+	return 0;
+}
+
+void br_switchdev_mdb_notify(struct net_device *dev,
+			     struct net_bridge_mdb_entry *mp,
+			     struct net_bridge_port_group *pg,
+			     int type)
+{
+	struct br_mdb_complete_info *complete_info;
+	struct switchdev_obj_port_mdb mdb = {
+		.obj = {
+			.id = SWITCHDEV_OBJ_ID_PORT_MDB,
+			.flags = SWITCHDEV_F_DEFER,
+		},
+	};
+
+	if (!pg)
+		return br_mdb_switchdev_host(dev, mp, type);
+
+	br_switchdev_mdb_populate(&mdb, mp);
+
+	mdb.obj.orig_dev = pg->key.port->dev;
+	switch (type) {
+	case RTM_NEWMDB:
+		complete_info = kmalloc(sizeof(*complete_info), GFP_ATOMIC);
+		if (!complete_info)
+			break;
+		complete_info->port = pg->key.port;
+		complete_info->ip = mp->addr;
+		mdb.obj.complete_priv = complete_info;
+		mdb.obj.complete = br_mdb_complete;
+		if (switchdev_port_obj_add(pg->key.port->dev, &mdb.obj, NULL))
+			kfree(complete_info);
+		break;
+	case RTM_DELMDB:
+		switchdev_port_obj_del(pg->key.port->dev, &mdb.obj);
+		break;
+	}
+}
+#endif
+
+static int br_mdb_replay(struct net_device *br_dev, struct net_device *dev,
+			 const void *ctx, bool adding,
+			 struct notifier_block *nb,
+			 struct netlink_ext_ack *extack)
+{
+#ifdef CONFIG_BRIDGE_IGMP_SNOOPING
+	const struct net_bridge_mdb_entry *mp;
+	struct switchdev_obj *obj, *tmp;
+	struct net_bridge *br;
+	unsigned long action;
+	LIST_HEAD(mdb_list);
+	int err = 0;
+
+	ASSERT_RTNL();
+
+	if (!nb)
+		return 0;
+
+	if (!netif_is_bridge_master(br_dev) || !netif_is_bridge_port(dev))
+		return -EINVAL;
+
+	br = netdev_priv(br_dev);
+
+	if (!br_opt_get(br, BROPT_MULTICAST_ENABLED))
+		return 0;
+
+	/* We cannot walk over br->mdb_list protected just by the rtnl_mutex,
+	 * because the write-side protection is br->multicast_lock. But we
+	 * need to emulate the [ blocking ] calling context of a regular
+	 * switchdev event, so since both br->multicast_lock and RCU read side
+	 * critical sections are atomic, we have no choice but to pick the RCU
+	 * read side lock, queue up all our events, leave the critical section
+	 * and notify switchdev from blocking context.
+	 */
+	rcu_read_lock();
+
+	hlist_for_each_entry_rcu(mp, &br->mdb_list, mdb_node) {
+		struct net_bridge_port_group __rcu * const *pp;
+		const struct net_bridge_port_group *p;
+
+		if (mp->host_joined) {
+			err = br_mdb_queue_one(&mdb_list,
+					       SWITCHDEV_OBJ_ID_HOST_MDB,
+					       mp, br_dev);
+			if (err) {
+				rcu_read_unlock();
+				goto out_free_mdb;
+			}
+		}
+
+		for (pp = &mp->ports; (p = rcu_dereference(*pp)) != NULL;
+		     pp = &p->next) {
+			if (p->key.port->dev != dev)
+				continue;
+
+			err = br_mdb_queue_one(&mdb_list,
+					       SWITCHDEV_OBJ_ID_PORT_MDB,
+					       mp, dev);
+			if (err) {
+				rcu_read_unlock();
+				goto out_free_mdb;
+			}
+		}
+	}
+
+	rcu_read_unlock();
+
+	if (adding)
+		action = SWITCHDEV_PORT_OBJ_ADD;
+	else
+		action = SWITCHDEV_PORT_OBJ_DEL;
+
+	list_for_each_entry(obj, &mdb_list, list) {
+		err = br_mdb_replay_one(nb, dev, SWITCHDEV_OBJ_PORT_MDB(obj),
+					action, ctx, extack);
+		if (err)
+			goto out_free_mdb;
+	}
+
+out_free_mdb:
+	list_for_each_entry_safe(obj, tmp, &mdb_list, list) {
+		list_del(&obj->list);
+		kfree(SWITCHDEV_OBJ_PORT_MDB(obj));
+	}
+
+	if (err)
+		return err;
+#endif
+
+	return 0;
+}
+
 static int nbp_switchdev_sync_objs(struct net_bridge_port *p, const void *ctx,
 				   struct notifier_block *atomic_nb,
 				   struct notifier_block *blocking_nb,
-- 
2.25.1

