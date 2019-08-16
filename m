Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34F5390974
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 22:28:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727643AbfHPU2s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 16:28:48 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:43151 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727589AbfHPU2s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 16:28:48 -0400
Received: from pd9ef1cb8.dip0.t-ipconnect.de ([217.239.28.184] helo=nanos)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1hyipq-00005o-Km; Fri, 16 Aug 2019 22:28:30 +0200
Date:   Fri, 16 Aug 2019 22:28:29 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
cc:     Jordan Glover <Golden_Miller83@protonmail.ch>,
        Andy Lutomirski <luto@kernel.org>,
        Daniel Colascione <dancol@google.com>,
        Song Liu <songliubraving@fb.com>,
        Kees Cook <keescook@chromium.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Jann Horn <jannh@google.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux API <linux-api@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH v2 bpf-next 1/4] bpf: unprivileged BPF access via
 /dev/bpf
In-Reply-To: <20190816195233.vzqqbqrivnooohq6@ast-mbp.dhcp.thefacebook.com>
Message-ID: <alpine.DEB.2.21.1908162211270.1923@nanos.tec.linutronix.de>
References: <20190806011134.p5baub5l3t5fkmou@ast-mbp> <CALCETrUkqUprujww26VxHwkdXQ3DWJH8nnL2VBYpK2EU0oX_YA@mail.gmail.com> <20190814220545.co5pucyo5jk3weiv@ast-mbp.dhcp.thefacebook.com> <HG0x24u69mnaMFKuxHVAzHpyjwsD5-U6RpqFRua87wGWQCHg00Q8ZqPeA_5kJ9l-d6oe0cXa4HyYXMnOO0Aofp_LcPcQdG0WFV21z1MbgcE=@protonmail.ch>
 <20190815172856.yoqvgu2yfrgbkowu@ast-mbp.dhcp.thefacebook.com> <CALCETrUv+g+cb79FJ1S4XuV0K=kowFkPXpzoC99svoOfs4-Kvg@mail.gmail.com> <20190815230808.2o2qe7a72cwdce2m@ast-mbp.dhcp.thefacebook.com>
 <fkD3fs46a1YnR4lh0tEG-g3tDnDcyZuzji7bAUR9wujPLLl75ZhI8Yk-H1jZpSugO7qChVeCwxAMmxLdeoF2QFS3ZzuYlh7zmeZOmhDJxww=@protonmail.ch> <alpine.DEB.2.21.1908161158490.1873@nanos.tec.linutronix.de> <lGGTLXBsX3V6p1Z4TkdzAjxbNywaPS2HwX5WLleAkmXNcnKjTPpWnP6DnceSsy8NKt5NBRBbuoAb0woKTcDhJXVoFb7Ygk3Skfj8j6rVfMQ=@protonmail.ch>
 <20190816195233.vzqqbqrivnooohq6@ast-mbp.dhcp.thefacebook.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei,

On Fri, 16 Aug 2019, Alexei Starovoitov wrote:
> It's both of the above when 'systemd' is not taken literally.
> To earlier Thomas's point: the use case is not only about systemd.
> There are other containers management systems.

<SNIP>

> These daemons need to drop privileges to make the system safer == less
> prone to corruption due to bugs in themselves. Not necessary security
> bugs.

Let's take a step back.

While real usecases are helpful to understand a design decision, the design
needs to be usecase independent.

The kernel provides mechanisms, not policies. My impression of this whole
discussion is that it is policy driven. That's the wrong approach.

So let's look at the mechanisms which we have at hand:

 1) Capabilities
 
 2) SUID and dropping priviledges

 3) Seccomp and LSM

Now the real interesting questions are:

 A) What kind of restrictions does BPF allow? Is it a binary on/off or is
    there a more finegrained control of BPF functionality?

    TBH, I can't tell.

 B) Depending on the answer to #A what is the control possibility for
    #1/#2/#3 ?

Answering those questions gives us a real scope of what can be achieved
independent of use cases and wishful thought out policies.

Thanks,

	tglx
