Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6C176361EA
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 15:34:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238408AbiKWOet (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 09:34:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238107AbiKWOes (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 09:34:48 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8531F18B21
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 06:33:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669214031;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VEC/ljsECl0xwOwNuuFj4J2VWL3DFQIVZWJ6dvR2khs=;
        b=C9vFwQEbkehORiQkhkuDd6jbj1pJJD5GTz1hlCK4houkRU0hjw/p+GBLHz0jh/Q0mvcK5B
        ffMtksegjZjM70KD/hnYcwmctRsEhcBLBBKP3ZWE7ZMfDgdqyq6XKLR7pVdWJ3WSQTpyyl
        liBiuuf9jVo5yOx0goFrS/kPxJTV9fY=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-212-NZmXO0IJMsGqsqibqthnMw-1; Wed, 23 Nov 2022 09:33:50 -0500
X-MC-Unique: NZmXO0IJMsGqsqibqthnMw-1
Received: by mail-ej1-f71.google.com with SMTP id xh12-20020a170906da8c00b007413144e87fso10015930ejb.14
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 06:33:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VEC/ljsECl0xwOwNuuFj4J2VWL3DFQIVZWJ6dvR2khs=;
        b=mDaDveWJsg234PzASWo8EQd+wq4nQT1fPxft4s+7DQhgeFqo8+96/oRfSaJNtMeCSq
         vbdnp41NpiX0uI8rC2wSIBr+WqaWJs/C8VL4i3Qlq/Sc1pzZtPUxrzOBQn2IuJESICIK
         j6+pUf7lULuOnF7HGeEwMS4Ri9J5LgDA32cWJRo4xo7F9weUJCa6PhjYQocsg690g1yo
         hlACkQwUrPWiNuDmdcdq7QunoQN54P8K6Nvz+fEtBBS1XWTeOFQfHAatIlqpqisDApu6
         TCWzQJonTg8r/ORvGtLJ7zcIQTjoYbBRiS9HNAO4pQME6TyS4D9C99GZkQystFeTKAI6
         Xt+w==
X-Gm-Message-State: ANoB5plsb2c4n/MbNOO8TZl+yi6juDOVKpODRcOjmQeIoZ4KmrYNKXnn
        bdtbyoXa/6zUYdURuMaQjzpMoTZiDWxHFzADcZU5YZEIyb5/zp7/nOVmXOhACsmGSQy6wWbqbK2
        f9NXLIwqE84ZAuvXn
X-Received: by 2002:a17:906:ce35:b0:7ae:215:2dd5 with SMTP id sd21-20020a170906ce3500b007ae02152dd5mr8205298ejb.208.1669214029127;
        Wed, 23 Nov 2022 06:33:49 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6Br7EfMXN8zzJJucIbAC1NA/3UEE3+EzuxBZef9EsnddC7aq3JapzaQq+3gcmcLf6jmsIGvw==
X-Received: by 2002:a17:906:ce35:b0:7ae:215:2dd5 with SMTP id sd21-20020a170906ce3500b007ae02152dd5mr8205265ejb.208.1669214028772;
        Wed, 23 Nov 2022 06:33:48 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id es8-20020a056402380800b00459148fbb3csm7642794edb.86.2022.11.23.06.33.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 06:33:48 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 63FC87D511B; Wed, 23 Nov 2022 15:33:47 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Stanislav Fomichev <sdf@google.com>, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Subject: Re: [xdp-hints] [PATCH bpf-next v2 6/8] mlx4: Introduce
 mlx4_xdp_buff wrapper for xdp_buff
In-Reply-To: <20221121182552.2152891-7-sdf@google.com>
References: <20221121182552.2152891-1-sdf@google.com>
 <20221121182552.2152891-7-sdf@google.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 23 Nov 2022 15:33:47 +0100
Message-ID: <874jupviyc.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stanislav Fomichev <sdf@google.com> writes:

> No functional changes. Boilerplate to allow stuffing more data after xdp_buff.
>
> Cc: Tariq Toukan <tariqt@nvidia.com>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Martin KaFai Lau <martin.lau@linux.dev>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Willem de Bruijn <willemb@google.com>
> Cc: Jesper Dangaard Brouer <brouer@redhat.com>
> Cc: Anatoly Burakov <anatoly.burakov@intel.com>
> Cc: Alexander Lobakin <alexandr.lobakin@intel.com>
> Cc: Magnus Karlsson <magnus.karlsson@gmail.com>
> Cc: Maryam Tahhan <mtahhan@redhat.com>
> Cc: xdp-hints@xdp-project.net
> Cc: netdev@vger.kernel.org
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>  drivers/net/ethernet/mellanox/mlx4/en_rx.c | 26 +++++++++++++---------
>  1 file changed, 15 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/net/ethernet/mellanox/mlx4/en_rx.c b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
> index 8f762fc170b3..467356633172 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/en_rx.c
> +++ b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
> @@ -661,17 +661,21 @@ static int check_csum(struct mlx4_cqe *cqe, struct sk_buff *skb, void *va,
>  #define MLX4_CQE_STATUS_IP_ANY (MLX4_CQE_STATUS_IPV4)
>  #endif
>  
> +struct mlx4_xdp_buff {
> +	struct xdp_buff xdp;
> +};

This embedding trick works for drivers that put xdp_buff on the stack,
but mlx5 supports XSK zerocopy, which uses the xsk_buff_pool for
allocating them. This makes it a bit awkward to do the same thing there;
and since it's probably going to be fairly common to do something like
this, how about we just add a 'void *drv_priv' pointer to struct
xdp_buff that the drivers can use? The xdp_buff already takes up a full
cache line anyway, so any data stuffed after it will spill over to a new
one; so I don't think there's much difference performance-wise.

I'll send my patch to add support to mlx5 (using the drv_priv pointer
approach) separately.

-Toke

