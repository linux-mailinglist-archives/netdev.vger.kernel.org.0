Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26B9429F5BC
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 21:01:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726404AbgJ2UBD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 16:01:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725914AbgJ2UBB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 16:01:01 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8914C0613CF;
        Thu, 29 Oct 2020 12:51:52 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id h21so4898206iob.10;
        Thu, 29 Oct 2020 12:51:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yGPWeMIi84aR1I4lps3FxOHp7MUBa0SbmybRkXicge8=;
        b=C8LcbvSXxLLX57cIkg2bN4jLT2ORvRz8ODQ4vvupZQXKLiiuILOvW50A22RZ+TKBkv
         RHvLLpvXMJbeFihIhz71sGJkwbao80F9jBtTFYq8/nsBalrLS5Lbat1Nps0G09bXI76m
         ZpQk04bw3+1OPLDEjccBA+G7kTgg/60JyKF99m1gcyxr8M9U5pcEg1AbMN5GamEwb7H9
         /YdffSm4spaB5yMQ/d0jdf5Ct+KeJHIijlFZKL2R9zEaOGPW/8LN7Oj4Spbcv1HnExIt
         6t3lPZDzWuUAyujhdBehNsHBZTxnhKNiWDsCRr3gPECdivHZ3gjjxNGbbowsqj/AX+fA
         PaTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yGPWeMIi84aR1I4lps3FxOHp7MUBa0SbmybRkXicge8=;
        b=HWpitXQmb7iZ5roR3U9OKrzmh5UHrqhec+j54fqKiMaYuGsDkxC7/WJQpOzawVM9I+
         5fgnFF7Saao6QZSaWMeLEef0jzS026jZZYn2IXChPD8Rytnpgh8/WBQuayDwcpA+/vJs
         Bcznv5zM9Fj+EoStF5RUblA0CTBAWO2DqIW0JVIGi0l0gWLPyfvGLNhhbgGf6VpCorcO
         tO6AR8HP8nCt0vjLTELsYlHFx1Yf42PEQmf/3u7KwdmWxO0N6ky1lXiPaZugKVuJycJG
         2YaBPjNtgCaaHxKX83X2ciOYdrLkvSJctmlbfJzpnbdtDCAarg0bWx0L64+bPfeUI9sv
         PnFw==
X-Gm-Message-State: AOAM530F8BClnI4o5wXTCG0TsD3B1EvfLTD7dId0BVonRwlgQfjBSOAe
        WWXqwsnIzD9QHXXiECbqRmBKWx3X6RnnED1sIKQ=
X-Google-Smtp-Source: ABdhPJzBH7FxSXk+z8mo7AmimRNJKTBp1oW9R8ih0X9YoJdtq3/e2F9QbFPqh5QfqUHQPfpvvPU2kOFmthE/rFbIZwI=
X-Received: by 2002:a02:c648:: with SMTP id k8mr4999752jan.96.1604001111938;
 Thu, 29 Oct 2020 12:51:51 -0700 (PDT)
MIME-Version: 1.0
References: <160384954046.698509.132709669068189999.stgit@localhost.localdomain>
 <160384963313.698509.13129692731727238158.stgit@localhost.localdomain>
 <20201029015115.jotej3wgi3p6yn6u@kafai-mbp> <CAKgT0UcpqQaHOdjcOGybF0pWuZS_ZqYOArQ8kLfvheGFE-ur-w@mail.gmail.com>
 <20201029181258.ezff3vfpar7fxbam@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20201029181258.ezff3vfpar7fxbam@kafai-mbp.dhcp.thefacebook.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 29 Oct 2020 12:51:40 -0700
Message-ID: <CAKgT0Ufx14H--p3PO7wunHNJ6vXyhmzB4ZgTw-h0wuVKrRT32A@mail.gmail.com>
Subject: Re: [bpf-next PATCH 2/4] selftests/bpf: Drop python client/server in
 favor of threads
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Kernel Team <kernel-team@fb.com>,
        Netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>, brakmo@fb.com,
        alexanderduyck@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 29, 2020 at 11:13 AM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Thu, Oct 29, 2020 at 09:58:15AM -0700, Alexander Duyck wrote:
> [ ... ]
>

[...]

> >
> > > Also, when looking closer at BPF_SOCK_OPS_STATE_CB in test_tcpbpf_kern.c,
> > > it seems the map value "gp" is slapped together across multiple
> > > TCP_CLOSE events which may be not easy to understand.
> > >
> > > How about it checks different states: TCP_CLOSE, TCP_LAST_ACK,
> > > and BPF_TCP_FIN_WAIT2.  Each of this state will update its own
> > > values under "gp".  Something like this (only compiler tested on
> > > top of patch 4):
> > >
> > > diff --git i/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c w/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
> > > index 7e92c37976ac..65b247b03dfc 100644
> > > --- i/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
> > > +++ w/tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
> > > @@ -90,15 +90,14 @@ static void verify_result(int map_fd, int sock_map_fd)
> > >               result.event_map, expected_events);
> > >
> > >         ASSERT_EQ(result.bytes_received, 501, "bytes_received");
> > > -       ASSERT_EQ(result.bytes_acked, 1002, "bytes_acked");
> > > +       ASSERT_EQ(result.bytes_acked, 1001, "bytes_acked");
> > >         ASSERT_EQ(result.data_segs_in, 1, "data_segs_in");
> > >         ASSERT_EQ(result.data_segs_out, 1, "data_segs_out");
> > >         ASSERT_EQ(result.bad_cb_test_rv, 0x80, "bad_cb_test_rv");
> > >         ASSERT_EQ(result.good_cb_test_rv, 0, "good_cb_test_rv");
> > > -       ASSERT_EQ(result.num_listen, 1, "num_listen");
> > > -
> > > -       /* 3 comes from one listening socket + both ends of the connection */
> > > -       ASSERT_EQ(result.num_close_events, 3, "num_close_events");
> > > +       ASSERT_EQ(result.num_listen_close, 1, "num_listen");
> > > +       ASSERT_EQ(result.num_last_ack, 1, "num_last_ack");
> > > +       ASSERT_EQ(result.num_fin_wait2, 1, "num_fin_wait2");
> > >
> > >         /* check setsockopt for SAVE_SYN */
> > >         key = 0;
> > > diff --git i/tools/testing/selftests/bpf/progs/test_tcpbpf_kern.c w/tools/testing/selftests/bpf/progs/test_tcpbpf_kern.c
> > > index 3e6912e4df3d..2c5ffb50d6e0 100644
> > > --- i/tools/testing/selftests/bpf/progs/test_tcpbpf_kern.c
> > > +++ w/tools/testing/selftests/bpf/progs/test_tcpbpf_kern.c
> > > @@ -55,9 +55,11 @@ int bpf_testcb(struct bpf_sock_ops *skops)
> > >  {
> > >         char header[sizeof(struct ipv6hdr) + sizeof(struct tcphdr)];
> > >         struct bpf_sock_ops *reuse = skops;
> > > +       struct tcpbpf_globals *gp;
> > >         struct tcphdr *thdr;
> > >         int good_call_rv = 0;
> > >         int bad_call_rv = 0;
> > > +       __u32 key_zero = 0;
> > >         int save_syn = 1;
> > >         int rv = -1;
> > >         int v = 0;
> > > @@ -155,26 +157,21 @@ int bpf_testcb(struct bpf_sock_ops *skops)
> > >         case BPF_SOCK_OPS_RETRANS_CB:
> > >                 break;
> > >         case BPF_SOCK_OPS_STATE_CB:
> > > -               if (skops->args[1] == BPF_TCP_CLOSE) {
> > > -                       __u32 key = 0;
> > > -                       struct tcpbpf_globals g, *gp;
> > > -
> > > -                       gp = bpf_map_lookup_elem(&global_map, &key);
> > > -                       if (!gp)
> > > -                               break;
> > > -                       g = *gp;
> > > -                       if (skops->args[0] == BPF_TCP_LISTEN) {
> > > -                               g.num_listen++;
> > > -                       } else {
> > > -                               g.total_retrans = skops->total_retrans;
> > > -                               g.data_segs_in = skops->data_segs_in;
> > > -                               g.data_segs_out = skops->data_segs_out;
> > > -                               g.bytes_received = skops->bytes_received;
> > > -                               g.bytes_acked = skops->bytes_acked;
> > > -                       }
> > > -                       g.num_close_events++;
> > > -                       bpf_map_update_elem(&global_map, &key, &g,
> > > -                                           BPF_ANY);
> > > +               gp = bpf_map_lookup_elem(&global_map, &key_zero);
> > > +               if (!gp)
> > > +                       break;
> > > +               if (skops->args[1] == BPF_TCP_CLOSE &&
> > > +                   skops->args[0] == BPF_TCP_LISTEN) {
> > > +                       gp->num_listen_close++;
> > > +               } else if (skops->args[1] == BPF_TCP_LAST_ACK) {
> > > +                       gp->total_retrans = skops->total_retrans;
> > > +                       gp->data_segs_in = skops->data_segs_in;
> > > +                       gp->data_segs_out = skops->data_segs_out;
> > > +                       gp->bytes_received = skops->bytes_received;
> > > +                       gp->bytes_acked = skops->bytes_acked;
> > > +                       gp->num_last_ack++;
> > > +               } else if (skops->args[1] == BPF_TCP_FIN_WAIT2) {
> > > +                       gp->num_fin_wait2++;
> I meant with the above change in "case BPF_SOCK_OPS_STATE_CB".
> The retry-and-wait in tcpbpf_user.c can be avoided.
>
> What may still be needed in tcpbpf_user.c is to use shutdown and
> read-zero to ensure the sk has gone through those states before
> calling verify_result().  Something like this [ uncompiled code again :) ]:
>
>         /* Always send FIN from accept_fd first to
>          * ensure it will go through FIN_WAIT_2.
>          */
>         shutdown(accept_fd, SHUT_WR);
>         /* Ensure client_fd gets the FIN */
>         err = read(client_fd, buf, sizeof(buf));
>         if (CHECK(err != 0, "read-after-shutdown(client_fd):",
>                   "err:%d errno:%d\n", err, errno))
>                 goto close_accept_fd;
>
>         /* FIN sends from client_fd and it must be in LAST_ACK now */
>         shutdown(client_fd, SHUT_WR);
>         /* Ensure accept_fd gets the FIN-ACK.
>          * accept_fd must have passed the FIN_WAIT2.
>          */
>         err = read(accept_fd, buf, sizeof(buf));
>         if (CHECK(err != 0, "read-after-shutdown(accept_fd):",
>                   "err:%d errno:%d\n", err, errno))
>                 goto close_accept_fd;
>
>         close(server_fd);
>         close(accept_fd);
>         close(client_fd);
>
>         /* All sk has gone through the states being tested.
>          * check the results now.
>          */
>         verify_result(map_fd, sock_map_fd);

Okay. I think I see how that works then. Basically shutdown the write
on one end and read on the other expecting to hold until it forces us
out with a read of length 0 on the other end. Although I might just
use recv since that was the call being used to pull data from the
socket rather than read. I just need to make sure I perform it
starting with the shutdown on the accept end first so that it will
close first to avoid causing the received/acked to be swapped.

Thanks.

- Alex
