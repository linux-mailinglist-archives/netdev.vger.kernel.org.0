Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B51368219D
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 02:53:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230062AbjAaBxb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 20:53:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbjAaBxa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 20:53:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B2E46181;
        Mon, 30 Jan 2023 17:53:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DE71661239;
        Tue, 31 Jan 2023 01:53:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EA86C4339C;
        Tue, 31 Jan 2023 01:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675130008;
        bh=+iqqV7Ebh2zl1FwhMmw27fnwfnWuTQ/JjDKl/D2pDJA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=FEpJactq42Nv8YTAh0TnHOWX6OaImJ8mJxC+yZz7ounEW6KOhHInTGu5FD8+PDEjA
         DdQE51NRlqq99zNcNowsfuSrmn84WNGilGRrp6Iib+pmNJkj8n2HERMn1aCS+/i6DT
         hEHkOfqxvCcOVb2nKMLU2s2eSgqBLCgVNrbykhgeU3fYR1HLYPX6Wp1HkYXUqtplW9
         0kFWvlZHvJ2tzWwnzuwjjwO4Tln+byLieA6tkHzJPedd0Ej5jml+JeR3Ar7l6Za82S
         Qlv56GcFwRO2sSJaumLIhs6RXFJ2xu+3aOm0EQhAhcEocthT/9xneoU6e0ZypONhFD
         lxpXAnifFtdYw==
Received: by mail-lj1-f180.google.com with SMTP id j8so881380ljq.1;
        Mon, 30 Jan 2023 17:53:28 -0800 (PST)
X-Gm-Message-State: AO0yUKVVQBI0f5hSpaH3phlwG9wXmyrCM0+HpqY2lK/wEDE6ji7PWHMo
        79wnmyZ1vJaBI7m2iY8Xd0XOo4TZQ/thbi3dWac=
X-Google-Smtp-Source: AK7set+NRLhpdOUCSZa756Gs9F0vLSw51igAYdk5lRDlENa/2ncLDSH7RUuLzOC4/ef9vS+JvxfvAhN4hzzxWNIgRdU=
X-Received: by 2002:a2e:a446:0:b0:290:70d1:7157 with SMTP id
 v6-20020a2ea446000000b0029070d17157mr98630ljn.172.1675130006347; Mon, 30 Jan
 2023 17:53:26 -0800 (PST)
MIME-Version: 1.0
References: <20230120-vhost-klp-switching-v1-0-7c2b65519c43@kernel.org>
 <Y9KyVKQk3eH+RRse@alley> <Y9LswwnPAf+nOVFG@do-x1extreme> <20230127044355.frggdswx424kd5dq@treble>
 <Y9OpTtqWjAkC2pal@hirez.programming.kicks-ass.net> <20230127165236.rjcp6jm6csdta6z3@treble>
 <20230127170946.zey6xbr4sm4kvh3x@treble> <20230127221131.sdneyrlxxhc4h3fa@treble>
 <Y9e6ssSHUt+MUvum@hirez.programming.kicks-ass.net> <Y9gOMCWGmoc5GQMj@FVFF77S0Q05N>
 <20230130194823.6y3rc227bvsgele4@treble>
In-Reply-To: <20230130194823.6y3rc227bvsgele4@treble>
From:   Song Liu <song@kernel.org>
Date:   Mon, 30 Jan 2023 17:53:14 -0800
X-Gmail-Original-Message-ID: <CAPhsuW437A5SHnWyAmZh_RTTxbxvvp-swy0JBJQnwJ2jxubX2Q@mail.gmail.com>
Message-ID: <CAPhsuW437A5SHnWyAmZh_RTTxbxvvp-swy0JBJQnwJ2jxubX2Q@mail.gmail.com>
Subject: Re: [PATCH 0/2] vhost: improve livepatch switching for heavily loaded
 vhost worker kthreads
To:     Josh Poimboeuf <jpoimboe@kernel.org>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        Jiri Kosina <jikos@kernel.org>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        "Seth Forshee (DigitalOcean)" <sforshee@digitalocean.com>,
        live-patching@vger.kernel.org, Miroslav Benes <mbenes@suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 30, 2023 at 11:48 AM Josh Poimboeuf <jpoimboe@kernel.org> wrote:
>
> On Mon, Jan 30, 2023 at 06:36:32PM +0000, Mark Rutland wrote:
> > On Mon, Jan 30, 2023 at 01:40:18PM +0100, Peter Zijlstra wrote:
> > > On Fri, Jan 27, 2023 at 02:11:31PM -0800, Josh Poimboeuf wrote:
> > > > @@ -8500,8 +8502,10 @@ EXPORT_STATIC_CALL_TRAMP(might_resched);
> > > >  static DEFINE_STATIC_KEY_FALSE(sk_dynamic_cond_resched);
> > > >  int __sched dynamic_cond_resched(void)
> > > >  {
> > > > - if (!static_branch_unlikely(&sk_dynamic_cond_resched))
> > > > + if (!static_branch_unlikely(&sk_dynamic_cond_resched)) {
> > > > +         klp_sched_try_switch();
> > > >           return 0;
> > > > + }
> > > >   return __cond_resched();
> > > >  }
> > > >  EXPORT_SYMBOL(dynamic_cond_resched);
> > >
> > > I would make the klp_sched_try_switch() not depend on
> > > sk_dynamic_cond_resched, because __cond_resched() is not a guaranteed
> > > pass through __schedule().
> > >
> > > But you'll probably want to check with Mark here, this all might
> > > generate crap code on arm64.
> >
> > IIUC here klp_sched_try_switch() is a static call, so on arm64 this'll generate
> > at least a load, a conditional branch, and an indirect branch. That's not
> > ideal, but I'd have to benchmark it to find out whether it's a significant
> > overhead relative to the baseline of PREEMPT_DYNAMIC.
> >
> > For arm64 it'd be a bit nicer to have another static key check, and a call to
> > __klp_sched_try_switch(). That way the static key check gets turned into a NOP
> > in the common case, and the call to __klp_sched_try_switch() can be a direct
> > call (potentially a tail-call if we made it return 0).
>
> Hm, it might be nice if our out-of-line static call implementation would
> automatically do a static key check as part of static_call_cond() for
> NULL-type static calls.
>
> But the best answer is probably to just add inline static calls to
> arm64.  Is the lack of objtool the only thing blocking that?
>
> Objtool is now modular, so all the controversial CFG reverse engineering
> is now optional, so it shouldn't be too hard to just enable objtool for
> static call inlines.

This might be a little off topic, and maybe I missed some threads:
How far are we from officially supporting livepatch on arm64?

IIUC, stable stack unwinding is the missing piece at the moment?

Thanks,
Song
