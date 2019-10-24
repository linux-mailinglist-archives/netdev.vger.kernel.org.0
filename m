Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE1C2E28D7
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 05:28:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437271AbfJXD2P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 23:28:15 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:41454 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437263AbfJXD2O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 23:28:14 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::b7e])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A299C14B7A410;
        Wed, 23 Oct 2019 20:28:13 -0700 (PDT)
Date:   Wed, 23 Oct 2019 20:28:13 -0700 (PDT)
Message-Id: <20191023.202813.607713311547571229.davem@davemloft.net>
To:     mcroce@redhat.com
Cc:     netdev@vger.kernel.org, antoine.tenart@bootlin.com,
        maxime.chevallier@bootlin.com, mw@semihalf.com,
        stefanc@marvell.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] mvpp2: prefetch frame header
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191022141438.22002-1-mcroce@redhat.com>
References: <20191022141438.22002-1-mcroce@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 23 Oct 2019 20:28:14 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matteo Croce <mcroce@redhat.com>
Date: Tue, 22 Oct 2019 16:14:38 +0200

> When receiving traffic, eth_type_trans() is high up on the perf top list,
> because it's the first function which access the packet data.
> 
> Move the DMA unmap a bit higher, and put a prefetch just after it, so we
> have more time to load the data into the cache.
> 
> The packet rate increase is about 13% with a tc drop test: 1620 => 1830 kpps
> 
> Signed-off-by: Matteo Croce <mcroce@redhat.com>
> ---
>  drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> index 111b3b8239e1..17378e0d8da1 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> @@ -2966,6 +2966,11 @@ static int mvpp2_rx(struct mvpp2_port *port, struct napi_struct *napi,
>  			continue;
>  		}
>  
> +		dma_unmap_single(dev->dev.parent, dma_addr,
> +				 bm_pool->buf_size, DMA_FROM_DEVICE);
> +
> +		prefetch(data);
> +
>  		if (bm_pool->frag_size > PAGE_SIZE)
>  			frag_size = 0;
>  		else

You cannot unmap it this early, because of all of the err_drop_frame
code paths that might be taken next.  The DMA mapping must stay in place
in those cases.
