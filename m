Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F10BF327B8E
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 11:08:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232132AbhCAKGv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 05:06:51 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36907 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232038AbhCAKGK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 05:06:10 -0500
Received: from ip5f5af0a0.dynamic.kabel-deutschland.de ([95.90.240.160] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1lGfPZ-0003lu-Cu; Mon, 01 Mar 2021 10:04:21 +0000
Date:   Mon, 1 Mar 2021 11:04:20 +0100
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        kernel-team@cloudflare.com, linux-api@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH bpf 2/4] nsfs: add an ioctl to discover the network
 namespace cookie
Message-ID: <20210301100420.slnjvzql6el4jlfj@wittgenstein>
References: <20210210120425.53438-1-lmb@cloudflare.com>
 <20210210120425.53438-3-lmb@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210210120425.53438-3-lmb@cloudflare.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 10, 2021 at 12:04:23PM +0000, Lorenz Bauer wrote:
> Network namespaces have a globally unique non-zero identifier aka a
> cookie, in line with socket cookies. Add an ioctl to retrieve the
> cookie from user space without going via BPF.
> 
> Cc: linux-api@vger.kernel.org
> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> ---
>  fs/nsfs.c                   |  9 +++++++++
>  include/net/net_namespace.h | 11 +++++++++++
>  include/uapi/linux/nsfs.h   |  2 ++
>  3 files changed, 22 insertions(+)
> 
> diff --git a/fs/nsfs.c b/fs/nsfs.c
> index 800c1d0eb0d0..d7865e39c049 100644
> --- a/fs/nsfs.c
> +++ b/fs/nsfs.c
> @@ -11,6 +11,7 @@
>  #include <linux/user_namespace.h>
>  #include <linux/nsfs.h>
>  #include <linux/uaccess.h>
> +#include <net/net_namespace.h>
>  
>  #include "internal.h"
>  
> @@ -191,6 +192,8 @@ static long ns_ioctl(struct file *filp, unsigned int ioctl,
>  	struct user_namespace *user_ns;
>  	struct ns_common *ns = get_proc_ns(file_inode(filp));
>  	uid_t __user *argp;
> +	struct net *net_ns;
> +	u64 cookie;
>  	uid_t uid;
>  
>  	switch (ioctl) {
> @@ -209,6 +212,12 @@ static long ns_ioctl(struct file *filp, unsigned int ioctl,
>  		argp = (uid_t __user *) arg;
>  		uid = from_kuid_munged(current_user_ns(), user_ns->owner);
>  		return put_user(uid, argp);
> +	case NS_GET_COOKIE:
> +		if (ns->ops->type != CLONE_NEWNET)
> +			return -EINVAL;
> +		net_ns = container_of(ns, struct net, ns);
> +		cookie = net_gen_cookie(net_ns);
> +		return put_user(cookie, (u64 __user *)arg);

Hey Lorenz,

Just to make sure: is it intentional that any user can retrieve the
cookie associated with any network namespace, i.e. you don't require any
form of permission checking in the owning user namespace of the network
namespace?

Christian
