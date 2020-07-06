Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB529215802
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 15:07:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729251AbgGFNHV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 09:07:21 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55535 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728940AbgGFNHT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 09:07:19 -0400
Received: from ip5f5af08c.dynamic.kabel-deutschland.de ([95.90.240.140] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1jsQq3-0006Z1-3m; Mon, 06 Jul 2020 13:07:15 +0000
Date:   Mon, 6 Jul 2020 15:07:13 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Kees Cook <keescook@chromium.org>
Cc:     linux-kernel@vger.kernel.org, Sargun Dhillon <sargun@sargun.me>,
        Christian Brauner <christian@brauner.io>,
        Tycho Andersen <tycho@tycho.ws>,
        David Laight <David.Laight@ACULAB.COM>,
        Christoph Hellwig <hch@lst.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Aleksa Sarai <cyphar@cyphar.com>,
        Matt Denton <mpdenton@google.com>,
        Jann Horn <jannh@google.com>, Chris Palmer <palmer@google.com>,
        Robert Sesek <rsesek@google.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Will Drewry <wad@chromium.org>, Shuah Khan <shuah@kernel.org>,
        netdev@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v5 4/7] pidfd: Replace open-coded partial
 fd_install_received()
Message-ID: <20200706130713.n6r3vhn4hn2lodex@wittgenstein>
References: <20200617220327.3731559-1-keescook@chromium.org>
 <20200617220327.3731559-5-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200617220327.3731559-5-keescook@chromium.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 17, 2020 at 03:03:24PM -0700, Kees Cook wrote:
> The sock counting (sock_update_netprioidx() and sock_update_classid()) was
> missing from pidfd's implementation of received fd installation. Replace
> the open-coded version with a call to the new fd_install_received()
> helper.
> 
> Fixes: 8649c322f75c ("pid: Implement pidfd_getfd syscall")
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  kernel/pid.c | 11 +----------
>  1 file changed, 1 insertion(+), 10 deletions(-)
> 
> diff --git a/kernel/pid.c b/kernel/pid.c
> index f1496b757162..24924ec5df0e 100644
> --- a/kernel/pid.c
> +++ b/kernel/pid.c
> @@ -635,18 +635,9 @@ static int pidfd_getfd(struct pid *pid, int fd)
>  	if (IS_ERR(file))
>  		return PTR_ERR(file);
>  
> -	ret = security_file_receive(file);
> -	if (ret) {
> -		fput(file);
> -		return ret;
> -	}
> -
> -	ret = get_unused_fd_flags(O_CLOEXEC);
> +	ret = fd_install_received(file, O_CLOEXEC);
>  	if (ret < 0)
>  		fput(file);
> -	else
> -		fd_install(ret, file);

So someone just sent a fix for pidfd_getfd() that was based on the
changes done here.

I've been on vacation so didn't have a change to review this series and
I see it's already in linux-next. This introduces a memory leak and
actually proves a point I tried to stress when adding this helper:
fd_install_received() in contrast to fd_install() does _not_ consume a
reference because it takes one before it calls into fd_install(). That
means, you need an unconditional fput() here both in the failure and
error path.
I strongly suggest though that we simply align the behavior between
fd_install() and fd_install_received() and have the latter simply
consume a reference when it succeeds! Imho, this bug proves that I was
right to insist on this before. ;)

Thanks!
Christian
