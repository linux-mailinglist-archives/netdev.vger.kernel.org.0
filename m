Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 897D9187439
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 21:47:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732621AbgCPUrc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 16:47:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:58728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732617AbgCPUrb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Mar 2020 16:47:31 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C4DC206C0;
        Mon, 16 Mar 2020 20:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584391650;
        bh=kC1SDN3SNXyliRURgKoD95Pi2ZU8rKCoguEhUdUUEfY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wb/IH+7UZGFtdbsYqnjLpAcbyQNsRsXVtPwPD8OVh9s+2VwG52sXbVTsgxeFEiERJ
         a0ZfxWSh3Cy3seKNK/sjMoMNOnkZdrJhBRrXI55hfcvye7VzYFv+TZD/3HO3x2oOk3
         JfPGCAPsNlCrngVV6ZkGH/2lwrbKM4LQreMjobqc=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-net-drivers@solarflare.com,
        ecree@solarflare.com, mhabets@solarflare.com,
        jaswinder.singh@linaro.org, ilias.apalodimas@linaro.org,
        Jose.Abreu@synopsys.com, andy@greyhouse.net,
        grygorii.strashko@ti.com, andrew@lunn.ch, michal.simek@xilinx.com,
        radhey.shyam.pandey@xilinx.com, mkubecek@suse.cz,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 9/9] net: ethtool: require drivers to set supported_coalesce_params
Date:   Mon, 16 Mar 2020 13:47:12 -0700
Message-Id: <20200316204712.3098382-10-kuba@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200316204712.3098382-1-kuba@kernel.org>
References: <20200316204712.3098382-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that all in-tree drivers have been updated we can
make the supported_coalesce_params mandatory.

To save debugging time in case some driver was missed
(or is out of tree) add a warning when netdev is registered
with set_coalesce but without supported_coalesce_params.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/linux/ethtool.h |  2 ++
 net/core/dev.c          |  4 ++++
 net/ethtool/common.c    | 11 +++++++++++
 net/ethtool/ioctl.c     |  3 ---
 4 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index be355f37337d..c1d379bf6ee1 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -458,6 +458,8 @@ struct ethtool_ops {
 					 struct ethtool_stats *, u64 *);
 };
 
+int ethtool_check_ops(const struct ethtool_ops *ops);
+
 struct ethtool_rx_flow_rule {
 	struct flow_rule	*rule;
 	unsigned long		priv[0];
diff --git a/net/core/dev.c b/net/core/dev.c
index d84541c24446..021e18251465 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9283,6 +9283,10 @@ int register_netdevice(struct net_device *dev)
 	BUG_ON(dev->reg_state != NETREG_UNINITIALIZED);
 	BUG_ON(!net);
 
+	ret = ethtool_check_ops(dev->ethtool_ops);
+	if (ret)
+		return ret;
+
 	spin_lock_init(&dev->addr_list_lock);
 	lockdep_set_class(&dev->addr_list_lock, &dev->addr_list_lock_key);
 
diff --git a/net/ethtool/common.c b/net/ethtool/common.c
index 0b22741b2f8f..dab047eec943 100644
--- a/net/ethtool/common.c
+++ b/net/ethtool/common.c
@@ -289,3 +289,14 @@ int ethtool_get_max_rxfh_channel(struct net_device *dev, u32 *max)
 	kfree(indir);
 	return ret;
 }
+
+int ethtool_check_ops(const struct ethtool_ops *ops)
+{
+	if (WARN_ON(ops->set_coalesce && !ops->supported_coalesce_params))
+		return -EINVAL;
+	/* NOTE: sufficiently insane drivers may swap ethtool_ops at runtime,
+	 * the fact that ops are checked at registration time does not
+	 * mean the ops attached to a netdev later on are sane.
+	 */
+	return 0;
+}
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 258840b19fb5..3852a58d7f95 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -1519,9 +1519,6 @@ ethtool_set_coalesce_supported(struct net_device *dev,
 	u32 supported_params = dev->ethtool_ops->supported_coalesce_params;
 	u32 nonzero_params = 0;
 
-	if (!supported_params)
-		return true;
-
 	if (coalesce->rx_coalesce_usecs)
 		nonzero_params |= ETHTOOL_COALESCE_RX_USECS;
 	if (coalesce->rx_max_coalesced_frames)
-- 
2.24.1

