Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C9856A2654
	for <lists+netdev@lfdr.de>; Sat, 25 Feb 2023 02:19:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbjBYBTM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 20:19:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbjBYBRd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 20:17:33 -0500
X-Greylist: delayed 39383 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 24 Feb 2023 17:17:18 PST
Received: from smtp-outbound5.duck.com (smtp-outbound5.duck.com [20.67.223.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51F301688D
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 17:17:17 -0800 (PST)
MIME-Version: 1.0
Subject: Re: 4-port ASMedia/RealTek RTL8125 2.5Gbps NIC freezes whole system
References: <AF9C0500-2909-4FF4-8E4E-3BAD8FD8AA14.1@smtp-inbound1.duck.com>
 <92181e0e-3ca0-b19c-71f3-607fbfdc40a3@gmail.com>
 <00F8F608-C2C6-454E-8CA4-F963BC9D7005.1@smtp-inbound1.duck.com>
Content-Type: text/plain;
        charset=US-ASCII;
        format=flowed
Content-Transfer-Encoding: 7bit
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Received: by smtp-inbound1.duck.com; Fri, 24 Feb 2023 20:17:16 -0500
Message-ID: <C8F575CA-6344-413B-9AD5-A5352660D381.1@smtp-inbound1.duck.com>
Date:   Fri, 24 Feb 2023 20:17:16 -0500
From:   fk1xdcio@duck.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=duck.com; h=From:
 Date: Message-ID: Cc: To: Content-Transfer-Encoding: Content-Type:
 References: Subject: MIME-Version; q=dns/txt; s=postal-KpyQVw;
 t=1677287836; bh=dOK2JZJtYKmgvU36DXJKpxkx9eiMR0Qvtnjdcr5Z8Z4=;
 b=JI0yu7qMFDw2v/H5GDew6O/uOCtdCmB67ciMdWeK0bMXnDgHSDSMTss7bVwL96qRyy2Ii5hlc
 nJOjBxE0/uzupjz4U4fxdSO4RVcF3mDGu22mThunZqKv7qp2+apr9WSK/yi8tem7EcddPZprZ10
 ubdsEahw7FZ/01oBTVk6thk=
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On 24.02.2023 15:37, fk1xdcio@duck.com wrote:
>> I'm having problems getting this 4-port 2.5Gbps NIC to be stable. I 
>> have tried on multiple different physical systems both with Xeon 
>> server and i7 workstation chipsets and it behaves the same way on 
>> everything. Testing with latest Arch Linux and kernels 6.1, 6.2, and 
>> 5.15. I'm using the kernel default r8169 driver.
>> 
>> The higher the load on the NIC the more likely the whole system 
>> freezes hard. Everything freezes including my serial console, SysRq 
>> doesn't work, even the motherboard hardware reset switch doesn't 
>> work(!). I have to cut power to the system to reset it.

I managed to get a little more debug output from the r8169 driver but it 
doesn't look useful.

---

3,1557,460720104,-;pcieport 0000:04:02.0: can't change power state from 
D3cold to D0 (config space inaccessible)
  SUBSYSTEM=pci
  DEVICE=+pci:0000:04:02.0
7,1558,460720169,-;pcieport 0000:03:00.0: Wakeup disabled by ACPI
  SUBSYSTEM=pci
  DEVICE=+pci:0000:03:00.0
7,1559,460820335,-;pcieport 0000:04:02.0: PME# disabled
  SUBSYSTEM=pci
  DEVICE=+pci:0000:04:02.0
3,1560,460920566,-;pcieport 0000:04:00.0: can't change power state from 
D3cold to D0 (config space inaccessible)
  SUBSYSTEM=pci
  DEVICE=+pci:0000:04:00.0
7,1561,460920605,-;pcieport 0000:03:00.0: Wakeup disabled by ACPI
  SUBSYSTEM=pci
  DEVICE=+pci:0000:03:00.0
7,1562,461020800,-;pcieport 0000:04:00.0: PME# disabled
  SUBSYSTEM=pci
  DEVICE=+pci:0000:04:00.0
47,1563,461021730,-;systemd-journald[300]: Sent WATCHDOG=1 notification.
4,1564,469141366,-;------------[ cut here ]------------
6,1565,469141462,-;NETDEV WATCHDOG: enp7s0 (r8169): transmit queue 0 
timed out
4,1566,469141564,-;WARNING: CPU: 4 PID: 0 at net/sched/sch_generic.c:477 
dev_watchdog+0x260/0x270
4,1567,469141598,-;Modules linked in: intel_rapl_msr intel_rapl_common 
x86_pkg_temp_thermal intel_powerclamp coretemp snd_hda_codec_realtek 
snd_hda_codec_generic kvm_intel ledtrig_audio snd_hda_codec_hdmi 
snd_hda_intel kvm snd_intel_dspcfg snd_intel_sdw_acpi snd_hda_codec 
irqbypass snd_hda_core crct10dif_pclmul vfat ghash_clmulni_intel 
snd_hwdep intel_spi_platform ppdev fat r8169 intel_spi snd_pcm spi_nor 
eeepc_wmi rapl mtd iTCO_wdt realtek asus_wmi intel_cstate snd_timer 
intel_pmc_bxt mdio_devres at24 snd iTCO_vendor_support sparse_keymap 
parport_pc libphy intel_uncore e1000e soundcore platform_profile pcspkr 
i2c_i801 lpc_ich wmi_bmof i2c_smbus parport cfg80211 mac_hid rfkill fuse 
dm_mod loop bpf_preload ip_tables x_tables ext4 crc32c_generic crc16 
mbcache jbd2 amdgpu gpu_sched uas usb_storage usbhid crc32_pclmul 
crc32c_intel i915 radeon xhci_pci aesni_intel crypto_simd drm_ttm_helper 
cryptd ttm xhci_pci_renesas intel_gtt wmi video
47,1568,469141808,-;systemd-journald[300]: Compressed data object 935 -> 
535 using ZSTD
4,1569,469141921,-;CPU: 4 PID: 0 Comm: swapper/4 Not tainted 
5.15.94-1-lts #1 3e19fc2ba95235027ca648af9def197ca71efbf9
4,1570,469141984,-;Hardware name: ASUS All Series/Q87M-E, BIOS 3801 
03/22/2019
4,1571,469142008,-;RIP: 0010:dev_watchdog+0x260/0x270
4,1572,469142028,-;Code: ff eb a8 4c 8b 3c 24 c6 05 20 11 43 01 01 4c 89 
ff e8 c4 c6 f9 ff 89 d9 4c 89 fe 48 c7 c7 08 ec b5 bd 48 89 c2 e8 30 50 
18 00 <0f> 0b eb 86 66 66 2e 0f 1f 84 00 00 00 00 00 90 0f 1f 44 00 00 
41
4,1573,469142085,-;RSP: 0018:ffffbc83401d4e88 EFLAGS: 00010282
4,1574,469142105,-;RAX: 0000000000000000 RBX: 0000000000000000 RCX: 
000000000000083f
4,1575,469142130,-;RDX: 0000000000000000 RSI: 00000000000000f6 RDI: 
000000000000083f
4,1576,469142154,-;RBP: ffff9a9b5386441c R08: 0000000000000000 R09: 
ffffbc83401d4c98
4,1577,469142180,-;R10: ffffbc83401d4c90 R11: 0000000000000003 R12: 
ffff9a9b4e515e80
4,1578,469142205,-;R13: 0000000000000004 R14: ffff9a9b538644c0 R15: 
ffff9a9b53864000
4,1579,469142231,-;FS:  0000000000000000(0000) GS:ffff9aa252100000(0000) 
knlGS:0000000000000000
4,1580,469142256,-;CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
4,1581,469142278,-;CR2: 00005602a258d098 CR3: 00000003a6410004 CR4: 
00000000001706e0
4,1582,469142304,-;Call Trace:
4,1583,469142316,-; <IRQ>
4,1584,469142329,-; ? pfifo_fast_enqueue+0x150/0x150
4,1585,469142347,-; call_timer_fn+0x27/0xf0
4,1586,469142366,-; __run_timers+0x219/0x280
4,1587,469142386,-; run_timer_softirq+0x19/0x30
4,1588,469142405,-; __do_softirq+0xd0/0x295
4,1589,469142425,-; ? sched_clock_cpu+0x9/0xa0
4,1590,469142445,-; irq_exit_rcu+0x99/0xc0
4,1591,469142461,-; sysvec_apic_timer_interrupt+0x6e/0x90
4,1592,469142482,-; </IRQ>
4,1593,469142495,-; <TASK>
4,1594,469142508,-; asm_sysvec_apic_timer_interrupt+0x16/0x20
4,1595,469142528,-;RIP: 0010:cpuidle_enter_state+0xc7/0x360
4,1596,469142550,-;Code: 8b 3d 75 2a 15 43 e8 58 20 81 ff 49 89 c5 0f 1f 
44 00 00 31 ff e8 59 2e 81 ff 45 84 ff 0f 85 0e 01 00 00 fb 66 0f 1f 44 
00 00 <45> 85 f6 0f 88 1a 01 00 00 49 63 ce 48 8d 04 49 48 8d 04 81 49 
8d
4,1597,469145359,-;RSP: 0018:ffffbc83400e3ea8 EFLAGS: 00000246
4,1598,469146764,-;RAX: ffff9aa252131280 RBX: 0000000000000005 RCX: 
000000000000001f
4,1599,469148147,-;RDX: 0000006d3b00c781 RSI: 000000002962cccc RDI: 
0000000000000000
4,1600,469149500,-;RBP: ffff9aa25213c258 R08: 0000000000000002 R09: 
0000000000000001
4,1601,469150871,-;R10: 0000000000000018 R11: 00000000000ecd7a R12: 
ffffffffbe348080
4,1602,469152220,-;R13: 0000006d3b00c781 R14: 0000000000000005 R15: 
0000000000000000
4,1603,469153555,-; ? cpuidle_enter_state+0xb7/0x360
4,1604,469154895,-; cpuidle_enter+0x29/0x40
4,1605,469156209,-; do_idle+0x1eb/0x280
4,1606,469157488,-; cpu_startup_entry+0x19/0x20
4,1607,469158756,-; secondary_startup_64_no_verify+0xc2/0xcb
4,1608,469160046,-; </TASK>
4,1609,469161309,-;---[ end trace 7d24d262f43696cd ]---

---

I noticed the RealTek r8125 driver has some memory errors. I'm not sure 
if that is affecting anything when testing it.

---

3,1931,431512992,-;==================================================================
3,1932,431513856,-;BUG: KFENCE: use-after-free read in 
rtl8125_rx_interrupt+0x372/0x580 [r8125]\x0a
3,1933,431515468,-;Use-after-free read at 0x00000000c475df7d (in 
kfence-#32):
4,1934,431516254,-; rtl8125_rx_interrupt+0x372/0x580 [r8125]
4,1935,431517036,-; rtl8125_poll_msix_rx+0x41/0x90 [r8125]
4,1936,431517822,-; __napi_poll+0x46/0x170
4,1937,431518609,-; net_rx_action+0x25c/0x320
4,1938,431519390,-; __do_softirq+0xd0/0x295
4,1939,431520175,-; irq_exit_rcu+0x99/0xc0
4,1940,431520960,-; common_interrupt+0x82/0xa0
4,1941,431521745,-; asm_common_interrupt+0x22/0x40
4,1942,431522526,-; cpuidle_enter_state+0xc7/0x360
4,1943,431523311,-; cpuidle_enter+0x29/0x40
4,1944,431524087,-; do_idle+0x1eb/0x280
4,1945,431524857,-; cpu_startup_entry+0x19/0x20
4,1946,431525613,-; secondary_startup_64_no_verify+0xc2/0xcb
3,1947,431526373,-;
4,1948,431527124,-;kfence-#32: 0x0000000042cdb04d-0x00000000805039f2, 
size=224, cache=skbuff_head_cache\x0a
4,1949,431528664,-;allocated by task 29 on cpu 2 at 431.510933s:
4,1950,431529441,-; __alloc_skb+0x179/0x1e0
4,1951,431530215,-; skb_segment+0x25e/0xe60
4,1952,431530990,-; tcp_gso_segment+0xec/0x4e0
4,1953,431531762,-; inet_gso_segment+0x155/0x3d0
4,1954,431532546,-; skb_mac_gso_segment+0x98/0x110
4,1955,431533317,-; __skb_gso_segment+0xb3/0x170
4,1956,431534085,-; validate_xmit_skb+0x159/0x320
4,1957,431534861,-; validate_xmit_skb_list+0x4a/0x70
4,1958,431535638,-; sch_direct_xmit+0x187/0x370
4,1959,431536415,-; __dev_queue_xmit+0x901/0xb70
4,1960,431537197,-; ip_finish_output2+0x258/0x520
4,1961,431537976,-; __ip_queue_xmit+0x168/0x410
4,1962,431538757,-; __tcp_transmit_skb+0xa02/0xbd0
4,1963,431539534,-; tcp_write_xmit+0x57c/0x13d0
4,1964,431540311,-; tcp_tsq_handler+0x81/0x90
4,1965,431541086,-; tcp_tasklet_func+0xdd/0x130
4,1966,431541861,-; tasklet_action_common.constprop.0+0xbf/0x120
4,1967,431542643,-; __do_softirq+0xd0/0x295
4,1968,431543416,-; run_ksoftirqd+0x2a/0x40
4,1969,431544192,-; smpboot_thread_fn+0xaf/0x140
4,1970,431544967,-; kthread+0x118/0x140
4,1971,431545745,-; ret_from_fork+0x22/0x30
4,1972,431546524,-;
4,1973,431547292,-;freed by task 0 on cpu 2 at 431.512987s:
4,1974,431548064,-; tcp_rcv_established+0x33f/0x690
4,1975,431548835,-; tcp_v4_do_rcv+0x13e/0x240
4,1976,431549609,-; tcp_v4_rcv+0xe08/0xe80
4,1977,431550380,-; ip_protocol_deliver_rcu+0x32/0x200
4,1978,431551159,-; ip_local_deliver_finish+0x44/0x60
4,1979,431551931,-; ip_sublist_rcv_finish+0x7e/0x90
4,1980,431552703,-; ip_sublist_rcv+0x182/0x230
4,1981,431553474,-; ip_list_rcv+0x139/0x170
4,1982,431554247,-; __netif_receive_skb_list_core+0x29e/0x2c0
4,1983,431555023,-; netif_receive_skb_list_internal+0x1c8/0x300
4,1984,431555802,-; gro_normal_one+0x77/0xa0
4,1985,431556574,-; napi_gro_receive+0x80/0x180
4,1986,431557341,-; rtl8125_rx_interrupt+0x368/0x580 [r8125]
4,1987,431558121,-; rtl8125_poll_msix_rx+0x41/0x90 [r8125]
4,1988,431558896,-; __napi_poll+0x46/0x170
4,1989,431559662,-; net_rx_action+0x25c/0x320
4,1990,431560433,-; __do_softirq+0xd0/0x295
4,1991,431561399,-; irq_exit_rcu+0x99/0xc0
4,1992,431562612,-; common_interrupt+0x82/0xa0
4,1993,431563715,-; asm_common_interrupt+0x22/0x40
4,1994,431564825,-; cpuidle_enter_state+0xc7/0x360
4,1995,431565937,-; cpuidle_enter+0x29/0x40
4,1996,431567047,-; do_idle+0x1eb/0x280
4,1997,431568157,-; cpu_startup_entry+0x19/0x20
4,1998,431569262,-; secondary_startup_64_no_verify+0xc2/0xcb

