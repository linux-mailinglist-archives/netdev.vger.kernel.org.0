Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A6D0313221
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 13:20:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231657AbhBHMTw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 07:19:52 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:12047 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232699AbhBHMSJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 07:18:09 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B60212bd80001>; Mon, 08 Feb 2021 04:17:28 -0800
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 8 Feb
 2021 12:17:16 +0000
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.106)
 by HQMAIL111.nvidia.com (172.20.187.18) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 8 Feb 2021 12:17:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q3OGPyWeTcP2h6ZLASQJWbWlD1++A9ESvmurC7kQoYh4cFivFePGGif+E53rib/FFYwmmqTv7fuawn2LvbkQl40zO+tLeFThRdi9BKY0d7nQBl8++/1V355soyUfJVnxgn0j0GrYmMZwtAOjLSgvtIILmUd9XuohERjUIE+5dBizJiGtxUqmpYXeIC8F9aaVMifsgpcrJiCm5QIPKMxJCUffHJHgXyHN0cMVX+MKyV7TuhFyp3OiMnmy2AcjR6I3B0v2d0fEfjgBJrx7FMJ/AJ02KX+tEoDKqclbUr4TPdqLxC9kXPOUm7rhH8svVmzymO9eQfY5ZRnikHjv/1dHew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w4RVkI/iNokwmnEOhVMllUSsNW4Mj3EHC1/ddDrha9w=;
 b=ZzG9Hun8BvvcVmABUnr4427Modxn+xlQXR6w2X7U8U96XJxV4XO7G9BiSg2hMpd0QDKzFawODX85D6BEbMBG9ODlxk4rZmjnIirqD5V0GdcNdrgO4FzcL/pee1BHFHiWBVJo8q4cJgw6FXkr2v1P0Iz/j1SZND1kidIDNoM+KpAV+fdCsBYAvSJN7zGlBqoFqTS2e3Ts71gnLxnbv5/s66ZV/PWE5myFZJZw8PYRCv9Lz+7wNeV4GDsiseByRUTpiGGen6+uyn6fC3RYeCg2yExiuzPYYcLXgg713HplIsqKeprfUOMRu+HhjIulAuiupa4yC+w+zl9X3QL/LicWaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4403.namprd12.prod.outlook.com (2603:10b6:5:2ab::24)
 by DM5PR1201MB0058.namprd12.prod.outlook.com (2603:10b6:4:50::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19; Mon, 8 Feb
 2021 12:17:14 +0000
Received: from DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::5c42:cbe:fe28:3a9b]) by DM6PR12MB4403.namprd12.prod.outlook.com
 ([fe80::5c42:cbe:fe28:3a9b%5]) with mapi id 15.20.3825.030; Mon, 8 Feb 2021
 12:17:14 +0000
Subject: Re: [PATCH net-next 2/9] net: bridge: offload initial and final port
 flags through switchdev
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>,
        "Roopa Prabhu" <roopa@nvidia.com>, Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "Alexandre Belloni" <alexandre.belloni@bootlin.com>,
        <UNGLinuxDriver@microchip.com>, Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>, <linux-omap@vger.kernel.org>
References: <20210207232141.2142678-1-olteanv@gmail.com>
 <20210207232141.2142678-3-olteanv@gmail.com>
 <95dede91-56aa-1852-8fbf-71d446fa7ede@nvidia.com>
 <20210208114511.xtzma5byrdnr5s7r@skbuf>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <a22fee65-9cb5-bdd5-fd40-cdd57dc072f3@nvidia.com>
Date:   Mon, 8 Feb 2021 14:17:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
In-Reply-To: <20210208114511.xtzma5byrdnr5s7r@skbuf>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: GV0P278CA0026.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:710:28::13) To DM6PR12MB4403.namprd12.prod.outlook.com
 (2603:10b6:5:2ab::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.241.121] (213.179.129.39) by GV0P278CA0026.CHEP278.PROD.OUTLOOK.COM (2603:10a6:710:28::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19 via Frontend Transport; Mon, 8 Feb 2021 12:17:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 80234db6-1b5e-4d43-de76-08d8cc2b77f7
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0058:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR1201MB00580D36B2726C510DBC16C4DF8F9@DM5PR1201MB0058.namprd12.prod.outlook.com>
X-Header: ProcessedBy-CMR-outbound
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vilbzdC8uIYWJ3k+dkjyxa0yXCSdXHLaUsVc2u4NXWQSB+XhmsbqYVlSm2x7C4kfBkobHtiXjVY0M/X8BIXFnKYQJ8t+9iyVztMLxCAWN9aYb9JbKTtOMq1yRH4y6nhJl4f/Z3UlYt9kd+8jVinIl2KUM4n+nBkpPyM+e49K8uxUuHqmILl4h+boCeb0LTf6a51DOQWkMNG8kjwizfsh6ROcI/ZEfcu/VWDj6N2DHRwREQvoJ6ykfMlScTdcym5VV3p7uyXJjEC8xK9tiEYnZEdUJXiqm6NauUGQO9BzSBrf8OV95IDa+dqrZuGA/JrwTTl91yWZpLgwrPsHk37MwN+ZYlDQDgfEJEedaa27iNYmiM2sMH4EYGkQB2Eci43OExBygtn2YQaPPJkzslbYi2uJfuEi5+uN7VC4bNnkMJM4bSdu8sIsXR8HpyTsql/dZBcUTRkJ4A/h7gmU8upqlwJGVCbfo8liuMYS6YQ+lzv+3sJBD9ikaFduRprFZOV/9fQp7MLm7p3jhYEONg/8NXAD/1gySpk2UYZ4GN96PvBL+15HVZwyKMk6AsG0RJrZcG0CiXw4NVWPHcS4/ooMS+B1esbovYMrKddGK2aR96g=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4403.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(396003)(136003)(366004)(39860400002)(186003)(6666004)(26005)(8936002)(16526019)(316002)(16576012)(478600001)(83380400001)(4326008)(31686004)(6486002)(66946007)(7416002)(36756003)(2906002)(54906003)(8676002)(2616005)(6916009)(5660300002)(86362001)(956004)(66556008)(31696002)(53546011)(66476007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?NkxqN1lMRm1XQ2tiSzdndjFEQU1qM2dCQzJMTS9xeFFyV3dJZEhYYlJqY3Ra?=
 =?utf-8?B?WVRrVTNzbG9OQnhySTdGZUpnY0NNTHFIK2lPTmE4NjB6dTh0dHBzZWVVU01K?=
 =?utf-8?B?Z3lIdk81c2w0WnpMWG5YNHFOS2FUcld4YStZMUMxNTQvaVhrZmxXbC9ST3A5?=
 =?utf-8?B?K1MxRk5DZVdYLzVkQ2dyUHhQVnJVYlhmTUdGOWFXUEZKakdmYzV2eVJsZDRZ?=
 =?utf-8?B?Q3NEeU1FaWhvNVZxQWRQYTJWeVYyaDI3ZE9xZ2RDcEJGY1MwK1ZheEFHNlpK?=
 =?utf-8?B?S3Y1aHR1NDVMVWV3TUloR2ZQL0JqMTZEY1BOd1VPY3hmWEYrNFZhUC9BcHFL?=
 =?utf-8?B?TEhYQnBjMU1jUTdRcWQxN2g2TlFCeEJ5M3VmSC9ZME9DRXppUUk3VUVWeUVi?=
 =?utf-8?B?WVlJT0k2RldjbFBVZHM1WXhXS2FYbnBNYTZUbEhhczBNTjIzN2dDMnczWHF0?=
 =?utf-8?B?YVA0NmJjTXVpc3NCZEJaWDFPek0vd3lBVkF0UFZRQ2VBeDJIOVcwc2dCT3RS?=
 =?utf-8?B?QktXazlqZWl3WlFYVGVlUk9FVE9PT0docUdxSU9ZcC9xU2NGa3NqckFzRUhM?=
 =?utf-8?B?OUZtelJhVUx2SEVKT29yUWwwVm9qRmphQzJtM1lhc09SRTFaM2p0cEt6Q2NP?=
 =?utf-8?B?dVRZRUtOZE1PeDlHcGZXUHp0cTh0aU9BMkt3UElJN2ViM1JORlRHR09MWDJB?=
 =?utf-8?B?ZWdTWk9tU1ZVRmV5SDl0eEhxTjJxYXd6Skw0WjVxcHAzc1R5T2lKUXpmbnI2?=
 =?utf-8?B?U1pDanAvT0ZwMEJyRUhxTkdQeXJFaDAzd2FlUXA4YUkzZ0pCeWZydWxuSEpI?=
 =?utf-8?B?Slh3Y012a2xwTG5hYkwrS1hoVUo2Y1NPNTEwRGdUNFJlTEdGUHhSZkVNbmtv?=
 =?utf-8?B?ZFdYeUd5T0tqK0x2OC9WenAzRFZJYTBPYnVjTUkycVh3R1lkbndBS1BnZ2xN?=
 =?utf-8?B?bDdITTg5dzdlM0NyUHloVzRSZVhId2xad0hnL1lnY0FpcHphYzlIZU5xcnVI?=
 =?utf-8?B?YkJFNXV2dFlVdFlQanZUYkxrSTBjYVdCWHFidlhvbXZhblpkQ1A0RmZvVUdz?=
 =?utf-8?B?STRtYzBodVdXeWl6VjN3RTQ5cWpQRk51dVI0N1NSL2VFOUNxVG5CODNBZ2g2?=
 =?utf-8?B?L3VOSWFoWjhNcTZNWG0vV2ZoNjU3RWhMQk01TWV1bGFMSjZLNDQ0L0p0Y3JH?=
 =?utf-8?B?S01YQVc2Z1MwVm4zbElPT2lsbk51RHZVYXhFMlBWZWw5Nlk2eWRobk1BYWRy?=
 =?utf-8?B?UHR3M1B0a1hiL0NzaTRwT1Z5RkxuRlNiN2lWZm9ONGhtbEZLYVJLTi9OcVpT?=
 =?utf-8?B?RGNmZ2VaeFBuR1hmcXVvREpUWFIyWHNHVGdQYnB3M1gxTFBNVzFhWmtkcDFD?=
 =?utf-8?B?QWQ2SVBrNmtmdEEvMHRCWk10ZG93SFZFNk5RRCtlQ3Jmc0ViWVlBc3BJTEtY?=
 =?utf-8?B?Q0NKVVkrUk52aCs0Q2JoTUxkODZURnBwd2tNaVhzaWRIS04yRk9jd0RMZGwy?=
 =?utf-8?B?OHZZT3MrR2c1TUxSWGVmdjZMUkhGYmxFMXJ6ZlNaNEx1SkIvZExrUTdidmVy?=
 =?utf-8?B?QmlJeTVYZFVEQUxEQkE4UVlDMTIzNGczR0c1Q3R6RHFPWGxRcXRUUDdJVTFN?=
 =?utf-8?B?NDVUaHd2RGlUNXVOZzFkU0FYYlozUXdCY2x0NVgvb3JBcHQxWHJOcnIyMWo4?=
 =?utf-8?B?b3VvWHhwWGM0MGtxWUdkdFEvSjMwT09xSVVsVlh1L3NHWURzWUJMS3FTaStt?=
 =?utf-8?Q?18gpUlsY9NNll/V6Dww49n8J0HFE2nIwjlhN6kI?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 80234db6-1b5e-4d43-de76-08d8cc2b77f7
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4403.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2021 12:17:14.3030
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m7kChxbalxkPeeN+jpBMVGVlcS4e5B0BayxEksD7jfLkkOgnsret+/iytFPCbisil9CEFkZkHfEabhfqS5BXHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0058
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612786648; bh=w4RVkI/iNokwmnEOhVMllUSsNW4Mj3EHC1/ddDrha9w=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:
         Authentication-Results:Subject:To:CC:References:From:Message-ID:
         Date:User-Agent:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy:
         MIME-Version:X-MS-Exchange-MessageSentRepresentingType:
         X-MS-PublicTrafficType:X-MS-Office365-Filtering-Correlation-Id:
         X-MS-TrafficTypeDiagnostic:X-MS-Exchange-Transport-Forked:
         X-Microsoft-Antispam-PRVS:X-Header:X-MS-Oob-TLC-OOBClassifiers:
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
        b=a1323N8eXC5BFt04xRqsY0wFjsSB/GSz/ZlxgT2JgCdT4xUb01/y/z/ySCaJptdsa
         vo7dPiX8tlzULxmMqsH/PUvlE+yh6CIObDqHS/M5VMXvkvPcT3Ktkg3qZ3r3XYIUhO
         Jd/Q1k/9hZ5oF8Pi9FegJZ/9J2ufBcrDlL4a2NCZiFYlGeZYWx8W3zncMSX/JC2iEa
         zn6RICXRf3syJ95M0feHekq+VpUe86mz5qHotGKPO8meeekP0DQXSe3vSzHmidNQNZ
         /EwLbLeqfgqJIOGva2M3GDbHjFXD8ROlSMW9hnPYV24fOM2iQE4jSlpGJM8jY/MZRI
         AiDh+8BLVyuIw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/02/2021 13:45, Vladimir Oltean wrote:
> On Mon, Feb 08, 2021 at 01:37:03PM +0200, Nikolay Aleksandrov wrote:
>> Hi Vladimir,
>> I think this patch potentially breaks some use cases. There are a few problems, I'll
>> start with the more serious one: before the ports would have a set of flags that were
>> always set when joining, now due to how nbp_flags_change() handles flag setting some might
>> not be set which would immediately change behaviour w.r.t software fwding. I'll use your
>> example of BR_BCAST_FLOOD: a lot of drivers will return an error for it and any broadcast
>> towards these ports will be dropped, we have mixed environments with software ports that
>> sometimes have traffic (e.g. decapped ARP requests) software forwarded which will stop working.
> 
> Yes, you're right. The only solution I can think of is to add a "bool ignore_errors"
> to nbp_flags_change, set to true from new_nbp and del_nbp, and to false from the
> netlink code.
> 

Indeed, I can't think of any better solution right now, but that would make it more or less
equal to the current situation where the flags are just set. You can read/restore them on add/del
of bridge port, but I guess that's what you'd like to avoid. :)
I don't mind adding the add/del_nbp() notifications, but both of them seem redundant with
the port add/del notifications which you can handle in the driver.

>> The other lesser issue is with the style below, I mean these three calls for each flag are
>> just ugly and look weird as you've also noted, since these APIs are internal can we do better?
> 
> Doing better would mean allowing nbp_flags_change() to have a bit mask with
> potentially more brport flags set, and to call br_switchdev_set_port_flag in
> a for_each_set_bit() loop?
> 

Sure, that sounds better for now. I think you've described the ideal case in your
commit message.
