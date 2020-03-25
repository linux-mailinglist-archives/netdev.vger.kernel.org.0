Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E149A191E9B
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 02:36:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727272AbgCYBgi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 21:36:38 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:45948 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727229AbgCYBgi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 21:36:38 -0400
Received: by mail-pl1-f193.google.com with SMTP id b9so148672pls.12;
        Tue, 24 Mar 2020 18:36:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uW/iRwUJZKsD7olxJkP9vaD4PA48xnp6VBM3+xZ/VKs=;
        b=rtcD6LvLmVsn6Tc7WJB4KpeW+XOVIYIPVkRnM3sKtK18iTkDs73fbVU9bEmDXgAuf7
         R7sH0Gk0xxxQYwHNBuvc9EZuLVPCpc9YRNjahg3itW9tT3YPYhj9wMTiqvjEhh/zslm8
         8o6quzaI2UBW1qrhZxEPbhrQ45hI9r97ZFwGQ1a7twDUHQFfGlvJ9NZ2Lv/2iWDQxcme
         yV7mgXcgeohFr7jn5ADnpzkEJCBydALowk3c7ygiZQq6eEQpWN66NafIZfJVhxUvhI7Z
         03FyWhzcD4opgTs97ujgXKCHHLs4VA9tj7GbrHyd3ayliDnGw36ELMF2D9oZ+q1tkdt/
         HdEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uW/iRwUJZKsD7olxJkP9vaD4PA48xnp6VBM3+xZ/VKs=;
        b=R/ZkFTQaJ7O5QoStM9MYw0glbH5t9l1F9466nvNSbCry8aJgwUwSqAL6mpuuuq1L0S
         QywCFuBMSLecKS73Pl0aVjTY36e9/rz/3f4XiDDw8Uv45fPMMS9sfoLhnYqEXaeySb8T
         q0Zyy3oZo5zTrUcZnjk2Y/EdazGlD5ydft0kymzH2L70k280sZuAzCopqOV4MBI4K7p4
         K/UAgyxhKeicXTW/A/RbzPb9xSRCUH2TatfwZrQ817kRb6ZGat0wE/XL0BNAwa2CNkx5
         ENNEPfPh0PJxJKzCp46oc+72FiwLt7jeX21wneQRPvmEA4r1Us9DQJgNuDggjHHmHbvL
         juvQ==
X-Gm-Message-State: ANhLgQ2Y4t9O4QpDP1M2r9KnAipOssyBq3qYPDHBLbOaanmytUyI5jXA
        stOVP+rV7GF82hkhpEuRc6Q=
X-Google-Smtp-Source: ADFU+vvYQzlIaLKblrDn/NtAYu6pWx7/hAlTrXeMSaV0dNhmwSFqLM38cJQlVEjbQRZwdW1SPwAiYQ==
X-Received: by 2002:a17:90b:2318:: with SMTP id mt24mr903833pjb.66.1585100196416;
        Tue, 24 Mar 2020 18:36:36 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:8308])
        by smtp.gmail.com with ESMTPSA id 144sm15788590pgc.25.2020.03.24.18.36.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2020 18:36:35 -0700 (PDT)
Date:   Tue, 24 Mar 2020 18:36:31 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
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
Message-ID: <20200325013631.vuncsvkivexdb3fr@ast-mbp>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5e7a5e07d85e8_74a82ad21f7a65b88d@john-XPS-13-9370.notmuch>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 24, 2020 at 12:22:47PM -0700, John Fastabend wrote:
> > 
> > Well, I wasn't talking about any of those subsystems, I was talking
> > about networking :)
> 
> My experience has been that networking in the strict sense of XDP no
> longer exists on its own without cgroups, flow dissector, sockops,
> sockmap, tracing, etc. All of these pieces are built, patched, loaded,
> pinned and otherwise managed and manipulated as BPF objects via libbpf.
> 
> Because I have all this infra in place for other items its a bit odd
> imo to drop out of BPF apis to then swap a program differently in the
> XDP case from how I would swap a program in any other place. I'm
> assuming ability to swap links will be enabled at some point.
> 
> Granted it just means I have some extra functions on the side to manage
> the swap similar to how 'qdisc' would be handled today but still not as
> nice an experience in my case as if it was handled natively.
> 
> Anyways the netlink API is going to have to call into the BPF infra
> on the kernel side for verification, etc so its already not pure
> networking.
> 
> > 
> > In particular, networking already has a consistent and fairly
> > well-designed configuration mechanism (i.e., netlink) that we are
> > generally trying to move more functionality *towards* not *away from*
> > (see, e.g., converting ethtool to use netlink).
> 
> True. But BPF programs are going to exist and interop with other
> programs not exactly in the networking space. Actually library calls
> might be used in tracing, cgroups, and XDP side. It gets a bit more
> interesting if the "same" object file (with some patching) runs in both
> XDP and sockops land for example.

Thanks John for summarizing it very well.
It looks to me that netlink proponents fail to realize that "bpf for
networking" goes way beyond what netlink is doing and capable of doing in the
future. BPF_*_INET_* progs do core networking without any smell of netlink
anywhere. "But, but, but, netlink is the way to configure networking"... is
simply not true. Even in years before BPF sockets and syscalls were the way to
do it. netlink has plenty of awesome properties, but arguing that it's the
only true way to do networking is not matching the reality.
Details are important and every case is different. So imo:
converting ethtool to netlink - great stuff.
converting netdev irq/queue management to netlink - great stuff too.
adding more netlink api for xdp - really bad idea.
