Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8EB7352EEC
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 20:05:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235797AbhDBSF3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Apr 2021 14:05:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234984AbhDBSF3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Apr 2021 14:05:29 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB809C0613E6;
        Fri,  2 Apr 2021 11:05:26 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id j20-20020a05600c1914b029010f31e15a7fso4658939wmq.1;
        Fri, 02 Apr 2021 11:05:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7mr2GfJg5eEcgvBSMCjlj1cDx5zt7P141cpidCvA+OE=;
        b=Bqpu5KNZC8ZgmSc6En7KsM0W7HKnyvePVTplgtYftLWqZ+TNghdf20o1psAEI+kaew
         KDYPXs+KYA2s5Gz2Y5eprNf/ieV+N3tgD6Y+UZmrnzmjZKYd0DMMWKFjZwnum1FlmFm5
         aGz2QvkBW/as3KtSS0xqaEqlBJBUwAhjkim5t8n3WSxF5a+Lradyt96TCSWTKDsM64Pl
         eSOonjh4hCD8nG1bEKRE6L/E+ZouOr+vpkwHAHpVwGZnWScZ0cm2+TqFxTGghmDqZsyv
         PKLlDKM/aCOxMqxEYLV+qflPTxGdqDAZPRQS8uBYUBm3eC9MsXJGGNxthK3KHWW0V7l1
         Yj9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7mr2GfJg5eEcgvBSMCjlj1cDx5zt7P141cpidCvA+OE=;
        b=jdHURbEGOdDwd9wQjilNPxjNZ/3RBhLBGaj+0wse5w9zGgWX5ArvZclQLeNP0lK1jZ
         WFX92tVaVd2zAtnuoA2C/7LlqPaUNPFYqLMyK55hmkp3wl0BikEuOmr1DQPiRfoL5O9a
         UMk4WGCA67ykuUvrEQGnUFsdAAIaiIphjKfKwRAnQGUSY4appTPpQxb3yasWhqjvaQMg
         jAwTbFnC9IABKJNqfRXDFBrEfF31Xq9mhLnBWHSlr1yrPB/TpHphLeEkiQxNXr88I/GB
         uZ81Nrnvdi0CeP9Y5X1RvW4JcsMkKU08XI14YNN1bi4zWwPgfQHPuFvvdzgIDnMBZRvX
         gr6g==
X-Gm-Message-State: AOAM533xBOYV3Ru26tM9ztSxBsINHv97DF1SMuNjl/RNmzHZjCgbphYU
        vZuuOnz11Ks/Ulx+TZs3Ej1aFd8W1ts=
X-Google-Smtp-Source: ABdhPJyaAtduqP9asCyPMlwX/IljNTQoupAqwWq5JfOut4afupWIFZmlDfHqtqmErqN1C8ZgqKkvDA==
X-Received: by 2002:a05:600c:4f89:: with SMTP id n9mr14084482wmq.133.1617386725296;
        Fri, 02 Apr 2021 11:05:25 -0700 (PDT)
Received: from [192.168.1.101] ([37.166.24.151])
        by smtp.gmail.com with ESMTPSA id u17sm11954151wmq.3.2021.04.02.11.05.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Apr 2021 11:05:24 -0700 (PDT)
Subject: Re: [PATCH net v2] atl1c: move tx cleanup processing out of interrupt
To:     Gatis Peisenieks <gatis@mikrotik.com>, chris.snook@gmail.com,
        davem@davemloft.net, kuba@kernel.org, hkallweit1@gmail.com,
        jesse.brandeburg@intel.com, dchickles@marvell.com,
        tully@mikrotik.com, eric.dumazet@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <c6ea0a3d1bcf79bb1e319d1e99cfed9b@mikrotik.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <e8b35b3e-ee20-412b-b2cd-5362e4282abf@gmail.com>
Date:   Fri, 2 Apr 2021 20:05:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <c6ea0a3d1bcf79bb1e319d1e99cfed9b@mikrotik.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/2/21 7:20 PM, Gatis Peisenieks wrote:
> Tx queue cleanup happens in interrupt handler on same core as rx queue processing.
> Both can take considerable amount of processing in high packet-per-second scenarios.
> 
> Sending big amounts of packets can stall the rx processing which is unfair
> and also can lead to to out-of-memory condition since __dev_kfree_skb_irq
> queues the skbs for later kfree in softirq which is not allowed to happen
> with heavy load in interrupt handler.
> 
> This puts tx cleanup in its own napi and enables threaded napi to allow the rx/tx
> queue processing to happen on different cores.
> 
> The ability to sustain equal amounts of tx/rx traffic increased:
> from 280Kpps to 1130Kpps on Threadripper 3960X with upcoming Mikrotik 10/25G NIC,
> from 520Kpps to 850Kpps on Intel i3-3320 with Mikrotik RB44Ge adapter.
> 
> Signed-off-by: Gatis Peisenieks <gatis@mikrotik.com>
> ---
>  drivers/net/ethernet/atheros/atl1c/atl1c.h    |  2 +
>  .../net/ethernet/atheros/atl1c/atl1c_main.c   | 43 +++++++++++++++++--
>  2 files changed, 41 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c.h b/drivers/net/ethernet/atheros/atl1c/atl1c.h
> index a0562a90fb6d..4404fa44d719 100644
> --- a/drivers/net/ethernet/atheros/atl1c/atl1c.h
> +++ b/drivers/net/ethernet/atheros/atl1c/atl1c.h
> @@ -506,6 +506,7 @@ struct atl1c_adapter {
>      struct net_device   *netdev;
>      struct pci_dev      *pdev;
>      struct napi_struct  napi;
> +    struct napi_struct  tx_napi;
>      struct page         *rx_page;
>      unsigned int        rx_page_offset;
>      unsigned int        rx_frag_size;
> @@ -529,6 +530,7 @@ struct atl1c_adapter {
>      u16 link_duplex;
> 
>      spinlock_t mdio_lock;
> +    spinlock_t irq_mask_lock;
>      atomic_t irq_sem;
> 
>      struct work_struct common_task;
> diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
> index 3f65f2b370c5..f51b28e8b6dc 100644
> --- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
> +++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
> @@ -813,6 +813,7 @@ static int atl1c_sw_init(struct atl1c_adapter *adapter)
>      atl1c_set_rxbufsize(adapter, adapter->netdev);
>      atomic_set(&adapter->irq_sem, 1);
>      spin_lock_init(&adapter->mdio_lock);
> +    spin_lock_init(&adapter->irq_mask_lock);
>      set_bit(__AT_DOWN, &adapter->flags);
> 
>      return 0;
> @@ -1530,7 +1531,7 @@ static inline void atl1c_clear_phy_int(struct atl1c_adapter *adapter)
>      spin_unlock(&adapter->mdio_lock);
>  }
> 
> -static bool atl1c_clean_tx_irq(struct atl1c_adapter *adapter,
> +static unsigned atl1c_clean_tx_irq(struct atl1c_adapter *adapter,
>                  enum atl1c_trans_queue type)


This v2 is much better, thanks.

You might rename this atl1c_clean_tx_irq(), because it is now
not run under hard irqs ?

Maybe merge atl1c_clean_tx_irq() and atl1c_clean_tx() into a single function ?


