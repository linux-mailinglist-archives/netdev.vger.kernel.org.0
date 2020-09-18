Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF47526FEE2
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 15:41:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726835AbgIRNka (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 09:40:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725955AbgIRNk1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 09:40:27 -0400
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F46CC0613CE;
        Fri, 18 Sep 2020 06:40:27 -0700 (PDT)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kJGcW-0014PO-Gq; Fri, 18 Sep 2020 13:40:12 +0000
Date:   Fri, 18 Sep 2020 14:40:12 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Arnd Bergmann <arnd@arndb.de>,
        David Howells <dhowells@redhat.com>,
        linux-arm-kernel@lists.infradead.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, sparclinux@vger.kernel.org,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
        io-uring@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-mm@kvack.org, netdev@vger.kernel.org,
        keyrings@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 1/9] kernel: add a PF_FORCE_COMPAT flag
Message-ID: <20200918134012.GY3421308@ZenIV.linux.org.uk>
References: <20200918124533.3487701-1-hch@lst.de>
 <20200918124533.3487701-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200918124533.3487701-2-hch@lst.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 18, 2020 at 02:45:25PM +0200, Christoph Hellwig wrote:
> Add a flag to force processing a syscall as a compat syscall.  This is
> required so that in_compat_syscall() works for I/O submitted by io_uring
> helper threads on behalf of compat syscalls.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  arch/sparc/include/asm/compat.h | 3 ++-
>  arch/x86/include/asm/compat.h   | 2 +-
>  fs/io_uring.c                   | 9 +++++++++
>  include/linux/compat.h          | 5 ++++-
>  include/linux/sched.h           | 1 +
>  5 files changed, 17 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/sparc/include/asm/compat.h b/arch/sparc/include/asm/compat.h
> index 40a267b3bd5208..fee6c51d36e869 100644
> --- a/arch/sparc/include/asm/compat.h
> +++ b/arch/sparc/include/asm/compat.h
> @@ -211,7 +211,8 @@ static inline int is_compat_task(void)
>  static inline bool in_compat_syscall(void)
>  {
>  	/* Vector 0x110 is LINUX_32BIT_SYSCALL_TRAP */
> -	return pt_regs_trap_type(current_pt_regs()) == 0x110;
> +	return pt_regs_trap_type(current_pt_regs()) == 0x110 ||
> +		(current->flags & PF_FORCE_COMPAT);

Can't say I like that approach ;-/  Reasoning about the behaviour is much
harder when it's controlled like that - witness set_fs() shite...
