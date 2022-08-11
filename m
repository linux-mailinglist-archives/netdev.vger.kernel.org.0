Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C36F45906FE
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 21:35:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235270AbiHKTfX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 15:35:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235403AbiHKTfV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 15:35:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 798426548;
        Thu, 11 Aug 2022 12:35:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 05B6DB82206;
        Thu, 11 Aug 2022 19:35:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B70FC433D6;
        Thu, 11 Aug 2022 19:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660246516;
        bh=sFqhIMSSxdlo/T1Wkm8sX5wGxJE29nTmQH6IHS/4K5c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qG1br2jGBwM3ym7YJ9k/wxwSkHV8Cpc6Q4IML7aDanhZvyejogyxLLYLmguKJfuaS
         ezK6Lv+Vo3hTI32I3jUjrF/fjIkkfAhL6Q5JyeBMPxjm/raA8a9+63extJHgHoHb24
         cElkvnB3NyrXNCq+NFpsIPGS8C5QK4uTcnfvgavSXMF2rclrM58ZKlOcyArCosvZGS
         XWByXkTlUJh514EkXM8wF+bBmnF//OF2mhEfGu1Ad0VU3OfZa6qepVM5tK1qTIIv8n
         eejhAuvdOoKsSZhLSt2XxlhyYXIiAFHjLJbuX38ULWIDWX0V8x2IqrghAunm1G5/vN
         Yjv2Nks2JY7xw==
Date:   Thu, 11 Aug 2022 12:35:15 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     sdf@google.com
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, jacob.e.keller@intel.com, vadfed@fb.com,
        johannes@sipsolutions.net, jiri@resnulli.us, dsahern@kernel.org,
        stephen@networkplumber.org, fw@strlen.de, linux-doc@vger.kernel.org
Subject: Re: [RFC net-next 4/4] ynl: add a sample user for ethtool
Message-ID: <20220811123515.4ef1a715@kernel.org>
In-Reply-To: <YvUru3QvN/LuYgnq@google.com>
References: <20220811022304.583300-1-kuba@kernel.org>
        <20220811022304.583300-5-kuba@kernel.org>
        <YvUru3QvN/LuYgnq@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 11 Aug 2022 09:18:03 -0700 sdf@google.com wrote:
> > +attr-cnt-suffix: CNT  
> 
> Is it a hack to make the generated header fit into existing
> implementation?

Yup.

> Should we #define ETHTOOL_XXX_CNT ETHTOOL_XXX in
> the implementation instead? (or s/ETHTOOL_XXX_CNT/ETHTOOL_XXX/ the
> source itself?)

We could, I guess. To be clear this controls the count, IOW:

enum {
	PREFIX_A_BLA_ATTR = 1,
	PREFIX_A_ANOTHER_ATTR,
	PREFIX_A_AND_ONEMORE,
	__PFREIX_A_CNT, // <--- This thing
};
#define PREFIX_A_MAX (__PFREIX_A_CNT - 1)

It's not used in the generated code, only if we codegen the uAPI,
AFAIR. So we'd need a way to tell the generator of the uAPI about
the situation, anyway. I could be misremembering.

> > +attribute-spaces:  
> 
> Are you open to bike shedding? :-)

I can't make promises that I'll change things but I'm curious 
to hear it!

> I like how ethtool_netlink.h calls these 'message types'.

It calls operation types message types, not attr spaces.
I used ops because that's what genetlink calls things.

> > +  -
> > +    name: header
> > +    name-prefix: ETHTOOL_A_HEADER_  
> 
> Any issue with name-prefix+name-suffix being non-greppable? Have you tried
> something like this instead:
> 
> - name: ETHTOOL_A_HEADER # this is fake, for ynl reference only
>    attributes:
>      - name: ETHTOOL_A_HEADER_DEV_INDEX
>        val:
>        type:
>      - name ETHTOOL_A_HEADER_DEV_NAME
>        ..
> 
> It seems a bit easier to map the spec into what it's going to produce.
> For example, it took me a while to translate 'channels_get' below into
> ETHTOOL_MSG_CHANNELS_GET.
> 
> Or is it too much ETHTOOL_A_HEADER_?

Dunno, that'd mean that the Python method is called
ETHTOOL_MSG_CHANNELS_GET rather than just channels_get.
I don't want to force all languages to use the C naming.
The C naming just leads to silly copy'n'paste issues like
f329a0ebeab.

> > +        len: ALTIFNAMSIZ - 1  
> 
> Not sure how strict you want to be here. ALTIFNAMSIZ is defined
> somewhere else it seems? (IOW, do we want to have implicit dependencies
> on external/uapi headers?)

Good catch, I'm aware. I was planning to add a "header constants" 
section or some such. A section in "headers" which defines the 
constants which C code will get from the headers.

For Python it does not matter, as we don't have to size arrays.
I was wondering if it will matter for other languages, like Rust?

> > +            - header
> > +            - rx_count
> > +            - tx_count
> > +            - other_count
> > +            - combined_count  
> 
> My netlink is super rusty, might be worth mentioning in the spec: these
> are possible attributes, but are all of them required?

Right, will do, nothing is required, or rather requirements are kinda
hard to express and checked by the code in the kernel.

> You also mention the validation part in the cover letter, do you plan
> add some of these policy properties to the spec or everything is
> there already? (I'm assuming we care about the types which we have above and
> optional/required attribute indication?)

Yeah, my initial plan was to encode requirement in the policy but its
not trivial. So I left it as future extension. Besides things which are
required today may not be tomorrow, so its a bit of a strange thing.

Regarding policy properties I'm intending to support all of the stuff
that the kernel policies recognize... but somehow most families I
converted don't have validation (only mask and length :S).

Actually for DPLL I have a nice validation trick. You can define an
enum:

constants:
  -
    type: flags
    name: genl_get_flags
    value-prefix: DPLL_FLAG_
    values: [ sources, outputs, status ]

Then for an attribute you link it:

      -
        name: flags
        type: u32
        flags-mask: genl_get_flags

And that will auto an enum:

enum dpll_genl_get_flags {
	DPLL_FLAG_SOURCES = 1,
	DPLL_FLAG_OUTPUTS = 2,
	DPLL_FLAG_STATUS = 4,
};

And a policy with a mask:

	[DPLLA_FLAGS] = NLA_POLICY_MASK(NLA_U32, 0x7),
