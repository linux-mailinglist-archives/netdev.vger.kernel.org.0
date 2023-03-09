Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AD196B2B04
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 17:41:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbjCIQlf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 11:41:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230112AbjCIQkz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 11:40:55 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD9DB10B1EA
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 08:29:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678379383;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qkGMBcAqnKS6JyN4vXTerExSnh7y8GSPNATG4aVOfrc=;
        b=Duwo8umPcihhbKZTUZvUgkiRkwEoIyjdLpTA2dDa6koagz5nlJ1gGc5gkrcMPcah5HppL2
        ASDcUOaQ3GB52e5dJhdqOQvYMTRLRwEZdTE3H7XyUIu2JG+v8BNIZ0JdizAmuvqqFmTW3G
        c1vprc/gAUKK+aI2S9Hsg0Qzscw+3hs=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-464-e_E0nXpMMje7nkMiDTuHWg-1; Thu, 09 Mar 2023 11:29:41 -0500
X-MC-Unique: e_E0nXpMMje7nkMiDTuHWg-1
Received: by mail-qv1-f71.google.com with SMTP id l13-20020ad44d0d000000b004c74bbb0affso1428326qvl.21
        for <netdev@vger.kernel.org>; Thu, 09 Mar 2023 08:29:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678379381;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qkGMBcAqnKS6JyN4vXTerExSnh7y8GSPNATG4aVOfrc=;
        b=QqqXpAr/I/+PCxfcDit6y6ggBhph4ndkOL+DoEheOW6fey8pV1/aYIk5AsuF+ID2XQ
         McbBCPvwKuPmzpOyEGmeBiPEOwBz5ENHqXksexoBSz9byOlDa1SBeYYNers71l2Nremk
         ksnqDbceaax+gHYx0xv8yMDRAnOhDXjoWXFtnpE+sPpLx6xY5Mwlwj3tsOk0nUZw6M2E
         BoxyRNC32vSWCmvf5gxnuCqQT/a3uL1OFMuR/RpIXZdVBAJ3fgwe8iv3z1m5ARP1yvZe
         5BPxAej5pRzX5oB+Jy7LhocHTRi9BC0svm40ozpiMP2LSWiLwuZK7QNnBn6mkTvagnn3
         dmaQ==
X-Gm-Message-State: AO0yUKWYyBsxrk/cxZ9WaQzMq9dqJQj2D4EWRV1j6pQbWz3KGvy4TRx1
        1FvSr0fdXP5yqlGiUQq0biZti5eo86axcAftd093rFUKd7FKC7e6wb1DK/55xbavKNWQ0WPGyLv
        dlxH+JkHykD7syYme
X-Received: by 2002:ac8:5c02:0:b0:3b8:525e:15ec with SMTP id i2-20020ac85c02000000b003b8525e15ecmr43003984qti.27.1678379381151;
        Thu, 09 Mar 2023 08:29:41 -0800 (PST)
X-Google-Smtp-Source: AK7set/wt8PRwAtM1Bf3zAU+80K15G/N3ODjmPX5KS1M+6kzBy453+fWsgrmcpFNeaN7ieLbWU2BRw==
X-Received: by 2002:ac8:5c02:0:b0:3b8:525e:15ec with SMTP id i2-20020ac85c02000000b003b8525e15ecmr43003941qti.27.1678379380798;
        Thu, 09 Mar 2023 08:29:40 -0800 (PST)
Received: from sgarzare-redhat (host-82-57-51-170.retail.telecomitalia.it. [82.57.51.170])
        by smtp.gmail.com with ESMTPSA id r13-20020a05622a034d00b0039cc0fbdb61sm14575595qtw.53.2023.03.09.08.29.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 08:29:40 -0800 (PST)
Date:   Thu, 9 Mar 2023 17:29:35 +0100
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
Subject: Re: [RFC PATCH v3 2/4] virtio/vsock: remove redundant 'skb_pull()'
 call
Message-ID: <20230309162935.c76hilqo3s22fysd@sgarzare-redhat>
References: <0abeec42-a11d-3a51-453b-6acf76604f2e@sberdevices.ru>
 <ea7a542b-8772-e204-6b2b-a60d89614f3b@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <ea7a542b-8772-e204-6b2b-a60d89614f3b@sberdevices.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 09, 2023 at 01:12:42PM +0300, Arseniy Krasnov wrote:

I would add:

Since we now no longer use `skb->len` to update credit, ...

>There is no sense to update skbuff state, because it is used only once
>after dequeue to copy data and then will be released.
>
>Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>---
> net/vmw_vsock/virtio_transport_common.c | 1 -
> 1 file changed, 1 deletion(-)

The patch LGTM!

Stefano

>
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index 618680fd9906..9a411475e201 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -465,7 +465,6 @@ static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
> 					dequeued_len = err;
> 				} else {
> 					user_buf_len -= bytes_to_copy;
>-					skb_pull(skb, bytes_to_copy);
> 				}
>
> 				spin_lock_bh(&vvs->rx_lock);
>-- 
>2.25.1
>

