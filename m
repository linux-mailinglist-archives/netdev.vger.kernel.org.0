Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E3C222E249
	for <lists+netdev@lfdr.de>; Sun, 26 Jul 2020 21:38:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727886AbgGZTiA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jul 2020 15:38:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:34678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726244AbgGZTh7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Jul 2020 15:37:59 -0400
Received: from lx-ilial.mea.qualcomm.com (unknown [185.23.60.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AEEB0206D8;
        Sun, 26 Jul 2020 19:37:56 +0000 (UTC)
From:   Ilia Lin <ilial@codeaurora.org>
To:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        edumazet@google.com, ap420073@gmail.com, xiyou.wangcong@gmail.com,
        maximmi@mellanox.com, ilia.lin@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: dev: Add API to check net_dev readiness
Date:   Sun, 26 Jul 2020 22:37:54 +0300
Message-Id: <1595792274-28580-1-git-send-email-ilial@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ilia Lin <ilia.lin@kernel.org>

Add an API that returns true, if the net_dev_init was already called,
and the driver was initialized.

Some early drivers, that are initialized during the subsys_initcall
may try accessing the net_dev or NAPI APIs before the net_dev_init,
and will encounter a kernel bug. This API provides a way to handle
this and manage by deferring or by other way.

Signed-off-by: Ilia Lin <ilia.lin@kernel.org>
---
 include/linux/netdevice.h |  2 ++
 net/core/dev.c            | 17 +++++++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 98d290c..d17d364 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2600,6 +2600,8 @@ enum netdev_cmd {
 };
 const char *netdev_cmd_to_name(enum netdev_cmd cmd);
 
+bool is_net_dev_initialized(void);
+
 int register_netdevice_notifier(struct notifier_block *nb);
 int unregister_netdevice_notifier(struct notifier_block *nb);
 int register_netdevice_notifier_net(struct net *net, struct notifier_block *nb);
diff --git a/net/core/dev.c b/net/core/dev.c
index 316349f..1b50488 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1793,6 +1793,23 @@ static void call_netdevice_unregister_net_notifiers(struct notifier_block *nb,
 static int dev_boot_phase = 1;
 
 /**
+ * is_net_dev_initialized - check, whether the net_dev was
+ * initialized
+ *
+ * Returns true, if the net_dev_init was already called, and
+ * the driver is initialized.
+ *
+ * This is useful for early drivers trying to call net_dev and
+ * NAPI APIs
+ */
+
+bool is_net_dev_initialized(void)
+{
+       return !(bool)dev_boot_phase;
+}
+EXPORT_SYMBOL(is_net_dev_initialized);
+
+/**
  * register_netdevice_notifier - register a network notifier block
  * @nb: notifier
  *

