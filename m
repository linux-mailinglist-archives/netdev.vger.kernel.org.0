Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDEAE471781
	for <lists+netdev@lfdr.de>; Sun, 12 Dec 2021 02:21:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232367AbhLLBSq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Dec 2021 20:18:46 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:16398 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232348AbhLLBSp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Dec 2021 20:18:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:mime-version:to:cc:content-transfer-encoding:
        content-type;
        s=sgd; bh=n0HMddjGrKnpVS5OFQD8ByG36/ADhDg6KTCm0PmFbCs=;
        b=jS7VhUJptqrjQkc02N/NL+xGFyWX+1Yf+uJAuvP/OZzmzx+lFyqu2t9FZvQcg6fzxvZh
        NpbrC3Y9FxCvXuRq5WJ6VHq/FkpOvpDOFlG3VSvhE8yWBXYzCS3T813ZewzOTwJNHSeqez
        y++AYxQtJfgBjHnouFopXULP/1JnFG2AA9wrDMgKW82Q69Cp1CXrVmG7n0JZ/7pRo2bpsz
        IQHVzZw1ZZogzP02aSU63QfCXDufLIEzMLbdhTvr0oTFI0vbEH52ZHx5DVG+iolRbFvdgL
        L7KU4NqQDq5Ry2rGyGJcnVlPUQmKRF5ZIod+2YpicCSolV8wcjjxjNIs13V7Y9Lw==
Received: by filterdrecv-75ff7b5ffb-8jc8g with SMTP id filterdrecv-75ff7b5ffb-8jc8g-1-61B54DF4-10
        2021-12-12 01:18:44.284698431 +0000 UTC m=+8737071.970174269
Received: from pearl.egauge.net (unknown)
        by ismtpd0065p1las1.sendgrid.net (SG) with ESMTP
        id xfk2N9YfTpi5F9GS2LxzDg
        Sun, 12 Dec 2021 01:18:44.149 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id EB8707003AA; Sat, 11 Dec 2021 18:18:40 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: [PATCH] wilc1000: Allow setting power_save before driver is
 initialized
Date:   Sun, 12 Dec 2021 01:18:44 +0000 (UTC)
Message-Id: <20211212011835.3719001-1-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvLrlz+ZJBGlhg9mbn?=
 =?us-ascii?Q?G0wJvhbY2=2FMh8gXkndExOud2LyxMko2i1zJTFmG?=
 =?us-ascii?Q?t7jbdHjreJO5R6qSOJ1WF6yxZnYn7O0IaWLElRr?=
 =?us-ascii?Q?Md5OiibAIyYrMG8eEwCZr9h7G7Y8Ar3tGAGXFzp?=
 =?us-ascii?Q?aPNfZpJeHvu1WMPbTljQj31gCpUDHiDDWy0l2H?=
To:     Ajay Singh <ajay.kathat@microchip.com>
Cc:     Claudiu Beznea <claudiu.beznea@microchip.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        David Mosberger-Tang <davidm@egauge.net>
X-Entity-ID: Xg4JGAcGrJFIz2kDG9eoaQ==
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=us-ascii
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Without this patch, trying to use:

	iw dev wlan0 set power_save on

before the driver is initialized results in an EIO error.  It is more
useful to simply remember the desired setting and establish it when
the driver is initialized.

Signed-off-by: David Mosberger-Tang <davidm@egauge.net>
---
 drivers/net/wireless/microchip/wilc1000/cfg80211.c | 3 ---
 drivers/net/wireless/microchip/wilc1000/hif.c      | 8 ++++++++
 drivers/net/wireless/microchip/wilc1000/netdev.c   | 3 ++-
 3 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/cfg80211.c b/drivers/net/wireless/microchip/wilc1000/cfg80211.c
index dc4bfe7be378..01d607fa2ded 100644
--- a/drivers/net/wireless/microchip/wilc1000/cfg80211.c
+++ b/drivers/net/wireless/microchip/wilc1000/cfg80211.c
@@ -1280,9 +1280,6 @@ static int set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
 	struct wilc_vif *vif = netdev_priv(dev);
 	struct wilc_priv *priv = &vif->priv;
 
-	if (!priv->hif_drv)
-		return -EIO;
-
 	wilc_set_power_mgmt(vif, enabled, timeout);
 
 	return 0;
diff --git a/drivers/net/wireless/microchip/wilc1000/hif.c b/drivers/net/wireless/microchip/wilc1000/hif.c
index 29a42bc47017..66fd77c816f7 100644
--- a/drivers/net/wireless/microchip/wilc1000/hif.c
+++ b/drivers/net/wireless/microchip/wilc1000/hif.c
@@ -1934,6 +1934,14 @@ int wilc_set_power_mgmt(struct wilc_vif *vif, bool enabled, u32 timeout)
 	int result;
 	s8 power_mode;
 
+	if (!wilc->initialized) {
+		/* Simply remember the desired setting for now; will be
+		 * established by wilc_init_fw_config().
+		 */
+		wilc->power_save_mode = enabled;
+		return 0;
+	}
+
 	if (enabled)
 		power_mode = WILC_FW_MIN_FAST_PS;
 	else
diff --git a/drivers/net/wireless/microchip/wilc1000/netdev.c b/drivers/net/wireless/microchip/wilc1000/netdev.c
index 4712cd7dff9f..082bed26a981 100644
--- a/drivers/net/wireless/microchip/wilc1000/netdev.c
+++ b/drivers/net/wireless/microchip/wilc1000/netdev.c
@@ -244,6 +244,7 @@ static int wilc1000_firmware_download(struct net_device *dev)
 static int wilc_init_fw_config(struct net_device *dev, struct wilc_vif *vif)
 {
 	struct wilc_priv *priv = &vif->priv;
+	struct wilc *wilc = vif->wilc;
 	struct host_if_drv *hif_drv;
 	u8 b;
 	u16 hw;
@@ -305,7 +306,7 @@ static int wilc_init_fw_config(struct net_device *dev, struct wilc_vif *vif)
 	if (!wilc_wlan_cfg_set(vif, 0, WID_QOS_ENABLE, &b, 1, 0, 0))
 		goto fail;
 
-	b = WILC_FW_NO_POWERSAVE;
+	b = wilc->power_save_mode ? WILC_FW_MIN_FAST_PS : WILC_FW_NO_POWERSAVE;
 	if (!wilc_wlan_cfg_set(vif, 0, WID_POWER_MANAGEMENT, &b, 1, 0, 0))
 		goto fail;
 
-- 
2.25.1

