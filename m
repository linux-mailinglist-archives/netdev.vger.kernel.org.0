Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3D082A0395
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 12:02:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726236AbgJ3LB7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 07:01:59 -0400
Received: from novek.ru ([213.148.174.62]:53574 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726210AbgJ3LB7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Oct 2020 07:01:59 -0400
Received: from [192.168.0.18] (unknown [37.228.234.253])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id E8B80502F85;
        Fri, 30 Oct 2020 14:04:03 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru E8B80502F85
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1604055845; bh=PrpEpYhQegyhchA2jupLKgJhHGM+qns2hDQvcmgaSnw=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=avMKY/snwK9ft8vuiJLo/XyMIslZSj5uL7w5C/yqFg+FjXcawhNYT/4fufxWrc5+p
         asxmLsNx7wBFXsGeKHqOnvDUQxRq3bBDBDZBkIb+fRGjtdpF34RUC67VgL4jTrwraV
         dpTAiSL2CZh+Rxm+t7XT+n6YUDKmLBFVeMrKtE/k=
Subject: Re: [PATCH net] ip6_tunnel: set inner ipproto before ip6_tnl_encap.
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Alexander Ovechkin <ovov@yandex-team.ru>
Cc:     Network Development <netdev@vger.kernel.org>,
        Tom Herbert <tom@herbertland.com>
References: <20201016111156.26927-1-ovov@yandex-team.ru>
 <CA+FuTSe5szAPV0qDVU1Qa7e-XH6uO4eWELfzykOvpb0CJ0NbUA@mail.gmail.com>
 <0E7BC212-3BBA-4C68-89B9-C6DA956553AD@yandex-team.ru>
 <CA+FuTSfNZoONM3TZxpC0ND2AsiNw0K-jgjKMe0FWkS9LVG6yNA@mail.gmail.com>
 <ABA7FBA9-42F8-4D6E-9D1E-CDEC74966131@yandex-team.ru>
 <CA+FuTSeejYh2eu80bB8MikUMb7KevQN-ka-+anfTfQATPSrKHA@mail.gmail.com>
From:   Vadim Fedorenko <vfedorenko@novek.ru>
Message-ID: <93a65f76-3052-6162-a2f4-00091cd78927@novek.ru>
Date:   Fri, 30 Oct 2020 11:01:51 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CA+FuTSeejYh2eu80bB8MikUMb7KevQN-ka-+anfTfQATPSrKHA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED autolearn=ham
        autolearn_force=no version=3.4.1
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 29.10.2020 14:40, Willem de Bruijn wrote:
> On Thu, Oct 29, 2020 at 3:46 AM Alexander Ovechkin <ovov@yandex-team.ru> wrote:
>> On 28 Oct 2020, at 01:53 UTC Willem de Bruijn <willemdebruijn.kernel@gmail.com> wrote:
>>> On Tue, Oct 27, 2020 at 5:52 PM Alexander Ovechkin <ovov@yandex-team.ru> wrote:
>>>>> But it was moved on purpose to avoid setting the inner protocol to IPPROTO_MPLS. That needs to use skb->inner_protocol to further segment.
>>>> And why do we need to avoid setting the inner protocol to IPPROTO_MPLS? Currently skb->inner_protocol is used before call of ip6_tnl_xmit.
>>>> Can you please give example when this patch breaks MPLS segmentation?
>>> mpls_gso_segment calls skb_mac_gso_segment on the inner packet. After
>>> setting skb->protocol based on skb->inner_protocol.
>> Yeah, but mpls_gso_segment is called before ip6_tnl_xmit (because tun devices don't have NETIF_F_GSO_SOFTWARE in their mpls_features), so it does not matter to what value ip6_tnl_xmit sets skb->inner_ipproto.
>> And even if gso would been called after both mpls_xmit and ip6_tnl_xmit it would fail as you have written.
> Good point. Okay, if no mpls gso packets can make it here, then it
> should not matter.
>
> Vadim, are we missing another reason for this move?
>
> Else, no other concerns from me. Please do add a Fixes tag.
Could not reproduce the bug. Could you please provide a test scenario?

Anyway, all my scenarious with MPLS-in-IPv6 and MPLS-in-GUE are working so I'm 
ok with moving

