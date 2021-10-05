Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94A514221A2
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 11:04:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233543AbhJEJGX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 05:06:23 -0400
Received: from mail-mw2nam08on2048.outbound.protection.outlook.com ([40.107.101.48]:4097
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232167AbhJEJGU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 05:06:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QkfrGhzRYm9G0nyt1SyGX42BZGzb/+H4qFPyapC4ACUVFVz3wq0809Z3KPqZx9ufPHJ8RE/oMLtht1v8rAh2l8gPlKeCS7H/IGXoNZN5lBB27giUP9ZKE3XXThouULYNPxD2xC3Vuuux/s9GtVMd3dPqnpzGLxs5FiyErsqJ+P9x4D+LcaDWpaSi3KyYp+Cl6tsx6SXtkC6f2QuXBOEK7oxJmg6c7T0ifOChhoU3ZTMhAcjblyD13jI8C4rIxoXS75HUDFiBnN/IzNh6bCq+VM2PeAnUdkxRt+SpQoeTvIzityN5RG3aB5+32k8oBlWiB6t+h4j9EyqHaHyTs59qzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=si/Bw3VqS4UhH7jzdwCilGNhPPgx8hzG1KMxKq2TAGM=;
 b=ZgR7sm+RszzRN6pL5h0B9xSuH3RCO6205DJwLkwebaTLSo8FTYduJxmFEtIqKvT9RtbLIyLTORvNulAz/+F8ZRAbQB1a9mEe6neNRJzc2kG6tQZ0au8U3zOdKC+aCuDlc+qccD9omdxdk8Wa+TEB0E3eVaSIjUkFXHTkdF5Ff1hOpjNIveCcas8GJK1Tw6jF8txhSxQ7PDPYCC2FhsOBi9zC/w8BILX8ruskniZ6uRkJvQYj/30mzoFMGOSnyOXwRtOYAcKbrqsrZ7gcjm5oAxvAfTmq8MuRO0yEA0EAoeyFnSBAY7B8jz8RTE6CzKY2KXGqlHaZGQYdnFwynELLqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=si/Bw3VqS4UhH7jzdwCilGNhPPgx8hzG1KMxKq2TAGM=;
 b=B5KEFH3PCGv1uA3pSI+hJWmYY/n0kngH6ZrMdqabKVdxGOiUxcuHTFhLyRneX1CTy78BwPVMIOaR3MlsGF484HkB/hUcCaVuqntr5JHazWt4TaZR1pttQKtCU4Yx+5qSsO3aP78xGV2Z/R6Fmdm5AYX27BsBi/qFTqqbqykhE86HQz+Kf+oCCDTreGXG64DGCvGrRPXOqZtSofg4Ro+Y09V3RaTzig7IrY8sBVPksNKVK1OlvenSY3GCEqDkZRA/0UaIgwZjpEBnroXobhA8rJ3vafmdlhNZBzHjWxIxoTrBWLy3MBXomLqTqF2b4NTHdg33D6ZVrP/OIOvBdKrrqw==
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM6PR12MB5567.namprd12.prod.outlook.com (2603:10b6:5:1ba::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.21; Tue, 5 Oct
 2021 09:04:28 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::513c:d3d8:9c43:2cea]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::513c:d3d8:9c43:2cea%7]) with mapi id 15.20.4566.022; Tue, 5 Oct 2021
 09:04:28 +0000
Subject: Re: [PATCH net 2/2] net: bridge: fix under estimation in
 br_get_linkxstats_size()
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
References: <20211005010508.2194560-1-eric.dumazet@gmail.com>
 <20211005010508.2194560-3-eric.dumazet@gmail.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <1f9eac11-cf42-68a4-632d-ce39677d9aac@nvidia.com>
Date:   Tue, 5 Oct 2021 12:04:11 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <20211005010508.2194560-3-eric.dumazet@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZR0P278CA0082.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:22::15) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
Received: from [10.21.241.239] (213.179.129.39) by ZR0P278CA0082.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:22::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.16 via Frontend Transport; Tue, 5 Oct 2021 09:04:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f7fdde88-c16d-440f-b5f9-08d987df229c
X-MS-TrafficTypeDiagnostic: DM6PR12MB5567:
X-Microsoft-Antispam-PRVS: <DM6PR12MB5567A05C82CF4463F83398A0DFAF9@DM6PR12MB5567.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FfHT6z9Ql1zPouyPMiW99X47JhGoKWYDZ0PNN+4af/61zaGuXx24JxWW8ardtN9WPTBgUcIARqqraouyazu6cqRqGuamD9B/y1z5WpDhzn7MxPt67304guoAr/blP6RpuU1684NKzHKHjP3+A1Ao6IPXY7EJ1okqAoEOmU9bGkXWyuQBY9P1beM0TZg8aL0g2EcH9CPeQMoy501azpq++F9MQ0eXHxV/U+YE5M2MKeAonf6cRNzEUuBtFFff3NO4v5cMvGtJHFDhuhTDG7yYrKYEnRilNfKW06ybv9CQ1PWimNPoMNJyWK2xGOiOiNp4BxQL8DBEjof9ErCdXu/sGV8IbwnAM8hbvuEr+fFkwGNfUOA7qFpPKSX3aEnRr9RoT3efN2IsSMM6xunn5uLFLRh0pXgx0MtzG+wlbo2nSVGtXXfAo5xfQd9Y8aDI2PUUuhzg1KSulKOcrXsOm+2EIoqMxpq4tilUNS+lSSZjQkeZU0I1ABCXYv0oX2Qnd9uEmbzrMOFOC1n530YydBqpfMYNs1/P9MFoZQx3XTkspgPwTQNqzJUa3wK6f4KTqGsi7cdn6xuDoJjWzm9seFl7mkkXmaVR+/U4r14b2AG8Em3FiBBLO1+Uz0IpdbQJWZscATH17fOYVQJzwdVuwRNBsGdVnbShNYyv8DzrNp/CJGTtKO4vqq+9GQQYozldp78WNONwtHcipKanzN60e2oOCFax7hGCRdfEqvzvRfL5/ks=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(31696002)(53546011)(16576012)(66946007)(86362001)(6666004)(316002)(110136005)(38100700002)(66476007)(66556008)(36756003)(31686004)(8676002)(2906002)(508600001)(54906003)(2616005)(186003)(956004)(4326008)(8936002)(26005)(83380400001)(5660300002)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aUhEUExyYmZabkxDa2RDYkZ5V250d3JsdmM4UFUvU3dkV2pDdHhCSUxtd2NR?=
 =?utf-8?B?QlRKNlI5cFVoMEh0bXg2TzcrYUpuWStqSG16andaZWRFS0wyOEU4dWJkRC9M?=
 =?utf-8?B?OFNxbk9UdlRXbUkxVzI5T1gyK1lrby9lNnErdk9KUWFPK1I3bUMySEloT21C?=
 =?utf-8?B?WE9BMHd0YTBSYytQMjhlZmtCS0pVNzdFcDdibGxNQkwzODRReFFDZVp3TWg2?=
 =?utf-8?B?Q0E5K1dxWWJ2UHgxWkVpTk51aEhraCs5NFNqdXBKd3cvWXZCWXdZSU9lZFRJ?=
 =?utf-8?B?SE1yKzA1ajBOMTh4aEZnd3o0bnZla1AwOVdKWnlaSGpZd0Zycm5NVEY3ME1p?=
 =?utf-8?B?ZGh5d1pJRDJiVW5ha2hid1JqUTd2VFRvbHVZdERYNldnZVJZQ04vMXplQ0lX?=
 =?utf-8?B?T1FTYVF5RVM4b1ZwYjR0MXpRMlFMMGh0TkpBdjd2UkE3R2JpRjc0aGRlNUph?=
 =?utf-8?B?YUtTSlprTWx4ZFF0aGlhanUxSTVrS3h2ZjNwWmY5Mzd2ZnFXY05hT001SmYx?=
 =?utf-8?B?N3dnZ21nK21BTEQybG96KytDM1NXN3JwNTZ2U2tCcXExSjI4MTBjOCs1NENY?=
 =?utf-8?B?QlNrNjhwY1FLMkdWM2xINEU3YWpoTzFMMGJBaG9yd0Q1c3ZCdkh3VkRJSGNN?=
 =?utf-8?B?Y2pvdnh6R09Cd3dmeVRGdkg4K3R6azg5RUk3VWdZTXIwZ240ZkZRNHd1aVQv?=
 =?utf-8?B?bHNrUFBYbEdiTmdJZWQ5OEVZVEVvUHhXOHNKRnZnaS80UENTb3FKY2dHdDFP?=
 =?utf-8?B?VVI5WXFzQ29ldHVaTm1MZjhaU2RPRWNmN2VFOE5nd282VTFpZWZ0Yk93L0lO?=
 =?utf-8?B?Kzhwb2tUUyswanY5Q1ZMOUZHazNZS1pUQlZWZmJjR1pnNjh0ZlFITVRpUldn?=
 =?utf-8?B?WUpBelNjbW1OY1VJY2ZkWWpWS21LbXNnNUxrTWMwWXNpeHFFOGVsU2hwczh3?=
 =?utf-8?B?UnphL3VIbnprVzZteGZlWkJvTWsvZzJ2b1ZlUG1XeXE4MUtyQklPRXlFd2Fm?=
 =?utf-8?B?Y0x0MndPZTVob2xPejZLQ28yZVdBZWU5SlBpNUczRXF5RDhYcXZXWUVsTVk1?=
 =?utf-8?B?ODRNbzNBT2MzNFY4KytGUXdZME5TMUxoaG5nMlpPUW9PTy8yTlpDVVd5LzlY?=
 =?utf-8?B?b2ZQYS9zeWdsL1BWWmtyT0RndUxLRkJoU0ZyQkdBNTVXZ2lpREhobEZaNTJq?=
 =?utf-8?B?Q21ZZTEzWHdUdEczSllnS1JjU0lBek5LNlE3Tm5ucHZMY2M5WWNWWGZNOXNJ?=
 =?utf-8?B?aWhGY09LUE94c0NmcTFsSE5LVG92YnZ4MStoeDBKU0s1ZGpmTTFMUnpxL2di?=
 =?utf-8?B?Z1JZa2ZHYWFBcmN6WFd2RFZUdUNob3ZkVlFCZ0ZGVjdzNmRKKzhzNkp6eWkw?=
 =?utf-8?B?VjJUbzNGeVdqSDBETGMwNTVFckFzVWJyd3c0M2pYMVozdVA2SlBSTDJEcVlZ?=
 =?utf-8?B?WWtEY25JVXBEdmNrVWtVQWthTHJBWWlWUXVWU2V2d2o3YllGVWhkakN1REU0?=
 =?utf-8?B?OEYxZlpVVnIydDZrVStVL1RKR1VQaUw0dGRrM1JabURNRFg5cmlsQ1pRRjJq?=
 =?utf-8?B?dEtiK2IxWDZ5U2FqRGZzZEFEQzY1eEhjNE9HYmZYLzd3VHVja0ZidGxsSWtt?=
 =?utf-8?B?cGQ3N0dsbklNZmlqcHU0d1RsU0paZHdrUEpHNjgzcVBZNUlPT2tEblVKSUJU?=
 =?utf-8?B?OFJENytqbm1IRHkwbkttZGI1UjBWOHhmcS9XR3VlVVd3TTJwRFg2cTZIcWwy?=
 =?utf-8?Q?tBYGrU6khsHEnUV0DVmdmRXXQ4HZWl5o2NrD7EI?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7fdde88-c16d-440f-b5f9-08d987df229c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2021 09:04:27.9898
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f3y5UjVSJ278eFOu+VPmVrlg+pVwl6tb4r8dalQ24/jQkQ4d+mObMmIRRP8dB6akjamH26+8DZet/tqL6nN0OA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB5567
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/10/2021 04:05, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Commit de1799667b00 ("net: bridge: add STP xstats")
> added an additional nla_reserve_64bit() in br_fill_linkxstats(),
> but forgot to update br_get_linkxstats_size() accordingly.
> 
> This can trigger the following in rtnl_stats_get()
> 
> 	WARN_ON(err == -EMSGSIZE);
> 
> Fixes: de1799667b00 ("net: bridge: add STP xstats")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Vivien Didelot <vivien.didelot@gmail.com>
> Cc: Nikolay Aleksandrov <nikolay@nvidia.com>
> ---
>  net/bridge/br_netlink.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
> index 29b8f6373fb925d48ce876dcda7fccc10539240a..5c6c4305ed235891b2ed5c5a17eb8382f2aec1a0 100644
> --- a/net/bridge/br_netlink.c
> +++ b/net/bridge/br_netlink.c
> @@ -1667,6 +1667,7 @@ static size_t br_get_linkxstats_size(const struct net_device *dev, int attr)
>  
>  	return numvls * nla_total_size(sizeof(struct bridge_vlan_xstats)) +
>  	       nla_total_size_64bit(sizeof(struct br_mcast_stats)) +
> +	       (p ? nla_total_size_64bit(sizeof(p->stp_xstats)) : 0) +
>  	       nla_total_size(0);
>  }
>  
> 

Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>
