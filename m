Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68F133E496C
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 18:06:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231751AbhHIQGk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 12:06:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:50402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229456AbhHIQGj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Aug 2021 12:06:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 044BB60F56;
        Mon,  9 Aug 2021 16:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628525179;
        bh=+5/Y9P/eIIGPo/tVm7vmNewM1ZvHkw3Lisdlnp9j9PU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=novI017mbiCI3gHlv9eV1IAefmm1s+AWi9G2DCHEehIDESUgpkh1B6cRFOX1RmRc3
         ITbzvChwICa88Yh7VwISQli68BUtyRMjhfKOYlqMF9BDcKg0IKVRVVsxgiLhBjpHKN
         uybdioZ2Zqr9aAUX7828CPIOJpTsLFOU+G/V3OjpKGu1KAc1LiUhi3eCfD53Ra3cGH
         2R2PtHouptwXRNkswf67eCG7JoQsz4yllIQqq38zHpqh6KljY8S/wpgyh06hqNXhFP
         7M2eyi0Gnd+90gxhbVQZr0V3/LsqrNrXorQNXTic0SLhXBPikmfJdxgPzVP8sd+ab0
         ndeNvy1oXFD6w==
Date:   Mon, 9 Aug 2021 12:06:17 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        gushengxian <gushengxian@yulong.com>,
        gushengxian <13145886936@163.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.13 184/189] flow_offload: action should not be
 NULL when it is referenced
Message-ID: <YRFSebqqB7HM7lsK@sashalap>
References: <20210706111409.2058071-1-sashal@kernel.org>
 <20210706111409.2058071-184-sashal@kernel.org>
 <caf751a7-ef2d-e31d-85e9-801e748b70dc@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <caf751a7-ef2d-e31d-85e9-801e748b70dc@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 06, 2021 at 11:30:04AM +0200, Eric Dumazet wrote:
>On 7/6/21 1:14 PM, Sasha Levin wrote:
>> From: gushengxian <gushengxian@yulong.com>
>>
>> [ Upstream commit 9ea3e52c5bc8bb4a084938dc1e3160643438927a ]
>>
>> "action" should not be NULL when it is referenced.
>>
>> Signed-off-by: gushengxian <13145886936@163.com>
>> Signed-off-by: gushengxian <gushengxian@yulong.com>
>> Signed-off-by: David S. Miller <davem@davemloft.net>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>  include/net/flow_offload.h | 12 +++++++-----
>>  1 file changed, 7 insertions(+), 5 deletions(-)
>>
>> diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
>> index dc5c1e69cd9f..69c9eabf8325 100644
>> --- a/include/net/flow_offload.h
>> +++ b/include/net/flow_offload.h
>> @@ -319,12 +319,14 @@ flow_action_mixed_hw_stats_check(const struct flow_action *action,
>>  	if (flow_offload_has_one_action(action))
>>  		return true;
>>
>> -	flow_action_for_each(i, action_entry, action) {
>> -		if (i && action_entry->hw_stats != last_hw_stats) {
>> -			NL_SET_ERR_MSG_MOD(extack, "Mixing HW stats types for actions is not supported");
>> -			return false;
>> +	if (action) {
>> +		flow_action_for_each(i, action_entry, action) {
>> +			if (i && action_entry->hw_stats != last_hw_stats) {
>> +				NL_SET_ERR_MSG_MOD(extack, "Mixing HW stats types for actions is not supported");
>> +				return false;
>> +			}
>> +			last_hw_stats = action_entry->hw_stats;
>>  		}
>> -		last_hw_stats = action_entry->hw_stats;
>>  	}
>>  	return true;
>>  }
>>
>
>This patch makes no sense really.
>
>If action is NULL, a crash would happen earlier anyway in
>
>if (flow_offload_has_one_action(action))
>    return true;
>
>Also, I wonder why it has been backported to stable version,
>there was no Fixes: tag in the submission.

That's the AUTOSEL logic: it will attempt to find fixes in commits that
don't have a fixes: tag. Those get longer review times and aren't
backported as quickly as commits with a stable tag or a fixes tag.

-- 
Thanks,
Sasha
