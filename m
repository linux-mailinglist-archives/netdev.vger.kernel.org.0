Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFC13148E5A
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 20:12:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392031AbgAXTLm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 14:11:42 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:34572 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391986AbgAXTLl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 14:11:41 -0500
Received: by mail-wr1-f65.google.com with SMTP id t2so3321983wrr.1;
        Fri, 24 Jan 2020 11:11:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ib2K0OzgQxGK4AUfBn4nEmNBb8HUwK4c3kiYTuosKRE=;
        b=ULlYSRLu2ySYOHh/fct+TOyrapuE9PCj2PW8DJ1sLDldIucl3J3MuSlagKeM06UII8
         fe4HAt1aRI8rrnkOyoXUIY95W1QnSNscAnx7yhAcTTPU7iIn6fZDR3mIhN6WAJ2Y4s2I
         SDgjChhG1CuaF9iwEPXtU4IkqE2p3MzNG2dCulx9AaXEKyzdxiufwLGY6VcxN92EGJ+N
         o/tymHCkXvXgO1/5Pf4jgzHGgSC5gmLULTnwsTowH+21aqTgggOqNqrW4Ca5TXcjWc1J
         hInb92wdgyqgk4Q8QsFmM9rioYQgBsI520+llaJzns/BiuHCkYNC0rS7DTrT8Vquf8CD
         WFHw==
X-Gm-Message-State: APjAAAWwSBOsCulW2rdn7X6x80Ox7ej+bMlGWgNf5usinF35mO3JhcXD
        /PXwRJ43h9r0yZOKUe1KgJ6HdpFFu2kciQBljWc=
X-Google-Smtp-Source: APXvYqw8InjYksiZzy8UtGN1kq2FhOuZCquiw1D+hkwVLCgi0LqU5KAbCFNXq/R2HiYlkq6EIXdCZSL53MGEP92pDy0=
X-Received: by 2002:adf:fe07:: with SMTP id n7mr5605808wrr.286.1579893099182;
 Fri, 24 Jan 2020 11:11:39 -0800 (PST)
MIME-Version: 1.0
References: <20200118000128.15746-1-matthew.cover@stackpath.com>
 <20200121202038.26490-1-matthew.cover@stackpath.com> <CAGyo_hpVm7q3ghW+je23xs3ja_COP_BMZoE_=phwGRzjSTih8w@mail.gmail.com>
In-Reply-To: <CAGyo_hpVm7q3ghW+je23xs3ja_COP_BMZoE_=phwGRzjSTih8w@mail.gmail.com>
From:   Joe Stringer <joe@wand.net.nz>
Date:   Fri, 24 Jan 2020 11:11:27 -0800
Message-ID: <CAOftzPi74gg=g8VK-43KmA7qqpiSYnJVoYUFDtPDwum10KHc2Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 1/2] bpf: add bpf_ct_lookup_{tcp,udp}() helpers
To:     Matt Cover <werekraken@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Shuah Khan <shuah@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Quentin Monnet <quentin.monnet@netronome.com>,
        Matthew Cover <matthew.cover@stackpath.com>,
        Stanislav Fomichev <sdf@google.com>,
        Andrey Ignatov <rdna@fb.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        netdev <netdev@vger.kernel.org>, bpf@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        linux-kselftest@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>, coreteam@netfilter.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 21, 2020 at 12:36 PM Matt Cover <werekraken@gmail.com> wrote:
>
> On Tue, Jan 21, 2020 at 1:20 PM Matthew Cover <werekraken@gmail.com> wrote:
> >
> > Allow looking up an nf_conn. This allows eBPF programs to leverage
> > nf_conntrack state for similar purposes to socket state use cases,
> > as provided by the socket lookup helpers. This is particularly
> > useful when nf_conntrack state is locally available, but socket
> > state is not.

I think there's an important distinction between accessing sockets and
accessing the connection tracker: Sockets are inherently tied to local
processes. They consume resources regardless of what kind of fancy
networking behaviour you desire out of the stack. Connection-tracking
on the other hand only consumes resources if you enable features that
explicitly require that functionality. This raises some interesting
questions.

The kernel disables nf_conntrack by default to alleviate the costs
associated with it[0]. In the case of this proposal, the BPF program
itself is trying to use nf_conntrack, so does that mean that the
kernel should auto-enable nf_conntrack hooks for the current namespace
(or all namespaces, given that the helper provides access into other
namespaces as well) whenever a BPF program is loaded that uses this
helper?

Related side note: What if you wanted to migitate the performance
penalty of turning on nf_conntrack by programmatically choosing
whether to populate the ct table? Do we then need to define an
interface that allows a BPF program to tell nf_conntrack whether or
not to track a given connection?

More importantly, nf_conntrack has a particular view in mind of what a
connection is and the metadata that can be associated with a
connection. On the other hand, one of the big pulls for building
networking functionality in BPF is to allow flexibility. Over time,
more complex use cases will arise that demand additional metadata to
be stored with their connections. Cilium's connection tracking entries
provides a glimpse of this[1]. I'm sure that the OVS-BPF project would
have similar demands. Longer term, do we encourage such projects to
migrate to this implementation, proposing metadata extensions that are
programmable from BPF?

Taking the metadata question further, there is not only the metadata
that arbitrary BPF programs wish to associate with nf_conntrack. There
is also the various extensions that nf_conntrack itself has which
could be interesting for users that depend on that state. Would we
draw a line before providing access into those aspects of nf_conntrack
from BPF?

Beyond metadata, there is the question of write access to
nf_conntrack. Presumably if a read helper like this is added to the
BPF API, it is only balanced to also add create, update and delete
operations? No doubt if someone wants to build NAT or firewall
functionality in BPF using nf_conntrack, they will want this. Does
this take us on the track of eventually exporting the entire
nf_conntrack module (or even nf_nat) internal kernel APIs as external
BPF API?

If the BPF API is going to provide a connection tracker, I feel that
it should aim to solve connection tracking for various potential
users. This takes us from not just what this patch does, but to the
full vision of where this API goes with a connection tracker
implementation that could be reused by e.g. OVS-BPF or Cilium. At this
point, I'm not convinced why such an implementation should exist in
the BPF API rather than as a common library that can be forked and
tweaked for anyone's uses.

What do you see as the split of responsibility between BPF and other
subsystems long-term for your use case that motivates relying upon
nf_conntrack always running?

[0] https://github.com/torvalds/linux/commit/4d3a57f23dec59f0a2362e63540b2d01b37afe0a
[1] https://github.com/cilium/cilium/blob/v1.6.5/bpf/lib/common.h#L510
