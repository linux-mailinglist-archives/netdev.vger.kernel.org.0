Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A9781549F7
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 18:07:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727788AbgBFRG5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 12:06:57 -0500
Received: from mo4-p00-ob.smtp.rzone.de ([85.215.255.22]:35466 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727060AbgBFRG4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Feb 2020 12:06:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1581008815;
        s=strato-dkim-0002; d=hartkopp.net;
        h=In-Reply-To:Date:Message-ID:From:References:To:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=Xekbzm1y2eWDWsDBv6FcjQ0BHpS6U3SXQC6QFTLcRj0=;
        b=bodMkOqa9AHbl4fMPWmMPbQ4F7vmhA2GU0dVZ/+Y3J8CrjgZChOsIEDq5e6yfCi98g
        9PLwQgVG+7DjjVxQ89NK1OCg3zzA3h+MpUI0M++/i/WjGZh6E85OoEl2+g9obfvGMXgF
        IBmEpQUGVgBd393VE6sEYWh4RLI8hLapPS7CGWL8Z1I8A1t95NIKZk3IYK/+I5MdrqJq
        U9FZEdU7EL3RZfgppwoSvoKPh5DvfDo3DnMdy9tJD3DZCy8YiXuBuyC676I+hjyQnx2y
        nFYX0S6C82Qkh4cMGSW1tpZ7fxW90iRse1Fm0wuc4nCs0ZErHJApRVn56TOheaZY2cNL
        Q6wA==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1o3PMaViOoLMJU8h6kUuM"
X-RZG-CLASS-ID: mo00
Received: from [192.168.1.177]
        by smtp.strato.de (RZmta 46.1.12 DYNA|AUTH)
        with ESMTPSA id g084e8w16H6oKc1
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Thu, 6 Feb 2020 18:06:50 +0100 (CET)
Subject: Re: [BUG] pfifo_fast may cause out-of-order CAN frame transmission
To:     Paolo Abeni <pabeni@redhat.com>,
        Ahmad Fatoum <a.fatoum@pengutronix.de>, netdev@vger.kernel.org,
        linux-can@vger.kernel.org,
        Pengutronix Kernel Team <kernel@pengutronix.de>
References: <661cc33a-5f65-2769-cc1a-65791cb4b131@pengutronix.de>
 <7717e4470f6881bbc92645c72ad7f6ec71360796.camel@redhat.com>
 <779d3346-0344-9064-15d5-4d565647a556@pengutronix.de>
 <1b70f56b72943bf5dfd2813565373e8c1b639c31.camel@redhat.com>
 <53ce1ab4-3346-2367-8aa5-85a89f6897ec@pengutronix.de>
 <57a2352dfc442ea2aa9cd653f8e09db277bf67c7.camel@redhat.com>
 <b012e914-fc1a-5a45-f28b-e9d4d4dfc0fe@pengutronix.de>
 <ef6b4e00-75fe-70f6-6b57-7bdbaa1aac33@pengutronix.de>
 <13e8950e8537e549f6afb6e254ec75a7462ce648.camel@redhat.com>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <5e9b81f5-018d-0680-2d0b-55ff3bfb978f@hartkopp.net>
Date:   Thu, 6 Feb 2020 18:06:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <13e8950e8537e549f6afb6e254ec75a7462ce648.camel@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Paolo,

On 06/02/2020 14.21, Paolo Abeni wrote:
> On Tue, 2020-02-04 at 17:25 +0100, Ahmad Fatoum wrote:
>> Hello Paolo,
>>
>> On 1/20/20 5:06 PM, Ahmad Fatoum wrote:
>>> Hello Paolo,
>>>
>>> On 1/16/20 1:40 PM, Paolo Abeni wrote:
>>>> I'm sorry for this trial & error experience. I tried to reproduce the
>>>> issue on top of the vcan virtual device, but it looks like it requires
>>>> the timing imposed by a real device, and it's missing here (TL;DR: I
>>>> can't reproduce the issue locally).
>>>
>>> No worries. I don't mind testing.
>>>
>>>> Code wise, the 2nd patch closed a possible race, but it dumbly re-
>>>> opened the one addressed by the first attempt - the 'empty' field must
>>>> be cleared prior to the trylock operation, or we may end-up with such
>>>> field set and the queue not empty.
>>>>
>>>> So, could you please try the following code?
>>>
>>> Unfortunately, I still see observe reodering.
>>
>> Any news?
> 
> I'm unable to find any better solution than a revert. That will cost
> some small performace regression, so I'm a bit reluctant to go ahead.
> If there is agreement I can post the revert.

Is it possible that the current pfifo_fast handling has some additional 
problems:

https://marc.info/?l=linux-netdev&m=158092393613669&w=2

Or is this unrelated?

Best,
Oliver
