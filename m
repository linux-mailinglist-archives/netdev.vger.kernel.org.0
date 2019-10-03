Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BC02CA068
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 16:33:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730239AbfJCOdS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 10:33:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37660 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728407AbfJCOdR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Oct 2019 10:33:17 -0400
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com [209.85.208.200])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5934C793C4
        for <netdev@vger.kernel.org>; Thu,  3 Oct 2019 14:33:17 +0000 (UTC)
Received: by mail-lj1-f200.google.com with SMTP id p18so933607ljn.1
        for <netdev@vger.kernel.org>; Thu, 03 Oct 2019 07:33:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=PlNbdekHjIXNTK1VHxjBK8lXGmbPJyCX++L2MditMcE=;
        b=hTaLpX0glowIcoJBxbHvTNwI0v5zMMRSISBkNwq+SSIYDj+eIGnNaqD/Pd9oXJLgeW
         PXVgjLE5i4uVzJx2qHtTsm1iT12tPFkjwd5rejPj8Qja0Ym8vnao4tI9R9hFOEdtmqON
         2Jh8RcL0MU3g2vhwG0IAnxxcGcjdApKwsCSOCA7ZDZscWroZI5d2uH5a0aNqEtjHa0w9
         XGq9aFo8qxbv+HMZvyebVS0Ueaiqs0TX1ofIjDVi4ttC6PooKgfPnu8PtbpYdbqWg1UU
         wFlwfYI/H8K3P8YLUiMNHi1/g8q8ebnxJfgAN5rS8mVNjVTVMBpkNmbvcPo3aBnrEmcf
         X1KA==
X-Gm-Message-State: APjAAAWUKbLkv2+jXE+3oTjMuBfT3y7oIG16ssPOTQMw1HhPZVG7AOUN
        SDWxlJg7GRPEUXLhz3tQQ6LhGNHRweVe8qV0Or9HDIz5HE+P3ry6dI2Edx5iUkeSsEIJHooq/U7
        nhRAT5J1a9JHkkmt3
X-Received: by 2002:a2e:924f:: with SMTP id v15mr6403453ljg.199.1570113195665;
        Thu, 03 Oct 2019 07:33:15 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwdgbGsjVfpkCpHe3SGNdaKKEoMEpby7oghNSXIiAuKe88nabCR7n0YMSkKCvRdeK2l7QtH0g==
X-Received: by 2002:a2e:924f:: with SMTP id v15mr6403439ljg.199.1570113195441;
        Thu, 03 Oct 2019 07:33:15 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id s6sm563223ljg.43.2019.10.03.07.33.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Oct 2019 07:33:14 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 9719F18063D; Thu,  3 Oct 2019 16:33:13 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Song Liu <songliubraving@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, Martin Lau <kafai@fb.com>,
        Yonghong Song <yhs@fb.com>,
        Marek Majkowski <marek@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        David Miller <davem@davemloft.net>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf\@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next 0/9] xdp: Support multiple programs on a single interface through chain calls
In-Reply-To: <CAADnVQKTbaxJhkukxXM7Ue7=kA9eWsGMpnkXc=Z8O3iWGSaO0A@mail.gmail.com>
References: <157002302448.1302756.5727756706334050763.stgit@alrua-x1> <E7319D69-6450-4BC3-97B1-134B420298FF@fb.com> <A754440E-07BF-4CF4-8F15-C41179DCECEF@fb.com> <87r23vq79z.fsf@toke.dk> <20191003105335.3cc65226@carbon> <CAADnVQKTbaxJhkukxXM7Ue7=kA9eWsGMpnkXc=Z8O3iWGSaO0A@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 03 Oct 2019 16:33:13 +0200
Message-ID: <87pnjdq4pi.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:

> On Thu, Oct 3, 2019 at 1:53 AM Jesper Dangaard Brouer <brouer@redhat.com> wrote:
>>> The xdpcap use-case is to trap any XDP return action code (and tcpdump
>> via perf event ring_buffer).  For system administrators the xdpcap
>> use-case is something we hear about all the time, so one of the missing
>> features for XDP.  As Toke also wrote, we want to extend this to ALSO
>> be-able to see/dump the packet BEFORE a given XDP program.
>
> It sounds to me that 'xdpdump/xdpcap' (tcpdump equivalent) is
> the only use case both you and Toke are advocating for.
> I think such case we can do already without new kernel code:
> - retrieve prog_id of the program attached to given xdp ifindex
> - convert to fd
> - create prog_array of one element and store that prog_fd
> - create xdpump bpf prog that prints to ring buffer
>   and tail_calls into that prog_array
> - replace xdp prog on that ifindex
>
> Now it see all the traffic first and existing xdp progs keep working.
> What am I missing?

Yeah, that takes care of the "run xdpdump as the first thing" use case.
But we also want to be able to run it *after* another program, *without*
modifying that program to add a tail call.

More generally, we want to be able to chain XDP programs from multiple
sources in arbitrary ways. Let me try to provide a more fleshed-out
usage example:

Say a distro ships MyFirewall and MyIDS, two different upstream
projects, both of which support XDP acceleration. MyFirewall has
specified in its documentation that its XDP program will return XDP_PASS
for anything that it has determined should not be dropped. So the
sysadmin decides he wants to enable both, and of course he wants both to
be XDP-accelerated.

This particular sysadmin doesn't want to expend IDS resources on traffic
that the firewall has already decided to drop, so he'll just install the
firewall first, and then run the IDS on any traffic that gets XDP_PASS.
So he installs IDS as a chain-call XDP program on the XDP_PASS action
after the firewall.

Another sysadmin might be more paranoid (or have more CPU resources
available), and so he wants to run the IDS first, and the firewall
afterwards. So he installs the two XDP programs in the reverse order, by
chaining the firewall to the IDS' XDP_PASS action.

At the same time, the sysadmin wants to inspect what the firewall is
actually dropping, so he fires up xdpdump and tells it to show him
everything dropped by the firewall. The xdpdump tool does this by
attaching itself as a chain call program to the XDP_DROP action of the
firewall program.

In all cases, the sysadmin can't (or doesn't want to) modify any of the
XDP programs. In fact, they may just be installed as pre-compiled .so
BPF files on his system. So he needs to be able to configure the call
chain of different programs without modifying the eBPF program source
code.

This is basically what we're trying to support with XDP chain calls
(which I guess is now turning into more general eBPF chain calls). I
think it is doable with something based on the BPF_PROG_CHAIN_* series
you posted a link to earlier; but instead of having an explicit
tail_call_next() helper, I'll just make the verifier insert the chain
calls before each BPF_EXIT instruction when this feature is turned on.
Do you see any reason why this wouldn't work?

-Toke
