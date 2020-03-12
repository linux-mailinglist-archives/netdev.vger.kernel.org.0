Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB89A182876
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 06:35:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387836AbgCLFfU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 01:35:20 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:40247 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387776AbgCLFfU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 01:35:20 -0400
Received: by mail-pg1-f193.google.com with SMTP id t24so2463889pgj.7;
        Wed, 11 Mar 2020 22:35:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=stwA2atqbUCSZq4KpX2D3kb+kLw99koUYCFDWaQWTYY=;
        b=c+2LTb9+TDoWjVsOSzRYQ/GyJ1SnMYpWlrLYXSWHaxOmgsyMloLr1rt+u9HTJLx696
         QSofxKcuxrOK9U7YS2yroW3NSx+k6NnfHfC+4L16s9iIwm1cXNpyBPDBv1qSEzY9rs+1
         6FzxzrSUg8gnMZMB/N0U3Z90XGfA0aAEXeaZJnIV7vQdZfTxiFqVdPuJeVzHN1Zfd3z3
         b4FGqqzXT9PXwsrwSautOzff+x30/DveyJMOXNCkUCbbgv94Gs0A8TjoOfUKdt5tX+AW
         /zATJfg6b6ZPl0Cl7NnlwiLnvIMvIU8nGtjsWuw7uq8V7HOc/cnk3DhgprJrH09Dxfo8
         KY1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=stwA2atqbUCSZq4KpX2D3kb+kLw99koUYCFDWaQWTYY=;
        b=Gaa/IikZNhezViODfy0Fn0Hk98bpe+sgT0f6SHFMESyIVhFx/79CLD+4FnZzrRljvr
         lfmSMCgfCIKVkNIceECQDqI17ZBvjCtqF9SH9CGP6NRtNRmWV3kC7rwM/bbpo4EupGf0
         iz7a4l6JlWYAbR64Ch9W8H1wKOsEDDB8Bg1gtT6fyktE30NxHKRfbkPWxCzEN4V2hXnI
         SiFBluMu7TUek24FIdGcYJ+PeGEnUC7JyxXp8Lx3cQoLhjewqShVFYkV5+wiE4oeyvxG
         ie6K/DNXFarolcFGqbm0wq5OF8la+k3Ia6FoV9f8TA4VBbKj97ALRriGThc+RZS2VRXG
         nsXw==
X-Gm-Message-State: ANhLgQ1LHUpaI1ym8951XDzH28I30FK5TTtzaH8C5b4VGnUoJ//R0Ax3
        LqdRa9eMebP/GSxC2MRtpmU=
X-Google-Smtp-Source: ADFU+vtGhEmB7fIfL1kzxqIYJIrliTlHfxflxUGtKE7RGVusYuXarENOJ/ZHyPaZy07TXdfhvk0RcA==
X-Received: by 2002:a62:1909:: with SMTP id 9mr6362078pfz.196.1583991318416;
        Wed, 11 Mar 2020 22:35:18 -0700 (PDT)
Received: from localhost.localdomain ([103.87.57.89])
        by smtp.gmail.com with ESMTPSA id mp5sm7095820pjb.48.2020.03.11.22.35.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2020 22:35:17 -0700 (PDT)
From:   Amol Grover <frextrite@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Fontana <rfontana@redhat.com>,
        Allison Randal <allison@lohutok.net>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Joel Fernandes <joel@joelfernandes.org>,
        Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>,
        "Paul E . Mckenney" <paulmck@kernel.org>,
        Amol Grover <frextrite@gmail.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH] net: caif: Add lockdep expression to RCU traversal primitive
Date:   Thu, 12 Mar 2020 11:04:20 +0530
Message-Id: <20200312053419.12258-1-frextrite@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

caifdevs->list is traversed using list_for_each_entry_rcu()
outside an RCU read-side critical section but under the
protection of rtnl_mutex. Hence, add the corresponding lockdep
expression to silence the following false-positive warning:

[   10.868467] =============================
[   10.869082] WARNING: suspicious RCU usage
[   10.869817] 5.6.0-rc1-00177-g06ec0a154aae4 #1 Not tainted
[   10.870804] -----------------------------
[   10.871557] net/caif/caif_dev.c:115 RCU-list traversed in non-reader section!!

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Amol Grover <frextrite@gmail.com>
---
 net/caif/caif_dev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/caif/caif_dev.c b/net/caif/caif_dev.c
index 03c7cdd8e4cb..195d2d67be8a 100644
--- a/net/caif/caif_dev.c
+++ b/net/caif/caif_dev.c
@@ -112,7 +112,8 @@ static struct caif_device_entry *caif_get(struct net_device *dev)
 	    caif_device_list(dev_net(dev));
 	struct caif_device_entry *caifd;
 
-	list_for_each_entry_rcu(caifd, &caifdevs->list, list) {
+	list_for_each_entry_rcu(caifd, &caifdevs->list, list,
+				lockdep_rtnl_is_held()) {
 		if (caifd->netdev == dev)
 			return caifd;
 	}
-- 
2.25.1

