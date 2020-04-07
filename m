Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5F7C1A0AD8
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 12:11:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728140AbgDGKLh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 06:11:37 -0400
Received: from mail-pj1-f65.google.com ([209.85.216.65]:32929 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726716AbgDGKLg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Apr 2020 06:11:36 -0400
Received: by mail-pj1-f65.google.com with SMTP id cp9so1025641pjb.0
        for <netdev@vger.kernel.org>; Tue, 07 Apr 2020 03:11:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=3Lk5/xOF8GmAm5CGxsYxvvNGCwk8oZx7GJZ2RMStRsA=;
        b=sVoo3UD03yj9EpPDPBT1OiLH75+8rv65KzM6qPBb35hNNuwPd8TSDJVfDT+iFslcV8
         MiUR5iyFHEXsbd8HBTwGvq84HunNGYdHb+0tPlkwiHdo6XZCDwuF9/i8DE0QpBKcmQGM
         grYuEdJk350htD1sYEG9IeofrQHk5uYQU/O/F4w58NEmy5O+DvVVdj9Z3d0I2jzUZetc
         3nYoungIn6blgf1HjfsYeNGDrXqUo+nQYRWj4c4GPMxk+pS13iJGMItuz8xa7e8veNq8
         tmX5peWY1c2qjQnQaKJCxg01IqG+xvaIUEQWZzjA50B+MHmfV4HV/rMomPGT0y7QVOIL
         JT8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=3Lk5/xOF8GmAm5CGxsYxvvNGCwk8oZx7GJZ2RMStRsA=;
        b=tu3LCrYn7mXYyDjCNsnztcfTs3hCjPS9CC5XhKvvdUuJVWJFfE/JjuZBl/pUsOGxxh
         CXLfPQqxc769hkN+10nihRD1+kR8K8N/ZVoESJvGtEuCNEbDXXsOtZRnGmAaJrrnM/KF
         MlPsDY8TGajbijK/eQEUBe7mr/ItiPfoodUgM7dOnK/oX6vldtwvIcww9A1F53B3gFt6
         NTpGQcOamvlPYj/5B0Dmp1yooS6SX3do8J/OXu60mEyDpWeLBaxpoCjY7DL3YCEo517s
         c/2bKTsvaLwPUgItgglh3I9yFNgRCAxL3e6N66b1vln8wD33Rk5Z7Zh2JI7ESbTVgNrw
         4hJQ==
X-Gm-Message-State: AGi0PuasWUgTG6DkAgVctXn0ZnoBx69JdeTvCTdJqFefxIYzp+b5tk3V
        /4jDyPYRP1QwN5rfM6xrsIjA4Q==
X-Google-Smtp-Source: APiQypIK+S5PEPLtnd7TZeAcCYxZYT5PuRWNTQmfbuH/XPngzM4EJQcB3Sxl1EsdijdFqy4CGHVbHQ==
X-Received: by 2002:a17:90a:c256:: with SMTP id d22mr1911489pjx.78.1586254295563;
        Tue, 07 Apr 2020 03:11:35 -0700 (PDT)
Received: from localhost.localdomain ([117.196.230.86])
        by smtp.gmail.com with ESMTPSA id q67sm1228692pjq.29.2020.04.07.03.11.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 07 Apr 2020 03:11:34 -0700 (PDT)
From:   Sumit Garg <sumit.garg@linaro.org>
To:     linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Cc:     davem@davemloft.net, kuba@kernel.org, kvalo@codeaurora.org,
        chaitanya.mgit@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, matthias.schoepfer@ithinx.io,
        Philipp.Berg@liebherr.com, Michael.Weitner@liebherr.com,
        daniel.thompson@linaro.org, loic.poulain@linaro.org,
        Sumit Garg <sumit.garg@linaro.org>, stable@vger.kernel.org
Subject: [PATCH v2] mac80211: fix race in ieee80211_register_hw()
Date:   Tue,  7 Apr 2020 15:40:55 +0530
Message-Id: <1586254255-28713-1-git-send-email-sumit.garg@linaro.org>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A race condition leading to a kernel crash is observed during invocation
of ieee80211_register_hw() on a dragonboard410c device having wcn36xx
driver built as a loadable module along with a wifi manager in user-space
waiting for a wifi device (wlanX) to be active.

Sequence diagram for a particular kernel crash scenario:

    user-space  ieee80211_register_hw()  ieee80211_tasklet_handler()
    ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
       |                    |                 |
       |<---phy0----wiphy_register()          |
       |-----iwd if_add---->|                 |
       |                    |<---IRQ----(RX packet)
       |              Kernel crash            |
       |              due to unallocated      |
       |              workqueue.              |
       |                    |                 |
       |       alloc_ordered_workqueue()      |
       |                    |                 |
       |              Misc wiphy init.        |
       |                    |                 |
       |            ieee80211_if_add()        |
       |                    |                 |

As evident from above sequence diagram, this race condition isn't specific
to a particular wifi driver but rather the initialization sequence in
ieee80211_register_hw() needs to be fixed. So re-order the initialization
sequence and the updated sequence diagram would look like:

    user-space  ieee80211_register_hw()  ieee80211_tasklet_handler()
    ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
       |                    |                 |
       |       alloc_ordered_workqueue()      |
       |                    |                 |
       |              Misc wiphy init.        |
       |                    |                 |
       |<---phy0----wiphy_register()          |
       |-----iwd if_add---->|                 |
       |                    |<---IRQ----(RX packet)
       |                    |                 |
       |            ieee80211_if_add()        |
       |                    |                 |

Cc: <stable@vger.kernel.org>
Signed-off-by: Sumit Garg <sumit.garg@linaro.org>
---

Changes in v2:
- Move rtnl_unlock() just after ieee80211_init_rate_ctrl_alg().
- Update sequence diagrams in commit message for more clarification.

 net/mac80211/main.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 4c2b5ba..d497129 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1051,7 +1051,7 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 		local->hw.wiphy->signal_type = CFG80211_SIGNAL_TYPE_UNSPEC;
 		if (hw->max_signal <= 0) {
 			result = -EINVAL;
-			goto fail_wiphy_register;
+			goto fail_workqueue;
 		}
 	}
 
@@ -1113,7 +1113,7 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 
 	result = ieee80211_init_cipher_suites(local);
 	if (result < 0)
-		goto fail_wiphy_register;
+		goto fail_workqueue;
 
 	if (!local->ops->remain_on_channel)
 		local->hw.wiphy->max_remain_on_channel_duration = 5000;
@@ -1139,10 +1139,6 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 
 	local->hw.wiphy->max_num_csa_counters = IEEE80211_MAX_CSA_COUNTERS_NUM;
 
-	result = wiphy_register(local->hw.wiphy);
-	if (result < 0)
-		goto fail_wiphy_register;
-
 	/*
 	 * We use the number of queues for feature tests (QoS, HT) internally
 	 * so restrict them appropriately.
@@ -1207,6 +1203,8 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 		goto fail_rate;
 	}
 
+	rtnl_unlock();
+
 	if (local->rate_ctrl) {
 		clear_bit(IEEE80211_HW_SUPPORTS_VHT_EXT_NSS_BW, hw->flags);
 		if (local->rate_ctrl->ops->capa & RATE_CTRL_CAPA_VHT_EXT_NSS_BW)
@@ -1254,6 +1252,12 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 		local->sband_allocated |= BIT(band);
 	}
 
+	result = wiphy_register(local->hw.wiphy);
+	if (result < 0)
+		goto fail_wiphy_register;
+
+	rtnl_lock();
+
 	/* add one default STA interface if supported */
 	if (local->hw.wiphy->interface_modes & BIT(NL80211_IFTYPE_STATION) &&
 	    !ieee80211_hw_check(hw, NO_AUTO_VIF)) {
@@ -1293,6 +1297,8 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 #if defined(CONFIG_INET) || defined(CONFIG_IPV6)
  fail_ifa:
 #endif
+	wiphy_unregister(local->hw.wiphy);
+ fail_wiphy_register:
 	rtnl_lock();
 	rate_control_deinitialize(local);
 	ieee80211_remove_interfaces(local);
@@ -1302,8 +1308,6 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	ieee80211_led_exit(local);
 	destroy_workqueue(local->workqueue);
  fail_workqueue:
-	wiphy_unregister(local->hw.wiphy);
- fail_wiphy_register:
 	if (local->wiphy_ciphers_allocated)
 		kfree(local->hw.wiphy->cipher_suites);
 	kfree(local->int_scan_req);
@@ -1353,8 +1357,8 @@ void ieee80211_unregister_hw(struct ieee80211_hw *hw)
 	skb_queue_purge(&local->skb_queue_unreliable);
 	skb_queue_purge(&local->skb_queue_tdls_chsw);
 
-	destroy_workqueue(local->workqueue);
 	wiphy_unregister(local->hw.wiphy);
+	destroy_workqueue(local->workqueue);
 	ieee80211_led_exit(local);
 	kfree(local->int_scan_req);
 }
-- 
2.7.4

