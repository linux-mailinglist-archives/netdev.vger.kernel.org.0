Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A694F1ECA12
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 09:02:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726469AbgFCHCo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 03:02:44 -0400
Received: from mail-eopbgr10069.outbound.protection.outlook.com ([40.107.1.69]:61606
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725855AbgFCHCn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Jun 2020 03:02:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=foP/9m4fM0caiNkFFN/x4ffSz05ayl+FY2HPkJbvuG+xoTjWV6CoAsL7tV11juWg+rG8zG6kPDz7le1skupEfeEU/IJ/jEGRFAcfr7LtMGd/fSCpHvXfwKqNP3xQcd05N6cYEKyR8dO6gYjJU/ckhEcuhulQX3E8Oiy9XLFRr0LGRzaPmWXp+QlOAymgdHBgZhQDNdj2UUQzUglKtpAiF8whzxeAvJFVhbjtvkULVciYMzsGOI+uAuxVf7ziZx6y8fb4y1P60ldGJxHV/ErV1N0ysCPGhJcYk9vBDVz68+IWVsZpPtayG+L2zKgmXtaGwT936Ea2FXa1X/2hMPAOSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a17eM8OJqmOL7vsLSx+DmvUUerRwSsC82V56G17CUN8=;
 b=ZJb45MuesBvPekL7/Vp+eKxT66r6sIkSTBid3Ww2ll2ZfSduOW8o59R0Sl1zXFTN6rKJVqP9GErvqI6JrAas7vDepF6CUdQjYkutfQ4ByW1QzsiDJx3i4lQzFwfLWaXf2TugualArS+VIgJf6NBX6T4pT6Xx730FJzYbKrEqU7ptv9rLbbvC3cJMIEXYckXj2dONKs+VdKHl66nwRPE8wLnFXpKLxx3Z54JiXZIc+Zyorb9u+uLZssn9MkamS8DgSw2W8B+HnzxoTnZCmeIGDr+tcnqwntfw1VQvNY+GwEjs0drieH8Jrnjm/Q3cdxQjb+8zUfYtz1JwPDZ+q3n7jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a17eM8OJqmOL7vsLSx+DmvUUerRwSsC82V56G17CUN8=;
 b=kGtZnmPZ2gXCylEEhHgdPLCFH7BWptJXVrYJ4gepNZunSDLf6jSG55s6TIea2UkQf524dLa+UZQX/Rep7fEVZ16rT9EEO28rHFfYfkjUa7PHQ+YaOWH4agihSdup8GvI8D41WUII5FTxAmg7glKOoo0cY3qT77bkh71KvlcBaXY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from VI1PR0501MB2205.eurprd05.prod.outlook.com
 (2603:10a6:800:2a::20) by VI1PR0501MB2464.eurprd05.prod.outlook.com
 (2603:10a6:800:6e::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.22; Wed, 3 Jun
 2020 07:02:38 +0000
Received: from VI1PR0501MB2205.eurprd05.prod.outlook.com
 ([fe80::d58c:3ca1:a6bb:e5fe]) by VI1PR0501MB2205.eurprd05.prod.outlook.com
 ([fe80::d58c:3ca1:a6bb:e5fe%5]) with mapi id 15.20.3045.024; Wed, 3 Jun 2020
 07:02:38 +0000
Subject: Re: [net-next 10/11] net/mlx5e: kTLS, Add kTLS RX resync support
To:     Jakub Kicinski <kuba@kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>
Cc:     Boris Pismenny <borisp@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20200529194641.243989-1-saeedm@mellanox.com>
 <20200529194641.243989-11-saeedm@mellanox.com>
 <20200529131631.285351a5@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <e0b8a4d9395207d553e46cb28e38f37b8f39b99d.camel@mellanox.com>
 <20200529145043.5d218693@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <27149ee9-0483-ecff-a4ec-477c8c03d4dd@mellanox.com>
 <20200601151206.454168ad@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <4f07f3e0-8179-e70a-71a5-9f0407b709d6@mellanox.com>
 <20200602113148.47c2daea@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Tariq Toukan <tariqt@mellanox.com>
Message-ID: <3895f115-6a0b-29ff-83b9-7e099819a570@mellanox.com>
Date:   Wed, 3 Jun 2020 10:02:33 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
In-Reply-To: <20200602113148.47c2daea@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR10CA0002.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:17c::12) To VI1PR0501MB2205.eurprd05.prod.outlook.com
 (2603:10a6:800:2a::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.110] (77.125.6.235) by AM0PR10CA0002.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:17c::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.18 via Frontend Transport; Wed, 3 Jun 2020 07:02:37 +0000
X-Originating-IP: [77.125.6.235]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 64b733fd-f1cd-4d45-cf50-08d8078c19b2
X-MS-TrafficTypeDiagnostic: VI1PR0501MB2464:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0501MB246469586D014B6869EBC91DAE880@VI1PR0501MB2464.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 04238CD941
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eHv5lvsQsLPJvzo2hXt9BjYkqpKuY9EOg8Yo0PS192XPSk0wbQdTc4OY1npE4/QlleZfBv7ojvotA0jNMhta2ZwTW5s1auTuG0HKhxgqQ6XviHY/ysMM6VHrSms+Nhgec5PK3cIwDO/AtmWuOIVAKRv6e+hRA49maA1enM9ayY+Sd8EvUkPY+5aVHy9AhhzyABfBUkT4a5HfsY+U3jpJcBph6Mr/jsf3waRDwCQ1E+E+XHSr0FYNxD0O3VHdSeycilwl7rN8GIy47tivf9EmPT//JSJmphwKYNYgJEV7aUa8yrTM2NdAIMvxe5EqMsbo4yAgH2eiQMf8iAC5dZvyZ5ikgHZgcV4gyMJ5zEO1L1YgN2BgXHinv70IGxXzMMam
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0501MB2205.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(136003)(366004)(39860400002)(346002)(376002)(53546011)(8936002)(6666004)(66946007)(186003)(52116002)(31696002)(66556008)(8676002)(66476007)(26005)(54906003)(5660300002)(83380400001)(6486002)(110136005)(316002)(16576012)(16526019)(4326008)(2906002)(956004)(36756003)(2616005)(478600001)(31686004)(86362001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: CZBaF87P7pd1tv1AoT3Lox93WVh/mklSo/kWo601ozvLqKl2hvi99vaq/748EIMioKcHKGFJqx1Ofjcsj/YvNc1D8qKvf+5CKeL0qW0F5L27J3F9qMO7H1t1ckTxnESBfEBeswg6fVOVFtkkk3tIu/8z59SY5LOaXv1/Zp+kb8PczXgSAgFej427eyJjnwNa+WEvgjVfq0X5QXqddsPFHOV8sgQ2dSYKeK9ZnuRDCnF0aXPds8V9Wysp6drEi/QH0W2JIdAczF7fTNHrb87Cnn1fkh16fy9YOkmB7vyPdzDqxE0DaZjpGNaFG2/ajKu78nRXVTai/PdTjx3Y2nAfxMZ/m3IIs4Jxlq5c6mKfDdce0EuKcAt4Vo/3WDeZK12zDt3hxyHqIM5TZj656ZWlX7TWIlvgblKFGhIM8KBONkhaJ9iAexXp5w1+LjVcE9xme3QAFwm9OW6lqRmCyX8oP1/QqwHKTBiy+9GVJIWKWcg=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64b733fd-f1cd-4d45-cf50-08d8078c19b2
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2020 07:02:38.2689
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: udjrZF4XoXZgchqg4yaP3ORDPD7xK/3jM/zCQkhNz+Evu47W1KMu6BZxdlgi4OpjKj6klLopVPTRjdVeGLWERQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2464
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/2/2020 9:31 PM, Jakub Kicinski wrote:
> On Tue, 2 Jun 2020 14:32:44 +0300 Tariq Toukan wrote:
>> On 6/2/2020 1:12 AM, Jakub Kicinski wrote:
>>>>>> This is a rare corner case anyway, where more than 1k tcp
>>>>>> connections sharing the same RX ring will request resync at the
>>>>>> same exact moment.
>>>>>
>>>>> IDK about that. Certain applications are architected for max
>>>>> capacity, not efficiency under steady load. So it matters a lot how
>>>>> the system behaves under stress. What if this is the chain of
>>>>> events:
>>>>>
>>>>> overload -> drops -> TLS steams go out of sync -> all try to resync
>>>>>      
>>>>
>>>> I agree that this is not that rare, and it may be improved both in
>>>> future patches and hardware. Do you think it is critical to improve
>>>> it now, and not in a follow-up series?
>>>
>>> It's not a blocker for me, although if this makes it into 5.8 there
>>> will not be a chance to improve before net-next closes, so depends if
>>> you want to risk it and support the code as is...
>>>    
>>
>> Hi Jakub,
>> Thanks for your comments.
>>
>> This is just the beginning of this driver's offload support. I will
>> continue working on enhancements and improvements in next kernels.
>> We have several enhancements in plans.
>>
>> For now, if no real blockers, I think it's in a good shape to start with
>> and make it to the kernel.
>>
>> IMHO, this specific issue of better handling the resync failure in
>> driver can be addressed in stages:
>>
>> 1. As a fix: stop asking the stack for resync re-calls. If a resync
>> attempt fails, terminate any resync attempts for the specific connection.
>> If there's room for a re-spin I can provide today. Otherwise it is a
>> simple fix that can be addressed in the early rc's in -net.
>> What do you think?
>>
>> 2. Recover: this is an enhancement to be done in future kernels, where
>> the driver internally and independently recovers from failed attempts
>> and makes sure the are processed when there's enough room on the SQ
>> again. Without the stack being engaged.
> 
> IIUC the HW asks for a resync at the first record after a specific seq
> (the record header is in the frame that carried the OOO marking, right?)
> 
> Can we make the core understand those semantics and avoid trying to
> resync at the wrong record?
> 

HW asks for a resync when it is in tracking mode and identifies the 
magic, so it calculates the expected seq of next record.
This seq is not part of the completion (for now, this is a planned 
enhancement), so the device driver posts a request to the device to get 
the seq, and then the driver hopefully approve it (by another post to 
the HW) after comparing it to the stack sw seq.

As long as the device driver does not know the HW expected seq, it 
cannot provide a seq to the stack. So force resync is used.

We can think of an optimization here, it is doable.
