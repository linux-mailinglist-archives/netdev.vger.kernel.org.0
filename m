Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C542425A942
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 12:17:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726733AbgIBKRO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 06:17:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726669AbgIBKRD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 06:17:03 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E89AC061244;
        Wed,  2 Sep 2020 03:17:01 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id e16so4622703wrm.2;
        Wed, 02 Sep 2020 03:17:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=N/dP84MtQMVHkBazS0DLjtQES8Qh70RraTOATCmW1ig=;
        b=vcoeLRaIK/PYuCxdeYXDxvNlLAvDzcL147In8qNnoJJK4ijgJLs7w9pwnMpuXIEORj
         XcDMcM8FKksPhjZW/mJZqyupBZDeEmG1tirF3BTU47BD98e/WksBwOE6AX2cwh1wBdm+
         44Duw4+TCkj5kG2cPtsjIQvhGt0xgPR+Lm4jn+JIuZSxh6RxUCWyP4W5Wt9mnzi7blCR
         1mZuoOnmTm6M3SZwuu3rP/tUI3sd5te5OMLIFSrQhQweNVMCUhlIJf3L21MejYhmvT84
         KgGpWZQFcnz6MY3miz+GLP1Jr+2FbRXQ0MjtVFqZBfDDO5Py+r/GpfZqzizngGAESnUg
         t2jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=N/dP84MtQMVHkBazS0DLjtQES8Qh70RraTOATCmW1ig=;
        b=KOLMjbNL65xusg7D6dfFIKk/fNyuELCheSMZyu1+euTJn3XPkGRkcyWQNtI6AyR7eX
         w1qjQiNmBHkkEqBYvoMffTh/jwdT5az+o340kikIPPhfBAKguvi1twj3x01D4Qr1C2sK
         yK+QnC917fG8x2fMQ7SE94KSMSdfHGK5ih7PedqY4or9N4IYW5x0ZeOgCURXlnQ1mmbk
         OPheakb5rzPp6pln1agTxb7mmTQTg45q+osesQt1FPtrs1IHuuS1RkE+LFOa/HzGe6wt
         w1KVV/qxNVOWRapWDJqH/2BEKrauQJYBy2W/UUExwGgHwGzovmaEXPDLfNVnZ9yhwW2q
         O99A==
X-Gm-Message-State: AOAM532BJypNKijxx9fb4p8ne/0EJQYfHDMmA8xChZF7aV4bI+Ko61Bu
        9hdwtDQGdO5juoH0kPMjuiA=
X-Google-Smtp-Source: ABdhPJwzvhhH1DstpySiVyyZ44G7ypEFLHyy+WXhMgCzA/0AwPZTBsdnE76N/xw/LFomBwfW1Syq0g==
X-Received: by 2002:a5d:43cf:: with SMTP id v15mr6468553wrr.269.1599041819804;
        Wed, 02 Sep 2020 03:16:59 -0700 (PDT)
Received: from [192.168.8.147] ([37.171.70.17])
        by smtp.gmail.com with ESMTPSA id f6sm6645502wro.5.2020.09.02.03.16.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Sep 2020 03:16:59 -0700 (PDT)
Subject: Re: [PATCH net 3/3] hinic: fix bug of send pkts while setting
 channels
To:     Luo bin <luobin9@huawei.com>, davem@davemloft.net
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        luoxianjun@huawei.com, yin.yinshi@huawei.com,
        cloud.wangxiaoyun@huawei.com, chiqijun@huawei.com
References: <20200902094145.12216-1-luobin9@huawei.com>
 <20200902094145.12216-4-luobin9@huawei.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <fa78a6e8-c21e-ca4a-e40b-4109fb8a78d5@gmail.com>
Date:   Wed, 2 Sep 2020 12:16:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200902094145.12216-4-luobin9@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/2/20 2:41 AM, Luo bin wrote:
> When calling hinic_close in hinic_set_channels, netif_carrier_off
> and netif_tx_disable are excuted, and TX host resources are freed
> after that. Core may call hinic_xmit_frame to send pkt after
> netif_tx_disable within a short time, so we should judge whether
> carrier is on before sending pkt otherwise the resources that
> have already been freed in hinic_close may be accessed.
> 
> Fixes: 2eed5a8b614b ("hinic: add set_channels ethtool_ops support")
> Signed-off-by: Luo bin <luobin9@huawei.com>
> ---
>  drivers/net/ethernet/huawei/hinic/hinic_tx.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/net/ethernet/huawei/hinic/hinic_tx.c b/drivers/net/ethernet/huawei/hinic/hinic_tx.c
> index a97498ee6914..a0662552a39c 100644
> --- a/drivers/net/ethernet/huawei/hinic/hinic_tx.c
> +++ b/drivers/net/ethernet/huawei/hinic/hinic_tx.c
> @@ -531,6 +531,11 @@ netdev_tx_t hinic_xmit_frame(struct sk_buff *skb, struct net_device *netdev)
>  	struct hinic_txq *txq;
>  	struct hinic_qp *qp;
>  
> +	if (unlikely(!netif_carrier_ok(netdev))) {
> +		dev_kfree_skb_any(skb);
> +		return NETDEV_TX_OK;
> +	}
> +
>  	txq = &nic_dev->txqs[q_id];
>  	qp = container_of(txq->sq, struct hinic_qp, sq);
>  
> 

Adding this kind of tests in fast path seems a big hammer to me.

See https://marc.info/?l=linux-netdev&m=159903844423389&w=2   for a similar problem.

Normally, after hinic_close() operation, no packet should be sent by core networking stack.

Trying to work around some core networking issue in each driver is a dead end.






