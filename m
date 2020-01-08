Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02A701343F8
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 14:37:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727777AbgAHNh0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 08:37:26 -0500
Received: from relay.sw.ru ([185.231.240.75]:59824 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726144AbgAHNh0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jan 2020 08:37:26 -0500
Received: from dhcp-172-16-24-104.sw.ru ([172.16.24.104])
        by relay.sw.ru with esmtp (Exim 4.92.3)
        (envelope-from <ktkhai@virtuozzo.com>)
        id 1ipBWC-0005kp-73; Wed, 08 Jan 2020 16:37:04 +0300
Subject: Re: [PATCH] [net-next] socket: fix unused-function warning
To:     Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Willem de Bruijn <willemb@google.com>,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Pedro Tammela <pctammela@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200107213609.520236-1-arnd@arndb.de>
From:   Kirill Tkhai <ktkhai@virtuozzo.com>
Message-ID: <8bc0e3d2-c2e0-b4ab-63fa-8b124ab4d0f8@virtuozzo.com>
Date:   Wed, 8 Jan 2020 16:37:03 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200107213609.520236-1-arnd@arndb.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08.01.2020 00:35, Arnd Bergmann wrote:
> When procfs is disabled, the fdinfo code causes a harmless
> warning:
> 
> net/socket.c:1000:13: error: 'sock_show_fdinfo' defined but not used [-Werror=unused-function]
>  static void sock_show_fdinfo(struct seq_file *m, struct file *f)
> 
> Change the preprocessor conditional to a compiler conditional
> to avoid the warning and let the compiler throw away the
> function itself.
> 
> Fixes: b4653342b151 ("net: Allow to show socket-specific information in /proc/[pid]/fdinfo/[fd]")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Thanks for fixing.

Acked-by: Kirill Tkhai <ktkhai@virtuozzo.com>

> ---
>  net/socket.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/net/socket.c b/net/socket.c
> index 5230c9e1bdec..444a617819f0 100644
> --- a/net/socket.c
> +++ b/net/socket.c
> @@ -151,9 +151,7 @@ static const struct file_operations socket_file_ops = {
>  	.sendpage =	sock_sendpage,
>  	.splice_write = generic_splice_sendpage,
>  	.splice_read =	sock_splice_read,
> -#ifdef CONFIG_PROC_FS
> -	.show_fdinfo =	sock_show_fdinfo,
> -#endif
> +	.show_fdinfo =	IS_ENABLED(CONFIG_PROC_FS) ? sock_show_fdinfo : NULL,
>  };
>  
>  /*
> 

