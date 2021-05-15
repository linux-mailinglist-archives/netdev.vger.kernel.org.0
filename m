Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B7D8381B5A
	for <lists+netdev@lfdr.de>; Sun, 16 May 2021 00:14:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235260AbhEOWQC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 18:16:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:46862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235225AbhEOWPw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 15 May 2021 18:15:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CAD6760C3F;
        Sat, 15 May 2021 22:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621116879;
        bh=TnmI0Tt4l/vUEyEMDzwuUMGskOueZuQukAa7BRBP30s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IlFvjeb80LSGhLHhUUIaR2AXtzOXHignio44xj4m1q0sbRLQFOgeGN/rqT9pB0xDL
         QJ7K6C0MRZ5WupMlDlvHWHTZY8siuDkBUOH4rXjWe/KX9X63LibajFaVLZB3+ZRajd
         Pr91oPsxIOuwknHIxjPD7cnQ/XFmeEAa0c2ZpVx0BD6WJDGCqwUM+csBulslf7Lr+a
         1dzJoFLZJmki8YJSX4y344Fhk1lubir/ApATQWPSKKxqmX6YW7nEXyfLFnShy59RU7
         9N01cC/Nhoj+J+3C0RGPXxOZVo3oXrTrGpKSdVTwtCbomgL8zENFZ4jkCFp4c5nMWB
         wp81HbLvkANQQ==
From:   Arnd Bergmann <arnd@kernel.org>
To:     netdev@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "Maciej W. Rozycki" <macro@orcam.me.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sam Creasey <sammy@sammy.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Finn Thain <fthain@telegraphics.com.au>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        linux-kernel@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com
Subject: [RFC 03/13] [net-next] appletalk: ltpc: remove static probing
Date:   Sun, 16 May 2021 00:13:10 +0200
Message-Id: <20210515221320.1255291-4-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210515221320.1255291-1-arnd@kernel.org>
References: <20210515221320.1255291-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

This driver never relies on the netdev_boot_setup_check()
to get its configuration, so it can just as well do its
own probing all the time.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/Space.c          | 3 ---
 drivers/net/appletalk/ltpc.c | 7 ++-----
 include/net/Space.h          | 1 -
 3 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/net/Space.c b/drivers/net/Space.c
index df79e7370bcc..9196a26615cc 100644
--- a/drivers/net/Space.c
+++ b/drivers/net/Space.c
@@ -142,9 +142,6 @@ static int __init net_olddevs_init(void)
 	cops_probe(1);
 	cops_probe(2);
 #endif
-#ifdef CONFIG_LTPC
-	ltpc_probe();
-#endif
 
 	return 0;
 }
diff --git a/drivers/net/appletalk/ltpc.c b/drivers/net/appletalk/ltpc.c
index c6f73aa3700c..9e7d3c686561 100644
--- a/drivers/net/appletalk/ltpc.c
+++ b/drivers/net/appletalk/ltpc.c
@@ -1013,7 +1013,7 @@ static const struct net_device_ops ltpc_netdev = {
 	.ndo_set_rx_mode	= set_multicast_list,
 };
 
-struct net_device * __init ltpc_probe(void)
+static struct net_device * __init ltpc_probe(void)
 {
 	struct net_device *dev;
 	int err = -ENOMEM;
@@ -1219,12 +1219,10 @@ static int __init ltpc_setup(char *str)
 }
 
 __setup("ltpc=", ltpc_setup);
-#endif /* MODULE */
+#endif
 
 static struct net_device *dev_ltpc;
 
-#ifdef MODULE
-
 MODULE_LICENSE("GPL");
 module_param(debug, int, 0);
 module_param_hw(io, int, ioport, 0);
@@ -1242,7 +1240,6 @@ static int __init ltpc_module_init(void)
 	return PTR_ERR_OR_ZERO(dev_ltpc);
 }
 module_init(ltpc_module_init);
-#endif
 
 static void __exit ltpc_cleanup(void)
 {
diff --git a/include/net/Space.h b/include/net/Space.h
index 9cce0d80d37a..e30e7a70ea99 100644
--- a/include/net/Space.h
+++ b/include/net/Space.h
@@ -21,7 +21,6 @@ struct net_device *mvme147lance_probe(int unit);
 struct net_device *tc515_probe(int unit);
 struct net_device *lance_probe(int unit);
 struct net_device *cops_probe(int unit);
-struct net_device *ltpc_probe(void);
 
 /* Fibre Channel adapters */
 int iph5526_probe(struct net_device *dev);
-- 
2.29.2

