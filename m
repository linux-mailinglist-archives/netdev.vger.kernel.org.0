Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E36264DE0CD
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 19:11:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240049AbiCRSM1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 14:12:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233194AbiCRSM1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 14:12:27 -0400
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::223])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8B2F2EDC20;
        Fri, 18 Mar 2022 11:11:06 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 33FEE60007;
        Fri, 18 Mar 2022 18:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1647627065;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R8NHyHx7StIdeAb1cP4RooO3thVY1uHjoKLKhREJtM8=;
        b=iefKOzdHaPlyoX9hmY6jLRpAbKefC85BiNHNYqoEzaEDTQHPi1K9AhDBx35RogsMBHXHos
        mtWDhQsflFMsIwHjqciccOTi12JW2atbfrm+HEcXlW4zSAItUt8VoRJGud2nwekRi7nB8j
        lzWZxFCeyBmmDiIr0ZxDVpZTQW8I8R+JSEnP61yRAFsCLH6LfC1+8L1jSih8ua0hmds9p1
        GL7LEbUQDO4eI2a1pvBsGTweOSXhzJjEcNYauAxY+hvsgOvWA3WNbR2jL89TOLy8yW/UV2
        v197PO2+YGL6tjfcT6yr3jCi4yK3MWpmpTTP3O5B1zkvKv8BSxSXsGVNw3kd9Q==
Date:   Fri, 18 Mar 2022 19:11:01 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH wpan-next v2 13/14] net: mac802154: Introduce a tx queue
 flushing mechanism
Message-ID: <20220318191101.4dbe5a02@xps13>
In-Reply-To: <CAB_54W4A6-Jgpr2WX3y3OPo-3=BJJDz+M5XPfWwpgCx1sXWAGQ@mail.gmail.com>
References: <20220207144804.708118-1-miquel.raynal@bootlin.com>
        <20220207144804.708118-14-miquel.raynal@bootlin.com>
        <CAB_54W5ao0b6QE7E_uXFeorbn6UjB6NV4emtibqswL4iXYEfng@mail.gmail.com>
        <20220303191723.39b87766@xps13>
        <20220304115432.7913f2ef@xps13>
        <CAB_54W4A6-Jgpr2WX3y3OPo-3=BJJDz+M5XPfWwpgCx1sXWAGQ@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,

alex.aring@gmail.com wrote on Sun, 13 Mar 2022 16:43:52 -0400:

> Hi,
>=20
> On Fri, Mar 4, 2022 at 5:54 AM Miquel Raynal <miquel.raynal@bootlin.com> =
wrote:
>=20
> > I had a second look at it and it appears to me that the issue was
> > already there and is structural. We just did not really cared about it
> > because we didn't bother with synchronization issues.
> > =20
>=20
> I am not sure if I understand correctly. We stop the queue at some
> specific moment and we need to make sure that xmit_do() is not called
> or can't be called anymore.
>=20
> I was thinking about:
>=20
> void ieee802154_disable_queue(struct ieee802154_hw *hw)
> {
>         struct ieee802154_local *local =3D hw_to_local(hw);
>         struct ieee802154_sub_if_data *sdata;
>=20
>         rcu_read_lock();
>         list_for_each_entry_rcu(sdata, &local->interfaces, list) {
>                 if (!sdata->dev)
>                         continue;
>=20
>                netif_tx_disable(sdata->dev);
>         }
>         rcu_read_unlock();
> }
> EXPORT_SYMBOL(ieee802154_stop_queue);
>=20
> From my quick view is that "netif_tx_disable()" ensures by holding
> locks and other things and doing netif_tx_stop_queue() it we can be
> sure there will be no xmit_do() going on while it's called and
> afterwards. It can be that there are still transmissions on the
> transceiver that are on the way, but then your atomic counter and
> wait_event() will come in place.

I went for a deeper investigation to understand how the net core
was calling our callbacks. And it appeared to go through
dev_hard_start_xmit() and come from __dev_queue_xmit(). This means
the ieee802154 callback could only be called once at a time
because it is protected by the network device transmit lock
(netif_tx_lock()). Which makes the logic safe and not racy as I
initially thought. This was the missing peace in my mental model I
believe.

> We need to be sure there will be nothing queued anymore for
> transmission what (in my opinion) tx_disable() does. from any context.
>
> We might need to review some netif callbacks... I have in my mind for
> example stop(), maybe netif_tx_stop_queue() is enough (because the
> context is like netif_tx_disable(), helding similar locks, etc.) but
> we might want to be sure that nothing is going on anymore by using
> your wait_event() with counter.

I don't see a real reason anymore to use the tx_disable() call. Is
there any reason this could be needed that I don't have in mind? Right
now the only thing that I see is that it could delay a little bit the
moment where we actually stop the queue because we would be waiting for
the lock to be released after the skb has been offloaded to hardware.
Perhaps maybe we would let another frame to be transmitted before we
actually get the lock.

> Is there any problem which I don't see?

One question however, as I understand, if userspace tries to send more
packets, I believe the "if (!stopped)" condition will be false and the
xmit call will simply be skipped, ending with a -ENETDOWN error [1]. Is
it what we want? I initially thought we could actually queue patches and
wait for the queue to be re-enabled again, but it does not look easy.

[1] https://elixir.bootlin.com/linux/latest/source/net/core/dev.c#L4249

Thanks,
Miqu=C3=A8l
