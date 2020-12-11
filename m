Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B71DD2D6D1D
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 02:14:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394539AbgLKBNk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 20:13:40 -0500
Received: from so254-31.mailgun.net ([198.61.254.31]:21629 "EHLO
        so254-31.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394531AbgLKBNP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 20:13:15 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1607649177; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=lxQq1KCpajem0qCf1f74c3ecDftU2PSBK/LbjhwB2Lw=;
 b=bxAGs95CS65SuQJOf5RLe2NkLkX/PCuSKcWAzI4aKzeHg6KXmiwgAyeD5DEAku8MVVy9Fa36
 dkVpNXfQcdKsA6pQUMfVGyh3AGwkMVLKzek5URvZR83ASXmN8MIgNG9+nfDQR2JUEB3JJS5H
 BWCZB//6/p3l3KGWurxqmsCMw0Y=
X-Mailgun-Sending-Ip: 198.61.254.31
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 5fd2c779962b2f3cb7b55924 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 11 Dec 2020 01:12:25
 GMT
Sender: stranche=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id E4DFDC433CA; Fri, 11 Dec 2020 01:12:25 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: stranche)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D0B34C433C6;
        Fri, 11 Dec 2020 01:12:24 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 10 Dec 2020 18:12:24 -0700
From:   stranche@codeaurora.org
To:     David Ahern <dsahern@gmail.com>
Cc:     Wei Wang <weiwan@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Mahesh Bandewar <maheshb@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Subject: Re: Refcount mismatch when unregistering netdevice from kernel
In-Reply-To: <f10c733a-09f8-2c72-c333-41f9d53e1498@gmail.com>
References: <ca64de092db5a2ac80d22eaa9d662520@codeaurora.org>
 <56e72b72-685f-925d-db2d-d245c1557987@gmail.com>
 <CAEA6p_D+diS7jnpoGk6cncWL8qiAGod2EAp=Vcnc-zWNPg04Jg@mail.gmail.com>
 <307c2de1a2ddbdcd0a346c57da88b394@codeaurora.org>
 <CAEA6p_ArQdNp=hQCjrsnAo-Xy22d44b=2KdLp7zO7E7XDA4Fog@mail.gmail.com>
 <f10c733a-09f8-2c72-c333-41f9d53e1498@gmail.com>
Message-ID: <6a314f7da0f41c899926d9e7ba996337@codeaurora.org>
X-Sender: stranche@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> BTW, have you tried your previous proposed patch and confirmed it
>> would fix the issue?
>> 

Yes, we shared this with the customer and the refcount mismatch still 
occurred, so this doesn't seem sufficient either.

>> Could we further distinguish between dst added to the uncached list by
>> icmp6_dst_alloc() and xfrm6_fill_dst(), and confirm which ones are the
>> ones leaking reference?
>> I suspect it would be the xfrm ones, but I think it is worth 
>> verifying.
>> 

After digging into the DST allocation/destroy a bit more, it seems that 
there are some cases where the DST's refcount does not hit zero, causing 
them to never be freed and release their references.
One case comes from here on the IPv6 packet output path (these DST 
structs would hold references to both the inet6_dev and the netdevice)
ip6_pol_route_output+0x20/0x2c -> ip6_pol_route+0x1dc/0x34c -> 
rt6_make_pcpu_route+0x18/0xf4 -> ip6_rt_pcpu_alloc+0xb4/0x19c

We also see two DSTs where they are stored as the xdst->rt entry on the 
XFRM path that do not get released. One is allocated by the same path as 
above, and the other like this
xfrm6_esp_err+0x7c/0xd4 -> esp6_err+0xc8/0x100 -> 
ip6_update_pmtu+0xc8/0x100 -> __ip6_rt_update_pmtu+0x248/0x434 -> 
ip6_rt_cache_alloc+0xa0/0x1dc

 From those alloc paths it seems like the problem might not be coming 
from the uncached list after all.

> 
> Finally found the reference:
> 
> tools/testing/selftests/net/l2tp.sh at one point was triggering a
> refcount leak:
> 
> https://lore.kernel.org/netdev/20190801235421.8344-1-dsahern@kernel.org/
> 
> And then Colin found more problems with it:
> 
> https://lore.kernel.org/netdev/450f5abb-5fe8-158d-d267-4334e15f8e58@canonical.com/
> 
> 
> running that on a 5.8 kernel on Ubuntu 20.10 did not trigger the
> problem. Neither did Ubuntu 20.04 with 5.4.0-51-generic.
> 
> Can you run it on your 5.4 version and see?

We let that run for two days on our setup and didn't see anything, 
unfortunately.

Thanks,
Sean
