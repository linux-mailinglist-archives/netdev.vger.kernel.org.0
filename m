Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DFA7155FD2
	for <lists+netdev@lfdr.de>; Fri,  7 Feb 2020 21:41:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727392AbgBGUlt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Feb 2020 15:41:49 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:43235 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726947AbgBGUlt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Feb 2020 15:41:49 -0500
Received: by mail-wr1-f68.google.com with SMTP id z9so420058wrs.10;
        Fri, 07 Feb 2020 12:41:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=amtnYZDIodDtymgnnHHYpf6Z2v42o4sNsPms+JV379g=;
        b=c9WsLsAuykRWxW7+FhitSQnnPVss4cV4Qg4MqYEQ0ITozOH6FZjYsRi4TBr5QNFhA6
         y3hh5mrYST3tiQ5XN7miZbXHNiNbL2/4NZe2zNlrW3OLZYsxbtb/A4n4XvCaI1CYz3HL
         ls+3dhPQkpklzY7IPaGjE3asQBO8b4uFJx3A975XQRkd2o5o3jnVyQADdZj5HBZdhG5v
         72Dm86jm4hCwdzBEAH7go53a7XTwNrzS1FJhn3DFaMcxJO1sVJLT8wi43iRi+Snk3G84
         WbQaACEJnlDC8vCg6hB0AH7u09i4/wetmAqaBn16t4pfggo7hoExszyDUPdB0lRfwRP5
         eS3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=amtnYZDIodDtymgnnHHYpf6Z2v42o4sNsPms+JV379g=;
        b=pH5Tma00z4mcCWPgy1buA7bWBs6GSKjrB8Ki2Y603qyOu2qaOH4zl4o9vDjFiyZcsE
         9OC2iKONx7pjoOfMZn6K8NxagbtKveVaVLwNdrvEKAwyH34OLKpy0SIkq4oFu2bvDvyt
         b5JGN8v/OiuVPSreWkfJoRSUzvczEi6CJou1UkkWvC80/G7zoYfULIgJ2Lkr/MbIslem
         bnps7det2nzQgdT01ynbHwWLFP1vp/1qnq+zpqS+tnvhwKvTcEi0WTS41VlVV1R3yP2K
         NBrFsTRIG5nVNaldt1VZScQjiPdWnE6TQiXdvmIp8hEuDq+hs3njzNi1efwPRQGF1RRX
         rFPg==
X-Gm-Message-State: APjAAAXbmESXwSktcTizMW7C0EV2H3NVNPfJ2imePHlI8r/0Kgtpstvx
        PXr9pFKIgzlclsmWemK8YOY=
X-Google-Smtp-Source: APXvYqw68bKRM2th+f0utmDsBXIx+7dzBMUrBJ9SlzjtfxD80yRf+BhLYTicJuUVDtARGub91iM8IA==
X-Received: by 2002:a5d:474d:: with SMTP id o13mr763917wrs.309.1581108106171;
        Fri, 07 Feb 2020 12:41:46 -0800 (PST)
Received: from ltop.local ([2a02:a03f:4017:df00:527:d70f:e855:bf1])
        by smtp.gmail.com with ESMTPSA id y17sm4767743wrs.82.2020.02.07.12.41.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Feb 2020 12:41:45 -0800 (PST)
Date:   Fri, 7 Feb 2020 21:41:44 +0100
From:   Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, bpf@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>, kernel-team@fb.com,
        Linux-Sparse <linux-sparse@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH bpf] bpf: Improve bucket_log calculation logic
Message-ID: <20200207204144.hh4n4o643oqpcwed@ltop.local>
References: <20200207081810.3918919-1-kafai@fb.com>
 <CAHk-=wieADOQcYkehVN7meevnd3jZrq06NkmyH9GGR==2rEpuQ@mail.gmail.com>
 <CAHk-=wjbhawNieeiEig4LnPVRTRPgY8xag7NuAKuM9NKXCTLeQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wjbhawNieeiEig4LnPVRTRPgY8xag7NuAKuM9NKXCTLeQ@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 07, 2020 at 11:39:24AM -0800, Linus Torvalds wrote:
> On Fri, Feb 7, 2020 at 10:07 AM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > I do think this is a good test-case for sparse. Luc, have you looked
> > at what it is that then makes sparse use *so* much memory for this one
> > line?
> 
> Looking at the profile, it's doing a lot of "copy_expression()".
> 
> Which comes from inlining.
> 
> I think the problem may be that with that macro expansion from hell we
> end up with 28968 copies of cpumask_weight(), and sparse will inline
> every one of them into the parse tree - even though basically none of
> them are _used_.

Yes, indeed. I was just what I saw too.

> In fact, it's worse than that: we end up having a few rounds of
> inlining thanks to

<snip> 

> So we may have "only" 28968 calls to cpumask_weight(), but it results
> in millions of expressions being expanded.

Yes, roughly 1500 expressions per call (:
 
> If we did some basic simplification of constant ops before inlining,
> that would likely help a lot.
> 
> But currently sparse does inline function expansion at type evaluation
> time - so long before it does any simplification of the tree at all.
> 
> So that explains why sparse happens to react _so_ badly to this thing.
> A real compiler would do inlining much later.
> 
> Inlining that early is partly because originally one of the design
> ideas in sparse was to make inline functions act basically as
> templates, so they'd react to the types of the context. But it really
> bites us in the ass here.
> 
> Luc, any ideas? Yes, this is solvable in the kernel, but it does show
> that sparse simply does a _lot_ of unnecessary work.

I never saw it so badly but it's not the first time I've bitten by
the very early inlining. Independently of this, it would be handy to
have an inliner at IR level, it shouldn't be very difficult but ...
OTOH, it should really be straightforward would be to separate the
current tree inliner from the type evaluation and instead run it just
after expansion. The downsides would be:
  * the tree would need to be walked once more;
  * this may make the expansion less useful but it could be run again
    after the inlining.

[ If we would like to keep inline-as-template it would just need to be
  able to detect such inlines at type evaluation and only inline those. ]

I'll look more closely at all of it during the WE.

-- Luc
