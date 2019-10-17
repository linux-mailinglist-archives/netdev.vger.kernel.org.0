Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33D04DA5C2
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 08:49:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404735AbfJQGth (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 02:49:37 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:54929 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389340AbfJQGth (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 02:49:37 -0400
Received: by mail-wm1-f67.google.com with SMTP id p7so1250740wmp.4
        for <netdev@vger.kernel.org>; Wed, 16 Oct 2019 23:49:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=3O1LXno2sElwzfqxT0UKTxXlrCFKeAbrmZgVoo3JZi8=;
        b=u8JfUvyEHsP1mOUmgvVLHY8YuaUu62XnCqqGmfmDcAbm3M+BqV0WRTPxRekyI0yWgj
         lGL+BYscu4Yq+Uzbf/kB0JiruT3xc6FXoxDp00MRqaw94mV9R0OJet9vt8dv0BA9io9k
         sn0ghGV2jFHXWnxMw1E3goIiQzRC5+4suX+vDozXH6K8uTJNx+UCBsPc/14uzn2h3Akt
         ly1H92q77FRiE77sHaz9Cz+q88B8C+eU8BXWw+uIDbod0khFocapm1Dd6pEfBg+Mu9zt
         5Otz2z8tOU82sEX5GaeA6ENF6DMg+Y9/LpxReggQ8T6rnrbt35Sld1Gw2Je542ZC7v7Y
         cCiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=3O1LXno2sElwzfqxT0UKTxXlrCFKeAbrmZgVoo3JZi8=;
        b=BH6QPR2sDacWOPyyh6XsHxc5/45fPBL9tfXEiYNg4xc+K1BKXLGLHc7R59QsKgOymh
         QcMMMKRkZ28ymOh+DG/Co9lfDvoBlhJzgaC5FdlKRnAv62sKMMaPvudUyhaoFYJBibwi
         mFODMcZWODrU/VnGlUxf77r2sopZZj0c4xfvwAF7+ENaeFViIkYIgv3a+fy9LQc20uNn
         EGYz93bUNp5oZ8gj2qBP8ZguOeOkAplYnHy7k59l/ZpRjR5HOzoh8oPGp1oNWak4IsE2
         2opPuvxLMvjrCXDinfeGm2yWKoPVzRvuQTbkvq3l4T62NIkcQwRs2PZ6ra6ynrqpD9aE
         Gt4A==
X-Gm-Message-State: APjAAAUgReRHCUlk+ca1KpVJjJgPQmmriwFzJ6WRV8IUBFAu2Wmk3bbH
        SzY1eb8Z87eBlyyADO/MtzFQyexs6sU=
X-Google-Smtp-Source: APXvYqwmwGAlKPVMIWuunuWk4uvfp1Bw26g0ghxWXPLGflj+qmzedoZsulnhW4o7AJDWlOAiYVPT+g==
X-Received: by 2002:a7b:ce89:: with SMTP id q9mr1422679wmj.2.1571294975005;
        Wed, 16 Oct 2019 23:49:35 -0700 (PDT)
Received: from apalos.home (ppp-94-65-92-5.home.otenet.gr. [94.65.92.5])
        by smtp.gmail.com with ESMTPSA id t83sm2145492wmt.18.2019.10.16.23.49.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Oct 2019 23:49:34 -0700 (PDT)
Date:   Thu, 17 Oct 2019 09:49:31 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, jaswinder.singh@linaro.org,
        davem@davemloft.net, brouer@redhat.com, lorenzo@kernel.org
Subject: Re: [PATCH] net: netsec: Correct dma sync for XDP_TX frames
Message-ID: <20191017064931.GA12128@apalos.home>
References: <20191016114032.21617-1-ilias.apalodimas@linaro.org>
 <20191016171401.16cb1bd5@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191016171401.16cb1bd5@cakuba.netronome.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub, 

On Wed, Oct 16, 2019 at 05:14:01PM -0700, Jakub Kicinski wrote:
> On Wed, 16 Oct 2019 14:40:32 +0300, Ilias Apalodimas wrote:
> > bpf_xdp_adjust_head() can change the frame boundaries. Account for the
> > potential shift properly by calculating the new offset before
> > syncing the buffer to the device for XDP_TX
> > 
> > Fixes: ba2b232108d3 ("net: netsec: add XDP support")
> > Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
> 
> Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> 
> You should target this to the bpf or net tree (appropriate [PATCH xyz]
> marking). Although I must admit it's unclear to me as well whether the
> driver changes should be picked up by bpf maintainers or Dave :S

My bad i forgot to add the net-next tag. I'd prefer Dave picking that up, since
he picked all the XDP-related patches for this driver before. 
Dave shall i re-send with the proper tag?

> 
> > diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
> > index f9e6744d8fd6..41ddd8fff2a7 100644
> > --- a/drivers/net/ethernet/socionext/netsec.c
> > +++ b/drivers/net/ethernet/socionext/netsec.c
> > @@ -847,8 +847,8 @@ static u32 netsec_xdp_queue_one(struct netsec_priv *priv,
> >  		enum dma_data_direction dma_dir =
> >  			page_pool_get_dma_dir(rx_ring->page_pool);
> >  
> > -		dma_handle = page_pool_get_dma_addr(page) +
> > -			NETSEC_RXBUF_HEADROOM;
> > +		dma_handle = page_pool_get_dma_addr(page) + xdpf->headroom +
> > +			sizeof(*xdpf);
> 
> very nitpick: I'd personally write addr + sizeof(*xdpf) + xdpf->headroom
> since that's the order in which they appear in memory
> 
> But likely not worth reposting for just that :)

Isn't sizeof static anyway? If Dave needs a v2 with the proper tag i'll change
this as well 

> 
> >  		dma_sync_single_for_device(priv->dev, dma_handle, xdpf->len,
> >  					   dma_dir);
> >  		tx_desc.buf_type = TYPE_NETSEC_XDP_TX;
> 

Thanks
/Ilias
