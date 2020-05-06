Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA4EB1C7924
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 20:16:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730414AbgEFSPr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 14:15:47 -0400
Received: from verein.lst.de ([213.95.11.211]:42418 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729477AbgEFSPr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 May 2020 14:15:47 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id E9BF768C7B; Wed,  6 May 2020 20:15:43 +0200 (CEST)
Date:   Wed, 6 May 2020 20:15:43 +0200
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
Subject: Re: [PATCH 15/15] x86: use non-set_fs based maccess routines
Message-ID: <20200506181543.GA7873@lst.de>
References: <20200506062223.30032-1-hch@lst.de> <20200506062223.30032-16-hch@lst.de> <CAHk-=wi6E5z_aKr9NX+QcEJqJvSyrDbO3ypPugxstcPV5EPSMQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wi6E5z_aKr9NX+QcEJqJvSyrDbO3ypPugxstcPV5EPSMQ@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 06, 2020 at 10:51:51AM -0700, Linus Torvalds wrote:
> My private tree no longer has those __get/put_user_size() things,
> because "unsafe_get/put_user()" is the only thing that remains with my
> conversion to asm goto.
> 
> And we're actively trying to get rid of the whole __get_user() mess.
> Admittedly "__get_user_size()" is just the internal helper that
> doesn't have the problem, but it really is an internal helper for a
> legacy operation, and the new op that uses it is that
> "unsafe_get_user()".
> 
> Also, because you use __get_user_size(), you then have to duplicate
> the error handling logic that we already have in unsafe_get_user().
> 
> IOW - is there some reason why you didn't just make these use
> "unsafe_get/put_user()" directly, and avoid both of those issues?

That was the first prototype, and or x86 it works great, just the
__user cases in maccess.c are a little ugly.  And they point to
the real problem - for architectures like sparc and s390 that use
an entirely separate address space for the kernel vs userspace
I dont think just use unsafe_{get,put}_user will work, as they need
different instructions.

Btw, where is you magic private tree and what is the plan for it?
