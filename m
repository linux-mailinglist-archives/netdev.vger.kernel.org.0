Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98D815A88D4
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 00:13:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbiHaWN2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 18:13:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiHaWN1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 18:13:27 -0400
Received: from mail.toke.dk (mail.toke.dk [IPv6:2a0c:4d80:42:2001::664])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AF30E3C39
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 15:13:26 -0700 (PDT)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1661984004; bh=J9smbeqwF6HR5Ev13cYaGixwetsw3HqCQJoMKnNobPk=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=Yq0bCWf5x+zj9awb5k1GIpMVkIug1D1TLqlt5Dev8vwemjzHhVw9vpOHhhmBwfWlM
         zml4ovmXxk62T6QvcMzM4/x++m4o+9GK8G43Uzjl+8DgaP/545i6a34KbKjTmLc/fy
         AvV97PNhjpij/DVHZNeh0DnrbEkg1FQbHbybO8XdEi6/slDcRH3VyNBKgo6bNmYjRK
         I128pcpOd0jMNbm4NjY6XugFE7kHU7BDJcaJzsv2y2HMUHsSEF5UqlM+E5dQmQO3vB
         nPEpRdqTu7MUBfjQiKGrzVtoIdzikr9x1AlFdEW1eF3DNFYVxGhW+/AOVB9HmkAgJg
         OGctYF2ksL5fg==
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, cake@lists.bufferbloat.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] sch_cake: Return __NET_XMIT_STOLEN when consuming
 enqueued skb
In-Reply-To: <166198321517.20200.12054704879498725145.git-patchwork-notify@kernel.org>
References: <20220831092103.442868-1-toke@toke.dk>
 <166198321517.20200.12054704879498725145.git-patchwork-notify@kernel.org>
Date:   Thu, 01 Sep 2022 00:13:24 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87wnao2ha3.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

patchwork-bot+netdevbpf@kernel.org writes:

> Hello:
>
> This patch was applied to netdev/net.git (master)
> by Jakub Kicinski <kuba@kernel.org>:
>
> On Wed, 31 Aug 2022 11:21:03 +0200 you wrote:
>> When the GSO splitting feature of sch_cake is enabled, GSO superpackets
>> will be broken up and the resulting segments enqueued in place of the
>> original skb. In this case, CAKE calls consume_skb() on the original skb,
>> but still returns NET_XMIT_SUCCESS. This can confuse parent qdiscs into
>> assuming the original skb still exists, when it really has been freed. Fix
>> this by adding the __NET_XMIT_STOLEN flag to the return value in this case.
>> 
>> [...]
>
> Here is the summary with links:
>   - [net] sch_cake: Return __NET_XMIT_STOLEN when consuming enqueued skb
>     https://git.kernel.org/netdev/net/c/90fabae8a2c2

Ah, crossed streams (just sent v2[0]).

Hmm, okay, so as noted in the changelog to v2, just this patch will
break htb+cake (because htb will now skip htb_activate()); do you prefer
that I send a follow-up to fix HTB in this mode, or to revert this and
apply the fix to sfb in v2 instead?

-Toke


[0] https://lore.kernel.org/r/20220831215219.499563-1-toke@toke.dk
