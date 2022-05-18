Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05F9152AF89
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 03:00:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233085AbiERBAK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 21:00:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232262AbiERBAJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 21:00:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8F98053E27
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 18:00:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652835607;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TD7xyGWTuwBRGr8+dLq49qXLZB7RZzLQlThaAODywHI=;
        b=LYhCpFI6MNyeAOI00xvW37Knoz5ub61wD5wKbnjPO/rdvp6AJQwj6pEC28WXkvk9C7qXaS
        7873HcqksBkXt4Y7DuQqDK2VCazyfhKf3cEhC0qRXimZXWpCn5TWhexZN71G7G9HQ2ACZ0
        JT/KS9ODQnXslwxm4I9a6mbjOlmJgpM=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-163--RnbilO7PVmwV2cPSGcyww-1; Tue, 17 May 2022 20:59:50 -0400
X-MC-Unique: -RnbilO7PVmwV2cPSGcyww-1
Received: by mail-qv1-f71.google.com with SMTP id a12-20020a056214062c00b0045a7b4a1a29so454332qvx.10
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 17:59:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TD7xyGWTuwBRGr8+dLq49qXLZB7RZzLQlThaAODywHI=;
        b=b2tLQV5GvlU6buxf5+cIcVF9Q3fMlGD/sTKo1BhU0dc0s4jegJqZJy6nlS00iwhdy9
         1hUd/idlriU1Erii1hm9wfragMVb5sF+bldjquq3ONPdz+XPtpujD0OsB4WLTmIEYgZt
         KBXvPqw/piV8i5dDWMG3tgfIU0o75+RlI3jthGXEKJEJjADVY5/p8i6yGl+53C0Mwuvk
         yMxoGgyYDKiBU4Mg6Ey4vMceJJUxpLsiVCDssmpY18aO5aTzOVrMGv17zmhQVaOrZCE3
         0RhAQtdZHFAb2l4VsNvbAwcyp4UQ1t2JmoLqiS4X/RNnEP/ThtZ2rxM1sjEvREnSASRi
         5e1w==
X-Gm-Message-State: AOAM5300mLcro4P9vPitvSMhQqdSUNnKf70m3fFCL95xHDdaWzgPgJIr
        MU0S7M5Sna85sDFM2vk/XH2hd8igUPQCs8d/7/+6wzxV+Dh9b0T1nm0PcI1uRZXVH+JtO2s1HkM
        YhOa6R/+qSb7b4CYboXNrWjyD/l8t/mkX
X-Received: by 2002:a37:350:0:b0:69f:8c4e:9fa5 with SMTP id 77-20020a370350000000b0069f8c4e9fa5mr18295865qkd.770.1652835590130;
        Tue, 17 May 2022 17:59:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz9DI611Whfu7K7lze9PphEAOqW0KpI/sUAabwcKdkjiNkDnXDqopFW56h064GCOtFoI0VHg2qNvTM3O9a6hwc=
X-Received: by 2002:a37:350:0:b0:69f:8c4e:9fa5 with SMTP id
 77-20020a370350000000b0069f8c4e9fa5mr18295857qkd.770.1652835589895; Tue, 17
 May 2022 17:59:49 -0700 (PDT)
MIME-Version: 1.0
References: <20220512143314.235604-1-miquel.raynal@bootlin.com>
 <20220512143314.235604-11-miquel.raynal@bootlin.com> <CAK-6q+jYb7A2RzG3u7PJYKZU9D5A=vben-Wnu-3EsUU-rqGT2Q@mail.gmail.com>
 <20220517153655.155ba311@xps-13> <20220517165259.52ddf6fc@xps-13>
In-Reply-To: <20220517165259.52ddf6fc@xps-13>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Tue, 17 May 2022 20:59:39 -0400
Message-ID: <CAK-6q+h=gNqoUHYi_2xamdGyMOYpO0GDO6--oKXSevJC9Wywag@mail.gmail.com>
Subject: Re: [PATCH wpan-next v2 10/11] net: mac802154: Add a warning in the
 hot path
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Tue, May 17, 2022 at 10:53 AM Miquel Raynal
<miquel.raynal@bootlin.com> wrote:
>
>
> miquel.raynal@bootlin.com wrote on Tue, 17 May 2022 15:36:55 +0200:
>
> > aahringo@redhat.com wrote on Sun, 15 May 2022 18:30:15 -0400:
> >
> > > Hi,
> > >
> > > On Thu, May 12, 2022 at 10:34 AM Miquel Raynal
> > > <miquel.raynal@bootlin.com> wrote:
> > > >
> > > > We should never start a transmission after the queue has been stopped.
> > > >
> > > > But because it might work we don't kill the function here but rather
> > > > warn loudly the user that something is wrong.
> > > >
> > > > Set an atomic when the queue will remain stopped. Reset this atomic when
> > > > the queue actually gets restarded. Just check this atomic to know if the
> > > > transmission is legitimate, warn if it is not.
> > > >
> > > > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > > > ---
> > > >  include/net/cfg802154.h |  1 +
> > > >  net/mac802154/tx.c      | 16 +++++++++++++++-
> > > >  net/mac802154/util.c    |  1 +
> > > >  3 files changed, 17 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/include/net/cfg802154.h b/include/net/cfg802154.h
> > > > index 8b6326aa2d42..a1370e87233e 100644
> > > > --- a/include/net/cfg802154.h
> > > > +++ b/include/net/cfg802154.h
> > > > @@ -218,6 +218,7 @@ struct wpan_phy {
> > > >         struct mutex queue_lock;
> > > >         atomic_t ongoing_txs;
> > > >         atomic_t hold_txs;
> > > > +       atomic_t queue_stopped;
> > >
> > > Maybe some test_bit()/set_bit() is better there?
> >
> > What do you mean? Shall I change the atomic_t type of queue_stopped?
> > Isn't the atomic_t preferred in this situation?
>
> Actually I re-read the doc and that's right, a regular unsigned long

Which doc is that?

- Alex

