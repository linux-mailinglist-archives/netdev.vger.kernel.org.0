Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F16163FBD1
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 00:17:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231381AbiLAXRY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 18:17:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230465AbiLAXRX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 18:17:23 -0500
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 414492125A;
        Thu,  1 Dec 2022 15:17:22 -0800 (PST)
Received: by mail-ot1-x32d.google.com with SMTP id a13-20020a9d6e8d000000b00668d65fc44fso1943475otr.9;
        Thu, 01 Dec 2022 15:17:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=DBc6RFle0m00JwSwMB3U89uXhK/jC0j0+ULxJGcGlZs=;
        b=aVaxUFeXgNiOog4IIjsp4DVM0zKmVuqgyBHsoUAs5rnylyB69Olppto9g4gFcN4FqQ
         H4SWhHi/33n3YxprvfTVvwFocCK1jHIvsnvJUNLNCItNCsDmNrYzQ9T9l0/XJICjsOWu
         4o4K0L5FK9udSpwBFbiETnf8s/m/asKVYs2Wqw89hvoGJpb+9pa3jlp5hTvu90T4ED9s
         Q14Kia1OiG1fSMTVomIH9Nn6lKnpjGWZ9w4OlkKoHvpbofIb4a99ntMv7ExUULwAdv74
         BXRDzuvdA+X3O/Jm+DEpktWCQ+Rx5DXoDS5rxkjm4YhvB6DUVPtOo3zeBTY+yUnOO3gv
         zh0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DBc6RFle0m00JwSwMB3U89uXhK/jC0j0+ULxJGcGlZs=;
        b=gEwvGpsTQUXOqj3mEREwqYg6yQTFI0VW+ESr0B7ihoiRQonW47t/rXM1gtfsLqmreM
         scpm7D+O+facB/lFIoDgm3ckuVEOmjHXh/rw/H/xjSTEEaxG/msBw5hapJepXKCJEgMT
         ALuTHs5sjryA26dBLsjTJYk2ksjkkiXJthLvO9u5bjsbShMZP3YnQiwdbikDYvdVnlsm
         UYvSoMpV0w0Y2fyc8X+FhezvqHimlVxR5Ery2l9biWcAaAUHMZsG6RG5dyyA/+RVHpbv
         5Y32bh7eYTO3OorRNmVsU+jHn86Zhm1gxj6GJRTU6zSV8IQhQ4WLWIwWz2huzeoEi0Ex
         D7eQ==
X-Gm-Message-State: ANoB5pnkBjbYhTjJ2l+kiVa0ATvMJ6vTCH+VyXztsIxFaE3AT4Ob+CIc
        MLFkCtd4mDM6evg5kO8U12BCMxIArFA9SQpaRe/5i1OS
X-Google-Smtp-Source: AA0mqf5MPDDKs+XONRrgIA79tbujNUkca/XcpxNtJ/8DIRgqhG2PKd7cZF1d44wjXS0vCpFNxsTDFUCTwFYDhCt86/k=
X-Received: by 2002:a05:6830:3697:b0:66b:e4f2:7f2a with SMTP id
 bk23-20020a056830369700b0066be4f27f2amr25550959otb.317.1669936641563; Thu, 01
 Dec 2022 15:17:21 -0800 (PST)
MIME-Version: 1.0
References: <20221123173859.473629-1-dima@arista.com> <20221123173859.473629-2-dima@arista.com>
 <Y4B17nBArWS1Iywo@hirez.programming.kicks-ass.net> <2081d2ac-b2b5-9299-7239-dc4348ec0d0a@arista.com>
 <20221201143134.6bb285d8@kernel.org>
In-Reply-To: <20221201143134.6bb285d8@kernel.org>
From:   Dmitry Safonov <0x7f454c46@gmail.com>
Date:   Thu, 1 Dec 2022 23:17:11 +0000
Message-ID: <CAJwJo6Z9sTDgOFFrpbrXT6eagtmbB5mhfudG0Osp75J4ipNSqQ@mail.gmail.com>
Subject: Re: [PATCH v6 1/5] jump_label: Prevent key->enabled int overflow
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Dmitry Safonov <dima@arista.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jason Baron <jbaron@akamai.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        Steven Rostedt <rostedt@goodmis.org>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 1 Dec 2022 at 22:31, Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri, 25 Nov 2022 14:28:30 +0000 Dmitry Safonov wrote:
> > > What is the plan for merging this? I'm assuming it would want to go
> > > through the network tree, but as already noted earlier it depends on a
> > > patch I have in tip/locking/core.
> > >
> > > Now I checked, tip/locking/core is *just* that one patch, so it might be
> > > possible to merge that branch and this series into the network tree and
> > > note that during the pull request to Linus.
> >
> > I initially thought it has to go through tip trees because of the
> > dependence, but as you say it's just one patch.
> >
> > I was also asked by Jakub on v4 to wait for Eric's Ack/Review, so once I
> > get a go from him, I will send all 6 patches for inclusion into -net
> > tree, if that will be in time before the merge window.
>
> Looks like we're all set on the networking side (thanks Eric!!)

Thanks!

> Should I pull Peter's branch? Or you want to just resent a patch Peter
> already queued. A bit of an unusual situation..

Either way would work for me.
I can send it in a couple of hours if you prefer instead of pulling the branch.

Thank you,
             Dmitry
