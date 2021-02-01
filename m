Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFF6830A283
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 08:09:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232122AbhBAHI7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 02:08:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232382AbhBAHHc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 02:07:32 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B4F8C0613D6
        for <netdev@vger.kernel.org>; Sun, 31 Jan 2021 23:07:17 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id nm1so1426726pjb.3
        for <netdev@vger.kernel.org>; Sun, 31 Jan 2021 23:07:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yEAXr+uYT47arw+BgtSxxjuiMvD2994EjnVkSqzNVfY=;
        b=W57OCjk6JbbEC4TjR83KofLCibS8dcJom3IZSNhSRjw5CSmPK6uBlvGID5M8peSK1g
         qbg2aSsCsVu9ARLEz506EijrXcJ5cuXfR7bEvPEGoLV1lckL1uC9baxQJI3Vvx2z3tj0
         cyXH9yc3PwbWbOlLXj4Lhsj8YujMnzZQTFyj8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yEAXr+uYT47arw+BgtSxxjuiMvD2994EjnVkSqzNVfY=;
        b=dsevo/uxdOMZXbWoHcRtrgPFzr1L7Sko4sKGNasLg1IJX3VHUfL6T3PWnAob9YH2OI
         XRymvs3kXlOY2u3NK1jaqA5x9RB+cMVyAw+lmY14dd1VJd+nNGpDoj035hcCNehZdz2R
         V7aEAD9fqvSbOQKp1XHv3X/wH+oqlVB5j+FLsFh15LoQYo/nqr8cO23W1QP92yetI7GH
         Dw4vhFGsFKppjR6ppvr1L2pcWuLdVjr7QtPdthR6iKDD84sopODMovAPFAsXOqoXj/UU
         Jp9Kb4ZblkeykmczrtIJod1EATf9mFa9Udn3RcbsXdE7WaePB5z0ZLq0nOsNzQXEspn7
         sZ5w==
X-Gm-Message-State: AOAM5324Fv/+EVh2zKnR/bXX4QdcMpvOWfPqhqaGRAujM/XTSOi7bj+y
        Xf0smy5BKW+v3WcjJl6ILWOiVQ==
X-Google-Smtp-Source: ABdhPJzYlktOhXkvTLg/xc7MCjc/pyZp0lyHg6HFBKuSA4R/WhR/9EXFwjDKeLhZBARJQLstYAGF8Q==
X-Received: by 2002:a17:90a:b282:: with SMTP id c2mr16030435pjr.54.1612163236914;
        Sun, 31 Jan 2021 23:07:16 -0800 (PST)
Received: from localhost ([2401:fa00:1:b:158e:ed37:38d6:db19])
        by smtp.gmail.com with ESMTPSA id a22sm14306240pjh.5.2021.01.31.23.07.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 31 Jan 2021 23:07:16 -0800 (PST)
From:   Yen-lin Lai <yenlinlai@chromium.org>
To:     linux-wireless@vger.kernel.org
Cc:     Brian Norris <briannorris@chromium.org>,
        Yen-lin Lai <yenlinlai@chromium.org>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Xinming Hu <huxinming820@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] mwifiex: Report connected BSS with cfg80211_connect_bss()
Date:   Mon,  1 Feb 2021 15:06:49 +0800
Message-Id: <20210201070649.1667209-1-yenlinlai@chromium.org>
X-Mailer: git-send-email 2.30.0.365.g02bc693789-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a network is moved or reconfigured on the different channel, there
can be multiple BSSes with the same BSSID and SSID in scan result
before the old one expires. Then, it can cause cfg80211_connect_result
to map current_bss to a bss with the wrong channel.

Let mwifiex_cfg80211_assoc return the selected BSS and then the caller
can report it cfg80211_connect_bss.

Signed-off-by: Yen-lin Lai <yenlinlai@chromium.org>

---

 .../net/wireless/marvell/mwifiex/cfg80211.c   | 35 ++++++++++++++-----
 1 file changed, 26 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index a6b9dc6700b1..4bae83e47e9e 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -2173,7 +2173,8 @@ static int
 mwifiex_cfg80211_assoc(struct mwifiex_private *priv, size_t ssid_len,
 		       const u8 *ssid, const u8 *bssid, int mode,
 		       struct ieee80211_channel *channel,
-		       struct cfg80211_connect_params *sme, bool privacy)
+		       struct cfg80211_connect_params *sme, bool privacy,
+		       struct cfg80211_bss **sel_bss)
 {
 	struct cfg80211_ssid req_ssid;
 	int ret, auth_type = 0;
@@ -2307,17 +2308,31 @@ mwifiex_cfg80211_assoc(struct mwifiex_private *priv, size_t ssid_len,
 		}
 	}
 
+	if (bss)
+		cfg80211_ref_bss(priv->adapter->wiphy, bss);
+
 	ret = mwifiex_bss_start(priv, bss, &req_ssid);
 	if (ret)
-		return ret;
+		goto cleanup;
 
 	if (mode == NL80211_IFTYPE_ADHOC) {
 		/* Inform the BSS information to kernel, otherwise
 		 * kernel will give a panic after successful assoc */
-		if (mwifiex_cfg80211_inform_ibss_bss(priv))
-			return -EFAULT;
+		if (mwifiex_cfg80211_inform_ibss_bss(priv)) {
+			ret = -EFAULT;
+			goto cleanup;
+		}
 	}
 
+	/* Pass the selected BSS entry to caller. */
+	if (sel_bss) {
+		*sel_bss = bss;
+		bss = NULL;
+	}
+
+cleanup:
+	if (bss)
+		cfg80211_put_bss(priv->adapter->wiphy, bss);
 	return ret;
 }
 
@@ -2334,6 +2349,7 @@ mwifiex_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 {
 	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
 	struct mwifiex_adapter *adapter = priv->adapter;
+	struct cfg80211_bss *bss = NULL;
 	int ret;
 
 	if (GET_BSS_ROLE(priv) != MWIFIEX_BSS_ROLE_STA) {
@@ -2369,11 +2385,12 @@ mwifiex_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 		cfg80211_sched_scan_stopped_rtnl(priv->wdev.wiphy, 0);
 
 	ret = mwifiex_cfg80211_assoc(priv, sme->ssid_len, sme->ssid, sme->bssid,
-				     priv->bss_mode, sme->channel, sme, 0);
+				     priv->bss_mode, sme->channel, sme, 0,
+				     &bss);
 	if (!ret) {
-		cfg80211_connect_result(priv->netdev, priv->cfg_bssid, NULL, 0,
-					NULL, 0, WLAN_STATUS_SUCCESS,
-					GFP_KERNEL);
+		cfg80211_connect_bss(priv->netdev, priv->cfg_bssid, bss, NULL,
+				     0, NULL, 0, WLAN_STATUS_SUCCESS,
+				     GFP_KERNEL, NL80211_TIMEOUT_UNSPECIFIED);
 		mwifiex_dbg(priv->adapter, MSG,
 			    "info: associated to bssid %pM successfully\n",
 			    priv->cfg_bssid);
@@ -2504,7 +2521,7 @@ mwifiex_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *dev,
 	ret = mwifiex_cfg80211_assoc(priv, params->ssid_len, params->ssid,
 				     params->bssid, priv->bss_mode,
 				     params->chandef.chan, NULL,
-				     params->privacy);
+				     params->privacy, NULL);
 done:
 	if (!ret) {
 		cfg80211_ibss_joined(priv->netdev, priv->cfg_bssid,
-- 
2.30.0.365.g02bc693789-goog

