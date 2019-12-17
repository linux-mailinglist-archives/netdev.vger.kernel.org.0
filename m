Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFCB41234CD
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 19:26:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727070AbfLQS0s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 13:26:48 -0500
Received: from guitar.tcltek.co.il ([192.115.133.116]:36758 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726191AbfLQS0r (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 13:26:47 -0500
Received: from sapphire.tkos.co.il (unknown [192.168.100.188])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.tkos.co.il (Postfix) with ESMTPS id 56910440567;
        Tue, 17 Dec 2019 20:26:44 +0200 (IST)
Date:   Tue, 17 Dec 2019 20:26:43 +0200
From:   Baruch Siach <baruch@tkos.co.il>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Marek Behun <marek.behun@nic.cz>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        netdev@vger.kernel.org,
        Denis Odintsov <d.odintsov@traviangames.com>,
        Hubert Feurstein <h.feurstein@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [BUG] mv88e6xxx: tx regression in v5.3
Message-ID: <20191217182643.augknhx57pafnelv@sapphire.tkos.co.il>
References: <20191212152355.iiepmi4cjriddeon@sapphire.tkos.co.il>
 <20191212193611.63111051@nic.cz>
 <20191212190640.6vki2pjfacdnxihh@sapphire.tkos.co.il>
 <20191212193129.GF30053@lunn.ch>
 <20191212204141.16a406cd@nic.cz>
 <8736dlucai.fsf@tarshish>
 <871rt5u9no.fsf@tarshish>
 <20191215145349.GB22725@lunn.ch>
 <87y2vdsk32.fsf@tarshish>
 <20191215161423.GE22725@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191215161423.GE22725@lunn.ch>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Sun, Dec 15, 2019 at 05:14:23PM +0100, Andrew Lunn wrote:
> On Sun, Dec 15, 2019 at 05:08:01PM +0200, Baruch Siach wrote:
> > On Sun, Dec 15 2019, Andrew Lunn wrote:
> > >> This fixes cpu port configuration for me:
> > >>
> > >> diff --git a/drivers/net/dsa/mv88e6xxx/port.c b/drivers/net/dsa/mv88e6xxx/port.c
> > >> index 7fe256c5739d..a6c320978bcf 100644
> > >> --- a/drivers/net/dsa/mv88e6xxx/port.c
> > >> +++ b/drivers/net/dsa/mv88e6xxx/port.c
> > >> @@ -427,10 +427,6 @@ static int mv88e6xxx_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
> > >>  		cmode = 0;
> > >>  	}
> > >>
> > >> -	/* cmode doesn't change, nothing to do for us */
> > >> -	if (cmode == chip->ports[port].cmode)
> > >> -		return 0;
> > >> -
> > >>  	lane = mv88e6xxx_serdes_get_lane(chip, port);
> > >>  	if (lane) {
> > >>  		if (chip->ports[port].serdes_irq) {
> > >>
> > >> Does that make sense?
> > >
> > > This needs testing on a 6390, with a port 9 or 10 using fixed link. We
> > > have had issues in the past where mac_config() has been called once
> > > per second, and each time it reconfigured the MAC, causing the link to
> > > go down/up. So we try to avoid doing work which is not requires and
> > > which could upset the link.
> > 
> > You refer to ed8fe20205ac ("net: dsa: mv88e6xxx: prevent interrupt storm
> > caused by mv88e6390x_port_set_cmode") that introduced this code.
> > 
> > The alternative is to call ->port_get_cmode() to refresh the cmode cache
> > after mv88e6xxx_port_hidden_write().
> 
> Refreshing the cmode after mv88e6xxx_port_hidden_write() sounds like a
> good idea. But please limit it to just switches which need to make
> cmode writable. cmode is rather fragile and the 6390 family is easy to
> break in this area.

This turned out to be much harder than expected. cmode update after 
mv88e6xxx_port_hidden_write() breaks the serdes configuration. The link change 
irq does not trigger on serdes interface up. The strange thing is that if I 
add 10ms delay after cmode read (or anywhere before the mv88e6xxx_port_write() 
call in mv88e6xxx_port_set_cmode()) it works again. I have no idea what is 
going on here. The cmode cache is used in many places, so maybe setting it to 
an invalid value (6) is not a good idea.

I ended up with cmode write force in mv88e6341_port_set_cmode_writable() like 
this:

diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index 8a8e38bfb161..70284f100d87 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -233,6 +233,7 @@ struct mv88e6xxx_port {
 	u64 vtu_member_violation;
 	u64 vtu_miss_violation;
 	u8 cmode;
+	bool force_cmode;
 	bool mirror_ingress;
 	bool mirror_egress;
 	unsigned int serdes_irq;
diff --git a/drivers/net/dsa/mv88e6xxx/port.c b/drivers/net/dsa/mv88e6xxx/port.c
index 7fe256c5739d..8e8724eb5669 100644
--- a/drivers/net/dsa/mv88e6xxx/port.c
+++ b/drivers/net/dsa/mv88e6xxx/port.c
@@ -427,9 +427,10 @@ static int mv88e6xxx_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
 		cmode = 0;
 	}
 
-	/* cmode doesn't change, nothing to do for us */
-	if (cmode == chip->ports[port].cmode)
+	/* cmode doesn't change, nothing to do for us unless forced */
+	if (cmode == chip->ports[port].cmode && !chip->ports[port].force_cmode)
 		return 0;
+	chip->ports[port].force_cmode = false;
 
 	lane = mv88e6xxx_serdes_get_lane(chip, port);
 	if (lane) {
@@ -516,6 +517,8 @@ static int mv88e6341_port_set_cmode_writable(struct mv88e6xxx_chip *chip,
 	if (port != 5)
 		return -EOPNOTSUPP;
 
+	chip->ports[port].force_cmode = true;
+
 	addr = chip->info->port_base_addr + port;
 
 	err = mv88e6xxx_port_hidden_read(chip, 0x7, addr, 0, &reg);

Does that look right?

baruch

-- 
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
