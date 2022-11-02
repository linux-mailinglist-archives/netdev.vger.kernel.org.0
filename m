Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE72B616D60
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 20:06:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231760AbiKBTGV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 15:06:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230153AbiKBTGT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 15:06:19 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A45CB3BB;
        Wed,  2 Nov 2022 12:06:18 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id f27so47862569eje.1;
        Wed, 02 Nov 2022 12:06:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=XXEVk8RjcP4SkdkjqLG5jpNr6DU98zef4V41f5hG5Rk=;
        b=etsfG+XsnmbKzS6zmHQnIS6e6MRlQmFOfua0HwT4tUOCvZZKtwgDnqiGEOa0x3xlhv
         Oc58VZNvTWk4dRTMIx9OXWNgEpcBDHf7B9o6oaxk597TCOlaKWAE95fnWZxbK3T+/kSF
         xblmW2nLl3EnDDQauhYvvJjmbJEu5iqHc9iecf9ncrAC8140JHH9and+BxoQd7Ajhw60
         pBOti0tYGobL5//9aIRojffDlF3NvggHSr7S3bbd+4ABYNs1Ttiljo9OIACFhg792g1L
         lZM10AeFmJAegpwm5Z1tVkb54qev7upJJw+D4H1AKD436U1PrkR9iskKm+EYcGHuSeFe
         9D0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XXEVk8RjcP4SkdkjqLG5jpNr6DU98zef4V41f5hG5Rk=;
        b=TUVPrK+b0Rva/iLXAJHfdO8kfHuRXdoX4hVvvZBnaHz470ifNPf1jWj80JjG1Luz2H
         gKOMQh3G40NViWEJ6XjiDzv8EESD7bA42wePXOuLd6u4j0SrzNMW8bh5ej8POG9b4vAv
         utaoXROxOPSyXq2jRAJpt8Id1iczrutkblhMMh0FpRyNWdyLQWAhoZOIR1G9H9vvdEq7
         lDkcB0U2yyM26V+VuraBIsWd5uf/ajPwihbhEfrGYcZdjy0qIpDPnz+5I5MDuKK3+WKd
         tGkUoU0Luz1h6k88EZnV6JvVcBTKZjOVp7WYhCXKLhue4se9QutwuuYTcMmV1gj1GMNb
         llSQ==
X-Gm-Message-State: ACrzQf0X50cgfEVjCJDw+tp7NuVVspwoPm+3yCznOwSYQi0fbzmXNYkO
        S9kq1JPlFJnXC6yWJ6YIj/QliG/znd1r4OUyUelXleB3
X-Google-Smtp-Source: AMsMyM6jpU2mnUc4AUyn706jlluVnOEUeRttLf/rvpPy1/dDxpiMlc/26NYoU7la4j8plCcHYeV1o+uanCgLWWhcAiA=
X-Received: by 2002:a17:907:9705:b0:7ad:b14f:d89e with SMTP id
 jg5-20020a170907970500b007adb14fd89emr24016482ejc.745.1667415977091; Wed, 02
 Nov 2022 12:06:17 -0700 (PDT)
MIME-Version: 1.0
References: <1666934520-22509-1-git-send-email-wangyufen@huawei.com> <CAEf4BzYpsxmmu48YKvWMuAgNp-H+CaEGChAet6DvWCLTcs61Zg@mail.gmail.com>
In-Reply-To: <CAEf4BzYpsxmmu48YKvWMuAgNp-H+CaEGChAet6DvWCLTcs61Zg@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 2 Nov 2022 12:06:04 -0700
Message-ID: <CAEf4BzZv+4Ykce-fc_G4Xyrm6qMaEQNr1mjs5Ya1fo3ibeis4w@mail.gmail.com>
Subject: Re: [PATCH net v2] bpf: Fix memory leaks in __check_func_call
To:     Wang Yufen <wangyufen@huawei.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, john.fastabend@gmail.com, andrii@kernel.org,
        martin.lau@linux.dev, yhs@fb.com, joe@wand.net.nz
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 2, 2022 at 12:05 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Thu, Oct 27, 2022 at 10:01 PM Wang Yufen <wangyufen@huawei.com> wrote:
> >
> > kmemleak reports this issue:
> >
> > unreferenced object 0xffff88817139d000 (size 2048):
> >   comm "test_progs", pid 33246, jiffies 4307381979 (age 45851.820s)
> >   hex dump (first 32 bytes):
> >     01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> >     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> >   backtrace:
> >     [<0000000045f075f0>] kmalloc_trace+0x27/0xa0
> >     [<0000000098b7c90a>] __check_func_call+0x316/0x1230
> >     [<00000000b4c3c403>] check_helper_call+0x172e/0x4700
> >     [<00000000aa3875b7>] do_check+0x21d8/0x45e0
> >     [<000000001147357b>] do_check_common+0x767/0xaf0
> >     [<00000000b5a595b4>] bpf_check+0x43e3/0x5bc0
> >     [<0000000011e391b1>] bpf_prog_load+0xf26/0x1940
> >     [<0000000007f765c0>] __sys_bpf+0xd2c/0x3650
> >     [<00000000839815d6>] __x64_sys_bpf+0x75/0xc0
> >     [<00000000946ee250>] do_syscall_64+0x3b/0x90
> >     [<0000000000506b7f>] entry_SYSCALL_64_after_hwframe+0x63/0xcd
> >
> > The root case here is: In function prepare_func_exit(), the callee is
> > not released in the abnormal scenario after "state->curframe--;". To
> > fix, move "state->curframe--;" to the very bottom of the function,
> > right when we free callee and reset frame[] pointer to NULL, as Andrii
> > suggested.
> >
> > In addition, function __check_func_call() has a similar problem. In
> > the abnormal scenario before "state->curframe++;", the callee is alse
> > not released.
> >
> > Fixes: 69c087ba6225 ("bpf: Add bpf_for_each_map_elem() helper")
> > Fixes: fd978bf7fd31 ("bpf: Add reference tracking to verifier")
> > Signed-off-by: Wang Yufen <wangyufen@huawei.com>
> > ---
>
> This change seems to be breaking BPF selftests quite badly, please
> check what's going on ([0]):
>
>   [0] https://github.com/kernel-patches/bpf/actions/runs/3379444311/jobs/5611599540
>

And also please target it against bpf tree: [PATCH bpf], not net tree.

> >  kernel/bpf/verifier.c | 11 ++++++++---
> >  1 file changed, 8 insertions(+), 3 deletions(-)
> >
> > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > index 014ee09..d28d460 100644
> > --- a/kernel/bpf/verifier.c
> > +++ b/kernel/bpf/verifier.c
> > @@ -6736,11 +6736,11 @@ static int __check_func_call(struct bpf_verifier_env *env, struct bpf_insn *insn
> >         /* Transfer references to the callee */
> >         err = copy_reference_state(callee, caller);
> >         if (err)
> > -               return err;
> > +               goto err_out;
> >
> >         err = set_callee_state_cb(env, caller, callee, *insn_idx);
> >         if (err)
> > -               return err;
> > +               goto err_out;
> >
> >         clear_caller_saved_regs(env, caller->regs);
> >
> > @@ -6757,6 +6757,11 @@ static int __check_func_call(struct bpf_verifier_env *env, struct bpf_insn *insn
> >                 print_verifier_state(env, callee, true);
> >         }
> >         return 0;
> > +
> > +err_out:
> > +       kfree(callee);
> > +       state->frame[state->curframe + 1] = NULL;
> > +       return err;
> >  }
> >
> >  int map_set_for_each_callback_args(struct bpf_verifier_env *env,
> > @@ -6969,7 +6974,6 @@ static int prepare_func_exit(struct bpf_verifier_env *env, int *insn_idx)
> >                 return -EINVAL;
> >         }
> >
> > -       state->curframe--;
> >         caller = state->frame[state->curframe];
> >         if (callee->in_callback_fn) {
> >                 /* enforce R0 return value range [0, 1]. */
> > @@ -7000,6 +7004,7 @@ static int prepare_func_exit(struct bpf_verifier_env *env, int *insn_idx)
> >                         return err;
> >         }
> >
> > +       state->curframe--;
> >         *insn_idx = callee->callsite + 1;
> >         if (env->log.level & BPF_LOG_LEVEL) {
> >                 verbose(env, "returning from callee:\n");
> > --
> > 1.8.3.1
> >
