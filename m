Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20402177C3D
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 17:46:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727989AbgCCQpk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 11:45:40 -0500
Received: from fieldses.org ([173.255.197.46]:37318 "EHLO fieldses.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726899AbgCCQpk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Mar 2020 11:45:40 -0500
Received: by fieldses.org (Postfix, from userid 2815)
        id 24CC11D3E; Tue,  3 Mar 2020 11:45:40 -0500 (EST)
Date:   Tue, 3 Mar 2020 11:45:40 -0500
From:   "J. Bruce Fields" <bfields@fieldses.org>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfs@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] svcrdma: Replace zero-length array with
 flexible-array member
Message-ID: <20200303164540.GB19140@fieldses.org>
References: <20200217200500.GA7628@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200217200500.GA7628@embeddedor>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Applying for 5.7, thanks.--b.

On Mon, Feb 17, 2020 at 02:05:00PM -0600, Gustavo A. R. Silva wrote:
> The current codebase makes use of the zero-length array language
> extension to the C90 standard, but the preferred mechanism to declare
> variable-length types such as these ones is a flexible array member[1][2],
> introduced in C99:
> 
> struct foo {
>         int stuff;
>         struct boo array[];
> };
> 
> By making use of the mechanism above, we will get a compiler warning
> in case the flexible array does not occur last in the structure, which
> will help us prevent some kind of undefined behavior bugs from being
> inadvertently introduced[3] to the codebase from now on.
> 
> Also, notice that, dynamic memory allocations won't be affected by
> this change:
> 
> "Flexible array members have incomplete type, and so the sizeof operator
> may not be applied. As a quirk of the original implementation of
> zero-length arrays, sizeof evaluates to zero."[1]
> 
> This issue was found with the help of Coccinelle.
> 
> [1] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
> [2] https://github.com/KSPP/linux/issues/21
> [3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")
> 
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> ---
>  net/sunrpc/xprtrdma/svc_rdma_rw.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/sunrpc/xprtrdma/svc_rdma_rw.c b/net/sunrpc/xprtrdma/svc_rdma_rw.c
> index 48fe3b16b0d9..003610ce00bc 100644
> --- a/net/sunrpc/xprtrdma/svc_rdma_rw.c
> +++ b/net/sunrpc/xprtrdma/svc_rdma_rw.c
> @@ -41,7 +41,7 @@ struct svc_rdma_rw_ctxt {
>  	struct rdma_rw_ctx	rw_ctx;
>  	int			rw_nents;
>  	struct sg_table		rw_sg_table;
> -	struct scatterlist	rw_first_sgl[0];
> +	struct scatterlist	rw_first_sgl[];
>  };
>  
>  static inline struct svc_rdma_rw_ctxt *
> -- 
> 2.25.0
