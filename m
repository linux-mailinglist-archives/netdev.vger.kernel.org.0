Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B7FC6BE537
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 10:14:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231253AbjCQJOe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 05:14:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230177AbjCQJOc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 05:14:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22DF21024D;
        Fri, 17 Mar 2023 02:14:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9F52FB8254C;
        Fri, 17 Mar 2023 09:13:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FC51C433D2;
        Fri, 17 Mar 2023 09:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679044428;
        bh=YV1j7F9lPdJujt2JHf0YnDDPqWKhPE5o3Tdae3oc+jY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GDgQqklqROvQYMbZ6hd5xs+pDOyGsIDD3wWLuZ4rHBYRoybZ0Tf1KBJ8pqYr8Oe9I
         ySIlHxx0h3E4ZIpQO2NirEQnvRBWNcFvLEmomxlKK2gemK1CCeg6yn9G/Ld+QeyE/e
         L7C/w690oxfOTA9ABrf6UxaIfNCQBMZlIcHGwfvinvJShDU9NOCSMI0jYzrnaQyhdH
         ZX4IwPE02EVCHqMI9UWMNWer27lP3kftVDLLXeBqyXeMSatyGnRGhuOldnSxhgk+Vk
         DUEH3XWW6qRACN/pObDWzPUBe9nJZYL+8FtUAyyTBw/mSA7Z5zwW+YHe3VZPSUc+bl
         a/76DHTARdO+A==
Date:   Fri, 17 Mar 2023 10:13:36 +0100
From:   Christian Brauner <brauner@kernel.org>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     aleksandr.mikhalitsyn@canonical.com, arnd@arndb.de,
        davem@davemloft.net, dsahern@kernel.org, edumazet@google.com,
        keescook@chromium.org, kuba@kernel.org, leon@kernel.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com
Subject: Re: [PATCH net-next 1/3] scm: add SO_PASSPIDFD and SCM_PIDFD
Message-ID: <20230317091336.vzxquodjybgo4nhv@wittgenstein>
References: <20230316131526.283569-2-aleksandr.mikhalitsyn@canonical.com>
 <20230317055320.32371-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230317055320.32371-1-kuniyu@amazon.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 16, 2023 at 10:53:20PM -0700, Kuniyuki Iwashima wrote:
> From:   Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
> Date:   Thu, 16 Mar 2023 14:15:24 +0100
> > Implement SCM_PIDFD, a new type of CMSG type analogical to SCM_CREDENTIALS,
> > but it contains pidfd instead of plain pid, which allows programmers not
> > to care about PID reuse problem.
> > 
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: Eric Dumazet <edumazet@google.com>
> > Cc: Jakub Kicinski <kuba@kernel.org>
> > Cc: Paolo Abeni <pabeni@redhat.com>
> > Cc: Leon Romanovsky <leon@kernel.org>
> > Cc: David Ahern <dsahern@kernel.org>
> > Cc: Arnd Bergmann <arnd@arndb.de>
> > Cc: Kees Cook <keescook@chromium.org>
> > Cc: Christian Brauner <brauner@kernel.org>
> > Cc: linux-kernel@vger.kernel.org
> > Cc: netdev@vger.kernel.org
> > Cc: linux-arch@vger.kernel.org
> > Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
> > ---
> >  arch/alpha/include/uapi/asm/socket.h    |  2 ++
> >  arch/mips/include/uapi/asm/socket.h     |  2 ++
> >  arch/parisc/include/uapi/asm/socket.h   |  2 ++
> >  arch/sparc/include/uapi/asm/socket.h    |  2 ++
> >  include/linux/net.h                     |  1 +
> >  include/linux/socket.h                  |  1 +
> >  include/net/scm.h                       | 16 +++++++++++++++-
> >  include/uapi/asm-generic/socket.h       |  2 ++
> >  net/core/sock.c                         | 11 +++++++++++
> >  net/mptcp/sockopt.c                     |  1 +
> >  net/unix/af_unix.c                      | 18 +++++++++++++-----
> >  tools/include/uapi/asm-generic/socket.h |  2 ++
> >  12 files changed, 54 insertions(+), 6 deletions(-)
> > 
> > diff --git a/arch/alpha/include/uapi/asm/socket.h b/arch/alpha/include/uapi/asm/socket.h
> > index 739891b94136..ff310613ae64 100644
> > --- a/arch/alpha/include/uapi/asm/socket.h
> > +++ b/arch/alpha/include/uapi/asm/socket.h
> > @@ -137,6 +137,8 @@
> >  
> >  #define SO_RCVMARK		75
> >  
> > +#define SO_PASSPIDFD		76
> > +
> >  #if !defined(__KERNEL__)
> >  
> >  #if __BITS_PER_LONG == 64
> > diff --git a/arch/mips/include/uapi/asm/socket.h b/arch/mips/include/uapi/asm/socket.h
> > index 18f3d95ecfec..762dcb80e4ec 100644
> > --- a/arch/mips/include/uapi/asm/socket.h
> > +++ b/arch/mips/include/uapi/asm/socket.h
> > @@ -148,6 +148,8 @@
> >  
> >  #define SO_RCVMARK		75
> >  
> > +#define SO_PASSPIDFD		76
> > +
> >  #if !defined(__KERNEL__)
> >  
> >  #if __BITS_PER_LONG == 64
> > diff --git a/arch/parisc/include/uapi/asm/socket.h b/arch/parisc/include/uapi/asm/socket.h
> > index f486d3dfb6bb..df16a3e16d64 100644
> > --- a/arch/parisc/include/uapi/asm/socket.h
> > +++ b/arch/parisc/include/uapi/asm/socket.h
> > @@ -129,6 +129,8 @@
> >  
> >  #define SO_RCVMARK		0x4049
> >  
> > +#define SO_PASSPIDFD		0x404A
> > +
> >  #if !defined(__KERNEL__)
> >  
> >  #if __BITS_PER_LONG == 64
> > diff --git a/arch/sparc/include/uapi/asm/socket.h b/arch/sparc/include/uapi/asm/socket.h
> > index 2fda57a3ea86..6e2847804fea 100644
> > --- a/arch/sparc/include/uapi/asm/socket.h
> > +++ b/arch/sparc/include/uapi/asm/socket.h
> > @@ -130,6 +130,8 @@
> >  
> >  #define SO_RCVMARK               0x0054
> >  
> > +#define SO_PASSPIDFD             0x0055
> > +
> >  #if !defined(__KERNEL__)
> >  
> >  
> > diff --git a/include/linux/net.h b/include/linux/net.h
> > index b73ad8e3c212..c234dfbe7a30 100644
> > --- a/include/linux/net.h
> > +++ b/include/linux/net.h
> > @@ -43,6 +43,7 @@ struct net;
> >  #define SOCK_PASSSEC		4
> >  #define SOCK_SUPPORT_ZC		5
> >  #define SOCK_CUSTOM_SOCKOPT	6
> > +#define SOCK_PASSPIDFD		7
> >  
> >  #ifndef ARCH_HAS_SOCKET_TYPES
> >  /**
> > diff --git a/include/linux/socket.h b/include/linux/socket.h
> > index 13c3a237b9c9..6bf90f251910 100644
> > --- a/include/linux/socket.h
> > +++ b/include/linux/socket.h
> > @@ -177,6 +177,7 @@ static inline size_t msg_data_left(struct msghdr *msg)
> >  #define	SCM_RIGHTS	0x01		/* rw: access rights (array of int) */
> >  #define SCM_CREDENTIALS 0x02		/* rw: struct ucred		*/
> >  #define SCM_SECURITY	0x03		/* rw: security label		*/
> > +#define SCM_PIDFD	0x04		/* ro: pidfd (int)		*/
> >  
> >  struct ucred {
> >  	__u32	pid;
> > diff --git a/include/net/scm.h b/include/net/scm.h
> > index 585adc1346bd..4617fbc65294 100644
> > --- a/include/net/scm.h
> > +++ b/include/net/scm.h
> > @@ -124,7 +124,9 @@ static __inline__ void scm_recv(struct socket *sock, struct msghdr *msg,
> >  				struct scm_cookie *scm, int flags)
> >  {
> >  	if (!msg->msg_control) {
> > -		if (test_bit(SOCK_PASSCRED, &sock->flags) || scm->fp ||
> > +		if (test_bit(SOCK_PASSCRED, &sock->flags) ||
> > +		    test_bit(SOCK_PASSPIDFD, &sock->flags) ||
> > +		    scm->fp ||
> 
> nit: I'd remove newline here.
> 
> 
> >  		    scm_has_secdata(sock))
> >  			msg->msg_flags |= MSG_CTRUNC;
> >  		scm_destroy(scm);
> > @@ -141,6 +143,18 @@ static __inline__ void scm_recv(struct socket *sock, struct msghdr *msg,
> >  		put_cmsg(msg, SOL_SOCKET, SCM_CREDENTIALS, sizeof(ucreds), &ucreds);
> >  	}
> >  
> > +	if (test_bit(SOCK_PASSPIDFD, &sock->flags)) {
> > +		int pidfd;
> > +
> > +		if (WARN_ON_ONCE(!scm->pid) ||
> > +		    !pid_has_task(scm->pid, PIDTYPE_TGID))
> 
> Can we change pidfd_create() to return -ESRCH as it has the same test ?

I don't think we can do this. pidfd_create() can't distinguish between
"this task has been reaped" and "this is a non-thread group leader". So
EINVAL is a better hint especially since pidfd_open() is preceeded by a
check that would return -ESRCH.

It would also be a uapi change for the pidfd_open() syscall to change
pidfd_create() like that and for fanotify as well. Now they get EINVAL
for a non-thread group leader pid they pass into the system call.
Afterwards they'd get ESRCH which is at least misleading if not wrong.
