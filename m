Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5360550B384
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 11:06:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345864AbiDVJF3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 05:05:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235103AbiDVJF2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 05:05:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B6E405370B
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 02:02:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650618154;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k5XMi3GRpGxoXEQ7zwj6cuCTJHahj0aDPgM7FPSBDAw=;
        b=Ui65FztgzZcE3MfkrqceuckUdU08jnOHotUO43Stu3v2vqahB08zc+0+7QXjXRADFkcM4g
        go6gYEUH7RPlrxKQdOLQyfjhMO+HCr7x5d+aTC1Tjk69aLV4gioP6A6Q3s8yUTAv1rkMEa
        ef8sPG5ytkUDrfba+yvV9/txyf41hJ4=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-390-O5XiOJUTMpmqrmLLHBK5kA-1; Fri, 22 Apr 2022 05:02:32 -0400
X-MC-Unique: O5XiOJUTMpmqrmLLHBK5kA-1
Received: by mail-wr1-f69.google.com with SMTP id v21-20020adfa1d5000000b0020a80b3b107so1664643wrv.0
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 02:02:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=k5XMi3GRpGxoXEQ7zwj6cuCTJHahj0aDPgM7FPSBDAw=;
        b=0XoKEAxDMLR58y84yCFc+lZoF6ndbOm290pGKngAZGkZrX24hnDIRN59HV5xTlbaEQ
         606fVGyy0ocbn+BHFh4eSc43t2/Kd2c2DxZ4JpmeviHz6vGqg3DupMK/4bzYu1Twy3Yw
         PdNLK9uKAtRFcIyFFKakdfxI/ZjtHVvxLHC9OJDPZfUL/y2mvBX3Yi8r/pQ1oexOjsDU
         L3qElRy5J2PGi1j7hS28Udc/5D+YND/nc6X9RJEL8gq0EYnWsXk/v9SAWU9yEbU5h9PR
         2MoUK4BgBmp8prjdSdduRYwhFa4MbRoAs8EVcQCRX4w/8qGiNMDgCwkO0hPc1zIzKRkK
         +DeQ==
X-Gm-Message-State: AOAM533CPfY65NEM3JPkxOZAk8OGESfRhK5aIRLlpu1Pszz0ujVPQd/H
        Dc2L3nIBXzmJM3yiyLzruFjIcmWyr1KAtaXs9HramfqwkhJyBzXtrb7HkSPN8P5BDiztTPBGogw
        zPtG1iG+u+AwbQIT0
X-Received: by 2002:a05:600c:4fd0:b0:392:8cd5:8abe with SMTP id o16-20020a05600c4fd000b003928cd58abemr12355485wmq.73.1650618149568;
        Fri, 22 Apr 2022 02:02:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx2kQS78ba3SGeyN9fgL3N7K3eqXxiVbdnmWv8N0QHwJAz+Xuy68DB4MJOpa+Pf7VXogOQVYQ==
X-Received: by 2002:a05:600c:4fd0:b0:392:8cd5:8abe with SMTP id o16-20020a05600c4fd000b003928cd58abemr12355465wmq.73.1650618149296;
        Fri, 22 Apr 2022 02:02:29 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-96-237.dyn.eolo.it. [146.241.96.237])
        by smtp.gmail.com with ESMTPSA id p1-20020adfaa01000000b0020ab1e305f1sm1228559wrd.22.2022.04.22.02.02.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Apr 2022 02:02:28 -0700 (PDT)
Message-ID: <319497a698ba77244aa935c13dc9b93c893dbbc3.camel@redhat.com>
Subject: Re: [PATCH net-next] net: generalize skb freeing deferral to
 per-cpu lists
From:   Paolo Abeni <pabeni@redhat.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, Eric Dumazet <edumazet@google.com>
Date:   Fri, 22 Apr 2022 11:02:27 +0200
In-Reply-To: <20220421153920.3637792-1-eric.dumazet@gmail.com>
References: <20220421153920.3637792-1-eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Looks great! I have a few questions below mostly to understand better
how it works...

On Thu, 2022-04-21 at 08:39 -0700, Eric Dumazet wrote:
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index 84d78df60453955a8eaf05847f6e2145176a727a..2fe311447fae5e860eee95f6e8772926d4915e9f 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -1080,6 +1080,7 @@ struct sk_buff {
>  		unsigned int	sender_cpu;
>  	};
>  #endif
> +	u16			alloc_cpu;

I *think* we could in theory fetch the CPU that allocated the skb from
the napi_id - adding a cpu field to napi_struct and implementing an
helper to fetch it. Have you considered that option? or the napi lookup
would be just too expensive?

[...]

> diff --git a/net/core/dev.c b/net/core/dev.c
> index 4a77ebda4fb155581a5f761a864446a046987f51..4136d9c0ada6870ea0f7689702bdb5f0bbf29145 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -4545,6 +4545,12 @@ static void rps_trigger_softirq(void *data)
>  
>  #endif /* CONFIG_RPS */
>  
> +/* Called from hardirq (IPI) context */
> +static void trigger_rx_softirq(void *data)

Perhaps '__always_unused' ? (But the compiler doesn't complain here)

> @@ -6486,3 +6487,46 @@ void __skb_ext_put(struct skb_ext *ext)
>  }
>  EXPORT_SYMBOL(__skb_ext_put);
>  #endif /* CONFIG_SKB_EXTENSIONS */
> +
> +/**
> + * skb_attempt_defer_free - queue skb for remote freeing
> + * @skb: buffer
> + *
> + * Put @skb in a per-cpu list, using the cpu which
> + * allocated the skb/pages to reduce false sharing
> + * and memory zone spinlock contention.
> + */
> +void skb_attempt_defer_free(struct sk_buff *skb)
> +{
> +	int cpu = skb->alloc_cpu;
> +	struct softnet_data *sd;
> +	unsigned long flags;
> +	bool kick;
> +
> +	if (WARN_ON_ONCE(cpu >= nr_cpu_ids) || !cpu_online(cpu)) {
> +		__kfree_skb(skb);
> +		return;
> +	}

I'm wondering if we should skip even when cpu == smp_processor_id()? 

> +
> +	sd = &per_cpu(softnet_data, cpu);
> +	/* We do not send an IPI or any signal.
> +	 * Remote cpu will eventually call skb_defer_free_flush()
> +	 */
> +	spin_lock_irqsave(&sd->skb_defer_list.lock, flags);
> +	__skb_queue_tail(&sd->skb_defer_list, skb);
> +
> +	/* kick every time queue length reaches 128.
> +	 * This should avoid blocking in smp_call_function_single_async().
> +	 * This condition should hardly be bit under normal conditions,
> +	 * unless cpu suddenly stopped to receive NIC interrupts.
> +	 */
> +	kick = skb_queue_len(&sd->skb_defer_list) == 128;

Out of sheer curiosity why 128? I guess it's should be larger then
NAPI_POLL_WEIGHT, to cope with with maximum theorethical burst len?

Thanks!

Paolo

