Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C17849EB44
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 20:44:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245720AbiA0ToY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 14:44:24 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.50]:36611 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245680AbiA0ToX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 14:44:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1643312660;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=EVzRmsDZ9FjMQAsnoiO4yhv7VR9Z+QFCW+RBfkJ/bvg=;
    b=RnwTtusYLwSXgtVe1aWnplrlRdKRVQ2VKPZMWbFIdAdtiTxOKeQjdlAi3AVoNZI0HM
    30ZW3kM9L/WP5BGV5ha0r5/JymlypBPJupNgLOPeNFI1KFdBUxIkwRX2ufz8uApDiB9u
    72rK5x1DQpaImK1UyOkfmTTyRkbGWkqYdNbEwbI92KI2Rcm5QdOj3YF04Zq+PEBNMWPM
    5rvvRRCyiR2Jq7ocI3p7aBjQFgyB8keoVpDqWNsknfzb7pVWD57pVBd0zFbRwUeHbs2z
    nFZ5RchsMCN0X9RH4J9FNyMXi1G74IdvuuGjUPcE82z2m0bYlpQJO3hDdmOkrCAZmmZj
    u/fA==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1qCHSa1GLptZHusx3hdd0DIgVvBOfBkHJSg=="
X-RZG-CLASS-ID: mo00
Received: from [IPV6:2a00:6020:1cfa:f904::923]
    by smtp.strato.de (RZmta 47.38.0 AUTH)
    with ESMTPSA id zaacbfy0RJiJPEb
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Thu, 27 Jan 2022 20:44:19 +0100 (CET)
Message-ID: <97339463-b357-3e0e-1cbf-c66415c08129@hartkopp.net>
Date:   Thu, 27 Jan 2022 20:44:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net] can: isotp: isotp_rcv_cf(): fix so->rx race problem
Content-Language: en-US
To:     "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>,
        mkl@pengutronix.de
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220117120102.2395157-1-william.xuanziyang@huawei.com>
 <53279d6d-298c-5a85-4c16-887c95447825@hartkopp.net>
 <280e10c1-d1f4-f39e-fa90-debd56f1746d@huawei.com>
 <eaafaca3-f003-ca56-c04c-baf6cf4f7627@hartkopp.net>
 <890d8209-f400-a3b0-df9c-3e198e3834d6@huawei.com>
 <1fb4407a-1269-ec50-0ad5-074e49f91144@hartkopp.net>
 <2aba02d4-0597-1d55-8b3e-2c67386f68cf@huawei.com>
 <64695483-ff75-4872-db81-ca55763f95cf@hartkopp.net>
 <d7e69278-d741-c706-65e1-e87623d9a8e8@huawei.com>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
In-Reply-To: <d7e69278-d741-c706-65e1-e87623d9a8e8@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Ziyang Xuan,

On 21.01.22 02:50, Ziyang Xuan (William) wrote:
>>
>> On 20.01.22 12:28, Ziyang Xuan (William) wrote:
>>>>
>>>> On 20.01.22 07:24, Ziyang Xuan (William) wrote:
>>>>
>>>>> I have reproduced the syz problem with Marc's commit, the commit can not fix the panic problem.
>>>>> So I tried to find the root cause for panic and gave my solution.
>>>>>
>>>>> Marc's commit just fix the condition that packet size bigger than INT_MAX which trigger
>>>>> tpcon::{idx,len} integer overflow, but the packet size is 4096 in the syz problem.
>>>>>
>>>>> so->rx.len is 0 after the following logic in isotp_rcv_ff():
>>>>>
>>>>> /* get the FF_DL */
>>>>> so->rx.len = (cf->data[ae] & 0x0F) << 8;
>>>>> so->rx.len += cf->data[ae + 1];
>>>>>
>>>>> so->rx.len is 4096 after the following logic in isotp_rcv_ff():
>>>>>
>>>>> /* FF_DL = 0 => get real length from next 4 bytes */
>>>>> so->rx.len = cf->data[ae + 2] << 24;
>>>>> so->rx.len += cf->data[ae + 3] << 16;
>>>>> so->rx.len += cf->data[ae + 4] << 8;
>>>>> so->rx.len += cf->data[ae + 5];
>>>>>
>>>>
>>>> In these cases the values 0 could be the minimum value in so->rx.len - but e.g. the value 0 can not show up in isotp_rcv_cf() as this function requires so->rx.state to be ISOTP_WAIT_DATA.
>>>
>>> Consider the scenario that isotp_rcv_cf() and isotp_rcv_cf() are concurrent for the same isotp_sock as following sequence:
>>
>> o_O
>>
>> Sorry but the receive path is not designed to handle concurrent receptions that would run isotp_rcv_cf() and isotp_rcv_ff() simultaneously.
>>
>>> isotp_rcv_cf()
>>> if (so->rx.state != ISOTP_WAIT_DATA) [false]
>>>                          isotp_rcv_ff()
>>>                          so->rx.state = ISOTP_IDLE
>>>                          /* get the FF_DL */ [so->rx.len == 0]
>>> alloc_skb() [so->rx.len == 0]
>>>                          /* FF_DL = 0 => get real length from next 4 bytes */ [so->rx.len == 4096]
>>> skb_put(nskb, so->rx.len) [so->rx.len == 4096]
>>> skb_over_panic()
>>>
>>
>> Even though this case is not possible with a real CAN bus due to the CAN frame transmission times we could introduce some locking (or dropping of concurrent CAN frames) in isotp_rcv() - but this code runs in net softirq context ...
>>

As discussed off-list I added a spin_lock() in isotp_rcv() as 
https://www.kernel.org/doc/htmldocs/kernel-locking/lock-softirqs.html 
suggests.

Please give this patch[1] a try in your test setup.

Many thanks,
Oliver

[1]: 
https://lore.kernel.org/linux-can/20220127192429.336335-1-socketcan@hartkopp.net/T/
