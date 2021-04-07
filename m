Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60883357275
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 18:55:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354397AbhDGQ4C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 12:56:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347854AbhDGQ4A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 12:56:00 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1E87C061756;
        Wed,  7 Apr 2021 09:55:50 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id t5-20020a1c77050000b029010e62cea9deso1577450wmi.0;
        Wed, 07 Apr 2021 09:55:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=915V6CjwSLmhpqpygdvEsCqxze4gWRGuBke0G653l/A=;
        b=DkdZvqQiiPo+VUt7vD5jo4mCHKSY5bswnzvU0NjnHyUJVXwb/ZWeE19Ml+2pk9rZ9t
         8qX00lc+y54bzhEJee9JfXVhbKSQQL6qvXqLfJ5AtHX0MHptAj6n9RMS8f98RYW1s/qS
         blG7fTu+U7ArD8QniPzLOczoL7vPsQv78+DhC6yetmJnBETLeO99T/n6OkPOm2NwjrqK
         0nky7P3jG/TTl21J0qPdmJFL2uJTl9yhNxvLv0pG3g8IJxKS0LxxUzc4cBkHwlfrtqff
         YdRL7AHbXtrlJwJcWnQv13MvCJv1/24vl06i7XEPshYJWLx82dneFTzGAeJeaQ3/3XuA
         hLnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=915V6CjwSLmhpqpygdvEsCqxze4gWRGuBke0G653l/A=;
        b=kxiOgvY/qtzbspERp99dCBSfnuwfBwh1FZ+DRxneFwf6NlrgxrPwxrtgFVBCCV4kZo
         w3/bZvkNz8ToxxVfYP59IVA7TvLCzIB94XC7ahYLTogA1HjfeaVniKpW4c1OCUfYEUvC
         poys0bERpy5ZatV06Kav08MmAWYGpVT3iJ+Tx8w3suSOzJWTWULO4WONnKhtN2hZZQa6
         1L0HnXEg99n+aI+AY2CZaHI0HuSG6AzG9XvsNzhOwRBFsxdSQyN7mWR9Pw2/mi2jcDTV
         A1u5PFqcjVh3Nt/3T5H+3Tn8YTxPafQXGIUYHL4EnGROM7itoZ+vZuxQ3EQZn4dfVPTb
         uEbg==
X-Gm-Message-State: AOAM532O1927MaydKT9Eh6KC+x7n06VKIxIK7zyrnI6uWIpQ53H39cFk
        rbvS8mmSAfiKislbW3WueKb/ZPJjOeI=
X-Google-Smtp-Source: ABdhPJy2i0PivtNtlBJljUSyafWje+oIqRtFM4Wf5rmQW7WFNhTT7M2KiPelZA8Eyb7cujGftmJX1w==
X-Received: by 2002:a1c:f701:: with SMTP id v1mr4049207wmh.69.1617814549387;
        Wed, 07 Apr 2021 09:55:49 -0700 (PDT)
Received: from [192.168.1.101] ([37.172.15.210])
        by smtp.gmail.com with ESMTPSA id c18sm14718985wrp.33.2021.04.07.09.55.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Apr 2021 09:55:48 -0700 (PDT)
Subject: Re: [PATCH net v4] atl1c: move tx cleanup processing out of interrupt
To:     Gatis Peisenieks <gatis@mikrotik.com>, chris.snook@gmail.com,
        davem@davemloft.net, kuba@kernel.org, hkallweit1@gmail.com,
        jesse.brandeburg@intel.com, dchickles@marvell.com,
        tully@mikrotik.com, eric.dumazet@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <c8327d4bb516dd4741878c64fa6485cd@mikrotik.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <7c5dad3e-950d-8ec9-8b9d-bbce41fafaa4@gmail.com>
Date:   Wed, 7 Apr 2021 18:55:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <c8327d4bb516dd4741878c64fa6485cd@mikrotik.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/6/21 4:49 PM, Gatis Peisenieks wrote:
> Tx queue cleanup happens in interrupt handler on same core as rx queue
> processing. Both can take considerable amount of processing in high
> packet-per-second scenarios.
> 
> Sending big amounts of packets can stall the rx processing which is unfair
> and also can lead to out-of-memory condition since __dev_kfree_skb_irq
> queues the skbs for later kfree in softirq which is not allowed to happen
> with heavy load in interrupt handler.
> 

[ ... ]

> diff --git a/net/core/dev.c b/net/core/dev.c
> index 0f72ff5d34ba..489ac60b530c 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -6789,6 +6789,7 @@ int dev_set_threaded(struct net_device *dev, bool threaded)
> 
>      return err;
>  }
> +EXPORT_SYMBOL(dev_set_threaded);
> 
>  void netif_napi_add(struct net_device *dev, struct napi_struct *napi,
>              int (*poll)(struct napi_struct *, int), int weight)

This has already been done in net-next

Please base your patch on top of net-next, this can not be backported to old
versions anyway, without some amount of pain.



