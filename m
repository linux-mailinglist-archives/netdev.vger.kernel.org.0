Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C784B344B8F
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 17:36:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231797AbhCVQfy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 12:35:54 -0400
Received: from mail-bn8nam11on2068.outbound.protection.outlook.com ([40.107.236.68]:10093
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231391AbhCVQfX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 12:35:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B1seSI23K6WsIpeziXv5+0C+ECKGkTthCl/Ee39aRyuf9KZ1AbkqUQj7Sv+gI9BjpNg+dho1mcjOR7Kyla+h5mnMgzW9IyMdnypRxPhFZBR6xjsXCVIe/zhzJ9AMXA4OaQWLzhvou5mvphrG3yao3ttkYFOL+t7JIlqq5688U9TO0+XRZakjq+v2p+Zn2SDEax3pUJRnGe4SiBEvfEMnTJTO4gUNyrCqdrUy4oIMnqI/hA6kn1ty2brA6lXGai61zlq/m+xZ9vdWDL2HFUUoTeliQW9+0//M40Ua2DjsaBC0PXeOdk6ZigETHC/hWKKiJLR2v8Vjp/bccZO/Fe3Agg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5DVctRpr/czxfLk0mwsTM+6OcsEORE3Ancu4H3PZu3g=;
 b=cLsutasmf6n7zg6jxXyoMevdSyqMS8LQzwDhbyNkN/94e1ZHYlFbWtwAiZkeOIy7NPmHH6KnVZQitrRl7bSw/sAds5MHG9SIs5LaZ31g+P+i8qRKgZJXXQh5w13M9/4isN5HlarnlL/vR5pES1aDIwBXRMBpquJW2tZDr13Oo+6H5QQzdQhzeqyScgsaXLItbEp8WYg9OGqtmyRkamn6dEEABoYCo3vdTeeJOl8dg1k7MmLpTM3hx7bde499lmG5PyLijDbnyTCe0oDsMgEjaQeRRLxvS7k+T7dYKgQvb4yCdCRY26kSCJJVCuTOIB/BIzjGlIdT432QpYH/+0f+yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5DVctRpr/czxfLk0mwsTM+6OcsEORE3Ancu4H3PZu3g=;
 b=ry9HaiPn6BkF+tTAJUzx3LB1Zt11vLzsA8xpedImo9Dwzrwvp4h6GrfcQwSl9ekYTJG/071dZZS3E3WmrsRoX9hv0xU4tKSx2rdmGK/0rqW5uimgHV2imhhf2XSbhMymeiSiS7V8ilFoo4vKs6KXZNF4VlWYKxdHQO+4Mhro3JA4xwxmPsX6fLCtTSEm4xP4wrQjrsuHXGgAfHsw8iG17Gn9Fpm/+6QI45gJDjxyukEDGXy7JXltwovWN7CviO3HbGIM+DdyYM3bqJjr7UBURMHuAeioNPdN0EW0gOMBqsAWO/JjhaF28gInZRuq9dS7yBQM4tdGjDcPFcTTJ7fi6w==
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4403.namprd12.prod.outlook.com (2603:10b6:5:2ab::24)
 by DM6PR12MB4531.namprd12.prod.outlook.com (2603:10b6:5:2a4::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Mon, 22 Mar
 2021 16:35:21 +0000
Received: from DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::5c42:cbe:fe28:3a9b]) by DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::5c42:cbe:fe28:3a9b%5]) with mapi id 15.20.3955.027; Mon, 22 Mar 2021
 16:35:21 +0000
Subject: Re: [PATCH v3 net-next 08/12] net: dsa: replay port and host-joined
 mdb entries when joining the bridge
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
References: <20210320223448.2452869-1-olteanv@gmail.com>
 <20210320223448.2452869-9-olteanv@gmail.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <7a89fd44-98d7-072f-6215-84960e27b0d9@nvidia.com>
Date:   Mon, 22 Mar 2021 18:35:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <20210320223448.2452869-9-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZR0P278CA0062.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:21::13) To DM6PR12MB4403.namprd12.prod.outlook.com
 (2603:10b6:5:2ab::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.240.38] (213.179.129.39) by ZR0P278CA0062.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:21::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend Transport; Mon, 22 Mar 2021 16:35:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 25d3c1a5-893d-45ec-0436-08d8ed507c4a
X-MS-TrafficTypeDiagnostic: DM6PR12MB4531:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4531EAD6861374628AB800A6DF659@DM6PR12MB4531.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hEDJHWdMqkX0mjmsfknSP31KJujPpSweo2ERiu3ncrCccU5RBSot4YgUMlkIPFkEwWIy8xoLYSvO4HVfRlJKvPe4d69MiHzst1N6BHDOQIdxu/xeqQWbiLiZprwTXSZjDz807F/PDQysc62s+xY0/iC74kFmAZ6mpwz2iNGNxk8Pdxwy8i3v1IE0y5fuHifiEgfJiSld3FfSXm4ILVgC9koKXGo1hAPrRNzhoUFNo8ier3aEs3RRo9wWOlgtfPYJQR3Smhrt6PY+RysqERmm2VtkqWebGiKtyaHJs0Hd+fe6y1bnxXDv7tzUdBhSebSPjwOW4pVEAF/d1Uj6+eHOcwbwKu74g312UGIEkuuxF8CcV1Ta8uLNEt4ZdnbhJuMkHa834Z5U1p7lijP2OHxvjTAswx5X4uL57GsLZc3fljE3DbLWYdv+GWIgpcEfAtcAItKcjnbpH0LOqyVG7MKXc0sNOsfExIfxvsVu7Em6e7gbEZoDihg/YrCbFjXzeOOV70YSUIEwfe86gXV2JYfXZ1pUjDUNce6dtIoGjsS+OJxBhW998ZUlriIUBuTnSD4XksOaWjpWsBpfJdggXufNRQx3NYokVePo3VVpJeZViiusqM0n++IEufsiTjOrerNL1S6/D1ecBbvJX++hJz2hWODUINDA258sFo+AYOPuf0KpG41uWRoQ9gJHFOliGExjF0AeFE1H83fW+iHI+N7CBZviUxny5OVrIKPrPxkiHrk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4403.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(136003)(396003)(376002)(39860400002)(83380400001)(2906002)(5660300002)(316002)(186003)(26005)(66574015)(16526019)(54906003)(53546011)(16576012)(36756003)(110136005)(6486002)(8936002)(7416002)(38100700001)(956004)(31696002)(6666004)(31686004)(8676002)(4326008)(66556008)(86362001)(66946007)(2616005)(478600001)(66476007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?bU5nbUp4VVd3M3pBd2Z5eEhoOGMwMVU0SlExUXpiTjdveTVNelZFU2FVbVNL?=
 =?utf-8?B?QS94Rm1MdnpnR2lObW5LRGJrd1pIOHdnM3JRSnd3cklWVU5hcDhTQkVJNU9l?=
 =?utf-8?B?NGRMWmFLdnhScTV4S1J6U01zTy9XM01mRnE3Z2dzNU5wR2o0WHBVSzJYM050?=
 =?utf-8?B?eUdBRDY3MDRaT0lEMVRRZWxyc0dMOVNBcmt6TmpBVi9NdlIwcVVOOU50VEo3?=
 =?utf-8?B?T1NzYkJWWEtIK25PMzhiQnlHeDI3ejUrMzBpYjRuQ0NEcFhoc3Z5RHlWT2Rr?=
 =?utf-8?B?RDdlNG9PT3lzaVh1bjRVU0JMZ2ZybDROVW9yRUI0SFJoK1hHakw3S2E5Z0tF?=
 =?utf-8?B?dm13WkVxWEdCNCtLMmxmUWRtNUdXUUx4V0FXdkJCSXV4NDk2MWUydTUwRGpH?=
 =?utf-8?B?NnJZNjVmYjlPcStyeEpxQ3R1K1JqakxVYWdPME9DcHFYOWpHRGo1MW5OUEkx?=
 =?utf-8?B?dUltTHJlS1BaWDlWUnVUc1kvVHNYZU5DdWtxM2piTnRQWVhXdCtybitGM1BW?=
 =?utf-8?B?WUpwb1BFQy9xMytkeE1jMGpOL1lZYWpxVVhXUk9Zc0lzdmZyTXo1QktQYkFn?=
 =?utf-8?B?Q05vTWUxVDVKNWVtNXNVNHhTRUdYVWVhdVdTdmdvTUl4V3F5cS90S1AwcjRM?=
 =?utf-8?B?OEVPOCs0Z2FMMDk5bDFtNzNUb21pTno5SjZ5R05Rd0JBdVNJM0Zrb2ROWmtF?=
 =?utf-8?B?QWJMV3VOZVY3U3dhSTFyRjJ2cVd1Uk12bXJWMHJvMmlVd3Z0M0R5N3k3YzNu?=
 =?utf-8?B?UC9va2diYWQzRnVpZnc1bXpFbzRoaEhqL1IzN1JzSXpyMkoxRTJ3M1A2K1lC?=
 =?utf-8?B?cjRlbG5uUW1ldEUzVlV1UzJSRVFVUHJRTHEvaDI2OWtYOW1mM1dTcTZhSmI2?=
 =?utf-8?B?ai9XVFdjODRJcFlZM0pkQ3krZGY0WVlGR2svUWpMZ2dHUnRnazNzc2cwWWl1?=
 =?utf-8?B?RGdabitYZWcvTWEvRVh3Z0U1a1pLbEpFRGlzNXBJOE1Ua1dHY0FaZitqazU0?=
 =?utf-8?B?aEs5T2w0YTM0V0xsR2xwQVZqWXh1RjBsUzlpcmpDeUNnQ1NYcUd3QmFHOVc4?=
 =?utf-8?B?TUxKK29ZWFRMLzRUUVNrWHVuaVdwYjJpQ2cvd1J0NFF2MmNiYndhaHEyVStL?=
 =?utf-8?B?RmxMdEdRU0hIcklnL2NPZDRvSndMT1M0R0RSUnNLSUF2alpHUzVyRnhIcXNn?=
 =?utf-8?B?Z3ExVjlCNzNUQXF1R2xMcUtDNDJnOS9sTGVhdHRWdFdISUlmSnVQNDd1TE5w?=
 =?utf-8?B?R1pWRmx2eDZHWnZ0T3lBRmRqTmJuM2lFVHpzMDh2N3pyTnZqbVhJb2oxcDRr?=
 =?utf-8?B?S1dqMFc0b0NXSmRJUDN2QWdXcUVpcTJtT1JoMC9UK292dGtZeXRxVUloYWVK?=
 =?utf-8?B?YkdTbWhtYWgyT1ZwVW8xaGIvWXhlOXdPcUlpaTJFem9CNTNmV3lYcGp6d2Fn?=
 =?utf-8?B?L2NQT3lLUUhOdFBBYjFhVmZsVlR0QzhDY3lXZkFrbHMwSFFSMmtSM1FVRUZY?=
 =?utf-8?B?ZUYxSTNpRS9pYlQrQTFhVFY4N0dHc2RJcTFsZVBOWkZSeHRiMlRsV0Y1bkJM?=
 =?utf-8?B?UHZMUGhIbnRHeTBzeERnWndvcEExN0JtRWxZV05HLzB3VDhNUE9RNCtRdGps?=
 =?utf-8?B?cTg2T21YU2E1SVRhMHhOcWFmVG9xMU4zeENDWXZETjVzNWpEdy9QSnpIMzZU?=
 =?utf-8?B?Vm8wRE9FNkJKYTE3QTFYaFpObHZ3WjRLcW5vbEFFQmI1R3ZyWVNaZ3J6aVgv?=
 =?utf-8?Q?avOsL9IPTYWQCyCMZ1B7cnRPFHuGK/3d5LN2Wye?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25d3c1a5-893d-45ec-0436-08d8ed507c4a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4403.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2021 16:35:21.2512
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2O4bouWr3gFT4urtZM0thuaeNputASdD5O1RsKMA9yxHCdRiv3JYjQZL5d3aJNdUZvCoFOuvrrm5/JOEyMESxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4531
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21/03/2021 00:34, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> I have udhcpcd in my system and this is configured to bring interfaces
> up as soon as they are created.
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
> Suggested-by: Ido Schimmel <idosch@idosch.org>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
> Changes in v3:
> - Removed the implication that avahi is crap from the commit message.
> - Made the br_mdb_replay shim return -EOPNOTSUPP.
> 
>  include/linux/if_bridge.h |  9 +++++
>  net/bridge/br_mdb.c       | 84 +++++++++++++++++++++++++++++++++++++++
>  net/dsa/dsa_priv.h        |  2 +
>  net/dsa/port.c            |  6 +++
>  net/dsa/slave.c           |  2 +-
>  5 files changed, 102 insertions(+), 1 deletion(-)
> 
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
> diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
> index 8846c5bcd075..23973186094c 100644
> --- a/net/bridge/br_mdb.c
> +++ b/net/bridge/br_mdb.c
> @@ -506,6 +506,90 @@ static void br_mdb_complete(struct net_device *dev, int err, void *priv)
>  	kfree(priv);
>  }
>  
> +static int br_mdb_replay_one(struct notifier_block *nb, struct net_device *dev,
> +			     struct net_bridge_mdb_entry *mp, int obj_id,
> +			     struct net_device *orig_dev,
> +			     struct netlink_ext_ack *extack)
> +{
> +	struct switchdev_notifier_port_obj_info obj_info = {
> +		.info = {
> +			.dev = dev,
> +			.extack = extack,
> +		},
> +	};
> +	struct switchdev_obj_port_mdb mdb = {
> +		.obj = {
> +			.orig_dev = orig_dev,
> +			.id = obj_id,
> +		},
> +		.vid = mp->addr.vid,
> +	};
> +	int err;
> +
> +	if (mp->addr.proto == htons(ETH_P_IP))
> +		ip_eth_mc_map(mp->addr.dst.ip4, mdb.addr);
> +#if IS_ENABLED(CONFIG_IPV6)
> +	else if (mp->addr.proto == htons(ETH_P_IPV6))
> +		ipv6_eth_mc_map(&mp->addr.dst.ip6, mdb.addr);
> +#endif
> +	else
> +		ether_addr_copy(mdb.addr, mp->addr.dst.mac_addr);
> +
> +	obj_info.obj = &mdb.obj;
> +
> +	err = nb->notifier_call(nb, SWITCHDEV_PORT_OBJ_ADD, &obj_info);
> +	return notifier_to_errno(err);
> +}
> +
> +int br_mdb_replay(struct net_device *br_dev, struct net_device *dev,
> +		  struct notifier_block *nb, struct netlink_ext_ack *extack)
> +{
> +	struct net_bridge_mdb_entry *mp;
> +	struct list_head mdb_list;

If you use LIST_HEAD(mdb_list)...

> +	struct net_bridge *br;
> +	int err = 0;
> +
> +	ASSERT_RTNL();
> +
> +	INIT_LIST_HEAD(&mdb_list);

... you can drop this one.

> +
> +	if (!netif_is_bridge_master(br_dev) || !netif_is_bridge_port(dev))
> +		return -EINVAL;
> +
> +	br = netdev_priv(br_dev);
> +
> +	if (!br_opt_get(br, BROPT_MULTICAST_ENABLED))
> +		return 0;
> +
> +	hlist_for_each_entry(mp, &br->mdb_list, mdb_node) {

You cannot walk over these lists without the multicast lock or RCU. RTNL is not
enough because of various timers and leave messages that can alter both the mdb_list
and the port group lists. I'd prefer RCU to avoid blocking the bridge mcast.

> +		struct net_bridge_port_group __rcu **pp;
> +		struct net_bridge_port_group *p;
> +
> +		if (mp->host_joined) {
> +			err = br_mdb_replay_one(nb, dev, mp,
> +						SWITCHDEV_OBJ_ID_HOST_MDB,
> +						br_dev, extack);
> +			if (err)
> +				return err;
> +		}
> +
> +		for (pp = &mp->ports; (p = rtnl_dereference(*pp)) != NULL;
> +		     pp = &p->next) {
> +			if (p->key.port->dev != dev)
> +				continue;
> +
> +			err = br_mdb_replay_one(nb, dev, mp,
> +						SWITCHDEV_OBJ_ID_PORT_MDB,
> +						dev, extack);
> +			if (err)
> +				return err;> +		}
> +	}
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(br_mdb_replay);

EXPORT_SYMBOL_GPL

> +
>  static void br_mdb_switchdev_host_port(struct net_device *dev,
>  				       struct net_device *lower_dev,
>  				       struct net_bridge_mdb_entry *mp,
> diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
> index b8778c5d8529..b14c43cb88bb 100644
> --- a/net/dsa/dsa_priv.h
> +++ b/net/dsa/dsa_priv.h
> @@ -262,6 +262,8 @@ static inline bool dsa_tree_offloads_bridge_port(struct dsa_switch_tree *dst,
>  
>  /* slave.c */
>  extern const struct dsa_device_ops notag_netdev_ops;
> +extern struct notifier_block dsa_slave_switchdev_blocking_notifier;
> +
>  void dsa_slave_mii_bus_init(struct dsa_switch *ds);
>  int dsa_slave_create(struct dsa_port *dp);
>  void dsa_slave_destroy(struct net_device *slave_dev);
> diff --git a/net/dsa/port.c b/net/dsa/port.c
> index 95e6f2861290..3e61e9e6675c 100644
> --- a/net/dsa/port.c
> +++ b/net/dsa/port.c
> @@ -199,6 +199,12 @@ static int dsa_port_switchdev_sync(struct dsa_port *dp,
>  	if (err && err != -EOPNOTSUPP)
>  		return err;
>  
> +	err = br_mdb_replay(br, brport_dev,
> +			    &dsa_slave_switchdev_blocking_notifier,
> +			    extack);
> +	if (err && err != -EOPNOTSUPP)
> +		return err;
> +
>  	return 0;
>  }
>  
> diff --git a/net/dsa/slave.c b/net/dsa/slave.c
> index 1ff48be476bb..b974d8f84a2e 100644
> --- a/net/dsa/slave.c
> +++ b/net/dsa/slave.c
> @@ -2396,7 +2396,7 @@ static struct notifier_block dsa_slave_switchdev_notifier = {
>  	.notifier_call = dsa_slave_switchdev_event,
>  };
>  
> -static struct notifier_block dsa_slave_switchdev_blocking_notifier = {
> +struct notifier_block dsa_slave_switchdev_blocking_notifier = {
>  	.notifier_call = dsa_slave_switchdev_blocking_event,
>  };
>  
> 

