Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03B776F3FCE
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 11:06:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233546AbjEBJGh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 05:06:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbjEBJGg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 05:06:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D76DC2D4A
        for <netdev@vger.kernel.org>; Tue,  2 May 2023 02:05:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683018345;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f0C+/AMlCSZv9AQrfgdKXuPAa+4+MUJG4w0wWq0+U44=;
        b=dy0bA6eo4E0nVMV00xZe4khym/sYuLG0jws2As7DI/e6pbXCwEnkSyYEwZdeHmcI3DA5yv
        nEtolJELA6VWubZK+sEVhO5WqvGlz5Z62ZyviEhYNOt1syJQWP26AZAsCF0jBmsnJQDTZi
        kn1O1PWp8YFI9JIKtuR96boKSfWyg04=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-480-P8XBzDBHP6Cg8_Zka9tkUw-1; Tue, 02 May 2023 05:05:44 -0400
X-MC-Unique: P8XBzDBHP6Cg8_Zka9tkUw-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-3f08900caadso1710825e9.0
        for <netdev@vger.kernel.org>; Tue, 02 May 2023 02:05:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683018343; x=1685610343;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=f0C+/AMlCSZv9AQrfgdKXuPAa+4+MUJG4w0wWq0+U44=;
        b=Mh3EOYxlyNxyev1iJ5ayYxDDL/g9CuT4vC54pa8TuMu+tIR+sBY3XeIf3vMORD677V
         vvCbolR0ZMe5b2g0j8ZwIrni4/goyclnd9uQrVE6b7skc3Zfs+gIL4QfzWoCVYxti8IX
         w6xV+YL9YLFiM7eXuyCyryCIjZhB8y9RCw+w7ItbslIN4gW+gd6DDIQC79H/MRf+HgVK
         euystNJK2tNtZGZfahOijN4ungAwJ5vGRipr7cRgfXu4JboQhyO8DxntUg9QifDBw+4d
         ldkhPiUsdLq6/Z128eb6euoBnCMIsoIzH83talSQLdycZ8jRyEvIvU1Un9mNeKkV067G
         1MUw==
X-Gm-Message-State: AC+VfDzPyjFiNfxPbJ+zPvMwmvuhyXuVo8O2wq4Or3xcR0tf5GyJAUl5
        K7/hQ1XKRrtSwY1IhCldWhESaY6e+5UTpGkO+il8ukmG8+v+0QXIvIjVS7BEjICD+CiMJ7Uksjl
        A/5ZYPUQ2DscCPftI
X-Received: by 2002:adf:fccd:0:b0:2e4:c9ac:c492 with SMTP id f13-20020adffccd000000b002e4c9acc492mr1293377wrs.1.1683018342788;
        Tue, 02 May 2023 02:05:42 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4rjtYdoyKyhcXOhmiGl12IvQfl4xRWKrtn/zid6aStQkUznSnb92UaWiUzP5pZgPUG9N/gkA==
X-Received: by 2002:adf:fccd:0:b0:2e4:c9ac:c492 with SMTP id f13-20020adffccd000000b002e4c9acc492mr1293354wrs.1.1683018342311;
        Tue, 02 May 2023 02:05:42 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-253-104.dyn.eolo.it. [146.241.253.104])
        by smtp.gmail.com with ESMTPSA id bl13-20020adfe24d000000b003062d3daf79sm4895245wrb.107.2023.05.02.02.05.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 May 2023 02:05:41 -0700 (PDT)
Message-ID: <d05564fd4fc47ed212be2c02be4d7c05167fa2b3.camel@redhat.com>
Subject: Re: [PATCH v3] virtio_net: suppress cpu stall when free_unused_bufs
From:   Paolo Abeni <pabeni@redhat.com>
To:     Wenliang Wang <wangwenliang.1995@bytedance.com>, mst@redhat.com,
        jasowang@redhat.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, zhengqi.arch@bytedance.com,
        willemdebruijn.kernel@gmail.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 02 May 2023 11:05:40 +0200
In-Reply-To: <1682783278-12819-1-git-send-email-wangwenliang.1995@bytedance.com>
References: <1682783278-12819-1-git-send-email-wangwenliang.1995@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2023-04-29 at 23:47 +0800, Wenliang Wang wrote:
> For multi-queue and large ring-size use case, the following error
> occurred when free_unused_bufs:
> rcu: INFO: rcu_sched self-detected stall on CPU.
>=20
> Signed-off-by: Wenliang Wang <wangwenliang.1995@bytedance.com>

Net next is currently closed, but this patch could arguably land on the
net tree - assuming Micheal agrees.

In that case you should include a suitable Fixes tag - reposting a new
version.

> ---
> v2:
> -add need_resched check.
> -apply same logic to sq.
> v3:
> -use cond_resched instead.
> ---
>  drivers/net/virtio_net.c | 2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index ea1bd4bb326d..744bdc8a1abd 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -3559,12 +3559,14 @@ static void free_unused_bufs(struct virtnet_info =
*vi)
>  		struct virtqueue *vq =3D vi->sq[i].vq;
>  		while ((buf =3D virtqueue_detach_unused_buf(vq)) !=3D NULL)
>  			virtnet_sq_free_unused_buf(vq, buf);
> +		cond_resched();

Note that on v1 Xuan Zhuo suggested to do the above check only every a
low fixed number of buffer. I think the current code is a better
option, as the need_resched() check is very cheap and the overall code
simpler.

In any case, when submitting a new revision, please explicitly CC
whoever gave feedback on previous ones.

Thanks,

Paolo

