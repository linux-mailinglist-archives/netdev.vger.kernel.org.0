Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14DF03DEC79
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 13:42:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236179AbhHCLmr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 07:42:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:34162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235998AbhHCLmP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 07:42:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8275460F11;
        Tue,  3 Aug 2021 11:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627990924;
        bh=sdY6MzvWnzAhWx6g0YoZjzNCW4W6FHBWO7eaWNLdiWo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=baTupv6mnYRxt1IMN9/t8+Zgk2UQaUxJZ8bAD1HgoSS5g8Omas8+4eCj8kzTzGuEM
         FHRdGdDINy5lipBha+wPvVGQaMevfnCi4BezcvC71ZMHgtAHSyPjQzm9fcuFC9n0RU
         JOaM8vL6SY3h7Km3ZLMlYp/QH5zizQ9N5XrHd3JdykyCNf4907tPiITqUShcfIEjCU
         r0Qh4XyA7IgdeRQx3oE/nQFjDz08cfOmZzCiHUokEEkvy6yu+Sc1ZptciJV/DD3R1y
         XoqwdCI6hEgsspSIUHXKlNu/71GIJVm3eZq1wQrs+8pugX1rtlgUYuiLzG6nYIBSQc
         woVDxUibDts5A==
From:   Arnd Bergmann <arnd@kernel.org>
To:     netdev@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        "Maciej W. Rozycki" <macro@orcam.me.uk>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>, Andrii Nakryiko <andriin@fb.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Doug Berger <opendmb@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Finn Thain <fthain@telegraphics.com.au>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Jakub Kicinski <kuba@kernel.org>, Jessica Yu <jeyu@kernel.org>,
        Michael Schmitz <schmitzmic@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Sam Creasey <sammy@sammy.net>, linux-kernel@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com
Subject: [PATCH v2 14/14] [net-next] ethernet: isa: convert to module_init/module_exit
Date:   Tue,  3 Aug 2021 13:40:51 +0200
Message-Id: <20210803114051.2112986-15-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210803114051.2112986-1-arnd@kernel.org>
References: <20210803114051.2112986-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

There are a couple of ISA ethernet drivers that use the old
init_module/cleanup_module function names for the main entry
points, nothing else uses those any more.

Change them to the documented method with module_init()
and module_exit() markers next to static functions.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ethernet/3com/3c515.c     | 3 ++-
 drivers/net/ethernet/8390/ne.c        | 3 ++-
 drivers/net/ethernet/8390/smc-ultra.c | 9 ++++-----
 drivers/net/ethernet/8390/wd.c        | 7 ++++---
 drivers/net/ethernet/amd/lance.c      | 6 ++++--
 drivers/net/ethernet/amd/ni65.c       | 6 ++++--
 drivers/net/ethernet/cirrus/cs89x0.c  | 7 ++++---
 drivers/net/ethernet/smsc/smc9194.c   | 6 ++++--
 8 files changed, 28 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/3com/3c515.c b/drivers/net/ethernet/3com/3c515.c
index 47b4215bb93b..8d90fed5d33e 100644
--- a/drivers/net/ethernet/3com/3c515.c
+++ b/drivers/net/ethernet/3com/3c515.c
@@ -407,7 +407,7 @@ MODULE_PARM_DESC(max_interrupt_work, "3c515 maximum events handled per interrupt
 /* we will need locking (and refcounting) if we ever use it for more */
 static LIST_HEAD(root_corkscrew_dev);
 
-int init_module(void)
+static int corkscrew_init_module(void)
 {
 	int found = 0;
 	if (debug >= 0)
@@ -416,6 +416,7 @@ int init_module(void)
 		found++;
 	return found ? 0 : -ENODEV;
 }
+module_init(corkscrew_init_module);
 
 #else
 struct net_device *tc515_probe(int unit)
diff --git a/drivers/net/ethernet/8390/ne.c b/drivers/net/ethernet/8390/ne.c
index d0bbe2180b9e..53660bc8d6ff 100644
--- a/drivers/net/ethernet/8390/ne.c
+++ b/drivers/net/ethernet/8390/ne.c
@@ -923,7 +923,7 @@ static void __init ne_add_devices(void)
 }
 
 #ifdef MODULE
-int __init init_module(void)
+static int __init ne_init(void)
 {
 	int retval;
 	ne_add_devices();
@@ -940,6 +940,7 @@ int __init init_module(void)
 	ne_loop_rm_unreg(0);
 	return retval;
 }
+module_init(ne_init);
 #else /* MODULE */
 static int __init ne_init(void)
 {
diff --git a/drivers/net/ethernet/8390/smc-ultra.c b/drivers/net/ethernet/8390/smc-ultra.c
index 1d8ed7357b7f..0890fa493f70 100644
--- a/drivers/net/ethernet/8390/smc-ultra.c
+++ b/drivers/net/ethernet/8390/smc-ultra.c
@@ -522,7 +522,6 @@ static void ultra_pio_input(struct net_device *dev, int count,
 	/* We know skbuffs are padded to at least word alignment. */
 	insw(ioaddr + IOPD, buf, (count+1)>>1);
 }
-
 static void ultra_pio_output(struct net_device *dev, int count,
 							const unsigned char *buf, const int start_page)
 {
@@ -572,8 +571,7 @@ MODULE_LICENSE("GPL");
 
 /* This is set up so that only a single autoprobe takes place per call.
 ISA device autoprobes on a running machine are not recommended. */
-int __init
-init_module(void)
+static int __init ultra_init_module(void)
 {
 	struct net_device *dev;
 	int this_dev, found = 0;
@@ -600,6 +598,7 @@ init_module(void)
 		return 0;
 	return -ENXIO;
 }
+module_init(ultra_init_module);
 
 static void cleanup_card(struct net_device *dev)
 {
@@ -613,8 +612,7 @@ static void cleanup_card(struct net_device *dev)
 	iounmap(ei_status.mem);
 }
 
-void __exit
-cleanup_module(void)
+static void __exit ultra_cleanup_module(void)
 {
 	int this_dev;
 
@@ -627,4 +625,5 @@ cleanup_module(void)
 		}
 	}
 }
+module_exit(ultra_cleanup_module);
 #endif /* MODULE */
diff --git a/drivers/net/ethernet/8390/wd.c b/drivers/net/ethernet/8390/wd.c
index c834123560f1..263a942d81fa 100644
--- a/drivers/net/ethernet/8390/wd.c
+++ b/drivers/net/ethernet/8390/wd.c
@@ -519,7 +519,7 @@ MODULE_LICENSE("GPL");
 /* This is set up so that only a single autoprobe takes place per call.
 ISA device autoprobes on a running machine are not recommended. */
 
-int __init init_module(void)
+static int __init wd_init_module(void)
 {
 	struct net_device *dev;
 	int this_dev, found = 0;
@@ -548,6 +548,7 @@ int __init init_module(void)
 		return 0;
 	return -ENXIO;
 }
+module_init(wd_init_module);
 
 static void cleanup_card(struct net_device *dev)
 {
@@ -556,8 +557,7 @@ static void cleanup_card(struct net_device *dev)
 	iounmap(ei_status.mem);
 }
 
-void __exit
-cleanup_module(void)
+static void __exit wd_cleanup_module(void)
 {
 	int this_dev;
 
@@ -570,4 +570,5 @@ cleanup_module(void)
 		}
 	}
 }
+module_exit(wd_cleanup_module);
 #endif /* MODULE */
diff --git a/drivers/net/ethernet/amd/lance.c b/drivers/net/ethernet/amd/lance.c
index 2178e6b89dbd..945bf1d87507 100644
--- a/drivers/net/ethernet/amd/lance.c
+++ b/drivers/net/ethernet/amd/lance.c
@@ -327,7 +327,7 @@ MODULE_PARM_DESC(dma, "LANCE/PCnet ISA DMA channel (ignored for some devices)");
 MODULE_PARM_DESC(irq, "LANCE/PCnet IRQ number (ignored for some devices)");
 MODULE_PARM_DESC(lance_debug, "LANCE/PCnet debug level (0-7)");
 
-int __init init_module(void)
+static int __init lance_init_module(void)
 {
 	struct net_device *dev;
 	int this_dev, found = 0;
@@ -356,6 +356,7 @@ int __init init_module(void)
 		return 0;
 	return -ENXIO;
 }
+module_init(lance_init_module);
 
 static void cleanup_card(struct net_device *dev)
 {
@@ -368,7 +369,7 @@ static void cleanup_card(struct net_device *dev)
 	kfree(lp);
 }
 
-void __exit cleanup_module(void)
+static void __exit lance_cleanup_module(void)
 {
 	int this_dev;
 
@@ -381,6 +382,7 @@ void __exit cleanup_module(void)
 		}
 	}
 }
+module_exit(lance_cleanup_module);
 #endif /* MODULE */
 MODULE_LICENSE("GPL");
 
diff --git a/drivers/net/ethernet/amd/ni65.c b/drivers/net/ethernet/amd/ni65.c
index 5c1cfb0c4a42..b5df7ad5a83f 100644
--- a/drivers/net/ethernet/amd/ni65.c
+++ b/drivers/net/ethernet/amd/ni65.c
@@ -1230,18 +1230,20 @@ MODULE_PARM_DESC(irq, "ni6510 IRQ number (ignored for some cards)");
 MODULE_PARM_DESC(io, "ni6510 I/O base address");
 MODULE_PARM_DESC(dma, "ni6510 ISA DMA channel (ignored for some cards)");
 
-int __init init_module(void)
+static int __init ni65_init_module(void)
 {
 	dev_ni65 = ni65_probe(-1);
 	return PTR_ERR_OR_ZERO(dev_ni65);
 }
+module_init(ni65_init_module);
 
-void __exit cleanup_module(void)
+static void __exit ni65_cleanup_module(void)
 {
 	unregister_netdev(dev_ni65);
 	cleanup_card(dev_ni65);
 	free_netdev(dev_ni65);
 }
+module_exit(ni65_cleanup_module);
 #endif /* MODULE */
 
 MODULE_LICENSE("GPL");
diff --git a/drivers/net/ethernet/cirrus/cs89x0.c b/drivers/net/ethernet/cirrus/cs89x0.c
index 3b08cd943b7b..d0c4c8b7a15a 100644
--- a/drivers/net/ethernet/cirrus/cs89x0.c
+++ b/drivers/net/ethernet/cirrus/cs89x0.c
@@ -1753,7 +1753,7 @@ MODULE_LICENSE("GPL");
  * (hw or software util)
  */
 
-int __init init_module(void)
+static int __init cs89x0_isa_init_module(void)
 {
 	struct net_device *dev;
 	struct net_local *lp;
@@ -1823,9 +1823,9 @@ int __init init_module(void)
 	free_netdev(dev);
 	return ret;
 }
+module_init(cs89x0_isa_init_module);
 
-void __exit
-cleanup_module(void)
+static void __exit cs89x0_isa_cleanup_module(void)
 {
 	struct net_local *lp = netdev_priv(dev_cs89x0);
 
@@ -1835,6 +1835,7 @@ cleanup_module(void)
 	release_region(dev_cs89x0->base_addr, NETCARD_IO_EXTENT);
 	free_netdev(dev_cs89x0);
 }
+module_exit(cs89x0_isa_cleanup_module);
 #endif /* MODULE */
 #endif /* CONFIG_CS89x0_ISA */
 
diff --git a/drivers/net/ethernet/smsc/smc9194.c b/drivers/net/ethernet/smsc/smc9194.c
index bf7c8c8b1350..0ce403fa5f1a 100644
--- a/drivers/net/ethernet/smsc/smc9194.c
+++ b/drivers/net/ethernet/smsc/smc9194.c
@@ -1508,7 +1508,7 @@ MODULE_PARM_DESC(io, "SMC 99194 I/O base address");
 MODULE_PARM_DESC(irq, "SMC 99194 IRQ number");
 MODULE_PARM_DESC(ifport, "SMC 99194 interface port (0-default, 1-TP, 2-AUI)");
 
-int __init init_module(void)
+static int __init smc_init_module(void)
 {
 	if (io == 0)
 		printk(KERN_WARNING
@@ -1518,13 +1518,15 @@ int __init init_module(void)
 	devSMC9194 = smc_init(-1);
 	return PTR_ERR_OR_ZERO(devSMC9194);
 }
+module_init(smc_init_module);
 
-void __exit cleanup_module(void)
+static void __exit smc_cleanup_module(void)
 {
 	unregister_netdev(devSMC9194);
 	free_irq(devSMC9194->irq, devSMC9194);
 	release_region(devSMC9194->base_addr, SMC_IO_EXTENT);
 	free_netdev(devSMC9194);
 }
+module_exit(smc_cleanup_module);
 
 #endif /* MODULE */
-- 
2.29.2

