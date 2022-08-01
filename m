Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A00F58749D
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 01:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234446AbiHAX7A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 19:59:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbiHAX67 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 19:58:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 55E1B24BD2
        for <netdev@vger.kernel.org>; Mon,  1 Aug 2022 16:58:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659398337;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LM5x9879Wci4vC1mMK72JhyNI4ToAQ+rR4Qkc1H6vrM=;
        b=QltNzYTEbdTC5jYheXi5IXRx6oDjzA6X2yp/YXAOTKyhld3PRuCcQZUnk1/5EHzltX/CZD
        uRKVm92eXcIR2xxXckAT516pE9dQH5213dTXNKGPlydDha8UYstz66TCAGJAk40ErZOxJC
        RQvvwgu/pK2Gh5KII8GDE8Mj4HC5gqE=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-399-c_axyx8qO_etiiS6mM9Maw-1; Mon, 01 Aug 2022 19:58:56 -0400
X-MC-Unique: c_axyx8qO_etiiS6mM9Maw-1
Received: by mail-qk1-f197.google.com with SMTP id m8-20020a05620a24c800b006b5d8eb23efso10433186qkn.10
        for <netdev@vger.kernel.org>; Mon, 01 Aug 2022 16:58:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=LM5x9879Wci4vC1mMK72JhyNI4ToAQ+rR4Qkc1H6vrM=;
        b=HLmozSAvM0U7Zu/Bk3RBmNOjQdcF9TGMTWVhZDfROM8HKZQQ1xDD6rflT/iNLsaEA7
         jaDs0P3p6r+C5AR4Bxp2c/5wVjKsB8sJrMGrLyGMBQm7nvGcau7BFYkZTLsxQPGQPbYM
         bOHBrAuYSBPqMr9kJGqUzuiv2ZaZ1NdWSKmAvg4z1p8Oh6kS1xUcusOgIANbN2Y6OXD/
         q10tdxb8hbJ1ZDFxzK8EPrARWrUMceHDo+H0qriikguNnyTRhPGb0sfEj4pvsrd+i8Of
         rZm8M1jsJFrt/54IGS7wXrarBeW3O4KHj5OrYWHq6WqO2UZJ1sdDlVnh7cnY6faTPSUB
         bxvA==
X-Gm-Message-State: AJIora+7LKic09lHqGCOUcWGFzE1DkQlfIg9Oe8ofGXL7RDjEce3KBSa
        485m+go+pWa1hB1qi8iEuIuWylWc9RHT0D1ledBt7501Ofl24knVAEiSYZaxcB2eDrr9UHTx6zi
        yi3E0bvl3Nbxa6Ua/ONPJgoUH/uFJ8+To
X-Received: by 2002:a05:620a:f13:b0:6b5:b956:c1f1 with SMTP id v19-20020a05620a0f1300b006b5b956c1f1mr13619147qkl.691.1659398336092;
        Mon, 01 Aug 2022 16:58:56 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uwknMVCKK6fhQJ3HEKR/Q6ywXFxRKc3gpLKeGLUpQ8cJQ9k0W02GLw8ag2ZG/XgjbZxW741+o9tjS/l2Gu4jo=
X-Received: by 2002:a05:620a:f13:b0:6b5:b956:c1f1 with SMTP id
 v19-20020a05620a0f1300b006b5b956c1f1mr13619135qkl.691.1659398335923; Mon, 01
 Aug 2022 16:58:55 -0700 (PDT)
MIME-Version: 1.0
References: <20220701143052.1267509-1-miquel.raynal@bootlin.com>
 <20220701143052.1267509-20-miquel.raynal@bootlin.com> <CAK-6q+ihSui2ra188kt9W5CT0HPfJgHoOJfsMS_XDLfVvoQJTg@mail.gmail.com>
In-Reply-To: <CAK-6q+ihSui2ra188kt9W5CT0HPfJgHoOJfsMS_XDLfVvoQJTg@mail.gmail.com>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Mon, 1 Aug 2022 19:58:45 -0400
Message-ID: <CAK-6q+j+xv+KwyN1M-uNy-G4y9uqQLU9Z8kDRF9bSs3w0VmTBA@mail.gmail.com>
Subject: Re: [PATCH wpan-next 19/20] ieee802154: hwsim: Do not check the rtnl
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Network Development <netdev@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Tue, Jul 5, 2022 at 9:23 PM Alexander Aring <aahringo@redhat.com> wrote:
>
> Hi,
>
> On Fri, Jul 1, 2022 at 10:37 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> >
> > There is no need to ensure the rtnl is locked when changing a driver's
> > channel. This cause issues when scanning and this is the only driver
> > relying on it. Just drop this dependency because it does not seem
> > legitimate.
> >
>
> switching channels relies on changing pib attributes, pib attributes
> are protected by rtnl. If you experience issues here then it's
> probably because you do something wrong. All drivers assuming here
> that rtnl lock is held.

especially this change could end in invalid free. Maybe we can solve
this problem in a different way, what exactly is the problem by
helding rtnl lock?

- Alex

