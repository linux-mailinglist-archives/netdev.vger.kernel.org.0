Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59E286EE1F3
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 14:34:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234126AbjDYMeu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 08:34:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233329AbjDYMes (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 08:34:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51C5013F9D
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 05:33:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682426020;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wUQt5lQEAzd3ahqHmV1QENMOzdVqzkRfQSadc2YBDxM=;
        b=bEkH7k886y/gOLq/+IL4gcGbq5E9Gll/yjOwgTSnSmaUN7DQXi3wKyJ7jLczy91L0syaHE
        945VbTw7yuPzh1+2O/TvqOYFd8eNO+dd2ZcV/CL1/KSAvdjPPUoAs0Ta7irIfAeDcDDCG6
        eaWRHBIIs/75Mt71u2qLSetAlRyb4T0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-172--wPTLhumODyeQIs1Q7kGbA-1; Tue, 25 Apr 2023 08:33:36 -0400
X-MC-Unique: -wPTLhumODyeQIs1Q7kGbA-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-3f16f50aeb5so21675805e9.3
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 05:33:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682426015; x=1685018015;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wUQt5lQEAzd3ahqHmV1QENMOzdVqzkRfQSadc2YBDxM=;
        b=f1rXGbSfQoUPQwm9RxdtClqbi7kUHmS/YtZ/7do2KqN3oZIcD18LT28SWMfPzz2pLa
         NKxA6+gRSMm4VCM9O96X7ADTM2qD3Y3F0n0czsX0g3ySyBZdXuLMJACLV8j1y9RPMDjj
         bhENZeAynMkk+LqQ9LLWnCtxvKMkIZ2fGFpPkF04Rm7UgTCdmGGWZ6t0PBe51P9XLMRZ
         SW240PL3Y+QoCrfRW9n790MxlbhGUkiyFZd9ocNQYVgeIu4DIwDgwb4py0eWhvTEt9QW
         rP72PMBl+4TzT2CmqXdNpQvOpRFCtahVWuctoaszl+cgp2Xa5hfUOtrEhjsAnpFBO/gI
         /o7Q==
X-Gm-Message-State: AAQBX9dfRCTSkRrpNpngYZy3gVWlYiWeQu3gbn7KLir4gFeK4UtXYu21
        gZdEE3BFgoEGL1hVKukgeyr7T55VGY5qarJ5D1OdbuqGrRsSvdEIUVNTCMk3SmD6C8tTY4xUOx8
        PfuciBktJNhrshbVi0/CHPsZZ
X-Received: by 2002:a1c:7707:0:b0:3f1:92e8:a6fe with SMTP id t7-20020a1c7707000000b003f192e8a6femr9788149wmi.31.1682426015464;
        Tue, 25 Apr 2023 05:33:35 -0700 (PDT)
X-Google-Smtp-Source: AKy350bbwbXGwV35ZzB88SPcCWZhKgDOx1uFXZVk4jqEryiTgkP0rJUqoUzbI4IvWln0BbQKedDO+g==
X-Received: by 2002:a1c:7707:0:b0:3f1:92e8:a6fe with SMTP id t7-20020a1c7707000000b003f192e8a6femr9788133wmi.31.1682426015164;
        Tue, 25 Apr 2023 05:33:35 -0700 (PDT)
Received: from redhat.com ([2.55.17.255])
        by smtp.gmail.com with ESMTPSA id w9-20020a1cf609000000b003ede06f3178sm14890603wmc.31.2023.04.25.05.33.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Apr 2023 05:33:34 -0700 (PDT)
Date:   Tue, 25 Apr 2023 08:33:31 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Alvaro Karsz <alvaro.karsz@solid-run.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] virtio-net: reject small vring sizes
Message-ID: <20230425083212-mutt-send-email-mst@kernel.org>
References: <AM0PR04MB4723FA4F0FFEBD25903E3344D49C9@AM0PR04MB4723.eurprd04.prod.outlook.com>
 <20230417075645-mutt-send-email-mst@kernel.org>
 <AM0PR04MB4723FA90465186B5A8A5C001D4669@AM0PR04MB4723.eurprd04.prod.outlook.com>
 <20230423031308-mutt-send-email-mst@kernel.org>
 <AM0PR04MB47233B680283E892C45430BCD4669@AM0PR04MB4723.eurprd04.prod.outlook.com>
 <20230423065132-mutt-send-email-mst@kernel.org>
 <AM0PR04MB47237D46ADE7954289025B66D4669@AM0PR04MB4723.eurprd04.prod.outlook.com>
 <20230425041352-mutt-send-email-mst@kernel.org>
 <AM0PR04MB4723CE2A9B8BFA7963A66A98D4649@AM0PR04MB4723.eurprd04.prod.outlook.com>
 <AM0PR04MB4723E09C948B92912C796BEAD4649@AM0PR04MB4723.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM0PR04MB4723E09C948B92912C796BEAD4649@AM0PR04MB4723.eurprd04.prod.outlook.com>
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 25, 2023 at 11:11:54AM +0000, Alvaro Karsz wrote:
> > > So, let's add some funky flags in virtio device to block out
> > > features, have core compare these before and after,
> > > detect change, reset and retry?
> > 
> > In the virtnet case, we'll decide which features to block based on the ring size.
> > 2 < ring < MAX_FRAGS + 2  -> BLOCK GRO + MRG_RXBUF
> > ring < 2  -> BLOCK GRO + MRG_RXBUF + CTRL_VQ
> > 
> > So we'll need a new virtio callback instead of flags.
> > 
> > Furthermore, other virtio drivers may decide which features to block based on parameters different than ring size (I don't have a good example at the moment).
> > So maybe we should leave it to the driver to handle (during probe), > and offer a virtio core function to re-negotiate the features?
> > 
> > In the solution I'm working on, I expose a new virtio core function that resets the device and renegotiates the received features.
> > + A new virtio_config_ops callback peek_vqs_len to peek at the VQ lengths before calling find_vqs. (The callback must be called after the features negotiation)
> > 
> > So, the flow is something like:
> > 
> > * Super early in virtnet probe, we peek at the VQ lengths and decide if we are
> >    using small vrings, if so, we reset and renegotiate the features.
> > * We continue normally and create the VQs.
> > * We check if the created rings are small.
> >    If they are and some blocked features were negotiated anyway (may occur if
> >    the re-negotiation fails, or if the transport has no implementation for
> >    peek_vqs_len), we fail probe.
> 
> Small fix: if the re-negotiation fails, we fail probe immediately.
> The only way to negotiate blocked features with a small vring is if the transport has no implementation for peek_vqs_len.

with my idea, you can go iteratively: fail one condition, core will
retry with a feature blocked, we can block more, retry again.
up to 64 times :)

> >    If the ring is small and the features are ok, we mark the virtnet device as
> >    vring_small and fixup some variables.
> > 
> > 
> > peek_vqs_len is needed because we must know the VQ length before calling init_vqs.
> > 
> > During virtnet_find_vqs we check the following:
> > vi->has_cvq
> > vi->big_packets
> > vi->mergeable_rx_bufs
> > 
> > But these will change if the ring is small..
> > 
> > (Of course, another solution will be to re-negotiate features after init_vqs, but this will make a big mess, tons of things to clean and reconfigure)
> > 
> > 
> > The 2 < ring < MAX_FRAGS + 2 part is ready, I have tested a few cases and it is working.
> > 
> > I'm considering splitting the effort into 2 series.
> > A 2 < ring < MAX_FRAGS + 2  series, and a follow up series with the ring < 2 case.
> > 
> > I'm also thinking about sending the first series as an RFC soon, so it will be more broadly tested.
> > 
> > What do you think?
> > 

