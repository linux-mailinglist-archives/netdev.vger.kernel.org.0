Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A49FA2F9ECD
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 12:54:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391157AbhARLyo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 06:54:44 -0500
Received: from nat-hk.nvidia.com ([203.18.50.4]:45056 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390866AbhARLyG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Jan 2021 06:54:06 -0500
Received: from HKMAIL102.nvidia.com (Not Verified[10.18.92.77]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B600576b30000>; Mon, 18 Jan 2021 19:53:23 +0800
Received: from HKMAIL102.nvidia.com (10.18.16.11) by HKMAIL102.nvidia.com
 (10.18.16.11) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 18 Jan
 2021 11:53:23 +0000
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.40) by
 HKMAIL102.nvidia.com (10.18.16.11) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 18 Jan 2021 11:53:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NTY5Tg+OCiLHKL8LgfJHNDmUIOs2KKFTNbVAZM+VOfZfVlrW7oHt4KXfxnqVpYpx35v6n4cqkllRq7ZR75xeGKw0LX29At1xjimFsLQcB00k9FiWYP9BjwtcuCnDXvqMO3WgDDEsoeuScWqs2yjBhTODe9lIbtUQUkeIjX9sS6fpq86r4QLvPf8ZfDDvr7EWOmkMgBAThENfY365humzcWs555r9Mi7mnVcIpX28ZjmofRV/JInjfiwtqdYq785oyFS2qISlNGedJraRq2GcMnb5kjRhtjkn6JNKlxYOy+ou4/9RXYeY2895Ml64w04uC2jP8zIS206LNpGN2wSpig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4Vm7Hkswa56DY+yAtX2oNmnN888f4LYixzf+BYvI4lQ=;
 b=GjRo/wvTvkLZvZ75B+WVsSXKVwLenHEgYKl4FtBZWMMnW+P1PFjMX6mVgPYHQLOaqMBnCdyTpJ9xP2kDntEA3NvBCasRY3DJi0bEeYEaoPNF+P0tiHSGTiSKXcOjoB7Z3cydAmkip4enxeopn1hEsohETGgRvJItMyVVh4me5YgC36GcCkPM1FC21oHVOlMJ4XuOJm+yjGWrfDLif2OTaZAruaeZShPeGdJzeBtEerjaLGbm7SsQnf2Q4Bw0JiZFRRekmx/zZnly/vDTEn1iRypeACkc0OJ9YuTRn1f65WRn6mZzQNj7SmDbTFSKMW1YQNvjJX76O4pPDE2oEhCheg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: lists.linux-foundation.org; dkim=none (message not
 signed) header.d=none;lists.linux-foundation.org; dmarc=none action=none
 header.from=nvidia.com;
Received: from DM6PR12MB4403.namprd12.prod.outlook.com (2603:10b6:5:2ab::24)
 by DM6PR12MB3339.namprd12.prod.outlook.com (2603:10b6:5:119::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10; Mon, 18 Jan
 2021 11:53:20 +0000
Received: from DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::6:2468:8ec8:acae]) by DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::6:2468:8ec8:acae%5]) with mapi id 15.20.3763.014; Mon, 18 Jan 2021
 11:53:20 +0000
Subject: Re: [RFC PATCH v2] net: bridge: igmp: Extend IGMP query to be per
 vlan
To:     Joachim Wiberg <troglobit@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <roopa@nvidia.com>,
        <allan.nielsen@microchip.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bridge@lists.linux-foundation.org>
References: <20210112135903.3730765-1-horatiu.vultur@microchip.com>
 <32bf6a72-6aff-5e36-fb02-333f3c450f49@nvidia.com> <8735z0zyab.fsf@gmail.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <b54644f6-b559-b13b-adf8-d95f7b2a6885@nvidia.com>
Date:   Mon, 18 Jan 2021 13:53:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
In-Reply-To: <8735z0zyab.fsf@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: GV0P278CA0021.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:710:28::8) To DM6PR12MB4403.namprd12.prod.outlook.com
 (2603:10b6:5:2ab::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.240.90] (213.179.129.39) by GV0P278CA0021.CHEP278.PROD.OUTLOOK.COM (2603:10a6:710:28::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9 via Frontend Transport; Mon, 18 Jan 2021 11:53:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 711ddefb-daef-4724-facc-08d8bba7a6b6
X-MS-TrafficTypeDiagnostic: DM6PR12MB3339:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB3339F05C747930584F206128DFA40@DM6PR12MB3339.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vexNIaZ8+c0lhEwx0tr3RCduen1xftLWUgrT2ClVHltldH//VpqKmeRorwT+j92n9iQvR31PwDhGI0HdPGmkugO+js8277VH1el+KSc0AFku2jGkaL8qDiDqi/RX8bMFcYD+I5zw8UitT/str7NjASNL5LNchAQoM6z4CpadUcZZLe8z4zuLdAz7h3NhwOoMSdme/nPehT51XFpQJ5fcoqogCmvZNpSK4cB5sSRERgiIayi+bcxiOCDuHXlONbd6Hqtq7ND7k3cF3A9iQVl7wukgQelWeP/KcuzJpVTGmqG2jCuLnBx0LViXo5HDdQId0C7qre0RhfPfd2plj7UPjHF2+/lZI5MA8ATPf6j0I+TvFZeDmWQzSUvtv9keZm8Nu2wBACkAebs13NowqS7QmDeROiH4LOItv/Jkfak1/OwAZUwHFPtjqbexekBoDcx9tgO/XZPvbqtIQ/iBvG5h7u83uxEAhg8U6p0NSggQcYW0RQI2KR8D/O2/+V+MlMXwdDLxblWFaplxoF0Ukrmh/4I6fVI6LGfbAGGUZ8CnE/YUcJQTw3fYBwD7/elEejbb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4403.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(346002)(376002)(396003)(39860400002)(36756003)(2906002)(110136005)(66476007)(186003)(66556008)(8676002)(66946007)(26005)(316002)(16526019)(31696002)(86362001)(6486002)(5660300002)(31686004)(956004)(16576012)(83380400001)(966005)(2616005)(478600001)(53546011)(8936002)(6666004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?elFuVGdsYjNtZVlyb3ErR09sbE1ESEZmUDdqSFhQVmFvR1JiQjR0Mk9SQXQr?=
 =?utf-8?B?ZjQxNVZtK1lPdXp1cFpyQzR6UWdCK1FQSnNLSGQ0SkNxQ1oyc0dERGhMbHl3?=
 =?utf-8?B?eXdkRkY5enllZVlsOTdiNmhYOXBrOGdCd0tUUng5MlpscmJoVjEzUGdrQ1VR?=
 =?utf-8?B?OEhRNTlxQU80L3BCblUvcnFzWkZLdk05TUpqem4vWnRwajVDcnlUYlJOYzEv?=
 =?utf-8?B?WWgxOEtSdzdrOVdYaWZZdTZPcnFublo2MXVHZU8vUlRYT3h4MWQ5Zlhnd1hV?=
 =?utf-8?B?eGVmM2JZclMxUjFOQjE5eXRqVmQ2OW9JdnBSUjBRZ3NaVnlZa3M3T3RoWCti?=
 =?utf-8?B?aVB4a3ZZVldYd0gxWm9wU2lzUUwrNDdBYUxHQi9QYXMvOFp1SlhEVW5HVXZJ?=
 =?utf-8?B?N0RKYmJ4MWM4YUJSS3hvYSthSFYzRU13bVNYMFhPeElhQk9JQk9BOGdJeDFT?=
 =?utf-8?B?emFVK1A5MmlhYUpwd3lmWlBkaE0ydzVwbTk4c05XUER5c0RJL1BDY3NVY3Fo?=
 =?utf-8?B?emVrY01rK3J4cVdMU250bklvMWxSTUh6ek5EZW8xNWJTbWhveXE5b3M5VWZQ?=
 =?utf-8?B?YWdsV1VKS2RSN21Xcnl0aERUampOVTAwZitONDN2VllwTjhSVXdERThMRnFa?=
 =?utf-8?B?N0tJeXhXYy9ZOHA4UC91ZXpCU3FLVk9MbXRzTDN6Qmo2Slp6aHViTmk4NGo0?=
 =?utf-8?B?YzI3NzROeXQ0dENLaHQ4blJBT0pXOWJLclhQMm03ODhKNWgySy9CMTJWdi9u?=
 =?utf-8?B?emx5c0tlcmJ2dzZzeXlnMUtHTGZFdnBDWTJGTkJMRkYxUDFqczdNVE1SUDgr?=
 =?utf-8?B?OHR0Y0xaVzVWU0JmWGs2Y0tHR1JzbUtwZ1BJa0lPMVk3K2hOWXVyYUtxMzN3?=
 =?utf-8?B?Q0QrcGZWYnNtRXdwVjNuRHlRdVhLcDE5b3NqU1FKMCsweG41ekw5VklNc0Va?=
 =?utf-8?B?RGpmNVd2ZklJWmdrYmRVVnU2SHdZUkdwemw2TTVBbTNaaTA2WlVxQUhzS05D?=
 =?utf-8?B?MnU2QjUrOFBWQ1F3MmQ1ZE1KaUNRY2pTM3hhNVFiNi9lVkM1QWRrYlFSdE5O?=
 =?utf-8?B?YUpWb0hYQVNMclRzdHVtdUVkd2VDb3VpamxGWjdSTlBvR2JlOFZNTWpZTmxN?=
 =?utf-8?B?b2RpaTVKc2FPb0NXcHdGd3NLZ01OR3BvZy9OWWpiVGRKM1ZOV0h4eW14YmFz?=
 =?utf-8?B?Y1dvcHVtVVhIV1VKUXdoT3Rlc0JHTXJTUUN1V0JIWWljQlFLT0hVK0RHRTAz?=
 =?utf-8?B?OWJ4SG1kVU5EN2Y5U1NvNFVWY05YNnhWMkhNbnA1VStydnI3OUg4VkdSTnZx?=
 =?utf-8?B?Mkg3NkdiSVdoUjBFbTNyUXI1NS9jcmlHSUFSZ2lGeGcxeUFUSFJPVCsxN2hO?=
 =?utf-8?B?dStQZUliR1AweWN6Ri9HaXZyR2d2bC9KTW9qTzVFK3pXeHFMSU5FaGV0dUor?=
 =?utf-8?Q?lj7tDqXj?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 711ddefb-daef-4724-facc-08d8bba7a6b6
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4403.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2021 11:53:20.5719
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jI41YQYRbP8PMu7l8gVyLNqtKYLScacgqPbB3pdVG1G0ty8WA+XyzVKwe9wCr7kJ9mQTzoE6m80UDx/7w23NGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3339
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1610970803; bh=4Vm7Hkswa56DY+yAtX2oNmnN888f4LYixzf+BYvI4lQ=;
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
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-OriginalArrivalTime:
         X-MS-Exchange-CrossTenant-FromEntityHeader:
         X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
         X-MS-Exchange-CrossTenant-UserPrincipalName:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=k86O0TXGa727usO8x5KFBTRv5ipULY+mHMX/x5IzUBWYdsoZpwMJvP4JpwgZ9cAlV
         lHNkWUXiWdEZV0Y2KsHozCo2r/j40ENqgiqBK0zUCNmGoUhMEDcCjjpJCqPoBaZGd5
         V9c4Mn1AKmFIqg6TTjB66dNd+q/Zh6je/vHOQqNNU8u60onOcb7vSQC2DXQ2t/J9kI
         S57QPxbw8efSdI2NQaYS93WN7wUUKEp77fV905WSBi1Cc2fY9GubyPZdrqAamcqLX8
         5TqP/POhL3CnMey8qPUa/1ovIdfgPTp3ZJ3CMuGvd9eIWolOGRZY2NgGhjMZA6W6to
         srtWaKFGpy/vg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16/01/2021 17:39, Joachim Wiberg wrote:
> On Wed, Jan 13, 2021 at 14:15, Nikolay Aleksandrov <nikolay@nvidia.com> wrote:
>> On 12/01/2021 15:59, Horatiu Vultur wrote:
>>> Based on the comments of the previous version, we started to work on a
>>> new version, so it would be possible to enable/disable queries per vlan.
>>> [snip]
>>> We were wondering if this what you had in mind when you proposed to have
>>> this per vlan? Or we are completely off? Or we should fix some of the
>>> issues that I mentioned, before you can see more clearly the direction?
>> No, unfortunately not even close. We already have per-port per-vlan and global per-vlan
>> contexts which are also linked together for each vlan, those must be used for any vlan
>> configuration and state. The problem is that you'd have to mix igmp and vlan code and
>> those two live under two different kconfig options, and worse rely on different locks, so
>> extra care must be taken.
>> [snip]
>> If you don't need this asap, I'll probably get to it in two months
>> after EHT and the new bridge flush api, even we are still carrying an out-of-tree patch
>> for this which someone (not from cumulus) tried to upstream a few years back, but it also has
>> wrong design in general. :)
> 
> Hi,
> 
> very interesting thread this!  I believe I may be the one who posted the
> patch[1] a few years ago, and I fully agree with Nik here.  We developed
> the basic concepts further at Westermo, but it's been really difficult
> to get it stable.
> 
> We have discussed at length at work if an IGMP snooping implementation
> really belongs in the bridge, or if it's better suited as a user space
> daemon?  Similar to what was decided for RSTP/MSTP support, i.e., the
> bridge only has STP and RSTP/MSTP is handled by mstpd[2].
> 
> Most of what's required for a user space implementation is available,
> but it would've been nice if a single AF_PACKET socket on br0 could be
> used to catch what brport (ifindex) a query or report comes in on.  As
> it is now that information is lost/replaced with the ifindex of br0.
> And then there's the issue of detecting and forwarding to a multicast
> routing daemon on top of br0.  That br0 is not a brport in the MDB, or
> that host_joined cannot be set/seen with iproute2 is quite limiting.
> These issues can of course be addressed, but are they of interest to
> the community at large?
> 
> 
> Best regards
>  /Joachim
> 
> [1]: https://lore.kernel.org/netdev/20180418120713.GA10742@troglobit/
> [2]: https://github.com/mstpd/mstpd
> 

Hi Joachim,
I actually had started implementing IGMPv3/MLDv2 as a user-space daemon part of
FRRouting (since it already has a lot of the required infra to talk to the kernel).
It also has IGMPv3/MLDv2 support within pimd, so a lot of code can be shared.
Obviously there are pros and cons to each choice, but I'd be interested to see a
full user-space implementation. I decided to make the kernel support more complete
since it already did IGMPv2 and so stopped with the new FRR daemon. If needed I'd be
happy to help with the kernel support for a new user-space daemon, and also can
contribute to the daemon itself if time permits.

Thanks,
 Nik

