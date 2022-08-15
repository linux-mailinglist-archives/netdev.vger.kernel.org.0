Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D812594DA8
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 03:34:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233832AbiHPAmQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 20:42:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349731AbiHPAle (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 20:41:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 123EBABF36
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 13:39:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660595958;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1Ju82h2Seq9g+C5kY2YGtQXKyGbfylxp+FKU0h7Nrc0=;
        b=GTQ0v/bxIl3Qa8mdS7qm4KmLETlmfv9vxUZrWUcwV8URlygNN0Pv0eawJ+8Hvpr7Xw24kt
        Df1v5qM2LACBgv7xCeDZ557JPbZrFA/hHGtjh0mxuxGxy8tn+M5iWyAjY6IhGmIA4GMVSB
        6iOz+y1wr88ImDgvFmhUeJn2eXHOtRY=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-282-gP96_FwkN1ak3xfIpsn35g-1; Mon, 15 Aug 2022 16:39:17 -0400
X-MC-Unique: gP96_FwkN1ak3xfIpsn35g-1
Received: by mail-ed1-f72.google.com with SMTP id y14-20020a056402440e00b0044301c7ccd9so5352403eda.19
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 13:39:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=1Ju82h2Seq9g+C5kY2YGtQXKyGbfylxp+FKU0h7Nrc0=;
        b=AJjXKqCh/t5EuDeqVZkrnmsOJd8xPAGj0r8Ja0PW3vNTwtDgC7jUElQhd892K1moPQ
         QBc+8Dlqx3vGfnpTHOHZaEqGRJOywkOES5WJp/fcgtFmFsQKYqxZCMHYEk/8BfrvApeh
         qsOGSmB+IW1SjL02khFfxNR0q0N3lmAHZBiBsrB9qhxpULJswkSAA2MT2WjnJ1JqL+wG
         OL6Xj69ZVGoo0xpnAFkj2JPrZKMZPA6a5Ztg4t8MFUobad12SxCG8j1qrd04WS56Exq+
         wviYmgJUDbWb+Hxzx0xpHJseVIEhQ3/WRLKSIfPs380wYrnw0Ngg88zM473+/qqIDVcy
         n3nA==
X-Gm-Message-State: ACgBeo0ii2fddTSS0Ks+rh9xV+ReAiNiUmDRAde1t0Y2gNkihW7a2x3f
        uMdvQwLYMLlTimux3zHensPC8ugKowQ72/9oi0A5CNL+St59vlYfz6ctZs3i6cNtSD4kB+dupXW
        3mooalck28zgVe5n3
X-Received: by 2002:aa7:dc10:0:b0:440:b446:c0cc with SMTP id b16-20020aa7dc10000000b00440b446c0ccmr15993699edu.34.1660595956283;
        Mon, 15 Aug 2022 13:39:16 -0700 (PDT)
X-Google-Smtp-Source: AA6agR45Fuir9EoNpEYCDZwTaOCu5+yshYNzN86x9kBq/JCQrW+g/Q8mhFtNHXDl7fhQaOWy+suhNw==
X-Received: by 2002:aa7:dc10:0:b0:440:b446:c0cc with SMTP id b16-20020aa7dc10000000b00440b446c0ccmr15993678edu.34.1660595956040;
        Mon, 15 Aug 2022 13:39:16 -0700 (PDT)
Received: from redhat.com ([2.55.43.215])
        by smtp.gmail.com with ESMTPSA id m17-20020a1709066d1100b007305b8aa36bsm4417030ejr.157.2022.08.15.13.39.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Aug 2022 13:39:15 -0700 (PDT)
Date:   Mon, 15 Aug 2022 16:39:08 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Bobby Eshleman <bobby.eshleman@gmail.com>
Cc:     Bobby Eshleman <bobbyeshleman@gmail.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org
Subject: Re: [PATCH 0/6] virtio/vsock: introduce dgrams, sk_buff, and qdisc
Message-ID: <20220815162524-mutt-send-email-mst@kernel.org>
References: <cover.1660362668.git.bobby.eshleman@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1660362668.git.bobby.eshleman@bytedance.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 15, 2022 at 10:56:03AM -0700, Bobby Eshleman wrote:
> Hey everybody,
> 
> This series introduces datagrams, packet scheduling, and sk_buff usage
> to virtio vsock.
> 
> The usage of struct sk_buff benefits users by a) preparing vsock to use
> other related systems that require sk_buff, such as sockmap and qdisc,
> b) supporting basic congestion control via sock_alloc_send_skb, and c)
> reducing copying when delivering packets to TAP.
> 
> The socket layer no longer forces errors to be -ENOMEM, as typically
> userspace expects -EAGAIN when the sk_sndbuf threshold is reached and
> messages are being sent with option MSG_DONTWAIT.
> 
> The datagram work is based off previous patches by Jiang Wang[1].
> 
> The introduction of datagrams creates a transport layer fairness issue
> where datagrams may freely starve streams of queue access. This happens
> because, unlike streams, datagrams lack the transactions necessary for
> calculating credits and throttling.
> 
> Previous proposals introduce changes to the spec to add an additional
> virtqueue pair for datagrams[1]. Although this solution works, using
> Linux's qdisc for packet scheduling leverages already existing systems,
> avoids the need to change the virtio specification, and gives additional
> capabilities. The usage of SFQ or fq_codel, for example, may solve the
> transport layer starvation problem. It is easy to imagine other use
> cases as well. For example, services of varying importance may be
> assigned different priorities, and qdisc will apply appropriate
> priority-based scheduling. By default, the system default pfifo qdisc is
> used. The qdisc may be bypassed and legacy queuing is resumed by simply
> setting the virtio-vsock%d network device to state DOWN. This technique
> still allows vsock to work with zero-configuration.
> 
> In summary, this series introduces these major changes to vsock:
> 
> - virtio vsock supports datagrams
> - virtio vsock uses struct sk_buff instead of virtio_vsock_pkt
>   - Because virtio vsock uses sk_buff, it also uses sock_alloc_send_skb,
>     which applies the throttling threshold sk_sndbuf.
> - The vsock socket layer supports returning errors other than -ENOMEM.
>   - This is used to return -EAGAIN when the sk_sndbuf threshold is
>     reached.
> - virtio vsock uses a net_device, through which qdisc may be used.
>  - qdisc allows scheduling policies to be applied to vsock flows.
>   - Some qdiscs, like SFQ, may allow vsock to avoid transport layer congestion. That is,
>     it may avoid datagrams from flooding out stream flows. The benefit
>     to this is that additional virtqueues are not needed for datagrams.
>   - The net_device and qdisc is bypassed by simply setting the
>     net_device state to DOWN.
> 
> [1]: https://lore.kernel.org/all/20210914055440.3121004-1-jiang.wang@bytedance.com/

Given this affects the driver/device interface I'd like to
ask you to please copy virtio-dev mailing list on these patches.
Subscriber only I'm afraid you will need to subscribe :(

> Bobby Eshleman (5):
>   vsock: replace virtio_vsock_pkt with sk_buff
>   vsock: return errors other than -ENOMEM to socket
>   vsock: add netdev to vhost/virtio vsock
>   virtio/vsock: add VIRTIO_VSOCK_F_DGRAM feature bit
>   virtio/vsock: add support for dgram
> 
> Jiang Wang (1):
>   vsock_test: add tests for vsock dgram
> 
>  drivers/vhost/vsock.c                   | 238 ++++----
>  include/linux/virtio_vsock.h            |  73 ++-
>  include/net/af_vsock.h                  |   2 +
>  include/uapi/linux/virtio_vsock.h       |   2 +
>  net/vmw_vsock/af_vsock.c                |  30 +-
>  net/vmw_vsock/hyperv_transport.c        |   2 +-
>  net/vmw_vsock/virtio_transport.c        | 237 +++++---
>  net/vmw_vsock/virtio_transport_common.c | 771 ++++++++++++++++--------
>  net/vmw_vsock/vmci_transport.c          |   9 +-
>  net/vmw_vsock/vsock_loopback.c          |  51 +-
>  tools/testing/vsock/util.c              | 105 ++++
>  tools/testing/vsock/util.h              |   4 +
>  tools/testing/vsock/vsock_test.c        | 195 ++++++
>  13 files changed, 1176 insertions(+), 543 deletions(-)
> 
> -- 
> 2.35.1

