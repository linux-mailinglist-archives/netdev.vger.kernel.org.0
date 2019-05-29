Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D41D12D783
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 10:17:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726453AbfE2IRR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 04:17:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34218 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725956AbfE2IRR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 May 2019 04:17:17 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6A60781F12;
        Wed, 29 May 2019 08:17:09 +0000 (UTC)
Received: from carbon (ovpn-200-30.brq.redhat.com [10.40.200.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7F45760BDF;
        Wed, 29 May 2019 08:17:01 +0000 (UTC)
Date:   Wed, 29 May 2019 10:16:59 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Cc:     grygorii.strashko@ti.com, hawk@kernel.org, davem@davemloft.net,
        ast@kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, xdp-newbies@vger.kernel.org,
        ilias.apalodimas@linaro.org, netdev@vger.kernel.org,
        daniel@iogearbox.net, jakub.kicinski@netronome.com,
        john.fastabend@gmail.com, brouer@redhat.com
Subject: Re: [PATCH net-next 3/3] net: ethernet: ti: cpsw: add XDP support
Message-ID: <20190529101659.2aa714b8@carbon>
In-Reply-To: <20190523182035.9283-4-ivan.khoronzhuk@linaro.org>
References: <20190523182035.9283-1-ivan.khoronzhuk@linaro.org>
        <20190523182035.9283-4-ivan.khoronzhuk@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Wed, 29 May 2019 08:17:17 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 May 2019 21:20:35 +0300
Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org> wrote:

> +static struct page *cpsw_alloc_page(struct cpsw_common *cpsw)
> +{
> +	struct page_pool *pool = cpsw->rx_page_pool;
> +	struct page *page, *prev_page = NULL;
> +	int try = pool->p.pool_size << 2;
> +	int start_free = 0, ret;
> +
> +	do {
> +		page = page_pool_dev_alloc_pages(pool);
> +		if (!page)
> +			return NULL;
> +
> +		/* if netstack has page_pool recycling remove the rest */
> +		if (page_ref_count(page) == 1)
> +			break;
> +
> +		/* start free pages in use, shouldn't happen */
> +		if (prev_page == page || start_free) {
> +			/* dma unmap/puts page if rfcnt != 1 */
> +			page_pool_recycle_direct(pool, page);
> +			start_free = 1;
> +			continue;
> +		}
> +
> +		/* if refcnt > 1, page has been holding by netstack, it's pity,
> +		 * so put it to the ring to be consumed later when fast cash is
> +		 * empty. If ring is full then free page by recycling as above.
> +		 */
> +		ret = ptr_ring_produce(&pool->ring, page);

This looks very wrong to me!  First of all you are manipulation
directly with the internal pool->ring and not using the API, which
makes this code un-maintainable.  Second this is wrong, as page_pool
assume the in-variance that pages on the ring have refcnt==1.

> +		if (ret) {
> +			page_pool_recycle_direct(pool, page);
> +			continue;
> +		}
> +
> +		if (!prev_page)
> +			prev_page = page;
> +	} while (try--);
> +
> +	return page;
> +}


-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
