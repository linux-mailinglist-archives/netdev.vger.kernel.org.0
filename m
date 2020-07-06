Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58692215BFF
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 18:38:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729653AbgGFQih (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 12:38:37 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34443 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729591AbgGFQig (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 12:38:36 -0400
Received: from ip5f5af08c.dynamic.kabel-deutschland.de ([95.90.240.140] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1jsU8V-0001E8-OP; Mon, 06 Jul 2020 16:38:31 +0000
Date:   Mon, 6 Jul 2020 18:38:30 +0200
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
Message-ID: <20200706163830.fyf64otz5bpubm3v@wittgenstein>
References: <20200617220327.3731559-1-keescook@chromium.org>
 <20200617220327.3731559-5-keescook@chromium.org>
 <20200706130713.n6r3vhn4hn2lodex@wittgenstein>
 <202007060830.0FE753B@keescook>
 <20200706161245.hjat2rsikt3linbm@wittgenstein>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200706161245.hjat2rsikt3linbm@wittgenstein>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 06, 2020 at 06:12:47PM +0200, Christian Brauner wrote:
> On Mon, Jul 06, 2020 at 08:34:06AM -0700, Kees Cook wrote:
> > On Mon, Jul 06, 2020 at 03:07:13PM +0200, Christian Brauner wrote:
> > > On Wed, Jun 17, 2020 at 03:03:24PM -0700, Kees Cook wrote:
> > > > The sock counting (sock_update_netprioidx() and sock_update_classid()) was
> > > > missing from pidfd's implementation of received fd installation. Replace
> > > > the open-coded version with a call to the new fd_install_received()
> > > > helper.
> > > > 
> > > > Fixes: 8649c322f75c ("pid: Implement pidfd_getfd syscall")
> > > > Signed-off-by: Kees Cook <keescook@chromium.org>
> > > > ---
> > > >  kernel/pid.c | 11 +----------
> > > >  1 file changed, 1 insertion(+), 10 deletions(-)
> > > > 
> > > > diff --git a/kernel/pid.c b/kernel/pid.c
> > > > index f1496b757162..24924ec5df0e 100644
> > > > --- a/kernel/pid.c
> > > > +++ b/kernel/pid.c
> > > > @@ -635,18 +635,9 @@ static int pidfd_getfd(struct pid *pid, int fd)
> > > >  	if (IS_ERR(file))
> > > >  		return PTR_ERR(file);
> > > >  
> > > > -	ret = security_file_receive(file);
> > > > -	if (ret) {
> > > > -		fput(file);
> > > > -		return ret;
> > > > -	}
> > > > -
> > > > -	ret = get_unused_fd_flags(O_CLOEXEC);
> > > > +	ret = fd_install_received(file, O_CLOEXEC);
> > > >  	if (ret < 0)
> > > >  		fput(file);
> > > > -	else
> > > > -		fd_install(ret, file);
> > > 
> > > So someone just sent a fix for pidfd_getfd() that was based on the
> > > changes done here.
> > 
> > Hi! Ah yes, that didn't get CCed to me. I'll go reply.
> > 
> > > I've been on vacation so didn't have a change to review this series and
> > > I see it's already in linux-next. This introduces a memory leak and
> > > actually proves a point I tried to stress when adding this helper:
> > > fd_install_received() in contrast to fd_install() does _not_ consume a
> > > reference because it takes one before it calls into fd_install(). That
> > > means, you need an unconditional fput() here both in the failure and
> > > error path.
> > 
> > Yup, this was a mistake in my refactoring of the pidfs changes.
> 
> I already did.
> 
> > 
> > > I strongly suggest though that we simply align the behavior between
> > > fd_install() and fd_install_received() and have the latter simply
> > > consume a reference when it succeeds! Imho, this bug proves that I was
> > > right to insist on this before. ;)
> > 
> > I still don't agree: it radically complicates the SCM_RIGHTS and seccomp
> 
> I'm sorry, I don't buy it yet, though I might've missed something in the
> discussions: :)
> After applying the patches in your series this literally is just (which
> is hardly radical ;):
> 
> diff --git a/fs/file.c b/fs/file.c
> index 9568bcfd1f44..26930b2ea39d 100644
> --- a/fs/file.c
> +++ b/fs/file.c
> @@ -974,7 +974,7 @@ int __fd_install_received(int fd, struct file *file, int __user *ufd,
>         }
> 
>         if (fd < 0)
> -               fd_install(new_fd, get_file(file));
> +               fd_install(new_fd, file);
>         else {
>                 new_fd = fd;
>                 error = replace_fd(new_fd, file, o_flags);
> diff --git a/net/compat.c b/net/compat.c
> index 71494337cca7..605a5a67200c 100644
> --- a/net/compat.c
> +++ b/net/compat.c
> @@ -298,9 +298,11 @@ void scm_detach_fds_compat(struct msghdr *msg, struct scm_cookie *scm)
>         int err = 0, i;
> 
>         for (i = 0; i < fdmax; i++) {
> -               err = fd_install_received_user(scm->fp->fp[i], cmsg_data + i, o_flags);
> -               if (err < 0)
> +               err = fd_install_received_user(get_file(scm->fp->fp[i]), cmsg_data + i, o_flags);
> +               if (err < 0) {
> +                       fput(scm->fp->fp[i]);
>                         break;
> +               }
>         }
> 
>         if (i > 0) {
> diff --git a/net/core/scm.c b/net/core/scm.c
> index b9a0442ebd26..0d06446ae598 100644
> --- a/net/core/scm.c
> +++ b/net/core/scm.c
> @@ -306,9 +306,11 @@ void scm_detach_fds(struct msghdr *msg, struct scm_cookie *scm)
>         }
> 
>         for (i = 0; i < fdmax; i++) {
> -               err = fd_install_received_user(scm->fp->fp[i], cmsg_data + i, o_flags);
> -               if (err < 0)
> +               err = fd_install_received_user(get_file(scm->fp->fp[i]), cmsg_data + i, o_flags);
> +               if (err < 0) {
> +                       fput(scm->fp->fp[i]);
>                         break;
> +               }
>         }
> 
>         if (i > 0) {
> 
> > cases. The primary difference is that fd_install() cannot fail, and it
> > was optimized for this situation. The other file-related helpers that
> > can fail do not consume the reference, so this is in keeping with those
> > as well.
> 
> That's not a real problem. Any function that can fail and which consumes
> a reference on success is assumed to not mutate the reference if it
> fails anywhere. So I don't see that as an issue.
> 
> The problem here is that the current patch invites bugs and has already
> produced one because fd_install() and fd_install_*() have the same
> naming scheme but different behavior when dealing with references.
> That's just not a good idea.

That being said, if you and others feel that this worry is nonsense then
sure let's fix the bug that this introduces in this series and move on.
If you do are you going to resend?

Christian
