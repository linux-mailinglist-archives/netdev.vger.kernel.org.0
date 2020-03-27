Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B269B194F2A
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 03:40:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727725AbgC0Cke (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 22:40:34 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42200 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726363AbgC0Ckd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 22:40:33 -0400
Received: by mail-wr1-f68.google.com with SMTP id h15so9662645wrx.9;
        Thu, 26 Mar 2020 19:40:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=e/YIBPhlq8KB4uSiWS+cksE43nsvx9VHHO45IthDJYc=;
        b=uX2iB7cw8cXkIBNaTKixBygFh6nRFHK2lc2Z7cdxSxnkNjZpXeLMq3lFIudKtMn3La
         KKDv4riwNwFTjah3K96U7/bvWQCYNcJc/7fZi1Re7DvHtVOJALCS6iNx/NKBCWQF2NBY
         gmZiA61hTAJHubRNFtf0QvRLPHMI6H34XVQMiZunIyHOFQj+zQmljgLquA2TKnhxkRi+
         uY4mO0BMyXJd+K6nEtdCmMU/ASXh5g8pGmRCdaw2mQWstztaqyfKElame0upDNtJnSyL
         zJQ80vnNss8+WPbeHgyZRK8aI2oJAvPFeia6Ag/dP/Ophc3VYODyn/iFLQYoGO3UqwIK
         ZswQ==
X-Gm-Message-State: ANhLgQ2jfs/6aYvXwTVYK27yhEa9r2kI1RQiVkKL95PoVWd3I08Wt8nN
        hHzLdrejCVQVPxDe3KfxkDdEE9xu54cMNt9fXZ4=
X-Google-Smtp-Source: ADFU+vuLnojRoXcgExqYrA5zWSIy4xG4JuuZjtVdMXPAMTpKXhLukHJXNyodu6WQ22G1omG7V3KS0rlpBkeWOWnWuw8=
X-Received: by 2002:adf:fece:: with SMTP id q14mr1072303wrs.300.1585276830342;
 Thu, 26 Mar 2020 19:40:30 -0700 (PDT)
MIME-Version: 1.0
References: <20200325055745.10710-1-joe@wand.net.nz> <20200325055745.10710-2-joe@wand.net.nz>
 <CACAyw989SkYaE6Qt_Lm+wjTCvpFH470ObGCkb4+hmEoijG3T8Q@mail.gmail.com> <CAOftzPi04QYiN6hjdzt+S128hc_1ZOYPCvPG7zc5DK=uqPOQCw@mail.gmail.com>
In-Reply-To: <CAOftzPi04QYiN6hjdzt+S128hc_1ZOYPCvPG7zc5DK=uqPOQCw@mail.gmail.com>
From:   Joe Stringer <joe@wand.net.nz>
Date:   Thu, 26 Mar 2020 19:40:03 -0700
Message-ID: <CAOftzPhBKuxYMM6iEmgWfJ8ikubLh4ORDei9Zpa3=amDRjT_NQ@mail.gmail.com>
Subject: Re: [PATCHv2 bpf-next 1/5] bpf: Add socket assign support
To:     Joe Stringer <joe@wand.net.nz>
Cc:     Lorenz Bauer <lmb@cloudflare.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Martin Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 26, 2020 at 3:52 PM Joe Stringer <joe@wand.net.nz> wrote:
>
> On Thu, Mar 26, 2020 at 3:25 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
> >
> > On Wed, 25 Mar 2020 at 05:57, Joe Stringer <joe@wand.net.nz> wrote:
> > >
> > > Add support for TPROXY via a new bpf helper, bpf_sk_assign().
> > >
> > > This helper requires the BPF program to discover the socket via a call
> > > to bpf_sk*_lookup_*(), then pass this socket to the new helper. The
> > > helper takes its own reference to the socket in addition to any existing
> > > reference that may or may not currently be obtained for the duration of
> > > BPF processing. For the destination socket to receive the traffic, the
> > > traffic must be routed towards that socket via local route. The
> > > simplest example route is below, but in practice you may want to route
> > > traffic more narrowly (eg by CIDR):
> > >
> > >   $ ip route add local default dev lo
> > >
> > > This patch avoids trying to introduce an extra bit into the skb->sk, as
> > > that would require more invasive changes to all code interacting with
> > > the socket to ensure that the bit is handled correctly, such as all
> > > error-handling cases along the path from the helper in BPF through to
> > > the orphan path in the input. Instead, we opt to use the destructor
> > > variable to switch on the prefetch of the socket.
> > >
> > > Signed-off-by: Joe Stringer <joe@wand.net.nz>
> > > ---
> > > v2: Use skb->destructor to determine socket prefetch usage instead of
> > >       introducing a new metadata_dst
> > >     Restrict socket assign to same netns as TC device
> > >     Restrict assigning reuseport sockets
> > >     Adjust commit wording
> > > v1: Initial version
> > > ---
> > >  include/net/sock.h             |  7 +++++++
> > >  include/uapi/linux/bpf.h       | 25 ++++++++++++++++++++++++-
> > >  net/core/filter.c              | 31 +++++++++++++++++++++++++++++++
> > >  net/core/sock.c                |  9 +++++++++
> > >  net/ipv4/ip_input.c            |  3 ++-
> > >  net/ipv6/ip6_input.c           |  3 ++-
> > >  net/sched/act_bpf.c            |  2 ++
> > >  tools/include/uapi/linux/bpf.h | 25 ++++++++++++++++++++++++-
> > >  8 files changed, 101 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/include/net/sock.h b/include/net/sock.h
> > > index b5cca7bae69b..2613d21a667a 100644
> > > --- a/include/net/sock.h
> > > +++ b/include/net/sock.h
> > > @@ -1657,6 +1657,7 @@ struct sk_buff *sock_omalloc(struct sock *sk, unsigned long size,
> > >  void skb_orphan_partial(struct sk_buff *skb);
> > >  void sock_rfree(struct sk_buff *skb);
> > >  void sock_efree(struct sk_buff *skb);
> > > +void sock_pfree(struct sk_buff *skb);
> > >  #ifdef CONFIG_INET
> > >  void sock_edemux(struct sk_buff *skb);
> > >  #else
> > > @@ -2526,6 +2527,12 @@ void sock_net_set(struct sock *sk, struct net *net)
> > >         write_pnet(&sk->sk_net, net);
> > >  }
> > >
> > > +static inline bool
> > > +skb_sk_is_prefetched(struct sk_buff *skb)
> > > +{
> > > +       return skb->destructor == sock_pfree;
> > > +}
> > > +
> > >  static inline struct sock *skb_steal_sock(struct sk_buff *skb)
> > >  {
> > >         if (skb->sk) {
> > > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > > index 5d01c5c7e598..0c6f151deebe 100644
> > > --- a/include/uapi/linux/bpf.h
> > > +++ b/include/uapi/linux/bpf.h
> > > @@ -2950,6 +2950,28 @@ union bpf_attr {
> > >   *             restricted to raw_tracepoint bpf programs.
> > >   *     Return
> > >   *             0 on success, or a negative error in case of failure.
> > > + *
> > > + * int bpf_sk_assign(struct sk_buff *skb, struct bpf_sock *sk, u64 flags)
> > > + *     Description
> > > + *             Assign the *sk* to the *skb*. When combined with appropriate
> > > + *             routing configuration to receive the packet towards the socket,
> > > + *             will cause *skb* to be delivered to the specified socket.
> > > + *             Subsequent redirection of *skb* via  **bpf_redirect**\ (),
> > > + *             **bpf_clone_redirect**\ () or other methods outside of BPF may
> > > + *             interfere with successful delivery to the socket.
> > > + *
> > > + *             This operation is only valid from TC ingress path.
> > > + *
> > > + *             The *flags* argument must be zero.
> > > + *     Return
> > > + *             0 on success, or a negative errno in case of failure.
> > > + *
> > > + *             * **-EINVAL**           Unsupported flags specified.
> > > + *             * **-ENETUNREACH**      Socket is unreachable (wrong netns).
> > > + *             * **-ENOENT**           Socket is unavailable for assignment.
> > > + *             * **-EOPNOTSUPP**       Unsupported operation, for example a
> > > + *                                     call from outside of TC ingress.
> > > + *             * **-ESOCKTNOSUPPORT**  Socket type not supported (reuseport).
> > >   */
> > >  #define __BPF_FUNC_MAPPER(FN)          \
> > >         FN(unspec),                     \
> > > @@ -3073,7 +3095,8 @@ union bpf_attr {
> > >         FN(jiffies64),                  \
> > >         FN(read_branch_records),        \
> > >         FN(get_ns_current_pid_tgid),    \
> > > -       FN(xdp_output),
> > > +       FN(xdp_output),                 \
> > > +       FN(sk_assign),
> > >
> > >  /* integer value in 'imm' field of BPF_CALL instruction selects which helper
> > >   * function eBPF program intends to call
> > > diff --git a/net/core/filter.c b/net/core/filter.c
> > > index 96350a743539..f7f9b6631f75 100644
> > > --- a/net/core/filter.c
> > > +++ b/net/core/filter.c
> > > @@ -5860,6 +5860,35 @@ static const struct bpf_func_proto bpf_tcp_gen_syncookie_proto = {
> > >         .arg5_type      = ARG_CONST_SIZE,
> > >  };
> > >
> > > +BPF_CALL_3(bpf_sk_assign, struct sk_buff *, skb, struct sock *, sk, u64, flags)
> > > +{
> > > +       if (flags != 0)
> > > +               return -EINVAL;
> > > +       if (!skb_at_tc_ingress(skb))
> > > +               return -EOPNOTSUPP;
> > > +       if (unlikely(sk->sk_reuseport))
> > > +               return -ESOCKTNOSUPPORT;
> > > +       if (unlikely(dev_net(skb->dev) != sock_net(sk)))
> > > +               return -ENETUNREACH;
> > > +       if (unlikely(!refcount_inc_not_zero(&sk->sk_refcnt)))
> > > +               return -ENOENT;
> > > +
> > > +       skb_orphan(skb);
> > > +       skb->sk = sk;
> > > +       skb->destructor = sock_pfree;
> > > +
> > > +       return 0;
> > > +}
> >
> > Follow up to my email re UDP tests: it seems like the helper doesn't check
> > that the sk is TCP, hence I assumed that you want to add support for
> > both in the same series.
> >
> > Also, is it possible to check that the sk protocol matches skb protocol?
>
> Correction, I was able to get UDP working without the other series (at
> least in Cilium, still working through the tests) so the extra check
> should be unnecessary.
>
> I'll look into options for avoiding crossing packets/sockets of the wrong types.

I looked into these options and found:
* sk->protocol is the L4 proto; skb->protocol is the L3 proto so it
doesn't make sense to compare them
* skb doesn't seem to have any L4 indicator unless you want to start
diving into the packet, which seems not ideal
* I tried using sk->family and ensuring, for example, only AF_INET
sockets can pair with skb->protocol == ETH_P_IP, but I found that in
my integration test I'm using dual-stack sockets so the check was
failing there
* I tried making up some nonsense tests where I cross different types
of sockets on send/recv side and the worst behaviour I could trigger
was timeouts
