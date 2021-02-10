Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 617C6317234
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 22:22:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232738AbhBJVVx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 16:21:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbhBJVVu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 16:21:50 -0500
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D662C061574
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 13:21:10 -0800 (PST)
Received: by mail-oi1-x229.google.com with SMTP id u66so3700461oig.9
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 13:21:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ip1AHGKwKY2VNyKo96TDsETMQmOB/EbZSzj9oNoDO2U=;
        b=NWB5+chUooMs3Trh8sFoEbpC18itlf2XkqapW5z3nrQz7shRIGfGWseyQcnnL4V85x
         HEpqNisHFxn8XKsIDQ144kk61XB2k82rqs9qxy63/SOGXYSfKhqht1LTRZJBKORiMt+t
         +sHQua3NFMbahX/45R5RmXGkcX/rKvYPvc5E8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ip1AHGKwKY2VNyKo96TDsETMQmOB/EbZSzj9oNoDO2U=;
        b=t2LJW/4CW6Ln3kLttMP7lG0+2RAUMS3P57nCbOJV95/YWLiVsvrN5Q+E/ho5gES2hD
         WbEQRE+fx0r6L10UMcopzyZ27VOjfoiXrQ893as4iyEa70MHTXqsh8eHQUu2gQlLIKwh
         4S62CZQV1ntH/sAfMUyH0SQkO+hP87kuOSxdeGxwKxAzPGvXBWMu0U91e0iq2Cz8XuFQ
         cUXaxV7DdaxomV+V954vmHUooyN+2+PVR+BGP4inbTlYRPFuBTrRUNMvPNqq5XHUIyVH
         gptGkLWBHufLxMiBZ0GP4CAY7KKm/jjl8lcGAAf+2aRY6cVGwNlKEUho9iBVBGx7EuDh
         Vg/w==
X-Gm-Message-State: AOAM532zyYTgLRaLTTbcR04PlGUV92UOJqS5JwNTFM6+hGI3fBZhpZlX
        B+qbB5eEFurPub0nFL6treYe/w==
X-Google-Smtp-Source: ABdhPJxrT8FYtLTqI2w9XouF8Nl/Ld4dzKncBZAgYE5/OdBRp3ZyZcfZDRKJ9fkokKBDb8panqyRpA==
X-Received: by 2002:aca:af91:: with SMTP id y139mr718825oie.88.1612992069497;
        Wed, 10 Feb 2021 13:21:09 -0800 (PST)
Received: from shuah-t480s.internal (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id l4sm597454oou.8.2021.02.10.13.21.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Feb 2021 13:21:09 -0800 (PST)
From:   Shuah Khan <skhan@linuxfoundation.org>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     Shuah Khan <skhan@linuxfoundation.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] ath10k: hold RCU lock when calling ieee80211_find_sta_by_ifaddr()
Date:   Wed, 10 Feb 2021 14:21:07 -0700
Message-Id: <20210210212107.40373-1-skhan@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ieee80211_find_sta_by_ifaddr() must be called under the RCU lock and
the resulting pointer is only valid under RCU lock as well.

Fix ath10k_wmi_tlv_op_pull_peer_stats_info() to hold RCU lock before it
calls ieee80211_find_sta_by_ifaddr() and release it when the resulting
pointer is no longer needed.

This problem was found while reviewing code to debug RCU warn from
ath10k_wmi_tlv_parse_peer_stats_info().

Link: https://lore.kernel.org/linux-wireless/7230c9e5-2632-b77e-c4f9-10eca557a5bb@linuxfoundation.org/
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
---
Changes since v1:
- v1 also included fix to ath10k_wmi_tlv_parse_peer_stats_info()
  RCU wrn which was already fixed. v2 drops that and fixes just
  ath10k_wmi_event_tdls_peer()
 
 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index bfdd017f1405..d97b33f789e4 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -576,13 +576,13 @@ static void ath10k_wmi_event_tdls_peer(struct ath10k *ar, struct sk_buff *skb)
 	case WMI_TDLS_TEARDOWN_REASON_TX:
 	case WMI_TDLS_TEARDOWN_REASON_RSSI:
 	case WMI_TDLS_TEARDOWN_REASON_PTR_TIMEOUT:
+		rcu_read_lock();
 		station = ieee80211_find_sta_by_ifaddr(ar->hw,
 						       ev->peer_macaddr.addr,
 						       NULL);
 		if (!station) {
 			ath10k_warn(ar, "did not find station from tdls peer event");
-			kfree(tb);
-			return;
+			goto exit;
 		}
 		arvif = ath10k_get_arvif(ar, __le32_to_cpu(ev->vdev_id));
 		ieee80211_tdls_oper_request(
@@ -593,6 +593,9 @@ static void ath10k_wmi_event_tdls_peer(struct ath10k *ar, struct sk_buff *skb)
 					);
 		break;
 	}
+
+exit:
+	rcu_read_unlock();
 	kfree(tb);
 }
 
-- 
2.27.0

