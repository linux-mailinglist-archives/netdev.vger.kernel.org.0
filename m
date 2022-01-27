Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D784C49DCD4
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 09:46:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237870AbiA0Ip3 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 27 Jan 2022 03:45:29 -0500
Received: from relay11.mail.gandi.net ([217.70.178.231]:51395 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232313AbiA0Ip3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 03:45:29 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id AA61E100010;
        Thu, 27 Jan 2022 08:45:24 +0000 (UTC)
Date:   Thu, 27 Jan 2022 09:45:23 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Stefan Schmidt <stefan@datenfreihafen.org>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [wpan v3 1/6] net: ieee802154: hwsim: Ensure proper channel
 selection at probe time
Message-ID: <20220127094523.6c5034b5@xps13>
In-Reply-To: <344c7192-20b6-15f5-021c-092148f87bca@datenfreihafen.org>
References: <20220125121426.848337-1-miquel.raynal@bootlin.com>
        <20220125121426.848337-2-miquel.raynal@bootlin.com>
        <d3cab1bb-184d-73f9-7bd8-8eefc5e7e70c@datenfreihafen.org>
        <20220125174849.31501317@xps13>
        <89726c29-bf7d-eaf1-2af0-da1914741bec@datenfreihafen.org>
        <CAB_54W4TGvLeXdKLpxDwTrt4a19WPtSWDXq7kX4i-Ypd6euLnQ@mail.gmail.com>
        <344c7192-20b6-15f5-021c-092148f87bca@datenfreihafen.org>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stefan,

stefan@datenfreihafen.org wrote on Thu, 27 Jan 2022 08:33:15 +0100:

> Hello.
> 
> On 26.01.22 23:54, Alexander Aring wrote:
> > Hi,
> > 
> > On Wed, Jan 26, 2022 at 8:38 AM Stefan Schmidt
> > <stefan@datenfreihafen.org> wrote:  
> >>
> >>
> >> Hello.
> >>
> >> On 25.01.22 17:48, Miquel Raynal wrote:  
> >>> Hi Stefan,
> >>>
> >>> stefan@datenfreihafen.org wrote on Tue, 25 Jan 2022 15:28:11 +0100:
> >>>  
> >>>> Hello.
> >>>>
> >>>> On 25.01.22 13:14, Miquel Raynal wrote:  
> >>>>> Drivers are expected to set the PHY current_channel and current_page
> >>>>> according to their default state. The hwsim driver is advertising being
> >>>>> configured on channel 13 by default but that is not reflected in its own
> >>>>> internal pib structure. In order to ensure that this driver consider the
> >>>>> current channel as being 13 internally, we at least need to set the
> >>>>> pib->channel field to 13.
> >>>>>
> >>>>> Fixes: f25da51fdc38 ("ieee802154: hwsim: add replacement for fakelb")
> >>>>> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> >>>>> ---
> >>>>>     drivers/net/ieee802154/mac802154_hwsim.c | 1 +
> >>>>>     1 file changed, 1 insertion(+)
> >>>>>
> >>>>> diff --git a/drivers/net/ieee802154/mac802154_hwsim.c b/drivers/net/ieee802154/mac802154_hwsim.c
> >>>>> index 8caa61ec718f..00ec188a3257 100644
> >>>>> --- a/drivers/net/ieee802154/mac802154_hwsim.c
> >>>>> +++ b/drivers/net/ieee802154/mac802154_hwsim.c
> >>>>> @@ -786,6 +786,7 @@ static int hwsim_add_one(struct genl_info *info, struct device *dev,
> >>>>>              goto err_pib;
> >>>>>      }  
> >>>>>     > +      pib->page = 13;  
> >>>>
> >>>> You want to set channel not page here.  
> >>>
> >>> Oh crap /o\ I've messed that update badly. Of course I meant
> >>> pib->channel here, as it is in the commit log.
> >>>
> >>> I'll wait for Alexander's feedback before re-spinning. Unless the rest
> >>> looks good for you both, I don't know if your policy allows you to fix
> >>> it when applying, anyhow I'll do what is necessary.  
> >>
> >> If Alex has nothing else and there is no re-spin I fix this when
> >> applying, no worries.  
> > 
> > Everything is fine.
> > 
> > Acked-by: Alexander Aring <aahringo@redhat.com>
> > 
> > On the whole series. Thanks.  
> 
> Fixed up this commit and applied the whole patchset.
> 
> Next one we should look at would be the 3 split out cleanup patches.

Great!

Thanks,
Miquèl
