Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DF7B680247
	for <lists+netdev@lfdr.de>; Sun, 29 Jan 2023 23:34:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234780AbjA2WeW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Jan 2023 17:34:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235419AbjA2WeV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Jan 2023 17:34:21 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B2D214EBB
        for <netdev@vger.kernel.org>; Sun, 29 Jan 2023 14:33:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675031614;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/vCgiIjpi7lDX2G2pl/mU/xcfS28czOyjP9ouExjW/I=;
        b=ZBrvzfMgL35Y4ZrunP+UCDkDYgegcwbn+8Cy8DCD47X9sjpfNkZ3pIirgErzhAhCqF45mN
        GhzUq0HZ7BG4YrAtmwhRfpAgM3c4x7qQGbwxI0Ic4Jro8GJ8w5294MhvT/6tmaTFa42PJB
        LiE/JPFx+mj3jjCRCpFEb5fYBPRVnaY=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-536-ky1rIlDoNxmMahXm8Ek9Og-1; Sun, 29 Jan 2023 17:33:30 -0500
X-MC-Unique: ky1rIlDoNxmMahXm8Ek9Og-1
Received: by mail-wm1-f71.google.com with SMTP id iv6-20020a05600c548600b003dc4b8ee42fso2524857wmb.1
        for <netdev@vger.kernel.org>; Sun, 29 Jan 2023 14:33:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/vCgiIjpi7lDX2G2pl/mU/xcfS28czOyjP9ouExjW/I=;
        b=f3DlMTEoB0xcgO4gxWUBCEhHR9fr9cN31WsmMamnhiplvLajE7i3pm3BR44wxKcBUe
         geM1jTRrnMhYx4PJteZEcAQ0yzLKz3gUwJMAQSyFQBW4Mes8wUG/qIZH/XtN+ZKodqA9
         E6XIXUQIUjVUtM6brUdquyFeZKuIdNTAqblzPGwWkF+XtANAvqiZ7jZzsts0yfQT/hRs
         s7WjrWH4dDktiqA0mDwG1WZ6CSGiFJVwoEpAKE7Z+mNwpdzSGGkNydNqZWbUDeTIeNMp
         uuWuxy/CL5/bV/AeXbKit51AlTcCavPL55h0k2/X5ZEB069C82mBiYm7cM+6SfNlcV4y
         S34g==
X-Gm-Message-State: AO0yUKX92zDkcFDV+YUA9hlshU7NBKlb4PXLOfiDzXYYBJ3BGHzKiAEK
        mHkQELPxybEXzz8drxjjLjxV2LBCGFbT1t4Y0tBhYFN7xRnZr0OnWuyZiyyuS2skBOl8WFCzZDR
        kyd3MkyFvgtiQrNRP
X-Received: by 2002:adf:a504:0:b0:2bf:ae0e:23d8 with SMTP id i4-20020adfa504000000b002bfae0e23d8mr19938615wrb.32.1675031609460;
        Sun, 29 Jan 2023 14:33:29 -0800 (PST)
X-Google-Smtp-Source: AK7set8I7BUkRtGi/Rxw0hzJh9BWvW50ICv0ytFQopbAPGiDJ0T7eGj+CJs02SjD3RVR4wxiLoWToQ==
X-Received: by 2002:adf:a504:0:b0:2bf:ae0e:23d8 with SMTP id i4-20020adfa504000000b002bfae0e23d8mr19938603wrb.32.1675031609234;
        Sun, 29 Jan 2023 14:33:29 -0800 (PST)
Received: from redhat.com ([2.52.20.248])
        by smtp.gmail.com with ESMTPSA id f12-20020adfdb4c000000b002bfb1de74absm10168012wrj.114.2023.01.29.14.33.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Jan 2023 14:33:26 -0800 (PST)
Date:   Sun, 29 Jan 2023 17:33:23 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Eric Auger <eric.auger@redhat.com>
Cc:     eric.auger.pro@gmail.com, jasowang@redhat.com, kvm@vger.kernel.org,
        netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        peterx@redhat.com, lvivier@redhat.com
Subject: Re: [PATCH 0/2] vhost/net: Clear the pending messages when the
 backend is removed
Message-ID: <20230129173240-mutt-send-email-mst@kernel.org>
References: <20230117151518.44725-1-eric.auger@redhat.com>
 <3fe5971a-5991-488f-cef5-473c9faa1ba1@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3fe5971a-5991-488f-cef5-473c9faa1ba1@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 29, 2023 at 06:58:09PM +0100, Eric Auger wrote:
> Hi,
> 
> On 1/17/23 16:15, Eric Auger wrote:
> > When the vhost iotlb is used along with a guest virtual iommu
> > and the guest gets rebooted, some MISS messages may have been
> > recorded just before the reboot and spuriously executed by
> > the virtual iommu after the reboot. This is due to the fact
> > the pending messages are not cleared.
> >
> > As vhost does not have any explicit reset user API,
> > VHOST_NET_SET_BACKEND looks a reasonable point where to clear
> > the pending messages, in case the backend is removed (fd = -1).
> >
> > This version is a follow-up on the discussions held in [1].
> >
> > The first patch removes an unused 'enabled' parameter in
> > vhost_init_device_iotlb().
> 
> Gentle Ping. Does it look a reasonable fix now?
> 
> Thanks
> 
> Eric

Yes I applied this - giving it a bit of time in next.

> >
> > Best Regards
> >
> > Eric
> >
> > History:
> > [1] RFC: [RFC] vhost: Clear the pending messages on vhost_init_device_iotlb()
> > https://lore.kernel.org/all/20221107203431.368306-1-eric.auger@redhat.com/
> >
> > Eric Auger (2):
> >   vhost: Remove the enabled parameter from vhost_init_device_iotlb
> >   vhost/net: Clear the pending messages when the backend is removed
> >
> >  drivers/vhost/net.c   | 5 ++++-
> >  drivers/vhost/vhost.c | 5 +++--
> >  drivers/vhost/vhost.h | 3 ++-
> >  3 files changed, 9 insertions(+), 4 deletions(-)
> >

