Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10EAC126818
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 18:29:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726949AbfLSR30 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 12:29:26 -0500
Received: from mail-ua1-f44.google.com ([209.85.222.44]:46045 "EHLO
        mail-ua1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726818AbfLSR30 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 12:29:26 -0500
Received: by mail-ua1-f44.google.com with SMTP id 59so2229087uap.12
        for <netdev@vger.kernel.org>; Thu, 19 Dec 2019 09:29:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5tN1HFc0FYyFyHRcui/ELlwKS+WhMN2kD3nJDfhpUBA=;
        b=miISq6QXW7dxHb0VcrzWidVQaG/RnSXjTAruDrgX+3hlDJcnfjZRfJeuEjdeFxoFOW
         cRp+Z/sVlKVPzDvY/kp6fW7L06nPhBbhjUo4dalI/vbvY7G6t7nxMJcrgFGaC9XWtkp+
         w/NamiyFSGHtyRBCvylamy0XZgZPG4zECX4VNvIYcW5MPetlbc/Upx5W4R954zmx4Zo6
         IwNE8mx686gOrWDnLLGUvztcP2yRs/626Tx1zYE+yVmpwaxY9b3zSUa4U3sjexFqCiJ4
         itJo9uximvqb691/BIZhugGzVmqJocwosPSzSVYOoxwTXwPT8sEIFpdFENx/pRm4Nt/f
         b7tg==
X-Gm-Message-State: APjAAAU3r4+iyR7uY+2yu9NgdJX70ZhjpDKSHci0jyjbxwhcaDP0EKzv
        fB16A4P8/pJ8QPQCpTxnseCAUGYIAbJxDsNUxF+bxA==
X-Google-Smtp-Source: APXvYqyFJZu1zFUOSlXkMOYp7KPlj6UctaR65gl9M5OA/KZgVmIV0GkVJuNjBvxhGM40/KoDUCCcuku0DdNC4eFhF2I=
X-Received: by 2002:ab0:5510:: with SMTP id t16mr6668945uaa.15.1576776564640;
 Thu, 19 Dec 2019 09:29:24 -0800 (PST)
MIME-Version: 1.0
References: <BA8DC06A-C508-402D-8A18-B715FBA674A2@amazon.com>
 <b28504a3-4a55-d302-91fe-63915e4568d3@iogearbox.net> <5FA3F980-29E6-4B91-8150-9F28C0E09C45@amazon.com>
 <20190823084704.075aeebd@carbon> <67C7F66A-A3F7-408F-9C9E-C53982BCCD40@amazon.com>
 <20191204155509.6b517f75@carbon> <ec2fd7f6da44410fbaeb021cf984f2f6@EX13D11EUC003.ant.amazon.com>
 <20191216150728.38c50822@carbon> <CA+hQ2+jp471vBvRna7ugdYyFgEB63a9tgCXZCOjEQkT+tZTM1g@mail.gmail.com>
 <20191217094635.7e4cac1c@carbon> <CA+hQ2+jzz2dZONYbW_+H6rE+u50a+r8p5yLtAWWSJFvjmnBz1g@mail.gmail.com>
 <fda0d409b60b4e0a94a0ed4f53f4a3cc@EX13D11EUB003.ant.amazon.com> <20191219114438.0bcb33ea@carbon>
In-Reply-To: <20191219114438.0bcb33ea@carbon>
From:   Luigi Rizzo <rizzo@iet.unipi.it>
Date:   Thu, 19 Dec 2019 09:29:13 -0800
Message-ID: <CA+hQ2+jUH52s==wYqWwJ5zZkDsiAFJ7+fz43BmqS4y84Lphzpg@mail.gmail.com>
Subject: Re: XDP multi-buffer design discussion
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     "Jubran, Samih" <sameehj@amazon.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        "Tzalik, Guy" <gtzalik@amazon.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 19, 2019 at 2:44 AM Jesper Dangaard Brouer
<brouer@redhat.com> wrote:
>
> On Wed, 18 Dec 2019 16:03:54 +0000
> "Jubran, Samih" <sameehj@amazon.com> wrote:
>
> > > -----Original Message-----
> > > From: Luigi Rizzo <rizzo@iet.unipi.it>
> > >...
> > > Here is a possible course of action (please let me know if you find
> > > loose ends)
> > >
> > > 1. extend struct xdp_buff with a total length and sk_buff * (NULL by default);

Top comment: thank you for the feedback, I see you disagree with my proposal :)
so let me ask some questions to understand its shortcoming, identify use cases,
and perhaps address subproblems individually.

> I don't like extending xdp_buff with an skb pointer. (Remember xdp_buff
> is only "allocated" on the stack).

Nit, what are your specific concerns in adding a field or two (pointer
+ total length)
to the xdp_buff (and to the struct visible to the bpf program) ?

> Perhaps xdp_buff with a total-length, *BUT* this can also be solved in
> other ways.  Extend xdp_buff with a flag indicating that this xdp_buff
> have multiple-buffers (segments).  Then we know that the area we store
> the segments is valid, and we can also store the total-length there.
> (We need this total-length later after xdp_buff is freed)

No matter how we extend the structure we must address problem #1
 #1: old bpf programs may not be aware of the new format
       hence may process packets incorrectly.
I don't think there is a way out of this other than have a mechanism
for the bpf programs to indicate which ABI(s) they understand.
Since there are several ways to address it (via BTF, etc.) at load time
and with minimal code changes in the kernel (and none in the loader
programs), I think we can discuss this separately if needed,
and proceed with the assumption that using a slightly different xdp_buff
with additional info (or bpf helpers to retrieve them) is a solved problem.

...
> > > 2. add a netdev callback to construct the skb for the current
> > >    packet. This code obviously already in all drivers, just needs to
> > >    be exposed as function callable by a bpf helper (next bullet);
> > >
>
> Today we already have functions that create an SKB from an xdp_frame.
> ...

I probably should have been more clear on this point.

I introduced the skb to address problem #2:
  #2:  how do we access a multi-segment packet from within the bpf program
      (in other words, how do we represent a multi-segment packet)

and suggested the helper to address problem #3
  #3: how do avoid constructing such a representation if not needed ?

I don't care whether this format is an skb (more details below), but
the xdp_frame
that you mention seems to have only information on the first segment so
I am not sure how it can help with multi-segment frames.

To elaborate: for #2 we should definitely find some optimized solution for the
common cases. The current xdp_buff is optimized for one segment (alas, it only
supports that), and so drivers disable header split when doing xdp to comply.
Header split with hdr+body is possibly very common too (especially if we don't
artificially disable it), so we could/should redefine the
xdp_{buff|frame} with static
room for two segments (header + rest). This can be populated unconditionally at
relatively low cost, for both the caller and the bpf program.

For larger number of segments, though, there is going to be an O(N) space/time
cost, with potentially large N (say when a NIC does RSC before calling
the driver,
resulting in many segments), and non-negligible constants (each segment may
require a dma_sync, and perhaps a decision to recycle or replenish the buffer).
These are all things that we don't want to do upfront because it could
be wasted work,
hence my suggestion for a netdev method and matching bpf helper to create
whatever multi-segment representation only when the bpf program asks for it.

Again, this would be problem #3, which relates to the next bullet:

> > > 3. add a new helper 'bpf_create_skb' that when invoked calls the
> > >    previously mentioned netdev callback to  constructs an skb for
> > >    the current packet, and sets the pointer in the xdp_buff, if not
> > >    there already. A bpf program that needs to access segments beyond
> > >    the first one can call bpf_create_skb() if needed, and then use
> > >    existing helpers skb_load_bytes, skb_store_bytes, etc) to access
> > >    the skb.
> > >
>
> I respectfully disagree with this approach.
>
> One reason is that we want to support creating SKBs on a remote CPU.
> Like we do today with CPUMAP redirect.  The proposed helper 'bpf_create_skb'
> implies that this happens in BPF-context, during the NAPI loop.

restricting the discussion to the non-optimized case (>2 segments):
there is an O(N) phase to grab the segments that has to happen in
the napi loop. Likewise, storage for the list/array of segments must be procured
in the napi loop (it could be in the page containing the packet, but we have
no guarantee that there is space), and then copied on the remote CPU
into a suitable format for xmit (which again does not have to be an skb,
but see more details in response to the last item).

> > >   My rationale is that if we need to access multiple segments, we
> > >   are already in an expensive territory and it makes little sense to
> > >   define a multi segment format that would essentially be an skb.
> > >
>
> I also disagree. Multi-egment frames also have some high speed
> use-cases.  Especially HW header-split at IP+TCP boundry is
> interesting.

Acknowledged and agreed. I have specifically added the 2-segments
case in the the discussion above.

> > > The native driver for a device that cannot guarantee a single
> > > segment would just refuse to load a program that does not
> > > understand them (same as today), so the code would be:
> > >
> > > <construct xdp_buff with first segment and empty skb>  <call bpf program>
> > >
> > > On return, we might find that an skb has been built by the xdp
> > > program, and can be immediately used for XDP_PASS (or dropped in
> > > case of XDP_DROP)
>
> I also disagree here.  SKB should first be created AFTER we know if
> this will be a XDP_PASS action.

Note that I said "we might" - the decision to build the "full_descriptor"
(skb or other format) is made by the bpf program itself. As a consequence,
it won't build a full_descriptor before making a decision, UNLESS it needs to
see the whole packet to make a decision, in which case there is no better
solution anyways.

The only thing where we may look for optimizations is what format this
full_descriptor should have. Depending on the outcome:
XDP_DROP: don't care, it is going to be dropped
XDP_PASS: skb seems convenient since the network stack expects that
XDP_TX if the buffers are mapped dma_bidir, just an array of dma_addr + len
   would work (no dma_map or page refcounts needed)
XDP_REDIRECT array of page fragments (since we need to dma-map them
  for the destination and play with refcounts)

cheers
luigi
