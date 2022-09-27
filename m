Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4D8D5EC27C
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 14:21:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231861AbiI0MVc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 08:21:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231828AbiI0MVK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 08:21:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F0D946D89
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 05:20:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664281230;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=I1+QNen7BiNp7SqBc9pVBci2+sHLmWbTr5LJQngU/K4=;
        b=WGmivSLxM2AiHcMlKcl5b68YpNG0dkr2ta/utzMzH71o4MaA2ShkqHEDgBoxAu75k27Dgv
        HWGXaejL+DUxM8yeLBww6/dpDx+DUqz4DBnQvY8toNOhflRjStMzGkrX6hwgMRQStCAS45
        RURfkZPhvRi1HW6/UHtFSMQBbaUxjsE=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-196-BClZp6nVOaWrqz46RbzspQ-1; Tue, 27 Sep 2022 08:20:28 -0400
X-MC-Unique: BClZp6nVOaWrqz46RbzspQ-1
Received: by mail-ej1-f72.google.com with SMTP id xc12-20020a170907074c00b007416699ea14so3726376ejb.19
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 05:20:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date;
        bh=I1+QNen7BiNp7SqBc9pVBci2+sHLmWbTr5LJQngU/K4=;
        b=YFtHCkYaI966jTYzLweuPs19KUHJI0REtvtSnlPraV86tO9GYZtc52lMBOi8YwRubP
         HAIW1bQ2X74gW+QkPrrIo1wQ6KV1d6xtCYY1xrlx2Qw4/K+NFJH2FIX1UeVRxgZRm881
         c2W6IIeto8J4REy7s7TIX+Kjy8VvCaagf81AqARiCelA9ZtKuxlhfOqTqmzhUssSxsz2
         +FsPxVZqqKLmalGXjefD4LyK0HeSgOBsWF+RZr2hzqNmoviQnDkOiCu9dhVshIIWKr69
         Uj1kSCXVnd7/CiOxmlc2Iavs2s513T6Lne5Isv8+ms3wRMrQUDoroq41Kb4WE51jSlNK
         mizQ==
X-Gm-Message-State: ACrzQf3oJMyuMokZTpG/QJtSu4QqgvMprQWQ7n3znFKmTaPTdmCdfe1/
        egGRrlfTG2zsvnyEuYrj8uIw3R46IPPgzb6XL7a7XMaRGFmr3xWYOUufHmorg/HR3YG5ea7yOyJ
        jTBsf1HTGjEILs9Xn
X-Received: by 2002:a05:6402:440d:b0:450:de54:3fcf with SMTP id y13-20020a056402440d00b00450de543fcfmr26682755eda.312.1664281227565;
        Tue, 27 Sep 2022 05:20:27 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4X9yLT6XqOx62kZcb9rnmnkmAxYmwl6IpCVQazZm3QvmFLmpt1lNYVVVQP6K9Miij4wBQZAw==
X-Received: by 2002:a05:6402:440d:b0:450:de54:3fcf with SMTP id y13-20020a056402440d00b00450de543fcfmr26682725eda.312.1664281227243;
        Tue, 27 Sep 2022 05:20:27 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id i28-20020a0564020f1c00b0044e7d69091asm1156159eda.85.2022.09.27.05.20.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 05:20:26 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id E6D1961CFF7; Tue, 27 Sep 2022 14:20:25 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Heng Qi <hengqi@linux.alibaba.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH net] veth: Avoid drop packets when xdp_redirect performs
In-Reply-To: <1664267413-75518-1-git-send-email-hengqi@linux.alibaba.com>
References: <1664267413-75518-1-git-send-email-hengqi@linux.alibaba.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 27 Sep 2022 14:20:25 +0200
Message-ID: <87wn9proty.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Heng Qi <hengqi@linux.alibaba.com> writes:

> In the current processing logic, when xdp_redirect occurs, it transmits
> the xdp frame based on napi.
>
> If napi of the peer veth is not ready, the veth will drop the packets.
> This doesn't meet our expectations.

Erm, why don't you just enable NAPI? Loading an XDP program is not
needed these days, you can just enable GRO on both peers...

> In this context, if napi is not ready, we convert the xdp frame to a skb,
> and then use veth_xmit() to deliver it to the peer veth.
>
> Like the following case:
> Even if veth1's napi cannot be used, the packet redirected from the NIC
> will be transmitted to veth1 successfully:
>
> NIC   ->   veth0----veth1
>  |                   |
> (XDP)             (no XDP)
>
> Signed-off-by: Heng Qi <hengqi@linux.alibaba.com>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---
>  drivers/net/veth.c | 36 +++++++++++++++++++++++++++++++++++-
>  1 file changed, 35 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/veth.c b/drivers/net/veth.c
> index 466da01..e1f5561 100644
> --- a/drivers/net/veth.c
> +++ b/drivers/net/veth.c
> @@ -469,8 +469,42 @@ static int veth_xdp_xmit(struct net_device *dev, int n,
>  	/* The napi pointer is set if NAPI is enabled, which ensures that
>  	 * xdp_ring is initialized on receive side and the peer device is up.
>  	 */
> -	if (!rcu_access_pointer(rq->napi))
> +	if (!rcu_access_pointer(rq->napi)) {
> +		for (i = 0; i < n; i++) {
> +			struct xdp_frame *xdpf = frames[i];
> +			struct netdev_queue *txq = NULL;
> +			struct sk_buff *skb;
> +			int queue_mapping;
> +			u16 mac_len;
> +
> +			skb = xdp_build_skb_from_frame(xdpf, dev);
> +			if (unlikely(!skb)) {
> +				ret = nxmit;
> +				goto out;
> +			}
> +
> +			/* We need to restore ETH header, because it is pulled
> +			 * in eth_type_trans.
> +			 */
> +			mac_len = skb->data - skb_mac_header(skb);
> +			skb_push(skb, mac_len);
> +
> +			nxmit++;
> +
> +			queue_mapping = skb_get_queue_mapping(skb);
> +			txq = netdev_get_tx_queue(dev, netdev_cap_txqueue(dev, queue_mapping));
> +			__netif_tx_lock(txq, smp_processor_id());
> +			if (unlikely(veth_xmit(skb, dev) != NETDEV_TX_OK)) {
> +				__netif_tx_unlock(txq);
> +				ret = nxmit;
> +				goto out;
> +			}
> +			__netif_tx_unlock(txq);

Locking and unlocking the txq repeatedly for each packet? Yikes! Did you
measure the performance overhead of this?

-Toke

