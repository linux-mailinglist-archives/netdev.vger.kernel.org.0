Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD03739B4AF
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 10:14:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230163AbhFDIQJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 04:16:09 -0400
Received: from mail-eopbgr60135.outbound.protection.outlook.com ([40.107.6.135]:50341
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229900AbhFDIQH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Jun 2021 04:16:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G3kNMr9zQcyCaWj8HCdgfMqdv2prTOVV7p9moIw7EDWPk+KTH/XiE5xTbqAd9FTcG5/fsNJCWyUkabjh1LVAIjlmHlbkLZoZM/WT+weRhUtL+UjUauwXBFmhNVncukz6GBxRmHcBxY8GHMfuLhctN5nxG71scGhwG2NoHNlpZ/og/Pkfweg+WH521tkRdfv/I3bL7uFeOAKE9Qr9vAzWULx0Yr3FhcFXqxkgPvB+LkhCMDAL+LbGle9ikRQkysJCiSo9jttCH0b9QvGXhdS8X+OlIXjtgXmqJWxE0/P7wGvEcbt9ZtLeK+kDu9bi8HatANABQrV7EB/86vBUtYIeHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6EzA6hx7h2qoZM6Hw/yttKnVy9CQNu9eKqs1QYGNqqo=;
 b=W1bsolTYgZ/7u3H5t5W5ZURM8Vz+eOXWo5irv2K23nyWXNImMKPd40qowbQ0tv+da64TJgtJZmoOYTB8xXK5EY/EKjUyamcJy/WZCmqNrm4GXRaRGiwpvzo8Wr2lsA0XE3qW3phuvi98NTVRy+PAmE4hFvNwwYgRolcTBM8giMdnR/ZpGnUlz+wGb2SMf0Bd5LQXA/uM3M7roc1vIX8M4YIIypoapOC7X1v7mD36V9BID7EwgJzt8ilQq1IIFpO8ksO34kTZbJs7tnFYE/Zgt/Cc7YhYyVNjxVll4FwPnwFJOxTG65ZebD1Cb1ZZJXZlKmm1alykCSjDUNQ+08MArw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=asocscloud.com; dmarc=pass action=none
 header.from=asocscloud.com; dkim=pass header.d=asocscloud.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Asocs.onmicrosoft.com;
 s=selector2-Asocs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6EzA6hx7h2qoZM6Hw/yttKnVy9CQNu9eKqs1QYGNqqo=;
 b=N2OztdbQrrOaZK+fFK5qO/vJhxSQRt8U6e+QKPUhjBOZvk1paBnqDBZMUBte16NCk+0p0DQ1H/J6lToEYb+xlymVkoRd6VEq/L6GpKmUHVRQlXA7kymW28wLzDm5T+RJllhGlUUFvyJfFGCWYn1Z26MykP0f2irwmatgmB6Z35E=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=asocscloud.com;
Received: from VI1PR1001MB1181.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:800:6d::22) by VE1PR10MB3853.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:800:149::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.22; Fri, 4 Jun
 2021 08:14:19 +0000
Received: from VI1PR1001MB1181.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::e021:4f40:bf7c:ee06]) by VI1PR1001MB1181.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::e021:4f40:bf7c:ee06%11]) with mapi id 15.20.4195.024; Fri, 4 Jun 2021
 08:14:19 +0000
Subject: Re: [BUG] hv_netvsc: Unbind exits before the VFs bound to it are
 unregistered
To:     Dexuan Cui <decui@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Long Li <longli@microsoft.com>
Cc:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <54fb17e8-6a0c-ab56-8570-93cc8d11b160@asocscloud.com>
 <SN6PR2101MB089485D8C070855CD43C1961BF3C9@SN6PR2101MB0894.namprd21.prod.outlook.com>
From:   Leonid Bloch <leonidb@asocscloud.com>
Message-ID: <d13d685a-ae48-b747-7ecf-357b91c275b2@asocscloud.com>
Date:   Fri, 4 Jun 2021 11:14:16 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <SN6PR2101MB089485D8C070855CD43C1961BF3C9@SN6PR2101MB0894.namprd21.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB-large
Content-Transfer-Encoding: 7bit
X-Originating-IP: [176.230.214.112]
X-ClientProxiedBy: MR2P264CA0125.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:500:30::17) To VI1PR1001MB1181.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:800:6d::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.206] (176.230.214.112) by MR2P264CA0125.FRAP264.PROD.OUTLOOK.COM (2603:10a6:500:30::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.15 via Frontend Transport; Fri, 4 Jun 2021 08:14:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9cbee338-a0ab-4e9a-6b10-08d92730c039
X-MS-TrafficTypeDiagnostic: VE1PR10MB3853:
X-Microsoft-Antispam-PRVS: <VE1PR10MB3853336FB7C1BE4DEAA9E203CE3B9@VE1PR10MB3853.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ilYY8WZPLpwtMU9+A0s+Ixx80vdDuaZhkO+fFP0Xjh91GYS/AUoX737a8/WlpkQbR6sJDNfofxK5rpd//dce6QMXiApFS0w8VqriipUi5/6rX4CDnt76jFXK5oHO1KtV0ZOAx6UFGKWD+NVWsiE59bAOmjdb8an4xnsjxzypIvNJ/nRKX5gyqlOV9Xo8/s+0KgvJSw2BrBQi1rGHdFeGSZLNiXq3f4wixyVY1t/TZNZygrKrObEptyCRHyRpwoh9G8y8wYcZ1uq398kAkC/vdW0s7DvsZqjhb7+EX5hnNvb8uCGKPoQJ8lJ1DqBSOPkGtznqekF8QQxjAshuTMEeWZlrWBAtWug2lEwpk3tlQmoKR9qpuXQoKQwm+1dlFoZgLL/RaQ1aQrpnqNUlqpOWTKqWn3ooSBcJeswOUsokbA7Bwur6N75HqD5M2ggjjdg+i6TBQ7I0sGfPk9WfDQBZc/tKYG8P0HY2uQydP0pvqWgQj55D6vwa9HLdOF/6/hTP7PIuR5EeP6cnNjJ+s/jGPzS6+xlk6t0DUZ5eVDIUZrWhURLU8nCuosCIARdbKiznrRHHSxbWJctp8+i+mk4OtYQLuuunrlAvFaScepCc9K07nqdfC6+YjM1xPATK/fYG3wRI9Tv4dUuL5lulNFXFmz/FCBTxfHVajV4JsOhIeQFar87MroPq89sD+ccUaLGyQMHorKLvM0LHEu4OGDGbeToFNQhBa+NeJgJ9EqvXolE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR1001MB1181.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(136003)(396003)(376002)(39830400003)(366004)(346002)(53546011)(38100700002)(38350700002)(36756003)(478600001)(66476007)(66946007)(66556008)(2906002)(86362001)(2616005)(31696002)(186003)(16526019)(956004)(26005)(31686004)(5660300002)(52116002)(54906003)(6486002)(316002)(110136005)(8676002)(16576012)(45080400002)(8936002)(4326008)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Y3pscy9hSEdTSng1a0c0bzdrWFFiSFVCa2lWTUhaVGJqUUJ3b2NubHNKMjVa?=
 =?utf-8?B?UzJlUmxlaWxqTmFBOXJMUGp2MXJmUEp2RjRHVmZxWFNSaGs1VGloUU4yNmti?=
 =?utf-8?B?cCtsQmtTU2RWdlFJbllycGo0aGFXNHJsT09ySVZmTmVXRmx0SlZoSTh0RHh2?=
 =?utf-8?B?V1Rva3VHSVBRc2lDQ0xNREcxMVgwaG9zaVZvbWJJOUc3TTdHWXhJSGxiSnJx?=
 =?utf-8?B?bzN3cVhldlJYSXpwU2lLcXVkZlJ3Ylp3bWQzYXNqbHQ5bjJid2pRNUFHNWdJ?=
 =?utf-8?B?bjk5dGVMUjJNdVRCRDNkMjdpekdxWDBQOUo2Z3I5S1hrZ3lwbjRvZnJsVjU2?=
 =?utf-8?B?akNXU3hheEVZdjJYaWkrQ3poenBUdDBiSFJxMUJRT0NvNXZ3ZEVadTluV2sv?=
 =?utf-8?B?VjdlNzN5V1NRTWxsZkJPZ2cwSTVXRVl5RTRiaVI3aENNZDNUZHo5NzVuWVYx?=
 =?utf-8?B?bkdvdjQ5ZVBTMlQ1TXBkSDlBbDRVSFI4NEc3Z1E1U29LU200Y21mRmRLS1NV?=
 =?utf-8?B?cEtsejNtWGlKTWVDZ09lQ3JMaG5mKzVxS3RpSyt4eUtJWjRKL3A4RWZYejJl?=
 =?utf-8?B?YlZmV2dpRWJVWnpZNUQxOUZiMFhIbTdMNGw1OHlvTTBGWUhDcUh2TXBRK1U4?=
 =?utf-8?B?K20rZzJRamcxWjJDanFmdTlranoyVC8zdWo3VkIvK3hjYk85TjhIWjNCM2sv?=
 =?utf-8?B?L0Z1aFYrVW9xRjVhQ2hlT0F0MFB1L1cvS0pTNkFNSEVFWTFjOWVHaUplY1Jq?=
 =?utf-8?B?YmdsSm0xYVdjcUdGUmpvL2FDY0JTS3kwUGE1MTlHWEhOZUNzOVBENTdpd3Zl?=
 =?utf-8?B?cjdIQnFCZ0NCSFZUQWZ6Zyt3UFVCZDEyVldabkJrYmZKUWFmMFZXR2ZyVCty?=
 =?utf-8?B?V0RqdDhFRnNmY3l0SFNBd2ZIOFBLaVBrUjlGK2xTd3FnUStXNWtZWUxtU2lG?=
 =?utf-8?B?QVhuTnpDZ1FNRXpBNzJWbUFlQXdiMmxIS3RXdlowQ1NTaWlYdUY5aStoYXVK?=
 =?utf-8?B?UDBEa0IwMTB3NUs0UThNRHJUZGdjd3o4NXk5R2ZUVUxlMjdhSjFLYUJaNmdu?=
 =?utf-8?B?eHg5R1haY0hYTmlZN0pZNmtKeGZVSUczL29pVHhwQkJtbGRXbEVDaFk3Yzhl?=
 =?utf-8?B?WUw1Zm5IR016ZW1MSDRSd3JycUx5OE00alQxdlZRT2Z4UnZTT2F5QldvMDFp?=
 =?utf-8?B?YVZvWHJETGZLclhHM3EyK3I0S1BTWi8vVmY0T1Q0OE5EcVJYNlc3M05wT21Y?=
 =?utf-8?B?d2lGb3hNMHJaMzU4c2wzcEpBV0pCZHRwRTVOTXZSRTh6U3lGZUZFS3R6N3o1?=
 =?utf-8?B?RkowL0ZXY3FVaGhZb3VyVkJkQncwenJIQU1qQzhMN05aZlhwM2JDbTZrR2Jq?=
 =?utf-8?B?OE4wV0p5NUEzakEyeUNxUlZ5RUhINmJKY0xIV09oMkFNOVBFUHNXZDVOcDhm?=
 =?utf-8?B?dmFaR2pqWkxYOG5PVnA4M0dPMG9RekVBeXhzZXVncGppa2g3TitNbVBESnIx?=
 =?utf-8?B?M21IR1g2eHVYeEt3cXhnd3oxTjNwWDEwb3RrUUxyZEJtcm41WCtwS05kd2Ns?=
 =?utf-8?B?ZjBLcWhiWkhNUlQ3VG1RMkJ4NmxhZnNubFNNVmFKNXh6dUlYOUtMbS9HYmtD?=
 =?utf-8?B?VFpwS3NmQWplVVBGZ1RaMlFCdW9GQTFLZEozMkk1ODhmakR4YUtoT25wOGQw?=
 =?utf-8?B?Nk14SXk2V2NTRWZ2MHE4STgwV2hGTGVZMlZGRk1uVmR3eVR6ZWJmakEyOCtv?=
 =?utf-8?Q?X2V7MDBgKqhoB7g0NgFESt7DLjFc1TuHkLNE8Fc?=
X-OriginatorOrg: asocscloud.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cbee338-a0ab-4e9a-6b10-08d92730c039
X-MS-Exchange-CrossTenant-AuthSource: VI1PR1001MB1181.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2021 08:14:19.0615
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 09a71e5b-e130-419f-bde2-1e8422f00aaa
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o525kghQw4jP7gqesyRSxBg9K3dLZk2dwdHuqmkO9up9ohsm/Y91b2LsL5SjXEkL4rvMjChq0x8Uadvg8fj4og==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR10MB3853
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/3/21 9:04 PM, Dexuan Cui wrote:
>> From: Leonid Bloch <leonidb@asocscloud.com>
>> Sent: Thursday, June 3, 2021 5:35 AM
>> To: KY Srinivasan <kys@microsoft.com>; Haiyang Zhang
>> <haiyangz@microsoft.com>; Stephen Hemminger
>> <sthemmin@microsoft.com>; Wei Liu <wei.liu@kernel.org>; Dexuan Cui
>> <decui@microsoft.com>
>> Cc: linux-hyperv@vger.kernel.org; netdev@vger.kernel.org
>> Subject: [BUG] hv_netvsc: Unbind exits before the VFs bound to it are
>> unregistered
>>
>> Hi,
>>
>> When I try to unbind a network interface from hv_netvsc and bind it to
>> uio_hv_generic, once in a while I get the following kernel panic (please
>> note the first two lines: it seems as uio_hv_generic is registered
>> before the VF bound to hv_netvsc is unregistered):
>>
>> [Jun 3 09:04] hv_vmbus: registering driver uio_hv_generic
>> [  +0.002215] hv_netvsc 5e089342-8a78-4b76-9729-25c81bd338fc eth2: VF
>> unregistering: eth5
>> [  +1.088078] BUG: scheduling while atomic: swapper/8/0/0x00010003
>> [  +0.000001] BUG: scheduling while atomic: swapper/3/0/0x00010003
>> [  +0.000001] BUG: scheduling while atomic: swapper/6/0/0x00010003
>> [  +0.000000] BUG: scheduling while atomic: swapper/7/0/0x00010003
>> [  +0.000005] Modules linked in:
>> [  +0.000001] Modules linked in:
>> [  +0.000001]  uio_hv_generic
>> [  +0.000000] Modules linked in:
>> [  +0.000000] Modules linked in:
>> [  +0.000001]  uio_hv_generic uio
>> [  +0.000001]  uio
>> [  +0.000000]  uio_hv_generic
>> [  +0.000000]  uio_hv_generic
>> ...
>>
>> I run kernel 5.10.27, unmodified, besides RT patch v36, on Azure Stack
>> Edge platform, software version 2105 (2.2.1606.3320).
>>
>> I perform the bind-unbind using the following script (please note the
>> comment inline):
>>
>> net_uuid="f8615163-df3e-46c5-913f-f2d2f965ed0e"
>> dev_uuid="$(basename "$(readlink "/sys/class/net/eth1/device")")"
>> modprobe uio_hv_generic
>> echo "${net_uuid}" > /sys/bus/vmbus/drivers/uio_hv_generic/new_id
>> printf "%s" "${dev_uuid}" > /sys/bus/vmbus/drivers/hv_netvsc/unbind
>> ### If I insert 'sleep 1' here - all works correctly
>> printf "%s" "${dev_uuid}" > /sys/bus/vmbus/drivers/uio_hv_generic/bind
>>
>>
>> Thanks,
>> Leonid.
> 
> It would be great if you can test the mainline kernel, which I suspect also
> has the bug.
> 
> It looks like netvsc_remove() -> netvsc_unregister_vf() does the unbinding work
> in a synchronous mannter. I don't know why the bug happens.
> 
> Right now I don't have a DPDK setup to test this, but I think the bug can
> be worked around by unbinding the PCI VF device from the pci-hyperv driver
> before unbinding the netvsc device, and re-binding the VF device after binding
> the netvsc device to uio_hv_generic.
> 
> Thanks,
> -- Dexuan
> 

Hi Dexuan,

Thanks for your reply. I can check for myself only next week, as I am 
out of office now, but do you think that the reason might be using 
cancel_delayed_work_sync(), instead of cancel_delayed_work() in 
netvsc_unregister_vf()?

And if the above is not correct, can you please advise on a way of 
finding the corresponding VF device from userspace, given the kernel 
name of the parent device? I did not find it in sysfs so far.

Thanks,
Leonid.
