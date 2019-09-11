Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBE98AFD52
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 15:03:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728053AbfIKNDZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 09:03:25 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:47422 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726954AbfIKNDZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 09:03:25 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 043A860A50; Wed, 11 Sep 2019 13:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1568207004;
        bh=Jx/H8oT6Fb0ToJyhm6N2k1MFhWHCeP6x1nQka7AZfdM=;
        h=From:To:Cc:Subject:Date:From;
        b=NmoSn7t7TUkRwv+lUPdCOllROZ4p+i2djL8MovwBf9L933YaJHFCbmV1/PZZOogzN
         28qpb7JKkDXfnHfUS97+yDfMcy4Bdg8ABrKsFHymfk3Wg3BdpjPZfXgYeRkboygjG4
         hPFixsZ4j278JhheI9NgIGoTJn6sASansHBG7cHM=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.0
Received: from jouni.codeaurora.org (37-130-183-34.bb.dnainternet.fi [37.130.183.34])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: jouni@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id AD7D4604D4;
        Wed, 11 Sep 2019 13:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1568207003;
        bh=Jx/H8oT6Fb0ToJyhm6N2k1MFhWHCeP6x1nQka7AZfdM=;
        h=From:To:Cc:Subject:Date:From;
        b=Jy+sAxVJ7qrvnRCr9Z4GyR3HLlNeI+hIhh0Uc67TAaZiiy3eI6m22N56jz+yl1UvD
         dtSJDx1K89Y3ngKWHKkDCNuAWls/JyoZaiebCYZcuQfgy2VPi3rNv8maPjDjHUHzyW
         h4IBRmiESb9KSJ1HPRbMlRr6r6Xvss5bybowIdVA=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org AD7D4604D4
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=jouni@codeaurora.org
From:   Jouni Malinen <jouni@codeaurora.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org, David Miller <davem@davemloft.net>,
        netdev@vger.kernel.org, Jouni Malinen <jouni@codeaurora.org>
Subject: [PATCH] mac80211: Do not send Layer 2 Update frame before authorization
Date:   Wed, 11 Sep 2019 16:03:05 +0300
Message-Id: <20190911130305.23704-1-jouni@codeaurora.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Layer 2 Update frame is used to update bridges when a station roams
to another AP even if that STA does not transmit any frames after the
reassociation. This behavior was described in IEEE Std 802.11F-2003 as
something that would happen based on MLME-ASSOCIATE.indication, i.e.,
before completing 4-way handshake. However, this IEEE trial-use
recommended practice document was published before RSN (IEEE Std
802.11i-2004) and as such, did not consider RSN use cases. Furthermore,
IEEE Std 802.11F-2003 was withdrawn in 2006 and as such, has not been
maintained amd should not be used anymore.

Sending out the Layer 2 Update frame immediately after association is
fine for open networks (and also when using SAE, FT protocol, or FILS
authentication when the station is actually authenticated by the time
association completes). However, it is not appropriate for cases where
RSN is used with PSK or EAP authentication since the station is actually
fully authenticated only once the 4-way handshake completes after
authentication and attackers might be able to use the unauthenticated
triggering of Layer 2 Update frame transmission to disrupt bridge
behavior.

Fix this by postponing transmission of the Layer 2 Update frame from
station entry addition to the point when the station entry is marked
authorized. Similarly, send out the VLAN binding update only if the STA
entry has already been authorized.

Signed-off-by: Jouni Malinen <jouni@codeaurora.org>
---
 net/mac80211/cfg.c      | 14 ++++----------
 net/mac80211/sta_info.c |  4 ++++
 2 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index ed56b0c6fe19..817f37b64eb5 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1532,7 +1532,6 @@ static int ieee80211_add_station(struct wiphy *wiphy, struct net_device *dev,
 	struct sta_info *sta;
 	struct ieee80211_sub_if_data *sdata;
 	int err;
-	int layer2_update;
 
 	if (params->vlan) {
 		sdata = IEEE80211_DEV_TO_SUB_IF(params->vlan);
@@ -1575,18 +1574,12 @@ static int ieee80211_add_station(struct wiphy *wiphy, struct net_device *dev,
 	    test_sta_flag(sta, WLAN_STA_ASSOC))
 		rate_control_rate_init(sta);
 
-	layer2_update = sdata->vif.type == NL80211_IFTYPE_AP_VLAN ||
-		sdata->vif.type == NL80211_IFTYPE_AP;
-
 	err = sta_info_insert_rcu(sta);
 	if (err) {
 		rcu_read_unlock();
 		return err;
 	}
 
-	if (layer2_update)
-		cfg80211_send_layer2_update(sta->sdata->dev, sta->sta.addr);
-
 	rcu_read_unlock();
 
 	return 0;
@@ -1684,10 +1677,11 @@ static int ieee80211_change_station(struct wiphy *wiphy,
 		sta->sdata = vlansdata;
 		ieee80211_check_fast_xmit(sta);
 
-		if (test_sta_flag(sta, WLAN_STA_AUTHORIZED))
+		if (test_sta_flag(sta, WLAN_STA_AUTHORIZED)) {
 			ieee80211_vif_inc_num_mcast(sta->sdata);
-
-		cfg80211_send_layer2_update(sta->sdata->dev, sta->sta.addr);
+			cfg80211_send_layer2_update(sta->sdata->dev,
+						    sta->sta.addr);
+		}
 	}
 
 	err = sta_apply_parameters(local, sta, params);
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index df553070206c..bd11fef2139f 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1979,6 +1979,10 @@ int sta_info_move_state(struct sta_info *sta,
 			ieee80211_check_fast_xmit(sta);
 			ieee80211_check_fast_rx(sta);
 		}
+		if (sta->sdata->vif.type == NL80211_IFTYPE_AP_VLAN ||
+		    sta->sdata->vif.type == NL80211_IFTYPE_AP)
+			cfg80211_send_layer2_update(sta->sdata->dev,
+						    sta->sta.addr);
 		break;
 	default:
 		break;
-- 
2.20.1

