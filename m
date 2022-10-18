Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBF8C603644
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 00:57:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbiJRW5F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 18:57:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbiJRW5E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 18:57:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D2176E887
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 15:57:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666133823;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=++gePNcxRlYQ7u6sjqQhm9MC+GRvONvqYTnuH8fpUXY=;
        b=Kzn2EQCnQcw/38vEypMAiro7UrDUkax63rZE/05sHeyOXN63UvvzlzJi5R8qKN2CLTk95X
        XHTOGEABPf+1+VL1n4GDMdZ/tt2+4NqVYQzcYf/JwVn7h3y6HLWSH4wbKy30vSQDEyP/nv
        /iHXx/7mFBrGW2GGzvSNUccd6oie8aI=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-148-F8Ll2NVhO4u8jVFhoT6B8A-1; Tue, 18 Oct 2022 18:57:01 -0400
X-MC-Unique: F8Ll2NVhO4u8jVFhoT6B8A-1
Received: by mail-wm1-f72.google.com with SMTP id n19-20020a7bcbd3000000b003c4a72334e7so7339496wmi.8
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 15:57:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=++gePNcxRlYQ7u6sjqQhm9MC+GRvONvqYTnuH8fpUXY=;
        b=ljgy4hUiTk7qvmR6Sc4R01nc4d3cpJ4+Q11n1r35rDkpDb+7MCSUqAIgSDJI6x1Kxt
         ij2z7XTLFUn9GI0HhnsxRX4McWn8VLBM2tBhInTozr7dFxPJZhFlbp4Fj2t79G5Gx0pP
         HpX7bYUyUrvJyh0W0uZyRQ5NEOshMfJUrG2pFn73QGca+dUCzzGd0kp6E6JRQ14FZh8a
         iv0vo8ii4z3uhCd0sGM0aBFmPtXEJL7LftjIrSf7GPVeH2vccuKKDMdU6ewRVmyfIvuI
         pn4IW+/UywPZ7nYJHBDPjugzKnN46plMtW6mC2pLI7RgE39gYg9eGSfoXFLzpg+ACVUn
         iYUQ==
X-Gm-Message-State: ACrzQf0/svt7jOrIPec9y3Lw2pLXqO7I9EujoZA0BIZPQnRdQVAtJAjd
        gZ5Ceum389nqBBj5gQyWNGhZ46rA0yaHyDvrCM6+yh2VoHuVTME6Nxo5lMTip+d/v2s6D/SuOcd
        mQ/6l8o3JVkR8x6OCSCW8ftMIW+fxDygZ
X-Received: by 2002:a05:600c:348f:b0:3c6:fff4:3a6a with SMTP id a15-20020a05600c348f00b003c6fff43a6amr2869456wmq.47.1666133820728;
        Tue, 18 Oct 2022 15:57:00 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6t9nDJj1v4/kC2hj0cxRwNrAzmRaV4HqZF/GiLji09cEXPDMjxC5pZcLLbkL+69C0AY1TegdgJj3f1nsx7l1c=
X-Received: by 2002:a05:600c:348f:b0:3c6:fff4:3a6a with SMTP id
 a15-20020a05600c348f00b003c6fff43a6amr2869442wmq.47.1666133820569; Tue, 18
 Oct 2022 15:57:00 -0700 (PDT)
MIME-Version: 1.0
References: <20221018183540.806471-1-miquel.raynal@bootlin.com>
 <CAK-6q+gRMG64Ra9ghAUVHXkJoGB1b5Kd6rLTiUK+UArbYhP+BA@mail.gmail.com> <20221019000329.2eacd502@xps-13>
In-Reply-To: <20221019000329.2eacd502@xps-13>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Tue, 18 Oct 2022 18:56:49 -0400
Message-ID: <CAK-6q+hB2883Jb=X90-wSj9PAhaAMQtxhbc3y2nYsMW5pb4ZvA@mail.gmail.com>
Subject: Re: [PATCH wpan-next v5] mac802154: Ensure proper scan-level filtering
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Guilhem Imberton <guilhem.imberton@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Tue, Oct 18, 2022 at 6:03 PM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> Hi Alexander,
>
> aahringo@redhat.com wrote on Tue, 18 Oct 2022 16:54:13 -0400:
>
> > Hi,
> >
> > On Tue, Oct 18, 2022 at 2:35 PM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> > >
> > > We now have a fine grained filtering information so let's ensure proper
> > > filtering in scan mode, which means that only beacons are processed.
> > >
> >
> > Is this a fixup? Can you resend the whole series please?
>
> Hmm no? Unless I understood things the wrong way, Stefan applied
> patches 1 to 7 of my v4, and asked me to make a change on the 8th
> patch.
>
> This is v5 just for patch 8/8 of the previous series, I just changed
> a debug string actually...
>

Okay, I see there are multiple new patches on the list, can you resend
them in one series? Then we have the right order how they need to be
applied without figuring it "somehow" out.

> There was a conflict when he applied it but I believe this is because
> wpan-next did not contain one of the fixes which made it to Linus' tree
> a month ago. So in my branch I still have this fix prior to this patch,
> because otherwise there will be a conflict when merging v6.1-rc1 (which
> I believe was not done yet).
>

I see. Thanks.

- Alex

