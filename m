Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BCF5292A48
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 17:23:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730097AbgJSPXE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 11:23:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729544AbgJSPXD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 11:23:03 -0400
Received: from fieldses.org (fieldses.org [IPv6:2600:3c00:e000:2f7::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D22D2C0613CE;
        Mon, 19 Oct 2020 08:23:02 -0700 (PDT)
Received: by fieldses.org (Postfix, from userid 2815)
        id E5ADBAAD; Mon, 19 Oct 2020 11:23:01 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 fieldses.org E5ADBAAD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fieldses.org;
        s=default; t=1603120981;
        bh=lT5xtlsxdwOYkecuDWJlMrE8tDokDHNn495zYSF9O6g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=joviL40jSOAtezsmhplLPOD506JpAKoE7uAJXqz9d5tKuxsgLjzu7RUEVujcEdkZe
         hZi5lpwnRHX4cywOrMhkd5Wui10LqL4MCOg9YVE/veJ6ilSTIsnTw8Uq6RZpEBlFdK
         ObD5ClmzEJkWXd77ArKXZpDkLAjIxqiljgfasrDk=
Date:   Mon, 19 Oct 2020 11:23:01 -0400
From:   "J. Bruce Fields" <bfields@fieldses.org>
To:     Martijn de Gouw <martijn.de.gouw@prodrive-technologies.com>
Cc:     Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, NeilBrown <neilb@suse.de>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Roberto Bergantinos Corpas <rbergant@redhat.com>,
        "open list:NFS, SUNRPC, AND LOCKD CLIENTS" 
        <linux-nfs@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] SUNRPC: fix copying of multiple pages in
 gss_read_proxy_verf()
Message-ID: <20201019152301.GC32403@fieldses.org>
References: <20201019114229.52973-1-martijn.de.gouw@prodrive-technologies.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201019114229.52973-1-martijn.de.gouw@prodrive-technologies.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 19, 2020 at 01:42:27PM +0200, Martijn de Gouw wrote:
> When the passed token is longer than 4032 bytes, the remaining part
> of the token must be copied from the rqstp->rq_arg.pages. But the
> copy must make sure it happens in a consecutive way.

Thanks.  Apologies, but I don't immediately see where the copy is
non-consecutive.  What exactly is the bug in the existing code?

--b.

> 
> Signed-off-by: Martijn de Gouw <martijn.de.gouw@prodrive-technologies.com>
> ---
>  net/sunrpc/auth_gss/svcauth_gss.c | 27 +++++++++++++++++----------
>  1 file changed, 17 insertions(+), 10 deletions(-)
> 
> diff --git a/net/sunrpc/auth_gss/svcauth_gss.c b/net/sunrpc/auth_gss/svcauth_gss.c
> index 258b04372f85..bd4678db9d76 100644
> --- a/net/sunrpc/auth_gss/svcauth_gss.c
> +++ b/net/sunrpc/auth_gss/svcauth_gss.c
> @@ -1147,9 +1147,9 @@ static int gss_read_proxy_verf(struct svc_rqst *rqstp,
>  			       struct gssp_in_token *in_token)
>  {
>  	struct kvec *argv = &rqstp->rq_arg.head[0];
> -	unsigned int page_base, length;
> -	int pages, i, res;
> -	size_t inlen;
> +	unsigned int length, pgto_offs, pgfrom_offs;
> +	int pages, i, res, pgto, pgfrom;
> +	size_t inlen, to_offs, from_offs;
>  
>  	res = gss_read_common_verf(gc, argv, authp, in_handle);
>  	if (res)
> @@ -1177,17 +1177,24 @@ static int gss_read_proxy_verf(struct svc_rqst *rqstp,
>  	memcpy(page_address(in_token->pages[0]), argv->iov_base, length);
>  	inlen -= length;
>  
> -	i = 1;
> -	page_base = rqstp->rq_arg.page_base;
> +	to_offs = length;
> +	from_offs = rqstp->rq_arg.page_base;
>  	while (inlen) {
> -		length = min_t(unsigned int, inlen, PAGE_SIZE);
> -		memcpy(page_address(in_token->pages[i]),
> -		       page_address(rqstp->rq_arg.pages[i]) + page_base,
> +		pgto = to_offs >> PAGE_SHIFT;
> +		pgfrom = from_offs >> PAGE_SHIFT;
> +		pgto_offs = to_offs & ~PAGE_MASK;
> +		pgfrom_offs = from_offs & ~PAGE_MASK;
> +
> +		length = min_t(unsigned int, inlen,
> +			 min_t(unsigned int, PAGE_SIZE - pgto_offs,
> +			       PAGE_SIZE - pgfrom_offs));
> +		memcpy(page_address(in_token->pages[pgto]) + pgto_offs,
> +		       page_address(rqstp->rq_arg.pages[pgfrom]) + pgfrom_offs,
>  		       length);
>  
> +		to_offs += length;
> +		from_offs += length;
>  		inlen -= length;
> -		page_base = 0;
> -		i++;
>  	}
>  	return 0;
>  }
> -- 
> 2.20.1
