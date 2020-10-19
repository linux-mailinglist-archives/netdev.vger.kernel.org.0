Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B4832930EC
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 00:04:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387800AbgJSWEl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 18:04:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387789AbgJSWEl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 18:04:41 -0400
Received: from fieldses.org (fieldses.org [IPv6:2600:3c00:e000:2f7::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5809C0613CE;
        Mon, 19 Oct 2020 15:04:40 -0700 (PDT)
Received: by fieldses.org (Postfix, from userid 2815)
        id D2023ABC; Mon, 19 Oct 2020 18:04:39 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 fieldses.org D2023ABC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fieldses.org;
        s=default; t=1603145079;
        bh=pHT45ccTuok+op00pL2TV3tQJKjTMnhWNMf1KA4PwoU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=G1OgnST/gN2QkFK5f+2holxaHhBR6QuKfzIhisMVa7tAz3OfpkgU8JVkFDoLpXxZw
         y9+o7IYVilw+iuqGnAkz5ERfab+Qd8BaKfyWzX0qTKBYvGPatc6d1MwforBM9rELe4
         gnDKlL8CExdro9VlcbbLUrHl7fA/fh0maiSNc7NY=
Date:   Mon, 19 Oct 2020 18:04:39 -0400
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
Message-ID: <20201019220439.GC6692@fieldses.org>
References: <20201019114229.52973-1-martijn.de.gouw@prodrive-technologies.com>
 <20201019152301.GC32403@fieldses.org>
 <834dc52b-34fc-fee5-0274-fdc8932040e6@prodrive-technologies.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <834dc52b-34fc-fee5-0274-fdc8932040e6@prodrive-technologies.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 19, 2020 at 03:46:39PM +0000, Martijn de Gouw wrote:
> Hi
> 
> On 19-10-2020 17:23, J. Bruce Fields wrote:
> > On Mon, Oct 19, 2020 at 01:42:27PM +0200, Martijn de Gouw wrote:
> >> When the passed token is longer than 4032 bytes, the remaining part
> >> of the token must be copied from the rqstp->rq_arg.pages. But the
> >> copy must make sure it happens in a consecutive way.
> > 
> > Thanks.  Apologies, but I don't immediately see where the copy is
> > non-consecutive.  What exactly is the bug in the existing code?
> 
> In the first memcpy 'length' bytes are copied from argv->iobase, but 
> since the header is in front, this never fills the whole first page of 
> in_token->pages.
> 
> The memcpy in the loop copies the following bytes, but starts writing at 
> the next page of in_token->pages. This leaves the last bytes of page 0 
> unwritten.
> 
> Next to that, the remaining data is in page 0 of rqstp->rq_arg.pages, 
> not page 1.

Got it, thanks.  Looks like the culprit might be a patch from a year ago
from Chuck, 5866efa8cbfb "SUNRPC: Fix svcauth_gss_proxy_init()"?  At
least, that's the last major patch to touch this code.

--b.

> 
> Regards, Martijn
> 
> > 
> > --b.
> > 
> >>
> >> Signed-off-by: Martijn de Gouw <martijn.de.gouw@prodrive-technologies.com>
> >> ---
> >>   net/sunrpc/auth_gss/svcauth_gss.c | 27 +++++++++++++++++----------
> >>   1 file changed, 17 insertions(+), 10 deletions(-)
> >>
> >> diff --git a/net/sunrpc/auth_gss/svcauth_gss.c b/net/sunrpc/auth_gss/svcauth_gss.c
> >> index 258b04372f85..bd4678db9d76 100644
> >> --- a/net/sunrpc/auth_gss/svcauth_gss.c
> >> +++ b/net/sunrpc/auth_gss/svcauth_gss.c
> >> @@ -1147,9 +1147,9 @@ static int gss_read_proxy_verf(struct svc_rqst *rqstp,
> >>   			       struct gssp_in_token *in_token)
> >>   {
> >>   	struct kvec *argv = &rqstp->rq_arg.head[0];
> >> -	unsigned int page_base, length;
> >> -	int pages, i, res;
> >> -	size_t inlen;
> >> +	unsigned int length, pgto_offs, pgfrom_offs;
> >> +	int pages, i, res, pgto, pgfrom;
> >> +	size_t inlen, to_offs, from_offs;
> >>   
> >>   	res = gss_read_common_verf(gc, argv, authp, in_handle);
> >>   	if (res)
> >> @@ -1177,17 +1177,24 @@ static int gss_read_proxy_verf(struct svc_rqst *rqstp,
> >>   	memcpy(page_address(in_token->pages[0]), argv->iov_base, length);
> >>   	inlen -= length;
> >>   
> >> -	i = 1;
> >> -	page_base = rqstp->rq_arg.page_base;
> >> +	to_offs = length;
> >> +	from_offs = rqstp->rq_arg.page_base;
> >>   	while (inlen) {
> >> -		length = min_t(unsigned int, inlen, PAGE_SIZE);
> >> -		memcpy(page_address(in_token->pages[i]),
> >> -		       page_address(rqstp->rq_arg.pages[i]) + page_base,
> >> +		pgto = to_offs >> PAGE_SHIFT;
> >> +		pgfrom = from_offs >> PAGE_SHIFT;
> >> +		pgto_offs = to_offs & ~PAGE_MASK;
> >> +		pgfrom_offs = from_offs & ~PAGE_MASK;
> >> +
> >> +		length = min_t(unsigned int, inlen,
> >> +			 min_t(unsigned int, PAGE_SIZE - pgto_offs,
> >> +			       PAGE_SIZE - pgfrom_offs));
> >> +		memcpy(page_address(in_token->pages[pgto]) + pgto_offs,
> >> +		       page_address(rqstp->rq_arg.pages[pgfrom]) + pgfrom_offs,
> >>   		       length);
> >>   
> >> +		to_offs += length;
> >> +		from_offs += length;
> >>   		inlen -= length;
> >> -		page_base = 0;
> >> -		i++;
> >>   	}
> >>   	return 0;
> >>   }
> >> -- 
> >> 2.20.1
> 
> -- 
> Martijn de Gouw
> Designer
> Prodrive Technologies
> Mobile: +31 63 17 76 161
> Phone:  +31 40 26 76 200
