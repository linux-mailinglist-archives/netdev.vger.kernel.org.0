Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C7D6699711
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 15:19:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229706AbjBPOTt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 09:19:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjBPOTs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 09:19:48 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A015210A9D
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 06:19:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676557143;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Pchzyi+iGSx4x4FUy9UsNRB/fTEcGnGSHaYZsjr+hLc=;
        b=XoPKYFhoHfI6N26kj0JoQveaX/HNnEFqoM9JpCATC93jVFp6LsGQZ9NTMW2RY6JRauZuRu
        QBBiiSQOPrsxuC3Ph4ud9D6aCwPQicIJAsTwN8b0d3GR4NmB8ARjhQH1LJcWgaXp9QPThu
        pdA9SRpCiu9lFZXWxJhHbtA7w8kUoRM=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-642-JiX7UgjeOMSeR5W7wkpP1A-1; Thu, 16 Feb 2023 09:19:02 -0500
X-MC-Unique: JiX7UgjeOMSeR5W7wkpP1A-1
Received: by mail-qv1-f72.google.com with SMTP id i17-20020a0cfcd1000000b0056ee5b123bbso1148306qvq.7
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 06:19:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Pchzyi+iGSx4x4FUy9UsNRB/fTEcGnGSHaYZsjr+hLc=;
        b=5LKUXnNJFmbRzMsam+pwH3TxbTo6bM3804oty3lsre+jIPiglFmNLpJKFC7pEYgAS4
         t8WfjW8aEaLf72IGFyKvbe8QP1LLM5NiFa5uqx6g6ocpKOvCV0g3dxxuZUVCgsmwUhln
         ueiliZIlxHqXh11MD+EtbwGBRb8TvniI7nCZnvEugF4GBmhsMTNHO2cIu5nKu0sTxD7H
         /uPdzRXm5+KGzHwJyNPHKsFTADcAyf4hkYA9VBLuEc0TZszt4pC7E06E0SfF3S2GFha6
         tQtqMLPqxrL2Uc+zQdNN/gBRr8LqYhHPMypHPDx2qLOWJxIAe3Qlh2aor30tyl5GhWCe
         a6Jg==
X-Gm-Message-State: AO0yUKVsoGg8HCxBGkChkU2R+bP8Ndj1Nw+Fl0Xz8PGOZ8D2zzQ+bLVw
        CJ4taSDm9qR0S0MeX1gxjVVT9aQNkcyWVvsXnXdIH3KRasIJAQQCpYfwprR8rj5IEvj5hHq3gRP
        JvhuOhdKYo39jNjURzQcfrA==
X-Received: by 2002:a05:622a:1492:b0:3b8:52b6:a313 with SMTP id t18-20020a05622a149200b003b852b6a313mr11672810qtx.30.1676557142026;
        Thu, 16 Feb 2023 06:19:02 -0800 (PST)
X-Google-Smtp-Source: AK7set+fxS4JhBoepOcXeUJoLRmfP/igXjolczTeDHypWOV4T3CC6+zz+5nMobryi+/8kbpvaTg/2g==
X-Received: by 2002:a05:622a:1492:b0:3b8:52b6:a313 with SMTP id t18-20020a05622a149200b003b852b6a313mr11672776qtx.30.1676557141742;
        Thu, 16 Feb 2023 06:19:01 -0800 (PST)
Received: from sgarzare-redhat (host-82-57-51-167.retail.telecomitalia.it. [82.57.51.167])
        by smtp.gmail.com with ESMTPSA id 205-20020a370ad6000000b0073b76f9409csm1278267qkk.14.2023.02.16.06.18.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Feb 2023 06:19:01 -0800 (PST)
Date:   Thu, 16 Feb 2023 15:18:56 +0100
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
Subject: Re: [RFC PATCH v1 05/12] vsock/virtio: non-linear skb support
Message-ID: <20230216141856.fnczv3ui6d3lpujy@sgarzare-redhat>
References: <0e7c6fc4-b4a6-a27b-36e9-359597bba2b5@sberdevices.ru>
 <b3060caf-df19-f1df-6d27-4e58f894c417@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <b3060caf-df19-f1df-6d27-4e58f894c417@sberdevices.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 06, 2023 at 06:58:24AM +0000, Arseniy Krasnov wrote:
>Use pages of non-linear skb as buffers in virtio tx queue.
>
>Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>---
> net/vmw_vsock/virtio_transport.c | 31 +++++++++++++++++++++++++------
> 1 file changed, 25 insertions(+), 6 deletions(-)
>
>diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
>index 28b5a8e8e094..b8a7d6dc9f46 100644
>--- a/net/vmw_vsock/virtio_transport.c
>+++ b/net/vmw_vsock/virtio_transport.c
>@@ -100,7 +100,8 @@ virtio_transport_send_pkt_work(struct work_struct *work)
> 	vq = vsock->vqs[VSOCK_VQ_TX];
>
> 	for (;;) {
>-		struct scatterlist hdr, buf, *sgs[2];
>+		struct scatterlist *sgs[MAX_SKB_FRAGS + 1];
>+		struct scatterlist bufs[MAX_SKB_FRAGS + 1];

+ 1 is for the header, right?
I'd add a comment just to be clear ;-)

> 		int ret, in_sg = 0, out_sg = 0;
> 		struct sk_buff *skb;
> 		bool reply;
>@@ -111,12 +112,30 @@ virtio_transport_send_pkt_work(struct work_struct *work)
>
> 		virtio_transport_deliver_tap_pkt(skb);
> 		reply = virtio_vsock_skb_reply(skb);
>+		sg_init_one(&bufs[0], virtio_vsock_hdr(skb), sizeof(*virtio_vsock_hdr(skb)));
>+		sgs[out_sg++] = &bufs[0];
>+
>+		if (skb_is_nonlinear(skb)) {
>+			int i;
>+
>+			for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
>+				struct page *data_page = skb_shinfo(skb)->frags[i].bv_page;
>+
>+				/* We will use 'page_to_virt()' for userspace page here,
>+				 * because virtio layer will call 'virt_to_phys()' later
>+				 * to fill buffer descriptor. We don't touch memory at
>+				 * "virtual" address of this page.
>+				 */

IIUC data_page is a user page, so since we are exposing it to the host,
I think we should pin it.

Is data_page always a user page, or can it be a kernel page when skb is 
nonlinear?

Thanks,
Stefano

>+				sg_init_one(&bufs[i + 1],
>+					    page_to_virt(data_page), PAGE_SIZE);
>+				sgs[out_sg++] = &bufs[i + 1];
>+			}
>+		} else {
>+			if (skb->len > 0) {
>+				sg_init_one(&bufs[1], skb->data, skb->len);
>+				sgs[out_sg++] = &bufs[1];
>+			}
>
>-		sg_init_one(&hdr, virtio_vsock_hdr(skb), sizeof(*virtio_vsock_hdr(skb)));
>-		sgs[out_sg++] = &hdr;
>-		if (skb->len > 0) {
>-			sg_init_one(&buf, skb->data, skb->len);
>-			sgs[out_sg++] = &buf;
> 		}
>
> 		ret = virtqueue_add_sgs(vq, sgs, out_sg, in_sg, skb, GFP_KERNEL);
>-- 
>2.25.1

