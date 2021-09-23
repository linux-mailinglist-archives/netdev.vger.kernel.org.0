Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CA7D416659
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 22:05:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243088AbhIWUGk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 16:06:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242982AbhIWUGj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 16:06:39 -0400
Received: from fieldses.org (fieldses.org [IPv6:2600:3c00:e000:2f7::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14BB4C061574;
        Thu, 23 Sep 2021 13:05:08 -0700 (PDT)
Received: by fieldses.org (Postfix, from userid 2815)
        id F34BA7028; Thu, 23 Sep 2021 16:05:06 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 fieldses.org F34BA7028
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fieldses.org;
        s=default; t=1632427506;
        bh=RA7LytCbQ/iS3aTI2O+4kY53kpLk048y3sZRj3y3SoQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ccHyZQ5r/DLwz/dKwnM2ivzA9V2Hsx5GPruga9JZl9f4QhV2o2cMH0PgyswNnOD9J
         GQYpWNgJxLhG9P3ttahx2s5WKehqjLvJjzOtlbDJOcpkho3kg1/KGAQdOiGD9nnrOV
         AwmF8aXzV4ZkL8ML46hdJmCjPi3PtRg9uDnq2HPM=
Date:   Thu, 23 Sep 2021 16:05:06 -0400
From:   "J. Bruce Fields" <bfields@fieldses.org>
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     kuba@kernel.org, davem@davemloft.net, anna.schumaker@netapp.com,
        trond.myklebust@hammerspace.com, chuck.lever@oracle.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] UNRPC: Return specific error code on kmalloc
 failure
Message-ID: <20210923200506.GF18334@fieldses.org>
References: <1631266404-29698-1-git-send-email-yang.lee@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1631266404-29698-1-git-send-email-yang.lee@linux.alibaba.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 10, 2021 at 05:33:24PM +0800, Yang Li wrote:
> Although the callers of this function only care about whether the
> return value is null or not, we should still give a rigorous
> error code.

Eh, I'm not sure I understand why this is important but, OK,
applying.--b.

> 
> Smatch tool warning:
> net/sunrpc/auth_gss/svcauth_gss.c:784 gss_write_verf() warn: returning
> -1 instead of -ENOMEM is sloppy
> 
> No functional change, just more standardized.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
> ---
>  net/sunrpc/auth_gss/svcauth_gss.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/sunrpc/auth_gss/svcauth_gss.c b/net/sunrpc/auth_gss/svcauth_gss.c
> index 3e776e3..7dba6a9 100644
> --- a/net/sunrpc/auth_gss/svcauth_gss.c
> +++ b/net/sunrpc/auth_gss/svcauth_gss.c
> @@ -781,7 +781,7 @@ static inline u32 round_up_to_quad(u32 i)
>  	svc_putnl(rqstp->rq_res.head, RPC_AUTH_GSS);
>  	xdr_seq = kmalloc(4, GFP_KERNEL);
>  	if (!xdr_seq)
> -		return -1;
> +		return -ENOMEM;
>  	*xdr_seq = htonl(seq);
>  
>  	iov.iov_base = xdr_seq;
> -- 
> 1.8.3.1
