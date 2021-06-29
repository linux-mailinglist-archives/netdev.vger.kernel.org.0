Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4626A3B70D7
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 12:40:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233052AbhF2Km5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 06:42:57 -0400
Received: from mail-dm6nam08on2048.outbound.protection.outlook.com ([40.107.102.48]:16736
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232410AbhF2Kmz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Jun 2021 06:42:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ger7fszulIfnIBk+oQIFvJN34OprWvORbTu5+a3/URkvrKuUA+1rciiXqj0Y1anNXECdVPMMCxTYRfpAZdNej13knfB5yVo44N8qJ97Xlc/j9969ZXe2Ph9QzzL8fmUfyaP1e4CGbS9eW3s689KXLiVGoefTV1VnK7X15k4z7J+8tibWCj/KYKkq+NYWaLckQ3CzBY0lnziOC0sXbztRGiUxlE+xk3d8lHhI/Xn8WpOJvpaF9zqpt0kLl58pIGmsQ5O+eYJRlNZjY/HK1pGSo0dAuaWjCxRqmYT+N48TgDgwiMX1/WaKpaLqG+ejq5eHjNHDnu+Z6HGZbh6kYB1FeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uztwsH+y8ocWNq24ncpm1FGSjx7XN+idh/ZpWReFRWM=;
 b=gqMa4aAVeV+rUh/txtZLDLrLQ+rpwc4xTcjCca8ytxsHTB0vATFJd8bcx2OWUZ7PRfGgsuJDRAkUz1OTKywQSLAWRRp5igB4d4p4sDFK1kUuFZ6OyQZEjoEQRjjuY940aszdxGQsuo+l6iXXLyI483l+7RG6E8yQOz/z/Smk1nHiHjyy3/eqPu+Zi+sL7ZHq5huQioTMfNpm67DCQB1oT5rWNnhEqhPpbHRVQbcWkJQsaerRc3LELrZnQMSTEtJ9O4ovJxPT4qTaSRTgpy7HmxjICWbC9ND3aLbDVXJNGvMsXe4vUF3HOvSMDYfSoA4Iup/9gbKmnOIT/Se4FYMtKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uztwsH+y8ocWNq24ncpm1FGSjx7XN+idh/ZpWReFRWM=;
 b=ScxHkzIW75vRv1AaaSGKpbHW3FKJbI42PzR9kPStXk9yOEEy8ZP/akmTeod/bWlfuDRoo21bZRFq8OZZbPTAiDG9rqmJATl8y515n2JiLSfiqly+3qk4+MV+a0GKFzrs5zepx5PieZk3o7SBJ3eo7BpTz7hKtCFOT0jRHnvfSd2WfJzk+u9Kk5kXwrD9SO47kK5fZ3x8VMvwYQ9mS0Fg1OkvgZh0yDvcjmSyBJtg70L+fQXu/t11YW/PoyVrGQOZpXABdofnKCHErwz3S+hqbrKxkgDapO2oRw5nLlNwAMEk16ESYUawbUmzqfedl2BXZgnxLFIdc5K2nBdMdQwVqw==
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM6PR12MB5520.namprd12.prod.outlook.com (2603:10b6:5:208::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.21; Tue, 29 Jun
 2021 10:40:27 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::601a:2b06:4e64:7fd3]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::601a:2b06:4e64:7fd3%3]) with mapi id 15.20.4264.026; Tue, 29 Jun 2021
 10:40:27 +0000
Subject: Re: [PATCH v4 net-next 01/14] net: bridge: switchdev: send FDB
 notifications for host addresses
To:     Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
References: <20210628220011.1910096-1-olteanv@gmail.com>
 <20210628220011.1910096-2-olteanv@gmail.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <984a649e-38fb-9962-e7dd-3cd441a83ec9@nvidia.com>
Date:   Tue, 29 Jun 2021 13:40:20 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <20210628220011.1910096-2-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZR0P278CA0130.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:40::9) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.241.74] (213.179.129.39) by ZR0P278CA0130.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:40::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.19 via Frontend Transport; Tue, 29 Jun 2021 10:40:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7b28810d-30ba-4610-1483-08d93aea4efe
X-MS-TrafficTypeDiagnostic: DM6PR12MB5520:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB5520DB51681BE95454696A13DF029@DM6PR12MB5520.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QWEpLi6dBhPtg0CBG5GKuL5CReSRVvF9vh4cjPldtdT6+PE4BQFM3aOozUVmVwqT/jS+qp557JTo/GvYNUfXTk6+HoBlAJBCxs2//gAYtSuoGmJkMY4BOKZvXEj3bHDClx1ortoF1UeBQVK8HzDkfW4ABLXxdsJDNeXNH0QjewYTW1lOX/jsFt3K61CNKcIRBqrpOWLNK+Ak9CYIwsdA+o0ZlJc5I21Ynl6BJRTXDfB8ZuPzSq5uvC1QDoKpd7WKm87RsyOsHqewSpfR+jcRE+VVFVit2kCdIpRMi35Or5qMBrht7pXllhwg8ZqdL4MBC69Zd9mOFnfxATKDiT+abp+NM4WBBGP93TB4WDYqFIZOPhQ98DmBm4CGzVG39AAj+7WO8Ds+/HVj+V74BoQp6qfYZLCtRQq4ecR0iNFc9/l281S2cVorLkjJQh2HacLSLcci3/DQDNLzL+f6zq747P4BqMF2WlPKTKdP07CClYqHPHcPMi9UiDJPn41Gz4MwgrWDXaj002aLfw0HpWKs+W0vNSITlSBxVTzUKqI5j0jBHhhxZvhu25q233EZBPC/4qEVekWeeYbVqDhZlvNF2bZdd/V8lLkPS2/LxZpocD0f50jjWFkxBcHb1BubzexB73cv7P6asdCm126StghcxZQJuXRph4W1Kyu8JNEtj2FF+U0+hfMmP8p30rIxBM1ors++fQZvFdqPLQCA0bUkHKnDeohPm1I3Oq5c7hq0mzw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(366004)(346002)(136003)(39860400002)(83380400001)(478600001)(6666004)(31696002)(86362001)(66476007)(38100700002)(5660300002)(66556008)(956004)(6486002)(36756003)(66946007)(4326008)(2616005)(26005)(8936002)(186003)(16526019)(54906003)(16576012)(316002)(8676002)(15650500001)(53546011)(31686004)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WjhLWGlrSUZKVG1VNENVaUh1ZGo1Tmd4QzBSVnpKZEhPRU5selY0VWh0WUZI?=
 =?utf-8?B?VFBTRG5YR3NFeVJGZENBYnhJZ0F2Y0FCandLRkhZZitwNko2ZWVVNEJDNVl5?=
 =?utf-8?B?US9CTmhwRnJMV1FkRHFDTVJvS3pPT204UXdVbUNnWVNITTJxeWVGekx0Ymwv?=
 =?utf-8?B?S1Nld05VTThuSEMrY2JRU0k1b3E5TTFSaXpmUlMvdUxtYUQ3WXRWREtDTllR?=
 =?utf-8?B?MkZ6UFA4a1hCaW5ISjlVRlBjaEpGUHJWZjNzMWFqdFV4U3lSYlFzZ0JhbmNL?=
 =?utf-8?B?MHQwejAwelhPdEd5SmtPSHdhdGpFT2VyUlQ5WnJobk4xVzlISFFuVk5UYVVm?=
 =?utf-8?B?M2xLck5iMWdYUGNpa1pUempJd21LS2tkelVkNjNpYko3ZVI3SGRhNU5saFRs?=
 =?utf-8?B?cEZKKzNuT0R0bmdQQS9ic2ptY0hwSklmdDE2UHZpZ0xQTURpV3c1T20xdkJC?=
 =?utf-8?B?UFk1M3QrY2NtejdXQy9pWDFFNUEzUkVkVytaeWlVcWlLMFJVUHJrWDZyeXM5?=
 =?utf-8?B?RkU3ejZHUVZTNUdKT1FxUll0VXdlUy9mNE1QbUJESG5GWEM2bTllZ0huV2Ro?=
 =?utf-8?B?N2pla2Q5aG8wRVYrWGI4R2dBK0xHc2t0a0kzRlY5WTg3aEYxcEVyOTBvWkJa?=
 =?utf-8?B?clJrd3QvZ2xMUzFadDFmdnY5ZzZNbEhIMjEveUFsOW16Y1kxQnJ2TjhvYzkx?=
 =?utf-8?B?SHh5TTNtWjVNV08wZnB3MFJtV2VNdDgrelA0Skl3bFdiUHFrQ0x0ZU9ITWsr?=
 =?utf-8?B?N3NLbDZTVFAvRUR0YUI0MnBLcU9iY0tmUzR1NXlXMEs5bVgvQzI1cXlKS3JN?=
 =?utf-8?B?SGlEQk1PT09pdHF3ZWVONElIeC8xTDVNN3c4SnViY2FyVSs4WnNPT0gwN25M?=
 =?utf-8?B?T1FhS2ZGeG5EandUMHlFU2RyVzNQQlJnSmxWeHNtK3ROR0R3Qm1TM1U1OStk?=
 =?utf-8?B?SXlqVHRIZGF1b1N3R2JSQWpuZm1zT05va2tKamtHa2lZaldMWDZkWTFhL254?=
 =?utf-8?B?S0R5RWpUODZkUEJHZ1Q2RE4rS3kremlJMllSQ3NPTGliOUc4NnJHdzRqNDNt?=
 =?utf-8?B?SytZN0R1dno3MGR5N2pVZG1YeTJod0FUQjNjcTQxR0RKM3RGL0RHR00wZmx6?=
 =?utf-8?B?OFBaRUFpNzFXNmFQUXlYSWVjRURHSmlZMmN1QU0xWFNzU290WDBNUUxRei94?=
 =?utf-8?B?NFJZNU40YzF4UDdleHNET2NmaTQ3K2hnMStNZ1pNdXdUZW9OKzNhbktyekRw?=
 =?utf-8?B?WWFxcThrYk1WanMzZlRMTFovUTBZMWNrWmNBYkEwNXJaaDNsVzFxdlg4WGtF?=
 =?utf-8?B?Z0gyOHhlTGJ1ZjE0bS8yUkRWL2JESHZRU1o1ZDJvOGJPWHlXd1FTZSttOEx6?=
 =?utf-8?B?c3RFNHVsNE8zWktGR0FqTEVTeG1IdWtiSlljbUpjc1Zkd0JBanRqenFpRnVI?=
 =?utf-8?B?ZlVhSDNSdlBJNXRWT3RNREowOVlPSWdhdDVnaFM5bnh2eGkxR25GLzV2SGVi?=
 =?utf-8?B?UWJGZXVtQ01mQy96Z0lsNzQzazZpWE5ZMzJ2TnN1TXhLRytmeXo2bjdpcDBD?=
 =?utf-8?B?S1RValA1Wm9ubXlqY05Nd2NTdmI5T05EOFRnSE16RUM3dDdoRzJLc0xacmkw?=
 =?utf-8?B?djEvQTJlTjBRQ05VK29OVWtjYk56UThNMzJDNUlWVXlVbGNmSStvbWhMZ3FO?=
 =?utf-8?B?VVNJdnNCRURGODRnTnAzVnBXOFB2ekkyMGZ2ZWN4SHd3STNPbGdhRytrQTlX?=
 =?utf-8?Q?m6tk6VAS9UI5cqphqyDz85re57GX/s45yNWST5p?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b28810d-30ba-4610-1483-08d93aea4efe
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2021 10:40:27.3848
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IVMXnQsTtsYsgpujRz68DjiBqrIWrsO1IjlAbinbeWgHjvTppx7fsWnvyC3k9yI3jMSY4ZsAd/nzCmpHKo1ghw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB5520
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29/06/2021 00:59, Vladimir Oltean wrote:
> From: Tobias Waldekranz <tobias@waldekranz.com>
> 
> Treat addresses added to the bridge itself in the same way as regular
> ports and send out a notification so that drivers may sync it down to
> the hardware FDB.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  net/bridge/br_fdb.c       |  4 ++--
>  net/bridge/br_private.h   |  7 ++++---
>  net/bridge/br_switchdev.c | 11 +++++------
>  3 files changed, 11 insertions(+), 11 deletions(-)
> 
> diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
> index 16f9434fdb5d..0296d737a519 100644
> --- a/net/bridge/br_fdb.c
> +++ b/net/bridge/br_fdb.c
> @@ -602,7 +602,7 @@ void br_fdb_update(struct net_bridge *br, struct net_bridge_port *source,
>  			/* fastpath: update of existing entry */
>  			if (unlikely(source != fdb->dst &&
>  				     !test_bit(BR_FDB_STICKY, &fdb->flags))) {
> -				br_switchdev_fdb_notify(fdb, RTM_DELNEIGH);
> +				br_switchdev_fdb_notify(br, fdb, RTM_DELNEIGH);
>  				fdb->dst = source;
>  				fdb_modified = true;
>  				/* Take over HW learned entry */
> @@ -794,7 +794,7 @@ static void fdb_notify(struct net_bridge *br,
>  	int err = -ENOBUFS;
>  
>  	if (swdev_notify)
> -		br_switchdev_fdb_notify(fdb, type);
> +		br_switchdev_fdb_notify(br, fdb, type);
>  
>  	skb = nlmsg_new(fdb_nlmsg_size(), GFP_ATOMIC);
>  	if (skb == NULL)
> diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
> index a684d0cfc58c..2b48b204205e 100644
> --- a/net/bridge/br_private.h
> +++ b/net/bridge/br_private.h
> @@ -1654,8 +1654,8 @@ int br_switchdev_set_port_flag(struct net_bridge_port *p,
>  			       unsigned long flags,
>  			       unsigned long mask,
>  			       struct netlink_ext_ack *extack);
> -void br_switchdev_fdb_notify(const struct net_bridge_fdb_entry *fdb,
> -			     int type);
> +void br_switchdev_fdb_notify(struct net_bridge *br,
> +			     const struct net_bridge_fdb_entry *fdb, int type);
>  int br_switchdev_port_vlan_add(struct net_device *dev, u16 vid, u16 flags,
>  			       struct netlink_ext_ack *extack);
>  int br_switchdev_port_vlan_del(struct net_device *dev, u16 vid);
> @@ -1702,7 +1702,8 @@ static inline int br_switchdev_port_vlan_del(struct net_device *dev, u16 vid)
>  }
>  
>  static inline void
> -br_switchdev_fdb_notify(const struct net_bridge_fdb_entry *fdb, int type)
> +br_switchdev_fdb_notify(struct net_bridge *br,
> +			const struct net_bridge_fdb_entry *fdb, int type)
>  {
>  }
>  
> diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
> index a5e601e41cb9..9a707da79dfe 100644
> --- a/net/bridge/br_switchdev.c
> +++ b/net/bridge/br_switchdev.c
> @@ -108,7 +108,8 @@ int br_switchdev_set_port_flag(struct net_bridge_port *p,
>  }
>  
>  void
> -br_switchdev_fdb_notify(const struct net_bridge_fdb_entry *fdb, int type)
> +br_switchdev_fdb_notify(struct net_bridge *br,
> +			const struct net_bridge_fdb_entry *fdb, int type)
>  {
>  	struct switchdev_notifier_fdb_info info = {
>  		.addr = fdb->key.addr.addr,
> @@ -117,18 +118,16 @@ br_switchdev_fdb_notify(const struct net_bridge_fdb_entry *fdb, int type)
>  		.is_local = test_bit(BR_FDB_LOCAL, &fdb->flags),
>  		.offloaded = test_bit(BR_FDB_OFFLOADED, &fdb->flags),
>  	};
> -
> -	if (!fdb->dst)
> -		return;
> +	struct net_device *dev = fdb->dst ? fdb->dst->dev : br->dev;

you should use READ_ONCE() for fdb->dst here to make sure it's read only once,
to be fair the old code had the same issue :)

>  
>  	switch (type) {
>  	case RTM_DELNEIGH:
>  		call_switchdev_notifiers(SWITCHDEV_FDB_DEL_TO_DEVICE,
> -					 fdb->dst->dev, &info.info, NULL);
> +					 dev, &info.info, NULL);
>  		break;
>  	case RTM_NEWNEIGH:
>  		call_switchdev_notifiers(SWITCHDEV_FDB_ADD_TO_DEVICE,
> -					 fdb->dst->dev, &info.info, NULL);
> +					 dev, &info.info, NULL);
>  		break;
>  	}
>  }
> 

