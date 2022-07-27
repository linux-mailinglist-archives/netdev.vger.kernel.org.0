Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2708582655
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 14:24:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232949AbiG0MYa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 08:24:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232923AbiG0MY1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 08:24:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EBC8B4B0FC
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 05:24:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658924666;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dapYisiCBXlgZkwMi+Hyveg1G9f8dLox6yKCT12ZMlw=;
        b=Os9ibwKHZCbV2+07ovnFkq/xVnf2YPtkViszeCBPjsjHVAy1TpnUTxZo6doZR9hEeHGpk4
        seSBsffdsuVwkbLIrNUfNURoOIR8kxVk7p0ubnuKAnuZD87G/rOVGu1ORb5fOu3AHy4aF2
        bebSaPaArp2zEqgFM1b8WCV+qtFJER4=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-454-wUkmN5xJOzCnLwQT6aZDUw-1; Wed, 27 Jul 2022 08:24:24 -0400
X-MC-Unique: wUkmN5xJOzCnLwQT6aZDUw-1
Received: by mail-wr1-f69.google.com with SMTP id c7-20020adfc6c7000000b0021db3d6961bso2798725wrh.23
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 05:24:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dapYisiCBXlgZkwMi+Hyveg1G9f8dLox6yKCT12ZMlw=;
        b=4+Qjm5+Ch9zyzakEiXIraKEO1WTMFsJfaZY2u5RVuyB1UkB2g4gLx9sWA5oWiNwd9h
         wz1S41oD3nPzdatDzk/0DN5+/XqSykg1Do0skBOtU4oS6brDjaSOvc7TkImwDX19avW9
         47WftFXJG+DzfMyNElkxRw3mowIc9cH90OTsBSp854wS9d/7PIfHBK7T25dplx4PLBJ4
         ijZRm0TlGl8y4EsuXzbGtaFFtiCfSmrKgXWHtA4JdRI0dZqmF85gbdQ4Y1v61mLlHhg4
         m9nDT2O2qAcXvwa1KA+D/DE8xgAPM8os3Va97vcAsn5YfdFrioSOmnarZvAeWse76uIQ
         BX1g==
X-Gm-Message-State: AJIora9WOdublceXD9JC+WYnc1V9n5W6j8/g3/iFgu2k4IbTINcMjNSo
        EHLFy8NiutkIuhO+oATLvaz/uwmsoZfya6thXSQPstwebfX6Yi+NpgFqLtKZ8lWJg4ujWtlHd2D
        bOI++YbKLxa1SrAN0
X-Received: by 2002:a05:6000:1541:b0:21d:b298:96be with SMTP id 1-20020a056000154100b0021db29896bemr13644416wry.206.1658924663470;
        Wed, 27 Jul 2022 05:24:23 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vC2MGRjFi3qSHZ2fm0BkjEDxRi6ABSiXhvcdsFTw4lBpGNZw6+Ua7w1AgH+IiVMbwoDfqM2g==
X-Received: by 2002:a05:6000:1541:b0:21d:b298:96be with SMTP id 1-20020a056000154100b0021db29896bemr13644403wry.206.1658924663274;
        Wed, 27 Jul 2022 05:24:23 -0700 (PDT)
Received: from sgarzare-redhat (host-79-46-200-178.retail.telecomitalia.it. [79.46.200.178])
        by smtp.gmail.com with ESMTPSA id bg26-20020a05600c3c9a00b003a3279b9037sm2308365wmb.16.2022.07.27.05.24.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jul 2022 05:24:22 -0700 (PDT)
Date:   Wed, 27 Jul 2022 14:24:17 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "kys@microsoft.com" <kys@microsoft.com>,
        "haiyangz@microsoft.com" <haiyangz@microsoft.com>,
        "sthemmin@microsoft.com" <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: Re: [RFC PATCH v2 5/9] vsock: SO_RCVLOWAT transport set callback
Message-ID: <20220727122417.jvdfjnuybk3mwxkq@sgarzare-redhat>
References: <19e25833-5f5c-f9b9-ac0f-1945ea17638d@sberdevices.ru>
 <8baa2e3a-af6b-c0fe-9bfb-7cf89506474a@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <8baa2e3a-af6b-c0fe-9bfb-7cf89506474a@sberdevices.ru>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 25, 2022 at 08:05:28AM +0000, Arseniy Krasnov wrote:
>This adds transport specific callback for SO_RCVLOWAT, because in some
>transports it may be difficult to know current available number of bytes
>ready to read. Thus, when SO_RCVLOWAT is set, transport may reject it.
>
>Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>---
> include/net/af_vsock.h   |  1 +
> net/vmw_vsock/af_vsock.c | 19 +++++++++++++++++++
> 2 files changed, 20 insertions(+)
>
>diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
>index f742e50207fb..eae5874bae35 100644
>--- a/include/net/af_vsock.h
>+++ b/include/net/af_vsock.h
>@@ -134,6 +134,7 @@ struct vsock_transport {
> 	u64 (*stream_rcvhiwat)(struct vsock_sock *);
> 	bool (*stream_is_active)(struct vsock_sock *);
> 	bool (*stream_allow)(u32 cid, u32 port);
>+	int (*set_rcvlowat)(struct vsock_sock *, int);
>
> 	/* SEQ_PACKET. */
> 	ssize_t (*seqpacket_dequeue)(struct vsock_sock *vsk, struct msghdr *msg,
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index 63a13fa2686a..b7a286db4af1 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -2130,6 +2130,24 @@ vsock_connectible_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
> 	return err;
> }
>
>+static int vsock_set_rcvlowat(struct sock *sk, int val)
>+{
>+	const struct vsock_transport *transport;
>+	struct vsock_sock *vsk;
>+	int err = 0;
>+
>+	vsk = vsock_sk(sk);
>+	transport = vsk->transport;

`transport` can be NULL if the user call SO_RCVLOWAT before we assign 
it, so we should check it.

I think if the transport implements `set_rcvlowat`, maybe we should set 
there sk->sk_rcvlowat, so I would do something like that:

     if (transport && transport->set_rcvlowat)
         err = transport->set_rcvlowat(vsk, val);
     else
         WRITE_ONCE(sk->sk_rcvlowat, val ? : 1);

     return err;

In addition I think we should check that val does not exceed 
vsk->buffer_size, something similar of what tcp_set_rcvlowat() does.

Thanks,
Stefano

