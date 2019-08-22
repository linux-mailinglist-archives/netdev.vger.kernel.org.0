Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3409F9A3F7
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 01:39:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727076AbfHVXjB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 19:39:01 -0400
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:37542 "EHLO
        emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725283AbfHVXjB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 19:39:01 -0400
Received: from darkstar.musicnaut.iki.fi (85-76-87-181-nat.elisa-mobile.fi [85.76.87.181])
        by emh03.mail.saunalahti.fi (Postfix) with ESMTP id 379894000F;
        Fri, 23 Aug 2019 02:38:55 +0300 (EEST)
Date:   Fri, 23 Aug 2019 02:38:54 +0300
From:   Aaro Koskinen <aaro.koskinen@iki.fi>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     netdev@vger.kernel.org, linux-mips@vger.kernel.org
Subject: Re: r8169: regression on MIPS/Loongson
Message-ID: <20190822233854.GG30291@darkstar.musicnaut.iki.fi>
References: <20190822222549.GF30291@darkstar.musicnaut.iki.fi>
 <d76b0614-188e-885c-b346-b131cc1d9688@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d76b0614-188e-885c-b346-b131cc1d9688@gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Fri, Aug 23, 2019 at 12:52:34AM +0200, Heiner Kallweit wrote:
> On 23.08.2019 00:25, Aaro Koskinen wrote:
> > After upgrading from v5.2 to v5.3-rc5 on MIPS/Loongson board, copying
> > large files from network with scp started to fail with "Integrity error".
> > Bisected to:
> > 
> > f072218cca5b076dd99f3dfa3aaafedfd0023a51 is the first bad commit
> > commit f072218cca5b076dd99f3dfa3aaafedfd0023a51
> > Author: Heiner Kallweit <hkallweit1@gmail.com>
> > Date:   Thu Jun 27 23:19:09 2019 +0200
> > 
> >     r8169: remove not needed call to dma_sync_single_for_device
> > 
> > Any idea what goes wrong? Should this change be reverted?
> > 
> Typically the Realtek chips are used on Intel platforms and I haven't
> seen any such report yet, so it seems to be platform-specific.

Probably. On my AMD x86_64 box r8169 works fine.

> Which board (DT config) is it, and can you provide a full dmesg?

This board does not use DT (support files are under arch/mips/loongson64).
dmesg is below:

[    0.000000] Linux version 5.3.0-rc4-lemote-los_1bf0c (aakoskin@amd-fx-6350) (gcc version 8.3.0 (GCC)) #1 Fri Aug 23 01:01:45 EEST 2019
[    0.000000] memsize=256, highmemsize=256
[    0.000000] CpuClock = 797800000
[    0.000000] printk: bootconsole [early0] enabled
[    0.000000] CPU0 revision is: 00006303 (ICT Loongson-2)
[    0.000000] FPU revision is: 00000501
[    0.000000] Checking for the multiply/shift bug... no.
[    0.000000] Checking for the daddiu bug... no.
[    0.000000] Determined physical RAM map:
[    0.000000]  memory: 0000000010000000 @ 0000000000000000 (usable)
[    0.000000]  memory: 0000000030000000 @ 0000000010000000 (reserved)
[    0.000000]  memory: 0000000010000000 @ 0000000090000000 (usable)
[    0.000000]  memory: 0000000010000000 @ 0000000080000000 (reserved)
[    0.000000] Initrd not found or empty - disabling initrd
[    0.000000] Primary instruction cache 64kB, VIPT, direct mapped, linesize 32 bytes.
[    0.000000] Primary data cache 64kB, 4-way, VIPT, no aliases, linesize 32 bytes
[    0.000000] Unified secondary cache 512kB 4-way, linesize 32 bytes.
[    0.000000] Zone ranges:
[    0.000000]   Normal   [mem 0x0000000000000000-0x000000009fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000000000000-0x000000003fffffff]
[    0.000000]   node   0: [mem 0x0000000080000000-0x000000009fffffff]
[    0.000000] Initmem setup node 0 [mem 0x0000000000000000-0x000000009fffffff]
[    0.000000] On node 0 totalpages: 98304
[    0.000000]   Normal zone: 336 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 98304 pages, LIFO batch:15
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768
[    0.000000] pcpu-alloc: [0] 0 
[    0.000000] Built 1 zonelists, mobility grouping on.  Total pages: 97968
[    0.000000] Kernel command line: console=tty console=ttyS0,115200
[    0.000000] Dentry cache hash table entries: 262144 (order: 7, 2097152 bytes, linear)
[    0.000000] Inode-cache hash table entries: 131072 (order: 6, 1048576 bytes, linear)
[    0.000000] mem auto-init: stack:off, heap alloc:off, heap free:off
[    0.000000] Memory: 489664K/1572864K available (4863K kernel code, 467K rwdata, 876K rodata, 1968K init, 16616K bss, 1083200K reserved, 0K cma-reserved)
[    0.000000] SLUB: HWalign=32, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[    0.000000] NR_IRQS: 128
[    0.000000] random: get_random_bytes called from start_kernel+0x368/0x620 with crng_init=0
[    0.000000] Console: colour dummy device 80x25
[    0.000000] printk: console [tty0] enabled
[    0.000000] sched_clock: 64 bits at 250 Hz, resolution 4000000ns, wraps every 9007199254000000ns
[    0.004000] Calibrating delay loop... 528.38 BogoMIPS (lpj=1056768)
[    0.040000] pid_max: default: 32768 minimum: 301
[    0.044000] Mount-cache hash table entries: 4096 (order: 1, 32768 bytes, linear)
[    0.048000] Mountpoint-cache hash table entries: 4096 (order: 1, 32768 bytes, linear)
[    0.052000] *** VALIDATE proc ***
[    0.056000] Checking for the daddi bug... no.
[    0.064000] devtmpfs: initialized
[    0.068000] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 7645041785100000 ns
[    0.072000] futex hash table entries: 256 (order: -2, 6144 bytes, linear)
[    0.076000] NET: Registered protocol family 16
[    0.080000] clocksource: mfgpt: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 133486551712 ns
[    0.124000] SCSI subsystem initialized
[    0.128000] usbcore: registered new interface driver usbfs
[    0.132000] usbcore: registered new interface driver hub
[    0.136000] usbcore: registered new device driver usb
[    0.140000] PCI host bridge to bus 0000:00
[    0.148000] pci_bus 0000:00: root bus resource [mem 0x40000000-0x7fffffff]
[    0.152000] pci_bus 0000:00: root bus resource [io  0x4000-0xffff]
[    0.156000] pci_bus 0000:00: root bus resource [??? 0x00000000 flags 0x0]
[    0.160000] pci_bus 0000:00: No busn resource found for root bus, will use [bus 00-ff]
[    0.164000] pci 0000:00:06.0: [10ec:8169] type 00 class 0x020000
[    0.168000] pci 0000:00:06.0: reg 0x10: [io  0xb100-0xb1ff]
[    0.172000] pci 0000:00:06.0: reg 0x14: [mem 0x04075000-0x040750ff]
[    0.176000] pci 0000:00:06.0: reg 0x30: [mem 0x04040000-0x0405ffff pref]
[    0.180000] pci 0000:00:06.0: supports D1 D2
[    0.184000] pci 0000:00:06.0: PME# supported from D1 D2 D3hot
[    0.188000] pci 0000:00:08.0: [1039:0325] type 00 class 0x030000
[    0.192000] pci 0000:00:08.0: reg 0x10: [mem 0x40000000-0x4fffffff pref]
[    0.196000] pci 0000:00:08.0: reg 0x14: [mem 0x04000000-0x0403ffff]
[    0.200000] pci 0000:00:08.0: reg 0x18: [io  0xb300-0xb37f]
[    0.204000] pci 0000:00:08.0: reg 0x30: [mem 0x04060000-0x0406ffff pref]
[    0.208000] pci 0000:00:08.0: supports D1 D2
[    0.212000] pci 0000:00:0e.0: [1022:2090] type 00 class 0x060100
[    0.216000] pci 0000:00:0e.0: reg 0x10: [io  0xb410-0xb417]
[    0.220000] pci 0000:00:0e.0: reg 0x14: [io  0xb000-0xb0ff]
[    0.224000] pci 0000:00:0e.0: reg 0x18: [io  0xb380-0xb3bf]
[    0.228000] pci 0000:00:0e.0: reg 0x20: [io  0xb280-0xb2ff]
[    0.232000] pci 0000:00:0e.0: reg 0x24: [io  0xb3c0-0xb3df]
[    0.240000] pci 0000:00:0e.2: [1022:209a] type 00 class 0x010180
[    0.244000] pci 0000:00:0e.2: reg 0x20: [io  0xb400-0xb40f]
[    0.252000] pci 0000:00:0e.2: legacy IDE quirk: reg 0x10: [io  0x01f0-0x01f7]
[    0.256000] pci 0000:00:0e.2: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    0.260000] pci 0000:00:0e.2: legacy IDE quirk: reg 0x18: [io  0x0170-0x0177]
[    0.264000] pci 0000:00:0e.2: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    0.268000] pci 0000:00:0e.3: [1022:2093] type 00 class 0x040100
[    0.272000] pci 0000:00:0e.3: reg 0x10: [io  0xb200-0xb27f]
[    0.276000] pci 0000:00:0e.4: [1022:2094] type 00 class 0x0c0310
[    0.280000] pci 0000:00:0e.4: reg 0x10: [mem 0x04074000-0x04074fff]
[    0.288000] pci 0000:00:0e.5: [1022:2095] type 00 class 0x0c0320
[    0.292000] pci 0000:00:0e.5: reg 0x10: [mem 0x04073000-0x04073fff]
[    0.296000] pci_bus 0000:00: busn_res: [bus 00-ff] end is updated to 00
[    0.300000] pci 0000:00:08.0: BAR 0: assigned [mem 0x40000000-0x4fffffff pref]
[    0.304000] pci 0000:00:08.0: BAR 1: assigned [mem 0x50000000-0x5003ffff]
[    0.308000] pci 0000:00:06.0: BAR 6: assigned [mem 0x50040000-0x5005ffff pref]
[    0.312000] pci 0000:00:08.0: BAR 6: assigned [mem 0x50060000-0x5006ffff pref]
[    0.316000] pci 0000:00:0e.4: BAR 0: assigned [mem 0x50070000-0x50070fff]
[    0.320000] pci 0000:00:0e.5: BAR 0: assigned [mem 0x50071000-0x50071fff]
[    0.324000] pci 0000:00:06.0: BAR 0: assigned [io  0x4000-0x40ff]
[    0.328000] pci 0000:00:06.0: BAR 1: assigned [mem 0x50072000-0x500720ff]
[    0.332000] pci 0000:00:0e.0: BAR 1: assigned [io  0x4400-0x44ff]
[    0.336000] pci 0000:00:08.0: BAR 2: assigned [io  0x4800-0x487f]
[    0.340000] pci 0000:00:0e.0: BAR 4: assigned [io  0x4880-0x48ff]
[    0.344000] pci 0000:00:0e.3: BAR 0: assigned [io  0x4c00-0x4c7f]
[    0.348000] pci 0000:00:0e.0: BAR 2: assigned [io  0x4c80-0x4cbf]
[    0.352000] pci 0000:00:0e.0: BAR 5: assigned [io  0x4cc0-0x4cdf]
[    0.356000] pci 0000:00:0e.2: BAR 4: assigned [io  0x4ce0-0x4cef]
[    0.360000] pci 0000:00:0e.0: BAR 0: assigned [io  0x4cf0-0x4cf7]
[    0.364000] clocksource: Switched to clocksource mfgpt
[    0.392000] NET: Registered protocol family 2
[    0.396000] tcp_listen_portaddr_hash hash table entries: 1024 (order: 0, 16384 bytes, linear)
[    0.400000] TCP established hash table entries: 16384 (order: 3, 131072 bytes, linear)
[    0.404000] TCP bind hash table entries: 16384 (order: 3, 131072 bytes, linear)
[    0.408000] TCP: Hash tables configured (established 16384 bind 16384)
[    0.412000] UDP hash table entries: 1024 (order: 1, 32768 bytes, linear)
[    0.416000] UDP-Lite hash table entries: 1024 (order: 1, 32768 bytes, linear)
[    0.420000] NET: Registered protocol family 1
[    0.424000] pci 0000:00:0e.4: enabling device (0000 -> 0002)
[    0.428000] PCI: CLS 32 bytes, default 32
[    0.888000] random: fast init done
[    1.804000] workingset: timestamp_bits=62 max_order=15 bucket_order=0
[    1.820000] NET: Registered protocol family 38
[    1.824000] io scheduler bfq registered
[    1.828000] slot: 8, pin: 1, irq: 38
[    1.832000] sisfb 0000:00:08.0: Invalid PCI ROM header signature: expecting 0xaa55, got 0x3030
[    1.836000] sisfb: Video ROM not found
[    1.840000] sisfb: Video RAM at 0x40000000, mapped to 0x9000000040000000, size 32768k
[    1.844000] sisfb: MMIO at 0x50000000, mapped to 0x9000000050000000, size 256k
[    1.848000] sisfb: Memory heap starting at 32160K, size 32K
[    3.140000] sisfb: Detected SiS301C video bridge
[    3.220000] sisfb: Detected 1280x1024 flat panel
[    3.304000] sisfb: CRT2 DDC supported
[    3.304000] sisfb: CRT2 DDC level: 2 
[    3.512000] sisfb: Monitor range H 30-81KHz, V 56-76Hz, Max. dotclock 140MHz
[    3.516000] sisfb: Default mode is 1280x1024x8 (60Hz)
[    3.520000] sisfb: Initial vbflags 0x10000022
[    4.008000] Console: switching to colour frame buffer device 160x64
[    4.068000] sisfb: 2D acceleration is enabled, y-panning enabled (auto-max)
[    4.072000] fb0: SiS 315PRO frame buffer device version 1.8.9
[    4.076000] sisfb: Copyright (C) 2001-2005 Thomas Winischhofer
[    4.156000] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    4.308000] printk: console [ttyS0] disabled
[    4.316000] serial8250.0: ttyS0 at I/O 0x2f8 (irq = 3, base_baud = 115200) is a 16550A
[    4.320000] printk: console [ttyS0] enabled
[    4.324000] printk: bootconsole [early0] disabled
[    4.808000] brd: module loaded
[    5.036000] loop: module loaded
[    5.040000] Uniform Multi-Platform E-IDE driver
[    5.044000] amd74xx 0000:00:0e.2: UDMA100 controller
[    5.048000] amd74xx 0000:00:0e.2: IDE controller (0x1022:0x209a rev 0x01)
[    5.052000] amd74xx 0000:00:0e.2: IDE port disabled
[    5.056000] amd74xx 0000:00:0e.2: not 100% native mode: will probe irqs later
[    5.060000] legacy IDE will be removed in 2021, please switch to libata
[    5.060000] Report any missing HW support to linux-ide@vger.kernel.org
[    5.064000]     ide0: BM-DMA at 0x4ce0-0x4ce7
[    5.068000] Probing IDE interface ide0...
[    5.428000] hda: WDC WD1600BEVS-00VAT0, ATA DISK drive
[    6.152000] hda: host max PIO5 wanted PIO255(auto-tune) selected PIO4
[    6.152000] hda: UDMA/100 mode selected
[    6.156000] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[    6.160000] ide-gd driver 1.18
[    6.164000] hda: max request size: 1024KiB
[    6.244000] hda: 312581808 sectors (160041 MB) w/8192KiB Cache, CHS=19457/255/63
[    6.248000] hda: cache flushes supported
[    6.268000]  hda: hda1
[    6.272000] slot: 6, pin: 1, irq: 36
[    6.276000] libphy: r8169: probed
[    6.280000] r8169 0000:00:06.0 eth0: RTL8169sc/8110sc, 00:23:9e:00:0f:54, XID 980, IRQ 36
[    6.284000] r8169 0000:00:06.0 eth0: jumbo features [frames: 7152 bytes, tx checksumming: ok]
[    6.288000] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    6.292000] ehci-pci: EHCI PCI platform driver
[    6.296000] ehci-pci 0000:00:0e.5: EHCI Host Controller
[    6.300000] ehci-pci 0000:00:0e.5: new USB bus registered, assigned bus number 1
[    6.304000] ehci-pci 0000:00:0e.5: irq 11, io mem 0x50071000
[    6.440000] ehci-pci 0000:00:0e.5: USB 0.0 started, EHCI 1.00
[    6.448000] hub 1-0:1.0: USB hub found
[    6.460000] hub 1-0:1.0: 4 ports detected
[    6.468000] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    6.472000] ohci-pci: OHCI PCI platform driver
[    6.476000] ohci-pci 0000:00:0e.4: OHCI PCI host controller
[    6.480000] ohci-pci 0000:00:0e.4: new USB bus registered, assigned bus number 2
[    6.484000] ohci-pci 0000:00:0e.4: irq 11, io mem 0x50070000
[    6.580000] hub 2-0:1.0: USB hub found
[    6.592000] hub 2-0:1.0: 4 ports detected
[    6.600000] usbcore: registered new interface driver usb-storage
[    6.604000] loongson2_cpufreq: Loongson-2F CPU frequency driver
[    6.608000] usbcore: registered new interface driver usbhid
[    6.612000] usbhid: USB HID core driver
[    6.620000] NET: Registered protocol family 17
[    6.700000] Freeing unused kernel memory: 1968K
[    6.704000] This architecture does not have kernel memory protection.
[    6.708000] Run /init as init process
[   10.868000] EXT4-fs (hda1): mounting ext3 file system using the ext4 subsystem
[   12.756000] EXT4-fs (hda1): mounted filesystem with ordered data mode. Opts: (null)
[   15.800000] RTL8211B Gigabit Ethernet r8169-30:00: attached PHY driver [RTL8211B Gigabit Ethernet] (mii_bus:phy_addr=r8169-30:00, irq=IGNORE)
[   15.908000] r8169 0000:00:06.0 eth0: Link is Down
[   18.424000] r8169 0000:00:06.0 eth0: Link is Up - 1Gbps/Full - flow control rx/tx

A.
