Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D173F4DB393
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 15:45:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345426AbiCPOqZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 10:46:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243640AbiCPOqX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 10:46:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B74B039B9F;
        Wed, 16 Mar 2022 07:45:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 522CA6158F;
        Wed, 16 Mar 2022 14:45:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6B59C340E9;
        Wed, 16 Mar 2022 14:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647441907;
        bh=EdzeWj/opABL78Uw5ziB5aHmdj+a+7DmJ7wbHG5eM24=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=mgmwIX+iucmyRtL/ywxTMi08ALCbYSCtysWtxJrtCE3nQRbSg0XmmIa4b86f+4V0S
         Ir0jvEZR0sxpBiFQCU+Rf2STeOHS0WESKxEWPsJ/GEVVazaqwQ0E7T6jg+3pw6UzHW
         9lvbyUnie3f5ue0IemQ0t3gsgHxitfWpMrjpedMBEfifjFq6Vy5+oKHmKaq4/q387A
         CeiXBuyF3D5T3TI3q/fys/lyYA6fh5wYu0VvDriVfXvcz2H2aa/WsnFAEgQNvY/uPj
         JES1B1fA7gcuvlwJgrk+IGOGOBHavgv6R978dD/rKA/wWQY+RohCwfnhSQgYgTUa+g
         7yOIAkUIXHiIw==
Message-ID: <1cab9152-a5bb-17e1-1101-f309a3be6365@kernel.org>
Date:   Wed, 16 Mar 2022 08:45:05 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.2
Subject: Re: [PATCH net-next 1/3] net: gre_demux: add skb drop reasons to
 gre_rcv()
Content-Language: en-US
To:     Menglong Dong <menglong8.dong@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
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
References: <20220314133312.336653-1-imagedong@tencent.com>
 <20220314133312.336653-2-imagedong@tencent.com>
 <20220315200847.68c2efee@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <daa287f3-fbed-515d-8f37-f2a36234cc8a@kernel.org>
 <CADxym3bK09hm2zn8yRU5g9fm=MhN7j9xZAjJEoV6_wpuvs9o-w@mail.gmail.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <CADxym3bK09hm2zn8yRU5g9fm=MhN7j9xZAjJEoV6_wpuvs9o-w@mail.gmail.com>
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

On 3/15/22 10:53 PM, Menglong Dong wrote:
> On Wed, Mar 16, 2022 at 11:49 AM David Ahern <dsahern@kernel.org> wrote:
>>
>> On 3/15/22 9:08 PM, Jakub Kicinski wrote:
>>> On Mon, 14 Mar 2022 21:33:10 +0800 menglong8.dong@gmail.com wrote:
>>>> +    reason = SKB_DROP_REASON_NOT_SPECIFIED;
>>>>      if (!pskb_may_pull(skb, 12))
>>>>              goto drop;
>>>
>>> REASON_HDR_TRUNC ?
>>>
>>>>      ver = skb->data[1]&0x7f;
>>>> -    if (ver >= GREPROTO_MAX)
>>>> +    if (ver >= GREPROTO_MAX) {
>>>> +            reason = SKB_DROP_REASON_GRE_VERSION;
>>>
>>> TBH I'm still not sure what level of granularity we should be shooting
>>> for with the reasons. I'd throw all unexpected header values into one
>>> bucket, not go for a reason per field, per protocol. But as I'm said
>>> I'm not sure myself, so we can keep what you have..
>>
>> I have stated before I do not believe every single drop point in the
>> kernel needs a unique reason code. This is overkill. The reason augments
>> information we already have -- the IP from kfree_skb tracepoint.
> 
> Is this reason unnecessary? I'm not sure if the GRE version problem should
> be reported. With versions not supported by the kernel, it seems we
> can't get the
> drop reason from the packet data, as they are fine. And previous seems not
> suitable here, as it is a L4 problem.
> 

Generically, it is "no support for a protocol version". That kind of
reason code + the IP tells you GRE is processing a packet with an
unsupported protocol version.

