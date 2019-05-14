Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 839E61C95E
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 15:27:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726148AbfENN06 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 09:26:58 -0400
Received: from mx2.suse.de ([195.135.220.15]:48368 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725854AbfENN06 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 May 2019 09:26:58 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id AB97AAD36;
        Tue, 14 May 2019 13:26:56 +0000 (UTC)
Message-ID: <1557839644.11261.4.camel@suse.com>
Subject: Re: [PATCH 2/3] aqc111: fix writing to the phy on BE
From:   Oliver Neukum <oneukum@suse.com>
To:     Igor Russkikh <Igor.Russkikh@aquantia.com>,
        Dmitry Bezrukov <Dmitry.Bezrukov@aquantia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Date:   Tue, 14 May 2019 15:14:04 +0200
In-Reply-To: <cd6754c6-8384-a65c-1c0e-0e3d2eaaa66b@aquantia.com>
References: <20190509090818.9257-1-oneukum@suse.com>
         <20190509090818.9257-2-oneukum@suse.com>
         <cd6754c6-8384-a65c-1c0e-0e3d2eaaa66b@aquantia.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Di, 2019-05-14 at 12:11 +0000, Igor Russkikh wrote:
> On 09.05.2019 12:08, Oliver Neukum wrote:
> > When writing to the phy on BE architectures an internal data structure
> > was directly given, leading to it being byte swapped in the wrong
> > way for the CPU in 50% of all cases. A temporary buffer must be used.
> > 
> > Signed-off-by: Oliver Neukum <oneukum@suse.com>
> > ---
> >  drivers/net/usb/aqc111.c | 23 +++++++++++++++++------
> >  1 file changed, 17 insertions(+), 6 deletions(-)
> > 
> > diff --git a/drivers/net/usb/aqc111.c b/drivers/net/usb/aqc111.c
> > index 408df2d335e3..599d560a8450 100644
> > --- a/drivers/net/usb/aqc111.c
> > +++ b/drivers/net/usb/aqc111.c
> > @@ -320,6 +320,7 @@ static int aqc111_get_link_ksettings(struct net_device *net,
> >  static void aqc111_set_phy_speed(struct usbnet *dev, u8 autoneg, u16 speed)
> >  {
> >  	struct aqc111_data *aqc111_data = dev->driver_priv;
> > +	u32 phy_on_the_wire;
> >  
> >  	aqc111_data->phy_cfg &= ~AQ_ADV_MASK;
> >  	aqc111_data->phy_cfg |= AQ_PAUSE;
> > @@ -361,7 +362,8 @@ static void aqc111_set_phy_speed(struct usbnet *dev, u8 autoneg, u16 speed)
> >  		}
> >  	}
> >  
> > -	aqc111_write32_cmd(dev, AQ_PHY_OPS, 0, 0, &aqc111_data->phy_cfg);
> > +	phy_on_the_wire = aqc111_data->phy_cfg;
> > +	aqc111_write32_cmd(dev, AQ_PHY_OPS, 0, 0, &phy_on_the_wire);
> 
> Hi Oliver,
> 
> I see all write32_cmd and write16_cmd are using a temporary variable to do an
> internal cpu_to_le32. Why this extra temporary storage is needed?
> 
> The question is actually for both 2nd and third patch.
> In all the cases BE machine will store temporary bswap conversion in tmp
> variable and will not actually touch actual field.

Hi,

I am most terribly sorry. I overlooked the copy. Shall I revert or will
you.

	Sorry
		Oliver

