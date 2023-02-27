Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 374EC6A42EE
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 14:36:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230191AbjB0NgN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 08:36:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230205AbjB0NgF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 08:36:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C861211B;
        Mon, 27 Feb 2023 05:35:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 28BAA60E33;
        Mon, 27 Feb 2023 13:35:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DCB6C4339B;
        Mon, 27 Feb 2023 13:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677504942;
        bh=dcKzIljL/0MdmqIdum1Oso7FBUOVJFZs8Htgpn/H/y8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HlmOF8hdJpfHCsmEqvwFfGIzhxHgTQLalqBvqj6oCdhpIRbynZTcMdzxRJYd/gvfT
         tDaWysRXTUqo9qSs65vVGnuE8wtBT9YEpiV5xzNEerxOO8lKJJGswF2FQ2l0HjQINe
         vaWM5ClCLaP4SUzOVu+TzjMYXGuTtwpcimJGZ9F9rdlX++pcZqsj67aEkE3OMDzK2+
         uZ+Bj/FN8fbbg6+kwIZAzl1dWx35uNrOmAO0ooSNQpWXM1jL4I3mhhIEUmL8mqA1/v
         YlxO7m3HXD2YCtdta4LG2HYvH1lihI6M41tbpr9jCU0H22S7SyCa9xbTWacdcgZKxd
         r/e7vs//ujyoQ==
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
Subject: [RFC 4/6] yenta_socket: remove dead code
Date:   Mon, 27 Feb 2023 14:34:55 +0100
Message-Id: <20230227133457.431729-5-arnd@kernel.org>
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

A lot of the now merged pccard layer in the yenta_socket driver is never
used on cardbus devices, so it can get removed. All global symbols can
be made static and exports removed.

The pccard_operations and pccard_resource_ops only have one valid
implementation, so all indirect function pointers become direct
calls.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/pcmcia/yenta_socket.c | 955 ++++------------------------------
 1 file changed, 91 insertions(+), 864 deletions(-)

diff --git a/drivers/pcmcia/yenta_socket.c b/drivers/pcmcia/yenta_socket.c
index 64d11592bd99..68b852f18cbb 100644
--- a/drivers/pcmcia/yenta_socket.c
+++ b/drivers/pcmcia/yenta_socket.c
@@ -1,24 +1,40 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * ss.h
+ * Regular cardbus driver ("yenta_socket")
  *
  * The initial developer of the original code is David A. Hinds
  * <dahinds@users.sourceforge.net>.  Portions created by David A. Hinds
  * are Copyright (C) 1999 David A. Hinds.  All Rights Reserved.
  *
  * (C) 1999             David A. Hinds
+ * (C) Copyright 1999, 2000 Linus Torvalds
+ * (C) 2003 - 2010	Dominik Brodowski
+ *
  */
-
-#ifndef _LINUX_SS_H
-#define _LINUX_SS_H
-
+#include <linux/delay.h>
 #include <linux/device.h>
-#include <linux/sched.h>	/* task_struct, completion */
+#include <linux/errno.h>
+#include <linux/freezer.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/ioport.h>
+#include <linux/kernel.h>
+#include <linux/kref.h>
+#include <linux/kthread.h>
+#include <linux/mm.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
 #include <linux/mutex.h>
-
-#if IS_ENABLED(CONFIG_CARDBUS)
 #include <linux/pci.h>
-#endif
+#include <linux/pm.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+#include <linux/timer.h>
+#include <linux/workqueue.h>
+#include <asm/irq.h>
+#include "i82365.h"
 
 /* Definitions for card status flags for GetStatus */
 #define SS_WRPROT	0x0001
@@ -38,14 +54,6 @@
 #define SS_PENDING	0x4000
 #define SS_ZVCARD	0x8000
 
-/* InquireSocket capabilities */
-#define SS_CAP_PAGE_REGS	0x0001
-#define SS_CAP_VIRTUAL_BUS	0x0002
-#define SS_CAP_MEM_ALIGN	0x0004
-#define SS_CAP_STATIC_MAP	0x0008
-#define SS_CAP_PCCARD		0x4000
-#define SS_CAP_CARDBUS		0x8000
-
 /* for GetSocket, SetSocket */
 typedef struct socket_state_t {
 	u_int	flags;
@@ -54,8 +62,6 @@ typedef struct socket_state_t {
 	u_char	io_irq;
 } socket_state_t;
 
-extern socket_state_t dead_socket;
-
 /* Socket configuration flags */
 #define SS_PWR_AUTO	0x0010
 #define SS_IOCARD	0x0020
@@ -97,35 +103,12 @@ typedef struct pccard_mem_map {
 	struct resource	*res;
 } pccard_mem_map;
 
-typedef struct io_window_t {
-	u_int			InUse, Config;
-	struct resource		*res;
-} io_window_t;
-
-/* Maximum number of IO windows per socket */
-#define MAX_IO_WIN 2
-
-/* Maximum number of memory windows per socket */
-#define MAX_WIN 4
-
-
-/*
- * Socket operations.
- */
 struct pcmcia_socket;
-struct pccard_resource_ops;
-struct config_t;
-struct pcmcia_callback;
-struct user_info_t;
-
-struct pccard_operations {
-	int (*init)(struct pcmcia_socket *s);
-	int (*suspend)(struct pcmcia_socket *s);
-	int (*get_status)(struct pcmcia_socket *s, u_int *value);
-	int (*set_socket)(struct pcmcia_socket *s, socket_state_t *state);
-	int (*set_io_map)(struct pcmcia_socket *s, struct pccard_io_map *io);
-	int (*set_mem_map)(struct pcmcia_socket *s, struct pccard_mem_map *mem);
-};
+
+static int yenta_sock_init(struct pcmcia_socket *sock);
+static int yenta_sock_suspend(struct pcmcia_socket *sock);
+static int yenta_set_socket(struct pcmcia_socket *sock, socket_state_t *state);
+static int yenta_get_status(struct pcmcia_socket *sock, unsigned int *value);
 
 struct pcmcia_socket {
 	struct module			*owner;
@@ -133,16 +116,10 @@ struct pcmcia_socket {
 	u_int				state;
 	u_int				suspended_state;	/* state before suspend */
 	u_short				functions;
-	u_short				lock_count;
-	pccard_mem_map			cis_mem;
-	void __iomem 			*cis_virt;
-	io_window_t			io[MAX_IO_WIN];
-	pccard_mem_map			win[MAX_WIN];
 	struct list_head		cis_cache;
 	size_t				fake_cis_len;
 	u8				*fake_cis;
 
-	struct list_head		socket_list;
 	struct completion		socket_released;
 
 	/* deprecated */
@@ -150,10 +127,7 @@ struct pcmcia_socket {
 
 
 	/* socket capabilities */
-	u_int				features;
 	u_int				irq_mask;
-	u_int				map_size;
-	u_int				io_offset;
 	u_int				pci_irq;
 	struct pci_dev			*cb_dev;
 
@@ -162,11 +136,6 @@ struct pcmcia_socket {
 	 * insertio events are actually managed by the PCMCIA layer.*/
 	u8				resource_setup_done;
 
-	/* socket operations */
-	struct pccard_operations	*ops;
-	struct pccard_resource_ops	*resource_ops;
-	void				*resource_data;
-
 	/* Zoom video behaviour is so chip specific its not worth adding
 	   this to _ops */
 	void 				(*zoom_video)(struct pcmcia_socket *,
@@ -176,9 +145,7 @@ struct pcmcia_socket {
 	int (*power_hook)(struct pcmcia_socket *sock, int operation);
 
 	/* allows tuning the CB bridge before loading driver for the CB card */
-#if IS_ENABLED(CONFIG_CARDBUS)
 	void (*tune_bridge)(struct pcmcia_socket *sock, struct pci_bus *bus);
-#endif
 
 	/* state thread */
 	struct task_struct		*thread;
@@ -194,73 +161,17 @@ struct pcmcia_socket {
 	/* protects thread_events and sysfs_events */
 	spinlock_t			thread_lock;
 
-	/* pcmcia (16-bit) */
-	struct pcmcia_callback		*callback;
-
-#if defined(CONFIG_PCMCIA) || defined(CONFIG_PCMCIA_MODULE)
-	/* The following elements refer to 16-bit PCMCIA devices inserted
-	 * into the socket */
-	struct list_head		devices_list;
-
-	/* the number of devices, used only internally and subject to
-	 * incorrectness and change */
-	u8				device_count;
-
-	/* does the PCMCIA card consist of two pseudo devices? */
-	u8				pcmcia_pfc;
-
-	/* non-zero if PCMCIA card is present */
-	atomic_t			present;
-
-	/* IRQ to be used by PCMCIA devices. May not be IRQ 0. */
-	unsigned int			pcmcia_irq;
-
-#endif /* CONFIG_PCMCIA */
-
 	/* socket device */
 	struct device			dev;
-	/* data internal to the socket driver */
-	void				*driver_data;
 	/* status of the card during resume from a system sleep state */
 	int				resume_status;
 };
 
 
-/* socket drivers must define the resource operations type they use. There
- * are three options:
- * - pccard_static_ops		iomem and ioport areas are assigned statically
- * - pccard_iodyn_ops		iomem areas is assigned statically, ioport
- *				areas dynamically
- *				If this option is selected, use
- *				"select PCCARD_IODYN" in Kconfig.
- * - pccard_nonstatic_ops	iomem and ioport areas are assigned dynamically.
- *				If this option is selected, use
- *				"select PCCARD_NONSTATIC" in Kconfig.
- *
- */
-extern struct pccard_resource_ops pccard_static_ops;
-#if defined(CONFIG_PCMCIA) || defined(CONFIG_PCMCIA_MODULE)
-extern struct pccard_resource_ops pccard_iodyn_ops;
-extern struct pccard_resource_ops pccard_nonstatic_ops;
-#else
-/* If PCMCIA is not used, but only CARDBUS, these functions are not used
- * at all. Therefore, do not use the large (240K!) rsrc_nonstatic module
- */
-#define pccard_iodyn_ops pccard_static_ops
-#define pccard_nonstatic_ops pccard_static_ops
-#endif
-
-
 /* socket drivers use this callback in their IRQ handler */
-extern void pcmcia_parse_events(struct pcmcia_socket *socket,
+static void pcmcia_parse_events(struct pcmcia_socket *socket,
 				unsigned int events);
 
-/* to register and unregister a socket */
-extern int pcmcia_register_socket(struct pcmcia_socket *socket);
-extern void pcmcia_unregister_socket(struct pcmcia_socket *socket);
-
-#endif /* _LINUX_SS_H */
-
 #define CB_SOCKET_EVENT		0x00
 #define    CB_CSTSEVENT		0x00000001	/* Card status event */
 #define    CB_CD1EVENT		0x00000002	/* Card detect 1 change event */
@@ -358,7 +269,6 @@ extern void pcmcia_unregister_socket(struct pcmcia_socket *socket);
 #define YENTA_16BIT_POWER_EXCA	0x00000001
 #define YENTA_16BIT_POWER_DF	0x00000002
 
-
 struct yenta_socket;
 
 struct cardbus_type {
@@ -389,212 +299,28 @@ struct yenta_socket {
 	u32 saved_state[2];
 };
 
-/*
- * cs_internal.h -- definitions internal to the PCMCIA core modules
- *
- * The initial developer of the original code is David A. Hinds
- * <dahinds@users.sourceforge.net>.  Portions created by David A. Hinds
- * are Copyright (C) 1999 David A. Hinds.  All Rights Reserved.
- *
- * (C) 1999		David A. Hinds
- * (C) 2003 - 2010	Dominik Brodowski
- *
- * This file contains definitions _only_ needed by the PCMCIA core modules.
- * It must not be included by PCMCIA socket drivers or by PCMCIA device
- * drivers.
- */
-
-#ifndef _LINUX_CS_INTERNAL_H
-#define _LINUX_CS_INTERNAL_H
-
-#include <linux/kref.h>
-#include <pcmcia/cistpl.h>
-
-/* Flags in client state */
-#define CLIENT_WIN_REQ(i)	(0x1<<(i))
-
-/* Flag to access all functions */
-#define BIND_FN_ALL	0xff
-
-/* Each card function gets one of these guys */
-typedef struct config_t {
-	struct kref	ref;
-	unsigned int	state;
-
-	struct resource io[MAX_IO_WIN]; /* io ports */
-	struct resource mem[MAX_WIN];   /* mem areas */
-} config_t;
-
-
-struct cis_cache_entry {
-	struct list_head	node;
-	unsigned int		addr;
-	unsigned int		len;
-	unsigned int		attr;
-	unsigned char		cache[];
-};
-
-struct pccard_resource_ops {
-	int	(*validate_mem)		(struct pcmcia_socket *s);
-	int	(*find_io)		(struct pcmcia_socket *s,
-					 unsigned int attr,
-					 unsigned int *base,
-					 unsigned int num,
-					 unsigned int align,
-					 struct resource **parent);
-	struct resource* (*find_mem)	(unsigned long base, unsigned long num,
-					 unsigned long align, int low,
-					 struct pcmcia_socket *s);
-	int	(*init)			(struct pcmcia_socket *s);
-	void	(*exit)			(struct pcmcia_socket *s);
-};
-
-/* Flags in config state */
-#define CONFIG_LOCKED		0x01
-#define CONFIG_IRQ_REQ		0x02
-#define CONFIG_IO_REQ		0x04
+static int static_init(struct pcmcia_socket *s);
 
 /* Flags in socket state */
 #define SOCKET_PRESENT		0x0008
 #define SOCKET_INUSE		0x0010
 #define SOCKET_IN_RESUME	0x0040
 #define SOCKET_SUSPEND		0x0080
-#define SOCKET_WIN_REQ(i)	(0x0100<<(i))
 #define SOCKET_CARDBUS		0x8000
 #define SOCKET_CARDBUS_CONFIG	0x10000
 
+static int pccard_sysfs_add_socket(struct device *dev);
+static void pccard_sysfs_remove_socket(struct device *dev);
+static int cb_alloc(struct pcmcia_socket *s);
+static void cb_free(struct pcmcia_socket *s);
+static struct class pcmcia_socket_class;
 
-/*
- * Stuff internal to module "pcmcia_rsrc":
- */
-extern int static_init(struct pcmcia_socket *s);
-extern struct resource *pcmcia_make_resource(resource_size_t start,
-					resource_size_t end,
-					unsigned long flags, const char *name);
-
-/*
- * Stuff internal to module "pcmcia_core":
- */
-
-/* socket_sysfs.c */
-extern int pccard_sysfs_add_socket(struct device *dev);
-extern void pccard_sysfs_remove_socket(struct device *dev);
-
-/* cardbus.c */
-int cb_alloc(struct pcmcia_socket *s);
-void cb_free(struct pcmcia_socket *s);
-
-
-
-/*
- * Stuff exported by module "pcmcia_core" to module "pcmcia"
- */
-
-struct pcmcia_callback{
-	struct module	*owner;
-	int		(*add) (struct pcmcia_socket *s);
-	int		(*remove) (struct pcmcia_socket *s);
-	void		(*requery) (struct pcmcia_socket *s);
-	int		(*validate) (struct pcmcia_socket *s, unsigned int *i);
-	int		(*suspend) (struct pcmcia_socket *s);
-	int		(*early_resume) (struct pcmcia_socket *s);
-	int		(*resume) (struct pcmcia_socket *s);
-};
-
-/* cs.c */
-extern struct rw_semaphore pcmcia_socket_list_rwsem;
-extern struct list_head pcmcia_socket_list;
-extern struct class pcmcia_socket_class;
-
-int pccard_register_pcmcia(struct pcmcia_socket *s, struct pcmcia_callback *c);
-struct pcmcia_socket *pcmcia_get_socket_by_nr(unsigned int nr);
-
-void pcmcia_parse_uevents(struct pcmcia_socket *socket, unsigned int events);
 #define PCMCIA_UEVENT_EJECT	0x0001
 #define PCMCIA_UEVENT_INSERT	0x0002
 #define PCMCIA_UEVENT_SUSPEND	0x0004
 #define PCMCIA_UEVENT_RESUME	0x0008
 #define PCMCIA_UEVENT_REQUERY	0x0010
 
-struct pcmcia_socket *pcmcia_get_socket(struct pcmcia_socket *skt);
-void pcmcia_put_socket(struct pcmcia_socket *skt);
-
-/*
- * Stuff internal to module "pcmcia".
- */
-/* ds.c */
-extern struct bus_type pcmcia_bus_type;
-
-struct pcmcia_device;
-
-/* pcmcia_resource.c */
-extern int pcmcia_release_configuration(struct pcmcia_device *p_dev);
-extern int pcmcia_validate_mem(struct pcmcia_socket *s);
-extern struct resource *pcmcia_find_mem_region(u_long base,
-					       u_long num,
-					       u_long align,
-					       int low,
-					       struct pcmcia_socket *s);
-
-void pcmcia_cleanup_irq(struct pcmcia_socket *s);
-int pcmcia_setup_irq(struct pcmcia_device *p_dev);
-
-/* cistpl.c */
-extern const struct bin_attribute pccard_cis_attr;
-
-int pcmcia_read_cis_mem(struct pcmcia_socket *s, int attr,
-			u_int addr, u_int len, void *ptr);
-int pcmcia_write_cis_mem(struct pcmcia_socket *s, int attr,
-			u_int addr, u_int len, void *ptr);
-void release_cis_mem(struct pcmcia_socket *s);
-void destroy_cis_cache(struct pcmcia_socket *s);
-int pccard_read_tuple(struct pcmcia_socket *s, unsigned int function,
-		      cisdata_t code, void *parse);
-int pcmcia_replace_cis(struct pcmcia_socket *s,
-		       const u8 *data, const size_t len);
-int pccard_validate_cis(struct pcmcia_socket *s, unsigned int *count);
-int verify_cis_cache(struct pcmcia_socket *s);
-
-int pccard_get_first_tuple(struct pcmcia_socket *s, unsigned int function,
-			tuple_t *tuple);
-
-int pccard_get_next_tuple(struct pcmcia_socket *s, unsigned int function,
-			tuple_t *tuple);
-
-int pccard_get_tuple_data(struct pcmcia_socket *s, tuple_t *tuple);
-
-#endif /* _LINUX_CS_INTERNAL_H */
-/*
- * cs.c -- Kernel Card Services - core services
- *
- * The initial developer of the original code is David A. Hinds
- * <dahinds@users.sourceforge.net>.  Portions created by David A. Hinds
- * are Copyright (C) 1999 David A. Hinds.  All Rights Reserved.
- *
- * (C) 1999		David A. Hinds
- */
-
-#include <linux/module.h>
-#include <linux/moduleparam.h>
-#include <linux/init.h>
-#include <linux/kernel.h>
-#include <linux/string.h>
-#include <linux/major.h>
-#include <linux/errno.h>
-#include <linux/slab.h>
-#include <linux/mm.h>
-#include <linux/interrupt.h>
-#include <linux/timer.h>
-#include <linux/ioport.h>
-#include <linux/delay.h>
-#include <linux/pm.h>
-#include <linux/device.h>
-#include <linux/kthread.h>
-#include <linux/freezer.h>
-#include <asm/irq.h>
-
-#include <pcmcia/cisreg.h>
-
 /* Module parameters */
 
 #define INT_MODULE_PARM(n, v) static int n = v; module_param(n, int, 0444)
@@ -611,37 +337,9 @@ INT_MODULE_PARM(unreset_limit,	30);		/* unreset_check's */
 /* Access speed for attribute memory windows */
 INT_MODULE_PARM(cis_speed,	300);		/* ns */
 
-
-socket_state_t dead_socket = {
+static socket_state_t dead_socket = {
 	.csc_mask	= SS_DETECT,
 };
-EXPORT_SYMBOL(dead_socket);
-
-
-/* List of all sockets, protected by a rwsem */
-LIST_HEAD(pcmcia_socket_list);
-EXPORT_SYMBOL(pcmcia_socket_list);
-
-DECLARE_RWSEM(pcmcia_socket_list_rwsem);
-EXPORT_SYMBOL(pcmcia_socket_list_rwsem);
-
-
-struct pcmcia_socket *pcmcia_get_socket(struct pcmcia_socket *skt)
-{
-	struct device *dev = get_device(&skt->dev);
-	if (!dev)
-		return NULL;
-	return dev_get_drvdata(dev);
-}
-EXPORT_SYMBOL(pcmcia_get_socket);
-
-
-void pcmcia_put_socket(struct pcmcia_socket *skt)
-{
-	put_device(&skt->dev);
-}
-EXPORT_SYMBOL(pcmcia_put_socket);
-
 
 static void pcmcia_release_socket(struct device *dev)
 {
@@ -656,56 +354,22 @@ static int pccardd(void *__skt);
  * pcmcia_register_socket - add a new pcmcia socket device
  * @socket: the &socket to register
  */
-int pcmcia_register_socket(struct pcmcia_socket *socket)
+static int pcmcia_register_socket(struct pcmcia_socket *socket)
 {
 	struct task_struct *tsk;
+	static atomic_t sock;
 	int ret;
 
-	if (!socket || !socket->ops || !socket->dev.parent || !socket->resource_ops)
+	if (!socket || !socket->dev.parent)
 		return -EINVAL;
 
-	dev_dbg(&socket->dev, "pcmcia_register_socket(0x%p)\n", socket->ops);
-
-	/* try to obtain a socket number [yes, it gets ugly if we
-	 * register more than 2^sizeof(unsigned int) pcmcia
-	 * sockets... but the socket number is deprecated
-	 * anyways, so I don't care] */
-	down_write(&pcmcia_socket_list_rwsem);
-	if (list_empty(&pcmcia_socket_list))
-		socket->sock = 0;
-	else {
-		unsigned int found, i = 1;
-		struct pcmcia_socket *tmp;
-		do {
-			found = 1;
-			list_for_each_entry(tmp, &pcmcia_socket_list, socket_list) {
-				if (tmp->sock == i)
-					found = 0;
-			}
-			i++;
-		} while (!found);
-		socket->sock = i - 1;
-	}
-	list_add_tail(&socket->socket_list, &pcmcia_socket_list);
-	up_write(&pcmcia_socket_list_rwsem);
-
-#if !IS_ENABLED(CONFIG_CARDBUS)
-	/*
-	 * If we do not support Cardbus, ensure that
-	 * the Cardbus socket capability is disabled.
-	 */
-	socket->features &= ~SS_CAP_CARDBUS;
-#endif
+	socket->sock = atomic_fetch_inc(&sock);
 
 	/* set proper values in socket->dev */
 	dev_set_drvdata(&socket->dev, socket);
 	socket->dev.class = &pcmcia_socket_class;
 	dev_set_name(&socket->dev, "pcmcia_socket%u", socket->sock);
 
-	/* base address = 0, map = 0 */
-	socket->cis_mem.flags = 0;
-	socket->cis_mem.speed = cis_speed;
-
 	INIT_LIST_HEAD(&socket->cis_cache);
 
 	init_completion(&socket->socket_released);
@@ -714,13 +378,11 @@ int pcmcia_register_socket(struct pcmcia_socket *socket)
 	mutex_init(&socket->ops_mutex);
 	spin_lock_init(&socket->thread_lock);
 
-	if (socket->resource_ops->init) {
-		mutex_lock(&socket->ops_mutex);
-		ret = socket->resource_ops->init(socket);
-		mutex_unlock(&socket->ops_mutex);
-		if (ret)
-			goto err;
-	}
+	mutex_lock(&socket->ops_mutex);
+	ret = static_init(socket);
+	mutex_unlock(&socket->ops_mutex);
+	if (ret)
+		goto err;
 
 	tsk = kthread_run(pccardd, socket, "pccardd");
 	if (IS_ERR(tsk)) {
@@ -747,60 +409,23 @@ int pcmcia_register_socket(struct pcmcia_socket *socket)
 	return 0;
 
  err:
-	down_write(&pcmcia_socket_list_rwsem);
-	list_del(&socket->socket_list);
-	up_write(&pcmcia_socket_list_rwsem);
 	return ret;
 } /* pcmcia_register_socket */
-EXPORT_SYMBOL(pcmcia_register_socket);
-
 
 /**
  * pcmcia_unregister_socket - remove a pcmcia socket device
  * @socket: the &socket to unregister
  */
-void pcmcia_unregister_socket(struct pcmcia_socket *socket)
+static void pcmcia_unregister_socket(struct pcmcia_socket *socket)
 {
 	if (!socket)
 		return;
 
-	dev_dbg(&socket->dev, "pcmcia_unregister_socket(0x%p)\n", socket->ops);
-
 	if (socket->thread)
 		kthread_stop(socket->thread);
 
-	/* remove from our own list */
-	down_write(&pcmcia_socket_list_rwsem);
-	list_del(&socket->socket_list);
-	up_write(&pcmcia_socket_list_rwsem);
-
-	/* wait for sysfs to drop all references */
-	if (socket->resource_ops->exit) {
-		mutex_lock(&socket->ops_mutex);
-		socket->resource_ops->exit(socket);
-		mutex_unlock(&socket->ops_mutex);
-	}
 	wait_for_completion(&socket->socket_released);
 } /* pcmcia_unregister_socket */
-EXPORT_SYMBOL(pcmcia_unregister_socket);
-
-
-struct pcmcia_socket *pcmcia_get_socket_by_nr(unsigned int nr)
-{
-	struct pcmcia_socket *s;
-
-	down_read(&pcmcia_socket_list_rwsem);
-	list_for_each_entry(s, &pcmcia_socket_list, socket_list)
-		if (s->sock == nr) {
-			up_read(&pcmcia_socket_list_rwsem);
-			return s;
-		}
-	up_read(&pcmcia_socket_list_rwsem);
-
-	return NULL;
-
-}
-EXPORT_SYMBOL(pcmcia_get_socket_by_nr);
 
 static int socket_reset(struct pcmcia_socket *skt)
 {
@@ -809,15 +434,15 @@ static int socket_reset(struct pcmcia_socket *skt)
 	dev_dbg(&skt->dev, "reset\n");
 
 	skt->socket.flags |= SS_OUTPUT_ENA | SS_RESET;
-	skt->ops->set_socket(skt, &skt->socket);
+	yenta_set_socket(skt, &skt->socket);
 	udelay((long)reset_time);
 
 	skt->socket.flags &= ~SS_RESET;
-	skt->ops->set_socket(skt, &skt->socket);
+	yenta_set_socket(skt, &skt->socket);
 
 	msleep(unreset_delay * 10);
 	for (i = 0; i < unreset_limit; i++) {
-		skt->ops->get_status(skt, &status);
+		yenta_get_status(skt, &status);
 
 		if (!(status & SS_DETECT))
 			return -ENODEV;
@@ -844,9 +469,6 @@ static void socket_shutdown(struct pcmcia_socket *s)
 
 	dev_dbg(&s->dev, "shutdown\n");
 
-	if (s->callback)
-		s->callback->remove(s);
-
 	mutex_lock(&s->ops_mutex);
 	s->state &= SOCKET_INUSE | SOCKET_PRESENT;
 	msleep(shutdown_delay * 10);
@@ -854,9 +476,8 @@ static void socket_shutdown(struct pcmcia_socket *s)
 
 	/* Blank out the socket state */
 	s->socket = dead_socket;
-	s->ops->init(s);
-	s->ops->set_socket(s, &s->socket);
-	s->lock_count = 0;
+	yenta_sock_init(s);
+	yenta_set_socket(s, &s->socket);
 	kfree(s->fake_cis);
 	s->fake_cis = NULL;
 	s->functions = 0;
@@ -869,14 +490,12 @@ static void socket_shutdown(struct pcmcia_socket *s)
 	 */
 	mutex_unlock(&s->ops_mutex);
 
-#if IS_ENABLED(CONFIG_CARDBUS)
 	cb_free(s);
-#endif
 
 	/* give socket some time to power down */
 	msleep(100);
 
-	s->ops->get_status(s, &status);
+	yenta_get_status(s, &status);
 	if (status & SS_POWERON) {
 		dev_err(&s->dev,
 			"*** DANGER *** unable to remove socket power\n");
@@ -891,14 +510,14 @@ static int socket_setup(struct pcmcia_socket *skt, int initial_delay)
 
 	dev_dbg(&skt->dev, "setup\n");
 
-	skt->ops->get_status(skt, &status);
+	yenta_get_status(skt, &status);
 	if (!(status & SS_DETECT))
 		return -ENODEV;
 
 	msleep(initial_delay * 10);
 
 	for (i = 0; i < 100; i++) {
-		skt->ops->get_status(skt, &status);
+		yenta_get_status(skt, &status);
 		if (!(status & SS_DETECT))
 			return -ENODEV;
 
@@ -914,10 +533,6 @@ static int socket_setup(struct pcmcia_socket *skt, int initial_delay)
 	}
 
 	if (status & SS_CARDBUS) {
-		if (!(skt->features & SS_CAP_CARDBUS)) {
-			dev_err(&skt->dev, "cardbus cards are not supported\n");
-			return -EINVAL;
-		}
 		skt->state |= SOCKET_CARDBUS;
 	} else
 		skt->state &= ~SOCKET_CARDBUS;
@@ -938,14 +553,14 @@ static int socket_setup(struct pcmcia_socket *skt, int initial_delay)
 		skt->power_hook(skt, HOOK_POWER_PRE);
 
 	skt->socket.flags = 0;
-	skt->ops->set_socket(skt, &skt->socket);
+	yenta_set_socket(skt, &skt->socket);
 
 	/*
 	 * Wait "vcc_settle" for the supply to stabilise.
 	 */
 	msleep(vcc_settle * 10);
 
-	skt->ops->get_status(skt, &status);
+	yenta_get_status(skt, &status);
 	if (!(status & SS_POWERON)) {
 		dev_err(&skt->dev, "unable to apply power\n");
 		return -EIO;
@@ -984,17 +599,11 @@ static int socket_insert(struct pcmcia_socket *skt)
 			   (skt->state & SOCKET_CARDBUS) ? "CardBus" : "PCMCIA",
 			   skt->sock);
 
-#if IS_ENABLED(CONFIG_CARDBUS)
-		if (skt->state & SOCKET_CARDBUS) {
-			cb_alloc(skt);
-			skt->state |= SOCKET_CARDBUS_CONFIG;
-		}
-#endif
+		cb_alloc(skt);
+		skt->state |= SOCKET_CARDBUS_CONFIG;
+
 		dev_dbg(&skt->dev, "insert done\n");
 		mutex_unlock(&skt->ops_mutex);
-
-		if (!(skt->state & SOCKET_CARDBUS) && (skt->callback))
-			skt->callback->add(skt);
 	} else {
 		mutex_unlock(&skt->ops_mutex);
 		socket_shutdown(skt);
@@ -1014,9 +623,8 @@ static int socket_suspend(struct pcmcia_socket *skt)
 		skt->suspended_state = skt->state;
 
 	skt->socket = dead_socket;
-	skt->ops->set_socket(skt, &skt->socket);
-	if (skt->ops->suspend)
-		skt->ops->suspend(skt);
+	yenta_set_socket(skt, &skt->socket);
+	yenta_sock_suspend(skt);
 	skt->state |= SOCKET_SUSPEND;
 	skt->state &= ~SOCKET_IN_RESUME;
 	mutex_unlock(&skt->ops_mutex);
@@ -1027,8 +635,8 @@ static int socket_early_resume(struct pcmcia_socket *skt)
 {
 	mutex_lock(&skt->ops_mutex);
 	skt->socket = dead_socket;
-	skt->ops->init(skt);
-	skt->ops->set_socket(skt, &skt->socket);
+	yenta_sock_init(skt);
+	yenta_set_socket(skt, &skt->socket);
 	if (skt->state & SOCKET_PRESENT)
 		skt->resume_status = socket_setup(skt, resume_delay);
 	skt->state |= SOCKET_IN_RESUME;
@@ -1065,8 +673,6 @@ static int socket_late_resume(struct pcmcia_socket *skt)
 		return socket_insert(skt);
 	}
 
-	if (!(skt->state & SOCKET_CARDBUS) && (skt->callback))
-		ret = skt->callback->early_resume(skt);
 	return ret;
 }
 
@@ -1078,36 +684,16 @@ static int socket_late_resume(struct pcmcia_socket *skt)
 static int socket_complete_resume(struct pcmcia_socket *skt)
 {
 	int ret = 0;
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
 
-/*
- * Resume a socket.  If a card is present, verify its CIS against
- * our cached copy.  If they are different, the card has been
- * replaced, and we need to tell the drivers.
- */
-static int socket_resume(struct pcmcia_socket *skt)
-{
-	int err;
-	if (!(skt->state & SOCKET_SUSPEND))
-		return -EBUSY;
+	/* We can't be sure the CardBus card is the same
+	 * as the one previously inserted. Therefore, remove
+	 * and re-add... */
+	cb_free(skt);
+	ret = cb_alloc(skt);
+	if (ret)
+		cb_free(skt);
 
-	socket_early_resume(skt);
-	err = socket_late_resume(skt);
-	if (!err)
-		err = socket_complete_resume(skt);
-	return err;
+	return ret;
 }
 
 static void socket_remove(struct pcmcia_socket *skt)
@@ -1135,7 +721,7 @@ static void socket_detect_change(struct pcmcia_socket *skt)
 		if (!(skt->state & SOCKET_PRESENT))
 			msleep(20);
 
-		skt->ops->get_status(skt, &status);
+		yenta_get_status(skt, &status);
 		if ((skt->state & SOCKET_PRESENT) &&
 		     !(status & SS_DETECT))
 			socket_remove(skt);
@@ -1152,8 +738,8 @@ static int pccardd(void *__skt)
 
 	skt->thread = current;
 	skt->socket = dead_socket;
-	skt->ops->init(skt);
-	skt->ops->set_socket(skt, &skt->socket);
+	yenta_sock_init(skt);
+	yenta_set_socket(skt, &skt->socket);
 
 	/* register with the device core */
 	ret = device_register(&skt->dev);
@@ -1194,28 +780,6 @@ static int pccardd(void *__skt)
 				socket_remove(skt);
 			if (sysfs_events & PCMCIA_UEVENT_INSERT)
 				socket_insert(skt);
-			if ((sysfs_events & PCMCIA_UEVENT_SUSPEND) &&
-				!(skt->state & SOCKET_CARDBUS)) {
-				if (skt->callback)
-					ret = skt->callback->suspend(skt);
-				else
-					ret = 0;
-				if (!ret) {
-					socket_suspend(skt);
-					msleep(100);
-				}
-			}
-			if ((sysfs_events & PCMCIA_UEVENT_RESUME) &&
-				!(skt->state & SOCKET_CARDBUS)) {
-				ret = socket_resume(skt);
-				if (!ret && skt->callback)
-					skt->callback->resume(skt);
-			}
-			if ((sysfs_events & PCMCIA_UEVENT_REQUERY) &&
-				!(skt->state & SOCKET_CARDBUS)) {
-				if (!ret && skt->callback)
-					skt->callback->requery(skt);
-			}
 		}
 		mutex_unlock(&skt->skt_mutex);
 
@@ -1251,7 +815,7 @@ static int pccardd(void *__skt)
  * Yenta (at least) probes interrupts before registering the socket and
  * starting the handler thread.
  */
-void pcmcia_parse_events(struct pcmcia_socket *s, u_int events)
+static void pcmcia_parse_events(struct pcmcia_socket *s, u_int events)
 {
 	unsigned long flags;
 	dev_dbg(&s->dev, "parse_events: events %08x\n", events);
@@ -1263,7 +827,6 @@ void pcmcia_parse_events(struct pcmcia_socket *s, u_int events)
 		wake_up_process(s->thread);
 	}
 } /* pcmcia_parse_events */
-EXPORT_SYMBOL(pcmcia_parse_events);
 
 /**
  * pcmcia_parse_uevents() - tell pccardd to issue manual commands
@@ -1276,7 +839,7 @@ EXPORT_SYMBOL(pcmcia_parse_events);
  * PCMCIA_UEVENT_RESUME (for resume), PCMCIA_UEVENT_SUSPEND (for suspend)
  * and PCMCIA_UEVENT_REQUERY (for re-querying the PCMCIA card).
  */
-void pcmcia_parse_uevents(struct pcmcia_socket *s, u_int events)
+static void pcmcia_parse_uevents(struct pcmcia_socket *s, u_int events)
 {
 	unsigned long flags;
 	dev_dbg(&s->dev, "parse_uevents: events %08x\n", events);
@@ -1288,84 +851,12 @@ void pcmcia_parse_uevents(struct pcmcia_socket *s, u_int events)
 		wake_up_process(s->thread);
 	}
 }
-EXPORT_SYMBOL(pcmcia_parse_uevents);
-
-
-/* register pcmcia_callback */
-int pccard_register_pcmcia(struct pcmcia_socket *s, struct pcmcia_callback *c)
-{
-	int ret = 0;
-
-	/* s->skt_mutex also protects s->callback */
-	mutex_lock(&s->skt_mutex);
-
-	if (c) {
-		/* registration */
-		if (s->callback) {
-			ret = -EBUSY;
-			goto err;
-		}
-
-		s->callback = c;
-
-		if ((s->state & (SOCKET_PRESENT|SOCKET_CARDBUS)) == SOCKET_PRESENT)
-			s->callback->add(s);
-	} else
-		s->callback = NULL;
- err:
-	mutex_unlock(&s->skt_mutex);
-
-	return ret;
-}
-EXPORT_SYMBOL(pccard_register_pcmcia);
-
 
 /* I'm not sure which "reset" function this is supposed to use,
  * but for now, it uses the low-level interface's reset, not the
  * CIS register.
  */
 
-int pcmcia_reset_card(struct pcmcia_socket *skt)
-{
-	int ret;
-
-	dev_dbg(&skt->dev, "resetting socket\n");
-
-	mutex_lock(&skt->skt_mutex);
-	do {
-		if (!(skt->state & SOCKET_PRESENT)) {
-			dev_dbg(&skt->dev, "can't reset, not present\n");
-			ret = -ENODEV;
-			break;
-		}
-		if (skt->state & SOCKET_SUSPEND) {
-			dev_dbg(&skt->dev, "can't reset, suspended\n");
-			ret = -EBUSY;
-			break;
-		}
-		if (skt->state & SOCKET_CARDBUS) {
-			dev_dbg(&skt->dev, "can't reset, is cardbus\n");
-			ret = -EPERM;
-			break;
-		}
-
-		if (skt->callback)
-			skt->callback->suspend(skt);
-		mutex_lock(&skt->ops_mutex);
-		ret = socket_reset(skt);
-		mutex_unlock(&skt->ops_mutex);
-		if ((ret == 0) && (skt->callback))
-			skt->callback->resume(skt);
-
-		ret = 0;
-	} while (0);
-	mutex_unlock(&skt->skt_mutex);
-
-	return ret;
-} /* reset_card */
-EXPORT_SYMBOL(pcmcia_reset_card);
-
-
 static int pcmcia_socket_uevent(const struct device *dev,
 				struct kobj_uevent_env *env)
 {
@@ -1385,9 +876,6 @@ static void pcmcia_release_socket_class(struct class *data)
 	complete(&pcmcia_unload);
 }
 
-
-#ifdef CONFIG_PM
-
 static int __pcmcia_pm_op(struct device *dev,
 			  int (*callback) (struct pcmcia_socket *skt))
 {
@@ -1424,8 +912,7 @@ static void __used pcmcia_socket_dev_complete(struct device *dev)
 
 static const struct dev_pm_ops pcmcia_socket_pm_ops = {
 	/* dev_resume may be called with IRQs enabled */
-	SET_SYSTEM_SLEEP_PM_OPS(NULL,
-				pcmcia_socket_dev_resume)
+	SYSTEM_SLEEP_PM_OPS(NULL, pcmcia_socket_dev_resume)
 
 	/* late suspend must be called with IRQs disabled */
 	.suspend_noirq = pcmcia_socket_dev_suspend_noirq,
@@ -1439,49 +926,13 @@ static const struct dev_pm_ops pcmcia_socket_pm_ops = {
 	.complete = pcmcia_socket_dev_complete,
 };
 
-#define PCMCIA_SOCKET_CLASS_PM_OPS (&pcmcia_socket_pm_ops)
-
-#else /* CONFIG_PM */
-
-#define PCMCIA_SOCKET_CLASS_PM_OPS NULL
-
-#endif /* CONFIG_PM */
-
-struct class pcmcia_socket_class = {
+static struct class pcmcia_socket_class = {
 	.name = "pcmcia_socket",
 	.dev_uevent = pcmcia_socket_uevent,
 	.dev_release = pcmcia_release_socket,
 	.class_release = pcmcia_release_socket_class,
-	.pm = PCMCIA_SOCKET_CLASS_PM_OPS,
+	.pm = pm_ptr(&pcmcia_socket_pm_ops),
 };
-EXPORT_SYMBOL(pcmcia_socket_class);
-
-/*
- * socket_sysfs.c -- most of socket-related sysfs output
- *
- * (C) 2003 - 2004		Dominik Brodowski
- */
-
-#include <linux/module.h>
-#include <linux/moduleparam.h>
-#include <linux/init.h>
-#include <linux/kernel.h>
-#include <linux/string.h>
-#include <linux/major.h>
-#include <linux/errno.h>
-#include <linux/mm.h>
-#include <linux/interrupt.h>
-#include <linux/timer.h>
-#include <linux/ioport.h>
-#include <linux/delay.h>
-#include <linux/pm.h>
-#include <linux/device.h>
-#include <linux/mutex.h>
-#include <asm/irq.h>
-
-#include <pcmcia/ss.h>
-#include <pcmcia/cisreg.h>
-#include <pcmcia/ds.h>
 
 #define to_socket(_dev) container_of(_dev, struct pcmcia_socket, dev)
 
@@ -1492,9 +943,7 @@ static ssize_t pccard_show_type(struct device *dev, struct device_attribute *att
 
 	if (!(s->state & SOCKET_PRESENT))
 		return -ENODEV;
-	if (s->state & SOCKET_CARDBUS)
-		return sysfs_emit(buf, "32-bit\n");
-	return sysfs_emit(buf, "16-bit\n");
+	return sysfs_emit(buf, "32-bit\n");
 }
 static DEVICE_ATTR(card_type, 0444, pccard_show_type, NULL);
 
@@ -1672,43 +1121,16 @@ static const struct attribute_group socket_attrs = {
 	.attrs = pccard_socket_attributes,
 };
 
-int pccard_sysfs_add_socket(struct device *dev)
+static int pccard_sysfs_add_socket(struct device *dev)
 {
 	return sysfs_create_group(&dev->kobj, &socket_attrs);
 }
 
-void pccard_sysfs_remove_socket(struct device *dev)
+static void pccard_sysfs_remove_socket(struct device *dev)
 {
 	sysfs_remove_group(&dev->kobj, &socket_attrs);
 }
 
-/*
- * cardbus.c -- 16-bit PCMCIA core support
- *
- * The initial developer of the original code is David A. Hinds
- * <dahinds@users.sourceforge.net>.  Portions created by David A. Hinds
- * are Copyright (C) 1999 David A. Hinds.  All Rights Reserved.
- *
- * (C) 1999		David A. Hinds
- */
-
-/*
- * Cardbus handling has been re-written to be more of a PCI bridge thing,
- * and the PCI code basically does all the resource handling.
- *
- *		Linus, Jan 2000
- */
-
-
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/pci.h>
-
-#include <pcmcia/ss.h>
-#include <pcmcia/cistpl.h>
-
-#include "cs_internal.h"
-
 static void cardbus_config_irq_and_cls(struct pci_bus *bus, int irq)
 {
 	struct pci_dev *dev;
@@ -1746,7 +1168,7 @@ static void cardbus_config_irq_and_cls(struct pci_bus *bus, int irq)
  * cb_alloc() allocates the kernel data structures for a Cardbus device
  * and handles the lowest level PCI device setup issues.
  */
-int __ref cb_alloc(struct pcmcia_socket *s)
+static int __ref cb_alloc(struct pcmcia_socket *s)
 {
 	struct pci_bus *bus = s->cb_dev->subordinate;
 	struct pci_dev *dev;
@@ -1785,7 +1207,7 @@ int __ref cb_alloc(struct pcmcia_socket *s)
  *
  * cb_free() handles the lowest level PCI device cleanup.
  */
-void cb_free(struct pcmcia_socket *s)
+static void cb_free(struct pcmcia_socket *s)
 {
 	struct pci_dev *bridge, *dev, *tmp;
 	struct pci_bus *bus;
@@ -1807,25 +1229,7 @@ void cb_free(struct pcmcia_socket *s)
 
 }
 
-/*
- * rsrc_mgr.c -- Resource management routines and/or wrappers
- *
- * The initial developer of the original code is David A. Hinds
- * <dahinds@users.sourceforge.net>.  Portions created by David A. Hinds
- * are Copyright (C) 1999 David A. Hinds.  All Rights Reserved.
- *
- * (C) 1999		David A. Hinds
- */
-
-#include <linux/slab.h>
-#include <linux/module.h>
-#include <linux/kernel.h>
-
-#include <pcmcia/ss.h>
-#include <pcmcia/cistpl.h>
-#include "cs_internal.h"
-
-int static_init(struct pcmcia_socket *s)
+static int static_init(struct pcmcia_socket *s)
 {
 	/* the good thing about SS_CAP_STATIC_MAP sockets is
 	 * that they don't need a resource database */
@@ -1835,69 +1239,6 @@ int static_init(struct pcmcia_socket *s)
 	return 0;
 }
 
-struct resource *pcmcia_make_resource(resource_size_t start,
-					resource_size_t end,
-					unsigned long flags, const char *name)
-{
-	struct resource *res = kzalloc(sizeof(*res), GFP_KERNEL);
-
-	if (res) {
-		res->name = name;
-		res->start = start;
-		res->end = start + end - 1;
-		res->flags = flags;
-	}
-	return res;
-}
-
-static int static_find_io(struct pcmcia_socket *s, unsigned int attr,
-			unsigned int *base, unsigned int num,
-			unsigned int align, struct resource **parent)
-{
-	if (!s->io_offset)
-		return -EINVAL;
-	*base = s->io_offset | (*base & 0x0fff);
-	*parent = NULL;
-
-	return 0;
-}
-
-struct pccard_resource_ops pccard_static_ops = {
-	.validate_mem = NULL,
-	.find_io = static_find_io,
-	.find_mem = NULL,
-	.init = static_init,
-	.exit = NULL,
-};
-EXPORT_SYMBOL(pccard_static_ops);
-
-
-/*
- * Regular cardbus driver ("yenta_socket")
- *
- * (C) Copyright 1999, 2000 Linus Torvalds
- *
- * Changelog:
- * Aug 2002: Manfred Spraul <manfred@colorfullife.com>
- * 	Dynamically adjust the size of the bridge resource
- *
- * May 2003: Dominik Brodowski <linux@brodo.de>
- * 	Merge pci_socket.c and yenta.c into one file
- */
-#include <linux/init.h>
-#include <linux/pci.h>
-#include <linux/workqueue.h>
-#include <linux/interrupt.h>
-#include <linux/delay.h>
-#include <linux/module.h>
-#include <linux/io.h>
-#include <linux/slab.h>
-
-#include <pcmcia/ss.h>
-
-#include "i82365.h"
-#include "cs_internal.h"
-
 static bool disable_clkrun;
 module_param(disable_clkrun, bool, 0444);
 MODULE_PARM_DESC(disable_clkrun,
@@ -2111,59 +1452,8 @@ static int yenta_get_status(struct pcmcia_socket *sock, unsigned int *value)
 
 static void yenta_set_power(struct yenta_socket *socket, socket_state_t *state)
 {
-	/* some birdges require to use the ExCA registers to power 16bit cards */
-	if (!(cb_readl(socket, CB_SOCKET_STATE) & CB_CBCARD) &&
-	    (socket->flags & YENTA_16BIT_POWER_EXCA)) {
-		u8 reg, old;
-		reg = old = exca_readb(socket, I365_POWER);
-		reg &= ~(I365_VCC_MASK | I365_VPP1_MASK | I365_VPP2_MASK);
-
-		/* i82365SL-DF style */
-		if (socket->flags & YENTA_16BIT_POWER_DF) {
-			switch (state->Vcc) {
-			case 33:
-				reg |= I365_VCC_3V;
-				break;
-			case 50:
-				reg |= I365_VCC_5V;
-				break;
-			default:
-				reg = 0;
-				break;
-			}
-			switch (state->Vpp) {
-			case 33:
-			case 50:
-				reg |= I365_VPP1_5V;
-				break;
-			case 120:
-				reg |= I365_VPP1_12V;
-				break;
-			}
-		} else {
-			/* i82365SL-B style */
-			switch (state->Vcc) {
-			case 50:
-				reg |= I365_VCC_5V;
-				break;
-			default:
-				reg = 0;
-				break;
-			}
-			switch (state->Vpp) {
-			case 50:
-				reg |= I365_VPP1_5V | I365_VPP2_5V;
-				break;
-			case 120:
-				reg |= I365_VPP1_12V | I365_VPP2_12V;
-				break;
-			}
-		}
-
-		if (reg != old)
-			exca_writeb(socket, I365_POWER, reg);
-	} else {
-		u32 reg = 0;	/* CB_SC_STPCLK? */
+	if (cb_readl(socket, CB_SOCKET_STATE) & CB_CBCARD) {
+		u32 reg = 0;	/* CB_SC_STPCLK? */
 		switch (state->Vcc) {
 		case 33:
 			reg = CB_SC_VCC_3V;
@@ -2214,46 +1504,6 @@ static int yenta_set_socket(struct pcmcia_socket *sock, socket_state_t *state)
 			bridge |= CB_BRIDGE_INTR;
 		}
 		exca_writeb(socket, I365_INTCTL, intr);
-	}  else {
-		u8 reg;
-
-		reg = exca_readb(socket, I365_INTCTL) & (I365_RING_ENA | I365_INTR_ENA);
-		reg |= (state->flags & SS_RESET) ? 0 : I365_PC_RESET;
-		reg |= (state->flags & SS_IOCARD) ? I365_PC_IOCARD : 0;
-		if (state->io_irq != socket->dev->irq) {
-			reg |= state->io_irq;
-			bridge |= CB_BRIDGE_INTR;
-		}
-		exca_writeb(socket, I365_INTCTL, reg);
-
-		reg = exca_readb(socket, I365_POWER) & (I365_VCC_MASK|I365_VPP1_MASK);
-		reg |= I365_PWR_NORESET;
-		if (state->flags & SS_PWR_AUTO)
-			reg |= I365_PWR_AUTO;
-		if (state->flags & SS_OUTPUT_ENA)
-			reg |= I365_PWR_OUT;
-		if (exca_readb(socket, I365_POWER) != reg)
-			exca_writeb(socket, I365_POWER, reg);
-
-		/* CSC interrupt: no ISA irq for CSC */
-		reg = exca_readb(socket, I365_CSCINT);
-		reg &= I365_CSC_IRQ_MASK;
-		reg |= I365_CSC_DETECT;
-		if (state->flags & SS_IOCARD) {
-			if (state->csc_mask & SS_STSCHG)
-				reg |= I365_CSC_STSCHG;
-		} else {
-			if (state->csc_mask & SS_BATDEAD)
-				reg |= I365_CSC_BVD1;
-			if (state->csc_mask & SS_BATWARN)
-				reg |= I365_CSC_BVD2;
-			if (state->csc_mask & SS_READY)
-				reg |= I365_CSC_READY;
-		}
-		exca_writeb(socket, I365_CSCINT, reg);
-		exca_readb(socket, I365_CSC);
-		if (sock->zoom_video)
-			sock->zoom_video(sock, state->flags & SS_ZVCARD);
 	}
 	config_writew(socket, CB_BRIDGE_CONTROL, bridge);
 	/* Socket event mask: get card insert/remove events.. */
@@ -2689,16 +1939,6 @@ static void yenta_close(struct pci_dev *dev)
 	kfree(sock);
 }
 
-
-static struct pccard_operations yenta_socket_operations = {
-	.init			= yenta_sock_init,
-	.suspend		= yenta_sock_suspend,
-	.get_status		= yenta_get_status,
-	.set_socket		= yenta_set_socket,
-	.set_io_map		= yenta_set_io_map,
-	.set_mem_map		= yenta_set_mem_map,
-};
-
 #ifdef CONFIG_YENTA_TI
 /*
  * ti113x.h 1.16 1999/10/25 20:03:34
@@ -4435,13 +3675,8 @@ static int yenta_probe(struct pci_dev *dev, const struct pci_device_id *id)
 		return -ENOMEM;
 
 	/* prepare pcmcia_socket */
-	socket->socket.ops = &yenta_socket_operations;
-	socket->socket.resource_ops = &pccard_static_ops;
 	socket->socket.dev.parent = &dev->dev;
-	socket->socket.driver_data = socket;
 	socket->socket.owner = THIS_MODULE;
-	socket->socket.features = SS_CAP_PAGE_REGS | SS_CAP_PCCARD;
-	socket->socket.map_size = 0x1000;
 	socket->socket.cb_dev = dev;
 
 	/* prepare struct yenta_socket */
@@ -4514,8 +3749,6 @@ static int yenta_probe(struct pci_dev *dev, const struct pci_device_id *id)
 			 "no PCI IRQ, CardBus support disabled for this socket.\n");
 		dev_info(&dev->dev,
 			 "check your BIOS CardBus, BIOS IRQ or ACPI settings.\n");
-	} else {
-		socket->socket.features |= SS_CAP_CARDBUS;
 	}
 
 	/* Figure out what the dang thing can do for the PCMCIA layer... */
@@ -4559,7 +3792,6 @@ static int yenta_probe(struct pci_dev *dev, const struct pci_device_id *id)
 	return ret;
 }
 
-#ifdef CONFIG_PM_SLEEP
 static int yenta_dev_suspend_noirq(struct device *dev)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
@@ -4604,14 +3836,9 @@ static int yenta_dev_resume_noirq(struct device *dev)
 }
 
 static const struct dev_pm_ops yenta_pm_ops = {
-	SET_NOIRQ_SYSTEM_SLEEP_PM_OPS(yenta_dev_suspend_noirq, yenta_dev_resume_noirq)
+	NOIRQ_SYSTEM_SLEEP_PM_OPS(yenta_dev_suspend_noirq, yenta_dev_resume_noirq)
 };
 
-#define YENTA_PM_OPS	(&yenta_pm_ops)
-#else
-#define YENTA_PM_OPS	NULL
-#endif
-
 #define CB_ID(vend, dev, type)				\
 	{						\
 		.vendor		= vend,			\
@@ -4707,7 +3934,7 @@ static struct pci_driver yenta_cardbus_driver = {
 	.id_table	= yenta_table,
 	.probe		= yenta_probe,
 	.remove		= yenta_close,
-	.driver.pm	= YENTA_PM_OPS,
+	.driver.pm	= pm_sleep_ptr(&yenta_pm_ops),
 };
 
 static int __init yenta_init(void)
-- 
2.39.2

