Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5097265267F
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 19:45:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234078AbiLTSpj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 13:45:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233948AbiLTSpb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 13:45:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB9772B0;
        Tue, 20 Dec 2022 10:45:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3BA1DB8197A;
        Tue, 20 Dec 2022 18:45:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AF55C433D2;
        Tue, 20 Dec 2022 18:45:20 +0000 (UTC)
Date:   Tue, 20 Dec 2022 13:45:19 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Anna-Maria Gleixner <anna-maria@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Julia Lawall <Julia.Lawall@inria.fr>, linux-sh@vger.kernel.org,
        cgroups@vger.kernel.org, linux-block@vger.kernel.org,
        linux-acpi@vger.kernel.org,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        drbd-dev@lists.linbit.com, linux-bluetooth@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-input@vger.kernel.org, linux-leds@vger.kernel.org,
        linux-media@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, linux-scsi@vger.kernel.org,
        linux-staging@lists.linux.dev, linux-ext4@vger.kernel.org,
        linux-nilfs@vger.kernel.org, bridge@lists.linux-foundation.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        lvs-devel@vger.kernel.org, linux-nfs@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net, alsa-devel@alsa-project.org
Subject: [PATCH] treewide: Convert del_timer*() to timer_shutdown*()
Message-ID: <20221220134519.3dd1318b@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[
  Linus,

    I ran the script against your latest master branch:
    commit b6bb9676f2165d518b35ba3bea5f1fcfc0d969bf

    As the timer_shutdown*() code is now in your tree, I figured
    we can start doing the conversions. At least add the trivial ones
    now as Thomas suggested that this gets applied at the end of the
    merge window, to avoid conflicts with linux-next during the
    development cycle. I can wait to Friday to run it again, and
    resubmit.

    What is the best way to handle this?
]

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Due to several bugs caused by timers being re-armed after they are
shutdown and just before they are freed, a new state of timers was added
called "shutdown". After a timer is set to this state, then it can no
longer be re-armed.

The following script was run to find all the trivial locations where
del_timer() or del_timer_sync() is called in the same function that the
object holding the timer is freed. It also ignores any locations where the
timer->function is modified between the del_timer*() and the free(), as
that is not considered a "trivial" case.

This was created by using a coccinelle script and the following commands:

 $ cat timer.cocci
@@
expression ptr, slab;
identifier timer, rfield;
@@
(
-       del_timer(&ptr->timer);
+       timer_shutdown(&ptr->timer);
|
-       del_timer_sync(&ptr->timer);
+       timer_shutdown_sync(&ptr->timer);
)
  ... when strict
      when != ptr->timer
(
        kfree_rcu(ptr, rfield);
|
        kmem_cache_free(slab, ptr);
|
        kfree(ptr);
)

 $ spatch timer.cocci . > /tmp/t.patch
 $ patch -p1 < /tmp/t.patch

Link: https://lore.kernel.org/lkml/20221123201306.823305113@linutronix.de/

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 arch/sh/drivers/push-switch.c                    |  2 +-
 block/blk-iocost.c                               |  2 +-
 block/blk-iolatency.c                            |  2 +-
 block/kyber-iosched.c                            |  2 +-
 drivers/acpi/apei/ghes.c                         |  2 +-
 drivers/atm/idt77252.c                           |  6 +++---
 drivers/block/drbd/drbd_main.c                   |  2 +-
 drivers/block/loop.c                             |  2 +-
 drivers/bluetooth/hci_bcsp.c                     |  2 +-
 drivers/gpu/drm/i915/i915_sw_fence.c             |  2 +-
 drivers/hid/hid-wiimote-core.c                   |  2 +-
 drivers/input/keyboard/locomokbd.c               |  2 +-
 drivers/input/keyboard/omap-keypad.c             |  2 +-
 drivers/input/mouse/alps.c                       |  2 +-
 drivers/isdn/mISDN/l1oip_core.c                  |  4 ++--
 drivers/isdn/mISDN/timerdev.c                    |  4 ++--
 drivers/leds/trigger/ledtrig-activity.c          |  2 +-
 drivers/leds/trigger/ledtrig-heartbeat.c         |  2 +-
 drivers/leds/trigger/ledtrig-pattern.c           |  2 +-
 drivers/leds/trigger/ledtrig-transient.c         |  2 +-
 drivers/media/pci/ivtv/ivtv-driver.c             |  2 +-
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c          | 16 ++++++++--------
 drivers/media/usb/s2255/s2255drv.c               |  4 ++--
 drivers/net/ethernet/intel/i40e/i40e_main.c      |  6 +++---
 drivers/net/ethernet/marvell/sky2.c              |  2 +-
 drivers/net/ethernet/sun/sunvnet.c               |  2 +-
 drivers/net/usb/sierra_net.c                     |  2 +-
 .../broadcom/brcm80211/brcmfmac/btcoex.c         |  2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c     |  2 +-
 drivers/net/wireless/intersil/hostap/hostap_ap.c |  2 +-
 drivers/net/wireless/marvell/mwifiex/main.c      |  2 +-
 drivers/net/wireless/microchip/wilc1000/hif.c    |  6 +++---
 drivers/nfc/pn533/pn533.c                        |  2 +-
 drivers/nfc/pn533/uart.c                         |  2 +-
 drivers/pcmcia/bcm63xx_pcmcia.c                  |  2 +-
 drivers/pcmcia/electra_cf.c                      |  2 +-
 drivers/pcmcia/omap_cf.c                         |  2 +-
 drivers/pcmcia/pd6729.c                          |  4 ++--
 drivers/pcmcia/yenta_socket.c                    |  4 ++--
 drivers/scsi/qla2xxx/qla_edif.c                  |  4 ++--
 .../staging/media/atomisp/i2c/atomisp-lm3554.c   |  2 +-
 drivers/staging/wlan-ng/prism2usb.c              |  6 +++---
 drivers/tty/n_gsm.c                              |  2 +-
 drivers/tty/sysrq.c                              |  2 +-
 drivers/usb/gadget/udc/m66592-udc.c              |  2 +-
 drivers/usb/serial/garmin_gps.c                  |  2 +-
 drivers/usb/serial/mos7840.c                     |  4 ++--
 fs/ext4/super.c                                  |  2 +-
 fs/nilfs2/segment.c                              |  2 +-
 net/802/garp.c                                   |  2 +-
 net/802/mrp.c                                    |  4 ++--
 net/bridge/br_multicast.c                        |  8 ++++----
 net/bridge/br_multicast_eht.c                    |  4 ++--
 net/core/gen_estimator.c                         |  2 +-
 net/ipv4/ipmr.c                                  |  2 +-
 net/ipv6/ip6mr.c                                 |  2 +-
 net/mac80211/mesh_pathtbl.c                      |  2 +-
 net/netfilter/ipset/ip_set_list_set.c            |  2 +-
 net/netfilter/ipvs/ip_vs_lblc.c                  |  2 +-
 net/netfilter/ipvs/ip_vs_lblcr.c                 |  2 +-
 net/netfilter/xt_IDLETIMER.c                     |  4 ++--
 net/netfilter/xt_LED.c                           |  2 +-
 net/sched/cls_flow.c                             |  2 +-
 net/sunrpc/svc.c                                 |  2 +-
 net/tipc/discover.c                              |  2 +-
 net/tipc/monitor.c                               |  2 +-
 sound/i2c/other/ak4117.c                         |  2 +-
 sound/synth/emux/emux.c                          |  2 +-
 69 files changed, 97 insertions(+), 97 deletions(-)

diff --git a/arch/sh/drivers/push-switch.c b/arch/sh/drivers/push-switch.c
index 2813140fd92b..c95f48ff3f6f 100644
--- a/arch/sh/drivers/push-switch.c
+++ b/arch/sh/drivers/push-switch.c
@@ -102,7 +102,7 @@ static int switch_drv_remove(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, NULL);
 	flush_work(&psw->work);
-	del_timer_sync(&psw->debounce);
+	timer_shutdown_sync(&psw->debounce);
 	free_irq(irq, pdev);
 
 	kfree(psw);
diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index d1bdc12deaa7..aeea49870c0e 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -2818,7 +2818,7 @@ static void ioc_rqos_exit(struct rq_qos *rqos)
 	ioc->running = IOC_STOP;
 	spin_unlock_irq(&ioc->lock);
 
-	del_timer_sync(&ioc->timer);
+	timer_shutdown_sync(&ioc->timer);
 	free_percpu(ioc->pcpu_stat);
 	kfree(ioc);
 }
diff --git a/block/blk-iolatency.c b/block/blk-iolatency.c
index 778a0057193e..ecdc10741836 100644
--- a/block/blk-iolatency.c
+++ b/block/blk-iolatency.c
@@ -644,7 +644,7 @@ static void blkcg_iolatency_exit(struct rq_qos *rqos)
 {
 	struct blk_iolatency *blkiolat = BLKIOLATENCY(rqos);
 
-	del_timer_sync(&blkiolat->timer);
+	timer_shutdown_sync(&blkiolat->timer);
 	flush_work(&blkiolat->enable_work);
 	blkcg_deactivate_policy(rqos->q, &blkcg_policy_iolatency);
 	kfree(blkiolat);
diff --git a/block/kyber-iosched.c b/block/kyber-iosched.c
index b05357bced99..2146969237bf 100644
--- a/block/kyber-iosched.c
+++ b/block/kyber-iosched.c
@@ -434,7 +434,7 @@ static void kyber_exit_sched(struct elevator_queue *e)
 	struct kyber_queue_data *kqd = e->elevator_data;
 	int i;
 
-	del_timer_sync(&kqd->timer);
+	timer_shutdown_sync(&kqd->timer);
 	blk_stat_disable_accounting(kqd->q);
 
 	for (i = 0; i < KYBER_NUM_DOMAINS; i++)
diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index 066dc1f5c235..34ad071a64e9 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -1431,7 +1431,7 @@ static int ghes_remove(struct platform_device *ghes_dev)
 	ghes->flags |= GHES_EXITING;
 	switch (generic->notify.type) {
 	case ACPI_HEST_NOTIFY_POLLED:
-		del_timer_sync(&ghes->timer);
+		timer_shutdown_sync(&ghes->timer);
 		break;
 	case ACPI_HEST_NOTIFY_EXTERNAL:
 		free_irq(ghes->irq, ghes);
diff --git a/drivers/atm/idt77252.c b/drivers/atm/idt77252.c
index 681cb3786794..eec0cc2144e0 100644
--- a/drivers/atm/idt77252.c
+++ b/drivers/atm/idt77252.c
@@ -2213,7 +2213,7 @@ idt77252_init_ubr(struct idt77252_dev *card, struct vc_map *vc,
 	}
 	spin_unlock_irqrestore(&vc->lock, flags);
 	if (est) {
-		del_timer_sync(&est->timer);
+		timer_shutdown_sync(&est->timer);
 		kfree(est);
 	}
 
@@ -2530,7 +2530,7 @@ idt77252_close(struct atm_vcc *vcc)
 		vc->tx_vcc = NULL;
 
 		if (vc->estimator) {
-			del_timer(&vc->estimator->timer);
+			timer_shutdown(&vc->estimator->timer);
 			kfree(vc->estimator);
 			vc->estimator = NULL;
 		}
@@ -3752,7 +3752,7 @@ static void __exit idt77252_exit(void)
 		card = idt77252_chain;
 		dev = card->atmdev;
 		idt77252_chain = card->next;
-		del_timer_sync(&card->tst_timer);
+		timer_shutdown_sync(&card->tst_timer);
 
 		if (dev->phy->stop)
 			dev->phy->stop(dev);
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 2f16e1bfb6e7..e43dfb9eb6ad 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2184,7 +2184,7 @@ void drbd_destroy_device(struct kref *kref)
 	struct drbd_resource *resource = device->resource;
 	struct drbd_peer_device *peer_device, *tmp_peer_device;
 
-	del_timer_sync(&device->request_timer);
+	timer_shutdown_sync(&device->request_timer);
 
 	/* paranoia asserts */
 	D_ASSERT(device, device->open_cnt == 0);
diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 1f8f3b87bdfa..4b366b658eea 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1755,7 +1755,7 @@ static void lo_free_disk(struct gendisk *disk)
 	if (lo->workqueue)
 		destroy_workqueue(lo->workqueue);
 	loop_free_idle_workers(lo, true);
-	del_timer_sync(&lo->timer);
+	timer_shutdown_sync(&lo->timer);
 	mutex_destroy(&lo->lo_mutex);
 	kfree(lo);
 }
diff --git a/drivers/bluetooth/hci_bcsp.c b/drivers/bluetooth/hci_bcsp.c
index 8055f63603f4..2a5a27d713f8 100644
--- a/drivers/bluetooth/hci_bcsp.c
+++ b/drivers/bluetooth/hci_bcsp.c
@@ -737,7 +737,7 @@ static int bcsp_close(struct hci_uart *hu)
 {
 	struct bcsp_struct *bcsp = hu->priv;
 
-	del_timer_sync(&bcsp->tbcsp);
+	timer_shutdown_sync(&bcsp->tbcsp);
 
 	hu->priv = NULL;
 
diff --git a/drivers/gpu/drm/i915/i915_sw_fence.c b/drivers/gpu/drm/i915/i915_sw_fence.c
index cc2a8821d22a..8a9aad523eec 100644
--- a/drivers/gpu/drm/i915/i915_sw_fence.c
+++ b/drivers/gpu/drm/i915/i915_sw_fence.c
@@ -465,7 +465,7 @@ static void irq_i915_sw_fence_work(struct irq_work *wrk)
 	struct i915_sw_dma_fence_cb_timer *cb =
 		container_of(wrk, typeof(*cb), work);
 
-	del_timer_sync(&cb->timer);
+	timer_shutdown_sync(&cb->timer);
 	dma_fence_put(cb->dma);
 
 	kfree_rcu(cb, rcu);
diff --git a/drivers/hid/hid-wiimote-core.c b/drivers/hid/hid-wiimote-core.c
index 09db8111dc26..26167cfb696f 100644
--- a/drivers/hid/hid-wiimote-core.c
+++ b/drivers/hid/hid-wiimote-core.c
@@ -1771,7 +1771,7 @@ static void wiimote_destroy(struct wiimote_data *wdata)
 	spin_unlock_irqrestore(&wdata->state.lock, flags);
 
 	cancel_work_sync(&wdata->init_worker);
-	del_timer_sync(&wdata->timer);
+	timer_shutdown_sync(&wdata->timer);
 
 	device_remove_file(&wdata->hdev->dev, &dev_attr_devtype);
 	device_remove_file(&wdata->hdev->dev, &dev_attr_extension);
diff --git a/drivers/input/keyboard/locomokbd.c b/drivers/input/keyboard/locomokbd.c
index dae053596572..f866c03b9d0e 100644
--- a/drivers/input/keyboard/locomokbd.c
+++ b/drivers/input/keyboard/locomokbd.c
@@ -310,7 +310,7 @@ static void locomokbd_remove(struct locomo_dev *dev)
 
 	free_irq(dev->irq[0], locomokbd);
 
-	del_timer_sync(&locomokbd->timer);
+	timer_shutdown_sync(&locomokbd->timer);
 
 	input_unregister_device(locomokbd->input);
 	locomo_set_drvdata(dev, NULL);
diff --git a/drivers/input/keyboard/omap-keypad.c b/drivers/input/keyboard/omap-keypad.c
index 57447d6c9007..24440b498645 100644
--- a/drivers/input/keyboard/omap-keypad.c
+++ b/drivers/input/keyboard/omap-keypad.c
@@ -296,7 +296,7 @@ static int omap_kp_remove(struct platform_device *pdev)
 	omap_writew(1, OMAP1_MPUIO_BASE + OMAP_MPUIO_KBD_MASKIT);
 	free_irq(omap_kp->irq, omap_kp);
 
-	del_timer_sync(&omap_kp->timer);
+	timer_shutdown_sync(&omap_kp->timer);
 	tasklet_kill(&kp_tasklet);
 
 	/* unregister everything */
diff --git a/drivers/input/mouse/alps.c b/drivers/input/mouse/alps.c
index 4a6b33bbe7ea..989228b5a0a4 100644
--- a/drivers/input/mouse/alps.c
+++ b/drivers/input/mouse/alps.c
@@ -2970,7 +2970,7 @@ static void alps_disconnect(struct psmouse *psmouse)
 	struct alps_data *priv = psmouse->private;
 
 	psmouse_reset(psmouse);
-	del_timer_sync(&priv->timer);
+	timer_shutdown_sync(&priv->timer);
 	if (priv->dev2)
 		input_unregister_device(priv->dev2);
 	if (!IS_ERR_OR_NULL(priv->dev3))
diff --git a/drivers/isdn/mISDN/l1oip_core.c b/drivers/isdn/mISDN/l1oip_core.c
index c24771336f61..f010b35a0531 100644
--- a/drivers/isdn/mISDN/l1oip_core.c
+++ b/drivers/isdn/mISDN/l1oip_core.c
@@ -1236,8 +1236,8 @@ release_card(struct l1oip *hc)
 
 	hc->shutdown = true;
 
-	del_timer_sync(&hc->keep_tl);
-	del_timer_sync(&hc->timeout_tl);
+	timer_shutdown_sync(&hc->keep_tl);
+	timer_shutdown_sync(&hc->timeout_tl);
 
 	cancel_work_sync(&hc->workq);
 
diff --git a/drivers/isdn/mISDN/timerdev.c b/drivers/isdn/mISDN/timerdev.c
index abdf36ac3bee..83d6b484d3c6 100644
--- a/drivers/isdn/mISDN/timerdev.c
+++ b/drivers/isdn/mISDN/timerdev.c
@@ -74,7 +74,7 @@ mISDN_close(struct inode *ino, struct file *filep)
 	while (!list_empty(list)) {
 		timer = list_first_entry(list, struct mISDNtimer, list);
 		spin_unlock_irq(&dev->lock);
-		del_timer_sync(&timer->tl);
+		timer_shutdown_sync(&timer->tl);
 		spin_lock_irq(&dev->lock);
 		/* it might have been moved to ->expired */
 		list_del(&timer->list);
@@ -204,7 +204,7 @@ misdn_del_timer(struct mISDNtimerdev *dev, int id)
 			list_del_init(&timer->list);
 			timer->id = -1;
 			spin_unlock_irq(&dev->lock);
-			del_timer_sync(&timer->tl);
+			timer_shutdown_sync(&timer->tl);
 			kfree(timer);
 			return id;
 		}
diff --git a/drivers/leds/trigger/ledtrig-activity.c b/drivers/leds/trigger/ledtrig-activity.c
index 30bc9df03636..33cbf8413658 100644
--- a/drivers/leds/trigger/ledtrig-activity.c
+++ b/drivers/leds/trigger/ledtrig-activity.c
@@ -208,7 +208,7 @@ static void activity_deactivate(struct led_classdev *led_cdev)
 {
 	struct activity_data *activity_data = led_get_trigger_data(led_cdev);
 
-	del_timer_sync(&activity_data->timer);
+	timer_shutdown_sync(&activity_data->timer);
 	kfree(activity_data);
 	clear_bit(LED_BLINK_SW, &led_cdev->work_flags);
 }
diff --git a/drivers/leds/trigger/ledtrig-heartbeat.c b/drivers/leds/trigger/ledtrig-heartbeat.c
index 7fe0a05574d2..393b3ae832f4 100644
--- a/drivers/leds/trigger/ledtrig-heartbeat.c
+++ b/drivers/leds/trigger/ledtrig-heartbeat.c
@@ -151,7 +151,7 @@ static void heartbeat_trig_deactivate(struct led_classdev *led_cdev)
 	struct heartbeat_trig_data *heartbeat_data =
 		led_get_trigger_data(led_cdev);
 
-	del_timer_sync(&heartbeat_data->timer);
+	timer_shutdown_sync(&heartbeat_data->timer);
 	kfree(heartbeat_data);
 	clear_bit(LED_BLINK_SW, &led_cdev->work_flags);
 }
diff --git a/drivers/leds/trigger/ledtrig-pattern.c b/drivers/leds/trigger/ledtrig-pattern.c
index 885ca63f383f..fadd87dbe993 100644
--- a/drivers/leds/trigger/ledtrig-pattern.c
+++ b/drivers/leds/trigger/ledtrig-pattern.c
@@ -430,7 +430,7 @@ static void pattern_trig_deactivate(struct led_classdev *led_cdev)
 	if (led_cdev->pattern_clear)
 		led_cdev->pattern_clear(led_cdev);
 
-	del_timer_sync(&data->timer);
+	timer_shutdown_sync(&data->timer);
 
 	led_set_brightness(led_cdev, LED_OFF);
 	kfree(data);
diff --git a/drivers/leds/trigger/ledtrig-transient.c b/drivers/leds/trigger/ledtrig-transient.c
index 80635183fac8..f111fa7635e5 100644
--- a/drivers/leds/trigger/ledtrig-transient.c
+++ b/drivers/leds/trigger/ledtrig-transient.c
@@ -180,7 +180,7 @@ static void transient_trig_deactivate(struct led_classdev *led_cdev)
 {
 	struct transient_trig_data *transient_data = led_get_trigger_data(led_cdev);
 
-	del_timer_sync(&transient_data->timer);
+	timer_shutdown_sync(&transient_data->timer);
 	led_set_brightness_nosleep(led_cdev, transient_data->restore_state);
 	kfree(transient_data);
 }
diff --git a/drivers/media/pci/ivtv/ivtv-driver.c b/drivers/media/pci/ivtv/ivtv-driver.c
index f5846c22c799..ba503d820e48 100644
--- a/drivers/media/pci/ivtv/ivtv-driver.c
+++ b/drivers/media/pci/ivtv/ivtv-driver.c
@@ -1425,7 +1425,7 @@ static void ivtv_remove(struct pci_dev *pdev)
 
 	/* Interrupts */
 	ivtv_set_irq_mask(itv, 0xffffffff);
-	del_timer_sync(&itv->dma_timer);
+	timer_shutdown_sync(&itv->dma_timer);
 
 	/* Kill irq worker */
 	kthread_flush_worker(&itv->irq_worker);
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-hdw.c b/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
index 62ff1fa1c753..75c89b07e86a 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
@@ -2605,10 +2605,10 @@ struct pvr2_hdw *pvr2_hdw_create(struct usb_interface *intf,
 	return hdw;
  fail:
 	if (hdw) {
-		del_timer_sync(&hdw->quiescent_timer);
-		del_timer_sync(&hdw->decoder_stabilization_timer);
-		del_timer_sync(&hdw->encoder_run_timer);
-		del_timer_sync(&hdw->encoder_wait_timer);
+		timer_shutdown_sync(&hdw->quiescent_timer);
+		timer_shutdown_sync(&hdw->decoder_stabilization_timer);
+		timer_shutdown_sync(&hdw->encoder_run_timer);
+		timer_shutdown_sync(&hdw->encoder_wait_timer);
 		flush_work(&hdw->workpoll);
 		v4l2_device_unregister(&hdw->v4l2_dev);
 		usb_free_urb(hdw->ctl_read_urb);
@@ -2668,10 +2668,10 @@ void pvr2_hdw_destroy(struct pvr2_hdw *hdw)
 	if (!hdw) return;
 	pvr2_trace(PVR2_TRACE_INIT,"pvr2_hdw_destroy: hdw=%p",hdw);
 	flush_work(&hdw->workpoll);
-	del_timer_sync(&hdw->quiescent_timer);
-	del_timer_sync(&hdw->decoder_stabilization_timer);
-	del_timer_sync(&hdw->encoder_run_timer);
-	del_timer_sync(&hdw->encoder_wait_timer);
+	timer_shutdown_sync(&hdw->quiescent_timer);
+	timer_shutdown_sync(&hdw->decoder_stabilization_timer);
+	timer_shutdown_sync(&hdw->encoder_run_timer);
+	timer_shutdown_sync(&hdw->encoder_wait_timer);
 	if (hdw->fw_buffer) {
 		kfree(hdw->fw_buffer);
 		hdw->fw_buffer = NULL;
diff --git a/drivers/media/usb/s2255/s2255drv.c b/drivers/media/usb/s2255/s2255drv.c
index acf18e2251a5..3c2627712fe9 100644
--- a/drivers/media/usb/s2255/s2255drv.c
+++ b/drivers/media/usb/s2255/s2255drv.c
@@ -1487,7 +1487,7 @@ static void s2255_destroy(struct s2255_dev *dev)
 	/* board shutdown stops the read pipe if it is running */
 	s2255_board_shutdown(dev);
 	/* make sure firmware still not trying to load */
-	del_timer_sync(&dev->timer);  /* only started in .probe and .open */
+	timer_shutdown_sync(&dev->timer);  /* only started in .probe and .open */
 	if (dev->fw_data->fw_urb) {
 		usb_kill_urb(dev->fw_data->fw_urb);
 		usb_free_urb(dev->fw_data->fw_urb);
@@ -2322,7 +2322,7 @@ static int s2255_probe(struct usb_interface *interface,
 errorFWDATA2:
 	usb_free_urb(dev->fw_data->fw_urb);
 errorFWURB:
-	del_timer_sync(&dev->timer);
+	timer_shutdown_sync(&dev->timer);
 errorEP:
 	usb_put_dev(dev->udev);
 errorUDEV:
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 94feea3b2599..53d0083e35da 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -15586,7 +15586,7 @@ static int i40e_init_recovery_mode(struct i40e_pf *pf, struct i40e_hw *hw)
 
 err_switch_setup:
 	i40e_reset_interrupt_capability(pf);
-	del_timer_sync(&pf->service_timer);
+	timer_shutdown_sync(&pf->service_timer);
 	i40e_shutdown_adminq(hw);
 	iounmap(hw->hw_addr);
 	pci_disable_pcie_error_reporting(pf->pdev);
@@ -16205,7 +16205,7 @@ static int i40e_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	kfree(pf->vsi);
 err_switch_setup:
 	i40e_reset_interrupt_capability(pf);
-	del_timer_sync(&pf->service_timer);
+	timer_shutdown_sync(&pf->service_timer);
 err_mac_addr:
 err_configure_lan_hmc:
 	(void)i40e_shutdown_lan_hmc(hw);
@@ -16267,7 +16267,7 @@ static void i40e_remove(struct pci_dev *pdev)
 	set_bit(__I40E_SUSPENDED, pf->state);
 	set_bit(__I40E_DOWN, pf->state);
 	if (pf->service_timer.function)
-		del_timer_sync(&pf->service_timer);
+		timer_shutdown_sync(&pf->service_timer);
 	if (pf->service_task.func)
 		cancel_work_sync(&pf->service_task);
 
diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethernet/marvell/sky2.c
index ff97b140886a..7c487f9b36ec 100644
--- a/drivers/net/ethernet/marvell/sky2.c
+++ b/drivers/net/ethernet/marvell/sky2.c
@@ -5013,7 +5013,7 @@ static void sky2_remove(struct pci_dev *pdev)
 	if (!hw)
 		return;
 
-	del_timer_sync(&hw->watchdog_timer);
+	timer_shutdown_sync(&hw->watchdog_timer);
 	cancel_work_sync(&hw->restart_work);
 
 	for (i = hw->ports-1; i >= 0; --i)
diff --git a/drivers/net/ethernet/sun/sunvnet.c b/drivers/net/ethernet/sun/sunvnet.c
index acda6cbd0238..fe86fbd58586 100644
--- a/drivers/net/ethernet/sun/sunvnet.c
+++ b/drivers/net/ethernet/sun/sunvnet.c
@@ -524,7 +524,7 @@ static void vnet_port_remove(struct vio_dev *vdev)
 		hlist_del_rcu(&port->hash);
 
 		synchronize_rcu();
-		del_timer_sync(&port->clean_timer);
+		timer_shutdown_sync(&port->clean_timer);
 		sunvnet_port_rm_txq_common(port);
 		netif_napi_del(&port->napi);
 		sunvnet_port_free_tx_bufs_common(port);
diff --git a/drivers/net/usb/sierra_net.c b/drivers/net/usb/sierra_net.c
index b3ae949e6f1c..673d3aa83792 100644
--- a/drivers/net/usb/sierra_net.c
+++ b/drivers/net/usb/sierra_net.c
@@ -759,7 +759,7 @@ static void sierra_net_unbind(struct usbnet *dev, struct usb_interface *intf)
 	dev_dbg(&dev->udev->dev, "%s", __func__);
 
 	/* kill the timer and work */
-	del_timer_sync(&priv->sync_timer);
+	timer_shutdown_sync(&priv->sync_timer);
 	cancel_work_sync(&priv->sierra_net_kevent);
 
 	/* tell modem we are going away */
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/btcoex.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/btcoex.c
index f9f18ff451ea..7ea2631b8069 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/btcoex.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/btcoex.c
@@ -394,7 +394,7 @@ void brcmf_btcoex_detach(struct brcmf_cfg80211_info *cfg)
 
 	if (cfg->btcoex->timer_on) {
 		cfg->btcoex->timer_on = false;
-		del_timer_sync(&cfg->btcoex->timer);
+		timer_shutdown_sync(&cfg->btcoex->timer);
 	}
 
 	cancel_work_sync(&cfg->btcoex->work);
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c b/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
index 6d6c12999645..48e7376a5fea 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
@@ -371,7 +371,7 @@ void iwl_dbg_tlv_del_timers(struct iwl_trans *trans)
 	struct iwl_dbg_tlv_timer_node *node, *tmp;
 
 	list_for_each_entry_safe(node, tmp, timer_list, list) {
-		del_timer_sync(&node->timer);
+		timer_shutdown_sync(&node->timer);
 		list_del(&node->list);
 		kfree(node);
 	}
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 6c9c5d6e7783..69634fb82a9b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -2835,7 +2835,7 @@ int iwl_mvm_sta_rx_agg(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 
 		/* synchronize all rx queues so we can safely delete */
 		iwl_mvm_free_reorder(mvm, baid_data);
-		del_timer_sync(&baid_data->session_timer);
+		timer_shutdown_sync(&baid_data->session_timer);
 		RCU_INIT_POINTER(mvm->baid_map[baid], NULL);
 		kfree_rcu(baid_data, rcu_head);
 		IWL_DEBUG_HT(mvm, "BAID %d is free\n", baid);
diff --git a/drivers/net/wireless/intersil/hostap/hostap_ap.c b/drivers/net/wireless/intersil/hostap/hostap_ap.c
index 462ccc7d7d1a..9b546a71e7a2 100644
--- a/drivers/net/wireless/intersil/hostap/hostap_ap.c
+++ b/drivers/net/wireless/intersil/hostap/hostap_ap.c
@@ -135,7 +135,7 @@ static void ap_free_sta(struct ap_data *ap, struct sta_info *sta)
 
 	if (!sta->ap)
 		kfree(sta->u.sta.challenge);
-	del_timer_sync(&sta->timer);
+	timer_shutdown_sync(&sta->timer);
 #endif /* PRISM2_NO_KERNEL_IEEE80211_MGMT */
 
 	kfree(sta);
diff --git a/drivers/net/wireless/marvell/mwifiex/main.c b/drivers/net/wireless/marvell/mwifiex/main.c
index da2e6557e684..ea22a08e6c08 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.c
+++ b/drivers/net/wireless/marvell/mwifiex/main.c
@@ -123,7 +123,7 @@ static int mwifiex_unregister(struct mwifiex_adapter *adapter)
 	if (adapter->if_ops.cleanup_if)
 		adapter->if_ops.cleanup_if(adapter);
 
-	del_timer_sync(&adapter->cmd_timer);
+	timer_shutdown_sync(&adapter->cmd_timer);
 
 	/* Free private structures */
 	for (i = 0; i < adapter->priv_num; i++) {
diff --git a/drivers/net/wireless/microchip/wilc1000/hif.c b/drivers/net/wireless/microchip/wilc1000/hif.c
index 67df8221b5ae..5adc69d5bcae 100644
--- a/drivers/net/wireless/microchip/wilc1000/hif.c
+++ b/drivers/net/wireless/microchip/wilc1000/hif.c
@@ -1531,10 +1531,10 @@ int wilc_deinit(struct wilc_vif *vif)
 
 	mutex_lock(&vif->wilc->deinit_lock);
 
-	del_timer_sync(&hif_drv->scan_timer);
-	del_timer_sync(&hif_drv->connect_timer);
+	timer_shutdown_sync(&hif_drv->scan_timer);
+	timer_shutdown_sync(&hif_drv->connect_timer);
 	del_timer_sync(&vif->periodic_rssi);
-	del_timer_sync(&hif_drv->remain_on_ch_timer);
+	timer_shutdown_sync(&hif_drv->remain_on_ch_timer);
 
 	if (hif_drv->usr_scan_req.scan_result) {
 		hif_drv->usr_scan_req.scan_result(SCAN_EVENT_ABORTED, NULL,
diff --git a/drivers/nfc/pn533/pn533.c b/drivers/nfc/pn533/pn533.c
index d9f6367b9993..0a1d0b4e3bb8 100644
--- a/drivers/nfc/pn533/pn533.c
+++ b/drivers/nfc/pn533/pn533.c
@@ -2788,7 +2788,7 @@ void pn53x_common_clean(struct pn533 *priv)
 	struct pn533_cmd *cmd, *n;
 
 	/* delete the timer before cleanup the worker */
-	del_timer_sync(&priv->listen_timer);
+	timer_shutdown_sync(&priv->listen_timer);
 
 	flush_delayed_work(&priv->poll_work);
 	destroy_workqueue(priv->wq);
diff --git a/drivers/nfc/pn533/uart.c b/drivers/nfc/pn533/uart.c
index 07596bf5f7d6..a556acdb947b 100644
--- a/drivers/nfc/pn533/uart.c
+++ b/drivers/nfc/pn533/uart.c
@@ -310,7 +310,7 @@ static void pn532_uart_remove(struct serdev_device *serdev)
 	pn53x_unregister_nfc(pn532->priv);
 	serdev_device_close(serdev);
 	pn53x_common_clean(pn532->priv);
-	del_timer_sync(&pn532->cmd_timeout);
+	timer_shutdown_sync(&pn532->cmd_timeout);
 	kfree_skb(pn532->recv_skb);
 	kfree(pn532);
 }
diff --git a/drivers/pcmcia/bcm63xx_pcmcia.c b/drivers/pcmcia/bcm63xx_pcmcia.c
index bb06311d0b5f..dd3c26099048 100644
--- a/drivers/pcmcia/bcm63xx_pcmcia.c
+++ b/drivers/pcmcia/bcm63xx_pcmcia.c
@@ -443,7 +443,7 @@ static int bcm63xx_drv_pcmcia_remove(struct platform_device *pdev)
 	struct resource *res;
 
 	skt = platform_get_drvdata(pdev);
-	del_timer_sync(&skt->timer);
+	timer_shutdown_sync(&skt->timer);
 	iounmap(skt->base);
 	iounmap(skt->io_base);
 	res = skt->reg_res;
diff --git a/drivers/pcmcia/electra_cf.c b/drivers/pcmcia/electra_cf.c
index 40a5cffe24a4..efc27bc15152 100644
--- a/drivers/pcmcia/electra_cf.c
+++ b/drivers/pcmcia/electra_cf.c
@@ -317,7 +317,7 @@ static int electra_cf_remove(struct platform_device *ofdev)
 	cf->active = 0;
 	pcmcia_unregister_socket(&cf->socket);
 	free_irq(cf->irq, cf);
-	del_timer_sync(&cf->timer);
+	timer_shutdown_sync(&cf->timer);
 
 	iounmap(cf->io_virt);
 	iounmap(cf->mem_base);
diff --git a/drivers/pcmcia/omap_cf.c b/drivers/pcmcia/omap_cf.c
index d3f827d4224a..e613818dc0bc 100644
--- a/drivers/pcmcia/omap_cf.c
+++ b/drivers/pcmcia/omap_cf.c
@@ -296,7 +296,7 @@ static int __exit omap_cf_remove(struct platform_device *pdev)
 
 	cf->active = 0;
 	pcmcia_unregister_socket(&cf->socket);
-	del_timer_sync(&cf->timer);
+	timer_shutdown_sync(&cf->timer);
 	release_mem_region(cf->phys_cf, SZ_8K);
 	free_irq(cf->irq, cf);
 	kfree(cf);
diff --git a/drivers/pcmcia/pd6729.c b/drivers/pcmcia/pd6729.c
index f0af9985ca09..a0a2e7f18356 100644
--- a/drivers/pcmcia/pd6729.c
+++ b/drivers/pcmcia/pd6729.c
@@ -727,7 +727,7 @@ static int pd6729_pci_probe(struct pci_dev *dev,
 	if (irq_mode == 1)
 		free_irq(dev->irq, socket);
 	else
-		del_timer_sync(&socket->poll_timer);
+		timer_shutdown_sync(&socket->poll_timer);
 err_out_free_res:
 	pci_release_regions(dev);
 err_out_disable:
@@ -754,7 +754,7 @@ static void pd6729_pci_remove(struct pci_dev *dev)
 	if (irq_mode == 1)
 		free_irq(dev->irq, socket);
 	else
-		del_timer_sync(&socket->poll_timer);
+		timer_shutdown_sync(&socket->poll_timer);
 	pci_release_regions(dev);
 	pci_disable_device(dev);
 
diff --git a/drivers/pcmcia/yenta_socket.c b/drivers/pcmcia/yenta_socket.c
index 3966a6ceb1ac..1365eaa20ff4 100644
--- a/drivers/pcmcia/yenta_socket.c
+++ b/drivers/pcmcia/yenta_socket.c
@@ -814,7 +814,7 @@ static void yenta_close(struct pci_dev *dev)
 	if (sock->cb_irq)
 		free_irq(sock->cb_irq, sock);
 	else
-		del_timer_sync(&sock->poll_timer);
+		timer_shutdown_sync(&sock->poll_timer);
 
 	iounmap(sock->base);
 	yenta_free_resources(sock);
@@ -1285,7 +1285,7 @@ static int yenta_probe(struct pci_dev *dev, const struct pci_device_id *id)
 	if (socket->cb_irq)
 		free_irq(socket->cb_irq, socket);
 	else
-		del_timer_sync(&socket->poll_timer);
+		timer_shutdown_sync(&socket->poll_timer);
  unmap:
 	iounmap(socket->base);
 	yenta_free_resources(socket);
diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_edif.c
index 00ccc41cef14..e4240aae5f9e 100644
--- a/drivers/scsi/qla2xxx/qla_edif.c
+++ b/drivers/scsi/qla2xxx/qla_edif.c
@@ -416,7 +416,7 @@ static void __qla2x00_release_all_sadb(struct scsi_qla_host *vha,
 				 */
 				if (edif_entry->delete_sa_index !=
 						INVALID_EDIF_SA_INDEX) {
-					del_timer(&edif_entry->timer);
+					timer_shutdown(&edif_entry->timer);
 
 					/* build and send the aen */
 					fcport->edif.rx_sa_set = 1;
@@ -2799,7 +2799,7 @@ qla28xx_sa_update_iocb_entry(scsi_qla_host_t *v, struct req_que *req,
 			    "%s: removing edif_entry %p, new sa_index: 0x%x\n",
 			    __func__, edif_entry, pkt->sa_index);
 			qla_edif_list_delete_sa_index(sp->fcport, edif_entry);
-			del_timer(&edif_entry->timer);
+			timer_shutdown(&edif_entry->timer);
 
 			ql_dbg(ql_dbg_edif, vha, 0x5033,
 			    "%s: releasing edif_entry %p, new sa_index: 0x%x\n",
diff --git a/drivers/staging/media/atomisp/i2c/atomisp-lm3554.c b/drivers/staging/media/atomisp/i2c/atomisp-lm3554.c
index 75d16b525294..c4ce4cd445d7 100644
--- a/drivers/staging/media/atomisp/i2c/atomisp-lm3554.c
+++ b/drivers/staging/media/atomisp/i2c/atomisp-lm3554.c
@@ -921,7 +921,7 @@ static void lm3554_remove(struct i2c_client *client)
 
 	atomisp_gmin_remove_subdev(sd);
 
-	del_timer_sync(&flash->flash_off_delay);
+	timer_shutdown_sync(&flash->flash_off_delay);
 
 	lm3554_gpio_uninit(client);
 
diff --git a/drivers/staging/wlan-ng/prism2usb.c b/drivers/staging/wlan-ng/prism2usb.c
index c13f1699e5a2..80e36d03c4e2 100644
--- a/drivers/staging/wlan-ng/prism2usb.c
+++ b/drivers/staging/wlan-ng/prism2usb.c
@@ -170,9 +170,9 @@ static void prism2sta_disconnect_usb(struct usb_interface *interface)
 		 */
 		prism2sta_ifstate(wlandev, P80211ENUM_ifstate_disable);
 
-		del_timer_sync(&hw->throttle);
-		del_timer_sync(&hw->reqtimer);
-		del_timer_sync(&hw->resptimer);
+		timer_shutdown_sync(&hw->throttle);
+		timer_shutdown_sync(&hw->reqtimer);
+		timer_shutdown_sync(&hw->resptimer);
 
 		/* Unlink all the URBs. This "removes the wheels"
 		 * from the entire CTLX handling mechanism.
diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index daf12132deb1..348d85c13f91 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -2444,7 +2444,7 @@ static void gsm_dlci_free(struct tty_port *port)
 {
 	struct gsm_dlci *dlci = container_of(port, struct gsm_dlci, port);
 
-	del_timer_sync(&dlci->t1);
+	timer_shutdown_sync(&dlci->t1);
 	dlci->gsm->dlci[dlci->addr] = NULL;
 	kfifo_free(&dlci->fifo);
 	while ((dlci->skb = skb_dequeue(&dlci->skb_list)))
diff --git a/drivers/tty/sysrq.c b/drivers/tty/sysrq.c
index d2b2720db6ca..b6e70c5cfa17 100644
--- a/drivers/tty/sysrq.c
+++ b/drivers/tty/sysrq.c
@@ -1003,7 +1003,7 @@ static void sysrq_disconnect(struct input_handle *handle)
 
 	input_close_device(handle);
 	cancel_work_sync(&sysrq->reinject_work);
-	del_timer_sync(&sysrq->keyreset_timer);
+	timer_shutdown_sync(&sysrq->keyreset_timer);
 	input_unregister_handle(handle);
 	kfree(sysrq);
 }
diff --git a/drivers/usb/gadget/udc/m66592-udc.c b/drivers/usb/gadget/udc/m66592-udc.c
index 931e6362a13d..c7e421b449f3 100644
--- a/drivers/usb/gadget/udc/m66592-udc.c
+++ b/drivers/usb/gadget/udc/m66592-udc.c
@@ -1519,7 +1519,7 @@ static int m66592_remove(struct platform_device *pdev)
 
 	usb_del_gadget_udc(&m66592->gadget);
 
-	del_timer_sync(&m66592->timer);
+	timer_shutdown_sync(&m66592->timer);
 	iounmap(m66592->reg);
 	free_irq(platform_get_irq(pdev, 0), m66592);
 	m66592_free_request(&m66592->ep[0].ep, m66592->ep0_req);
diff --git a/drivers/usb/serial/garmin_gps.c b/drivers/usb/serial/garmin_gps.c
index f1a8d8343623..670e942fdaaa 100644
--- a/drivers/usb/serial/garmin_gps.c
+++ b/drivers/usb/serial/garmin_gps.c
@@ -1405,7 +1405,7 @@ static void garmin_port_remove(struct usb_serial_port *port)
 
 	usb_kill_anchored_urbs(&garmin_data_p->write_urbs);
 	usb_kill_urb(port->interrupt_in_urb);
-	del_timer_sync(&garmin_data_p->timer);
+	timer_shutdown_sync(&garmin_data_p->timer);
 	kfree(garmin_data_p);
 }
 
diff --git a/drivers/usb/serial/mos7840.c b/drivers/usb/serial/mos7840.c
index 6b12bb4648b8..73370eaae0ab 100644
--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -1725,8 +1725,8 @@ static void mos7840_port_remove(struct usb_serial_port *port)
 		/* Turn off LED */
 		mos7840_set_led_sync(port, MODEM_CONTROL_REGISTER, 0x0300);
 
-		del_timer_sync(&mos7840_port->led_timer1);
-		del_timer_sync(&mos7840_port->led_timer2);
+		timer_shutdown_sync(&mos7840_port->led_timer1);
+		timer_shutdown_sync(&mos7840_port->led_timer2);
 
 		usb_kill_urb(mos7840_port->led_urb);
 		usb_free_urb(mos7840_port->led_urb);
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 16a343e8047d..260c1b3e3ef2 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1225,7 +1225,7 @@ static void ext4_put_super(struct super_block *sb)
 	}
 
 	ext4_es_unregister_shrinker(sbi);
-	del_timer_sync(&sbi->s_err_report);
+	timer_shutdown_sync(&sbi->s_err_report);
 	ext4_release_system_zone(sb);
 	ext4_mb_release(sb);
 	ext4_ext_release(sb);
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 3335ef352915..76c3bd88b858 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -2752,7 +2752,7 @@ static void nilfs_segctor_destroy(struct nilfs_sc_info *sci)
 
 	down_write(&nilfs->ns_segctor_sem);
 
-	del_timer_sync(&sci->sc_timer);
+	timer_shutdown_sync(&sci->sc_timer);
 	kfree(sci);
 }
 
diff --git a/net/802/garp.c b/net/802/garp.c
index 77aac2763835..ab24b21fbb49 100644
--- a/net/802/garp.c
+++ b/net/802/garp.c
@@ -618,7 +618,7 @@ void garp_uninit_applicant(struct net_device *dev, struct garp_application *appl
 
 	/* Delete timer and generate a final TRANSMIT_PDU event to flush out
 	 * all pending messages before the applicant is gone. */
-	del_timer_sync(&app->join_timer);
+	timer_shutdown_sync(&app->join_timer);
 
 	spin_lock_bh(&app->lock);
 	garp_gid_event(app, GARP_EVENT_TRANSMIT_PDU);
diff --git a/net/802/mrp.c b/net/802/mrp.c
index 66fcbf23b486..eafc21ecc287 100644
--- a/net/802/mrp.c
+++ b/net/802/mrp.c
@@ -911,8 +911,8 @@ void mrp_uninit_applicant(struct net_device *dev, struct mrp_application *appl)
 	/* Delete timer and generate a final TX event to flush out
 	 * all pending messages before the applicant is gone.
 	 */
-	del_timer_sync(&app->join_timer);
-	del_timer_sync(&app->periodic_timer);
+	timer_shutdown_sync(&app->join_timer);
+	timer_shutdown_sync(&app->periodic_timer);
 
 	spin_lock_bh(&app->lock);
 	mrp_mad_event(app, MRP_EVENT_TX);
diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 48170bd3785e..dea1ee1bd095 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -606,7 +606,7 @@ static void br_multicast_destroy_mdb_entry(struct net_bridge_mcast_gc *gc)
 	WARN_ON(!hlist_unhashed(&mp->mdb_node));
 	WARN_ON(mp->ports);
 
-	del_timer_sync(&mp->timer);
+	timer_shutdown_sync(&mp->timer);
 	kfree_rcu(mp, rcu);
 }
 
@@ -647,7 +647,7 @@ static void br_multicast_destroy_group_src(struct net_bridge_mcast_gc *gc)
 	src = container_of(gc, struct net_bridge_group_src, mcast_gc);
 	WARN_ON(!hlist_unhashed(&src->node));
 
-	del_timer_sync(&src->timer);
+	timer_shutdown_sync(&src->timer);
 	kfree_rcu(src, rcu);
 }
 
@@ -676,8 +676,8 @@ static void br_multicast_destroy_port_group(struct net_bridge_mcast_gc *gc)
 	WARN_ON(!hlist_unhashed(&pg->mglist));
 	WARN_ON(!hlist_empty(&pg->src_list));
 
-	del_timer_sync(&pg->rexmit_timer);
-	del_timer_sync(&pg->timer);
+	timer_shutdown_sync(&pg->rexmit_timer);
+	timer_shutdown_sync(&pg->timer);
 	kfree_rcu(pg, rcu);
 }
 
diff --git a/net/bridge/br_multicast_eht.c b/net/bridge/br_multicast_eht.c
index f91c071d1608..c126aa4e7551 100644
--- a/net/bridge/br_multicast_eht.c
+++ b/net/bridge/br_multicast_eht.c
@@ -142,7 +142,7 @@ static void br_multicast_destroy_eht_set_entry(struct net_bridge_mcast_gc *gc)
 	set_h = container_of(gc, struct net_bridge_group_eht_set_entry, mcast_gc);
 	WARN_ON(!RB_EMPTY_NODE(&set_h->rb_node));
 
-	del_timer_sync(&set_h->timer);
+	timer_shutdown_sync(&set_h->timer);
 	kfree(set_h);
 }
 
@@ -154,7 +154,7 @@ static void br_multicast_destroy_eht_set(struct net_bridge_mcast_gc *gc)
 	WARN_ON(!RB_EMPTY_NODE(&eht_set->rb_node));
 	WARN_ON(!RB_EMPTY_ROOT(&eht_set->entry_tree));
 
-	del_timer_sync(&eht_set->timer);
+	timer_shutdown_sync(&eht_set->timer);
 	kfree(eht_set);
 }
 
diff --git a/net/core/gen_estimator.c b/net/core/gen_estimator.c
index 4fcbdd71c59f..fae9c4694186 100644
--- a/net/core/gen_estimator.c
+++ b/net/core/gen_estimator.c
@@ -208,7 +208,7 @@ void gen_kill_estimator(struct net_rate_estimator __rcu **rate_est)
 
 	est = xchg((__force struct net_rate_estimator **)rate_est, NULL);
 	if (est) {
-		del_timer_sync(&est->timer);
+		timer_shutdown_sync(&est->timer);
 		kfree_rcu(est, rcu);
 	}
 }
diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index b58df3c1bf7d..eec1f6df80d8 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -412,7 +412,7 @@ static struct mr_table *ipmr_new_table(struct net *net, u32 id)
 
 static void ipmr_free_table(struct mr_table *mrt)
 {
-	del_timer_sync(&mrt->ipmr_expire_timer);
+	timer_shutdown_sync(&mrt->ipmr_expire_timer);
 	mroute_clean_tables(mrt, MRT_FLUSH_VIFS | MRT_FLUSH_VIFS_STATIC |
 				 MRT_FLUSH_MFC | MRT_FLUSH_MFC_STATIC);
 	rhltable_destroy(&mrt->mfc_hash);
diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index 23e766597f36..51cf37abd142 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -392,7 +392,7 @@ static struct mr_table *ip6mr_new_table(struct net *net, u32 id)
 
 static void ip6mr_free_table(struct mr_table *mrt)
 {
-	del_timer_sync(&mrt->ipmr_expire_timer);
+	timer_shutdown_sync(&mrt->ipmr_expire_timer);
 	mroute_clean_tables(mrt, MRT6_FLUSH_MIFS | MRT6_FLUSH_MIFS_STATIC |
 				 MRT6_FLUSH_MFC | MRT6_FLUSH_MFC_STATIC);
 	rhltable_destroy(&mrt->mfc_hash);
diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 69d5e1ec6ede..3b81e6df3f34 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -512,7 +512,7 @@ static void mesh_path_free_rcu(struct mesh_table *tbl,
 	mpath->flags |= MESH_PATH_RESOLVING | MESH_PATH_DELETED;
 	mesh_gate_del(tbl, mpath);
 	spin_unlock_bh(&mpath->state_lock);
-	del_timer_sync(&mpath->timer);
+	timer_shutdown_sync(&mpath->timer);
 	atomic_dec(&sdata->u.mesh.mpaths);
 	atomic_dec(&tbl->entries);
 	mesh_path_flush_pending(mpath);
diff --git a/net/netfilter/ipset/ip_set_list_set.c b/net/netfilter/ipset/ip_set_list_set.c
index 5a67f7966574..e162636525cf 100644
--- a/net/netfilter/ipset/ip_set_list_set.c
+++ b/net/netfilter/ipset/ip_set_list_set.c
@@ -427,7 +427,7 @@ list_set_destroy(struct ip_set *set)
 	struct set_elem *e, *n;
 
 	if (SET_WITH_TIMEOUT(set))
-		del_timer_sync(&map->gc);
+		timer_shutdown_sync(&map->gc);
 
 	list_for_each_entry_safe(e, n, &map->members, list) {
 		list_del(&e->list);
diff --git a/net/netfilter/ipvs/ip_vs_lblc.c b/net/netfilter/ipvs/ip_vs_lblc.c
index 7ac7473e3804..1b87214d385e 100644
--- a/net/netfilter/ipvs/ip_vs_lblc.c
+++ b/net/netfilter/ipvs/ip_vs_lblc.c
@@ -384,7 +384,7 @@ static void ip_vs_lblc_done_svc(struct ip_vs_service *svc)
 	struct ip_vs_lblc_table *tbl = svc->sched_data;
 
 	/* remove periodic timer */
-	del_timer_sync(&tbl->periodic_timer);
+	timer_shutdown_sync(&tbl->periodic_timer);
 
 	/* got to clean up table entries here */
 	ip_vs_lblc_flush(svc);
diff --git a/net/netfilter/ipvs/ip_vs_lblcr.c b/net/netfilter/ipvs/ip_vs_lblcr.c
index 77c323c36a88..ad8f5fea6d3a 100644
--- a/net/netfilter/ipvs/ip_vs_lblcr.c
+++ b/net/netfilter/ipvs/ip_vs_lblcr.c
@@ -547,7 +547,7 @@ static void ip_vs_lblcr_done_svc(struct ip_vs_service *svc)
 	struct ip_vs_lblcr_table *tbl = svc->sched_data;
 
 	/* remove periodic timer */
-	del_timer_sync(&tbl->periodic_timer);
+	timer_shutdown_sync(&tbl->periodic_timer);
 
 	/* got to clean up table entries here */
 	ip_vs_lblcr_flush(svc);
diff --git a/net/netfilter/xt_IDLETIMER.c b/net/netfilter/xt_IDLETIMER.c
index 0f8bb0bf558f..8d36303f3935 100644
--- a/net/netfilter/xt_IDLETIMER.c
+++ b/net/netfilter/xt_IDLETIMER.c
@@ -413,7 +413,7 @@ static void idletimer_tg_destroy(const struct xt_tgdtor_param *par)
 		pr_debug("deleting timer %s\n", info->label);
 
 		list_del(&info->timer->entry);
-		del_timer_sync(&info->timer->timer);
+		timer_shutdown_sync(&info->timer->timer);
 		cancel_work_sync(&info->timer->work);
 		sysfs_remove_file(idletimer_tg_kobj, &info->timer->attr.attr);
 		kfree(info->timer->attr.attr.name);
@@ -441,7 +441,7 @@ static void idletimer_tg_destroy_v1(const struct xt_tgdtor_param *par)
 		if (info->timer->timer_type & XT_IDLETIMER_ALARM) {
 			alarm_cancel(&info->timer->alarm);
 		} else {
-			del_timer_sync(&info->timer->timer);
+			timer_shutdown_sync(&info->timer->timer);
 		}
 		cancel_work_sync(&info->timer->work);
 		sysfs_remove_file(idletimer_tg_kobj, &info->timer->attr.attr);
diff --git a/net/netfilter/xt_LED.c b/net/netfilter/xt_LED.c
index 0371c387b0d1..66b0f941d8fb 100644
--- a/net/netfilter/xt_LED.c
+++ b/net/netfilter/xt_LED.c
@@ -166,7 +166,7 @@ static void led_tg_destroy(const struct xt_tgdtor_param *par)
 
 	list_del(&ledinternal->list);
 
-	del_timer_sync(&ledinternal->timer);
+	timer_shutdown_sync(&ledinternal->timer);
 
 	led_trigger_unregister(&ledinternal->netfilter_led_trigger);
 
diff --git a/net/sched/cls_flow.c b/net/sched/cls_flow.c
index 535668e1f748..6ab317b48d6c 100644
--- a/net/sched/cls_flow.c
+++ b/net/sched/cls_flow.c
@@ -369,7 +369,7 @@ static const struct nla_policy flow_policy[TCA_FLOW_MAX + 1] = {
 
 static void __flow_destroy_filter(struct flow_filter *f)
 {
-	del_timer_sync(&f->perturb_timer);
+	timer_shutdown_sync(&f->perturb_timer);
 	tcf_exts_destroy(&f->exts);
 	tcf_em_tree_destroy(&f->ematches);
 	tcf_exts_put_net(&f->exts);
diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
index 8f1b596db33f..85f0c3cfc877 100644
--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -567,7 +567,7 @@ svc_destroy(struct kref *ref)
 	struct svc_serv *serv = container_of(ref, struct svc_serv, sv_refcnt);
 
 	dprintk("svc: svc_destroy(%s)\n", serv->sv_program->pg_name);
-	del_timer_sync(&serv->sv_temptimer);
+	timer_shutdown_sync(&serv->sv_temptimer);
 
 	/*
 	 * The last user is gone and thus all sockets have to be destroyed to
diff --git a/net/tipc/discover.c b/net/tipc/discover.c
index e8dcdf267c0c..685389d4b245 100644
--- a/net/tipc/discover.c
+++ b/net/tipc/discover.c
@@ -388,7 +388,7 @@ int tipc_disc_create(struct net *net, struct tipc_bearer *b,
  */
 void tipc_disc_delete(struct tipc_discoverer *d)
 {
-	del_timer_sync(&d->timer);
+	timer_shutdown_sync(&d->timer);
 	kfree_skb(d->skb);
 	kfree(d);
 }
diff --git a/net/tipc/monitor.c b/net/tipc/monitor.c
index 9618e4429f0f..77a3d016cade 100644
--- a/net/tipc/monitor.c
+++ b/net/tipc/monitor.c
@@ -700,7 +700,7 @@ void tipc_mon_delete(struct net *net, int bearer_id)
 	}
 	mon->self = NULL;
 	write_unlock_bh(&mon->lock);
-	del_timer_sync(&mon->timer);
+	timer_shutdown_sync(&mon->timer);
 	kfree(self->domain);
 	kfree(self);
 	kfree(mon);
diff --git a/sound/i2c/other/ak4117.c b/sound/i2c/other/ak4117.c
index 1bc43e927d82..640501bb3ca6 100644
--- a/sound/i2c/other/ak4117.c
+++ b/sound/i2c/other/ak4117.c
@@ -47,7 +47,7 @@ static void reg_dump(struct ak4117 *ak4117)
 
 static void snd_ak4117_free(struct ak4117 *chip)
 {
-	del_timer_sync(&chip->timer);
+	timer_shutdown_sync(&chip->timer);
 	kfree(chip);
 }
 
diff --git a/sound/synth/emux/emux.c b/sound/synth/emux/emux.c
index a870759d179e..0006c3ddb51d 100644
--- a/sound/synth/emux/emux.c
+++ b/sound/synth/emux/emux.c
@@ -129,7 +129,7 @@ int snd_emux_free(struct snd_emux *emu)
 	if (! emu)
 		return -EINVAL;
 
-	del_timer_sync(&emu->tlist);
+	timer_shutdown_sync(&emu->tlist);
 
 	snd_emux_proc_free(emu);
 	snd_emux_delete_virmidi(emu);
-- 
2.35.1

