Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 452351D1FB9
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 21:55:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390750AbgEMTzA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 15:55:00 -0400
Received: from verein.lst.de ([213.95.11.211]:48422 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732218AbgEMTzA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 May 2020 15:55:00 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 2D25668B05; Wed, 13 May 2020 21:54:57 +0200 (CEST)
Date:   Wed, 13 May 2020 21:54:56 +0200
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
Subject: Re: [PATCH 14/18] maccess: allow architectures to provide kernel
 probing directly
Message-ID: <20200513195456.GA31096@lst.de>
References: <20200513160038.2482415-1-hch@lst.de> <20200513160038.2482415-15-hch@lst.de> <CAHk-=wgzXqgYQQt2NCdZTtxLmV1FV1nbZ_gKw0O_mRkXZj57zg@mail.gmail.com> <20200513194003.GA31028@lst.de> <CAHk-=whtGLxezkdMP6+859LFDgb++6dgYa6Vrc=zJ9+GB7UMFQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=whtGLxezkdMP6+859LFDgb++6dgYa6Vrc=zJ9+GB7UMFQ@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 13, 2020 at 12:48:54PM -0700, Linus Torvalds wrote:
> Looking at the current users of "probe_kernel_read()", it looks like
> it's almost mostly things that just want a single byte or word.
> 
> It's not 100% that: we definitely do several things that want the
> "copy" semantics vs the "get" semantics: on the x86 side we have
> CALL_INSN_SIZE and MAX_INSN_SIZE, and the ldttss_desc.
> 
> But the bulk of them do seem to be a single value.
> 
> I don't know if performance really matters here, but to me the whole
> "most users seem to want to read a single value" is what makes me
> think that maybe that should be the primary model, rather than have
> the copy model be the primary one and then we implement the single
> value case (badly) with a copy.
> 
> It probably doesn't matter that much. I certainly wouldn't hold this
> series up over it - it can be a future thing.

I can make the get_kernel_nofault implementation suck a little less :)

Note that the arch helper (we could call it unsafe_get_kernel_nofault)
we still need to have a pagefault_disable / pagefault_enable pair
around the calls.  So maybe keep the get_kernel_nofault interface
as-is (without the goto label), and prepare the arch helpers for
being used similar to unsafe_get_user once all architectures are
converted.  And I can throw in a few patches to convert callers
from the copy semantics to the get semantics.
