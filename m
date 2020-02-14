Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 193E715E550
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 17:41:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393931AbgBNQlC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 11:41:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:58540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405060AbgBNQWm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 11:22:42 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D6965246D9;
        Fri, 14 Feb 2020 16:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581697361;
        bh=w61Y2oCtqAzKFgj+H/+9L2qLOJTi5QsYYyj1weMQ/0I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2Y0Ql8OF3V2neqdnrnR25h+pBevd6iabtHFVf1xInZq+r+E85eg6pneOjROHAEzH9
         zrdHIvGQuhXVi61aI3+5DzTNzeQ8DUDpYLtN+WCFzAIsWGaF40x6arLlMul8dOZPai
         H9swW0g8AiZ5N9FZhdKxmVH5+y4eAEP5/zwpbbwU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Phong Tran <tranmanphong@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 062/141] ipw2x00: Fix -Wcast-function-type
Date:   Fri, 14 Feb 2020 11:20:02 -0500
Message-Id: <20200214162122.19794-62-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214162122.19794-1-sashal@kernel.org>
References: <20200214162122.19794-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Phong Tran <tranmanphong@gmail.com>

[ Upstream commit ebd77feb27e91bb5fe35a7818b7c13ea7435fb98 ]

correct usage prototype of callback in tasklet_init().
Report by https://github.com/KSPP/linux/issues/20

Signed-off-by: Phong Tran <tranmanphong@gmail.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/ipw2x00/ipw2100.c | 7 ++++---
 drivers/net/wireless/intel/ipw2x00/ipw2200.c | 5 +++--
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2100.c b/drivers/net/wireless/intel/ipw2x00/ipw2100.c
index bfa542c8d6f1a..86c84b11218db 100644
--- a/drivers/net/wireless/intel/ipw2x00/ipw2100.c
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2100.c
@@ -3220,8 +3220,9 @@ static void ipw2100_tx_send_data(struct ipw2100_priv *priv)
 	}
 }
 
-static void ipw2100_irq_tasklet(struct ipw2100_priv *priv)
+static void ipw2100_irq_tasklet(unsigned long data)
 {
+	struct ipw2100_priv *priv = (struct ipw2100_priv *)data;
 	struct net_device *dev = priv->net_dev;
 	unsigned long flags;
 	u32 inta, tmp;
@@ -6029,7 +6030,7 @@ static void ipw2100_rf_kill(struct work_struct *work)
 	spin_unlock_irqrestore(&priv->low_lock, flags);
 }
 
-static void ipw2100_irq_tasklet(struct ipw2100_priv *priv);
+static void ipw2100_irq_tasklet(unsigned long data);
 
 static const struct net_device_ops ipw2100_netdev_ops = {
 	.ndo_open		= ipw2100_open,
@@ -6158,7 +6159,7 @@ static struct net_device *ipw2100_alloc_device(struct pci_dev *pci_dev,
 	INIT_DELAYED_WORK(&priv->rf_kill, ipw2100_rf_kill);
 	INIT_DELAYED_WORK(&priv->scan_event, ipw2100_scan_event);
 
-	tasklet_init(&priv->irq_tasklet, (void (*)(unsigned long))
+	tasklet_init(&priv->irq_tasklet,
 		     ipw2100_irq_tasklet, (unsigned long)priv);
 
 	/* NOTE:  We do not start the deferred work for status checks yet */
diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2200.c b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
index bfd68612a535d..48edb2b6eb7d5 100644
--- a/drivers/net/wireless/intel/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
@@ -1968,8 +1968,9 @@ static void notify_wx_assoc_event(struct ipw_priv *priv)
 	wireless_send_event(priv->net_dev, SIOCGIWAP, &wrqu, NULL);
 }
 
-static void ipw_irq_tasklet(struct ipw_priv *priv)
+static void ipw_irq_tasklet(unsigned long data)
 {
+	struct ipw_priv *priv = (struct ipw_priv *)data;
 	u32 inta, inta_mask, handled = 0;
 	unsigned long flags;
 	int rc = 0;
@@ -10705,7 +10706,7 @@ static int ipw_setup_deferred_work(struct ipw_priv *priv)
 	INIT_WORK(&priv->qos_activate, ipw_bg_qos_activate);
 #endif				/* CONFIG_IPW2200_QOS */
 
-	tasklet_init(&priv->irq_tasklet, (void (*)(unsigned long))
+	tasklet_init(&priv->irq_tasklet,
 		     ipw_irq_tasklet, (unsigned long)priv);
 
 	return ret;
-- 
2.20.1

