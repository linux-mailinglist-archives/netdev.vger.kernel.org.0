Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15049700AD
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 15:11:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730552AbfGVNKr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 09:10:47 -0400
Received: from ajax.cs.uga.edu ([128.192.4.6]:49442 "EHLO ajax.cs.uga.edu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728343AbfGVNKq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jul 2019 09:10:46 -0400
X-Greylist: delayed 967 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Jul 2019 09:10:45 EDT
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
        (authenticated bits=0)
        by ajax.cs.uga.edu (8.14.4/8.14.4) with ESMTP id x6MCsZkX013562
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Jul 2019 08:54:37 -0400
Received: by mail-lf1-f48.google.com with SMTP id 62so21670281lfa.8;
        Mon, 22 Jul 2019 05:54:36 -0700 (PDT)
X-Gm-Message-State: APjAAAUVtJrnlw7xYq8J1kpLJPP/+MnqLN9+2al5jfaWtr0pH8CzBDIh
        4Z29ufzqpDyoPcDlC00bVbGB22kn6fH+65nCB9o=
X-Google-Smtp-Source: APXvYqz4FayGl7GhjYqBZCRR2PNrf9fqpfgXxMkDxoQT1M5AKTCW0Ks6Rp2FxLNB0uqRaazJ2RdDpsYGTEtzckqhZ0s=
X-Received: by 2002:ac2:4565:: with SMTP id k5mr31911521lfm.170.1563800075295;
 Mon, 22 Jul 2019 05:54:35 -0700 (PDT)
MIME-Version: 1.0
References: <1563625366-3602-1-git-send-email-wang6495@umn.edu> <20190722123204.rvsqlqgynfgjcif7@oracle.com>
In-Reply-To: <20190722123204.rvsqlqgynfgjcif7@oracle.com>
From:   Wenwen Wang <wenwen@cs.uga.edu>
Date:   Mon, 22 Jul 2019 07:53:59 -0500
X-Gmail-Original-Message-ID: <CAAa=b7cwJ-2wPNtH_j6saHiUWRj7zSwzZ8sGPWfgG9AyxWrOPg@mail.gmail.com>
Message-ID: <CAAa=b7cwJ-2wPNtH_j6saHiUWRj7zSwzZ8sGPWfgG9AyxWrOPg@mail.gmail.com>
Subject: Re: [PATCH] netfilter: ebtables: compat: fix a memory leak bug
To:     "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:NETFILTER" <netfilter-devel@vger.kernel.org>,
        "open list:NETFILTER" <coreteam@netfilter.org>,
        "moderated list:ETHERNET BRIDGE" <bridge@lists.linux-foundation.org>,
        "open list:ETHERNET BRIDGE" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Wenwen Wang <wenwen@cs.uga.edu>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 22, 2019 at 7:34 AM Liam R. Howlett <Liam.Howlett@oracle.com> wrote:
>
> Nice catch.  The code that exists is confusing due to newinfo->entries
> being overwritten and then freed in the existing code path as you state
> in your commit log.
>
> * Wenwen Wang <wang6495@umn.edu> [190720 08:23]:
> > From: Wenwen Wang <wenwen@cs.uga.edu>
> >
> > In compat_do_replace(), a temporary buffer is allocated through vmalloc()
> > to hold entries copied from the user space. The buffer address is firstly
> > saved to 'newinfo->entries', and later on assigned to 'entries_tmp'. Then
> > the entries in this temporary buffer is copied to the internal kernel
> > structure through compat_copy_entries(). If this copy process fails,
> > compat_do_replace() should be terminated. However, the allocated temporary
> > buffer is not freed on this path, leading to a memory leak.
> >
> > To fix the bug, free the buffer before returning from compat_do_replace().
> >
> > Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>
> > ---
> >  net/bridge/netfilter/ebtables.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
> > index 963dfdc..fd84b48e 100644
> > --- a/net/bridge/netfilter/ebtables.c
> > +++ b/net/bridge/netfilter/ebtables.c
> > @@ -2261,8 +2261,10 @@ static int compat_do_replace(struct net *net, void __user *user,
> >       state.buf_kern_len = size64;
> >
> >       ret = compat_copy_entries(entries_tmp, tmp.entries_size, &state);
> > -     if (WARN_ON(ret < 0))
> > +     if (WARN_ON(ret < 0)) {
> > +             vfree(entries_tmp);
> >               goto out_unlock;
> > +     }
>
>
> Would it be worth adding a new goto label above out_unlock and free this
> entries_tmp?  It could then be used in previous failure path as well.

Yes, that would make the code much clearer and easier to understand.

Thanks!
Wenwen
