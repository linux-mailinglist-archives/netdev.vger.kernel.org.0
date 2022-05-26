Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 576B25353CC
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 21:12:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238699AbiEZTMM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 15:12:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229896AbiEZTML (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 15:12:11 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B5189CF52
        for <netdev@vger.kernel.org>; Thu, 26 May 2022 12:12:10 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id s14so4397626ybc.10
        for <netdev@vger.kernel.org>; Thu, 26 May 2022 12:12:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EBNON44YyLTaKbLKZQBq6N75tWNiWAtt9fCntxmnYVQ=;
        b=bA8p/aedo22mEjYCIcs4OqaatmvpBQMj3AliT5OdNmq8jL9eHSqZsUcatRozvB3Spy
         zXvpnomt4gDzutYpXbNiD/9+PzqX0ksuGxqshdo36xd7SdteOcFhQjE8lVGD3lT997iW
         ePLuQPaExK43nqXj0gUwgnC4VPvCaSnerjxLEDBoeAddexiKN9zZruL17zFTurLNjZlT
         I5kkXeQZynetX3J+sRM3vIvrfzPHi83pbPZpSUxncccNPawK7HCkdAm4V4p7QHCHQJJV
         QrmJS8IkmSvk3qx/JuoZRJpEemxbDls6Bn9q8EEFrefr344NaENqWopgXsHLBy6fJJ2D
         2x1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EBNON44YyLTaKbLKZQBq6N75tWNiWAtt9fCntxmnYVQ=;
        b=2g03WcH6011H2U169dcixO0WhTjiOiopN7i6SIWqhkZ6eJQfyiiFFM4/3qVp3l2Gqa
         rns+lbNx1KryXU9doW31k6zkJyWuzA3U55Fxa3+3qWZn7LyJfGSVfGGQHu4Y/LSJhdqL
         p7L0DByVpRyEA2tOA3HirgN+D9KG2FgwXPwuExjbgCEd3Yc2juTszarb824TMOEwfSe6
         4ASWQsdQVxQQF9XCAvSjtZ8pr2bGOTOtYH4kEmpEH/wutFcfdtFhfWq1B0Nf90UTrjUr
         y7+ZZJ/m6RwIT+pHHtmYtRhs/7xwZBu0see/yT0hJMJWAlK2muE86EVcDmKBsgRj705Z
         ZF5A==
X-Gm-Message-State: AOAM531pnnPLgSKYXqkgITGsiHrQwTFqDzNfWTfpmv1X6vbG0HkvIlZr
        yWlfes1FE+pKbtWIGbgwXSnTpI2r0GLIlcJSi/Y=
X-Google-Smtp-Source: ABdhPJwkdzaLhmjZH72qg2fkER+bjYrofegdz8Ov+pw2Wb//R/YoGCMeH40nn3QhGeg6DM76IdXLC4jHPEC5C0N8rGw=
X-Received: by 2002:a25:d38c:0:b0:657:1c9d:96e9 with SMTP id
 e134-20020a25d38c000000b006571c9d96e9mr4103996ybf.547.1653592329447; Thu, 26
 May 2022 12:12:09 -0700 (PDT)
MIME-Version: 1.0
References: <20220523202543.9019-1-CFSworks@gmail.com> <76f1d70068523c173670819fc9a688a1368bfa12.camel@redhat.com>
 <CAH5Ym4gm49mkMUKzyPqKT8vt3M67NZB-zoep3bu+VB3FbuVzCQ@mail.gmail.com> <5497d8af4630264418ad91513e7eafeb016e6971.camel@redhat.com>
In-Reply-To: <5497d8af4630264418ad91513e7eafeb016e6971.camel@redhat.com>
From:   Sam Edwards <cfsworks@gmail.com>
Date:   Thu, 26 May 2022 13:11:57 -0600
Message-ID: <CAH5Ym4gXVvESnE9ZbJL+QbucrOB=M4LXEZw+XvSA04xxFVfy6g@mail.gmail.com>
Subject: Re: [PATCH] ipv6/addrconf: fix timing bug in tempaddr regen
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 26, 2022 at 1:40 AM Paolo Abeni <pabeni@redhat.com> wrote:
> 'age', 'ifp->prefered_lft' and 'regen_advance' are unsigned, and it
> looks like 'regen_advance' is not constrained to be less then 'ifp-
> >prefered_lft'. If that happens the condition will (allways) evaluate
> to false, there will be no temporary address regenaration,
> 'regen_count' will be untouched and the temporary address will never
> expire...

Hmm... I think the answer to whether `regen_advance` is constrained is
"yes but actually no."

ipv6_create_tempaddr() does have a check that will return early
without even creating an address if the calculated preferred lifetime
isn't greater than regen_advance. Now, if regen_advance were a
constant, I'd say that's the end of it, but it's actually computed
from some configuration variables which the system administrator might
change (increase) between then and here. So what you said could end up
happening, albeit in rare circumstances.

> Otherwise I think we need to explicitly handle the 'regen_advance >
> ifp->prefered_lft' condition possibly with something alike:
>
>         unsigned long regen_advance = ifp->idev->cnf.regen_max_retry * //...
>
>         regen_adavance = min(regen_advance, ifp->prefered_lft);
>         if (age >= ifp->prefered_lft - regen_advance) { //...

For readability's sake, it might be better to mirror what
ipv6_create_tempaddr does:
if (age + regen_advance >= ifp->prefered_lft)

Does that seem good? I doubt we'll have overflows as they would
require unreasonably large regen_advance values.

===

Now, in thinking about this some more, I'm starting to believe that
this if/elseif/elseif/... block is not the appropriate place for
tempaddr regeneration at all. The branches of this block implement the
*destructive* parts of an address's lifecycle. Most importantly, the
branches can be in latest-to-earliest order because the effects are
*cumulative*: if an address has a valid_lft only a second longer than
the prefered_lft, and addrconf_verify_rtnl runs a second late, then
the DEPRECATED branch will be skipped, but that's okay because the
address actually gets deleted instead. Regenerating a temporary
address is *not* a destructive stage in the address's lifecycle -- the
effects are not cumulative -- so if that stage is skipped,
regeneration never happens. My patch is trying to fix that by
essentially *holding up the lifecycle* until regeneration happens. But
that's leading to the more general concern I am seeing from you: a
logic error in regeneration (even one that has been there all along,
such as the potential underflow you just pointed out) could then
affect the whole deprecation flow, not just regeneration.

So, I think my v2 patch should probably put the tempaddr case right:

age = (now - ifp->tstamp + ADDRCONF_TIMER_FUZZ_MINUS) / HZ;
// here
if (ifp->valid_lft != INFINITY_LIFE_TIME &&
    age >= ifp->valid_lft) {

Thoughts? :)

Thank you for your input,
Sam
