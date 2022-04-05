Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A39174F30AE
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 14:34:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243915AbiDEJPZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 05:15:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244583AbiDEIw0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 04:52:26 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3DFCD7623;
        Tue,  5 Apr 2022 01:41:25 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id q19so10481318pgm.6;
        Tue, 05 Apr 2022 01:41:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=tyMTkL/DEwEGwyWd4XeYbKKLsgq9vE9sanIeDqHge+c=;
        b=E932Wipj1sJQuJkCtNE43IEEtNx+73IQi5E3EYoThThq6YVQ9fUyyMe4QHoZOeox/S
         UWkDRXvmDFZXNpgCeaufOR+wgg2VhsmEjQJvtTpZxOY4Sz28aKXubvaoXLfvjCeFJmXh
         6KRqmI9qSdAC6DU8OviemKz5J2327Wj7EaM35dx0fcThPmRv4EDoDeYflgI3fgEhXGcN
         fFpMECKlwxNnBOZPatI5d7cuY3vYXMJcewTJhU+AxdmB/iH14G05ECSr1mZRgDZYwfS0
         2hJgGRNtQY3MVWY+kS2UpbcY+5LBR8+uEzCNCJy1RkagnbOyR7K3rm1bCxdFqOujESzy
         PCCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=tyMTkL/DEwEGwyWd4XeYbKKLsgq9vE9sanIeDqHge+c=;
        b=LERonoXSJ4LD/FOgIrNzU+gwNjkSK+0+N2NEe+LDRx7L9+f3clNbqTTRCuYovQxxvq
         AgJlwLTlcIbdq2OG1Dc6JtFshCrAR77UhnzqDcTDcKsk8cE7GIZroGZWS6MRqR7VNs3f
         yKwWudcZsPVZ/oTLXOPL9j/cPdmuPGEDHV6ADbKmsnJOuZDLO4nwtRDgUBDhRkUY4Ywd
         0ufDrrSGsE+N8+QrPbQMfjb0yMm8sGGDqV2+37RTErlLS0lEgqHiGT23Hc+L1339B3Ay
         y2ja6LuvMrNeiw3YiQXz27X7N/GrUjznIDMdATZ5FvIbepwwpT9mIRScSLHs/Sjk8nRM
         8W6w==
X-Gm-Message-State: AOAM532RrHBY/dBa2DgnWx8y+GctaaC4JIWdxJEmyaJ6VDxQxV/Yi1RZ
        Vrszrc4qf++XuaRoog7NORg=
X-Google-Smtp-Source: ABdhPJz5Y8sgWZuw/3cWEi02oqEoozSCg+cw7pNipJPm/ERviJ1PEcBZJOFB2YCKM7d27eRYnN85Xg==
X-Received: by 2002:a05:6a00:1d03:b0:4fa:7710:7b1b with SMTP id a3-20020a056a001d0300b004fa77107b1bmr2331868pfx.29.1649148085191;
        Tue, 05 Apr 2022 01:41:25 -0700 (PDT)
Received: from [192.168.0.4] ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id l1-20020a639841000000b00399322e8a09sm4604331pgo.60.2022.04.05.01.41.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Apr 2022 01:41:24 -0700 (PDT)
Message-ID: <f308136f-0744-0a78-d882-bfd926fe1ea2@gmail.com>
Date:   Tue, 5 Apr 2022 17:41:20 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net] net: sfc: fix using uninitialized xdp tx_queue
Content-Language: en-US
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, ecree.xilinx@gmail.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        cmclachlan@solarflare.com, bpf@vger.kernel.org
References: <20220405050019.12260-1-ap420073@gmail.com>
 <20220405082009.sgxozrdssoypaw7h@gmail.com>
From:   Taehee Yoo <ap420073@gmail.com>
In-Reply-To: <20220405082009.sgxozrdssoypaw7h@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/5/22 17:20, Martin Habets wrote:

Hi Martin,
Thank you so much for your review!

 > Hi Taehee,
 >
 > On Tue, Apr 05, 2022 at 05:00:19AM +0000, Taehee Yoo wrote:
 >> In some cases, xdp tx_queue can get used before initialization.
 >> 1. interface up/down
 >> 2. ring buffer size change
 >>
 >> When CPU cores are lower than maximum number of channels of sfc driver,
 >> it creates new channels only for XDP.
 >>
 >> When an interface is up or ring buffer size is changed, all channels
 >> are initialized.
 >> But xdp channels are always initialized later.
 >> So, the below scenario is possible.
 >> Packets are received to rx queue of normal channels and it is acted
 >> XDP_TX and tx_queue of xdp channels get used.
 >> But these tx_queues are not initialized yet.
 >> If so, TX DMA or queue error occurs.
 >>
 >> In order to avoid this problem
 >> 1. initializes xdp tx_queues earlier than other rx_queue in
 >> efx_start_channels().
 >> 2. checks whether tx_queue is initialized or not in 
efx_xdp_tx_buffers().
 >>
 >> Splat looks like:
 >>     sfc 0000:08:00.1 enp8s0f1np1: TX queue 10 spurious TX completion 
id 250
 >>     sfc 0000:08:00.1 enp8s0f1np1: resetting (RECOVER_OR_ALL)
 >>     sfc 0000:08:00.1 enp8s0f1np1: MC command 0x80 inlen 100 failed 
rc=-22
 >>     (raw=22) arg=789
 >>     sfc 0000:08:00.1 enp8s0f1np1: has been disabled
 >>
 >> Fixes: dfe44c1f52ee ("sfc: handle XDP_TX outcomes of XDP eBPF programs")
 >
 > A better fixes tag for this might be
 > f28100cb9c96 ("sfc: fix lack of XDP TX queues - error XDP TX failed 
(-22)")
 > as it enabled XDP in more situations.
 >
 >> Signed-off-by: Taehee Yoo <ap420073@gmail.com>
 >
 > Acked-by: Martin Habets <habetsm.xilinx@gmail.com>
 >

Thanks, I will send a v2 patch to change fixes tag and it will contain 
your Acked tag.

Thanks a lot,
Taehee Yoo

 >> ---
 >>   drivers/net/ethernet/sfc/efx_channels.c | 2 +-
 >>   drivers/net/ethernet/sfc/tx.c           | 3 +++
 >>   drivers/net/ethernet/sfc/tx_common.c    | 2 ++
 >>   3 files changed, 6 insertions(+), 1 deletion(-)
 >>
 >> diff --git a/drivers/net/ethernet/sfc/efx_channels.c 
b/drivers/net/ethernet/sfc/efx_channels.c
 >> index 83e27231fbe6..377df8b7f015 100644
 >> --- a/drivers/net/ethernet/sfc/efx_channels.c
 >> +++ b/drivers/net/ethernet/sfc/efx_channels.c
 >> @@ -1140,7 +1140,7 @@ void efx_start_channels(struct efx_nic *efx)
 >>   	struct efx_rx_queue *rx_queue;
 >>   	struct efx_channel *channel;
 >>
 >> -	efx_for_each_channel(channel, efx) {
 >> +	efx_for_each_channel_rev(channel, efx) {
 >>   		efx_for_each_channel_tx_queue(tx_queue, channel) {
 >>   			efx_init_tx_queue(tx_queue);
 >>   			atomic_inc(&efx->active_queues);
 >> diff --git a/drivers/net/ethernet/sfc/tx.c 
b/drivers/net/ethernet/sfc/tx.c
 >> index d16e031e95f4..6983799e1c05 100644
 >> --- a/drivers/net/ethernet/sfc/tx.c
 >> +++ b/drivers/net/ethernet/sfc/tx.c
 >> @@ -443,6 +443,9 @@ int efx_xdp_tx_buffers(struct efx_nic *efx, int 
n, struct xdp_frame **xdpfs,
 >>   	if (unlikely(!tx_queue))
 >>   		return -EINVAL;
 >>
 >> +	if (!tx_queue->initialised)
 >> +		return -EINVAL;
 >> +
 >>   	if (efx->xdp_txq_queues_mode != EFX_XDP_TX_QUEUES_DEDICATED)
 >>   		HARD_TX_LOCK(efx->net_dev, tx_queue->core_txq, cpu);
 >>
 >> diff --git a/drivers/net/ethernet/sfc/tx_common.c 
b/drivers/net/ethernet/sfc/tx_common.c
 >> index d530cde2b864..9bc8281b7f5b 100644
 >> --- a/drivers/net/ethernet/sfc/tx_common.c
 >> +++ b/drivers/net/ethernet/sfc/tx_common.c
 >> @@ -101,6 +101,8 @@ void efx_fini_tx_queue(struct efx_tx_queue 
*tx_queue)
 >>   	netif_dbg(tx_queue->efx, drv, tx_queue->efx->net_dev,
 >>   		  "shutting down TX queue %d\n", tx_queue->queue);
 >>
 >> +	tx_queue->initialised = false;
 >> +
 >>   	if (!tx_queue->buffer)
 >>   		return;
 >>
 >> --
 >> 2.17.1
