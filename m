Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38AFF7FC41
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 16:30:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394908AbfHBO37 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 10:29:59 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:35911 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726505AbfHBO37 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 10:29:59 -0400
Received: by mail-ed1-f66.google.com with SMTP id k21so72580634edq.3
        for <netdev@vger.kernel.org>; Fri, 02 Aug 2019 07:29:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6/YUk+s06hAVlFScFvuqBWrCMc7SbUqY5yZ8thAohgc=;
        b=YEeAa1MO/ZT/XDp6v5ZilE/cHNC23cJUFVL42exnPJkE17cDls7LUzePvMmvcojzKr
         PYJ5hl1WwwA6Izfc3TqctfJtebTD1PmD/XnePRCAkYj2Qhh/l2FLHCh/E3dFFqBR09bT
         mxHs/b4qleIWhCdQg+CPgcq2gX+RNczY/v5Js=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6/YUk+s06hAVlFScFvuqBWrCMc7SbUqY5yZ8thAohgc=;
        b=PVaHWxsQ/OtyzfpRfs7jQixRw0RnJDlE3out8OzctOBYB/YzR/yYOf8PW8RTC1stqT
         AhNMSDS8xRJNOxOMlHwO2a7XvwHkrLuqaMOarZLbE+bHWxDWlNUK9uIoKOCJiEDcv0U7
         m5CClXFiYEjY9AlqLqwGWjmChNq0h7iOLIQD1L7wmRXtLzvcwjm6goPaZvGDCeqKFuqT
         cBo3JZXf3I74tDUm/YpWe3kbh+3J8yxJyRZeWe3/mVeGMgymemj5pNpGrjTzfuD5NBFZ
         bDKqQRYa/y1pvHEOV5/tN/3iCj8MlerzgEYswB0z71m5O4ABRySPCAffH7qGY5y7wz8T
         hpGA==
X-Gm-Message-State: APjAAAVVZzViY5h2aW+kZRVcZB2FuHENGfe72JRJKB4U5tT1lOK+Ah0P
        T/i6xzNSDkWNt8TUJMxvn0qvVmcakvsRvhBKSA3SPw==
X-Google-Smtp-Source: APXvYqyUY9i0euJay/JliAcigHmKXHooCGBtq7aFqiFICEuaXx/CHRZG9wxmZ352bNLjpAuf1HlXOMlrgUO09DSQiIg=
X-Received: by 2002:a17:906:5399:: with SMTP id g25mr104653993ejo.247.1564756197376;
 Fri, 02 Aug 2019 07:29:57 -0700 (PDT)
MIME-Version: 1.0
References: <0a015a21-c1ae-e275-e675-431f08bece86@cumulusnetworks.com> <20190802105736.26767-1-nikolay@cumulusnetworks.com>
In-Reply-To: <20190802105736.26767-1-nikolay@cumulusnetworks.com>
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
Date:   Fri, 2 Aug 2019 07:29:46 -0700
Message-ID: <CAJieiUiPFYDoi=AuFURNEuxNmkcVq5jcEVyDq5Ei1=i5tZ4nSA@mail.gmail.com>
Subject: Re: [PATCH net v4] net: bridge: move default pvid init/deinit to NETDEV_REGISTER/UNREGISTER
To:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Cc:     netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        bridge@lists.linux-foundation.org,
        michael-dev <michael-dev@fami-braun.de>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 2, 2019 at 3:57 AM Nikolay Aleksandrov
<nikolay@cumulusnetworks.com> wrote:
>
> Most of the bridge device's vlan init bugs come from the fact that its
> default pvid is created at the wrong time, way too early in ndo_init()
> before the device is even assigned an ifindex. It introduces a bug when the
> bridge's dev_addr is added as fdb during the initial default pvid creation
> the notification has ifindex/NDA_MASTER both equal to 0 (see example below)
> which really makes no sense for user-space[0] and is wrong.
> Usually user-space software would ignore such entries, but they are
> actually valid and will eventually have all necessary attributes.
> It makes much more sense to send a notification *after* the device has
> registered and has a proper ifindex allocated rather than before when
> there's a chance that the registration might still fail or to receive
> it with ifindex/NDA_MASTER == 0. Note that we can remove the fdb flush
> from br_vlan_flush() since that case can no longer happen. At
> NETDEV_REGISTER br->default_pvid is always == 1 as it's initialized by
> br_vlan_init() before that and at NETDEV_UNREGISTER it can be anything
> depending why it was called (if called due to NETDEV_REGISTER error
> it'll still be == 1, otherwise it could be any value changed during the
> device life time).
>
> For the demonstration below a small change to iproute2 for printing all fdb
> notifications is added, because it contained a workaround not to show
> entries with ifindex == 0.
> Command executed while monitoring: $ ip l add br0 type bridge
> Before (both ifindex and master == 0):
> $ bridge monitor fdb
> 36:7e:8a:b3:56:ba dev * vlan 1 master * permanent
>
> After (proper br0 ifindex):
> $ bridge monitor fdb
> e6:2a:ae:7a:b7:48 dev br0 vlan 1 master br0 permanent
>
> v4: move only the default pvid init/deinit to NETDEV_REGISTER/UNREGISTER
> v3: send the correct v2 patch with all changes (stub should return 0)
> v2: on error in br_vlan_init set br->vlgrp to NULL and return 0 in
>     the br_vlan_bridge_event stub when bridge vlans are disabled
>
> [0] https://bugzilla.kernel.org/show_bug.cgi?id=204389
>
> Reported-by: michael-dev <michael-dev@fami-braun.de>
> Fixes: 5be5a2df40f0 ("bridge: Add filtering support for default_pvid")
> Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>

Acked-by: Roopa Prabhu <roopa@cumulusnetworks.com>
