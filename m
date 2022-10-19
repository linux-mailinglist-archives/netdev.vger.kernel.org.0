Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C8996044E0
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 14:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232624AbiJSMR1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 08:17:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232901AbiJSMRH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 08:17:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C85DF9868
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 04:52:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666180248;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=U0Ito9oBTwecyhoOGkvM7eQkEImsAA6dypnkM5tOFSU=;
        b=K5NFgm4Ai7lDgasI13MrWWqMMEFe3nyexCGdp7dPscz3q6CKFC8T2wUOIhl0NDalo2ww4l
        G4HJLdTaPxOqIrBI7FkyPb288By8BAVXnDsQJRsFyI8SUi0N/XmiUOM9kfC2arQHV9B/rv
        J5kcp5JeGejtW6Os9aF4TBtcy1quE/k=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-651-VkAADPd6MhGEzxakl7Ec8g-1; Wed, 19 Oct 2022 07:50:47 -0400
X-MC-Unique: VkAADPd6MhGEzxakl7Ec8g-1
Received: by mail-wm1-f72.google.com with SMTP id o18-20020a05600c4fd200b003c6ceb1339bso445337wmq.1
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 04:50:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U0Ito9oBTwecyhoOGkvM7eQkEImsAA6dypnkM5tOFSU=;
        b=6wC76S8rKxXsy3Rkuu8jGdRJPST6rRrkTW68QMXx5jpSwDiQ4Emmv8hsya+9aJ/R7o
         WtK/sRvgXUkVWXJYDxV6xzkPfi+IALiFV/Z819/UMVdq0ILZNLyXVi0eoreqncfpW57C
         EkgcKdttNXeNjPhuD1w63U5S7VaNcT798CtFNUpyR+cGQMxICDiK0vnldkca+8jcNLdF
         FS6FTZqn6cMz3fIsJsYqWnRtsHP0rBM3mUpS8hZGVE7NvrWJBDAazsWUx4MtZ5Iyc5Et
         JRH2ixR3N9YGLkesomnflYyEN6TysH5XRXNxu1E+38LEgwqa9rs6OXSG2+0OTPXmd78I
         nlmQ==
X-Gm-Message-State: ACrzQf2REUU3c+qWy7JW+T04vt9xrB1kaaTmbCDLnFp4UR76+9tU1yi5
        0BQ2argghkk5THQf0iuMsox68D+d+mTeIu2+5DzEnJYauN0YmCHlTFdHrCKHulCpuvSJHA7TLUz
        Bhr9LVYUy3Vxp47S8
X-Received: by 2002:adf:f40e:0:b0:22e:2ce4:e6a2 with SMTP id g14-20020adff40e000000b0022e2ce4e6a2mr5230955wro.30.1666180246162;
        Wed, 19 Oct 2022 04:50:46 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM46+3jUTqcGiLRotFZdSsYsXxrsUcvAJFYWAwhfGL5+lnqYoZHaA3KZlDHoCCIDDoqAzIcPIw==
X-Received: by 2002:adf:f40e:0:b0:22e:2ce4:e6a2 with SMTP id g14-20020adff40e000000b0022e2ce4e6a2mr5230933wro.30.1666180245888;
        Wed, 19 Oct 2022 04:50:45 -0700 (PDT)
Received: from redhat.com ([2.54.191.184])
        by smtp.gmail.com with ESMTPSA id d20-20020a05600c34d400b003b4de550e34sm16769319wmq.40.2022.10.19.04.50.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Oct 2022 04:50:45 -0700 (PDT)
Date:   Wed, 19 Oct 2022 07:50:42 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Christian Borntraeger <borntraeger@linux.ibm.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        kvm list <kvm@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Yury Norov <yury.norov@gmail.com>, netdev@vger.kernel.org
Subject: Re: 6.1-rc1 regression: virtio-net cpumask and during reboot
Message-ID: <20221019074308-mutt-send-email-mst@kernel.org>
References: <ac72ff9d-4246-3631-6e31-8c3033a70bf0@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac72ff9d-4246-3631-6e31-8c3033a70bf0@linux.ibm.com>
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 19, 2022 at 12:59:58PM +0200, Christian Borntraeger wrote:
> Michael,
> 
> as a heads-up.
> I have not looked into any details yet but we do get the following during reboot of a system on s390.
> It seems to be new with 6.1-rc1 (over 6.0)
> 
>   [    8.532461] ------------[ cut here ]------------
>   [    8.532497] WARNING: CPU: 8 PID: 377 at include/linux/cpumask.h:110 __netif_set_xps_queue+0x3d8/0xca8
>   [    8.532507] Modules linked in: sha1_s390(+) sha_common virtio_net(+) net_failover failover pkey zcrypt rng_core autofs4
>   [    8.532528] CPU: 8 PID: 377 Comm: systemd-udevd Not tainted 6.1.0-20221018.rc1.git15.0fd5f2557625.300.fc36.s390x+debug #1
>   [    8.532533] Hardware name: IBM 8561 T01 701 (KVM/Linux)
>   [    8.532537] Krnl PSW : 0704e00180000000 00000000b05ec33c (__netif_set_xps_queue+0x3dc/0xca8)
>   [    8.532546]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:2 PM:0 RI:0 EA:3
>   [    8.532552] Krnl GPRS: 00000000e7fb8b3f 0000000080000001 00000000b1870700 00000000b0ca1d3c
>   [    8.532557]            0000000000000100 0000000000000300 000000008b362500 00000000b133ba48
>   [    8.532561]            000000000000000c 0000038000000100 000000000000000c 0000000000000070
>   [    8.532566]            0000000084cd3200 0000000000000000 00000000b05ec0c2 00000380010b77c8
>   [    8.532575] Krnl Code: 00000000b05ec32e: c0e500187331      brasl   %r14,00000000b08fa990
>                             00000000b05ec334: a7f4ff0c          brc     15,00000000b05ec14c
>                            #00000000b05ec338: af000000          mc      0,0
>                            >00000000b05ec33c: ec76fed8007c      cgij    %r7,0,6,00000000b05ec0ec
>                             00000000b05ec342: e310f0b00004      lg      %r1,176(%r15)
>                             00000000b05ec348: ec16ffac007c      cgij    %r1,0,6,00000000b05ec2a0
>                             00000000b05ec34e: ec680388007c      cgij    %r6,0,8,00000000b05eca5e
>                             00000000b05ec354: e310f0b80004      lg      %r1,184(%r15)
>   [    8.532600] Call Trace:
>   [    8.532604]  [<00000000b05ec33c>] __netif_set_xps_queue+0x3dc/0xca8
>   [    8.532609] ([<00000000b05ec0c2>] __netif_set_xps_queue+0x162/0xca8)
>   [    8.532614]  [<000003ff7fbb81ce>] virtnet_set_affinity+0x1de/0x2a0 [virtio_net]
>   [    8.532622]  [<000003ff7fbbb674>] virtnet_probe+0x4d4/0xc08 [virtio_net]
>   [    8.532630]  [<00000000b04ec4e8>] virtio_dev_probe+0x1e8/0x418
>   [    8.532638]  [<00000000b05350ea>] really_probe+0xd2/0x480
>   [    8.532644]  [<00000000b0535648>] driver_probe_device+0x40/0xf0
>   [    8.532649]  [<00000000b0535fac>] __driver_attach+0x10c/0x208
>   [    8.532655]  [<00000000b0532542>] bus_for_each_dev+0x82/0xb8
>   [    8.532662]  [<00000000b053422e>] bus_add_driver+0x1d6/0x260
>   [    8.532667]  [<00000000b0536a70>] driver_register+0xa8/0x170
>   [    8.532672]  [<000003ff7fbc8088>] virtio_net_driver_init+0x88/0x1000 [virtio_net]
>   [    8.532680]  [<00000000afb50ab0>] do_one_initcall+0x78/0x388
>   [    8.532685]  [<00000000afc7b5b8>] do_init_module+0x60/0x248
>   [    8.532692]  [<00000000afc7ce96>] __do_sys_init_module+0xbe/0xd8
>   [    8.532698]  [<00000000b09123b2>] __do_syscall+0x1da/0x208
>   [    8.532704]  [<00000000b0925b12>] system_call+0x82/0xb0
>   [    8.532710] 3 locks held by systemd-udevd/377:
>   [    8.532715]  #0: 0000000089af5188 (&dev->mutex){....}-{3:3}, at: __driver_attach+0xfe/0x208
>   [    8.532728]  #1: 00000000b14668f0 (cpu_hotplug_lock){++++}-{0:0}, at: virtnet_probe+0x4ca/0xc08 [virtio_net]
>   [    8.532744]  #2: 00000000b1509d40 (xps_map_mutex){+.+.}-{3:3}, at: __netif_set_xps_queue+0x88/0xca8
>   [    8.532757] Last Breaking-Event-Address:
>   [    8.532760]  [<00000000b05ec0e0>] __netif_set_xps_queue+0x180/0xca8


Does this fix it for you?

https://lore.kernel.org/r/20221017030947.1295426-1-yury.norov%40gmail.com








-- 
MST

