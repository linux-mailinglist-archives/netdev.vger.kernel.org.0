Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF86C171356
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 09:51:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728697AbgB0Iuz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 03:50:55 -0500
Received: from relay.sw.ru ([185.231.240.75]:52820 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728469AbgB0Iuz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Feb 2020 03:50:55 -0500
Received: from dhcp-172-16-24-104.sw.ru ([172.16.24.104])
        by relay.sw.ru with esmtp (Exim 4.92.3)
        (envelope-from <ktkhai@virtuozzo.com>)
        id 1j7EsC-00043o-NO; Thu, 27 Feb 2020 11:50:24 +0300
Subject: Re: [PATCH] unix: define and set show_fdinfo only if procfs is
 enabled
To:     Tobias Klauser <tklauser@distanz.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
References: <20200226172953.16471-1-tklauser@distanz.ch>
From:   Kirill Tkhai <ktkhai@virtuozzo.com>
Message-ID: <6ac440dc-8300-2c19-d9a1-6b92c1cf8b84@virtuozzo.com>
Date:   Thu, 27 Feb 2020 11:50:24 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200226172953.16471-1-tklauser@distanz.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26.02.2020 20:29, Tobias Klauser wrote:
> Follow the pattern used with other *_show_fdinfo functions and only
> define unix_show_fdinfo and set it in proto_ops if CONFIG_PROCFS
> is set.
> 
> Fixes: 3c32da19a858 ("unix: Show number of pending scm files of receive queue in fdinfo")
> Signed-off-by: Tobias Klauser <tklauser@distanz.ch>

Reviewed-by: Kirill Tkhai <ktkhai@virtuozzo.com>

> ---
>  net/unix/af_unix.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
> index 62c12cb5763e..aa6e2530e1ec 100644
> --- a/net/unix/af_unix.c
> +++ b/net/unix/af_unix.c
> @@ -682,6 +682,7 @@ static int unix_set_peek_off(struct sock *sk, int val)
>  	return 0;
>  }
>  
> +#ifdef CONFIG_PROCFS
>  static void unix_show_fdinfo(struct seq_file *m, struct socket *sock)
>  {
>  	struct sock *sk = sock->sk;
> @@ -692,6 +693,9 @@ static void unix_show_fdinfo(struct seq_file *m, struct socket *sock)
>  		seq_printf(m, "scm_fds: %u\n", READ_ONCE(u->scm_stat.nr_fds));
>  	}
>  }
> +#else
> +#define unix_show_fdinfo NULL
> +#endif
>  
>  static const struct proto_ops unix_stream_ops = {
>  	.family =	PF_UNIX,
> 

