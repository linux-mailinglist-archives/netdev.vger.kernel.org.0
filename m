Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F4A4626A3
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 18:52:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403990AbfGHQvw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 12:51:52 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:41956 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730628AbfGHQvv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 12:51:51 -0400
Received: by mail-lj1-f193.google.com with SMTP id d24so7536291ljg.8
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 09:51:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kinvolk.io; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=JiyfBxDrUpJwKDj5qRxHMNcBMneqQ8dyhv4/1WSz/nM=;
        b=IvFIKtChvtNohLTnMgGzxoRkIk+WcVdktFHEk4p20NBTSlwCluMT2Rg8RV1y5cfgKC
         9F77cauh2pamKTgc+4qnvO5FE/9K9JuiJ70HP4vepUvSpemgQtlNIiT5WYkuY+ZGKgj5
         U4KBeOYrlbAFPAHcM1nfSm7ICNujoPJyL32us=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=JiyfBxDrUpJwKDj5qRxHMNcBMneqQ8dyhv4/1WSz/nM=;
        b=T3z328QjvkIeTxdLOOfJt+W/WjBIahfvavYO77rm+C9KsDWIzrbwpJQ+eOwR1yHnGi
         Djeug438DeUJeEKYcppYzd4+xBtiMGyKglfxnZykEZGyZqiumXLnL+ztdBmyxxCk6VYG
         lpV/kERan1qU2rljHFzbKUuDfpEHeZMP++YJ4SjLeCvNyV8K1xs633kt+585hlFnykhF
         mngNAI10wliQIB3Tum0ATt4Hv/1hjl6Yo3c0ay2niMBvVQAecO/pLzeGJ8gRJi/xsakT
         PSgi/QvpJ0GIfdP49ehMAJc43ZLmCk75Ujd9lgeJWpJp0+Y1bTvtp0sDI8/uhTxH2v0W
         tmVw==
X-Gm-Message-State: APjAAAUBfRKuk8IW2E6kuh6gtg+NZfF1racrZVjP0gLyTESZ7f2gSMu0
        AcVqOtD2KIGld1ji2VmVLVgAa8LDX/R2UKcNI6gqEg==
X-Google-Smtp-Source: APXvYqyjUhCe+SlbocNI+sCV28D/05h38efmPoCXwgGs4skkGvEhFtgWw6YEi51RuUhiIliigG6xljsuTmDeiRubFCk=
X-Received: by 2002:a2e:9754:: with SMTP id f20mr10715874ljj.151.1562604708948;
 Mon, 08 Jul 2019 09:51:48 -0700 (PDT)
MIME-Version: 1.0
References: <20190625194215.14927-1-krzesimir@kinvolk.io> <20190625194215.14927-9-krzesimir@kinvolk.io>
 <20190625201220.GC10487@mini-arch> <CAGGp+cE3m1+ZWFBmjTgKFEHYVJ-L1dE=+iVUXvXCxWAxRG9YTA@mail.gmail.com>
 <20190626161231.GA4866@mini-arch>
In-Reply-To: <20190626161231.GA4866@mini-arch>
From:   Krzesimir Nowak <krzesimir@kinvolk.io>
Date:   Mon, 8 Jul 2019 18:51:38 +0200
Message-ID: <CAGGp+cGXaOAYNgz4VPbNwaVf3ZBHJ3XaOn=rN9hMdcAAPDY7bQ@mail.gmail.com>
Subject: Re: [bpf-next v2 08/10] bpf: Implement bpf_prog_test_run for perf
 event programs
To:     Stanislav Fomichev <sdf@fomichev.me>
Cc:     netdev@vger.kernel.org, Alban Crequy <alban@kinvolk.io>,
        =?UTF-8?Q?Iago_L=C3=B3pez_Galeiras?= <iago@kinvolk.io>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 26, 2019 at 6:12 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
>
> On 06/26, Krzesimir Nowak wrote:
> > On Tue, Jun 25, 2019 at 10:12 PM Stanislav Fomichev <sdf@fomichev.me> w=
rote:
> > >
> > > On 06/25, Krzesimir Nowak wrote:
> > > > As an input, test run for perf event program takes struct
> > > > bpf_perf_event_data as ctx_in and struct bpf_perf_event_value as
> > > > data_in. For an output, it basically ignores ctx_out and data_out.
> > > >
> > > > The implementation sets an instance of struct bpf_perf_event_data_k=
ern
> > > > in such a way that the BPF program reading data from context will
> > > > receive what we passed to the bpf prog test run in ctx_in. Also BPF
> > > > program can call bpf_perf_prog_read_value to receive what was passe=
d
> > > > in data_in.
> > > >
> > > > Signed-off-by: Krzesimir Nowak <krzesimir@kinvolk.io>
> > > > ---
> > > >  kernel/trace/bpf_trace.c                      | 107 ++++++++++++++=
++++
> > > >  .../bpf/verifier/perf_event_sample_period.c   |   8 ++
> > > >  2 files changed, 115 insertions(+)
> > > >
> > > > diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> > > > index c102c240bb0b..2fa49ea8a475 100644
> > > > --- a/kernel/trace/bpf_trace.c
> > > > +++ b/kernel/trace/bpf_trace.c
> > > > @@ -16,6 +16,8 @@
> > > >
> > > >  #include <asm/tlb.h>
> > > >
> > > > +#include <trace/events/bpf_test_run.h>
> > > > +
> > > >  #include "trace_probe.h"
> > > >  #include "trace.h"
> > > >
> > > > @@ -1160,7 +1162,112 @@ const struct bpf_verifier_ops perf_event_ve=
rifier_ops =3D {
> > > >       .convert_ctx_access     =3D pe_prog_convert_ctx_access,
> > > >  };
> > > >
> > > > +static int pe_prog_test_run(struct bpf_prog *prog,
> > > > +                         const union bpf_attr *kattr,
> > > > +                         union bpf_attr __user *uattr)
> > > > +{
> > > > +     void __user *ctx_in =3D u64_to_user_ptr(kattr->test.ctx_in);
> > > > +     void __user *data_in =3D u64_to_user_ptr(kattr->test.data_in)=
;
> > > > +     u32 data_size_in =3D kattr->test.data_size_in;
> > > > +     u32 ctx_size_in =3D kattr->test.ctx_size_in;
> > > > +     u32 repeat =3D kattr->test.repeat;
> > > > +     u32 retval =3D 0, duration =3D 0;
> > > > +     int err =3D -EINVAL;
> > > > +     u64 time_start, time_spent =3D 0;
> > > > +     int i;
> > > > +     struct perf_sample_data sample_data =3D {0, };
> > > > +     struct perf_event event =3D {0, };
> > > > +     struct bpf_perf_event_data_kern real_ctx =3D {0, };
> > > > +     struct bpf_perf_event_data fake_ctx =3D {0, };
> > > > +     struct bpf_perf_event_value value =3D {0, };
> > > > +
> > > > +     if (ctx_size_in !=3D sizeof(fake_ctx))
> > > > +             goto out;
> > > > +     if (data_size_in !=3D sizeof(value))
> > > > +             goto out;
> > > > +
> > > > +     if (copy_from_user(&fake_ctx, ctx_in, ctx_size_in)) {
> > > > +             err =3D -EFAULT;
> > > > +             goto out;
> > > > +     }
> > > Move this to net/bpf/test_run.c? I have a bpf_ctx_init helper to deal
> > > with ctx input, might save you some code above wrt ctx size/etc.
> >
> > My impression about net/bpf/test_run.c was that it was a collection of
> > helpers for test runs of the network-related BPF programs, because
> > they are so similar to each other. So kernel/trace/bpf_trace.c looked
> > like an obvious place for the test_run implementation since other perf
> > trace BPF stuff was already there.
> Maybe net/bpf/test_run.c should be renamed to kernel/bpf/test_run.c?

Just sent another version of this patch series. I went with slightly
different approach - moved some functions to kernel/bpf/test_run.c and
left the network specific stuff in net/bpf/test_run.c.

>
> > And about bpf_ctx_init - looks useful as it seems to me that it
> > handles the scenario where the size of the ctx struct grows, but still
> > allows passing older version of the struct (thus smaller) from
> > userspace for compatibility. Maybe that checking and copying part of
> > the function could be moved into some non-static helper function, so I
> > could use it and still skip the need for allocating memory for the
> > context?
> You can always make bpf_ctx_init non-static and export it.
> But, again, consider adding your stuff to the net/bpf/test_run.c
> and exporting only pe_prog_test_run. That way you can reuse
> bpf_ctx_init and bpf_test_run.
>
> Why do you care about memory allocation though? It's a one time
> operation and doesn't affect the performance measurements.
>
> > > > +     if (copy_from_user(&value, data_in, data_size_in)) {
> > > > +             err =3D -EFAULT;
> > > > +             goto out;
> > > > +     }
> > > > +
> > > > +     real_ctx.regs =3D &fake_ctx.regs;
> > > > +     real_ctx.data =3D &sample_data;
> > > > +     real_ctx.event =3D &event;
> > > > +     perf_sample_data_init(&sample_data, fake_ctx.addr,
> > > > +                           fake_ctx.sample_period);
> > > > +     event.cpu =3D smp_processor_id();
> > > > +     event.oncpu =3D -1;
> > > > +     event.state =3D PERF_EVENT_STATE_OFF;
> > > > +     local64_set(&event.count, value.counter);
> > > > +     event.total_time_enabled =3D value.enabled;
> > > > +     event.total_time_running =3D value.running;
> > > > +     /* make self as a leader - it is used only for checking the
> > > > +      * state field
> > > > +      */
> > > > +     event.group_leader =3D &event;
> > > > +
> > > > +     /* slightly changed copy pasta from bpf_test_run() in
> > > > +      * net/bpf/test_run.c
> > > > +      */
> > > > +     if (!repeat)
> > > > +             repeat =3D 1;
> > > > +
> > > > +     rcu_read_lock();
> > > > +     preempt_disable();
> > > > +     time_start =3D ktime_get_ns();
> > > > +     for (i =3D 0; i < repeat; i++) {
> > > Any reason for not using bpf_test_run?
> >
> > Two, mostly. One was that it is a static function and my code was
> > elsewhere. Second was that it does some cgroup storage setup and I'm
> > not sure if the perf event BPF program needs that.
> You can always make it non-static.
>
> Regarding cgroup storage: do we care? If you can see it affecting
> your performance numbers, then yes, but you can try to measure to see
> if it gives you any noticeable overhead. Maybe add an argument to
> bpf_test_run to skip cgroup storage stuff?
>
> > > > +             retval =3D BPF_PROG_RUN(prog, &real_ctx);
> > > > +
> > > > +             if (signal_pending(current)) {
> > > > +                     err =3D -EINTR;
> > > > +                     preempt_enable();
> > > > +                     rcu_read_unlock();
> > > > +                     goto out;
> > > > +             }
> > > > +
> > > > +             if (need_resched()) {
> > > > +                     time_spent +=3D ktime_get_ns() - time_start;
> > > > +                     preempt_enable();
> > > > +                     rcu_read_unlock();
> > > > +
> > > > +                     cond_resched();
> > > > +
> > > > +                     rcu_read_lock();
> > > > +                     preempt_disable();
> > > > +                     time_start =3D ktime_get_ns();
> > > > +             }
> > > > +     }
> > > > +     time_spent +=3D ktime_get_ns() - time_start;
> > > > +     preempt_enable();
> > > > +     rcu_read_unlock();
> > > > +
> > > > +     do_div(time_spent, repeat);
> > > > +     duration =3D time_spent > U32_MAX ? U32_MAX : (u32)time_spent=
;
> > > > +     /* end of slightly changed copy pasta from bpf_test_run() in
> > > > +      * net/bpf/test_run.c
> > > > +      */
> > > > +
> > > > +     if (copy_to_user(&uattr->test.retval, &retval, sizeof(retval)=
)) {
> > > > +             err =3D -EFAULT;
> > > > +             goto out;
> > > > +     }
> > > > +     if (copy_to_user(&uattr->test.duration, &duration, sizeof(dur=
ation))) {
> > > > +             err =3D -EFAULT;
> > > > +             goto out;
> > > > +     }
> > > Can BPF program modify fake_ctx? Do we need/want to copy it back?
> >
> > Reading the pe_prog_is_valid_access function tells me that it's not
> > possible - the only type of valid access is read. So maybe I should be
> > stricter about the requirements for the data_out and ctx_out sizes
> > (should be zero or return -EINVAL).
> Yes, better to explicitly prohibit anything that we don't support.
>
> > > > +     err =3D 0;
> > > > +out:
> > > > +     trace_bpf_test_finish(&err);
> > > > +     return err;
> > > > +}
> > > > +
> > > >  const struct bpf_prog_ops perf_event_prog_ops =3D {
> > > > +     .test_run       =3D pe_prog_test_run,
> > > >  };
> > > >
> > > >  static DEFINE_MUTEX(bpf_event_mutex);
> > > > diff --git a/tools/testing/selftests/bpf/verifier/perf_event_sample=
_period.c b/tools/testing/selftests/bpf/verifier/perf_event_sample_period.c
> > > > index 471c1a5950d8..16e9e5824d14 100644
> > > > --- a/tools/testing/selftests/bpf/verifier/perf_event_sample_period=
.c
> > > > +++ b/tools/testing/selftests/bpf/verifier/perf_event_sample_period=
.c
> > > This should probably go in another patch.
> >
> > Yeah, I was wondering about it. These changes are here to avoid
> > breaking the tests, since perf event program can actually be run now
> > and the test_run for perf event required certain sizes for ctx and
> > data.
> You need to make sure the context is optional, that way you don't break
> any existing tests out in the wild and can move those changes to
> another patch.
>
> > So, I will either move them to a separate patch or rework the test_run
> > for perf event to accept the size between 0 and sizeof(struct
> > something), so the changes in tests maybe will not be necessary.
> >
> > >
> > > > @@ -13,6 +13,8 @@
> > > >       },
> > > >       .result =3D ACCEPT,
> > > >       .prog_type =3D BPF_PROG_TYPE_PERF_EVENT,
> > > > +     .ctx_len =3D sizeof(struct bpf_perf_event_data),
> > > > +     .data_len =3D sizeof(struct bpf_perf_event_value),
> > > >  },
> > > >  {
> > > >       "check bpf_perf_event_data->sample_period half load permitted=
",
> > > > @@ -29,6 +31,8 @@
> > > >       },
> > > >       .result =3D ACCEPT,
> > > >       .prog_type =3D BPF_PROG_TYPE_PERF_EVENT,
> > > > +     .ctx_len =3D sizeof(struct bpf_perf_event_data),
> > > > +     .data_len =3D sizeof(struct bpf_perf_event_value),
> > > >  },
> > > >  {
> > > >       "check bpf_perf_event_data->sample_period word load permitted=
",
> > > > @@ -45,6 +49,8 @@
> > > >       },
> > > >       .result =3D ACCEPT,
> > > >       .prog_type =3D BPF_PROG_TYPE_PERF_EVENT,
> > > > +     .ctx_len =3D sizeof(struct bpf_perf_event_data),
> > > > +     .data_len =3D sizeof(struct bpf_perf_event_value),
> > > >  },
> > > >  {
> > > >       "check bpf_perf_event_data->sample_period dword load permitte=
d",
> > > > @@ -56,4 +62,6 @@
> > > >       },
> > > >       .result =3D ACCEPT,
> > > >       .prog_type =3D BPF_PROG_TYPE_PERF_EVENT,
> > > > +     .ctx_len =3D sizeof(struct bpf_perf_event_data),
> > > > +     .data_len =3D sizeof(struct bpf_perf_event_value),
> > > >  },
> > > > --
> > > > 2.20.1
> > > >
> >
> >
> >
> > --
> > Kinvolk GmbH | Adalbertstr.6a, 10999 Berlin | tel: +491755589364
> > Gesch=C3=A4ftsf=C3=BChrer/Directors: Alban Crequy, Chris K=C3=BChl, Iag=
o L=C3=B3pez Galeiras
> > Registergericht/Court of registration: Amtsgericht Charlottenburg
> > Registernummer/Registration number: HRB 171414 B
> > Ust-ID-Nummer/VAT ID number: DE302207000



--=20
Kinvolk GmbH | Adalbertstr.6a, 10999 Berlin | tel: +491755589364
Gesch=C3=A4ftsf=C3=BChrer/Directors: Alban Crequy, Chris K=C3=BChl, Iago L=
=C3=B3pez Galeiras
Registergericht/Court of registration: Amtsgericht Charlottenburg
Registernummer/Registration number: HRB 171414 B
Ust-ID-Nummer/VAT ID number: DE302207000
