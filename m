Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F0A652DD38
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 20:54:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244172AbiESSyW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 14:54:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243512AbiESSyU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 14:54:20 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAE9562BD7
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 11:54:11 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id a23so7264170ljd.9
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 11:54:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=wXaeAuBMMr/+w0tr5u40UE0EUhEqkGrD7mWDF8wrAb0=;
        b=RD/Z4YQp8eA52cEewC2/Knwi0v/JsLaZxtJ+HSluC5kOXbt3qLvwor/xnyT2wSANvl
         1CUWSVNmtxYuHQm5gyC3NGoFQNXKZcKMMTwT/r29BLioHFOY5XhJRFi0MIl8yaIpVafB
         izumxyGaSms2BDBIy5yD4wqffb9jcYWOhBhXRipFaMJSYQ3R/VRmseAGmZwcCdVsYH8a
         3o1xtO3G2J7KzUoYH5EdIVL8w0LfHSoPq0tw3pQEZh+nWTXMbevX2OhVIC2j+D87MZ65
         kZPRxEc7I3f0ffa4f/lyiGtZIgfgO0kfsCrAUtLO70D8KVbRUOs7Fryt+xFhHdnJ9rd+
         tIDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=wXaeAuBMMr/+w0tr5u40UE0EUhEqkGrD7mWDF8wrAb0=;
        b=RjL/m5w09RcjABKuiebhugZtnUCnbk60JtlT6/+6C1RXNeYAkYB3tMRhGfLoz89cRl
         iBiHfsRYuxqbwRNK7kfi7s18iVYT6cETpiWa71PlrHUgq4Kdkd5VaXZndAeXGDD2hA2n
         ZxUpBXrcovC+7cl23GUQb4hq0cXzS9mBMaMBfcC/62itHbb3IHRP7nL98UPTwG4Nfx3H
         bD5q1Qe1Nidi7DVx8qn+847QmLKPbbjyMT3XYz50p/BWvcUAw0gilBeX741mcG9hcfa6
         37ZPhPv5TDYbTI5cv+2r+0J+Q8xbB/4Mrs/jvx+vpNY5S7QQ6PzAwtq5TN5ItCY/Ra0g
         IHJg==
X-Gm-Message-State: AOAM531JPrLJ7FXWKuNJKnjkKd3Ua9rXtyHR/Yya7trLjaBOv2KhmjJx
        0sZ02b3AXuCV+zmoumTS8S2ETQD7ARCbtf0b11qiQoS1QW0=
X-Google-Smtp-Source: ABdhPJxiqV9x/XSUlt8VDsJ+cl9Rycicxa5X3c2cKrKqSDSgBmzizh3n64d7XIk91nqZay9+b6lfa9VdaW4J+PXbLX0=
X-Received: by 2002:a2e:93c8:0:b0:24e:eabd:bf6e with SMTP id
 p8-20020a2e93c8000000b0024eeabdbf6emr3294545ljh.347.1652986449694; Thu, 19
 May 2022 11:54:09 -0700 (PDT)
MIME-Version: 1.0
From:   Jann Horn <jannh@google.com>
Date:   Thu, 19 May 2022 20:53:33 +0200
Message-ID: <CAG48ez2Rk5R=tNOa0vViah850ZdvVHn30knDX3pzM4pm67ZM=w@mail.gmail.com>
Subject: usbnet tells minidrivers to unbind while netdev is still up, causing UAFs
To:     USB list <linux-usb@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Oliver Neukum <oneukum@suse.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        kernel list <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary="00000000000027ae1405df61e695"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_FILL_THIS_FORM_SHORT,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--00000000000027ae1405df61e695
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

[resubmitting to public list - this was previously submitted to
security@kernel.org, but ended up not being resolved within 90 days.
see also https://crbug.com/project-zero/2262.]

I've been digging more into the usbnet code, and it's all really brittle.
I keep hitting random KASAN splats while I'm just trying to normally bring
up drivers (mainly when my fake USB device can't handle some request yet
and exits, which results in a USB disconnect, and apparently usbnet
tends to blow up a lot in various ways if you disconnect before the
device is fully up, at least on a kernel with
CONFIG_RCU_STRICT_GRACE_PERIOD=3Dy).

One particularly easy-to-trigger bug was introduced by
commit 2c9d6c2b871d ("usbnet: run unbind() before unregister_netdev()"),
first in v5.14.

Before that commit, the driver_info->unbind() callback was the last call
to the minidriver during USB disconnect, and so one of the things some
minidrivers do there is to free memory associated with the device.

But after that commit, the semantics of driver_info->unbind() are
completely different: It is called at a point where the networking
subsystem **has no idea** yet that the device is going down.
The netdev might still be up, or in the middle of going up, or going
down, or whatever else netdevs do; and so it is still possible that
e.g. userspace sends some netlink message that results in a call to
the minidriver's ->reset method, and then e.g. aqc111_reset() will
try to access its freed dev->driver_priv, and you get UAF.


I looked at this more, and it turns out that with another
minidriver, you don't even need to race to cause a UAF:
Simply disconnecting a USB device when it is currently up will
reliably cause a UAF.

This is the case with the driver in drivers/net/usb/ax88172a.c
(described as "ASIX AX88172A USB 2.0 Ethernet"), which is only
used for the USB device ID of some demo board, nothing else:

/* ASIX 88172a demo board */
USB_DEVICE(0x0b95, 0x172a),
.driver_info =3D (unsigned long) &ax88172a_info,

(Even though this driver is only used for talking to some demo
board, it is enabled in kconfig together with all the other ASIX
devices using kconfig flag CONFIG_USB_NET_AX8817X, which is
enabled on many kernels, including Debian, some Android kernels
and Chrome OS. Android and Chrome OS are probably not affected
by this one though, since they run sufficiently old kernels...)

The call graph of how the UAF happens:

usbnet_disconnect
  ax88172a_unbind (as driver_info->unbind)
    kfree(dev->driver_priv)
  unregister_netdev
    unregister_netdevice
      unregister_netdevice_queue
        unregister_netdevice_many
          dev_close_many
            __dev_close_many
              usbnet_stop (as ops->ndo_stop)
                ax88172a_stop (as driver_info->stop)
                  [UAF access to dev->driver_priv]

The driver_info->stop() handler tries to access data that was freed
in driver_info->unbind(). This makes it pretty clear that the
reordering in commit 2c9d6c2b871d broke stuff.


I have no clue how to fix all this though. From what I can tell,
there are two points during usbnet_disconnect() where the
minidriver might want to get a callback:

 - When ->ndo_close() is invoked by the netdev code; at that point,
   the netdev is definitely down but hasn't been completely torn
   down yet. usbnet doesn't currently use ->ndo_open/->ndo_close
   at all.
 - In the spot where the driver_info->unbind callback used to
   happen before commit 2c9d6c2b871d.

But I have no clue whether we need one or both of these, and
which of the things the current ->unbind callbacks do have to
happen at what time.
commit 2c9d6c2b871d claims that the current ->unbind callback
is too late for the minidriver to disconnect PHY, so I guess
that should probably happen in ->ndo_close()? Maybe?


=3D=3D=3D=3D kernel splats and reproduction instructions =3D=3D=3D=3D

On a system running a normal Debian experimental kernel
(version 5.17.0-rc3-amd64 #1  Debian 5.17~rc3-1~exp1), this also
happens. With slub_debug=3DPF (to make SLUB poison freed memory
and do some extra consistency checks to make UAFs easier to see),
I get this in dmesg when I attach a fake USB device (over real
USB, using a NET2380 USB device-side controller on another
machine), wait for a few seconds so that it can be brought up
completely, and then disconnect it:

[  138.697877] usb 1-2: new high-speed USB device number 3 using xhci_hcd
[  138.852315] usb 1-2: New USB device found, idVendor=3D0b95,
idProduct=3D172a, bcdDevice=3D 0.00
[  138.856972] usb 1-2: New USB device strings: Mfr=3D1, Product=3D2, Seria=
lNumber=3D3
[  138.861557] usb 1-2: Product: DUMMY
[  138.866016] usb 1-2: Manufacturer: DUMMY
[  138.870312] usb 1-2: SerialNumber: DUMMY
[  139.403344] asix 1-2:1.0 (unnamed net_device) (uninitialized):
registered mdio bus usb-001:003
[  139.404897] asix 1-2:1.0 eth1: register 'asix' at
usb-0000:00:14.0-2, ASIX AX88172A USB 2.0 Ethernet, 00:12:34:56:78:90
[  139.406292] usbcore: registered new interface driver asix
[  139.408747] usbcore: registered new interface driver cdc_ether
[  139.481399] asix 1-2:1.0 enx001234567890: renamed from eth1
[  140.150427] asix 1-2:1.0 enx001234567890: Connected to phy usb-001:003:0=
0
[  149.299153] usb 1-2: USB disconnect, device number 3
[  149.303077] asix 1-2:1.0 enx001234567890: unregister 'asix'
usb-0000:00:14.0-2, ASIX AX88172A USB 2.0 Ethernet
[  149.306775] asix 1-2:1.0 enx001234567890: deregistering mdio bus usb-001=
:003
[  149.314206] asix 1-2:1.0 enx001234567890: Disconnecting from phy
kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk\xa5%!LhH\xf2/\xa1ZZZZZZZZZZ=
ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ\x80\xe5W\xe1\xf9\x99\xff\xff=
\xe0#=D5=A1\xff\xff\xff\xff\x80t\xf0\xc0\xff\xff\xff\xff\x98XW\x82\xf9\x99\=
xff\xff\x80\xb9[\xe1\xf9\x99\xff\xff
[  149.315731] general protection fault, probably for non-canonical
address 0x6b6b6b6b6b6b6f43: 0000 [#1] PREEMPT SMP PTI
[  149.317234] CPU: 4 PID: 105 Comm: kworker/4:1 Tainted: G
E     5.17.0-rc3-amd64 #1  Debian 5.17~rc3-1~exp1
[  149.318815] Hardware name: [...]
[  149.320214] Workqueue: usb_hub_wq hub_event [usbcore]
[  149.321030] RIP: 0010:phy_stop+0x9/0xf0 [libphy]
[  149.321835] Code: 02 e0 eb d4 48 8b 0c dd 20 ed b9 c0 e9 33 ff ff
ff 4c 89 f7 e8 68 a3 fa df eb c6 e8 11 ff 1a e0 90 0f 1f 44 00 00 41
54 55 53 <8b> 87 d8 03 00 00 4c 8b a7 28 05 00 00 8d 50 ff 83 fa 01 0f
86 af
[  149.322714] RSP: 0018:ffffb68a807efa58 EFLAGS: 00010246
[  149.323560] RAX: 0000000000000000 RBX: ffff99f9e168e980 RCX: 00000000000=
00000
[  149.324405] RDX: ffffb68a807efa08 RSI: ffffffffa15526f6 RDI: 6b6b6b6b6b6=
b6b6b
[  149.325251] RBP: ffff99f9e15bbb80 R08: 0000000000000000 R09: ffffb68a807=
ef758
[  149.326128] R10: ffffb68a807ef750 R11: ffffffffa1cd1568 R12: 00000000000=
00000
[  149.326965] R13: ffff99f9e168e980 R14: ffffb68a807efad0 R15: ffffb68a807=
efba0
[  149.327800] FS:  0000000000000000(0000) GS:ffff99fc8f700000(0000)
knlGS:0000000000000000
[  149.328641] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  149.329482] CR2: 00007fc2351ba6f4 CR3: 00000002fb410001 CR4: 00000000001=
706e0
[  149.330352] Call Trace:
[  149.331198]  <TASK>
[  149.332030]  ax88172a_stop.cold+0x20/0x2e [asix]
[  149.332857]  usbnet_stop+0x64/0x140 [usbnet]
[  149.333676]  __dev_close_many+0x9e/0x110
[  149.334512]  dev_close_many+0x8b/0x140
[  149.335295]  ? __slab_free+0xa0/0x330
[  149.336059]  unregister_netdevice_many+0x158/0x740
[  149.336816]  ? kfree+0x218/0x250
[  149.337573]  unregister_netdevice_queue+0xcb/0x110
[  149.338361]  unregister_netdev+0x18/0x20
[  149.339112]  usbnet_disconnect+0x59/0xb0 [usbnet]
[  149.339864]  usb_unbind_interface+0x8a/0x270 [usbcore]
[  149.340616]  __device_release_driver+0x22d/0x240
[  149.341358]  device_release_driver+0x24/0x30
[  149.342112]  bus_remove_device+0xd8/0x140
[  149.342840]  device_del+0x18b/0x3f0
[  149.343573]  ? kobject_put+0x91/0x1d0
[  149.344307]  usb_disable_device+0xc6/0x1e0 [usbcore]
[  149.345056]  usb_disconnect.cold+0x7b/0x24d [usbcore]
[  149.345802]  hub_event+0xc4c/0x1880 [usbcore]
[  149.346571]  ? preempt_count_sub+0x81/0x90
[  149.347313]  process_one_work+0x1e5/0x3b0
[  149.348055]  ? rescuer_thread+0x370/0x370
[  149.348795]  worker_thread+0x50/0x3a0
[  149.349531]  ? rescuer_thread+0x370/0x370
[  149.350292]  kthread+0xe7/0x110
[  149.351030]  ? kthread_complete_and_exit+0x20/0x20
[  149.351771]  ret_from_fork+0x22/0x30
[  149.352504]  </TASK>
[  149.353234] Modules linked in: cdc_ether(E) asix(E) selftests(E)
usbnet(E) mii(E) nfnetlink(E) rfkill(E) zstd(E) zstd_compress(E)
zram(E) zsmalloc(E) intel_rapl_msr(E) intel_rapl_common(E)
x86_pkg_temp_thermal(E) intel_powerclamp(E) coretemp(E) nls_ascii(E)
nls_cp437(E) vfat(E) snd_hda_codec_realtek(E) kvm_intel(E) fat(E)
snd_hda_codec_generic(E) snd_hda_codec_hdmi(E) ledtrig_audio(E) kvm(E)
irqbypass(E) snd_hda_intel(E) crc32_pclmul(E) snd_intel_dspcfg(E)
snd_intel_sdw_acpi(E) snd_hda_codec(E) iTCO_wdt(E) intel_pmc_bxt(E)
iTCO_vendor_support(E) snd_hda_core(E) at24(E) mei_hdcp(E) watchdog(E)
ghash_clmulni_intel(E) snd_hwdep(E) snd_pcm_oss(E) snd_mixer_oss(E)
rapl(E) r8169(E) intel_cstate(E) intel_uncore(E) efi_pstore(E)
pcspkr(E) realtek(E) snd_pcm(E) mdio_devres(E) i2c_i801(E)
snd_timer(E) mei_me(E) i2c_smbus(E) snd(E) ehci_pci(E) sg(E) libphy(E)
soundcore(E) ehci_hcd(E) mei(E) lpc_ich(E) button(E) msr(E)
parport_pc(E) ppdev(E) parport(E) fuse(E) configfs(E) efivarfs(E)
ip_tables(E)
[  149.353267]  x_tables(E) autofs4(E) ext4(E) crc16(E) mbcache(E)
jbd2(E) dm_crypt(E) dm_mod(E) raid10(E) raid456(E) libcrc32c(E)
crc32c_generic(E) async_raid6_recov(E) async_memcpy(E) async_pq(E)
async_xor(E) xor(E) async_tx(E) raid6_pq(E) raid1(E) raid0(E)
multipath(E) linear(E) md_mod(E) hid_generic(E) usbhid(E) hid(E)
sd_mod(E) t10_pi(E) crc_t10dif(E) crct10dif_generic(E)
crct10dif_pclmul(E) crct10dif_common(E) evdev(E) crc32c_intel(E)
i915(E) i2c_algo_bit(E) ahci(E) xhci_pci(E) libahci(E)
drm_kms_helper(E) xhci_hcd(E) cec(E) rc_core(E) libata(E) ttm(E)
aesni_intel(E) crypto_simd(E) usbcore(E) scsi_mod(E) cryptd(E)
scsi_common(E) drm(E) usb_common(E) video(E)
[  149.360796] ---[ end trace 0000000000000000 ]---
[  149.362505] ------------[ cut here ]------------


In my test VM with a bunch of kernel debugging enabled, I get this
KASAN splat (shown here without guess frames) when I attach the same
fake USB device through an emulated HCD:

BUG: KASAN: use-after-free in ax88172a_stop+0xab/0xc0
Read of size 8 at addr ffff88800c684e48 by task kworker/0:2/33

CPU: 0 PID: 33 Comm: kworker/0:2 Not tainted 5.17.0-rc4-00054-gf71077a4d84b=
 #949
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/=
2014
Workqueue: usb_hub_wq hub_event
Call Trace:
 <TASK>
 dump_stack_lvl+0x45/0x59
 print_address_description.constprop.0+0x1f/0x150
 kasan_report.cold+0x7f/0x11b
 ax88172a_stop+0xab/0xc0
 usbnet_stop+0x13d/0x390
 __dev_close_many+0x18c/0x290
 dev_close_many+0x18a/0x3f0
 unregister_netdevice_many+0x2f8/0x1420
 unregister_netdevice_queue+0x1dc/0x280
 unregister_netdev+0x18/0x20
 usbnet_disconnect+0x118/0x260
 usb_unbind_interface+0x182/0x7e0
 __device_release_driver+0x531/0x670
 device_release_driver+0x26/0x40
 bus_remove_device+0x2ae/0x570
 device_del+0x490/0xb50
 usb_disable_device+0x294/0x600
 usb_disconnect.cold+0x1fb/0x68b
 hub_event+0x1472/0x39d0
 process_one_work+0x91d/0x15d0
 worker_thread+0x57b/0x1240
 kthread+0x2a5/0x350
 ret_from_fork+0x22/0x30
 </TASK>

Allocated by task 33:
 kasan_save_stack+0x1e/0x40
 __kasan_kmalloc+0x81/0xa0
 ax88172a_bind+0x95/0x7b0
 usbnet_probe+0xa62/0x2370
 usb_probe_interface+0x27d/0x760
 really_probe+0x475/0xbd0
 __driver_probe_device+0x18f/0x470
 driver_probe_device+0x49/0x120
 __device_attach_driver+0x199/0x250
 bus_for_each_drv+0x125/0x1b0
 __device_attach+0x1e0/0x3d0
 bus_probe_device+0x1a5/0x260
 device_add+0x971/0x1a70
 usb_set_configuration+0x92b/0x1600
 usb_generic_driver_probe+0x79/0xa0
 usb_probe_device+0xab/0x250
 really_probe+0x475/0xbd0
 __driver_probe_device+0x18f/0x470
 driver_probe_device+0x49/0x120
 __device_attach_driver+0x199/0x250
 bus_for_each_drv+0x125/0x1b0
 __device_attach+0x1e0/0x3d0
 bus_probe_device+0x1a5/0x260
 device_add+0x971/0x1a70
 usb_new_device.cold+0x47d/0xb88
 hub_event+0x20c7/0x39d0
 process_one_work+0x91d/0x15d0
 worker_thread+0x57b/0x1240
 kthread+0x2a5/0x350
 ret_from_fork+0x22/0x30

Freed by task 33:
 kasan_save_stack+0x1e/0x40
 kasan_set_track+0x21/0x30
 kasan_set_free_info+0x20/0x30
 __kasan_slab_free+0xe0/0x110
 kfree+0xa5/0x2b0
 usbnet_disconnect+0xe7/0x260
 usb_unbind_interface+0x182/0x7e0
 __device_release_driver+0x531/0x670
 device_release_driver+0x26/0x40
 bus_remove_device+0x2ae/0x570
 device_del+0x490/0xb50
 usb_disable_device+0x294/0x600
 usb_disconnect.cold+0x1fb/0x68b
 hub_event+0x1472/0x39d0
 process_one_work+0x91d/0x15d0
 worker_thread+0x57b/0x1240
 kthread+0x2a5/0x350
 ret_from_fork+0x22/0x30



If you want to test this yourself, you can use the USB raw gadget
(https://www.kernel.org/doc/html/latest/usb/raw-gadget.html)
with dummy_hcd. Compile the attached testcase, then run it as
"./usb-ax88172a dummy_udc dummy_udc.0", wait a few seconds for
the device to come up, and press CTRL+C to trigger USB disconnect.
This requires CONFIG_USB_DUMMY_HCD=3Dy and CONFIG_USB_RAW_GADGET=3Dy.

--00000000000027ae1405df61e695
Content-Type: text/x-c-code; charset="US-ASCII"; name="usb-ax88172a.c"
Content-Disposition: attachment; filename="usb-ax88172a.c"
Content-Transfer-Encoding: base64
Content-ID: <f_l3ddailf0>
X-Attachment-Id: f_l3ddailf0

Ly8gcm91Z2hseSBiYXNlZCBvZmYgaHR0cHM6Ly9naXRodWIuY29tL3hhaXJ5L3Jhdy1nYWRnZXQv
YmxvYi9tYXN0ZXIvZXhhbXBsZXMva2V5Ym9hcmQuYwovLyBOT1RFOiB0aGlzIGlzIHBsYXlpbmcg
ZmFzdC1hbmQtbG9vc2Ugd2l0aCBlbmRpYW5uZXNzLCBpdCdsbCBicmVhayBvbiBiaWctZW5kaWFu
IHN5c3RlbXMuCgojaW5jbHVkZSA8ZXJyLmg+CiNpbmNsdWRlIDxzaWduYWwuaD4KI2luY2x1ZGUg
PHN0ZGJvb2wuaD4KI2luY2x1ZGUgPGFzc2VydC5oPgojaW5jbHVkZSA8YWxsb2NhLmg+CiNpbmNs
dWRlIDxlcnJuby5oPgojaW5jbHVkZSA8dW5pc3RkLmg+CiNpbmNsdWRlIDxzdHJpbmcuaD4KI2lu
Y2x1ZGUgPHN0ZGxpYi5oPgojaW5jbHVkZSA8c3RkaW8uaD4KI2luY2x1ZGUgPGZjbnRsLmg+CiNp
bmNsdWRlIDxzeXMvaW9jdGwuaD4KI2luY2x1ZGUgPGxpbnV4L3VzYi9jZGMuaD4KI2luY2x1ZGUg
PGxpbnV4L3VzYi9yYXdfZ2FkZ2V0Lmg+CiNpbmNsdWRlIDxsaW51eC9taWkuaD4KI2luY2x1ZGUg
PGxpbnV4L21kaW8uaD4KCiNkZWZpbmUgU1lTQ0hLKHgpICh7ICAgICAgICAgIFwKICB0eXBlb2Yo
eCkgX19yZXMgPSAoeCk7ICAgICAgXAogIGlmIChfX3JlcyA9PSAodHlwZW9mKHgpKS0xKSBcCiAg
ICBlcnIoMSwgIlNZU0NISygiICN4ICIpIik7IFwKICBfX3JlczsgICAgICAgICAgICAgICAgICAg
ICAgXAp9KQoKc3RhdGljIGludCB1c2JfZmQ7CgojZGVmaW5lIGVycngoY29kZSwgLi4uKSB7IHBy
aW50ZihfX1ZBX0FSR1NfXyk7IHByaW50ZigiXG4iKTsgd2hpbGUgKDEpIHBhdXNlKCk7IH0KCnN0
cnVjdCB1c2JfcmF3X2NvbnRyb2xfZXZlbnQgewogIHN0cnVjdCB1c2JfcmF3X2V2ZW50IGlubmVy
OwogIHN0cnVjdCB1c2JfY3RybHJlcXVlc3QgY3RybDsKfTsKCnN0YXRpYyBzdHJ1Y3QgdXNiX2Rl
dmljZV9kZXNjcmlwdG9yIHVzYl9kZXZpY2UgPSB7CiAgLmJMZW5ndGggPSBVU0JfRFRfREVWSUNF
X1NJWkUsCiAgLmJEZXNjcmlwdG9yVHlwZSA9IFVTQl9EVF9ERVZJQ0UsCiAgLmJjZFVTQiA9IF9f
Y29uc3RhbnRfY3B1X3RvX2xlMTYoMHgwMjAwKSwgLyogVVNCIDIuMCAqLwogIC5iRGV2aWNlQ2xh
c3MgPSBfX2NvbnN0YW50X2NwdV90b19sZTE2KFVTQl9DTEFTU19DT01NKSwgLy8gaXMgdGhpcyBl
dmVuIHVzZWQ/CiAgLmJNYXhQYWNrZXRTaXplMCA9IDY0LCAvKiBtYXhpbXVtIHZhbHVlIHRoZSBr
ZXJuZWwgbGV0cyB1cyB1c2UgKi8KCiAgLyogIldlIGFyZSBhIHZlcnkgbGVnaXQuLi4iIChjaGVj
a3Mgbm90ZXMpICJBU0lYIDg4MTcyYSBkZW1vIGJvYXJkIiAobG9va3MKICAgKiBiYWNrIHVwKSAi
YW5kIHdvdWxkIGxpa2UgdG8gaGVscCB5b3UgZ2V0IGNvbm5lY3RlZCB0byB0aGUgbmV0d29yayEi
ICovCiAgLmlkVmVuZG9yID0gX19jb25zdGFudF9jcHVfdG9fbGUxNigweDBiOTUpLAogIC5pZFBy
b2R1Y3QgPSBfX2NvbnN0YW50X2NwdV90b19sZTE2KDB4MTcyYSksCgogIC5pTWFudWZhY3R1cmVy
ID0gMSwKICAuaVByb2R1Y3QgPSAyLAogIC5pU2VyaWFsTnVtYmVyID0gMywKCiAgLmJOdW1Db25m
aWd1cmF0aW9ucyA9IDEKfTsKCnN0cnVjdCB1c2JfY29uZmlnX2Rlc2NyaXB0b3IgdXNiX2NvbmZp
ZyA9IHsKICAuYkxlbmd0aCA9IFVTQl9EVF9DT05GSUdfU0laRSwKICAuYkRlc2NyaXB0b3JUeXBl
ID0gVVNCX0RUX0NPTkZJRywKICAud1RvdGFsTGVuZ3RoID0gMCwgLy8gZml4ZWQgdXAgbGF0ZXIK
ICAuYk51bUludGVyZmFjZXMgPSAxLAogIC5iQ29uZmlndXJhdGlvblZhbHVlID0gMSwKICAuaUNv
bmZpZ3VyYXRpb24gPSA0LAogIC5ibUF0dHJpYnV0ZXMgPQogICAgVVNCX0NPTkZJR19BVFRfT05F
IHwvLyBtdXN0IGJlIHNldAogICAgVVNCX0NPTkZJR19BVFRfU0VMRlBPV0VSLAogIC5iTWF4UG93
ZXIgPSAwIC8vIG5vIHBvd2VyIGRyYXcgZnJvbSBob3N0Cn07CnN0cnVjdCB1c2JfaW50ZXJmYWNl
X2Rlc2NyaXB0b3IgdXNiX2ludGVyZmFjZSA9IHsKICAuYkxlbmd0aCA9IFVTQl9EVF9JTlRFUkZB
Q0VfU0laRSwKICAuYkRlc2NyaXB0b3JUeXBlID0gVVNCX0RUX0lOVEVSRkFDRSwKICAuYkludGVy
ZmFjZU51bWJlciA9IDAsCiAgLmJBbHRlcm5hdGVTZXR0aW5nID0gMCwKICAuYk51bUVuZHBvaW50
cyA9IDMsCiAgLmJJbnRlcmZhY2VDbGFzcyA9IFVTQl9DTEFTU19DT01NLCAvLyA/CiAgLmJJbnRl
cmZhY2VTdWJDbGFzcyA9IFVTQl9DRENfU1VCQ0xBU1NfRVRIRVJORVQsCiAgLmJJbnRlcmZhY2VQ
cm90b2NvbCA9IFVTQl9DRENfUFJPVE9fTk9ORSwKICAuaUludGVyZmFjZSA9IDUsCgp9OwpzdHJ1
Y3QgdXNiX2VuZHBvaW50X2Rlc2NyaXB0b3IgdXNiX2VuZHBvaW50X2luID0gewogIC5iTGVuZ3Ro
ID0gVVNCX0RUX0VORFBPSU5UX1NJWkUsCiAgLmJEZXNjcmlwdG9yVHlwZSA9IFVTQl9EVF9FTkRQ
T0lOVCwKICAuYkVuZHBvaW50QWRkcmVzcyA9IFVTQl9ESVJfSU4gfCAxLAogIC5ibUF0dHJpYnV0
ZXMgPSBVU0JfRU5EUE9JTlRfWEZFUl9CVUxLLAogIC53TWF4UGFja2V0U2l6ZSA9IDUxMiwKICAv
Ly5iSW50ZXJ2YWwgPSAxCn07CnN0cnVjdCB1c2JfZW5kcG9pbnRfZGVzY3JpcHRvciB1c2JfZW5k
cG9pbnRfb3V0ID0gewogIC5iTGVuZ3RoID0gVVNCX0RUX0VORFBPSU5UX1NJWkUsCiAgLmJEZXNj
cmlwdG9yVHlwZSA9IFVTQl9EVF9FTkRQT0lOVCwKICAuYkVuZHBvaW50QWRkcmVzcyA9IFVTQl9E
SVJfT1VUIHwgMSwKICAuYm1BdHRyaWJ1dGVzID0gVVNCX0VORFBPSU5UX1hGRVJfQlVMSywKICAu
d01heFBhY2tldFNpemUgPSA1MTIsCiAgLy8uYkludGVydmFsID0gMQp9OwpzdHJ1Y3QgdXNiX2Vu
ZHBvaW50X2Rlc2NyaXB0b3IgdXNiX2VuZHBvaW50X2ludHIgPSB7CiAgLmJMZW5ndGggPSBVU0Jf
RFRfRU5EUE9JTlRfU0laRSwKICAuYkRlc2NyaXB0b3JUeXBlID0gVVNCX0RUX0VORFBPSU5ULAog
IC5iRW5kcG9pbnRBZGRyZXNzID0gVVNCX0RJUl9JTiB8IDIsCiAgLmJtQXR0cmlidXRlcyA9IFVT
Ql9FTkRQT0lOVF9YRkVSX0lOVCwKICAud01heFBhY2tldFNpemUgPSA4LAogIC5iSW50ZXJ2YWwg
PSAxCn07CnVuc2lnbmVkIHNob3J0IGludHJfaGFuZGxlOwoKdm9pZCB1c2JfcmVwbHkodm9pZCAq
ZGF0YSwgc2l6ZV90IGxlbiwgc2l6ZV90IHJlcV9sZW5ndGgpIHsKICBwcmludGYoIiAgICAgICAg
IFJFUExZOiBzaXplICVsdSwgcmVxX2xlbmd0aCAlbHVcbiIsICh1bnNpZ25lZCBsb25nKWxlbiwg
KHVuc2lnbmVkIGxvbmcpcmVxX2xlbmd0aCk7CiAgaWYgKGxlbiA+IHJlcV9sZW5ndGgpCiAgICBs
ZW4gPSByZXFfbGVuZ3RoOwogIHN0cnVjdCB1c2JfcmF3X2VwX2lvICppbyA9IGFsbG9jYShzaXpl
b2Yoc3RydWN0IHVzYl9yYXdfZXBfaW8pK2xlbik7CiAgaW8tPmVwID0gMDsKICBpby0+ZmxhZ3Mg
PSAwOwogIGlvLT5sZW5ndGggPSBsZW47CiAgbWVtY3B5KGlvLT5kYXRhLCBkYXRhLCBsZW4pOwog
IFNZU0NISyhpb2N0bCh1c2JfZmQsIFVTQl9SQVdfSU9DVExfRVAwX1dSSVRFLCBpbykpOwp9Cgp2
b2lkIHVzYl9yZXBseV96ZXJvKHNpemVfdCByZXFfbGVuZ3RoKSB7CiAgY2hhciAqZGF0YSA9IGFs
bG9jYShyZXFfbGVuZ3RoKTsKICBtZW1zZXQoZGF0YSwgJ1wwJywgcmVxX2xlbmd0aCk7CiAgdXNi
X3JlcGx5KGRhdGEsIHJlcV9sZW5ndGgsIHJlcV9sZW5ndGgpOwp9Cgp2b2lkIHVzYl9nZXRfYW5k
X2Fjayh2b2lkICpidWYsIHNpemVfdCBsZW4sIHNpemVfdCByZXFfbGVuZ3RoKSB7CiAgcHJpbnRm
KCIgICAgICAgICBBQ0sgT1VUOiByZXFfbGVuZ3RoICVsdVxuIiwgKHVuc2lnbmVkIGxvbmcpcmVx
X2xlbmd0aCk7CiAgc3RydWN0IHVzYl9yYXdfZXBfaW8gKmlvID0gYWxsb2NhKHNpemVvZihzdHJ1
Y3QgdXNiX3Jhd19lcF9pbykrcmVxX2xlbmd0aCk7CiAgbWVtc2V0KGlvLCAweGVlLCBzaXplb2Yo
c3RydWN0IHVzYl9yYXdfZXBfaW8pK3JlcV9sZW5ndGgpOwogIGlvLT5lcCA9IDA7CiAgaW8tPmZs
YWdzID0gMDsKICBpby0+bGVuZ3RoID0gcmVxX2xlbmd0aDsKICAvL3ByaW50ZigiaXNzdWluZyBV
U0JfUkFXX0lPQ1RMX0VQMF9SRUFEIHdpdGggaW8tPmxlbmd0aD0ldVxuIiwgaW8tPmxlbmd0aCk7
CiAgaW50IHJldF9sZW4gPSBTWVNDSEsoaW9jdGwodXNiX2ZkLCBVU0JfUkFXX0lPQ1RMX0VQMF9S
RUFELCBpbykpOwogIGFzc2VydChyZXRfbGVuID09IHJlcV9sZW5ndGgpOwogIGlmIChidWYpIHsK
ICAgIGlmIChsZW4gPiByZXFfbGVuZ3RoKSB7CiAgICAgIG1lbXNldChidWYsICdcMCcsIGxlbik7
CiAgICAgIGxlbiA9IHJlcV9sZW5ndGg7CiAgICB9CiAgICBtZW1jcHkoYnVmLCAoKGNoYXIqKWlv
KStzaXplb2Yoc3RydWN0IHVzYl9yYXdfZXBfaW8pLCBsZW4pOwogIH0KfQp2b2lkIHVzYl9hY2so
c2l6ZV90IHJlcV9sZW5ndGgpIHsKICB1c2JfZ2V0X2FuZF9hY2soTlVMTCwgMCwgcmVxX2xlbmd0
aCk7Cn0KCnZvaWQgZGVzY3JfYXBwZW5kKHZvaWQgKmJ1Ziwgc2l6ZV90ICpidWZfbGVuLCB2b2lk
ICpkZXNjciwgc2l6ZV90IGRlc2NyX2xlbikgewogIHByaW50ZigiICAgICAgICAgICBkZXNjcl9h
cHBlbmQoYnVmLCBsZW4sIGRlc2NyLCBkZXNjcl9sZW49JWx1IHdpdGggZmlyc3QgYnl0ZSAlaGh1
XG4iLCAodW5zaWduZWQgbG9uZylkZXNjcl9sZW4sICoodW5zaWduZWQgY2hhciAqKWRlc2NyKTsK
ICBhc3NlcnQoZGVzY3JfbGVuIDw9IDI1NSk7CiAgYXNzZXJ0KGRlc2NyX2xlbiA+PSAyKTsKICBh
c3NlcnQoKCh1bnNpZ25lZCBjaGFyKilkZXNjcilbMF0gPT0gZGVzY3JfbGVuKTsKICBtZW1jcHko
YnVmICsgKmJ1Zl9sZW4sIGRlc2NyLCBkZXNjcl9sZW4pOwogICgqYnVmX2xlbikgKz0gZGVzY3Jf
bGVuOwogICgoc3RydWN0IHVzYl9jb25maWdfZGVzY3JpcHRvciopYnVmKS0+d1RvdGFsTGVuZ3Ro
ID0gX19jcHVfdG9fbGUxNigqYnVmX2xlbik7Cn0KCmludCBzdGF0ZSA9IDA7Cgp2b2lkIGhhbmRs
ZV9hbGFybShpbnQgc2lnKSB7CiAgaWYgKHN0YXRlID09IDApCiAgICBzdGF0ZSA9IDE7Cn0KCmlu
dCBtYWluKGludCBhcmdjLCBjaGFyICoqYXJndikgewogIHNldGJ1ZihzdGRvdXQsIE5VTEwpOwog
IHNldGJ1ZihzdGRlcnIsIE5VTEwpOwogIHVzYl9mZCA9IFNZU0NISyhvcGVuKCIvZGV2L3Jhdy1n
YWRnZXQiLCBPX1JEV1IpKTsKCiAgc3RydWN0IHVzYl9yYXdfaW5pdCBpbml0X2FyZ3MgPSB7CiAg
ICAuc3BlZWQgPSBVU0JfU1BFRURfSElHSAogIH07CiAgc3RyY3B5KGluaXRfYXJncy5kcml2ZXJf
bmFtZSwgYXJndlsxXSk7CiAgc3RyY3B5KGluaXRfYXJncy5kZXZpY2VfbmFtZSwgYXJndlsyXSk7
CiAgU1lTQ0hLKGlvY3RsKHVzYl9mZCwgVVNCX1JBV19JT0NUTF9JTklULCAmaW5pdF9hcmdzKSk7
CiAgU1lTQ0hLKGlvY3RsKHVzYl9mZCwgVVNCX1JBV19JT0NUTF9SVU4sIDApKTsKCiAgc3RydWN0
IHNpZ2FjdGlvbiBhbGFybV9hY3QgPSB7CiAgICAuc2FfaGFuZGxlciA9IGhhbmRsZV9hbGFybSwK
ICAgIC5zYV9mbGFncyA9IDAKICB9OwogIGlmIChzaWdhY3Rpb24oU0lHQUxSTSwgJmFsYXJtX2Fj
dCwgTlVMTCkpCiAgICBlcnIoMSwgInNpZ2FjdGlvbiIpOwogIC8vYWxhcm0oMzApOwoKICB3aGls
ZSAoMSkgewogICAgaWYgKHN0YXRlID09IDEpIHsKICAgICAgcHJpbnRmKCI9PT09PT09PT09PT09
PT09PT09PT0gQlJJTkdJTkcgTElOSyBVUCA9PT09PT09PT09PT09PT09PT09PT1cbiIpOwogICAg
ICBzdGF0ZSA9IDI7CiAgICAgIHN0cnVjdCB7CiAgICAgICAgc3RydWN0IHVzYl9yYXdfZXBfaW8g
aW87CiAgICAgICAgc3RydWN0IHsgLypheDg4MTcyX2ludF9kYXRhKi8KICAgICAgICAgIHVuc2ln
bmVkIHNob3J0IHJlczE7CiAgICAgICAgICB1bnNpZ25lZCBjaGFyIGxpbms7CiAgICAgICAgICB1
bnNpZ25lZCBzaG9ydCByZXMyOwogICAgICAgICAgdW5zaWduZWQgY2hhciBzdGF0dXM7CiAgICAg
ICAgICB1bnNpZ25lZCBzaG9ydCByZXMzOwogICAgICAgICAgdW5zaWduZWQgaW50IGludGRhdGEy
OwogICAgICAgIH0gX19hdHRyaWJ1dGVfXygocGFja2VkKSkgZGF0YTsKICAgICAgfSBpb193aXRo
X2RhdGEgPSB7CiAgICAgICAgLmlvID0gewogICAgICAgICAgLmVwID0gaW50cl9oYW5kbGUsCiAg
ICAgICAgICAuZmxhZ3MgPSAwLAogICAgICAgICAgLmxlbmd0aCA9IHNpemVvZihpb193aXRoX2Rh
dGEuZGF0YSkKICAgICAgICB9LCAuZGF0YSA9IHsKICAgICAgICAgIC5saW5rID0gMQogICAgICAg
IH0KICAgICAgfTsKICAgICAgU1lTQ0hLKGlvY3RsKHVzYl9mZCwgVVNCX1JBV19JT0NUTF9FUF9X
UklURSwgJmlvX3dpdGhfZGF0YSkpOwogICAgICAvKgogICAgICBjbG9zZSh1c2JfZmQpOwogICAg
ICBleGl0KDApOwogICAgICAqLwogICAgfQoKICAgIHN0cnVjdCB1c2JfcmF3X2NvbnRyb2xfZXZl
bnQgY29udHJvbF9ldiA9IHsKICAgICAgLmlubmVyID0geyAudHlwZSA9IDAsIC5sZW5ndGggPSBz
aXplb2YoY29udHJvbF9ldi5jdHJsKSB9CiAgICB9OwogICAgaW50IHJlcyA9IGlvY3RsKHVzYl9m
ZCwgVVNCX1JBV19JT0NUTF9FVkVOVF9GRVRDSCwgJmNvbnRyb2xfZXYpOwogICAgaWYgKHJlcyA9
PSAtMSkgewogICAgICBpZiAoZXJybm8gPT0gRUlOVFIpCiAgICAgICAgY29udGludWU7CiAgICAg
IGVycigxLCAiVVNCX1JBV19JT0NUTF9FVkVOVF9GRVRDSCIpOwogICAgfQogICAgaWYgKGNvbnRy
b2xfZXYuaW5uZXIudHlwZSA9PSBVU0JfUkFXX0VWRU5UX0NPTk5FQ1QpIHsKICAgICAgLy8gbm90
aGluZyB0byBkbwogICAgfSBlbHNlIGlmIChjb250cm9sX2V2LmlubmVyLnR5cGUgPT0gVVNCX1JB
V19FVkVOVF9DT05UUk9MKSB7CiAgICAgIHVuc2lnbmVkIHJlcV9sZW5ndGggPSBfX2xlMTZfdG9f
Y3B1KGNvbnRyb2xfZXYuY3RybC53TGVuZ3RoKTsKICAgICAgYm9vbCBpc19kaXJfaW4gPSAoY29u
dHJvbF9ldi5jdHJsLmJSZXF1ZXN0VHlwZSAmIFVTQl9ESVJfSU4pICE9IDA7CiAgICAgIHByaW50
ZigiZ290IGNvbnRyb2wgKGluPSVkLCB3TGVuZ3RoPSV1KTpcbiIsIGlzX2Rpcl9pbiwgcmVxX2xl
bmd0aCk7CiAgICAgIHN3aXRjaCAoY29udHJvbF9ldi5jdHJsLmJSZXF1ZXN0VHlwZSAmIFVTQl9U
WVBFX01BU0spIHsKICAgICAgICBjYXNlIFVTQl9UWVBFX1NUQU5EQVJEOgogICAgICAgICAgc3dp
dGNoKGNvbnRyb2xfZXYuY3RybC5iUmVxdWVzdCkgewogICAgICAgICAgICBjYXNlIFVTQl9SRVFf
R0VUX0RFU0NSSVBUT1I6IHsKICAgICAgICAgICAgICB1bnNpZ25lZCBkZXNjcmlwdG9yX3R5cGUg
PSBjb250cm9sX2V2LmN0cmwud1ZhbHVlID4+IDg7CiAgICAgICAgICAgICAgc3dpdGNoIChkZXNj
cmlwdG9yX3R5cGUpIHsKICAgICAgICAgICAgICAgIGNhc2UgVVNCX0RUX0RFVklDRToKICAgICAg
ICAgICAgICAgICAgcHJpbnRmKCIgIGdldHRpbmcgZGV2aWNlIGRlc2NyaXB0b3JcbiIpOwogICAg
ICAgICAgICAgICAgICB1c2JfcmVwbHkoJnVzYl9kZXZpY2UsIHNpemVvZih1c2JfZGV2aWNlKSwg
cmVxX2xlbmd0aCk7CiAgICAgICAgICAgICAgICAgIGJyZWFrOwogICAgICAgICAgICAgICAgY2Fz
ZSBVU0JfRFRfQ09ORklHOiB7CiAgICAgICAgICAgICAgICAgIHByaW50ZigiICBnZXR0aW5nIGR0
IGNvbmZpZ1xuIik7CiAgICAgICAgICAgICAgICAgIGNoYXIgZHRfY29uZmlnWzEwMjQqMTI4XTsK
ICAgICAgICAgICAgICAgICAgc2l6ZV90IGR0X2NvbmZpZ19sZW4gPSAwOwogICAgICAgICAgICAg
ICAgICBkZXNjcl9hcHBlbmQoZHRfY29uZmlnLCAmZHRfY29uZmlnX2xlbiwgJnVzYl9jb25maWcs
IHNpemVvZih1c2JfY29uZmlnKSk7CiAgICAgICAgICAgICAgICAgIGRlc2NyX2FwcGVuZChkdF9j
b25maWcsICZkdF9jb25maWdfbGVuLCAmdXNiX2ludGVyZmFjZSwgc2l6ZW9mKHVzYl9pbnRlcmZh
Y2UpKTsKICAgICAgICAgICAgICAgICAgZGVzY3JfYXBwZW5kKGR0X2NvbmZpZywgJmR0X2NvbmZp
Z19sZW4sICZ1c2JfZW5kcG9pbnRfaW4sIFVTQl9EVF9FTkRQT0lOVF9TSVpFKTsKICAgICAgICAg
ICAgICAgICAgZGVzY3JfYXBwZW5kKGR0X2NvbmZpZywgJmR0X2NvbmZpZ19sZW4sICZ1c2JfZW5k
cG9pbnRfb3V0LCBVU0JfRFRfRU5EUE9JTlRfU0laRSk7CiAgICAgICAgICAgICAgICAgIGRlc2Ny
X2FwcGVuZChkdF9jb25maWcsICZkdF9jb25maWdfbGVuLCAmdXNiX2VuZHBvaW50X2ludHIsIFVT
Ql9EVF9FTkRQT0lOVF9TSVpFKTsKICAgICAgICAgICAgICAgICAgdXNiX3JlcGx5KGR0X2NvbmZp
ZywgZHRfY29uZmlnX2xlbiwgcmVxX2xlbmd0aCk7CiAgICAgICAgICAgICAgICB9IGJyZWFrOwog
ICAgICAgICAgICAgICAgY2FzZSBVU0JfRFRfU1RSSU5HOiB7CiAgICAgICAgICAgICAgICAgIHVu
c2lnbmVkIHN0cmluZ19pZCA9IGNvbnRyb2xfZXYuY3RybC53VmFsdWUgJiAweGZmOwogICAgICAg
ICAgICAgICAgICBwcmludGYoIiAgZ2V0dGluZyBzdHJpbmcgJWRcbiIsIHN0cmluZ19pZCk7CiAg
ICAgICAgICAgICAgICAgIGlmIChzdHJpbmdfaWQgPT0gMCkgewogICAgICAgICAgICAgICAgICAg
IHVuc2lnbmVkIGNoYXIgc3RyaW5nX2Rlc2NyW10gPSB7CiAgICAgICAgICAgICAgICAgICAgICA0
LypsZW5ndGgqLywgVVNCX0RUX1NUUklORywKICAgICAgICAgICAgICAgICAgICAgIDB4MDksIDB4
MDQgLyogRW5nbGlzaCAtIFVuaXRlZCBTdGF0ZXMgKi8KICAgICAgICAgICAgICAgICAgICB9Owog
ICAgICAgICAgICAgICAgICAgIHVzYl9yZXBseShzdHJpbmdfZGVzY3IsIHNpemVvZihzdHJpbmdf
ZGVzY3IpLCByZXFfbGVuZ3RoKTsKICAgICAgICAgICAgICAgICAgfSBlbHNlIHsKICAgICAgICAg
ICAgICAgICAgICB1bnNpZ25lZCBjaGFyIHN0cmluZ19kZXNjcltdID0gewogICAgICAgICAgICAg
ICAgICAgICAgMTIvKmxlbmd0aCovLCBVU0JfRFRfU1RSSU5HLAogICAgICAgICAgICAgICAgICAg
ICAgJ0QnLDAsJ1UnLDAsJ00nLDAsJ00nLDAsJ1knLDAKICAgICAgICAgICAgICAgICAgICB9Owog
ICAgICAgICAgICAgICAgICAgIHVzYl9yZXBseShzdHJpbmdfZGVzY3IsIHNpemVvZihzdHJpbmdf
ZGVzY3IpLCByZXFfbGVuZ3RoKTsKICAgICAgICAgICAgICAgICAgfQogICAgICAgICAgICAgICAg
fSBicmVhazsKICAgICAgICAgICAgICAgIGRlZmF1bHQ6CiAgICAgICAgICAgICAgICAgIGVycngo
MSwgIlVTQl9SRVFfR0VUX0RFU0NSSVBUT1I6IGRlc2NyaXB0b3JfdHlwZT0leCIsIGRlc2NyaXB0
b3JfdHlwZSk7CiAgICAgICAgICAgICAgfQogICAgICAgICAgICB9IGJyZWFrOwogICAgICAgICAg
ICBjYXNlIFVTQl9SRVFfU0VUX0NPTkZJR1VSQVRJT046IHsKICAgICAgICAgICAgICBwcmludGYo
IiAgc2V0IGNvbmZpZ3VyYXRpb25cbiIpOwogICAgICAgICAgICAgIFNZU0NISyhpb2N0bCh1c2Jf
ZmQsIFVTQl9SQVdfSU9DVExfRVBfRU5BQkxFLCAmdXNiX2VuZHBvaW50X2luKSk7CiAgICAgICAg
ICAgICAgU1lTQ0hLKGlvY3RsKHVzYl9mZCwgVVNCX1JBV19JT0NUTF9FUF9FTkFCTEUsICZ1c2Jf
ZW5kcG9pbnRfb3V0KSk7CiAgICAgICAgICAgICAgaW50cl9oYW5kbGUgPSBTWVNDSEsoaW9jdGwo
dXNiX2ZkLCBVU0JfUkFXX0lPQ1RMX0VQX0VOQUJMRSwgJnVzYl9lbmRwb2ludF9pbnRyKSk7CiAg
ICAgICAgICAgICAgU1lTQ0hLKGlvY3RsKHVzYl9mZCwgVVNCX1JBV19JT0NUTF9DT05GSUdVUkUs
IDApKTsKICAgICAgICAgICAgICB1c2JfYWNrKHJlcV9sZW5ndGgpOwogICAgICAgICAgICB9IGJy
ZWFrOwogICAgICAgICAgICBjYXNlIFVTQl9SRVFfU0VUX0lOVEVSRkFDRTogewogICAgICAgICAg
ICAgIHByaW50ZigiICBzZXQgaW50ZXJmYWNlXG4iKTsKICAgICAgICAgICAgICB1c2JfYWNrKHJl
cV9sZW5ndGgpOwogICAgICAgICAgICB9IGJyZWFrOwogICAgICAgICAgICBkZWZhdWx0OgogICAg
ICAgICAgICAgIGVycngoMSwgInVua25vd24gc3RhbmRhcmQgY3RybHJlcXVlc3QgMHgleCIsICh1
bnNpZ25lZCljb250cm9sX2V2LmN0cmwuYlJlcXVlc3QpOwogICAgICAgICAgfQogICAgICAgICAg
YnJlYWs7CiAgICAgICAgY2FzZSBVU0JfVFlQRV9DTEFTUzoKICAgICAgICAgIGVycngoMSwgInVu
a25vd24gY2xhc3MgY3RybHJlcXVlc3QiKTsKICAgICAgICBjYXNlIFVTQl9UWVBFX1ZFTkRPUjoK
ICAgICAgICAgIHByaW50ZigiICB2ZW5kb3IgY3RybHJlcXVlc3QgYlJlcXVlc3Q9MHglMDJoaHgg
d1ZhbHVlPTB4JTA0aHggd0luZGV4PTB4JTA0aHggd0xlbmd0aD0weCUwNGh4XG4iLCBjb250cm9s
X2V2LmN0cmwuYlJlcXVlc3QsIGNvbnRyb2xfZXYuY3RybC53VmFsdWUsIGNvbnRyb2xfZXYuY3Ry
bC53SW5kZXgsIGNvbnRyb2xfZXYuY3RybC53TGVuZ3RoKTsKICAgICAgICAgIGlmICghaXNfZGly
X2luKSB7CiAgICAgICAgICAgIHVzYl9hY2socmVxX2xlbmd0aCk7CiAgICAgICAgICAgIGNvbnRp
bnVlOwogICAgICAgICAgfQogICAgICAgICAgc3dpdGNoIChjb250cm9sX2V2LmN0cmwuYlJlcXVl
c3QpIHsKI2lmIDEKICAgICAgICAgICAgY2FzZSAweDAxLypBWF9BQ0NFU1NfTUFDKi86IHsKICAg
ICAgICAgICAgICBzdGF0aWMgdW5zaWduZWQgY2hhciBzcm9tX2FkZHI7CiAgICAgICAgICAgICAg
c3RhdGljIGNvbnN0IHVuc2lnbmVkIHNob3J0IGxlZHZhbHVlID0gKDE8PDE1LypMRURfVkFMSUQq
Lyk7CiAgICAgICAgICAgICAgcHJpbnRmKCIgIEFYX0FDQ0VTU19NQUNcbiIpOwogICAgICAgICAg
ICAgIHN3aXRjaCAoY29udHJvbF9ldi5jdHJsLndWYWx1ZSkgewogICAgICAgICAgICAgICAgY2Fz
ZSAweDAyLypQSFlTSUNBTF9MSU5LX1NUQVRVUyovOiB7CiAgICAgICAgICAgICAgICAgIHByaW50
ZigiICAgIFBIWVNJQ0FMX0xJTktfU1RBVFVTXG4iKTsKICAgICAgICAgICAgICAgICAgLyogTGlu
dXggY2hlY2tzIEFYX1VTQl9TUyBhbmQgQVhfVVNCX0hTLCBpbmZsdWVuY2VzIFVSQiBzaXplOgog
ICAgICAgICAgICAgICAgICAgKiAtPnJ4X3VyYl9zaXplCiAgICAgICAgICAgICAgICAgICAqIGNh
biBiZSAweDUwMDAgLyAweDYwMDAgLyAweDY4MDAgLyAweDY4MDAKICAgICAgICAgICAgICAgICAg
ICogV2UgcHJlZmVyIHRoZSBzbWFsbGVzdCBvbmUgKDB4NTAwMCksIHdoaWNoIHdlIGdldCBmcm9t
CiAgICAgICAgICAgICAgICAgICAqIHNldHRpbmcgQVhfVVNCX1NTIHBsdXMgR01JSV9QSFlfUEhZ
U1JfR0lHQS4KICAgICAgICAgICAgICAgICAgICovCiAgICAgICAgICAgICAgICAgIHVuc2lnbmVk
IGNoYXIgcGxfc3RhdHVzID0gMHgwNDsgLypBWF9VU0JfU1MqLwogICAgICAgICAgICAgICAgICB1
c2JfcmVwbHkoJnBsX3N0YXR1cywgc2l6ZW9mKHBsX3N0YXR1cyksIHJlcV9sZW5ndGgpOwogICAg
ICAgICAgICAgICAgfSBicmVhazsKICAgICAgICAgICAgICAgIGNhc2UgMHgwMy8qR0VORVJBTF9T
VEFUVVMqLzogewogICAgICAgICAgICAgICAgICBwcmludGYoIiAgICBHRU5FUkFMX1NUQVRVU1xu
Iik7CiAgICAgICAgICAgICAgICAgIHVuc2lnbmVkIHNob3J0IGdlbmVyYWxfc3RhdHVzID0gX19j
cHVfdG9fbGUxNigweDA0LypBWF9TRUNMRCovKTsKICAgICAgICAgICAgICAgICAgdXNiX3JlcGx5
KCZnZW5lcmFsX3N0YXR1cywgMiwgcmVxX2xlbmd0aCk7CiAgICAgICAgICAgICAgICB9IGJyZWFr
OwogICAgICAgICAgICAgICAgY2FzZSAweDA3LypBWF9TUk9NX0FERFIqLzogewogICAgICAgICAg
ICAgICAgICBwcmludGYoIiAgICBBWF9TUk9NX0FERFJcbiIpOwogICAgICAgICAgICAgICAgICB1
c2JfZ2V0X2FuZF9hY2soJnNyb21fYWRkciwgMSwgcmVxX2xlbmd0aCk7CiAgICAgICAgICAgICAg
ICAgIHByaW50ZigiICAgIFNST00gYWRkcmVzczogMHglaGh4XG4iLCBzcm9tX2FkZHIpOwogICAg
ICAgICAgICAgICAgfSBicmVhazsKICAgICAgICAgICAgICAgIGNhc2UgMHgwOC8qQVhfU1JPTV9E
QVRBX0xPVyovOiB7CiAgICAgICAgICAgICAgICAgIHByaW50ZigiICAgIEFYX1NST01fREFUQV9M
T1cgZnJvbSAweCVoaHhcbiIsIHNyb21fYWRkcik7CiAgICAgICAgICAgICAgICAgIGlmIChzcm9t
X2FkZHIgPCA2KSB7CiAgICAgICAgICAgICAgICAgICAgdW5zaWduZWQgY2hhciBlZXByb21faGVh
ZFsxMl0gPSB7CiAgICAgICAgICAgICAgICAgICAgICAvKjAtNSovMCwgMCwgMCwgMCwgMCwgMCwg
Ly8gZG9udGNhcmUgKGZpcnN0IG11c3Qgbm90IGJlIEZGKQogICAgICAgICAgICAgICAgICAgICAg
Lyo2LTkqLzAsIDAsIDAsIDAsIC8vIGNoZWNrc3VtbWVkCiAgICAgICAgICAgICAgICAgICAgICAv
KjEwKi8weGZmIC8vIGNoZWNrc3VtCiAgICAgICAgICAgICAgICAgICAgfTsKICAgICAgICAgICAg
ICAgICAgICB1c2JfcmVwbHkoZWVwcm9tX2hlYWQgKyBzcm9tX2FkZHIqMiwgMiwgcmVxX2xlbmd0
aCk7CiAgICAgICAgICAgICAgICAgIH0gZWxzZSBpZiAoc3JvbV9hZGRyID09IDB4NDIpIHsKICAg
ICAgICAgICAgICAgICAgICB1bnNpZ25lZCBjaGFyIGIgPSA4ICYgMHhmZjsKICAgICAgICAgICAg
ICAgICAgICB1c2JfcmVwbHkoJmIsIDEsIHJlcV9sZW5ndGgpOwogICAgICAgICAgICAgICAgICB9
IGVsc2UgewogICAgICAgICAgICAgICAgICAgIGVycngoMSwgInVuaGFuZGxlZCBTUk9NIHJhbmdl
Iik7CiAgICAgICAgICAgICAgICAgIH0KICAgICAgICAgICAgICAgIH0gYnJlYWs7CiAgICAgICAg
ICAgICAgICBjYXNlIDB4MDkvKkFYX1NST01fREFUQV9ISUdIKi86IHsKICAgICAgICAgICAgICAg
ICAgcHJpbnRmKCIgICAgQVhfU1JPTV9EQVRBX0hJR0ggZnJvbSAweCVoaHhcbiIsIHNyb21fYWRk
cik7CiAgICAgICAgICAgICAgICAgIGlmIChzcm9tX2FkZHIgPT0gMHg0MikgewogICAgICAgICAg
ICAgICAgICAgIHVuc2lnbmVkIGNoYXIgYiA9IGxlZHZhbHVlID4+IDg7CiAgICAgICAgICAgICAg
ICAgICAgdXNiX3JlcGx5KCZiLCAxLCByZXFfbGVuZ3RoKTsKICAgICAgICAgICAgICAgICAgfSBl
bHNlIHsKICAgICAgICAgICAgICAgICAgICBlcnJ4KDEsICJ1bmhhbmRsZWQgU1JPTSByYW5nZSIp
OwogICAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgICAgICB9IGJyZWFrOwogICAgICAgICAg
ICAgICAgY2FzZSAweDBhLypBWF9TUk9NX0NNRCovOiB7CiAgICAgICAgICAgICAgICAgIHByaW50
ZigiICAgIEFYX1NST01fQ01EXG4iKTsKICAgICAgICAgICAgICAgICAgaWYgKGlzX2Rpcl9pbikg
ewogICAgICAgICAgICAgICAgICAgIHVuc2lnbmVkIGNoYXIgdmFsdWUgPSAwOyAvLyBFRVBfQlVT
WSB3b3VsZCBzcGluIHVudGlsIHRpbWVvdXQKICAgICAgICAgICAgICAgICAgICB1c2JfcmVwbHko
JnZhbHVlLCAxLCByZXFfbGVuZ3RoKTsKICAgICAgICAgICAgICAgICAgfSBlbHNlIHsKICAgICAg
ICAgICAgICAgICAgICB1c2JfYWNrKHJlcV9sZW5ndGgpOwogICAgICAgICAgICAgICAgICB9CiAg
ICAgICAgICAgICAgICB9IGJyZWFrOwogICAgICAgICAgICAgICAgY2FzZSAweDBiLypBWF9SWF9D
VEwqLzogewogICAgICAgICAgICAgICAgICB1bnNpZ25lZCBzaG9ydCBheF9yeF9jdGxfdmFsdWU7
CiAgICAgICAgICAgICAgICAgIHVzYl9nZXRfYW5kX2FjaygmYXhfcnhfY3RsX3ZhbHVlLCBzaXpl
b2YoYXhfcnhfY3RsX3ZhbHVlKSwgcmVxX2xlbmd0aCk7CiAgICAgICAgICAgICAgICAgIHByaW50
ZigiICAgIEFYX1JYX0NUTCA9IDB4JTA0aHggICMjIyMjIyMjIyMjIyMjIyNcbiIsIGF4X3J4X2N0
bF92YWx1ZSk7CiAgICAgICAgICAgICAgICB9IGJyZWFrOwogICAgICAgICAgICAgICAgY2FzZSAw
eDE2LypBWF9NVUxGTFRBUlkqLzogewogICAgICAgICAgICAgICAgICBwcmludGYoIiAgICBBWF9N
VUxGTFRBUlkgIHx8fHx8fHx8fHx8fHx8fHx8fHx8fHx8fHx8fHx8fHx8fHx8fHx8fHx8fFxuIik7
CiAgICAgICAgICAgICAgICAgIHVzYl9hY2socmVxX2xlbmd0aCk7CiAgICAgICAgICAgICAgICAg
IGlmIChzdGF0ZSA9PSAwKQogICAgICAgICAgICAgICAgICAgIHN0YXRlID0gMTsKICAgICAgICAg
ICAgICAgIH0gYnJlYWs7CiAgICAgICAgICAgICAgICBjYXNlIDB4MjIvKkFYX01FRElVTV9TVEFU
VVNfTU9ERSovOiB7CiAgICAgICAgICAgICAgICAgIHByaW50ZigiICAgIEFYX01FRElVTV9TVEFU
VVNfTU9ERVxuIik7CiAgICAgICAgICAgICAgICAgIHVzYl9hY2socmVxX2xlbmd0aCk7CiAgICAg
ICAgICAgICAgICB9IGJyZWFrOwogICAgICAgICAgICAgICAgY2FzZSAweDI0LypBWF9NT05JVE9S
X01PRCovOiB7CiAgICAgICAgICAgICAgICAgIHByaW50ZigiICAgIEFYX01PTklUT1JfTU9EXG4i
KTsKICAgICAgICAgICAgICAgICAgdXNiX2FjayhyZXFfbGVuZ3RoKTsKICAgICAgICAgICAgICAg
IH0gYnJlYWs7CiAgICAgICAgICAgICAgICBjYXNlIDB4MjYvKkFYX1BIWVBXUl9SU1RDVEwqLzog
ewogICAgICAgICAgICAgICAgICBwcmludGYoIiAgICBBWF9QSFlQV1JfUlNUQ1RMXG4iKTsKICAg
ICAgICAgICAgICAgICAgdXNiX2FjayhyZXFfbGVuZ3RoKTsKICAgICAgICAgICAgICAgIH0gYnJl
YWs7CiAgICAgICAgICAgICAgICBjYXNlIDB4MmUvKkFYX1JYX0JVTEtJTl9RQ1RSTCovOiB7CiAg
ICAgICAgICAgICAgICAgIHByaW50ZigiICAgIEFYX1JYX0JVTEtJTl9RQ1RSTFxuIik7CiAgICAg
ICAgICAgICAgICAgIHVzYl9hY2socmVxX2xlbmd0aCk7CiAgICAgICAgICAgICAgICB9IGJyZWFr
OwogICAgICAgICAgICAgICAgY2FzZSAweDM0LypBWF9SWENPRV9DVEwqLzogewogICAgICAgICAg
ICAgICAgICBwcmludGYoIiAgICBBWF9SWENPRV9DVExcbiIpOwogICAgICAgICAgICAgICAgICB1
c2JfYWNrKHJlcV9sZW5ndGgpOwogICAgICAgICAgICAgICAgfSBicmVhazsKICAgICAgICAgICAg
ICAgIGNhc2UgMHgzNS8qQVhfVFhDT0VfQ1RMKi86IHsKICAgICAgICAgICAgICAgICAgcHJpbnRm
KCIgICAgQVhfVFhDT0VfQ1RMXG4iKTsKICAgICAgICAgICAgICAgICAgdXNiX2FjayhyZXFfbGVu
Z3RoKTsKICAgICAgICAgICAgICAgIH0gYnJlYWs7CiAgICAgICAgICAgICAgICBjYXNlIDB4NTQv
KkFYX1BBVVNFX1dBVEVSTFZMX0hJR0gqLzogewogICAgICAgICAgICAgICAgICBwcmludGYoIiAg
ICBBWF9QQVVTRV9XQVRFUkxWTF9ISUdIXG4iKTsKICAgICAgICAgICAgICAgICAgdXNiX2Fjayhy
ZXFfbGVuZ3RoKTsKICAgICAgICAgICAgICAgIH0gYnJlYWs7CiAgICAgICAgICAgICAgICBjYXNl
IDB4NTUvKkFYX1BBVVNFX1dBVEVSTFZMX0xPVyovOiB7CiAgICAgICAgICAgICAgICAgIHByaW50
ZigiICAgIEFYX1BBVVNFX1dBVEVSTFZMX0xPV1xuIik7CiAgICAgICAgICAgICAgICAgIHVzYl9h
Y2socmVxX2xlbmd0aCk7CiAgICAgICAgICAgICAgICB9IGJyZWFrOwogICAgICAgICAgICAgICAg
Y2FzZSAweDczLypBWF9MRURDVFJMKi86IHsKICAgICAgICAgICAgICAgICAgcHJpbnRmKCIgICAg
QVhfTEVEQ1RSTFxuIik7CiAgICAgICAgICAgICAgICAgIHVzYl9hY2socmVxX2xlbmd0aCk7CiAg
ICAgICAgICAgICAgICB9IGJyZWFrOwogICAgICAgICAgICAgICAgY2FzZSAweDMzLypBWF9DTE9D
S19TRUxFQ1QqLzogewogICAgICAgICAgICAgICAgICBwcmludGYoIiAgICBBWF9DTE9DS19TRUxF
Q1RcbiIpOwogICAgICAgICAgICAgICAgICB1c2JfYWNrKHJlcV9sZW5ndGgpOwogICAgICAgICAg
ICAgICAgfSBicmVhazsKICAgICAgICAgICAgICAgIGNhc2UgMHgxMC8qQVhfTk9ERV9JRCovOiB7
CiAgICAgICAgICAgICAgICAgIHByaW50ZigiICAgIEFYX05PREVfSURcbiIpOwogICAgICAgICAg
ICAgICAgICBpZiAoaXNfZGlyX2luKSB7CiAgICAgICAgICAgICAgICAgICAgdW5zaWduZWQgY2hh
ciBtYWNfYWRkcltdID0geyAweDAwLCAweDEyLCAweDM0LCAweDU2LCAweDc4LCAweDkwIH07CiAg
ICAgICAgICAgICAgICAgICAgdXNiX3JlcGx5KG1hY19hZGRyLCBzaXplb2YobWFjX2FkZHIpLCBy
ZXFfbGVuZ3RoKTsKICAgICAgICAgICAgICAgICAgfSBlbHNlIHsKICAgICAgICAgICAgICAgICAg
ICB1c2JfYWNrKHJlcV9sZW5ndGgpOwogICAgICAgICAgICAgICAgICB9CiAgICAgICAgICAgICAg
ICB9IGJyZWFrOwogICAgICAgICAgICAgICAgZGVmYXVsdDoKICAgICAgICAgICAgICAgICAgaWYg
KGlzX2Rpcl9pbikgewogICAgICAgICAgICAgICAgICAgIGVycngoMSwgIiAgICB1bmtub3duIEFY
X0FDQ0VTU19NQUMgY29tbWFuZCAweCUwMmhoeCIsIGNvbnRyb2xfZXYuY3RybC53VmFsdWUpOwog
ICAgICAgICAgICAgICAgICB9IGVsc2UgewogICAgICAgICAgICAgICAgICAgIHByaW50ZigiICAg
IGlnbm9yaW5nIHVua25vd24gT1VUIEFYX0FDQ0VTU19NQUMgY29tbWFuZCAweCUwMmh4XG4iLCBj
b250cm9sX2V2LmN0cmwud1ZhbHVlKTsKICAgICAgICAgICAgICAgICAgfQogICAgICAgICAgICAg
IH0KICAgICAgICAgICAgfSBicmVhazsKICAgICAgICAgICAgY2FzZSAweDAyLypBWF9BQ0NFU1Nf
UEhZKi86IHsKICAgICAgICAgICAgICBwcmludGYoIiAgQVhfQUNDRVNTX1BIWVxuIik7CiAgICAg
ICAgICAgICAgYXNzZXJ0KGNvbnRyb2xfZXYuY3RybC53VmFsdWUgPT0gMHgwMy8qQVg4ODE3OV9Q
SFlfSUQqLyk7CiAgICAgICAgICAgICAgc3RhdGljIHVuc2lnbmVkIHNob3J0IG1tZF9pZDsKICAg
ICAgICAgICAgICBzdGF0aWMgYm9vbCBub19hdXRvX2luY3JlbWVudDsKICAgICAgICAgICAgICBz
d2l0Y2ggKGNvbnRyb2xfZXYuY3RybC53SW5kZXgpIHsKICAgICAgICAgICAgICAgIGNhc2UgTUlJ
X0JNQ1I6IHsgLyogQmFzaWMgbW9kZSBjb250cm9sIHJlZ2lzdGVyICovCiAgICAgICAgICAgICAg
ICAgIC8qIGlkayB3aGF0IGFueSBvZiB0aGVzZSBmbGFncyBhY3R1YWxseSBkbyBpbiBkZXRhaWwu
Li4gKi8KICAgICAgICAgICAgICAgICAgcHJpbnRmKCIgICAgTUlJX0JNQ1IgKGJhc2ljIG1vZGUg
Y29udHJvbCByZWdpc3RlcilcbiIpOwogICAgICAgICAgICAgICAgICBpZiAoaXNfZGlyX2luKSB7
CiAgICAgICAgICAgICAgICAgICAgdW5zaWduZWQgc2hvcnQgYm1jcl9zdGF0ZSA9IEJNQ1JfU1BF
RUQxMDAwIHwgQk1DUl9GVUxMRFBMWDsKICAgICAgICAgICAgICAgICAgICB1c2JfcmVwbHkoJmJt
Y3Jfc3RhdGUsIHNpemVvZihibWNyX3N0YXRlKSwgcmVxX2xlbmd0aCk7CiAgICAgICAgICAgICAg
ICAgIH0gZWxzZSB7CiAgICAgICAgICAgICAgICAgICAgdXNiX2FjayhyZXFfbGVuZ3RoKTsKICAg
ICAgICAgICAgICAgICAgfQogICAgICAgICAgICAgICAgfSBicmVhazsKICAgICAgICAgICAgICAg
IGNhc2UgTUlJX01NRF9DVFJMOiB7CiAgICAgICAgICAgICAgICAgIHByaW50ZigiICAgIE1JSV9N
TURfQ1RSTFxuIik7CiAgICAgICAgICAgICAgICAgIHVzYl9nZXRfYW5kX2FjaygmbW1kX2lkLCAy
LCByZXFfbGVuZ3RoKTsKICAgICAgICAgICAgICAgICAgbW1kX2lkICY9IH4weDQwMDA7CiAgICAg
ICAgICAgICAgICAgIG5vX2F1dG9faW5jcmVtZW50ID0gKG1tZF9pZCAmIDB4NDAwMCkgIT0gMDsK
ICAgICAgICAgICAgICAgICAgcHJpbnRmKCIgICAgc2V0IElEICVkLCBuby1hdXRvLWluY3JlbWVu
dCAlZFxuIiwgbW1kX2lkLCBub19hdXRvX2luY3JlbWVudCk7CiAgICAgICAgICAgICAgICB9IGJy
ZWFrOwogICAgICAgICAgICAgICAgY2FzZSBNSUlfTU1EX0RBVEE6IHsKICAgICAgICAgICAgICAg
ICAgcHJpbnRmKCIgICAgTUlJX01NRF9EQVRBIChhdCBJRCAlZClcbiIsIG1tZF9pZCk7CiAgICAg
ICAgICAgICAgICAgIGlmIChpc19kaXJfaW4pIHsKICAgICAgICAgICAgICAgICAgICBzd2l0Y2gg
KG1tZF9pZCkgewogICAgICAgICAgICAgICAgICAgICAgY2FzZSBNRElPX01NRF9QQ1M6CiAgICAg
ICAgICAgICAgICAgICAgICAgIHByaW50ZigiICAgIFBoeXNpY2FsIENvZGluZyBTdWJsYXllclxu
Iik7CiAgICAgICAgICAgICAgICAgICAgICAgIC8vIGRlY29kZWQgdmlhIG1tZF9lZWVfY2FwX3Rv
X2V0aHRvb2xfc3VwX3QoKQogICAgICAgICAgICAgICAgICAgICAgICB1bnNpZ25lZCBzaG9ydCBl
ZWVfY2FwcyA9IE1ESU9fRUVFXzEwMDBUOwogICAgICAgICAgICAgICAgICAgICAgICB1c2JfcmVw
bHkoJmVlZV9jYXBzLCBzaXplb2YoZWVlX2NhcHMpLCByZXFfbGVuZ3RoKTsKICAgICAgICAgICAg
ICAgICAgICAgICAgYnJlYWs7CiAgICAgICAgICAgICAgICAgICAgICBjYXNlIE1ESU9fTU1EX0FO
OgogICAgICAgICAgICAgICAgICAgICAgICBwcmludGYoIiAgICBBdXRvLU5lZ290aWF0aW9uXG4i
KTsKICAgICAgICAgICAgICAgICAgICAgICAgLy8gV0FSTklORzogdGhpcyBpcyBhY3R1YWxseSB1
c2VkIGluIHR3byBkaWZmZXJlbnQKICAgICAgICAgICAgICAgICAgICAgICAgLy8gICAgICAgICAg
Y29udGV4dHMKICAgICAgICAgICAgICAgICAgICAgICAgdW5zaWduZWQgc2hvcnQgZWVlX2FkdiA9
IE1ESU9fRUVFXzEwMDBUOwogICAgICAgICAgICAgICAgICAgICAgICB1c2JfcmVwbHkoJmVlZV9h
ZHYsIHNpemVvZihlZWVfYWR2KSwgcmVxX2xlbmd0aCk7CiAgICAgICAgICAgICAgICAgICAgICAg
IGJyZWFrOwogICAgICAgICAgICAgICAgICAgICAgZGVmYXVsdDoKICAgICAgICAgICAgICAgICAg
ICAgICAgZXJyeCgxLCAidW5rbm93biBJRCAlZCIsIG1tZF9pZCk7CiAgICAgICAgICAgICAgICAg
ICAgfQogICAgICAgICAgICAgICAgICB9IGVsc2UgewogICAgICAgICAgICAgICAgICAgIHVzYl9h
Y2socmVxX2xlbmd0aCk7CiAgICAgICAgICAgICAgICAgIH0KICAgICAgICAgICAgICAgIH0gYnJl
YWs7CiAgICAgICAgICAgICAgICBjYXNlIE1JSV9QSFlBRERSOiB7CiAgICAgICAgICAgICAgICAg
IHByaW50ZigiICAgIE1JSV9QSFlBRERSXG4iKTsKICAgICAgICAgICAgICAgICAgdXNiX2Fjayhy
ZXFfbGVuZ3RoKTsKICAgICAgICAgICAgICAgIH0gYnJlYWs7CiAgICAgICAgICAgICAgICBjYXNl
IDB4MTEvKkdNSUlfUEhZX1BIWVNSKi86IHsKICAgICAgICAgICAgICAgICAgcHJpbnRmKCIgICAg
TUlJX1BIWV9QSFlTUlxuIik7CiAgICAgICAgICAgICAgICAgIHVuc2lnbmVkIHNob3J0IHBoeXNy
ID0gMHgwNDAwLypHTUlJX1BIWV9QSFlTUl9MSU5LKi8gfAogICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIDB4ODAwMC8qR01JSV9QSFlfUEhZU1JfR0lHQSovOwogICAgICAg
ICAgICAgICAgICB1c2JfcmVwbHkoJnBoeXNyLCBzaXplb2YocGh5c3IpLCByZXFfbGVuZ3RoKTsK
ICAgICAgICAgICAgICAgIH0gYnJlYWs7CiAgICAgICAgICAgICAgICBjYXNlIDB4MWEvKkdNSUlf
TEVEX0FDVCovOiB7CiAgICAgICAgICAgICAgICAgIHByaW50ZigiICAgIEdNSUlfTEVEX0FDVFxu
Iik7CiAgICAgICAgICAgICAgICAgIGlmIChpc19kaXJfaW4pIHsKICAgICAgICAgICAgICAgICAg
ICB1bnNpZ25lZCBzaG9ydCBsZWRhY3QgPSAwOwogICAgICAgICAgICAgICAgICAgIHVzYl9yZXBs
eSgmbGVkYWN0LCBzaXplb2YobGVkYWN0KSwgcmVxX2xlbmd0aCk7CiAgICAgICAgICAgICAgICAg
IH0gZWxzZSB7CiAgICAgICAgICAgICAgICAgICAgdXNiX2FjayhyZXFfbGVuZ3RoKTsKICAgICAg
ICAgICAgICAgICAgfQogICAgICAgICAgICAgICAgfSBicmVhazsKICAgICAgICAgICAgICAgIGNh
c2UgMHgxYy8qR01JSV9MRURfTElOSyovOiB7CiAgICAgICAgICAgICAgICAgIHByaW50ZigiICAg
IEdNSUlfTEVEX0xJTktcbiIpOwogICAgICAgICAgICAgICAgICBpZiAoaXNfZGlyX2luKSB7CiAg
ICAgICAgICAgICAgICAgICAgdW5zaWduZWQgc2hvcnQgbGVkbGluayA9IDA7CiAgICAgICAgICAg
ICAgICAgICAgdXNiX3JlcGx5KCZsZWRsaW5rLCBzaXplb2YobGVkbGluayksIHJlcV9sZW5ndGgp
OwogICAgICAgICAgICAgICAgICB9IGVsc2UgewogICAgICAgICAgICAgICAgICAgIHVzYl9hY2so
cmVxX2xlbmd0aCk7CiAgICAgICAgICAgICAgICAgIH0KICAgICAgICAgICAgICAgIH0gYnJlYWs7
CiAgICAgICAgICAgICAgICBjYXNlIDB4MWUvKkdNSUlfUEhZUEFHRSovOiB7CiAgICAgICAgICAg
ICAgICAgIHByaW50ZigiICAgIEdNSUlfUEhZUEFHRVxuIik7CiAgICAgICAgICAgICAgICAgIHVz
Yl9hY2socmVxX2xlbmd0aCk7CiAgICAgICAgICAgICAgICB9IGJyZWFrOwogICAgICAgICAgICAg
ICAgY2FzZSAweDFmLypHTUlJX1BIWV9QQUdFX1NFTEVDVCovOiB7CiAgICAgICAgICAgICAgICAg
IHByaW50ZigiICAgIEdNSUlfUEhZX1BBR0VfU0VMRUNUXG4iKTsKICAgICAgICAgICAgICAgICAg
dXNiX2FjayhyZXFfbGVuZ3RoKTsKICAgICAgICAgICAgICAgIH0gYnJlYWs7CiAgICAgICAgICAg
ICAgICBkZWZhdWx0OgogICAgICAgICAgICAgICAgICBlcnJ4KDEsICIgICAgdW5rbm93biBBWF9B
Q0NFU1NfUEhZIGNvbW1hbmQgMHglMDJoaHgiLCBjb250cm9sX2V2LmN0cmwud0luZGV4KTsKICAg
ICAgICAgICAgICB9CiAgICAgICAgICAgIH0gYnJlYWs7CiAgICAgICAgICAgIGNhc2UgMHgwNC8q
QVhfQUNDRVNTX1BIWSovOiB7CiAgICAgICAgICAgICAgdW5zaWduZWQgZWVwcm9tX2lkeCA9ICh1
bnNpZ25lZCljb250cm9sX2V2LmN0cmwud1ZhbHVlOwogICAgICAgICAgICAgIHByaW50ZigiICBB
WF9BQ0NFU1NfRUVQUk9NIGF0IDB4JXhcbiIsIGVlcHJvbV9pZHgpOwogICAgICAgICAgICAgIGlm
IChpc19kaXJfaW4pIHsKICAgICAgICAgICAgICAgIHByaW50ZigiICAgIEVFUFJPTSByZWFkXG4i
KTsKICAgICAgICAgICAgICAgIHN3aXRjaCAoZWVwcm9tX2lkeCkgewogICAgICAgICAgICAgICAg
ICBjYXNlIDB4NDM6IHsvKiBhdXRvZGV0YWNoICovCiAgICAgICAgICAgICAgICAgICAgdW5zaWdu
ZWQgc2hvcnQgYXV0b2RldGFjaCA9IDB4ZmZmZjsKICAgICAgICAgICAgICAgICAgICB1c2JfcmVw
bHkoJmF1dG9kZXRhY2gsIHNpemVvZihhdXRvZGV0YWNoKSwgcmVxX2xlbmd0aCk7CiAgICAgICAg
ICAgICAgICAgIH0gYnJlYWs7CiAgICAgICAgICAgICAgICAgIGRlZmF1bHQ6CiAgICAgICAgICAg
ICAgICAgICAgZXJyeCgxLCAidW5oYW5kbGVkIEVFUFJPTSBvZmZzZXQiKTsKICAgICAgICAgICAg
ICAgIH0KICAgICAgICAgICAgICB9IGVsc2UgewogICAgICAgICAgICAgICAgcHJpbnRmKCIgICAg
aWdub3JpbmcgRUVQUk9NIHdyaXRlXG4iKTsKICAgICAgICAgICAgICAgIHVzYl9hY2socmVxX2xl
bmd0aCk7CiAgICAgICAgICAgICAgfQogICAgICAgICAgICB9IGJyZWFrOwogICAgICAgICAgICBj
YXNlIDB4ODE6IHsKICAgICAgICAgICAgICBwcmludGYoIiAgMHg4MSBUWCBGSUZPIGNoZWNrXG4i
KTsKICAgICAgICAgICAgICB1bnNpZ25lZCBpbnQgdHhfZmlmb19zdGF0ZSA9IDA7CiAgICAgICAg
ICAgICAgdXNiX3JlcGx5KCZ0eF9maWZvX3N0YXRlLCBzaXplb2YodHhfZmlmb19zdGF0ZSksIHJl
cV9sZW5ndGgpOwogICAgICAgICAgICB9IGJyZWFrOwojZW5kaWYKICAgICAgICAgICAgY2FzZSAw
eDEzLypBWF9DTURfUkVBRF9OT0RFX0lEKi86IHsKICAgICAgICAgICAgICB1bnNpZ25lZCBjaGFy
IG1hY19hZGRyW10gPSB7IDB4MDAsIDB4MTIsIDB4MzQsIDB4NTYsIDB4NzgsIDB4OTAgfTsKICAg
ICAgICAgICAgICB1c2JfcmVwbHkobWFjX2FkZHIsIHNpemVvZihtYWNfYWRkciksIHJlcV9sZW5n
dGgpOwogICAgICAgICAgICB9IGJyZWFrOwogICAgICAgICAgICBjYXNlIDB4MjEvKkFYX0NNRF9T
V19QSFlfU1RBVFVTKi86CiAgICAgICAgICAgIGNhc2UgMHgxYS8qQVhfQ01EX1JFQURfTUVESVVN
X1NUQVRVUyovOgogICAgICAgICAgICBjYXNlIDB4MGYvKkFYX0NNRF9SRUFEX1JYX0NUTCovOiB7
CiAgICAgICAgICAgICAgdXNiX3JlcGx5X3plcm8ocmVxX2xlbmd0aCk7CiAgICAgICAgICAgIH0g
YnJlYWs7CiAgICAgICAgICAgIGNhc2UgMHgxOS8qQVhfQ01EX1JFQURfUEhZX0lEKi86IHsKICAg
ICAgICAgICAgICBwcmludGYoIiAgICBDTURfUkVBRF9QSFlfSURcbiIpOwogICAgICAgICAgICAg
IHVuc2lnbmVkIHNob3J0IHBoeV9pZCA9IDE7CiAgICAgICAgICAgICAgdXNiX3JlcGx5KCZwaHlf
aWQsIHNpemVvZihwaHlfaWQpLCByZXFfbGVuZ3RoKTsKICAgICAgICAgICAgfSBicmVhazsKICAg
ICAgICAgICAgY2FzZSAweDA5LypBWF9DTURfU1RBVE1OR1NUU19SRUcqLzogewogICAgICAgICAg
ICAgIHByaW50ZigiICAgIENNRF9TVEFUTU5HU1RTX1JFR1xuIik7CiAgICAgICAgICAgICAgdW5z
aWduZWQgY2hhciB2YWwgPSAweDAxOyAvKiBBWF9IT1NUX0VOICovCiAgICAgICAgICAgICAgdXNi
X3JlcGx5KCZ2YWwsIHNpemVvZih2YWwpLCByZXFfbGVuZ3RoKTsKICAgICAgICAgICAgfSBicmVh
azsKICAgICAgICAgICAgY2FzZSAweDA3LypBWF9DTURfUkVBRF9NSUlfUkVHKi86IHsKICAgICAg
ICAgICAgICBwcmludGYoIiAgICBDTURfUkVBRF9NSUlfUkVHXG4iKTsKICAgICAgICAgICAgICAv
KgogICAgICAgICAgICAgICAgdW5zaWduZWQgY2hhciB2YWwgPSAweDAxOwogICAgICAgICAgICAg
ICAgdXNiX3JlcGx5KCZ2YWwsIHNpemVvZih2YWwpLCByZXFfbGVuZ3RoKTsKICAgICAgICAgICAg
ICAgICovCiAgICAgICAgICAgICAgc3dpdGNoIChjb250cm9sX2V2LmN0cmwud0luZGV4KSB7CiAg
ICAgICAgICAgICAgICBjYXNlIE1JSV9CTUNSOiB7IC8qIEJhc2ljIG1vZGUgY29udHJvbCByZWdp
c3RlciAqLwogICAgICAgICAgICAgICAgICAvKiBpZGsgd2hhdCBhbnkgb2YgdGhlc2UgZmxhZ3Mg
YWN0dWFsbHkgZG8gaW4gZGV0YWlsLi4uICovCiAgICAgICAgICAgICAgICAgIHByaW50ZigiICAg
IE1JSV9CTUNSIChiYXNpYyBtb2RlIGNvbnRyb2wgcmVnaXN0ZXIpXG4iKTsKICAgICAgICAgICAg
ICAgICAgdW5zaWduZWQgc2hvcnQgYm1jcl9zdGF0ZSA9IEJNQ1JfU1BFRUQxMDAgfCBCTUNSX0ZV
TExEUExYOwogICAgICAgICAgICAgICAgICB1c2JfcmVwbHkoJmJtY3Jfc3RhdGUsIHNpemVvZihi
bWNyX3N0YXRlKSwgcmVxX2xlbmd0aCk7CiAgICAgICAgICAgICAgICB9IGJyZWFrOwogICAgICAg
ICAgICAgICAgY2FzZSBNSUlfQk1TUjogeyAvKiBCYXNpYyBtb2RlIHN0YXR1cyByZWdpc3RlciAq
LwogICAgICAgICAgICAgICAgICBwcmludGYoIiAgICBNSUlfQk1TUiAoYmFzaWMgbW9kZSBzdGF0
dXMgcmVnaXN0ZXIpXG4iKTsKICAgICAgICAgICAgICAgICAgLyogc2F5IGxpbmsgaXMgaW5pdGlh
bGx5IGRvd24gKi8KICAgICAgICAgICAgICAgICAgdW5zaWduZWQgc2hvcnQgYm1zcl9zdGF0ZSA9
ICgoc3RhdGUgPiAwKSA/IEJNU1JfTFNUQVRVUyA6IDApIHwgQk1TUl8xMDBGVUxMOwogICAgICAg
ICAgICAgICAgICB1c2JfcmVwbHkoJmJtc3Jfc3RhdGUsIHNpemVvZihibXNyX3N0YXRlKSwgcmVx
X2xlbmd0aCk7CiAgICAgICAgICAgICAgICB9IGJyZWFrOwogICAgICAgICAgICAgICAgY2FzZSBN
SUlfQURWRVJUSVNFOiB7IC8qIEFkdmVydGlzZW1lbnQgY29udHJvbCByZWdpc3RlciAqLwogICAg
ICAgICAgICAgICAgICBwcmludGYoIiAgICBNSUlfQURWRVJUSVNFXG4iKTsKICAgICAgICAgICAg
ICAgICAgdW5zaWduZWQgc2hvcnQgYWR2X3N0YXRlID0gQURWRVJUSVNFXzEwMEZVTEw7CiAgICAg
ICAgICAgICAgICAgIHVzYl9yZXBseSgmYWR2X3N0YXRlLCBzaXplb2YoYWR2X3N0YXRlKSwgcmVx
X2xlbmd0aCk7CiAgICAgICAgICAgICAgICB9IGJyZWFrOwogICAgICAgICAgICAgICAgY2FzZSBN
SUlfTFBBOiB7IC8qIExpbmsgcGFydG5lciBhYmlsaXR5ICovCiAgICAgICAgICAgICAgICAgIHBy
aW50ZigiICAgIE1JSV9MUEEgKExpbmsgcGFydG5lciBhYmlsaXR5KVxuIik7CiAgICAgICAgICAg
ICAgICAgIHVuc2lnbmVkIHNob3J0IGxwYV9zdGF0ZSA9IExQQV8xMDBGVUxMOwogICAgICAgICAg
ICAgICAgICB1c2JfcmVwbHkoJmxwYV9zdGF0ZSwgc2l6ZW9mKGxwYV9zdGF0ZSksIHJlcV9sZW5n
dGgpOwogICAgICAgICAgICAgICAgfSBicmVhazsKICAgICAgICAgICAgICAgIGNhc2UgTUlJX1BI
WVNJRDE6CiAgICAgICAgICAgICAgICBjYXNlIE1JSV9QSFlTSUQyOiB7CiAgICAgICAgICAgICAg
ICAgIHByaW50ZigiICAgIE1JSV9QSFlTSURcbiIpOwogICAgICAgICAgICAgICAgICB1bnNpZ25l
ZCBzaG9ydCBwaHlzaWQgPSAxOwogICAgICAgICAgICAgICAgICB1c2JfcmVwbHkoJnBoeXNpZCwg
c2l6ZW9mKHBoeXNpZCksIHJlcV9sZW5ndGgpOwogICAgICAgICAgICAgICAgfSBicmVhazsKICAg
ICAgICAgICAgICAgIGRlZmF1bHQ6CiAgICAgICAgICAgICAgICAgIGVycngoMSwgIiAgICB1bmtu
b3duIFJFQURfTUlJX1JFRyBjb21tYW5kIDB4JTAyaGh4IiwgY29udHJvbF9ldi5jdHJsLndJbmRl
eCk7CiAgICAgICAgICAgICAgfQogICAgICAgICAgICB9IGJyZWFrOwojaWYgMAogICAgICAgICAg
ICBjYXNlIDB4MTAvKkFYX0NNRF9XUklURV9SWF9DVEwqLzogewogICAgICAgICAgICAgIHByaW50
ZigiICAgIENNRF9XUklURV9SWF9DVEwgPSAweCVoeFxuIiwgY29udHJvbF9ldi5jdHJsLndJbmRl
eCk7CiAgICAgICAgICAgICAgdXNiX2FjayhyZXFfbGVuZ3RoKTsKICAgICAgICAgICAgfSBicmVh
azsKICAgICAgICAgICAgY2FzZSAweDE2LypBWF9DTURfV1JJVEVfTVVMVElfRklMVEVSKi86IHsK
ICAgICAgICAgICAgICBwcmludGYoIiAgICBDTURfV1JJVEVfTVVMVElfRklMVEVSXG4iKTsKICAg
ICAgICAgICAgICB1c2JfYWNrKHJlcV9sZW5ndGgpOwogICAgICAgICAgICB9IGJyZWFrOwojZW5k
aWYKICAgICAgICAgICAgZGVmYXVsdDoKICAgICAgICAgICAgICBpZiAoaXNfZGlyX2luKSB7CiAg
ICAgICAgICAgICAgICBlcnJ4KDEsICJ1bmtub3duIHZlbmRvciBjdHJscmVxdWVzdCAweCUwMmho
eCIsIGNvbnRyb2xfZXYuY3RybC5iUmVxdWVzdCk7CiAgICAgICAgICAgICAgfSBlbHNlIHsKICAg
ICAgICAgICAgICAgIHByaW50ZigiICAgIGlnbm9yaW5nIHVua25vd24gdmVuZG9yIGN0cmxyZXF1
ZXN0IDB4JTAyaHhcbiIsIGNvbnRyb2xfZXYuY3RybC5iUmVxdWVzdCk7CiAgICAgICAgICAgICAg
ICB1c2JfYWNrKHJlcV9sZW5ndGgpOwogICAgICAgICAgICAgIH0KICAgICAgICAgIH0KICAgICAg
ICAgIGJyZWFrOwogICAgICAgIGRlZmF1bHQ6CiAgICAgICAgICBlcnJ4KDEsICJVU0JfVFlQRV8q
IHVua25vd24iKTsKICAgICAgfQogICAgfSBlbHNlIHsKICAgICAgcHJpbnRmKCJ1bmtub3duIGV2
ZW50LCB0eXBlIDB4JXhcbiIsICh1bnNpZ25lZCljb250cm9sX2V2LmlubmVyLnR5cGUpOwogICAg
fQogIH0KfQo=
--00000000000027ae1405df61e695--
