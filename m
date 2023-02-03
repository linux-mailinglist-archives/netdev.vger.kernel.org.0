Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12F99689EE4
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 17:06:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232877AbjBCQF5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 11:05:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233010AbjBCQFz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 11:05:55 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26B7A9EE14
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 08:05:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675440307;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0L59+pNfEZIN5gOwrLsRUSpQin4oZBtWA5b003EaTd4=;
        b=HD/LDVpCqDiFwVurEpRveTvFEsARDTWCin1RQCa2SEcMJuBZBVjMp5IFJwTv9J6ZScFX+c
        Wpla8MewI5J2W0Z1neDesl4SKlZlD8o8jVLbCX2dqQLTCJyV/ze4nVqkYA5IUMKHNvjJKH
        SQEbfKb1p+dqeRCiWYryggwMVn17F7E=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-567-A5fk2BBbO2aBc77400nh3g-1; Fri, 03 Feb 2023 11:05:06 -0500
X-MC-Unique: A5fk2BBbO2aBc77400nh3g-1
Received: by mail-pf1-f198.google.com with SMTP id k14-20020aa7972e000000b00593a8232ac3so2904029pfg.22
        for <netdev@vger.kernel.org>; Fri, 03 Feb 2023 08:05:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0L59+pNfEZIN5gOwrLsRUSpQin4oZBtWA5b003EaTd4=;
        b=BLkQNaY0seXOt5OfgGSDxTCMtIkNduvQRIsT6JDVCyiP+MaMNKRF5UD/JYnkmrKpWd
         oPe9K/A6AXelYgWJ43jvyF6Lmsr0Hkl5e9GbAqauoCSOFKLBP5DaIUGErAQlh5XPY6ph
         mmN8zfX1uIKRQQzdJSXoKxQ9U6ZeWgDAYpZytUcH5Wsq0ma/deJU+fqO0FEXC1/Y+mSn
         pQtl+MNvJc8rsrGTeLht0V7Ah/XJ9d12wZvpyt3TaXA+yFDYd0Mp538mmlr4N0CYaEjW
         YUiow81XkvrtQUdlbVexv8vBrQq4fVPEZT1MXyyG9feMVgcLcQADOtdiDXLdOxRTsbkf
         pQXA==
X-Gm-Message-State: AO0yUKXg7Vs+mbTzniirPK6Mtcb6zTJnbG0RRpbIXr5wvjuGHSXV0u+l
        QjO4UdgTrbZfRSm3lAhrWl3ng6hjD8eV0iPCzJ8LWAV20YLrzKPnqJ2rni6Y41ntsG3wRH+qk0n
        srbhFS8332thh8zqO4U2JHtD2wCnJUsNb
X-Received: by 2002:a17:90a:ce14:b0:22c:7479:a111 with SMTP id f20-20020a17090ace1400b0022c7479a111mr1365036pju.50.1675440305380;
        Fri, 03 Feb 2023 08:05:05 -0800 (PST)
X-Google-Smtp-Source: AK7set/Z3ThwsJaOstRhwrIKRFhY6KVSX2QglHn5YNqHpCWkDCmVQg0RyQ4Fa9mFPJv0FeVDjgeDY2cxonQFw1cM9E8=
X-Received: by 2002:a17:90a:ce14:b0:22c:7479:a111 with SMTP id
 f20-20020a17090ace1400b0022c7479a111mr1365027pju.50.1675440305100; Fri, 03
 Feb 2023 08:05:05 -0800 (PST)
MIME-Version: 1.0
References: <69d0ff33-bd32-6aa5-d36c-fbdc3c01337c@redhat.com>
 <Y9vly2QNCxl3d2QL@localhost> <Y9xQ8ikvkWjjuw2p@hoboy.vegasvil.org>
In-Reply-To: <Y9xQ8ikvkWjjuw2p@hoboy.vegasvil.org>
From:   =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>
Date:   Fri, 3 Feb 2023 17:04:53 +0100
Message-ID: <CACT4oudV-rA0ViZy5tWkvTufYji3bZzUyXcU0tTB67GjsvcvFw@mail.gmail.com>
Subject: Re: PTP vclock: BUG: scheduling while atomic
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Miroslav Lichvar <mlichvar@redhat.com>, netdev@vger.kernel.org,
        yangbo.lu@nxp.com, gerhard@engleder-embedded.com,
        habetsm.xilinx@gmail.com, ecree.xilinx@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, alex.maftei@amd.com,
        Jacob Keller <jacob.e.keller@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 3, 2023 at 1:10 AM Richard Cochran <richardcochran@gmail.com> w=
rote:
>
> On Thu, Feb 02, 2023 at 05:33:15PM +0100, Miroslav Lichvar wrote:
> > On Thu, Feb 02, 2023 at 05:02:07PM +0100, =C3=8D=C3=B1igo Huguet wrote:
> > > Our QA team was testing PTP vclocks, and they've found this error wit=
h sfc NIC/driver:
> > >   BUG: scheduling while atomic: ptp5/25223/0x00000002
> > >
> > > The reason seems to be that vclocks disable interrupts with `spin_loc=
k_irqsave` in
> > > `ptp_vclock_gettime`, and then read the timecounter, which in turns e=
nds calling to
> > > the driver's `gettime64` callback.
> >
> > The same issue was observed with the ice driver:
> > https://lists.osuosl.org/pipermail/intel-wired-lan/Week-of-Mon-20221107=
/030633.html
> >
> > I tried to fix it generally in the vclock support, but was not
> > successful. There was a hint it would be fixed in the driver. I'm not
> > sure what is the best approach here.
>
> Can ptp_vclock_gettime use a mutex instead?

I don't see any place where these vclock functions are called in
atomic context, so it might be possible, but there are many callback
indirections and I'm not sure if I might have missed any.

>
> Thanks,
> Richard
>


--=20
=C3=8D=C3=B1igo Huguet

