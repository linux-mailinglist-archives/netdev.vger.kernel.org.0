Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61BAB1D9C27
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 18:14:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729223AbgESQOW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 12:14:22 -0400
Received: from verein.lst.de ([213.95.11.211]:44769 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728534AbgESQOW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 May 2020 12:14:22 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 1F99968B02; Tue, 19 May 2020 18:14:19 +0200 (CEST)
Date:   Tue, 19 May 2020 18:14:18 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Christoph Hellwig <hch@lst.de>,
        the arch/x86 maintainers <x86@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-parisc@vger.kernel.org,
        linux-um <linux-um@lists.infradead.org>,
        Netdev <netdev@vger.kernel.org>, bpf@vger.kernel.org,
        Linux-MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 11/20] bpf: factor out a bpf_trace_copy_string helper
Message-ID: <20200519161418.GA26545@lst.de>
References: <20200519134449.1466624-1-hch@lst.de> <20200519134449.1466624-12-hch@lst.de> <CAHk-=wjm3HQy_awVX-WyF6KrSuE1pcFRaNX_XhiLKkBUFUZBtQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wjm3HQy_awVX-WyF6KrSuE1pcFRaNX_XhiLKkBUFUZBtQ@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 19, 2020 at 09:07:55AM -0700, Linus Torvalds wrote:
> On Tue, May 19, 2020 at 6:45 AM Christoph Hellwig <hch@lst.de> wrote:
> >
> > +       switch (fmt_ptype) {
> > +       case 's':
> > +#ifdef CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
> > +               strncpy_from_unsafe(buf, unsafe_ptr, bufsz);
> > +               break;
> > +#endif
> > +       case 'k':
> > +               strncpy_from_kernel_nofault(buf, unsafe_ptr, bufsz);
> > +               break;
> 
> That 's' case needs a "fallthrough;" for the overlapping case,
> methinks. Otherwise you'll get warnings.

I don't think we need it as the case of

	case 'a':
	case 'b':
		do_stuff();
		break;

has always been fine even with the fallthough warnings.  And the
rest of the stuff gets removed by cpp..
