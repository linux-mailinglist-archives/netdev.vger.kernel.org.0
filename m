Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF2831D2BB3
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 11:44:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726033AbgENJoZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 05:44:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:54536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725878AbgENJoZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 May 2020 05:44:25 -0400
Received: from devnote2 (NE2965lan1.rev.em-net.ne.jp [210.141.244.193])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D6A0D20671;
        Thu, 14 May 2020 09:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589449464;
        bh=F5xzM4P9ET4yKXEBz9PLWzDD7uANZxM9kOF6Hi0Phw0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jk6aTEoiSH2Mnk1a8lmx/pG+iP7t0ZtuYeeNlaBT8nrfRmPuNI0GvacMD/IuOomjY
         pOyeQAkAAiS0iTtbNPcuvt5G/Wr3M2YGy3VFqa+2II8TrrWHG3i20uAlz3jwxVHn2J
         wzQ54xIWj0eC9lQRZeFVyATuE2gt0dSEVAB8XocA=
Date:   Thu, 14 May 2020 18:44:19 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Christoph Hellwig <hch@lst.de>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-parisc@vger.kernel.org,
        linux-um <linux-um@lists.infradead.org>,
        Netdev <netdev@vger.kernel.org>, bpf@vger.kernel.org,
        Linux-MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 11/18] maccess: remove strncpy_from_unsafe
Message-Id: <20200514184419.0fbf548ccf883c097d94573a@kernel.org>
In-Reply-To: <CAHk-=wjP8ysEZnNFi_+E1ZEFGpcbAN8kbYHrCnC93TX6XX+jEQ@mail.gmail.com>
References: <20200513160038.2482415-1-hch@lst.de>
        <20200513160038.2482415-12-hch@lst.de>
        <CAHk-=wj=u+nttmd1huNES2U=9nePtmk7WgR8cMLCYS8wc=rhdA@mail.gmail.com>
        <20200513192804.GA30751@lst.de>
        <0c1a7066-b269-9695-b94a-bb5f4f20ebd8@iogearbox.net>
        <20200514082054.f817721ce196f134e6820644@kernel.org>
        <CAHk-=wjBKGLyf1d53GwfUTZiK_XPdujwh+u2XSpD2HWRV01Afw@mail.gmail.com>
        <20200514100009.a8e6aa001f0ace5553c7904f@kernel.org>
        <CAHk-=wjP8ysEZnNFi_+E1ZEFGpcbAN8kbYHrCnC93TX6XX+jEQ@mail.gmail.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 13 May 2020 19:43:24 -0700
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Wed, May 13, 2020 at 6:00 PM Masami Hiramatsu <mhiramat@kernel.org> wrote:
> >
> > > But we should likely at least disallow it entirely on platforms where
> > > we really can't - or pick one hardcoded choice. On sparc, you really
> > > _have_ to specify one or the other.
> >
> > OK. BTW, is there any way to detect the kernel/user space overlap on
> > memory layout statically? If there, I can do it. (I don't like
> > "if (CONFIG_X86)" thing....)
> > Or, maybe we need CONFIG_ARCH_OVERLAP_ADDRESS_SPACE?
> 
> I think it would be better to have a CONFIG variable that
> architectures can just 'select' to show that they are ok with separate
> kernel and user addresses.
> 
> Because I don't think we have any way to say that right now as-is. You
> can probably come up with hacky ways to approximate it, ie something
> like
> 
>     if (TASK_SIZE_MAX > PAGE_OFFSET)
>         .... they overlap ..
> 
> which would almost work, but..

It seems TASK_SIZE_MAX is defined only on x86 and s390, what about
comparing STACK_TOP_MAX with PAGE_OFFSET ?
Anyway, I agree that the best way is introducing a CONFIG.

Thank you,

-- 
Masami Hiramatsu <mhiramat@kernel.org>
