Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10B5C149F61
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 09:01:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725991AbgA0IB3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 03:01:29 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:34609 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725938AbgA0IB3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 03:01:29 -0500
Received: by mail-wr1-f67.google.com with SMTP id t2so9935674wrr.1
        for <netdev@vger.kernel.org>; Mon, 27 Jan 2020 00:01:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WLwQoVylZq5AxW28ALjoXpyGwsDGFlZ69J0r6RWR758=;
        b=xtHofkqb9/fI+WVtiCHU6JkIJHoVFb60nGXJbZ/gTjDzlNJ5TixikiLz8rxuUjKYu9
         vPasXajIJX70+ddvBqVwvbLFUWaEPc+Seci5Yl1y1TpwVjimTW5NqbjrCdC0S7LFtDoj
         hoc+ngiSTdLKphjdvv72iu0AqPdo9sZjjo9le4GV53s5J1jQrVU7sVHegRZZvnmzckf/
         AtjF2OfktVygmJyZeNS7JlBu6r6Ry49P16rh8C5kFoL2vXsFM86kYYnBoUoKxsqn4Miu
         Yb/ciwDV0SmNCaggAPGZecLg3xdcbjRLlh+L3ydrMfbizCUyWecnm0yzDAGS6V9FscOi
         +uag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WLwQoVylZq5AxW28ALjoXpyGwsDGFlZ69J0r6RWR758=;
        b=j4XZ9qtNvNjppWsgufsoD6CcjaoosSvHl2MEKUVl8ZkVREnk6bolcNSHnqXsdrBDFl
         +OzbgZwhdTJvtKBeyFF+8abNWC64q+rU3mmMrtSxKVpfYb4DTiU5XyzAFP55f1Jhq6f3
         ApbStrFXKRhkYbkYRRDoQjHkhI3qY7n5jEOdHvHKx9GZnC1RMnVqTcI6IRkxsYGMaMgt
         nL413PDq8zUsySKv7Vcay/Vu1mFoMXY6oZ8BTq/ct9eRcj98RBP5nwKaLHNmgod+t5s3
         gdZzI+dJQpIv4hW4h95Es/u0KPcomA+iZ77sd6/3She01UCJBzswobaP6iV70XzzQZBH
         ECPA==
X-Gm-Message-State: APjAAAW1RVsxwPbe44yPTbAzs8MSDZziULWE1YcVmJUJJ50g5nhzrzmf
        W5/QaQcyCvgHu0bhvqZMezGCuiM1mmE=
X-Google-Smtp-Source: APXvYqzFt2OS5yYOk+EMVdYPbO4a19bC4fp/i20NvS8OgFHdop3HlFO3vLvzWTK83ut0c++Zk2rZVw==
X-Received: by 2002:adf:f491:: with SMTP id l17mr21606282wro.149.1580112087936;
        Mon, 27 Jan 2020 00:01:27 -0800 (PST)
Received: from apalos.home (ppp-94-66-201-28.home.otenet.gr. [94.66.201.28])
        by smtp.gmail.com with ESMTPSA id x132sm25656450wmg.0.2020.01.27.00.01.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2020 00:01:27 -0800 (PST)
Date:   Mon, 27 Jan 2020 10:01:24 +0200
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        lorenzo.bianconi@redhat.com, brouer@redhat.com
Subject: Re: [PATCH net 1/2] net: socionext: fix possible user-after-free in
 netsec_process_rx
Message-ID: <20200127080124.GA24434@apalos.home>
References: <cover.1579952387.git.lorenzo@kernel.org>
 <b66c3b2603da49706597d84aacb7ac8b4ffb1820.1579952387.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b66c3b2603da49706597d84aacb7ac8b4ffb1820.1579952387.git.lorenzo@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 25, 2020 at 12:48:50PM +0100, Lorenzo Bianconi wrote:
> Fix possible use-after-free in in netsec_process_rx that can occurs if
> the first packet is sent to the normal networking stack and the
> following one is dropped by the bpf program attached to the xdp hook.
> Fix the issue defining the skb pointer in the 'budget' loop
> 
> Fixes: ba2b232108d3c ("net: netsec: add XDP support")
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  drivers/net/ethernet/socionext/netsec.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
> index 869a498e3b5e..0e12a9856aea 100644
> --- a/drivers/net/ethernet/socionext/netsec.c
> +++ b/drivers/net/ethernet/socionext/netsec.c
> @@ -929,7 +929,6 @@ static int netsec_process_rx(struct netsec_priv *priv, int budget)
>  	struct netsec_rx_pkt_info rx_info;
>  	enum dma_data_direction dma_dir;
>  	struct bpf_prog *xdp_prog;
> -	struct sk_buff *skb = NULL;
>  	u16 xdp_xmit = 0;
>  	u32 xdp_act = 0;
>  	int done = 0;
> @@ -943,6 +942,7 @@ static int netsec_process_rx(struct netsec_priv *priv, int budget)
>  		struct netsec_de *de = dring->vaddr + (DESC_SZ * idx);
>  		struct netsec_desc *desc = &dring->desc[idx];
>  		struct page *page = virt_to_page(desc->addr);
> +		struct sk_buff *skb = NULL;
>  		u32 xdp_result = XDP_PASS;
>  		u16 pkt_len, desc_len;
>  		dma_addr_t dma_handle;
> -- 
> 2.21.1
> 

Acked-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
