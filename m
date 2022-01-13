Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 764E448D500
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 10:50:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233399AbiAMJaC convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 13 Jan 2022 04:30:02 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:55679 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233382AbiAMJaB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 04:30:01 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id BB9BF6002D;
        Thu, 13 Jan 2022 09:29:55 +0000 (UTC)
Date:   Thu, 13 Jan 2022 10:29:54 +0100
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
Subject: Re: [wpan-next v2 27/27] net: ieee802154: ca8210: Refuse most of
 the scan operations
Message-ID: <20220113102954.7a0e213e@xps13>
In-Reply-To: <CAB_54W5ojqi2obtNLihCMXsZkh+aN_cVbSTRptq3=PXkpknzJQ@mail.gmail.com>
References: <20220112173312.764660-1-miquel.raynal@bootlin.com>
        <20220112173312.764660-28-miquel.raynal@bootlin.com>
        <CAB_54W5ojqi2obtNLihCMXsZkh+aN_cVbSTRptq3=PXkpknzJQ@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,

alex.aring@gmail.com wrote on Wed, 12 Jan 2022 17:48:59 -0500:

> Hi,
> 
> On Wed, 12 Jan 2022 at 12:34, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> >
> > The Cascada 8210 hardware transceiver is kind of a hardMAC which
> > interfaces with the softMAC and in practice does not support sending
> > anything else than dataframes. This means we cannot send any BEACON_REQ
> > during active scans nor any BEACON in general. Refuse these operations
> > officially so that the user is aware of the limitation.
> >
> > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > ---
> >  drivers/net/ieee802154/ca8210.c | 25 ++++++++++++++++++++++++-
> >  1 file changed, 24 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/ieee802154/ca8210.c b/drivers/net/ieee802154/ca8210.c
> > index d3a9e4fe05f4..49c274280e3c 100644
> > --- a/drivers/net/ieee802154/ca8210.c
> > +++ b/drivers/net/ieee802154/ca8210.c
> > @@ -2385,6 +2385,25 @@ static int ca8210_set_promiscuous_mode(struct ieee802154_hw *hw, const bool on)
> >         return link_to_linux_err(status);
> >  }
> >
> > +static int ca8210_enter_scan_mode(struct ieee802154_hw *hw,
> > +                                 struct cfg802154_scan_request *request)
> > +{
> > +       /* This xceiver can only send dataframes */
> > +       if (request->type != NL802154_SCAN_PASSIVE)
> > +               return -EOPNOTSUPP;
> > +
> > +       return 0;
> > +}
> > +
> > +static int ca8210_enter_beacons_mode(struct ieee802154_hw *hw,
> > +                                    struct cfg802154_beacons_request *request)
> > +{
> > +       /* This xceiver can only send dataframes */
> > +       return -EOPNOTSUPP;
> > +}
> > +
> > +static void ca8210_exit_scan_beacons_mode(struct ieee802154_hw *hw) { }
> > +
> >  static const struct ieee802154_ops ca8210_phy_ops = {
> >         .start = ca8210_start,
> >         .stop = ca8210_stop,
> > @@ -2397,7 +2416,11 @@ static const struct ieee802154_ops ca8210_phy_ops = {
> >         .set_cca_ed_level = ca8210_set_cca_ed_level,
> >         .set_csma_params = ca8210_set_csma_params,
> >         .set_frame_retries = ca8210_set_frame_retries,
> > -       .set_promiscuous_mode = ca8210_set_promiscuous_mode
> > +       .set_promiscuous_mode = ca8210_set_promiscuous_mode,
> > +       .enter_scan_mode = ca8210_enter_scan_mode,
> > +       .exit_scan_mode = ca8210_exit_scan_beacons_mode,
> > +       .enter_beacons_mode = ca8210_enter_beacons_mode,
> > +       .exit_beacons_mode = ca8210_exit_scan_beacons_mode,
> >  };  
> 
> so there is no flag that this driver can't support scanning currently
> and it works now because the offload functionality will return
> -ENOTSUPP? This is misleading because I would assume if it's not
> supported we can do it by software which the driver can't do.

I believe there is a misunderstanding.

This is what I have understood from your previous comments in v1:
"This driver does not support transmitting anything else than
datagrams", which is what I assumed was a regular data packet. IOW,
sending a MAC_CMD such as a beacon request or sending a beacon was not
supported physically by the hardware. Hence, most of the scans
operations cannot be performed and must be rejected (all but a passive
scan, assuming that receiving beacons was okay).

Please mind the update in that hook which currently is just an FYI from
the mac to the drivers and not a "do it by yourself" injunction. So
answering -EOPNOTSUPP to the mac here does not mean:
	"I cannot handle it by myself, the scan cannot happen"
but
	"I cannot handle the forged frames, so let's just not try"
 
> ... I see that the offload functions now are getting used and have a
> reason to be upstream, but the use of it is wrong.

As a personal matter of taste, I don't like flags when it comes to
something complex like supporting a specific operation. Just in the
scanning procedure there are 4 different actions and a driver might
support only a subset of these, which is totally fine but hard to
properly describe by well-named flags. Here the driver hooks say to
the driver which are interested "here is what is going to happen" and
then they can:
- ignore the details by just not implementing the hooks, let the mac do
  its job, they will then transmit the relevant frames forged by the
  mac
- eventually enter a specific mode internally for this operation, but
  basically do the same as above, ie. transmitting the frames forged
  by the mac
- refuse the operation by returning an error code if something cannot
  be done

I've experienced a number of situations in the MTD world and later with
IIO drivers where flags have been remodeled and reused in different
manners, until the flag description gets totally wrong and
undescriptive regarding what it actually does. Hence my main idea of
letting drivers refuse these operations instead of having the mac doing
it for them.

I can definitely use flags if you want, but in this case, what flags do
you want to see?

Thanks,
Miquèl
