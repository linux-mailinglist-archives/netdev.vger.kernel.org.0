Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 809623A86DC
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 18:50:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbhFOQwG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 12:52:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:41514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229528AbhFOQwG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Jun 2021 12:52:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E14FB6191C;
        Tue, 15 Jun 2021 16:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623775801;
        bh=VM1U0u+TWCNs6rr3AWIbcRK6P6q6JzW5E3iJdzlDDlE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Jlr7nfaPM4OETwVu0dM49jvAP1GSkttj4O5pJzov/F/H+a1LrQ6p4dyHzmEfLb6K0
         6ifF7u9O87KZ04qNEVihFJAsy0haZFF+rbt7CU8Ralzup25e+KHBCdw31GwYOeN9h/
         dVni5lSr9yWXFbM+8Lx3IBNuazZ3/Ns29mvpsJrHkNuGhnTd9KeVVH5K+rZ8fdpTCL
         BfnPU1Xtj+n4LZUN89ThTRlOqlqU9hH+ExHyBrJB3ix7HTGrjC2OEfTVC78aUwEHWY
         vhMzUyl0yjS4bBJU1uRGBC4me8xYMoUobPEoGmEKinca++aaEFpdGC3TK30D8upQfm
         yJ0ekKA3doGXg==
Date:   Tue, 15 Jun 2021 19:49:57 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Kees Cook <keescook@chromium.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Andrea Righi <andrea.righi@canonical.com>,
        stable <stable@vger.kernel.org>,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: NetworkManager fails to start
Message-ID: <YMjaNQGAHhh9Zpg8@unreal>
References: <YMjTlp2FSJYvoyFa@unreal>
 <CAHk-=wiucGtZQHpyfm5bK1xp9vepu9dA_OBE-A1-Gr=Neo8b2Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wiucGtZQHpyfm5bK1xp9vepu9dA_OBE-A1-Gr=Neo8b2Q@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 15, 2021 at 09:26:19AM -0700, Linus Torvalds wrote:
> On Tue, Jun 15, 2021 at 9:21 AM Leon Romanovsky <leon@kernel.org> wrote:
> >
> > The commit 591a22c14d3f ("proc: Track /proc/$pid/attr/ opener mm_struct")
> > that we got in v5.13-rc6 broke our regression to pieces. The NIC interfaces
> > fail to start when using NetworkManager.
> 
> Does the attached patch fix it?

I pushed it for testing, will update shortly.

Thanks

> 
> It just makes the open always succeed, and then the private_data that
> the open did (that may or may not then have been filled in) is only
> used on write.
> 
>                Linus

>  fs/proc/base.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index 7118ebe38fa6..9cbd915025ad 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -2676,7 +2676,9 @@ static int proc_pident_readdir(struct file *file, struct dir_context *ctx,
>  #ifdef CONFIG_SECURITY
>  static int proc_pid_attr_open(struct inode *inode, struct file *file)
>  {
> -	return __mem_open(inode, file, PTRACE_MODE_READ_FSCREDS);
> +	file->private_data = NULL;
> +	__mem_open(inode, file, PTRACE_MODE_READ_FSCREDS);
> +	return 0;
>  }
>  
>  static ssize_t proc_pid_attr_read(struct file * file, char __user * buf,

