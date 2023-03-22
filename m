Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCC6B6C4119
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 04:35:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbjCVDfp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 23:35:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230120AbjCVDfj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 23:35:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A55F3574F7
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 20:34:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679456091;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rEgoe1zFDcLmhk4rxGiMPFPfHT6rEh3EAYPVCGRVzRQ=;
        b=ZrMUZxcZwACJcvuM6zKWwxw/DJJ+M5EhqhWXQJ0PXtAzldHWa3l6t6VwCvSnpZQttPEx3z
        46vmND7mqZFn09/bHLZyOF9otcj8liES60nF0+8GSxHgSnmuGabU31l/Su/BCZ1lxkMF/9
        Lq8Lzj2fWYOsYnryOlXgyUdP2DxDaSg=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-125-Uz54PtGtNAixqwC48vhhgA-1; Tue, 21 Mar 2023 23:34:49 -0400
X-MC-Unique: Uz54PtGtNAixqwC48vhhgA-1
Received: by mail-wm1-f71.google.com with SMTP id t1-20020a7bc3c1000000b003dfe223de49so10930889wmj.5
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 20:34:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679456088;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rEgoe1zFDcLmhk4rxGiMPFPfHT6rEh3EAYPVCGRVzRQ=;
        b=d3K0TLdz6KkoRvm8wxlKnU6O0gfuLkGLy+DZ48zYKSE00ZMCgd9XYUyp0gO4vm+A1P
         rCNvAdkGX9rhBsZ66lcdcG+x5e/DOoTNtbXmLWDp3Mt5Jiao0ekzhw32iAk2yoiip7AQ
         VnHajAfSCB1mwj5EmvuUawlPd/SXfMaO2YZhBDkuHx2/Cu/1MSaBB1tvlsnumrjvmM+q
         qJKx1YXcgVbhJWVmlpcrrwuSW8KEGuI0jpZ8nSLlc0wP4eealtLJl5pZb2/ueF1aaQq1
         Qwi62x/NzSkjhlmi9fLEKpKDibx/cXffRa5WRWy02NnWonHiKF/Bsf0GeiRcKOeCGAZY
         5RNA==
X-Gm-Message-State: AO0yUKWpSns2IDefUDhOC2C5bar4k6fcRx43qH3CDRsmsVWUG/+yY4ut
        8G6FXSdqAkB14aF/f4iiunHtyQwMvDKWhJloFCp78slL7tsIGeWB72VKUp1H05NUgD9cy0cWbY/
        PGUOLoDYAMcnCD0zbmw3YfsBT
X-Received: by 2002:adf:e981:0:b0:2c7:a55:bef5 with SMTP id h1-20020adfe981000000b002c70a55bef5mr3544124wrm.23.1679456088343;
        Tue, 21 Mar 2023 20:34:48 -0700 (PDT)
X-Google-Smtp-Source: AK7set+Apq+HPpz2Z8yaQvS6OjyfaVy0S9hujAOKApOdfMAoD3TzIb2fbtsNFWywoo0nKrsHt9X9zg==
X-Received: by 2002:adf:e981:0:b0:2c7:a55:bef5 with SMTP id h1-20020adfe981000000b002c70a55bef5mr3544111wrm.23.1679456088062;
        Tue, 21 Mar 2023 20:34:48 -0700 (PDT)
Received: from redhat.com ([2.52.1.105])
        by smtp.gmail.com with ESMTPSA id v3-20020adfe4c3000000b002cf8220cc75sm4802911wrm.24.2023.03.21.20.34.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 20:34:47 -0700 (PDT)
Date:   Tue, 21 Mar 2023 23:34:43 -0400
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
Subject: Re: [PATCH net-next 0/8] virtio_net: refactor xdp codes
Message-ID: <20230321233325-mutt-send-email-mst@kernel.org>
References: <20230322030308.16046-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230322030308.16046-1-xuanzhuo@linux.alibaba.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 22, 2023 at 11:03:00AM +0800, Xuan Zhuo wrote:
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

I really want to see that code make progress though.
Would it make sense to merge this one through the virtio tree?

Then you will have all the pieces in one place and try to target
next linux.


> Xuan Zhuo (8):
>   virtio_net: mergeable xdp: put old page immediately
>   virtio_net: mergeable xdp: introduce mergeable_xdp_prepare
>   virtio_net: introduce virtnet_xdp_handler() to seprate the logic of
>     run xdp
>   virtio_net: separate the logic of freeing xdp shinfo
>   virtio_net: separate the logic of freeing the rest mergeable buf
>   virtio_net: auto release xdp shinfo
>   virtio_net: introduce receive_mergeable_xdp()
>   virtio_net: introduce receive_small_xdp()
> 
>  drivers/net/virtio_net.c | 615 +++++++++++++++++++++++----------------
>  1 file changed, 357 insertions(+), 258 deletions(-)
> 
> --
> 2.32.0.3.g01195cf9f

