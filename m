Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 704F739BDAF
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 18:54:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbhFDQzu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 12:55:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:35448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229791AbhFDQzu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Jun 2021 12:55:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4107A61287;
        Fri,  4 Jun 2021 16:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622825644;
        bh=mz6cIA1EIJyWfjzcdTql50qtZoFGmtGK88vnB2IoHAQ=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=VMcCoxmFGWNABY/u7NL4rbKbnwAXozcgMaJ3Erutzy7+POR/+zyFwIij+ifEXygTO
         q+j4KKJf+SO7nUQ+o7yga1yQ+nYBjq5/z0mKZLp1yvs1jOcLjuvn7KxTYVXWY9mN7q
         01Ud4GHNFn/j86dKUSMRKcX+mlV0AZ7GBRF4sHBLQlqZqx2r9C8tMjgDUWyb862HCc
         Dh6jkM0gjo/V10ZhOs1IPi2vmvsSGf89ZzwZiAdCeMzQtwGWB/exj1gX5UIAoo1aIr
         cj/yUz8qqZwfHVEHGL6padxG0xukQbN30OEOnsgzdA/aYW43mj/4c2NixqEMWr0Jjn
         UNWlXfHoON4mw==
Subject: Re: [PATCH net-next] net: ethernet: rmnet: Restructure if checks to
 avoid uninitialized warning
To:     subashab@codeaurora.org, patchwork-bot+netdevbpf@kernel.org
Cc:     stranche@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        ndesaulniers@google.com, sharathv@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
References: <20210603173410.310362-1-nathan@kernel.org>
 <162276000605.13062.14467575723320615318.git-patchwork-notify@kernel.org>
 <1f6f8246f0cd477c0b1e2b88b4ec825a@codeaurora.org>
From:   Nathan Chancellor <nathan@kernel.org>
Message-ID: <2145e27f-c8b3-ef4b-793a-841cb2f7e60f@kernel.org>
Date:   Fri, 4 Jun 2021 09:54:02 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <1f6f8246f0cd477c0b1e2b88b4ec825a@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Subash,

On 6/3/2021 10:15 PM, subashab@codeaurora.org wrote:
> On 2021-06-03 16:40, patchwork-bot+netdevbpf@kernel.org wrote:
>> Hello:
>>
>> This patch was applied to netdev/net-next.git (refs/heads/master):
>>
>> On Thu,  3 Jun 2021 10:34:10 -0700 you wrote:
>>> Clang warns that proto in rmnet_map_v5_checksum_uplink_packet() might be
>>> used uninitialized:
>>>
>>> drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c:283:14: warning:
>>> variable 'proto' is used uninitialized whenever 'if' condition is false
>>> [-Wsometimes-uninitialized]
>>>                 } else if (skb->protocol == htons(ETH_P_IPV6)) {
>>>                            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>>> drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c:295:36: note:
>>> uninitialized use occurs here
>>>                 check = rmnet_map_get_csum_field(proto, trans);
>>>                                                  ^~~~~
>>> drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c:283:10: note:
>>> remove the 'if' if its condition is always true
>>>                 } else if (skb->protocol == htons(ETH_P_IPV6)) {
>>>                        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>>> drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c:270:11: note:
>>> initialize the variable 'proto' to silence this warning
>>>                 u8 proto;
>>>                         ^
>>>                          = '\0'
>>> 1 warning generated.
>>>
>>> [...]
>>
>> Here is the summary with links:
>>   - [net-next] net: ethernet: rmnet: Restructure if checks to avoid
>> uninitialized warning
>>     https://git.kernel.org/netdev/net-next/c/118de6106735
>>
>> You are awesome, thank you!
>> -- 
>> Deet-doot-dot, I am a bot.
>> https://korg.docs.kernel.org/patchwork/pwbot.html
> 
> Hi Nathan
> 
> Can you tell why CLANG detected this error.
> Does it require a bug fix.

As far as I understand it, clang does not remember the conditions of 
previous if statements when generating this warning. Basically:

void bar(int x)
{
}

int foo(int a, int b)
{
	int x;

	if (!a && !b)
		goto out;

	if (a)
		x = 1;
	else if (b)
		x = 2;

	bar(x);

out:
	return 0;
}

clang will warn that x is uninitialized when neither of the second if 
statement's conditions are true, even though we as humans know that is 
not possible due to the first if statement. I am guessing this has 
something to do with how clang generates its control flow graphs. While 
this is a false positive, I do not personally see this as a bug in the 
compiler. The code is more clear to both the compiler and humans if it 
is written as:

	if (a)
		x = 1;
	else if (b)
		x = 2;
	else
		goto out;

Cheers,
Nathan
