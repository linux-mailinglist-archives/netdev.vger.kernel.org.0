Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AABF9213945
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 13:22:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726374AbgGCLWn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 07:22:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:50608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726039AbgGCLWn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Jul 2020 07:22:43 -0400
Received: from pali.im (pali.im [31.31.79.79])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA7F720674;
        Fri,  3 Jul 2020 11:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593775362;
        bh=6n28vpx/soKyjVr4Qm0kMEuzFjiXcM8KUitLv0Cgf/0=;
        h=From:To:Cc:Subject:Date:From;
        b=nQjxyVEI2yn5VgxkwVOEe2ufkTUTzgWidEE+rLTENbUwAvmEEZ4owS02JW0bP0d6f
         +UCXbi2HQ+GyTycjMd2X+QcR6iOy0z4/jGPopVqgr273u8IGlLt5yEpLsImBk/8jTN
         QgdT444JVHCw/x+Y2/yx/BX5NdIfdDvQawc/EMAE=
Received: by pali.im (Postfix)
        id 7B291121B; Fri,  3 Jul 2020 13:22:40 +0200 (CEST)
From:   =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To:     Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mwifiex: Fix reporting 'operation not supported' error code
Date:   Fri,  3 Jul 2020 13:21:51 +0200
Message-Id: <20200703112151.18917-1-pali@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ENOTSUPP (double PP) is internal linux kernel code 524 available only in
kernel include file linux/errno.h and not exported to userspace.

EOPNOTSUPP (OP; double PP) is standard code 95 for reporting 'operation not
supported' available via kernel include file uapi/asm-generic/errno.h.

ENOTSUP (single P) is alias for EOPNOTSUPP defined only in userspace
include file bits/errno.h and not available in kernel.

Because Linux kernel does not support ENOTSUP (single P) and because
userspace does not support ENOTSUPP (double PP), report error code for
'operation not supported' via EOPNOTSUPP macro.

This patch fixes problem that mwifiex kernel driver sends to userspace
unsupported error codes like: "failed: -524 (No error information)".
After applying this patch userspace see: "failed: -95 (Not supported)".

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 .../net/wireless/marvell/mwifiex/cfg80211.c    | 18 +++++++++---------
 drivers/net/wireless/marvell/mwifiex/main.c    |  2 +-
 drivers/net/wireless/marvell/mwifiex/sta_cmd.c |  4 ++--
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index 867b5cf385a8..96848fa0e417 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -3727,11 +3727,11 @@ mwifiex_cfg80211_tdls_mgmt(struct wiphy *wiphy, struct net_device *dev,
 	int ret;
 
 	if (!(wiphy->flags & WIPHY_FLAG_SUPPORTS_TDLS))
-		return -ENOTSUPP;
+		return -EOPNOTSUPP;
 
 	/* make sure we are in station mode and connected */
 	if (!(priv->bss_type == MWIFIEX_BSS_TYPE_STA && priv->media_connected))
-		return -ENOTSUPP;
+		return -EOPNOTSUPP;
 
 	switch (action_code) {
 	case WLAN_TDLS_SETUP_REQUEST:
@@ -3799,11 +3799,11 @@ mwifiex_cfg80211_tdls_oper(struct wiphy *wiphy, struct net_device *dev,
 
 	if (!(wiphy->flags & WIPHY_FLAG_SUPPORTS_TDLS) ||
 	    !(wiphy->flags & WIPHY_FLAG_TDLS_EXTERNAL_SETUP))
-		return -ENOTSUPP;
+		return -EOPNOTSUPP;
 
 	/* make sure we are in station mode and connected */
 	if (!(priv->bss_type == MWIFIEX_BSS_TYPE_STA && priv->media_connected))
-		return -ENOTSUPP;
+		return -EOPNOTSUPP;
 
 	mwifiex_dbg(priv->adapter, MSG,
 		    "TDLS peer=%pM, oper=%d\n", peer, action);
@@ -3833,7 +3833,7 @@ mwifiex_cfg80211_tdls_oper(struct wiphy *wiphy, struct net_device *dev,
 	default:
 		mwifiex_dbg(priv->adapter, ERROR,
 			    "tdls_oper: operation not supported\n");
-		return -ENOTSUPP;
+		return -EOPNOTSUPP;
 	}
 
 	return mwifiex_tdls_oper(priv, peer, action);
@@ -3914,11 +3914,11 @@ mwifiex_cfg80211_add_station(struct wiphy *wiphy, struct net_device *dev,
 	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
 
 	if (!(params->sta_flags_set & BIT(NL80211_STA_FLAG_TDLS_PEER)))
-		return -ENOTSUPP;
+		return -EOPNOTSUPP;
 
 	/* make sure we are in station mode and connected */
 	if ((priv->bss_type != MWIFIEX_BSS_TYPE_STA) || !priv->media_connected)
-		return -ENOTSUPP;
+		return -EOPNOTSUPP;
 
 	return mwifiex_tdls_oper(priv, mac, MWIFIEX_TDLS_CREATE_LINK);
 }
@@ -4151,11 +4151,11 @@ mwifiex_cfg80211_change_station(struct wiphy *wiphy, struct net_device *dev,
 
 	/* we support change_station handler only for TDLS peers*/
 	if (!(params->sta_flags_set & BIT(NL80211_STA_FLAG_TDLS_PEER)))
-		return -ENOTSUPP;
+		return -EOPNOTSUPP;
 
 	/* make sure we are in station mode and connected */
 	if ((priv->bss_type != MWIFIEX_BSS_TYPE_STA) || !priv->media_connected)
-		return -ENOTSUPP;
+		return -EOPNOTSUPP;
 
 	priv->sta_params = params;
 
diff --git a/drivers/net/wireless/marvell/mwifiex/main.c b/drivers/net/wireless/marvell/mwifiex/main.c
index 529099137644..9ee5600351a7 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.c
+++ b/drivers/net/wireless/marvell/mwifiex/main.c
@@ -953,7 +953,7 @@ int mwifiex_set_mac_address(struct mwifiex_private *priv,
 	} else {
 		/* Internal mac address change */
 		if (priv->bss_type == MWIFIEX_BSS_TYPE_ANY)
-			return -ENOTSUPP;
+			return -EOPNOTSUPP;
 
 		mac_addr = old_mac_addr;
 
diff --git a/drivers/net/wireless/marvell/mwifiex/sta_cmd.c b/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
index 8bd355d7974e..d3a968ef21ef 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
@@ -1723,7 +1723,7 @@ mwifiex_cmd_tdls_config(struct mwifiex_private *priv,
 	default:
 		mwifiex_dbg(priv->adapter, ERROR,
 			    "Unknown TDLS configuration\n");
-		return -ENOTSUPP;
+		return -EOPNOTSUPP;
 	}
 
 	le16_unaligned_add_cpu(&cmd->size, len);
@@ -1849,7 +1849,7 @@ mwifiex_cmd_tdls_oper(struct mwifiex_private *priv,
 		break;
 	default:
 		mwifiex_dbg(priv->adapter, ERROR, "Unknown TDLS operation\n");
-		return -ENOTSUPP;
+		return -EOPNOTSUPP;
 	}
 
 	le16_unaligned_add_cpu(&cmd->size, config_len);
-- 
2.20.1

