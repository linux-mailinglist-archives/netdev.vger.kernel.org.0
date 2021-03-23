Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09995345D8A
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 13:01:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230154AbhCWMA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 08:00:28 -0400
Received: from mail-dm6nam10on2072.outbound.protection.outlook.com ([40.107.93.72]:44992
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229866AbhCWMAU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Mar 2021 08:00:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OJ4Zi8sHGFyLtSA5pJ4bs891TixAlPlWLmMIC5WuCIUT9pvCIu67pODPFhm5K0ZevF1fwMHtUqUKxymxlAiznHCu2CC2PFvC2HjvNaj0tb+T277ZHgpP70YZbEOO0KLSb+KkDkteNOPvKonTAGuzIruRyQKaL6lHBXV6Fzq9EEzuJicSFA7Zpn7LykRc8LR7tyChPrNzPIO6swUbOZLkdMuFVx0gkpkrIgvbNIOug07nm4cJoDZxC9gfxenWRlafNnccuj9N1jKLCKCSrFYCGZR9+JWJz5DxV0IDQ6Mgp1PSUK6WV7yPwWDfSLBHprNQprqiPfBhKrg4ds/kJcC0WQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+tpJ7+qOIYXVZHXzyvfJ2PFw3q8kSsvWHvidtOhqXT0=;
 b=gnf1ndEpksJi7cjjb8mcW0yHmuh1Oo3KI06hAYly/rIdSSYAUP6pu6h0r7fWNE4pqUHpdwiwfsxjYxAAn6fj3wmCf3x7FQioWuhZrLXpqCN5ZGcpA9IDS8gxGR6panLmU6rRuuOS4S4Y8sQN//zfvo3kVF+/ilLtR6x+6JJ1gIB3H3BWLrfq03tf9IfcPV8XRP0f/7DLmShfdIsTQsPlCFBVh+WqypjSt/GGcVezxpFSeKp/vWkCYunw88OLOSQaKwIZd3tpZohrYPHYyTxC0DuPz0kKQErDb7yDS4L1ybRD/JkkJXUHBspdAx5LqpkyXvGLCAv2XokzPx8AsSW64g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+tpJ7+qOIYXVZHXzyvfJ2PFw3q8kSsvWHvidtOhqXT0=;
 b=ORNWxf/VCvrTBNkoxDYkuzkhI+Yj+95wztYwA87tfpiwrMiodtvfs2T6ja2XJ+0o+qaq/KIoHFzlCuVOOIqh53CmzArZLm7u22aWy5WzbeXE9F7iVBMY/+h9Wiz5cbgFdKm27ZlQmpKztdfHw6drhWrlwT8edUTRRvYUx3bRGyU9Ky8u7/hzkE/fBwK0vnbAO0V6RTSkXrlkwJyw6K//FNvKpr9SqNaEMlMBIUChY5xUB/zHlDVrlyC2zEn8Ss7Yh0SCLHNxvUC7YuQhRMD2zMVls/DL82Gr0+QUR+IurWbJqifcIViPmZZXP6YlAzPup404uI4gH0ie4lp2+pvYsg==
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4403.namprd12.prod.outlook.com (2603:10b6:5:2ab::24)
 by DM5PR1201MB0155.namprd12.prod.outlook.com (2603:10b6:4:55::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.24; Tue, 23 Mar
 2021 12:00:19 +0000
Received: from DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::5c42:cbe:fe28:3a9b]) by DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::5c42:cbe:fe28:3a9b%5]) with mapi id 15.20.3955.027; Tue, 23 Mar 2021
 12:00:19 +0000
Subject: Re: [PATCH v4 net-next 03/11] net: bridge: add helper to replay port
 and host-joined mdb entries
To:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roopa Prabhu <roopa@nvidia.com>, Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Ivan Vecera <ivecera@redhat.com>,
        linux-omap@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
References: <20210322235152.268695-1-olteanv@gmail.com>
 <20210322235152.268695-4-olteanv@gmail.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <e73b5c1e-2d8a-2f86-32e2-85e93f774d0c@nvidia.com>
Date:   Tue, 23 Mar 2021 14:00:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <20210322235152.268695-4-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZR0P278CA0130.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:40::9) To DM6PR12MB4403.namprd12.prod.outlook.com
 (2603:10b6:5:2ab::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.240.137] (213.179.129.39) by ZR0P278CA0130.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:40::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend Transport; Tue, 23 Mar 2021 12:00:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9050d82c-d536-4492-f274-08d8edf33a8f
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0155:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR1201MB0155182BA82F72A805561E95DF649@DM5PR1201MB0155.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nqjpis1RBwtfhJ2D7N9nmhx4gpOUYxThk8HV3mRdhaHvd/Npm+znpn0pTYoHf07riwPu0Mdzi3R6fM+hSZbLLQF+0bCGZHTeG6QX4SW5p2aIcPTHmVheIZ8yAzuHP1R0A3gwc1ZkhYeCYXfKnTRv3qHRImVzmjodcBBW57MQ9cVC8d7B51r50pSS9BXbYxdivBnDGQOSkY76yDxWod8Yl/ASgZtlJ5NKkC1khGhNZEH9kmUmSUanDAw2xNZ9XLgSyJQl4v/+E7AjkOvEGYXXH17QOlbwbJ5zvTFlcb2TtGK1iXHa0AWl98UKVPqlkk46pkwJX1IKN3wmgVDA9+MUgpjdCumOXh9bcE9C2SSvysRVPOefPtI0SmIlkJ1+/4VEKYu50rz5c3BF/a/ymzBNBm/x1dwIrPzfewiYUxB8xoD51JWtqxp0Bu1HkmCecwwKJLyea/yxqWOU62zSVvnaICZK7wq6ZAehJfNdK1eIRmpEqgn/L00Iwbxv8WXC1H9spdmT6rrSNh9gvV80Ys1VG7al5cSek4KNz3Nu31L07Y221bSh38hCrXyQXfDgzE2UiPM9R/G+XsFN0t3C/Rdfjnb+qJvKgxq84jS0Y5Mu09PtqfH7OHPPsl5r4KHeGQ2Nvmou2Jpafp9n0wzAxfClZG/ulIhwbmYyFKn/UihzAfOY//p9+xp2hwtMk4in+y05dyLrbUBw6iQiu53WsFTfV7AzrDWK7yM7rMzOGYm9ZK0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4403.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(136003)(346002)(376002)(366004)(478600001)(66556008)(86362001)(66476007)(26005)(38100700001)(2906002)(7416002)(16576012)(54906003)(110136005)(4326008)(186003)(36756003)(316002)(31696002)(16526019)(6486002)(83380400001)(8676002)(53546011)(956004)(6666004)(66574015)(8936002)(66946007)(2616005)(5660300002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Ak8x6D1XtHWBmevbc/qtBejHbjX3NYXeqWBaGeSqmZTzQ5VPYwrcPRxjswlrE/K/bxvRwvLRATpLAHS5kr7CJ6ULmqTTn0mzqhEu0DRjfL/Mt+RSBcTtZ43obT0x/9OZNiB5C0tG20C1lmmFjcdVK5VpF1yTIlyaG738lZ1tMJh6udUSRGh3rSDK6+JnOghepwuo1mZKlwhF2VsXFv1e9i1bY9ZtVqYl0ilhCvnRLSPLIh5jwvJBM6NB/WdImzMLl/o7Wn7wXreiDtSJgygyk04scVyF3z6D/wK7dbBI9UeN2CSspo3XKkTY1UchTCmcFYb3s+jSem0Pa1I7guN2c352d2Y7EJaHqfvp5Ytq66caNA7UYNio0tTe1yCZMMBTRXIGZuVfvGgHffzHB0GuK1/tCOAGJfnyVWuFeJGB2BdveC05lT5ple035LBaVDnyPGuzkUfT5n+D72ps27EODupswk212481RVYUFJL9urPqNk09St3LYSYuH8qti6yIAMxUbyHsc/3jP13n9GEU2xsJ5XkgRAV9WKOBsYHUf2CFGVSTAUbYeFtngFXaHBL9GCcWdVI4Poc8WsHQ3il6eU5BDbrRob3m79ghW3v0ITVRaLcmYxgTXsWfGFyq7le+HfxE0o2AW9vMb1BuIm0JIYfivjO4pXEdJtN7sGt7P0b3tlYrnmhJg4iIRJlsgrEVSQzsserA9nQMCx0Vp3IvrzzqvAUlm9H/Og7FGOyc7POnEx+8EeJVJH13GNueJHxY
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9050d82c-d536-4492-f274-08d8edf33a8f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4403.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2021 12:00:19.0364
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hzj6Vca1/1qZAXMvli6yvO+31FWfcAss7xED82XpKHTsBByF32UEHyjSphAN59iWnH9xVA8BMRj4Kv2JJfNvnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0155
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23/03/2021 01:51, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> I have a system with DSA ports, and udhcpcd is configured to bring
> interfaces up as soon as they are created.
> 
> I create a bridge as follows:
> 
> ip link add br0 type bridge
> 
> As soon as I create the bridge and udhcpcd brings it up, I also have
> avahi which automatically starts sending IPv6 packets to advertise some
> local services, and because of that, the br0 bridge joins the following
> IPv6 groups due to the code path detailed below:
> 
> 33:33:ff:6d:c1:9c vid 0
> 33:33:00:00:00:6a vid 0
> 33:33:00:00:00:fb vid 0
> 
> br_dev_xmit
> -> br_multicast_rcv
>    -> br_ip6_multicast_add_group
>       -> __br_multicast_add_group
>          -> br_multicast_host_join
>             -> br_mdb_notify
> 
> This is all fine, but inside br_mdb_notify we have br_mdb_switchdev_host
> hooked up, and switchdev will attempt to offload the host joined groups
> to an empty list of ports. Of course nobody offloads them.
> 
> Then when we add a port to br0:
> 
> ip link set swp0 master br0
> 
> the bridge doesn't replay the host-joined MDB entries from br_add_if,
> and eventually the host joined addresses expire, and a switchdev
> notification for deleting it is emitted, but surprise, the original
> addition was already completely missed.
> 
> The strategy to address this problem is to replay the MDB entries (both
> the port ones and the host joined ones) when the new port joins the
> bridge, similar to what vxlan_fdb_replay does (in that case, its FDB can
> be populated and only then attached to a bridge that you offload).
> However there are 2 possibilities: the addresses can be 'pushed' by the
> bridge into the port, or the port can 'pull' them from the bridge.
> 
> Considering that in the general case, the new port can be really late to
> the party, and there may have been many other switchdev ports that
> already received the initial notification, we would like to avoid
> delivering duplicate events to them, since they might misbehave. And
> currently, the bridge calls the entire switchdev notifier chain, whereas
> for replaying it should just call the notifier block of the new guy.
> But the bridge doesn't know what is the new guy's notifier block, it
> just knows where the switchdev notifier chain is. So for simplification,
> we make this a driver-initiated pull for now, and the notifier block is
> passed as an argument.
> 
> To emulate the calling context for mdb objects (deferred and put on the
> blocking notifier chain), we must iterate under RCU protection through
> the bridge's mdb entries, queue them, and only call them once we're out
> of the RCU read-side critical section.
> 
> There was some opportunity for reuse between br_mdb_switchdev_host_port,
> br_mdb_notify and the newly added br_mdb_queue_one in how the switchdev
> mdb object is created, so a helper was created.
> 
> Suggested-by: Ido Schimmel <idosch@idosch.org>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  include/linux/if_bridge.h |   9 +++
>  include/net/switchdev.h   |   1 +
>  net/bridge/br_mdb.c       | 148 +++++++++++++++++++++++++++++++++-----
>  3 files changed, 141 insertions(+), 17 deletions(-)
> 

Absolutely the same comments here as for the fdb version.
The code looks correct.

Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>

> diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
> index ebd16495459c..f6472969bb44 100644
> --- a/include/linux/if_bridge.h
> +++ b/include/linux/if_bridge.h
> @@ -69,6 +69,8 @@ bool br_multicast_has_querier_anywhere(struct net_device *dev, int proto);
>  bool br_multicast_has_querier_adjacent(struct net_device *dev, int proto);
>  bool br_multicast_enabled(const struct net_device *dev);
>  bool br_multicast_router(const struct net_device *dev);
> +int br_mdb_replay(struct net_device *br_dev, struct net_device *dev,
> +		  struct notifier_block *nb, struct netlink_ext_ack *extack);
>  #else
>  static inline int br_multicast_list_adjacent(struct net_device *dev,
>  					     struct list_head *br_ip_list)
> @@ -93,6 +95,13 @@ static inline bool br_multicast_router(const struct net_device *dev)
>  {
>  	return false;
>  }
> +static inline int br_mdb_replay(struct net_device *br_dev,
> +				struct net_device *dev,
> +				struct notifier_block *nb,
> +				struct netlink_ext_ack *extack)
> +{
> +	return -EOPNOTSUPP;
> +}
>  #endif
>  
>  #if IS_ENABLED(CONFIG_BRIDGE) && IS_ENABLED(CONFIG_BRIDGE_VLAN_FILTERING)
> diff --git a/include/net/switchdev.h b/include/net/switchdev.h
> index b7fc7d0f54e2..8c3218177136 100644
> --- a/include/net/switchdev.h
> +++ b/include/net/switchdev.h
> @@ -68,6 +68,7 @@ enum switchdev_obj_id {
>  };
>  
>  struct switchdev_obj {
> +	struct list_head list;
>  	struct net_device *orig_dev;
>  	enum switchdev_obj_id id;
>  	u32 flags;
> diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
> index 8846c5bcd075..95fa4af0e8dd 100644
> --- a/net/bridge/br_mdb.c
> +++ b/net/bridge/br_mdb.c
> @@ -506,6 +506,134 @@ static void br_mdb_complete(struct net_device *dev, int err, void *priv)
>  	kfree(priv);
>  }
>  
> +static void br_switchdev_mdb_populate(struct switchdev_obj_port_mdb *mdb,
> +				      const struct net_bridge_mdb_entry *mp)
> +{
> +	if (mp->addr.proto == htons(ETH_P_IP))
> +		ip_eth_mc_map(mp->addr.dst.ip4, mdb->addr);
> +#if IS_ENABLED(CONFIG_IPV6)
> +	else if (mp->addr.proto == htons(ETH_P_IPV6))
> +		ipv6_eth_mc_map(&mp->addr.dst.ip6, mdb->addr);
> +#endif
> +	else
> +		ether_addr_copy(mdb->addr, mp->addr.dst.mac_addr);
> +
> +	mdb->vid = mp->addr.vid;
> +}
> +
> +static int br_mdb_replay_one(struct notifier_block *nb, struct net_device *dev,
> +			     struct switchdev_obj_port_mdb *mdb,
> +			     struct netlink_ext_ack *extack)
> +{
> +	struct switchdev_notifier_port_obj_info obj_info = {
> +		.info = {
> +			.dev = dev,
> +			.extack = extack,
> +		},
> +		.obj = &mdb->obj,
> +	};
> +	int err;
> +
> +	err = nb->notifier_call(nb, SWITCHDEV_PORT_OBJ_ADD, &obj_info);
> +	return notifier_to_errno(err);
> +}
> +
> +static int br_mdb_queue_one(struct list_head *mdb_list,
> +			    enum switchdev_obj_id id,
> +			    const struct net_bridge_mdb_entry *mp,
> +			    struct net_device *orig_dev)
> +{
> +	struct switchdev_obj_port_mdb *mdb;
> +
> +	mdb = kzalloc(sizeof(*mdb), GFP_ATOMIC);
> +	if (!mdb)
> +		return -ENOMEM;
> +
> +	mdb->obj.id = id;
> +	mdb->obj.orig_dev = orig_dev;
> +	br_switchdev_mdb_populate(mdb, mp);
> +	list_add_tail(&mdb->obj.list, mdb_list);
> +
> +	return 0;
> +}
> +
> +int br_mdb_replay(struct net_device *br_dev, struct net_device *dev,
> +		  struct notifier_block *nb, struct netlink_ext_ack *extack)
> +{
> +	struct net_bridge_mdb_entry *mp;
> +	struct switchdev_obj *obj, *tmp;
> +	struct net_bridge *br;
> +	LIST_HEAD(mdb_list);
> +	int err = 0;
> +
> +	ASSERT_RTNL();
> +
> +	if (!netif_is_bridge_master(br_dev) || !netif_is_bridge_port(dev))
> +		return -EINVAL;
> +
> +	br = netdev_priv(br_dev);
> +
> +	if (!br_opt_get(br, BROPT_MULTICAST_ENABLED))
> +		return 0;
> +
> +	/* We cannot walk over br->mdb_list protected just by the rtnl_mutex,
> +	 * because the write-side protection is br->multicast_lock. But we
> +	 * need to emulate the [ blocking ] calling context of a regular
> +	 * switchdev event, so since both br->multicast_lock and RCU read side
> +	 * critical sections are atomic, we have no choice but to pick the RCU
> +	 * read side lock, queue up all our events, leave the critical section
> +	 * and notify switchdev from blocking context.
> +	 */
> +	rcu_read_lock();
> +
> +	hlist_for_each_entry_rcu(mp, &br->mdb_list, mdb_node) {
> +		struct net_bridge_port_group __rcu **pp;
> +		struct net_bridge_port_group *p;
> +
> +		if (mp->host_joined) {
> +			err = br_mdb_queue_one(&mdb_list,
> +					       SWITCHDEV_OBJ_ID_HOST_MDB,
> +					       mp, br_dev);
> +			if (err) {
> +				rcu_read_unlock();
> +				goto out_free_mdb;
> +			}
> +		}
> +
> +		for (pp = &mp->ports; (p = rcu_dereference(*pp)) != NULL;
> +		     pp = &p->next) {
> +			if (p->key.port->dev != dev)
> +				continue;
> +
> +			err = br_mdb_queue_one(&mdb_list,
> +					       SWITCHDEV_OBJ_ID_PORT_MDB,
> +					       mp, dev);
> +			if (err) {
> +				rcu_read_unlock();
> +				goto out_free_mdb;
> +			}
> +		}
> +	}
> +
> +	rcu_read_unlock();
> +
> +	list_for_each_entry(obj, &mdb_list, list) {
> +		err = br_mdb_replay_one(nb, dev, SWITCHDEV_OBJ_PORT_MDB(obj),
> +					extack);
> +		if (err)
> +			goto out_free_mdb;
> +	}
> +
> +out_free_mdb:
> +	list_for_each_entry_safe(obj, tmp, &mdb_list, list) {
> +		list_del(&obj->list);
> +		kfree(SWITCHDEV_OBJ_PORT_MDB(obj));
> +	}
> +
> +	return err;
> +}
> +EXPORT_SYMBOL_GPL(br_mdb_replay);
> +
>  static void br_mdb_switchdev_host_port(struct net_device *dev,
>  				       struct net_device *lower_dev,
>  				       struct net_bridge_mdb_entry *mp,
> @@ -515,18 +643,12 @@ static void br_mdb_switchdev_host_port(struct net_device *dev,
>  		.obj = {
>  			.id = SWITCHDEV_OBJ_ID_HOST_MDB,
>  			.flags = SWITCHDEV_F_DEFER,
> +			.orig_dev = dev,
>  		},
> -		.vid = mp->addr.vid,
>  	};
>  
> -	if (mp->addr.proto == htons(ETH_P_IP))
> -		ip_eth_mc_map(mp->addr.dst.ip4, mdb.addr);
> -#if IS_ENABLED(CONFIG_IPV6)
> -	else
> -		ipv6_eth_mc_map(&mp->addr.dst.ip6, mdb.addr);
> -#endif
> +	br_switchdev_mdb_populate(&mdb, mp);
>  
> -	mdb.obj.orig_dev = dev;
>  	switch (type) {
>  	case RTM_NEWMDB:
>  		switchdev_port_obj_add(lower_dev, &mdb.obj, NULL);
> @@ -558,21 +680,13 @@ void br_mdb_notify(struct net_device *dev,
>  			.id = SWITCHDEV_OBJ_ID_PORT_MDB,
>  			.flags = SWITCHDEV_F_DEFER,
>  		},
> -		.vid = mp->addr.vid,
>  	};
>  	struct net *net = dev_net(dev);
>  	struct sk_buff *skb;
>  	int err = -ENOBUFS;
>  
>  	if (pg) {
> -		if (mp->addr.proto == htons(ETH_P_IP))
> -			ip_eth_mc_map(mp->addr.dst.ip4, mdb.addr);
> -#if IS_ENABLED(CONFIG_IPV6)
> -		else if (mp->addr.proto == htons(ETH_P_IPV6))
> -			ipv6_eth_mc_map(&mp->addr.dst.ip6, mdb.addr);
> -#endif
> -		else
> -			ether_addr_copy(mdb.addr, mp->addr.dst.mac_addr);
> +		br_switchdev_mdb_populate(&mdb, mp);
>  
>  		mdb.obj.orig_dev = pg->key.port->dev;
>  		switch (type) {
> 
n
