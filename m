Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C078011D088
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 16:08:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728962AbfLLPIP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 10:08:15 -0500
Received: from guitar.tcltek.co.il ([192.115.133.116]:36284 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728683AbfLLPIO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Dec 2019 10:08:14 -0500
Received: from sapphire.tkos.co.il (unknown [192.168.100.188])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.tkos.co.il (Postfix) with ESMTPS id 55160440022;
        Thu, 12 Dec 2019 17:08:11 +0200 (IST)
Date:   Thu, 12 Dec 2019 17:08:10 +0200
From:   Baruch Siach <baruch@tkos.co.il>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>, netdev@vger.kernel.org,
        Denis Odintsov <d.odintsov@traviangames.com>,
        Hubert Feurstein <h.feurstein@gmail.com>
Subject: Re: [BUG] mv88e6xxx: tx regression in v5.3
Message-ID: <20191212150810.zx6o26jnk5croh4r@sapphire.tkos.co.il>
References: <87tv67tcom.fsf@tarshish>
 <20191211131111.GK16369@lunn.ch>
 <87fthqu6y6.fsf@tarshish>
 <20191211174938.GB30053@lunn.ch>
 <20191212085045.nqhfldkbebqzzamv@sapphire.tkos.co.il>
 <20191212131448.GA9959@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191212131448.GA9959@lunn.ch>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Thu, Dec 12, 2019 at 02:14:48PM +0100, Andrew Lunn wrote:
> > As you guessed, mv88e6xxx_mac_config() exits early because 
> > mv88e6xxx_phy_is_internal() returns true for port number 2, and 'mode' is 
> > MLO_AN_PHY. What is the right MAC/PHY setup flow in this case?
> 
> So this goes back to
> 
> commit d700ec4118f9d5e88db8f678e7342f28c93037b9
> Author: Marek Vasut <marex@denx.de>
> Date:   Wed Sep 12 00:15:24 2018 +0200
> 
>     net: dsa: mv88e6xxx: Make sure to configure ports with external PHYs
>     
>     The MV88E6xxx can have external PHYs attached to certain ports and those
>     PHYs could even be on different MDIO bus than the one within the switch.
>     This patch makes sure that ports with such PHYs are configured correctly
>     according to the information provided by the PHY.
> 
> @@ -709,13 +717,17 @@ static void mv88e6xxx_mac_config(struct dsa_switch *ds, int port,
>         struct mv88e6xxx_chip *chip = ds->priv;
>         int speed, duplex, link, pause, err;
>  
> -       if (mode == MLO_AN_PHY)
> +       if ((mode == MLO_AN_PHY) && mv88e6xxx_phy_is_internal(ds, port))
>                 return;
> 
> The idea being, that the MAC has direct knowledge of the PHY
> configuration because it is internal. There is no need to configure
> the MAC, it does it itself.
> 
> This assumption seems wrong for the switch you have.
> 
> I think it is just a optimisation. So we can probably remove this phy
> internal test.
> 
> And
>         } else if (!mv88e6xxx_phy_is_internal(ds, port)) {
> 
> also needs to change.
> 
> It would be interesting to know if the MAC is completely wrongly
> configured, or it is just a subset of parameters.

I compared phylib to phylink calls to mv88e6xxx_port_setup_mac(). It turns out 
that the phylink adds mv88e6xxx_port_setup_mac() call for the cpu port (port 5 
in my case) with these parameters and call stack:

[    4.219148] mv88e6xxx_port_setup_mac: port: 5 link: 0 speed: -1 duplex: 255
[    4.226144] CPU: 2 PID: 21 Comm: kworker/2:0 Not tainted 5.3.15-00003-gb9bb09189d02-dirty #104
[    4.234795] Hardware name: SolidRun ClearFog GT 8K (DT)
[    4.240044] Workqueue: events deferred_probe_work_func
[    4.245205] Call trace:
[    4.247661]  dump_backtrace+0x0/0x128
[    4.251339]  show_stack+0x14/0x1c
[    4.254669]  dump_stack+0xa4/0xd0
[    4.257998]  mv88e6xxx_port_setup_mac+0x78/0x2a0
[    4.262635]  mv88e6xxx_mac_config+0xd0/0x154
[    4.266924]  dsa_port_phylink_mac_config+0x2c/0x38
[    4.271736]  phylink_mac_config+0xe0/0x1cc
[    4.275849]  phylink_start+0xc8/0x224
[    4.279527]  dsa_port_link_register_of+0xe8/0x1b0
[    4.284251]  dsa_register_switch+0x7fc/0x908
[    4.288539]  mv88e6xxx_probe+0x62c/0x66c
[    4.292478]  mdio_probe+0x30/0x5c
[    4.295806]  really_probe+0x1d0/0x280
[    4.299483]  driver_probe_device+0xd4/0xe4
[    4.303596]  __device_attach_driver+0x94/0xa0
[    4.307971]  bus_for_each_drv+0x94/0xb4
[    4.311823]  __device_attach+0xc0/0x12c
[    4.315674]  device_initial_probe+0x10/0x18
[    4.319875]  bus_probe_device+0x2c/0x8c
[    4.323726]  deferred_probe_work_func+0x84/0x98
[    4.328276]  process_one_work+0x19c/0x258
[    4.332303]  process_scheduled_works+0x3c/0x40
[    4.336765]  worker_thread+0x228/0x2f8
[    4.340530]  kthread+0x114/0x124
[    4.343771]  ret_from_fork+0x10/0x18

This hunk removed that mv88e6xxx_port_setup_mac() call, and fixed Tx for me on 
v5.3.15:

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index d0a97eb73a37..f0457274b5a9 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -611,6 +611,9 @@ static void mv88e6xxx_mac_config(struct dsa_switch *ds, int port,
 	if ((mode == MLO_AN_PHY) && mv88e6xxx_phy_is_internal(ds, port))
 		return;
 
+	if (dsa_is_cpu_port(ds, port))
+		return;
+
 	if (mode == MLO_AN_FIXED) {
 		link = LINK_FORCED_UP;
 		speed = state->speed;

Is that the right solution? Or maybe mv88e6xxx_port_setup_mac() should be 
called again when the cpu interface goes up?

baruch

-- 
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
