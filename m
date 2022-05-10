Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2257521774
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 15:23:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243013AbiEJNZs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 09:25:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243029AbiEJNZ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 09:25:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7F44722EA64
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 06:18:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652188716;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sHy0F7ac22uwKEpSKuZcvo5GcFLWTTOIEdgJB67ZhmA=;
        b=QHwd05NJ7mXnRXGDaIgyrVpxkOrrPrEJFcO/gonXlxP3h0zcbhY3qL0FpMVVVv80Iq1DTS
        kAQWWctPpFapEnllCMWEoEhKE3ZDUCkeB+dv5NC3p55e13UcsX+lTY4lklFfTvPptjcIRJ
        +vWtd/9Et+Yf+fGCRCqbvdrf2+P06p8=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-453-t-MN4JbPPnWJ86jQ8oLxBw-1; Tue, 10 May 2022 09:18:35 -0400
X-MC-Unique: t-MN4JbPPnWJ86jQ8oLxBw-1
Received: by mail-wm1-f71.google.com with SMTP id e9-20020a05600c4e4900b00394779649b1so1295611wmq.3
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 06:18:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=sHy0F7ac22uwKEpSKuZcvo5GcFLWTTOIEdgJB67ZhmA=;
        b=wnVdgYDPHc5/60mEBpN8vLazg5uwTOAEdgNmqzg+OYd/eX5vtxj+I78C3S+foc0itN
         Fhzpou1hXt7aTx7hCu+Nv3wmLbgVAUtAIseuhip7FW/BoEm//Ypx/P32MU5uKJrUDf+6
         C/w12olToXjkiTSi6ZKJSXO9MwhA0QfeaZYzgk8eqk4KtXvYYnUkSyJuA1m5N+/iBTdV
         hUIe27PEATVNQu3XUwDzZ5qIjaN96itIhOG+q9spAnQTMMeLnCcQf8A7TXrUWF2moPNt
         h7w3ULc1rDHPvdG+2KALmzsiqJVUg0UnYaq07XSMJEYLgFDJtpwTy+dctG9feT17lUsH
         15rg==
X-Gm-Message-State: AOAM531gkAVYNjZl/GOlrgLiy6BnGUQsvoWCfto8oFK/CAn2G4fb8h1P
        D1STn2n9vTP3M07Y1nDQqRVUYYp1pTv2OAyRqf28aOaVBvCA3fP6vxyGh+Ciuqe92s+viK1FR/r
        BKDC23PzbH6GtJtnx
X-Received: by 2002:a05:600c:5105:b0:394:7d22:aa93 with SMTP id o5-20020a05600c510500b003947d22aa93mr19997770wms.107.1652188714215;
        Tue, 10 May 2022 06:18:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzJhqj/rclE960FiMWEPu/ABEdzf1gL2hi5Dp98G//UB2PCflcGTO2OPYlMduSsRS0sioEd9g==
X-Received: by 2002:a05:600c:5105:b0:394:7d22:aa93 with SMTP id o5-20020a05600c510500b003947d22aa93mr19997736wms.107.1652188713913;
        Tue, 10 May 2022 06:18:33 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-113-89.dyn.eolo.it. [146.241.113.89])
        by smtp.gmail.com with ESMTPSA id c2-20020a5d5282000000b0020c5253d8e0sm14119404wrv.44.2022.05.10.06.18.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 May 2022 06:18:33 -0700 (PDT)
Message-ID: <21ee77073341cd2b5e0109be5da61d8e981ea50d.camel@redhat.com>
Subject: Re: [PATCH] net: macb: Disable macb pad and fcs for fragmented
 packets
From:   Paolo Abeni <pabeni@redhat.com>
To:     Harini Katakam <harini.katakam@xilinx.com>,
        nicolas.ferre@microchip.com, davem@davemloft.net,
        claudiu.beznea@microchip.com, kuba@kernel.org, dumazet@google.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        michal.simek@xilinx.com, harinikatakamlinux@gmail.com,
        radhey.shyam.pandey@xilinx.com
Date:   Tue, 10 May 2022 15:18:32 +0200
In-Reply-To: <20220509121513.30549-1-harini.katakam@xilinx.com>
References: <20220509121513.30549-1-harini.katakam@xilinx.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2022-05-09 at 17:45 +0530, Harini Katakam wrote:
> data_len in skbuff represents bytes resident in fragment lists or
> unmapped page buffers. For such packets, when data_len is non-zero,
> skb_put cannot be used - this will throw a kernel bug. Hence do not
> use macb_pad_and_fcs for such fragments.
> 
> Signed-off-by: Harini Katakam <harini.katakam@xilinx.com>
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>

This looks like a fix suitable for the net tree. Please add a relevant
'Fixes' tag.

> ---
>  drivers/net/ethernet/cadence/macb_main.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
> index 6434e74c04f1..0b03305ad6a0 100644
> --- a/drivers/net/ethernet/cadence/macb_main.c
> +++ b/drivers/net/ethernet/cadence/macb_main.c
> @@ -1995,7 +1995,8 @@ static unsigned int macb_tx_map(struct macb *bp,
>  			ctrl |= MACB_BF(TX_LSO, lso_ctrl);
>  			ctrl |= MACB_BF(TX_TCP_SEQ_SRC, seq_ctrl);
>  			if ((bp->dev->features & NETIF_F_HW_CSUM) &&
> -			    skb->ip_summed != CHECKSUM_PARTIAL && !lso_ctrl)
> +			    skb->ip_summed != CHECKSUM_PARTIAL && !lso_ctrl &&
> +			    (skb->data_len == 0))
>  				ctrl |= MACB_BIT(TX_NOCRC);
>  		} else
>  			/* Only set MSS/MFS on payload descriptors

This chunk looks unrelated to the commit message ?!? only the next one
looks relevant.

Thanks.

Paolo

