Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 262D12A85F3
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 19:15:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732280AbgKESPe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 13:15:34 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:11912 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731871AbgKESOS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 13:14:18 -0500
Received: from [10.193.177.147] (lakshmi-pc.asicdesigners.com [10.193.177.147] (may be forged))
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 0A5IE6U3008829;
        Thu, 5 Nov 2020 10:14:07 -0800
Subject: Re: [PATCH net] net/tls: Fix kernel panic when socket is in TLS ULP
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, borisp@nvidia.com,
        secdev@chelsio.com
References: <20201103104702.798-1-vinay.yadav@chelsio.com>
 <20201104171609.78d410db@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <976e0bb7-1846-94cc-0be7-9a9e62563130@chelsio.com>
 <20201105095344.0edecafa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Message-ID: <043b91f8-60e0-b890-7ce2-557299ee745d@chelsio.com>
Date:   Thu, 5 Nov 2020 23:55:15 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201105095344.0edecafa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/5/2020 11:23 PM, Jakub Kicinski wrote:
> On Thu, 5 Nov 2020 23:20:13 +0530 Vinay Kumar Yadav wrote:
>> On 11/5/2020 6:46 AM, Jakub Kicinski wrote:
>>> On Tue,  3 Nov 2020 16:17:03 +0530 Vinay Kumar Yadav wrote:
>>>> user can initialize tls ulp using setsockopt call on socket
>>>> before listen() in case of tls-toe (TLS_HW_RECORD) and same
>>>> setsockopt call on connected socket in case of kernel tls (TLS_SW).
>>>> In presence of tls-toe devices, TLS ulp is initialized, tls context
>>>> is allocated per listen socket and socket is listening at adapter
>>>> as well as kernel tcp stack. now consider the scenario, connections
>>>> are established in kernel stack.
>>>> on every connection close which is established in kernel stack,
>>>> it clears tls context which is created on listen socket causing
>>>> kernel panic.
>>>> Addressed the issue by setting child socket to base (non TLS ULP)
>>>> when tls ulp is initialized on parent socket (listen socket).
>>>>
>>>> Fixes: 76f7164d02d4 ("net/tls: free ctx in sock destruct")
>>>> Signed-off-by: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
>>>
>>> We should prevent from the socket getting into LISTEN state in the
>>> first place. Can we make a copy of proto_ops (like tls_sw_proto_ops)
>>> and set listen to sock_no_listen?
>>
>> Once tls-toe (TLS_HW_RECORD) is configured on a socket, listen() call
>> from user on same socket will create hash at two places.
> 
> What I'm saying is - disallow listen calls on sockets with tls-toe
> installed on them. Is that not possible?
>
You mean socket with tls-toe installed shouldn't be listening at other
than adapter? basically avoid ctx->sk_proto->hash(sk) call.

>> tls_toe_hash() ---> ctx->sk_proto->hash(sk); dev->hash(dev, sk);
>>
>> when connection establishes, same sock is cloned in case of both
>> (connection in adapter or kernel stack).
>>
>> Please suggest if we can handle it other way?
> 
