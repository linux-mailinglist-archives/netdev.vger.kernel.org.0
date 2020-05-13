Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C9781D22E8
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 01:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732576AbgEMXVC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 19:21:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:42132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732374AbgEMXVB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 May 2020 19:21:01 -0400
Received: from devnote2 (NE2965lan1.rev.em-net.ne.jp [210.141.244.193])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E88B0205ED;
        Wed, 13 May 2020 23:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589412060;
        bh=YDpY+oFCkFIHw2paw3aSACA9Hw6Wo+2HjdFDzhL6e38=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VY6ReKk0+WrAeE5ZcMXyCwAji3tlYNb/nbD2ggy3exjFLZEjT+0+pc5M2WrrXmQH0
         JQWCoAo25rOLn65XcG+voP2CL/K9HMF/5jLJiguZCbvKj7Ig9RkfxHptSOAPl7eg+4
         c+G4ppBlY+/44iQvxYyUGGeiJfjGc2UNIDz5ZKPs=
Date:   Thu, 14 May 2020 08:20:54 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Christoph Hellwig <hch@lst.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-parisc@vger.kernel.org,
        linux-um <linux-um@lists.infradead.org>,
        Netdev <netdev@vger.kernel.org>, bpf@vger.kernel.org,
        Linux-MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 11/18] maccess: remove strncpy_from_unsafe
Message-Id: <20200514082054.f817721ce196f134e6820644@kernel.org>
In-Reply-To: <0c1a7066-b269-9695-b94a-bb5f4f20ebd8@iogearbox.net>
References: <20200513160038.2482415-1-hch@lst.de>
        <20200513160038.2482415-12-hch@lst.de>
        <CAHk-=wj=u+nttmd1huNES2U=9nePtmk7WgR8cMLCYS8wc=rhdA@mail.gmail.com>
        <20200513192804.GA30751@lst.de>
        <0c1a7066-b269-9695-b94a-bb5f4f20ebd8@iogearbox.net>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 May 2020 00:36:28 +0200
Daniel Borkmann <daniel@iogearbox.net> wrote:

> On 5/13/20 9:28 PM, Christoph Hellwig wrote:
> > On Wed, May 13, 2020 at 12:11:27PM -0700, Linus Torvalds wrote:
> >> On Wed, May 13, 2020 at 9:01 AM Christoph Hellwig <hch@lst.de> wrote:
> >>>
> >>> +static void bpf_strncpy(char *buf, long unsafe_addr)
> >>> +{
> >>> +       buf[0] = 0;
> >>> +       if (strncpy_from_kernel_nofault(buf, (void *)unsafe_addr,
> >>> +                       BPF_STRNCPY_LEN))
> >>> +               strncpy_from_user_nofault(buf, (void __user *)unsafe_addr,
> >>> +                               BPF_STRNCPY_LEN);
> >>> +}
> >>
> >> This seems buggy when I look at it.
> >>
> >> It seems to think that strncpy_from_kernel_nofault() returns an error code.
> >>
> >> Not so, unless I missed where you changed the rules.
> > 
> > I didn't change the rules, so yes, this is wrong.
> > 
> >> Also, I do wonder if we shouldn't gate this on TASK_SIZE, and do the
> >> user trial first. On architectures where this thing is valid in the
> >> first place (ie kernel and user addresses are separate), the test for
> >> address size would allow us to avoid a pointless fault due to an
> >> invalid kernel access to user space.
> >>
> >> So I think this function should look something like
> >>
> >>    static void bpf_strncpy(char *buf, long unsafe_addr)
> >>    {
> >>            /* Try user address */
> >>            if (unsafe_addr < TASK_SIZE) {
> >>                    void __user *ptr = (void __user *)unsafe_addr;
> >>                    if (strncpy_from_user_nofault(buf, ptr, BPF_STRNCPY_LEN) >= 0)
> >>                            return;
> >>            }
> >>
> >>            /* .. fall back on trying kernel access */
> >>            buf[0] = 0;
> >>            strncpy_from_kernel_nofault(buf, (void *)unsafe_addr,
> >> BPF_STRNCPY_LEN);
> >>    }
> >>
> >> or similar. No?
> > 
> > So on say s390 TASK_SIZE_USUALLy is (-PAGE_SIZE), which means we'd alway
> > try the user copy first, which seems odd.
> > 
> > I'd really like to here from the bpf folks what the expected use case
> > is here, and if the typical argument is kernel or user memory.
> 
> It's used for both. Given this is enabled on pretty much all program types, my
> assumption would be that usage is still more often on kernel memory than user one.

For trace_kprobe.c current order (kernel -> user fallback) is preferred
because it has another function dedicated for user memory.

Thank you,

-- 
Masami Hiramatsu <mhiramat@kernel.org>
