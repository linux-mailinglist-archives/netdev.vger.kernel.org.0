Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 704C15BADE
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 13:41:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728500AbfGALlX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 07:41:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47834 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727296AbfGALlX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Jul 2019 07:41:23 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id EAFF230917AA;
        Mon,  1 Jul 2019 11:41:07 +0000 (UTC)
Received: from carbon (ovpn-200-45.brq.redhat.com [10.40.200.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D3C6219732;
        Mon,  1 Jul 2019 11:41:00 +0000 (UTC)
Date:   Mon, 1 Jul 2019 13:40:59 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Cc:     grygorii.strashko@ti.com, hawk@kernel.org, davem@davemloft.net,
        ast@kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, xdp-newbies@vger.kernel.org,
        ilias.apalodimas@linaro.org, netdev@vger.kernel.org,
        daniel@iogearbox.net, jakub.kicinski@netronome.com,
        john.fastabend@gmail.com, brouer@redhat.com
Subject: Re: [PATCH v5 net-next 1/6] xdp: allow same allocator usage
Message-ID: <20190701134059.71757892@carbon>
In-Reply-To: <20190630172348.5692-2-ivan.khoronzhuk@linaro.org>
References: <20190630172348.5692-1-ivan.khoronzhuk@linaro.org>
        <20190630172348.5692-2-ivan.khoronzhuk@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Mon, 01 Jul 2019 11:41:23 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


I'm very skeptical about this approach.

On Sun, 30 Jun 2019 20:23:43 +0300
Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org> wrote:

> XDP rxqs can be same for ndevs running under same rx napi softirq.
> But there is no ability to register same allocator for both rxqs,
> by fact it can same rxq but has different ndev as a reference.

This description is not very clear. It can easily be misunderstood.

It is an absolute requirement that each RX-queue have their own
page_pool object/allocator. (This where the performance comes from) as
the page_pool have NAPI protected array for alloc and XDP_DROP recycle.

Your driver/hardware seems to have special case, where a single
RX-queue can receive packets for two different net_device'es.

Do you violate this XDP devmap redirect assumption[1]?
[1] https://github.com/torvalds/linux/blob/v5.2-rc7/kernel/bpf/devmap.c#L324-L329


> Due to last changes allocator destroy can be defered till the moment
> all packets are recycled by destination interface, afterwards it's
> freed. In order to schedule allocator destroy only after all users are
> unregistered, add refcnt to allocator object and schedule to destroy
> only it reaches 0.

The guiding principles when designing an API, is to make it easy to
use, but also make it hard to misuse.

Your API change makes it easy to misuse the API.  As it make it easy to
(re)use the allocator pointer (likely page_pool) for multiple
xdp_rxq_info structs.  It is only valid for your use-case, because you
have hardware where a single RX-queue delivers to two different
net_devices.  For other normal use-cases, this will be a violation.

If I was a user of this API, and saw your xdp_allocator_get(), then I
would assume that this was the normal case.  As minimum, we need to add
a comment in the code, about this specific/intended use-case.  I
through about detecting the misuse, by adding a queue_index to
xdp_mem_allocator, that can be checked against, when calling
xdp_rxq_info_reg_mem_model() with another xdp_rxq_info struct (to catch
the obvious mistake where queue_index mismatch).


> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
> ---
>  include/net/xdp_priv.h |  1 +
>  net/core/xdp.c         | 46 ++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 47 insertions(+)
> 
> diff --git a/include/net/xdp_priv.h b/include/net/xdp_priv.h
> index 6a8cba6ea79a..995b21da2f27 100644
> --- a/include/net/xdp_priv.h
> +++ b/include/net/xdp_priv.h
> @@ -18,6 +18,7 @@ struct xdp_mem_allocator {
>  	struct rcu_head rcu;
>  	struct delayed_work defer_wq;
>  	unsigned long defer_warn;
> +	unsigned long refcnt;
>  };
>  
>  #endif /* __LINUX_NET_XDP_PRIV_H__ */
> diff --git a/net/core/xdp.c b/net/core/xdp.c
> index b29d7b513a18..a44621190fdc 100644
> --- a/net/core/xdp.c
> +++ b/net/core/xdp.c
> @@ -98,6 +98,18 @@ bool __mem_id_disconnect(int id, bool force)
>  		WARN(1, "Request remove non-existing id(%d), driver bug?", id);
>  		return true;
>  	}
> +
> +	/* to avoid calling hash lookup twice, decrement refcnt here till it
> +	 * reaches zero, then it can be called from workqueue afterwards.
> +	 */
> +	if (xa->refcnt)
> +		xa->refcnt--;
> +
> +	if (xa->refcnt) {
> +		mutex_unlock(&mem_id_lock);
> +		return true;
> +	}
> +
>  	xa->disconnect_cnt++;
>  
>  	/* Detects in-flight packet-pages for page_pool */
> @@ -312,6 +324,33 @@ static bool __is_supported_mem_type(enum xdp_mem_type type)
>  	return true;
>  }
>  
> +static struct xdp_mem_allocator *xdp_allocator_get(void *allocator)

API wise, when you have "get" operation, you usually also have a "put"
operation...

> +{
> +	struct xdp_mem_allocator *xae, *xa = NULL;
> +	struct rhashtable_iter iter;
> +
> +	mutex_lock(&mem_id_lock);
> +	rhashtable_walk_enter(mem_id_ht, &iter);
> +	do {
> +		rhashtable_walk_start(&iter);
> +
> +		while ((xae = rhashtable_walk_next(&iter)) && !IS_ERR(xae)) {
> +			if (xae->allocator == allocator) {
> +				xae->refcnt++;
> +				xa = xae;
> +				break;
> +			}
> +		}
> +
> +		rhashtable_walk_stop(&iter);
> +
> +	} while (xae == ERR_PTR(-EAGAIN));
> +	rhashtable_walk_exit(&iter);
> +	mutex_unlock(&mem_id_lock);
> +
> +	return xa;
> +}
> +
>  int xdp_rxq_info_reg_mem_model(struct xdp_rxq_info *xdp_rxq,
>  			       enum xdp_mem_type type, void *allocator)
>  {
> @@ -347,6 +386,12 @@ int xdp_rxq_info_reg_mem_model(struct xdp_rxq_info *xdp_rxq,
>  		}
>  	}
>  
> +	xdp_alloc = xdp_allocator_get(allocator);
> +	if (xdp_alloc) {
> +		xdp_rxq->mem.id = xdp_alloc->mem.id;
> +		return 0;
> +	}
> +

The allocator pointer (in-practice) becomes the identifier for the
mem.id (which rhashtable points to xdp_mem_allocator object).


>  	xdp_alloc = kzalloc(sizeof(*xdp_alloc), gfp);
>  	if (!xdp_alloc)
>  		return -ENOMEM;
> @@ -360,6 +405,7 @@ int xdp_rxq_info_reg_mem_model(struct xdp_rxq_info *xdp_rxq,
>  	xdp_rxq->mem.id = id;
>  	xdp_alloc->mem  = xdp_rxq->mem;
>  	xdp_alloc->allocator = allocator;
> +	xdp_alloc->refcnt = 1;
>  
>  	/* Insert allocator into ID lookup table */
>  	ptr = rhashtable_insert_slow(mem_id_ht, &id, &xdp_alloc->node);



-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
