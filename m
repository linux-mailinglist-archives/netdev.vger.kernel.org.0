Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08BD811D51F
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 19:17:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730404AbfLLSRe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 13:17:34 -0500
Received: from guitar.tcltek.co.il ([192.115.133.116]:36315 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730362AbfLLSRe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Dec 2019 13:17:34 -0500
Received: from sapphire.tkos.co.il (unknown [192.168.100.188])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.tkos.co.il (Postfix) with ESMTPS id D8E79440159;
        Thu, 12 Dec 2019 20:17:30 +0200 (IST)
Date:   Thu, 12 Dec 2019 20:17:29 +0200
From:   Baruch Siach <baruch@tkos.co.il>
To:     Andrew Lunn <andrew@lunn.ch>,
        Marek =?utf-8?B?QmVow7pu?= <marek.behun@nic.cz>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>, netdev@vger.kernel.org,
        Denis Odintsov <d.odintsov@traviangames.com>,
        Hubert Feurstein <h.feurstein@gmail.com>
Subject: Re: [BUG] mv88e6xxx: tx regression in v5.3
Message-ID: <20191212181729.mviz5c26ysebg4w3@sapphire.tkos.co.il>
References: <87tv67tcom.fsf@tarshish>
 <20191211131111.GK16369@lunn.ch>
 <87fthqu6y6.fsf@tarshish>
 <20191211174938.GB30053@lunn.ch>
 <20191212085045.nqhfldkbebqzzamv@sapphire.tkos.co.il>
 <20191212131448.GA9959@lunn.ch>
 <20191212150810.zx6o26jnk5croh4r@sapphire.tkos.co.il>
 <20191212151355.GE30053@lunn.ch>
 <20191212152355.iiepmi4cjriddeon@sapphire.tkos.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191212152355.iiepmi4cjriddeon@sapphire.tkos.co.il>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew, Marek,

On Thu, Dec 12, 2019 at 05:23:57PM +0200, Baruch Siach wrote:
> On Thu, Dec 12, 2019 at 04:13:55PM +0100, Andrew Lunn wrote:
> > > I compared phylib to phylink calls to mv88e6xxx_port_setup_mac(). It turns out 
> > > that the phylink adds mv88e6xxx_port_setup_mac() call for the cpu port (port 5 
> > > in my case) with these parameters and call stack:
> > > 
> > > [    4.219148] mv88e6xxx_port_setup_mac: port: 5 link: 0 speed: -1 duplex: 255
> > > [    4.226144] CPU: 2 PID: 21 Comm: kworker/2:0 Not tainted 5.3.15-00003-gb9bb09189d02-dirty #104
> > > [    4.234795] Hardware name: SolidRun ClearFog GT 8K (DT)
> > > [    4.240044] Workqueue: events deferred_probe_work_func
> > > [    4.245205] Call trace:
> > > [    4.247661]  dump_backtrace+0x0/0x128
> > > [    4.251339]  show_stack+0x14/0x1c
> > > [    4.254669]  dump_stack+0xa4/0xd0
> > > [    4.257998]  mv88e6xxx_port_setup_mac+0x78/0x2a0
> > > [    4.262635]  mv88e6xxx_mac_config+0xd0/0x154
> > > [    4.266924]  dsa_port_phylink_mac_config+0x2c/0x38
> > > [    4.271736]  phylink_mac_config+0xe0/0x1cc
> > > [    4.275849]  phylink_start+0xc8/0x224
> > > [    4.279527]  dsa_port_link_register_of+0xe8/0x1b0
> > > [    4.284251]  dsa_register_switch+0x7fc/0x908
> > > [    4.288539]  mv88e6xxx_probe+0x62c/0x66c
> > > [    4.292478]  mdio_probe+0x30/0x5c
> > > [    4.295806]  really_probe+0x1d0/0x280
> > > [    4.299483]  driver_probe_device+0xd4/0xe4
> > > [    4.303596]  __device_attach_driver+0x94/0xa0
> > > [    4.307971]  bus_for_each_drv+0x94/0xb4
> > > [    4.311823]  __device_attach+0xc0/0x12c
> > > [    4.315674]  device_initial_probe+0x10/0x18
> > > [    4.319875]  bus_probe_device+0x2c/0x8c
> > > [    4.323726]  deferred_probe_work_func+0x84/0x98
> > > [    4.328276]  process_one_work+0x19c/0x258
> > > [    4.332303]  process_scheduled_works+0x3c/0x40
> > > [    4.336765]  worker_thread+0x228/0x2f8
> > > [    4.340530]  kthread+0x114/0x124
> > > [    4.343771]  ret_from_fork+0x10/0x18
> > > 
> > > This hunk removed that mv88e6xxx_port_setup_mac() call, and fixed Tx for me on 
> > > v5.3.15:
> > > 
> > > diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
> > > index d0a97eb73a37..f0457274b5a9 100644
> > > --- a/drivers/net/dsa/mv88e6xxx/chip.c
> > > +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> > > @@ -611,6 +611,9 @@ static void mv88e6xxx_mac_config(struct dsa_switch *ds, int port,
> > >  	if ((mode == MLO_AN_PHY) && mv88e6xxx_phy_is_internal(ds, port))
> > >  		return;
> > >  
> > > +	if (dsa_is_cpu_port(ds, port))
> > > +		return;
> > > +
> > >  	if (mode == MLO_AN_FIXED) {
> > >  		link = LINK_FORCED_UP;
> > >  		speed = state->speed;
> > > 
> > > Is that the right solution?
> > 
> > What needs testing is:
> > 
> >                                         port@0 {
> >                                                 reg = <0>;
> >                                                 label = "cpu";
> >                                                 ethernet = <&fec1>;
> > 
> >                                                 fixed-link {
> >                                                         speed = <100>;
> >                                                         full-duplex;
> >                                                 };
> > 
> > At some point, there is a call to configure the CPU port to 100Mbps,
> > because the SoC Ethernet does not support 1G. We need to ensure this
> > does not break with your change.
> 
> So maybe this:
> 
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
> index d0a97eb73a37..84ca4f36a778 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.c
> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> @@ -611,6 +611,9 @@ static void mv88e6xxx_mac_config(struct dsa_switch *ds, int port,
>  	if ((mode == MLO_AN_PHY) && mv88e6xxx_phy_is_internal(ds, port))
>  		return;
>  
> +	if (mode != MLO_AN_FIXED && dsa_is_cpu_port(ds, port))
> +		return;
> +
>  	if (mode == MLO_AN_FIXED) {
>  		link = LINK_FORCED_UP;
>  		speed = state->speed;

This is not enough to fix v5.4, though. Commit 7a3007d22e8dc ("net: dsa: 
mv88e6xxx: fully support SERDES on Topaz family") breaks switch Tx on SolidRun 
Clearfog GT-8K in much the same way. I could not easily revert 7a3007d22e8dc 
on top of v5.4, but this is enough to make Tx work again with v5.4:

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 7b5b73499e37..e7e6400a994e 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3191,7 +3191,6 @@ static const struct mv88e6xxx_ops mv88e6141_ops = {
 	.port_disable_pri_override = mv88e6xxx_port_disable_pri_override,
 	.port_link_state = mv88e6352_port_link_state,
 	.port_get_cmode = mv88e6352_port_get_cmode,
-	.port_set_cmode = mv88e6341_port_set_cmode,
 	.port_setup_message_port = mv88e6xxx_setup_message_port,
 	.stats_snapshot = mv88e6390_g1_stats_snapshot,
 	.stats_set_histogram = mv88e6095_g1_stats_set_histogram,

Marek, do you have any idea how to properly fix this?

Thanks,
baruch

-- 
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
