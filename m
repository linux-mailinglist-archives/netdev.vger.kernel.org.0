Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01749345C89
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 12:13:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230365AbhCWLNM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 07:13:12 -0400
Received: from mail-eopbgr680065.outbound.protection.outlook.com ([40.107.68.65]:36864
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230406AbhCWLMr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Mar 2021 07:12:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lmIlQtGyrHRWSeYPG8xrEhdxrqVeegxwuweufKSSBTcRGmg/hxwqwLTJUzU9q6eQJah6vPQ++zF4ReStlpUkPkDLTN5bpVL74Kf7sUE/LXjiCEE5SX9J0xPIrp5vSedTLxMQnUfQk53w7cC2Ke3KbnQUJeQvf12ei9QIcEjvWSYbiZSxDgbu8GQuu7AaOnZWAxIdz869APVu22cSyZ3pzK8/gvoodYuDr5Z/O4pnCSI7HB7kA9pSZ6GfJ4yEpBVxFuQRicIreKuPsWALNiWKqK8ODBt9lu+fV2TGAR30dlhxfsfgEP2uN3S9xjos255qoF3PHEWNHiytGFzC7KdiPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4rbAjwI0goBbosAjM1w8woMAocgKIMpJchcv3Pg8OFc=;
 b=Q0cKfZYZRKnwvODvOaIGoPd4HCUT1lbl+6QHCOO0uebdvuKzoFJZvIJ1plEtFMEWQugX0nxh27E+xatUZto9fGqC/wFpiKgEkkNGu2S7UyyvFV/G2FllceajoMOXFglA2nmsTGVOaM8aOItALpthDQrIbeiqhMcuhAzORIoqsnmHMkbBGyn418LYw7QVCuoRapyM9xlrrDcn1ugHORYIkUBUGaGGTVKZqf8BE/mCBUwMuw3ms4XBLGieOloH1amkvAJmf9wl+QxhBog1UrFqgHQ3EWoG0c9mJJMe3T+chgC/ydCJWb9eVKoBYvCFbAXXCW0/xvuIlMX6GU2igTfkVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4rbAjwI0goBbosAjM1w8woMAocgKIMpJchcv3Pg8OFc=;
 b=HW7EAANUneqaEiTJyjMxf6wQcmeRVtevf+RWUaJV4Rm0TbhUozpwGqrDZ30ydZP5JrxkbswagOk7SOR9gDc7n+0V3nVKRS3MQ+JyMaPn5ILyl44jfq/rlbhh3mae4x0Z9RYbGYdwzdjRRfKG4d56+MNx56gSCmiWqHtJ/+j9aH0LNx3f9AOxJaDhXFuexiUnlW7uwRncUsoK3XrpdCCt3s0XyNbuU85YugE1zazJeNOWXBg9zKslHL572SKy+n/k9vjIkm3ZO6WH8Wy+w2Sp04HsEFVl3C7UFUrlFB9CZ/ZEECcq0Gjc3ynmGfKoolnqF1lL1g4uvYgmchhootX47g==
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4403.namprd12.prod.outlook.com (2603:10b6:5:2ab::24)
 by DM6PR12MB4548.namprd12.prod.outlook.com (2603:10b6:5:2a1::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.25; Tue, 23 Mar
 2021 11:12:44 +0000
Received: from DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::5c42:cbe:fe28:3a9b]) by DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::5c42:cbe:fe28:3a9b%5]) with mapi id 15.20.3955.027; Tue, 23 Mar 2021
 11:12:44 +0000
Subject: Re: [PATCH v4 net-next 04/11] net: bridge: add helper to replay port
 and local fdb entries
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
 <20210322235152.268695-5-olteanv@gmail.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <f9076daf-7479-8c49-5e7c-ea20d86214c4@nvidia.com>
Date:   Tue, 23 Mar 2021 13:12:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <20210322235152.268695-5-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZRAP278CA0014.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:10::24) To DM6PR12MB4403.namprd12.prod.outlook.com
 (2603:10b6:5:2ab::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.240.137] (213.179.129.39) by ZRAP278CA0014.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:10::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend Transport; Tue, 23 Mar 2021 11:12:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 86045ec6-e134-4540-bb06-08d8edec9515
X-MS-TrafficTypeDiagnostic: DM6PR12MB4548:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB45481AFDE64AA471581B1AD5DF649@DM6PR12MB4548.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rGq018lnJ+Os9lQvyuGW/6zuxx3nox5/DGRz20oVXiGq5iJ0pJ/9K8HRg+QprfzawTS9UUSCp06vjk9PTNDEk8R2ne+Z/Ln4s3wSQr2269G4DD2QMZb2NsKj2tIQYRcBhT2JyoI1sDeBwHQ8Jxe948qH8YqH7lxTe1+SI6gB5Io1KkX9THijJnpBrEbeDjpOEEbef2f2sjXfcTM6XPuK8gRXpqdPLS9UppdsnbppqpasuzADRAv06Gz5HnNAfTPYjAU/5kcb/s9QvCHEqUPA4Mrjm1ADeOwBO0+LFePKbJTlhtmp/P7AfJYmzwtVc5AZwMz7hggevazESWufWmIJnJLudNH8b2+/ZNBpwWx7GYsIPBqQj85iMquiNX0YVE3kfRr1iyYxIVHGGVVfbYtaR15mWC3EGZ2zS4IcOOIx/ZsdgyZdYzJqvdBo4gBtT3ha1Y9ZUybgURt02JE5nmbQTxP55drlgH5qi2YS9NbWEEXpaEn8zOr1wb2kbhrNBSx8GzS8DiecTw8RoYY7CYW2rEaJTb6NTKAWEDX+czhjKrziWBTmzc8TyoRsioNC2PUfl5qD7vmoDfVPZAyv+zMbm13/5CglRpiT2CbhSk2KoPdXDyFapI7ds4+ya+6/hIPdmgAJ5Uxa/bhCp5NKVFvpyYDpzVq3+fPr2IpCt1aKDPTL4oGUrSQQ2JLUfBFYny1kKe6qd4FIxU6Kn20xsfJya7z9g3Clt77Yp8LoYwMdOqR/EumFQ/baMsF3y8bDLCUfedPH1Nd4q5kW099qEGkaPmXGVVLpTlibEljkWKFwoNE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4403.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(396003)(346002)(39860400002)(136003)(36756003)(186003)(8936002)(16526019)(4326008)(7416002)(26005)(66946007)(31686004)(31696002)(53546011)(86362001)(6666004)(478600001)(966005)(8676002)(5660300002)(956004)(83380400001)(38100700001)(54906003)(16576012)(110136005)(66556008)(66476007)(2616005)(6486002)(316002)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?WmRJTEdWb0Q3NzFmeWRONzI2S1gyYlFvb3lIU0ZZSE5Ra3V4UzlXalJLVGt0?=
 =?utf-8?B?M20yZnU0TWtpazlrSlJ3Qjd0RGZ2cjN0ZmNaWFg2TWJYcEZDREN0d0lPZ2JN?=
 =?utf-8?B?bkNYZ3h4cG9LK015T1NZS1IvT1F2azBCTU16VURyZE1Yc0hvc1JvT2dzMUdM?=
 =?utf-8?B?WmFGWlZrVGVicG1CejhnU1NOT05jK0RMSWw1NitXT2tWNVFrNXQxNSswRzZa?=
 =?utf-8?B?M3BDamlxeThNdStVSVhvaU9Ma0JnVEFVcEpKenFKN1dsbWNZdTNkNmhzV09p?=
 =?utf-8?B?eEN0bnhzYlkrcnJxWmk4d1hGU0FNOHZiRXhXdE1SaUtweUV1QmtDWVJKeE9u?=
 =?utf-8?B?T3hEczkxWTEwUXFEV0RGMXFJOGtSbmMxRHlSeGRXM282MWZLYTkwWUVmbHY4?=
 =?utf-8?B?b3NRNDBDL09UaVc3STRhL3VIZkQ4MUF2OGpha1hMZzJpcndoQ3hYWldxbTU3?=
 =?utf-8?B?Z2EzbllWMnVUN2VyUHpMZ1dDM2thOGZSeEMwemJ2WHAzMER3UUlqZE1laU9p?=
 =?utf-8?B?bnpxdGRZTENhMFJPMFBocmhtQjZvSURXVHdVTlk2VnpXZEpDbmxxQzNKa3Bw?=
 =?utf-8?B?b0t5blA5eWVoWTBpQjZjRnUxYjBCSHMrdDFRZHZwTkFvRTEydzhYam16OFlC?=
 =?utf-8?B?RWNQVUVrd0RLYVNqS1BpWTNRNTdnS2tLSDFVUVRLRHlsSFhFbTJRZ3FZak5I?=
 =?utf-8?B?OERoR0VUbVh1eFNIU0hZMVlWenFqWHpzcnA5ZWtpTVVJdmNPRktVMHIveE41?=
 =?utf-8?B?QVNobFlZTU10c2s0U2dNaG1vZjdkVmRkK0ExQ1NBSHVQK1lxcVVFS2wrdkZl?=
 =?utf-8?B?Tzh2VjZaKzc0bHVFTU9jcUdhQzBUZWI3WmpIaXZNcmZYU0ZadWVLVlo0dUxP?=
 =?utf-8?B?Rk5VaUtaZlVXN1FkYkc1MENYRXRpTjBBbEsySEdNbldmM1J6dGJvajZaeUQw?=
 =?utf-8?B?cHVDNGpzM29oRy85bjFjdC9JZGN2dUVCek9JcEIzRUhVUk1HeWVJNlFVS0xJ?=
 =?utf-8?B?ZFpDY09EZHRQUStjTzJvN25ZZWdjZzR4Q1Zwd1lGMjZWNWRzLzBiRGVuYS9n?=
 =?utf-8?B?bENzU3o4dG43VFpyamZrTEFObXAwYzBhcWpoS2RJbnRnZmduV0d1eCs1UmdZ?=
 =?utf-8?B?SzM3a20xWUdzZkFKT21Mbnc2REpLN0Nyd2hrZTdrZHdCUU1sekNOd0d5UXVi?=
 =?utf-8?B?K3d0VkhTOVo1eDQvZDBXRnM2TWVlSnA2Z1FLUU52TWs5UDVKclRPdnNZTjNN?=
 =?utf-8?B?Ny9ob3UyWW5tQ3hDbmltN3RmUXVDT3lpRUt0ZC9LRllyOUNscVJTWjhVTnpr?=
 =?utf-8?B?Z1Y0S0lDclcvYzRJaUpHdElXOUwxaW1jVVJFZ3ROWjIxajEvZXNXV2tSZDZ6?=
 =?utf-8?B?Snk3ZDhsUWhiTlR1dm5TOWxYRHVNaUFIQ0FqMzJCdEtNNWtjemg2bGJ6ek5z?=
 =?utf-8?B?TnFzbVpVZ0hnbWZJSmVxRzd6d0Z0M1dtbEJJUHE1Z3p1S29VRVY5dWJET21o?=
 =?utf-8?B?THpyTWpHRXZkb2xOT093NFR2bS9sRy9ueFpxaE5BL0VUMjd4MXV1VGVySjYr?=
 =?utf-8?B?ZDJaSUxUcnF3TUdmNm95ODZDUDYyMHFWbjVUajUvUVlFWUdrMitkSkE1bnQy?=
 =?utf-8?B?Yk5IYkxNSWZza2dqVXhJbzdBUGJKUE9VcndPbTVVM3pwNGNkZWs2ZXZGRUwr?=
 =?utf-8?B?L2U4NWp6TGM3VkJWZVZHVUF1YVhXU1MzMkxIZDR4ci9rcjNGcysrT1Q2RWRk?=
 =?utf-8?Q?DpqhRe5PlvcGjVS1EPmJ9kryd1a7RfY8yCaKhuf?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86045ec6-e134-4540-bb06-08d8edec9515
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4403.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2021 11:12:44.3752
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +oKGq+HuQe9og6L0bPvKz+9waFpcfm3pPa6Sk35Gyh+aPsBdHEJPNRstUImouBZag/DGUHJu1hNpQ+zGOcFChQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4548
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23/03/2021 01:51, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> When a switchdev port starts offloading a LAG that is already in a
> bridge and has an FDB entry pointing to it:
> 
> ip link set bond0 master br0
> bridge fdb add dev bond0 00:01:02:03:04:05 master static
> ip link set swp0 master bond0
> 
> the switchdev driver will have no idea that this FDB entry is there,
> because it missed the switchdev event emitted at its creation.
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

I get the reason to have both bridge and bridge port devices (although the bridge
is really unnecessary as it can be inferred from the port), but it looks kind of
weird at first glance, I mean we get all of the port's fdbs and all of the bridge
fdbs every time (dst == NULL). The code itself is correct and the alternative
to take only 1 net_device and act based on its type would add another
step to the process per-port which also doesn't sound good...
There are a few minor const nits below too, again if there is another version
please take care of them, for the patch:

Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>

> Reported-by: Ido Schimmel <idosch@idosch.org>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  include/linux/if_bridge.h |  9 +++++++
>  net/bridge/br_fdb.c       | 50 +++++++++++++++++++++++++++++++++++++++
>  2 files changed, 59 insertions(+)
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
> diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
> index b7490237f3fc..698b79747d32 100644
> --- a/net/bridge/br_fdb.c
> +++ b/net/bridge/br_fdb.c
> @@ -726,6 +726,56 @@ static inline size_t fdb_nlmsg_size(void)
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

The devices can be const

> +{
> +	struct net_bridge_fdb_entry *fdb;
> +	struct net_bridge *br;
> +	int err = 0;
> +
> +	if (!netif_is_bridge_master(br_dev) || !netif_is_bridge_port(dev))
> +		return -EINVAL;
> +
> +	br = netdev_priv(br_dev);
> +
> +	rcu_read_lock();
> +
> +	hlist_for_each_entry_rcu(fdb, &br->fdb_list, fdb_node) {
> +		struct net_bridge_port *dst = READ_ONCE(fdb->dst);

const

> +		struct net_device *dst_dev;
> +
> +		dst_dev = dst ? dst->dev : br->dev;
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
> +EXPORT_SYMBOL_GPL(br_fdb_replay);
> +
>  static void fdb_notify(struct net_bridge *br,
>  		       const struct net_bridge_fdb_entry *fdb, int type,
>  		       bool swdev_notify)
> 

