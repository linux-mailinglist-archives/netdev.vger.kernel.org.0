Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFAE56CBB16
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 11:34:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232944AbjC1JdR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 05:33:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232942AbjC1JdB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 05:33:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F1FC83F2
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 02:30:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679995761;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2MTYkIHhyDg1tSTjOD+oc1eBs9Ie8OrzP6nP660U11M=;
        b=co8y9FE3CeMxbgb9J/erVbhhC9QnN5ji8wtKFh0cSIFWPlQrI06gNUsOtKluDjsIU5DDw0
        EgFJ4BxrrkwRFKmvcHJNcrsNjeCoIylg+3ej3diNar85y9iYMJhQuGUnasD2KCudwCi/37
        q17jUbTmimEu7Sh+Bvsk7w67OfPqtoI=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-547-i4WXrM5tNo-4l36uZHH7UQ-1; Tue, 28 Mar 2023 05:29:20 -0400
X-MC-Unique: i4WXrM5tNo-4l36uZHH7UQ-1
Received: by mail-qv1-f69.google.com with SMTP id m3-20020a0cbf03000000b005de7233ca79so2618150qvi.3
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 02:29:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679995758;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2MTYkIHhyDg1tSTjOD+oc1eBs9Ie8OrzP6nP660U11M=;
        b=ououlpOqxiEAfTK4V1oiPPIY9HWv/0q3Vnl0E7Kh1w4QqyQEd7eONySrwHaxGDsl1B
         yYIftUvrdTDn9cwgm2KhKEdKuN8IlwJoLfaBJ028RMTwK97Hb7r8wuMqc6buI6NkpRLD
         m+n9iPuH417By90prXvbfD5aDtpEHQgoDfdAQ6hxMaJSMglKvKJIAKIzlXPZeUdpiweE
         g7VI+0WKhNo4ndrwV6uAN8jD5wyystiqGnrC5OMg9K2Dje/sYdsMr+pRI4gWgwxw8sG3
         wqVhea1lhh/sLP5FU3ypfelQuooKI8Nm2S4m7K8TVLDBDLfi+wRIRa91AHlx+dxeLu8v
         MLHA==
X-Gm-Message-State: AAQBX9f9AiCW66yiogNzWJzdpPOYRFXmGVa6jC2kyYNhFHUYrM8h3o9d
        zjXXxQ1YGEcX/ECfAZ5+yn/B9JVaahhc8oUr5wMvqULd+zI83CZx0P82b2l2Yhl+A8ADcUgUuOL
        TzF0V0G2JHybAFsR0
X-Received: by 2002:a05:6214:260f:b0:56b:fb58:c350 with SMTP id gu15-20020a056214260f00b0056bfb58c350mr23964670qvb.26.1679995758200;
        Tue, 28 Mar 2023 02:29:18 -0700 (PDT)
X-Google-Smtp-Source: AKy350YbQdtTvthYdS2lSVNkd7CIQnOjtbLTtQpWx6BoakwOHWkvtaIfcNuo2kDx2/O8wrbZT546kA==
X-Received: by 2002:a05:6214:260f:b0:56b:fb58:c350 with SMTP id gu15-20020a056214260f00b0056bfb58c350mr23964649qvb.26.1679995757971;
        Tue, 28 Mar 2023 02:29:17 -0700 (PDT)
Received: from sgarzare-redhat (host-82-53-134-98.retail.telecomitalia.it. [82.53.134.98])
        by smtp.gmail.com with ESMTPSA id z9-20020a376509000000b0074283b87a4esm10340876qkb.90.2023.03.28.02.29.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Mar 2023 02:29:17 -0700 (PDT)
Date:   Tue, 28 Mar 2023 11:29:12 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
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
Subject: Re: [RFC PATCH v2 2/3] virtio/vsock: WARN_ONCE() for invalid state
 of socket
Message-ID: <lgpswwclsuiukh2q5couf33jytf6abneazmwkty6fevoxcgh5p@3dzfbmenjhco>
References: <728181e9-6b35-0092-3d01-3d7aff4521b6@sberdevices.ru>
 <30aa2604-77c0-322e-44fd-ff99fc25e388@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <30aa2604-77c0-322e-44fd-ff99fc25e388@sberdevices.ru>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 26, 2023 at 01:09:25AM +0300, Arseniy Krasnov wrote:
>This adds WARN_ONCE() and return from stream dequeue callback when
>socket's queue is empty, but 'rx_bytes' still non-zero.

Nit: I would explain why we add this, for example:

This allows the detection of potential bugs due to packet merging
(see previous patch).

>
>Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>---
> net/vmw_vsock/virtio_transport_common.c | 7 +++++++
> 1 file changed, 7 insertions(+)

>
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index b9144af71553..ad70531de133 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -398,6 +398,13 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
> 	u32 free_space;
>
> 	spin_lock_bh(&vvs->rx_lock);
>+
>+	if (WARN_ONCE(skb_queue_empty(&vvs->rx_queue) && vvs->rx_bytes,
>+		      "No skbuffs with non-zero 'rx_bytes'\n")) {

Nit: I would rephrase it this way:
"rx_queue is empty, but rx_bytes is non-zero"

>+		spin_unlock_bh(&vvs->rx_lock);
>+		return err;
>+	}
>+
> 	while (total < len && !skb_queue_empty(&vvs->rx_queue)) {
> 		skb = skb_peek(&vvs->rx_queue);
>
>-- 
>2.25.1
>

Anyway the patch LGTM!

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

