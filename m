Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B163C5F62D
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 12:01:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727488AbfGDKAd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 06:00:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39094 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727470AbfGDKAc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Jul 2019 06:00:32 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D6434C0586C4;
        Thu,  4 Jul 2019 10:00:28 +0000 (UTC)
Received: from carbon (ovpn-200-17.brq.redhat.com [10.40.200.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 879E2379C;
        Thu,  4 Jul 2019 10:00:19 +0000 (UTC)
Date:   Thu, 4 Jul 2019 12:00:18 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     brouer@redhat.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Subject: Re: [PATCH net-next 3/3] net: stmmac: Introducing support for Page
 Pool
Message-ID: <20190704120018.4523a119@carbon>
In-Reply-To: <1b254bb7fc6044c5e6e2fdd9e00088d1d13a808b.1562149883.git.joabreu@synopsys.com>
References: <cover.1562149883.git.joabreu@synopsys.com>
        <1b254bb7fc6044c5e6e2fdd9e00088d1d13a808b.1562149883.git.joabreu@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Thu, 04 Jul 2019 10:00:32 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  3 Jul 2019 12:37:50 +0200
Jose Abreu <Jose.Abreu@synopsys.com> wrote:

> @@ -3547,6 +3456,9 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
>  
>  			napi_gro_receive(&ch->rx_napi, skb);
>  
> +			page_pool_recycle_direct(rx_q->page_pool, buf->page);

This doesn't look correct.

The page_pool DMA mapping cannot be "kept" when page traveling into the
network stack attached to an SKB.  (Ilias and I have a long term plan[1]
to allow this, but you cannot do it ATM).

You will have to call:
  page_pool_release_page(rx_q->page_pool, buf->page);

This will do a DMA-unmap, and you will likely loose your performance
gain :-(


> +			buf->page = NULL;
> +
>  			priv->dev->stats.rx_packets++;
>  			priv->dev->stats.rx_bytes += frame_len;
>  		}

Also remember that the page_pool requires you driver to do the DMA-sync
operation.  I see a dma_sync_single_for_cpu(), but I didn't see a
dma_sync_single_for_device() (well, I noticed one getting removed).
(For some HW Ilias tells me that the dma_sync_single_for_device can be
elided, so maybe this can still be correct for you).


[1] https://github.com/xdp-project/xdp-project/blob/master/areas/mem/page_pool02_SKB_return_callback.org
-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
