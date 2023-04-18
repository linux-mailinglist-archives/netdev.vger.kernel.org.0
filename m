Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FF066E6092
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 14:03:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230120AbjDRMDH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 08:03:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230465AbjDRMAd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 08:00:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0364B1BE2
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 04:56:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681818961;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZXvHe+hqlmu93yWIU70NYfBDF1m9Fy56L1Ru9xyKRuE=;
        b=Zzdp8pqdWRKbya7QHWt1yYv2z7TTuf8uI/Qbq+tjimMmK+rwWElLw46fEnhnz6bvKFpOyU
        zc5nm1sVT8+L1/o0EKFD4JuwwCL1sAvGZnfth7AzqAjEqh1fl2LYGxKFjkyOzqbO8goFDT
        YdhY407EBpSmlO26cmsw2NB34KOFe7o=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-653-pEjSujsKM_iNqU4Kbvso9A-1; Tue, 18 Apr 2023 07:49:35 -0400
X-MC-Unique: pEjSujsKM_iNqU4Kbvso9A-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-3f16ef3bf06so7267385e9.3
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 04:49:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681818574; x=1684410574;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZXvHe+hqlmu93yWIU70NYfBDF1m9Fy56L1Ru9xyKRuE=;
        b=b3I+FPLv22vK5IvMmZFM20tJ1QvFNNVqFGPP4ZsBblT46rX85Y/RgW9rKCeT5Qu1Dd
         T2ywnFhfYShaypK8lTkKcHNme6+gB8Dlfs962xqaCCe9SVLm3c9Fv0LzfE/2DX8T6EVI
         EftwDWosvg1TnTjSZIzgmAlnLNgjpBJKCgU0QbtAshCyBx0C4l3pGzgN3OtaIn5V9w15
         gFe9kF2pQi3X7wYE3Jk+HAIUcHzwLFhhOZ2jHAgXlEcU7UXFGUDurC8Ap2Z07iNUb+YX
         8QaGLmJ8G0uxpWIxkPHwX/O3UgOq8YDA/hb1BXLgbwHIhMlzr2AdEJ4C+hFhfN+iUv3u
         RZIA==
X-Gm-Message-State: AAQBX9dFtY34Un8IufTRf6Tl0BXQeTOoqdnG+CUQ0Lm6EZ9CnWHJKcQD
        t5kfnXQIO8Lc/RsrISqiSSe+t5S0023f8wUwmBIvDH6RxQNnN4G09y8f1ucwrFrKvissyRi2yLH
        +3r+iC72Zq+C8hEKvwqiPtJRM
X-Received: by 2002:adf:fc92:0:b0:2f9:338:743d with SMTP id g18-20020adffc92000000b002f90338743dmr1863033wrr.23.1681818574099;
        Tue, 18 Apr 2023 04:49:34 -0700 (PDT)
X-Google-Smtp-Source: AKy350aYOVN1Z2VSO4baE6EM1hNDxkNcLBVWEre5foX9c33S7tdTllckYbjKhI5GlVc4jsmMnSneYQ==
X-Received: by 2002:adf:fc92:0:b0:2f9:338:743d with SMTP id g18-20020adffc92000000b002f90338743dmr1863011wrr.23.1681818573765;
        Tue, 18 Apr 2023 04:49:33 -0700 (PDT)
Received: from redhat.com ([2.52.136.129])
        by smtp.gmail.com with ESMTPSA id a7-20020adfed07000000b002fb2782219esm3758368wro.3.2023.04.18.04.49.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 04:49:33 -0700 (PDT)
Date:   Tue, 18 Apr 2023 07:49:28 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
Subject: Re: [PATCH net-next v2 00/14] virtio_net: refactor xdp codes
Message-ID: <20230418074911-mutt-send-email-mst@kernel.org>
References: <20230418065327.72281-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230418065327.72281-1-xuanzhuo@linux.alibaba.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 18, 2023 at 02:53:13PM +0800, Xuan Zhuo wrote:
> Due to historical reasons, the implementation of XDP in virtio-net is relatively
> chaotic. For example, the processing of XDP actions has two copies of similar
> code. Such as page, xdp_page processing, etc.
> 
> The purpose of this patch set is to refactor these code. Reduce the difficulty
> of subsequent maintenance. Subsequent developers will not introduce new bugs
> because of some complex logical relationships.
> 
> In addition, the supporting to AF_XDP that I want to submit later will also need
> to reuse the logic of XDP, such as the processing of actions, I don't want to
> introduce a new similar code. In this way, I can reuse these codes in the
> future.
> 
> Please review.
> 
> Thanks.

Big refactoring, pls allow a bit more time for review. Thanks!

> v2:
>     1. re-split to make review more convenient
> 
> v1:
>     1. fix some variables are uninitialized
> 
> Xuan Zhuo (14):
>   virtio_net: mergeable xdp: put old page immediately
>   virtio_net: introduce mergeable_xdp_prepare()
>   virtio_net: optimize mergeable_xdp_prepare()
>   virtio_net: introduce virtnet_xdp_handler() to seprate the logic of
>     run xdp
>   virtio_net: introduce xdp res enums
>   virtio_net: separate the logic of freeing xdp shinfo
>   virtio_net: separate the logic of freeing the rest mergeable buf
>   virtio_net: auto release xdp shinfo
>   virtio_net: introduce receive_mergeable_xdp()
>   virtio_net: merge: remove skip_xdp
>   virtio_net: introduce receive_small_xdp()
>   virtio_net: small: optimize code
>   virtio_net: small: optimize code
>   virtio_net: small: remove skip_xdp
> 
>  drivers/net/virtio_net.c | 625 +++++++++++++++++++++++----------------
>  1 file changed, 362 insertions(+), 263 deletions(-)
> 
> --
> 2.32.0.3.g01195cf9f

