Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40CB0344BE0
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 17:40:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231985AbhCVQkJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 12:40:09 -0400
Received: from mail-mw2nam10on2088.outbound.protection.outlook.com ([40.107.94.88]:48608
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231486AbhCVQjq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 12:39:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YbjhzITNZcwFYh/dDMc4bHY9164AXzp8e0Ym07o78BbVHiF4irkpCOWmaGABpLoUGvUX9qE7VukJ3JQ7EIqfQ6PhjsDhwbGNesDJTP/OSzaFKd90Eisbfr7fimiAY1vtYF5cqIL52Fe6lpNAuJZx33WDoPSmXZsXzRXScvMmGbPP6HLjbcGiiYTYEgVushM4pixk4XXFeaZiIjoQy2HR6QGqW4Qm7VIG7UVNQcRt+i7+Viv5dfzVITDYNRTthZ8yjJbdozDrugmdDPDeBVuZcqFSYf87JsziRDlgf6Y8exhdh8U42K0v1ymJxVf3LNOS2Rk8clO1VskescE29GB4OQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HAm4IIAz8UMMCprBQ/TcJpzS66NYWB+GoPeUiJpx/2Q=;
 b=Q+z8Ej1hhBa7qB5Q+vAH05DlCMTKHrA1pkXSKa0UD8g75myTERs70wSQkywzJ/vXD/BIb6aEaShHf4F88nLVtRTEgTEu2ZSuHWyC0beIJ3YMu6dm552QldS7KFACabAfqZepWrtF32iGNPvDTjgXFy7HGip1UJPzl88aNaYFRiGCbo1d2jY4r4hNfgqXWrKyihx9uuHhvKBc0+qyMDtv51C7rlBJhc04K4xNyx8GOmj5MgENCw1cldfQUB41dSsuCyVj8hA3gkUPHWuQzSSkNiWscR+iF8H9CGt0loK4cs4kzLXVRHp2PP9ncosFt3DyuIHSVzPVwRL0Fy9b2zCW4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HAm4IIAz8UMMCprBQ/TcJpzS66NYWB+GoPeUiJpx/2Q=;
 b=fMFYEmr2MMiJrwKhs2oRLeO44VBqzbcsSURCUyNjfDQWYZUNgnXXpvE9fJSRF/nzvcmLJKBwzXLD5uRYAlLsEUv7HwRxEPyoI5mNDlIn618TtLnZSW7em38E4uJoQ/C/PyV1C8pH3DV/gcUNArp9T81jKRj8X8nf1AdTcIINEITVY8+tKmhm6gmebNbvQmtX+dhsyhlUJ95IkL0aL5MZYNZvVFbW2TTAdl9fhqLFUH8o56NiUMvABCsE1OIGCvgxPXsHS3HbpnYwIjGBmv0ECc7OEZ8a1JubS7S+R5YIV7NYVp6n8Bw0BVyrGsV1EG+vb1QgGew0lz+LM1T2wG0acw==
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4403.namprd12.prod.outlook.com (2603:10b6:5:2ab::24)
 by DM6PR12MB4106.namprd12.prod.outlook.com (2603:10b6:5:221::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Mon, 22 Mar
 2021 16:39:43 +0000
Received: from DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::5c42:cbe:fe28:3a9b]) by DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::5c42:cbe:fe28:3a9b%5]) with mapi id 15.20.3955.027; Mon, 22 Mar 2021
 16:39:43 +0000
Subject: Re: [PATCH v3 net-next 09/12] net: dsa: replay port and local fdb
 entries when joining the bridge
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
 <20210320223448.2452869-10-olteanv@gmail.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <91fa3435-8a25-ebda-32ca-6de9bc2546a8@nvidia.com>
Date:   Mon, 22 Mar 2021 18:39:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <20210320223448.2452869-10-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZR0P278CA0090.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:22::23) To DM6PR12MB4403.namprd12.prod.outlook.com
 (2603:10b6:5:2ab::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.240.38] (213.179.129.39) by ZR0P278CA0090.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:22::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend Transport; Mon, 22 Mar 2021 16:39:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 33bf366f-0276-4296-8f92-08d8ed5118b3
X-MS-TrafficTypeDiagnostic: DM6PR12MB4106:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4106829D7535F5666670BD12DF659@DM6PR12MB4106.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nWXqAoRmZdElcNek/IX+C3YPn2J6G2GC/XFQ9w/w7IPoopY+cB9OGtOpVqblBU3RXCitghxD7LQgdonLDElximIdq2pN4t+q28F0JNG2DtHu8hP8BKvwvqPKLsmJwpUgf0Z8EnF3IwFrktnjM/cuaiyGIgi/y0lzxmJK3EqiNrPk5wtkGwouszl/i3i+ENaI8I+WdTA2nQ9ZFqYp/LkpRo0ZldGjpfRvYfUWnBv+SN3egnfQvH9ahLQFXFpo5tDUZ22s0zOEoTYSv7W3galrl8gTazxFtOLWW0x9OnGJtjoSpK+LpNbUkGgD/XWdGd2xekFV84O5ttN+HEaIDhnXib+/WyruEv2ZGY+R5wB7pSP2ItiW4998qpPinraGHPN3KSw9w9Y3QKFxvylRMWu/jLiZEYv/nlc0MexRZipoeeoQL0zbeAzbbVFp8cAOOUoGgojD+mj1sxZEiWMiHrf27i03z9rbN5d6Ze3yIEm7SFbIiQwj1tAa939ELvQm4c9jKVKful0C5NGD5toNUndZ+YD+ogOmhUcyuuyzlCc/x/IhgO2I6unbur6ETjoRuA+fxZjuFRFC285yZVDODGmKN0I0jEy4YnW6ByJByFSxQSMp6RuwUtbkyOm/zgabVrAuwjrC67Z6aPbs0FCCcnyAGDZtRFP5Bnvbk3AO/e2qn5B3suqBm7KXLfxbfwCGVvb02glCl8rRAJmQCilfSf8USUyWTPZ8BxGIXMHLKhuUTRh+TpbFmVnqhJe1wjrUwvd4D7iU+2Mx0Z4QCCLk4UB8O5dJeUIsKbFv/Ab7HKwpI+g=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4403.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(136003)(376002)(39860400002)(366004)(36756003)(83380400001)(8676002)(66476007)(66946007)(956004)(66556008)(31696002)(2616005)(31686004)(86362001)(8936002)(186003)(16526019)(26005)(16576012)(5660300002)(6486002)(53546011)(316002)(6666004)(478600001)(2906002)(4326008)(54906003)(110136005)(7416002)(38100700001)(966005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?UkFmZEdSKzNuYVM2WklSclNkV3ZkOHlkT3VZUnBrVi9uS1pZWDREaUNnbkZH?=
 =?utf-8?B?U0V6TEZ3K0RWMTlESHZLNks0bFQ0VzlTV1d3aHN2YzJMb0Y5RmJrQjhBSzdK?=
 =?utf-8?B?bm10cFlaRERwaGtMenRlbUFkL3hDVUtGYWtNUUo4QWdNRUxLWlBraTJvY2VT?=
 =?utf-8?B?VURpbDV6MUtNSzJBREpqb0E5ZlBSdHZhYlpqZWg5WGszV3ppQnBpckRQdDRD?=
 =?utf-8?B?Yzh2djdwQlgrZXZpdHRVRlNnMDdNTW16OVVqUmtMbStaTlgzL0gzSy9nOXp6?=
 =?utf-8?B?RFNQNzQvT3hKRHpBRk5PcmhGUjdEQWZIMjZXVHcvaDJuVllsQzNmNUZHaVND?=
 =?utf-8?B?ZzZHWWNKQXdYVzkxekhVNHB2YWZpL09RaFNjMHlla1F0SU5Tc2xiQXd3MDla?=
 =?utf-8?B?Q3VZSDVyemNkOUhnYjhCZitpRDhoTXFoNXRBb245dy9INGlsSk12amNkU1I4?=
 =?utf-8?B?UGNBV1dVL3l3bFdvRG5lcU54c3N3ZEUvcjczQkI2MHFxZGxaVUZ4ZExSNjZq?=
 =?utf-8?B?eVNnOGd0MnRPYWcxaVd2UUh1TjRvQjQzWURyak02d2xWeElUT3RscDdpMUJ1?=
 =?utf-8?B?R0FZWTNpQnR0cEhUL3I2KzdhdHZ0ZlpwRWJNaCt6eVlEODV1T1RpNzRXalYz?=
 =?utf-8?B?ZCtlVjUwQzJlODcvZmpDK2RucGloN2ZtQ2VPMm1vUWhhbW1yTzduQVRyUmt2?=
 =?utf-8?B?V1poSjZ6bmJKcThRTktMaHZhcUNZR3NkV3g3Wm9qV0xqeWh5eEVUclVuVlF5?=
 =?utf-8?B?dXRPajNsSW9xd1FJK3c0MG8weEQvV3lVbEdXdmtHS2RmdkU3QUJHM1ZzbjZP?=
 =?utf-8?B?WVUybUoxalhwbmM4bEMwR3lTdXVTV0VZMzVUWFFqQTFhU1V1alhOUFBjU2JC?=
 =?utf-8?B?am5KUnh1eU4vUGkxclRJSmVaa3dGS0dEU2hVRG1aeTlZaWYwQzM2UGFtVjh0?=
 =?utf-8?B?WWtOdzdIem03ZDQ5dTRyZk9rbWpKeDV2Sk1jbkg5OVRNMjIvZ25PNVB1U092?=
 =?utf-8?B?Y0dSRjVFd2EwOFNjZlFYWDNlRldPcStlOXI3WnhHNUtXbjFPTktMTDVhN3Fa?=
 =?utf-8?B?eWdjTzMrVnpNZUowVjlRNmJGdVpWQ1NtUnlqanZpRXg2d0QxbmFINUMyS0ZJ?=
 =?utf-8?B?RXUrT203M2pTUldEOU5BK3h0bzF5THVHcmV3R2l1UkIwNUp0MEZBU3ZMTEJY?=
 =?utf-8?B?M3VURS95TW1oOVJXeVJVbVNxQlVtV2hXeURNWE00NDA3VzZvVE1qWlhJYmtY?=
 =?utf-8?B?UlI0RDZ1VnFtekVoSndOdm8zakVWQU9UYy93blFzdFZoSVdnZ2d4akQ2RTc4?=
 =?utf-8?B?YmcxalU0bTVYMUZzUlo3N1BaSm1GT3BDSzI4cG94R3FqSkl3K3lXMVMvWFd4?=
 =?utf-8?B?TFlhSWlZbDh3MHVnMVB0RWtZd1ZQR2Vlb3VXOG5uTDJ4VUI3L3l0TVA0dXNP?=
 =?utf-8?B?WDZKOW5MQkowbjZWbUM4WG9iTUk0SUFCZmt3RGZHRHdrQk1KZlBDY051QzZ3?=
 =?utf-8?B?Q1p5N2I3UFIyZ2FzemUvVFdVcHdqVnpXUjVvV0Z3ZEY1MzhTWmNiSHhwWjZ0?=
 =?utf-8?B?bWx3STdxTERxd3BSdEVRUm9KbURmbTlVREQ5L01FQWEwTlcxWENWUnFVVGhq?=
 =?utf-8?B?UGlEcCtjRjV4SkdpSjZ2RWQ1MzNKZmhhYjA0Y3MweU1Sck4yMGN2elpSVzFM?=
 =?utf-8?B?akY5Q3dpVzNxWVZZNlVXUG1qcnpOT3lzQWcwN3R4UEt2Sk9TcDN3eHhVeGpN?=
 =?utf-8?Q?/7VzRVEP0xcwMbHPhB/imlmZES8GtxYOU/qHm8x?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33bf366f-0276-4296-8f92-08d8ed5118b3
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4403.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2021 16:39:43.6694
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /XWpfvW6ZLxVp/sY9az0EVowo0qCbnnB5mRr4xmdJ6J+TlZMzJmJwNUDRcS3pIFFn2mmA5v9iDt+k0PVDyMF1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4106
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21/03/2021 00:34, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> When a DSA port joins a LAG that already had an FDB entry pointing to it:
> 
> ip link set bond0 master br0
> bridge fdb add dev bond0 00:01:02:03:04:05 master static
> ip link set swp0 master bond0
> 
> the DSA port will have no idea that this FDB entry is there, because it
> missed the switchdev event emitted at its creation.
> 
> Ido Schimmel pointed this out during a discussion about challenges with
> switchdev offloading of stacked interfaces between the physical port and
> the bridge, and recommended to just catch that condition and deny the
> CHANGEUPPER event:
> https://lore.kernel.org/netdev/20210210105949.GB287766@shredder.lan/
> 
> But in fact, we might need to deal with the hard thing anyway, which is
> to replay all FDB addresses relevant to this port, because it isn't just
> static FDB entries, but also local addresses (ones that are not
> forwarded but terminated by the bridge). There, we can't just say 'oh
> yeah, there was an upper already so I'm not joining that'.
> 
> So, similar to the logic for replaying MDB entries, add a function that
> must be called by individual switchdev drivers and replays local FDB
> entries as well as ones pointing towards a bridge port. This time, we
> use the atomic switchdev notifier block, since that's what FDB entries
> expect for some reason.
> 
> Reported-by: Ido Schimmel <idosch@idosch.org>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
> Changes in v3:
> Made the br_fdb_replay shim return -EOPNOTSUPP.
> 
>  include/linux/if_bridge.h |  9 +++++++
>  include/net/switchdev.h   |  1 +
>  net/bridge/br_fdb.c       | 52 +++++++++++++++++++++++++++++++++++++++
>  net/dsa/dsa_priv.h        |  1 +
>  net/dsa/port.c            |  4 +++
>  net/dsa/slave.c           |  2 +-
>  6 files changed, 68 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
> index f6472969bb44..b564c4486a45 100644
> --- a/include/linux/if_bridge.h
> +++ b/include/linux/if_bridge.h
> @@ -147,6 +147,8 @@ void br_fdb_clear_offload(const struct net_device *dev, u16 vid);
>  bool br_port_flag_is_set(const struct net_device *dev, unsigned long flag);
>  u8 br_port_get_stp_state(const struct net_device *dev);
>  clock_t br_get_ageing_time(struct net_device *br_dev);
> +int br_fdb_replay(struct net_device *br_dev, struct net_device *dev,
> +		  struct notifier_block *nb);
>  #else
>  static inline struct net_device *
>  br_fdb_find_port(const struct net_device *br_dev,
> @@ -175,6 +177,13 @@ static inline clock_t br_get_ageing_time(struct net_device *br_dev)
>  {
>  	return 0;
>  }
> +
> +static inline int br_fdb_replay(struct net_device *br_dev,
> +				struct net_device *dev,
> +				struct notifier_block *nb)
> +{
> +	return -EOPNOTSUPP;
> +}
>  #endif
>  
>  #endif
> diff --git a/include/net/switchdev.h b/include/net/switchdev.h
> index b7fc7d0f54e2..7688ec572757 100644
> --- a/include/net/switchdev.h
> +++ b/include/net/switchdev.h
> @@ -205,6 +205,7 @@ struct switchdev_notifier_info {
>  
>  struct switchdev_notifier_fdb_info {
>  	struct switchdev_notifier_info info; /* must be first */
> +	struct list_head list;
>  	const unsigned char *addr;
>  	u16 vid;
>  	u8 added_by_user:1,
> diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
> index b7490237f3fc..49125cc196ac 100644
> --- a/net/bridge/br_fdb.c
> +++ b/net/bridge/br_fdb.c
> @@ -726,6 +726,58 @@ static inline size_t fdb_nlmsg_size(void)
>  		+ nla_total_size(sizeof(u8)); /* NFEA_ACTIVITY_NOTIFY */
>  }
>  
> +static int br_fdb_replay_one(struct notifier_block *nb,
> +			     struct net_bridge_fdb_entry *fdb,
> +			     struct net_device *dev)
> +{
> +	struct switchdev_notifier_fdb_info item;
> +	int err;
> +
> +	item.addr = fdb->key.addr.addr;
> +	item.vid = fdb->key.vlan_id;
> +	item.added_by_user = test_bit(BR_FDB_ADDED_BY_USER, &fdb->flags);
> +	item.offloaded = test_bit(BR_FDB_OFFLOADED, &fdb->flags);
> +	item.info.dev = dev;
> +
> +	err = nb->notifier_call(nb, SWITCHDEV_FDB_ADD_TO_DEVICE, &item);
> +	return notifier_to_errno(err);
> +}
> +
> +int br_fdb_replay(struct net_device *br_dev, struct net_device *dev,
> +		  struct notifier_block *nb)
> +{
> +	struct net_bridge_fdb_entry *fdb;
> +	struct net_bridge *br;
> +	int err = 0;
> +
> +	if (!netif_is_bridge_master(br_dev))
> +		return -EINVAL;
> +
> +	if (!netif_is_bridge_port(dev))
> +		return -EINVAL;
> +
> +	br = netdev_priv(br_dev);
> +
> +	rcu_read_lock();
> +
> +	hlist_for_each_entry_rcu(fdb, &br->fdb_list, fdb_node) {
> +		struct net_device *dst_dev;
> +
> +		dst_dev = fdb->dst ? fdb->dst->dev : br->dev;

Please use READ_ONCE() to read fdb->dst and then check the result here.
I'll soon send patches to annotate all fdb->dst lockless places properly.

> +		if (dst_dev != br_dev && dst_dev != dev)
> +			continue;
> +
> +		err = br_fdb_replay_one(nb, fdb, dst_dev);
> +		if (err)
> +			break;
> +	}
> +
> +	rcu_read_unlock();
> +
> +	return err;
> +}
> +EXPORT_SYMBOL(br_fdb_replay);

EXPORT_SYMBOL_GPL

> +
>  static void fdb_notify(struct net_bridge *br,
>  		       const struct net_bridge_fdb_entry *fdb, int type,
>  		       bool swdev_notify)
> diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
> index b14c43cb88bb..92282de54230 100644
> --- a/net/dsa/dsa_priv.h
> +++ b/net/dsa/dsa_priv.h
> @@ -262,6 +262,7 @@ static inline bool dsa_tree_offloads_bridge_port(struct dsa_switch_tree *dst,
>  
>  /* slave.c */
>  extern const struct dsa_device_ops notag_netdev_ops;
> +extern struct notifier_block dsa_slave_switchdev_notifier;
>  extern struct notifier_block dsa_slave_switchdev_blocking_notifier;
>  
>  void dsa_slave_mii_bus_init(struct dsa_switch *ds);
> diff --git a/net/dsa/port.c b/net/dsa/port.c
> index 3e61e9e6675c..d21a511f1e16 100644
> --- a/net/dsa/port.c
> +++ b/net/dsa/port.c
> @@ -205,6 +205,10 @@ static int dsa_port_switchdev_sync(struct dsa_port *dp,
>  	if (err && err != -EOPNOTSUPP)
>  		return err;
>  
> +	err = br_fdb_replay(br, brport_dev, &dsa_slave_switchdev_notifier);
> +	if (err && err != -EOPNOTSUPP)
> +		return err;
> +
>  	return 0;
>  }
>  
> diff --git a/net/dsa/slave.c b/net/dsa/slave.c
> index b974d8f84a2e..c51e52418a62 100644
> --- a/net/dsa/slave.c
> +++ b/net/dsa/slave.c
> @@ -2392,7 +2392,7 @@ static struct notifier_block dsa_slave_nb __read_mostly = {
>  	.notifier_call  = dsa_slave_netdevice_event,
>  };
>  
> -static struct notifier_block dsa_slave_switchdev_notifier = {
> +struct notifier_block dsa_slave_switchdev_notifier = {
>  	.notifier_call = dsa_slave_switchdev_event,
>  };
>  
> 

