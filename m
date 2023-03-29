Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7EDB6CD2C7
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 09:17:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229909AbjC2HRP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 03:17:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbjC2HRO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 03:17:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 626F1BA
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 00:16:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680074185;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FgNqIpETnEwtXon7v3S9aQlVl6/D6olezWGAgum/M94=;
        b=UmgAySgWXbE/22GqjFjAGXcg951QWg0fDA+NE3CPihHInvQ4PEnTvLCzXaaZboJfPR/Zr8
        bsGh0CsRcEb41Jpu/du7ZBMgAoEQyO3HsBUYUWNUF+qyUZN+gvPP3LRFI0Z4EGQEkEUIab
        grIBiANYQV+cOO1zDApKMvu6A6/5Wd0=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-50-Lhjovu6QNLe1-aUlTIgVvQ-1; Wed, 29 Mar 2023 03:16:23 -0400
X-MC-Unique: Lhjovu6QNLe1-aUlTIgVvQ-1
Received: by mail-ed1-f70.google.com with SMTP id i42-20020a0564020f2a00b004fd23c238beso20929065eda.0
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 00:16:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680074183;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FgNqIpETnEwtXon7v3S9aQlVl6/D6olezWGAgum/M94=;
        b=B6AS786s1CljY6N4lUPdCbUlxheFd/uZIrsr15KLrB6FNO8SfWjUX9t64kRi5KK778
         761K9F7fS01uw5upM/67E07JdjMwEWiWRPxD+ktUASAzduqCavwJ5BF9ky0pRvekvs0C
         abnm4RZpChEuMNQtLpRBy1z7oTbsgMRU+XuO4jEjfw8mGWPuYcogWUdsyqix3esckQC+
         hArQ7lZr4FvcGk5LibIDCtyjbf+MwUkQxDqv60JElr51qjGIkZc1B4eaMgUzSzgeH7Cj
         oeABCCWvgLOp3LKLFLma2RTE8czqxT1aIvUl3ELs6GzquCGWygrHIZUr1GKm6OoHBrJp
         evpw==
X-Gm-Message-State: AAQBX9eAyAqBMOIDwvGIIK3VOonjNZzEO40HuY/CKoykHJ2WfTKNnI9H
        9sJjkfjcBnyg5Mcp9BE7sSEClabOuweAA8PRnhm1yZGihk+AHldVitTEgwSSokhxP6HJzy1bb/+
        guOogQBZ0m9s2z1zj
X-Received: by 2002:a17:906:33d3:b0:908:7fed:f0f with SMTP id w19-20020a17090633d300b009087fed0f0fmr18015429eja.42.1680074182859;
        Wed, 29 Mar 2023 00:16:22 -0700 (PDT)
X-Google-Smtp-Source: AKy350bXrrArCxeBniSit8qX/4ISh60zS47mWrvlzo8Jgs3svz8qYB58JPbBHkk1wTagNwUK5LAUEQ==
X-Received: by 2002:a17:906:33d3:b0:908:7fed:f0f with SMTP id w19-20020a17090633d300b009087fed0f0fmr18015416eja.42.1680074182527;
        Wed, 29 Mar 2023 00:16:22 -0700 (PDT)
Received: from sgarzare-redhat (host-82-57-51-130.retail.telecomitalia.it. [82.57.51.130])
        by smtp.gmail.com with ESMTPSA id sc36-20020a1709078a2400b0093e39b921c8sm6666528ejc.164.2023.03.29.00.16.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Mar 2023 00:16:22 -0700 (PDT)
Date:   Wed, 29 Mar 2023 09:16:19 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Bobby Eshleman <bobby.eshleman@bytedance.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH net v2] virtio/vsock: fix leaks due to missing skb owner
Message-ID: <teatarzyqlkgbgxjezbm56ilpsbcq3f6nwvwwfi7f6z7agbgoh@jxwm3mgot2w4>
References: <20230327-vsock-fix-leak-v2-1-f6619972dee0@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230327-vsock-fix-leak-v2-1-f6619972dee0@bytedance.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 28, 2023 at 04:29:09PM +0000, Bobby Eshleman wrote:
>This patch sets the skb owner in the recv and send path for virtio.
>
>For the send path, this solves the leak caused when
>virtio_transport_purge_skbs() finds skb->sk is always NULL and therefore
>never matches it with the current socket. Setting the owner upon
>allocation fixes this.
>
>For the recv path, this ensures correctness of accounting and also
>correct transfer of ownership in vsock_loopback (when skbs are sent from
>one socket and received by another).
>
>Fixes: 71dc9ec9ac7d ("virtio/vsock: replace virtio_vsock_pkt with sk_buff")
>Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
>Reported-by: Cong Wang <xiyou.wangcong@gmail.com>
>Link: https://lore.kernel.org/all/ZCCbATwov4U+GBUv@pop-os.localdomain/
>---
>Changes in v2:
>- virtio/vsock: add skb_set_owner_r to recv_pkt()
>- Link to v1: https://lore.kernel.org/r/20230327-vsock-fix-leak-v1-1-3fede367105f@bytedance.com
>---
> net/vmw_vsock/virtio_transport_common.c | 5 +++++
> 1 file changed, 5 insertions(+)
>
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index 957cdc01c8e8..900e5dca05f5 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -94,6 +94,9 @@ virtio_transport_alloc_skb(struct virtio_vsock_pkt_info *info,
> 					 info->op,
> 					 info->flags);
>
>+	if (info->vsk)
>+		skb_set_owner_w(skb, sk_vsock(info->vsk));
>+
> 	return skb;
>
> out:
>@@ -1294,6 +1297,8 @@ void virtio_transport_recv_pkt(struct virtio_transport *t,
> 		goto free_pkt;
> 	}
>
>+	skb_set_owner_r(skb, sk);
>+
> 	vsk = vsock_sk(sk);
>
> 	lock_sock(sk);

Can you explain why we are using skb_set_owner_w/skb_set_owner_r?

I'm a little concerned about 2 things:
- skb_set_owner_r() documentation says: "Stream and sequenced
   protocols can't normally use this as they need to fit buffers in
   and play with them."
- they increment sk_wmem_alloc and sk_rmem_alloc that we never used
   (IIRC)

For the long run, I think we should manage memory better, and using
socket accounting makes sense to me, but since we now have a different
system (which we have been carrying around since the introduction of
vsock), I think this change is a bit risky, especially as a fix.

So my suggestion is to use skb_set_owner_sk_safe() for now, unless I
missed something about why to use skb_set_owner_w/skb_set_owner_r.

Thanks,
Stefano

