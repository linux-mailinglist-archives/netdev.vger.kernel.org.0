Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AC071F6A74
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 17:00:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728405AbgFKO7X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 10:59:23 -0400
Received: from nautica.notk.org ([91.121.71.147]:48635 "EHLO nautica.notk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727850AbgFKO7V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Jun 2020 10:59:21 -0400
X-Greylist: delayed 489 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Jun 2020 10:59:20 EDT
Received: by nautica.notk.org (Postfix, from userid 1001)
        id 38925C009; Thu, 11 Jun 2020 16:51:10 +0200 (CEST)
Date:   Thu, 11 Jun 2020 16:50:55 +0200
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Wang Hai <wanghai38@huawei.com>
Cc:     ericvh@gmail.com, lucho@ionkov.net, davem@davemloft.net,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 9p/trans_fd: Fix concurrency del of req_list in
 p9_fd_cancelled/p9_read_work
Message-ID: <20200611145055.GA28945@nautica>
References: <20200611014855.60550-1-wanghai38@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200611014855.60550-1-wanghai38@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wang Hai wrote on Thu, Jun 11, 2020:
> p9_read_work and p9_fd_cancelled may be called concurrently.

Good catch. I'm sure this fixes some of the old syzbot bugs...
I'll check other transports handle this properly as well.

> Before list_del(&m->rreq->req_list) in p9_read_work is called,
> the req->req_list may have been deleted in p9_fd_cancelled.
> We can fix it by setting req->status to REQ_STATUS_FLSHD after
> list_del(&req->req_list) in p9_fd_cancelled.

hm if you do that read_work will fail with EIO and all further 9p
messages will not be read?
p9_read_work probably should handle REQ_STATUS_FLSHD in a special case
that just throws the message away without error as well.

> Before list_del(&req->req_list) in p9_fd_cancelled is called,
> the req->req_list may have been deleted in p9_read_work.
> We should return when req->status = REQ_STATUS_RCVD which means
> we just received a response for oldreq, so we need do nothing
> in p9_fd_cancelled.

I'll need some time to convince myself the refcounting is correct in
this case.
Pre-ref counting this definitely was wrong, but now it might just work
by chance.... I'll double-check.

> Fixes: 60ff779c4abb ("9p: client: remove unused code and any reference
> to "cancelled" function")

I don't understand how this commit is related?
At least make it afd8d65411 ("9P: Add cancelled() to the transport
functions.") which adds the op, not something that removed a previous
version of cancelled even earlier.

> diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
> index f868cf6fba79..a563699629cb 100644
> --- a/net/9p/trans_fd.c
> +++ b/net/9p/trans_fd.c
> @@ -718,11 +718,18 @@ static int p9_fd_cancelled(struct p9_client *client, struct p9_req_t *req)
>  {
>  	p9_debug(P9_DEBUG_TRANS, "client %p req %p\n", client, req);
>  
> -	/* we haven't received a response for oldreq,
> -	 * remove it from the list.
> +	/* If req->status == REQ_STATUS_RCVD, it means we just received a
> +	 * response for oldreq, we need do nothing here. Else, remove it from
> +	 * the list.

(nitpick) this feels a bit hard to read, and does not give any
information: you're just paraphrasing the C code.

I would suggest moving the comment after the spinlock and say what we
really do ; something as simple as "ignore cancelled request if message
has been received before lock" is enough.

>  	 */
>  	spin_lock(&client->lock);
> +	if (req->status == REQ_STATUS_RCVD) {
> +		spin_unlock(&client->lock);
> +		return 0;
> +	}
> +
>  	list_del(&req->req_list);
> +	req->status = REQ_STATUS_FLSHD;
>  	spin_unlock(&client->lock);
>  	p9_req_put(req);
>  
-- 
Dominique
