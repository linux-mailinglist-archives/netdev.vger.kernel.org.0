Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4864D6A42F7
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 14:36:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230086AbjB0Ng4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 08:36:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229948AbjB0Ngr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 08:36:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84A0121A05;
        Mon, 27 Feb 2023 05:35:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E7141B8074C;
        Mon, 27 Feb 2023 13:35:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08801C433D2;
        Mon, 27 Feb 2023 13:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677504947;
        bh=1Ww/7e3RJTMKgfKFzXO3pKumxZIgKPNHR/yiafv3REY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PefI5B4VOrc57BLXksqw/xdqvSAUgtM6sxZtL3mr0qjuscydp9s1a67cbabzcDth+
         iyHNv60VMjl1RHAuwyJKskyaXfSLO63e8SZvylsq1bp4upxupPyCJPzK/3JDUqXhL8
         NUkN0eKIn5N2U8tKeEziLHfzaerHfhPQFL935z5/kbx6Flx/cSGKAn367Rnr+jfmSe
         gFHpS0GKXurz5t9E36Uob8Njclwq1yYknLWaygPSJtwo5ru2Ou5zjmfh7ACR5MOrmP
         cjPM8BB4mOwJuIZT2bbdNR8vz094/tfweersPYv54sJURWnT/idpGVUmY2udnV9bdG
         m7u/k9wWHeXjw==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Dominik Brodowski <linux@dominikbrodowski.net>,
        linux-kernel@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, Bjorn Helgaas <bhelgaas@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Ian Abbott <abbotti@mev.co.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Kevin Cernekee <cernekee@gmail.com>,
        Lukas Wunner <lukas@wunner.de>,
        Manuel Lauss <manuel.lauss@gmail.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Olof Johansson <olof@lixom.net>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>,
        bcm-kernel-feedback-list@broadcom.com,
        linux-arm-kernel@lists.infradead.org, linux-can@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [RFC 5/6] pccard: drop remnants of cardbus support
Date:   Mon, 27 Feb 2023 14:34:56 +0100
Message-Id: <20230227133457.431729-6-arnd@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230227133457.431729-1-arnd@kernel.org>
References: <20230227133457.431729-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

Now that cardbus/yenta support is independent of PCMCIA support,
there is no need to keep the conditional compilation bits around
any longer.

This means we can allow both CARDBUS and PCMCIA to be built
as loadable modules, though actually loading them at the same
time, or building them into the kernel would still fails
because they try to create the same sysfs interface.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/pcmcia/Kconfig        |  2 +-
 drivers/pcmcia/cistpl.c       | 10 +---
 drivers/pcmcia/cs.c           | 86 ++++-------------------------------
 drivers/pcmcia/cs_internal.h  |  9 ----
 drivers/pcmcia/socket_sysfs.c |  2 -
 include/pcmcia/ss.h           | 21 ---------
 6 files changed, 11 insertions(+), 119 deletions(-)

diff --git a/drivers/pcmcia/Kconfig b/drivers/pcmcia/Kconfig
index 7b449d40da5e..c05d95cf7d3e 100644
--- a/drivers/pcmcia/Kconfig
+++ b/drivers/pcmcia/Kconfig
@@ -23,7 +23,7 @@ config PCMCIA
 	select CRC32
 	depends on X86_32 || ARCH_PXA || ARCH_SA1100 || ARCH_OMAP1 || \
 		   MIPS_ALCHEMY || PPC_PASEMI || COMPILE_TEST
-	depends on CARDBUS=n
+	depends on !CARDBUS
 	default y
 	help
 	   This option enables support for 16-bit PCMCIA cards. Most older
diff --git a/drivers/pcmcia/cistpl.c b/drivers/pcmcia/cistpl.c
index 948b763dc451..05967953fafa 100644
--- a/drivers/pcmcia/cistpl.c
+++ b/drivers/pcmcia/cistpl.c
@@ -290,9 +290,6 @@ static int read_cis_cache(struct pcmcia_socket *s, int attr, u_int addr,
 	struct cis_cache_entry *cis;
 	int ret = 0;
 
-	if (s->state & SOCKET_CARDBUS)
-		return -EINVAL;
-
 	mutex_lock(&s->ops_mutex);
 	if (s->fake_cis) {
 		if (s->fake_cis_len >= addr+len)
@@ -374,9 +371,6 @@ int verify_cis_cache(struct pcmcia_socket *s)
 	char *buf;
 	int ret;
 
-	if (s->state & SOCKET_CARDBUS)
-		return -EINVAL;
-
 	buf = kmalloc(256, GFP_KERNEL);
 	if (buf == NULL) {
 		dev_warn(&s->dev, "no memory for verifying CIS\n");
@@ -449,7 +443,7 @@ int pccard_get_first_tuple(struct pcmcia_socket *s, unsigned int function,
 	if (!s)
 		return -EINVAL;
 
-	if (!(s->state & SOCKET_PRESENT) || (s->state & SOCKET_CARDBUS))
+	if (!(s->state & SOCKET_PRESENT))
 		return -ENODEV;
 	tuple->TupleLink = tuple->Flags = 0;
 
@@ -527,7 +521,7 @@ int pccard_get_next_tuple(struct pcmcia_socket *s, unsigned int function,
 
 	if (!s)
 		return -EINVAL;
-	if (!(s->state & SOCKET_PRESENT) || (s->state & SOCKET_CARDBUS))
+	if (!(s->state & SOCKET_PRESENT))
 		return -ENODEV;
 
 	link[1] = tuple->TupleLink;
diff --git a/drivers/pcmcia/cs.c b/drivers/pcmcia/cs.c
index 8ed89d7cfc94..3d69914f5fec 100644
--- a/drivers/pcmcia/cs.c
+++ b/drivers/pcmcia/cs.c
@@ -133,14 +133,6 @@ int pcmcia_register_socket(struct pcmcia_socket *socket)
 	list_add_tail(&socket->socket_list, &pcmcia_socket_list);
 	up_write(&pcmcia_socket_list_rwsem);
 
-#if !IS_ENABLED(CONFIG_CARDBUS)
-	/*
-	 * If we do not support Cardbus, ensure that
-	 * the Cardbus socket capability is disabled.
-	 */
-	socket->features &= ~SS_CAP_CARDBUS;
-#endif
-
 	/* set proper values in socket->dev */
 	dev_set_drvdata(&socket->dev, socket);
 	socket->dev.class = &pcmcia_socket_class;
@@ -313,10 +305,6 @@ static void socket_shutdown(struct pcmcia_socket *s)
 	 */
 	mutex_unlock(&s->ops_mutex);
 
-#if IS_ENABLED(CONFIG_CARDBUS)
-	cb_free(s);
-#endif
-
 	/* give socket some time to power down */
 	msleep(100);
 
@@ -357,15 +345,6 @@ static int socket_setup(struct pcmcia_socket *skt, int initial_delay)
 		return -ETIMEDOUT;
 	}
 
-	if (status & SS_CARDBUS) {
-		if (!(skt->features & SS_CAP_CARDBUS)) {
-			dev_err(&skt->dev, "cardbus cards are not supported\n");
-			return -EINVAL;
-		}
-		skt->state |= SOCKET_CARDBUS;
-	} else
-		skt->state &= ~SOCKET_CARDBUS;
-
 	/*
 	 * Decode the card voltage requirements, and apply power to the card.
 	 */
@@ -425,19 +404,12 @@ static int socket_insert(struct pcmcia_socket *skt)
 		skt->state |= SOCKET_PRESENT;
 
 		dev_notice(&skt->dev, "pccard: %s card inserted into slot %d\n",
-			   (skt->state & SOCKET_CARDBUS) ? "CardBus" : "PCMCIA",
-			   skt->sock);
+			   "PCMCIA", skt->sock);
 
-#if IS_ENABLED(CONFIG_CARDBUS)
-		if (skt->state & SOCKET_CARDBUS) {
-			cb_alloc(skt);
-			skt->state |= SOCKET_CARDBUS_CONFIG;
-		}
-#endif
 		dev_dbg(&skt->dev, "insert done\n");
 		mutex_unlock(&skt->ops_mutex);
 
-		if (!(skt->state & SOCKET_CARDBUS) && (skt->callback))
+		if (skt->callback)
 			skt->callback->add(skt);
 	} else {
 		mutex_unlock(&skt->ops_mutex);
@@ -509,33 +481,11 @@ static int socket_late_resume(struct pcmcia_socket *skt)
 		return socket_insert(skt);
 	}
 
-	if (!(skt->state & SOCKET_CARDBUS) && (skt->callback))
+	if (skt->callback)
 		ret = skt->callback->early_resume(skt);
 	return ret;
 }
 
-/*
- * Finalize the resume. In case of a cardbus socket, we have
- * to rebind the devices as we can't be certain that it has been
- * replaced, or not.
- */
-static int socket_complete_resume(struct pcmcia_socket *skt)
-{
-	int ret = 0;
-#if IS_ENABLED(CONFIG_CARDBUS)
-	if (skt->state & SOCKET_CARDBUS) {
-		/* We can't be sure the CardBus card is the same
-		 * as the one previously inserted. Therefore, remove
-		 * and re-add... */
-		cb_free(skt);
-		ret = cb_alloc(skt);
-		if (ret)
-			cb_free(skt);
-	}
-#endif
-	return ret;
-}
-
 /*
  * Resume a socket.  If a card is present, verify its CIS against
  * our cached copy.  If they are different, the card has been
@@ -543,15 +493,11 @@ static int socket_complete_resume(struct pcmcia_socket *skt)
  */
 static int socket_resume(struct pcmcia_socket *skt)
 {
-	int err;
 	if (!(skt->state & SOCKET_SUSPEND))
 		return -EBUSY;
 
 	socket_early_resume(skt);
-	err = socket_late_resume(skt);
-	if (!err)
-		err = socket_complete_resume(skt);
-	return err;
+	return socket_late_resume(skt);
 }
 
 static void socket_remove(struct pcmcia_socket *skt)
@@ -638,8 +584,7 @@ static int pccardd(void *__skt)
 				socket_remove(skt);
 			if (sysfs_events & PCMCIA_UEVENT_INSERT)
 				socket_insert(skt);
-			if ((sysfs_events & PCMCIA_UEVENT_SUSPEND) &&
-				!(skt->state & SOCKET_CARDBUS)) {
+			if (sysfs_events & PCMCIA_UEVENT_SUSPEND) {
 				if (skt->callback)
 					ret = skt->callback->suspend(skt);
 				else
@@ -649,14 +594,12 @@ static int pccardd(void *__skt)
 					msleep(100);
 				}
 			}
-			if ((sysfs_events & PCMCIA_UEVENT_RESUME) &&
-				!(skt->state & SOCKET_CARDBUS)) {
+			if (sysfs_events & PCMCIA_UEVENT_RESUME) {
 				ret = socket_resume(skt);
 				if (!ret && skt->callback)
 					skt->callback->resume(skt);
 			}
-			if ((sysfs_events & PCMCIA_UEVENT_REQUERY) &&
-				!(skt->state & SOCKET_CARDBUS)) {
+			if (sysfs_events & PCMCIA_UEVENT_REQUERY) {
 				if (!ret && skt->callback)
 					skt->callback->requery(skt);
 			}
@@ -752,7 +695,7 @@ int pccard_register_pcmcia(struct pcmcia_socket *s, struct pcmcia_callback *c)
 
 		s->callback = c;
 
-		if ((s->state & (SOCKET_PRESENT|SOCKET_CARDBUS)) == SOCKET_PRESENT)
+		if (s->state & SOCKET_PRESENT)
 			s->callback->add(s);
 	} else
 		s->callback = NULL;
@@ -787,12 +730,6 @@ int pcmcia_reset_card(struct pcmcia_socket *skt)
 			ret = -EBUSY;
 			break;
 		}
-		if (skt->state & SOCKET_CARDBUS) {
-			dev_dbg(&skt->dev, "can't reset, is cardbus\n");
-			ret = -EPERM;
-			break;
-		}
-
 		if (skt->callback)
 			skt->callback->suspend(skt);
 		mutex_lock(&skt->ops_mutex);
@@ -860,12 +797,6 @@ static int __used pcmcia_socket_dev_resume(struct device *dev)
 	return __pcmcia_pm_op(dev, socket_late_resume);
 }
 
-static void __used pcmcia_socket_dev_complete(struct device *dev)
-{
-	WARN(__pcmcia_pm_op(dev, socket_complete_resume),
-		"failed to complete resume");
-}
-
 static const struct dev_pm_ops pcmcia_socket_pm_ops = {
 	/* dev_resume may be called with IRQs enabled */
 	SET_SYSTEM_SLEEP_PM_OPS(NULL,
@@ -880,7 +811,6 @@ static const struct dev_pm_ops pcmcia_socket_pm_ops = {
 	.resume_noirq = pcmcia_socket_dev_resume_noirq,
 	.thaw_noirq = pcmcia_socket_dev_resume_noirq,
 	.restore_noirq = pcmcia_socket_dev_resume_noirq,
-	.complete = pcmcia_socket_dev_complete,
 };
 
 #define PCMCIA_SOCKET_CLASS_PM_OPS (&pcmcia_socket_pm_ops)
diff --git a/drivers/pcmcia/cs_internal.h b/drivers/pcmcia/cs_internal.h
index 1fc527fd06c3..c29b86d6910b 100644
--- a/drivers/pcmcia/cs_internal.h
+++ b/drivers/pcmcia/cs_internal.h
@@ -70,9 +70,6 @@ struct pccard_resource_ops {
 #define SOCKET_IN_RESUME	0x0040
 #define SOCKET_SUSPEND		0x0080
 #define SOCKET_WIN_REQ(i)	(0x0100<<(i))
-#define SOCKET_CARDBUS		0x8000
-#define SOCKET_CARDBUS_CONFIG	0x10000
-
 
 /*
  * Stuff internal to module "pcmcia_rsrc":
@@ -90,12 +87,6 @@ extern struct resource *pcmcia_make_resource(resource_size_t start,
 extern int pccard_sysfs_add_socket(struct device *dev);
 extern void pccard_sysfs_remove_socket(struct device *dev);
 
-/* cardbus.c */
-int cb_alloc(struct pcmcia_socket *s);
-void cb_free(struct pcmcia_socket *s);
-
-
-
 /*
  * Stuff exported by module "pcmcia_core" to module "pcmcia"
  */
diff --git a/drivers/pcmcia/socket_sysfs.c b/drivers/pcmcia/socket_sysfs.c
index c7a906664c36..d41d6fbe48cf 100644
--- a/drivers/pcmcia/socket_sysfs.c
+++ b/drivers/pcmcia/socket_sysfs.c
@@ -37,8 +37,6 @@ static ssize_t pccard_show_type(struct device *dev, struct device_attribute *att
 
 	if (!(s->state & SOCKET_PRESENT))
 		return -ENODEV;
-	if (s->state & SOCKET_CARDBUS)
-		return sysfs_emit(buf, "32-bit\n");
 	return sysfs_emit(buf, "16-bit\n");
 }
 static DEVICE_ATTR(card_type, 0444, pccard_show_type, NULL);
diff --git a/include/pcmcia/ss.h b/include/pcmcia/ss.h
index b905f5248fc6..ea22367e6a78 100644
--- a/include/pcmcia/ss.h
+++ b/include/pcmcia/ss.h
@@ -16,10 +16,6 @@
 #include <linux/sched.h>	/* task_struct, completion */
 #include <linux/mutex.h>
 
-#if IS_ENABLED(CONFIG_CARDBUS)
-#include <linux/pci.h>
-#endif
-
 /* Definitions for card status flags for GetStatus */
 #define SS_WRPROT	0x0001
 #define SS_CARDLOCK	0x0002
@@ -175,11 +171,6 @@ struct pcmcia_socket {
 	/* so is power hook */
 	int (*power_hook)(struct pcmcia_socket *sock, int operation);
 
-	/* allows tuning the CB bridge before loading driver for the CB card */
-#if IS_ENABLED(CONFIG_CARDBUS)
-	void (*tune_bridge)(struct pcmcia_socket *sock, struct pci_bus *bus);
-#endif
-
 	/* state thread */
 	struct task_struct		*thread;
 	struct completion		thread_done;
@@ -197,7 +188,6 @@ struct pcmcia_socket {
 	/* pcmcia (16-bit) */
 	struct pcmcia_callback		*callback;
 
-#if defined(CONFIG_PCMCIA) || defined(CONFIG_PCMCIA_MODULE)
 	/* The following elements refer to 16-bit PCMCIA devices inserted
 	 * into the socket */
 	struct list_head		devices_list;
@@ -215,8 +205,6 @@ struct pcmcia_socket {
 	/* IRQ to be used by PCMCIA devices. May not be IRQ 0. */
 	unsigned int			pcmcia_irq;
 
-#endif /* CONFIG_PCMCIA */
-
 	/* socket device */
 	struct device			dev;
 	/* data internal to the socket driver */
@@ -239,17 +227,8 @@ struct pcmcia_socket {
  *
  */
 extern struct pccard_resource_ops pccard_static_ops;
-#if defined(CONFIG_PCMCIA) || defined(CONFIG_PCMCIA_MODULE)
 extern struct pccard_resource_ops pccard_iodyn_ops;
 extern struct pccard_resource_ops pccard_nonstatic_ops;
-#else
-/* If PCMCIA is not used, but only CARDBUS, these functions are not used
- * at all. Therefore, do not use the large (240K!) rsrc_nonstatic module
- */
-#define pccard_iodyn_ops pccard_static_ops
-#define pccard_nonstatic_ops pccard_static_ops
-#endif
-
 
 /* socket drivers use this callback in their IRQ handler */
 extern void pcmcia_parse_events(struct pcmcia_socket *socket,
-- 
2.39.2

