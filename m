Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2898C39B1DA
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 07:15:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbhFDFQ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 01:16:57 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:52362 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229527AbhFDFQ5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Jun 2021 01:16:57 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1622783711; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=uRQ5+HAqjf1zI3L21gFTmAKCk0wOVTgllZo9/C7+/WA=;
 b=wq7eYjdBSk/EitnlLlMjr3nm/S6dybEsqG4KNsF36EXiuokq6ofGmVp3yPO97nWhMyfcZlLt
 Syf2ZxQ0F9UXJrw/cbiqprurUHLKCONuwz4/VeTXf/tcWAmVl3/gzfYggivBNEFa4GPXfOD9
 oFSuF21ZDXN1+/zhokYjYCRbWDc=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-west-2.postgun.com with SMTP id
 60b9b6dfe570c05619fab9e2 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 04 Jun 2021 05:15:11
 GMT
Sender: subashab=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 1B22AC4323A; Fri,  4 Jun 2021 05:15:11 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: subashab)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7237CC433F1;
        Fri,  4 Jun 2021 05:15:10 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 03 Jun 2021 23:15:10 -0600
From:   subashab@codeaurora.org
To:     patchwork-bot+netdevbpf@kernel.org
Cc:     Nathan Chancellor <nathan@kernel.org>, stranche@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org, ndesaulniers@google.com,
        sharathv@codeaurora.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH net-next] net: ethernet: rmnet: Restructure if checks to
 avoid uninitialized warning
In-Reply-To: <162276000605.13062.14467575723320615318.git-patchwork-notify@kernel.org>
References: <20210603173410.310362-1-nathan@kernel.org>
 <162276000605.13062.14467575723320615318.git-patchwork-notify@kernel.org>
Message-ID: <1f6f8246f0cd477c0b1e2b88b4ec825a@codeaurora.org>
X-Sender: subashab@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-06-03 16:40, patchwork-bot+netdevbpf@kernel.org wrote:
> Hello:
> 
> This patch was applied to netdev/net-next.git (refs/heads/master):
> 
> On Thu,  3 Jun 2021 10:34:10 -0700 you wrote:
>> Clang warns that proto in rmnet_map_v5_checksum_uplink_packet() might 
>> be
>> used uninitialized:
>> 
>> drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c:283:14: warning:
>> variable 'proto' is used uninitialized whenever 'if' condition is 
>> false
>> [-Wsometimes-uninitialized]
>>                 } else if (skb->protocol == htons(ETH_P_IPV6)) {
>>                            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c:295:36: note:
>> uninitialized use occurs here
>>                 check = rmnet_map_get_csum_field(proto, trans);
>>                                                  ^~~~~
>> drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c:283:10: note:
>> remove the 'if' if its condition is always true
>>                 } else if (skb->protocol == htons(ETH_P_IPV6)) {
>>                        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c:270:11: note:
>> initialize the variable 'proto' to silence this warning
>>                 u8 proto;
>>                         ^
>>                          = '\0'
>> 1 warning generated.
>> 
>> [...]
> 
> Here is the summary with links:
>   - [net-next] net: ethernet: rmnet: Restructure if checks to avoid
> uninitialized warning
>     https://git.kernel.org/netdev/net-next/c/118de6106735
> 
> You are awesome, thank you!
> --
> Deet-doot-dot, I am a bot.
> https://korg.docs.kernel.org/patchwork/pwbot.html

Hi Nathan

Can you tell why CLANG detected this error.
Does it require a bug fix.
