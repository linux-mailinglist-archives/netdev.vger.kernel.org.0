Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFDFC6AAEE3
	for <lists+netdev@lfdr.de>; Sun,  5 Mar 2023 10:54:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbjCEJyw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Mar 2023 04:54:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbjCEJyv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Mar 2023 04:54:51 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24FB7A5FD
        for <netdev@vger.kernel.org>; Sun,  5 Mar 2023 01:54:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678010045;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zZ1FRbEzDhg7eiI4sxCa3iFgs3/LMEjHpvregVmhCSg=;
        b=frZEOw7tGhYHFMuUwPJpmgvB5kENa87clBxOBlT3YVfd0PKk4HrWAqoogAJj9T5CFoFBff
        GJsz0qw9SgnXVSG5+yhHQ6YkNlNiv/mH4vP429egBwZhY2QcPZ/84uIntfkIo2vtAwjH9u
        CvMgoI3lJ8FcZ4G0L6UYHyTxhJMgvjI=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-458-rdJ3u0gBOQyZ38YowrzjlQ-1; Sun, 05 Mar 2023 04:54:03 -0500
X-MC-Unique: rdJ3u0gBOQyZ38YowrzjlQ-1
Received: by mail-wr1-f71.google.com with SMTP id bh3-20020a05600005c300b002c70d6e2014so951726wrb.10
        for <netdev@vger.kernel.org>; Sun, 05 Mar 2023 01:54:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678010042;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zZ1FRbEzDhg7eiI4sxCa3iFgs3/LMEjHpvregVmhCSg=;
        b=iHL03CViebB4emjYli0q/Ctooc55ib/0JkHctnuN450hsBwNDgwvQn7qKAXPZYBk9O
         TKUh3uY5qxc0AoK4vVfk0i4zbbDaXjpI+Hhxk8Dd50u2H0y0HiGX17iJbaO4kaYH7Lc9
         J+4KdpIpGw4WYhtyYC2UQ8wbnuPCpEy6nT4H40UA2UaCxS8EJrBSksQT6kvIl2xdWEZc
         LPlgEW1VdXgY9LNCV9Xe1d9R2mJMSEgn6fdZNAEcMX8BKm/NXGLMExvMLH85uyNhPWFn
         pPEXrepiLXFTBbj9WDFJix21GawrTDljAuJ7p+gknzVN8TFrOxFUfe2cahtN0Fq3TIym
         bwJw==
X-Gm-Message-State: AO0yUKUEm1c1xkXitw14yvQr2ydlzzXYIwFSgOB5PBYJbNFmq+ixKthM
        DYvoxxaO35GckCXLlhNmCdDthcmZBTKLP3tAygakKSRX95CJyhuF5ThrBpR6Y2NeKt9B+0YGF14
        0VzkupaTW+o0pABdt
X-Received: by 2002:adf:fc0d:0:b0:2c7:1e3b:2d46 with SMTP id i13-20020adffc0d000000b002c71e3b2d46mr4900200wrr.17.1678010042430;
        Sun, 05 Mar 2023 01:54:02 -0800 (PST)
X-Google-Smtp-Source: AK7set8IoOS6Gx/WJKStkNGfdBuK7UXUinqGFeitKJGyU7CYQyNcgwXAwkQ7nJs7SEFHzH1aVenCxA==
X-Received: by 2002:adf:fc0d:0:b0:2c7:1e3b:2d46 with SMTP id i13-20020adffc0d000000b002c71e3b2d46mr4900192wrr.17.1678010042180;
        Sun, 05 Mar 2023 01:54:02 -0800 (PST)
Received: from redhat.com ([2.52.23.160])
        by smtp.gmail.com with ESMTPSA id k8-20020a5d66c8000000b002c573a6216fsm6984304wrw.37.2023.03.05.01.54.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Mar 2023 01:54:01 -0800 (PST)
Date:   Sun, 5 Mar 2023 04:53:58 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jason Wang <jasowang@redhat.com>, rbradford@rivosinc.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] virtio-net: Fix probe of virtio-net on kvmtool
Message-ID: <20230305045249-mutt-send-email-mst@kernel.org>
References: <20230223-virtio-net-kvmtool-v3-1-e038660624de@rivosinc.com>
 <20230301093054-mutt-send-email-mst@kernel.org>
 <CACGkMEsG10CWigz+S6JgSVK8XfbpT=L=30hZ8LDvohtaanAiZQ@mail.gmail.com>
 <20230302044806-mutt-send-email-mst@kernel.org>
 <20230303164603.7b35a76f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230303164603.7b35a76f@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 03, 2023 at 04:46:03PM -0800, Jakub Kicinski wrote:
> On Thu, 2 Mar 2023 04:48:38 -0500 Michael S. Tsirkin wrote:
> > > Looks not the core can try to enable and disable features according to
> > > the diff between features and hw_features
> > > 
> > > static inline netdev_features_t netdev_get_wanted_features(
> > >         struct net_device *dev)
> > > {
> > >         return (dev->features & ~dev->hw_features) | dev->wanted_features;
> > > }
> > 
> > yes what we do work according to code.  So the documentation is wrong then?
> 
> It's definitely incomplete but which part are you saying is wrong?

So it says:
  2. netdev->features set contains features which are currently enabled
     for a device.

ok so far.
But this part:

  This should be changed only by network core or in
     error paths of ndo_set_features callback.

seems to say virtio should not touch netdev->features, no?

-- 
MST

