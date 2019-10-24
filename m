Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5598AE2E25
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 12:08:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393203AbfJXKH7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 06:07:59 -0400
Received: from fudo.makrotopia.org ([185.142.180.71]:45402 "EHLO
        fudo.makrotopia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389290AbfJXKH7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 06:07:59 -0400
X-Greylist: delayed 1422 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Oct 2019 06:07:57 EDT
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
         (Exim 4.92.2)
        (envelope-from <daniel@makrotopia.org>)
        id 1iNZey-0004X9-F4; Thu, 24 Oct 2019 11:44:04 +0200
Date:   Thu, 24 Oct 2019 11:43:39 +0200
From:   Daniel Golle <daniel@makrotopia.org>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Oleksandr Natalenko <oleksandr@natalenko.name>,
        linux-kernel@vger.kernel.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, Roy Luo <royluo@google.com>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>, Felix Fietkau <nbd@nbd.name>
Subject: Re: mt76x2e hardware restart
Message-ID: <20191024094339.GB1252@makrotopia.org>
References: <deaafa7a3e9ea2111ebb5106430849c6@natalenko.name>
 <c6d621759c190f7810d898765115f3b4@natalenko.name>
 <9d581001e2e6cece418329842b2b0959@natalenko.name>
 <20191012165028.GA8739@lore-desk-wlan.lan>
 <f7695bc79d40bbc96744a639b1243027@natalenko.name>
 <96f43a2103a9f2be152c53f867f5805c@natalenko.name>
 <20191016163842.GA18799@localhost.localdomain>
 <20191023085039.GB2461@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191023085039.GB2461@localhost.localdomain>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Lorenzo,

On Wed, Oct 23, 2019 at 10:50:39AM +0200, Lorenzo Bianconi wrote:
> ...
> I think I spotted the SG issue on mt76x2e. Could you please:
> - keep pcie_aspm patch I sent
> - remove the debug patch where I disabled TX Scatter-Gather on mt76x2e
> - apply the following patch

With those two patches I'm for the first time able to use the U7612
mPCIe module on my x86 Laptop in a more or less stable way.
In now 10 hours uptime I had one serious hickup of
[35790.926455] mt76x2e 0000:02:00.0: MCU message 31 (seq 11) timed out
[35790.991227] mt76x2e 0000:02:00.0: Firmware Version: 0.0.00
[35790.991231] mt76x2e 0000:02:00.0: Build: 1
[35790.991233] mt76x2e 0000:02:00.0: Build Time: 201507311614____
[35791.016460] mt76x2e 0000:02:00.0: Firmware running!
[35791.017153] ieee80211 phy0: Hardware restart was requested
...(repeating about 10 times, every 20 seconds)
and one less serious, all related to MCU message 31.
However, unlike before, the hardware actually recovers and works
quite well most of the time.

Thank you!!!

Cheers

Daniel

> 
> Regards,
> Lorenzo
> 
> mt76: dma: fix buffer unmap with non-linear skbs
> 
> mt76 dma layer is supposed to unmap skb data buffers while keep txwi mapped
> on hw dma ring. At the moment mt76 wrongly unmap txwi or does not unmap data
> fragments in even positions for non-linear skbs. This issue may result in hw
> hangs with A-MSUD if the system relies on IOMMU or SWIOTLB.
> Fix this behaviour marking first and last queue entries introducing
> MT_QUEUE_ENTRY_FIRST and MT_QUEUE_ENTRY_LAST flags and properly unmap
> data fragments
> 
> Fixes: 17f1de56df05 ("mt76: add common code shared between multiple chipsets")
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  drivers/net/wireless/mediatek/mt76/dma.c  | 33 +++++++++++++----------
>  drivers/net/wireless/mediatek/mt76/mt76.h |  3 +++
>  2 files changed, 22 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
> index 4da7cffbab29..a3026a0ca8c5 100644
> --- a/drivers/net/wireless/mediatek/mt76/dma.c
> +++ b/drivers/net/wireless/mediatek/mt76/dma.c
> @@ -54,7 +54,7 @@ mt76_dma_add_buf(struct mt76_dev *dev, struct mt76_queue *q,
>  	int i, idx = -1;
>  
>  	if (txwi)
> -		q->entry[q->head].txwi = DMA_DUMMY_DATA;
> +		q->entry[q->head].flags = MT_QUEUE_ENTRY_FIRST;
>  
>  	for (i = 0; i < nbufs; i += 2, buf += 2) {
>  		u32 buf0 = buf[0].addr, buf1 = 0;
> @@ -83,6 +83,7 @@ mt76_dma_add_buf(struct mt76_dev *dev, struct mt76_queue *q,
>  		q->queued++;
>  	}
>  
> +	q->entry[idx].flags |= MT_QUEUE_ENTRY_LAST;
>  	q->entry[idx].txwi = txwi;
>  	q->entry[idx].skb = skb;
>  
> @@ -93,27 +94,31 @@ static void
>  mt76_dma_tx_cleanup_idx(struct mt76_dev *dev, struct mt76_queue *q, int idx,
>  			struct mt76_queue_entry *prev_e)
>  {
> +	__le32 addr, __ctrl = READ_ONCE(q->desc[idx].ctrl);
>  	struct mt76_queue_entry *e = &q->entry[idx];
> -	__le32 __ctrl = READ_ONCE(q->desc[idx].ctrl);
> -	u32 ctrl = le32_to_cpu(__ctrl);
> -
> -	if (!e->txwi || !e->skb) {
> -		__le32 addr = READ_ONCE(q->desc[idx].buf0);
> -		u32 len = FIELD_GET(MT_DMA_CTL_SD_LEN0, ctrl);
> +	u32 len, ctrl = le32_to_cpu(__ctrl);
>  
> +	if (e->flags & MT_QUEUE_ENTRY_FIRST) {
> +		addr = READ_ONCE(q->desc[idx].buf1);
> +		len = FIELD_GET(MT_DMA_CTL_SD_LEN1, ctrl);
>  		dma_unmap_single(dev->dev, le32_to_cpu(addr), len,
>  				 DMA_TO_DEVICE);
> -	}
> -
> -	if (!(ctrl & MT_DMA_CTL_LAST_SEC0)) {
> -		__le32 addr = READ_ONCE(q->desc[idx].buf1);
> -		u32 len = FIELD_GET(MT_DMA_CTL_SD_LEN1, ctrl);
> -
> +	} else {
> +		addr = READ_ONCE(q->desc[idx].buf0);
> +		len = FIELD_GET(MT_DMA_CTL_SD_LEN0, ctrl);
>  		dma_unmap_single(dev->dev, le32_to_cpu(addr), len,
>  				 DMA_TO_DEVICE);
> +		if (e->txwi &&
> +		    ((ctrl & MT_DMA_CTL_LAST_SEC1) ||
> +		     !(e->flags & MT_QUEUE_ENTRY_LAST))) {
> +			addr = READ_ONCE(q->desc[idx].buf1);
> +			len = FIELD_GET(MT_DMA_CTL_SD_LEN1, ctrl);
> +			dma_unmap_single(dev->dev, le32_to_cpu(addr), len,
> +					 DMA_TO_DEVICE);
> +		}
>  	}
>  
> -	if (e->txwi == DMA_DUMMY_DATA)
> +	if (!(e->flags & MT_QUEUE_ENTRY_LAST))
>  		e->txwi = NULL;
>  
>  	if (e->skb == DMA_DUMMY_DATA)
> diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
> index e95a5893f93b..b0ac82b31789 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt76.h
> +++ b/drivers/net/wireless/mediatek/mt76/mt76.h
> @@ -83,6 +83,8 @@ struct mt76_tx_info {
>  	u32 info;
>  };
>  
> +#define MT_QUEUE_ENTRY_FIRST	BIT(0)
> +#define MT_QUEUE_ENTRY_LAST	BIT(1)
>  struct mt76_queue_entry {
>  	union {
>  		void *buf;
> @@ -95,6 +97,7 @@ struct mt76_queue_entry {
>  	enum mt76_txq_id qid;
>  	bool schedule;
>  	bool done;
> +	u32 flags;
>  };
>  
>  struct mt76_queue_regs {
> -- 
> 2.21.0
> 
> > 
> > Regards,
> > Lorenzo
> > 
> > > 
> > > -- 
> > >   Oleksandr Natalenko (post-factum)
> 
> 



> _______________________________________________
> Linux-mediatek mailing list
> Linux-mediatek@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-mediatek

