Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9929F6E2880
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 18:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbjDNQkL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 12:40:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbjDNQkK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 12:40:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7794213D
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 09:38:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681490327;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RQ7sgqQDmbwnKclLYwzzFoBdsimrT7SdVshCZK2WEYc=;
        b=G3jyZuEzs2ZiwqKq3WFQN0pST2NOMx/kGv+9oe/lvO581NMHFht/50LoNubcu6jsga3a8c
        8ku2LcONO8nq/DNBB8M/oV0oCqobcTfccTXIPn+CkFzssUkMjQCPuJ/3lpHyAA3YRUJyNP
        gZathanqwEl3Cv3FATViu2um9u1fRdY=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-25-BdO2P5RwOHSWNjKLXyeizg-1; Fri, 14 Apr 2023 12:38:46 -0400
X-MC-Unique: BdO2P5RwOHSWNjKLXyeizg-1
Received: by mail-ed1-f71.google.com with SMTP id a26-20020a509b5a000000b004acbe232c03so10090235edj.9
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 09:38:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681490325; x=1684082325;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RQ7sgqQDmbwnKclLYwzzFoBdsimrT7SdVshCZK2WEYc=;
        b=aDYuJQgUs/n4CaGHlhk00Rg56PZBuh4dEpUsQ8tsgJ4s3Jf5jOliXJr3kVO97D1GrI
         UiP7wtJD6D2nOaT198mS1Kc2MnM8zcg0VrGVtcSFdptu3CMSvUfoKGPQMsNE4J5Si5+a
         9+KuQZF/PB2wwHh8ODu9nepfBK61n3e/sXUso/CT3XNY/tj/eyrWvijn1QMFbxPfxUgW
         NM0sfGZJzQUfkVbVrgADS6GgrcNavJ9I3SjbrSnKnwXcFZR/8LCT1xq7spqdK11bhC7d
         +y+DioN2/VDvgH/oy6+pLGY1Go6/mYlxbtMBDgwXEUbEpYjj4bzXaXwmFbsROk73TWda
         nmUA==
X-Gm-Message-State: AAQBX9d+s6Rb97wX8bE5g9YtPcb/zWHddK+4dmAvbC9D3epL70dNGeF7
        F9qHEqCc2NbnK3LwBgD//INx63vybHOTO+aEjuduRgPfTkP6/NGXO9MW4aTfHblMk0G9+X663IP
        1oPl7SQnhhPzXMMqU
X-Received: by 2002:a17:906:4d1:b0:94e:8aeb:f8f3 with SMTP id g17-20020a17090604d100b0094e8aebf8f3mr7484955eja.57.1681490324943;
        Fri, 14 Apr 2023 09:38:44 -0700 (PDT)
X-Google-Smtp-Source: AKy350ayugk3Xrac/spJG74Sa/J9mNGI+/Fz+UylpmqnwMJbWMwuvI3GN4RYzod8i4kv0xVxOUhMqQ==
X-Received: by 2002:a17:906:4d1:b0:94e:8aeb:f8f3 with SMTP id g17-20020a17090604d100b0094e8aebf8f3mr7484919eja.57.1681490324603;
        Fri, 14 Apr 2023 09:38:44 -0700 (PDT)
Received: from [192.168.42.222] (194-45-78-10.static.kviknet.net. [194.45.78.10])
        by smtp.gmail.com with ESMTPSA id pg16-20020a170907205000b0094a85f6074bsm2649346ejb.33.2023.04.14.09.38.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Apr 2023 09:38:44 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <d74d570c-3001-4c92-7516-eb20ecb479d7@redhat.com>
Date:   Fri, 14 Apr 2023 18:38:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Cc:     brouer@redhat.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, xdp-hints@xdp-project.net
Subject: Re: [PATCH net-next v5 2/3] net: stmmac: add Rx HWTS metadata to XDP
 receive pkt
Content-Language: en-US
To:     Song Yoong Siang <yoong.siang.song@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Stanislav Fomichev <sdf@google.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Jacob Keller <jacob.e.keller@intel.com>
References: <20230414052651.1871424-1-yoong.siang.song@intel.com>
 <20230414052651.1871424-3-yoong.siang.song@intel.com>
In-Reply-To: <20230414052651.1871424-3-yoong.siang.song@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 14/04/2023 07.26, Song Yoong Siang wrote:
> Add receive hardware timestamp metadata support via kfunc to XDP receive
> packets.
> 
> Suggested-by: Stanislav Fomichev <sdf@google.com>
> Signed-off-by: Song Yoong Siang <yoong.siang.song@intel.com>
> Acked-by: Stanislav Fomichev <sdf@google.com>
> ---
>   drivers/net/ethernet/stmicro/stmmac/stmmac.h  |  3 ++
>   .../net/ethernet/stmicro/stmmac/stmmac_main.c | 40 ++++++++++++++++++-
>   2 files changed, 42 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
> index ac8ccf851708..826ac0ec88c6 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
> @@ -94,6 +94,9 @@ struct stmmac_rx_buffer {
>   
>   struct stmmac_xdp_buff {
>   	struct xdp_buff xdp;
> +	struct stmmac_priv *priv;
> +	struct dma_desc *p;
> +	struct dma_desc *np;

Hmm, I don't like the naming of the descriptors as "p" and "np".
If you insist on this naming, at least we need comments describing that 
this is.

Does "desc" and "ndesc" make sense?  (where "n" means "next")

>   };
>   
>   struct stmmac_rx_queue {
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> index 10b9f8912bb2..74f78e5537a3 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> @@ -5313,10 +5313,15 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
>   
>   			xdp_init_buff(&ctx.xdp, buf_sz, &rx_q->xdp_rxq);
>   			xdp_prepare_buff(&ctx.xdp, page_address(buf->page),
> -					 buf->page_offset, buf1_len, false);
> +					 buf->page_offset, buf1_len, true);
>   
>   			pre_len = ctx.xdp.data_end - ctx.xdp.data_hard_start -
>   				  buf->page_offset;
> +
> +			ctx.priv = priv;
> +			ctx.p = p;
> +			ctx.np = np;
> +
>   			skb = stmmac_xdp_run_prog(priv, &ctx.xdp);
>   			/* Due xdp_adjust_tail: DMA sync for_device
>   			 * cover max len CPU touch
> @@ -7060,6 +7065,37 @@ void stmmac_fpe_handshake(struct stmmac_priv *priv, bool enable)
>   	}
>   }
>   
> +static int stmmac_xdp_rx_timestamp(const struct xdp_md *_ctx, u64 *timestamp)
> +{
> +	const struct stmmac_xdp_buff *ctx = (void *)_ctx;
> +	struct stmmac_priv *priv = ctx->priv;
> +	struct dma_desc *desc = ctx->p;
> +	struct dma_desc *np = ctx->np;
> +	struct dma_desc *p = ctx->p;
> +	u64 ns = 0;
> +
> +	if (!priv->hwts_rx_en)
> +		return -ENODATA;
> +
> +	/* For GMAC4, the valid timestamp is from CTX next desc. */
> +	if (priv->plat->has_gmac4 || priv->plat->has_xgmac)
> +		desc = np;
> +
> +	/* Check if timestamp is available */
> +	if (stmmac_get_rx_timestamp_status(priv, p, np, priv->adv_ts)) {
> +		stmmac_get_timestamp(priv, desc, priv->adv_ts, &ns);
> +		ns -= priv->plat->cdc_error_adj;
> +		*timestamp = ns_to_ktime(ns);
> +		return 0;
> +	}
> +
> +	return -ENODATA;
> +}
> +
> +static const struct xdp_metadata_ops stmmac_xdp_metadata_ops = {
> +	.xmo_rx_timestamp		= stmmac_xdp_rx_timestamp,
> +};
> +
>   /**
>    * stmmac_dvr_probe
>    * @device: device pointer
> @@ -7167,6 +7203,8 @@ int stmmac_dvr_probe(struct device *device,
>   
>   	ndev->netdev_ops = &stmmac_netdev_ops;
>   
> +	ndev->xdp_metadata_ops = &stmmac_xdp_metadata_ops;
> +
>   	ndev->hw_features = NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
>   			    NETIF_F_RXCSUM;
>   	ndev->xdp_features = NETDEV_XDP_ACT_BASIC | NETDEV_XDP_ACT_REDIRECT |

