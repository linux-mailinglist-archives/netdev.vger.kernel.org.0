Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF22E5368B0
	for <lists+netdev@lfdr.de>; Sat, 28 May 2022 00:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344410AbiE0WKR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 18:10:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbiE0WKQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 18:10:16 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1FDA6622F;
        Fri, 27 May 2022 15:10:12 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id jx22so11008945ejb.12;
        Fri, 27 May 2022 15:10:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=oukq4BrRroZdnwtsCtnGKzub7xqcAGtJO6v8azC2xEA=;
        b=XBVQbQpBf//NeoTj4WSNgbW9qr+4TUIyl6au6/UKJpoL1clDXJuPyxyFEe5KgJ3bLh
         +sVImQkHxvDbJxMotprxSg66yKl30jBNrmBWhhAdNUk5ssvocQvWnLaG68p/0j3Wm6z9
         5KiRbciA8jCx3Oo/QtTySsMgTRY4CO+kFTGGTQXT9C2xgeMinCa8WhD1Ak+zavmKnQcI
         KpWXOLztoszMB7oTtCRAHdlAfuhB4Rq47PdTlC4QZIVenpj6KOR9m77ZEOeW4lp7pPa5
         9OJSggbvyCAo9a7DWm64hps1494GzuZ5HCBw0KDXrQUTk78in9Og8U05MLM4/HHyii7B
         79Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oukq4BrRroZdnwtsCtnGKzub7xqcAGtJO6v8azC2xEA=;
        b=1BGW3gdh4dwV4LPbN3HsNSKfbgqI1RI+a/VQo8Aksc0ydntgcQ7yXgcGkEvkY5tYR3
         shNCeca7vDYg4TaVBfRx/rGrXA3zczV7U8TfRU0TvE6m0di8wlidoN6BNRDkb5h+L4gM
         fOrmx4ArrZxRfN+F+7yLn9NBTftH4ZYe3LIyo34pILlfRQDQf0Xm0ybUbzfanaed52RG
         131nOxeIe6aKio75F7JGbbu6eSHafzbYQcfNykgy56M8Hq4+w0LY96wz77kmawomM1Lo
         r6JQGrn+JrW5erHsF1Q7pwMsp3rMuNgyyAv8M77LXQa3qlqN43Wnbf7VcdxXkqnspJLM
         Zo6w==
X-Gm-Message-State: AOAM5322JliUDVayBnTnQPXaH3D6aTNlsiSwu7PIYGWFGJIoG01GAwMk
        5mZG+pdYOC36GYMyescEUZA=
X-Google-Smtp-Source: ABdhPJyXtlVDwl/kaymExPY9DtbP6IH3dQddqj8fSOd9q5zj2P3PnryJFUKeMx2AWjlys4A5tDIyxg==
X-Received: by 2002:a17:906:9753:b0:6fe:dece:982a with SMTP id o19-20020a170906975300b006fedece982amr25834832ejy.560.1653689411016;
        Fri, 27 May 2022 15:10:11 -0700 (PDT)
Received: from krava ([83.240.62.49])
        by smtp.gmail.com with ESMTPSA id o25-20020a509b19000000b0042617ba63a7sm2646180edi.49.2022.05.27.15.10.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 May 2022 15:10:10 -0700 (PDT)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Sat, 28 May 2022 00:10:08 +0200
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     Jiri Olsa <olsajiri@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, "Paul E. McKenney" <paulmck@kernel.org>
Subject: Re: [PATCH] rethook: Reject getting a rethook if RCU is not watching
Message-ID: <YpFMQOjvV/tgwsuK@krava>
References: <165189881197.175864.14757002789194211860.stgit@devnote2>
 <20220524192301.0c2ab08a@gandalf.local.home>
 <20220526232530.cb7d0aed0c60625ef093a735@kernel.org>
 <Yo+TWcfpyHy55Il5@krava>
 <20220527011434.9e8c47d1b40f549baf2cf52a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220527011434.9e8c47d1b40f549baf2cf52a@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 27, 2022 at 01:14:34AM +0900, Masami Hiramatsu wrote:
> On Thu, 26 May 2022 16:49:26 +0200
> Jiri Olsa <olsajiri@gmail.com> wrote:
> 
> > On Thu, May 26, 2022 at 11:25:30PM +0900, Masami Hiramatsu wrote:
> > > On Tue, 24 May 2022 19:23:01 -0400
> > > Steven Rostedt <rostedt@goodmis.org> wrote:
> > > 
> > > > On Sat,  7 May 2022 13:46:52 +0900
> > > > Masami Hiramatsu <mhiramat@kernel.org> wrote:
> > > > 
> > > > Is this expected to go through the BPF tree?
> > > > 
> > > 
> > > Yes, since rethook (fprobe) is currently used only from eBPF.
> > > Jiri, can you check this is good for your test case?
> > 
> > sure I'll test it.. can't see the original email,
> > perhaps I wasn't cc-ed.. but I'll find it
> 
> Here it is. I Cc-ed your @kernel.org address.
> https://lore.kernel.org/all/165189881197.175864.14757002789194211860.stgit@devnote2/T/#u
> 
> > 
> > is this also related to tracing 'idle' functions,
> > as discussed in here?
> >   https://lore.kernel.org/bpf/20220515203653.4039075-1-jolsa@kernel.org/
> 
> Ah, yes. So this may not happen with the above patch, but for the
> hardening (ensuring it is always safe), I would like to add this.
> 
> > 
> > because that's the one I can reproduce.. but I can
> > certainly try that with your change as well
> 
> Thank you!

it did not help the idle warning as expected, but I did not
see any problems running bpf tests on top of this

jirka

> 
> > 
> > jirka
> > 
> > > 
> > > Thank you,
> > > 
> > > 
> > > > -- Steve
> > > > 
> > > > 
> > > > > Since the rethook_recycle() will involve the call_rcu() for reclaiming
> > > > > the rethook_instance, the rethook must be set up at the RCU available
> > > > > context (non idle). This rethook_recycle() in the rethook trampoline
> > > > > handler is inevitable, thus the RCU available check must be done before
> > > > > setting the rethook trampoline.
> > > > > 
> > > > > This adds a rcu_is_watching() check in the rethook_try_get() so that
> > > > > it will return NULL if it is called when !rcu_is_watching().
> > > > > 
> > > > > Fixes: 54ecbe6f1ed5 ("rethook: Add a generic return hook")
> > > > > Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
> > > > > ---
> > > > >  kernel/trace/rethook.c |    9 +++++++++
> > > > >  1 file changed, 9 insertions(+)
> > > > > 
> > > > > diff --git a/kernel/trace/rethook.c b/kernel/trace/rethook.c
> > > > > index b56833700d23..c69d82273ce7 100644
> > > > > --- a/kernel/trace/rethook.c
> > > > > +++ b/kernel/trace/rethook.c
> > > > > @@ -154,6 +154,15 @@ struct rethook_node *rethook_try_get(struct rethook *rh)
> > > > >  	if (unlikely(!handler))
> > > > >  		return NULL;
> > > > >  
> > > > > +	/*
> > > > > +	 * This expects the caller will set up a rethook on a function entry.
> > > > > +	 * When the function returns, the rethook will eventually be reclaimed
> > > > > +	 * or released in the rethook_recycle() with call_rcu().
> > > > > +	 * This means the caller must be run in the RCU-availabe context.
> > > > > +	 */
> > > > > +	if (unlikely(!rcu_is_watching()))
> > > > > +		return NULL;
> > > > > +
> > > > >  	fn = freelist_try_get(&rh->pool);
> > > > >  	if (!fn)
> > > > >  		return NULL;
> > > > 
> > > 
> > > 
> > > -- 
> > > Masami Hiramatsu (Google) <mhiramat@kernel.org>
> 
> 
> -- 
> Masami Hiramatsu (Google) <mhiramat@kernel.org>
