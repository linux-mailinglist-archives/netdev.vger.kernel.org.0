Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E96F3B9FA3
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 13:17:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231791AbhGBLTb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 07:19:31 -0400
Received: from mail-sn1anam02on2053.outbound.protection.outlook.com ([40.107.96.53]:35157
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231700AbhGBLTa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Jul 2021 07:19:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F8VPIA/7YuMmjYC3yVOBs0jeYo8HqZIBAdBnc625XPKhZZNQZNaXakOLphi6DncBAGGgy7ZOu1v81vjk+dDkignpPvZzT0w2gkkyu2hAAgGOV7QrCpo0t4gPEsNKgCkotEr/zHFW4wmtMJ6ijpMt90qvN2lf394dtETUoUGOD4reaJFwvQEFug7mitYGkEWGc4f/IethnuXyJxr+zKSsJktFwvlItxRlnCOcza1/rtiJUPxWFNxunARzOcWwEP9YRCdrgcvgFBT4OGsCr8glAAQ5p16NqStv6wrbsYxJYifxHUR4xUQk9hbNJJuu0FKxNyJnXOFh+4/RAxWxgHl8bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qd8xLkRCM6SKISMKJf3NDD+yOFlQIiW4imN9nW+F+S4=;
 b=U0kydzJrjBRP3SYCim0j3jzKNcZzr5ckq2GlWc6UFRUyeAaY9rch8O3g2E3v7IXyWTd1QWwEcS+L/mV/FEvTjgvmsfiM8ScEnVS+IMrfsy8zLU6QMIQ2bQAdIWi7WKDbinp5p8PmU+JqJ8v5R9vy3RsmMcXHsFs+1CpCu2KNh1JNd9Thohcwe5Rr1U225dLdPFSkJcOWiu3pzd93iMZm5nzYmVx7L/G2dGwzE8Ej7/cPqDHZenc6SyS4cyhBr3z+qxUxoCRgV70PvNFQ1rOozhcbIx3Y6/hIMSLeEjWFQlWIs8O+Kz7Fpax9+rNvZuXhkFLpqFhlOgDnebKqlKIFMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qd8xLkRCM6SKISMKJf3NDD+yOFlQIiW4imN9nW+F+S4=;
 b=sxU2550GqGlfdYNTgzbfEOglkpjnxVjJWOmG5N6vPeFvC4J+659A/4oPY9v3TeSGxNm/wBRQEGF31OJtpy+em4bhB33YeY236SkFLHqO+Vz5INcwooHcpQmHzJ7RkzXm44Lv4YzyHL13I3MGeOjfKtNl4Nv/FyVe1xhmUTuC1eUljFUyTuvNMtEWBxthUvgtHLG609voO1F1Okf6KmQicfkMEWRhKnk05aMOQAJel6IOHk1Wo0/BJ1XgGL/9FSRk19mnXjhi/tZAIOYsmdZ208DiIzi8OMiEcyjogx4H37lVCASlsw3erTW/bCI8wn92rwqZN7Sp4Abr6hM+oX8Y7w==
Authentication-Results: proxmox.com; dkim=none (message not signed)
 header.d=none;proxmox.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL1PR12MB5271.namprd12.prod.outlook.com (2603:10b6:208:315::9)
 by BL0PR12MB5521.namprd12.prod.outlook.com (2603:10b6:208:1c7::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.22; Fri, 2 Jul
 2021 11:16:57 +0000
Received: from BL1PR12MB5271.namprd12.prod.outlook.com
 ([fe80::31e3:a65f:b29f:6c25]) by BL1PR12MB5271.namprd12.prod.outlook.com
 ([fe80::31e3:a65f:b29f:6c25%2]) with mapi id 15.20.4287.024; Fri, 2 Jul 2021
 11:16:57 +0000
Subject: Re: [PATCH v2] net: bridge: sync fdb to new unicast-filtering ports
To:     Wolfgang Bumiller <w.bumiller@proxmox.com>, netdev@vger.kernel.org
Cc:     bridge@lists.linux-foundation.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@nvidia.com>,
        Vlad Yasevich <vyasevic@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Thomas Lamprecht <t.lamprecht@proxmox.com>
References: <20210702082605.6034-1-w.bumiller@proxmox.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <113d8503-8670-c0a3-54a6-0b18af64632e@nvidia.com>
Date:   Fri, 2 Jul 2021 14:16:51 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <20210702082605.6034-1-w.bumiller@proxmox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZR0P278CA0022.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1c::9) To BL1PR12MB5271.namprd12.prod.outlook.com
 (2603:10b6:208:315::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.241.74] (213.179.129.39) by ZR0P278CA0022.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1c::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.22 via Frontend Transport; Fri, 2 Jul 2021 11:16:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8ec4e2c7-a633-4a53-bb47-08d93d4ae78f
X-MS-TrafficTypeDiagnostic: BL0PR12MB5521:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL0PR12MB55214609829C80A5ABCA44F6DF1F9@BL0PR12MB5521.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sMyNxGKsfm0pltyLY8WmP8F/n3vM3ysTrBpczDryzUvBs3wqBXarEEJwOr/09hOiUdH6PI7k3INUTofE78aLIXy5U1NUOXvtpFw8ZfPkOzZc19fdgTmIKbHATdNAkKuZ+gTLkeFUrbFRVQqNA2zOKkW092SmbvvXrahFbhnzhBjKhas4KrPIrwJ02Tj7hF8SLKptnzLqz9wYEBKZvxwi3TdccBtatu4xd6bhIY5ahOnn3BwJT+0mKal3ATxBGVQPGVFNGli0AyK1lWTIFYU7wZLEVlPw7Uu9XxuRu/svnb6UW4Av2Z+E3tX/0mArW9PiWdpkxyir2y6IlODBiEUwzU/G82OSmeNXe6nMAvzJ80SLSpQbjv4po5bVyPleGcsoz2T6e1Nt3tQu8vd8NjPLOCusH9tQYdIDlWfYSRGYAriYUbfwpUw3FwL5xsbeMEa8541sGW/DWLW5XlPmRtUeoCtcHhB/BRqI+LAslKZmHKTX0JwW+DcO0rwuf8QMssRelxGkzauifhfM1gQpQ1DjYd36bNh1M7avwNFWEov2B9xJ2nZIsN5grmofaYRXKweNVGE2HcHxqgxDdyGRa09h6RMJteU3Pbf9bRlcsDzGcuMPziKQAeNNPQTB2SBb5ZQmE/Ra3RYI6no9DuitoycQOc28ArcjZ4Zm+XrFWdmo2nfnQxJMwzRrvwPPM2R5b2bmi3/wG4oi9ea7unMxdOWZMdQAiT+mVgUG9p7mVYPcneE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5271.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(396003)(376002)(39860400002)(346002)(31686004)(31696002)(86362001)(53546011)(2906002)(16576012)(26005)(4326008)(36756003)(316002)(5660300002)(8936002)(956004)(478600001)(54906003)(2616005)(8676002)(6666004)(38100700002)(66476007)(16526019)(66556008)(186003)(66946007)(6486002)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NHBPTTROd2xqV3F3dTVBdFdCeGQ4aVNPdTllVWR4NWZSL2FhaUN3ak1zUXA0?=
 =?utf-8?B?T1pmTktFbWtob1gyR1FzQU1VVFhUa0srYThUT0lWbkpudU1HSFgwdmhRWnBN?=
 =?utf-8?B?QmRkeU5hK0lxdXROMkQvc29OQWZHcGhLV05Cc3hVc2FQbjIwWWZRZm5EcWFN?=
 =?utf-8?B?dGZZd0hNQlNWUm5XTlZzanJ3blJ0NVBkYnQxUDBKTkt1SlRyRWU5Vy9ySDZh?=
 =?utf-8?B?U2RtakNRY2JQSHlIUkttUnpPenlWZUoxYVpCTEMzbDVNR0VFY2pYNEFlNk5v?=
 =?utf-8?B?dUdLMFNCSGY3Ykk5Wk5sL001dmcwVW9CNkVJRmV0b3NUcTJJSXZ1bE9PajU1?=
 =?utf-8?B?NnZhRjI4U0d1NGZueCtUaWJwWnY5SFBYYkFieUNyREJhYytCcnJ2QVZvU0Vr?=
 =?utf-8?B?R2ltWWEyWU96S3d5cXIzQkFQMk1oRzJMaWdQNUNqSm9lNzlrMHh1KzhxVEw0?=
 =?utf-8?B?NXpGTzB5WVNNakpqNmVkMlFVSXlmNGFTOXJlcTVRVnhuU1JEZ29teFVMUldu?=
 =?utf-8?B?MDVCNjlSZE5HY3VpNE9pL3h2YTZUM2FBNEcxNVJ0SFd3L3NuM2ZUK1pMZ1RD?=
 =?utf-8?B?TFNKZlhyTkNaVnVxa2psSm05MmpkaVpPeTE1NkJ0dUZjaC9kSmNocDZkcUlQ?=
 =?utf-8?B?RmFsT1p6WGdQc01meFZvQ1IrSmxEYS8wakc0ZWhDbmRDQWhqeFpQL24vdEhi?=
 =?utf-8?B?TExYdWVUand1UVZIblZ5NW9OT1orK2Z6MU0yR285andGZHB5UTlsMnphbTZT?=
 =?utf-8?B?MEV6Wks3M25TSHczVnh0UVExeXZYb255S0hPRXFTU1Q5S0xJWVZHUDhTd3dm?=
 =?utf-8?B?WFkyYUdkSDVFc1BLOVJaRGp3OFVSWDM0OFdQK1lUQkpScDI5UkNoQ2liOVhO?=
 =?utf-8?B?WDFOZlZRVHNLcW9LSk8vN2R6V3lxTnBwQ1ZkVEJiVCs0SE9DYlptd3VKUWVI?=
 =?utf-8?B?eXhXWUljaWYzdnE4Z0E5RnF4V3l6MzdrMWN0RHJxUWN0aDhWNkE1UzgwZy83?=
 =?utf-8?B?RjFRaFVEbGJPRlBodXFNYzJhVFAwWVhIK3BSOTV3Q0FaZHdDeDNpMUw5TktP?=
 =?utf-8?B?QUp0MllKcFJZWFJiNGdLWGRDb0xRUWRyU25qUjJ4ek9kTWJJejVydmNJbktp?=
 =?utf-8?B?dzBZMGkyZDZiWmo3c2JOTmFFT0o4RUNOMXdJQXFLckNmYjEwRmhJbncrVlhz?=
 =?utf-8?B?cDJRVGNCbFpldHNlR2RiYUl4SWlKSTdNaWwrU0srRmJaYjdzaVZFU2FZUVcr?=
 =?utf-8?B?SjhYOE1BK3FKRi9IZGRtek0xZVBxdmZFenExTE5uczFpRDZObGVQUjhPeG5w?=
 =?utf-8?B?TVczS3V3RFFGOHNIYkowWHl6VEs3bDArYUI2M1AvaTlRdzBHaUhWWmdaUStz?=
 =?utf-8?B?L0JJbnBTLzFnUzlMUDhTeW5Db1RFY2NoOFY4ck1hSG05VFhDTUpseTVNeGRz?=
 =?utf-8?B?d2NqUjBzdnN6KzlxM0tnaU1oZjhRSGRyYzl4QVpyWFFSeDh2cVJCUXpEcVlG?=
 =?utf-8?B?cGY3UmYxcThwN2JUc0c3ZWVESTQrVU02d29zcFBYVmxROVA0REJLYVc2UDJI?=
 =?utf-8?B?OENLSm1Lb1JVR1p5V3ByMUFNekJzTzB4ZFJmR1pSRDdrUE9VcncxME9CLzJ5?=
 =?utf-8?B?dHZQTGlFTWFiamNHVEFyNlFWK0tRUmYxcFIvcmRPNmtVakFnSDFXVUpVZ0lz?=
 =?utf-8?B?cmNINlBoZHR4bnFscjJNdlRDMTZsa0ZQd0pRNFRWTTRvdEpnOUUvMXh5aHhK?=
 =?utf-8?Q?aur42qYUUmZyYZ6YwjT2KD1FR/aklwU49Bkof39?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ec4e2c7-a633-4a53-bb47-08d93d4ae78f
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5271.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2021 11:16:57.3169
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zMxXaIMJVuVx22bGAZ0oWIszx2Cl8MZA0WrNcZIK5i77Bp/uNmL63d9aA5H4LS5iuVMCB3NpBIESJqQ5G6uYAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB5521
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02/07/2021 11:26, Wolfgang Bumiller wrote:
> Since commit 2796d0c648c9 ("bridge: Automatically manage
> port promiscuous mode.")
> bridges with `vlan_filtering 1` and only 1 auto-port don't
> set IFF_PROMISC for unicast-filtering-capable ports.
> 
> Normally on port changes `br_manage_promisc` is called to
> update the promisc flags and unicast filters if necessary,
> but it cannot distinguish between *new* ports and ones
> losing their promisc flag, and new ports end up not
> receiving the MAC address list.
> 
> Fix this by calling `br_fdb_sync_static` in `br_add_if`
> after the port promisc flags are updated and the unicast
> filter was supposed to have been filled.
> 
> Fixes: 2796d0c648c9 ("bridge: Automatically manage port promiscuous mode.")
> Signed-off-by: Wolfgang Bumiller <w.bumiller@proxmox.com>
> ---
> Changes to v1:
>   * Added unsync to error case.
>   * Improved error message
>   * Added `Fixes` tag to commit message
> 

Hi,
One comment below..

>  net/bridge/br_if.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
> index f7d2f472ae24..2fd03a9742c8 100644
> --- a/net/bridge/br_if.c
> +++ b/net/bridge/br_if.c
> @@ -652,6 +652,18 @@ int br_add_if(struct net_bridge *br, struct net_device *dev,
>  	list_add_rcu(&p->list, &br->port_list);
>  
>  	nbp_update_port_count(br);
> +	if (!br_promisc_port(p) && (p->dev->priv_flags & IFF_UNICAST_FLT)) {
> +		/* When updating the port count we also update all ports'
> +		 * promiscuous mode.
> +		 * A port leaving promiscuous mode normally gets the bridge's
> +		 * fdb synced to the unicast filter (if supported), however,
> +		 * `br_port_clear_promisc` does not distinguish between
> +		 * non-promiscuous ports and *new* ports, so we need to
> +		 * sync explicitly here.
> +		 */
> +		if (br_fdb_sync_static(br, p))
> +			netdev_err(dev, "failed to sync bridge static fdb addresses to this port\n");
> +	}
>  
>  	netdev_update_features(br->dev);
>  
> @@ -701,6 +713,7 @@ int br_add_if(struct net_bridge *br, struct net_device *dev,
>  	return 0;
>  
>  err7:
> +	br_fdb_unsync_static(br, p);

I don't think you should always unsync, but only if they were synced otherwise you
might delete an entry that wasn't added by the bridge (e.g. promisc bond dev with mac A ->
port mac A and if the bridge has that as static fdb it will delete it on error)

I've been thinking some more about this and obviously you can check if the sync happened,
but you could avoid the error path if you move that sync after the vlan init (nbp_vlan_init())
but before the port is STP enabled, that would avoid error handling altogether.

Thanks,
 Nik

>  	list_del_rcu(&p->list);
>  	br_fdb_delete_by_port(br, p, 0, 1);
>  	nbp_update_port_count(br);
> 

