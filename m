Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DFAD5974C7
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 19:07:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240506AbiHQRDE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 13:03:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238200AbiHQRDD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 13:03:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D53599C1D3
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 10:03:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660755782;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iKDI4wZP72dFon1h0J2l9ajfalLVCP4U7tsE8KQrHV8=;
        b=GlNZRmvBygQNFcWF2DZ8eBpULCvxpT8yeMiAn3KPCKdyFEFO2Giv7fiWXBqIy6xDfkBwuP
        IaKK0vMpMZWfQuLHpTVOOpNnM5Gm7KSxS797RjfgGznC4jzPnDYMjTfigyrJekY4YMRet9
        18JKGAEMYNF/uFS+Pq6mZIWMDI2teTQ=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-534-8P3a0DjtPzah1xqwf2s2dg-1; Wed, 17 Aug 2022 13:03:00 -0400
X-MC-Unique: 8P3a0DjtPzah1xqwf2s2dg-1
Received: by mail-wr1-f69.google.com with SMTP id i29-20020adfa51d000000b002251fd0ff14so911602wrb.16
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 10:03:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=iKDI4wZP72dFon1h0J2l9ajfalLVCP4U7tsE8KQrHV8=;
        b=ea6GdirSjeCALbqKxrvriTvhPMVhLHSPRw43tlRAhcnPnOkLDRGsRHOOLyMIu6mPMV
         dcNI1BVGfxs1Kz+S4YLgkrjkxuuBWbcAfI791SZXssW4bvT+tR3nQIBJ7R9+1YUIWRWv
         21JZ7+tzrw0GCoeHBEkxlkzSkgV0PT2gmV/yC74XiASgOKGH6Fxnew9Q1hdjT8zUNHYE
         cLmTUs4BJcBfRdCBhsd+kbr6XdIkIuDENy2izOtGSYBsuhogpGBd5fppiNvKZxFs/Q5y
         qFKP8ZgUZnvZNuv+y09tOofU64G6ztAX/yZueE0KtJ6M3F1gKZCUyyj8Dp26YDMqDz6q
         LWqg==
X-Gm-Message-State: ACgBeo22WoOo1rQSGk4XRptgz4I/Mf56tagp39bUdantGIPiuyrkaeWi
        I4TWb6n103YsCZDGixliE78a53sdtoNeomOOyT7A8IIuzo0PbDs7cWnY4ZEUE2c13gAoGq7pXYZ
        fymcTge5Hp+B+OUhA
X-Received: by 2002:a5d:440b:0:b0:225:2106:2f30 with SMTP id z11-20020a5d440b000000b0022521062f30mr3175262wrq.533.1660755779411;
        Wed, 17 Aug 2022 10:02:59 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5AuDbo8GcZEnqQiqOeyM94DlUbLxyqrhdFN62DfedDuMFRt+WAj8nSt4Xs7jQmlw2zs7JUow==
X-Received: by 2002:a5d:440b:0:b0:225:2106:2f30 with SMTP id z11-20020a5d440b000000b0022521062f30mr3175243wrq.533.1660755779078;
        Wed, 17 Aug 2022 10:02:59 -0700 (PDT)
Received: from redhat.com ([2.55.43.215])
        by smtp.gmail.com with ESMTPSA id h82-20020a1c2155000000b003a319bd3278sm2825504wmh.40.2022.08.17.10.02.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 10:02:58 -0700 (PDT)
Date:   Wed, 17 Aug 2022 13:02:52 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Bobby Eshleman <bobbyeshleman@gmail.com>
Cc:     Bobby Eshleman <bobby.eshleman@gmail.com>,
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
Message-ID: <20220817130044-mutt-send-email-mst@kernel.org>
References: <cover.1660362668.git.bobby.eshleman@bytedance.com>
 <20220817025250-mutt-send-email-mst@kernel.org>
 <YvtmYpMieMFb80qR@bullseye>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YvtmYpMieMFb80qR@bullseye>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 16, 2022 at 09:42:51AM +0000, Bobby Eshleman wrote:
> > The basic question to answer then is this: with a net device qdisc
> > etc in the picture, how is this different from virtio net then?
> > Why do you still want to use vsock?
> > 
> 
> When using virtio-net, users looking for inter-VM communication are
> required to setup bridges, TAPs, allocate IP addresses or setup DNS,
> etc... and then finally when you have a network, you can open a socket
> on an IP address and port. This is the configuration that vsock avoids.
> For vsock, we just need a CID and a port, but no network configuration.

Surely when you mention DNS you are going overboard? vsock doesn't
remove the need for DNS as much as it does not support it.

-- 
MST

