Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C20A76C2CB4
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 09:41:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbjCUIll (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 04:41:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbjCUIlj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 04:41:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E570746142
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 01:40:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679388010;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3ue5AFGaReKj/xnbY98VYj9OaV+WVOdpiOY5id9iIGc=;
        b=Dhbno0w/uBzR8s2EiaHZEcjlQsBw2xdUMzXroMYDPXcNn4yHllSx7VHKd6wm+/NcwAERXc
        vuVxJptjk+F1G9fOaHstNwyEtyAdg/XJNDC3NbY8D8NVFBK1frlWbsn+Udh/CeM6yDBfxq
        XOSWR8wgaSMCulxvRBNMRBv54SxoN/w=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-524-yBLPuSLWMlWVOmPnnwdvVA-1; Tue, 21 Mar 2023 04:40:08 -0400
X-MC-Unique: yBLPuSLWMlWVOmPnnwdvVA-1
Received: by mail-qv1-f69.google.com with SMTP id q1-20020ad44341000000b005a676b725a2so7270619qvs.18
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 01:40:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679388008;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3ue5AFGaReKj/xnbY98VYj9OaV+WVOdpiOY5id9iIGc=;
        b=4G6sZ38+ZQk9wiElcLTBSgTBSS7y0SXUESDNJSWsZPVv3HRNCg7DZAu9h6zlnbXdnQ
         DAzCrFX8d4nJgzHa1QkkHwsB2S4YsVv7ACII/TBT1USn4Nm6u9zX1b/eogkdekr46nHd
         CVX4CnCwLEi2WGLohqifLgaMEGDd9NH8dGEmbz3cJW8y6ZQpl1IDltpb+3sK9hkog/az
         3WguuhT8XVRpXnuxlJjVEo9wrcXOv4GNJr77hUZ1CG1Uc/YZIXJVKs6McUeOWkFni86w
         BhGNmo4Np6NfCr5pCw9NRGFAz2vCkGviDDNKVKRMjK5yhyyImxrrQjhLarMBkI9AonDT
         Wr3g==
X-Gm-Message-State: AO0yUKVBqxLM9eb43OKXPk/21VKp2mtKrIvQy2ySgWWjdQbMxCbX1lzm
        ibBql7+lySpvCcNX/AHF4aTT1LfgdmcUH7/gZfk7eRMwypSputv9kHDP5Vyq/uOcM5WUeeQ5KCp
        Djd/06+NHNk4yDJGr
X-Received: by 2002:ac8:7f82:0:b0:3b8:6ae9:b10d with SMTP id z2-20020ac87f82000000b003b86ae9b10dmr2446539qtj.2.1679388008126;
        Tue, 21 Mar 2023 01:40:08 -0700 (PDT)
X-Google-Smtp-Source: AK7set8QDeZYCc7+c7IEn1uW0Jnl2bYqoqO+r68HTwXQ2vd7mj/LnUa34SC9AX/rzKtTfj6hGS72jQ==
X-Received: by 2002:ac8:7f82:0:b0:3b8:6ae9:b10d with SMTP id z2-20020ac87f82000000b003b86ae9b10dmr2446521qtj.2.1679388007827;
        Tue, 21 Mar 2023 01:40:07 -0700 (PDT)
Received: from sgarzare-redhat (host-82-57-51-170.retail.telecomitalia.it. [82.57.51.170])
        by smtp.gmail.com with ESMTPSA id h12-20020ac8548c000000b003d58d0297e5sm8076455qtq.3.2023.03.21.01.40.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 01:40:07 -0700 (PDT)
Date:   Tue, 21 Mar 2023 09:40:02 +0100
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
Subject: Re: [RFC PATCH v3] virtio/vsock: allocate multiple skbuffs on tx
Message-ID: <20230321084002.5anjcr3ikw3ynbse@sgarzare-redhat>
References: <f33ef593-982e-2b3f-0986-6d537a3aaf08@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <f33ef593-982e-2b3f-0986-6d537a3aaf08@sberdevices.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 21, 2023 at 12:31:48AM +0300, Arseniy Krasnov wrote:
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
> net/vmw_vsock/virtio_transport_common.c | 59 +++++++++++++++++++------
> 1 file changed, 45 insertions(+), 14 deletions(-)
>
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index 6564192e7f20..e0b2c6ecbe22 100644
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
>+
>+		virtio_transport_inc_tx_pkt(vvs, skb);
>
>-	virtio_transport_inc_tx_pkt(vvs, skb);
>+		ret = t_ops->send_pkt(skb);
>
>-	return t_ops->send_pkt(skb);
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
>+		if (ret != skb_len) {
>+			ret = -EFAULT;

Okay, but `ret` will be overwritten by the check we have before the
return ...

>+			break;
>+		}
>+	} while (rest_len);
>+
>+	virtio_transport_put_credit(vvs, rest_len);
>+
>+	/* Return number of bytes, if any data has been sent. */
>+	if (rest_len != pkt_len)
>+		ret = pkt_len - rest_len;

... here.

Since we don't expect this condition for now, perhaps we can avoid
setting ret with -EFAULT, but we can add a WARN_ONCE (interrupting the
loop as you did here).

This way we return the partial length as we did before.

Thanks,
Stefano

>+
>+	return ret;
> }
>
> static bool virtio_transport_inc_rx_pkt(struct virtio_vsock_sock *vvs,
>-- 
>2.25.1
>

