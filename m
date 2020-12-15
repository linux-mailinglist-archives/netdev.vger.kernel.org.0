Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E3692DA7C6
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 06:44:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726033AbgLOFns (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 00:43:48 -0500
Received: from mail-am6eur05on2107.outbound.protection.outlook.com ([40.107.22.107]:11851
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725889AbgLOFnr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Dec 2020 00:43:47 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bTmxhkRqwMuQVW1FaBhwcG1oEy14rUZhkXeTzyggLF1eC8XGsg1TfZBKLRAY1hLZ9wdsoyghfFoJCKvJ/Wu+1LveDIA+6wy5sFt+vlZ7Fz56H5eH+B6fvtLDhyAP5DMCJmMJVhsB06+C+xVUmVxgVQrGov1pB2G8aZl1Ksh1IbLbX0F33LMTt+6XUCFMQ8HLlGe8+bmO7pZI59BDCTeYWrI33oZuTBWWo4rNupgW8+0N+wHSAax2CdmlBh25th3Mj0EdCTcSHxmp50fqRFxiZwqmzakexvt2WQMUF5SJgP9/KWeNYrGgj2DkwSJRVvMI7ulpKasqWvAYVlowOnIneQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E+RvWkNSpc02NBiknJtrBly6Nu5jjc6UUcqCAxdKKIU=;
 b=kSstL6mOxjI6EW5L9X3SdSwlm3KiFJSZGFM6oEQWUe0bR7DeE+ZClFLo14VR0PlC66mCraBrdWWwq+Xoc+hzcOi0qV8RpgoTfkwSs1TzIMt0H6f21XHvnprSniXqwLfM9UNYcc/TTXkbTycrK5edmOy1G6xwPnyn4AXRArCqUP/px4tJDeUkb8ILDRZxWVfrDjeZR4vVJb7Xa+LRA9g60oQajpuFsuTRIKK5u4Ov0M1zKNyglKZLl4xVGGfDxHwAjINEZbl6kJtR/tC57SvYHFYZ5EZzwUYU4joKLfD85cLjqDATj6SrGTNLMAyreSCBXNV60QkcepiVZkL4fxeXkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E+RvWkNSpc02NBiknJtrBly6Nu5jjc6UUcqCAxdKKIU=;
 b=BSi9WAul6/yHv0AuoZuyrdWY31yr+HBXhfM7eb1GE0LVp67ewDVeoN6G31LpwxHf4hrnrKu6/ZBZMVB9ViygSBKADKsDK+Q2CoiZpcnI2JzWL2iszKly4WL2sOlL/fP193aV/qB2991DtwO2LZ17CaWGVAjlzVueW2dKyaXYBVo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=virtuozzo.com;
Received: from VI1PR0801MB1678.eurprd08.prod.outlook.com
 (2603:10a6:800:51::23) by VE1PR08MB5008.eurprd08.prod.outlook.com
 (2603:10a6:803:116::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.18; Tue, 15 Dec
 2020 05:42:58 +0000
Received: from VI1PR0801MB1678.eurprd08.prod.outlook.com
 ([fe80::b18d:c047:56c0:e0d3]) by VI1PR0801MB1678.eurprd08.prod.outlook.com
 ([fe80::b18d:c047:56c0:e0d3%9]) with mapi id 15.20.3654.024; Tue, 15 Dec 2020
 05:42:58 +0000
Subject: Re: [PATCH] net: check skb partial checksum offset after trim
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>
References: <7080e8a3-6eaa-e9e1-afd8-b1eef38d1e89@virtuozzo.com>
 <1f8e9b9f-b319-9c03-d139-db57e30ce14f@virtuozzo.com>
 <3749313e-a0dc-5d8a-ad0f-b86c389c0ba4@virtuozzo.com>
 <CA+FuTScG1iW6nBLxNSLrTXfxxg66-PTu3_5GpKdM+h2HjjY6KA@mail.gmail.com>
 <98675d3c-62fb-e175-60d6-c1c9964af295@virtuozzo.com>
 <CAF=yD-JqVEQTKzTdO1BaR_2w6u2eyc6FvtghFb9bp3xYODHnqg@mail.gmail.com>
 <20201214125430.244c9359@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CA+FuTSdHAEL1yoMoFJqDuh7ivXUp17EmXeYY-KFxobY9Hmfb4Q@mail.gmail.com>
From:   Vasily Averin <vvs@virtuozzo.com>
Message-ID: <6e956d96-0839-51f7-e1ea-16c3d179e9f2@virtuozzo.com>
Date:   Tue, 15 Dec 2020 08:42:56 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <CA+FuTSdHAEL1yoMoFJqDuh7ivXUp17EmXeYY-KFxobY9Hmfb4Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [185.231.240.5]
X-ClientProxiedBy: AM4PR05CA0019.eurprd05.prod.outlook.com (2603:10a6:205::32)
 To VI1PR0801MB1678.eurprd08.prod.outlook.com (2603:10a6:800:51::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [172.16.24.21] (185.231.240.5) by AM4PR05CA0019.eurprd05.prod.outlook.com (2603:10a6:205::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Tue, 15 Dec 2020 05:42:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5c0367ea-de95-4b5a-3c1a-08d8a0bc4752
X-MS-TrafficTypeDiagnostic: VE1PR08MB5008:
X-Microsoft-Antispam-PRVS: <VE1PR08MB50081CD39946D9F61B978AF5AAC60@VE1PR08MB5008.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X4McRjHTTZZVO0EHHg7SL/90TLwQXfrXLz7feI0IaGknXoh6RP608fKmd3qrJBwF2V1svfoNjPktIt5wahNZG0pTAA887PLbtIZL1iacj38hMM+xSbHJzMzCAYn+7aJA85Ur4rEbrbm2/RVDOlZgpN6VxY8cCJn8RrG8WdJmgFy3je/xHdzjGtOyfhyxagx2PhuhfhdWzc5fLMy2wmPc+C13w5nBV1SPaOjwnAYjCyYDPHSRmdB/e+1Jt0r/gObjUhbQ7AAh3CjubcqSmCjYBkUV+n4MF5ChjZ+gDTBRFQm1FZphebQpN4vAr6C1QIy1CbHOvrgQ1FDJdvzurnGTX41Y3s7DWQbg69W/0AGcqXYTF6hT2BHyYGzvVxTJfgP2QWu8rAJf5HbSqmlgzZJFJfClX3kgm63P5RLpn9AaD94=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0801MB1678.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(39840400004)(376002)(346002)(136003)(26005)(54906003)(83380400001)(8676002)(2906002)(66946007)(66476007)(31686004)(478600001)(66556008)(31696002)(86362001)(16576012)(2616005)(316002)(6486002)(16526019)(186003)(52116002)(110136005)(4326008)(8936002)(5660300002)(53546011)(956004)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?YkFVQ2xIcHhXWDhCTGZCYXpvbTc1SWJiaEtDZXluOG1ETytTd0dGeVFseWg1?=
 =?utf-8?B?N1YvcElnU283TnpLa1d3YjJhVXdHMGpDQ3V6NGZ0a0xuR0RXT1MvNTVaWXhu?=
 =?utf-8?B?L0dzbGxtL3RkYWt4bTdHYkt3MWppOTIvZ1ZjWVlKbTNuUEFtTWhmRzJhWFBi?=
 =?utf-8?B?UE81aEYvVnh4QWZzTDVQV1dRS0x6bU1YdXJiSWVSZnN5Wk1BRDFJR2dPUTNM?=
 =?utf-8?B?a21sVGwrTE5xT1ZwRWMwQTlvUDNUaXRUZVM3dTFwUmFIbWMzaGluVmkxdkpR?=
 =?utf-8?B?OFNLVkVzTDgxV29XNW1YREduOGdGQ3BUSHZPdkNPV2ZHMkJxNGJGMVlxbGZu?=
 =?utf-8?B?a2d0OU5YVWQ5S2ZIWUVsWGxxeFZ1cVlQc3JUSCtpbE1jUldxRWl6dm1kZXBs?=
 =?utf-8?B?UUFjREJVemVUeEMwZ2UwUi92dFFtNTNvVytzS0hYbWFOV2RmNmNOckFJZDRx?=
 =?utf-8?B?TDFrMzN4em02WnNjNnFkVm9tMHdNdDhRdnVBWGpPYXRVMktNTzVnOTlKVVYy?=
 =?utf-8?B?QkdPRU5Bb0RkWEVidXk0YWtDeWg0dWNvZ1BxQ1VvMElKN3cxMkNSM2JKam1n?=
 =?utf-8?B?eWJ4V0pCTzl4cjNYcE9KVjlNd1dCZnpOUzJjcGdrd3o3OUNJRjZzbzVoc2hH?=
 =?utf-8?B?MXZJbkpUdXVXYjNQNklXRXlUd3dsU1pKV0dadWs0SjNFVU5OR3dHWS82VFhz?=
 =?utf-8?B?TmFnYkVyRFZ4aDZhQkJPZHlzMDhiRUd4eEVaejdCcVZHYjRlTDMyRk5Danl2?=
 =?utf-8?B?UkxUbWNyQW9YTXdiK01ad1B4OGFKaEdKYjIxczduMUtyMkFISHRaaDVSaDFF?=
 =?utf-8?B?SU9UQll0WHo0VFFYZXJ0OWdESnFlc1ROODJJbmRiQUtldFJMcUVPMXVyUFdC?=
 =?utf-8?B?WjhYU0UwcmJla2VOVHJ2RklRZU9PaUUyRVBKWGlTQStoZkFoczlvMDVaNXph?=
 =?utf-8?B?SXIvSlA5bjM4Y3JtdzFVM25VWGRnQi9Ea0VmWXdkbksveEtNQnJaejVseUg4?=
 =?utf-8?B?T05VRERTdGpvVWZTMExYMnEwTFJOeWVITzJRMTNyZC9UdGY2ZVJFRVJYL09h?=
 =?utf-8?B?ejIrL2l6aGYydDBnSk5OekVyZk9UbmlNTFZWcG02WkhvUFR0WHF1cC9LMHJv?=
 =?utf-8?B?QmRTMkdJUWNZd3RYbTRvbWR2M3NSRWFhU2JORDA5RGNzdTREbis0SnFWODlT?=
 =?utf-8?B?N2JaN1haUi9qL1p5cjlXTlhXRjZ3VXh0cmNxMnJjWEo2SzBmUE9MdzBaL3JD?=
 =?utf-8?B?R1JveUtzMlhDdW5kL2NacEJDcE4xaUZ0STM1QTFpeENNVkRBQTZ5S1pxdlhU?=
 =?utf-8?Q?9lKzMuU6q3tuchWJTmmhB0MNPAKdbOXa2Q?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0801MB1678.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2020 05:42:58.1803
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c0367ea-de95-4b5a-3c1a-08d8a0bc4752
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OLx72dsrFHY7WDTLTgxhIjgAOQuzz3Ko8+zBRBM8fL1Cuc4TNIlMIibsb7tpHecbO7wk0aymuwfoVgY6+qM7Ew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB5008
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/15/20 12:07 AM, Willem de Bruijn wrote:
> On Mon, Dec 14, 2020 at 3:56 PM Jakub Kicinski <kuba@kernel.org> wrote:
>>
>> On Sun, 13 Dec 2020 20:59:54 -0500 Willem de Bruijn wrote:
>>> On Sun, Dec 13, 2020 at 2:37 PM Vasily Averin <vvs@virtuozzo.com> wrote:
>>>>>> On 12/11/20 6:37 PM, Vasily Averin wrote:
>>>>>>> It seems for me the similar problem can happen in __skb_trim_rcsum().
>>>>>>> Also I doubt that that skb_checksum_start_offset(skb) checks in
>>>>>>> __skb_postpull_rcsum() and skb_csum_unnecessary() are correct,
>>>>>>> becasue they do not guarantee that skb have correct CHECKSUM_PARTIAL.
>>>>>>> Could somebody confirm it?
>>>>>>
>>>>>> I've rechecked the code and I think now that other places are not affected,
>>>>>> i.e. skb_push_rcsum() only should be patched.
>>>>>
>>>>> Thanks for investigating this. So tun was able to insert a packet with
>>>>> csum_start + csum_off + 2 beyond the packet after trimming, using
>>>>> virtio_net_hdr.csum_...
>>>>>
>>>>> Any packet with an offset beyond the end of the packet is bogus
>>>>> really. No need to try to accept it by downgrading to CHECKSUM_NONE.
>>>>
>>>> Do you mean it's better to force pskb_trim_rcsum() to return -EINVAL instead?
>>>
>>> I would prefer to have more strict input validation in
>>> tun/virtio/packet (virtio_net_hdr_to_skb), rather than new checks in
>>> the hot path. But that is a larger change and not feasible
>>> unconditionally due to performance impact and likely some false
>>> positive drops. So out of scope here.
>>
>> Could you please elaborate? Is it the case that syzbot constructed some
>> extremely convoluted frame to trigger this?
> 
> Somewhat convoluted, yes. A packet with a checksum offset beyond the
> end of the ip packet.
> 
> skb_partial_csum_set (called from virtio_net_hdr_to_skb) verifies that
> the offsets are within the linear buffer passed from userspace, but
> without protocol parsing we don't know at that time that the offset is
> beyond the end of the packet.
> 
>> Otherwise the validation
>> at the source would work as well, no?
> 
> The problem with validation is two fold: it may add noticeable cost to
> the hot path and it may have false positives: packets that the flow
> dissector cannot fully dissect, but which are harmless and were
> previously accepted.
> 
> I do want to add such strict source validation based on flow
> dissection, but as an opt-in (sysctl) feature.
> 
>> Does it actually trigger upstream? The linked syzbot report is for 4.14
>> but from the commit description it sounds like the problem should repro
>> rather reliably.
> 
>>From the description, I would assume so, too. Haven't tested.

Original syzkaller reproducer fails on upstream because it prepares
invalid iptable ruleset, new kernels have more strict validation of iptable rules. 
I've commented this call im originsl reproducer and set the CHECKSUM rule manually,
then run of corrected reproducer triggered BUG_ON in skb_checksum_help().
I've crashed upstream 5.10-rc7 kernel by this way and then validated patched kernel.
originally we got such problem on RHEL7-based kernel, so I think the problem 
affects all stable and actual distribution kernels. 

Thank you,	
    Vasily Averin
