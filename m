Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D142E6A645C
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 01:42:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbjCAAmv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 19:42:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbjCAAmu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 19:42:50 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3CB438013
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 16:42:44 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id i34so47388724eda.7
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 16:42:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1677631363;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6+Y/xqXtM4CeDX2eR0y7F5j30gs0rHpamGJAJph3YVc=;
        b=iWJpu2di/vSzvCTDcD5YZ150MBA2doZ4mYtkyP7qQWwv8L54h1fgrsPw9SXjwdrHPH
         l0NMbV22OXlKjaMstIS6or4y8WfhLrb504qzioPquCupjpxoz9dMo/aHow/Ufo9eq109
         OgNDB1B1xYn9wKsWJNSSlZuWfPat0SBVKlTuc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677631363;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6+Y/xqXtM4CeDX2eR0y7F5j30gs0rHpamGJAJph3YVc=;
        b=3dezaXtFGxU+4fbW0tq7deN2Jjxz5YmQRAARfZdWCpug744Qz8o/vMgzSywvaLS1oK
         sU7+yhipWJ217M+r0BT2K721V7JGMqbmYJtCKJUmjkI7iINARxYIu16ZyRmCcifpFnK5
         o8ZGV/At5tjscUP8wouK+lV25XNzL99JEjFQgsIUErEuzGTexq4z8MEn2Wt/LaYYtjtk
         Pvthllgc1RO5BvUpMDtAgtj3PNrwcDUfZYiWpHVBSEUjzkaZLBo09bHafSSFWnJP+hNa
         SO6IhW/0FksAbEO6iPqqdvBP8nvLZEfQfwJ4TNFEBEbrLv3ZlnN1BXgWJ+Wqm4wiOiBq
         Bv9g==
X-Gm-Message-State: AO0yUKW7WL0jg/aAPQtFgH+21ToFGN6NsbVWe9z4fBHsMhMjPXVxSUz3
        HS7H8L49u5W8RO+zW2nz71lf/JqMtQFufTNVdrg=
X-Google-Smtp-Source: AK7set9+1Ss0DOZK1fjkt+eNpMUKxwS8DC63AGD8S+6cNlMB29CBQzi1eNsw4NnWiTFB8jcl8m90Dw==
X-Received: by 2002:a17:906:858c:b0:8b1:3a23:8ec7 with SMTP id v12-20020a170906858c00b008b13a238ec7mr3791194ejx.43.1677631362909;
        Tue, 28 Feb 2023 16:42:42 -0800 (PST)
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com. [209.85.208.48])
        by smtp.gmail.com with ESMTPSA id u11-20020a170906108b00b008d173604d72sm5104351eju.174.2023.02.28.16.42.41
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Feb 2023 16:42:41 -0800 (PST)
Received: by mail-ed1-f48.google.com with SMTP id eg37so47264940edb.12
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 16:42:41 -0800 (PST)
X-Received: by 2002:a17:906:5d10:b0:8f5:2e0e:6dc5 with SMTP id
 g16-20020a1709065d1000b008f52e0e6dc5mr4097453ejt.0.1677631361396; Tue, 28 Feb
 2023 16:42:41 -0800 (PST)
MIME-Version: 1.0
References: <20230228132118.978145284@linutronix.de> <20230228132910.991359171@linutronix.de>
In-Reply-To: <20230228132910.991359171@linutronix.de>
From:   Linus Torvalds <torvalds@linuxfoundation.org>
Date:   Tue, 28 Feb 2023 16:42:23 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjeMbHK61Ee+Ug4w8AGHCSDx94GuLs5bPXhHNhA_+RjzA@mail.gmail.com>
Message-ID: <CAHk-=wjeMbHK61Ee+Ug4w8AGHCSDx94GuLs5bPXhHNhA_+RjzA@mail.gmail.com>
Subject: Re: [patch 2/3] atomics: Provide rcuref - scalable reference counting
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Wangyang Guo <wangyang.guo@intel.com>,
        Arjan Van De Ven <arjan.van.de.ven@intel.com>,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 28, 2023 at 6:33=E2=80=AFAM Thomas Gleixner <tglx@linutronix.de=
> wrote:
>
> This unconditional increment avoids the inc_not_zero() problem, but
> requires a more complex implementation on the put() side when the count
> drops from 1 to 0.
>
> When this transition is detected then it is attempted to mark the referen=
ce
> count dead, by setting it to the midpoint of the dead zone with a single
> atomic_cmpxchg_release() operation. This operation can fail due to a
> concurrent rcuref_get() elevating the reference count from 0 to 1.

This looks sane to me, however it does look like the code is not really opt=
imal.

This is supposed to be a critical function, and is inlined:

> +static inline __must_check bool rcuref_get(rcuref_t *ref)
> +{
> +       unsigned int old =3D atomic_fetch_add_relaxed(1, &ref->refcnt);
> +
> +       if (likely(old < RCUREF_MAXREF))
> +               return true;

but that comparison would be much better if RCUREF_MAXREF was
0x80000000 and you'd end up just checking the sign of the result,
instead of checking big numbers.

Also, this optimal value choice ends up being architecture-specific,
since some do the "fetch_add", and others tend to prefer "add_return",
and so the point that is cheapest to check ends up depending on which
architecture it is.

This may seem like nit-picking, but I absolutely *HATE* our current
refcount interface for how absolutely horrid the code generation ends
up being. It's gotten better, but it's still not great.

So if we're introducing yet another refcount interface, and it's done
in the name of efficiency, I would *really* want it to actually be
exactly that: efficient. Not some half-way thing.

And yes, that may mean that it should have some architecture-specific
code (with fallback defaults for the generic case).

               Linus
