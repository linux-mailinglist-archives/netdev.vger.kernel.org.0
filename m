Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32452189004
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 22:03:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726864AbgCQVDv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 17:03:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:38992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726801AbgCQVDu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Mar 2020 17:03:50 -0400
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4F742051A;
        Tue, 17 Mar 2020 21:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584479029;
        bh=8FbM2CA+Iyjqv4tbWq6Yzorkw4hRaPZ30XcFiumHABs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Lzl4qzfNC1dlfs6kF+VNezyoJwwfPTY+gUHRa8+ry2MsM0m96IpQPoj2koKxWYimt
         UB0Z8z2mZAKfkKUpB3HwpeNidnK7753U0MHLT2hOIYoSr1P3PXz6o+FUvnNR5SeMGo
         oXoWTS2gWyiIjkZ/6nue61sPx/dTovSq6VErsP24=
Date:   Tue, 17 Mar 2020 21:03:44 +0000
From:   Will Deacon <will@kernel.org>
To:     =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        bpf <bpf@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>, mark.rutland@arm.com
Subject: Re: [PATCH bpf-next] xsk: update rings for
 load-acquire/store-release semantics
Message-ID: <20200317210344.GB19752@willie-the-truck>
References: <20200120092149.13775-1-bjorn.topel@gmail.com>
 <28b2b6ba-7f43-6cab-9b3a-174fc71d5a62@iogearbox.net>
 <CAJ+HfNj6dWLgODuHN82H5pXZgzYjx3cLi5WvGSoMg57TgYuRbg@mail.gmail.com>
 <20200316184423.GA14143@willie-the-truck>
 <CAJ+HfNh=XuCU3QBSbJZ-qEj-fx+JrB_iiJGpqKQmOwEjvAROpg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJ+HfNh=XuCU3QBSbJZ-qEj-fx+JrB_iiJGpqKQmOwEjvAROpg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 17, 2020 at 08:14:09PM +0100, Björn Töpel wrote:
> On Mon, 16 Mar 2020 at 19:44, Will Deacon <will@kernel.org> wrote:
> >
> > On Tue, Jan 21, 2020 at 12:50:23PM +0100, Björn Töpel wrote:
> > > On Tue, 21 Jan 2020 at 00:51, Daniel Borkmann <daniel@iogearbox.net> wrote:
> > > >
> > > > On 1/20/20 10:21 AM, Björn Töpel wrote:
> > > > > From: Björn Töpel <bjorn.topel@intel.com>
> > > > >
> > > > > Currently, the AF_XDP rings uses fences for the kernel-side
> > > > > produce/consume functions. By updating rings for
> > > > > load-acquire/store-release semantics, the full barrier (smp_mb()) on
> > > > > the consumer side can be replaced.
> > > > >
> > > > > Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
> > > >
> > > > If I'm not missing something from the ring update scheme, don't you also need
> > > > to adapt to STORE.rel ->producer with matching barrier in tools/lib/bpf/xsk.h ?
> > > >
> > >
> > > Daniel/John,
> > >
> > > Hmm, I was under the impression that *wasn't* the case. Quoting
> > > memory-barriers.txt:
> > >
> > > --8<--
> > > When dealing with CPU-CPU interactions, certain types of memory
> > > barrier should always be paired.  A lack of appropriate pairing is
> > > almost certainly an error.
> > >
> > > General barriers pair with each other, though they also pair with most
> > > other types of barriers, albeit without multicopy atomicity.  An
> > > acquire barrier pairs with a release barrier, but both may also pair
> > > with other barriers, including of course general barriers.  A write
> > > barrier pairs with a data dependency barrier, a control dependency, an
> > > acquire barrier, a release barrier, a read barrier, or a general
> > > barrier.  Similarly a read barrier, control dependency, or a data
> > > dependency barrier pairs with a write barrier, an acquire barrier, a
> > > release barrier, or a general barrier:
> > > -->8--
> >
> > The key part here is "albeit without multicopy atomicity". I don't think
> > you care about that at all for these rings as you're very clearly passing a
> > message from the producer side to the consumer side in a point-to-point like
> > manner, so I think you're ok to change the kernel independently from
> > userspace (but I would still recommend updating both eventually).
> >
> > The only thing you might run into is if anybody is relying on the smp_mb()
> > in the consumer to order other unrelated stuff either side of the consume
> > operation (or even another consume operation to a different ring!), but it
> > looks like you can't rely on that in the xsk queue implementation anyway
> > because you cache the global state and so the barriers are conditional.
> >
> 
> Thanks for getting back, and for the clarification! I'll do a respin
> (as part of a another series) that include the userland changes.

I'm just sorry it took me so long. I got tied up with personal stuff,
then conferences and finally, when it got to the top of my list, I took
some holiday.

Will
