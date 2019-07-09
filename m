Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6308E63921
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 18:16:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726585AbfGIQP7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 12:15:59 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:47048 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725816AbfGIQP7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 12:15:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=dCpzFzu5/U/he9Oo9VsjZUs68uCHS4wh8DDRIspguLY=; b=Ds586ejCEExvMxDQM6zwFPeBH
        kaA+bMZBmskIlrdYh8RE6ZVHf9Lh+O+gJE5BmWCqK3tbZhqGYVk4AwTGtSKs6o/CWdpUMUJuezJ1T
        tXrlXR1ng40iAM4lhSAwrOeuZ7kzTyfZ5rShXjpLIXSUB+bSSHGCMl6FI8TSwOyXEXofGEpSwiCtw
        vjsLaLVrOmIuzT46BuLplm5VZS/G/cxkCs2bi/YvnfCHAjxY25sRekw1BFgbaD+3lJgxHLZiR9oNH
        cZXpXN0SB7wlerrq2i37lxXPnzF+GL38QPexntwuX8wQ0GmeLCvsIlgHr9KT9FobLmrrgnBSg5f2s
        Vpp/7zbyg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hksmU-0003ek-Hu; Tue, 09 Jul 2019 16:15:50 +0000
Date:   Tue, 9 Jul 2019 09:15:50 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Jian-Hong Pan <jian-hong@endlessm.com>
Cc:     Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        David Laight <David.Laight@aculab.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@endlessm.com,
        Daniel Drake <drake@endlessm.com>
Subject: Re: [PATCH v2 2/2] rtw88: pci: Use DMA sync instead of remapping in
 RX ISR
Message-ID: <20190709161550.GA8703@infradead.org>
References: <20190708063252.4756-1-jian-hong@endlessm.com>
 <20190709102059.7036-2-jian-hong@endlessm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190709102059.7036-2-jian-hong@endlessm.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 09, 2019 at 06:21:01PM +0800, Jian-Hong Pan wrote:
> Since each skb in RX ring is reused instead of new allocation, we can
> treat the DMA in a more efficient way by DMA synchronization.
> 
> Signed-off-by: Jian-Hong Pan <jian-hong@endlessm.com>
> ---
>  drivers/net/wireless/realtek/rtw88/pci.c | 35 ++++++++++++++++++++++--
>  1 file changed, 32 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtw88/pci.c b/drivers/net/wireless/realtek/rtw88/pci.c
> index e9fe3ad896c8..28ca76f71dfe 100644
> --- a/drivers/net/wireless/realtek/rtw88/pci.c
> +++ b/drivers/net/wireless/realtek/rtw88/pci.c
> @@ -206,6 +206,35 @@ static int rtw_pci_reset_rx_desc(struct rtw_dev *rtwdev, struct sk_buff *skb,
>  	return 0;
>  }
>  
> +static int rtw_pci_sync_rx_desc_cpu(struct rtw_dev *rtwdev, dma_addr_t dma)
> +{
> +	struct device *dev = rtwdev->dev;
> +	int buf_sz = RTK_PCI_RX_BUF_SIZE;
> +
> +	dma_sync_single_for_cpu(dev, dma, buf_sz, PCI_DMA_FROMDEVICE);
> +
> +	return 0;
> +}

No need to return a value from this helper. In fact I'm not even sure
you need the helper at all.  Also please use the DMA_FROM_DEVICE
constant instead of the deprecated PCI variant.

> +static int rtw_pci_sync_rx_desc_device(struct rtw_dev *rtwdev, dma_addr_t dma,
> +				       struct rtw_pci_rx_ring *rx_ring,
> +				       u32 idx, u32 desc_sz)
> +{
> +	struct device *dev = rtwdev->dev;
> +	struct rtw_pci_rx_buffer_desc *buf_desc;
> +	int buf_sz = RTK_PCI_RX_BUF_SIZE;
> +
> +	dma_sync_single_for_device(dev, dma, buf_sz, PCI_DMA_FROMDEVICE);
> +
> +	buf_desc = (struct rtw_pci_rx_buffer_desc *)(rx_ring->r.head +
> +						     idx * desc_sz);
> +	memset(buf_desc, 0, sizeof(*buf_desc));
> +	buf_desc->buf_size = cpu_to_le16(RTK_PCI_RX_BUF_SIZE);
> +	buf_desc->dma = cpu_to_le32(dma);
> +
> +	return 0;
> +}

Same comment on the PCI constant and the return value here.
