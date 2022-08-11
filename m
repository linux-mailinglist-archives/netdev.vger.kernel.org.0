Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E524A590932
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 01:31:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236665AbiHKXbR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 19:31:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233974AbiHKXbQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 19:31:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28AF99410B;
        Thu, 11 Aug 2022 16:31:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D63FBB82339;
        Thu, 11 Aug 2022 23:31:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3764BC433D6;
        Thu, 11 Aug 2022 23:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660260672;
        bh=g9lXYjeZup1st1u3UHpbk9YPsqoJWbV7ijlwPKUv80U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SUz/ZJw84+7ItNUt3Pf3kI+WmsYaNCOBfNuz4W3JSmo5avGwaplPRzIA6GHdHnM69
         GS0+hOCpWFbgPrYRWjlfZzwo1SlzLjMnR//9J+sgUwv7jnOAdNinTESNOxK+lg70fb
         9GxfggVtXQcYYgJ9ulmVy8jLuLEbFJeDaZS9gJuJpoHp4YWxjnCMdRPTly8DKNhxLr
         EkwNhhc5oBjxsAO7mTV15e33iz15ht5sc+b1PfyPPLLT1QTb7VnJFhNQuj1vwEzkqv
         V6vRHQVbDKm7qH34QuKTJ+gJTwL9jjGxShpfp5dvCxZ8e8FFWsqWEtwxc8G51/o4Ht
         1iYfMPJm7fk3Q==
Date:   Thu, 11 Aug 2022 16:31:11 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, jacob.e.keller@intel.com, vadfed@fb.com,
        johannes@sipsolutions.net, jiri@resnulli.us, dsahern@kernel.org,
        stephen@networkplumber.org, fw@strlen.de, linux-doc@vger.kernel.org
Subject: Re: [RFC net-next 4/4] ynl: add a sample user for ethtool
Message-ID: <20220811163111.56d83702@kernel.org>
In-Reply-To: <CAKH8qBs54kX_MjA2xHM1sSa_zvNYDEPhiZcwEVWV4kP1dEPcEw@mail.gmail.com>
References: <20220811022304.583300-1-kuba@kernel.org>
        <20220811022304.583300-5-kuba@kernel.org>
        <YvUru3QvN/LuYgnq@google.com>
        <20220811123515.4ef1a715@kernel.org>
        <CAKH8qBs54kX_MjA2xHM1sSa_zvNYDEPhiZcwEVWV4kP1dEPcEw@mail.gmail.com>
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

On Thu, 11 Aug 2022 15:55:44 -0700 Stanislav Fomichev wrote:
> > We could, I guess. To be clear this controls the count, IOW:
> >
> > enum {
> >         PREFIX_A_BLA_ATTR = 1,
> >         PREFIX_A_ANOTHER_ATTR,
> >         PREFIX_A_AND_ONEMORE,
> >         __PFREIX_A_CNT, // <--- This thing
> > };
> > #define PREFIX_A_MAX (__PFREIX_A_CNT - 1)
> >
> > It's not used in the generated code, only if we codegen the uAPI,
> > AFAIR. So we'd need a way to tell the generator of the uAPI about
> > the situation, anyway. I could be misremembering.  
> 
> My worry is that we'll have more hacks like these and it's hard, as a
> spec reader/writer, to figure out that they exist..
> So I was wondering if it's "easier" (from the spec reader/writer pov)
> to have some c-header-fixup: section where we can have plain
> c-preprocessor hacks like these (where we need to redefine something
> to match the old behavior).

Let me think about it some more. My main motivation is people writing
new families, I haven't sent too much time worrying about the existing
ones with all their quirks. It's entirely possible that the uAPI quirks
can just go and we won't generate uAPI for existing families as it
doesn't buy us anything.

> Coming from stubby/grpc, I was expecting to see words like
> message/field/struct. The question is what's more confusing: sticking
> with netlink naming or trying to map grpc/thrift concepts on top of
> what we have. (I'm assuming more people know about grpc/thrift than
> netlink)
> 
> messages: # or maybe 'attribute-sets' ?
>   - name: channels
>     ...

Still not convinced about messages, as it makes me think that every
"space" is then a definition of a message rather than just container
for field definitions with independent ID spaces. 

Attribute-sets sounds good, happy to rename.

Another thought I just had was to call it something like "data-types"
or "field-types" or "type-spaces". To indicate the split into "data" 
and "actions"/"operations"?

> operations:
>   - name: channel_get
>     message: channels
>     do:
>       request:
>         fields:
>         - header
>         - rx_max
> 
> Or maybe all we really need is a section in the doc called 'Netlink
> for gRPC/Thrift users' where we map these concepts:
> - attribute-spaces (attribute-sets?) -> messages
> - attributes -> fields

Excellent idea!

> > Dunno, that'd mean that the Python method is called
> > ETHTOOL_MSG_CHANNELS_GET rather than just channels_get.
> > I don't want to force all languages to use the C naming.
> > The C naming just leads to silly copy'n'paste issues like
> > f329a0ebeab.  
> 
> Can we have 'name:' and 'long-name:' or 'c-name:' or 'full-name' ?
> 
> - name: header
>    attributes:
>     - name: dev_index
>       full-name: ETHTOOL_A_HEADER_DEV_INDEX
>       val:
>       type:
> 
> Suppose I'm rewriting my c application from uapi to some generated (in
> the future) python-like channels_get() method. If I can grep for
> ETHTOOL_MSG_CHANNELS_GET, that would save me a bunch of time figuring
> out what the new canonical wrapper is.
> 
> Also, maybe, at some point we'll have:
> - name: dev_index
>   c-name: ETHTOOL_A_HEADER_DEV_INDEX
>   java-name: headerDevIndex

Herm, looking at my commits where I started going with the C codegen
(which I haven't posted here) is converting the values to the same
format as keys (i.e. YAML/JSON style with dashes). So the codegen does:

	c_name = attr['name']
	if c_name in c_keywords:
		c_name += '_'
	c_name = c_name.replace('-', '_')

So the name would be "dev-index", C will make that dev_index, Java will
make that devIndex (or whatever) etc.

I really don't want people to have to prefix the names because that's
creating more work. We can slap a /* header.dev_index */ comment in 
the generated uAPI, for the grep? Dunno..

> > Good catch, I'm aware. I was planning to add a "header constants"
> > section or some such. A section in "headers" which defines the
> > constants which C code will get from the headers.  
> 
> Define as in 're-define' or define as in 'you need to include some
> other header for this to work'?
> 
> const:
>   - name: ALTIFNAMSIZ
>     val: 128

This one. In most cases the constant is defined in the same uAPI header
as the proto so we're good. But there's IFNAMSIZ and friends which are
shared.

> which then does
> 
> #ifndef
> #define ALTIFNAMSIZ 128
> #else
> static_assert(ALTIFNAMSIZ == 128)
> #endif
> 
> ?
> 
> or:
> 
> external-const:
>   - name: ALTIFNAMSIZ
>     header: include/uapi/linux/if.h
> 
> which then might generate the following:
> 
> #include <include/uapi/linux/if.h>
> #ifndef ALTIFNAMSIZ
> #error "include/uapi/linux/if.h does not define ALTIFNAMSIZ"
> #endif
> 
> > For Python it does not matter, as we don't have to size arrays.  
> 
> Hm, I was expecting the situation to be the opposite :-) Because if
> you really have to know this len in python, how do you resolve
> ALTIFNAMSIZ?

Why does Python need to know the length of the string tho?
On receive if kernel gives you a longer name - great, no problem.
On send the kernel will tell you so also meh.

In C the struct has a char bla[FIXED_SIZE] so if we get an oversized
string we're pooped, that's my point, dunno what other practical use
the string sizing has.

> The simplest thing to do might be to require these headers to be
> hermetic (i.e., redefine all consts the spec cares about internally)?

That's what I'm thinking if they are actually needed. But it only C
cares we can just slap the right includes and not worry. Dunno if other
languages are similarly string-challenged. 
