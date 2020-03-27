Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 333BB19602C
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 22:05:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727505AbgC0VFf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 17:05:35 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:34393 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727352AbgC0VFe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 17:05:34 -0400
Received: by mail-wr1-f66.google.com with SMTP id 65so13222845wrl.1;
        Fri, 27 Mar 2020 14:05:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uC3/UwAhfLTmbfSw0X2EqP5XAU6300Fl1XuApVESDKI=;
        b=JW0RjHJipGPCpZZ1p663q3iir0/ZGNgX0Ef+dk5WDtmKeowPSndJco6yiOxuwYYL68
         ra09D3DRWQGJ5oEPZd7HnaadCIQBi5EH3UZUP5FRTZ5WqRv07ad2gmGkXca3ggkJjLGt
         8D3Mn+pfvcBG4a32MShE1Z/p55kNPoZbNDGY9btpnkSxOeJtshQFl1vc7MVvRcyrKTkw
         Mox8cKJaqqMN8wwq1TIgxRW+nEu+HpvAYPX6h81iU75AhY11Pcvzi28pv4yy55GHZlbT
         0lqICHpoQExd9900BHvqUEzV3xUgdwUzDOmDLqCRbjKzuNyNNOfIByP0xelK/Ds4sSRz
         sxnw==
X-Gm-Message-State: ANhLgQ37PP58E/yOJMEQsBW8oYMC3wTlhJe1m23REwuiv0yvJPWD8ppD
        FfoPzmtrxj5D4ny9KM3j06uNfj/LLs56RwtIKh8=
X-Google-Smtp-Source: ADFU+vt51AwfD1CA65OgKcekVfRwTkPnbrZ5cvWLG+wEZ0izHd6zf+xXcjZqSN2KkN928w4kitrtBHPqqkzJKwKfJsc=
X-Received: by 2002:adf:e584:: with SMTP id l4mr1301801wrm.388.1585343132421;
 Fri, 27 Mar 2020 14:05:32 -0700 (PDT)
MIME-Version: 1.0
References: <20200327042556.11560-1-joe@wand.net.nz> <20200327184621.67324727o5rtu42p@kafai-mbp>
In-Reply-To: <20200327184621.67324727o5rtu42p@kafai-mbp>
From:   Joe Stringer <joe@wand.net.nz>
Date:   Fri, 27 Mar 2020 14:05:05 -0700
Message-ID: <CAOftzPjv8rcP7Ge59fc4rhy=BR2Ym1=G3n3fvi402nx61zLf-Q@mail.gmail.com>
Subject: Re: [PATCHv3 bpf-next 0/5] Add bpf_sk_assign eBPF helper
To:     Martin KaFai Lau <kafai@fb.com>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     Joe Stringer <joe@wand.net.nz>, bpf <bpf@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 27, 2020 at 11:46 AM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Thu, Mar 26, 2020 at 09:25:51PM -0700, Joe Stringer wrote:
> > Introduce a new helper that allows assigning a previously-found socket
> > to the skb as the packet is received towards the stack, to cause the
> > stack to guide the packet towards that socket subject to local routing
> > configuration. The intention is to support TProxy use cases more
> > directly from eBPF programs attached at TC ingress, to simplify and
> > streamline Linux stack configuration in scale environments with Cilium.
> >
> > Normally in ip{,6}_rcv_core(), the skb will be orphaned, dropping any
> > existing socket reference associated with the skb. Existing tproxy
> > implementations in netfilter get around this restriction by running the
> > tproxy logic after ip_rcv_core() in the PREROUTING table. However, this
> > is not an option for TC-based logic (including eBPF programs attached at
> > TC ingress).
> >
> > This series introduces the BPF helper bpf_sk_assign() to associate the
> > socket with the skb on the ingress path as the packet is passed up the
> > stack. The initial patch in the series simply takes a reference on the
> > socket to ensure safety, but later patches relax this for listen
> > sockets.
> >
> > To ensure delivery to the relevant socket, we still consult the routing
> > table, for full examples of how to configure see the tests in patch #5;
> > the simplest form of the route would look like this:
> >
> >   $ ip route add local default dev lo
> >
> > This series is laid out as follows:
> > * Patch 1 extends the eBPF API to add sk_assign() and defines a new
> >   socket free function to allow the later paths to understand when the
> >   socket associated with the skb should be kept through receive.
> > * Patches 2-3 optimize the receive path to avoid taking a reference on
> >   listener sockets during receive.
> > * Patches 4-5 extends the selftests with examples of the new
> >   functionality and validation of correct behaviour.
> >
> > Changes since v2:
> > * Add selftests for UDP socket redirection
> > * Drop the early demux optimization patch (defer for more testing)
> > * Fix check for orphaning after TC act return
> > * Tidy up the tests to clean up properly and be less noisy.
> >
> > Changes since v1:
> > * Replace the metadata_dst approach with using the skb->destructor to
> >   determine whether the socket has been prefetched. This is much
> >   simpler.
> > * Avoid taking a reference on listener sockets during receive
> > * Restrict assigning sockets across namespaces
> > * Restrict assigning SO_REUSEPORT sockets
> > * Fix cookie usage for socket dst check
> > * Rebase the tests against test_progs infrastructure
> > * Tidy up commit messages
> lgtm.
>
> Acked-by: Martin KaFai Lau <kafai@fb.com>

Thanks for the reviews!

I've rolled in the current nits + acks into the branch below, pending
any further feedback. Alexei, happy to respin this on the mailinglist
at some point if that's easier for you.

https://github.com/joestringer/linux/tree/submit/bpf-sk-assign-v3+
