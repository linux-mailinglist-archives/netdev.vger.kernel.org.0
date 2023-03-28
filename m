Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B39D56CBB4A
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 11:42:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230371AbjC1JmU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 05:42:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232889AbjC1JmK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 05:42:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C029255A4
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 02:41:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679996478;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vmyGwthrGrNGtqcedPWh2+q6nW2x4B+d0rjKglHKKz4=;
        b=VKyD1FAuTF7eKRS6PhORwnltxGivxzv7VVQZZgprC9ZBEFtmx3CUcsZX4gEBOfvu6VJfNM
        GiXhzQj0Pg1Rcwp2DJiD3+EnybOlWryGJ3WodMcEqUCsgMsOuwIB/w6ssH51HWezy6Sb3O
        XKuBUrnGcmmGQNphPCiAsLWA743cEAw=
Received: from mail-yb1-f199.google.com (mail-yb1-f199.google.com
 [209.85.219.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-475-R58Hz9e4Nraq119jqe5orw-1; Tue, 28 Mar 2023 05:41:16 -0400
X-MC-Unique: R58Hz9e4Nraq119jqe5orw-1
Received: by mail-yb1-f199.google.com with SMTP id 205-20020a2503d6000000b00b7411408308so11360094ybd.1
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 02:41:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679996476;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vmyGwthrGrNGtqcedPWh2+q6nW2x4B+d0rjKglHKKz4=;
        b=J674O5rR5CZ5F3jfqSm/x9yLk8gpmxUorhE+9eOnpZEpYCWeOlufgMbWz3VchEyv8K
         nbzYo6qT1XVtbPwhrkocWFbiAE7apfgzbOsQejBZ2ixG9lJUQtF2m91Ls1My1j8syczO
         Zk7/jg7Hs7XCmnC28oHByqbqlnS6J6j/TbYOjGhIbqHzPYeoaYX+wAj8hb3eIVKQClKJ
         8sPQR787roG+uGyl29F/DFzgZRKBhkBPK4OjnVWmjS/WAsBNxvrRCO2cqbvJMfyYAS4E
         Z/8Uf47mYWbFywE7XEX0BqbMolsJnpoz9rwXbcCHtEJwxkDcwEYtzD+v/PWRhTzK0spd
         9QsA==
X-Gm-Message-State: AAQBX9caTRrgL/s8xeM5pmBe2qqDOk2c6pISmr4sBingszwxc302W933
        B/rkxpTobLjaD82+Kv5dEG1lG0Y5FfQroU1WJuHrzfKUQqdBwMdpDPjPmwXncQTOm2saIM+Q/dF
        16O/VykCROYCN+U42/d4fobflRRGpcwqD
X-Received: by 2002:a81:b721:0:b0:545:3f42:2d97 with SMTP id v33-20020a81b721000000b005453f422d97mr5919436ywh.3.1679996475821;
        Tue, 28 Mar 2023 02:41:15 -0700 (PDT)
X-Google-Smtp-Source: AKy350aUolOHwAe56CecNd0CABkiuSrZUxDa3K0A8CszJ088fIp7QTXcDxgWE91uDzPEPSrBDT7cUYobpC//OMoAK54=
X-Received: by 2002:a81:b721:0:b0:545:3f42:2d97 with SMTP id
 v33-20020a81b721000000b005453f422d97mr5919429ywh.3.1679996475584; Tue, 28 Mar
 2023 02:41:15 -0700 (PDT)
MIME-Version: 1.0
References: <728181e9-6b35-0092-3d01-3d7aff4521b6@sberdevices.ru>
 <30aa2604-77c0-322e-44fd-ff99fc25e388@sberdevices.ru> <lgpswwclsuiukh2q5couf33jytf6abneazmwkty6fevoxcgh5p@3dzfbmenjhco>
 <d91ac5f0-1f47-58b3-d033-f492d0e17da7@sberdevices.ru>
In-Reply-To: <d91ac5f0-1f47-58b3-d033-f492d0e17da7@sberdevices.ru>
From:   Stefano Garzarella <sgarzare@redhat.com>
Date:   Tue, 28 Mar 2023 11:41:03 +0200
Message-ID: <CAGxU2F707_88UGt1w9pp_KLrg8EY7-BjceM+N1S6YHXSmBC+eQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2 2/3] virtio/vsock: WARN_ONCE() for invalid state of socket
To:     Arseniy Krasnov <avkrasnov@sberdevices.ru>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@sberdevices.ru, oxffffaa@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 28, 2023 at 11:35=E2=80=AFAM Arseniy Krasnov
<avkrasnov@sberdevices.ru> wrote:
>
>
>
> On 28.03.2023 12:29, Stefano Garzarella wrote:
> > On Sun, Mar 26, 2023 at 01:09:25AM +0300, Arseniy Krasnov wrote:
> >> This adds WARN_ONCE() and return from stream dequeue callback when
> >> socket's queue is empty, but 'rx_bytes' still non-zero.
> >
> > Nit: I would explain why we add this, for example:
> >
> > This allows the detection of potential bugs due to packet merging
> > (see previous patch).
> >
> >>
> >> Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
> >> ---
> >> net/vmw_vsock/virtio_transport_common.c | 7 +++++++
> >> 1 file changed, 7 insertions(+)
> >
> >>
> >> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/v=
irtio_transport_common.c
> >> index b9144af71553..ad70531de133 100644
> >> --- a/net/vmw_vsock/virtio_transport_common.c
> >> +++ b/net/vmw_vsock/virtio_transport_common.c
> >> @@ -398,6 +398,13 @@ virtio_transport_stream_do_dequeue(struct vsock_s=
ock *vsk,
> >>     u32 free_space;
> >>
> >>     spin_lock_bh(&vvs->rx_lock);
> >> +
> >> +    if (WARN_ONCE(skb_queue_empty(&vvs->rx_queue) && vvs->rx_bytes,
> >> +              "No skbuffs with non-zero 'rx_bytes'\n")) {
> >
> > Nit: I would rephrase it this way:
> > "rx_queue is empty, but rx_bytes is non-zero"
> >
> >> +        spin_unlock_bh(&vvs->rx_lock);
> >> +        return err;
> >> +    }
> >> +
> >>     while (total < len && !skb_queue_empty(&vvs->rx_queue)) {
> >>         skb =3D skb_peek(&vvs->rx_queue);
> >>
> >> --
> >> 2.25.1
> >>
> >
> > Anyway the patch LGTM!
>
> Thanks for review! Since only string value and commit message should be
> updated, i can resend it with 'net' (as it is fix) and update two thing
> above in 'net' version?

Yep, sure!

And you can already add my R-b ;-)

Thanks,
Stefano

>
> Thanks, Arseniy
> >
> > Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
> >
>

