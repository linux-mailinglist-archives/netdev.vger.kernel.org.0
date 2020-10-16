Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7005D28FCEA
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 05:31:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394172AbgJPDbp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 23:31:45 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59254 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394159AbgJPDbo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Oct 2020 23:31:44 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kTGT0-001v2C-6N; Fri, 16 Oct 2020 05:31:42 +0200
Date:   Fri, 16 Oct 2020 05:31:42 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     michael alayev <mic.al.linux@gmail.com>
Cc:     vivien.didelot@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Dts for eth network based on marvell's mv88e6390x crashes
 Xilinx's linux-kernel v5.4
Message-ID: <20201016033142.GB456889@lunn.ch>
References: <CANBsoPmgct2UTq=Cuf1rXJRitiF1mWhWwdtH2=73yyZiJbT0rg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANBsoPmgct2UTq=Cuf1rXJRitiF1mWhWwdtH2=73yyZiJbT0rg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 11, 2020 at 03:31:52PM +0300, michael alayev wrote:
> Hello,
> 
> This is my system's network topology. It relies on Xilinx's Zynq-7000 soc.
> 
> zynq-7000      switch1       switch2
>  (cpu)       mv88e6390x    mv88e6390x
> -------      ---------     ---------
> |     |      |       |     |       |
> | gem0|------|p0  p10|-----|p10    |
> |     |      |       |     |       |
> |     |      ---------     ---------
> |     |         |mdio_addr=2   | mdio_addr=3
> |     |         |              |
> |     |-------------------------
> |     |    |
> |     |    |              mv88e1510(phy)
> |     |    |  mdio_addr=1 --------
> |     |    ---------------|      |
> |     |                   |      |
> | gem1|-------------------|      |
> |     |                   |      |
> |     |                   --------
> -------
> 
> I have built a v5.4 linux kernel for it and its ethernet network defined in the device-tree as follows
> 
> (arch/arm/boot/dts/zynq-zed.dts gem0 and gem1)   :
> 
> &gem0 {
> status = "okay";
> phy-mode = "rgmii-id";
> phy-handle = <&phy0>;
> 
> 
> mdio {
> #address-cells = <1>;
> #size-cells = <0>;
> 
> phy0: ethernet-phy@0 {
> compatible = "marvell";
> reg = <0>;
> device_type = "ethernet-phy";
> fixed-link {
> speed = <1000>;
> full-duplex;
> };
> };
> 
> debug_phy: ethernet-phy@1 {
> compatible = "marvell";
> reg = <1>;
> device_type = "ethernet-phy";
> label = "debug-phy";
> };

Hi Michael

This is pretty unreadable with all the white space removed. Please
could you post again with the white space.

> 
> Starting kernel ...
> ...
> [   40.953876] [<c05ab9cc>] (dsa_unregister_switch) from [<c042c980>] (mv88e6xxx_remove+0x1c/0x6c)
> [   40.962602] [<c042c980>] (mv88e6xxx_remove) from [<c042572c>] (mdio_remove+0x1c/0x38)
> [   40.970457] [<c042572c>] (mdio_remove) from [<c03cb4a4>] (device_release_driver_internal+0xf0/0x194)
> [   40.979612] [<c03cb4a4>] (device_release_driver_internal) from [<c03ca1e8>] (bus_remove_device+0xcc/0xdc)
> [   40.989201] [<c03ca1e8>] (bus_remove_device) from [<c03c7108>] (device_del+0x170/0x288)
> [   40.997227] [<c03c7108>] (device_del) from [<c0425674>] (mdio_device_remove+0xc/0x18)
> [   41.005073] [<c0425674>] (mdio_device_remove) from [<c0425024>] (mdiobus_unregister+0x50/0x84)
> [   41.013714] [<c0425024>] (mdiobus_unregister) from [<c043ac2c>] (macb_probe+0x88c/0xa68)
> [   41.021834] [<c043ac2c>] (macb_probe) from [<c03cc6d0>] (platform_drv_probe+0x48/0x98)
> [   41.029771] [<c03cc6d0>] (platform_drv_probe) from [<c03cad04>] (really_probe+0x140/0x2f8)
> [   41.038060] [<c03cad04>] (really_probe) from [<c03cb110>] (driver_probe_device+0x10c/0x154)
> [   41.046427] [<c03cb110>] (driver_probe_device) from [<c03cb2e4>] (device_driver_attach+0x44/0x5c)
> [   41.055316] [<c03cb2e4>] (device_driver_attach) from [<c03cb3a8>] (__driver_attach+0xac/0xb8)
> [   41.063856] [<c03cb3a8>] (__driver_attach) from [<c03c93b8>] (bus_for_each_dev+0x64/0xa0)
> [   41.072049] [<c03c93b8>] (bus_for_each_dev) from [<c03ca2d4>] (bus_add_driver+0xdc/0x1bc)
> [   41.080244] [<c03ca2d4>] (bus_add_driver) from [<c03cba60>] (driver_register+0xb0/0xf8)
> [   41.088266] [<c03cba60>] (driver_register) from [<c01026e0>] (do_one_initcall+0x74/0x164)
> [   41.096469] [<c01026e0>] (do_one_initcall) from [<c0800e38>] (kernel_init_freeable+0x108/0x1d8)
> [   41.105192] [<c0800e38>] (kernel_init_freeable) from [<c05e829c>] (kernel_init+0x8/0x110)
> [   41.113391] [<c05e829c>] (kernel_init) from [<c01010e8>] (ret_from_fork+0x14/0x2c)

This looks like the classic first time probe -EPROBE_DEFER. You expect
this path to happen, but not the invalid access. macb_probe will
register the mdio bus which causes the switches to probe. But because
macb_probe has not got so far as to call register_netdev, the gem
interface is not available, so DSA ends up returning
EPROBE_DEFER. What normally happens is that macb_probe continues, and
registers the network interface. The switches get probed again later
and it all works.

The real question is, why does the unroll go wrong when -EPROBE_DEFER
is returned?

   Andrew
