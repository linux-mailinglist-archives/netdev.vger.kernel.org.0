Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 580A4505CC2
	for <lists+netdev@lfdr.de>; Mon, 18 Apr 2022 18:50:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346459AbiDRQx3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 12:53:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346452AbiDRQx2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 12:53:28 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEB5F3150D
        for <netdev@vger.kernel.org>; Mon, 18 Apr 2022 09:50:48 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-2ebfdbe01f6so122202687b3.10
        for <netdev@vger.kernel.org>; Mon, 18 Apr 2022 09:50:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Oyh1WpmZyRhAh6LbbmL6kVxO7rVD6ZzMLRjNqyG46HQ=;
        b=H5/ql9180csX6oJqirVWeYuzXUO+VYAqhiOVAKr130ZSZbia9k7REtHroXdJ//eT5f
         2UTCgG7RsO29dh78OkUee9EDBGnTiBnbb7yAK6GiKTYJbcMaPe6Ewb27ap0Ha4HKAp80
         lt99p5UqHzCzGZZAkf5x2Hdb84ul1212ICPYEUtzqyQ0F0haiUZkm+opjIv+EGTNtsXj
         JRPhAc0FrFsLnLCWUQAa8I204yCIbxan6oVeNthlKi0ABuSDkYUpiEtUAfk193OV0xBj
         3nw2h9D9pVr4EU+uDcEUkR5JeP3E6XbRDuYOrboFsDDzziQ3QoEhaJLbYZ6/3MPE4C/5
         Gvhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Oyh1WpmZyRhAh6LbbmL6kVxO7rVD6ZzMLRjNqyG46HQ=;
        b=xexeaKPw4nq0YvWzbpuyMlj38yHt7mZ13v6zHgOsGcphvEfr8Lrvj5fRsgC1G3r1Ca
         8RtLLNWS8rCnmQ5MmJGaSn5Ntj2Urz183H6pr9zo54j4iKRsc7fxNZutFA2s+ABZAqLa
         pfyrOT/F/GdYrdVUkMrjrzWwKqValjpsmrrGn2kqQ6wujlPWI1U0m6tDBTC63zU/K4eN
         lb/gSt83KiqHNLiaC2003786iBWpQbZTfK0XPhmSQ7soXL2dJqu+RYsvqovjw5DVIqKK
         25krhXZWTcozsnqhPNcE6yNFcFl3AwX9t1TeAazViYYts3ttJOSALMIyPgPrEKMkLulX
         XIUA==
X-Gm-Message-State: AOAM5306y1GOk28IE1+P70QPeFu17Ggqkk//B+XGoAKJwsnKkHTBVw38
        rrC6d2e306adITinbrTFPyXItDU=
X-Google-Smtp-Source: ABdhPJwkQcf0RK+vCjPRf2wpPS6un2FvXIgGKczdot3qamiaDzc0uiQcQIs7vcL5gcodd2kIESKvN4w=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:201:e6a5:7fa4:f053:e29d])
 (user=sdf job=sendgmr) by 2002:a25:dc4:0:b0:641:438e:dd2a with SMTP id
 187-20020a250dc4000000b00641438edd2amr10989302ybn.456.1650300648029; Mon, 18
 Apr 2022 09:50:48 -0700 (PDT)
Date:   Mon, 18 Apr 2022 09:50:45 -0700
In-Reply-To: <CAADnVQJ-kiWJopu+VjLDXYb9ifjKyA2h8MO=CaQppNxbHqH=-Q@mail.gmail.com>
Message-Id: <Yl2W5ThWCFPIeLW8@google.com>
Mime-Version: 1.0
References: <20220414161233.170780-1-sdf@google.com> <CAADnVQJ-kiWJopu+VjLDXYb9ifjKyA2h8MO=CaQppNxbHqH=-Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2] bpf: move rcu lock management out of
 BPF_PROG_RUN routines
From:   sdf@google.com
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04/16, Alexei Starovoitov wrote:
> On Thu, Apr 14, 2022 at 9:12 AM Stanislav Fomichev <sdf@google.com> wrote:
> > +static int
> > +bpf_prog_run_array_cg_flags(const struct cgroup_bpf *cgrp,
> > +                           enum cgroup_bpf_attach_type atype,
> > +                           const void *ctx, bpf_prog_run_fn run_prog,
> > +                           int retval, u32 *ret_flags)
> > +{
> > +       const struct bpf_prog_array_item *item;
> > +       const struct bpf_prog *prog;
> > +       const struct bpf_prog_array *array;
> > +       struct bpf_run_ctx *old_run_ctx;
> > +       struct bpf_cg_run_ctx run_ctx;
> > +       u32 func_ret;
> > +
> > +       run_ctx.retval = retval;
> > +       migrate_disable();
> > +       rcu_read_lock();
> > +       array = rcu_dereference(cgrp->effective[atype]);
> > +       item = &array->items[0];
> > +       old_run_ctx = bpf_set_run_ctx(&run_ctx.run_ctx);
> > +       while ((prog = READ_ONCE(item->prog))) {
> > +               run_ctx.prog_item = item;
> > +               func_ret = run_prog(prog, ctx);
> ...
> > +       ret = bpf_prog_run_array_cg(&cgrp->bpf, CGROUP_GETSOCKOPT,
> >                                     &ctx, bpf_prog_run, retval);

> Did you check the asm that bpf_prog_run gets inlined
> after being passed as a pointer to a function?
> Crossing fingers... I suspect not every compiler can do that :(
> De-virtualization optimization used to be tricky.

No, I didn't, but looking at it right now, both gcc and clang
seem to be doing inlining all way up to bpf_dispatcher_nop_func.

clang:

   0000000000001750 <__cgroup_bpf_run_filter_sock_addr>:
   __cgroup_bpf_run_filter_sock_addr():
   ./kernel/bpf/cgroup.c:1226
   int __cgroup_bpf_run_filter_sock_addr(struct sock *sk,
   				      struct sockaddr *uaddr,
   				      enum cgroup_bpf_attach_type atype,
   				      void *t_ctx,
   				      u32 *flags)
   {

   ...

   ./include/linux/filter.h:628
   		ret = dfunc(ctx, prog->insnsi, prog->bpf_func);
       1980:	49 8d 75 48          	lea    0x48(%r13),%rsi
   bpf_dispatcher_nop_func():
   ./include/linux/bpf.h:804
   	return bpf_func(ctx, insnsi);
       1984:	4c 89 f7             	mov    %r14,%rdi
       1987:	41 ff 55 30          	call   *0x30(%r13)
       198b:	89 c3                	mov    %eax,%ebx

gcc (w/retpoline):

   0000000000001110 <__cgroup_bpf_run_filter_sock_addr>:
   __cgroup_bpf_run_filter_sock_addr():
   kernel/bpf/cgroup.c:1226
   {

   ...

   ./include/linux/filter.h:628
   		ret = dfunc(ctx, prog->insnsi, prog->bpf_func);
       11c5:	49 8d 75 48          	lea    0x48(%r13),%rsi
   bpf_dispatcher_nop_func():
   ./include/linux/bpf.h:804
       11c9:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
       11ce:	e8 00 00 00 00       	call   11d3  
<__cgroup_bpf_run_filter_sock_addr+0xc3>
   			11cf: R_X86_64_PLT32	__x86_indirect_thunk_rax-0x4
       11d3:	89 c3                	mov    %eax,%ebx
