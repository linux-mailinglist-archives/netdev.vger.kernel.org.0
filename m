Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B92E31C58F
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 03:34:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbhBPCd6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 21:33:58 -0500
Received: from mga06.intel.com ([134.134.136.31]:61034 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229497AbhBPCd6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Feb 2021 21:33:58 -0500
IronPort-SDR: 2lEnECs8kJRZR9k5g4aGZLC4emY1pnDQWBbmdf+arqwCc+dWq9exXuPCgoEX4Zy5d9/AdsXvNo
 yNoj4fr8wl5g==
X-IronPort-AV: E=McAfee;i="6000,8403,9896"; a="244271975"
X-IronPort-AV: E=Sophos;i="5.81,182,1610438400"; 
   d="scan'208";a="244271975"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2021 18:33:11 -0800
IronPort-SDR: Yp+7uw05CRDufCIBtfflNopUX8jkJ4ebbhVlZzagEwq6i7ke+1QLlgTsL1tFW/TdbDB8KHKzCZ
 gP+f68A6qtrw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,182,1610438400"; 
   d="scan'208";a="426119638"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga002.fm.intel.com with ESMTP; 15 Feb 2021 18:33:08 -0800
Date:   Tue, 16 Feb 2021 03:23:20 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        daniel@iogearbox.net, ast@kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, andrii@kernel.org,
        magnus.karlsson@intel.com, ciara.loftus@intel.com
Subject: Re: [PATCH bpf-next 1/3] libbpf: xsk: use bpf_link
Message-ID: <20210216022320.GC9572@ranger.igk.intel.com>
References: <20210215154638.4627-1-maciej.fijalkowski@intel.com>
 <20210215154638.4627-2-maciej.fijalkowski@intel.com>
 <87eehhcl9x.fsf@toke.dk>
 <fe0c957e-d212-4265-a271-ba301c3c5eca@intel.com>
 <602ad80c566ea_3ed4120871@john-XPS-13-9370.notmuch>
 <8735xxc8pf.fsf@toke.dk>
 <602b0f54c05a6_3ed41208dc@john-XPS-13-9370.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <602b0f54c05a6_3ed41208dc@john-XPS-13-9370.notmuch>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 15, 2021 at 04:18:28PM -0800, John Fastabend wrote:
> Toke Høiland-Jørgensen wrote:
> > John Fastabend <john.fastabend@gmail.com> writes:
> > 
> > >> > However, in libxdp we can solve the original problem in a different way,
> > >> > and in fact I already suggested to Magnus that we should do this (see
> > >> > [1]); so one way forward could be to address it during the merge in
> > >> > libxdp? It should be possible to address the original issue (two
> > >> > instances of xdpsock breaking each other when they exit), but
> > >> > applications will still need to do an explicit unload operation before
> > >> > exiting (i.e., the automatic detach on bpf_link fd closure will take
> > >> > more work, and likely require extending the bpf_link kernel support)...
> > >> >
> > >> 
> > >> I'd say it's depending on the libbpf 1.0/libxdp merge timeframe. If
> > >> we're months ahead, then I'd really like to see this in libbpf until the
> > >> merge. However, I'll leave that for Magnus/you to decide!
> > >
> > > Did I miss some thread? What does this mean libbpf 1.0/libxdp merge?
> > 
> > The idea is to keep libbpf focused on bpf, and move the AF_XDP stuff to
> > libxdp (so the socket stuff in xsk.h). We're adding the existing code
> > wholesale, and keeping API compatibility during the move, so all that's
> > needed is adding -lxdp when compiling. And obviously the existing libbpf
> > code isn't going anywhere until such a time as there's a general
> > backwards compatibility-breaking deprecation in libbpf (which I believe
> > Andrii is planning to do in an upcoming and as-of-yet unannounced v1.0
> > release).

Once again, is libxdp going to land in th kernel? Still not clear to me.

> 
> OK, I would like to keep the basic XDP pieces in libbpf though. For example
> bpf_program__attach_xdp(). This way we don't have one lib to attach
> everything, but XDP.
> 
> > 
> > While integrating the XSK code into libxdp we're trying to make it
> > compatible with the rest of the library (i.e., multi-prog). Hence my
> > preference to avoid introducing something that makes this harder :)

Do you see the issue with solving it one way in libbpf currently given
that we can't really tell when the merge of libs is going to happen and
the other way within the libxdp itself?

> > 
> > -Toke
> > 
> 
> OK that makes sense to me thanks. But, I'm missing something (maybe its
> obvious to everyone else?).
> 
> When you load an XDP program you should get a reference to it. And then
> XDP program should never be unloaded until that id is removed right? It

WDYM by 'that id is removed' ?

> may or may not have an xsk map. Why does adding/removing programs from

you meant adding/removing 'sockets'?

> an associated map have any impact on the XDP program? That seems like
> the buggy part to me. No other map behaves this way as far as I can
> tell. Now if the program with the XDP reference closes without pinning
> the map or otherwise doing something with it, sure the map gets destroyed
> and any xsk sockets are lost.

It's the XDP program that is getting lost, not XSKMAP. XDP prog presence
determines whether your driver works in ZC or not. If XDP prog is gone
then xdpsock bails out (or any other AF-XDP app won't be able to work).

> 
> Thanks!
> John
