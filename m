Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69A652A5A77
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 00:19:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728551AbgKCXS7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 18:18:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:43882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728026AbgKCXS7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Nov 2020 18:18:59 -0500
Received: from sx1.lan (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A495223BD;
        Tue,  3 Nov 2020 23:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604445538;
        bh=a5jwVxgTVf1eMXAnuVLtgOMvkf5sQwePVAZ2zBFA0b8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ct2woLUT5OcDe1U00+KS1ZNkN1YUnYyDyHIj58R8zkjrpbhGu3iFRZnOvibFQKoyV
         4RBIqboUj71X9oLr53HVOok9IipjAwuGDIgXzBRi/2l015HtX+cn8ZtXUvI9KSmYnJ
         F9KSXZOBsmuNe005yiPQPqXBzNZqF5593LwTAWVk=
Message-ID: <5c28ff0dbee9895665082fc2cfb59c15dc905322.camel@kernel.org>
Subject: Re: [PATCH 2/4] gve: Add support for raw addressing to the rx path
From:   Saeed Mahameed <saeed@kernel.org>
To:     David Awogbemila <awogbemila@google.com>, netdev@vger.kernel.org
Cc:     Catherine Sullivan <csully@google.com>,
        Yangchun Fu <yangchun@google.com>
Date:   Tue, 03 Nov 2020 15:18:57 -0800
In-Reply-To: <20201103174651.590586-3-awogbemila@google.com>
References: <20201103174651.590586-1-awogbemila@google.com>
         <20201103174651.590586-3-awogbemila@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2020-11-03 at 09:46 -0800, David Awogbemila wrote:
> From: Catherine Sullivan <csully@google.com>
> 
> Add support to use raw dma addresses in the rx path. Due to this new
> support we can alloc a new buffer instead of making a copy.
> 
> RX buffers are handed to the networking stack and are
> re-allocated as needed, avoiding the need to use
> skb_copy_to_linear_data() as in "qpl" mode.
> 
> Reviewed-by: Yangchun Fu <yangchun@google.com>
> Signed-off-by: Catherine Sullivan <csully@google.com>
> Signed-off-by: David Awogbemila <awogbemila@google.com>
> ---
>  drivers/net/ethernet/google/gve/gve.h        |   9 +-
>  drivers/net/ethernet/google/gve/gve_adminq.c |  14 +-
>  drivers/net/ethernet/google/gve/gve_desc.h   |  10 +-
>  drivers/net/ethernet/google/gve/gve_main.c   |   3 +-
>  drivers/net/ethernet/google/gve/gve_rx.c     | 220 +++++++++++++++
> ----
>  5 files changed, 203 insertions(+), 53 deletions(-)
> 

...

>  static inline u32 gve_num_rx_qpls(struct gve_priv *priv)
>  {
> -	return priv->rx_cfg.num_queues;
> +	if (priv->raw_addressing)
> +		return 0;
> +	else
> +		return priv->rx_cfg.num_queues;

else statement is redundant.


>  
>  static int gve_prefill_rx_pages(struct gve_rx_ring *rx)
>  {
>  	struct gve_priv *priv = rx->gve;
>  	u32 slots;
> +	int err;
>  	int i;
>  
>  	/* Allocate one page per Rx queue slot. Each page is split into
> two
> @@ -71,12 +96,31 @@ static int gve_prefill_rx_pages(struct
> gve_rx_ring *rx)
>  	if (!rx->data.page_info)
>  		return -ENOMEM;
>  
> -	rx->data.qpl = gve_assign_rx_qpl(priv);
> -
> +	if (!rx->data.raw_addressing)
> +		rx->data.qpl = gve_assign_rx_qpl(priv);
>  	for (i = 0; i < slots; i++) {
> -		struct page *page = rx->data.qpl->pages[i];
> -		dma_addr_t addr = i * PAGE_SIZE;
> +		struct page *page;
> +		dma_addr_t addr;
> +
> +		if (rx->data.raw_addressing) {
> +			err = gve_alloc_page(priv, &priv->pdev->dev,
> &page,
> +					     &addr, DMA_FROM_DEVICE);
> +			if (err) {
> +				int j;
>  

the code is skewed right, 5 level indentation is a lot.
you can just goto alloc_err; and handle the rewind on the exit path of
the function .

BTW you could split this loop to two independent flows if you utilize 
gve_rx_alloc_buffer()

if (!raw_Addressing) {
        page = rx->data.qpl->pages[i];
	addr = i * PAGE_SIZE;
	gve_setup_rx_buffer(...);
        continue;
}

/* raw addressing mode */
err = gve_rx_alloc_buffer(...); 
if (err)
      goto alloc_err;



