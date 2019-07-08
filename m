Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C94F66206D
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 16:26:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731590AbfGHO0P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 10:26:15 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:37524 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727413AbfGHO0P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 10:26:15 -0400
Received: by mail-pf1-f195.google.com with SMTP id 19so7713531pfa.4
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 07:26:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=5oNB+D0MeaMiNAek/iB8WJmexNS/sGqIyyhbfDeaRmE=;
        b=LkEje841QrsS6DA66E0JRppYtJoNTbY+j6S5WEPVUN22ncol8StAHdsm8wLLiNcaBM
         fW9fwesIcqg0QcZGveO9rW44hO6617Adsk5vQA7KEjTpkh7+SOvMZdYTQo0ip63jqviK
         MWQL7frMZPiZNw4H0Ku3T7+fbtTbuKR/hiFXE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=5oNB+D0MeaMiNAek/iB8WJmexNS/sGqIyyhbfDeaRmE=;
        b=g6hVENFN88OfMcIMsYOrwpHU6+CtxsyRRQCXxQvupzaNkfK79oy/kj50EXG4X1Vu8F
         60G5rvPLRacLTPnWtBQ7Gzmnpc2XxbfSZowWucCrg1x8Dc3N/PEOO0UXAs/c1Zak4W01
         dTBvmka8CtCicPVESE35saAC30KgtkzNaZ5UepuY4iAe/SfIoeXFX1aQQpMaY9Bd5D7u
         rmnAD5kwhmLQjhkgAxcz7gzlV1j7fh7RIgNIU7c6SwkG3iZ0G1vmKNvntfBApQxoQ4r2
         DDYR4K+kqIbPe5luTvPaX3nwD1Pl+AmZj2jaN2E6Wy6CHjMJISf3m6cfwIpzAibSiTXi
         fBWQ==
X-Gm-Message-State: APjAAAX9qbewH6EThUv+njn2Aq9CZhMIOLlWgnu1EG4TEYa1DzCvZBoD
        0jilsSmFruHv6KG8a/m9EUPD9g==
X-Google-Smtp-Source: APXvYqxkuwYESoZiBr91sHAl2Yj8hVhAcPK5WXiCBSaOrxS0tN6WyRU1KJ9H3oAI3YCS4egPA3W2ow==
X-Received: by 2002:a17:90a:9386:: with SMTP id q6mr25737567pjo.81.1562595974211;
        Mon, 08 Jul 2019 07:26:14 -0700 (PDT)
Received: from C02RW35GFVH8.dhcp.broadcom.net ([192.19.231.250])
        by smtp.gmail.com with ESMTPSA id u16sm17431103pjb.2.2019.07.08.07.26.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Jul 2019 07:26:13 -0700 (PDT)
From:   Andy Gospodarek <andrew.gospodarek@broadcom.com>
X-Google-Original-From: Andy Gospodarek <gospo@broadcom.com>
Date:   Mon, 8 Jul 2019 10:26:06 -0400
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     Michael Chan <michael.chan@broadcom.com>, davem@davemloft.net,
        netdev@vger.kernel.org, hawk@kernel.org, ast@kernel.org,
        ivan.khoronzhuk@linaro.org
Subject: Re: [PATCH net-next 3/4] bnxt_en: optimized XDP_REDIRECT support
Message-ID: <20190708142606.GF87269@C02RW35GFVH8.dhcp.broadcom.net>
References: <1562398578-26020-1-git-send-email-michael.chan@broadcom.com>
 <1562398578-26020-4-git-send-email-michael.chan@broadcom.com>
 <20190708082803.GA28592@apalos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190708082803.GA28592@apalos>
User-Agent: Mutt/1.8.0 (2017-02-23)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 08, 2019 at 11:28:03AM +0300, Ilias Apalodimas wrote:
> Thanks Andy, Michael
> 
> > +	if (event & BNXT_REDIRECT_EVENT)
> > +		xdp_do_flush_map();
> > +
> >  	if (event & BNXT_TX_EVENT) {
> >  		struct bnxt_tx_ring_info *txr = bnapi->tx_ring;
> >  		u16 prod = txr->tx_prod;
> > @@ -2254,9 +2257,23 @@ static void bnxt_free_tx_skbs(struct bnxt *bp)
> >  
> >  		for (j = 0; j < max_idx;) {
> >  			struct bnxt_sw_tx_bd *tx_buf = &txr->tx_buf_ring[j];
> > -			struct sk_buff *skb = tx_buf->skb;
> > +			struct sk_buff *skb;
> >  			int k, last;
> >  
> > +			if (i < bp->tx_nr_rings_xdp &&
> > +			    tx_buf->action == XDP_REDIRECT) {
> > +				dma_unmap_single(&pdev->dev,
> > +					dma_unmap_addr(tx_buf, mapping),
> > +					dma_unmap_len(tx_buf, len),
> > +					PCI_DMA_TODEVICE);
> > +				xdp_return_frame(tx_buf->xdpf);
> > +				tx_buf->action = 0;
> > +				tx_buf->xdpf = NULL;
> > +				j++;
> > +				continue;
> > +			}
> > +
> 
> Can't see the whole file here and maybe i am missing something, but since you
> optimize for that and start using page_pool, XDP_TX will be a re-synced (and
> not remapped)  buffer that can be returned to the pool and resynced for 
> device usage. 
> Is that happening later on the tx clean function?

Take a look at the way we treat the buffers in bnxt_rx_xdp() when we
receive them and then in bnxt_tx_int_xdp() when the transmits have
completed (for XDP_TX and XDP_REDIRECT).  I think we are doing what is
proper with respect to mapping vs sync for both cases, but I would be
fine to be corrected.

> 
> > +			skb = tx_buf->skb;
> >  			if (!skb) {
> >  				j++;
> >  				continue;
> > @@ -2517,6 +2534,13 @@ static int bnxt_alloc_rx_rings(struct bnxt *bp)
> >  		if (rc < 0)
> >  			return rc;
> >  
> > +		rc = xdp_rxq_info_reg_mem_model(&rxr->xdp_rxq,
> > +						MEM_TYPE_PAGE_SHARED, NULL);
> > +		if (rc) {
> > +			xdp_rxq_info_unreg(&rxr->xdp_rxq);
> 
> I think you can use page_pool_free directly here (and pge_pool_destroy once
> Ivan's patchset gets nerged), that's what mlx5 does iirc. Can we keep that
> common please?

That's an easy change, I can do that.

> 
> If Ivan's patch get merged please note you'll have to explicitly
> page_pool_destroy, after calling xdp_rxq_info_unreg() in the general unregister
> case (not the error habdling here). Sorry for the confusion this might bring!

Funny enough the driver was basically doing that until page_pool_destroy
was removed (these patches are not new).  I saw last week there was
discussion to add it back, but I did not want to wait to get this on the
list before that was resolved.

This path works as expected with the code in the tree today so it seemed
like the correct approach to post something that is working, right?  :-)

> 
> > +			return rc;
> > +		}
> > +
> >  		rc = bnxt_alloc_ring(bp, &ring->ring_mem);
> >  		if (rc)
> >  			return rc;
> > @@ -10233,6 +10257,7 @@ static const struct net_device_ops bnxt_netdev_ops = {
> [...]
> 
> Thanks!
> /Ilias
