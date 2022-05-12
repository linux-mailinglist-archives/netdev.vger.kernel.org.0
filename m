Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75BA952507B
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 16:45:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355539AbiELOo5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 10:44:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232208AbiELOov (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 10:44:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AD20A261946
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 07:44:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652366687;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hDn+rJrqCWL0whZkTRg3HfuDKIQLnq7/rvfqZhPp9Dw=;
        b=ZvhU+ADZZE77ILu3EHFR/fMKiACEAYfKOsbmY2A86jae80uDWDIxJB5boPt86fOFg+Ug3S
        cAxFvLfU9PODUgY8yKhsdybD3qKGhowD4DqI1B2z1a0rIIZYnzAq0xKJES/lwuDX8YNj9m
        4Y7XCdMBNLBuCFyHZAFdVSu5mti+dK8=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-610-4JXEbXAmO1i2b6c7jIq2MQ-1; Thu, 12 May 2022 10:44:46 -0400
X-MC-Unique: 4JXEbXAmO1i2b6c7jIq2MQ-1
Received: by mail-qk1-f197.google.com with SMTP id a5-20020ae9e805000000b006a034b31384so4254953qkg.8
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 07:44:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hDn+rJrqCWL0whZkTRg3HfuDKIQLnq7/rvfqZhPp9Dw=;
        b=JTJGuEcOwjhb4iyOVCiUXgmbwowdyu6fqhAUmz3MD6vqcILAJbCbK0pSjxKPoz0zF4
         8QiooI4o0aM7ieF7lN4ppYdfxJ6eVkTXssDoefWJheKFGk0n56oR9nqCs0P2uWPVqRcF
         7lqzlgN4PRNqA+iSUUI90V4yQyUjNfADkA9aFKemyGIsQkTB3K5/9h5I85Dx+KmGQ21M
         zpDVNf+HX8jIjil4iQhFQ2bSxG2JjFo3pnb4j/7cgKWB3BC3o06nQbmhpgPd8+Ig1Pk0
         JMJAFS+qD6ugfh8L2yKQR652j4Fy7t/ZK+uOzQfYboBpsY7Y77ZqCx+2Sm/tIN560zpW
         4WFg==
X-Gm-Message-State: AOAM531JTB8QujUGuqR9JYcwX/FOIhXxKqdHj97WIPNimWkp46Wmv9Ag
        H+ZUhIis6P4vwHZhbY79i9Gl8Lvnqx5ae898W/bD+GRklOmZnHnmSuK9lt0jvvqkky0zq/XJ1X5
        FMAhAPB0/AhaCL7iZirl3vMZPjRiNHks2
X-Received: by 2002:a05:622a:351:b0:2f3:d8e4:529f with SMTP id r17-20020a05622a035100b002f3d8e4529fmr57472qtw.123.1652366686179;
        Thu, 12 May 2022 07:44:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyR+6Osf3CvRwy7Ah7LACYipP4JyjvLB85JHn/ZxzsxI0lx2gfrRsWsVax9Le6bXtd4m3xXaSGkWkuODNi5pyY=
X-Received: by 2002:a05:622a:351:b0:2f3:d8e4:529f with SMTP id
 r17-20020a05622a035100b002f3d8e4529fmr57452qtw.123.1652366685957; Thu, 12 May
 2022 07:44:45 -0700 (PDT)
MIME-Version: 1.0
References: <20220427164659.106447-1-miquel.raynal@bootlin.com>
 <20220427164659.106447-7-miquel.raynal@bootlin.com> <CAK-6q+jCYDQ-rtyawz1m2Yt+ti=3d6PrhZebB=-PjcX-6L-Kdg@mail.gmail.com>
 <20220510165237.43382f42@xps13> <CAK-6q+jeubhGah2gG1JJxfmOW=sNdMrLf+mk_a3X_r+Na=tHXg@mail.gmail.com>
 <20220512163307.540d635d@xps13>
In-Reply-To: <20220512163307.540d635d@xps13>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Thu, 12 May 2022 10:44:35 -0400
Message-ID: <CAK-6q+h07LM1-Cu_mkxAZWN2kG9LLxoKvXxUiQ5DPSYwRkbXZw@mail.gmail.com>
Subject: Re: [PATCH wpan-next 06/11] net: mac802154: Hold the transmit queue
 when relevant
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Thu, May 12, 2022 at 10:33 AM Miquel Raynal
<miquel.raynal@bootlin.com> wrote:
>
> Hi Alexander,
>
> aahringo@redhat.com wrote on Wed, 11 May 2022 09:09:40 -0400:
>
> > Hi,
> >
> > On Tue, May 10, 2022 at 10:52 AM Miquel Raynal
> > <miquel.raynal@bootlin.com> wrote:
> > >
> > > Hi Alex,
> > >
> > > > > --- a/net/mac802154/tx.c
> > > > > +++ b/net/mac802154/tx.c
> > > > > @@ -106,6 +106,21 @@ ieee802154_tx(struct ieee802154_local *local, struct sk_buff *skb)
> > > > >         return NETDEV_TX_OK;
> > > > >  }
> > > > >
> > > > > +void ieee802154_hold_queue(struct ieee802154_local *local)
> > > > > +{
> > > > > +       atomic_inc(&local->phy->hold_txs);
> > > > > +}
> > > > > +
> > > > > +void ieee802154_release_queue(struct ieee802154_local *local)
> > > > > +{
> > > > > +       atomic_dec(&local->phy->hold_txs);
> > > > > +}
> > > > > +
> > > > > +bool ieee802154_queue_is_held(struct ieee802154_local *local)
> > > > > +{
> > > > > +       return atomic_read(&local->phy->hold_txs);
> > > > > +}
> > > >
> > > > I am not getting this, should the release_queue() function not do
> > > > something like:
> > > >
> > > > if (atomic_dec_and_test(hold_txs))
> > > >       ieee802154_wake_queue(local);
> > > >
> > > > I think we don't need the test of "ieee802154_queue_is_held()" here,
> > > > then we need to replace all stop_queue/wake_queue with hold and
> > > > release?
> > >
> > > That's actually a good idea. I've implemented it and it looks nice too.
> > > I'll clean this up and share a new version with:
> > > - The wake call checked everytime hold_txs gets decremented
> > > - The removal of the _queue_is_held() helper
> > > - _wake/stop_queue() turned static
> > > - _hold/release_queue() used everywhere
> > >
> >
> > I think there is also a lock necessary for atomic inc/dec hitting zero
> > and the stop/wake call afterwards...
>
> Mmmh that is true, it can race. I've introduced a mutex (I think it's
> safe but it can be turned into a spinlock if proven necessary) to
> secure these increment/decrement+wakeup operations.
>

be aware that you might call these functions from different contexts,
test your patches with PROVE_LOCKING enabled.

> > ,there are also a lot of
> > optimization techniques to only hold the lock for hitting zero cases
> > in such areas. However we will see...
>
> I am not aware of technical solutions to avoid the locking in these
> cases, what do you have in mind? Otherwise I propose just to come up
> with a working and hopefully solid solution and then we'll see how to
> optimize.

Yes, it's not so important...

- Alex

