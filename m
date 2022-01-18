Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C55F4928A5
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 15:44:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343731AbiAROoY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 09:44:24 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.54]:46759 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235735AbiAROoX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 09:44:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1642517059;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=/aiPUdZU/NMvB9CFhXaRDgauYeoCZM/hElRYJqOCGPU=;
    b=tTfs86GijTsVM2iql/rm7HIjPdFK4x+gL8s7MKTJlle5wnzM6GHNKcmuPnKWqfM1yQ
    7I+ReggBXVSIlTPUM3JiuMXj/FA6S/tCoENnAZoead8+iAi61LOdBFZ3DDZD2kXjPbFm
    vpXVDDqNlTzqsPv+0mtnDDgwwfwCu8sE2j3uEIikvrkiVIqOPXTMInDDjXNfJ9NteVDx
    gQpNlmaQ4ZJXQy1OIZRJX/27MUmdvNt6Q2DNO5SBavvCrZh1jU+VfH42bexofeJaF/qs
    4mVJvDFFP6oNJM99poTmgrbRAa/4Cru12RJn+fVe87kLopOBtjYPY1Qx3TbfAebCk42S
    445A==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1qCHSa1GLptZHusx3hdd0DIgVuBOfXW6v7w=="
X-RZG-CLASS-ID: mo00
Received: from [IPV6:2a00:6020:1cfa:f900::b82]
    by smtp.strato.de (RZmta 47.37.6 AUTH)
    with ESMTPSA id Rb080by0IEiJWDH
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Tue, 18 Jan 2022 15:44:19 +0100 (CET)
Message-ID: <eaafaca3-f003-ca56-c04c-baf6cf4f7627@hartkopp.net>
Date:   Tue, 18 Jan 2022 15:44:13 +0100
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
From:   Oliver Hartkopp <socketcan@hartkopp.net>
In-Reply-To: <280e10c1-d1f4-f39e-fa90-debd56f1746d@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 18.01.22 13:46, Ziyang Xuan (William) wrote:
>> Hi,
>>
>> the referenced syzbot issue has already been fixed in upstream here:
>>
>> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=5f33a09e769a9da0482f20a6770a342842443776
>>
>> ("can: isotp: convert struct tpcon::{idx,len} to unsigned int")
>>
>> Additionally this fix changes some behaviour that is required by the ISO 16765-2 specification (see below).
>>
>> On 17.01.22 13:01, Ziyang Xuan wrote:
>>> When receive a FF, the current code logic does not consider the real
>>> so->rx.state but set so->rx.state to ISOTP_IDLE directly. That will
>>> make so->rx accessed by multiple receiving processes concurrently.
>>
>> This is intentionally. "multiple receiving processes" are not allowed resp. specified by ISO 15765-2.
> 
> Does it can be a network attack?

Yes. You can see it like this. The ISO 15765-2 protocol is an unreliable 
UDP-like datagram protocol and the session layer takes care about 
timeouts and packet lost.

If you want to disturb that protocol you can also send PDUs with 
out-of-sync packet counters which will make the receiver drop the 
communication attempt.

This is 'CAN-style' ... as usually the bus is very reliable. Security 
and reliable communication is done on top of these protocols.

> It receives packets from network, but unexpected packets order make server panic.

Haha, no :-)

Unexpected packets should not make the server panic but only drop the 
communication process.

In the case pointed out by syzbot the unsigned 32 bit length information 
was stored in a signed 32 bit integer which caused a sanity check to fail.

This is now fixed with the patch from Marc.

Regards,
Oliver
