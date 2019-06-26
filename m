Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F96656560
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 11:10:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726673AbfFZJKe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 05:10:34 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:35259 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726329AbfFZJKe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 05:10:34 -0400
Received: by mail-lf1-f68.google.com with SMTP id a25so1059588lfg.2
        for <netdev@vger.kernel.org>; Wed, 26 Jun 2019 02:10:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kinvolk.io; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=YoeqkPyuuUAa89a437Y8XeIR94IijuVYW37iJHKjXro=;
        b=QCubpUKtrVll90cGRqb8Cq97Ey09kXjAZfiiKTih+3YGW80RSglFZRnsPIjISll9ZD
         qF2C2a7hL5SsTky9phPAVleo1aFYfPBRMpZjhlyXV4cytIZSXYVB2b5k8w4tppDHsymp
         9B02eWOVWuM8UbYMO7eHrhMCLl3+KLJbZJRak=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=YoeqkPyuuUAa89a437Y8XeIR94IijuVYW37iJHKjXro=;
        b=VTo9YqtsTqTSBKqe4mhf0vqEUICBI88yL84mnZ/hiKtFO/LfPGWnq7K3GiswLH274B
         y8OVj5enXbwr83bLbMYAebz+5/wUFeVXYKIQ36vVgNuCvtRhz3JkWlFRsrWNWspHQDQ4
         eSKI+4Uk+9VFmWgSzC9OJOP3KhKNieIwSoX6u64mzA+SnTiLt5CjCYFZcyQ8qOCEFs+z
         hghpM+19uyDmkZX4dGplb5vq/n39kVKtDm+yPksEVk3DX1mXLkWTb0lwUZF+/qiQU70E
         Iklk1NpQXPgZ/gcssw9UmqoVJat0vqvZgJ1iO2t8sOQrvdI0zpKmIOdBU1ZhiU3R+Pio
         Ck0A==
X-Gm-Message-State: APjAAAVnJmqCHwuOn388FXuuTLyKPyOtsYNgxqjI41/cj/Bm/C6exz9H
        JfoAyYIOFH5/Y56xc/JdPHjuimywAyfEgVmPtBVAjw==
X-Google-Smtp-Source: APXvYqymZ7lUVgJdBpBi6jtOw+JA7FkCqSjQ7i/H6+FJ0lYr8Np2FRYIbmUefQFTW6IHKYweDRBGVB5Ju2417aCZP40=
X-Received: by 2002:ac2:418f:: with SMTP id z15mr1951625lfh.177.1561540231825;
 Wed, 26 Jun 2019 02:10:31 -0700 (PDT)
MIME-Version: 1.0
References: <20190625194215.14927-1-krzesimir@kinvolk.io> <20190625194215.14927-9-krzesimir@kinvolk.io>
 <20190625201220.GC10487@mini-arch>
In-Reply-To: <20190625201220.GC10487@mini-arch>
From:   Krzesimir Nowak <krzesimir@kinvolk.io>
Date:   Wed, 26 Jun 2019 11:10:20 +0200
Message-ID: <CAGGp+cE3m1+ZWFBmjTgKFEHYVJ-L1dE=+iVUXvXCxWAxRG9YTA@mail.gmail.com>
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

On Tue, Jun 25, 2019 at 10:12 PM Stanislav Fomichev <sdf@fomichev.me> wrote=
:
>
> On 06/25, Krzesimir Nowak wrote:
> > As an input, test run for perf event program takes struct
> > bpf_perf_event_data as ctx_in and struct bpf_perf_event_value as
> > data_in. For an output, it basically ignores ctx_out and data_out.
> >
> > The implementation sets an instance of struct bpf_perf_event_data_kern
> > in such a way that the BPF program reading data from context will
> > receive what we passed to the bpf prog test run in ctx_in. Also BPF
> > program can call bpf_perf_prog_read_value to receive what was passed
> > in data_in.
> >
> > Signed-off-by: Krzesimir Nowak <krzesimir@kinvolk.io>
> > ---
> >  kernel/trace/bpf_trace.c                      | 107 ++++++++++++++++++
> >  .../bpf/verifier/perf_event_sample_period.c   |   8 ++
> >  2 files changed, 115 insertions(+)
> >
> > diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> > index c102c240bb0b..2fa49ea8a475 100644
> > --- a/kernel/trace/bpf_trace.c
> > +++ b/kernel/trace/bpf_trace.c
> > @@ -16,6 +16,8 @@
> >
> >  #include <asm/tlb.h>
> >
> > +#include <trace/events/bpf_test_run.h>
> > +
> >  #include "trace_probe.h"
> >  #include "trace.h"
> >
> > @@ -1160,7 +1162,112 @@ const struct bpf_verifier_ops perf_event_verifi=
er_ops =3D {
> >       .convert_ctx_access     =3D pe_prog_convert_ctx_access,
> >  };
> >
> > +static int pe_prog_test_run(struct bpf_prog *prog,
> > +                         const union bpf_attr *kattr,
> > +                         union bpf_attr __user *uattr)
> > +{
> > +     void __user *ctx_in =3D u64_to_user_ptr(kattr->test.ctx_in);
> > +     void __user *data_in =3D u64_to_user_ptr(kattr->test.data_in);
> > +     u32 data_size_in =3D kattr->test.data_size_in;
> > +     u32 ctx_size_in =3D kattr->test.ctx_size_in;
> > +     u32 repeat =3D kattr->test.repeat;
> > +     u32 retval =3D 0, duration =3D 0;
> > +     int err =3D -EINVAL;
> > +     u64 time_start, time_spent =3D 0;
> > +     int i;
> > +     struct perf_sample_data sample_data =3D {0, };
> > +     struct perf_event event =3D {0, };
> > +     struct bpf_perf_event_data_kern real_ctx =3D {0, };
> > +     struct bpf_perf_event_data fake_ctx =3D {0, };
> > +     struct bpf_perf_event_value value =3D {0, };
> > +
> > +     if (ctx_size_in !=3D sizeof(fake_ctx))
> > +             goto out;
> > +     if (data_size_in !=3D sizeof(value))
> > +             goto out;
> > +
> > +     if (copy_from_user(&fake_ctx, ctx_in, ctx_size_in)) {
> > +             err =3D -EFAULT;
> > +             goto out;
> > +     }
> Move this to net/bpf/test_run.c? I have a bpf_ctx_init helper to deal
> with ctx input, might save you some code above wrt ctx size/etc.

My impression about net/bpf/test_run.c was that it was a collection of
helpers for test runs of the network-related BPF programs, because
they are so similar to each other. So kernel/trace/bpf_trace.c looked
like an obvious place for the test_run implementation since other perf
trace BPF stuff was already there.

And about bpf_ctx_init - looks useful as it seems to me that it
handles the scenario where the size of the ctx struct grows, but still
allows passing older version of the struct (thus smaller) from
userspace for compatibility. Maybe that checking and copying part of
the function could be moved into some non-static helper function, so I
could use it and still skip the need for allocating memory for the
context?

>
> > +     if (copy_from_user(&value, data_in, data_size_in)) {
> > +             err =3D -EFAULT;
> > +             goto out;
> > +     }
> > +
> > +     real_ctx.regs =3D &fake_ctx.regs;
> > +     real_ctx.data =3D &sample_data;
> > +     real_ctx.event =3D &event;
> > +     perf_sample_data_init(&sample_data, fake_ctx.addr,
> > +                           fake_ctx.sample_period);
> > +     event.cpu =3D smp_processor_id();
> > +     event.oncpu =3D -1;
> > +     event.state =3D PERF_EVENT_STATE_OFF;
> > +     local64_set(&event.count, value.counter);
> > +     event.total_time_enabled =3D value.enabled;
> > +     event.total_time_running =3D value.running;
> > +     /* make self as a leader - it is used only for checking the
> > +      * state field
> > +      */
> > +     event.group_leader =3D &event;
> > +
> > +     /* slightly changed copy pasta from bpf_test_run() in
> > +      * net/bpf/test_run.c
> > +      */
> > +     if (!repeat)
> > +             repeat =3D 1;
> > +
> > +     rcu_read_lock();
> > +     preempt_disable();
> > +     time_start =3D ktime_get_ns();
> > +     for (i =3D 0; i < repeat; i++) {
> Any reason for not using bpf_test_run?

Two, mostly. One was that it is a static function and my code was
elsewhere. Second was that it does some cgroup storage setup and I'm
not sure if the perf event BPF program needs that.

>
> > +             retval =3D BPF_PROG_RUN(prog, &real_ctx);
> > +
> > +             if (signal_pending(current)) {
> > +                     err =3D -EINTR;
> > +                     preempt_enable();
> > +                     rcu_read_unlock();
> > +                     goto out;
> > +             }
> > +
> > +             if (need_resched()) {
> > +                     time_spent +=3D ktime_get_ns() - time_start;
> > +                     preempt_enable();
> > +                     rcu_read_unlock();
> > +
> > +                     cond_resched();
> > +
> > +                     rcu_read_lock();
> > +                     preempt_disable();
> > +                     time_start =3D ktime_get_ns();
> > +             }
> > +     }
> > +     time_spent +=3D ktime_get_ns() - time_start;
> > +     preempt_enable();
> > +     rcu_read_unlock();
> > +
> > +     do_div(time_spent, repeat);
> > +     duration =3D time_spent > U32_MAX ? U32_MAX : (u32)time_spent;
> > +     /* end of slightly changed copy pasta from bpf_test_run() in
> > +      * net/bpf/test_run.c
> > +      */
> > +
> > +     if (copy_to_user(&uattr->test.retval, &retval, sizeof(retval))) {
> > +             err =3D -EFAULT;
> > +             goto out;
> > +     }
> > +     if (copy_to_user(&uattr->test.duration, &duration, sizeof(duratio=
n))) {
> > +             err =3D -EFAULT;
> > +             goto out;
> > +     }
> Can BPF program modify fake_ctx? Do we need/want to copy it back?

Reading the pe_prog_is_valid_access function tells me that it's not
possible - the only type of valid access is read. So maybe I should be
stricter about the requirements for the data_out and ctx_out sizes
(should be zero or return -EINVAL).

>
> > +     err =3D 0;
> > +out:
> > +     trace_bpf_test_finish(&err);
> > +     return err;
> > +}
> > +
> >  const struct bpf_prog_ops perf_event_prog_ops =3D {
> > +     .test_run       =3D pe_prog_test_run,
> >  };
> >
> >  static DEFINE_MUTEX(bpf_event_mutex);
> > diff --git a/tools/testing/selftests/bpf/verifier/perf_event_sample_per=
iod.c b/tools/testing/selftests/bpf/verifier/perf_event_sample_period.c
> > index 471c1a5950d8..16e9e5824d14 100644
> > --- a/tools/testing/selftests/bpf/verifier/perf_event_sample_period.c
> > +++ b/tools/testing/selftests/bpf/verifier/perf_event_sample_period.c
> This should probably go in another patch.

Yeah, I was wondering about it. These changes are here to avoid
breaking the tests, since perf event program can actually be run now
and the test_run for perf event required certain sizes for ctx and
data.

So, I will either move them to a separate patch or rework the test_run
for perf event to accept the size between 0 and sizeof(struct
something), so the changes in tests maybe will not be necessary.

>
> > @@ -13,6 +13,8 @@
> >       },
> >       .result =3D ACCEPT,
> >       .prog_type =3D BPF_PROG_TYPE_PERF_EVENT,
> > +     .ctx_len =3D sizeof(struct bpf_perf_event_data),
> > +     .data_len =3D sizeof(struct bpf_perf_event_value),
> >  },
> >  {
> >       "check bpf_perf_event_data->sample_period half load permitted",
> > @@ -29,6 +31,8 @@
> >       },
> >       .result =3D ACCEPT,
> >       .prog_type =3D BPF_PROG_TYPE_PERF_EVENT,
> > +     .ctx_len =3D sizeof(struct bpf_perf_event_data),
> > +     .data_len =3D sizeof(struct bpf_perf_event_value),
> >  },
> >  {
> >       "check bpf_perf_event_data->sample_period word load permitted",
> > @@ -45,6 +49,8 @@
> >       },
> >       .result =3D ACCEPT,
> >       .prog_type =3D BPF_PROG_TYPE_PERF_EVENT,
> > +     .ctx_len =3D sizeof(struct bpf_perf_event_data),
> > +     .data_len =3D sizeof(struct bpf_perf_event_value),
> >  },
> >  {
> >       "check bpf_perf_event_data->sample_period dword load permitted",
> > @@ -56,4 +62,6 @@
> >       },
> >       .result =3D ACCEPT,
> >       .prog_type =3D BPF_PROG_TYPE_PERF_EVENT,
> > +     .ctx_len =3D sizeof(struct bpf_perf_event_data),
> > +     .data_len =3D sizeof(struct bpf_perf_event_value),
> >  },
> > --
> > 2.20.1
> >



--=20
Kinvolk GmbH | Adalbertstr.6a, 10999 Berlin | tel: +491755589364
Gesch=C3=A4ftsf=C3=BChrer/Directors: Alban Crequy, Chris K=C3=BChl, Iago L=
=C3=B3pez Galeiras
Registergericht/Court of registration: Amtsgericht Charlottenburg
Registernummer/Registration number: HRB 171414 B
Ust-ID-Nummer/VAT ID number: DE302207000
