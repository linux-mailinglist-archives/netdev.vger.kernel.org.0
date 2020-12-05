Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C51322CFAB4
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 09:59:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727855AbgLEI6D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 03:58:03 -0500
Received: from nat-hk.nvidia.com ([203.18.50.4]:13957 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726206AbgLEI5p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Dec 2020 03:57:45 -0500
Received: from HKMAIL101.nvidia.com (Not Verified[10.18.92.9]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fcb4b5b0000>; Sat, 05 Dec 2020 16:56:59 +0800
Received: from HKMAIL102.nvidia.com (10.18.16.11) by HKMAIL101.nvidia.com
 (10.18.16.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sat, 5 Dec
 2020 08:56:59 +0000
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (104.47.37.55) by
 HKMAIL102.nvidia.com (10.18.16.11) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Sat, 5 Dec 2020 08:56:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nNDYU1vkVzanjuEZenjFzeBy8xRMn9yvBbcbvQ9FgJGIcr8OLYaNcECY1mr34CrG50kwWQB4s0cxIYPS4mMbZG7hW9RPZaK3AHQd1ELnKNJt/QEqF4T7lcJ1jmDjpmREr+ifu+1WeB2NNFXP6BjovxkwG+nNuSvceT0HqStAro9h6Izpn0dEhD0q4z3y0MS5+qIKfNs5/mkr2qUrJIqNAU/z4ORyQU8Vc+wrnRsCTfQGTbeqHL0KvZGsfdH4IIO1NLXFL7IQ78/bvjnYT3n3xpanGC27Tc9zG03A0SH+fRGm9CAWcRJnUoT3JwEnnMWxGX1MgTAxiEv0S5lqbwS5nA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PDqkbuMglZcW4bQP6ZepiUbAcvVq4qTwQiNmYFLzT6M=;
 b=MLZ5exhUpoxy5wyFRN1+MtbIXjWsP4+D0hfo7Y1hMqoVQxVCbOo1WvGUUOVUOfj4Nv6K6VQGs58Q8+h6rhU3WAz++hmsVfC/eBOL/rUsXRNNtJk+aQYglNwu/Z/qtEfIEM8u65hdwoCEPKs+YVY5aAphtHdWcKZ5W3nkICorazV8hItOL8LZgUvLrSEAvQPjQDU/dgoLtlGFdI7X/XNYDcV8LyidnPLvPL80YH0BebC5frjTbi/DdoOplhys3SmBsHQj83RjGuE7NXvCqDN1sfrorPnoW+59qM8wajyDDmfOI2T/gFC+sfgIbWbvL91Zp8n2uJlgYemG+ia5m2PUMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM5PR12MB1356.namprd12.prod.outlook.com (2603:10b6:3:74::18) by
 DM6PR12MB4862.namprd12.prod.outlook.com (2603:10b6:5:1b7::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3632.17; Sat, 5 Dec 2020 08:56:53 +0000
Received: from DM5PR12MB1356.namprd12.prod.outlook.com
 ([fe80::3cc2:a2d6:2919:6a5a]) by DM5PR12MB1356.namprd12.prod.outlook.com
 ([fe80::3cc2:a2d6:2919:6a5a%6]) with mapi id 15.20.3632.017; Sat, 5 Dec 2020
 08:56:53 +0000
Subject: Re: [PATCH v3] bridge: Fix a deadlock when enabling multicast
 snooping
To:     Joseph Huang <Joseph.Huang@garmin.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        <bridge@lists.linux-foundation.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20201201214047.128948-1-Joseph.Huang@garmin.com>
 <20201204235628.50653-1-Joseph.Huang@garmin.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <f16d76ed-5d93-d15b-e7da-5133e3b6c3e7@nvidia.com>
Date:   Sat, 5 Dec 2020 10:56:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
In-Reply-To: <20201204235628.50653-1-Joseph.Huang@garmin.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [84.238.136.197]
X-ClientProxiedBy: ZR0P278CA0036.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1c::23) To DM5PR12MB1356.namprd12.prod.outlook.com
 (2603:10b6:3:74::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.104] (84.238.136.197) by ZR0P278CA0036.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1c::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Sat, 5 Dec 2020 08:56:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6b6d23ca-ed15-45e9-e6b3-08d898fbb632
X-MS-TrafficTypeDiagnostic: DM6PR12MB4862:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB48622D3449958D4AC3C6624BDFF00@DM6PR12MB4862.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VGL6kQRxe2z6yww2rXZlQc7OzOxZiButBAtqnfNA+9qQc+IleKHSNUJavFwVtxqU7ibIiiepyUJHSoD+70p49MNuOD5anY8rCTHirRBjrrgwLAeEcFjemizhDNaAwjhQmN9vMBnudW3RgqPNg+jur4Tx6mnVVLj1OFQvSSkf4xNpUlxiAyeh1akgOPwsZxaz/KwUAQFTM7REykqEcXz/Mum8qfWB3ylB/PjFrSXNV97TAZfneglcUvqGsrep/2UpMjl5Ucy0ks70CcwdkbHL0dUmH9mw6iBpPaFCnCHfX1Yb6FMRCRrsf6+0arkFAX+ZP4wkfipuGME+P7KZYUCTSB1UBI+kPRipnZfL6eVTx9CtBj3JFTk2lYzhD72QUAhFQqx/3QqONSdnW039M7MFHZ4EEnJqX7cE0mYtLgN4A9M=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1356.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(396003)(39860400002)(376002)(366004)(478600001)(66556008)(66946007)(66476007)(31696002)(956004)(53546011)(5660300002)(8936002)(2906002)(186003)(26005)(2616005)(83380400001)(8676002)(36756003)(6666004)(16526019)(6486002)(16576012)(316002)(110136005)(86362001)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?WGxwVkp2OG0yRXpKRldoOWFCMGZKY3JQUzJPeklFSmpnNnVhNGF0dXpXdE5R?=
 =?utf-8?B?YStjRUFTMmxvdGlNcUx3THltRys4dDZkRTZOaEZOZXZ6N1JTSHY1QTMyN2oz?=
 =?utf-8?B?SVY2U3BmTFVNcHlxM1dPZGRCa3IzL05lcFNZdlRPYk9oenYvSmg4SSt2ODVH?=
 =?utf-8?B?YnBWbHR3YWZIZWZoOEdYMkFRWldET25vWHdDeEwzbEUrUWh4UGdRbm5Ma1pF?=
 =?utf-8?B?a0FhSFFFdVdIRTRzV0VFU1pselR2dERQRklYeUxLMW03YmkwaEFLc2ZyWkxn?=
 =?utf-8?B?UkxSNFF5Q2hTL2lWVHlnbkdSRHBMalpOVm9JOXNGVGlxT3lNU09sMklNNTh3?=
 =?utf-8?B?bTlLc2I2MTdkRUxlcks5Zzd1bUlEV0Erb3M1YndyVHNtd0loUG1CN0x2OE1U?=
 =?utf-8?B?ZjczN3lOMndHNnhNUHF1OXhxWHI3aU54V1lYT2loa3p1MmdUWmxsZ09EbWdD?=
 =?utf-8?B?eEYwc1RBMi9PZ2lWT0hmTEFod09laERzLzRucno3OUtEdmgzUzY3TW52RkZl?=
 =?utf-8?B?b2RmeWdIczVaU29rWXoxOUJYYk84YWtGbndjaHVCckZteFplZHIyUndLc2tJ?=
 =?utf-8?B?NU1CVndyY0tzS2lXL21oNTZnV1JUL3I4NlkvM1VOTERuQ0tvMFo1R3BmdWFm?=
 =?utf-8?B?a1BxUFh5UWV5U1lqU3N5c2RRdU9zc05KTXlzMUJSSnVnSytCTTl5TzRuR3d4?=
 =?utf-8?B?NUM1NTVTSmIyNTJHMVZWVHF5ekpsRUY4eTNXZFErVWRMTHk0cHlSZEIvL2l2?=
 =?utf-8?B?TXRZSkRTd3NqR2NTZ21sT2RacmdvdEM0dzZZTXpoaWFPWEJFcWNCT3BHRzZa?=
 =?utf-8?B?Y3lOMVhrMjdIQTUyQjFwSEdSUGFCaEtKMEhsOEFFTE9PS1hRL29aYTk5cDhE?=
 =?utf-8?B?YTYxUXhYd21YRkhyeGFqMGhaUW10NWQ5OExRSWtuR3czWTdSWGwwZXJrbHhm?=
 =?utf-8?B?NFVjcmpPTXhxLzFCcVpXQzNsSFhzbXVDRE1oUkovc0Y4WHdZL2ZxY2p6ZC9F?=
 =?utf-8?B?VUgxTFRiMmlGREllTTd2eUs4QkV4ZHJ2OE5wQmd0Z3pWaC96aVdVeHQya2RU?=
 =?utf-8?B?WFBHT2VzamxJRWdyaFkzRk1vUmJZcmUzMWZ0OVpaTVhxZlI5cTRpM0ZHbVFa?=
 =?utf-8?B?QytyRE9CZzdCN1VWL284cytDYUUwRENRMjdmLzVxbC9mTVZab0FBNS9ZWjZX?=
 =?utf-8?B?N3dubFVWcndHeHFpNE8xamVuRERlMENBOEZMQSthalhqTlBvUHQ5Zm05Tm04?=
 =?utf-8?B?cHdvQSt3WXM0QS9KQXRjejRwR09hR1djd0pnbGh2VU5uVDZZeU5JQURpTDVT?=
 =?utf-8?Q?YJY7o/JTXM109iwW87i52QmXJ50tf6CP4c?=
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1356.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2020 08:56:53.3367
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b6d23ca-ed15-45e9-e6b3-08d898fbb632
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5X8ICCC9kt7vDvqD0DOM24f1OMwPV2spmDM3MqCaU6haKnCvHQbrjr0DVZdma8da81gEkE8MlOl0S1umacUTLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4862
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1607158619; bh=PDqkbuMglZcW4bQP6ZepiUbAcvVq4qTwQiNmYFLzT6M=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:
         Authentication-Results:Subject:To:References:From:Message-ID:Date:
         User-Agent:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy:
         MIME-Version:X-MS-Exchange-MessageSentRepresentingType:
         X-MS-PublicTrafficType:X-MS-Office365-Filtering-Correlation-Id:
         X-MS-TrafficTypeDiagnostic:X-MS-Exchange-Transport-Forked:
         X-Microsoft-Antispam-PRVS:X-MS-Oob-TLC-OOBClassifiers:
         X-MS-Exchange-SenderADCheck:X-Microsoft-Antispam:
         X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
         X-MS-Exchange-AntiSpam-MessageData:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-OriginalArrivalTime:
         X-MS-Exchange-CrossTenant-FromEntityHeader:
         X-MS-Exchange-CrossTenant-Id:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-MailboxType:
         X-MS-Exchange-CrossTenant-UserPrincipalName:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=ovYiF2rs5Bgz1s5BpmEmhAPe2FCIJX0iNHcVacewMKZqVYsuMPkLm6ruofjXVPiUQ
         gESNY2nzOlcv++DA8KaU7EAVLet4wzJkA7N+3/ImxfB81pxpifffZnHREvEptTQdgT
         GEJ0t5iGZN2RZu8Jsi2OUXtBlrP8zoeZK88VI3mbVA7GJYqdypgUTbHdKXPJrNHSFA
         P5xYcaI0pIhpZOkkZpPRhlztWcvoRE8UoQK4ecQAOva5Pq2rgID9Stacnq4Q9OmznN
         AjyRBk1WwenfEbl1OcvMT+01lisRESLJl9eu2MGeXWLVhW2L9CGvC8w5WowsblrG4M
         EogAL/teB/tkQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/12/2020 01:56, Joseph Huang wrote:
> When enabling multicast snooping, bridge module deadlocks on multicast_lock
> if 1) IPv6 is enabled, and 2) there is an existing querier on the same L2
> network.
> 
> The deadlock was caused by the following sequence: While holding the lock,
> br_multicast_open calls br_multicast_join_snoopers, which eventually causes
> IP stack to (attempt to) send out a Listener Report (in igmp6_join_group).
> Since the destination Ethernet address is a multicast address, br_dev_xmit
> feeds the packet back to the bridge via br_multicast_rcv, which in turn
> calls br_multicast_add_group, which then deadlocks on multicast_lock.
> 
> The fix is to move the call br_multicast_join_snoopers outside of the
> critical section. This works since br_multicast_join_snoopers only deals
> with IP and does not modify any multicast data structures of the bridge,
> so there's no need to hold the lock.
> 
> Steps to reproduce:
> 1. sysctl net.ipv6.conf.all.force_mld_version=1
> 2. have another querier
> 3. ip link set dev bridge type bridge mcast_snooping 0 && \
>    ip link set dev bridge type bridge mcast_snooping 1 < deadlock >
> 
> A typical call trace looks like the following:
> 
> [  936.251495]  _raw_spin_lock+0x5c/0x68
> [  936.255221]  br_multicast_add_group+0x40/0x170 [bridge]
> [  936.260491]  br_multicast_rcv+0x7ac/0xe30 [bridge]
> [  936.265322]  br_dev_xmit+0x140/0x368 [bridge]
> [  936.269689]  dev_hard_start_xmit+0x94/0x158
> [  936.273876]  __dev_queue_xmit+0x5ac/0x7f8
> [  936.277890]  dev_queue_xmit+0x10/0x18
> [  936.281563]  neigh_resolve_output+0xec/0x198
> [  936.285845]  ip6_finish_output2+0x240/0x710
> [  936.290039]  __ip6_finish_output+0x130/0x170
> [  936.294318]  ip6_output+0x6c/0x1c8
> [  936.297731]  NF_HOOK.constprop.0+0xd8/0xe8
> [  936.301834]  igmp6_send+0x358/0x558
> [  936.305326]  igmp6_join_group.part.0+0x30/0xf0
> [  936.309774]  igmp6_group_added+0xfc/0x110
> [  936.313787]  __ipv6_dev_mc_inc+0x1a4/0x290
> [  936.317885]  ipv6_dev_mc_inc+0x10/0x18
> [  936.321677]  br_multicast_open+0xbc/0x110 [bridge]
> [  936.326506]  br_multicast_toggle+0xec/0x140 [bridge]
> 
> Fixes: 4effd28c1245 ("bridge: join all-snoopers multicast address")
> Signed-off-by: Joseph Huang <Joseph.Huang@garmin.com>
> ---
>  net/bridge/br_device.c    |  6 ++++++
>  net/bridge/br_multicast.c | 34 +++++++++++++++++++++++++---------
>  net/bridge/br_private.h   | 10 ++++++++++
>  3 files changed, 41 insertions(+), 9 deletions(-)
> 

LGTM, thanks!
Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>


