Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11AD16C4E3C
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 15:44:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231864AbjCVOoE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 10:44:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231751AbjCVOnU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 10:43:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C722C664C9
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 07:41:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679496082;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HLKDxFolV4+rR00GX3j1Ecw4i/HFp0PPyVxu2w/0V7w=;
        b=f/NCqzh4dEh1Nub6LblWTUBdq7uP3LP9eUx/HprCkqfgANWA9dxxGu7dxHUbvUpzTo1ueG
        QTA8APOB7u/AY0zF0QCgGAutBXut37npzaeAigTdv+Oz0pSyQnWu2oG/eQLuYiFV/d5bZ/
        OYiJbnqh/x2jifYAfoATEoQP9/RzOTs=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-320-6OXr9EbFP3mqoPQWoj6jxQ-1; Wed, 22 Mar 2023 10:41:21 -0400
X-MC-Unique: 6OXr9EbFP3mqoPQWoj6jxQ-1
Received: by mail-qt1-f199.google.com with SMTP id v7-20020a05622a188700b003e0e27bbc2eso6071387qtc.8
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 07:41:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679496080;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HLKDxFolV4+rR00GX3j1Ecw4i/HFp0PPyVxu2w/0V7w=;
        b=KSR57rsqbbseeVuACQawk4gGn6uQS3Qe0aiO25SBeNtmT50rMyuegFQWUQsnxPeY/K
         H5W3rwqJHsCOCDAiZ66o/Qc/s5oxsRDNeUutHC8j1vtOblAHsEP16T5cz55f+64MXYw2
         QEJ/jLmtcfl0bNZRMtXlsyha5FJ3ZQPX3eG/GJ5BvZ+76EkXRkozHVWnBj3IsSF0jSDN
         Zd9KDEfsGoxUZnZV4U7yA1dEDPLJK+ls7yU+N7ADT3b3Fh4EyH4/dcPdVEhaO5O+OxgC
         PgBZdq7os7sBxuFVj/IP0/4ZZ2DAVvgedqD3y4aDCUilLAbGYahsMSIoKLcbPK3oatt9
         r4eA==
X-Gm-Message-State: AO0yUKW5dNYID3gpc0dmt2THA8pZpcq9Q6FT1SIMlYjRqsS2vI3tTQ2b
        1Qn8im8mrKmIn8IYIo70ehxT+iirpQWdUhTlTv1emzIJvEI0cxlW0FNmrBDIyTuy7ynDzdKXNB+
        J2N8MV033NB1yjEcn
X-Received: by 2002:a05:622a:408:b0:3e1:b06d:e9e0 with SMTP id n8-20020a05622a040800b003e1b06de9e0mr6228374qtx.56.1679496080663;
        Wed, 22 Mar 2023 07:41:20 -0700 (PDT)
X-Google-Smtp-Source: AK7set8/wgsKLj9GUGG1GRhMhqaCnjl30RufXTIdaJf4Ub159yWBZLYd3EzoSNVPdHZrQ/N36OqnqA==
X-Received: by 2002:a05:622a:408:b0:3e1:b06d:e9e0 with SMTP id n8-20020a05622a040800b003e1b06de9e0mr6228339qtx.56.1679496080406;
        Wed, 22 Mar 2023 07:41:20 -0700 (PDT)
Received: from sgarzare-redhat (host-82-57-51-170.retail.telecomitalia.it. [82.57.51.170])
        by smtp.gmail.com with ESMTPSA id q21-20020ac87355000000b003e387a2fbdfsm2158689qtp.0.2023.03.22.07.41.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 07:41:19 -0700 (PDT)
Date:   Wed, 22 Mar 2023 15:41:15 +0100
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
Subject: Re: [RFC PATCH v4] virtio/vsock: allocate multiple skbuffs on tx
Message-ID: <20230322144115.sz3icgbnhjgae2fj@sgarzare-redhat>
References: <0e0c1421-7cdc-2582-b120-cad6f42824bb@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <0e0c1421-7cdc-2582-b120-cad6f42824bb@sberdevices.ru>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 21, 2023 at 06:03:14PM +0300, Arseniy Krasnov wrote:
>This adds small optimization for tx path: instead of allocating single
>skbuff on every call to transport, allocate multiple skbuff's until
>credit space allows, thus trying to send as much as possible data without
>return to af_vsock.c.
>
>Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>---
> Link to v1:
> https://lore.kernel.org/netdev/2c52aa26-8181-d37a-bccd-a86bd3cbc6e1@sberdevices.ru/
> Link to v2:
> https://lore.kernel.org/netdev/ea5725eb-6cb5-cf15-2938-34e335a442fa@sberdevices.ru/
> Link to v3:
> https://lore.kernel.org/netdev/f33ef593-982e-2b3f-0986-6d537a3aaf08@sberdevices.ru/
>
> Changelog:
> v1 -> v2:
> - If sent something, return number of bytes sent (even in
>   case of error). Return error only if failed to sent first
>   skbuff.
>
> v2 -> v3:
> - Handle case when transport callback returns unexpected value which
>   is not equal to 'skb->len'. Break loop.
> - Don't check for zero value of 'rest_len' before calling
>   'virtio_transport_put_credit()'. Decided to add this check directly
>   to 'virtio_transport_put_credit()' in separate patch.
>
> v3 -> v4:
> - Use WARN_ONCE() to handle case when transport callback returns
>   unexpected value.
> - Remove useless 'ret = -EFAULT;' assignment for case above.
>
> net/vmw_vsock/virtio_transport_common.c | 59 +++++++++++++++++++------
> 1 file changed, 45 insertions(+), 14 deletions(-)
>
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index 6564192e7f20..a300f25749ea 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -196,7 +196,8 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
> 	const struct virtio_transport *t_ops;
> 	struct virtio_vsock_sock *vvs;
> 	u32 pkt_len = info->pkt_len;
>-	struct sk_buff *skb;
>+	u32 rest_len;
>+	int ret;
>
> 	info->type = virtio_transport_get_type(sk_vsock(vsk));
>
>@@ -216,10 +217,6 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
>
> 	vvs = vsk->trans;
>
>-	/* we can send less than pkt_len bytes */
>-	if (pkt_len > VIRTIO_VSOCK_MAX_PKT_BUF_SIZE)
>-		pkt_len = VIRTIO_VSOCK_MAX_PKT_BUF_SIZE;
>-
> 	/* virtio_transport_get_credit might return less than pkt_len credit */
> 	pkt_len = virtio_transport_get_credit(vvs, pkt_len);
>
>@@ -227,17 +224,51 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
> 	if (pkt_len == 0 && info->op == VIRTIO_VSOCK_OP_RW)
> 		return pkt_len;
>
>-	skb = virtio_transport_alloc_skb(info, pkt_len,
>-					 src_cid, src_port,
>-					 dst_cid, dst_port);
>-	if (!skb) {
>-		virtio_transport_put_credit(vvs, pkt_len);
>-		return -ENOMEM;
>-	}
>+	ret = 0;

nit: this initialization seems superfluous since `ret` is
overwritten later ...

>+	rest_len = pkt_len;
>+
>+	do {
>+		struct sk_buff *skb;
>+		size_t skb_len;
>+
>+		skb_len = min_t(u32, VIRTIO_VSOCK_MAX_PKT_BUF_SIZE, rest_len);
>+
>+		skb = virtio_transport_alloc_skb(info, skb_len,
>+						 src_cid, src_port,
>+						 dst_cid, dst_port);
>+		if (!skb) {
>+			ret = -ENOMEM;
>+			break;
>+		}
>
>-	virtio_transport_inc_tx_pkt(vvs, skb);
>+		virtio_transport_inc_tx_pkt(vvs, skb);
>
>-	return t_ops->send_pkt(skb);
>+		ret = t_ops->send_pkt(skb);

... here.

>+

nit: we can remove this extra line

>+		if (ret < 0)
>+			break;
>+
>+		/* Both virtio and vhost 'send_pkt()' returns 'skb_len',
>+		 * but for reliability use 'ret' instead of 'skb_len'.
>+		 * Also if partial send happens (e.g. 'ret' != 'skb_len')
>+		 * somehow, we break this loop, but account such returned
>+		 * value in 'virtio_transport_put_credit()'.
>+		 */
>+		rest_len -= ret;
>+
>+		if (WARN_ONCE(ret != skb_len,
>+			      "'send_pkt()' returns %i, but %zu expected\n",
>+			      ret, skb_len))
>+			break;
>+	} while (rest_len);
>+
>+	virtio_transport_put_credit(vvs, rest_len);
>+
>+	/* Return number of bytes, if any data has been sent. */
>+	if (rest_len != pkt_len)
>+		ret = pkt_len - rest_len;
>+
>+	return ret;
> }
>
> static bool virtio_transport_inc_rx_pkt(struct virtio_vsock_sock *vvs,
>-- 2.25.1
>

The patch LGTM:

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

Anyway, feel free to include in the same series or as separate patch
also the changes to avoid useless lock in virtio_transport_put_credit()
and virtio_transport_get_credit().

I would include it in this series, because before these changes, we
used to call virtio_transport_put_credit() only in the error path,
while now we always call it, even when rest_len is 0.

Thanks,
Stefano

