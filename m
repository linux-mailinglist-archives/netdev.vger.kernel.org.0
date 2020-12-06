Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 615B32D086E
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 01:02:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728760AbgLGABc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Dec 2020 19:01:32 -0500
Received: from mail-eopbgr80082.outbound.protection.outlook.com ([40.107.8.82]:2436
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728715AbgLGABc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 6 Dec 2020 19:01:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XMrNUKQfWANdMWHHoTW2QQXfsYnfloO2RlDWxr0pagU0x1QXBlc1FXGsXI64FkiApn28ll7KtZdpuNdqJAqK7mTVwTIospxbVSrh3ZtjPIOp3e7J4zpSVmbsmx4jlvbwb0NwB884UEdptbmPb0ITs5S1JtTcyvAYKq+FnR4RD5w472lN+qVHBFJcn3/DdIYdtxpaJI/EXr6NhoKWk6NHrn8Q5kF9XnntKkUHTw+0XzjoM/7LjNl61PZ4uv0uzFGwR2MFPoo+2fpXbzK5JydckDW0DndQAMDG2IYIDwxYcMaT4nwpeSaQjKYNVvrPx7Ws7y99+49eFaWbIDAWWelFoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aY0/IkAWKznNa/gL2l77XEYt95zVr83h8i2p05YcBcw=;
 b=CODp55VgplN1caT2Tp2r6hfKmSTmm0+QZvXL1+z3M+J7CA7/VvvEYi14hkVnS27fnkN9iaSXXTzrOmMjmcTIzEpADIrzH9XCBX/5T7rxbqoIALvWHWhpirSPZ6uuOkmwo0M2M5k3LExgm16HGwGFw/ZiyMUg/vcpeQNdXxGrrcOdcklwExgg0YBdE3gJeYYfjGe97Vi/jPags7y1BX2rNsRRO1VyUrVU2VjD0zWHaMMylF+h7gO3ZpXT9Ni5IyuL6tjdBXlnvJSz1cEZTkzryA+IVgGpB8fQu+h/xS8udaLiiVYp882ckV9YvPSSA2AXA8ech00rXHOssgBWQc483A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aY0/IkAWKznNa/gL2l77XEYt95zVr83h8i2p05YcBcw=;
 b=IlgKghUqJnqLYHJeEd9R4K7iiBu/Iy61RVhicAsDaJtEIg2qjZSDmLJrma59tdeCxrlvEBARAqa3DGRzdZnNshoCOdZbmeXeBGcgxMWeWYtMZDuQy1+2IVKhT1nHl5xioSJOduqJ81q66ctLi8MN/EEZXnD7OOVhZTI7fhGeDjg=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VE1PR04MB6637.eurprd04.prod.outlook.com (2603:10a6:803:126::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17; Mon, 7 Dec
 2020 00:00:01 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3632.021; Mon, 7 Dec 2020
 00:00:01 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jiri Benc <jbenc@redhat.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Eric Dumazet <edumazet@google.com>,
        George McCollister <george.mccollister@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>
Subject: [RFC PATCH net-next 03/13] net: introduce a mutex for the netns interface lists
Date:   Mon,  7 Dec 2020 01:59:09 +0200
Message-Id: <20201206235919.393158-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201206235919.393158-1-vladimir.oltean@nxp.com>
References: <20201206235919.393158-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.120]
X-ClientProxiedBy: VI1PR08CA0156.eurprd08.prod.outlook.com
 (2603:10a6:800:d5::34) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.120) by VI1PR08CA0156.eurprd08.prod.outlook.com (2603:10a6:800:d5::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.21 via Frontend Transport; Mon, 7 Dec 2020 00:00:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 786714ef-2c81-498b-1f8c-08d89a430af6
X-MS-TrafficTypeDiagnostic: VE1PR04MB6637:
X-Microsoft-Antispam-PRVS: <VE1PR04MB663703074F313EB7A8E1A3FCE0CE0@VE1PR04MB6637.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ez+mzGfHkQY6Rr8TUTSyMRknHRPtYAardN75t9iDybg/WHe9yaNZUwcEZ9EpGHAIS9BM7NlggUaGXfxFrcFoZxGl89cngCEf0Q0rDuCVU0zMNPYOa3cfj39IT7kFUwvxviuJvdWNWjplW7H1OsgMoYGIPrEHXDVmuXH1O5nGbENeW4D5nPxDkS4SGeKNNd3g2q1U0G4GimMzodF8snBlAw7HnktDKWlO+m8grP57GAhSV5IEhWSA8pUroBSamCTBI4aggS2Auv2KpVWYEhymMVIlvwnn/lRnMZQFqhER1dHvmTCBrDvSZTpDvq+GWGn0FWMZcV7/zESnLnrakpiIxDc9+kOSDupx+AMinPhPrAhgNCAkuonLm0ojTyPRFLdj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(366004)(136003)(39860400002)(376002)(6506007)(52116002)(5660300002)(66946007)(66556008)(26005)(8676002)(2906002)(8936002)(1076003)(316002)(110136005)(54906003)(478600001)(44832011)(7416002)(6512007)(186003)(6486002)(16526019)(36756003)(956004)(4326008)(86362001)(66476007)(69590400008)(2616005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?tB+CK+We1gyU+Rh3Md+2ho4D9ktaWeSCURxJ7g3P1zDVGsBOnjS99i7axLwA?=
 =?us-ascii?Q?AmTg6papUEWYtccwKSa7hjZxMB4dCraL9qAsEkskdlNc8J2Feq6noyBsNqHZ?=
 =?us-ascii?Q?VB2itdjM2FsffKMWCilUHj5AvB00FSMOhrepml3AORnVnCjN9C64X2o15yeR?=
 =?us-ascii?Q?p9QCirfTjVSDv9eOGRM3tUJDv3Ei+KJ63iQlbUDjD25ZM1LNvjwtYliFx8I9?=
 =?us-ascii?Q?EUQAS+Tm7aF/OxGo+U/hM9K7H/P/tmDofapaynx9CnIKzxOPfP3YzMJfudck?=
 =?us-ascii?Q?FdREheGPFLMQM2r37M2LlqcdVrMCSKxtZbunpx9vYTll22qDomcW5uCtpbeO?=
 =?us-ascii?Q?eU8qLKIHpj3yfrmuEIuYiJNyI/IVf6sNkaNfVq4VreKQk42B6CWu6My06sC5?=
 =?us-ascii?Q?UNzJp4bvEUeOJw2dRt3OO6KulHltVXnhsO27AogpfGKKALOBE3PmbA8ArN5n?=
 =?us-ascii?Q?4rwX/yU0q/hrBPQCNuqcvf6u1KJrY5i8pxiJM1MGq9M3cr8PFKSxtIMa4t5Y?=
 =?us-ascii?Q?PdRRxWJUAOM4W1wFusSeqkxm9DbsnUT9F7SvI5Biv1NZBtPSk/5IOe3pbOfj?=
 =?us-ascii?Q?I7NayM+VzVuuJ3CtEzLSgVxdHxkReV0fgx42r3RzAzejYDLwOyVqHdArqzk/?=
 =?us-ascii?Q?t4G/qqbZ79sjx0EskV7s6xuvXDs3HfnYKasNE5Zen6mMZrS/MXR0BG32w1tx?=
 =?us-ascii?Q?HHUa5ZKwke4bcNELdYyHKLoi3se8107ykB3lBZez+6PQECe+mVOqZGjEucAd?=
 =?us-ascii?Q?xzsNWwpPIXmYtiqeyhyOxQ053YPXtkMgae6QnOSkiktPyobmjdGdAXiDtMN1?=
 =?us-ascii?Q?PVfD7kpd2MxtpfdorHx9t6BgpERwJWkZBTK7bnc5FEGYfmWTnqoWZ/3eK3Go?=
 =?us-ascii?Q?KHQpyHjzvSaoFZmHA7ZhkYrU/6YljS/wtNPMrL0Zlt+nEya+CbUMOfqliALk?=
 =?us-ascii?Q?/LRhraeD4tFztdeVZ3tBFZm5g9Q3v8449Fwd7zUX4UI=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 786714ef-2c81-498b-1f8c-08d89a430af6
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2020 00:00:01.2852
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HQecPmU2H+hPxha1j41N4cp302viZf4VfXoyt5eLVICk50BzwhS2sS3uSbvbshcega9s/mbI4HODS0zOsB8ygQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6637
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, any writer that wants to alter the lists of network
interfaces (either the plain list net->dev_base_head, or the hash tables
net->dev_index_head and net->dev_name_head) can keep other writers at
bay using the RTNL mutex.

However, the RTNL mutex has become a very contended resource over the
years, so there is a movement to do finer grained locking.

This patch adds one more way for writers to the network interface lists
to serialize themselves. We assume that all writers to the network
interface lists are easily identifiable because the write side of
dev_base_lock also needs to be held (note that some instances of that
were deliberately skipped, since they only dealt with protecting the
operational state of the netdev).

Holding the RTNL mutex is now optional for new code that alters the
lists, since all relevant writers were made to also hold the new lock.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/net/net_namespace.h |  5 +++++
 net/core/dev.c              | 44 +++++++++++++++++++++++++------------
 2 files changed, 35 insertions(+), 14 deletions(-)

diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index 29567875f428..90826982843d 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -105,6 +105,11 @@ struct net {
 	struct hlist_head	*dev_index_head;
 	struct raw_notifier_head	netdev_chain;
 
+	/* Serializes writers to @dev_base_head, @dev_name_head
+	 * and @dev_index_head
+	 */
+	struct mutex		netdev_lists_lock;
+
 	/* Note that @hash_mix can be read millions times per second,
 	 * it is critical that it is on a read_mostly cache line.
 	 */
diff --git a/net/core/dev.c b/net/core/dev.c
index 701a326682e8..18904acb7797 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -175,13 +175,16 @@ static struct napi_struct *napi_by_id(unsigned int napi_id);
  *
  * Pure readers should hold rcu_read_lock() which should protect them against
  * concurrent changes to the interface lists made by the writers. Pure writers
- * must serialize by holding the RTNL mutex while they loop through the list
- * and make changes to it.
+ * must serialize by holding the @net->netdev_lists_lock mutex while they loop
+ * through the list and make changes to it.
+ *
+ * It is possible to hold the RTNL mutex for serializing the writers too, but
+ * this should be avoided in new code due to lock contention.
  *
  * It is also possible to hold the global rwlock_t @dev_base_lock for
  * protection (holding its read side as an alternative to rcu_read_lock, and
- * its write side as an alternative to the RTNL mutex), however this should not
- * be done in new code, since it is deprecated and pending removal.
+ * its write side as an alternative to @net->netdev_lists_lock), however this
+ * should not be done in new code, since it is deprecated and pending removal.
  *
  * One other role of @dev_base_lock is to protect against changes in the
  * operational state of a network interface.
@@ -360,12 +363,14 @@ static void list_netdevice(struct net_device *dev)
 
 	ASSERT_RTNL();
 
+	mutex_lock(&net->netdev_lists_lock);
 	write_lock_bh(&dev_base_lock);
 	list_add_tail_rcu(&dev->dev_list, &net->dev_base_head);
 	netdev_name_node_add(net, dev->name_node);
 	hlist_add_head_rcu(&dev->index_hlist,
 			   dev_index_hash(net, dev->ifindex));
 	write_unlock_bh(&dev_base_lock);
+	mutex_unlock(&net->netdev_lists_lock);
 
 	dev_base_seq_inc(net);
 }
@@ -375,16 +380,20 @@ static void list_netdevice(struct net_device *dev)
  */
 static void unlist_netdevice(struct net_device *dev)
 {
+	struct net *net = dev_net(dev);
+
 	ASSERT_RTNL();
 
 	/* Unlink dev from the device chain */
+	mutex_lock(&net->netdev_lists_lock);
 	write_lock_bh(&dev_base_lock);
 	list_del_rcu(&dev->dev_list);
 	netdev_name_node_del(dev->name_node);
 	hlist_del_rcu(&dev->index_hlist);
 	write_unlock_bh(&dev_base_lock);
+	mutex_unlock(&net->netdev_lists_lock);
 
-	dev_base_seq_inc(dev_net(dev));
+	dev_base_seq_inc(net);
 }
 
 /*
@@ -850,11 +859,11 @@ EXPORT_SYMBOL_GPL(dev_fill_metadata_dst);
  *	@net: the applicable net namespace
  *	@name: name to find
  *
- *	Find an interface by name. Must be called under RTNL semaphore
- *	or @dev_base_lock. If the name is found a pointer to the device
- *	is returned. If the name is not found then %NULL is returned. The
- *	reference counters are not incremented so the caller must be
- *	careful with locks.
+ *	Find an interface by name. Must be called under RTNL semaphore,
+ *	@net->netdev_lists_lock or @dev_base_lock. If the name is found,
+ *	a pointer to the device is returned. If the name is not found then
+ *	%NULL is returned. The reference counters are not incremented so the
+ *	caller must be careful with locks.
  */
 
 struct net_device *__dev_get_by_name(struct net *net, const char *name)
@@ -920,8 +929,8 @@ EXPORT_SYMBOL(dev_get_by_name);
  *	Search for an interface by index. Returns %NULL if the device
  *	is not found or a pointer to the device. The device has not
  *	had its reference counter increased so the caller must be careful
- *	about locking. The caller must hold either the RTNL semaphore
- *	or @dev_base_lock.
+ *	about locking. The caller must hold either the RTNL semaphore,
+ *	@net->netdev_lists_lock or @dev_base_lock.
  */
 
 struct net_device *__dev_get_by_index(struct net *net, int ifindex)
@@ -1330,15 +1339,19 @@ int dev_change_name(struct net_device *dev, const char *newname)
 
 	netdev_adjacent_rename_links(dev, oldname);
 
+	mutex_lock(&net->netdev_lists_lock);
 	write_lock_bh(&dev_base_lock);
 	netdev_name_node_del(dev->name_node);
 	write_unlock_bh(&dev_base_lock);
+	mutex_unlock(&net->netdev_lists_lock);
 
 	synchronize_rcu();
 
+	mutex_lock(&net->netdev_lists_lock);
 	write_lock_bh(&dev_base_lock);
 	netdev_name_node_add(net, dev->name_node);
 	write_unlock_bh(&dev_base_lock);
+	mutex_unlock(&net->netdev_lists_lock);
 
 	ret = call_netdevice_notifiers(NETDEV_CHANGENAME, dev);
 	ret = notifier_to_errno(ret);
@@ -9379,8 +9392,9 @@ int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
  *	@net: the applicable net namespace
  *
  *	Returns a suitable unique value for a new device interface
- *	number.  The caller must hold the rtnl semaphore or the
- *	dev_base_lock to be sure it remains unique.
+ *	number.
+ *	The caller must hold the rtnl semaphore, @net->netdev_lists_lock or the
+ *	@dev_base_lock to be sure it remains unique.
  */
 static int dev_new_index(struct net *net)
 {
@@ -10958,6 +10972,8 @@ static int __net_init netdev_init(struct net *net)
 	if (net->dev_index_head == NULL)
 		goto err_idx;
 
+	mutex_init(&net->netdev_lists_lock);
+
 	RAW_INIT_NOTIFIER_HEAD(&net->netdev_chain);
 
 	return 0;
-- 
2.25.1

