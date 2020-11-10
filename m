Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BAFF2ACF41
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 06:46:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731551AbgKJFq4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 00:46:56 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:3505 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729795AbgKJFq4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 00:46:56 -0500
Received: from [10.193.177.155] (bharat.asicdesigners.com [10.193.177.155] (may be forged))
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 0AA5kj67029840;
        Mon, 9 Nov 2020 21:46:47 -0800
Subject: Re: [PATCH net] net/tls: Fix kernel panic when socket is in TLS ULP
From:   Vinay Kumar Yadav <vinay.yadav@chelsio.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, borisp@nvidia.com,
        secdev@chelsio.com
References: <20201103104702.798-1-vinay.yadav@chelsio.com>
 <20201104171609.78d410db@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <976e0bb7-1846-94cc-0be7-9a9e62563130@chelsio.com>
 <20201105095344.0edecafa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <043b91f8-60e0-b890-7ce2-557299ee745d@chelsio.com>
 <20201105104658.4f96cc90@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <a9d6ec03-1638-6282-470a-3a6b09b96652@chelsio.com>
 <20201106122831.5fccebe3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <8c7a1bab-3c7b-e3bf-3572-afdf2abd2505@chelsio.com>
 <20201109105851.41417807@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <0cd430df-167a-be86-66c5-f0838ed24641@chelsio.com>
Message-ID: <bef56b83-add2-7007-d394-fe8b356f26b0@chelsio.com>
Date:   Tue, 10 Nov 2020 11:28:11 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <0cd430df-167a-be86-66c5-f0838ed24641@chelsio.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/10/2020 10:37 AM, Vinay Kumar Yadav wrote:
> 
> 
> On 11/10/2020 12:28 AM, Jakub Kicinski wrote:
>> On Tue, 10 Nov 2020 00:21:13 +0530 Vinay Kumar Yadav wrote:
>>> On 11/7/2020 1:58 AM, Jakub Kicinski wrote:
>>>> On Sat, 7 Nov 2020 02:02:42 +0530 Vinay Kumar Yadav wrote:
>>>>> On 11/6/2020 12:16 AM, Jakub Kicinski wrote:
>>>>>> On Thu, 5 Nov 2020 23:55:15 +0530 Vinay Kumar Yadav wrote:
>>>>>>>>>> We should prevent from the socket getting into LISTEN state in 
>>>>>>>>>> the
>>>>>>>>>> first place. Can we make a copy of proto_ops (like 
>>>>>>>>>> tls_sw_proto_ops)
>>>>>>>>>> and set listen to sock_no_listen?
>>>>>>>>>
>>>>>>>>> Once tls-toe (TLS_HW_RECORD) is configured on a socket, 
>>>>>>>>> listen() call
>>>>>>>>> from user on same socket will create hash at two places.
>>>>>>>>
>>>>>>>> What I'm saying is - disallow listen calls on sockets with tls-toe
>>>>>>>> installed on them. Is that not possible?
>>>>>>> You mean socket with tls-toe installed shouldn't be listening at 
>>>>>>> other
>>>>>>> than adapter? basically avoid ctx->sk_proto->hash(sk) call.
>>>>>>
>>>>>> No, replace the listen callback, like I said. Why are you talking 
>>>>>> about
>>>>>> hash???
>>>>>> As per my understanding we can't avoid socket listen.
>>>>> Not sure how replacing listen callback solve the issue,
>>>>> can you please elaborate ?
>>>>
>>>> TLS sockets are not supposed to get into listen state. IIUC the problem
>>>> is that the user is able to set TLS TOE on a socket which then starts
>>>> to listen and the state gets cloned improperly.
>>>
>>> TLS-TOE can go to listen mode, removing listen is not an option and
>>> TLS-TOE support only server mode so if we remove listen then we will not
>>> have TLS-TOE support which we don't want.
>>
>> Oh, so it's completely incompatible with kernel tls. How about we
>> remove the support completely then? Clearly it's not an offload of
>> kernel tls if it supports completely different mode of operation.
>>
> 
> It is not incompatible. It fits in k.org tls infrastructure (TLS-TOE 
> mode). For the current issue we have proposed a fix. What is the issue 
> with proposed fix, can you elaborate and we will address that?
and it is valid TLS offload mode.
