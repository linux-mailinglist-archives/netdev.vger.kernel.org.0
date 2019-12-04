Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4108C11250C
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 09:32:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726679AbfLDIcy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 03:32:54 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:28511 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725951AbfLDIcx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 03:32:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575448372;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2H88vmqiN1pQc08ctaT8baQrkROLbD4ABDtIr1sX3po=;
        b=SgY95byO7f4AuDgGvaRiVHkgfcUxB4k59zomhnALACDGMuqpgntkOKjPO6DeTcjKKOkd+v
        +OQWJ0kVuQHFQjFdQr71RuIiWvewbcLfzmykE/0yDjvWfo2/A0vAXMZfMqmqb+by/C8cvO
        xwcmazdNhsYeQL2o1C3aa4Qh/LUjG6g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-231-2rgH4tTpOuS29vGGEySLSg-1; Wed, 04 Dec 2019 03:32:48 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 39B2B1005509;
        Wed,  4 Dec 2019 08:32:47 +0000 (UTC)
Received: from carbon (ovpn-200-52.brq.redhat.com [10.40.200.52])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 218811D1;
        Wed,  4 Dec 2019 08:32:41 +0000 (UTC)
Date:   Wed, 4 Dec 2019 09:32:40 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <kernel-team@fb.com>, <grygorii.strashko@ti.com>,
        brouer@redhat.com, Ilias Apalodimas <ilias.apalodimas@linaro.org>
Subject: Re: [net PATCH] xdp: obtain the mem_id mutex before trying to
 remove an entry.
Message-ID: <20191204093240.581543f3@carbon>
In-Reply-To: <20191203220114.1524992-1-jonathan.lemon@gmail.com>
References: <20191203220114.1524992-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: 2rgH4tTpOuS29vGGEySLSg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 3 Dec 2019 14:01:14 -0800
Jonathan Lemon <jonathan.lemon@gmail.com> wrote:

> A lockdep splat was observed when trying to remove an xdp memory
> model from the table since the mutex was obtained when trying to
> remove the entry, but not before the table walk started:
> 
> Fix the splat by obtaining the lock before starting the table walk.
> 
> Fixes: c3f812cea0d7 ("page_pool: do not release pool until inflight == 0.")
> Reported-by: Grygorii Strashko <grygorii.strashko@ti.com>
> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>

Have you tested if this patch fix the problem reported by Grygorii?

Link: https://lore.kernel.org/netdev/c2de8927-7bca-612f-cdfd-e9112fee412a@ti.com

Grygorii can you test this?

> ---
>  net/core/xdp.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/net/core/xdp.c b/net/core/xdp.c
> index e334fad0a6b8..7c8390ad4dc6 100644
> --- a/net/core/xdp.c
> +++ b/net/core/xdp.c
> @@ -80,12 +80,8 @@ static void mem_xa_remove(struct xdp_mem_allocator *xa)
>  {
>  	trace_mem_disconnect(xa);
>  
> -	mutex_lock(&mem_id_lock);
> -
>  	if (!rhashtable_remove_fast(mem_id_ht, &xa->node, mem_id_rht_params))
>  		call_rcu(&xa->rcu, __xdp_mem_allocator_rcu_free);
> -
> -	mutex_unlock(&mem_id_lock);
>  }
>  
>  static void mem_allocator_disconnect(void *allocator)
> @@ -93,6 +89,8 @@ static void mem_allocator_disconnect(void *allocator)
>  	struct xdp_mem_allocator *xa;
>  	struct rhashtable_iter iter;
>  
> +	mutex_lock(&mem_id_lock);
> +
>  	rhashtable_walk_enter(mem_id_ht, &iter);
>  	do {
>  		rhashtable_walk_start(&iter);
> @@ -106,6 +104,8 @@ static void mem_allocator_disconnect(void *allocator)
>  
>  	} while (xa == ERR_PTR(-EAGAIN));
>  	rhashtable_walk_exit(&iter);
> +
> +	mutex_unlock(&mem_id_lock);
>  }
>  
>  static void mem_id_disconnect(int id)

Moving the mutex-lock might be a good idea, but I'm not sure that fixes
the issue.  I'm more suspect about the usage of rcu_read_lock() in
xdp_rxq_info_unreg_mem_model(), listed below.

void xdp_rxq_info_unreg_mem_model(struct xdp_rxq_info *xdp_rxq)
{
	struct xdp_mem_allocator *xa;
	int id = xdp_rxq->mem.id;

	if (xdp_rxq->reg_state != REG_STATE_REGISTERED) {
		WARN(1, "Missing register, driver bug");
		return;
	}

	if (id == 0)
		return;

	if (xdp_rxq->mem.type == MEM_TYPE_ZERO_COPY)
		return mem_id_disconnect(id);

	if (xdp_rxq->mem.type == MEM_TYPE_PAGE_POOL) {
		rcu_read_lock();
		xa = rhashtable_lookup(mem_id_ht, &id, mem_id_rht_params);
		page_pool_destroy(xa->page_pool);
		rcu_read_unlock();
	}
}
EXPORT_SYMBOL_GPL(xdp_rxq_info_unreg_mem_model);


-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

