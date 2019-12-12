Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED73F11D630
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 19:48:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730434AbfLLSst (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 13:48:49 -0500
Received: from guitar.tcltek.co.il ([192.115.133.116]:36328 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730433AbfLLSst (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Dec 2019 13:48:49 -0500
Received: from sapphire.tkos.co.il (unknown [192.168.100.188])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.tkos.co.il (Postfix) with ESMTPS id CCF75440406;
        Thu, 12 Dec 2019 20:48:29 +0200 (IST)
Date:   Thu, 12 Dec 2019 20:48:46 +0200
From:   Baruch Siach <baruch@tkos.co.il>
To:     Marek Behun <marek.behun@nic.cz>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        netdev@vger.kernel.org,
        Denis Odintsov <d.odintsov@traviangames.com>,
        Hubert Feurstein <h.feurstein@gmail.com>
Subject: Re: [BUG] mv88e6xxx: tx regression in v5.3
Message-ID: <20191212184846.nse4jxkyt2qe6bng@sapphire.tkos.co.il>
References: <20191211131111.GK16369@lunn.ch>
 <87fthqu6y6.fsf@tarshish>
 <20191211174938.GB30053@lunn.ch>
 <20191212085045.nqhfldkbebqzzamv@sapphire.tkos.co.il>
 <20191212131448.GA9959@lunn.ch>
 <20191212150810.zx6o26jnk5croh4r@sapphire.tkos.co.il>
 <20191212151355.GE30053@lunn.ch>
 <20191212152355.iiepmi4cjriddeon@sapphire.tkos.co.il>
 <20191212181729.mviz5c26ysebg4w3@sapphire.tkos.co.il>
 <20191212193218.2f91df52@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191212193218.2f91df52@nic.cz>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marek,

On Thu, Dec 12, 2019 at 07:32:18PM +0100, Marek Behun wrote:
> On Thu, 12 Dec 2019 20:17:29 +0200
> Baruch Siach <baruch@tkos.co.il> wrote:
> 
> > This is not enough to fix v5.4, though. Commit 7a3007d22e8dc ("net: dsa: 
> > mv88e6xxx: fully support SERDES on Topaz family") breaks switch Tx on SolidRun 
> > Clearfog GT-8K in much the same way. I could not easily revert 7a3007d22e8dc 
> > on top of v5.4, but this is enough to make Tx work again with v5.4:
> > 
> > diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
> > index 7b5b73499e37..e7e6400a994e 100644
> > --- a/drivers/net/dsa/mv88e6xxx/chip.c
> > +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> > @@ -3191,7 +3191,6 @@ static const struct mv88e6xxx_ops mv88e6141_ops = {
> >  	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
> >  	.port_link_state = mv88e6352_port_link_state,
> >  	.port_get_cmode = mv88e6352_port_get_cmode,
> > -	.port_set_cmode = mv88e6341_port_set_cmode,
> >  	.port_setup_message_port = mv88e6xxx_setup_message_port,
> >  	.stats_snapshot = mv88e6390_g1_stats_snapshot,
> >  	.stats_set_histogram = mv88e6095_g1_stats_set_histogram,
> > 
> > Marek, do you have any idea how to properly fix this?
> 
> can you tell on which port the port_set_cmode is called when things
> break? Because if it is other than port 5, than method
> mv88e6341_port_set_cmode does nothing. If it is port 5, do you have cpu
> connected to the switch via port 5? What phy mode?

This is indeed port 5. It is connected to the cpu (Armada 8040). PHY mode is 
19 (PHY_INTERFACE_MODE_2500BASEX).

I have now tested v5.5-rc1 which behaves just like v5.4. The same "fix" works 
with v5.5-rc1.

Thanks,
baruch

-- 
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
