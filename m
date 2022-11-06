Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E98861E687
	for <lists+netdev@lfdr.de>; Sun,  6 Nov 2022 22:26:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230366AbiKFV0h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Nov 2022 16:26:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229973AbiKFV0d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Nov 2022 16:26:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9383A7648;
        Sun,  6 Nov 2022 13:26:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 21D3660DC7;
        Sun,  6 Nov 2022 21:26:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C35DC433C1;
        Sun,  6 Nov 2022 21:26:31 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@goodmis.org>)
        id 1ornAT-008Cga-2Z;
        Sun, 06 Nov 2022 16:27:01 -0500
Message-ID: <20221106212427.739928660@goodmis.org>
User-Agent: quilt/0.66
Date:   Sun, 06 Nov 2022 16:24:27 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Anna-Maria Gleixner <anna-maria@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Julia Lawall <Julia.Lawall@inria.fr>, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        linux-block@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        drbd-dev@lists.linbit.com, linux-bluetooth@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-input@vger.kernel.org, linux-leds@vger.kernel.org,
        linux-media@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-ext4@vger.kernel.org, linux-nilfs@vger.kernel.org,
        bridge@lists.linux-foundation.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, lvs-devel@vger.kernel.org,
        linux-afs@lists.infradead.org, linux-nfs@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net, alsa-devel@alsa-project.org
Subject: [PATCH v6a 0/5] timers: Use timer_shutdown*() before freeing timers
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

del_timer_sync() is often called before the object that owns the timer is
freed. But sometimes there's a race that enables the timer again before it is
freed and causes a use after free when that timer triggers. This patch set
adds a new "shutdown" timer state, which is set on the new timer_shutdown()
API. Once a timer is in this state, it can not be re-armed and if it is, it
will warn.

The first three patches change existing timer_shutdown() functions used
locally in ARM and some drivers to better namespace names.

The fourth patch implements the new API.

The fifth patch is now a treewide patch that uses a coccinelle script to
convert the trivial locations where a del_timer*() is called on a timer of an
object that is freed immediately afterward (or at least in the same function).

Changes since v5a: https://lore.kernel.org/all/20221106054535.709068702@goodmis.org/

 - Updated the script to make ptr and slab into expressions instead of
   using identifiers (Julia Lawall and Linus Torvalds)

Steven Rostedt (Google) (5):
      ARM: spear: Do not use timer namespace for timer_shutdown() function
      clocksource/drivers/arm_arch_timer: Do not use timer namespace for timer_shutdown() function
      clocksource/drivers/sp804: Do not use timer namespace for timer_shutdown() function
      timers: Add timer_shutdown_sync() and timer_shutdown() to be called before freeing timers
      treewide: Convert del_timer*() to timer_shutdown*()

----
 .../RCU/Design/Requirements/Requirements.rst       |  2 +-
 Documentation/core-api/local_ops.rst               |  2 +-
 Documentation/kernel-hacking/locking.rst           |  5 ++
 arch/arm/mach-spear/time.c                         |  8 +--
 arch/sh/drivers/push-switch.c                      |  2 +-
 block/blk-iocost.c                                 |  2 +-
 block/blk-iolatency.c                              |  2 +-
 block/kyber-iosched.c                              |  2 +-
 drivers/acpi/apei/ghes.c                           |  2 +-
 drivers/atm/idt77252.c                             |  6 +-
 drivers/block/drbd/drbd_main.c                     |  2 +-
 drivers/block/loop.c                               |  2 +-
 drivers/bluetooth/hci_bcsp.c                       |  2 +-
 drivers/bluetooth/hci_qca.c                        |  4 +-
 drivers/clocksource/arm_arch_timer.c               | 12 ++--
 drivers/clocksource/timer-sp804.c                  |  6 +-
 drivers/gpu/drm/i915/i915_sw_fence.c               |  2 +-
 drivers/hid/hid-wiimote-core.c                     |  2 +-
 drivers/input/keyboard/locomokbd.c                 |  2 +-
 drivers/input/keyboard/omap-keypad.c               |  2 +-
 drivers/input/mouse/alps.c                         |  2 +-
 drivers/isdn/mISDN/l1oip_core.c                    |  4 +-
 drivers/isdn/mISDN/timerdev.c                      |  4 +-
 drivers/leds/trigger/ledtrig-activity.c            |  2 +-
 drivers/leds/trigger/ledtrig-heartbeat.c           |  2 +-
 drivers/leds/trigger/ledtrig-pattern.c             |  2 +-
 drivers/leds/trigger/ledtrig-transient.c           |  2 +-
 drivers/media/pci/ivtv/ivtv-driver.c               |  2 +-
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c            | 16 +++---
 drivers/media/usb/s2255/s2255drv.c                 |  4 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |  6 +-
 drivers/net/ethernet/marvell/sky2.c                |  2 +-
 drivers/net/ethernet/sun/sunvnet.c                 |  2 +-
 drivers/net/usb/sierra_net.c                       |  2 +-
 .../wireless/broadcom/brcm80211/brcmfmac/btcoex.c  |  2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c   |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |  2 +-
 drivers/net/wireless/intersil/hostap/hostap_ap.c   |  2 +-
 drivers/net/wireless/marvell/mwifiex/main.c        |  2 +-
 drivers/net/wireless/microchip/wilc1000/hif.c      |  6 +-
 drivers/nfc/pn533/pn533.c                          |  2 +-
 drivers/nfc/pn533/uart.c                           |  2 +-
 drivers/pcmcia/bcm63xx_pcmcia.c                    |  2 +-
 drivers/pcmcia/electra_cf.c                        |  2 +-
 drivers/pcmcia/omap_cf.c                           |  2 +-
 drivers/pcmcia/pd6729.c                            |  4 +-
 drivers/pcmcia/yenta_socket.c                      |  4 +-
 drivers/scsi/qla2xxx/qla_edif.c                    |  4 +-
 drivers/staging/media/atomisp/i2c/atomisp-lm3554.c |  2 +-
 drivers/tty/n_gsm.c                                |  2 +-
 drivers/tty/sysrq.c                                |  2 +-
 drivers/usb/gadget/udc/m66592-udc.c                |  2 +-
 drivers/usb/serial/garmin_gps.c                    |  2 +-
 drivers/usb/serial/mos7840.c                       |  4 +-
 fs/ext4/super.c                                    |  2 +-
 fs/nilfs2/segment.c                                |  2 +-
 include/linux/timer.h                              | 62 +++++++++++++++++++--
 kernel/time/timer.c                                | 64 ++++++++++++----------
 net/802/garp.c                                     |  2 +-
 net/802/mrp.c                                      |  4 +-
 net/bridge/br_multicast.c                          |  8 +--
 net/bridge/br_multicast_eht.c                      |  4 +-
 net/core/gen_estimator.c                           |  2 +-
 net/ipv4/ipmr.c                                    |  2 +-
 net/ipv6/ip6mr.c                                   |  2 +-
 net/mac80211/mesh_pathtbl.c                        |  2 +-
 net/netfilter/ipset/ip_set_list_set.c              |  2 +-
 net/netfilter/ipvs/ip_vs_lblc.c                    |  2 +-
 net/netfilter/ipvs/ip_vs_lblcr.c                   |  2 +-
 net/netfilter/xt_IDLETIMER.c                       |  4 +-
 net/netfilter/xt_LED.c                             |  2 +-
 net/rxrpc/conn_object.c                            |  2 +-
 net/sched/cls_flow.c                               |  2 +-
 net/sunrpc/svc.c                                   |  2 +-
 net/tipc/discover.c                                |  2 +-
 net/tipc/monitor.c                                 |  2 +-
 sound/i2c/other/ak4117.c                           |  2 +-
 sound/synth/emux/emux.c                            |  2 +-
 78 files changed, 207 insertions(+), 148 deletions(-)
