Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9CB9346100
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 15:07:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232143AbhCWOGw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 10:06:52 -0400
Received: from mail-dm3nam07on2086.outbound.protection.outlook.com ([40.107.95.86]:11393
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232000AbhCWOGT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Mar 2021 10:06:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bemjTRD8bBpMlp5WYkj7QxKsittjJ6BQaGMHdxE54lQc/64350BTCFuAZscO+Gz/FgtATMLw18QoHFNFIOEWWy+rYdAJehgJ2VCVvkVCccGxANJxDlAoPWBasR34s3EM839IeQvxXgIWmKhpp/mYOotajAXr5pIgIcCYG5qyNcVG1hqRJ+DeEUhlI10u1iAVhAXuAPGkA6ew1S1hoDUCQ6TqY1zAu73kwiM9w3dQkTdFE//w/YydGsAATSMSrNBQLg4kSxH5g96//QuVakif/tbiWno9ihvyTimvA2t2SgmgQj6zTBizcJpEw5EV7QUykDHF2Y2aoJhG76tsu8t71Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nCzCjOCHksG3yU/zQdk3Bbw1MhBzofXtXDTgHKqSHbs=;
 b=oayRFI4bkSLctCeBXTnZHyxjQxZEhzq3T1RLppO2r48NokiJzGX9Fa0bZa4bUlIxqbo4axY1cMNGCQX7BU7/SZ2diRNrEpE65yKi7JltdPzcRV0zjpJV22bECsFzHKxvdomghe2S7gtPg6r0tzJmRl2VqJSOukTsIMYXo0rN2gxq/drcd0XH41nklVn+1NdjRKpyWO/uzj5Sbp0RBJmkFOiFvCZ+54838cChLXCnLM/JN3IkjPh19oAd49tR9LN4jwvFS7Mfry5zUjDDdgYxhJ46FyOH5QXyCPbLWfPzQon8LUzhl/K6Alr1cTXZRRtmPkraXYoL+0vO6TVOsc/+Eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nCzCjOCHksG3yU/zQdk3Bbw1MhBzofXtXDTgHKqSHbs=;
 b=lXGLRbdfWwUKL6eFC4jzZApex3+kjMTCE5oqeM2mRCfU4q6YPb4BT8K0E5kmkvM8pxajXoS8o8bf08wWC+WrypnPhDZC7wChA1VD2yxWJ2u8SBTSc+hp7iwlBZYV/G6FXed+vraLChHuekOwTD8gwUGQ1yFez4aKaZRfl07q6uI6xhpaHL5YuX8mFcFDpzXdt+jdj60XClUPC8PHfFfuERIR6Ch03SYuM+b/p0RX5eD9SQStLvwCSdIVLrp0Zqc1RRlGzDbKowqQHRNgf2JPQSgTosUOLSiOyyytvkr7XO+hmRp+A1K4XB/gdXcayD2cQG8tVWVKKhXsR/qsrk/OQQ==
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4403.namprd12.prod.outlook.com (2603:10b6:5:2ab::24)
 by DM6PR12MB3337.namprd12.prod.outlook.com (2603:10b6:5:118::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24; Tue, 23 Mar
 2021 14:06:18 +0000
Received: from DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::5c42:cbe:fe28:3a9b]) by DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::5c42:cbe:fe28:3a9b%5]) with mapi id 15.20.3955.027; Tue, 23 Mar 2021
 14:06:18 +0000
Subject: Re: [PATCH v4 net-next 05/11] net: bridge: add helper to replay VLANs
 installed on port
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
 <20210322235152.268695-6-olteanv@gmail.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <3f659e4c-fe27-bc0e-9f13-06f808b8d3b7@nvidia.com>
Date:   Tue, 23 Mar 2021 16:06:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <20210322235152.268695-6-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZR0P278CA0093.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:23::8) To DM6PR12MB4403.namprd12.prod.outlook.com
 (2603:10b6:5:2ab::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.240.137] (213.179.129.39) by ZR0P278CA0093.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:23::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend Transport; Tue, 23 Mar 2021 14:06:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 132c7243-1297-49b7-cbea-08d8ee04d414
X-MS-TrafficTypeDiagnostic: DM6PR12MB3337:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB3337E379826A4FDA28FBFE3BDF649@DM6PR12MB3337.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c9dyQo/UgOCOkK1gylk3PpFjfTTdPknRBb5D7JF4s1bpUPmVuqrOIUROAhHBXb1UYxr43zVoyyJmIHn0Bvdo8w3REkb0sI5rLJk0XQcVx2pbirbYNoXwEY3kgQ0b1RhKc0xeEvyYVvG1iZFIZCp3yjWkwZcne9JNHym/Mf0JWMKysHhbTYhit8lSnTWsyNlAUbVLQfNvJ1BHxnu7jnInxWA+2eJ70mGLOU9TaAaD+aBbi5XFhRCQM4GmaTgNk2tWg3xJ1G0fIfGGkCQ20+1myK3xwpy+9oukwxqrojF63dKY4UaGLMhOPK3fS1S31vo1KSWzmGXczZV3YeLB1LunlJk6RGsda3g5VxI+H3o6QfOsf2PlGtES14BIKDMOss+dL4HDuGwyThTolDs/HI2RdTLKqe6sHPWtVB3uyepr297w3xl5zCPSOVq3h2dDJkmyu9wrCAm6/Dc7KEcJp1IKyFUMUzm7Peo9to73c2VcEMvyn6cGJ34bTd1HOAjOfJ7/r/I+/lplwUujPYOMuVOdHE3yRqonWyT+wKlaR3Zx9aAfI58NKTFDWzFPcYAXv75gytwjLlAWO6ddJTBSyyTu0FEv9ZKhbDljCERGc5srE+X6xtn6wVhfjKbRy4e44cCRgocXYpBDfCmY4tjH18qGxZYqHizNq2XJldWTBfdLPAjo4/9AlA8AcmOq5ixIc7JWEIYE1mZLYUy8h8L/F6jW2A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4403.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(346002)(376002)(396003)(366004)(5660300002)(66476007)(2616005)(956004)(66946007)(2906002)(66556008)(186003)(16526019)(7416002)(6486002)(6666004)(83380400001)(31696002)(54906003)(316002)(16576012)(110136005)(53546011)(8936002)(478600001)(8676002)(4326008)(26005)(31686004)(86362001)(36756003)(38100700001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Y1h4TmI1OE1rbStoeWVhTzZWMGRTcjN2MkNWRmtJYVRKTmhmUi9jVnJjYlE2?=
 =?utf-8?B?Nk1XRTJPMUtpRjRhSjFKRm1zcGZyYnlrTDZRaHF6a0Q4TUwxQVB1WlYxNWZ4?=
 =?utf-8?B?YUQ4bzNxNFNCbHNUUmN3QVdsTnlmNTYvOC9TekwxN3dwSllFL2IrQjdaVjlv?=
 =?utf-8?B?VDhyNTV0Zy9hYi8vR3dsaWJaNlhrRW5rRzBsWGlyQ2VuRmpaaFJFWGRWVVlS?=
 =?utf-8?B?TXdJZldUMy9kS3hFTFBVUzdBZTFCUG1YVXJPdTZ4cENITHpvWHJwdjBlZ0JF?=
 =?utf-8?B?dWFIRlhDVVBwQ3VNRVNTM1dDcDNYVWRINEM4WnYzMlJ3K3NZRU9XMFl3Y0FS?=
 =?utf-8?B?MUpubmdEMG8zQThCTlFUUXFCbXRLMEZMenFOanlEOElnVjhoeVNKcXR2NUlX?=
 =?utf-8?B?MU95NFNURTlwODZXZ0ZaWTg3b3RvZDIyeW1xOEVNT2pVUm12cmpFWm9UQlFJ?=
 =?utf-8?B?LzdVdWVWZGErVzdFanUxNGFvUTF3d1V3QVlGZ2N2Z3B2dCtKelh4a1FXSHFL?=
 =?utf-8?B?SjUvR1QxbG41RFBSQXRqc0dsVllyR05VRnBBQVpwdFgvQytZdjZwTkE1WEU2?=
 =?utf-8?B?dFFzbDQxS08rL240a3p0a1BaZ3pzZVUrY1VmeWpMQTcwU29QVmxvY3pDR3VW?=
 =?utf-8?B?Q0RPTlJJQTNEdHdoQzF0Yy9qWmdhUEp5N09wUzBwVXFyeFZ3akp4NmxBUFAy?=
 =?utf-8?B?OThFa1pkVXo4eG1QcDFLVVY1M1U3MTdja2JjSXJYeUFsMDBoTmR6ckFONWhY?=
 =?utf-8?B?dGM1V0RoRUJtdmE1UnNxbUxob0lxbGszdVhFaEIwRU9qN3N3UjZPaVYwYk5C?=
 =?utf-8?B?WnJhbjdhbkRhQkM3cnhpWDdBVnRqZzd2cXN5bE1LRDIwYWNCRG9ZYnlUcTV4?=
 =?utf-8?B?RzROTit5akJsSFJoU0Z5alVETVdwMEY4OTZVMXZ5NW90NXhKakg5ZDJ6T1Y0?=
 =?utf-8?B?K3l0TVBmOFhhUDRkdW12cmdJa1JZYVhteTRndjEvcU5kWEhpcFl5WG1ZUnJn?=
 =?utf-8?B?emN3U1V2dHhFOG5USlBCSW1hTmIrWDJ2L1JLUlFQM2o4WWhubUx6NCtFVUZF?=
 =?utf-8?B?eHpTcmFWajBEZktXdnFOaHJPalduYzNkUERRSU5xcU14YzlyV050MVJiMjV0?=
 =?utf-8?B?YW5kRWwxbTFlNVNFZlRKWTdQcC91dmRtRUVOdlM0SnQvVisxeDN1a1c0Wlo1?=
 =?utf-8?B?dkd6aWxTV09XcUxDWDhyMjJPeGxuZVNwbmdUdzZ5QnJabzNLcVEwZFpHdWtm?=
 =?utf-8?B?ZkJRemJ2R0w3aHcrUXlVT1E2T2tyVHl1YnRjVmpDRmNkQkZzbVNiaG52S3Nw?=
 =?utf-8?B?RlpEMTNKbDVObVIrOWtkc1U0UWFLdHdzUktJQXdVT0lmc3NBRDdQMlZldUlR?=
 =?utf-8?B?L01sVVVmMlFabDcrZ1dySFJwMi9WWnNtaGF6ZlNHQ2ZqMER6bVFVZmQ2OGZv?=
 =?utf-8?B?ZEFsUUxYKzdFWnM5dVNJeHVzVHY2YzNIOXJKMUIwanBUek9MdkNzUDZMeDY3?=
 =?utf-8?B?UzRHand3aFFHZWJ0WG1FdURNT3JSVlRmL0xSRTBvUWtmWTY4Ym1INklSQlRi?=
 =?utf-8?B?RGFRZ1QwTUVCOVJ3Y2hpZlhHUHFmVUkxQll6UDNwZmlLR1FiRHlNbmZqSDEw?=
 =?utf-8?B?VENBOGNYcm0yendxaVlmNEZDTUZhQWxKL21aR2hwQ2pXYkUrUDF4T09URjhP?=
 =?utf-8?B?Y0hRSjFmVEZPUzN4aVM3MTVEbEhCTmZhRjdPTUJEOGRvZWlCQ3cvMnZJVDUv?=
 =?utf-8?Q?AoS0A6jcG1aaj9cHqQ+BEzZh+k3lXcfhvRad+Jb?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 132c7243-1297-49b7-cbea-08d8ee04d414
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4403.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2021 14:06:18.2051
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VIpF3tvKhHQ0f79oMfpS0mTPFX/4aomx8G27xQkTJL39x/QaV1xUq1GfklK7KQiauW0pIH4hQYWRhU/qJN/tSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3337
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23/03/2021 01:51, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Currently this simple setup with DSA:
> 
> ip link add br0 type bridge vlan_filtering 1
> ip link add bond0 type bond
> ip link set bond0 master br0
> ip link set swp0 master bond0
> 
> will not work because the bridge has created the PVID in br_add_if ->
> nbp_vlan_init, and it has notified switchdev of the existence of VLAN 1,
> but that was too early, since swp0 was not yet a lower of bond0, so it
> had no reason to act upon that notification.
> 
> We need a helper in the bridge to replay the switchdev VLAN objects that
> were notified since the bridge port creation, because some of them may
> have been missed.
> 
> As opposed to the br_mdb_replay function, the vg->vlan_list write side
> protection is offered by the rtnl_mutex which is sleepable, so we don't
> need to queue up the objects in atomic context, we can replay them right
> away.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  include/linux/if_bridge.h | 10 ++++++
>  net/bridge/br_vlan.c      | 73 +++++++++++++++++++++++++++++++++++++++
>  2 files changed, 83 insertions(+)
> 

Same comments about the const qualifiers as the other patches.
The code looks good to me otherwise.

Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>

> diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
> index b564c4486a45..2cc35038a8ca 100644
> --- a/include/linux/if_bridge.h
> +++ b/include/linux/if_bridge.h
> @@ -111,6 +111,8 @@ int br_vlan_get_pvid_rcu(const struct net_device *dev, u16 *p_pvid);
>  int br_vlan_get_proto(const struct net_device *dev, u16 *p_proto);
>  int br_vlan_get_info(const struct net_device *dev, u16 vid,
>  		     struct bridge_vlan_info *p_vinfo);
> +int br_vlan_replay(struct net_device *br_dev, struct net_device *dev,
> +		   struct notifier_block *nb, struct netlink_ext_ack *extack);
>  #else
>  static inline bool br_vlan_enabled(const struct net_device *dev)
>  {
> @@ -137,6 +139,14 @@ static inline int br_vlan_get_info(const struct net_device *dev, u16 vid,
>  {
>  	return -EINVAL;
>  }
> +
> +static inline int br_vlan_replay(struct net_device *br_dev,
> +				 struct net_device *dev,
> +				 struct notifier_block *nb,
> +				 struct netlink_ext_ack *extack)
> +{
> +	return -EOPNOTSUPP;
> +}
>  #endif
>  
>  #if IS_ENABLED(CONFIG_BRIDGE)
> diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
> index 8829f621b8ec..ca8daccff217 100644
> --- a/net/bridge/br_vlan.c
> +++ b/net/bridge/br_vlan.c
> @@ -1751,6 +1751,79 @@ void br_vlan_notify(const struct net_bridge *br,
>  	kfree_skb(skb);
>  }
>  
> +static int br_vlan_replay_one(struct notifier_block *nb,
> +			      struct net_device *dev,
> +			      struct switchdev_obj_port_vlan *vlan,
> +			      struct netlink_ext_ack *extack)
> +{
> +	struct switchdev_notifier_port_obj_info obj_info = {
> +		.info = {
> +			.dev = dev,
> +			.extack = extack,
> +		},
> +		.obj = &vlan->obj,
> +	};
> +	int err;
> +
> +	err = nb->notifier_call(nb, SWITCHDEV_PORT_OBJ_ADD, &obj_info);
> +	return notifier_to_errno(err);
> +}
> +
> +int br_vlan_replay(struct net_device *br_dev, struct net_device *dev,
> +		   struct notifier_block *nb, struct netlink_ext_ack *extack)
> +{
> +	struct net_bridge_vlan_group *vg;
> +	struct net_bridge_vlan *v;
> +	struct net_bridge_port *p;
> +	struct net_bridge *br;
> +	int err = 0;
> +	u16 pvid;
> +
> +	ASSERT_RTNL();
> +
> +	if (!netif_is_bridge_master(br_dev))
> +		return -EINVAL;
> +
> +	if (!netif_is_bridge_master(dev) && !netif_is_bridge_port(dev))
> +		return -EINVAL;
> +
> +	if (netif_is_bridge_master(dev)) {
> +		br = netdev_priv(dev);
> +		vg = br_vlan_group(br);
> +		p = NULL;
> +	} else {
> +		p = br_port_get_rtnl(dev);
> +		if (WARN_ON(!p))
> +			return -EINVAL;
> +		vg = nbp_vlan_group(p);
> +		br = p->br;
> +	}
> +
> +	if (!vg)
> +		return 0;
> +
> +	pvid = br_get_pvid(vg);
> +
> +	list_for_each_entry(v, &vg->vlan_list, vlist) {
> +		struct switchdev_obj_port_vlan vlan = {
> +			.obj.orig_dev = dev,
> +			.obj.id = SWITCHDEV_OBJ_ID_PORT_VLAN,
> +			.flags = br_vlan_flags(v, pvid),
> +			.vid = v->vid,
> +		};
> +
> +		if (!br_vlan_should_use(v))
> +			continue;
> +
> +		br_vlan_replay_one(nb, dev, &vlan, extack);
> +		if (err)
> +			return err;
> +	}
> +
> +	return err;
> +}
> +EXPORT_SYMBOL_GPL(br_vlan_replay);
> +
>  /* check if v_curr can enter a range ending in range_end */
>  bool br_vlan_can_enter_range(const struct net_bridge_vlan *v_curr,
>  			     const struct net_bridge_vlan *range_end)
> 

