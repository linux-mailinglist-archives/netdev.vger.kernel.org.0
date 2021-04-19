Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7043036487E
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 18:48:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238997AbhDSQst (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 12:48:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231674AbhDSQss (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 12:48:48 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8397C06174A
        for <netdev@vger.kernel.org>; Mon, 19 Apr 2021 09:48:18 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id c8-20020a9d78480000b0290289e9d1b7bcso19114333otm.4
        for <netdev@vger.kernel.org>; Mon, 19 Apr 2021 09:48:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sJGKbymQi9DBaB5FfbpLm+QMITeaprzp7V2EHZWOmNo=;
        b=bERlyjmAr/QcW+a1cHmXNDJX5sjznRzB6WDRTVS6gyCYVkxeSDmq2oxeu6uk0KFlzC
         FXyFzI2BP0X2OsD6Z+boF6prTfuY8WzNCj7xY2LRWF7DXTKDu5da9xnQ8ICpjkc6xMSk
         2sECNtkcpFtwKtijXT6dlI8H/+uEPjaakwtsG5F0SxG0ie3zdpfZK1N4dVB9gyZecfU0
         gxFVyrd8gFElmlGJ5s4tuEX+LnNSad9IcTZFvfooBqb9yxHTzKl+zuoN06e2O/wGSEft
         9AqwFLw9+VM0N6QU4Oy2WMmt9ED/TbUkGcY45c7apdyVw3QVvccMOK75F/qzi21qbEBU
         KYlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sJGKbymQi9DBaB5FfbpLm+QMITeaprzp7V2EHZWOmNo=;
        b=kEA8c9zSkdRWFaarja9VKtuwLVCBCzEz4QrJmsDwFY7ZIMWAgjdA0ARDIXRYPFstJc
         pVg1WjcwDHVTBvdmJ2ncIf7zC/JCQXDq9tVxW1tiTxLcauBxGUhmV9RR3dyCO3+OzSk7
         vTisnjwRl1K8ehc5ip9GSUBGyZELp0tBGdNw4MQ+33se7gYWOVoPJEa7VMkkTFHpIvE0
         vyK2t+lL2wfF4rAB/kO95KYwKcgw0gy4AXl04wn85qMkpWNql6sipCDl2sYc1B6790js
         ixJ3tgxXh3P1l18rrsG091v89dJ+8HWIN64oV/LCCWHm205ZW4iixNb56OPD03Ld86DI
         0aVg==
X-Gm-Message-State: AOAM531+tC4BqHFt2Hrjjmg+SfM4+Ou3XXs8ElRO0WV9WrzU0zUptmDy
        7E5cwjzpdZAVvxc8qbUNlkaE+lMyBS8=
X-Google-Smtp-Source: ABdhPJwfX5nh9pF75tXwDAGoj59DPOWQU6o9JkNznnYMMqFvEelehYN6etDO6WWN9FwmUnVYy8bbIQ==
X-Received: by 2002:a9d:73c7:: with SMTP id m7mr15164909otk.11.1618850898293;
        Mon, 19 Apr 2021 09:48:18 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.45.42.15])
        by smtp.googlemail.com with ESMTPSA id 3sm3569597otw.58.2021.04.19.09.48.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Apr 2021 09:48:17 -0700 (PDT)
Subject: Re: [PATCH net-next v3] virtio-net: page_to_skb() use build_skb when
 there's sufficient tailroom
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>, netdev@vger.kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        virtualization@lists.linux-foundation.org
References: <20210416091615.25198-1-xuanzhuo@linux.alibaba.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <ebaeb57a-924a-43e4-bd5f-e41ecce9ffe6@gmail.com>
Date:   Mon, 19 Apr 2021 09:48:16 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210416091615.25198-1-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/16/21 2:16 AM, Xuan Zhuo wrote:
> In page_to_skb(), if we have enough tailroom to save skb_shared_info, we
> can use build_skb to create skb directly. No need to alloc for
> additional space. And it can save a 'frags slot', which is very friendly
> to GRO.
> 
> Here, if the payload of the received package is too small (less than
> GOOD_COPY_LEN), we still choose to copy it directly to the space got by
> napi_alloc_skb. So we can reuse these pages.
> 
> Testing Machine:
>     The four queues of the network card are bound to the cpu1.
> 
> Test command:
>     for ((i=0;i<5;++i)); do sockperf tp --ip 192.168.122.64 -m 1000 -t 150& done
> 
> The size of the udp package is 1000, so in the case of this patch, there
> will always be enough tailroom to use build_skb. The sent udp packet
> will be discarded because there is no port to receive it. The irqsoftd
> of the machine is 100%, we observe the received quantity displayed by
> sar -n DEV 1:
> 
> no build_skb:  956864.00 rxpck/s
> build_skb:    1158465.00 rxpck/s
> 

virtio_net is using napi_consume_skb, so napi_build_skb should show a
small increase from build_skb.

