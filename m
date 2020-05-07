Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7657C1C8161
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 07:12:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725905AbgEGFMS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 01:12:18 -0400
Received: from verein.lst.de ([213.95.11.211]:44501 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725783AbgEGFMR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 May 2020 01:12:17 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 990EF68B05; Thu,  7 May 2020 07:12:13 +0200 (CEST)
Date:   Thu, 7 May 2020 07:12:13 +0200
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
Message-ID: <20200507051213.GB4501@lst.de>
References: <20200506062223.30032-1-hch@lst.de> <20200506062223.30032-16-hch@lst.de> <CAHk-=wi6E5z_aKr9NX+QcEJqJvSyrDbO3ypPugxstcPV5EPSMQ@mail.gmail.com> <20200506181543.GA7873@lst.de> <CAHk-=wghKpGdTmD4EDfwX2uyppwxksU+nFyS1B--kbopcQAgwg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wghKpGdTmD4EDfwX2uyppwxksU+nFyS1B--kbopcQAgwg@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 06, 2020 at 12:01:32PM -0700, Linus Torvalds wrote:
> Oh, absolutely. I did *NOT* mean that you'd use "unsafe_get_user()" as
> the actual interface. I just meant that as an implementation detail on
> x86, using "unsafe_get_user()" instead of "__get_user_size()"
> internally both simplifies the implementation, and means that it
> doesn't clash horribly with my local changes.

I had a version that just wrapped them, but somehow wasn't able to
make it work due to all the side effects vs macros issues.  Maybe I
need to try again, the current version seemed like a nice way out
as it avoided a lot of the silly casting.


> Btw, that brings up another issue: so that people can't mis-use those
> kernel accessors and use them for user addresses, they probably should
> actually do something like
> 
>         if ((long)addr >= 0)
>                 goto error_label;
> 
> on x86. IOW, have the "strict" kernel pointer behavior.
> 
> Otherwise somebody will start using them for user pointers, and it
> will happen to work on old x86 without CLAC/STAC support.
> 
> Of course, maybe CLAC/STAC is so common these days (at least with
> developers) that we don't have to worry about it.

The actual public routines (probe_kernel_read and co) get these
checks through probe_kernel_read_allowed, which is implemented by
the x86 code.  Doing this for every 1-8 byte access might be a little
slow, though.  Do you really fear drivers starting to use the low-level
helper?  Maybe we need to move those into a different header than
<asm/uaccess.h> that makes it more clear that they are internal?

> But here you see what it is, if you want to. __get_user_size()
> technically still exists, but it has the "target branch" semantics in
> here, so your patch clashes badly with it.

The target branch semantics actually are what I want, that is how the
maccess code is structured.  This is the diff I'd need for the calling
conventions in your bundle:


diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index 765e18417b3ba..d1c8aacedade1 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -526,14 +526,8 @@ do {									\
 #define HAVE_ARCH_PROBE_KERNEL
 
 #define arch_kernel_read(dst, src, type, err_label)			\
-do {									\
-        int __kr_err;							\
-									\
 	__get_user_size(*((type *)dst), (__force type __user *)src,	\
-			sizeof(type), __kr_err);			\
-        if (unlikely(__kr_err))						\
-		goto err_label;						\
-} while (0)
+			sizeof(type), err_label);			\
 
 #define arch_kernel_write(dst, src, type, err_label)			\
 	__put_user_size(*((type *)(src)), (__force type __user *)(dst),	\
