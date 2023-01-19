Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2FEA674C5C
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 06:29:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230297AbjATF3Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 00:29:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbjATF2r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 00:28:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E1DD518C4;
        Thu, 19 Jan 2023 21:23:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 193B1B8274C;
        Thu, 19 Jan 2023 21:49:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CB9AC433EF;
        Thu, 19 Jan 2023 21:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674164963;
        bh=MgNZwh4nQfnPJ36l6qwjUf+OsEmqk/JP33EfxezB2/s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bxHCEZApGhGuevD3ZIoR9MTH0Y0E6fI9H29vx86L0Ek9d1bc2qu/8+Npx030BqhF2
         EvmzFRodGoGQWwF49dNFjRCyC82zlrNCH5K5EOfVq/prLvIY0d5NUWAetuOBWvjdwi
         FaMs0ZLskLypejHgTLkFhcKGromK9vbiY/v+ElTXXtp4fSXTzSz4BAA3jkuhz8jEDL
         nbGF0vIWccRNp1D1l+q8KtXg0E8bl6atR1nErEe8UO9gy1hJa/EbWLmWfIfpQi7MuK
         PJUxeDv2C19heyJZVwR9M5raM0hpg8ZOOF/gyQWTqnGoPnXHrp0aNyp4q35IdcE7JH
         38UAESjR19gxA==
Date:   Thu, 19 Jan 2023 13:49:22 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rob Herring <robh@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, johannes@sipsolutions.net,
        stephen@networkplumber.org, ecree.xilinx@gmail.com, sdf@google.com,
        f.fainelli@gmail.com, fw@strlen.de, linux-doc@vger.kernel.org,
        razor@blackwall.org, nicolas.dichtel@6wind.com
Subject: Re: [PATCH net-next v3 2/8] netlink: add schemas for YAML specs
Message-ID: <20230119134922.3fa24ed2@kernel.org>
In-Reply-To: <CAL_JsqKk5RT6PmRSrq=YK7AvzCbcVkxasykJqe1df=3g-=kD7A@mail.gmail.com>
References: <20230119003613.111778-1-kuba@kernel.org>
        <20230119003613.111778-3-kuba@kernel.org>
        <CAL_JsqKk5RT6PmRSrq=YK7AvzCbcVkxasykJqe1df=3g-=kD7A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 Jan 2023 08:07:31 -0600 Rob Herring wrote:
> On Wed, Jan 18, 2023 at 6:36 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > Add schemas for Netlink spec files. As described in the docs
> > we have 4 "protocols" or compatibility levels, and each one
> > comes with its own schema, but the more general / legacy
> > schemas are superset of more modern ones: genetlink is
> > the smallest followed by genetlink-c and genetlink-legacy.
> > There is no schema for raw netlink, yet, I haven't found the time..
> >
> > I don't know enough jsonschema to do inheritance or something
> > but the repetition is not too bad. I hope.  
> 
> Generally you put common schemas under '$defs' and the then reference
> them with '$ref'.
> 
> $defs:
>   some-prop-type:
>     type: integer
>     minimum: 0
> 
> properties:
>   foo:
>     $ref: '#/$defs/some-prop-type'
>   bar:
>     $ref: '#/$defs/some-prop-type'

Thanks! Is it possible to move the common definitions to a separate
file? I tried to create a file called defs.yaml and change the ref to:

  $ref: "defs.yaml#/$defs/len-or-define"

But:

  File "/usr/lib/python3.11/site-packages/jsonschema/validators.py", line 257, in iter_errors
    for error in errors:
  File "/usr/lib/python3.11/site-packages/jsonschema/_validators.py", line 294, in ref
    scope, resolved = validator.resolver.resolve(ref)
                      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "/usr/lib/python3.11/site-packages/jsonschema/validators.py", line 856, in resolve
    return url, self._remote_cache(url)
                ^^^^^^^^^^^^^^^^^^^^^^^
  File "/usr/lib/python3.11/site-packages/jsonschema/validators.py", line 870, in resolve_from_url
    raise exceptions.RefResolutionError(exc)
jsonschema.exceptions.RefResolutionError: Expecting value: line 1 column 1 (char 0)

> If you have objects with common sets of properties, you can do the
> same thing, but then you need 'unevaluatedProperties' if you want to
> define a base set of properties and add to them. We do that frequently
> in DT schemas. Unlike typical inheritance, you can't override the
> 'base' schema. It's an AND operation.

This is hard to comprehend :o Most of the time I seem to need only the
ability to add a custom "description" to the object, so for example:

$defs:
  len-or-define:
    oneOf:
      -
        type: string
        pattern: ^[0-9A-Za-z_-]*( - 1)?$
      -
        type: integer
        minimum: 0

Then:

       min-len:
         description: Min length for a binary attribute.
         $ref: '#/$defs/len-or-define'

And that seems to work. Should I be using unevaluatedProperties somehow
as well here?

> > +          description: |
> > +            Name used when referring to this space in other definitions, not used outside of YAML.
> > +          type: string
> > +        # Strictly speaking 'name-prefix' and 'subset-of' should be mutually exclusive.  
> 
> If one is required:
> 
> oneOf:
>   - required: [ name-prefix ]
>   - required: [ subset-of ]
> 
> Or if both are optional:
> 
> dependencies:
>   name-prefix:
>     not:
>       required: [ subset-of ]
>   subset-of:
>     not:
>       required: [ name-prefix ]

Nice, let me try this.

> > +                  min-len:
> > +                    description: Min length for a binary attribute.
> > +                    oneOf:
> > +                      - type: string
> > +                        pattern: ^[0-9A-Za-z_-]*( - 1)?$
> > +                      - type: integer  
> 
> How can a length be a string?

For readability in C I wanted to allow using a define for the length.
Then the name of the define goes here, and the value can be fetched
from the "definitions" section of the spec.

> Anyways, this is something you could pull out into a $defs entry and
> reference. It will also work without the oneOf because 'pattern' will
> just be ignored for an integer. That's one gotcha with json-schema. If
> a keyword doesn't apply to the instance, it is silently ignored. (That
> includes unknown keywords such as ones with typos. Fun!). 'oneOf' will
> give you pretty crappy error messages, so it's good to avoid when
> possible.

Oh, interesting. Changed to:

$defs:
  len-or-define:
    type: [ string, integer ]
    pattern: ^[0-9A-Za-z_-]*( - 1)?$
    minimum: 0
