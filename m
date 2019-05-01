Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 412E610E7D
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 23:19:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726209AbfEAVTJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 17:19:09 -0400
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:53899 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726116AbfEAVTI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 17:19:08 -0400
Received: from localhost.localdomain ([83.160.161.190])
        by smtp-cloud7.xs4all.net with ESMTPSA
        id Lwd5hCHvaZVjxLwd7h3Uok; Wed, 01 May 2019 23:19:05 +0200
From:   Paul Bolle <pebolle@tiscali.nl>
To:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        gigaset307x-common@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] isdn: bas_gigaset: use usb_fill_int_urb() properly
Date:   Wed,  1 May 2019 23:19:03 +0200
Message-Id: <20190501211903.14806-1-pebolle@tiscali.nl>
X-Mailer: git-send-email 2.17.2
X-CMAE-Envelope: MS4wfOp5vPG9xELxzSh+dUzvBxQYzI2cQDZmE49vzSrlF8aB/d8MQv73euPb7NwpkqLRPCuN2y3q7AaFj98EZiFJVvl+SrNigkTRoTvllg5fw5EIFxwU+O56
 j3yCP7A7LTEJq8/LlQWbDdCDmUFq0Wvy9gy2iwuIVD+TvMvfmMP5RB0Pe2uZfaR/SHjqt0fWAzoKMtK5DoZa4Y++aBIMdOF7AHsYQpq+9LPtTnBayqRgdxDB
 vpLvZxXd6V8HK9zdaSUC4Bbo60+YFl1if+pL7ynypWNO9ff6JGBh5WCQL/FpAVnDEbs2oxchqt4zqY8h1XD0JNCumDMfjOux+pWzbFRzkOYOWmZ4aFA59Ygf
 Ng51pFRb4J3lmMREZejU17ZBtV1jKomXOibkPdbzIMlTMntUPCY=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The switch to make bas_gigaset use usb_fill_int_urb() - instead of
filling that urb "by hand" - missed the subtle ordering of the previous
code.

See, before the switch urb->dev was set to a member somewhere deep in a
complicated structure and then supplied to usb_rcvisocpipe() and
usb_sndisocpipe(). After that switch urb->dev wasn't set to anything
specific before being supplied to those two macros. This triggers a
nasty oops:

    BUG: unable to handle kernel NULL pointer dereference at 00000000
    #PF error: [normal kernel read fault]
    *pde = 00000000
    Oops: 0000 [#1] SMP
    CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.1.0-0.rc4.1.local0.fc28.i686 #1
    Hardware name: IBM 2525FAG/2525FAG, BIOS 74ET64WW (2.09 ) 12/14/2006
    EIP: gigaset_init_bchannel+0x89/0x320 [bas_gigaset]
    Code: 75 07 83 8b 84 00 00 00 40 8d 47 74 c7 07 01 00 00 00 89 45 f0 8b 44 b7 68 85 c0 0f 84 6a 02 00 00 8b 48 28 8b 93 88 00 00 00 <8b> 09 8d 54 12 03 c1 e2 0f c1 e1 08 09 ca 8b 8b 8c 00 00 00 80 ca
    EAX: f05ec200 EBX: ed404200 ECX: 00000000 EDX: 00000000
    ESI: 00000000 EDI: f065a000 EBP: f30c9f40 ESP: f30c9f20
    DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068 EFLAGS: 00010086
    CR0: 80050033 CR2: 00000000 CR3: 0ddc7000 CR4: 000006d0
    Call Trace:
     <SOFTIRQ>
     ? gigaset_isdn_connD+0xf6/0x140 [gigaset]
     gigaset_handle_event+0x173e/0x1b90 [gigaset]
     tasklet_action_common.isra.16+0x4e/0xf0
     tasklet_action+0x1e/0x20
     __do_softirq+0xb2/0x293
     ? __irqentry_text_end+0x3/0x3
     call_on_stack+0x45/0x50
     </SOFTIRQ>
     ? irq_exit+0xb5/0xc0
     ? do_IRQ+0x78/0xd0
     ? acpi_idle_enter_s2idle+0x50/0x50
     ? common_interrupt+0xd4/0xdc
     ? acpi_idle_enter_s2idle+0x50/0x50
     ? sched_cpu_activate+0x1b/0xf0
     ? acpi_fan_resume.cold.7+0x9/0x18
     ? cpuidle_enter_state+0x152/0x4c0
     ? cpuidle_enter+0x14/0x20
     ? call_cpuidle+0x21/0x40
     ? do_idle+0x1c8/0x200
     ? cpu_startup_entry+0x25/0x30
     ? rest_init+0x88/0x8a
     ? arch_call_rest_init+0xd/0x19
     ? start_kernel+0x42f/0x448
     ? i386_start_kernel+0xac/0xb0
     ? startup_32_smp+0x164/0x168
    Modules linked in: ppp_generic slhc capi bas_gigaset gigaset kernelcapi nf_conntrack_netbios_ns nf_conntrack_broadcast xt_CT ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 xt_conntrack ip_set nfnetlink ebtable_nat ebtable_broute bridge stp llc ip6table_nat ip6table_mangle ip6table_raw ip6table_security iptable_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 libcrc32c iptable_mangle iptable_raw iptable_security ebtable_filter ebtables ip6table_filter ip6_tables sunrpc ipw2200 iTCO_wdt gpio_ich snd_intel8x0 libipw iTCO_vendor_support snd_ac97_codec lib80211 ppdev ac97_bus snd_seq cfg80211 snd_seq_device pcspkr thinkpad_acpi lpc_ich snd_pcm i2c_i801 snd_timer ledtrig_audio snd soundcore rfkill parport_pc parport pcc_cpufreq acpi_cpufreq i915 i2c_algo_bit drm_kms_helper syscopyarea sysfillrect sdhci_pci sysimgblt cqhci fb_sys_fops drm sdhci mmc_core tg3 ata_generic serio_raw yenta_socket pata_acpi video
    CR2: 0000000000000000
    ---[ end trace 1fe07487b9200c73 ]---
    EIP: gigaset_init_bchannel+0x89/0x320 [bas_gigaset]
    Code: 75 07 83 8b 84 00 00 00 40 8d 47 74 c7 07 01 00 00 00 89 45 f0 8b 44 b7 68 85 c0 0f 84 6a 02 00 00 8b 48 28 8b 93 88 00 00 00 <8b> 09 8d 54 12 03 c1 e2 0f c1 e1 08 09 ca 8b 8b 8c 00 00 00 80 ca
    EAX: f05ec200 EBX: ed404200 ECX: 00000000 EDX: 00000000
    ESI: 00000000 EDI: f065a000 EBP: f30c9f40 ESP: cddcb3bc
    DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068 EFLAGS: 00010086
    CR0: 80050033 CR2: 00000000 CR3: 0ddc7000 CR4: 000006d0
    Kernel panic - not syncing: Fatal exception in interrupt
    Kernel Offset: 0xcc00000 from 0xc0400000 (relocation range: 0xc0000000-0xf6ffdfff)
    ---[ end Kernel panic - not syncing: Fatal exception in interrupt ]---

No-one noticed because this Oops is apparently only triggered by setting
up an ISDN data connection on a live ISDN line on a gigaset base (ie,
the PBX that the gigaset driver support). Very few people do that
running present day kernels.

Anyhow, a little code reorganization makes this problem go away, while
avoiding the subtle ordering that was used in the past. So let's do
that.

Fixes: 78c696c19578 ("isdn: gigaset: use usb_fill_int_urb()")
Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Arnd's ISDN cleanup hasn't yet hit net-next so this still uses
drivers/isdn. If people prefer to apply this after Arnd has exiled
gigaset into staging, I'll gladly respin. 

 drivers/isdn/gigaset/bas-gigaset.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/isdn/gigaset/bas-gigaset.c b/drivers/isdn/gigaset/bas-gigaset.c
index ecdeb89645d0..149b1aca52a2 100644
--- a/drivers/isdn/gigaset/bas-gigaset.c
+++ b/drivers/isdn/gigaset/bas-gigaset.c
@@ -958,6 +958,7 @@ static void write_iso_callback(struct urb *urb)
  */
 static int starturbs(struct bc_state *bcs)
 {
+	struct usb_device *udev = bcs->cs->hw.bas->udev;
 	struct bas_bc_state *ubc = bcs->hw.bas;
 	struct urb *urb;
 	int j, k;
@@ -975,8 +976,8 @@ static int starturbs(struct bc_state *bcs)
 			rc = -EFAULT;
 			goto error;
 		}
-		usb_fill_int_urb(urb, bcs->cs->hw.bas->udev,
-				 usb_rcvisocpipe(urb->dev, 3 + 2 * bcs->channel),
+		usb_fill_int_urb(urb, udev,
+				 usb_rcvisocpipe(udev, 3 + 2 * bcs->channel),
 				 ubc->isoinbuf + k * BAS_INBUFSIZE,
 				 BAS_INBUFSIZE, read_iso_callback, bcs,
 				 BAS_FRAMETIME);
@@ -1006,8 +1007,8 @@ static int starturbs(struct bc_state *bcs)
 			rc = -EFAULT;
 			goto error;
 		}
-		usb_fill_int_urb(urb, bcs->cs->hw.bas->udev,
-				 usb_sndisocpipe(urb->dev, 4 + 2 * bcs->channel),
+		usb_fill_int_urb(urb, udev,
+				 usb_sndisocpipe(udev, 4 + 2 * bcs->channel),
 				 ubc->isooutbuf->data,
 				 sizeof(ubc->isooutbuf->data),
 				 write_iso_callback, &ubc->isoouturbs[k],
-- 
2.17.2

