Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14E96550625
	for <lists+netdev@lfdr.de>; Sat, 18 Jun 2022 18:43:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236595AbiFRQnP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jun 2022 12:43:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231359AbiFRQnO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jun 2022 12:43:14 -0400
Received: from mailrelay.tu-berlin.de (mailrelay.tu-berlin.de [130.149.7.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18AA06454;
        Sat, 18 Jun 2022 09:43:11 -0700 (PDT)
Received: from SPMA-04.tubit.win.tu-berlin.de (localhost.localdomain [127.0.0.1])
        by localhost (Email Security Appliance) with SMTP id C05EB974F53_2AE009CB;
        Sat, 18 Jun 2022 16:43:08 +0000 (GMT)
Received: from mail.tu-berlin.de (postcard.tu-berlin.de [141.23.12.142])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "exchange.tu-berlin.de", Issuer "DFN-Verein Global Issuing CA" (verified OK))
        by SPMA-04.tubit.win.tu-berlin.de (Sophos Email Appliance) with ESMTPS id 019E69787B2_2AE009CF;
        Sat, 18 Jun 2022 16:43:08 +0000 (GMT)
Received: from [192.168.178.14] (77.191.21.30) by ex-02.svc.tu-berlin.de
 (10.150.18.6) with Microsoft SMTP Server id 15.2.986.22; Sat, 18 Jun 2022
 18:43:07 +0200
Message-ID: <629bc069dd807d7ac646f836e9dca28bbc1108e2.camel@mailbox.tu-berlin.de>
Subject: Re: [PATCH bpf-next v3 3/5] selftests/bpf: Test a BPF CC writing
 sk_pacing_*
From:   =?ISO-8859-1?Q?J=F6rn-Thorben?= Hinz <jthinz@mailbox.tu-berlin.de>
To:     Martin KaFai Lau <kafai@fb.com>
CC:     <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, <netdev@vger.kernel.org>
Date:   Sat, 18 Jun 2022 18:43:06 +0200
In-Reply-To: <20220617210425.xpeyxd4ahnudxnxb@kafai-mbp>
References: <20220614104452.3370148-1-jthinz@mailbox.tu-berlin.de>
         <20220614104452.3370148-4-jthinz@mailbox.tu-berlin.de>
         <20220617210425.xpeyxd4ahnudxnxb@kafai-mbp>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SASI-RCODE: 200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=campus.tu-berlin.de; h=message-id:subject:from:to:cc:date:in-reply-to:references:content-type:mime-version:content-transfer-encoding; s=dkim-tub; bh=6Rtoe1X8vqsaXMzSQejEJx5OSjXs4Fw7+IacNXVLR28=; b=ZjOTED6Nhz23r4NtHMldFmLuTZ2AnCeWrlpsWrLiYxbCd0mTL42IrEmW08i+59jhjyo+z9ls9R13Unn6O6exdS6j9Z/lFNq/mT20KP7KN2O/EaSgWDEZj1timBpRc1De6J3H+BULrg9xBzgszYp+klRnQeDvILrMd+LehSIu5S0=
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2022-06-17 at 14:04 -0700, Martin KaFai Lau wrote:
> On Tue, Jun 14, 2022 at 12:44:50PM +0200, Jörn-Thorben Hinz wrote:
> > Test whether a TCP CC implemented in BPF is allowed to write
> > sk_pacing_rate and sk_pacing_status in struct sock. This is needed
> > when
> > cong_control() is implemented and used.
> > 
> > Signed-off-by: Jörn-Thorben Hinz <jthinz@mailbox.tu-berlin.de>
> > ---
> >  .../selftests/bpf/prog_tests/bpf_tcp_ca.c     | 21 +++++++
> >  .../bpf/progs/tcp_ca_write_sk_pacing.c        | 60
> > +++++++++++++++++++
> >  2 files changed, 81 insertions(+)
> >  create mode 100644
> > tools/testing/selftests/bpf/progs/tcp_ca_write_sk_pacing.c
> > 
> > diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c
> > b/tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c
> > index e9a9a31b2ffe..a797497e2864 100644
> > --- a/tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c
> > +++ b/tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c
> > @@ -9,6 +9,7 @@
> >  #include "bpf_cubic.skel.h"
> >  #include "bpf_tcp_nogpl.skel.h"
> >  #include "bpf_dctcp_release.skel.h"
> > +#include "tcp_ca_write_sk_pacing.skel.h"
> >  
> >  #ifndef ENOTSUPP
> >  #define ENOTSUPP 524
> > @@ -322,6 +323,24 @@ static void test_rel_setsockopt(void)
> >         bpf_dctcp_release__destroy(rel_skel);
> >  }
> >  
> > +static void test_write_sk_pacing(void)
> > +{
> > +       struct tcp_ca_write_sk_pacing *skel;
> > +       struct bpf_link *link;
> > +
> > +       skel = tcp_ca_write_sk_pacing__open_and_load();
> > +       if (!ASSERT_OK_PTR(skel, "open_and_load")) {
> nit. Remove this single line '{'.
> 
> ./scripts/checkpatch.pl has reported that also:
> WARNING: braces {} are not necessary for single statement blocks
> #43: FILE: tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c:332:
> +       if (!ASSERT_OK_PTR(skel, "open_and_load")) {
> +               return;
> +       }
Have to admit I knowingly disregarded that warning as more of a
recommendation. Out of habit and since I personally don’t see any
compelling reason to generally use single-line statements after ifs,
only multiple disadvantages.

But wrong place to argue here, of course. Will bow to the warning.

> 
> 
> > +               return;
> > +       }
> > +
> > +       link = bpf_map__attach_struct_ops(skel-
> > >maps.write_sk_pacing);
> > +       if (ASSERT_OK_PTR(link, "attach_struct_ops")) {
> Same here.
> 
> and no need to check the link before bpf_link__destroy.
> bpf_link__destroy can handle error link.  Something like:
> 
>         ASSERT_OK_PTR(link, "attach_struct_ops");
>         bpf_link__destroy(link);
>         tcp_ca_write_sk_pacing__destroy(skel);
> 
> The earlier examples in test_cubic and test_dctcp were
> written before bpf_link__destroy can handle error link.
You are right, I followed the other two test_*() functions there. Good
to know that it behaves similar to (k)free() and others. Will remove
the ifs around bpf_link__destroy().

> 
> > +               bpf_link__destroy(link);
> > +       }
> > +
> > +       tcp_ca_write_sk_pacing__destroy(skel);
> > +}
> > +
> >  void test_bpf_tcp_ca(void)
> >  {
> >         if (test__start_subtest("dctcp"))
> > @@ -334,4 +353,6 @@ void test_bpf_tcp_ca(void)
> >                 test_dctcp_fallback();
> >         if (test__start_subtest("rel_setsockopt"))
> >                 test_rel_setsockopt();
> > +       if (test__start_subtest("write_sk_pacing"))
> > +               test_write_sk_pacing();
> >  }
> > diff --git
> > a/tools/testing/selftests/bpf/progs/tcp_ca_write_sk_pacing.c
> > b/tools/testing/selftests/bpf/progs/tcp_ca_write_sk_pacing.c
> > new file mode 100644
> > index 000000000000..43447704cf0e
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/progs/tcp_ca_write_sk_pacing.c
> > @@ -0,0 +1,60 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +
> > +#include "vmlinux.h"
> > +
> > +#include <bpf/bpf_helpers.h>
> > +#include <bpf/bpf_tracing.h>
> > +
> > +char _license[] SEC("license") = "GPL";
> > +
> > +#define USEC_PER_SEC 1000000UL
> > +
> > +#define min(a, b) ((a) < (b) ? (a) : (b))
> > +
> > +static inline struct tcp_sock *tcp_sk(const struct sock *sk)
> > +{
> This helper is already available in bpf_tcp_helpers.h.
> Is there a reason not to use that one and redefine
> it in both patch 3 and 4?  The mss_cache and srtt_us can be added
> to bpf_tcp_helpers.h.  It will need another effort to move
> all selftest's bpf-cc to vmlinux.h.
I fully agree it’s not elegant to redefine tcp_sk() twice more.

It was between either using bpf_tcp_helpers.h and adding and
maintaining additional struct members there. Or using the (as I
understood it) more “modern” approach with vmlinux.h and redefining the
trivial tcp_sk(). I chose the later. Didn’t see a reason not to slowly
introduce vmlinux.h into the CA tests.

I had the same dilemma for the algorithm I’m implementing: Reuse
bpf_tcp_helpers.h from the kernel tree and extend it. Or use vmlinux.h
and copy only some of the (mostly trivial) helper functions. Also chose
the later here.

While doing the above, I also considered extracting the type
declarations from bpf_tcp_helpers.h into an, e.g.,
bpf_tcp_types_helper.h, keeping only the functions in
bpf_tcp_helpers.h. bpf_tcp_helpers.h could have been a base helper for
any BPF CA implementation then and used with either vmlinux.h or the
“old-school” includes. Similar to the way bpf_helpers.h is used. But at
that point, a bpf_tcp_types_helper.h could have probably just been
dropped for good and in favor of vmlinux.h. So I didn’t continue with
that.

Do you insist to use bpf_tcp_helpers.h instead of vmlinux.h? Or could
the described split into two headers make sense after all?

(Will wait for your reply here before sending a v4.)

> 
> > +       return (struct tcp_sock *)sk;
> > +}
> > +
> > +SEC("struct_ops/write_sk_pacing_init")
> > +void BPF_PROG(write_sk_pacing_init, struct sock *sk)
> > +{
> > +#ifdef ENABLE_ATOMICS_TESTS
> > +       __sync_bool_compare_and_swap(&sk->sk_pacing_status,
> > SK_PACING_NONE,
> > +                                    SK_PACING_NEEDED);
> > +#else
> > +       sk->sk_pacing_status = SK_PACING_NEEDED;
> > +#endif
> > +}
> > +
> > +SEC("struct_ops/write_sk_pacing_cong_control")
> > +void BPF_PROG(write_sk_pacing_cong_control, struct sock *sk,
> > +             const struct rate_sample *rs)
> > +{
> > +       const struct tcp_sock *tp = tcp_sk(sk);
> > +       unsigned long rate =
> > +               ((tp->snd_cwnd * tp->mss_cache * USEC_PER_SEC) <<
> > 3) /
> > +               (tp->srtt_us ?: 1U << 3);
> > +       sk->sk_pacing_rate = min(rate, sk->sk_max_pacing_rate);
> > +}
> > +
> > +SEC("struct_ops/write_sk_pacing_ssthresh")
> > +__u32 BPF_PROG(write_sk_pacing_ssthresh, struct sock *sk)
> > +{
> > +       return tcp_sk(sk)->snd_ssthresh;
> > +}
> > +
> > +SEC("struct_ops/write_sk_pacing_undo_cwnd")
> > +__u32 BPF_PROG(write_sk_pacing_undo_cwnd, struct sock *sk)
> > +{
> > +       return tcp_sk(sk)->snd_cwnd;
> > +}
> > +
> > +SEC(".struct_ops")
> > +struct tcp_congestion_ops write_sk_pacing = {
> > +       .init = (void *)write_sk_pacing_init,
> > +       .cong_control = (void *)write_sk_pacing_cong_control,
> > +       .ssthresh = (void *)write_sk_pacing_ssthresh,
> > +       .undo_cwnd = (void *)write_sk_pacing_undo_cwnd,
> > +       .name = "bpf_w_sk_pacing",
> > +};
> > -- 
> > 2.30.2
> > 


