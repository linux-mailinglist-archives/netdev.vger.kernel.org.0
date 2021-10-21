Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 604A0435DCB
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 11:20:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231424AbhJUJXG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 05:23:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:38752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231320AbhJUJXE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Oct 2021 05:23:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1D9B0610CB;
        Thu, 21 Oct 2021 09:20:47 +0000 (UTC)
Date:   Thu, 21 Oct 2021 11:20:44 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Sargun Dhillon <sargun@sargun.me>
Cc:     Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: Retrieving the network namespace of a socket
Message-ID: <20211021092044.o7lmudkixlqu6vfq@wittgenstein>
References: <20211020095707.GA16295@ircssh-2.c.rugged-nimbus-611.internal>
 <CAHNKnsRFah6MRxECTLNwu+maN0o9jS9ENzSAiWS4v1247BqYdg@mail.gmail.com>
 <20211020163417.GA21040@ircssh-2.c.rugged-nimbus-611.internal>
 <20211020192456.GA23489@ircssh-2.c.rugged-nimbus-611.internal>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211020192456.GA23489@ircssh-2.c.rugged-nimbus-611.internal>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 20, 2021 at 07:24:57PM +0000, Sargun Dhillon wrote:
> On Wed, Oct 20, 2021 at 04:34:18PM +0000, Sargun Dhillon wrote:
> > On Wed, Oct 20, 2021 at 05:03:56PM +0300, Sergey Ryazanov wrote:
> > > Hello Sargun,
> > > 
> > > On Wed, Oct 20, 2021 at 12:57 PM Sargun Dhillon <sargun@sargun.me> wrote:
> > > > I'm working on a problem where I need to determine which network namespace a
> > > > given socket is in. I can currently bruteforce this by using INET_DIAG, and
> > > > enumerating namespaces and working backwards.
> > > 
> > > Namespace is not a per-socket, but a per-process attribute. So each
> > > socket of a process belongs to the same namespace.
> > > 
> > > Could you elaborate what kind of problem you are trying to solve?
> > > Maybe there is a more simple solution. for it.
> > > 
> > > -- 
> > > Sergey
> > 
> > That's not entirely true. See the folowing code:
> > 
> > int main() {
> > 	int fd1, fd2;
> > 	fd1 = socket(AF_INET, SOCK_STREAM, 0);
> > 	assert(fd1 >= 0);
> > 	assert(unshare(CLONE_NEWNET) == 0);
> > 	fd2 = socket(AF_INET, SOCK_STREAM, 0);
> > 	assert(fd2 >= 0);
> > }
> > 
> > fd1 and fd2 have different sock_net.
> > 
> > The context for this is:
> > https://linuxplumbersconf.org/event/11/contributions/932/
> > 
> > We need to figure out, for a given socket, if it has reachability to a given IP.
> 
> So, I was lazy / misread documentation. It turns out SIOCGSKNS does exactly
> what I need.

I was about to reply with this. :) It's heavily used in CRIU and we use
it in LXC/LXD as well.

> 
> Nonetheless, it's a little weird and awkward that it is exists. I was wondering
> if this functionality made sense as part of kcmp. I wrote up a quick patch
> to see if anyone was interested:

Per se I don't see a reason why this shouldn't exist as an extension to
kcmp(). It seems useful.

> 
> diff --git a/include/uapi/linux/kcmp.h b/include/uapi/linux/kcmp.h
> index ef1305010925..d6b9c3923d20 100644
> --- a/include/uapi/linux/kcmp.h
> +++ b/include/uapi/linux/kcmp.h
> @@ -14,6 +14,7 @@ enum kcmp_type {
>  	KCMP_IO,
>  	KCMP_SYSVSEM,
>  	KCMP_EPOLL_TFD,
> +	KCMP_NETNS,
>  
>  	KCMP_TYPES,
>  };
> diff --git a/kernel/kcmp.c b/kernel/kcmp.c
> index 5353edfad8e1..8fadae4b588f 100644
> --- a/kernel/kcmp.c
> +++ b/kernel/kcmp.c
> @@ -18,6 +18,8 @@
>  #include <linux/file.h>
>  
>  #include <asm/unistd.h>
> +#include <net/net_namespace.h>
> +#include <net/sock.h>
>  
>  /*
>   * We don't expose the real in-memory order of objects for security reasons.
> @@ -132,6 +134,58 @@ static int kcmp_epoll_target(struct task_struct *task1,
>  }
>  #endif
>  
> +#ifdef CONFIG_NET
> +static int __kcmp_netns_target(struct task_struct *task1,
> +			       struct task_struct *task2,
> +			       struct file *filp1,
> +			       struct file *filp2)
> +{
> +	struct socket *sock1, *sock2;
> +	struct net *net1, *net2;
> +
> +	sock1 = sock_from_file(filp1);
> +	sock2 = sock_from_file(filp1);
> +	if (!sock1 || !sock2)
> +		return -ENOTSOCK;
> +
> +	net1 = sock_net(sock1->sk);
> +	net2 = sock_net(sock2->sk);
> +
> +	return kcmp_ptr(net1, net2, KCMP_NETNS);
> +}
> +
> +static int kcmp_netns_target(struct task_struct *task1,
> +			     struct task_struct *task2,
> +			     unsigned long idx1,
> +			     unsigned long idx2)
> +{
> +	struct file *filp1, *filp2;
> +
> +	int ret = -EBADF;
> +
> +	filp1 = fget_task(task1, idx1);
> +	if (filp1) {
> +		filp2 = fget_task(task2, idx2);
> +		if (filp2) {
> +			ret = __kcmp_netns_target(task1, task2, filp1, filp2);
> +			fput(filp2);
> +		}
> +
> +		fput(filp1);
> +	}
> +
> +	return ret;
> +}
> +#else
> +static int kcmp_netns_target(struct task_struct *task1,
> +			     struct task_struct *task2,
> +			     unsigned long idx1,
> +			     unsigned long idx2)
> +{
> +	return -EOPNOTSUPP;
> +}
> +#endif
> +
>  SYSCALL_DEFINE5(kcmp, pid_t, pid1, pid_t, pid2, int, type,
>  		unsigned long, idx1, unsigned long, idx2)
>  {
> @@ -206,6 +260,9 @@ SYSCALL_DEFINE5(kcmp, pid_t, pid1, pid_t, pid2, int, type,
>  	case KCMP_EPOLL_TFD:
>  		ret = kcmp_epoll_target(task1, task2, idx1, (void *)idx2);
>  		break;
> +	case KCMP_NETNS:
> +		ret = kcmp_netns_target(task1, task2, idx1, idx2);
> +		break;
>  	default:
>  		ret = -EINVAL;
>  		break;
> 
