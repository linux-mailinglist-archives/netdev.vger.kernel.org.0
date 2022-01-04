Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 167644847A2
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 19:18:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236181AbiADSSH convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 4 Jan 2022 13:18:07 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:60751 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbiADSSH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 13:18:07 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id A8FD56000A;
        Tue,  4 Jan 2022 18:18:03 +0000 (UTC)
Date:   Tue, 4 Jan 2022 19:18:02 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>
Cc:     Nicolas Schodet <nico@ni.fr.eu.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [net-next 12/18] net: mac802154: Handle scan requests
Message-ID: <20220104191802.2323e44a@xps13>
In-Reply-To: <CAB_54W6gHE1S9Q+-SVbrnAWPxBxnvf54XVTCmddtj8g-bZzMRA@mail.gmail.com>
References: <20211222155743.256280-1-miquel.raynal@bootlin.com>
        <20211222155743.256280-13-miquel.raynal@bootlin.com>
        <CAB_54W6AZ+LGTcFsQjNx7uq=+R5v_kdF0Xm5kwWQ8ONtfOrmAw@mail.gmail.com>
        <Ycx0mwQcFsmVqWVH@ni.fr.eu.org>
        <CAB_54W41ZEoXzoD2_wadfMTY8anv9D9e2T5wRckdXjs7jKTTCA@mail.gmail.com>
        <CAB_54W6gHE1S9Q+-SVbrnAWPxBxnvf54XVTCmddtj8g-bZzMRA@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,

alex.aring@gmail.com wrote on Fri, 31 Dec 2021 14:27:12 -0500:

> Hi,
> 
> On Thu, 30 Dec 2021 at 14:47, Alexander Aring <alex.aring@gmail.com> wrote:
> >
> > Hi,
> >
> > On Wed, 29 Dec 2021 at 09:45, Nicolas Schodet <nico@ni.fr.eu.org> wrote:  
> > >
> > > Hi,
> > >
> > > * Alexander Aring <alex.aring@gmail.com> [2021-12-29 09:30]:  
> > > > Hi,
> > > > On Wed, 22 Dec 2021 at 10:58, Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> > > > ...  
> > > > > +{
> > > > > +       bool promiscuous_on = mac802154_check_promiscuous(local);
> > > > > +       int ret;
> > > > > +
> > > > > +       if ((state && promiscuous_on) || (!state && !promiscuous_on))
> > > > > +               return 0;
> > > > > +
> > > > > +       ret = drv_set_promiscuous_mode(local, state);
> > > > > +       if (ret)
> > > > > +               pr_err("Failed to %s promiscuous mode for SW scanning",
> > > > > +                      state ? "set" : "reset");  
> > > > The semantic of promiscuous mode on the driver layer is to turn off
> > > > ack response, address filtering and crc checking. Some transceivers
> > > > don't allow a more fine tuning on what to enable/disable. I think we
> > > > should at least do the checksum checking per software then?
> > > > Sure there is a possible tune up for more "powerful" transceivers then...  
> > >
> > > In this case, the driver could change the (flags &
> > > IEEE802154_HW_RX_DROP_BAD_CKSUM) bit dynamically to signal it does not
> > > check the checksum anymore. Would it work?  
> >
> > I think that would work, although the intention of the hw->flags is to
> > define what the hardware is supposed to support as not changing those
> > values dynamically during runtime so mac will care about it. However
> > we don't expose those flags to the userspace, so far I know. We can
> > still introduce two separated flags if necessary in future.
> >
> > Why do we need promiscuous mode at all? Why is it necessary for a
> > scan? What of "ack response, address filtering and crc checking" you
> > want to disable and why?
> >  
> 
> I see now why promiscuous mode is necessary here. The actual
> promiscuous mode setting for the driver is not the same as promiscuous
> mode in 802.15.4 spec. For until now it was there for running a
> sniffer device only.
> As the 802.15.4 spec defines some "filtering levels" I came up with a
> draft so we can define which filtering level should be done on the
> hardware.

I like the idea but I'm not sure on what side you want to tackle the
problem first. Is it the phy drivers which should advertise the mac
about the promiscuous mode they support (which matches the description
below but does not fit the purpose of an enum very well)? Or is it the
MAC that requests a particular filtering mode? In this case what a phy
driver should do if:
- the requested mode is more constrained than its usual promiscuous
  capabilities?
- the requested mode is less constrained than its usual promiscuous
  capabilities?

> 
> diff --git a/include/net/mac802154.h b/include/net/mac802154.h
> index 72978fb72a3a..3839ed3f8f0d 100644
> --- a/include/net/mac802154.h
> +++ b/include/net/mac802154.h
> @@ -130,6 +130,48 @@ enum ieee802154_hw_flags {
>  #define IEEE802154_HW_OMIT_CKSUM       (IEEE802154_HW_TX_OMIT_CKSUM | \
>                                          IEEE802154_HW_RX_OMIT_CKSUM)
> 
> +/**
> + * enum ieee802154_filter_mode - hardware filter mode that a driver
> will pass to
> + *                              pass to mac802154.

Isn't it the opposite: The filtering level the mac is requesting? Here
it looks like we are describing driver capabilities (ie what drivers
advertise supporting).

> + *
> + * @IEEE802154_FILTER_MODE_0: No MFR filtering at all.

I suppose this would be for a sniffer accepting all frames, including
the bad ones.

> + *
> + * @IEEE802154_FILTER_MODE_1: IEEE802154_FILTER_MODE_1 with a bad FCS filter.

This means that the driver should only discard bad frames and propagate
all the remaining frames, right? So this typically is a regular sniffer
mode.

> + *
> + * @IEEE802154_FILTER_MODE_2: Same as IEEE802154_FILTER_MODE_1, known as
> + *                           802.15.4 promiscuous mode, sets
> + *                           mib.PromiscuousMode.

I believe what you call mib.PromiscuousMode is the mode that is
referred in the spec, ie. being in the official promiscuous mode? So
that is the mode that should be used "by default" when really asking
for a 802154 promiscuous mode.

Is there really a need for a different mode than mode_1 ?

> + *
> + * @IEEE802154_FILTER_MODE_3_SCAN: Same as IEEE802154_FILTER_MODE_2 without
> + *                                set mib.PromiscuousMode.

And here what is the difference between MODE_1 and MODE_3 ?

I suppose here we should as well drop all non-beacon frames?

> + *
> + * @IEEE802154_FILTER_MODE_3_NO_SCAN:
> + *     IEEE802154_FILTER_MODE_3_SCAN with MFR additional filter on:
> + *
> + *     - No reserved value in frame type
> + *     - No reserved value in frame version
> + *     - Match mib.PanId or broadcast
> + *     - Destination address field:
> + *       - Match mib.ShortAddress or broadcast
> + *       - Match mib.ExtendedAddress or GroupRxMode is true
> + *       - ImplicitBroadcast is true and destination address field/destination
> + *         panid is not included.
> + *       - Device is coordinator only source address present in data
> + *         frame/command frame and source panid matches mib.PanId
> + *       - Device is coordinator only source address present in multipurpose
> + *         frame and destination panid matches macPanId
> + *     - Beacon frames source panid matches mib.PanId. If mib.PanId is
> + *       broadcast it should always be accepted.

This is a bit counter intuitive, but do we agree on the fact that the
higher level of filtering should refer to promiscuous = false?

> + *
> + */
> +enum ieee802154_filter_mode {
> +       IEEE802154_FILTER_MODE_0,
> +       IEEE802154_FILTER_MODE_1,
> +       IEEE802154_FILTER_MODE_2,
> +       IEEE802154_FILTER_MODE_3_SCAN,
> +       IEEE802154_FILTER_MODE_3_NO_SCAN,
> +};
> +
>  /* struct ieee802154_ops - callbacks from mac802154 to the driver
>   *
>   * This structure contains various callbacks that the driver may
> @@ -249,7 +291,7 @@ struct ieee802154_ops {
>         int             (*set_frame_retries)(struct ieee802154_hw *hw,
>                                              s8 retries);
>         int             (*set_promiscuous_mode)(struct ieee802154_hw *hw,
> -                                               const bool on);
> +                                               enum
> ieee802154_filter_mode mode);
>         int             (*enter_scan_mode)(struct ieee802154_hw *hw,
>                                            struct
> cfg802154_scan_request *request);
>         int             (*exit_scan_mode)(struct ieee802154_hw *hw);
> 
> ---
> 
> In your case it will be IEEE802154_FILTER_MODE_3_SCAN mode, for a
> sniffer we probably want as default IEEE802154_FILTER_MODE_0, as
> "promiscuous mode" currently is.
> 
> - Alex


Thanks,
Miquèl
