Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E11520D3B4
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 21:13:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730094AbgF2TB0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 15:01:26 -0400
Received: from mx2.suse.de ([195.135.220.15]:48448 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728101AbgF2TBY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jun 2020 15:01:24 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 7BA11AD8D;
        Mon, 29 Jun 2020 09:44:40 +0000 (UTC)
Date:   Mon, 29 Jun 2020 11:43:50 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     rostedt@goodmis.org, sergey.senozhatsky@gmail.com,
        Linus Torvalds <torvalds@linux-foundation.org>, ast@kernel.org,
        daniel@iogearbox.net, yhs@fb.com, andriin@fb.com,
        arnaldo.melo@gmail.com, kafai@fb.com, songliubraving@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        linux@rasmusvillemoes.dk, joe@perches.com,
        andriy.shevchenko@linux.intel.com, corbet@lwn.net,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH v3 bpf-next 4/8] printk: add type-printing %pT format
 specifier which uses BTF
Message-ID: <20200629094349.GQ8444@alley>
References: <1592914031-31049-1-git-send-email-alan.maguire@oracle.com>
 <1592914031-31049-5-git-send-email-alan.maguire@oracle.com>
 <20200626101523.GM8444@alley>
 <alpine.LRH.2.21.2006261147130.417@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.21.2006261147130.417@localhost>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri 2020-06-26 12:37:19, Alan Maguire wrote:
> 
> On Fri, 26 Jun 2020, Petr Mladek wrote:
> 
> > On Tue 2020-06-23 13:07:07, Alan Maguire wrote:
> > > 
> > >         printk(KERN_INFO "%pT", BTF_PTR_TYPE(skb, struct sk_buff));
> > > 
> > >   struct sk_buff *skb = alloc_skb(64, GFP_KERNEL);
> > >   pr_info("%pT", BTF_PTR_TYPE(skb, struct sk_buff));
> > > 
> > > ...gives us:
> > > 
> > > (struct sk_buff){
> > >  .transport_header = (__u16)65535,
> > >  .mac_header = (__u16)65535,
> > >  .end = (sk_buff_data_t)192,
> > >  .head = (unsigned char *)0x000000006b71155a,
> > >  .data = (unsigned char *)0x000000006b71155a,
> > >  .truesize = (unsigned int)768,
> > >  .users = (refcount_t){
> > >   .refs = (atomic_t){
> > >    .counter = (int)1,
> > >   },
> > >  },
> > >  .extensions = (struct skb_ext *)0x00000000f486a130,
> > > }
> > > 
> > > printk output is truncated at 1024 bytes.  For cases where overflow
> > > is likely, the compact/no type names display modes may be used.
> > 
> > Hmm, this scares me:
> > 
> >    1. The long message and many lines are going to stretch printk
> >       design in another dimensions.
> > 
> >    2. vsprintf() is important for debugging the system. It has to be
> >       stable. But the btf code is too complex.
> >
> 
> Right on both points, and there's no way around that really. Representing 
> even small data structures will stretch us to or beyond the 1024 byte 
> limit.  This can be mitigated by using compact display mode and not 
> printing field names, but the output becomes hard to parse then.
>
> I think a better approach might be to start small, adding the core
> btf_show functionality to BPF, allowing consumers to use it there,
> perhaps via a custom helper.

Sounds good to me.

> In the current model bpf_trace_printk() inherits the functionality
> to display data from core printk, so a different approach would
> be needed there.

BTW: Even the trace buffer has a limitation, see BUF_MAX_DATA_SIZE
in kernel/trace/ring_buffer.c. It is internally implemented as
a list of memory pages, see the comments above RB_BUFFER_OFF
definition.

It is typically 4k. I think that you might hit this limit as well.
We had to increase per-CPU buffers used by printk() in NMI context
because 4k was not enough for some backtraces.

So, using different approach would make sense even when using trace
buffer.

> Other consumers outside of BPF
> could potentially avail of the show functionality directly via the btf_show
> functions in the future, but at least it would have one consumer at the 
> outset, and wouldn't present problems like these for printk.

Sounds good to me.

> > I would strongly prefer to keep this outside vsprintf and printk.
> > Please, invert the logic and convert it into using separate printk()
> > call for each printed line.
> > 
> 
> I think the above is in line with what you're suggesting?

Yes, as far as I understand it.

> Yep, no way round this either. I'll try a different approach. Thanks for 
> taking a look!

Uff, thanks a lot for understanding. I hope that most of the code will
be reusable in some form.

Best Regards,
Petr
