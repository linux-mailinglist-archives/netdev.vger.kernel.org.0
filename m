Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B243C1FAB34
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 10:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727916AbgFPIaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 04:30:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726573AbgFPIaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 04:30:18 -0400
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98C14C03E96A
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 01:30:18 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id n70so15324563ota.5
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 01:30:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iFZu21anIecqeWnmtHDcKq9io7f3G/fD/2SgVahSB5o=;
        b=xNw2XJ3W6+QRI42l+XFlKIs2oUp3ZMllemOdGovEuifvIF3kEWzDFTdYX+xBKVJZe0
         XZ+aHBfFXcExTyTXZx2pwIo6GF3KWtHNfN0wD8alb7/4mqnwZMoxYoZfDZcDY6mRwH7X
         1OI8kbUZYWXgNEdjExp8YSuk1HrapdVEoQ5v4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iFZu21anIecqeWnmtHDcKq9io7f3G/fD/2SgVahSB5o=;
        b=ne5S2GmlZD75kbbnPAbbc0VT1efTXdqjSIjaIZcVLhBvZ3+RCKEZprgX6KMZmv6ov5
         rji5hoqPfPIA/mCeWVioDk+IrBk94L1qNmeG/r+Wcem9VHJh2KuPD4RxyRhe8IyogMPa
         PK449b6aADyId3wRkR941ZyL8mTA3JKopEd6SziK3uM3Klxddok148OVfDfxIA+Dd7Bc
         nu9hdwSSrw2zvyrQtVe4K416en3vl1VEvuzZOtQDEldY0HfVzPEtBWjydJLR3DljQmwB
         E+CJ8SSu7j7oYXqc8oHEpZioZ1TZc2T/TqsRfTkXzmTnH/F8Bi5+b/kOVJ37oaQyUlKG
         k0Tw==
X-Gm-Message-State: AOAM531UAzE3D5Uf+ZSTw1BrVv8wbXJryzkFOaPRzqyq1MszFEDcfgGl
        JEjj1yYOJI09B11TPhYOmxwxsgVUXOMM5KDL9sca5xfc7a0=
X-Google-Smtp-Source: ABdhPJxrzvbJdzoHn4DvVnkgACjbZuigtgxQERvnRr4I09yrEvDM8GB18hU9JmN3mH7A3JSLwqB26+Qq3j6dQyXGWTc=
X-Received: by 2002:a9d:5cc1:: with SMTP id r1mr1384294oti.147.1592296217878;
 Tue, 16 Jun 2020 01:30:17 -0700 (PDT)
MIME-Version: 1.0
References: <20200612160141.188370-1-lmb@cloudflare.com> <CAADnVQ+owOvkZ03qyodmh+4NkZD=1LpgTN+YJqiKgr0_OKqRtA@mail.gmail.com>
 <CACAyw9-Jy+r2t5Yy83EEZ8GDnxEsGOPdrqr2JSfVqcC2E6dYmQ@mail.gmail.com> <CAADnVQJP_i+KsP771L=GwxousnE=w9o2KckZ7ZCbc064EqSq6w@mail.gmail.com>
In-Reply-To: <CAADnVQJP_i+KsP771L=GwxousnE=w9o2KckZ7ZCbc064EqSq6w@mail.gmail.com>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Tue, 16 Jun 2020 09:30:06 +0100
Message-ID: <CACAyw99Szs3nUTx=DSmh0x8iTBLNF9TTLGC0GQLZ=FifVnbzBA@mail.gmail.com>
Subject: Re: [PATCH bpf 1/2] flow_dissector: reject invalid attach_flags
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        kernel-team <kernel-team@cloudflare.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 16 Jun 2020 at 04:55, Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Mon, Jun 15, 2020 at 7:43 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
> >
> > On Fri, 12 Jun 2020 at 23:36, Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > On Fri, Jun 12, 2020 at 9:02 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
> > > >
> > > > Using BPF_PROG_ATTACH on a flow dissector program supports neither flags
> > > > nor target_fd but accepts any value. Return EINVAL if either are non-zero.
> > > >
> > > > Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> > > > Fixes: b27f7bb590ba ("flow_dissector: Move out netns_bpf prog callbacks")
> > > > ---
> > > >  kernel/bpf/net_namespace.c | 3 +++
> > > >  1 file changed, 3 insertions(+)
> > > >
> > > > diff --git a/kernel/bpf/net_namespace.c b/kernel/bpf/net_namespace.c
> > > > index 78cf061f8179..56133e78ae4f 100644
> > > > --- a/kernel/bpf/net_namespace.c
> > > > +++ b/kernel/bpf/net_namespace.c
> > > > @@ -192,6 +192,9 @@ int netns_bpf_prog_attach(const union bpf_attr *attr, struct bpf_prog *prog)
> > > >         struct net *net;
> > > >         int ret;
> > > >
> > > > +       if (attr->attach_flags || attr->target_fd)
> > > > +               return -EINVAL;
> > > > +
> > >
> > > In theory it makes sense, but how did you test it?
> >
> > Not properly it seems, sorry!
> >
> > > test_progs -t flow
> > > fails 5 tests.
> >
> > I spent today digging through this, and the issue is actually more annoying than
> > I thought. BPF_PROG_DETACH for sockmap and flow_dissector ignores
> > attach_bpf_fd. The cgroup and lirc2 attach point use this to make sure that the
> > program being detached is actually what user space expects. We actually have
> > tests that set attach_bpf_fd for these to attach points, which tells
> > me that this is
> > an easy mistake to make.
> >
> > Unfortunately I can't come up with a good fix that seems backportable:
> > - Making sockmap and flow_dissector have the same semantics as cgroup
> >   and lirc2 requires a bunch of changes (probably a new function for sockmap)
>
> making flow dissector pass prog_fd as cg and lirc is certainly my preference.
> Especially since tests are passing fd user code is likely doing the same,
> so breakage is unlikely. Also it wasn't done that long ago, so
> we can backport far enough.
> It will remove cap_net_admin ugly check in bpf_prog_detach()
> which is the only exception now in cap model.

SGTM. What about sockmap though? The code for that has been around for ages.

-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
