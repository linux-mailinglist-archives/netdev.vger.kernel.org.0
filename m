Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D295F71B89
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 17:25:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730568AbfGWPZD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 11:25:03 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:41311 "EHLO
        smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729840AbfGWPZC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 11:25:02 -0400
Received: from [66.61.193.110] (helo=localhost)
        by smtp.tuxdriver.com with esmtpsa (TLSv1:AES256-SHA:256)
        (Exim 4.63)
        (envelope-from <nhorman@tuxdriver.com>)
        id 1hpwet-00051C-Ry; Tue, 23 Jul 2019 11:24:58 -0400
Date:   Tue, 23 Jul 2019 11:24:49 -0400
From:   Neil Horman <nhorman@tuxdriver.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        davem@davemloft.net
Subject: Re: [PATCH net-next 1/4] sctp: check addr_size with sa_family_t size
 in __sctp_setsockopt_connectx
Message-ID: <20190723152449.GB8419@localhost.localdomain>
References: <cover.1563817029.git.lucien.xin@gmail.com>
 <c875aa0a5b2965636dc3da83398856627310b280.1563817029.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c875aa0a5b2965636dc3da83398856627310b280.1563817029.git.lucien.xin@gmail.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-Spam-Score: -2.9 (--)
X-Spam-Status: No
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 23, 2019 at 01:37:57AM +0800, Xin Long wrote:
> Now __sctp_connect() is called by __sctp_setsockopt_connectx() and
> sctp_inet_connect(), the latter has done addr_size check with size
> of sa_family_t.
> 
> In the next patch to clean up __sctp_connect(), we will remove
> addr_size check with size of sa_family_t from __sctp_connect()
> for the 1st address.
> 
> So before doing that, __sctp_setsockopt_connectx() should do
> this check first, as sctp_inet_connect() does.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  net/sctp/socket.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index aa80cda..5f92e4a 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -1311,7 +1311,7 @@ static int __sctp_setsockopt_connectx(struct sock *sk,
>  	pr_debug("%s: sk:%p addrs:%p addrs_size:%d\n",
>  		 __func__, sk, addrs, addrs_size);
>  
> -	if (unlikely(addrs_size <= 0))
> +	if (unlikely(addrs_size < sizeof(sa_family_t)))
I don't think this is what you want to check for here.  sa_family_t is
an unsigned short, and addrs_size is the number of bytes in the addrs
array.  The addrs array should be at least the size of one struct
sockaddr (16 bytes iirc), and, if larger, should be a multiple of
sizeof(struct sockaddr)

Neil

>  		return -EINVAL;
>  
>  	kaddrs = memdup_user(addrs, addrs_size);
> -- 
> 2.1.0
> 
> 
