Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC3C4178948
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 04:56:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727206AbgCDDz7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 22:55:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:49352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726390AbgCDDz7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Mar 2020 22:55:59 -0500
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 144B2214DB;
        Wed,  4 Mar 2020 03:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583294157;
        bh=ldwtn4i+6uuiYcuyX0HkDjOpznu1SNPoPFiorsXfOr4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rapCOY+DwY/ksA1atBFF7QONUfNAz23Jvoqmi3CZYl3/oW/dIIgs89xPkr+WE4Ni9
         zYiMiYcDConWogSzSrcZvO4h3FLHY2wkTkr5aAbPv9NwPwq6e2MKREWEHPHPbXklP6
         qzlmbLms1autcKG18tY/wV2rCV9WxYTfaVeHUoKk=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     mkubecek@suse.cz, thomas.lendacky@amd.com, benve@cisco.com,
        _govind@gmx.com, pkaustub@cisco.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, joabreu@synopsys.com, snelson@pensando.io,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jeffrey.t.kirsher@intel.com, jacob.e.keller@intel.com,
        alexander.h.duyck@linux.intel.com, michael.chan@broadcom.com,
        saeedm@mellanox.com, leon@kernel.org, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 01/12] ethtool: add infrastructure for centralized checking of coalescing parameters
Date:   Tue,  3 Mar 2020 19:54:50 -0800
Message-Id: <20200304035501.628139-2-kuba@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200304035501.628139-1-kuba@kernel.org>
References: <20200304035501.628139-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Linux supports 22 different interrupt coalescing parameters.
No driver implements them all. Some drivers just ignore the
ones they don't support, while others have to carry a long
list of checks to reject unsupported settings.

To simplify the drivers add the ability to specify inside
ethtool_ops which parameters are supported and let the core
reject attempts to set any other one.

This commit makes the mechanism an opt-in, only drivers which
set ethtool_opts->coalesce_types to a non-zero value will have
the checks enforced.

The same mask is used for global and per queue settings.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/linux/ethtool.h | 45 +++++++++++++++++++++++++++--
 net/ethtool/ioctl.c     | 63 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 105 insertions(+), 3 deletions(-)

diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 23373978cb3c..3c7328f02ba3 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -177,8 +177,44 @@ void ethtool_convert_legacy_u32_to_link_mode(unsigned long *dst,
 bool ethtool_convert_link_mode_to_legacy_u32(u32 *legacy_u32,
 				     const unsigned long *src);
 
+#define ETHTOOL_COALESCE_RX_USECS		BIT(0)
+#define ETHTOOL_COALESCE_RX_MAX_FRAMES		BIT(1)
+#define ETHTOOL_COALESCE_RX_USECS_IRQ		BIT(2)
+#define ETHTOOL_COALESCE_RX_MAX_FRAMES_IRQ	BIT(3)
+#define ETHTOOL_COALESCE_TX_USECS		BIT(4)
+#define ETHTOOL_COALESCE_TX_MAX_FRAMES		BIT(5)
+#define ETHTOOL_COALESCE_TX_USECS_IRQ		BIT(6)
+#define ETHTOOL_COALESCE_TX_MAX_FRAMES_IRQ	BIT(7)
+#define ETHTOOL_COALESCE_STATS_BLOCK_USECS	BIT(8)
+#define ETHTOOL_COALESCE_USE_ADAPTIVE_RX	BIT(9)
+#define ETHTOOL_COALESCE_USE_ADAPTIVE_TX	BIT(10)
+#define ETHTOOL_COALESCE_PKT_RATE_LOW		BIT(11)
+#define ETHTOOL_COALESCE_RX_USECS_LOW		BIT(12)
+#define ETHTOOL_COALESCE_RX_MAX_FRAMES_LOW	BIT(13)
+#define ETHTOOL_COALESCE_TX_USECS_LOW		BIT(14)
+#define ETHTOOL_COALESCE_TX_MAX_FRAMES_LOW	BIT(15)
+#define ETHTOOL_COALESCE_PKT_RATE_HIGH		BIT(16)
+#define ETHTOOL_COALESCE_RX_USECS_HIGH		BIT(17)
+#define ETHTOOL_COALESCE_RX_MAX_FRAMES_HIGH	BIT(18)
+#define ETHTOOL_COALESCE_TX_USECS_HIGH		BIT(19)
+#define ETHTOOL_COALESCE_TX_MAX_FRAMES_HIGH	BIT(20)
+#define ETHTOOL_COALESCE_RATE_SAMPLE_INTERVAL	BIT(21)
+
+#define ETHTOOL_COALESCE_USECS						\
+	(ETHTOOL_COALESCE_RX_USECS | ETHTOOL_COALESCE_TX_USECS)
+#define ETHTOOL_COALESCE_MAX_FRAMES					\
+	(ETHTOOL_COALESCE_RX_MAX_FRAMES | ETHTOOL_COALESCE_TX_MAX_FRAMES)
+#define ETHTOOL_COALESCE_USECS_IRQ					\
+	(ETHTOOL_COALESCE_RX_USECS_IRQ | ETHTOOL_COALESCE_TX_USECS_IRQ)
+#define ETHTOOL_COALESCE_MAX_FRAMES_IRQ		\
+	(ETHTOOL_COALESCE_RX_MAX_FRAMES_IRQ |	\
+	 ETHTOOL_COALESCE_TX_MAX_FRAMES_IRQ)
+#define ETHTOOL_COALESCE_USE_ADAPTIVE					\
+	(ETHTOOL_COALESCE_USE_ADAPTIVE_RX | ETHTOOL_COALESCE_USE_ADAPTIVE_TX)
+
 /**
  * struct ethtool_ops - optional netdev operations
+ * @coalesce_types: supported types of interrupt coalescing.
  * @get_drvinfo: Report driver/device information.  Should only set the
  *	@driver, @version, @fw_version and @bus_info fields.  If not
  *	implemented, the @driver and @bus_info fields will be filled in
@@ -207,8 +243,9 @@ bool ethtool_convert_link_mode_to_legacy_u32(u32 *legacy_u32,
  *	or zero.
  * @get_coalesce: Get interrupt coalescing parameters.  Returns a negative
  *	error code or zero.
- * @set_coalesce: Set interrupt coalescing parameters.  Returns a negative
- *	error code or zero.
+ * @set_coalesce: Set interrupt coalescing parameters.  Supported coalescing
+ *	types should be set in @coalesce_types.
+ *	Returns a negative error code or zero.
  * @get_ringparam: Report ring sizes
  * @set_ringparam: Set ring sizes.  Returns a negative error code or zero.
  * @get_pauseparam: Report pause parameters
@@ -292,7 +329,8 @@ bool ethtool_convert_link_mode_to_legacy_u32(u32 *legacy_u32,
  * @set_per_queue_coalesce: Set interrupt coalescing parameters per queue.
  *	It must check that the given queue number is valid. If neither a RX nor
  *	a TX queue has this number, return -EINVAL. If only a RX queue or a TX
- *	queue has this number, ignore the inapplicable fields.
+ *	queue has this number, ignore the inapplicable fields. Supported
+ *	coalescing types should be set in @coalesce_types.
  *	Returns a negative error code or zero.
  * @get_link_ksettings: Get various device settings including Ethernet link
  *	settings. The %cmd and %link_mode_masks_nwords fields should be
@@ -323,6 +361,7 @@ bool ethtool_convert_link_mode_to_legacy_u32(u32 *legacy_u32,
  * of the generic netdev features interface.
  */
 struct ethtool_ops {
+	u32	coalesce_types;
 	void	(*get_drvinfo)(struct net_device *, struct ethtool_drvinfo *);
 	int	(*get_regs_len)(struct net_device *);
 	void	(*get_regs)(struct net_device *, struct ethtool_regs *, void *);
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index f2fe8e5896dc..ae1a6eea36f1 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -1544,6 +1544,61 @@ static noinline_for_stack int ethtool_get_coalesce(struct net_device *dev,
 	return 0;
 }
 
+static bool
+ethtool_set_coalesce_supported(struct net_device *dev,
+			       struct ethtool_coalesce *coalesce)
+{
+	u32 used_types = 0;
+
+	if (coalesce->rx_coalesce_usecs)
+		used_types |= ETHTOOL_COALESCE_RX_USECS;
+	if (coalesce->rx_max_coalesced_frames)
+		used_types |= ETHTOOL_COALESCE_RX_MAX_FRAMES;
+	if (coalesce->rx_coalesce_usecs_irq)
+		used_types |= ETHTOOL_COALESCE_RX_USECS_IRQ;
+	if (coalesce->rx_max_coalesced_frames_irq)
+		used_types |= ETHTOOL_COALESCE_RX_MAX_FRAMES_IRQ;
+	if (coalesce->tx_coalesce_usecs)
+		used_types |= ETHTOOL_COALESCE_TX_USECS;
+	if (coalesce->tx_max_coalesced_frames)
+		used_types |= ETHTOOL_COALESCE_TX_MAX_FRAMES;
+	if (coalesce->tx_coalesce_usecs_irq)
+		used_types |= ETHTOOL_COALESCE_TX_USECS_IRQ;
+	if (coalesce->tx_max_coalesced_frames_irq)
+		used_types |= ETHTOOL_COALESCE_TX_MAX_FRAMES_IRQ;
+	if (coalesce->stats_block_coalesce_usecs)
+		used_types |= ETHTOOL_COALESCE_STATS_BLOCK_USECS;
+	if (coalesce->use_adaptive_rx_coalesce)
+		used_types |= ETHTOOL_COALESCE_USE_ADAPTIVE_RX;
+	if (coalesce->use_adaptive_tx_coalesce)
+		used_types |= ETHTOOL_COALESCE_USE_ADAPTIVE_TX;
+	if (coalesce->pkt_rate_low)
+		used_types |= ETHTOOL_COALESCE_PKT_RATE_LOW;
+	if (coalesce->rx_coalesce_usecs_low)
+		used_types |= ETHTOOL_COALESCE_RX_USECS_LOW;
+	if (coalesce->rx_max_coalesced_frames_low)
+		used_types |= ETHTOOL_COALESCE_RX_MAX_FRAMES_LOW;
+	if (coalesce->tx_coalesce_usecs_low)
+		used_types |= ETHTOOL_COALESCE_TX_USECS_LOW;
+	if (coalesce->tx_max_coalesced_frames_low)
+		used_types |= ETHTOOL_COALESCE_TX_MAX_FRAMES_LOW;
+	if (coalesce->pkt_rate_high)
+		used_types |= ETHTOOL_COALESCE_PKT_RATE_HIGH;
+	if (coalesce->rx_coalesce_usecs_high)
+		used_types |= ETHTOOL_COALESCE_RX_USECS_HIGH;
+	if (coalesce->rx_max_coalesced_frames_high)
+		used_types |= ETHTOOL_COALESCE_RX_MAX_FRAMES_HIGH;
+	if (coalesce->tx_coalesce_usecs_high)
+		used_types |= ETHTOOL_COALESCE_TX_USECS_HIGH;
+	if (coalesce->tx_max_coalesced_frames_high)
+		used_types |= ETHTOOL_COALESCE_TX_MAX_FRAMES_HIGH;
+	if (coalesce->rate_sample_interval)
+		used_types |= ETHTOOL_COALESCE_RATE_SAMPLE_INTERVAL;
+
+	return !dev->ethtool_ops->coalesce_types ||
+		(dev->ethtool_ops->coalesce_types & used_types) == used_types;
+}
+
 static noinline_for_stack int ethtool_set_coalesce(struct net_device *dev,
 						   void __user *useraddr)
 {
@@ -1555,6 +1610,9 @@ static noinline_for_stack int ethtool_set_coalesce(struct net_device *dev,
 	if (copy_from_user(&coalesce, useraddr, sizeof(coalesce)))
 		return -EFAULT;
 
+	if (!ethtool_set_coalesce_supported(dev, &coalesce))
+		return -EINVAL;
+
 	return dev->ethtool_ops->set_coalesce(dev, &coalesce);
 }
 
@@ -2336,6 +2394,11 @@ ethtool_set_per_queue_coalesce(struct net_device *dev,
 			goto roll_back;
 		}
 
+		if (!ethtool_set_coalesce_supported(dev, &coalesce)) {
+			ret = -EINVAL;
+			goto roll_back;
+		}
+
 		ret = dev->ethtool_ops->set_per_queue_coalesce(dev, bit, &coalesce);
 		if (ret != 0)
 			goto roll_back;
-- 
2.24.1

