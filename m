Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8458722FF6A
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 04:16:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726841AbgG1CQm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 22:16:42 -0400
Received: from smtp7.emailarray.com ([65.39.216.66]:26159 "EHLO
        smtp7.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726247AbgG1CQm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 22:16:42 -0400
Received: (qmail 42216 invoked by uid 89); 28 Jul 2020 02:16:38 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuMw==) (POLARISLOCAL)  
  by smtp7.emailarray.com with SMTP; 28 Jul 2020 02:16:38 -0000
Date:   Mon, 27 Jul 2020 19:16:36 -0700
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     netdev@vger.kernel.org
Cc:     kernel-team@fb.com
Subject: Re: [RFC PATCH v2 14/21] net/tcp: add netgpu ioctl setting up zero
 copy RX queues
Message-ID: <20200728021636.ifn3kuawc5gg6lv6@bsd-mbp.dhcp.thefacebook.com>
References: <20200727224444.2987641-1-jonathan.lemon@gmail.com>
 <20200727224444.2987641-15-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200727224444.2987641-15-jonathan.lemon@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 27, 2020 at 03:44:37PM -0700, Jonathan Lemon wrote:
> From: Jonathan Lemon <bsd@fb.com>
> 
> Netgpu delivers iovecs to userspace for incoming data, but the
> destination queue must be attached to the socket.  Do this via
> and ioctl call on the socket itself.
> 
> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> ---
>  net/ipv4/tcp.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index 27de9380ed14..261c28ccc8f6 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -279,6 +279,7 @@
>  #include <linux/uaccess.h>
>  #include <asm/ioctls.h>
>  #include <net/busy_poll.h>
> +#include <net/netgpu.h>
>  
>  struct percpu_counter tcp_orphan_count;
>  EXPORT_SYMBOL_GPL(tcp_orphan_count);
> @@ -636,6 +637,10 @@ int tcp_ioctl(struct sock *sk, int cmd, unsigned long arg)
>  			answ = READ_ONCE(tp->write_seq) -
>  			       READ_ONCE(tp->snd_nxt);
>  		break;
> +#if IS_ENABLED(CONFIG_NETGPU)
> +	case NETGPU_SOCK_IOCTL_ATTACH_QUEUES:	/* SIOCPROTOPRIVATE */
> +		return netgpu_attach_socket(sk, (void __user *)arg);
> +#endif
>  	default:
>  		return -ENOIOCTLCMD;
>  	}

Actually, this is just ugly, so I'm going to rip it out and have it done
the other way around: (ctx -> sk) instead of (sk -> ctx), so ignore this.
-- 
Jonathan
