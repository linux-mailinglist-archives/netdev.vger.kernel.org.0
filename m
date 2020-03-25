Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42590191EE3
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 03:15:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727320AbgCYCP5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 22:15:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:33188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727249AbgCYCP5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Mar 2020 22:15:57 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F43820722;
        Wed, 25 Mar 2020 02:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585102556;
        bh=54tljddbiTenKuvzACM/r2jigUZKNxNknkxOF7SY7wI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kL91OI67FQzAhwcCnz1cXPx14Fu8RBWLiNY4Bk6O1AGSL/yD++jdMtuiUeglKcN0+
         Pk0f3uYeXRGfpN0Xwv1wIjWepdd5wsmbpZ1Mq9TyQrIIgimezW6gFbYKdadCFFhbHS
         52+JHucebSUimCorJUnsow5aFEkeJuBtlh2LlLJE=
Date:   Tue, 24 Mar 2020 19:15:54 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Toke =?UTF-8?B?SMO4aWxhbmQt?= =?UTF-8?B?SsO4cmdlbnNlbg==?= 
        <toke@redhat.com>, Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Andrey Ignatov <rdna@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next 1/4] xdp: Support specifying expected existing
 program when attaching XDP
Message-ID: <20200324191554.46a7e0c2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200325013631.vuncsvkivexdb3fr@ast-mbp>
References: <875zez76ph.fsf@toke.dk>
        <20200320103530.2853c573@kicinski-fedora-PC1C0HJN>
        <5e750bd4ebf8d_233f2ab4c81425c4ce@john-XPS-13-9370.notmuch>
        <CAEf4BzbWa8vdyLuzr_nxFM3BtT+hhzjCe9UQF8Y5cN+sVqa72g@mail.gmail.com>
        <87tv2f48lp.fsf@toke.dk>
        <CAEf4BzYutqP0yAy-KyToUNHM6Z-6C-XaEwK25pK123gejG0s9Q@mail.gmail.com>
        <87h7ye3mf3.fsf@toke.dk>
        <CAEf4BzY+JsmxCfjMVizLWYU05VS6DiwKE=e564Egu1jMba6fXQ@mail.gmail.com>
        <87tv2e10ly.fsf@toke.dk>
        <5e7a5e07d85e8_74a82ad21f7a65b88d@john-XPS-13-9370.notmuch>
        <20200325013631.vuncsvkivexdb3fr@ast-mbp>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 24 Mar 2020 18:36:31 -0700 Alexei Starovoitov wrote:
> On Tue, Mar 24, 2020 at 12:22:47PM -0700, John Fastabend wrote:
> > > Well, I wasn't talking about any of those subsystems, I was talking
> > > about networking :)  
> > 
> > My experience has been that networking in the strict sense of XDP no
> > longer exists on its own without cgroups, flow dissector, sockops,
> > sockmap, tracing, etc. All of these pieces are built, patched, loaded,
> > pinned and otherwise managed and manipulated as BPF objects via libbpf.
> > 
> > Because I have all this infra in place for other items its a bit odd
> > imo to drop out of BPF apis to then swap a program differently in the
> > XDP case from how I would swap a program in any other place. I'm
> > assuming ability to swap links will be enabled at some point.
> > 
> > Granted it just means I have some extra functions on the side to manage
> > the swap similar to how 'qdisc' would be handled today but still not as
> > nice an experience in my case as if it was handled natively.
> > 
> > Anyways the netlink API is going to have to call into the BPF infra
> > on the kernel side for verification, etc so its already not pure
> > networking.
> >   
> > > 
> > > In particular, networking already has a consistent and fairly
> > > well-designed configuration mechanism (i.e., netlink) that we are
> > > generally trying to move more functionality *towards* not *away from*
> > > (see, e.g., converting ethtool to use netlink).  
> > 
> > True. But BPF programs are going to exist and interop with other
> > programs not exactly in the networking space. Actually library calls
> > might be used in tracing, cgroups, and XDP side. It gets a bit more
> > interesting if the "same" object file (with some patching) runs in both
> > XDP and sockops land for example.  
> 
> Thanks John for summarizing it very well.
> It looks to me that netlink proponents fail to realize that "bpf for
> networking" goes way beyond what netlink is doing and capable of doing in the
> future. BPF_*_INET_* progs do core networking without any smell of netlink
> anywhere. "But, but, but, netlink is the way to configure networking"... is
> simply not true. Even in years before BPF sockets and syscalls were the way to
> do it. netlink has plenty of awesome properties, but arguing that it's the
> only true way to do networking is not matching the reality.

It is the way to configure XDP today, so it's only natural to
scrutinize the attempts to replace it. 

Also I personally don't think you'd see this much push back trying to
add bpf_link-based stuff to cls_bpf, that's an add-on. XDP is
integrated very fundamentally with the networking stack at this point.

> Details are important and every case is different. So imo:
> converting ethtool to netlink - great stuff.
> converting netdev irq/queue management to netlink - great stuff too.
> adding more netlink api for xdp - really bad idea.

Why is it a bad idea?

There are plenty things which will only be available over netlink.
Configuring the interface so installing the XDP program is possible
(disabling features, configuring queues etc.). Chances are user gets
the ifindex of the interface to attach to over netlink in the first
place. The queue configuration (which you agree belongs in netlink)
will definitely get more complex to allow REDIRECTs to work more
smoothly. AF_XDP needs all sort of netlink stuff.

Netlink gives us the notification mechanism which is how we solve
coordination across daemons (something that BPF subsystem is only 
now trying to solve).

BPF subsystem has a proven track record of reimplementing things devs
don't like or haven't studied (bpftool net, netlink library). So it is
a real concern to allow duplicating parts of the kernel netlink API.
