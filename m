Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31E57303056
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 00:39:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732833AbhAYXiA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 18:38:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:37606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732663AbhAYXhc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Jan 2021 18:37:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0B25A2226A;
        Mon, 25 Jan 2021 23:36:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611617811;
        bh=btQutt9g5gmPo92SiwndArw245bwhH2tfk1kHeGLqwA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VhQoLJXnNotLp3TZxEwUaKno4R5egQqxuQj+wh74UvfI4Zrfk8cqifEJiqsVtl7e6
         1wWOIsOTGBMgopWtGz4r/Ga7aUieMivVs2FnYdgEcEjQxscgUVDBdvNvNO/a9qkoc2
         27wWtYe/7ZCZCysNAmnGu7NWcvh3VXR2+UbwN2bhdCp9Pekr4PlS1IL6i4OHak6GEx
         JEs7/tlN2sBB5JuBWqw60OBYMrXd4n23AdqdKKAiTFKo7wJOaUTOkmSX/tFsuYvQco
         wE66K+C/Lv+ZWypcsUX4l1E691Dedcw/eo2HL6iMWaMGoY4lbhfGppNXIn4mPjsTGv
         kQUdcgvlbFW3g==
Date:   Mon, 25 Jan 2021 15:36:50 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        andy.rudoff@intel.com, Rao Shoaib <rao.shoaib@oracle.com>
Subject: Re: [PATCH] af_unix: Allow Unix sockets to raise SIGURG
Message-ID: <20210125153650.18c84b1a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210122150638.210444-1-willy@infradead.org>
References: <20210122150638.210444-1-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 22 Jan 2021 15:06:37 +0000 Matthew Wilcox (Oracle) wrote:
> From: Rao Shoaib <rao.shoaib@oracle.com>
> 
> TCP sockets allow SIGURG to be sent to the process holding the other
> end of the socket.  Extend Unix sockets to have the same ability.
> 
> The API is the same in that the sender uses sendmsg() with MSG_OOB to
> raise SIGURG.  Unix sockets behave in the same way as TCP sockets with
> SO_OOBINLINE set.

Noob question, if we only want to support the inline mode, why don't we
require SO_OOBINLINE to have been called on @other? Wouldn't that
provide more consistent behavior across address families?

With the current implementation the receiver will also not see MSG_OOB
set in msg->msg_flags, right?

> SIGURG is ignored by default, so applications which do not know about this
> feature will be unaffected.  In addition to installing a SIGURG handler,
> the receiving application must call F_SETOWN or F_SETOWN_EX to indicate
> which process or thread should receive the signal.
> 
> Signed-off-by: Rao Shoaib <rao.shoaib@oracle.com>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  net/unix/af_unix.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
> index 41c3303c3357..849dff688c2c 100644
> --- a/net/unix/af_unix.c
> +++ b/net/unix/af_unix.c
> @@ -1837,8 +1837,6 @@ static int unix_stream_sendmsg(struct socket *sock, struct msghdr *msg,
>  		return err;
>  
>  	err = -EOPNOTSUPP;
> -	if (msg->msg_flags&MSG_OOB)
> -		goto out_err;
>  
>  	if (msg->msg_namelen) {
>  		err = sk->sk_state == TCP_ESTABLISHED ? -EISCONN : -EOPNOTSUPP;
> @@ -1903,6 +1901,9 @@ static int unix_stream_sendmsg(struct socket *sock, struct msghdr *msg,
>  		sent += size;
>  	}
>  
> +	if (msg->msg_flags & MSG_OOB)
> +		sk_send_sigurg(other);
> +
>  	scm_destroy(&scm);
>  
>  	return sent;

