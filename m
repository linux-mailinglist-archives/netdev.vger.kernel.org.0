Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFA184B719C
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 17:40:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239449AbiBOO7z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 09:59:55 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239422AbiBOO7x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 09:59:53 -0500
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB9A2DEB7
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 06:59:43 -0800 (PST)
Received: from ip4d144895.dynamic.kabel-deutschland.de ([77.20.72.149] helo=[192.168.66.200]); authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1nJzIp-0007mL-Fd; Tue, 15 Feb 2022 15:59:39 +0100
Message-ID: <6da289bf-86a5-44ce-cd19-85529ec1bfe5@leemhuis.info>
Date:   Tue, 15 Feb 2022 15:59:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] Revert "xfrm: xfrm_state_mtu should return at least 1280
 for ipv6"
Content-Language: en-BW
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        Jiri Bohac <jbohac@suse.cz>
Cc:     Sabrina Dubroca <sd@queasysnail.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Mike Maloney <maloneykernel@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>
References: <20220114173133.tzmdm2hy4flhblo3@dwarf.suse.cz>
 <20220114174058.rqhtuwpfhq6czldn@dwarf.suse.cz>
 <20220119073519.GJ1223722@gauss3.secunet.de>
 <20220119091233.pzqdlzpcyicjavk5@dwarf.suse.cz>
 <20220124154531.GM1223722@gauss3.secunet.de>
 <20220125094102.ju7bhuplcxnkyv4x@dwarf.suse.cz>
 <20220126064214.GO1223722@gauss3.secunet.de>
 <20220126150018.7cdfxtkq2nfkqj4j@dwarf.suse.cz>
 <20220201064639.GS1223722@gauss3.secunet.de>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
In-Reply-To: <20220201064639.GS1223722@gauss3.secunet.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1644937183;79b2bef5;
X-HE-SMSGID: 1nJzIp-0007mL-Fd
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, this is your Linux kernel regression tracker speaking.

The patch discussed below is now in linux-next for about 11 days, but
not yet in the net tree afaics. Will it be merged this week? And
shouldn't this patch have these stables tags?

Cc: <stable@vger.kernel.org> # 5.14: 6596a0229541 xfrm: fix MTU regression
Cc: <stable@vger.kernel.org> # 5.14

And maybe a fixes tag, too?

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)

P.S.: As the Linux kernel's regression tracker I'm getting a lot of
reports on my table. I can only look briefly into most of them and lack
knowledge about most of the areas they concern. I thus unfortunately
will sometimes get things wrong or miss something important. I hope
that's not the case here; if you think it is, don't hesitate to tell me
in a public reply, it's in everyone's interest to set the public record
straight.

#regzbot poke

On 01.02.22 07:46, Steffen Klassert wrote:
> On Wed, Jan 26, 2022 at 04:00:18PM +0100, Jiri Bohac wrote:
>> This reverts commit b515d2637276a3810d6595e10ab02c13bfd0b63a.
>>
>> Commit b515d2637276a3810d6595e10ab02c13bfd0b63a ("xfrm: xfrm_state_mtu
>> should return at least 1280 for ipv6") in v5.14 breaks the TCP MSS
>> calculation in ipsec transport mode, resulting complete stalls of TCP
>> connections. This happens when the (P)MTU is 1280 or slighly larger.
>>
>> The desired formula for the MSS is:
>> MSS = (MTU - ESP_overhead) - IP header - TCP header
>>
>> However, the above commit clamps the (MTU - ESP_overhead) to a
>> minimum of 1280, turning the formula into
>> MSS = max(MTU - ESP overhead, 1280) -  IP header - TCP header
>>
>> With the (P)MTU near 1280, the calculated MSS is too large and the
>> resulting TCP packets never make it to the destination because they
>> are over the actual PMTU.
>>
>> The above commit also causes suboptimal double fragmentation in
>> xfrm tunnel mode, as described in
>> https://lore.kernel.org/netdev/20210429202529.codhwpc7w6kbudug@dwarf.suse.cz/
>>
>> The original problem the above commit was trying to fix is now fixed
>> by commit 6596a0229541270fb8d38d989f91b78838e5e9da ("xfrm: fix MTU
>> regression").
>>
>> Signed-off-by: Jiri Bohac <jbohac@suse.cz>
> 
> Applied, thanks Jiri!
