Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BFAB233673
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 18:13:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729989AbgG3QNK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 12:13:10 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56483 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726353AbgG3QNI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 12:13:08 -0400
Received: from ip5f5af08c.dynamic.kabel-deutschland.de ([95.90.240.140] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1k1BB1-0001kT-Np; Thu, 30 Jul 2020 16:13:03 +0000
Date:   Thu, 30 Jul 2020 18:13:03 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        Rodrigo Madera <rodrigo.madera@gmail.com>
Subject: Re: [PATCH net] net/bpfilter: initialize pos in
 __bpfilter_process_sockopt
Message-ID: <20200730161303.erzgrhqsgc77d4ny@wittgenstein>
References: <20200730160900.187157-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200730160900.187157-1-hch@lst.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 30, 2020 at 06:09:00PM +0200, Christoph Hellwig wrote:
> __bpfilter_process_sockopt never initialized the pos variable passed to
> the pipe write.  This has been mostly harmless in the past as pipes
> ignore the offset, but the switch to kernel_write no verified the

s/no/now/

> position, which can lead to a failure depending on the exact stack
> initialization patter.  Initialize the variable to zero to make

s/patter/pattern/

> rw_verify_area happy.
> 
> Fixes: 6955a76fbcd5 ("bpfilter: switch to kernel_write")
> Reported-by: Christian Brauner <christian.brauner@ubuntu.com>
> Reported-by: Rodrigo Madera <rodrigo.madera@gmail.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Tested-by: Rodrigo Madera <rodrigo.madera@gmail.com>
> ---

Thanks for tracking this down, Christoph! This fixes the logging issue
for me.
Tested-by: Christian Brauner <christian.brauner@ubuntu.com>
Reviewed-by: Christian Brauner <christian.brauner@ubuntu.com>

>  net/bpfilter/bpfilter_kern.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/bpfilter/bpfilter_kern.c b/net/bpfilter/bpfilter_kern.c
> index 1905e01c3aa9a7..4494ea6056cdb8 100644
> --- a/net/bpfilter/bpfilter_kern.c
> +++ b/net/bpfilter/bpfilter_kern.c
> @@ -39,7 +39,7 @@ static int __bpfilter_process_sockopt(struct sock *sk, int optname,
>  {
>  	struct mbox_request req;
>  	struct mbox_reply reply;
> -	loff_t pos;
> +	loff_t pos = 0;
>  	ssize_t n;
>  	int ret = -EFAULT;
>  
> -- 
> 2.27.0
> 
