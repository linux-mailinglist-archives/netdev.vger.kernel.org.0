Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B64053FCFEA
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 01:27:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240694AbhHaX2Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 19:28:24 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50946 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234343AbhHaX2X (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Aug 2021 19:28:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=twgcO7A40eF8e4Wz/fRxGEP2Dz/URjaA1spYaISfANA=; b=H0S//2nFtcmO9FJ8hrjuzlT6LK
        jsQkQfjBO/f72o8duYy2qGU9PWkNqRBMyXaCKN8kFCJOfWr0MhDDX8YUmqdwoZZ/Fmd4GHXBUp0Ql
        euMGUaWbwiUC/5TC24fC2Tkg714yBP6sbWcQAH3he8flZvfQmQVuuntyl73rfz2f9hNQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mLD9y-004mBE-LJ; Wed, 01 Sep 2021 01:27:18 +0200
Date:   Wed, 1 Sep 2021 01:27:18 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Saravana Kannan <saravanak@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Len Brown <lenb@kernel.org>,
        Alvin Sipraga <ALSI@bang-olufsen.dk>, kernel-team@android.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH v1 1/2] driver core: fw_devlink: Add support for
 FWNODE_FLAG_BROKEN_PARENT
Message-ID: <YS661l5gIi3wcpHc@lunn.ch>
References: <YSlG4XRGrq5D1/WU@lunn.ch>
 <CAGETcx-ZvENq8tFZ9wb_BCPZabpZcqPrguY5rsg4fSNdOAB+Kw@mail.gmail.com>
 <YSpr/BOZj2PKoC8B@lunn.ch>
 <CAGETcx_mjY10WzaOvb=vuojbodK7pvY1srvKmimu4h6xWkeQuQ@mail.gmail.com>
 <YS4rw7NQcpRmkO/K@lunn.ch>
 <CAGETcx_QPh=ppHzBdM2_TYZz3o+O7Ab9-JSY52Yz1--iLnykxA@mail.gmail.com>
 <YS6nxLp5TYCK+mJP@lunn.ch>
 <CAGETcx90dOkw+Yp5ZRNqQq2Ny_ToOKvGJNpvyRohaRQi=SQxhw@mail.gmail.com>
 <YS608fdIhH4+qJsn@lunn.ch>
 <20210831231804.zozyenear45ljemd@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210831231804.zozyenear45ljemd@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 01, 2021 at 02:18:04AM +0300, Vladimir Oltean wrote:
> On Wed, Sep 01, 2021 at 01:02:09AM +0200, Andrew Lunn wrote:
> > Rev B is interesting because switch0 and switch1 got genphy, while
> > switch2 got the correct Marvell PHY driver. switch2 PHYs don't have
> > interrupt properties, so don't loop back to their parent device.
> 
> This is interesting and not what I really expected to happen. It goes to
> show that we really need more time to understand all the subtleties of
> device dependencies before jumping on patching stuff.

Here is the log on Rev B with the extra debug prints

Linux version 5.12.0-rc4-00011-gea718c699055-dirty (andrew@lenovo) (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binu
tils for Debian) 2.37) #20 Tue Aug 31 18:06:09 CDT 2021
CPU: ARMv7 Processor [410fc051] revision 1 (ARMv7), cr=10c53c7d
CPU: PIPT / VIPT nonaliasing data cache, VIPT aliasing instruction cache
OF: fdt: Machine model: ZII VF610 Development Board, Rev B
printk: bootconsole [earlycon0] enabled
Memory policy: Data cache writeback
Zone ranges:
  Normal   [mem 0x0000000080000000-0x000000009fffffff]
Movable zone start for each node
Early memory node ranges
  node   0: [mem 0x0000000080000000-0x000000009fffffff]
Initmem setup node 0 [mem 0x0000000080000000-0x000000009fffffff]
CPU: All CPU(s) started in SVC mode.
Built 1 zonelists, mobility grouping on.  Total pages: 130048
Kernel command line: root=/dev/nfs nfsroot=10.0.0.1:/srv/nfsroot/zii_devel_b,nfsvers=3,tcp ip=dhcp rw earlyprintk
Dentry cache hash table entries: 65536 (order: 6, 262144 bytes, linear)
Inode-cache hash table entries: 32768 (order: 5, 131072 bytes, linear)
mem auto-init: stack:off, heap alloc:off, heap free:off
Memory: 508204K/524288K available (7168K kernel code, 931K rwdata, 1644K rodata, 1024K init, 250K bss, 16084K reserved, 0K cma-reserved)
SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
ftrace: allocating 25455 entries in 50 pages
ftrace: allocated 50 pages with 3 groups
NR_IRQS: 16, nr_irqs: 16, preallocated irqs: 16
L2C-310 erratum 769419 enabled
L2C-310 dynamic clock gating enabled, standby mode enabled
L2C-310 cache controller enabled, 8 ways, 512 kB
L2C-310: CACHE_ID 0x410000c8, AUX_CTRL 0x06060000
random: get_random_bytes called from start_kernel+0x32c/0x470 with crng_init=0
sched_clock: 64 bits at 166MHz, resolution 5ns, wraps every 4398046511102ns
clocksource: arm_global_timer: mask: 0xffffffffffffffff max_cycles: 0x2674622ffc, max_idle_ns: 440795203810 ns
Switching to timer-based delay loop, resolution 5ns
Console: colour dummy device 80x30
printk: console [tty0] enabled
printk: bootconsole [earlycon0] disabled
Booting Linux on physical CPU 0x0
Linux version 5.12.0-rc4-00011-gea718c699055-dirty (andrew@lenovo) (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binu
tils for Debian) 2.37) #20 Tue Aug 31 18:06:09 CDT 2021
CPU: ARMv7 Processor [410fc051] revision 1 (ARMv7), cr=10c53c7d
CPU: PIPT / VIPT nonaliasing data cache, VIPT aliasing instruction cache
OF: fdt: Machine model: ZII VF610 Development Board, Rev B
printk: bootconsole [earlycon0] enabled
Memory policy: Data cache writeback
Zone ranges:
  Normal   [mem 0x0000000080000000-0x000000009fffffff]
Movable zone start for each node
Early memory node ranges
  node   0: [mem 0x0000000080000000-0x000000009fffffff]
Initmem setup node 0 [mem 0x0000000080000000-0x000000009fffffff]
CPU: All CPU(s) started in SVC mode.
Built 1 zonelists, mobility grouping on.  Total pages: 130048
Kernel command line: root=/dev/nfs nfsroot=10.0.0.1:/srv/nfsroot/zii_devel_b,nfsvers=3,tcp ip=dhcp rw earlyprintk
Dentry cache hash table entries: 65536 (order: 6, 262144 bytes, linear)
Inode-cache hash table entries: 32768 (order: 5, 131072 bytes, linear)
mem auto-init: stack:off, heap alloc:off, heap free:off
Memory: 508204K/524288K available (7168K kernel code, 931K rwdata, 1644K rodata, 1024K init, 250K bss, 16084K reserved, 0K cma-reserved)
SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
ftrace: allocating 25455 entries in 50 pages
ftrace: allocated 50 pages with 3 groups
NR_IRQS: 16, nr_irqs: 16, preallocated irqs: 16
L2C-310 erratum 769419 enabled
L2C-310 dynamic clock gating enabled, standby mode enabled
L2C-310 cache controller enabled, 8 ways, 512 kB
L2C-310: CACHE_ID 0x410000c8, AUX_CTRL 0x06060000
random: get_random_bytes called from start_kernel+0x32c/0x470 with crng_init=0
sched_clock: 64 bits at 166MHz, resolution 5ns, wraps every 4398046511102ns
clocksource: arm_global_timer: mask: 0xffffffffffffffff max_cycles: 0x2674622ffc, max_idle_ns: 440795203810 ns
Switching to timer-based delay loop, resolution 5ns
Console: colour dummy device 80x30
printk: console [tty0] enabled
printk: bootconsole [earlycon0] disabled
Calibrating delay loop (skipped), value calculated using timer frequency.. 333.47 BogoMIPS (lpj=1667368)
pid_max: default: 32768 minimum: 301
Mount-cache hash table entries: 1024 (order: 0, 4096 bytes, linear)
Mountpoint-cache hash table entries: 1024 (order: 0, 4096 bytes, linear)
CPU: Testing write buffer coherency: ok
Setting up static identity map for 0x80100000 - 0x8010003c
devtmpfs: initialized
VFP support v0.3: implementor 41 architecture 2 part 30 variant 5 rev 1
clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 19112604462750000 ns
futex hash table entries: 256 (order: -1, 3072 bytes, linear)
pinctrl core: initialized pinctrl subsystem
NET: Registered protocol family 16
DMA: preallocated 256 KiB pool for atomic coherent allocations
platform 40044000.spi: Linked as a consumer to 40048000.iomuxc
platform 4003b000.adc: Linked as a consumer to 40048000.iomuxc
platform 40029000.serial: Linked as a consumer to 40048000.iomuxc
platform 40028000.serial: Linked as a consumer to 40048000.iomuxc
platform 40027000.serial: Linked as a consumer to 40048000.iomuxc
platform 40066000.i2c: Linked as a consumer to 4004a000.gpio
platform 40066000.i2c: Linked as a consumer to 40048000.iomuxc
platform 40066000.i2c: Linked as a sync state only consumer to 4004c000.gpio
platform 40067000.i2c: Linked as a consumer to 40048000.iomuxc
platform 40080000.bus: Linked as a sync state only consumer to 40048000.iomuxc
platform 40080000.bus: Linked as a sync state only consumer to 4004c000.gpio
platform 400b2000.esdhc: Linked as a consumer to 40048000.iomuxc
platform 400d0000.ethernet: Linked as a consumer to 40048000.iomuxc
platform 400d1000.ethernet: Linked as a consumer to 40048000.iomuxc
platform 400e6000.i2c: Linked as a consumer to 40048000.iomuxc
platform 400e6000.i2c: Linked as a sync state only consumer to 4004c000.gpio
platform gpio-leds: Linked as a consumer to 40048000.iomuxc
platform gpio-leds: Linked as a sync state only consumer to 4004b000.gpio
platform 4003b000.adc: Linked as a consumer to regulator-vcc-3v3-mcu
platform 40034000.usb: Linked as a consumer to regulator-usb0-vbus
platform regulator-usb0-vbus: Linked as a consumer to 40049000.gpio
platform regulator-usb0-vbus: Linked as a consumer to 40048000.iomuxc
platform mdio-mux: Linked as a consumer to 40049000.gpio
platform mdio-mux: Linked as a consumer to 40048000.iomuxc
platform spi0: Linked as a consumer to 4004a000.gpio
platform spi0: Linked as a consumer to 40048000.iomuxc
platform spi0: Linked as a sync state only consumer to 4004d000.gpio
vf610-pinctrl 40048000.iomuxc: initialized IMX pinctrl driver
Kprobes globally optimized
platform regulator-usb0-vbus: probe deferral - supplier 40049000.gpio not ready
SCSI subsystem initialized
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
platform 40066000.i2c: probe deferral - supplier 4004a000.gpio not ready
i2c i2c-0: IMX I2C adapter registered
i2c i2c-0: using dma0chan0 (tx) and dma0chan1 (rx) for DMA transfers
i2c 1-0070: Linked as a consumer to 4004c000.gpio
i2c 1-0070: Linked as a consumer to 40048000.iomuxc
i2c i2c-1: IMX I2C adapter registered
i2c i2c-1: using dma0chan16 (tx) and dma0chan17 (rx) for DMA transfers
imx-i2c 400e6000.i2c: Dropping the link to 4004c000.gpio
pps_core: LinuxPPS API ver. 1 registered
pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
PTP clock support registered
Advanced Linux Sound Architecture Driver Initialized.
clocksource: Switched to clocksource arm_global_timer
NET: Registered protocol family 2
tcp_listen_portaddr_hash hash table entries: 512 (order: 0, 4096 bytes, linear)
TCP established hash table entries: 4096 (order: 2, 16384 bytes, linear)
TCP bind hash table entries: 4096 (order: 2, 16384 bytes, linear)
TCP: Hash tables configured (established 4096 bind 4096)
UDP hash table entries: 256 (order: 0, 4096 bytes, linear)
UDP-Lite hash table entries: 256 (order: 0, 4096 bytes, linear)
NET: Registered protocol family 1
RPC: Registered named UNIX socket transport module.
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
RPC: Registered tcp NFSv4.1 backchannel transport module.
workingset: timestamp_bits=30 max_order=17 bucket_order=0
io scheduler mq-deadline registered
io scheduler kyber registered
40027000.serial: ttyLP0 at MMIO 0x40027000 (irq = 19, base_baud = 5210526) is a FSL_LPUART
printk: console [ttyLP0] enabled
40028000.serial: ttyLP1 at MMIO 0x40028000 (irq = 20, base_baud = 5210526) is a FSL_LPUART
40029000.serial: ttyLP2 at MMIO 0x40029000 (irq = 21, base_baud = 5210526) is a FSL_LPUART
brd: module loaded
spi-nor spi0.0: mt25ql02g (262144 Kbytes)
spi-nor spi0.2: mt25ql02g (262144 Kbytes)
libphy: Fixed MDIO Bus: probed
libphy: fec_enet_mii_bus: probed
fec 400d1000.ethernet: Invalid MAC address: 00:00:00:00:00:00
fec 400d1000.ethernet: Using random MAC address: 1a:09:76:4a:0d:49
libphy: fec_enet_mii_bus: probed
usbcore: registered new interface driver asix
usbcore: registered new interface driver ax88179_178a
usbcore: registered new interface driver cdc_ether
usbcore: registered new interface driver net1080
usbcore: registered new interface driver cdc_subset
usbcore: registered new interface driver zaurus
usbcore: registered new interface driver cdc_ncm
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci-platform: EHCI generic platform driver
usbcore: registered new interface driver usb-storage
platform 40034000.usb: probe deferral - supplier regulator-usb0-vbus not ready
snvs_rtc 400a7000.snvs:snvs-rtc-lp: registered as rtc0
snvs_rtc 400a7000.snvs:snvs-rtc-lp: setting system clock to 1970-01-01T00:00:00 UTC (0)
i2c /dev entries driver
at24 2-0050: supply vcc not found, using dummy regulator
at24 2-0050: Linked as a consumer to regulator.0
at24 2-0050: Dropping the link to regulator.0
i2c i2c-1: Added multiplexed i2c bus 2
at24 3-0050: supply vcc not found, using dummy regulator
at24 3-0050: Linked as a consumer to regulator.0
at24 3-0050: Dropping the link to regulator.0
i2c i2c-1: Added multiplexed i2c bus 3
at24 4-0050: supply vcc not found, using dummy regulator
at24 4-0050: Linked as a consumer to regulator.0
at24 4-0050: 256 byte 24c02 EEPROM, writable, 1 bytes/write
i2c i2c-1: Added multiplexed i2c bus 4
at24 5-0050: supply vcc not found, using dummy regulator
at24 5-0050: Linked as a consumer to regulator.0
at24 5-0050: 256 byte 24c02 EEPROM, writable, 1 bytes/write
i2c i2c-1: Added multiplexed i2c bus 5
i2c i2c-1: Added multiplexed i2c bus 6
i2c i2c-1: Added multiplexed i2c bus 7
i2c i2c-1: Added multiplexed i2c bus 8
i2c i2c-1: Added multiplexed i2c bus 9
pca954x 1-0070: registered 8 multiplexed busses for I2C switch pca9548
sdhci: Secure Digital Host Controller Interface driver
sdhci: Copyright(c) Pierre Ossman
sdhci-pltfm: SDHCI platform and OF driver helper
leds-gpio gpio-leds: Dropping the link to 4004b000.gpio
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
vf610-adc 4003b000.adc: Linked as a consumer to regulator.1
NET: Registered protocol family 17
mmc0: SDHCI controller on 400b2000.esdhc [400b2000.esdhc] using ADMA
lm75 10-0048: supply vs not found, using dummy regulator
lm75 10-0048: Linked as a consumer to regulator.0
lm75 10-0048: hwmon0: sensor 'lm75'
at24 10-0050: supply vcc not found, using dummy regulator
at24 10-0050: Linked as a consumer to regulator.0
at24 10-0050: 512 byte 24c04 EEPROM, writable, 1 bytes/write
at24 10-0052: supply vcc not found, using dummy regulator
at24 10-0052: Linked as a consumer to regulator.0
at24 10-0052: 512 byte 24c04 EEPROM, writable, 1 bytes/write
pca953x 10-0020: supply vcc not found, using dummy regulator
pca953x 10-0020: Linked as a consumer to regulator.0
pca953x 10-0020: using no AI
platform mdio-mux: Linked as a sync state only consumer to 10-0022
i2c 10-0022: Linked as a consumer to 4004c000.gpio
i2c 10-0022: Linked as a consumer to 40048000.iomuxc
pca953x 10-0022: supply vcc not found, using dummy regulator
pca953x 10-0022: Linked as a consumer to regulator.0
pca953x 10-0022: using no AI
pca953x 10-0022: interrupt support not compiled in
i2c i2c-10: IMX I2C adapter registered
i2c i2c-10: using dma0chan2 (tx) and dma0chan3 (rx) for DMA transfers
imx-i2c 40066000.i2c: Dropping the link to 4004c000.gpio
mdio_bus 0.1: Linked as a sync state only consumer to 40049000.gpio
mdio_bus 0.1: Linked as a sync state only consumer to 40048000.iomuxc
libphy: mdio_mux: probed
mdio_bus 0.1:00: Linked as a consumer to 40049000.gpio
mdio_bus 0.1:00: Linked as a consumer to 40048000.iomuxc
mdio_bus 0.1:00: Linked as a sync state only consumer to 0.1:00
mv88e6085 0.1:00: switch 0x3520 detected: Marvell 88E6352, revision 1
mdio_bus !mdio-mux!mdio@1!switch@0!mdio: Linked as a sync state only consumer to 0.1:00
libphy: mdio: probed
mmc0: host does not support reading read-only switch, assuming write-enable
mmc0: new high speed SDHC card at address 0007
mdio_bus !mdio-mux!mdio@1!switch@0!mdio:00: Linked as a consumer to 0.1:00
mdio_bus !mdio-mux!mdio@1!switch@0!mdio:00: probe deferral - supplier 0.1:00 not ready
mmcblk0: mmc0:0007 SD4GB 3.71 GiB 
mdio_bus !mdio-mux!mdio@1!switch@0!mdio:01: Linked as a consumer to 0.1:00
mdio_bus !mdio-mux!mdio@1!switch@0!mdio:01: probe deferral - supplier 0.1:00 not ready
 mmcblk0: p1 p2 p3 < p5 >
mdio_bus !mdio-mux!mdio@1!switch@0!mdio:02: Linked as a consumer to 0.1:00
mdio_bus !mdio-mux!mdio@1!switch@0!mdio:02: probe deferral - supplier 0.1:00 not ready
mv88e6085 0.1:00: Dropping the link to 0.1:00
mdio_bus 0.2: Linked as a sync state only consumer to 40049000.gpio
mdio_bus 0.2: Linked as a sync state only consumer to 40048000.iomuxc
libphy: mdio_mux: probed
mdio_bus 0.2:00: Linked as a consumer to 40049000.gpio
mdio_bus 0.2:00: Linked as a consumer to 40048000.iomuxc
mdio_bus 0.2:00: Linked as a sync state only consumer to 0.2:00
mv88e6085 0.2:00: switch 0x3520 detected: Marvell 88E6352, revision 1
mdio_bus !mdio-mux!mdio@2!switch@0!mdio: Linked as a sync state only consumer to 0.2:00
libphy: mdio: probed
mdio_bus !mdio-mux!mdio@2!switch@0!mdio:00: Linked as a consumer to 0.2:00
mdio_bus !mdio-mux!mdio@2!switch@0!mdio:00: probe deferral - supplier 0.2:00 not ready
mdio_bus !mdio-mux!mdio@2!switch@0!mdio:01: Linked as a consumer to 0.2:00
mdio_bus !mdio-mux!mdio@2!switch@0!mdio:01: probe deferral - supplier 0.2:00 not ready
mdio_bus !mdio-mux!mdio@2!switch@0!mdio:02: Linked as a consumer to 0.2:00
mdio_bus !mdio-mux!mdio@2!switch@0!mdio:02: probe deferral - supplier 0.2:00 not ready
mv88e6085 0.2:00: Dropping the link to 0.2:00
mdio_bus 0.4: Linked as a sync state only consumer to 10-0022
libphy: mdio_mux: probed
mdio_bus 0.4:00: Linked as a sync state only consumer to 10-0022
mv88e6085 0.4:00: switch 0x1a70 detected: Marvell 88E6185, revision 2
libphy: mdio: probed
mv88e6085 0.1:00 lan0 (uninitialized): PHY [!mdio-mux!mdio@1!switch@0!mdio:00] driver [Generic PHY] (irq=POLL)
mv88e6085 0.1:00 lan1 (uninitialized): PHY [!mdio-mux!mdio@1!switch@0!mdio:01] driver [Generic PHY] (irq=POLL)
mv88e6085 0.1:00 lan2 (uninitialized): PHY [!mdio-mux!mdio@1!switch@0!mdio:02] driver [Generic PHY] (irq=POLL)
mv88e6085 0.1:00: configuring for fixed/rgmii-txid link mode
mv88e6085 0.1:00: configuring for fixed/ link mode
mv88e6085 0.1:00: Link is Up - 1Gbps/Full - flow control off
mv88e6085 0.1:00: Link is Up - 100Mbps/Full - flow control off
mv88e6085 0.2:00 lan3 (uninitialized): PHY [!mdio-mux!mdio@2!switch@0!mdio:00] driver [Generic PHY] (irq=POLL)
mv88e6085 0.2:00 lan4 (uninitialized): PHY [!mdio-mux!mdio@2!switch@0!mdio:01] driver [Generic PHY] (irq=POLL)
mv88e6085 0.2:00 lan5 (uninitialized): PHY [!mdio-mux!mdio@2!switch@0!mdio:02] driver [Generic PHY] (irq=POLL)
mv88e6085 0.2:00: configuring for fixed/rgmii-txid link mode
mv88e6085 0.2:00: configuring for fixed/rgmii-txid link mode
mv88e6085 0.4:00 lan6 (uninitialized): PHY [!mdio-mux!mdio@4!switch@0!mdio:00] driver [Marvell 88E1545] (irq=POLL)
mv88e6085 0.4:00 lan7 (uninitialized): PHY [!mdio-mux!mdio@4!switch@0!mdio:01] driver [Marvell 88E1545] (irq=POLL)
mv88e6085 0.4:00 lan8 (uninitialized): PHY [!mdio-mux!mdio@4!switch@0!mdio:02] driver [Marvell 88E1545] (irq=POLL)
mv88e6085 0.4:00: configuring for fixed/rgmii-txid link mode
mv88e6085 0.1:00: Linked as a consumer to 400d1000.ethernet
DSA: tree 0 setup
mv88e6085 0.4:00: Dropping the link to 10-0022
libphy: mdio_mux: probed
mdio-mux-gpio mdio-mux: Dropping the link to 10-0022

      Andrew
