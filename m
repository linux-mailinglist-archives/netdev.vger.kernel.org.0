Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E085134EFE
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 22:39:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726758AbgAHVjY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 16:39:24 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:58536 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbgAHVjY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 16:39:24 -0500
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ipJ2p-004STj-7R; Wed, 08 Jan 2020 21:39:15 +0000
Date:   Wed, 8 Jan 2020 21:39:15 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
        Jens Axboe <axboe@kernel.dk>,
        Willem de Bruijn <willemb@google.com>,
        Deepa Dinamani <deepa.kernel@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Pedro Tammela <pctammela@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [net-next] socket: fix unused-function warning
Message-ID: <20200108213915.GG8904@ZenIV.linux.org.uk>
References: <20200107213609.520236-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200107213609.520236-1-arnd@arndb.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 07, 2020 at 10:35:59PM +0100, Arnd Bergmann wrote:
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

Ugh...  So put that ifdef around the definition of sock_show_fdinfo,
with #define sock_show_fdinfo NULL on the other side...
