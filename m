Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87F632DB280
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 18:26:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730841AbgLORYw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 12:24:52 -0500
Received: from alexa-out.qualcomm.com ([129.46.98.28]:7628 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729872AbgLORYk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 12:24:40 -0500
Received: from ironmsg07-lv.qualcomm.com (HELO ironmsg07-lv.qulacomm.com) ([10.47.202.151])
  by alexa-out.qualcomm.com with ESMTP; 15 Dec 2020 09:24:00 -0800
X-QCInternal: smtphost
Received: from ironmsg02-blr.qualcomm.com ([10.86.208.131])
  by ironmsg07-lv.qulacomm.com with ESMTP/TLS/AES256-SHA; 15 Dec 2020 09:23:58 -0800
X-QCInternal: smtphost
Received: from youghand-linux.qualcomm.com ([10.206.66.115])
  by ironmsg02-blr.qualcomm.com with ESMTP; 15 Dec 2020 22:53:55 +0530
Received: by youghand-linux.qualcomm.com (Postfix, from userid 2370257)
        id A45F820F17; Tue, 15 Dec 2020 22:53:54 +0530 (IST)
From:   Youghandhar Chintala <youghand@codeaurora.org>
To:     johannes@sipsolutions.net
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kuabhs@chromium.org,
        dianders@chromium.org, briannorris@chromium.org,
        pillair@codeaurora.org,
        Youghandhar Chintala <youghand@codeaurora.org>
Subject: [PATCH 2/3] mac80211: Add support to trigger sta disconnect on hardware restart
Date:   Tue, 15 Dec 2020 22:53:52 +0530
Message-Id: <20201215172352.5311-1-youghand@codeaurora.org>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently in case of target hardware restart, we just reconfig and
re-enable the security keys and enable the network queues to start
data traffic back from where it was interrupted.

Many ath10k wifi chipsets have sequence numbers for the data
packets assigned by firmware and the mac sequence number will
restart from zero after target hardware restart leading to mismatch
in the sequence number expected by the remote peer vs the sequence
number of the frame sent by the target firmware.

This mismatch in sequence number will cause out-of-order packets
on the remote peer and all the frames sent by the device are dropped
until we reach the sequence number which was sent before we restarted
the target hardware

In order to fix this, we trigger a sta disconnect, for the targets
which expose this corresponding wiphy flag, in case of target hw
restart. After this there will be a fresh connection and thereby
avoiding the dropping of frames by remote peer.

The right fix would be to pull the entire data path into the host
which is not feasible or would need lots of complex changes and
will still be inefficient.

Tested on ath10k using WCN3990, QCA6174

Signed-off-by: Youghandhar Chintala <youghand@codeaurora.org>
---
 net/mac80211/ieee80211_i.h |  3 +++
 net/mac80211/mlme.c        |  9 +++++++++
 net/mac80211/util.c        | 22 +++++++++++++++++++---
 3 files changed, 31 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index cde2e3f..8cbeb5f 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -748,6 +748,8 @@ struct ieee80211_if_mesh {
  *	back to wireless media and to the local net stack.
  * @IEEE80211_SDATA_DISCONNECT_RESUME: Disconnect after resume.
  * @IEEE80211_SDATA_IN_DRIVER: indicates interface was added to driver
+ * @IEEE80211_SDATA_DISCONNECT_HW_RESTART: Disconnect after hardware restart
+ *	recovery
  */
 enum ieee80211_sub_if_data_flags {
 	IEEE80211_SDATA_ALLMULTI		= BIT(0),
@@ -755,6 +757,7 @@ enum ieee80211_sub_if_data_flags {
 	IEEE80211_SDATA_DONT_BRIDGE_PACKETS	= BIT(3),
 	IEEE80211_SDATA_DISCONNECT_RESUME	= BIT(4),
 	IEEE80211_SDATA_IN_DRIVER		= BIT(5),
+	IEEE80211_SDATA_DISCONNECT_HW_RESTART	= BIT(6),
 };
 
 /**
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 6adfcb9..e4d0d16 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -4769,6 +4769,15 @@ void ieee80211_sta_restart(struct ieee80211_sub_if_data *sdata)
 					      true);
 		sdata_unlock(sdata);
 		return;
+	} else if (sdata->flags & IEEE80211_SDATA_DISCONNECT_HW_RESTART) {
+		sdata->flags &= ~IEEE80211_SDATA_DISCONNECT_HW_RESTART;
+		mlme_dbg(sdata, "driver requested disconnect after hardware restart\n");
+		ieee80211_sta_connection_lost(sdata,
+					      ifmgd->associated->bssid,
+					      WLAN_REASON_UNSPECIFIED,
+					      true);
+		sdata_unlock(sdata);
+		return;
 	}
 	sdata_unlock(sdata);
 }
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 8c3c01a..98567a3 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2567,9 +2567,12 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 	}
 	mutex_unlock(&local->sta_mtx);
 
-	/* add back keys */
-	list_for_each_entry(sdata, &local->interfaces, list)
-		ieee80211_reenable_keys(sdata);
+
+	if (!(hw->wiphy->flags & WIPHY_FLAG_STA_DISCONNECT_ON_HW_RESTART)) {
+		/* add back keys */
+		list_for_each_entry(sdata, &local->interfaces, list)
+			ieee80211_reenable_keys(sdata);
+	}
 
 	/* Reconfigure sched scan if it was interrupted by FW restart */
 	mutex_lock(&local->mtx);
@@ -2643,6 +2646,19 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 					IEEE80211_QUEUE_STOP_REASON_SUSPEND,
 					false);
 
+	if ((hw->wiphy->flags & WIPHY_FLAG_STA_DISCONNECT_ON_HW_RESTART) &&
+	    !reconfig_due_to_wowlan) {
+		list_for_each_entry(sdata, &local->interfaces, list) {
+			if (!ieee80211_sdata_running(sdata))
+				continue;
+			if (sdata->vif.type == NL80211_IFTYPE_STATION) {
+				sdata->flags |=
+					IEEE80211_SDATA_DISCONNECT_HW_RESTART;
+				ieee80211_sta_restart(sdata);
+			}
+		}
+	}
+
 	/*
 	 * If this is for hw restart things are still running.
 	 * We may want to change that later, however.
-- 
2.7.4

