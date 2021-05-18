Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07540387DFE
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 18:57:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350947AbhERQ6N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 12:58:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244114AbhERQ6N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 May 2021 12:58:13 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE8BEC061573;
        Tue, 18 May 2021 09:56:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=qyKJRbFTV93LiLXWxvzyFcJFk7aSvtQn/KPe+Lil9pI=; b=fGL9CLnIJKl6Fcuh2XtpKNxbMc
        G4lrSmyzwpjo4OYcddJH22NPUI8k1De/WaaOrjj0CCxY8wSTpILU6tVtGFGAy9C312tZk8uljd5VD
        5gAx8Ik1txEPKGi3WkloIdImiM0keHT6ZxXV2hIUAcSIDPa6VeL45qyY6rgixiYbYGFdSC6GM7izC
        XGS0KbfQgw3Ilxw2NzrJ4Wl/5mgh8lWO4BPcy5FNBPJHd7MsZl8n9eBiGgTWwRXydHcfnG6Hi8eyY
        xEHTor/AWUJHULJ2MJ8QVcKR2SFUzbSVxfa4pladjKxPQoq3xH2vljHsMg7Apu7T9HjDt7cPS4COW
        kHOLPY/g==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lj30d-00EArZ-9T; Tue, 18 May 2021 16:56:09 +0000
Date:   Tue, 18 May 2021 17:55:55 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Rao Shoaib <Rao.Shoaib@oracle.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        matthew.wilcox@oracle.com
Subject: Re: [RFC net-next af_unix v1 1/1] net:af_unix: Allow unix sockets to
 raise SIGURG
Message-ID: <YKPxm8+8Wz5mTPba@casper.infradead.org>
References: <20210518074343.980438-1-Rao.Shoaib@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210518074343.980438-1-Rao.Shoaib@oracle.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 18, 2021 at 12:43:43AM -0700, Rao Shoaib wrote:
> From: Rao Shoaib <rao.shoaib@oracle.com>
> 
> TCP sockets allow SIGURG to be sent to the process holding the other
> end of the socket.  Extend Unix sockets to have the same ability.
> 
> The API is the same in that the sender uses sendmsg() with MSG_OOB to
> raise SIGURG.  Unix sockets behave in the same way as TCP sockets with
> SO_OOBINLINE set.
> 
> SIGURG is ignored by default, so applications which do not know about this
> feature will be unaffected.  In addition to installing a SIGURG handler,
> the receiving application must call F_SETOWN or F_SETOWN_EX to indicate
> which process or thread should receive the signal.
> 
> Signed-off-by: Rao Shoaib <rao.shoaib@oracle.com>
> Signed-off-by: Matthew Wilcox <matthew.wilcox@oracle.com>

Please don't forge my Signed-off-by.  With that line deleted,

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>

> ---
>  net/unix/af_unix.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
> index 5a31307ceb76..c8400c002882 100644
> --- a/net/unix/af_unix.c
> +++ b/net/unix/af_unix.c
> @@ -1838,8 +1838,6 @@ static int unix_stream_sendmsg(struct socket *sock, struct msghdr *msg,
>  		return err;
>  
>  	err = -EOPNOTSUPP;
> -	if (msg->msg_flags&MSG_OOB)
> -		goto out_err;
>  
>  	if (msg->msg_namelen) {
>  		err = sk->sk_state == TCP_ESTABLISHED ? -EISCONN : -EOPNOTSUPP;
> @@ -1904,6 +1902,9 @@ static int unix_stream_sendmsg(struct socket *sock, struct msghdr *msg,
>  		sent += size;
>  	}
>  
> +	if (msg->msg_flags & MSG_OOB)
> +		sk_send_sigurg(other);
> +
>  	scm_destroy(&scm);
>  
>  	return sent;
> -- 
> 2.31.1
> 
