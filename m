Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE8952795F0
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 03:19:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729789AbgIZBTR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 21:19:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:54410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729426AbgIZBTR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 21:19:17 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4747B2075A;
        Sat, 26 Sep 2020 01:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601083157;
        bh=2/bWv3kAfB2DfSCixFNeo5ou48IDOOHnRwIYsroxzuE=;
        h=From:To:Cc:Subject:Date:From;
        b=sWjsorVdZ8v+c4npBUOXEc4/t950p2wh5qG8OSuoOsT7OHSEKPGy8pYN1puv0AIv+
         KNQ95czpY02vgOSb2s5lPlJ5E6gVwbhN6F1SsIAHW106+uXiIrsde4SHMNWQ13tjV0
         c5v/xpRHzxYd/8zkkrlO7rP3//p1WXUgFzoG56F4=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] netdevsim: fix duplicated debugfs directory
Date:   Fri, 25 Sep 2020 18:19:13 -0700
Message-Id: <20200926011913.3324120-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The "ethtool" debugfs directory holds per-netdev knobs, so move
it from the device instance directory to the port directory.

This fixes the following warning when creating multiple ports:

 debugfs: Directory 'ethtool' with parent 'netdevsim1' already present!

Fixes: ff1f7c17fb20 ("netdevsim: add pause frame stats")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/netdevsim/ethtool.c                                | 2 +-
 tools/testing/selftests/drivers/net/netdevsim/ethtool-pause.sh | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/netdevsim/ethtool.c b/drivers/net/netdevsim/ethtool.c
index 7a4c779b4c89..f1884d90a876 100644
--- a/drivers/net/netdevsim/ethtool.c
+++ b/drivers/net/netdevsim/ethtool.c
@@ -54,7 +54,7 @@ void nsim_ethtool_init(struct netdevsim *ns)
 
 	ns->netdev->ethtool_ops = &nsim_ethtool_ops;
 
-	ethtool = debugfs_create_dir("ethtool", ns->nsim_dev->ddir);
+	ethtool = debugfs_create_dir("ethtool", ns->nsim_dev_port->ddir);
 
 	dir = debugfs_create_dir("pause", ethtool);
 	debugfs_create_bool("report_stats_rx", 0600, dir,
diff --git a/tools/testing/selftests/drivers/net/netdevsim/ethtool-pause.sh b/tools/testing/selftests/drivers/net/netdevsim/ethtool-pause.sh
index dd6ad6501c9c..25c896b9e2eb 100755
--- a/tools/testing/selftests/drivers/net/netdevsim/ethtool-pause.sh
+++ b/tools/testing/selftests/drivers/net/netdevsim/ethtool-pause.sh
@@ -3,7 +3,7 @@
 
 NSIM_ID=$((RANDOM % 1024))
 NSIM_DEV_SYS=/sys/bus/netdevsim/devices/netdevsim$NSIM_ID
-NSIM_DEV_DFS=/sys/kernel/debug/netdevsim/netdevsim$NSIM_ID
+NSIM_DEV_DFS=/sys/kernel/debug/netdevsim/netdevsim$NSIM_ID/ports/0
 NSIM_NETDEV=
 num_passes=0
 num_errors=0
-- 
2.26.2

