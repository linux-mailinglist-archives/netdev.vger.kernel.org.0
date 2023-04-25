Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA80D6EE27C
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 15:09:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233454AbjDYNJq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 09:09:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233322AbjDYNJp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 09:09:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A42DF2
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 06:08:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682428137;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+fKc7C0hTjXYruI3suD5rQvaDU7fCvCV7e+LIaqkh9A=;
        b=DMuB2jGPf2JZ5DUPgXFOe/rzQ/fTgpc8MUzAwjHEkg39fz7noqFnNHKNC4OeA+7EGUmjqN
        T3DSNOSB4vUc0kU24jtvJPI4idSWKtAm4msxpiRzwwYOaGXT8oLJvRDzEnhx2DYKjDmSV3
        +kqwsZvizHM3BsRcMmhEmLB5v7J0cNg=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-27-cnsg8MOkO8S8k-DpZkVzGA-1; Tue, 25 Apr 2023 09:08:56 -0400
X-MC-Unique: cnsg8MOkO8S8k-DpZkVzGA-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-2fe3fb8e32aso2085970f8f.1
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 06:08:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682428135; x=1685020135;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+fKc7C0hTjXYruI3suD5rQvaDU7fCvCV7e+LIaqkh9A=;
        b=PsjnEaxvKl3j4T6q/AwG9ywgHBLtn/Iqc1r1ZPzFHSrA6X2VAKusdGs8yt17uPvRg4
         YYZotvt9rK+zkzwCE9gE7Hilv89V6l59JpxNhLrbtLU90ncdmj2cN2gR6RRW9js0osLj
         i3chfDy1BG9G5fH4fpbYDnL4NqK7A7eJKyyw+nYB6WUMULeFC9IbEZFza5JzIXkWRfF9
         2rcBt7HE/soOh5W9mGTJXPOtSmSbwRnKlb1FT7Ufnm+5Wmg6rzxu69YOrFSKIVquRc3f
         zjMQY28cQjopnxnJ3rZQri+PfYAJFZRj2osM/RiK92FEdzizU/CWdwJcqLtaAFaSnFIp
         T6yQ==
X-Gm-Message-State: AAQBX9daIoRG7qVl6TopH7+gVAbyy/Jaq05NXDkLH65gzgbP0iR55dzQ
        7igP+P9fcUcQGzSeV8aqgMMayW7P4PzG8CcNuUO3DHL19PWCALLh/0XTjVzfJbTie1yuAjQXb8z
        dk9KgdB5++jvKGj3s
X-Received: by 2002:a5d:6a85:0:b0:303:a2e4:e652 with SMTP id s5-20020a5d6a85000000b00303a2e4e652mr10068938wru.14.1682428135278;
        Tue, 25 Apr 2023 06:08:55 -0700 (PDT)
X-Google-Smtp-Source: AKy350Z/5PjVU1BDfVWhe5ZogmeG2QujfzTYbkQm7cIQds9gnOnNL45pBPkNdHk963LSlI0oVKLjJQ==
X-Received: by 2002:a5d:6a85:0:b0:303:a2e4:e652 with SMTP id s5-20020a5d6a85000000b00303a2e4e652mr10068917wru.14.1682428134946;
        Tue, 25 Apr 2023 06:08:54 -0700 (PDT)
Received: from redhat.com ([2.55.17.255])
        by smtp.gmail.com with ESMTPSA id o4-20020a056000010400b002fa67f77c16sm13024173wrx.57.2023.04.25.06.08.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Apr 2023 06:08:54 -0700 (PDT)
Date:   Tue, 25 Apr 2023 09:08:50 -0400
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
Message-ID: <20230425090723-mutt-send-email-mst@kernel.org>
References: <20230417075645-mutt-send-email-mst@kernel.org>
 <AM0PR04MB4723FA90465186B5A8A5C001D4669@AM0PR04MB4723.eurprd04.prod.outlook.com>
 <20230423031308-mutt-send-email-mst@kernel.org>
 <AM0PR04MB47233B680283E892C45430BCD4669@AM0PR04MB4723.eurprd04.prod.outlook.com>
 <20230423065132-mutt-send-email-mst@kernel.org>
 <AM0PR04MB47237D46ADE7954289025B66D4669@AM0PR04MB4723.eurprd04.prod.outlook.com>
 <20230425041352-mutt-send-email-mst@kernel.org>
 <AM0PR04MB4723CE2A9B8BFA7963A66A98D4649@AM0PR04MB4723.eurprd04.prod.outlook.com>
 <20230425082150-mutt-send-email-mst@kernel.org>
 <AM0PR04MB4723E38859953B6C531D3E5CD4649@AM0PR04MB4723.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM0PR04MB4723E38859953B6C531D3E5CD4649@AM0PR04MB4723.eurprd04.prod.outlook.com>
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 25, 2023 at 01:02:38PM +0000, Alvaro Karsz wrote:
> > > In the virtnet case, we'll decide which features to block based on the ring size.
> > > 2 < ring < MAX_FRAGS + 2  -> BLOCK GRO + MRG_RXBUF
> > > ring < 2  -> BLOCK GRO + MRG_RXBUF + CTRL_VQ
> > 
> > why MRG_RXBUF? what does it matter?
> > 
> 
> You're right, it should be blocked only when ring < 2.
> Or we should let this pass, and let the device figure out that MRG_RXBUF is meaningless with 1 entry..

yep, later I think.

> > > So we'll need a new virtio callback instead of flags.
> > > Furthermore, other virtio drivers may decide which features to block based on parameters different than ring size (I don't have a good example at the moment).
> > > So maybe we should leave it to the driver to handle (during probe), and offer a virtio core function to re-negotiate the features?
> > >
> > > In the solution I'm working on, I expose a new virtio core function that resets the device and renegotiates the received features.
> > > + A new virtio_config_ops callback peek_vqs_len to peek at the VQ lengths before calling find_vqs. (The callback must be called after the features negotiation)
> > >
> > > So, the flow is something like:
> > >
> > > * Super early in virtnet probe, we peek at the VQ lengths and decide if we are
> > >    using small vrings, if so, we reset and renegotiate the features.
> > 
> > Using which APIs? What does peek_vqs_len do and why does it matter that
> > it is super early?
> > 
> 
> We peek at the lengths using a new virtio_config.h function that calls a transport specific callback.
> We renegotiate calling the new, exported virtio core function.
> 
> peek_vqs_len fills an array of u16 variables with the max length of every VQ.
> 
> The idea here is not to fail probe.
> So we start probe, check if the ring is small, renegotiate the features and then continue with the new features.
> This needs to be super early because otherwise, some virtio_has_feature calls before re-negotiating may be invalid, meaning a lot of reconfigurations.
> 
> > > * We continue normally and create the VQs.
> > > * We check if the created rings are small.
> > >    If they are and some blocked features were negotiated anyway (may occur if
> > >    the re-negotiation fails, or if the transport has no implementation for
> > >    peek_vqs_len), we fail probe.
> > >    If the ring is small and the features are ok, we mark the virtnet device as
> > >    vring_small and fixup some variables.
> > >
> > >
> > > peek_vqs_len is needed because we must know the VQ length before calling init_vqs.
> > >
> > > During virtnet_find_vqs we check the following:
> > > vi->has_cvq
> > > vi->big_packets
> > > vi->mergeable_rx_bufs
> > >
> > > But these will change if the ring is small..
> > >
> > > (Of course, another solution will be to re-negotiate features after init_vqs, but this will make a big mess, tons of things to clean and reconfigure)
> > >
> > >
> > > The 2 < ring < MAX_FRAGS + 2 part is ready, I have tested a few cases and it is working.
> > >
> > > I'm considering splitting the effort into 2 series.
> > > A 2 < ring < MAX_FRAGS + 2  series, and a follow up series with the ring < 2 case.
> > >
> > > I'm also thinking about sending the first series as an RFC soon, so it will be more broadly tested.
> > >
> > > What do you think?
> > 
> > Lots of work spilling over to transports.
> > 
> > And I especially don't like that it slows down boot on good path.
> 
> Yes, but I don't think that this is really significant.
> It's just a call to the transport to get the length of the VQs.

With lots of VQs that is lots of exits.

> If ring is not small, we continue as normal.
> If ring is small, we renegotiate and continue, without failing probe.
> 
> > 
> > I have the following idea:
> > - add a blocked features value in virtio_device
> > - before calling probe, core saves blocked features
> > - if probe fails, checks blocked features.
> >   if any were added, reset, negotiate all features
> >   except blocked ones and do the validate/probe dance again
> > 
> > 
> > This will mean mostly no changes to drivers: just check condition,
> > block feature and fail probe.
> > 
> 
> I like the idea, will try to implement it.
> 
> Thanks,

