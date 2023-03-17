Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B28C6BE0DC
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 06:56:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbjCQF4O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 01:56:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbjCQF4M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 01:56:12 -0400
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FB1E6701F;
        Thu, 16 Mar 2023 22:56:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1679032572; x=1710568572;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qr8ymExQ8MQh74MDTzLo7tXS7z+/I7o3X/Mnduj9VFM=;
  b=bzFmi2Xfpn/W6Hv3MQS2MATI4+jvzlab+PsRwr4WrGOfGGff0Zb1UIN2
   MzsTnALO/09hk9AVKU1VB/0wmpVZjaKko3OzxnP5dZ5EeFAa9vlM0eqDO
   3qizLp18tmQFO2vzHJ1r0HXSFN8NPxeQ28Arv9bzvVfrDNDO7E+o1magS
   I=;
X-IronPort-AV: E=Sophos;i="5.98,268,1673913600"; 
   d="scan'208";a="310171870"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2a-m6i4x-1cca8d67.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2023 05:56:09 +0000
Received: from EX19MTAUWA002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2a-m6i4x-1cca8d67.us-west-2.amazon.com (Postfix) with ESMTPS id 27A9F80E0E;
        Fri, 17 Mar 2023 05:56:08 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.22; Fri, 17 Mar 2023 05:56:07 +0000
Received: from 88665a182662.ant.amazon.com (10.106.101.15) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.24;
 Fri, 17 Mar 2023 05:56:03 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <aleksandr.mikhalitsyn@canonical.com>
CC:     <arnd@arndb.de>, <brauner@kernel.org>, <davem@davemloft.net>,
        <dsahern@kernel.org>, <edumazet@google.com>,
        <keescook@chromium.org>, <kuba@kernel.org>, <leon@kernel.org>,
        <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <pabeni@redhat.com>, <kuniyu@amazon.com>
Subject: Re: [PATCH net-next 2/3] net: core: add getsockopt SO_PEERPIDFD
Date:   Thu, 16 Mar 2023 22:55:55 -0700
Message-ID: <20230317055555.33192-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230316131526.283569-3-aleksandr.mikhalitsyn@canonical.com>
References: <20230316131526.283569-3-aleksandr.mikhalitsyn@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.106.101.15]
X-ClientProxiedBy: EX19D036UWC004.ant.amazon.com (10.13.139.205) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Date:   Thu, 16 Mar 2023 14:15:25 +0100
> Add SO_PEERPIDFD which allows to get pidfd of peer socket holder pidfd.
> This thing is direct analog of SO_PEERCRED which allows to get plain PID.
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
>  arch/alpha/include/uapi/asm/socket.h    |  1 +
>  arch/mips/include/uapi/asm/socket.h     |  1 +
>  arch/parisc/include/uapi/asm/socket.h   |  1 +
>  arch/sparc/include/uapi/asm/socket.h    |  1 +
>  include/uapi/asm-generic/socket.h       |  1 +
>  net/core/sock.c                         | 24 ++++++++++++++++++++++++
>  tools/include/uapi/asm-generic/socket.h |  1 +
>  7 files changed, 30 insertions(+)
> 
> diff --git a/arch/alpha/include/uapi/asm/socket.h b/arch/alpha/include/uapi/asm/socket.h
> index ff310613ae64..e94f621903fe 100644
> --- a/arch/alpha/include/uapi/asm/socket.h
> +++ b/arch/alpha/include/uapi/asm/socket.h
> @@ -138,6 +138,7 @@
>  #define SO_RCVMARK		75
>  
>  #define SO_PASSPIDFD		76
> +#define SO_PEERPIDFD		77
>  
>  #if !defined(__KERNEL__)
>  
> diff --git a/arch/mips/include/uapi/asm/socket.h b/arch/mips/include/uapi/asm/socket.h
> index 762dcb80e4ec..60ebaed28a4c 100644
> --- a/arch/mips/include/uapi/asm/socket.h
> +++ b/arch/mips/include/uapi/asm/socket.h
> @@ -149,6 +149,7 @@
>  #define SO_RCVMARK		75
>  
>  #define SO_PASSPIDFD		76
> +#define SO_PEERPIDFD		77
>  
>  #if !defined(__KERNEL__)
>  
> diff --git a/arch/parisc/include/uapi/asm/socket.h b/arch/parisc/include/uapi/asm/socket.h
> index df16a3e16d64..be264c2b1a11 100644
> --- a/arch/parisc/include/uapi/asm/socket.h
> +++ b/arch/parisc/include/uapi/asm/socket.h
> @@ -130,6 +130,7 @@
>  #define SO_RCVMARK		0x4049
>  
>  #define SO_PASSPIDFD		0x404A
> +#define SO_PEERPIDFD		0x404B
>  
>  #if !defined(__KERNEL__)
>  
> diff --git a/arch/sparc/include/uapi/asm/socket.h b/arch/sparc/include/uapi/asm/socket.h
> index 6e2847804fea..682da3714686 100644
> --- a/arch/sparc/include/uapi/asm/socket.h
> +++ b/arch/sparc/include/uapi/asm/socket.h
> @@ -131,6 +131,7 @@
>  #define SO_RCVMARK               0x0054
>  
>  #define SO_PASSPIDFD             0x0055
> +#define SO_PEERPIDFD             0x0056
>  
>  #if !defined(__KERNEL__)
>  
> diff --git a/include/uapi/asm-generic/socket.h b/include/uapi/asm-generic/socket.h
> index b76169fdb80b..8ce8a39a1e5f 100644
> --- a/include/uapi/asm-generic/socket.h
> +++ b/include/uapi/asm-generic/socket.h
> @@ -133,6 +133,7 @@
>  #define SO_RCVMARK		75
>  
>  #define SO_PASSPIDFD		76
> +#define SO_PEERPIDFD		77
>  
>  #if !defined(__KERNEL__)
>  
> diff --git a/net/core/sock.c b/net/core/sock.c
> index 3f974246ba3e..3aa1ccd4bcf3 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -1763,6 +1763,30 @@ int sk_getsockopt(struct sock *sk, int level, int optname,
>  		goto lenout;
>  	}
>  
> +	case SO_PEERPIDFD:
> +	{
> +		struct pid *peer_pid;
> +		int pidfd;

nit: newline here, checkpatch.pl will complain.

> +		if (len > sizeof(pidfd))
> +			len = sizeof(pidfd);
> +
> +		spin_lock(&sk->sk_peer_lock);
> +		peer_pid = get_pid(sk->sk_peer_pid);
> +		spin_unlock(&sk->sk_peer_lock);
> +
> +		if (!peer_pid ||
> +		    !pid_has_task(peer_pid, PIDTYPE_TGID))
> +			pidfd = -ESRCH;
> +		else
> +			pidfd = pidfd_create(peer_pid, 0);

Same comment from patch 1.

                pidfd = pidfd_create(peer_pid, 0);


> +
> +		put_pid(peer_pid);
> +
> +		if (copy_to_sockptr(optval, &pidfd, len))
> +			return -EFAULT;
> +		goto lenout;
> +	}
> +
>  	case SO_PEERGROUPS:
>  	{
>  		const struct cred *cred;
> diff --git a/tools/include/uapi/asm-generic/socket.h b/tools/include/uapi/asm-generic/socket.h
> index fbbc4bf53ee3..54d9c8bf7c55 100644
> --- a/tools/include/uapi/asm-generic/socket.h
> +++ b/tools/include/uapi/asm-generic/socket.h
> @@ -122,6 +122,7 @@
>  #define SO_RCVMARK		75
>  
>  #define SO_PASSPIDFD		76
> +#define SO_PEERPIDFD		77
>  
>  #if !defined(__KERNEL__)
>  
> -- 
> 2.34.1
