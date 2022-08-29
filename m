Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 173725A423F
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 07:28:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbiH2F2Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 01:28:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbiH2F2M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 01:28:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 831EC459AA;
        Sun, 28 Aug 2022 22:28:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 737B3B80CC5;
        Mon, 29 Aug 2022 05:28:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A4A9C433C1;
        Mon, 29 Aug 2022 05:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661750885;
        bh=QN/CfA5mG+7/T0w3sbSwXmKF4NHtAk2IC3zgSTEmqvc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=n3XpDF90C92OaQ9H7SPW/jV+TURT5FHLb6zGEf3L+Q/cROU7zN5mE4QXLwlt6yip4
         67z4ntii5rDBMDv+V7A+bj+chK89bBPkllzTX3Y6RFxKjn9Qo+khORlqORfCT41ekL
         TnKK9gKOEORVzAjR/MpfwpZiug85eP8+4Lxe/yxg=
Date:   Mon, 29 Aug 2022 07:28:19 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Alexander Aring <aahringo@redhat.com>
Cc:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Alexander Aring <alex.aring@gmail.com>,
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
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] net: mac802154: Fix a condition in the receive path
Message-ID: <YwxOc+X7VpMhKv+4@kroah.com>
References: <20220826142954.254853-1-miquel.raynal@bootlin.com>
 <CAK-6q+imPjpBxSZG7e5nxYYgtkrM5pfncxza9=vA+sq+eFQsUw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK-6q+imPjpBxSZG7e5nxYYgtkrM5pfncxza9=vA+sq+eFQsUw@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 28, 2022 at 08:16:20PM -0400, Alexander Aring wrote:
> Hi,
> 
> On Fri, Aug 26, 2022 at 10:31 AM Miquel Raynal
> <miquel.raynal@bootlin.com> wrote:
> >
> > Upon reception, a packet must be categorized, either it's destination is
> > the host, or it is another host. A packet with no destination addressing
> > fields may be valid in two situations:
> > - the packet has no source field: only ACKs are built like that, we
> >   consider the host as the destination.
> > - the packet has a valid source field: it is directed to the PAN
> >   coordinator, as for know we don't have this information we consider we
> >   are not the PAN coordinator.
> >
> > There was likely a copy/paste error made during a previous cleanup
> > because the if clause is now containing exactly the same condition as in
> > the switch case, which can never be true. In the past the destination
> > address was used in the switch and the source address was used in the
> > if, which matches what the spec says.
> >
> > Cc: stable@vger.kernel.org
> > Fixes: ae531b9475f6 ("ieee802154: use ieee802154_addr instead of *_sa variants")
> > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > ---
> >  net/mac802154/rx.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/net/mac802154/rx.c b/net/mac802154/rx.c
> > index b8ce84618a55..c439125ef2b9 100644
> > --- a/net/mac802154/rx.c
> > +++ b/net/mac802154/rx.c
> > @@ -44,7 +44,7 @@ ieee802154_subif_frame(struct ieee802154_sub_if_data *sdata,
> >
> >         switch (mac_cb(skb)->dest.mode) {
> >         case IEEE802154_ADDR_NONE:
> > -               if (mac_cb(skb)->dest.mode != IEEE802154_ADDR_NONE)
> > +               if (hdr->source.mode != IEEE802154_ADDR_NONE)
> >                         /* FIXME: check if we are PAN coordinator */
> >                         skb->pkt_type = PACKET_OTHERHOST;
> >                 else
> 
> 
> This patch looks okay but it should not be addressed to stable. Leave
> of course the fixes tag.

Why do that?  Do you not want this in the stable tree?

> Wpan sends pull requests to net and they have their own way to get
> into the stable tree when they are in net.

No, the normal method has been used for quite a while now.

Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.
