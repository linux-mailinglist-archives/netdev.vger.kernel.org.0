Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1E1C6E4067
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 09:12:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbjDQHMc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 03:12:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjDQHMb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 03:12:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4762D40E2
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 00:11:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681715507;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3DxIGeDChpW+dCspX207xU3KDB22/OENqLPHBuTpQk8=;
        b=FesVfWKQwFZoCp87J5C24sRfjKKEnxwTZbodf7ktgqeswR8odoyfbuW5T8eZpkkKO2hBpd
        yzKAeE8P5Yj57zj/DpGZTrC627h7ZSFodzypPm/SZH7P4+Jwbi0nwo7zDdd6cto4yU588V
        MP4EL0KgV7n8wMELFY4ipo4el5/rYOQ=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-253-AELJAZQKOk-iOwm5GGVtDg-1; Mon, 17 Apr 2023 03:11:46 -0400
X-MC-Unique: AELJAZQKOk-iOwm5GGVtDg-1
Received: by mail-qt1-f198.google.com with SMTP id v24-20020a05622a189800b003e0e27bbc2eso17351353qtc.8
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 00:11:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681715506; x=1684307506;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3DxIGeDChpW+dCspX207xU3KDB22/OENqLPHBuTpQk8=;
        b=YllTfeVrRRhaalqBHE8br7+PidziU7ob+6Fe+PSgpPvKekF6BXXXzw34Z81wD9pLnc
         zNj60zxF6M+zuR4de/21vYM/BTvoKvHUxpQrW/YlPy5pCBUFc21ZRx1xX9TfxeBDuB8W
         qp4JdtN94j1ZlPdZIKofcnQa+IB+EWDqUj5/I0OWUT8YBndXIkoVs/V7kIRNCRYsMxXz
         DHUdgY/Jk8h0tr5U6xoC4BZH4WOAZZuyUaaC68+FYzFYqNdDQG0htrmCYUw1QIr5QS3t
         S2Akyoofyl6gJls/CI6xYUzyd44RlxkViHKBMcA7+pJALRGeTAETlkAuqIG0Of8RAdKm
         kQBQ==
X-Gm-Message-State: AAQBX9cJeJmYINilepJKoTYEgyCJhC06Ezgu4SUB6BUkkk7WR0GgcavG
        nIh11FwUtL3NPKvI2KnlaiOQFzXD+ixbINkDF1MrQEuQroZt/giC0FM/AdsNGess5Nr99tkl00C
        GgOTj6LeovMxwIGf8
X-Received: by 2002:a05:622a:15c8:b0:3e6:7634:3d0a with SMTP id d8-20020a05622a15c800b003e676343d0amr20401076qty.1.1681715505870;
        Mon, 17 Apr 2023 00:11:45 -0700 (PDT)
X-Google-Smtp-Source: AKy350bRWAwroeDDp+zaMLOKHGqZ0C7Fj+pnRJZLP5CoVXzD2w0JJpOmAxj/pZFif7P2SmN4qP2jFA==
X-Received: by 2002:a05:622a:15c8:b0:3e6:7634:3d0a with SMTP id d8-20020a05622a15c800b003e676343d0amr20401058qty.1.1681715505638;
        Mon, 17 Apr 2023 00:11:45 -0700 (PDT)
Received: from redhat.com ([185.199.103.251])
        by smtp.gmail.com with ESMTPSA id z1-20020ac81001000000b003b9b8ec742csm3089121qti.14.2023.04.17.00.11.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Apr 2023 00:11:45 -0700 (PDT)
Date:   Mon, 17 Apr 2023 03:11:38 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Alvaro Karsz <alvaro.karsz@solid-run.com>
Cc:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jason Wang <jasowang@redhat.com>
Subject: Re: [PATCH net] virtio-net: reject small vring sizes
Message-ID: <20230417031052-mutt-send-email-mst@kernel.org>
References: <20230416074607.292616-1-alvaro.karsz@solid-run.com>
 <AM0PR04MB4723C6E99A217F51973710F5D49F9@AM0PR04MB4723.eurprd04.prod.outlook.com>
 <20230416164453-mutt-send-email-mst@kernel.org>
 <CACGkMEvFhVyWb5+ET_akPvnjUq04+ZbJC8o_GtNBWqSMGNum8A@mail.gmail.com>
 <20230417021725-mutt-send-email-mst@kernel.org>
 <AM0PR04MB4723B8489F8F9AE547393697D49C9@AM0PR04MB4723.eurprd04.prod.outlook.com>
 <1681713856.1928573-2-xuanzhuo@linux.alibaba.com>
 <AM0PR04MB4723EB7A5E42A090F63EEC11D49C9@AM0PR04MB4723.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM0PR04MB4723EB7A5E42A090F63EEC11D49C9@AM0PR04MB4723.eurprd04.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 17, 2023 at 07:07:59AM +0000, Alvaro Karsz wrote:
> > Why tx timeout without frags?
> 
> Please see my response to Michael.
> 
> > > * Guest GSO/big MTU (without VIRTIO_NET_F_MRG_RXBUF?), we can't chain page size buffers anymore.
> > 
> > 
> > Or, we disable the GUEST_GSO, HOST_GSO......
> > 
> And disable VIRTIO_NET_F_MTU, quoting the spec:
> "A driver SHOULD negotiate VIRTIO_NET_F_MTU if the device offers it."

If you don't the nic can still get jumbo packets it will just drop them ...

> We can find a way around using buffers bigger than a page size like Michael implied.

