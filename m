Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11C3F36D02E
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 03:10:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232190AbhD1BLa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 21:11:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbhD1BL3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Apr 2021 21:11:29 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FD99C061574;
        Tue, 27 Apr 2021 18:10:45 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id x19so66149576lfa.2;
        Tue, 27 Apr 2021 18:10:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zlV+K13XmSuFx5MNz6arYD8sR8Cd3Anv5dk4EMlpg8Y=;
        b=MFyFqiuDz+r6Vhp4gS0FdOMnF8IurcAChSPOdzuCIOqU6ZcuugrYcwzIqhm5jUiS7u
         nif7sJdBjW2AFUlDXQdx9ADExZ2Rc0NK72rs9sWDu6FOX4mfhvS6Nh2TSPdDZvpzvn6R
         MoaMVOd19h5jXaGEZoy1Nu1z3U/BrjQ7eXO84bYXhS7ml1byGGRpm0f1g7V00sfcuB5G
         Lg+UROGsNrHgfF720agFbDUA6zU7l1fZIXKngDbp9oxAPm5Hfi6SrJgNMZ+PgAknj7Kk
         TVqn2C9eUo5yPS/5Fafx008md5B1BjIvoaVuZisEQlJGaKfVsYJThC4iorfrr7qZpX7x
         vNww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zlV+K13XmSuFx5MNz6arYD8sR8Cd3Anv5dk4EMlpg8Y=;
        b=cFPdePsz73ejNs7hz7PXae/qixQC5Z4W1PTpZcjQbHRmoQAaYt+fPGaNMMp/NBQzYw
         jxfU1E4uOgkMZGNg5+qIC1FGvVn7271kwriFPcYtdtyjadiJgmnEt8uSB53Wh6Usnsgc
         lqeli1CdXVWdDofum+7y0sIwm74fFunDqN3xDGl9ID4YV6HJL+dnddEqB5cQ8cdnCTJt
         7hS02lCPCfBp33XNoef48sB21bHW5Nw3joxq6tiEI6Oda7VVuGhrsSA1v2JxFSdgl+V6
         1hyJCaMc+x0ik4hP1Fs0gnTe99T96qFtAVzyUQKvrvQN93dh8u62weQOpvrxteipALRL
         Hn+w==
X-Gm-Message-State: AOAM532CfzThePX2KzzAutroa0N05FXkQxeYiU4CK2fPxNuj/kmlQfN5
        V7ABERNY/I8Eepeq/UMZTHpAK4FFAnqSAwPP6eY=
X-Google-Smtp-Source: ABdhPJwx2615qcO5CX6m0aX7wZ4aCPl4OnALob73oBj6wYRv86whMxfb70w71NtA3/e9b7+y7mMW0li996WE2VeMaX8=
X-Received: by 2002:a05:6512:3984:: with SMTP id j4mr19098079lfu.38.1619572243456;
 Tue, 27 Apr 2021 18:10:43 -0700 (PDT)
MIME-Version: 1.0
References: <20210427224156.708231-1-jolsa@kernel.org>
In-Reply-To: <20210427224156.708231-1-jolsa@kernel.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 27 Apr 2021 18:10:32 -0700
Message-ID: <CAADnVQKuBOc-jqaK1H5Usb6PKFWdbBoo8tzVOU2jzXwa1ENd0g@mail.gmail.com>
Subject: Re: [PATCH] bpf: Fix recursion check in trampoline
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 27, 2021 at 3:42 PM Jiri Olsa <jolsa@kernel.org> wrote:
>
> The recursion check in __bpf_prog_enter and __bpf_prog_exit leaves
> some (not inlined) functions unprotected:
>
> In __bpf_prog_enter:
>   - migrate_disable is called before prog->active is checked
>
> In __bpf_prog_exit:
>   - migrate_enable,rcu_read_unlock_strict are called after
>     prog->active is decreased
>
> When attaching trampoline to them we get panic like:
>
>   traps: PANIC: double fault, error_code: 0x0
>   double fault: 0000 [#1] SMP PTI
>   RIP: 0010:__bpf_prog_enter+0x4/0x50
>   ...
>   Call Trace:
>    <IRQ>
>    bpf_trampoline_6442466513_0+0x18/0x1000
>    migrate_disable+0x5/0x50
>    __bpf_prog_enter+0x9/0x50
>    bpf_trampoline_6442466513_0+0x18/0x1000
>    migrate_disable+0x5/0x50
>    __bpf_prog_enter+0x9/0x50
>    bpf_trampoline_6442466513_0+0x18/0x1000
>    migrate_disable+0x5/0x50
>    __bpf_prog_enter+0x9/0x50
>    bpf_trampoline_6442466513_0+0x18/0x1000
>    migrate_disable+0x5/0x50
>    ...
>
> Making the recursion check before the rest of the calls
> in __bpf_prog_enter and as last call in __bpf_prog_exit.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  kernel/bpf/trampoline.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
>
> diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
> index 4aa8b52adf25..301735f7e88e 100644
> --- a/kernel/bpf/trampoline.c
> +++ b/kernel/bpf/trampoline.c
> @@ -558,12 +558,12 @@ static void notrace inc_misses_counter(struct bpf_prog *prog)
>  u64 notrace __bpf_prog_enter(struct bpf_prog *prog)
>         __acquires(RCU)
>  {
> -       rcu_read_lock();
> -       migrate_disable();
>         if (unlikely(__this_cpu_inc_return(*(prog->active)) != 1)) {
>                 inc_misses_counter(prog);
>                 return 0;
>         }
> +       rcu_read_lock();
> +       migrate_disable();

That obviously doesn't work.
After cpu_inc the task can migrate and cpu_dec
will happen on a different cpu likely underflowing
the counter into negative.
We can either mark migrate_disable as nokprobe/notrace or have bpf
trampoline specific denylist.
