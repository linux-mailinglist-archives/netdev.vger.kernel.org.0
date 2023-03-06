Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B01EB6ABF22
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 13:08:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbjCFMIj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 07:08:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjCFMIh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 07:08:37 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B120921A32
        for <netdev@vger.kernel.org>; Mon,  6 Mar 2023 04:07:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678104468;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=I0ekj7n7BGA/ETtY6sbgYM92CAukII9oGd0VLpZBNPM=;
        b=FzYp/LtsXs6r6XOKfVzSSFzL7/oz/iUxuhparwb5rf4SrQZ8O7bsLAtoGnE8DfjocqEymb
        zz/IkI/bzgpGPUL9fNmRY6QMFFNuZFPe3S1Z2ULpIDv060lVVYuYoW73JGui+RCaYvMWwC
        nJXGSJplL1ZAIwrFolPbHCfx8iwVmR8=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-490-qZEL9nENMlWklnHhap8i8A-1; Mon, 06 Mar 2023 07:07:47 -0500
X-MC-Unique: qZEL9nENMlWklnHhap8i8A-1
Received: by mail-qk1-f198.google.com with SMTP id dm13-20020a05620a1d4d00b00742a22c4239so5269169qkb.1
        for <netdev@vger.kernel.org>; Mon, 06 Mar 2023 04:07:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678104467;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I0ekj7n7BGA/ETtY6sbgYM92CAukII9oGd0VLpZBNPM=;
        b=cH/7vSeiQ2buLzbZZ794vvyagLuXTCW1BCWmm/fniFzKaWVyGOZfjDUODkFz2j1sLp
         MIAOtIen3r1RQgUkdpnAO7H9fzZXvzczQc5jNNeKagp5WHcQaqPIXzdHlz5ayuaUCOEV
         Dl2josXg8i0l0eqVRrTIhL6LSsvr3Nbe4SDsbvW99LsWp9pp0RJMyKiqerx2rQ4Hvfcl
         YQZLpHJywfdQWcfOZKJlLge3qDhnoSlI40QAD2IBTbnxiZ8+zwqD1CgtKH8AOvJnDxV7
         i/JBj9bG2yStrhsTctT1dNhAEsKTvle8aggUm/nH5GxUUEO0njwL5vRqN4TDGCTVRs9t
         Tpgw==
X-Gm-Message-State: AO0yUKWr1lVDIbjvCtNfPk86RNk4Y+y0lchKmDfBvMUWMardNTvaquS+
        XWqtjGgRwAZXWgwHD2MgPABgLxKUS2K1EyK+iSh++NDBe/mqKJQuJNnyeVFM3UpqtnAIlfLbWCH
        dD0EmJ4AEWcqG8ygm
X-Received: by 2002:ac8:5846:0:b0:3b8:5f26:e81f with SMTP id h6-20020ac85846000000b003b85f26e81fmr17766936qth.26.1678104467253;
        Mon, 06 Mar 2023 04:07:47 -0800 (PST)
X-Google-Smtp-Source: AK7set+V96PPHCzW88GO7gnogT8Tq/LXjyFpkqulWQDOc7ELP578FLhsQX2W1rCp9GrjRWDk+JnlEg==
X-Received: by 2002:ac8:5846:0:b0:3b8:5f26:e81f with SMTP id h6-20020ac85846000000b003b85f26e81fmr17766898qth.26.1678104466945;
        Mon, 06 Mar 2023 04:07:46 -0800 (PST)
Received: from sgarzare-redhat (host-82-57-51-170.retail.telecomitalia.it. [82.57.51.170])
        by smtp.gmail.com with ESMTPSA id 5-20020ac85605000000b003b0766cd169sm7496344qtr.2.2023.03.06.04.07.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Mar 2023 04:07:46 -0800 (PST)
Date:   Mon, 6 Mar 2023 13:07:42 +0100
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
Subject: Re: [RFC PATCH v2 3/4] virtio/vsock: free skb on data copy failure
Message-ID: <20230306120742.v6ss4w22ku7pe45a@sgarzare-redhat>
References: <a7ab414b-5e41-c7b6-250b-e8401f335859@sberdevices.ru>
 <ef98aad4-f86d-fe60-9a35-792363a78a68@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <ef98aad4-f86d-fe60-9a35-792363a78a68@sberdevices.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 05, 2023 at 11:08:38PM +0300, Arseniy Krasnov wrote:
>This fixes two things in case when 'memcpy_to_msg()' fails:
>1) Update credit parameters of the socket, like this skbuff was
>   copied to user successfully. This is needed because when skbuff was
>   received it's length was used to update 'rx_bytes', thus when we drop
>   skbuff here, we must account rest of it's data in 'rx_bytes'.
>2) Free skbuff which was removed from socket's queue.
>
>Fixes: 71dc9ec9ac7d ("virtio/vsock: replace virtio_vsock_pkt with sk_buff")
>Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>---
> net/vmw_vsock/virtio_transport_common.c | 6 +++++-
> 1 file changed, 5 insertions(+), 1 deletion(-)
>
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index 30b0539990ba..ffb1af4f2b52 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -379,8 +379,12 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
> 		spin_unlock_bh(&vvs->rx_lock);
>
> 		err = memcpy_to_msg(msg, skb->data, bytes);
>-		if (err)
>+		if (err) {
>+			skb_pull(skb, skb->len);
>+			virtio_transport_dec_rx_pkt(vvs, skb);
>+			consume_skb(skb);

I'm not sure it's the right thing to do, if we fail to copy the content
into the user's buffer, I think we should queue it again.

In fact, before commit 71dc9ec9ac7d ("virtio/vsock: replace
virtio_vsock_pkt with sk_buff"), we used to remove the packet from the
rx_queue, only if memcpy_to_msg() was successful.

Maybe it is better to do as we did before and use skb_peek() at the
beginning of the loop and __skb_unlink() when skb->len == 0.

Thanks,
Stefano

> 			goto out;
>+		}
>
> 		spin_lock_bh(&vvs->rx_lock);
>
>-- 
>2.25.1
>

