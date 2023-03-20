Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D4766C1769
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 16:13:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232514AbjCTPNi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 11:13:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232380AbjCTPNP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 11:13:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30DA726BC
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 08:07:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679324842;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VgebBbttaGt4D40EQmQ7/+4mDXUoVf9daeLT8gWgLtM=;
        b=K+S95Iej7iFImLF6W7dEOIWO27EVfnTE5pm1bBvTpUwAHLVBcqBlMuJg5PPk2PVGApTd5W
        vJ7Qwz4hTI2Ob3Q5ysSNW0NmXUt20V/r8TQWpq9S24pJTdSpsNmxM8BCycHof7aKFEtOQv
        X8RXLSYxemcmQ7mR1MeF639bu+XwPIE=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-216-2qT1vHY6M9yKUkO0J5yCGw-1; Mon, 20 Mar 2023 11:07:20 -0400
X-MC-Unique: 2qT1vHY6M9yKUkO0J5yCGw-1
Received: by mail-wm1-f72.google.com with SMTP id j27-20020a05600c1c1b00b003edd2023418so2675331wms.4
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 08:07:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679324839;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VgebBbttaGt4D40EQmQ7/+4mDXUoVf9daeLT8gWgLtM=;
        b=kiAvn0hnnCMlEkuNDvULycykO+qmSljHH8rPumgqM+lufePejlWE46o00eepzoN168
         vPfE0hequ98A+qu3W2gU59oeXu0Hj+gLNuis8oYyaycwPQn0Y+rMRkaNxcq837Qg0DzS
         s30k/tH0541/CNJIsBXU6G/C7KdZVoamoAoxBv2m7F8s7JZbV696jkWGg0i86s7O1Rc6
         KidpzDe1+S4ZjaEeeFpbnQ8qzxep17gdBHNk0PTV5jCmb4dkPP7mUAenmnkE/kLLkRCQ
         KN/71WBnxKzmADMISD4Nj11v8pa1ZwVsYMHEgKdf1wEMMhh31xwHUcdoAD5NxOrjYmO8
         LR9Q==
X-Gm-Message-State: AO0yUKXAVnJmP4OPK84Eutw5RO8lPAAHEHB99k7tmX+WDod8zIGpoV7t
        P9RB2eOyzkX6ELwtR3ceNVOosGGzDY0y/oJazG1QkMQMwEq32Ggvpc6swmUZ3/7f+vp9uhx7v5T
        LeULuAYyex9Mv7QYn
X-Received: by 2002:a5d:574a:0:b0:2d7:a1e2:f5 with SMTP id q10-20020a5d574a000000b002d7a1e200f5mr1911370wrw.55.1679324839305;
        Mon, 20 Mar 2023 08:07:19 -0700 (PDT)
X-Google-Smtp-Source: AK7set/T14nWSia5GZnuqnU654Kdl6pDq7bn2tDAbaRQz0T3coNj3BVGpa9eETzLvxUNUoJckiLdQg==
X-Received: by 2002:a5d:574a:0:b0:2d7:a1e2:f5 with SMTP id q10-20020a5d574a000000b002d7a1e200f5mr1911351wrw.55.1679324838997;
        Mon, 20 Mar 2023 08:07:18 -0700 (PDT)
Received: from sgarzare-redhat (host-82-57-51-170.retail.telecomitalia.it. [82.57.51.170])
        by smtp.gmail.com with ESMTPSA id k2-20020a5d6e82000000b002c55b0e6ef1sm9243349wrz.4.2023.03.20.08.07.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Mar 2023 08:07:18 -0700 (PDT)
Date:   Mon, 20 Mar 2023 16:07:15 +0100
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
Subject: Re: [RFC PATCH v1 2/3] virtio/vsock: add WARN() for invalid state of
 socket
Message-ID: <20230320150715.twapgesp2gj6egua@sgarzare-redhat>
References: <e141e6f1-00ae-232c-b840-b146bdb10e99@sberdevices.ru>
 <da93402d-920e-c248-a5a1-baf24b70ebee@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <da93402d-920e-c248-a5a1-baf24b70ebee@sberdevices.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 19, 2023 at 09:52:19PM +0300, Arseniy Krasnov wrote:
>This prints WARN() and returns from stream dequeue callback when socket's
>queue is empty, but 'rx_bytes' still non-zero.
>
>Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>---
> net/vmw_vsock/virtio_transport_common.c | 7 +++++++
> 1 file changed, 7 insertions(+)
>
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index 3c75986e16c2..c35b03adad8d 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -388,6 +388,13 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
> 	u32 free_space;
>
> 	spin_lock_bh(&vvs->rx_lock);
>+
>+	if (skb_queue_empty(&vvs->rx_queue) && vvs->rx_bytes) {
>+		WARN(1, "No skbuffs with non-zero 'rx_bytes'\n");

I would use WARN_ONCE, since we can't recover so we will flood the log.

And you can put the condition in the first argument, I mean something
like this:
         if (WARN_ONCE(skb_queue_empty(&vvs->rx_queue) && vvs->rx_bytes,
                       "rx_queue is empty, but rx_bytes is non-zero\n")) {

Thanks,
Stefano

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

