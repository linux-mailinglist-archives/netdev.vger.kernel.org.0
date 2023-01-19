Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E751673633
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 11:58:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbjASK60 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 05:58:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbjASK6X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 05:58:23 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A03C70C75
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 02:57:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674125852;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=X+YxX0wT5arsqEpEVRlF0GTgX6zkshCJMCpK1xpEa/s=;
        b=hnV27f6Lqk3zBLAcDuSt3QFWW1H/ZsIfYH9OtgmWydZR5LsK9MTEuZYVEjWEGCnZ7nGp4s
        trJrlL+U4Tibq7mp1UbrTKjfgT3JeNZBhvCg/hbtWclDa8Yfo62vDvWtuKKjUhPugHk+FR
        kG+EcI0HQzuoN+PSXY6rmjQHFhEIpzg=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-326-SbDBuGX3PZKVH8acfAwrXw-1; Thu, 19 Jan 2023 05:57:31 -0500
X-MC-Unique: SbDBuGX3PZKVH8acfAwrXw-1
Received: by mail-qv1-f70.google.com with SMTP id k15-20020a0cd68f000000b00535261af1b1so800139qvi.13
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 02:57:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=X+YxX0wT5arsqEpEVRlF0GTgX6zkshCJMCpK1xpEa/s=;
        b=65CSwal4gWdceUguXMWLx5kf8G8E8hWy+SvIrFEaxZYrU1Onhhg63IBVbzMXSed9rI
         NRaoEC8rKXIMTOk/EaGETqVQsywTc1am7LH+aWf73wU4ghi3Mc1kLAV2o7W4pT4XoM5/
         EWmeDj/i9xO/B4rnUPtA/S7vMpKJqpnR8u+tueCeFSPdEafN9d+LcyPVCW1SLf5tdrZO
         9GHqf/VGuEvxM7d5qeO/Mb1mvVBJdGsrkgQ2i/musGav59bH+pFCVh/b4PDgvETCUCa6
         Fb+3f96An6RohUnXoPLgYiGawI60AndgYWAGEzWnLeHzHA0276byiRJdL9gWdGs8YB3C
         VZrQ==
X-Gm-Message-State: AFqh2koUEbHGnvzGyXnTOxoJD3n719j68XFWUnXjGSYSMAnr2pEqioCu
        +EzsI0qQHbOQtMSjxMXhqeZfeudGdXZMfLW3SuWiBLud+JGK57YRdJcq2Adds9CV7L+kLLPl/Np
        VjmBRrHSPVOCCGYWK
X-Received: by 2002:ac8:60da:0:b0:3b6:2dbd:7610 with SMTP id i26-20020ac860da000000b003b62dbd7610mr25558367qtm.45.1674125850264;
        Thu, 19 Jan 2023 02:57:30 -0800 (PST)
X-Google-Smtp-Source: AMrXdXupQRvVQygNExc2oOm85l9McoTSlTe0Fg5Auoq0sA5YQxEQEnuJ9CURNUqSLdeH9/2tyrNSfg==
X-Received: by 2002:ac8:60da:0:b0:3b6:2dbd:7610 with SMTP id i26-20020ac860da000000b003b62dbd7610mr25558340qtm.45.1674125849981;
        Thu, 19 Jan 2023 02:57:29 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-124-97.dyn.eolo.it. [146.241.124.97])
        by smtp.gmail.com with ESMTPSA id h2-20020ac846c2000000b003b2ea9b76d0sm9077076qto.34.2023.01.19.02.57.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jan 2023 02:57:29 -0800 (PST)
Message-ID: <65d3fab9c64423fbf9841b21448fe48cd825070c.camel@redhat.com>
Subject: Re: [PATCH v9 01/25] net: Introduce direct data placement tcp
 offload
From:   Paolo Abeni <pabeni@redhat.com>
To:     Aurelien Aptel <aaptel@nvidia.com>, linux-nvme@lists.infradead.org,
        netdev@vger.kernel.org, sagi@grimberg.me, hch@lst.de,
        kbusch@kernel.org, axboe@fb.com, chaitanyak@nvidia.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     Boris Pismenny <borisp@nvidia.com>, aurelien.aptel@gmail.com,
        smalin@nvidia.com, malin1024@gmail.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com
Date:   Thu, 19 Jan 2023 11:57:25 +0100
In-Reply-To: <20230117153535.1945554-2-aaptel@nvidia.com>
References: <20230117153535.1945554-1-aaptel@nvidia.com>
         <20230117153535.1945554-2-aaptel@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I'm sorry for the very late feedback.

On Tue, 2023-01-17 at 17:35 +0200, Aurelien Aptel wrote:
> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> index cc072d2cfcd8..c711614604a6 100644
> --- a/net/ipv4/tcp_input.c
> +++ b/net/ipv4/tcp_input.c
> @@ -5234,6 +5234,10 @@ tcp_collapse(struct sock *sk, struct sk_buff_head =
*list, struct rb_root *root,
>  		memcpy(nskb->cb, skb->cb, sizeof(skb->cb));
>  #ifdef CONFIG_TLS_DEVICE
>  		nskb->decrypted =3D skb->decrypted;
> +#endif
> +#ifdef CONFIG_ULP_DDP
> +		nskb->ulp_ddp =3D skb->ulp_ddp;
> +		nskb->ulp_crc =3D skb->ulp_crc;
>  #endif
>  		TCP_SKB_CB(nskb)->seq =3D TCP_SKB_CB(nskb)->end_seq =3D start;
>  		if (list)
> @@ -5267,6 +5271,10 @@ tcp_collapse(struct sock *sk, struct sk_buff_head =
*list, struct rb_root *root,
>  #ifdef CONFIG_TLS_DEVICE
>  				if (skb->decrypted !=3D nskb->decrypted)
>  					goto end;
> +#endif
> +#ifdef CONFIG_ULP_DDP
> +				if (skb_is_ulp_crc(skb) !=3D skb_is_ulp_crc(nskb))
> +					goto end;
>  #endif
>  			}
>  		}

I *think* a similar check is additionally needed in tcp_try_coalesce().
Possibly even in tcp_shift_skb_data().

Cheers,

Paolo

