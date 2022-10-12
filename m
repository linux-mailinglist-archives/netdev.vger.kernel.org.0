Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C03265FC560
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 14:34:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbiJLMeN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 08:34:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbiJLMeM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 08:34:12 -0400
X-Greylist: delayed 583 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 12 Oct 2022 05:34:09 PDT
Received: from pm.theglu.org (pm.theglu.org [5.39.81.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8464DC58A1;
        Wed, 12 Oct 2022 05:34:09 -0700 (PDT)
Received: from pm.theglu.org (localhost [127.0.0.1])
        by pm.theglu.org (Postfix) with ESMTP id C020440334;
        Wed, 12 Oct 2022 12:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=simple; d=theglu.org; h=message-id
        :date:mime-version:subject:to:cc:references:from:in-reply-to
        :content-type:content-transfer-encoding; s=postier; bh=WmbqpEAaQ
        V3hejfjmDbHh1em7d4=; b=UkfZ5qboZWOpX2D/NXHQd60M3Xdm4v41twJ8RmdRH
        NFBFDvPOSEoJ8Q1UM6eo+AmJq4bkLl2KnSYRvNpXBx4ldVF2Hi6pflK5MnTzTJ8T
        CNZ+BKtSgoFLxKY0EJT+oqiAQrhhs5Z2l030sW0VgixhuqgNk3QdhVsYGQerR56S
        Ng=
Received: from [10.0.17.2] (people.swisscom.puidoux-infra.ch [146.4.119.107])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by pm.theglu.org (Postfix) with ESMTPSA id E19B440124;
        Wed, 12 Oct 2022 12:24:12 +0000 (UTC)
Message-ID: <d6c3cd78-741c-d528-129a-cf7ed7ef236d@arcanite.ch>
Date:   Wed, 12 Oct 2022 14:24:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [REGRESSION] Unable to NAT own TCP packets from another VRF with
 tcp_l3mdev_accept = 1
Content-Language: en-US-large
To:     Mike Manning <mvrmanning@gmail.com>
Cc:     netdev@vger.kernel.org, Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>,
        David Ahern <dsahern@kernel.org>,
        netfilter-devel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
References: <98348818-28c5-4cb2-556b-5061f77e112c@arcanite.ch>
 <20220930174237.2e89c9e1@kernel.org>
 <1eca7cd0-ad6e-014f-d4e2-490b307ab61d@gmail.com>
From:   Maximilien Cuony <maximilien.cuony@arcanite.ch>
Organization: Arcanite Solutions SARL
In-Reply-To: <1eca7cd0-ad6e-014f-d4e2-490b307ab61d@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/7/22 18:47, Mike Manning wrote:
> Hi Maximilien,
>
> Apologies that you have now hit this issue. Further to David's reply
> with the link for the rationale behind the change, the bisected commit
> you found restores backwards compatibility with the 4.19 kernel to allow
> a match on an unbound socket when in a VRF if tcp_l3mdev_accept=1, the
> absence of this causing issues for others. Isolation between default and
> other VRFs as introduced by the team I worked for back in 2018 and
> introduced in 5.x kernels remains guaranteed if tcp_l3mdev_accept=0.
>
> There is no appetite so far to introduce yet another kernel parameter to
> control this specific behavior, see e.g.
> https://lore.kernel.org/netdev/f174108c-67c5-3bb6-d558-7e02de701ee2@gmail.com/
Ok, I do understand it's tricky to satisfy both side and adding a 
parameter for each cases is probably not sustainable ^^'
> Is there any possibility that you could use tcp_l3mdev_accept=0 by
> running any services needed in the VRF with 'ip vrf exec <vrf> <cmd>'?
Yes, we will try to do that, there was some complication but it's 
probably easier and better for the future.
> Is the problem specific to using NAT for eth2 in the VRF, i.e. have you
> tried on another interface in that VRF, or on eth2 without NAT config?
If we try to NAT on another interface in the VRF it doesn't work. 
Without NAT it does work.
> No doubt you are doing this, but can I also check that your VRF config
> is correct according to
> https://www.kernel.org/doc/Documentation/networking/vrf.txt , so
> reducing the local lookup preference, etc., e.g.

Yes, rules/preferences are correct - I think by ifupdown2 during 
interface activation.

So we will try to not to have to use tcp_l3mdev_accept=1 to make it 
working as expected.

Thanks for you help and have a nice day :)

-- 
Maximilien Cuony

