Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A0C75EFC68
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 19:55:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230114AbiI2RzD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 13:55:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235001AbiI2Ryv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 13:54:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8913D2A71D;
        Thu, 29 Sep 2022 10:54:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B9F04B82623;
        Thu, 29 Sep 2022 17:54:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11E2DC433D7;
        Thu, 29 Sep 2022 17:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664474083;
        bh=5cNXRd1M33fpSuvsDPGvMhqGKl7X3rs5VlVMGC+403Y=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=T+dclZFurVocAMmJNGZcNV8fYAWhhDFYo7tUQdF5/IE3WFJpZCePxUlijyxsRsS/6
         b/UFpmq8GlAqPDpHet++6/KSsEMGbLFgZa5VBPDVff2C3S9D/+j6P911Ocdkpg7z1w
         UvbbNOpPlvSJp2ud7Upu+f4Lh3A18T7jrjv4eu9XHG9Ymj+e7w4/RWlrjDIXskXZc+
         RWXNQDVUlKyYtVV1eI7bqyysxMsOHHDxTfvx6oYGh31O4Ot9FIf5UAt3o5k6YGgZ4O
         8nqarYTpOYy4869N5f64AznSA8fQZVUEGq1Gj9hbopepDVUGHFMuJ1kW62w+sKQPOb
         2sM7f/mTnGhsQ==
Message-ID: <d8adea18-2e1c-6c99-f334-bf6c19373baa@kernel.org>
Date:   Thu, 29 Sep 2022 11:54:42 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [PATCH 1/1] netfilter: nft_fib: Fix for rpath check with VRF
 devices
Content-Language: en-US
To:     Florian Westphal <fw@strlen.de>,
        Guillaume Nault <gnault@redhat.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        netfilter-devel@vger.kernel.org, Phil Sutter <phil@nwl.cc>
References: <20220928113908.4525-1-fw@strlen.de>
 <20220928113908.4525-2-fw@strlen.de>
 <20220929161035.GE6761@localhost.localdomain>
 <20220929162129.GA10152@breakpoint.cc>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220929162129.GA10152@breakpoint.cc>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-11.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/29/22 9:21 AM, Florian Westphal wrote:
> Guillaume Nault <gnault@redhat.com> wrote:
> 
> [ CC David Ahern ]
> 
>> On Wed, Sep 28, 2022 at 01:39:08PM +0200, Florian Westphal wrote:
>>> From: Phil Sutter <phil@nwl.cc>
>>>
>>> Analogous to commit b575b24b8eee3 ("netfilter: Fix rpfilter
>>> dropping vrf packets by mistake") but for nftables fib expression:
>>> Add special treatment of VRF devices so that typical reverse path
>>> filtering via 'fib saddr . iif oif' expression works as expected.
>>>
>>> Fixes: f6d0cbcf09c50 ("netfilter: nf_tables: add fib expression")
>>> Signed-off-by: Phil Sutter <phil@nwl.cc>
>>> Signed-off-by: Florian Westphal <fw@strlen.de>
>>> ---
>>>  net/ipv4/netfilter/nft_fib_ipv4.c | 3 +++
>>>  net/ipv6/netfilter/nft_fib_ipv6.c | 6 +++++-
>>>  2 files changed, 8 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/net/ipv4/netfilter/nft_fib_ipv4.c b/net/ipv4/netfilter/nft_fib_ipv4.c
>>> index b75cac69bd7e..7ade04ff972d 100644
>>> --- a/net/ipv4/netfilter/nft_fib_ipv4.c
>>> +++ b/net/ipv4/netfilter/nft_fib_ipv4.c
>>> @@ -83,6 +83,9 @@ void nft_fib4_eval(const struct nft_expr *expr, struct nft_regs *regs,
>>>  	else
>>>  		oif = NULL;
>>>  
>>> +	if (priv->flags & NFTA_FIB_F_IIF)
>>> +		fl4.flowi4_oif = l3mdev_master_ifindex_rcu(oif);
>>> +
>>
>> Shouldn't we set .flowi4_l3mdev instead of .flowi4_oif?
> 
> No idea.
> db53cd3d88dc328dea2e968c9c8d3b4294a8a674 sets both.
> rp_filter modules in iptables only set flowi(6)_oif.
> 
> David, can you give advice on what the correct fix is?
> 
> Then we could change all users in netfilter at once rather than the
> current collection of random-looking guesses...

Old usage is setting flow oif and it gets converted to the L3 device if
there is one. The new usage is flow l3mdev, but I only updated places I
new I was testing.

ie.., use l3mdev in the flow struct if you have a VRF test case for it.
