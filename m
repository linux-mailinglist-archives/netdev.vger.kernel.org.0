Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F81E3DBA59
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 16:21:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239453AbhG3OVx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 10:21:53 -0400
Received: from mail-eopbgr60118.outbound.protection.outlook.com ([40.107.6.118]:4803
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239329AbhG3OVq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Jul 2021 10:21:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pv4h6XJ5dMye/j7XAjKVZfhp/25rw5CODq69iKvvL0Kl685Y1m7rAR62z7C0QR9bNgCX4RgPOB9xhgwCV6sGNQcug54RlOULSofnMxALIHcQIBaitOUSLvdOUv8rJuPsfiLK3QdGjttNgr9UwPFnmtPKqBTpgmdMC8Dy+yAz+l5WPcd+fXn11GI183/JJn7/3IstyYx3vAkwUR4D3HyGQYrOdimoeuNcHfNb6dwFrmBpQB4AbpabyFiW4FuG7juM8McgRWNoDH4WG9z/GLQeFpTuuBizlo9+MhNUY8vPaE30YARtFg/0ABjY4KEg+Zt4w6+AxaLRSnhIfzEfFbHehw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uoX2JubXMSBFsSAEWIrJlyU+D8aoJi7xdMJ6Yfw7Lcg=;
 b=ffva325B3I5KjPbKQQ6j2MiOGbE5Jw/prFPDON6GJ3wpvsn0kO8U9qddcS0dvdpyvlUODe9eYTUUeROfZCGK96BGgnhGQQR2nwJHqrNSOuvvNxaq0QXXsXw2zgKNRq7XhqDO7DyoY2wMUhp7ueM0CcYhkw301J9vOMbT+p70uBMRLNVReu+IHD2L+jeSaHUOGuw6ehZqIZ5vquIzactE6gWbYHtTPvQ9tTxBqjK6yUyysEL2zPEsWfnyZG+xxKMQQ5T5YXqh0LABn/jtXZ1IOROeH1f/Qz7gKuDSgefpMnkAT6inQ/bBlqwG96qj7cXvshUG4N9rt7kEC4mglO/1zA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uoX2JubXMSBFsSAEWIrJlyU+D8aoJi7xdMJ6Yfw7Lcg=;
 b=az/jlCjWp9ROKHJGJSzlXXvqYwe/5cAtFzmal/IgMCQ8pI4o9ZE1ls4XzIqT8eXhi1tSv02rSHY0uvIRnZE4DZIke4xPe7IgvH27zr3XdcYzqJSPYuan2CKG99op4y6eHwfGj4CehNuu1piDURvM4LQkmIj2TkA+rFRIuRy99Nw=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=virtuozzo.com;
Received: from VE1PR08MB4989.eurprd08.prod.outlook.com (2603:10a6:803:114::19)
 by VI1PR0801MB1936.eurprd08.prod.outlook.com (2603:10a6:800:89::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18; Fri, 30 Jul
 2021 14:21:38 +0000
Received: from VE1PR08MB4989.eurprd08.prod.outlook.com
 ([fe80::c402:b828:df33:5694]) by VE1PR08MB4989.eurprd08.prod.outlook.com
 ([fe80::c402:b828:df33:5694%7]) with mapi id 15.20.4373.022; Fri, 30 Jul 2021
 14:21:38 +0000
Subject: Re: [PATCH] sock: allow reading and changing sk_userlocks with
 setsockopt
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Dumazet <edumazet@google.com>,
        Florian Westphal <fw@strlen.de>, linux-kernel@vger.kernel.org,
        linux-alpha@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-parisc@vger.kernel.org, sparclinux@vger.kernel.org,
        linux-arch@vger.kernel.org, Andrei Vagin <avagin@gmail.com>
References: <20210730105406.318726-1-ptikhomirov@virtuozzo.com>
 <bc53b476f8a3a1bafb73c2f5072c0bad03bc1709.camel@redhat.com>
From:   Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Message-ID: <bedb3a9f-1c2c-050b-aafb-6dc676526152@virtuozzo.com>
Date:   Fri, 30 Jul 2021 17:21:32 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
In-Reply-To: <bc53b476f8a3a1bafb73c2f5072c0bad03bc1709.camel@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM9P192CA0020.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:21d::25) To VE1PR08MB4989.eurprd08.prod.outlook.com
 (2603:10a6:803:114::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.100] (46.39.230.13) by AM9P192CA0020.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:21d::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Fri, 30 Jul 2021 14:21:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f92a8d81-b172-473c-5b12-08d9536557d0
X-MS-TrafficTypeDiagnostic: VI1PR0801MB1936:
X-LD-Processed: 0bc7f26d-0264-416e-a6fc-8352af79c58f,ExtAddr
X-Microsoft-Antispam-PRVS: <VI1PR0801MB193632B30F8BEB5DB7FF7EF7B7EC9@VI1PR0801MB1936.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D04t4DuwNDsITpGGxC1TxR+BOE95nLmaDRyeuMYaXaSoeRrkS6PyGVqxIarclIcoZiXada6irjA2A/qeoZGZc0IMt0WrzyrjTwNOxFmjyjwnYbtqXdwycCm0l8crBs2xILL/KtN2OC01l48CA3zEhL0fIiLMZKHBvFnZV75OxnHOb/SRHyFsdrvoaV9MmeVBzoX6qsWEGldBNNA4zYWnHgUwCHvly/b3VKLWzt88RbkZQ4KRNb2q5udXl1+92UyT3+vkZO97m9qdWQ8JEM/9zfzBnYNr8z2GetMAJsbHGblRf6fFEfaNomVfAKHFgN2teklL7MOn9B5fHeunFCaSpQ8yAEa33WDRpejJZWAY9NLHTElbjEaklYdV5b1GeV9kfYNVYlMAxTiwG6l+oW5eyfk/xIeM4GYfEvsPYCLK+Q43kG/GWuzLGR9fWLgA5dkez0SvJ/sQ4Ux5Yq8PUTdFlhBzMQeSAIvW54QT0Cx+b9Fbin85jw6Dkt2ckCzaewzvsDCXTo4csDjXf+M8WGw5//7+b9cZ+UeCQXC0NnsDWXDJbFhCrxonFqr9FfH4Art8xYzYRdwWGCDMqwLb8ckmuxo50aLmA+c1We/vQEjaNjlGds0+ErASzMiuQnuJtBHOEBOT/DL145TpAdo9OrgrOMAdN+mPwmSFTVOxPX2qmyCHvoV+PxZMm9hpCSWNKnQRNv+eP8jshZV516x6IYAzR5Sc989EetN6ukfmYnc/lnzzBETM3qi1XjGdrhGncJD44xb+VC0P9wjRWRXOAxVexl6T2axRdXLQziUWC6QU1/NJEHBUOYhyVq5MNRCNvdk3HikxMpdK4sqGgQ85ti64OzGp276WNX4hEV6WSlDjatyYwt+HEx4/UsOfhi9N+iuS
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR08MB4989.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(396003)(136003)(39830400003)(346002)(54906003)(2616005)(956004)(66946007)(4326008)(316002)(38350700002)(7416002)(66476007)(66556008)(8936002)(31686004)(31696002)(478600001)(38100700002)(53546011)(6486002)(16576012)(8676002)(966005)(83380400001)(52116002)(5660300002)(2906002)(86362001)(186003)(36756003)(6666004)(26005)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WksyclgxSk81RTNTTnNCL2hKWEREUkxhbTJNSHlFdEViVE54MHNRWUVWSEpv?=
 =?utf-8?B?d001TlNrdDRKUjlJTGRyMURkUEZpTVdKbUFYVnhPS0hidDk2K1QrMUZwTm9x?=
 =?utf-8?B?VVFobmU0emRkTUNMQnZsNE5Ia2ZPOFpyQUZWZk5TaDhOM1ZJa0hqVlkzQmZ3?=
 =?utf-8?B?dlI1Q3hTSmgyV0I5OW1JR1dhRjNPQ3ZzblBMY3pEOEZQRzNNTEM1a2NrUWlv?=
 =?utf-8?B?ZFFUYlcweCtoVXEvd2dhNGw1QThXcGtMdDI2bzBrdTRVNkdYZ2h4SnZQWG9E?=
 =?utf-8?B?cUxleUtNYUx2UWkvQTZoMWVtQzBIUTUvMFZ5UGtiK01qSUZTSURJR0M0Zmwx?=
 =?utf-8?B?VWw5Y0JvZGloV3NzZmo4eEF2QkphQmhiWEIyYThkWHZQUzFZbi9jSjRJSnNq?=
 =?utf-8?B?bU13K2xiR1oybjhFNDJKSUhhT0VCTDlkRTFWTzBleC9HL2krQVl0M21PeGNV?=
 =?utf-8?B?TXJpS1N4Q2xiR3FRNVhkOUtQV2lmSGV5YzIwTUFYNFphUW1mQ24xSWRqb3k0?=
 =?utf-8?B?M1NvL2QrT05Xc2dNUWdGZ3llZ3FSWkRXMGVaa2ErOXp2bUlJZGE4dFV3aktw?=
 =?utf-8?B?Y1htR3BxOHVLd3BkdDBaSzM5VllGVGZVVjgwOU1Va2RnS0xKbVR3VzV6d2Ux?=
 =?utf-8?B?YTdnRmorU0c2OVF0MUcxVjRhRmM5Uis1RG5qdzduOXZYbWcvVFhEQWZvbndo?=
 =?utf-8?B?U01oZXArNGhxVjZuK2hkSVVqS2RuYzZtZm5oa0JQbW85YUVDWWx4ZmJLRkJn?=
 =?utf-8?B?bVZsSkw0emFUdWFGQkhXQUEwYVUrZFIwYUxNc1A3d0ZUeitsQVMzTmRmMHhp?=
 =?utf-8?B?c3F3YUxzK0V4MldoTEd4aUVPVEJHSWNTbWt1OHlCNkpzbHF2eDMyTlJFTFhO?=
 =?utf-8?B?UmxoeXlGb0xSZkYxMTBzeG4vdGZLdGtGWCtQVXJqWEtBdEJ2NDhGUXN3UWYw?=
 =?utf-8?B?YXFyYzNlNmYrb2RQdXNoQ2NJUCtVV205TGFlUGtEcG1sUHJQVWpaVHBmOERD?=
 =?utf-8?B?Qnc4MFlvTkVzMzNWSVFsUUVZMWp5Y1NybXoyTEYrV2tIUG0yaVlnNDFXREp1?=
 =?utf-8?B?TkRHd0hWWG9rM2c0Q3JoNFo3dkh6dUtUSUFOaW9pc3Z1N0NRL0FONmVNdHdt?=
 =?utf-8?B?R1lzMVYvTDZ1THRJalJlUDl6ZGp4N2VyQ1poOUcvdzlHL1htMzRZeTgyM2xu?=
 =?utf-8?B?ZmhNRmZpMmtUYTl5cmRCcmRzZDN2UDg0Wjlrb1IyT05BTFhKNThOcnpEWFJp?=
 =?utf-8?B?OGxhTHlJVXFNUmhsN2J4QmFpTUxtZXNpZjg1UDlsZVhmc0IzVm5wMGdUV3h1?=
 =?utf-8?B?T01NV2JqUVB4dUxoZjRpTi9qWUdFZkJKaG04Ykw0K3NlS0Ewdkg1cGlJWTlS?=
 =?utf-8?B?SEkyMCsrYjFQamdyK1FKUE94MU1meGd0aEk5ZTE1NE95WlJOVkVWb2ZtU05l?=
 =?utf-8?B?NW1WWXVyMm90U1c4OWxhVUhQd2ZoNllGZ0p1ZGI1K2lhQkFRKzRSV2lqZmFR?=
 =?utf-8?B?VUZtcTdSM3dsS2ZjbGZjek5yZmt6ZVlXOHlrTXI1Q0U1V1hGUjFXWlVNdU5n?=
 =?utf-8?B?eGhTa3NKRDdjTUtIdTE3Yi9DNDduL2tjSWxyQXBtUkVLVGt0b0hYSzNNUUl2?=
 =?utf-8?B?RkkrMzYwNDJUdzd3NTdSc3F2SU11bmFIUUVDVTRWS1F6aDVYQVNvOTNPdkNF?=
 =?utf-8?B?R05HdlV6T0YrdVVZbSsxek1oN2RlYSt3ZEdoNzJsclpUZnpnVk5MNzl0MjhJ?=
 =?utf-8?Q?WioGC+BbAdB+Bh69Zonu18gijhqlw4Mi496I2VX?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f92a8d81-b172-473c-5b12-08d9536557d0
X-MS-Exchange-CrossTenant-AuthSource: VE1PR08MB4989.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2021 14:21:38.2649
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 45uoeITGghYHIkg7yGs+DID6Gpy5qE7yAStH9xZGgujqRVgKHXHEz7m5WIFm/HgSKcnO79PQir4RrRDkSwivqtomk+ya9nAYN68SZxZfIBU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0801MB1936
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 30.07.2021 16:13, Paolo Abeni wrote:
> On Fri, 2021-07-30 at 13:54 +0300, Pavel Tikhomirov wrote:
>> SOCK_SNDBUF_LOCK and SOCK_RCVBUF_LOCK flags disable automatic socket
>> buffers adjustment done by kernel (see tcp_fixup_rcvbuf() and
>> tcp_sndbuf_expand()). If we've just created a new socket this adjustment
>> is enabled on it, but if one changes the socket buffer size by
>> setsockopt(SO_{SND,RCV}BUF*) it becomes disabled.
>>
>> CRIU needs to call setsockopt(SO_{SND,RCV}BUF*) on each socket on
>> restore as it first needs to increase buffer sizes for packet queues
>> restore and second it needs to restore back original buffer sizes. So
>> after CRIU restore all sockets become non-auto-adjustable, which can
>> decrease network performance of restored applications significantly.
> 
> I'm wondering if you could just tune tcp_rmem instead?

It would not help with the lack of information about if a socket is in 
auto-adjusted mode or not.

Though, yes in some part it helps. We can set tcp_rmem[1] before 
creating each socket to the buffer size we want for this socket. This 
way we would leave all sockets in autoadjusted state.

But a) it would be tcp-only approach and b) with this approach we need 
to create socket with it's final size and never change it. We would not 
be able to temporary increase buffer size like we do in socket queue 
restore code... (I see that initially we had some problem so that we 
needed to increase the buffer size 
https://lists.openvz.org/pipermail/criu/2012-November/005477.html but 
I'm not sure about real reason here, probably Andrey will be able to 
remember, almost 10 years passed since when.)

> 
>> CRIU need to be able to restore sockets with enabled/disabled adjustment
>> to the same state it was before dump, so let's add special setsockopt
>> for it.
>>
>> Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
>> ---
>> Here is a corresponding CRIU commits using these new feature to fix slow
>> download speed problem after migration:
>> https://github.com/checkpoint-restore/criu/pull/1568
>>
>> Origin of the problem:
>>
>> We have a customer in Virtuozzo who mentioned that nginx server becomes
>> slower after container migration. Especially it is easy to mention when
>> you wget some big file via localhost from the same container which was
>> just migrated.
>>   
>> By strace-ing all nginx processes I see that nginx worker process before
>> c/r sends data to local wget with big chunks ~1.5Mb, but after c/r it
>> only succeeds to send by small chunks ~64Kb.
>>
>> Before:
>> sendfile(12, 13, [7984974] => [9425600], 11479629) = 1440626 <0.000180>
>>   
>> After:
>> sendfile(8, 13, [1507275] => [1568768], 17957328) = 61493 <0.000675>
>>
>> Smaller buffer can explain the decrease in download speed. So as a POC I
>> just commented out all buffer setting manipulations and that helped.
>>
>> ---
>>   arch/alpha/include/uapi/asm/socket.h  |  2 ++
>>   arch/mips/include/uapi/asm/socket.h   |  2 ++
>>   arch/parisc/include/uapi/asm/socket.h |  2 ++
>>   arch/sparc/include/uapi/asm/socket.h  |  2 ++
>>   include/uapi/asm-generic/socket.h     |  2 ++
>>   net/core/sock.c                       | 12 ++++++++++++
>>   6 files changed, 22 insertions(+)
>>
>> diff --git a/arch/alpha/include/uapi/asm/socket.h b/arch/alpha/include/uapi/asm/socket.h
>> index 6b3daba60987..1dd9baf4a6c2 100644
>> --- a/arch/alpha/include/uapi/asm/socket.h
>> +++ b/arch/alpha/include/uapi/asm/socket.h
>> @@ -129,6 +129,8 @@
>>   
>>   #define SO_NETNS_COOKIE		71
>>   
>> +#define SO_BUF_LOCK		72
>> +
>>   #if !defined(__KERNEL__)
>>   
>>   #if __BITS_PER_LONG == 64
>> diff --git a/arch/mips/include/uapi/asm/socket.h b/arch/mips/include/uapi/asm/socket.h
>> index cdf404a831b2..1eaf6a1ca561 100644
>> --- a/arch/mips/include/uapi/asm/socket.h
>> +++ b/arch/mips/include/uapi/asm/socket.h
>> @@ -140,6 +140,8 @@
>>   
>>   #define SO_NETNS_COOKIE		71
>>   
>> +#define SO_BUF_LOCK		72
>> +
>>   #if !defined(__KERNEL__)
>>   
>>   #if __BITS_PER_LONG == 64
>> diff --git a/arch/parisc/include/uapi/asm/socket.h b/arch/parisc/include/uapi/asm/socket.h
>> index 5b5351cdcb33..8baaad52d799 100644
>> --- a/arch/parisc/include/uapi/asm/socket.h
>> +++ b/arch/parisc/include/uapi/asm/socket.h
>> @@ -121,6 +121,8 @@
>>   
>>   #define SO_NETNS_COOKIE		0x4045
>>   
>> +#define SO_BUF_LOCK		0x4046
>> +
>>   #if !defined(__KERNEL__)
>>   
>>   #if __BITS_PER_LONG == 64
>> diff --git a/arch/sparc/include/uapi/asm/socket.h b/arch/sparc/include/uapi/asm/socket.h
>> index 92675dc380fa..e80ee8641ac3 100644
>> --- a/arch/sparc/include/uapi/asm/socket.h
>> +++ b/arch/sparc/include/uapi/asm/socket.h
>> @@ -122,6 +122,8 @@
>>   
>>   #define SO_NETNS_COOKIE          0x0050
>>   
>> +#define SO_BUF_LOCK              0x0051
>> +
>>   #if !defined(__KERNEL__)
>>   
>>   
>> diff --git a/include/uapi/asm-generic/socket.h b/include/uapi/asm-generic/socket.h
>> index d588c244ec2f..1f0a2b4864e4 100644
>> --- a/include/uapi/asm-generic/socket.h
>> +++ b/include/uapi/asm-generic/socket.h
>> @@ -124,6 +124,8 @@
>>   
>>   #define SO_NETNS_COOKIE		71
>>   
>> +#define SO_BUF_LOCK		72
>> +
>>   #if !defined(__KERNEL__)
>>   
>>   #if __BITS_PER_LONG == 64 || (defined(__x86_64__) && defined(__ILP32__))
>> diff --git a/net/core/sock.c b/net/core/sock.c
>> index a3eea6e0b30a..843094f069f3 100644
>> --- a/net/core/sock.c
>> +++ b/net/core/sock.c
>> @@ -1357,6 +1357,14 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
>>   		ret = sock_bindtoindex_locked(sk, val);
>>   		break;
>>   
>> +	case SO_BUF_LOCK:
>> +		{
>> +		int mask = SOCK_SNDBUF_LOCK | SOCK_RCVBUF_LOCK;
> 
> What about define a marco with the above mask, and avoid the local
> variable declaration and brackets??!

Sure, will do.

> 
> Thanks!
> 
> Paolo
> 

-- 
Best regards, Tikhomirov Pavel
Software Developer, Virtuozzo.
