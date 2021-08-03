Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A8243DEC5C
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 13:41:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235917AbhHCLlg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 07:41:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:33102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235822AbhHCLla (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 07:41:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B62F760EE9;
        Tue,  3 Aug 2021 11:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627990879;
        bh=EktyPkSuaAP0S36bgMFYvE7c9bgTYUSVl2hmFxoFvX4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qP4VKlcdB1bL9zPKWEAyKy3oGDCm5QSw+zS2Byi/JgheEoW21WACjc39OBVxnKckF
         5KlaUkWa9ZmlbfONtYKC4ThiWEVjAtoRnvOTb5DmPJp4mE4uwc7Id/f/4Hlolk327T
         wcZ+chEtX+sYdaDMez3kTQTqnCYpV4P/sL7nd8SY/toAVkDJ9tLt/nEbbX+vqBOg2o
         54hjKSDBiujjU8wQkxaBQThNRweNxyeY9hXFGFTdWBMp5lKRrHVcOfQmM/10rc6eQc
         Af1StTOShmALtmkoWJDdd351AW391iUckF877+PtQK7RIdRY+GGCmTBIA4HxarAL4e
         Z4Qtw55gtg/Bg==
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
Subject: [PATCH v2 03/14] [net-next] appletalk: ltpc: remove static probing
Date:   Tue,  3 Aug 2021 13:40:40 +0200
Message-Id: <20210803114051.2112986-4-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210803114051.2112986-1-arnd@kernel.org>
References: <20210803114051.2112986-1-arnd@kernel.org>
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
index 69c270885ff0..1f8925e75b3f 100644
--- a/drivers/net/appletalk/ltpc.c
+++ b/drivers/net/appletalk/ltpc.c
@@ -1015,7 +1015,7 @@ static const struct net_device_ops ltpc_netdev = {
 	.ndo_set_rx_mode	= set_multicast_list,
 };
 
-struct net_device * __init ltpc_probe(void)
+static struct net_device * __init ltpc_probe(void)
 {
 	struct net_device *dev;
 	int err = -ENOMEM;
@@ -1221,12 +1221,10 @@ static int __init ltpc_setup(char *str)
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
@@ -1244,7 +1242,6 @@ static int __init ltpc_module_init(void)
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

