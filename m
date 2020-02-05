Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE2AA152729
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 08:43:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728009AbgBEHns (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 02:43:48 -0500
Received: from nautica.notk.org ([91.121.71.147]:46412 "EHLO nautica.notk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725468AbgBEHns (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Feb 2020 02:43:48 -0500
Received: by nautica.notk.org (Postfix, from userid 1001)
        id AC309C009; Wed,  5 Feb 2020 08:35:19 +0100 (CET)
Date:   Wed, 5 Feb 2020 08:35:04 +0100
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Sergey Alirzaev <l29ah@cock.li>
Cc:     v9fs-developer@lists.sourceforge.net,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] 9pnet: allow making incomplete read requests
Message-ID: <20200205073504.GA16626@nautica>
References: <20200205003457.24340-1-l29ah@cock.li>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200205003457.24340-1-l29ah@cock.li>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sergey Alirzaev wrote on Wed, Feb 05, 2020:
> A user doesn't necessarily want to wait for all the requested data to
> be available, since the waiting time is unbounded.

I'm not sure I agree on the argument there: the waiting time is
unbounded for a single request as well. What's your use case?

I think it would be better to describe what you really do with
O_NONBLOCK that requires this, and not just false theoritical
arguments.


> Signed-off-by: Sergey Alirzaev <l29ah@cock.li>

Code-wise looks mostly good, just a nitpick about keeping the total
variable in p9_client_read_once inline.

> ---
>  include/net/9p/client.h |   2 +
>  net/9p/client.c         | 133 ++++++++++++++++++++++------------------
>  2 files changed, 76 insertions(+), 59 deletions(-)
> 
> --- a/net/9p/client.c
> +++ b/net/9p/client.c
> @@ -1548,83 +1548,98 @@ EXPORT_SYMBOL(p9_client_unlinkat);
>  
>  int
>  p9_client_read(struct p9_fid *fid, u64 offset, struct iov_iter *to, int *err)
> +{
> +	int total = 0;
> +	*err = 0;
> +
> +	while (iov_iter_count(to)) {
> +		int count;
> +
> +		count = p9_client_read_once(fid, offset, to, err);
> +		if (!count || *err)
> +			break;
> +		offset += count;
> +		total += count;
> +	}
> +	return total;
> +}
> +EXPORT_SYMBOL(p9_client_read);
> +
> +int
> +p9_client_read_once(struct p9_fid *fid, u64 offset, struct iov_iter *to,
> +		    int *err)
>  {
>  	struct p9_client *clnt = fid->clnt;
>  	struct p9_req_t *req;
>  	int total = 0;

total only makes sense in an iterating p9_client_read, I think it makes
code harder to read here (can basically use count or 0 directly now)

> -	*err = 0;
> +	int count = iov_iter_count(to);
> +	int rsize, non_zc = 0;
> +	char *dataptr;
>  
> +	*err = 0;
>  	p9_debug(P9_DEBUG_9P, ">>> TREAD fid %d offset %llu %d\n",
>  		   fid->fid, (unsigned long long) offset, (int)iov_iter_count(to));
>  
> -	while (iov_iter_count(to)) {
> -		int count = iov_iter_count(to);
> -		int rsize, non_zc = 0;
> -		char *dataptr;
> +	rsize = fid->iounit;
> +	if (!rsize || rsize > clnt->msize - P9_IOHDRSZ)
> +		rsize = clnt->msize - P9_IOHDRSZ;
>  
> -		rsize = fid->iounit;
> -		if (!rsize || rsize > clnt->msize-P9_IOHDRSZ)
> -			rsize = clnt->msize - P9_IOHDRSZ;
> +	if (count < rsize)
> +		rsize = count;
>  
> -		if (count < rsize)
> -			rsize = count;
> +	/* Don't bother zerocopy for small IO (< 1024) */
> +	if (clnt->trans_mod->zc_request && rsize > 1024) {
> +		/* response header len is 11
> +		 * PDU Header(7) + IO Size (4)
> +		 */
> +		req = p9_client_zc_rpc(clnt, P9_TREAD, to, NULL, rsize,
> +				       0, 11, "dqd", fid->fid,
> +				       offset, rsize);
> +	} else {
> +		non_zc = 1;
> +		req = p9_client_rpc(clnt, P9_TREAD, "dqd", fid->fid, offset,
> +				    rsize);
> +	}
> +	if (IS_ERR(req)) {
> +		*err = PTR_ERR(req);
> +		return total;
> +	}
>  
> -		/* Don't bother zerocopy for small IO (< 1024) */
> -		if (clnt->trans_mod->zc_request && rsize > 1024) {
> -			/*
> -			 * response header len is 11
> -			 * PDU Header(7) + IO Size (4)
> -			 */
> -			req = p9_client_zc_rpc(clnt, P9_TREAD, to, NULL, rsize,
> -					       0, 11, "dqd", fid->fid,
> -					       offset, rsize);
> -		} else {
> -			non_zc = 1;
> -			req = p9_client_rpc(clnt, P9_TREAD, "dqd", fid->fid, offset,
> -					    rsize);
> -		}
> -		if (IS_ERR(req)) {
> -			*err = PTR_ERR(req);
> -			break;
> -		}
> +	*err = p9pdu_readf(&req->rc, clnt->proto_version,
> +			   "D", &count, &dataptr);
> +	if (*err) {
> +		trace_9p_protocol_dump(clnt, &req->rc);
> +		p9_tag_remove(clnt, req);
> +		return total;
> +	}
> +	if (rsize < count) {
> +		pr_err("bogus RREAD count (%d > %d)\n", count, rsize);
> +		count = rsize;
> +	}
>  
> -		*err = p9pdu_readf(&req->rc, clnt->proto_version,
> -				   "D", &count, &dataptr);
> -		if (*err) {
> -			trace_9p_protocol_dump(clnt, &req->rc);
> -			p9_tag_remove(clnt, req);
> -			break;
> -		}
> -		if (rsize < count) {
> -			pr_err("bogus RREAD count (%d > %d)\n", count, rsize);
> -			count = rsize;
> -		}
> +	p9_debug(P9_DEBUG_9P, "<<< RREAD count %d\n", count);
> +	if (!count) {
> +		p9_tag_remove(clnt, req);
> +		return total;
> +	}
>  
> -		p9_debug(P9_DEBUG_9P, "<<< RREAD count %d\n", count);
> -		if (!count) {
> -			p9_tag_remove(clnt, req);
> -			break;
> -		}
> +	if (non_zc) {
> +		int n = copy_to_iter(dataptr, count, to);
>  
> -		if (non_zc) {
> -			int n = copy_to_iter(dataptr, count, to);
> -			total += n;
> -			offset += n;
> -			if (n != count) {
> -				*err = -EFAULT;
> -				p9_tag_remove(clnt, req);
> -				break;
> -			}
> -		} else {
> -			iov_iter_advance(to, count);
> -			total += count;
> -			offset += count;
> +		total += n;
> +		if (n != count) {
> +			*err = -EFAULT;
> +			p9_tag_remove(clnt, req);
> +			return total;
>  		}
> -		p9_tag_remove(clnt, req);
> +	} else {
> +		iov_iter_advance(to, count);
> +		total += count;
>  	}
> +	p9_tag_remove(clnt, req);
>  	return total;
>  }
> -EXPORT_SYMBOL(p9_client_read);
> +EXPORT_SYMBOL(p9_client_read_once);
>  
>  int
>  p9_client_write(struct p9_fid *fid, u64 offset, struct iov_iter *from, int *err)

-- 
Dominique
