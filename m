Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DEE456AA2A
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 20:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235934AbiGGSBf convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 7 Jul 2022 14:01:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235546AbiGGSBe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 14:01:34 -0400
Received: from relay3.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D693A23BFE
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 11:01:33 -0700 (PDT)
Received: from omf11.hostedemail.com (a10.router.float.18 [10.200.18.1])
        by unirelay01.hostedemail.com (Postfix) with ESMTP id 1B3526101C;
        Thu,  7 Jul 2022 18:01:31 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf11.hostedemail.com (Postfix) with ESMTPA id E45E020037;
        Thu,  7 Jul 2022 18:01:27 +0000 (UTC)
Message-ID: <da17617717c5f6a79f58cdf4a56cd39e28c53377.camel@perches.com>
Subject: Re: [PATCH] net: ipv4: fix clang -Wformat warning
From:   Joe Perches <joe@perches.com>
To:     Justin Stitt <justinstitt@google.com>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Date:   Thu, 07 Jul 2022 11:01:26 -0700
In-Reply-To: <CAFhGd8oTybm0aQ_q60e+exf5eFO1kLiNKnmDZfVTyg=BbtgZsw@mail.gmail.com>
References: <20220707173040.704116-1-justinstitt@google.com>
         <6f5a1c04746feb04add15107c70332ac603e4561.camel@perches.com>
         <CAFhGd8oTybm0aQ_q60e+exf5eFO1kLiNKnmDZfVTyg=BbtgZsw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.44.1-0ubuntu1 
MIME-Version: 1.0
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=no
        autolearn_force=no version=3.4.6
X-Stat-Signature: 9hji8x14hjnfib6t8mqzghy4hgmidssk
X-Rspamd-Server: rspamout05
X-Rspamd-Queue-Id: E45E020037
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX1+YCj/8yCY3yEUbxnuMVC5Ve/GvPfwKDhc=
X-HE-Tag: 1657216887-660842
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2022-07-07 at 10:47 -0700, Justin Stitt wrote:
> On Thu, Jul 7, 2022 at 10:40 AM Joe Perches <joe@perches.com> wrote:
> > 
> > On Thu, 2022-07-07 at 10:30 -0700, Justin Stitt wrote:
> > > When building with Clang we encounter this warning:
> > > > net/ipv4/ah4.c:513:4: error: format specifies type 'unsigned short' but
> > > > the argument has type 'int' [-Werror,-Wformat]
> > > > aalg_desc->uinfo.auth.icv_fullbits / 8);
> > > 
> > > `aalg_desc->uinfo.auth.icv_fullbits` is a u16 but due to default
> > > argument promotion becomes an int.
> > > 
> > > Variadic functions (printf-like) undergo default argument promotion.
> > > Documentation/core-api/printk-formats.rst specifically recommends using
> > > the promoted-to-type's format flag.
> > > 
> > > As per C11 6.3.1.1:
> > > (https://www.open-std.org/jtc1/sc22/wg14/www/docs/n1548.pdf) `If an int
> > > can represent all values of the original type ..., the value is
> > > converted to an int; otherwise, it is converted to an unsigned int.
> > > These are called the integer promotions.` Thus it makes sense to change
> > > %hu to %d not only to follow this standard but to suppress the warning
> > > as well.
> > 
> > I think it also makes sense to use %u and not %d
> > as the original type is unsigned.
> Yeah, that would also work. An integer (even a signed one) fully
> encompasses a u16 so it's really a choice of style. Do you think the
> change to %u warrants a v2 of this patch?

As it's rather odd output to use '%u != %d', probably.

Your patch, up to you.

> > 
> > > diff --git a/net/ipv4/ah4.c b/net/ipv4/ah4.c
> > []
> > > @@ -507,7 +507,7 @@ static int ah_init_state(struct xfrm_state *x)
> > > 
> > >       if (aalg_desc->uinfo.auth.icv_fullbits/8 !=
> > >           crypto_ahash_digestsize(ahash)) {
> > > -             pr_info("%s: %s digestsize %u != %hu\n",
> > > +             pr_info("%s: %s digestsize %u != %d\n",
> > >                       __func__, x->aalg->alg_name,
> > >                       crypto_ahash_digestsize(ahash),
> > >                       aalg_desc->uinfo.auth.icv_fullbits / 8);
> > 

