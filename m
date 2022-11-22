Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2E836337F3
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 10:07:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233131AbiKVJHb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 04:07:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233179AbiKVJHU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 04:07:20 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBD0418B3E
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 01:06:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669107975;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wXCLVuWe4heHUFwjtIeuGbx591KChmJODX4iIb4c9Gw=;
        b=TshBEE3bagV1ObKt0m1zjuLeoFfIaCBwZDCazoHeoDUi39VADNbztE0CN/1rVjBoXBWVJD
        ZD3OeytY1gvIKkAGEGNJOIld6kYS57ogTbLminoUP3Mts6pvSrAQyd9t5DwKJlmfadX+3M
        575QZL+Gignw0lQFD284KFmTstrXDE8=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-623-2TbcRwzaPxiDnxxA-5i7Og-1; Tue, 22 Nov 2022 04:06:13 -0500
X-MC-Unique: 2TbcRwzaPxiDnxxA-5i7Og-1
Received: by mail-io1-f70.google.com with SMTP id n19-20020a6b7713000000b006dee0b795a5so2458842iom.18
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 01:06:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wXCLVuWe4heHUFwjtIeuGbx591KChmJODX4iIb4c9Gw=;
        b=mr9Z1O3MueGWpShqq/RAAwuZjDMLl/qVYARdrSTjoiYVt8QfXLsIvTYtytxOnNAr9o
         3sJQrRvnKjovkASOwfAs1AiNmExEmsVx/fR4YKuhlL0Rwd6SuUzMo1PtI1gNkhQV6Sfq
         WxJWP1C2GAl5pyfZXOKzIO0jkY5fjjeKqzlLzhzQOIDEcBJJ+Eii19CWFaIe14Y7aL7m
         mim+AdGQUsEaT4Dx7K3ASKI2WdfWrK7qvDibGa7e7WxCQ9MA3V9O83XjDDzwAVdth4D5
         bqJXPb2DaJna7iR2JWSYqk7Kd5OBUEPdQiw+7KL7YU9oQqMpEwCft0p6YJLIzgdkrVY/
         lbiQ==
X-Gm-Message-State: ANoB5pkgAErWDp8p+FHcCm5IneMJBMJkfaKEvWoBcf++a9JavE4HwjjR
        3mXA6abA+DpbGLdtCoiuPWjl1lX0258g4hTksFRso78Mr1de8lcSetjhTpO2qFrwOMBXxoNJRr8
        Rg2+DNPAlX55RXbyZAF7hsKuZ74mBB2ym
X-Received: by 2002:a02:a089:0:b0:375:2a78:73fd with SMTP id g9-20020a02a089000000b003752a7873fdmr9902552jah.217.1669107973170;
        Tue, 22 Nov 2022 01:06:13 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5XLS+3PYA1IYMmdQ1qcqimc0kUtHimM+dxwtQiTWi3mGlBhbBtZRrTK8mQms5cphCXnrDZPZ6Sm1TrCQKNxxk=
X-Received: by 2002:a02:a089:0:b0:375:2a78:73fd with SMTP id
 g9-20020a02a089000000b003752a7873fdmr9902539jah.217.1669107972919; Tue, 22
 Nov 2022 01:06:12 -0800 (PST)
MIME-Version: 1.0
References: <20221122034246.24408-1-yuehaibing@huawei.com> <29fb52c0-155b-470e-10d5-5e3b2451272d@molgen.mpg.de>
In-Reply-To: <29fb52c0-155b-470e-10d5-5e3b2451272d@molgen.mpg.de>
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
Date:   Tue, 22 Nov 2022 10:06:01 +0100
Message-ID: <CAO-hwJKraiox13k=ukXOhSNt9sTc6Q0KpGR5=AHDknZeR6omwA@mail.gmail.com>
Subject: Re: [PATCH -next] Bluetooth: Fix Kconfig warning for BT_HIDP
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     YueHaibing <yuehaibing@huawei.com>, marcel@holtmann.org,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        jkosina@suse.cz, gregkh@linuxfoundation.org,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Tue, Nov 22, 2022 at 9:37 AM Paul Menzel <pmenzel@molgen.mpg.de> wrote:
>
> Dear YueHaibing,
>
>
> Thank you for your patch.
>
>
> Am 22.11.22 um 04:42 schrieb YueHaibing:
>
> Maybe use the more specific summary below:
>
> Bluetooth: Add HID_SUPPORT dependency for BT_HIDP
>
> > commit 25621bcc8976 add HID_SUPPORT, and HID depends on it now.
>
> add*s*
>
> or
>
> Commit 25621bcc8976 ("HID: Kconfig: split HID support and hid-core
> compilation") introduces the new Kconfig symbol HID_SUPPORT =E2=80=A6
>
>
> Kind regards,
>
> Paul
>
>
> > Add HID_SUPPORT dependency for BT_HIDP to fix the warning:
> >
> > WARNING: unmet direct dependencies detected for HID
> >    Depends on [n]: HID_SUPPORT [=3Dn]
> >    Selected by [m]:
> >    - BT_HIDP [=3Dm] && NET [=3Dy] && BT_BREDR [=3Dy] && INPUT [=3Dm]
> >
> > Fixes: 25621bcc8976 ("HID: Kconfig: split HID support and hid-core comp=
ilation")
> > Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> > ---


FWIW, a fix is already in -next:
https://git.kernel.org/pub/scm/linux/kernel/git/hid/hid.git/commit/?h=3Dfor=
-6.2/hid-bpf&id=3D6cc90ccd4f6cfed98e2a3a378debc69f28d57473

 But thanks for the patch nonetheless!

Cheers,
Benjamin

>
> >   net/bluetooth/hidp/Kconfig | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/net/bluetooth/hidp/Kconfig b/net/bluetooth/hidp/Kconfig
> > index 14100f341f33..6746be07e222 100644
> > --- a/net/bluetooth/hidp/Kconfig
> > +++ b/net/bluetooth/hidp/Kconfig
> > @@ -1,7 +1,7 @@
> >   # SPDX-License-Identifier: GPL-2.0-only
> >   config BT_HIDP
> >       tristate "HIDP protocol support"
> > -     depends on BT_BREDR && INPUT
> > +     depends on BT_BREDR && INPUT && HID_SUPPORT
> >       select HID
> >       help
> >         HIDP (Human Interface Device Protocol) is a transport layer
>

