Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 481274DD3D8
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 05:11:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232341AbiCRELz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 00:11:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbiCRELw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 00:11:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F6131F9743;
        Thu, 17 Mar 2022 21:10:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5050EB820F3;
        Fri, 18 Mar 2022 04:10:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD9ECC340E8;
        Fri, 18 Mar 2022 04:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647576631;
        bh=6oioHeCh/ZpCHdWoOxstjZkQ5zS1I/5xfc1rk5jnyjQ=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=A7MAiN+swECTPWooBZgXSnXEj9LgOeeyMjiiyshSLN3ra154ogRWauDPPB55Sjsa+
         XxxTYJiCPxW8Y/zGjJnHRVw13+DVWMmSWgPC8jH2+1GSYcQu4WyhRpRi99hBKsNBZ1
         PhskHnjQQjU3AnDVS1v0jOuBZPs3jU3uIjZzhJycetKjg19Byc/BZg7UJIlcEPxdfY
         ngoho+KjIvA6Hgt34AXS37dQnuUhiYbwoR7wtpVqcBvVXDlfhOWQCQhCZbpT97sk4h
         FE1wUr6cnzoSGILxKpO8o4ptyZrXpRswRJexFU/aXZlUf+Wm2072teDIf5jlEOx5gP
         MR9y95AGKzESg==
Message-ID: <a4032cff-0d48-2690-3c1f-a2ec6c54ffb4@kernel.org>
Date:   Thu, 17 Mar 2022 22:10:28 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.2
Subject: Re: [PATCH net-next v3 3/3] net: icmp: add reasons of the skb drops
 to icmp protocol
Content-Language: en-US
To:     Menglong Dong <menglong8.dong@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, xeb@mail.ru,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Menglong Dong <imagedong@tencent.com>,
        Eric Dumazet <edumazet@google.com>, Martin Lau <kafai@fb.com>,
        Talal Ahmad <talalahmad@google.com>,
        Kees Cook <keescook@chromium.org>,
        Alexander Lobakin <alobakin@pm.me>,
        Hao Peng <flyingpeng@tencent.com>,
        Mengen Sun <mengensun@tencent.com>, dongli.zhang@oracle.com,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Biao Jiang <benbjiang@tencent.com>
References: <20220316063148.700769-1-imagedong@tencent.com>
 <20220316063148.700769-4-imagedong@tencent.com>
 <20220316201853.0734280f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <4315b50e-9077-cc4b-010b-b38a2fbb7168@kernel.org>
 <20220316210534.06b6cfe0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <f787c35b-0984-ecaf-ad97-c7580fcdbbad@kernel.org>
 <CADxym3YM9FMFrTirxWQF7aDOpoEGq5bC4-xm2p0mF8shP+Q0Hw@mail.gmail.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <CADxym3YM9FMFrTirxWQF7aDOpoEGq5bC4-xm2p0mF8shP+Q0Hw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/17/22 7:37 PM, Menglong Dong wrote:
> On Thu, Mar 17, 2022 at 10:48 PM David Ahern <dsahern@kernel.org> wrote:
>>
>> On 3/16/22 10:05 PM, Jakub Kicinski wrote:
>>> On Wed, 16 Mar 2022 21:35:47 -0600 David Ahern wrote:
>>>> On 3/16/22 9:18 PM, Jakub Kicinski wrote:
>>>>>
>>>>> I guess this set raises the follow up question to Dave if adding
>>>>> drop reasons to places with MIB exception stats means improving
>>>>> the granularity or one MIB stat == one reason?
>>>>
>>>> There are a few examples where multiple MIB stats are bumped on a drop,
>>>> but the reason code should always be set based on first failure. Did you
>>>> mean something else with your question?
>>>
>>> I meant whether we want to differentiate between TYPE, and BROADCAST or
>>> whatever other possible invalid protocol cases we can get here or just
>>> dump them all into a single protocol error code.
>>
>> I think a single one is a good starting point.
> 
> Ok, I'll try my best to make a V4 base this way...Is there any inspiration?
> 
> Such as we make SKB_DROP_REASON_PTYPE_ABSENT to
> SKB_DROP_REASON_L2_PROTO, which means the L2 protocol is not
> supported or invalied.

not following. PTYPE is a Linux name. That means nothing to a user.

I am not sure where you want to use L2_PROTO.

> 
> And use SKB_DROP_REASON_L4_PROTO for the L4 protocol problem,
> such as GRE version not supported, ICMP type not supported, etc.
> 
> Sounds nice, isn't it?

