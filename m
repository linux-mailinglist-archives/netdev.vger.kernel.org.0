Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CBD2434F76
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 17:56:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231201AbhJTP6w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 11:58:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:34488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230510AbhJTP6l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 11:58:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 750AD613A0;
        Wed, 20 Oct 2021 15:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634745386;
        bh=K8IIQzRrXwqKD/fneGJaop/PWBAqXpOUhyRz0OJY0Ac=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dg6rHSXkkKKPTFemKP0WW5AHxlIqesSWSurLvSKupWPMdyjb/QWmmP8oMu85XpmeC
         bHaWccGO1c6bWkqsGOt+s99hwggZTgXABaCstAFlMMQxI6IoE2kmyhrxD2f3NvX6gl
         CEWywN3zz7ImTozJLu8uXErW/nk+sHAtfCmZeMahlXaZvj3lynHvy+AMNh27j3G9mg
         Uvp14FauR8S9ngXrNRk9KCAAhnuTCFUlxxhVymppKUCVSiCy6NqEeZwvkkx5lRRKIM
         wF2CtThyOL9zYSN1cJK/VpzEIt8++I93hHxktpQVOKHw8WByNHKU0zThKoNar76p9D
         vBzIhnxWhYPlA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 06/12] fddi: skfp: constify and use dev_addr_set()
Date:   Wed, 20 Oct 2021 08:56:11 -0700
Message-Id: <20211020155617.1721694-7-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211020155617.1721694-1-kuba@kernel.org>
References: <20211020155617.1721694-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Get it ready for constant netdev->dev_addr.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/fddi/skfp/h/smc.h   | 2 +-
 drivers/net/fddi/skfp/skfddi.c  | 2 +-
 drivers/net/fddi/skfp/smtinit.c | 4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/fddi/skfp/h/smc.h b/drivers/net/fddi/skfp/h/smc.h
index 3814a2ff64ae..b0e6ce0d893e 100644
--- a/drivers/net/fddi/skfp/h/smc.h
+++ b/drivers/net/fddi/skfp/h/smc.h
@@ -470,7 +470,7 @@ void card_stop(struct s_smc *smc);
 void init_board(struct s_smc *smc, u_char *mac_addr);
 int init_fplus(struct s_smc *smc);
 void init_plc(struct s_smc *smc);
-int init_smt(struct s_smc *smc, u_char *mac_addr);
+int init_smt(struct s_smc *smc, const u_char *mac_addr);
 void mac1_irq(struct s_smc *smc, u_short stu, u_short stl);
 void mac2_irq(struct s_smc *smc, u_short code_s2u, u_short code_s2l);
 void mac3_irq(struct s_smc *smc, u_short code_s3u, u_short code_s3l);
diff --git a/drivers/net/fddi/skfp/skfddi.c b/drivers/net/fddi/skfp/skfddi.c
index 652cb174302e..2b6a607ac0b7 100644
--- a/drivers/net/fddi/skfp/skfddi.c
+++ b/drivers/net/fddi/skfp/skfddi.c
@@ -925,7 +925,7 @@ static int skfp_ctl_set_mac_address(struct net_device *dev, void *addr)
 	unsigned long Flags;
 
 
-	memcpy(dev->dev_addr, p_sockaddr->sa_data, FDDI_K_ALEN);
+	dev_addr_set(dev, p_sockaddr->sa_data);
 	spin_lock_irqsave(&bp->DriverLock, Flags);
 	ResetAdapter(smc);
 	spin_unlock_irqrestore(&bp->DriverLock, Flags);
diff --git a/drivers/net/fddi/skfp/smtinit.c b/drivers/net/fddi/skfp/smtinit.c
index c9898c83fe30..8b172c195685 100644
--- a/drivers/net/fddi/skfp/smtinit.c
+++ b/drivers/net/fddi/skfp/smtinit.c
@@ -19,7 +19,7 @@
 #include "h/fddi.h"
 #include "h/smc.h"
 
-void init_fddi_driver(struct s_smc *smc, u_char *mac_addr);
+void init_fddi_driver(struct s_smc *smc, const u_char *mac_addr);
 
 /* define global debug variable */
 #if defined(DEBUG) && !defined(DEBUG_BRD)
@@ -57,7 +57,7 @@ static void set_oem_spec_val(struct s_smc *smc)
 /*
  * Init SMT
  */
-int init_smt(struct s_smc *smc, u_char *mac_addr)
+int init_smt(struct s_smc *smc, const u_char *mac_addr)
 /* u_char *mac_addr;	canonical address or NULL */
 {
 	int	p ;
-- 
2.31.1

