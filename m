Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BE6FAE483
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 09:15:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730594AbfIJHPj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 03:15:39 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:54562 "EHLO
        smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726192AbfIJHPj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 03:15:39 -0400
Received: from [88.214.186.143] (helo=localhost)
        by smtp.tuxdriver.com with esmtpsa (TLSv1:AES256-SHA:256)
        (Exim 4.63)
        (envelope-from <nhorman@tuxdriver.com>)
        id 1i7aN7-00040c-IV; Tue, 10 Sep 2019 03:15:36 -0400
Date:   Tue, 10 Sep 2019 03:15:21 -0400
From:   Neil Horman <nhorman@tuxdriver.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        davem@davemloft.net,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: Re: [PATCH net] sctp: fix the missing put_user when dumping
 transport thresholds
Message-ID: <20190910071521.GA31884@localhost.localdomain>
References: <3fa4f7700c93f06530c80bc666d1696cb7c077de.1568014409.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3fa4f7700c93f06530c80bc666d1696cb7c077de.1568014409.git.lucien.xin@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Spam-Score: -2.9 (--)
X-Spam-Status: No
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 09, 2019 at 03:33:29PM +0800, Xin Long wrote:
> This issue causes SCTP_PEER_ADDR_THLDS sockopt not to be able to dump
> a transport thresholds info.
> 
> Fix it by adding 'goto' put_user in sctp_getsockopt_paddr_thresholds.
> 
> Fixes: 8add543e369d ("sctp: add SCTP_FUTURE_ASSOC for SCTP_PEER_ADDR_THLDS sockopt")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  net/sctp/socket.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/sctp/socket.c b/net/sctp/socket.c
> index 9d1f83b..ad87518 100644
> --- a/net/sctp/socket.c
> +++ b/net/sctp/socket.c
> @@ -7173,7 +7173,7 @@ static int sctp_getsockopt_paddr_thresholds(struct sock *sk,
>  		val.spt_pathmaxrxt = trans->pathmaxrxt;
>  		val.spt_pathpfthld = trans->pf_retrans;
>  
> -		return 0;
> +		goto out;
>  	}
>  
>  	asoc = sctp_id2assoc(sk, val.spt_assoc_id);
> @@ -7191,6 +7191,7 @@ static int sctp_getsockopt_paddr_thresholds(struct sock *sk,
>  		val.spt_pathmaxrxt = sp->pathmaxrxt;
>  	}
>  
> +out:
>  	if (put_user(len, optlen) || copy_to_user(optval, &val, len))
>  		return -EFAULT;
>  
> -- 
> 2.1.0
> 
> 
Acked-by: Neil Horman <nhorman@tuxdriver.com>

