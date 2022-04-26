Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8959650F2BA
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 09:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234970AbiDZHlf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 03:41:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229825AbiDZHld (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 03:41:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6ED16DFA0
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 00:38:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650958706;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LzpJo1iu/LzOA4G9nSxWsey/leg3HpUfxIQwmJi9HX0=;
        b=eXvOCrZDfZB7d3RhT/YiEp5B0myj0xxvQyL+PFDtTINjciJD2ceCvOZbueh9LBzVJFdeXo
        8wdzrxSVfvq5d506taMyKSdxLnytPeg052sFPsf1vppl3KA6gL1qiFTVWdJGu1tJIQW05h
        p9ux9CMAHZIVDbC4p/5MYU+vjKpTUOg=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-612-hqo09vdfNjqf7mJGkRbRLw-1; Tue, 26 Apr 2022 03:38:25 -0400
X-MC-Unique: hqo09vdfNjqf7mJGkRbRLw-1
Received: by mail-wr1-f69.google.com with SMTP id s14-20020adfa28e000000b0020ac7532f08so2824412wra.15
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 00:38:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=LzpJo1iu/LzOA4G9nSxWsey/leg3HpUfxIQwmJi9HX0=;
        b=zpgAbmKqJt2bImQiBTrimGf+HYkUKLi5DLL8wH1jrICV2nFwiIgQ0EqUcxGP+u+2H5
         ugIDYQiBNZsxR643AxAxTsrpsTAkHiT2D/jaT8k7MBX/puGd0Nc4LD50e2UhgggmtQDs
         RxSdLVzepNNUP6X82qMPcTLbWfK2KMdSy7hFFxfshSMRHzT0n/fj6coQZaMJHNmt9ZaZ
         KrVhdmlMnm7TPNCJHqaW6eC9VlClrIsPbr2Jh2xCwEuWQeUUUyDJLHyxORdOWNH1wB5W
         ARZbh4DXUyCTdayfir5Vn5qC5FDWp8K5YxbAnqfHtVeyhNl0bi2m+6IHGD+C4FzlRz2m
         KK5g==
X-Gm-Message-State: AOAM531eLgH6chQwetB2Ra4e53bOR7s2bXGaRsTWXNP7/ZsEWRMbprAN
        3V73I2zoNBt1YDriY7moGk7riqCYfnW4lpn3FHzCyGZDLaGPHuH4Lf8DcWdyeoDy+mD9lZmARnw
        Nu0nivnrXSytFKo2V
X-Received: by 2002:adf:d1ea:0:b0:20a:2823:9e22 with SMTP id g10-20020adfd1ea000000b0020a28239e22mr17341560wrd.332.1650958704103;
        Tue, 26 Apr 2022 00:38:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzddT9w2YcT8YUXgopB1FrF9dk0mdAvpU8PZNJZabQUkQh3Ps05HmayEF++VL1kh8nTx2PkoQ==
X-Received: by 2002:adf:d1ea:0:b0:20a:2823:9e22 with SMTP id g10-20020adfd1ea000000b0020a28239e22mr17341541wrd.332.1650958703836;
        Tue, 26 Apr 2022 00:38:23 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-117-160.dyn.eolo.it. [146.241.117.160])
        by smtp.gmail.com with ESMTPSA id m1-20020a1ca301000000b003929c4bf250sm13506607wme.13.2022.04.26.00.38.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Apr 2022 00:38:23 -0700 (PDT)
Message-ID: <2c092f98a8fe1702173fe2b4999811dd2263faf3.camel@redhat.com>
Subject: Re: [PATCH v2 net-next] net: generalize skb freeing deferral to
 per-cpu lists
From:   Paolo Abeni <pabeni@redhat.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, Eric Dumazet <edumazet@google.com>
Date:   Tue, 26 Apr 2022 09:38:22 +0200
In-Reply-To: <20220422201237.416238-1-eric.dumazet@gmail.com>
References: <20220422201237.416238-1-eric.dumazet@gmail.com>
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


Hello,

I'm sorry for the late feedback. I have only a possibly relevant point
below.

On Fri, 2022-04-22 at 13:12 -0700, Eric Dumazet wrote:
[...]
> @@ -6571,6 +6577,28 @@ static int napi_threaded_poll(void *data)
>  	return 0;
>  }
>  
> +static void skb_defer_free_flush(struct softnet_data *sd)
> +{
> +	struct sk_buff *skb, *next;
> +	unsigned long flags;
> +
> +	/* Paired with WRITE_ONCE() in skb_attempt_defer_free() */
> +	if (!READ_ONCE(sd->defer_list))
> +		return;
> +
> +	spin_lock_irqsave(&sd->defer_lock, flags);
> +	skb = sd->defer_list;

I *think* that this read can possibly be fused with the previous one,
and another READ_ONCE() should avoid that.

BTW it looks like this version gives slightly better results than the
previous one, perhpas due to the single-liked list usage?

Thanks!

Paolo

