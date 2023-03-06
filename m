Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 850206ABF30
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 13:10:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230268AbjCFMKP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 07:10:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230073AbjCFMKJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 07:10:09 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE0B2298E8
        for <netdev@vger.kernel.org>; Mon,  6 Mar 2023 04:09:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678104543;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TIQWpkWpesX3O84a09lrsGwpESW6OyZggcHe4WwruKk=;
        b=EIZjiOmh91if1hjOge59zMe7sQhrDTWGV0ObcFkRqtpezoyJy81tskTJ1UVrmXYg9rqexr
        9k4LyqgsqkJpjxqvLTX7IwFdmmsFrcUxvLpX8l7vFp+WgOlDW4CQbtQfHZWdoo3l3Sq2ts
        b3S+KyZG/58A9lDR7k/mp/8Qq+bLN40=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-497-a0L8gOIIN3-GP1NdpvM0HA-1; Mon, 06 Mar 2023 07:09:01 -0500
X-MC-Unique: a0L8gOIIN3-GP1NdpvM0HA-1
Received: by mail-wm1-f69.google.com with SMTP id f14-20020a7bcc0e000000b003dd41ad974bso3663924wmh.3
        for <netdev@vger.kernel.org>; Mon, 06 Mar 2023 04:09:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678104540;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TIQWpkWpesX3O84a09lrsGwpESW6OyZggcHe4WwruKk=;
        b=bKchCtXfT70+L4hAkMNspb1IRfW9Bp/qrWsCeQoYloNBpMSrmqaM9cVs/XZ7gDGKGz
         N2Xt/Z+ac6f+sWxTD6UjHGxmiS93uQ1taanZf9fgciFhmBIreFXNerZUK1ChcrRkNXzp
         WyDvX6+r01OciJCfcPAFRcXhuTp/zjpQLFfW5edbn4TTdRiE9BCi+ll7iMhpSdWqLkGG
         nLOX9TlufY148frm+shGIuHZpQonnYFCMWhEzKrzHbTFr3Mdl+OymuQHfgN0DIkMoDl7
         DMi/lKR5t5RVmrsOHqXOBeRfL1p2XV/b1meZ/ZqpKAnlusP5vNNfbY0dHh9DvtF2vdlL
         RYkA==
X-Gm-Message-State: AO0yUKV5ttLrnjNMUZNd9TLhRVFyapW1Pshk3U8zhJ3ieBvAVTjXTS1J
        I7Aa49NhqJUw+nF/RxFVLmd2u8tCCrLAUcCGbHhd+S/gU9Opy2puzF8dZH/j3Df5iMcq4tKj5BM
        lUpP51reh4UaxjKpE
X-Received: by 2002:a05:6000:10cc:b0:2c7:420:5d52 with SMTP id b12-20020a05600010cc00b002c704205d52mr6551208wrx.62.1678104540678;
        Mon, 06 Mar 2023 04:09:00 -0800 (PST)
X-Google-Smtp-Source: AK7set9mVWEN2OAq/N1LHfsMLygbhdAAUyaT4XAYy96wMKTIdzRA5IDlfgb0poIN+cI9N1MTK/FGlw==
X-Received: by 2002:a05:6000:10cc:b0:2c7:420:5d52 with SMTP id b12-20020a05600010cc00b002c704205d52mr6551188wrx.62.1678104540406;
        Mon, 06 Mar 2023 04:09:00 -0800 (PST)
Received: from sgarzare-redhat (host-82-57-51-170.retail.telecomitalia.it. [82.57.51.170])
        by smtp.gmail.com with ESMTPSA id c18-20020a5d4cd2000000b002c551f7d452sm9957713wrt.98.2023.03.06.04.08.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Mar 2023 04:08:59 -0800 (PST)
Date:   Mon, 6 Mar 2023 13:08:57 +0100
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
Subject: Re: [RFC PATCH v2 2/4] virtio/vsock: remove all data from sk_buff
Message-ID: <20230306120857.6flftb3fftmsceyl@sgarzare-redhat>
References: <a7ab414b-5e41-c7b6-250b-e8401f335859@sberdevices.ru>
 <dfadea17-a91e-105f-c213-a73f9731c8bd@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <dfadea17-a91e-105f-c213-a73f9731c8bd@sberdevices.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 05, 2023 at 11:07:37PM +0300, Arseniy Krasnov wrote:
>In case of SOCK_SEQPACKET all sk_buffs are used once - after read some
>data from it, it will be removed, so user will never read rest of the
>data. Thus we need to update credit parameters of the socket like whole
>sk_buff is read - so call 'skb_pull()' for the whole buffer.
>
>Fixes: 71dc9ec9ac7d ("virtio/vsock: replace virtio_vsock_pkt with sk_buff")
>Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>---
> net/vmw_vsock/virtio_transport_common.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)

Maybe we could avoid this patch if we directly use pkt_len as I
suggested in the previous patch.

Thanks,
Stefano

>
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index 2e2a773df5c1..30b0539990ba 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -466,7 +466,6 @@ static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
> 					dequeued_len = err;
> 				} else {
> 					user_buf_len -= bytes_to_copy;
>-					skb_pull(skb, bytes_to_copy);
> 				}
>
> 				spin_lock_bh(&vvs->rx_lock);
>@@ -484,6 +483,7 @@ static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
> 				msg->msg_flags |= MSG_EOR;
> 		}
>
>+		skb_pull(skb, skb->len);
> 		virtio_transport_dec_rx_pkt(vvs, skb);
> 		kfree_skb(skb);
> 	}
>-- 
>2.25.1
>

