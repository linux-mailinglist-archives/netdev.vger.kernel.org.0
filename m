Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2D8E6509E9
	for <lists+netdev@lfdr.de>; Mon, 19 Dec 2022 11:16:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231664AbiLSKQL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 05:16:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231401AbiLSKQJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 05:16:09 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 499D5A444
        for <netdev@vger.kernel.org>; Mon, 19 Dec 2022 02:15:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671444920;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0F60KxR0W9IzjgTzMiPaONsb+3DC5K9NhR1i6GY+9bw=;
        b=UCyJWuRWj0jWxC73KOYjHtojHh6nXW+7UV36fdidehnR2PGoybgiQHbLO7xspk1LJKiMYW
        4DpH62xFMl/9r/uo51fhf0x6wXc8Std2dAmQdqDLS/XAb8AzTFa26g5vvNQz/u2HKH3+vS
        IW8RfFFNLnp7n8LYPCrhO8/zSRGFJJs=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-127-sBdDrLTcMgu8u_3QJXFfbw-1; Mon, 19 Dec 2022 05:15:18 -0500
X-MC-Unique: sBdDrLTcMgu8u_3QJXFfbw-1
Received: by mail-qk1-f199.google.com with SMTP id h13-20020a05620a244d00b006fb713618b8so7035404qkn.0
        for <netdev@vger.kernel.org>; Mon, 19 Dec 2022 02:15:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0F60KxR0W9IzjgTzMiPaONsb+3DC5K9NhR1i6GY+9bw=;
        b=SchPhFgVW9gg1EJk+UKkZ9q1EjagF6ReIkrRiJnzZP8s6LPmcFgq5irP7jmLzwWeUv
         oSFGN0kecJAEjSyJ+YTnMRkxO2mOd672AF9hdLrcoRUsW1B6df78jewlBWj3ISVR5gyl
         K03DNxQDwSQHXZPUqCsFZxGG7x57LU4B3QELnxs++aT48gVIOxwqHuSnZZ2iSG75qluZ
         1LpLwtmckZDwh5+ASljsoayQv4ospzeZQgVI/nDqj7FKsspw3LRjbixb96U3eiWYv2Qe
         3xGIEKfOMosJqeCwUPlYYn+jC3epk9fJCLDSWnbcX5XWf4cYdWMfsBAD9ti/VQBYqm2d
         4Oyg==
X-Gm-Message-State: ANoB5plJiThX4wbDcbwxOr8wlKVgRJFWiP8igkCTGa+Fe7ZWo0rISnGt
        McvTRukonUMHOijkP63apOdYX663rtWGjVDIPGleMyItL740MAUlxTFdykefKceCkWCKo4tjqhv
        AmQVPBoH1coCcVYOm
X-Received: by 2002:ac8:4e51:0:b0:3a5:2704:d4bd with SMTP id e17-20020ac84e51000000b003a52704d4bdmr74303341qtw.16.1671444918004;
        Mon, 19 Dec 2022 02:15:18 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5bm5Qnb85eW38Qmkj26T6UAoQXiAZKZbsD/6lF6kYKtBjYMui2UsCvc851kAw1QZmfTvQTLw==
X-Received: by 2002:ac8:4e51:0:b0:3a5:2704:d4bd with SMTP id e17-20020ac84e51000000b003a52704d4bdmr74303318qtw.16.1671444917765;
        Mon, 19 Dec 2022 02:15:17 -0800 (PST)
Received: from redhat.com ([45.144.113.29])
        by smtp.gmail.com with ESMTPSA id r17-20020a05620a299100b006fb8239db65sm6819951qkp.43.2022.12.19.02.15.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Dec 2022 02:15:17 -0800 (PST)
Date:   Mon, 19 Dec 2022 05:15:09 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Li Zetao <lizetao1@huawei.com>, pbonzini@redhat.com,
        stefanha@redhat.com, axboe@kernel.dk, kraxel@redhat.com,
        david@redhat.com, ericvh@gmail.com, lucho@ionkov.net,
        asmadeus@codewreck.org, linux_oss@crudebyte.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, rusty@rustcorp.com.au,
        virtualization@lists.linux-foundation.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org
Subject: Re: [PATCH 0/4] Fix probe failed when modprobe modules
Message-ID: <20221219050716-mutt-send-email-mst@kernel.org>
References: <20221128021005.232105-1-lizetao1@huawei.com>
 <20221128042945-mutt-send-email-mst@kernel.org>
 <CACGkMEtuOk+wyCsvY0uayGAvy926G381PC-csoXVAwCfiKCZQw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACGkMEtuOk+wyCsvY0uayGAvy926G381PC-csoXVAwCfiKCZQw@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 29, 2022 at 11:37:09AM +0800, Jason Wang wrote:
> >
> >
> > Quite a lot of core work here. Jason are you still looking into
> > hardening?
> 
> Yes, last time we've discussed a solution that depends on the first
> kick to enable the interrupt handler. But after some thought, it seems
> risky since there's no guarantee that the device work in this way.
> 
> One example is the current vhost_net, it doesn't wait for the kick to
> process the rx packets. Any more thought on this?
> 
> Thanks

Specifically virtio net is careful to call virtio_device_ready
under rtnl lock so buffers are only added after DRIVER_OK.

However we do not need to tie this to kick, this is what I wrote:

> BTW Jason, I had the idea to disable callbacks until driver uses the
> virtio core for the first time (e.g. by calling virtqueue_add* family of
> APIs). Less aggressive than your ideas but I feel it will add security
> to the init path at least.

So not necessarily kick, we can make adding buffers allow the
interrupt.



-- 
MST

