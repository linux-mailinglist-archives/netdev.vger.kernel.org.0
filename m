Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4508D269A38
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 02:13:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726066AbgIOANT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 20:13:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:58280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726019AbgIOANJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 20:13:09 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A5105216C4;
        Tue, 15 Sep 2020 00:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600128789;
        bh=7+7PTWdgLkjpHvhREyHVA9VVTRwWU188syhx9SvhqEY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zu9f+oQd67PeSerLeKQ29QMMN46yeuEt2/KK50zUTWUkZg/L+7VJIIIWDDSYayaSL
         m6Lox80xWA7kYTFOZLrSOvEK3F2Bbc4NVBXd3Bcltx8Nq4eDw9stN+ZDRzvhdgoj1R
         YtIkuk70KixyDv/kyMsoOfNxqyZe20uL4tm+2oSI=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     mkubecek@suse.cz, michael.chan@broadcom.com, saeedm@nvidia.com,
        tariqt@nvidia.com, andrew@lunn.ch, alexander.duyck@gmail.com,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v3 1/8] ethtool: add standard pause stats
Date:   Mon, 14 Sep 2020 17:11:52 -0700
Message-Id: <20200915001159.346469-2-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200915001159.346469-1-kuba@kernel.org>
References: <20200915001159.346469-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently drivers have to report their pause frames statistics
via ethtool -S, and there is a wide variety of names used for
these statistics.

Add the two statistics defined in IEEE 802.3x to the standard
API. Create a new ethtool request header flag for including
statistics in the response to GET commands.

Always create the ETHTOOL_A_PAUSE_STATS nest in replies when
flag is set. Testing if driver declares the op is not a reliable
way of checking if any stats will actually be included and therefore
we don't want to give the impression that presence of
ETHTOOL_A_PAUSE_STATS indicates driver support.

Note that this patch does not include PFC counters, which may fit
better in dcbnl? But mostly I don't need them/have a setup to test
them so I haven't looked deeply into exposing them :)

v3:
 - add a helper for "uninitializing" stats, rather than a cryptic
   memset() (Andrew)

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
---
 Documentation/networking/ethtool-netlink.rst | 11 ++++
 include/linux/ethtool.h                      | 26 ++++++++
 include/uapi/linux/ethtool_netlink.h         | 18 +++++-
 net/ethtool/pause.c                          | 63 +++++++++++++++++++-
 4 files changed, 116 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index d53bcb31645a..2c8e0ddf548e 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -68,6 +68,7 @@ types. The interpretation of these flags is the same for all request types but
   =================================  ===================================
   ``ETHTOOL_FLAG_COMPACT_BITSETS``   use compact format bitsets in reply
   ``ETHTOOL_FLAG_OMIT_REPLY``        omit optional reply (_SET and _ACT)
+  ``ETHTOOL_FLAG_STATS``             include optional device statistics
   =================================  ===================================
 
 New request flags should follow the general idea that if the flag is not set,
@@ -989,8 +990,18 @@ Gets channel counts like ``ETHTOOL_GPAUSE`` ioctl request.
   ``ETHTOOL_A_PAUSE_AUTONEG``            bool    pause autonegotiation
   ``ETHTOOL_A_PAUSE_RX``                 bool    receive pause frames
   ``ETHTOOL_A_PAUSE_TX``                 bool    transmit pause frames
+  ``ETHTOOL_A_PAUSE_STATS``              nested  pause statistics
   =====================================  ======  ==========================
 
+``ETHTOOL_A_PAUSE_STATS`` are reported if ``ETHTOOL_FLAG_STATS`` was set
+in ``ETHTOOL_A_HEADER_FLAGS``.
+It will be empty if driver did not report any statistics. Drivers fill in
+the statistics in the following structure:
+
+.. kernel-doc:: include/linux/ethtool.h
+    :identifiers: ethtool_pause_stats
+
+Each member has a corresponding attribute defined.
 
 PAUSE_SET
 ============
diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 969a80211df6..060b20f0b20f 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -241,6 +241,27 @@ bool ethtool_convert_link_mode_to_legacy_u32(u32 *legacy_u32,
 	 ETHTOOL_COALESCE_PKT_RATE_LOW | ETHTOOL_COALESCE_PKT_RATE_HIGH | \
 	 ETHTOOL_COALESCE_RATE_SAMPLE_INTERVAL)
 
+#define ETHTOOL_STAT_NOT_SET	(~0ULL)
+
+/**
+ * struct ethtool_pause_stats - statistics for IEEE 802.3x pause frames
+ * @tx_pause_frames: transmitted pause frame count. Reported to user space
+ *	as %ETHTOOL_A_PAUSE_STAT_TX_FRAMES.
+ *
+ *	Equivalent to `30.3.4.2 aPAUSEMACCtrlFramesTransmitted`
+ *	from the standard.
+ *
+ * @rx_pause_frames: received pause frame count. Reported to user space
+ *	as %ETHTOOL_A_PAUSE_STAT_RX_FRAMES. Equivalent to:
+ *
+ *	Equivalent to `30.3.4.3 aPAUSEMACCtrlFramesReceived`
+ *	from the standard.
+ */
+struct ethtool_pause_stats {
+	u64 tx_pause_frames;
+	u64 rx_pause_frames;
+};
+
 /**
  * struct ethtool_ops - optional netdev operations
  * @supported_coalesce_params: supported types of interrupt coalescing.
@@ -282,6 +303,9 @@ bool ethtool_convert_link_mode_to_legacy_u32(u32 *legacy_u32,
  *	Returns a negative error code or zero.
  * @get_ringparam: Report ring sizes
  * @set_ringparam: Set ring sizes.  Returns a negative error code or zero.
+ * @get_pause_stats: Report pause frame statistics. Drivers must not zero
+ *	statistics which they don't report. The stats structure is initialized
+ *	to ETHTOOL_STAT_NOT_SET indicating driver does not report statistics.
  * @get_pauseparam: Report pause parameters
  * @set_pauseparam: Set pause parameters.  Returns a negative error code
  *	or zero.
@@ -418,6 +442,8 @@ struct ethtool_ops {
 				 struct ethtool_ringparam *);
 	int	(*set_ringparam)(struct net_device *,
 				 struct ethtool_ringparam *);
+	void	(*get_pause_stats)(struct net_device *dev,
+				   struct ethtool_pause_stats *pause_stats);
 	void	(*get_pauseparam)(struct net_device *,
 				  struct ethtool_pauseparam*);
 	int	(*set_pauseparam)(struct net_device *,
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index 5dcd24cb33ea..9cee6df01a10 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -91,9 +91,12 @@ enum {
 #define ETHTOOL_FLAG_COMPACT_BITSETS	(1 << 0)
 /* provide optional reply for SET or ACT requests */
 #define ETHTOOL_FLAG_OMIT_REPLY	(1 << 1)
+/* request statistics, if supported by the driver */
+#define ETHTOOL_FLAG_STATS		(1 << 2)
 
 #define ETHTOOL_FLAG_ALL (ETHTOOL_FLAG_COMPACT_BITSETS | \
-			  ETHTOOL_FLAG_OMIT_REPLY)
+			  ETHTOOL_FLAG_OMIT_REPLY | \
+			  ETHTOOL_FLAG_STATS)
 
 enum {
 	ETHTOOL_A_HEADER_UNSPEC,
@@ -376,12 +379,25 @@ enum {
 	ETHTOOL_A_PAUSE_AUTONEG,			/* u8 */
 	ETHTOOL_A_PAUSE_RX,				/* u8 */
 	ETHTOOL_A_PAUSE_TX,				/* u8 */
+	ETHTOOL_A_PAUSE_STATS,				/* nest - _PAUSE_STAT_* */
 
 	/* add new constants above here */
 	__ETHTOOL_A_PAUSE_CNT,
 	ETHTOOL_A_PAUSE_MAX = (__ETHTOOL_A_PAUSE_CNT - 1)
 };
 
+enum {
+	ETHTOOL_A_PAUSE_STAT_UNSPEC,
+	ETHTOOL_A_PAUSE_STAT_PAD,
+
+	ETHTOOL_A_PAUSE_STAT_TX_FRAMES,
+	ETHTOOL_A_PAUSE_STAT_RX_FRAMES,
+
+	/* add new constants above here */
+	__ETHTOOL_A_PAUSE_STAT_CNT,
+	ETHTOOL_A_PAUSE_STAT_MAX = (__ETHTOOL_A_PAUSE_STAT_CNT - 1)
+};
+
 /* EEE */
 
 enum {
diff --git a/net/ethtool/pause.c b/net/ethtool/pause.c
index 7aea35d1e8a5..1980aa7eb2b6 100644
--- a/net/ethtool/pause.c
+++ b/net/ethtool/pause.c
@@ -10,6 +10,7 @@ struct pause_req_info {
 struct pause_reply_data {
 	struct ethnl_reply_data		base;
 	struct ethtool_pauseparam	pauseparam;
+	struct ethtool_pause_stats	pausestat;
 };
 
 #define PAUSE_REPDATA(__reply_base) \
@@ -22,8 +23,15 @@ pause_get_policy[ETHTOOL_A_PAUSE_MAX + 1] = {
 	[ETHTOOL_A_PAUSE_AUTONEG]		= { .type = NLA_REJECT },
 	[ETHTOOL_A_PAUSE_RX]			= { .type = NLA_REJECT },
 	[ETHTOOL_A_PAUSE_TX]			= { .type = NLA_REJECT },
+	[ETHTOOL_A_PAUSE_STATS]			= { .type = NLA_REJECT },
 };
 
+static void ethtool_stats_init(u64 *stats, unsigned int n)
+{
+	while (n--)
+		stats[n] = ETHTOOL_STAT_NOT_SET;
+}
+
 static int pause_prepare_data(const struct ethnl_req_info *req_base,
 			      struct ethnl_reply_data *reply_base,
 			      struct genl_info *info)
@@ -34,10 +42,17 @@ static int pause_prepare_data(const struct ethnl_req_info *req_base,
 
 	if (!dev->ethtool_ops->get_pauseparam)
 		return -EOPNOTSUPP;
+
 	ret = ethnl_ops_begin(dev);
 	if (ret < 0)
 		return ret;
 	dev->ethtool_ops->get_pauseparam(dev, &data->pauseparam);
+	if (req_base->flags & ETHTOOL_FLAG_STATS &&
+	    dev->ethtool_ops->get_pause_stats) {
+		ethtool_stats_init((u64 *)&data->pausestat,
+				   sizeof(data->pausestat) / 8);
+		dev->ethtool_ops->get_pause_stats(dev, &data->pausestat);
+	}
 	ethnl_ops_complete(dev);
 
 	return 0;
@@ -46,9 +61,50 @@ static int pause_prepare_data(const struct ethnl_req_info *req_base,
 static int pause_reply_size(const struct ethnl_req_info *req_base,
 			    const struct ethnl_reply_data *reply_base)
 {
-	return nla_total_size(sizeof(u8)) +	/* _PAUSE_AUTONEG */
+	int n = nla_total_size(sizeof(u8)) +	/* _PAUSE_AUTONEG */
 		nla_total_size(sizeof(u8)) +	/* _PAUSE_RX */
 		nla_total_size(sizeof(u8));	/* _PAUSE_TX */
+
+	if (req_base->flags & ETHTOOL_FLAG_STATS)
+		n += nla_total_size(0) +	/* _PAUSE_STATS */
+			nla_total_size_64bit(sizeof(u64)) *
+				(ETHTOOL_A_PAUSE_STAT_MAX - 2);
+	return n;
+}
+
+static int ethtool_put_stat(struct sk_buff *skb, u64 val, u16 attrtype,
+			    u16 padtype)
+{
+	if (val == ETHTOOL_STAT_NOT_SET)
+		return 0;
+	if (nla_put_u64_64bit(skb, attrtype, val, padtype))
+		return -EMSGSIZE;
+
+	return 0;
+}
+
+static int pause_put_stats(struct sk_buff *skb,
+			   const struct ethtool_pause_stats *pause_stats)
+{
+	const u16 pad = ETHTOOL_A_PAUSE_STAT_PAD;
+	struct nlattr *nest;
+
+	nest = nla_nest_start(skb, ETHTOOL_A_PAUSE_STATS);
+	if (!nest)
+		return -EMSGSIZE;
+
+	if (ethtool_put_stat(skb, pause_stats->tx_pause_frames,
+			     ETHTOOL_A_PAUSE_STAT_TX_FRAMES, pad) ||
+	    ethtool_put_stat(skb, pause_stats->rx_pause_frames,
+			     ETHTOOL_A_PAUSE_STAT_RX_FRAMES, pad))
+		goto err_cancel;
+
+	nla_nest_end(skb, nest);
+	return 0;
+
+err_cancel:
+	nla_nest_cancel(skb, nest);
+	return -EMSGSIZE;
 }
 
 static int pause_fill_reply(struct sk_buff *skb,
@@ -63,6 +119,10 @@ static int pause_fill_reply(struct sk_buff *skb,
 	    nla_put_u8(skb, ETHTOOL_A_PAUSE_TX, !!pauseparam->tx_pause))
 		return -EMSGSIZE;
 
+	if (req_base->flags & ETHTOOL_FLAG_STATS &&
+	    pause_put_stats(skb, &data->pausestat))
+		return -EMSGSIZE;
+
 	return 0;
 }
 
@@ -89,6 +149,7 @@ pause_set_policy[ETHTOOL_A_PAUSE_MAX + 1] = {
 	[ETHTOOL_A_PAUSE_AUTONEG]		= { .type = NLA_U8 },
 	[ETHTOOL_A_PAUSE_RX]			= { .type = NLA_U8 },
 	[ETHTOOL_A_PAUSE_TX]			= { .type = NLA_U8 },
+	[ETHTOOL_A_PAUSE_STATS]			= { .type = NLA_REJECT },
 };
 
 int ethnl_set_pause(struct sk_buff *skb, struct genl_info *info)
-- 
2.26.2

