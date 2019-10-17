Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F0F4DA299
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 02:14:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387904AbfJQAOL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 20:14:11 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:45743 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726820AbfJQAOL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 20:14:11 -0400
Received: by mail-lj1-f193.google.com with SMTP id q64so532800ljb.12
        for <netdev@vger.kernel.org>; Wed, 16 Oct 2019 17:14:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=mi8Xx7h4hNZDFEbhFfyXVFIDOXuTC8lk+7evlJKk5tw=;
        b=uKgLe2hBwptOhYVEFcVbVtrbDw0XQA+CHtWw1QzllCHfq4tcEwUsZeClTnSjH5oN1o
         R1SRuTZcUanj30DwZQ4RwoWj0rZz6xnxoYcjnlnnICLW2LETFKUXpIsS97nn5u7q1nTx
         ELGN/L7FzurWS29DHIEdTOkNKhHIV0mHWxfMyB678eOSYvh0AmvtoLes6H9nT/LnANHW
         JINTUKM/a02oUiHMB/GFEd7URDUyBLxglG29Qof3qTDDSdYMKu+99EwSXHpYZyz7K00J
         JxQAZ/XP+kJ38Ff4G0Sv+EBmXEM8o9guRBj6yHxbu17JgbqSe3852a846f4CweRdT3xf
         jfDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=mi8Xx7h4hNZDFEbhFfyXVFIDOXuTC8lk+7evlJKk5tw=;
        b=s9km29vo0W2dK0KzehncAZCMAF2B8kuklcv/Ll6qA4KlMXmhe5Zje7sq41q3eWaaSH
         TC3nREIxxE5R17ss19LH461buNkVFayyyt6DV7fvFKUVaJvVL4zmn0JuyHX/cqJrv0K5
         kfyCYJMKHN84qlnyrNZWKcj/uHFSTne6DaWaQnuUg7da6dn1XqDWkV5GRhEz+vW98FNY
         N4ykiSArM5Tl3sYudZQSMxJmKMyRIqgGQjyu/4RNCga8oHhd11lXyOS3mbZXLpMVrYgV
         49WmNh1FLTsMEg0tT866Dqet9EhD1rKfLf93HKPuCR+oYpD7QmpmuOOKECV+39tHCrpP
         C2Xg==
X-Gm-Message-State: APjAAAWlgbGXPURaAlTC9IXlKc2CX4LUwCCIul4ymcufwutgcsuJtQu3
        QkrbqP0Gf0RS9/NP8nX9Na1RmA==
X-Google-Smtp-Source: APXvYqwOxOSp2HgMbpm51Itb/X/TnnBh6K4Z5hd/2X6SNvNfKw2CS0f6BgJBEdAikv2jQe0B1VRHGw==
X-Received: by 2002:a2e:8593:: with SMTP id b19mr498959lji.34.1571271248985;
        Wed, 16 Oct 2019 17:14:08 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id z8sm155337lfg.18.2019.10.16.17.14.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Oct 2019 17:14:08 -0700 (PDT)
Date:   Wed, 16 Oct 2019 17:14:01 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     netdev@vger.kernel.org, jaswinder.singh@linaro.org,
        davem@davemloft.net, brouer@redhat.com, lorenzo@kernel.org
Subject: Re: [PATCH] net: netsec: Correct dma sync for XDP_TX frames
Message-ID: <20191016171401.16cb1bd5@cakuba.netronome.com>
In-Reply-To: <20191016114032.21617-1-ilias.apalodimas@linaro.org>
References: <20191016114032.21617-1-ilias.apalodimas@linaro.org>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Oct 2019 14:40:32 +0300, Ilias Apalodimas wrote:
> bpf_xdp_adjust_head() can change the frame boundaries. Account for the
> potential shift properly by calculating the new offset before
> syncing the buffer to the device for XDP_TX
> 
> Fixes: ba2b232108d3 ("net: netsec: add XDP support")
> Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>

Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>

You should target this to the bpf or net tree (appropriate [PATCH xyz]
marking). Although I must admit it's unclear to me as well whether the
driver changes should be picked up by bpf maintainers or Dave :S

> diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
> index f9e6744d8fd6..41ddd8fff2a7 100644
> --- a/drivers/net/ethernet/socionext/netsec.c
> +++ b/drivers/net/ethernet/socionext/netsec.c
> @@ -847,8 +847,8 @@ static u32 netsec_xdp_queue_one(struct netsec_priv *priv,
>  		enum dma_data_direction dma_dir =
>  			page_pool_get_dma_dir(rx_ring->page_pool);
>  
> -		dma_handle = page_pool_get_dma_addr(page) +
> -			NETSEC_RXBUF_HEADROOM;
> +		dma_handle = page_pool_get_dma_addr(page) + xdpf->headroom +
> +			sizeof(*xdpf);

very nitpick: I'd personally write addr + sizeof(*xdpf) + xdpf->headroom
since that's the order in which they appear in memory

But likely not worth reposting for just that :)

>  		dma_sync_single_for_device(priv->dev, dma_handle, xdpf->len,
>  					   dma_dir);
>  		tx_desc.buf_type = TYPE_NETSEC_XDP_TX;

