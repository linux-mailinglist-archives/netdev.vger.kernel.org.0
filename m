Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A65945EFA6E
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 18:27:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236128AbiI2Q1N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 12:27:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236048AbiI2Q0j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 12:26:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EFB0D98F6
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 09:25:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664468729;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wP+ERui3HiyMQ5txVX6VKAqSsbRuHdNYsyw/tUJPBgg=;
        b=e6WWsE4E4ZGHsE4cmsJ4vP5BG9qpuFM1A5xuOGRw49e/ScZyGXrizETWzqO1Kke9ShPHTg
        ziH5SopPKeIIbEoyHUISnKL8QGRV9e5KCd1usBQdzPukuFBHEcxqRPU/qtAQvvJMqm2e11
        4wpm0JvyIfQ1PFv0Yrm8jSPE9+McxHk=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-3-BkjZcFPsMxSQJJ2fD8A5sA-1; Thu, 29 Sep 2022 12:25:20 -0400
X-MC-Unique: BkjZcFPsMxSQJJ2fD8A5sA-1
Received: by mail-wm1-f72.google.com with SMTP id r128-20020a1c4486000000b003b3309435a9so2423858wma.6
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 09:25:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=wP+ERui3HiyMQ5txVX6VKAqSsbRuHdNYsyw/tUJPBgg=;
        b=CZyWw8Gt7oC5r1ziOaCUdMO/wllLCG+1Z39iLX1d/t9E88nD3JX9/QJxbUzLCx2f92
         ylB0cV7RoMJ3siO+R2oY+on+h8Fba3TD7PNDgHw9dN8Agl2TFaj+eQ2ZeyjAOoOY24wO
         i/DHvcj6WysQr0t+Kbk+bvu7Q6B2b0UEwpvJbB/4gvoDZCxnysuU6gcjLVbjHaZvAL3r
         V3FEIQ/RGgz7T9T/htBTxNM3B1bfym3VWwKMzMZCbsR+Eic8779Uso26I/9B7ldassGu
         f7FoRHlrD5r/miLsUVzM98fy0lZ/ThZrb+3rcdka6Kmbs0LIasNGN3SbGcdJohbJ99hs
         +gvQ==
X-Gm-Message-State: ACrzQf1+U+6petBKlkrCgLoD0UVY8MbEMU6RiOiov57SZBUyEsutFJ8G
        eub2TMsLe/kKnNHedWIq3Ar2tI3aMna54HCt64i59Dd1pVwi78mHUWR827p2RdZIncil8l/O5zM
        782tM/jlLXbchsYh6
X-Received: by 2002:a05:600c:3205:b0:3b3:3813:ae3f with SMTP id r5-20020a05600c320500b003b33813ae3fmr3196834wmp.158.1664468719682;
        Thu, 29 Sep 2022 09:25:19 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7GXSxx1LBarzR7zq6U/e87GpBhC/rEY4V4sODPzyAV8maunzFx+24hSqCxT0BLh73br06cHw==
X-Received: by 2002:a05:600c:3205:b0:3b3:3813:ae3f with SMTP id r5-20020a05600c320500b003b33813ae3fmr3196805wmp.158.1664468719486;
        Thu, 29 Sep 2022 09:25:19 -0700 (PDT)
Received: from redhat.com ([2.55.17.78])
        by smtp.gmail.com with ESMTPSA id t18-20020adfe452000000b00228cd9f6349sm7243877wrm.106.2022.09.29.09.25.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Sep 2022 09:25:18 -0700 (PDT)
Date:   Thu, 29 Sep 2022 12:25:14 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Stefano Garzarella <sgarzare@redhat.com>,
        Junichi Uekawa =?utf-8?B?KCDkuIrlt53ntJTkuIAp?= 
        <uekawa@google.com>, Stefan Hajnoczi <stefanha@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Eric Dumazet <edumazet@google.com>, davem@davemloft.net,
        netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        kvm@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        linux-kernel@vger.kernel.org,
        Bobby Eshleman <bobby.eshleman@gmail.com>
Subject: Re: [PATCH] vhost/vsock: Use kvmalloc/kvfree for larger packets.
Message-ID: <20220929122444-mutt-send-email-mst@kernel.org>
References: <20220928064538.667678-1-uekawa@chromium.org>
 <20220928082823.wyxplop5wtpuurwo@sgarzare-redhat>
 <20220928052738-mutt-send-email-mst@kernel.org>
 <20220928151135.pvrlsylg6j3hzh74@sgarzare-redhat>
 <CADgJSGHxPWXJjbakEeWnqF42A03yK7Dpw6U1SKNLhk+B248Ymg@mail.gmail.com>
 <20220929031419-mutt-send-email-mst@kernel.org>
 <20220929074606.yqzihpcc7cl442c5@sgarzare-redhat>
 <20220929034807-mutt-send-email-mst@kernel.org>
 <20220929090731.27cda58c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220929090731.27cda58c@kernel.org>
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 29, 2022 at 09:07:31AM -0700, Jakub Kicinski wrote:
> On Thu, 29 Sep 2022 03:49:18 -0400 Michael S. Tsirkin wrote:
> > net tree would be preferable, my pull for this release is kind of ready ... kuba?
> 
> If we're talking about 6.1 - we can take it, no problem.

I think they want it in 6.0 as it fixes a crash.

