Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64A341D5A5B
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 21:49:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726639AbgEOTtP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 15:49:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:48192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726367AbgEOTtJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 15:49:09 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0EA0720758;
        Fri, 15 May 2020 19:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589572148;
        bh=oe8wpYrvlfE0bajQTMDbh6WSewsXpZWtdNM/OctveYg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dDdYr7lW2EexhfBIn/tXKMKf10tGbwZCtoZvLeHEmLLJsmuSXWBK8WKiF1X8Ywku/
         ODKS38OaQSluoAkPjlTim/Ff00Gnlcp2AQQ0BMUaaVc4BNGAB2H1BLWlIadTNgAjGx
         Rpnu9yv8ui21rz7z1p1Zlx9hLY6TZmTQOT4mMvh8=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     mkubecek@suse.cz, netdev@vger.kernel.org,
        simon.horman@netronome.com, kernel-team@fb.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 1/3] ethtool: check if there is at least one channel for TX/RX in the core
Date:   Fri, 15 May 2020 12:49:00 -0700
Message-Id: <20200515194902.3103469-2-kuba@kernel.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200515194902.3103469-1-kuba@kernel.org>
References: <20200515194902.3103469-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Having a channel config with no ability to RX or TX traffic is
clearly wrong. Check for this in the core so the drivers don't
have to.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/ethtool/channels.c | 20 ++++++++++++++++++--
 net/ethtool/ioctl.c    |  5 +++++
 2 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/net/ethtool/channels.c b/net/ethtool/channels.c
index 389924b65d05..3aa4975919d7 100644
--- a/net/ethtool/channels.c
+++ b/net/ethtool/channels.c
@@ -129,13 +129,13 @@ int ethnl_set_channels(struct sk_buff *skb, struct genl_info *info)
 {
 	struct nlattr *tb[ETHTOOL_A_CHANNELS_MAX + 1];
 	unsigned int from_channel, old_total, i;
+	bool mod = false, mod_combined = false;
 	struct ethtool_channels channels = {};
 	struct ethnl_req_info req_info = {};
 	const struct nlattr *err_attr;
 	const struct ethtool_ops *ops;
 	struct net_device *dev;
 	u32 max_rx_in_use = 0;
-	bool mod = false;
 	int ret;
 
 	ret = nlmsg_parse(info->nlhdr, GENL_HDRLEN, tb,
@@ -170,7 +170,8 @@ int ethnl_set_channels(struct sk_buff *skb, struct genl_info *info)
 	ethnl_update_u32(&channels.other_count,
 			 tb[ETHTOOL_A_CHANNELS_OTHER_COUNT], &mod);
 	ethnl_update_u32(&channels.combined_count,
-			 tb[ETHTOOL_A_CHANNELS_COMBINED_COUNT], &mod);
+			 tb[ETHTOOL_A_CHANNELS_COMBINED_COUNT], &mod_combined);
+	mod |= mod_combined;
 	ret = 0;
 	if (!mod)
 		goto out_ops;
@@ -193,6 +194,21 @@ int ethnl_set_channels(struct sk_buff *skb, struct genl_info *info)
 		goto out_ops;
 	}
 
+	/* ensure there is at least one RX and one TX channel */
+	if (!channels.combined_count && !channels.rx_count)
+		err_attr = tb[ETHTOOL_A_CHANNELS_RX_COUNT];
+	else if (!channels.combined_count && !channels.tx_count)
+		err_attr = tb[ETHTOOL_A_CHANNELS_TX_COUNT];
+	else
+		err_attr = NULL;
+	if (err_attr) {
+		if (mod_combined)
+			err_attr = tb[ETHTOOL_A_CHANNELS_COMBINED_COUNT];
+		ret = -EINVAL;
+		NL_SET_ERR_MSG_ATTR(info->extack, err_attr, "requested channel counts would result in no RX or TX channel being configured");
+		goto out_ops;
+	}
+
 	/* ensure the new Rx count fits within the configured Rx flow
 	 * indirection table settings
 	 */
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 52102ab1709b..a574d60111fa 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -1676,6 +1676,11 @@ static noinline_for_stack int ethtool_set_channels(struct net_device *dev,
 	    channels.other_count > curr.max_other)
 		return -EINVAL;
 
+	/* ensure there is at least one RX and one TX channel */
+	if (!channels.combined_count &&
+	    (!channels.rx_count || !channels.tx_count))
+		return -EINVAL;
+
 	/* ensure the new Rx count fits within the configured Rx flow
 	 * indirection table settings */
 	if (netif_is_rxfh_configured(dev) &&
-- 
2.25.4

