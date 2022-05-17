Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5633A52A3C8
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 15:45:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344991AbiEQNpW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 09:45:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243712AbiEQNpU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 09:45:20 -0400
Received: from relay10.mail.gandi.net (relay10.mail.gandi.net [IPv6:2001:4b98:dc4:8::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 056CA4D240;
        Tue, 17 May 2022 06:45:16 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 0ABC4240008;
        Tue, 17 May 2022 13:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1652795115;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ca1VcPUtCSThulRGThSIW1iyDvT90bQQDkEh2AeRIVg=;
        b=n0DdyinVtJ0VWlovT+PRlOS076zecnvfH4oBIaHTDP/zz5MotJo8Em6PAMbydFLW/PTlLr
        D60nTsJkddrqqciuxwyGuZDl/PDCfFtwDrW7Ia1doUr8yBwxtyOddGte5iepCa25YGNiWH
        Ij5qBR/xxZ70gTcARBpf2PJIMngzBmrCmp+LXWxVaoSfKuP6QZ24HbqGm/KOnWXW+mTpku
        265Yef7PlKATjEpge82eGl194QjvsuC4HCKeoypqtysblWFYj0pIRBTly6q0nuG6fjoaHb
        UJ44p6wKa5d4iXRyHWDYCTQqA/oimIfCFJAlxOUakeHHhQEM0hGVGdYoYkFLiw==
Date:   Tue, 17 May 2022 15:45:12 +0200
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <aahringo@redhat.com>
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
Subject: Re: [PATCH wpan-next v2 11/11] net: mac802154: Add a warning in the
 slow path
Message-ID: <20220517154512.5a98e4c4@xps-13>
In-Reply-To: <CAK-6q+iuB4kFOP7RwwaFQ9AbQTijrmXBzDis7wXo2Pat=cW6kA@mail.gmail.com>
References: <20220512143314.235604-1-miquel.raynal@bootlin.com>
        <20220512143314.235604-12-miquel.raynal@bootlin.com>
        <CAK-6q+iuB4kFOP7RwwaFQ9AbQTijrmXBzDis7wXo2Pat=cW6kA@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,

aahringo@redhat.com wrote on Sun, 15 May 2022 18:30:28 -0400:

> Hi,
> 
> On Thu, May 12, 2022 at 10:34 AM Miquel Raynal
> <miquel.raynal@bootlin.com> wrote:
> >
> > In order to be able to detect possible conflicts between the net
> > interface core and the ieee802154 core, let's add a warning in the slow
> > path: we want to be sure that whenever we start an asynchronous MLME
> > transmission (which can be fully asynchronous) the net core somehow
> > agrees that this transmission is possible, ie. the device was not
> > stopped. Warning in this case would allow us to track down more easily
> > possible issues with the MLME logic if we ever get reports.
> >
> > Unlike in the hot path, such a situation cannot be handled.
> >
> > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > ---
> >  net/mac802154/tx.c | 25 +++++++++++++++++++++++++
> >  1 file changed, 25 insertions(+)
> >
> > diff --git a/net/mac802154/tx.c b/net/mac802154/tx.c
> > index a3c9f194c025..d61b076239c3 100644
> > --- a/net/mac802154/tx.c
> > +++ b/net/mac802154/tx.c
> > @@ -132,6 +132,25 @@ int ieee802154_sync_and_hold_queue(struct ieee802154_local *local)
> >         return ret;
> >  }
> >
> > +static bool ieee802154_netif_is_down(struct ieee802154_local *local)
> > +{
> > +       struct ieee802154_sub_if_data *sdata;
> > +       bool is_down = false;
> > +
> > +       rcu_read_lock();
> > +       list_for_each_entry_rcu(sdata, &local->interfaces, list) {
> > +               if (!sdata->dev)
> > +                       continue;
> > +
> > +               is_down = !(sdata->dev->flags & IFF_UP);  
> 
> Is there not a helper for this flag?

I was surprised that nobody cared enough about that information to
create a helper. Then I grepped and figured out I was not the first to
to do that...

$ git grep "flags & IFF_UP" | wc -l
289
