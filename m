Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D95A23B4937
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 21:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbhFYTYm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 15:24:42 -0400
Received: from mail.asbjorn.biz ([185.38.24.25]:52641 "EHLO mail.asbjorn.biz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229697AbhFYTYf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Jun 2021 15:24:35 -0400
Received: from x201s (space.labitat.dk [185.38.175.0])
        by mail.asbjorn.biz (Postfix) with ESMTPSA id CA4571C2973C;
        Fri, 25 Jun 2021 19:22:09 +0000 (UTC)
Received: from x201s.roaming.asbjorn.biz (localhost [127.0.0.1])
        by x201s (Postfix) with ESMTP id 3BEAC2025C7;
        Fri, 25 Jun 2021 19:21:41 +0000 (UTC)
Subject: Re: [PATCH iproute2 v3 2/2] tc: pedit: add decrement operation
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org,
        Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Jiri Pirko <jiri@nvidia.com>, Amir Vadai <amir@vadai.me>
References: <20210618160635.703845-1-asbjorn@asbjorn.st>
 <20210618160635.703845-2-asbjorn@asbjorn.st>
 <7b5d610b-0fd6-d466-cd6d-bb2725397cdd@gmail.com>
 <74b620dd-3552-b20d-ba5c-b681e7eabca7@mojatatu.com>
From:   =?UTF-8?Q?Asbj=c3=b8rn_Sloth_T=c3=b8nnesen?= <asbjorn@asbjorn.st>
Message-ID: <b91f8e7f-d91d-c5e3-a638-88476f3cff73@asbjorn.st>
Date:   Fri, 25 Jun 2021 19:21:41 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <74b620dd-3552-b20d-ba5c-b681e7eabca7@mojatatu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jamal,

Thank you for your review.

On 6/24/21 8:24 PM, Jamal Hadi Salim wrote:
> So you "add" essentially one's complement of the value you are trying to
> decrement with?

Almost (off by one), it's basically decrement by overflowing it, which
is safe since the operation is masked. One should however have another
rule, that matches on TTL == 1. so it can get a proper ICMP error.

Decrementing TTL by one was actually the prime example presented
when Amir Vadai introduced TCA_PEDIT_KEY_EX_CMD_ADD.

kernel   853a14ba net/act_pedit: Introduce 'add' operation     [1]
iproute2 8d193d96 tc/pedit: p_ip: introduce editing ttl header [2]

[1] https://git.kernel.org/torvalds/c/853a14ba
[2] https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=8d193d96


>>> This feature was suggested by some pseudo tc examples in Mellanox's
>>> documentation[1], but wasn't present in neither their mlnx-iproute2
>>> nor iproute2.
>>>
>>> Tested with skip_sw on Mellanox ConnectX-6 Dx.
>>>
>>> [1] https://docs.mellanox.com/pages/viewpage.action?pageId=47033989
> 
> 
> I didnt see an example which showed using "dec" but what you described
> above makes sense.

It is indeed a large document, so to be more specific:

https://docs.mellanox.com/pages/viewpage.action?pageId=47033989#highlighter_159101
 > Using TC rules:
 > IPv4:
 > tc filter add [..] munge ip ttl dec [..]
 > IPv6:
 > tc filter add [..] munge ipv6 hlimit dec [..]

"ipv6 hlimit" should obviously be "ip6 hoplimit".


-- 
Best regards
Asbjørn Sloth Tønnesen
