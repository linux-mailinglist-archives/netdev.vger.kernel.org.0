Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B221A3A1406
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 14:16:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234936AbhFIMSI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 08:18:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232947AbhFIMSE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 08:18:04 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 072BAC061574;
        Wed,  9 Jun 2021 05:15:58 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id o127so3864767wmo.4;
        Wed, 09 Jun 2021 05:15:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Z31/vYKGtzhdpeM4FMOlx5cnnD+ujAUw41rs1nOjnbs=;
        b=R90IEov593+/aMPfPZQRUZxKjelhHwQoHZQWkFBA78ELwhTmPSX+Y+DCHWOM8L1DIN
         POh9ZP/wY2rAvj4EVddVt8t7xQ23LvFuRnA+3of9Pw+q78hgCoE8NOJf89fdNZUG+hxa
         wN0fgUK2/snFWT1zqMkY+O5laTsOsgQW5z7n+R9lIdKXWPbhmyBhB6uBPehvnNG0ZJHZ
         f3Rtj9HOCOdsmp/V9tDLX2R1SKcxQF+WNdZfM4nbSNSElJzGHTowGB/UcCe43lsv2/uX
         5ycl48DNr+FHuToO3vheE9AqxnbkPTiZxBfVzJkUitt17aGQX8bK1BYR73YlrWdYjmnm
         AD+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Z31/vYKGtzhdpeM4FMOlx5cnnD+ujAUw41rs1nOjnbs=;
        b=K8ejM9vx/lsjIrulIq2eZVSGnhaH8iAbJBw7+jaO6Qpwdl4BWPvLlXzzwHEZE7T+U9
         WtRFiAJTcVVNJOJvDIUnq+mGVtYCG43/4asY5LUX0l0qJtPlsPW1MDfWX8NlATtXkWEl
         qES+T0Y57ABdVTaQNR1fRWWNNtJ0xlcLkmjVN1MNgmTUTCubZVrZSvmNFAqGYbe59mb5
         QFoIby/BJZK7BU6D8vUrNpw+sxJdSEfs2MQUkFdZQs9NmxtbxbjP+jZHL8EkMUIB0+QJ
         CE88uqx4pxYK/9xYib5//GkeIzXCGK71SMgIhIRb0qcWeSBb7Nb+OC2y58okYBf4+LHz
         pLyw==
X-Gm-Message-State: AOAM530hs2BI1CwIpbep3XHbJU2W+HuNbwiXek9ldInU5BJMuPhQSFUM
        MYmCxuquC7fV9zRzQq6bsGOm/X5chEgL8w==
X-Google-Smtp-Source: ABdhPJxxPVUVQ6bTVvTpNtBRk84w+ePs4tIoHGXfWEo3uPX248tcFuEk1rqI78fRzifmf3XefdQQQA==
X-Received: by 2002:a05:600c:4a29:: with SMTP id c41mr27862889wmp.17.1623240956656;
        Wed, 09 Jun 2021 05:15:56 -0700 (PDT)
Received: from [192.168.1.122] (cpc159425-cmbg20-2-0-cust403.5-4.cable.virginm.net. [86.7.189.148])
        by smtp.gmail.com with ESMTPSA id 6sm21317493wmg.17.2021.06.09.05.15.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Jun 2021 05:15:55 -0700 (PDT)
Subject: Re: [PATCH bpf-next 14/17] sfc: remove rcu_read_lock() around XDP
 program invocation
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     Martin KaFai Lau <kafai@fb.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Martin Habets <habetsm.xilinx@gmail.com>
References: <20210609103326.278782-1-toke@redhat.com>
 <20210609103326.278782-15-toke@redhat.com>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <e439d412-610b-3e2c-b40f-6eb68fde4e49@gmail.com>
Date:   Wed, 9 Jun 2021 13:15:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20210609103326.278782-15-toke@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/06/2021 11:33, Toke Høiland-Jørgensen wrote:
> The sfc driver has rcu_read_lock()/rcu_read_unlock() pairs around XDP
> program invocations. However, the actual lifetime of the objects referred
> by the XDP program invocation is longer, all the way through to the call to
> xdp_do_flush(), making the scope of the rcu_read_lock() too small. This
> turns out to be harmless because it all happens in a single NAPI poll
> cycle (and thus under local_bh_disable()), but it makes the rcu_read_lock()
> misleading.
> 
> Rather than extend the scope of the rcu_read_lock(), just get rid of it
> entirely. With the addition of RCU annotations to the XDP_REDIRECT map
> types that take bh execution into account, lockdep even understands this to
> be safe, so there's really no reason to keep it around.
> 
> Cc: Edward Cree <ecree.xilinx@gmail.com>
> Cc: Martin Habets <habetsm.xilinx@gmail.com>
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
> ---
Acked-by: Edward Cree <ecree.xilinx@gmail.com>

>  drivers/net/ethernet/sfc/rx.c | 9 ++-------
>  1 file changed, 2 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/ethernet/sfc/rx.c b/drivers/net/ethernet/sfc/rx.c
> index 17b8119c48e5..606750938b89 100644
> --- a/drivers/net/ethernet/sfc/rx.c
> +++ b/drivers/net/ethernet/sfc/rx.c
> @@ -260,18 +260,14 @@ static bool efx_do_xdp(struct efx_nic *efx, struct efx_channel *channel,
>  	s16 offset;
>  	int err;
>  
> -	rcu_read_lock();
> -	xdp_prog = rcu_dereference(efx->xdp_prog);
> -	if (!xdp_prog) {
> -		rcu_read_unlock();
> +	xdp_prog = rcu_dereference_bh(efx->xdp_prog);
> +	if (!xdp_prog)
>  		return true;
> -	}
>  
>  	rx_queue = efx_channel_get_rx_queue(channel);
>  
>  	if (unlikely(channel->rx_pkt_n_frags > 1)) {
>  		/* We can't do XDP on fragmented packets - drop. */
> -		rcu_read_unlock();
>  		efx_free_rx_buffers(rx_queue, rx_buf,
>  				    channel->rx_pkt_n_frags);
>  		if (net_ratelimit())
> @@ -296,7 +292,6 @@ static bool efx_do_xdp(struct efx_nic *efx, struct efx_channel *channel,
>  			 rx_buf->len, false);
>  
>  	xdp_act = bpf_prog_run_xdp(xdp_prog, &xdp);
> -	rcu_read_unlock();
>  
>  	offset = (u8 *)xdp.data - *ehp;
>  
> 

