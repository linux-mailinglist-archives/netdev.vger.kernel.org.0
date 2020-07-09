Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C6F021A04D
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 14:54:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726856AbgGIMyi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 08:54:38 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35142 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726347AbgGIMyi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 08:54:38 -0400
Received: from ip5f5af08c.dynamic.kabel-deutschland.de ([95.90.240.140] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1jtW4O-000809-VS; Thu, 09 Jul 2020 12:54:33 +0000
Date:   Thu, 9 Jul 2020 14:54:31 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Kees Cook <keescook@chromium.org>
Cc:     Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org,
        Sargun Dhillon <sargun@sargun.me>,
        Christian Brauner <christian@brauner.io>,
        Tycho Andersen <tycho@tycho.ws>,
        David Laight <David.Laight@ACULAB.COM>,
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
Subject: Re: [PATCH v6 4/7] pidfd: Replace open-coded partial receive_fd()
Message-ID: <20200709125431.4zsxxsyxfe6aq3ar@wittgenstein>
References: <20200706201720.3482959-1-keescook@chromium.org>
 <20200706201720.3482959-5-keescook@chromium.org>
 <20200707122220.cazzek4655gj4tj7@wittgenstein>
 <202007082330.6B423FE@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <202007082330.6B423FE@keescook>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 08, 2020 at 11:35:39PM -0700, Kees Cook wrote:
> On Tue, Jul 07, 2020 at 02:22:20PM +0200, Christian Brauner wrote:
> > So while the patch is correct it leaves 5.6 and 5.7 with a bug in the
> > pidfd_getfd() implementation and that just doesn't seem right. I'm
> > wondering whether we should introduce:
> > 
> > void sock_update(struct file *file)
> > {
> > 	struct socket *sock;
> > 	int error;
> > 
> > 	sock = sock_from_file(file, &error);
> > 	if (sock) {
> > 		sock_update_netprioidx(&sock->sk->sk_cgrp_data);
> > 		sock_update_classid(&sock->sk->sk_cgrp_data);
> > 	}
> > }
> > 
> > and switch pidfd_getfd() over to:
> > 
> > diff --git a/kernel/pid.c b/kernel/pid.c
> > index f1496b757162..c26bba822be3 100644
> > --- a/kernel/pid.c
> > +++ b/kernel/pid.c
> > @@ -642,10 +642,12 @@ static int pidfd_getfd(struct pid *pid, int fd)
> >         }
> > 
> >         ret = get_unused_fd_flags(O_CLOEXEC);
> > -       if (ret < 0)
> > +       if (ret < 0) {
> >                 fput(file);
> > -       else
> > +       } else {
> > +               sock_update(file);
> >                 fd_install(ret, file);
> > +       }
> > 
> >         return ret;
> >  }
> > 
> > first thing in the series and then all of the other patches on top of it
> > so that we can Cc stable for this and that can get it backported to 5.6,
> > 5.7, and 5.8.
> > 
> > Alternatively, I can make this a separate bugfix patch series which I'll
> > send upstream soonish. Or we have specific patches just for 5.6, 5.7,
> > and 5.8. Thoughts?
> 
> Okay, I looked at hch's clean-ups again and I'm reminded why they
> don't make great -stable material. :) The compat bug (also missing the
> sock_update()) needs a similar fix (going back to 3.6...), so, yeah,
> for ease of backport, probably an explicit sock_update() implementation
> (with compat and native scm using it), and a second patch for pidfd.
> 
> Let me see what I looks best...

Yeah, it'd be quite some code. I've written some patches for this before
I sent this mail, just so you know. We likely need a 5.6 and 5.7 patch
and a 5.8 patch after Christoph's changes. The 5.8 fixes I'd like to get
in during this merge window. So either I can do this or you can send me
the patches for this?

Christian
