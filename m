Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64A1A5AE3B1
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 11:01:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239344AbiIFJBR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 05:01:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238620AbiIFJBO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 05:01:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7E0B3CBD8
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 02:01:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662454867;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uEYw8dkEXgcUOX7V93X65x+uXJi/wlkI4CEWgXjX+U8=;
        b=f4WDrH2yCHdNf4gcYT4cyG1sO3xIORq+jNXNmuWeFra6DDVUVJL9QKPKKGSM+Nws1rkVd/
        DvgYKOzgNkeVFeReq6Dl6oqgTuGCK60KMweGNi92maVlkIB65eYRqiiiU8l+23kHLDj+HU
        rzj8oMvsbknp60BUxkl1A+TZmXKd1SY=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-347-TTmEbN-YNZ-jSq3TK0BRJQ-1; Tue, 06 Sep 2022 05:01:06 -0400
X-MC-Unique: TTmEbN-YNZ-jSq3TK0BRJQ-1
Received: by mail-qk1-f200.google.com with SMTP id x22-20020a05620a259600b006b552a69231so8510428qko.18
        for <netdev@vger.kernel.org>; Tue, 06 Sep 2022 02:01:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date;
        bh=uEYw8dkEXgcUOX7V93X65x+uXJi/wlkI4CEWgXjX+U8=;
        b=HwXNIR45MUHg4ZHXEeUSSC+CxMnMwvhepA1IHKGVmZxGb06dFNsdWIH//ghfQ814Ki
         QsIFfidoP27CkoyELDUSaDcduY80qRJZxoV9wLPFyzjVcDMThBIdr9fkXN6M0kqn6cGU
         cLKiaexXfstxsxfFK73Lou/xt+Hdwg33mU/Wu6VOmAFz6QAdKYvXWYct6IW6pc9Udgdu
         Yk0t/7EmQb2BgzVnhz1ZsinCRVrdZcOGUOMxwtpZ65EfC9JEcILD6TsCZ+eiDHloqaXw
         Mnbc194mZn5bu2ij73lhkV+Ixornh8yi/6VSflNfNv2Mv/AwBWnhSPou5r+u9Z9qqwyc
         rFIw==
X-Gm-Message-State: ACgBeo1mZYrxX5r5+KPz8msIz4eQjwmbmBYOC7boE8BCZhCvUMxCTDbk
        UhWu3c/IZP5k84JD/SRZJ5//bLVhGIsuwh34eIUMbx0K3Vpr+qHkvgUhWjMozL5F/RZP4V3vOHb
        RiGQ25dLylOduhM1B
X-Received: by 2002:a05:620a:4711:b0:6bb:7e1b:5f0b with SMTP id bs17-20020a05620a471100b006bb7e1b5f0bmr33657194qkb.127.1662454866185;
        Tue, 06 Sep 2022 02:01:06 -0700 (PDT)
X-Google-Smtp-Source: AA6agR54SeftazVhGuQR9Denza8esCRyPUSRNGJRsOYWXZ1aLyu1Zb25CEzZerEVP/BwXWQhYQ8KcQ==
X-Received: by 2002:a05:620a:4711:b0:6bb:7e1b:5f0b with SMTP id bs17-20020a05620a471100b006bb7e1b5f0bmr33657178qkb.127.1662454865958;
        Tue, 06 Sep 2022 02:01:05 -0700 (PDT)
Received: from sgarzare-redhat (host-87-11-6-69.retail.telecomitalia.it. [87.11.6.69])
        by smtp.gmail.com with ESMTPSA id z20-20020ac87cb4000000b0031f36cd1958sm8888786qtv.81.2022.09.06.02.01.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Sep 2022 02:01:04 -0700 (PDT)
Date:   Tue, 6 Sep 2022 11:00:48 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Bobby Eshleman <bobby.eshleman@gmail.com>,
        Bobby Eshleman <bobbyeshleman@gmail.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
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
Message-ID: <20220906090048.xdwdnxy3dvuos36x@sgarzare-redhat>
References: <cover.1660362668.git.bobby.eshleman@bytedance.com>
 <20220817025250-mutt-send-email-mst@kernel.org>
 <3abb1be9-b12c-e658-0391-8461e28f1b33@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3abb1be9-b12c-e658-0391-8461e28f1b33@redhat.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 18, 2022 at 12:28:48PM +0800, Jason Wang wrote:
>
>在 2022/8/17 14:54, Michael S. Tsirkin 写道:
>>On Mon, Aug 15, 2022 at 10:56:03AM -0700, Bobby Eshleman wrote:
>>>Hey everybody,
>>>
>>>This series introduces datagrams, packet scheduling, and sk_buff usage
>>>to virtio vsock.
>>>
>>>The usage of struct sk_buff benefits users by a) preparing vsock to use
>>>other related systems that require sk_buff, such as sockmap and qdisc,
>>>b) supporting basic congestion control via sock_alloc_send_skb, and c)
>>>reducing copying when delivering packets to TAP.
>>>
>>>The socket layer no longer forces errors to be -ENOMEM, as typically
>>>userspace expects -EAGAIN when the sk_sndbuf threshold is reached and
>>>messages are being sent with option MSG_DONTWAIT.
>>>
>>>The datagram work is based off previous patches by Jiang Wang[1].
>>>
>>>The introduction of datagrams creates a transport layer fairness issue
>>>where datagrams may freely starve streams of queue access. This happens
>>>because, unlike streams, datagrams lack the transactions necessary for
>>>calculating credits and throttling.
>>>
>>>Previous proposals introduce changes to the spec to add an additional
>>>virtqueue pair for datagrams[1]. Although this solution works, using
>>>Linux's qdisc for packet scheduling leverages already existing systems,
>>>avoids the need to change the virtio specification, and gives additional
>>>capabilities. The usage of SFQ or fq_codel, for example, may solve the
>>>transport layer starvation problem. It is easy to imagine other use
>>>cases as well. For example, services of varying importance may be
>>>assigned different priorities, and qdisc will apply appropriate
>>>priority-based scheduling. By default, the system default pfifo qdisc is
>>>used. The qdisc may be bypassed and legacy queuing is resumed by simply
>>>setting the virtio-vsock%d network device to state DOWN. This technique
>>>still allows vsock to work with zero-configuration.
>>The basic question to answer then is this: with a net device qdisc
>>etc in the picture, how is this different from virtio net then?
>>Why do you still want to use vsock?
>
>
>Or maybe it's time to revisit an old idea[1] to unify at least the 
>driver part (e.g using virtio-net driver for vsock then we can all 
>features that vsock is lacking now)?

Sorry for coming late to the discussion!

This would be great, though, last time I had looked at it, I had found 
it quite complicated. The main problem is trying to avoid all the 
net-specific stuff (MTU, ethernet header, HW offloading, etc.).

Maybe we could start thinking about this idea by adding a new transport 
to vsock (e.g. virtio-net-vsock) completely separate from what we have 
now.

Thanks,
Stefano

