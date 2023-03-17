Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08D3E6BE0D4
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 06:53:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbjCQFxj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 01:53:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjCQFxi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 01:53:38 -0400
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 229CF13D5D;
        Thu, 16 Mar 2023 22:53:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1679032416; x=1710568416;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1/2rEZg1fU498haLmlTIq/1ySyVPjOa+yrxCOB0w6Zw=;
  b=UVEQtr/c+nCwjfZ1fboecVWFRdG22ulp4dYngfSGvCkQXywNhVEd1omR
   qx8lIhyK1cNzK4Jp+yN7h/S/HdPr6E9ISs6G/LHxsnn/OM8RYIqI2hzJb
   jdSfvHFsR9pv67W3VKajlfv8jr8b7su12LmIpBTUH3CA+ACIo0GbEDEh4
   Y=;
X-IronPort-AV: E=Sophos;i="5.98,268,1673913600"; 
   d="scan'208";a="310171314"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-iad-1e-m6i4x-9694bb9e.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2023 05:53:34 +0000
Received: from EX19MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1e-m6i4x-9694bb9e.us-east-1.amazon.com (Postfix) with ESMTPS id 1824280D3A;
        Fri, 17 Mar 2023 05:53:33 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.25; Fri, 17 Mar 2023 05:53:32 +0000
Received: from 88665a182662.ant.amazon.com (10.106.101.15) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.24;
 Fri, 17 Mar 2023 05:53:29 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <aleksandr.mikhalitsyn@canonical.com>
CC:     <arnd@arndb.de>, <brauner@kernel.org>, <davem@davemloft.net>,
        <dsahern@kernel.org>, <edumazet@google.com>,
        <keescook@chromium.org>, <kuba@kernel.org>, <leon@kernel.org>,
        <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <pabeni@redhat.com>, <kuniyu@amazon.com>
Subject: Re: [PATCH net-next 1/3] scm: add SO_PASSPIDFD and SCM_PIDFD
Date:   Thu, 16 Mar 2023 22:53:20 -0700
Message-ID: <20230317055320.32371-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230316131526.283569-2-aleksandr.mikhalitsyn@canonical.com>
References: <20230316131526.283569-2-aleksandr.mikhalitsyn@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.106.101.15]
X-ClientProxiedBy: EX19D036UWC001.ant.amazon.com (10.13.139.233) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Date:   Thu, 16 Mar 2023 14:15:24 +0100
> Implement SCM_PIDFD, a new type of CMSG type analogical to SCM_CREDENTIALS,
> but it contains pidfd instead of plain pid, which allows programmers not
> to care about PID reuse problem.
> 
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: Leon Romanovsky <leon@kernel.org>
> Cc: David Ahern <dsahern@kernel.org>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Christian Brauner <brauner@kernel.org>
> Cc: linux-kernel@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Cc: linux-arch@vger.kernel.org
> Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
> ---
>  arch/alpha/include/uapi/asm/socket.h    |  2 ++
>  arch/mips/include/uapi/asm/socket.h     |  2 ++
>  arch/parisc/include/uapi/asm/socket.h   |  2 ++
>  arch/sparc/include/uapi/asm/socket.h    |  2 ++
>  include/linux/net.h                     |  1 +
>  include/linux/socket.h                  |  1 +
>  include/net/scm.h                       | 16 +++++++++++++++-
>  include/uapi/asm-generic/socket.h       |  2 ++
>  net/core/sock.c                         | 11 +++++++++++
>  net/mptcp/sockopt.c                     |  1 +
>  net/unix/af_unix.c                      | 18 +++++++++++++-----
>  tools/include/uapi/asm-generic/socket.h |  2 ++
>  12 files changed, 54 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/alpha/include/uapi/asm/socket.h b/arch/alpha/include/uapi/asm/socket.h
> index 739891b94136..ff310613ae64 100644
> --- a/arch/alpha/include/uapi/asm/socket.h
> +++ b/arch/alpha/include/uapi/asm/socket.h
> @@ -137,6 +137,8 @@
>  
>  #define SO_RCVMARK		75
>  
> +#define SO_PASSPIDFD		76
> +
>  #if !defined(__KERNEL__)
>  
>  #if __BITS_PER_LONG == 64
> diff --git a/arch/mips/include/uapi/asm/socket.h b/arch/mips/include/uapi/asm/socket.h
> index 18f3d95ecfec..762dcb80e4ec 100644
> --- a/arch/mips/include/uapi/asm/socket.h
> +++ b/arch/mips/include/uapi/asm/socket.h
> @@ -148,6 +148,8 @@
>  
>  #define SO_RCVMARK		75
>  
> +#define SO_PASSPIDFD		76
> +
>  #if !defined(__KERNEL__)
>  
>  #if __BITS_PER_LONG == 64
> diff --git a/arch/parisc/include/uapi/asm/socket.h b/arch/parisc/include/uapi/asm/socket.h
> index f486d3dfb6bb..df16a3e16d64 100644
> --- a/arch/parisc/include/uapi/asm/socket.h
> +++ b/arch/parisc/include/uapi/asm/socket.h
> @@ -129,6 +129,8 @@
>  
>  #define SO_RCVMARK		0x4049
>  
> +#define SO_PASSPIDFD		0x404A
> +
>  #if !defined(__KERNEL__)
>  
>  #if __BITS_PER_LONG == 64
> diff --git a/arch/sparc/include/uapi/asm/socket.h b/arch/sparc/include/uapi/asm/socket.h
> index 2fda57a3ea86..6e2847804fea 100644
> --- a/arch/sparc/include/uapi/asm/socket.h
> +++ b/arch/sparc/include/uapi/asm/socket.h
> @@ -130,6 +130,8 @@
>  
>  #define SO_RCVMARK               0x0054
>  
> +#define SO_PASSPIDFD             0x0055
> +
>  #if !defined(__KERNEL__)
>  
>  
> diff --git a/include/linux/net.h b/include/linux/net.h
> index b73ad8e3c212..c234dfbe7a30 100644
> --- a/include/linux/net.h
> +++ b/include/linux/net.h
> @@ -43,6 +43,7 @@ struct net;
>  #define SOCK_PASSSEC		4
>  #define SOCK_SUPPORT_ZC		5
>  #define SOCK_CUSTOM_SOCKOPT	6
> +#define SOCK_PASSPIDFD		7
>  
>  #ifndef ARCH_HAS_SOCKET_TYPES
>  /**
> diff --git a/include/linux/socket.h b/include/linux/socket.h
> index 13c3a237b9c9..6bf90f251910 100644
> --- a/include/linux/socket.h
> +++ b/include/linux/socket.h
> @@ -177,6 +177,7 @@ static inline size_t msg_data_left(struct msghdr *msg)
>  #define	SCM_RIGHTS	0x01		/* rw: access rights (array of int) */
>  #define SCM_CREDENTIALS 0x02		/* rw: struct ucred		*/
>  #define SCM_SECURITY	0x03		/* rw: security label		*/
> +#define SCM_PIDFD	0x04		/* ro: pidfd (int)		*/
>  
>  struct ucred {
>  	__u32	pid;
> diff --git a/include/net/scm.h b/include/net/scm.h
> index 585adc1346bd..4617fbc65294 100644
> --- a/include/net/scm.h
> +++ b/include/net/scm.h
> @@ -124,7 +124,9 @@ static __inline__ void scm_recv(struct socket *sock, struct msghdr *msg,
>  				struct scm_cookie *scm, int flags)
>  {
>  	if (!msg->msg_control) {
> -		if (test_bit(SOCK_PASSCRED, &sock->flags) || scm->fp ||
> +		if (test_bit(SOCK_PASSCRED, &sock->flags) ||
> +		    test_bit(SOCK_PASSPIDFD, &sock->flags) ||
> +		    scm->fp ||

nit: I'd remove newline here.


>  		    scm_has_secdata(sock))
>  			msg->msg_flags |= MSG_CTRUNC;
>  		scm_destroy(scm);
> @@ -141,6 +143,18 @@ static __inline__ void scm_recv(struct socket *sock, struct msghdr *msg,
>  		put_cmsg(msg, SOL_SOCKET, SCM_CREDENTIALS, sizeof(ucreds), &ucreds);
>  	}
>  
> +	if (test_bit(SOCK_PASSPIDFD, &sock->flags)) {
> +		int pidfd;
> +
> +		if (WARN_ON_ONCE(!scm->pid) ||
> +		    !pid_has_task(scm->pid, PIDTYPE_TGID))

Can we change pidfd_create() to return -ESRCH as it has the same test ?

> +			pidfd = -ESRCH;
> +		else
> +			pidfd = pidfd_create(scm->pid, 0);

Then we can change this part like:

    int pidfd = pidfd_create(scm->pid, 0);

    WARN_ON_ONCE(!scm->pid);


Thanks,
Kuniyuki


> +
> +		put_cmsg(msg, SOL_SOCKET, SCM_PIDFD, sizeof(int), &pidfd);
> +	}
> +
>  	scm_destroy_cred(scm);
>  
>  	scm_passec(sock, msg, scm);
> diff --git a/include/uapi/asm-generic/socket.h b/include/uapi/asm-generic/socket.h
> index 638230899e98..b76169fdb80b 100644
> --- a/include/uapi/asm-generic/socket.h
> +++ b/include/uapi/asm-generic/socket.h
> @@ -132,6 +132,8 @@
>  
>  #define SO_RCVMARK		75
>  
> +#define SO_PASSPIDFD		76
> +
>  #if !defined(__KERNEL__)
>  
>  #if __BITS_PER_LONG == 64 || (defined(__x86_64__) && defined(__ILP32__))
> diff --git a/net/core/sock.c b/net/core/sock.c
> index c25888795390..3f974246ba3e 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -1246,6 +1246,13 @@ int sk_setsockopt(struct sock *sk, int level, int optname,
>  			clear_bit(SOCK_PASSCRED, &sock->flags);
>  		break;
>  
> +	case SO_PASSPIDFD:
> +		if (valbool)
> +			set_bit(SOCK_PASSPIDFD, &sock->flags);
> +		else
> +			clear_bit(SOCK_PASSPIDFD, &sock->flags);
> +		break;
> +
>  	case SO_TIMESTAMP_OLD:
>  	case SO_TIMESTAMP_NEW:
>  	case SO_TIMESTAMPNS_OLD:
> @@ -1737,6 +1744,10 @@ int sk_getsockopt(struct sock *sk, int level, int optname,
>  		v.val = !!test_bit(SOCK_PASSCRED, &sock->flags);
>  		break;
>  
> +	case SO_PASSPIDFD:
> +		v.val = !!test_bit(SOCK_PASSPIDFD, &sock->flags);
> +		break;
> +
>  	case SO_PEERCRED:
>  	{
>  		struct ucred peercred;
> diff --git a/net/mptcp/sockopt.c b/net/mptcp/sockopt.c
> index 8a9656248b0f..bd80e707d0b3 100644
> --- a/net/mptcp/sockopt.c
> +++ b/net/mptcp/sockopt.c
> @@ -355,6 +355,7 @@ static int mptcp_setsockopt_sol_socket(struct mptcp_sock *msk, int optname,
>  	case SO_BROADCAST:
>  	case SO_BSDCOMPAT:
>  	case SO_PASSCRED:
> +	case SO_PASSPIDFD:
>  	case SO_PASSSEC:
>  	case SO_RXQ_OVFL:
>  	case SO_WIFI_STATUS:
> diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
> index 0b0f18ecce44..b0ac768752fa 100644
> --- a/net/unix/af_unix.c
> +++ b/net/unix/af_unix.c
> @@ -1361,7 +1361,8 @@ static int unix_dgram_connect(struct socket *sock, struct sockaddr *addr,
>  		if (err)
>  			goto out;
>  
> -		if (test_bit(SOCK_PASSCRED, &sock->flags) &&
> +		if ((test_bit(SOCK_PASSCRED, &sock->flags) ||
> +		     test_bit(SOCK_PASSPIDFD, &sock->flags)) &&
>  		    !unix_sk(sk)->addr) {
>  			err = unix_autobind(sk);
>  			if (err)
> @@ -1469,7 +1470,8 @@ static int unix_stream_connect(struct socket *sock, struct sockaddr *uaddr,
>  	if (err)
>  		goto out;
>  
> -	if (test_bit(SOCK_PASSCRED, &sock->flags) && !u->addr) {
> +	if ((test_bit(SOCK_PASSCRED, &sock->flags) ||
> +	     test_bit(SOCK_PASSPIDFD, &sock->flags)) && !u->addr) {
>  		err = unix_autobind(sk);
>  		if (err)
>  			goto out;
> @@ -1670,6 +1672,8 @@ static void unix_sock_inherit_flags(const struct socket *old,
>  {
>  	if (test_bit(SOCK_PASSCRED, &old->flags))
>  		set_bit(SOCK_PASSCRED, &new->flags);
> +	if (test_bit(SOCK_PASSPIDFD, &old->flags))
> +		set_bit(SOCK_PASSPIDFD, &new->flags);
>  	if (test_bit(SOCK_PASSSEC, &old->flags))
>  		set_bit(SOCK_PASSSEC, &new->flags);
>  }
> @@ -1819,8 +1823,10 @@ static bool unix_passcred_enabled(const struct socket *sock,
>  				  const struct sock *other)
>  {
>  	return test_bit(SOCK_PASSCRED, &sock->flags) ||
> +	       test_bit(SOCK_PASSPIDFD, &sock->flags) ||
>  	       !other->sk_socket ||
> -	       test_bit(SOCK_PASSCRED, &other->sk_socket->flags);
> +	       test_bit(SOCK_PASSCRED, &other->sk_socket->flags) ||
> +	       test_bit(SOCK_PASSPIDFD, &other->sk_socket->flags);
>  }
>  
>  /*
> @@ -1922,7 +1928,8 @@ static int unix_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
>  			goto out;
>  	}
>  
> -	if (test_bit(SOCK_PASSCRED, &sock->flags) && !u->addr) {
> +	if ((test_bit(SOCK_PASSCRED, &sock->flags) ||
> +	     test_bit(SOCK_PASSPIDFD, &sock->flags)) && !u->addr) {
>  		err = unix_autobind(sk);
>  		if (err)
>  			goto out;
> @@ -2824,7 +2831,8 @@ static int unix_stream_read_generic(struct unix_stream_read_state *state,
>  			/* Never glue messages from different writers */
>  			if (!unix_skb_scm_eq(skb, &scm))
>  				break;
> -		} else if (test_bit(SOCK_PASSCRED, &sock->flags)) {
> +		} else if (test_bit(SOCK_PASSCRED, &sock->flags) ||
> +			   test_bit(SOCK_PASSPIDFD, &sock->flags)) {
>  			/* Copy credentials */
>  			scm_set_cred(&scm, UNIXCB(skb).pid, UNIXCB(skb).uid, UNIXCB(skb).gid);
>  			unix_set_secdata(&scm, skb);
> diff --git a/tools/include/uapi/asm-generic/socket.h b/tools/include/uapi/asm-generic/socket.h
> index 8756df13be50..fbbc4bf53ee3 100644
> --- a/tools/include/uapi/asm-generic/socket.h
> +++ b/tools/include/uapi/asm-generic/socket.h
> @@ -121,6 +121,8 @@
>  
>  #define SO_RCVMARK		75
>  
> +#define SO_PASSPIDFD		76
> +
>  #if !defined(__KERNEL__)
>  
>  #if __BITS_PER_LONG == 64 || (defined(__x86_64__) && defined(__ILP32__))
> -- 
> 2.34.1
