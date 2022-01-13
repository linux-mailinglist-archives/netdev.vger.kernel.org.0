Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52B7948DCBD
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 18:15:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236983AbiAMRPB convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 13 Jan 2022 12:15:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234010AbiAMRO5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 12:14:57 -0500
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::226])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7283C061574;
        Thu, 13 Jan 2022 09:14:56 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay6-d.mail.gandi.net (Postfix) with ESMTPSA id C5D23C0003;
        Thu, 13 Jan 2022 17:14:52 +0000 (UTC)
Date:   Thu, 13 Jan 2022 18:14:51 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Harry Morris <h.morris@cascoda.com>,
        Varka Bhadram <varkabhadram@gmail.com>,
        Xue Liu <liuxuenetmail@gmail.com>, Alan Ott <alan@signal11.us>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "linux-wireless@vger.kernel.org Wireless" 
        <linux-wireless@vger.kernel.org>
Subject: Re: [wpan-next v2 23/27] net: mac802154: Add support for active
 scans
Message-ID: <20220113181451.6aa5e60a@xps13>
In-Reply-To: <CAB_54W6bJ5oV1pTX03-xWaFohdyxrjy2WSa2kxp3rBzLqSo=UA@mail.gmail.com>
References: <20220112173312.764660-1-miquel.raynal@bootlin.com>
        <20220112173312.764660-24-miquel.raynal@bootlin.com>
        <CAB_54W6bJ5oV1pTX03-xWaFohdyxrjy2WSa2kxp3rBzLqSo=UA@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,

alex.aring@gmail.com wrote on Wed, 12 Jan 2022 18:16:11 -0500:

> Hi,
> 
> On Wed, 12 Jan 2022 at 12:34, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> ...
> > +static int mac802154_scan_send_beacon_req_locked(struct ieee802154_local *local)
> > +{
> > +       struct sk_buff *skb;
> > +       int ret;
> > +
> > +       lockdep_assert_held(&local->scan_lock);
> > +
> > +       skb = alloc_skb(IEEE802154_BEACON_REQ_SKB_SZ, GFP_KERNEL);
> > +       if (!skb)
> > +               return -ENOBUFS;
> > +
> > +       ret = ieee802154_beacon_req_push(skb, &local->beacon_req);
> > +       if (ret) {
> > +               kfree_skb(skb);
> > +               return ret;
> > +       }
> > +
> > +       return drv_xmit_async(local, skb);  
> 
> I think you need to implement a sync transmit handling here.

True.

> And what
> I mean is not using dryv_xmit_sync() (It is a long story and should
> not be used, it's just that the driver is allowed to call bus api
> functions which can sleep).

Understood.

> We don't have such a function yet (but I
> think it can be implemented), you should wait until the transmission
> is done. If we don't wait we fill framebuffers on the hardware while
> the hardware is transmitting the framebuffer which is... bad.

Do you already have something in mind?

If I focus on the scan operation, it could be that we consider the
queue empty, then we put this transfer, wait for completion and
continue. But this only work for places where we know we have full
control over what is transmitted (eg. during a scan) and not for all
transfers. Would this fit your idea?

Or do you want something more generic with some kind of an
internal queue where we have the knowledge of what has been queued and
a token to link with every xmit_done call that is made?

I'm open to suggestions.

Thanks,
Miquèl
