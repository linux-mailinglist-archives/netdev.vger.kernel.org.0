Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DBAD3E5883
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 12:43:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236476AbhHJKoN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 06:44:13 -0400
Received: from mail-dm6nam08on2053.outbound.protection.outlook.com ([40.107.102.53]:49376
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231705AbhHJKoM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 06:44:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j9NaFrXmsIF+B1UaBhCToiFtuYwlXeSmEYaqReylWF148EePr4h5ipWSvSyuxYBkmxMa0IIQF1a1DeNo/F4/Xd6tp6TxYYVgBCr4RJIun9eYEfQJHURejm5qLzZBxBnQCZoD2O2SOmh767S31uIXC0DTX9D6b1RfXlNoaQK0hv9q3Y2QYd0w1Hhktjq/KZxyjWwjhLoELQXlC5U2s0+vMDb3sl9hMtUr5i7JBz8XrCCtCDQdE7wKadufYSBtc5e7Dg5dTCJbzBRddJLaeXr1rhnX9QqMCrP7VjBdinVFssRRuhml2dXxvBucrhpaSwgcFPz+OaQzU07Q4MjF3acenA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HVzNtu2QXU8lmc9mizTVY1B13xdizkdC/1812TUsFJQ=;
 b=Tr704PUQ6GDfdm/JdtAAcjsh4/tgcMZzswWuEUD9s9o5gTZ9KVHvtGR9UFWfR1E+MDiKIGR+cqg0VS2klfoLgCGJXKC4uQwfiWbA7muAYDlOI5hm5MyF8G7pY9+NmKZoveadEp+lJRhpHIw8zRtrbFsnbnn3Wk5kNmA86YMWe307X/skpyX7SM7zOzzDJSVQrwL1ICMu4GVIMyGpsWK8YxEyBzEujLuEGa6MbTWcm4ae/uNjwDf/V9mvusXjTQnJNc9sQQ/jAnXD9eJX87Srt9bA64NiK10tH5O51s5NL+OXsWbps831/ZUR9YP255aEo/9bGBxTLsJoRaWFthD0Aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HVzNtu2QXU8lmc9mizTVY1B13xdizkdC/1812TUsFJQ=;
 b=bJmwxYn1FM4rqc3VOAG3RrfK7blCgGfbeW4rt0pwEryfj7HnG1nB/4pGVqxkT9ZQBxLWAkAyTmhSdfHp5K2FUXCxUxtEBtza1OvnmGIjEdkFRMrfWVP17E9tyocTbypv6NyMOoP00xyCTiK8hcPT7x6xNpj9LqdA3P5ahCz2jwVPkl8zKKm0h6r6RnT1ol0xp2hUPiT7TuKKdmuutZuvt5tnwyMJcf2gCdYOc82zA5z8Y71K9iHCqYnF7I4vDAD5aD2Ed6aqifzwq2dby+cbhmjoFDDc7hdNrsWmxwa0vc+N57suMjkBQZU3++i2uDiWsB/qVqCdXsP4VOOXUTVaJg==
Authentication-Results: syzkaller.appspotmail.com; dkim=none (message not
 signed) header.d=none;syzkaller.appspotmail.com; dmarc=none action=none
 header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM4PR12MB5213.namprd12.prod.outlook.com (2603:10b6:5:394::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17; Tue, 10 Aug
 2021 10:43:49 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::c170:83a0:720d:6287]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::c170:83a0:720d:6287%6]) with mapi id 15.20.4394.023; Tue, 10 Aug 2021
 10:43:49 +0000
Subject: Re: [PATCH net] net: bridge: validate the NUD_PERMANENT bit when
 adding an extern_learn FDB entry
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Ido Schimmel <idosch@idosch.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@resnulli.us>, Roopa Prabhu <roopa@nvidia.com>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        "syzbot+9ba1174359adba5a5b7c@syzkaller.appspotmail.com" 
        <syzbot+9ba1174359adba5a5b7c@syzkaller.appspotmail.com>
References: <20210801231730.7493-1-vladimir.oltean@nxp.com>
 <YREcqAdU+6IpT0+w@shredder> <20210809160521.audhnv7o2tugwtmp@skbuf>
 <YRIgynudgTsOpe5q@shredder> <20210810100928.uk7dfstrnts2may4@skbuf>
 <c6d91ec7-6081-85d0-9bc8-569838d8f9a4@nvidia.com>
 <20210810103840.oequsjeg5be2jkkz@skbuf>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <bd891cb9-a5d8-1341-15cd-cba3c118f76a@nvidia.com>
Date:   Tue, 10 Aug 2021 13:43:41 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <20210810103840.oequsjeg5be2jkkz@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZRAP278CA0007.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:10::17) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.241.235] (213.179.129.39) by ZRAP278CA0007.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:10::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.16 via Frontend Transport; Tue, 10 Aug 2021 10:43:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7706cf97-69f6-4734-9a59-08d95bebbcc2
X-MS-TrafficTypeDiagnostic: DM4PR12MB5213:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM4PR12MB5213DEEDFACB4852008B5A2CDFF79@DM4PR12MB5213.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SrZMaszxbV4r0YQ/5jB/jIXZVrR1LwTDt6QE3L1Z9I3M8trz0yP8re5D1mJWcyhTJ/SrKOwjASj8HodK79v0s0TCTjrRj5EVmc9OsYQ5GFz2xZLUrwuFiYvmJyprRywI44a68/fMNOwsLUJGfGPSrrSjTHG1HjyTlGbcA+OU1764vJ+f4UI/8KdKvM2VeDeaytoCADUes4Mcjydp6kjb9446OtuwiBXaUtvshL1MYKC7b/DMU4DyVqMddpHj2ychZCLWhcbO2vOIzp4yn+SP3EXMjco3mMSh13xcf7VPzsp96SbWkDb0q7LvsZrmn0jsBb1wETG5zMXeNZr3IVAKbWmzwzkCdGTSY4IuqvlN+rQESM5S728H+fThvqeRmn6yze3k6w0zt7+NFpIS1IsU2X3nMD3cobIo1SBwbhRapInOIw2boKOpgdKrE40FC89SwywF1vszXQGYhpgouYuzx2q7aL5oaqTmh5DdjnkjM3+vkcB77roH8/xT2x/BeQeTyRFr6wcGau9Ddg9kBWh7ZBqXIKdc9WiirBxm8Rg2cakPYCnZhh/YDVSNH7m3g8qBBuDvA0sdkAKw2gTgdtR7pGyt1/i4UMBGz3ZmF46MMuq9rXKq9P5q9LBKy7DBAobLNTOJGoQKlZn9NhD8akwCo18rmKy3nvU70w2suBCx4F7347xjK/q94RdY0tpgBr88A3gI14XCBQXTMk2Coqfsba044FRukK1mkJYv/T84N6U=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(83380400001)(316002)(4326008)(16576012)(53546011)(26005)(186003)(54906003)(508600001)(6666004)(36756003)(6916009)(31696002)(86362001)(8676002)(15650500001)(8936002)(66476007)(66556008)(66946007)(6486002)(38100700002)(31686004)(2616005)(956004)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SStNSGNyV05iV1ZhQ0FBYVRKc0txcm5PaU5KZkF6U2VLME8xNFd0dXBYNWNh?=
 =?utf-8?B?RG5uZmpEaTFHd3dMQlVJenJGMkNBWEpndUVkRllKWmFPMWs1UHFxTnJvcW4w?=
 =?utf-8?B?MXhxM2FSNXpFQTdRYnVIN2tFMVVaekFySXFkRXpac0FMbWk4cXFTMW1WcHNq?=
 =?utf-8?B?VTFkQXo5Y3Ira25uV1FSTEgvT1k0THhuQ3Q5NU5PamQ4Ni9QYlV2M1BROWRH?=
 =?utf-8?B?UGRaQXpZOVRwaEU2VzR1K0Q1K1RNMVREV25jZEs2UngrN3RVK1VSYnV4eEMz?=
 =?utf-8?B?YlBkcWVOZDRYT0tWYjRDM0JpUVhhbEpJd3l6bUFER0swaGs5bWszQXAzbWpX?=
 =?utf-8?B?VCs1QXZ0c2pIa1NiSUJhdDRhTmJvYjhMWmJ1OUFZRVVxM2IwZ1pVQmw4ZkdY?=
 =?utf-8?B?Qjd1NG9zeC9MMzQyQnFuOUVkTW9PRUFQeFBvZ3ZKYXBOM2hzWWZLLzdoS0Qx?=
 =?utf-8?B?bVVGdzNra05sVTZ2S3UzdEdSYmNsRzV2cTZvZEEzT2NuNG5DalY3UWlIL3N1?=
 =?utf-8?B?aWphUWJzbXJTUUN5bjRRaGRvWHZLNkpxcWhvcXB2eDZmMzF1Q29MZUt1cGFx?=
 =?utf-8?B?aFExMUVKNDUwOXYrZUIwSWRrVTRYQ1NSbU5YMHRUSk04RWlpZWE2NHM2TXEw?=
 =?utf-8?B?SVkrTDVoNG1oWUlnc245b0NzSWNQVERXV2Z2TUVzNWFGNUF5ZWlIRUVNSklG?=
 =?utf-8?B?Lzd5T2dzRGNzaEY1U20zOGlCVEFTRmFHZFZwbUxORFlOM3VwSWtTUjhMQU5C?=
 =?utf-8?B?dzVzR3FyU0NRLzYrN2tNcEdMTllIOGZkQUc3dFJLeUVDTUFFRTlNWndoSnBR?=
 =?utf-8?B?ZDduaUNrSEN4Z2VQQU5jbkFmeUViZlh1YlVrblJjRWh3OWRjUEV6YTZ5SGRR?=
 =?utf-8?B?TkRqazRCeU1NSTVLbEMwV0RybFI4SzlvOXF6U3dYV1pJT21WaDgrUjVUUDBT?=
 =?utf-8?B?cG0ydGNWTUgrdlhyRzN1NW1qaGZEZ3EzWFE1alBjTTdtL2E3WDFkUkNTeXhi?=
 =?utf-8?B?YmwwT0tNMFFqK1hHdU9mWUp6RXZtTmEzL3RYdWRoVVowNkRDSXo1aHJxdk9W?=
 =?utf-8?B?QjF5M1hIWjRJa1pvSlBSN0xUd0NnZkthbHBBRXVQekkrWlk3dThBR1BuZnNF?=
 =?utf-8?B?Y1E1aVE5S2s3VnRlVmxKaDYrY1YxVS9uU1k1bjF4a3pkcExwOCtqb1RhN0dP?=
 =?utf-8?B?bWZlYWtGbVJORkR1YlhqNTNlT0FqYWU1bGJIdHpjRjNpR3dhVm1TR3pwamtS?=
 =?utf-8?B?dTFibFZZRXhDUU10aUc2VWFJOThiWDFKTTJWZlNndCtWUlM1TkR6Mk54UDRx?=
 =?utf-8?B?dlFOM0xRYy94OUp4WVpHLzBHNzBVTFd2ZXNtblBKZ29XNlhic0k0Z08yVWtX?=
 =?utf-8?B?dENIUUlaRzhFMmYzcVQvc0pTcyt6aWNhWCtZaXNRN01GSUFTTW0rTEtXd1BK?=
 =?utf-8?B?M0EwWTN6elVRVjREZ3JYYS82UUNyOUFhZDAvMFgrTWNkWmhndmI3QXN1NEhR?=
 =?utf-8?B?akFLUTVEa3IyNU1mazR0Z3kzdFFSckVKc0FxN1lMUjczV2UrYjlVNVBkdXBT?=
 =?utf-8?B?alJqU0xOQnpoSGhOQVB6a3pVZmtSWU54bU9mRW10ZnJJellja0RUZHBndHox?=
 =?utf-8?B?ZUJNRnA1TXF2dHlTajZaL0t0UFVpQWNnNENnMWJXcHprWmxQUXlwWXhxaTh5?=
 =?utf-8?B?VXMxNjdwR3JOYmtiVW1PZlBjLy80MVdoTGZtU0FtUDZTUVNHcE04d1M4RWR4?=
 =?utf-8?Q?T/W4BL7HQMlTmCKdWSYEBDoKwWGZpSLRfsDYE60?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7706cf97-69f6-4734-9a59-08d95bebbcc2
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2021 10:43:49.4337
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UtvuUpzbWjx3tDflWTzspqatHzxyIk6sSDA3vd2tlGAb/gj9Ze2nrp8xdjo9qKuxhQMmGIco7VYGKmj/VWDzyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5213
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/08/2021 13:38, Vladimir Oltean wrote:
> On Tue, Aug 10, 2021 at 01:15:32PM +0300, Nikolay Aleksandrov wrote:
>> On 10/08/2021 13:09, Vladimir Oltean wrote:
>>> On Tue, Aug 10, 2021 at 09:46:34AM +0300, Ido Schimmel wrote:
>>>> On Mon, Aug 09, 2021 at 04:05:22PM +0000, Vladimir Oltean wrote:
>>>>> On Mon, Aug 09, 2021 at 03:16:40PM +0300, Ido Schimmel wrote:
>>>>>> I have at least once selftest where I forgot the 'static' keyword:
>>>>>>
>>>>>> bridge fdb add de:ad:be:ef:13:37 dev $swp1 master extern_learn vlan 1
>>>>>>
>>>>>> This patch breaks the test when run against both the kernel and hardware
>>>>>> data paths. I don't mind patching these tests, but we might get more
>>>>>> reports in the future.
>>>>>
>>>>> Is it the 'static' keyword that you forgot, or 'dynamic'? The
>>>>> tools/testing/selftests/net/forwarding/bridge_vlan_aware.sh selftest
>>>>> looks to me like it's testing the behavior of an FDB entry which should
>>>>> roam, and which without the extern_learn flag would be ageable.
>>>>
>>>> static - no aging, no roaming
>>>> dynamic - aging, roaming
>>>> extern_learn - no aging, roaming
>>>>
>>>> So these combinations do not make any sense and the kernel will ignore
>>>> static/dynamic when extern_learn is specified. It's needed to work
>>>> around iproute2 behavior of "assume permanent"
>>>
>>> Since NTF_EXT_LEARNED is part of ndm->ndm_flags and NUD_REACHABLE/NUD_NOARP
>>> are part of ndm->ndm_state, it is not at all clear to me that 'extern_learn'
>>> belongs to the same class of bridge neighbor attributes as 'static'/'dynamic',
>>> and that it is invalid to have the full degree of freedom. If it isn't,
>>> shouldn't the kernel validate that, instead of just ignoring the ndm->ndm_state?
>>> If it's too late to validate, shouldn't we at least document somewhere
>>> that the ndm_state is ignored in the presence of ndm_flags & NTF_EXT_LEARNED?
>>> It is user API after all, easter eggs like this aren't very enjoyable.
>>>
>>
>> It's too late unfortunately, ignoring other flags in that case has been the standard
>> behaviour for a long time (it has never made sense to specify flags for extern_learn
>> entries). I'll send a separate patch that adds a comment to document it or if you have
>> another thing in mind feel free to send a patch.
> 
> No, I don't have anything else in mind, but since the topic is the same
> as the "net: bridge: fix flags interpretation for extern learn fdb entries"
> patch you already sent, you could as well just send a v2 for that and
> add an extra phrase in a comment somewhere near a NTF_EXT_LEARNED uapi
> definition, or perhaps extend this comment right here:
> 
> /* NUD_NOARP & NUD_PERMANENT are pseudostates, they never change
>    and make no address resolution or NUD.
>    NUD_PERMANENT also cannot be deleted by garbage collectors.
>  */
> 

sure, I was going to send it for net-next, but I might as well do it in -net.

