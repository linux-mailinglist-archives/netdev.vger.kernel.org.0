Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09A7F74F0E
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 15:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389888AbfGYNUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 09:20:16 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:18063 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389776AbfGYNUO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 09:20:14 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d39ac940000>; Thu, 25 Jul 2019 06:20:20 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 25 Jul 2019 06:20:12 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 25 Jul 2019 06:20:12 -0700
Received: from [10.21.132.148] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 25 Jul
 2019 13:20:09 +0000
Subject: Re: [PATCH net-next 3/3] net: stmmac: Introducing support for Page
 Pool
To:     Jose Abreu <Jose.Abreu@synopsys.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>
CC:     Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Robin Murphy <robin.murphy@arm.com>,
        "wens@csie.org" <wens@csie.org>,
        linux-tegra <linux-tegra@vger.kernel.org>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>
References: <cover.1562149883.git.joabreu@synopsys.com>
 <1b254bb7fc6044c5e6e2fdd9e00088d1d13a808b.1562149883.git.joabreu@synopsys.com>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <7a79be5d-7ba2-c457-36d3-1ccef6572181@nvidia.com>
Date:   Thu, 25 Jul 2019 14:20:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1b254bb7fc6044c5e6e2fdd9e00088d1d13a808b.1562149883.git.joabreu@synopsys.com>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1564060820; bh=0UU4p4fjSvuq+XgEx2myYMcD6cODEFOXywbe+DQR42Y=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=isQLuIiSVeLw7cn+/BRLZrFTRMXNgmPPF16oiSOHPfNeyumjr63w6TZtNtKuV1T2e
         P17wS19TRokQFI5cvZJ76VRFyYk7PuYIqQjQ5Bf68HgOB/N7gSId073r5SUhZ+ASVS
         chMa2uQjJG6MDZl06C5fOdJvC3ytWA9s1ol0J3TuqoRgBPNbialMHD/+1CuqvUbnsi
         HhVtgM7YnBPHMqCIwicc16LgQL5ZUS7eyJFoNwjIOpHsrj1W40KMJevK4K5a89qYSK
         91RNn6AJCz70A6CHt+WcnSBkGdCPktYqRFL5wxve7j99z5Jnoy5X1Bj2WS6Ikm5F2R
         5SFgMFTGGbZjg==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 03/07/2019 11:37, Jose Abreu wrote:
> Mapping and unmapping DMA region is an high bottleneck in stmmac driver,
> specially in the RX path.
> 
> This commit introduces support for Page Pool API and uses it in all RX
> queues. With this change, we get more stable troughput and some increase
> of banwidth with iperf:
> 	- MAC1000 - 950 Mbps
> 	- XGMAC: 9.22 Gbps
> 
> Signed-off-by: Jose Abreu <joabreu@synopsys.com>
> Cc: Joao Pinto <jpinto@synopsys.com>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
> Cc: Alexandre Torgue <alexandre.torgue@st.com>
> Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
> Cc: Maxime Ripard <maxime.ripard@bootlin.com>
> Cc: Chen-Yu Tsai <wens@csie.org>
> ---
>  drivers/net/ethernet/stmicro/stmmac/Kconfig       |   1 +
>  drivers/net/ethernet/stmicro/stmmac/stmmac.h      |  10 +-
>  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 196 ++++++----------------
>  3 files changed, 63 insertions(+), 144 deletions(-)

...

> @@ -3306,49 +3295,22 @@ static inline void stmmac_rx_refill(struct stmmac_priv *priv, u32 queue)
>  		else
>  			p = rx_q->dma_rx + entry;
>  
> -		if (likely(!rx_q->rx_skbuff[entry])) {
> -			struct sk_buff *skb;
> -
> -			skb = netdev_alloc_skb_ip_align(priv->dev, bfsize);
> -			if (unlikely(!skb)) {
> -				/* so for a while no zero-copy! */
> -				rx_q->rx_zeroc_thresh = STMMAC_RX_THRESH;
> -				if (unlikely(net_ratelimit()))
> -					dev_err(priv->device,
> -						"fail to alloc skb entry %d\n",
> -						entry);
> -				break;
> -			}
> -
> -			rx_q->rx_skbuff[entry] = skb;
> -			rx_q->rx_skbuff_dma[entry] =
> -			    dma_map_single(priv->device, skb->data, bfsize,
> -					   DMA_FROM_DEVICE);
> -			if (dma_mapping_error(priv->device,
> -					      rx_q->rx_skbuff_dma[entry])) {
> -				netdev_err(priv->dev, "Rx DMA map failed\n");
> -				dev_kfree_skb(skb);
> +		if (!buf->page) {
> +			buf->page = page_pool_dev_alloc_pages(rx_q->page_pool);
> +			if (!buf->page)
>  				break;
> -			}
> -
> -			stmmac_set_desc_addr(priv, p, rx_q->rx_skbuff_dma[entry]);
> -			stmmac_refill_desc3(priv, rx_q, p);
> -
> -			if (rx_q->rx_zeroc_thresh > 0)
> -				rx_q->rx_zeroc_thresh--;
> -
> -			netif_dbg(priv, rx_status, priv->dev,
> -				  "refill entry #%d\n", entry);
>  		}
> -		dma_wmb();
> +
> +		buf->addr = buf->page->dma_addr;
> +		stmmac_set_desc_addr(priv, p, buf->addr);
> +		stmmac_refill_desc3(priv, rx_q, p);
>  
>  		rx_q->rx_count_frames++;
>  		rx_q->rx_count_frames %= priv->rx_coal_frames;
>  		use_rx_wd = priv->use_riwt && rx_q->rx_count_frames;
>  
> -		stmmac_set_rx_owner(priv, p, use_rx_wd);
> -
>  		dma_wmb();
> +		stmmac_set_rx_owner(priv, p, use_rx_wd);
>  
>  		entry = STMMAC_GET_ENTRY(entry, DMA_RX_SIZE);
>  	}

I was looking at this change in a bit closer detail and one thing that
stuck out to me was the above where the barrier had been moved from
after the stmmac_set_rx_owner() call to before. 

So I moved this back and I no longer saw the crash. However, then I
recalled I had the patch to enable the debug prints for the buffer
address applied but after reverting that, the crash occurred again. 

In other words, what works for me is moving the above barrier and adding
the debug print, which appears to suggest that there is some
timing/coherency issue here. Anyway, maybe this is clue to what is going
on?

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index a7486c2f3221..2f016397231b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3303,8 +3303,8 @@ static inline void stmmac_rx_refill(struct stmmac_priv *priv, u32 queue)
                rx_q->rx_count_frames %= priv->rx_coal_frames;
                use_rx_wd = priv->use_riwt && rx_q->rx_count_frames;
 
-               dma_wmb();
                stmmac_set_rx_owner(priv, p, use_rx_wd);
+               dma_wmb();
 
                entry = STMMAC_GET_ENTRY(entry, DMA_RX_SIZE);
        }
@@ -3438,6 +3438,10 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
                        dma_sync_single_for_device(priv->device, buf->addr,
                                                   frame_len, DMA_FROM_DEVICE);
 
+                       pr_info("%s: paddr=0x%llx, vaddr=0x%llx, len=%d", __func__,
+                                       buf->addr, page_address(buf->page),
+                                       frame_len);
+
                        if (netif_msg_pktdata(priv)) {
                                netdev_dbg(priv->dev, "frame received (%dbytes)",
                                           frame_len);

Cheers
Jon

-- 
nvpublic
