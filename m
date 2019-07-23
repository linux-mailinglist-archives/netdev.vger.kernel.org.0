Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 044D17187C
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 14:45:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729825AbfGWMpq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 08:45:46 -0400
Received: from mx.0dd.nl ([5.2.79.48]:47576 "EHLO mx.0dd.nl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727724AbfGWMpq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jul 2019 08:45:46 -0400
Received: from mail.vdorst.com (mail.vdorst.com [IPv6:fd01::250])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.0dd.nl (Postfix) with ESMTPS id 373A55FD59;
        Tue, 23 Jul 2019 14:45:43 +0200 (CEST)
Authentication-Results: mx.0dd.nl;
        dkim=pass (2048-bit key; secure) header.d=vdorst.com header.i=@vdorst.com header.b="SfdsrJJ4";
        dkim-atps=neutral
Received: from www (www.vdorst.com [192.168.2.222])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.vdorst.com (Postfix) with ESMTPSA id 021041D22519;
        Tue, 23 Jul 2019 14:45:43 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.vdorst.com 021041D22519
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vdorst.com;
        s=default; t=1563885943;
        bh=k9RXmH6jgFE/f4WBomDyt2/hQHrkTkE3r4gN+UgmrLQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SfdsrJJ47YZE9T6LxxGCX38kt+7eqsc6Qph5Fp9A06gC9HIHRFcaAplyYYeBoL+a1
         TYC6I79WQwQnyJGZcpcs6h/wvdxpU5FAHvwANBhHIPCW8QR0I2GdwXYHzLmdoL7RHL
         YuWvfvukJvGSMRaZWKcOb13Mmv3Gr2NdDSQzkTOYfqcC1/QGrofd93gw2/HW0DYiMq
         ++TuxaqKaPyF2ABpCpUeIRGoVDFT1qGWLFx/oDROl0IkhslkTpoHs/MQ4m4+gEeyG/
         AoUVmEAhLszIgofeUwuFAGAgVBok2ajGVx86cmH3aT/h9gAgM/843gA0qCLZn3Shjk
         2pRF2YT2lK0ig==
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1]) by
 www.vdorst.com (Horde Framework) with HTTPS; Tue, 23 Jul 2019 12:45:42 +0000
Date:   Tue, 23 Jul 2019 12:45:42 +0000
Message-ID: <20190723124542.Horde.V1atRU6HCQ6ct8dJCXossTs@www.vdorst.com>
From:   =?utf-8?b?UmVuw6k=?= van Dorst <opensource@vdorst.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     kbuild-all@01.org, netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [net-next:master 13/14]
 drivers/net/ethernet/faraday/ftgmac100.c:777:13: error: 'skb_frag_t {aka
 struct bio_vec}' has no member named 'size'
References: <201907231400.Q5QaKepi%lkp@intel.com>
 <20190723085844.Horde.ehPsGFdWI2BCQdl_UyzJxlS@www.vdorst.com>
 <20190723115238.GJ363@bombadil.infradead.org>
In-Reply-To: <20190723115238.GJ363@bombadil.infradead.org>
User-Agent: Horde Application Framework 5
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting Matthew Wilcox <willy@infradead.org>:

> On Tue, Jul 23, 2019 at 08:58:44AM +0000, René van Dorst wrote:
>> Hi Matthew,
>>
>> I see the same issue for the mediatek/mtk_eth_soc driver.
>
> Thanks, Rene.  The root problem for both of these drivers is that neither
> are built on x86 with CONFIG_COMPILE_TEST.  Is it possible to fix this?
>
> An untested patch to fix both of these problems (and two more that I
> spotted):

Hi Matthew,

Your patch fixes the build error.

I am not sure if iperf3 also triggers this code on my mt7621 device.
iperf3 results seems normal.

Greats,

René


>
> diff --git a/drivers/atm/he.c b/drivers/atm/he.c
> index 211607986134..70b00ae4ec38 100644
> --- a/drivers/atm/he.c
> +++ b/drivers/atm/he.c
> @@ -2580,10 +2580,9 @@ he_send(struct atm_vcc *vcc, struct sk_buff *skb)
>  			slot = 0;
>  		}
>
> -		tpd->iovec[slot].addr = dma_map_single(&he_dev->pci_dev->dev,
> -			(void *) page_address(frag->page) + frag->page_offset,
> -				frag->size, DMA_TO_DEVICE);
> -		tpd->iovec[slot].len = frag->size;
> +		tpd->iovec[slot].addr = skb_frag_dma_map(&he_dev->pci_dev->dev,
> +				frag, 0, skb_frag_size(frag), DMA_TO_DEVICE);
> +		tpd->iovec[slot].len = skb_frag_size(frag);
>  		++slot;
>
>  	}
> diff --git a/drivers/net/ethernet/faraday/ftgmac100.c  
> b/drivers/net/ethernet/faraday/ftgmac100.c
> index 030fed65393e..dc8d3e726e75 100644
> --- a/drivers/net/ethernet/faraday/ftgmac100.c
> +++ b/drivers/net/ethernet/faraday/ftgmac100.c
> @@ -774,7 +774,7 @@ static netdev_tx_t  
> ftgmac100_hard_start_xmit(struct sk_buff *skb,
>  	for (i = 0; i < nfrags; i++) {
>  		skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
>
> -		len = frag->size;
> +		len = skb_frag_size(frag);
>
>  		/* Map it */
>  		map = skb_frag_dma_map(priv->dev, frag, 0, len,
> diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c  
> b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> index f38c3fa7d705..9c4d1afa34e5 100644
> --- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> +++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> @@ -1958,7 +1958,7 @@ static int skb_to_sg_fd(struct dpaa_priv *priv,
>  	/* populate the rest of SGT entries */
>  	for (i = 0; i < nr_frags; i++) {
>  		frag = &skb_shinfo(skb)->frags[i];
> -		frag_len = frag->size;
> +		frag_len = skb_frag_size(frag);
>  		WARN_ON(!skb_frag_page(frag));
>  		addr = skb_frag_dma_map(dev, frag, 0,
>  					frag_len, dma_dir);
> diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c  
> b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> index 00991df44ed6..e529d86468b8 100644
> --- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> +++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> @@ -787,7 +787,8 @@ static inline int mtk_cal_txd_req(struct sk_buff *skb)
>  	if (skb_is_gso(skb)) {
>  		for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
>  			frag = &skb_shinfo(skb)->frags[i];
> -			nfrags += DIV_ROUND_UP(frag->size, MTK_TX_DMA_BUF_LEN);
> +			nfrags += DIV_ROUND_UP(skb_frag_size(frag),
> +						MTK_TX_DMA_BUF_LEN);
>  		}
>  	} else {
>  		nfrags += skb_shinfo(skb)->nr_frags;



