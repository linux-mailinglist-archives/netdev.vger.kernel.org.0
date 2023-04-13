Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69C046E09DF
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 11:15:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230142AbjDMJPD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 05:15:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230007AbjDMJPB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 05:15:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 511AC9029
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 02:14:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681377250;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dyzRm431VL1Fbej5RMckdPouF+WGu3yZlZlqm5Jr8zA=;
        b=IhE6Tda2BOI3LdMTnN363f7tkbsV1eNbJPFqwokHjCo92cniRslskQ5i/QerEKXKlPZP/T
        1/fpXy2baCG9QibgnulypziuL888Bxt5y8dai5etyAFhlleiiZuodlTLpiyHk+Ka2FRGuL
        EboDpe8yx6sktFeDadNQBKKPc2DZkEo=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-211-2xSm7GmIP1eN_B_nl8fJzw-1; Thu, 13 Apr 2023 05:14:07 -0400
X-MC-Unique: 2xSm7GmIP1eN_B_nl8fJzw-1
Received: by mail-qk1-f200.google.com with SMTP id c128-20020ae9ed86000000b0074690a17414so7269960qkg.7
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 02:14:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681377247; x=1683969247;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dyzRm431VL1Fbej5RMckdPouF+WGu3yZlZlqm5Jr8zA=;
        b=RrWFSc69Ylo2jlPDShOK9HZbmdF2MNgb5jqU6BzoXCnMecchNxC4VqPb6H/fnXYL6U
         k6jHuMuE3yViUMotzUBZlHwsjXtOsTNtMylH90TC0EVgXzKLfyapo8b8+qL4D8lXJlNU
         L3LT8Jp95mofwPMaI0sAUXtAGYAVi9nQ8JmvQQkNPsI5+Tn56C2f4LhTZ8E0A4pGMk7Q
         PLFHkvZaPtKMaAcPcRBoJcWA7q0jt6BSOmxGiivY9b9zEuEzqvz3FFW+0Exz20+KBL1u
         rP9RXcIbev3Jt5+Vv8QaIJ9zXqo2+thK7xs8jj8e4g8RzTP5p2++tYZK6SqhIeObcex4
         GSSg==
X-Gm-Message-State: AAQBX9eZfwRgfnzfwc/qNP3WD/UmICkK/qQgwJzKE6iHA4vyIa4QoZ7l
        qVl+FKidT1rkWyV+UIglNAA8B9vmAfUDj8+DoDaXLOdcWuz0mCEzrOyQlU4aTdb81YBCLwhDjxA
        uRlT/GddCUBE3UzoJ
X-Received: by 2002:ac8:7e95:0:b0:3e3:8e55:1e64 with SMTP id w21-20020ac87e95000000b003e38e551e64mr2377954qtj.14.1681377247476;
        Thu, 13 Apr 2023 02:14:07 -0700 (PDT)
X-Google-Smtp-Source: AKy350YIU+TgyV60nszZOUUj8q3myAkq179cnjkKyv9e28PXemEbrxintxbe43QqEzW46gKSh3J/rw==
X-Received: by 2002:ac8:7e95:0:b0:3e3:8e55:1e64 with SMTP id w21-20020ac87e95000000b003e38e551e64mr2377935qtj.14.1681377247280;
        Thu, 13 Apr 2023 02:14:07 -0700 (PDT)
Received: from sgarzare-redhat (host-82-53-134-157.retail.telecomitalia.it. [82.53.134.157])
        by smtp.gmail.com with ESMTPSA id l22-20020ac81496000000b003e4c6b2cc35sm359795qtj.24.2023.04.13.02.14.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Apr 2023 02:14:06 -0700 (PDT)
Date:   Thu, 13 Apr 2023 11:14:01 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <avkrasnov@sberdevices.ru>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@sberdevices.ru,
        oxffffaa@gmail.com
Subject: Re: [RFC PATCH v1] vsock/loopback: don't disable irqs for queue
 access
Message-ID: <m6zafomiasxi7fdlejxqebvq5lkjwo3wvpkc7xa6tzfa7ywfy6@bswd76cx772g>
References: <b6dd26b3-97d7-ef8e-d8f8-a0e728fa2b02@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <b6dd26b3-97d7-ef8e-d8f8-a0e728fa2b02@sberdevices.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 09, 2023 at 10:17:51PM +0300, Arseniy Krasnov wrote:
>This replaces 'skb_queue_tail()' with 'virtio_vsock_skb_queue_tail()'.
>The first one uses 'spin_lock_irqsave()', second uses 'spin_lock_bh()'.
>There is no need to disable interrupts in the loopback transport as
>there is no access to the queue with skbs from interrupt context. Both
>virtio and vhost transports work in the same way.

Yep, this is a good point!

>
>Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>---
> net/vmw_vsock/vsock_loopback.c | 3 +--
> 1 file changed, 1 insertion(+), 2 deletions(-)

LGTM! (net-next material)

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

Thanks,
Stefano

>
>diff --git a/net/vmw_vsock/vsock_loopback.c b/net/vmw_vsock/vsock_loopback.c
>index e3afc0c866f5..5c6360df1f31 100644
>--- a/net/vmw_vsock/vsock_loopback.c
>+++ b/net/vmw_vsock/vsock_loopback.c
>@@ -31,8 +31,7 @@ static int vsock_loopback_send_pkt(struct sk_buff *skb)
> 	struct vsock_loopback *vsock = &the_vsock_loopback;
> 	int len = skb->len;
>
>-	skb_queue_tail(&vsock->pkt_queue, skb);
>-
>+	virtio_vsock_skb_queue_tail(&vsock->pkt_queue, skb);
> 	queue_work(vsock->workqueue, &vsock->pkt_work);
>
> 	return len;
>-- 
>2.25.1
>

