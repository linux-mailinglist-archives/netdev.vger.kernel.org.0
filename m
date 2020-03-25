Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1124D1930EE
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 20:15:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727473AbgCYTPB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 15:15:01 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:41603 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727174AbgCYTPB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 15:15:01 -0400
Received: by mail-pf1-f195.google.com with SMTP id z65so1517173pfz.8;
        Wed, 25 Mar 2020 12:14:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZT1H/FfhGLTxL1pvr6fLZlzv5YS5gaAXQt+6VTg1Ii8=;
        b=FLQosNSUNZQkZ2nVncGN7xFlwOiL8XkKPS28lP3ID+fj8yomnTAGrf+8QzPmDfdyvC
         o+rBvX3+aQg0a1LPLfOUxOKhnhvsIbqaePCODnYeMVeZrxd8rJQ2wn07m0FDDIBz1UW/
         zajQayzBqs6eS9tNlHpectzsLOs75mCMlKO+ugQHWtAa4eRrvEzYgStTlL9HXhNFIKWe
         zfj6qCoa5fiZOD9MREYmg6GcM8s2ftDgQQIaQ0wVvXA637/mnOBD7haRvivp/J+F3v+A
         ZofttKoelSi27h3MvM9jDK5c7VovM9hDkwOgsOez9/YR46DamtQlJeCBxSV7M+97i+c5
         P6yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZT1H/FfhGLTxL1pvr6fLZlzv5YS5gaAXQt+6VTg1Ii8=;
        b=R5/z91eJRlQIXOQbXPy207P+h+fNdSogbYlhoHza3He0+abVdsJ7uad1v5DpqxwTnB
         4tm9VOeLIvVymyrZpbAsg7LaDdvKGB9oNdSF/1KEnKJPIyEnGxb2bFBqQ7y7f20T7Lip
         Jj7I10+yMJoTuI5vshu5LaGdohO0E/vt/tsBS7sfYEGb/xId0KUfMvqlkjaoTcO2mDnm
         67RrtZ/zk1JtK9RvLrcJuaqervvk8tGUX7/f7rw+ZXhKzA0jE9BXOceoGM6O4d8HZ2cS
         ACrFrrGjCwAab4oNMJXh4welo9PoQmLWRH1tNiYVjUAK/SE8HUjSYh2DvlQxN0fXq6Hh
         DbBA==
X-Gm-Message-State: ANhLgQ2dRiKqlZBoEzHcHiScX6dkSq537Nd1zdCmEoBd26W0VWxN3ZXU
        MqnMEw2Zz3NVUe5IMFkxTEc=
X-Google-Smtp-Source: ADFU+vsHmK+VvXjcXPBL6qVKZCN2+uHiQJ6mDz3TKSTPPphiNuyQ/DY2IcNqATc+JEk/P3ccLAhD7Q==
X-Received: by 2002:a63:be0f:: with SMTP id l15mr4444126pgf.451.1585163698152;
        Wed, 25 Mar 2020 12:14:58 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:b339])
        by smtp.gmail.com with ESMTPSA id l7sm18344504pff.204.2020.03.25.12.14.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2020 12:14:57 -0700 (PDT)
Date:   Wed, 25 Mar 2020 12:14:54 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
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
Message-ID: <20200325191454.ub5x3kayowsc75vg@ast-mbp>
References: <87tv2f48lp.fsf@toke.dk>
 <CAEf4BzYutqP0yAy-KyToUNHM6Z-6C-XaEwK25pK123gejG0s9Q@mail.gmail.com>
 <87h7ye3mf3.fsf@toke.dk>
 <CAEf4BzY+JsmxCfjMVizLWYU05VS6DiwKE=e564Egu1jMba6fXQ@mail.gmail.com>
 <87tv2e10ly.fsf@toke.dk>
 <5e7a5e07d85e8_74a82ad21f7a65b88d@john-XPS-13-9370.notmuch>
 <20200325013631.vuncsvkivexdb3fr@ast-mbp>
 <20200324191554.46a7e0c2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200325180638.el22n4ms6aau42r4@ast-mbp>
 <20200325112005.205d985a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200325112005.205d985a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 25, 2020 at 11:20:05AM -0700, Jakub Kicinski wrote:
> On Wed, 25 Mar 2020 11:06:38 -0700 Alexei Starovoitov wrote:
> > On Tue, Mar 24, 2020 at 07:15:54PM -0700, Jakub Kicinski wrote:
> > > It is the way to configure XDP today, so it's only natural to
> > > scrutinize the attempts to replace it.   
> > 
> > No one is replacing it.
> 
> You're blocking extensions to the existing API, that means that part 
> of the API is frozen and is being replaced.

two things are wrong in the above stmt:
1. extensions are not frozen in general.
2. api is not being replaced. ownership is lacking. It needs to be added.
   It's a new concept. Not a replacement.

> > > Also I personally don't think you'd see this much push back trying to
> > > add bpf_link-based stuff to cls_bpf, that's an add-on. XDP is
> > > integrated very fundamentally with the networking stack at this point.
> > >   
> > > > Details are important and every case is different. So imo:
> > > > converting ethtool to netlink - great stuff.
> > > > converting netdev irq/queue management to netlink - great stuff too.
> > > > adding more netlink api for xdp - really bad idea.  
> > > 
> > > Why is it a bad idea?  
> > 
> > I explained in three other emails. tldr: lack of ownership.
> 
> Those came later, I think, thanks.
> 
> Fine, maybe one day someone will find the extension you're proposing
> useful. To me that's not a justification to freeze the existing API
> (you said "adding more netlink api for xdp - really bad idea").
> 
> Besides, if you look at Toke's libxdp work (which exists), what's the
> ownership of the attached program? Whichever application touched it
> last?
> 
> The whole auto-detachment thing may work nicely in cls_bpf and
> sub-programs attached to the root XDP program, but it's a bit hard 
> to imagine how its useful for the singleton root XDP program.

bpf_link introduces two new things: 1. ownership 2. auto-detach
They are both useful. Looks like the use case for 2 is obvious, but
1 can exist without being FD based.

> 
> > > There are plenty things which will only be available over netlink.
> > > Configuring the interface so installing the XDP program is possible
> > > (disabling features, configuring queues etc.). Chances are user gets
> > > the ifindex of the interface to attach to over netlink in the first
> > > place. The queue configuration (which you agree belongs in netlink)
> > > will definitely get more complex to allow REDIRECTs to work more
> > > smoothly. AF_XDP needs all sort of netlink stuff.  
> > 
> > sure. that has nothing to do with ownership of attachment.
> 
> AFAICT the allure to John is the uniform API, and no need for netlink.
> I was explaining how that's a bad goal to have.

You clearly misunderstood. Neither John nor I were saying that there is
no need for netlink.

> 
> > > Netlink gives us the notification mechanism which is how we solve
> > > coordination across daemons (something that BPF subsystem is only 
> > > now trying to solve).  
> > 
> > I don't care about notifications on attachment and no one is trying to
> > solve that as far as I can see. It's not a problem to solve in the first place.
> 
> Well, it's the existing solution to the "ownership" problem.
> I think most people simply didn't know about it.

Toke's set introduces the same thing to XDP as
commit 7dd68b3279f1 ("bpf: Support replacing cgroup-bpf program in MULTI mode")
did for cgroup-bpf.
Both are trying to address the same issue and both are NOT doing.
That cgroup-bpf commit looked like a great solution just three month ago.
Now it's clear it's not fixing the underlying issue.
Same thing with Toke's fix. It feels good now, but going to be uselss
without introducing ownership.

Why that cgroup-bpf commit not fixing it?
Take a look at that commit. The first paragraph is
"
The common use-case in production is to have multiple cgroup-bpf
programs per attach type that cover multiple use-cases. Such programs
are attached with BPF_F_ALLOW_MULTI and can be maintained by different
people.
"
Then the description goes into explaining how one service wants to replace its prog.
In this case it sort of works because it's single c++ service with multiple
progs that do different things. There is a 'centralized daemon' (kinda) that
can try to orchestrate. It breaks when there are two c++ services.
That replace_bpf_fd is trying to be a link identifier. But the kernel lacks
that identifier.
I think it would be simpler to understand the ownership if bpf_link had
its own IDR for every link. Every attachment(link) would be an object with its
own id. We could have iterated over all attachments with GET_NEXT_ID, for example.
But that's nice to have. Not strictly necessary.
The ownership of the attachment needs to be permanent. It needs to belong
to a task and other tasks should not be able to break that attachment.
That cgroup-bpf commit addressing part of the issue by "inventing" an identifier
for the attachment (in the form of prog_fd that suppose to be there in that
attachment), but not addressing the owner part of the attachment.
Only the task(s) that own that attachment should be able to modify the attachment.

One can imagine how attachment ID can be completely implemented with netlink.
Is it good idea? Not really, because there is no mechanism to transfer the ownership.
Having an FD that points to a kernel object that represents the ownership makes it
easy for user space to pass the ownership (by passing an FD).
Auto-detach part comes for free with FD based bpf_link, but that's not the main feature.
May be we will add a flag to disable auto-detach too.
