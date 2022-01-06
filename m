Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22D04486A61
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 20:15:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243200AbiAFTPX convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 6 Jan 2022 14:15:23 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:41817 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243146AbiAFTPX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 14:15:23 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 096F260009;
        Thu,  6 Jan 2022 19:15:17 +0000 (UTC)
Date:   Thu, 6 Jan 2022 20:15:16 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [net-next 12/18] net: mac802154: Handle scan requests
Message-ID: <20220106201516.6a48154a@xps13>
In-Reply-To: <CAB_54W7zDXfybMZZo8QPwRCxX8-BbkQdznwEkLEWeW+E3k2dNg@mail.gmail.com>
References: <20211222155743.256280-1-miquel.raynal@bootlin.com>
        <20211222155743.256280-13-miquel.raynal@bootlin.com>
        <CAB_54W6AZ+LGTcFsQjNx7uq=+R5v_kdF0Xm5kwWQ8ONtfOrmAw@mail.gmail.com>
        <Ycx0mwQcFsmVqWVH@ni.fr.eu.org>
        <CAB_54W41ZEoXzoD2_wadfMTY8anv9D9e2T5wRckdXjs7jKTTCA@mail.gmail.com>
        <CAB_54W6gHE1S9Q+-SVbrnAWPxBxnvf54XVTCmddtj8g-bZzMRA@mail.gmail.com>
        <20220104191802.2323e44a@xps13>
        <CAB_54W5quZz8rVrbdx+cotTRZZpJ4ouRDZkxeW6S1L775Si=cw@mail.gmail.com>
        <20220105215551.1693eba4@xps13>
        <CAB_54W7zDXfybMZZo8QPwRCxX8-BbkQdznwEkLEWeW+E3k2dNg@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,

alex.aring@gmail.com wrote on Wed, 5 Jan 2022 19:38:12 -0500:

> Hi,
> 
> 
> On Wed, 5 Jan 2022 at 15:55, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> ...
> > > rest in software is a bigger task here...  
> >
> > On the symbol duration side I feel I'm close to a working PoC.
> >  
> 
> oh, ok.

I think it's ready, I'll soon send two series:
- the symbol duration update
- v2 for this series, which will not apply without the symbol duration
  update.

> > So there is 'only' this item left in my mind. Could you please clarify
> > what you expect from me exactly in terms of support for the promiscuous
> > filters we discussed so far?
> >  
> 
> I think for now it's okay to set the device into promiscuous mode and
> enable the flag which checks for bad FCS... we can still implement the
> filter modes later (and I think it should work on all supported
> transceivers (except that SoftMAC/HardMAC thing)).

I considered the following options in order to do that:
1- Hack all ->set_promiscuous() driver implementations to set
   IEEE802154_HW_RX_DROP_BAD_CKSUM as long as it was not already set
   initially.
2- Set the above flag at scan level, ie. in
   scan.c:mac802154_set_promiscuous_mode(). But this would be a bit
   ugly and I'd need to add a persistent field somewhere in the
   wpan_dev structure to remember how the flags settings where before
   the scan code hacked it.
3- Add more code in hwsim to handle checksum manually instead of
   by default setting the above flag to request the core to do the
   job. This way no driver would actually set this flag. We can then
   consider it "volatile" and would not need to track its state.
4- We know that we are in a scan thanks to a mac802154 internal
   variable, we can just assume that all drivers are in promiscuous
   mode and that none of them actually checks the FCS. This is
   certainly the simplest yet effective solution. In the worst case, we
   are just doing the check twice, which I believe does not hurt as
   long as the checksum is not cut off. If the checksum is cut, then
   the core is buggy because it always remove the two last bytes.

I picked 4 for now, but if you think this is unreliable, please
tell me what do you prefer otherwise.

> One point to promiscuous mode, currently we have a checking for if a
> phy is in promiscuous mode on ifup and it would forbid to ifup a node
> interface if the phy is in promiscuous mode (because of the missing
> automatic acknowledgement). I see there is a need to turn the phy into
> promiscuous mode during runtime... so we need somehow make sure the
> constraints are still valid here.

Yes, the code (rx.c) currently drops everything that is not a beacon
during a scan.

> Maybe we even forbid multiple devs
> on a phy if the transceiver/driver/firmware is poor and this is
> currently all transceivers (except hwsim? But that doesn't use any ack
> handling anyway).

Thanks,
Miquèl
