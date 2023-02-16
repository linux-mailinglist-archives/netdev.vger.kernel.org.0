Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 060A46996CA
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 15:12:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbjBPOML (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 09:12:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbjBPOMK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 09:12:10 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD16B4AFE7
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 06:10:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676556566;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SIv/znYayUURQPypPRVti8rBugentUV5lP2jcUhz0tw=;
        b=jC6Hh2dIiKap3VE4qAvCHuaHD1cQC/XksDA1irezzKbFvVd1fxiZ4XgMcjGa2zpcW9/wDX
        m8zq7zQh1uInefOpEALBwLjH54PlTYaFF6XDMehWEMp4fqoIcNzmSAG2xs/eplgylEAK/a
        LtBtCdsfukB/u2cLDQDEGK8asUfn0Nc=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-541-FfffJRfsOg-rBCmbkZlYDg-1; Thu, 16 Feb 2023 09:09:25 -0500
X-MC-Unique: FfffJRfsOg-rBCmbkZlYDg-1
Received: by mail-qk1-f200.google.com with SMTP id a6-20020a05620a102600b00729952b4c73so1235110qkk.6
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 06:09:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SIv/znYayUURQPypPRVti8rBugentUV5lP2jcUhz0tw=;
        b=zKWhC46Jhe3I0u/X+7NPppmI1+zlQE+DZZaf2RQeO90rSZazcLOVeff70yVXQzx/rz
         bcddkxoiY3UUuBXOUlkHZrudpLcvinUWzGXYWqf/+WVb8E9Og9Y95PDtBNNTwXIzP9hY
         KKK09i26BLCh4OhNEPQ8cztDRdkdSctIvijHHw9/m6y6ICCQrASetS4NPDN8wteSWQ6W
         sXnAfXMOiuBZRKjO5TbFp+FRFdzu9ShfaTgc3Pg2DlYeQtBsTvOfNYZ2jK04HSdb5Ezy
         eRwyN722hIp+838kBjaPEWmzeaIff4NoUMN1taLXwjEUwqs4KN7d+zvR9iOuSCYLOeeh
         zCXw==
X-Gm-Message-State: AO0yUKWs4pz85bXff1fmz5HrFAUcdUlczNQAdVfjYN/yMgzhxzWErXrO
        x8YtTzjq6GsHVFFMJUzLeLVIQIGuqL0wMc1cEBEPRbH5Jyy3woJ6nJTg1NE1Gm70T6hc2wlahl7
        oST3+yoBgZuzRcRwv
X-Received: by 2002:ad4:5c66:0:b0:56b:f308:caab with SMTP id i6-20020ad45c66000000b0056bf308caabmr12608756qvh.13.1676556564486;
        Thu, 16 Feb 2023 06:09:24 -0800 (PST)
X-Google-Smtp-Source: AK7set/6LTFM2e6dQZOBByDiucEi9Lpba61BrCfPHXHquEYhMRipHLkb91i0Fk5WcPqTp3fViwTP9w==
X-Received: by 2002:ad4:5c66:0:b0:56b:f308:caab with SMTP id i6-20020ad45c66000000b0056bf308caabmr12608717qvh.13.1676556564160;
        Thu, 16 Feb 2023 06:09:24 -0800 (PST)
Received: from sgarzare-redhat (host-82-57-51-167.retail.telecomitalia.it. [82.57.51.167])
        by smtp.gmail.com with ESMTPSA id x4-20020ac84d44000000b003b82a07c4d6sm1236152qtv.84.2023.02.16.06.09.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Feb 2023 06:09:23 -0800 (PST)
Date:   Thu, 16 Feb 2023 15:09:17 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: Re: [RFC PATCH v1 04/12] vhost/vsock: non-linear skb handling support
Message-ID: <20230216140917.jpcmfrwl5gpdzdzi@sgarzare-redhat>
References: <0e7c6fc4-b4a6-a27b-36e9-359597bba2b5@sberdevices.ru>
 <c1570fa9-1673-73cf-5545-995e9aac1dbb@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <c1570fa9-1673-73cf-5545-995e9aac1dbb@sberdevices.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 06, 2023 at 06:57:16AM +0000, Arseniy Krasnov wrote:
>This adds copying to guest's virtio buffers from non-linear skbs. Such
>skbs are created by protocol layer when MSG_ZEROCOPY flags is used.
>
>Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>---
> drivers/vhost/vsock.c        | 56 ++++++++++++++++++++++++++++++++----
> include/linux/virtio_vsock.h | 12 ++++++++
> 2 files changed, 63 insertions(+), 5 deletions(-)
>
>diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
>index 1f3b89c885cc..60b9cafa3e31 100644
>--- a/drivers/vhost/vsock.c
>+++ b/drivers/vhost/vsock.c
>@@ -86,6 +86,44 @@ static struct vhost_vsock *vhost_vsock_get(u32 guest_cid)
> 	return NULL;
> }
>
>+static int vhost_transport_copy_nonlinear_skb(struct sk_buff *skb,
>+					      struct iov_iter *iov_iter,
>+					      size_t len)
>+{
>+	size_t rest_len = len;
>+
>+	while (rest_len && virtio_vsock_skb_has_frags(skb)) {
>+		struct bio_vec *curr_vec;
>+		size_t curr_vec_end;
>+		size_t to_copy;
>+		int curr_frag;
>+		int curr_offs;
>+
>+		curr_frag = VIRTIO_VSOCK_SKB_CB(skb)->curr_frag;
>+		curr_offs = VIRTIO_VSOCK_SKB_CB(skb)->frag_off;
>+		curr_vec = &skb_shinfo(skb)->frags[curr_frag];
>+
>+		curr_vec_end = curr_vec->bv_offset + curr_vec->bv_len;
>+		to_copy = min(rest_len, (size_t)(curr_vec_end - curr_offs));
>+
>+		if (copy_page_to_iter(curr_vec->bv_page, curr_offs,
>+				      to_copy, iov_iter) != to_copy)
>+			return -1;
>+
>+		rest_len -= to_copy;
>+		VIRTIO_VSOCK_SKB_CB(skb)->frag_off += to_copy;
>+
>+		if (VIRTIO_VSOCK_SKB_CB(skb)->frag_off == (curr_vec_end)) {
>+			VIRTIO_VSOCK_SKB_CB(skb)->curr_frag++;
>+			VIRTIO_VSOCK_SKB_CB(skb)->frag_off = 0;
>+		}
>+	}

Can it happen that we exit this loop and rest_len is not 0?

In this case, is it correct to decrement data_len by len?

Thanks,
Stefano

>+
>+	skb->data_len -= len;
>+
>+	return 0;
>+}
>+
> static void
> vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
> 			    struct vhost_virtqueue *vq)
>@@ -197,11 +235,19 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
> 			break;
> 		}
>
>-		nbytes = copy_to_iter(skb->data, payload_len, &iov_iter);
>-		if (nbytes != payload_len) {
>-			kfree_skb(skb);
>-			vq_err(vq, "Faulted on copying pkt buf\n");
>-			break;
>+		if (skb_is_nonlinear(skb)) {
>+			if (vhost_transport_copy_nonlinear_skb(skb, &iov_iter,
>+							       payload_len)) {
>+				vq_err(vq, "Faulted on copying pkt buf from page\n");
>+				break;
>+			}
>+		} else {
>+			nbytes = copy_to_iter(skb->data, payload_len, &iov_iter);
>+			if (nbytes != payload_len) {
>+				kfree_skb(skb);
>+				vq_err(vq, "Faulted on copying pkt buf\n");
>+				break;
>+			}
> 		}
>
> 		/* Deliver to monitoring devices all packets that we
>diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
>index 3f9c16611306..e7efdb78ce6e 100644
>--- a/include/linux/virtio_vsock.h
>+++ b/include/linux/virtio_vsock.h
>@@ -12,6 +12,10 @@
> struct virtio_vsock_skb_cb {
> 	bool reply;
> 	bool tap_delivered;
>+	/* Current fragment in 'frags' of skb. */
>+	u32 curr_frag;
>+	/* Offset from 0 in current fragment. */
>+	u32 frag_off;
> };
>
> #define VIRTIO_VSOCK_SKB_CB(skb) ((struct virtio_vsock_skb_cb *)((skb)->cb))
>@@ -46,6 +50,14 @@ static inline void virtio_vsock_skb_clear_tap_delivered(struct sk_buff *skb)
> 	VIRTIO_VSOCK_SKB_CB(skb)->tap_delivered = false;
> }
>
>+static inline bool virtio_vsock_skb_has_frags(struct sk_buff *skb)
>+{
>+	if (!skb_is_nonlinear(skb))
>+		return false;
>+
>+	return VIRTIO_VSOCK_SKB_CB(skb)->curr_frag != skb_shinfo(skb)->nr_frags;
>+}
>+
> static inline void virtio_vsock_skb_rx_put(struct sk_buff *skb)
> {
> 	u32 len;
>-- 
>2.25.1

