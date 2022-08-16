Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BCDC59528B
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 08:31:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbiHPGa7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 02:30:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbiHPGag (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 02:30:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56B3C365805;
        Mon, 15 Aug 2022 17:47:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 39C46611CA;
        Tue, 16 Aug 2022 00:47:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 166FCC433D6;
        Tue, 16 Aug 2022 00:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660610863;
        bh=rivhVaF5P8dIsbt4rHeNA6xHf5uobphxrS9T5pIZWeQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Q4pzVYGgg9a3hCz6aB6GO6WMg6deuAfaAezLJfmPeKzGcK2mqExggbaGcTurQbohm
         xkLRWvHluqnvPXX+Yk519XDp67JdiQuBOB3UlITtOIKpV3zIG763SHyFXLn9ldka0d
         vmSvoG4vlhN036iZmC2FGocR7nNmVVWK9cwehULjdjDIDYpZ7QySXxu12YKIvckbj2
         Hj3l7mxlrcIaZKk25Pv84OoQKAPpGGV6oLY0iq/mt8rAiowyGeeeAghafIxM5thbqa
         pOp0xCM3POL6/mc+0HT4+5amvNYy1SBavOod+L8F5kdQ3nqIUkhDICShjDF6AXvqW0
         iEmlCco7A9Tyg==
Date:   Mon, 15 Aug 2022 17:47:42 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, sdf@google.com, jacob.e.keller@intel.com,
        vadfed@fb.com, jiri@resnulli.us, dsahern@kernel.org,
        stephen@networkplumber.org, fw@strlen.de, linux-doc@vger.kernel.org
Subject: Re: [RFC net-next 2/4] ynl: add the schema for the schemas
Message-ID: <20220815174742.32b3611e@kernel.org>
In-Reply-To: <6b972ef603ff2bc3a3f3e489aa6638f6246c1e48.camel@sipsolutions.net>
References: <20220811022304.583300-1-kuba@kernel.org>
        <20220811022304.583300-3-kuba@kernel.org>
        <6b972ef603ff2bc3a3f3e489aa6638f6246c1e48.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 15 Aug 2022 22:09:11 +0200 Johannes Berg wrote:
> On Wed, 2022-08-10 at 19:23 -0700, Jakub Kicinski wrote:
> > 
> > +        attributes:
> > +          description: List of attributes in the space.
> > +          type: array
> > +          items:
> > +            type: object
> > +            required: [ name, type ]
> > +            additionalProperties: False
> > +            properties:
> > +              name:
> > +                type: string
> > +              type: &attr-type
> > +                enum: [ unused, flag, binary, u8, u16, u32, u64, s32, s64,
> > +                        nul-string, multi-attr, nest, array-nest, nest-type-value ]  
> 
> nest-type-value?

It's the incredibly inventive nesting format used in genetlink policy
dumps where the type of the sub-attr(s there are actually two levels)
carry a value (index of the policy and attribute) rather than denoting
a type :S :S :S

I really need to document the types, I know...

> > +              description:
> > +                description: Documentation of the attribute.
> > +                type: string
> > +              type-value:
> > +                description: Name of the value extracted from the type of a nest-type-value attribute.
> > +                type: array
> > +                items:
> > +                  type: string
> > +              len:
> > +                oneOf: [ { type: string }, { type: integer }]
> > +              sub-type: *attr-type
> > +              nested-attributes:
> > +                description: Name of the space (sub-space) used inside the attribute.
> > +                type: string  
> 
> Maybe expand that description a bit, it's not really accurate for
> "array-nest"?

Slightly guessing but I think I know what you mean -> the value of the
array is a nest with index as the type and then inside that is the
entry of the array with its attributes <- and that's where the space is
applied, not at the first nest level?

Right, I should probably put that in the docs rather than the schema,
array-nests are expected to strip one layer of nesting and put the
value taken from the type (:D) into an @idx member of the struct
representing the values of the array. Or at least that's what I do in
the C codegen.

Not that any of these beautiful, precious formats should be encouraged
going forward. multi-attr all the way!

> > +              enum:
> > +                description: Name of the enum used for the atttribute.  
> 
> typo - attribute

Thanks!

> Do you mean the "name of the enumeration" or the "name of the
> enumeration constant"? (per C99 concepts) I'm a bit confused? I guess
> you mean the "name of the enumeration constant" though I agree most
> people probably don't know the names from C99 (I had to look them up too
> for the sake of being precise here ...)

I meant the type. I think. When u32 carries values of an enum.
Enumeration constant for the attribute type is constructed from
it's name and the prefix/suffix kludge.
