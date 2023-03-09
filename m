Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DA016B2AC8
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 17:32:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbjCIQb7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 11:31:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230420AbjCIQbg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 11:31:36 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1EB9F2F8A
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 08:22:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678378918;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LEHbZXmqj5JG1Cxdlx+rAzJmqeOLu7jI6Qgs9itxkdM=;
        b=gIhLyJ48YQhOwjcWFcKItvomdvJalU9V/NEpo3jcUj/vej1H3asTsJunOWMqYb/Lm876rk
        dUHyaJBUQ36+yMo2WGs78iU/I09ORjbynkKfBIJi1gjGQtmuYMbOKlHu0Qa9cljNWuhxJ2
        DmcikqnM6TuBg+VUJ0Y2BCSqMUNQcaM=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-235-jXbo3OwbPS-pPeSu_7Igjg-1; Thu, 09 Mar 2023 11:21:57 -0500
X-MC-Unique: jXbo3OwbPS-pPeSu_7Igjg-1
Received: by mail-qt1-f199.google.com with SMTP id p7-20020ac84607000000b003b9b6101f65so1329206qtn.11
        for <netdev@vger.kernel.org>; Thu, 09 Mar 2023 08:21:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678378916;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LEHbZXmqj5JG1Cxdlx+rAzJmqeOLu7jI6Qgs9itxkdM=;
        b=19Rqkq2srEt74sxuFf0ILPUvj80nyMGA7LjvpGEPAAHDRdimB/4UUBqt28pl+bHwwU
         bgtKEtv3DFomJ90IpqAUEHQPzgjwKt2IzhR4TCnDTiNOcamX+WxakZxOpj9RgWY8PB0m
         o1RmoR2nxwm9qynDt6eUIncmrad+kbCaiElNHM7wqSEfr8V/PsDw7nCYP4Y9QIweBr9t
         5WFH5dfPrhL7UEk9stb+1N8dRaPY/Mn2pIwt9zrZj6szsO/dsgN8m8QlGbaQJmLIwkzS
         JrVFbecXGdB+hHN1YdXs5oCenxSfpcrRTODM6xV8DGWMyHv7GNVgX98eEXfxNbKhD0hj
         Ev0g==
X-Gm-Message-State: AO0yUKXNLYKGplD/BwLl/tawAh1kXM1saycjcYegLO/tY7RzySzhVBXT
        6Bb9RxkkcpcjuZVHukXqArJaMli2tVJTS/hVhW2C50d8dQaahbwAZwTLQvHjWc9wvBlOj4VOxKU
        QUw+QRl8AKkBTtOWv
X-Received: by 2002:a05:622a:1a1c:b0:3b8:6788:bf25 with SMTP id f28-20020a05622a1a1c00b003b86788bf25mr37444154qtb.23.1678378916661;
        Thu, 09 Mar 2023 08:21:56 -0800 (PST)
X-Google-Smtp-Source: AK7set+GI92GzioBeNCbqnB3nXBd7JnBKOAfAg1RXELqlvwy47gh802YuCBcQAaesacewK2BJ1ThFw==
X-Received: by 2002:a05:622a:1a1c:b0:3b8:6788:bf25 with SMTP id f28-20020a05622a1a1c00b003b86788bf25mr37444121qtb.23.1678378916373;
        Thu, 09 Mar 2023 08:21:56 -0800 (PST)
Received: from sgarzare-redhat (host-82-57-51-170.retail.telecomitalia.it. [82.57.51.170])
        by smtp.gmail.com with ESMTPSA id t197-20020a3746ce000000b007417e60f621sm13896467qka.126.2023.03.09.08.21.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 08:21:55 -0800 (PST)
Date:   Thu, 9 Mar 2023 17:21:50 +0100
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
Subject: Re: [RFC PATCH v3 0/4] several updates to virtio/vsock
Message-ID: <20230309162150.qqrlqmqghi5muucx@sgarzare-redhat>
References: <0abeec42-a11d-3a51-453b-6acf76604f2e@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <0abeec42-a11d-3a51-453b-6acf76604f2e@sberdevices.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 09, 2023 at 01:10:36PM +0300, Arseniy Krasnov wrote:
>Hello,
>
>this patchset evolved from previous v2 version (see link below). It does
>several updates to virtio/vsock:
>1) Changes 'virtio_transport_inc/dec_rx_pkt()' interface. Now instead of
>   using skbuff state ('head' and 'data' pointers) to update 'fwd_cnt'
>   and 'rx_bytes', integer value is passed as an input argument. This
>   makes code more simple, because in this case we don't need to udpate
>   skbuff state before calling 'virtio_transport_inc/dec_rx_pkt()'. In
>   more common words - we don't need to change skbuff state to update
>   'rx_bytes' and 'fwd_cnt' correctly.
>2) For SOCK_STREAM, when copying data to user fails, current skbuff is
>   not dropped. Next read attempt will use same skbuff and last offset.
>   Instead of 'skb_dequeue()', 'skb_peek()' + '__skb_unlink()' are used.
>   This behaviour was implemented before skbuff support.
>3) For SOCK_SEQPACKET it removes unneeded 'skb_pull()' call, because for
>   this type of socket each skbuff is used only once: after removing it
>   from socket's queue, it will be freed anyway.
>
>Test for 2) also added:
>Test tries to 'recv()' data to NULL buffer, then does 'recv()' with valid
>buffer. For SOCK_STREAM second 'recv()' must return data, because skbuff
>must not be dropped, but for SOCK_SEQPACKET skbuff will be dropped by
>kernel, and 'recv()' will return EAGAIN.
>
>Link to v1 on lore:
>https://lore.kernel.org/netdev/c2d3e204-89d9-88e9-8a15-3fe027e56b4b@sberdevices.ru/
>
>Link to v2 on lore:
>https://lore.kernel.org/netdev/a7ab414b-5e41-c7b6-250b-e8401f335859@sberdevices.ru/
>
>Change log:
>
>v1 -> v2:
> - For SOCK_SEQPACKET call 'skb_pull()' also in case of copy failure or
>   dropping skbuff (when we just waiting message end).
> - Handle copy failure for SOCK_STREAM in the same manner (plus free
>   current skbuff).
> - Replace bug repdroducer with new test in vsock_test.c
>
>v2 -> v3:
> - Replace patch which removes 'skb->len' subtraction from function
>   'virtio_transport_dec_rx_pkt()' with patch which updates functions
>   'virtio_transport_inc/dec_rx_pkt()' by passing integer argument
>   instead of skbuff pointer.
> - Replace patch which drops skbuff when copying to user fails with
>   patch which changes this behaviour by keeping skbuff in queue until
>   it has no data.
> - Add patch for SOCK_SEQPACKET which removes redundant 'skb_pull()'
>   call on read.
> - I remove "Fixes" tag from all patches, because all of them now change
>   code logic, not only fix something.

Yes, but they solve the problem, so we should use the tag (I think at
least in patch 1 and 3).

We usually use the tag when we are fixing a problem introduced by a
previous change. So we need to backport the patch to the stable branches
as well, and we need the tag to figure out which branches have the patch
or not.

Thanks,
Stefano

>
>Arseniy Krasnov (4):
>  virtio/vsock: don't use skbuff state to account credit
>  virtio/vsock: remove redundant 'skb_pull()' call
>  virtio/vsock: don't drop skbuff on copy failure
>  test/vsock: copy to user failure test
>
> net/vmw_vsock/virtio_transport_common.c |  29 +++---
> tools/testing/vsock/vsock_test.c        | 118 ++++++++++++++++++++++++
> 2 files changed, 131 insertions(+), 16 deletions(-)
>
>-- 
>2.25.1
>

