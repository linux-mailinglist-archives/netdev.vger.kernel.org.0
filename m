Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C85439C0EE
	for <lists+netdev@lfdr.de>; Sun, 25 Aug 2019 01:16:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728055AbfHXXQ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Aug 2019 19:16:56 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57634 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727708AbfHXXQ4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 24 Aug 2019 19:16:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=OGPFfnAlNSBCVbfCct8tv1ubgptGzVdAQ99onXvNQcg=; b=mDQvi/kdz4XHmo8E6PFJN8lbuH
        cTSJ9Df0LYPtCkJKN9HaNHMV4LW6MmbyzRGjSX28ZWJfhLTLfs8GgG1SafaDMyHpKu5eKWJk/7H8W
        WSR0g8AvNXRHF5Rx5GQmT1BhMRLCPfrhpLS/EG29AXVleCwXEhYQRloShwbayyrlSk10=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i1fHB-0004yp-Ic; Sun, 25 Aug 2019 01:16:53 +0200
Date:   Sun, 25 Aug 2019 01:16:53 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vivien Didelot <vivien.didelot@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>
Subject: Re: Regresion with dsa_port_disable
Message-ID: <20190824231653.GA17726@lunn.ch>
References: <20190824225306.GA15986@lunn.ch>
 <20190824191220.GB1808@t480s.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190824191220.GB1808@t480s.localdomain>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 24, 2019 at 07:12:20PM -0400, Vivien Didelot wrote:
> Hi Andrew,
> 
> On Sun, 25 Aug 2019 00:53:06 +0200, Andrew Lunn <andrew@lunn.ch> wrote:
> > I just booted a ZII devel C and got a new warning splat.
> > 
> > WARNING: CPU: 0 PID: 925 at kernel/irq/manage.c:1708 __free_irq+0xc8/0x2c4
> > Trying to free already-free IRQ 0
> > Modules linked in:
> > CPU: 0 PID: 925 Comm: kworker/0:2 Not tainted 5.3.0-rc5-01151-g7ff758fcdf65 #231
> > Hardware name: Freescale Vybrid VF5xx/VF6xx (Device Tree)
> > Workqueue: events deferred_probe_work_func
> > Backtrace: 
> > [<8010d9e4>] (dump_backtrace) from [<8010dd9c>] (show_stack+0x20/0x24)
> >  r7:8016edf8 r6:00000009 r5:00000000 r4:9ec67944
> > [<8010dd7c>] (show_stack) from [<8083b03c>] (dump_stack+0x24/0x28)
> > [<8083b018>] (dump_stack) from [<8011c108>] (__warn.part.3+0xcc/0xf8)
> > [<8011c03c>] (__warn.part.3) from [<8011c1ac>] (warn_slowpath_fmt+0x78/0x94)
> >  r6:000006ac r5:80a8cbf0 r4:80d07088
> > [<8011c138>] (warn_slowpath_fmt) from [<8016edf8>] (__free_irq+0xc8/0x2c4)
> >  r3:00000000 r2:80a8cca8
> >  r7:9f486668 r6:9ee25268 r5:9f486600 r4:9ee25268
> > [<8016ed30>] (__free_irq) from [<8016f07c>] (free_irq+0x38/0x74)
> >  r10:9eeb3600 r9:9e412040 r8:00000009 r7:9ee26040 r6:9ee2404c r5:9ee242c8
> >  r4:9ee25268 r3:00000c00
> > [<8016f044>] (free_irq) from [<805a244c>] (mv88e6390x_serdes_irq_free+0x68/0x98)
> >  r5:9ee242c8 r4:9ee24040
> > [<805a23e4>] (mv88e6390x_serdes_irq_free) from [<8059bc94>] (mv88e6xxx_port_disable+0x58/0x98)
> >  r7:9ee26040 r6:00000009 r5:9ee2404c r4:9ee24040
> > [<8059bc3c>] (mv88e6xxx_port_disable) from [<80806f70>] (dsa_port_disable+0x44/0x50)
> >  r7:9ee26040 r6:9ee26d74 r5:00000009 r4:9ee26040
> > [<80806f2c>] (dsa_port_disable) from [<80805df0>] (dsa_register_switch+0x964/0xab8)
> >  r5:9efe194c r4:9ee26d38
> > [<8080548c>] (dsa_register_switch) from [<8059b734>] (mv88e6xxx_probe+0x730/0x778)
> >  r10:80943e64 r9:9fbf77d0 r8:00000000 r7:80d07088 r6:9e410040 r5:00000000
> >  r4:9e40e800
> > [<8059b004>] (mv88e6xxx_probe) from [<80582da8>] (mdio_probe+0x40/0x64)
> >  r10:00000012 r9:80d5eccc r8:00000000 r7:00000000 r6:8141f358 r5:9e40e800
> >  r4:80d5eccc
> > [<80582d68>] (mdio_probe) from [<80518858>] (really_probe+0x100/0x2d8)
> >  r5:9e40e800 r4:8141f354
> > 
> > The previous code was careful to balance mv88e6352_serdes_irq_setup()
> > with mv88e6390x_serdes_irq_free(). I _think_ your change broke this
> > balance, and we now try to free an interrupt which was never
> > allocated.
> 
> What do you mean by "balance mv88e6352_serdes_irq_setup() with
> mv88e6390x_serdes_irq_free()"?

Hi Vivien

It never called mv88e6390x_serdes_irq_free() unless
mv88e6352_serdes_irq_setup() had been called first.
mv88e6390x_serdes_irq_free() makes the assumption there actually is an
interrupt to free. I suspect your changes now call
mv88e6390x_serdes_irq_free() unconditionally.

	Andrew
