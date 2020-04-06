Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FF1619F5BB
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 14:23:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727883AbgDFMWv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 08:22:51 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:40443 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727793AbgDFMWu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 08:22:50 -0400
Received: by mail-pl1-f194.google.com with SMTP id h11so5835606plk.7
        for <netdev@vger.kernel.org>; Mon, 06 Apr 2020 05:22:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=iwCr3yzDYxmGeyXo7I4nPmvDOn5x27crLJNYH0MVPHs=;
        b=TiUWw6Wt4+ZEeyTnPdEII0fumOXHJyANslkKPjbDOIV4ATYKpLRsH36K1CbirIvym4
         Ob1I0giCW+RfY8FfnGVLD39KH50mjz5dLS8HLpAnLhZEteyq2IhWaGx/55cTu25mmISh
         pKoemuSHysMf3D3v7d3vA4L1RipwSG+sHu2JwtPP90VMAm5KM4jk+vbIUEO+ufP7S6gR
         fN6d8i+Wy5Ng+zmjy/HnVb50B5mkcsQvlYOjTNE0L/12CG1WbsoIA1cUXieMqGqLwk8t
         GLBQVzISPEnN7YdFE59TOetNR3N+AndHCbDeQFRaIxpVo4MJDzOsf4+6Gbl31m9cn9hG
         uPXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=iwCr3yzDYxmGeyXo7I4nPmvDOn5x27crLJNYH0MVPHs=;
        b=K8HlhJ+BhdDjlk9Mh4EP7fiWUsvHk0oKGO1lzx64GmNcu2ztWVO16pOMjidFBCWwif
         mNVuPmJ5eK003u4SYCIzm8mOopwd9mNXROGPYnPucr9FRFF9IRT49UvDvvo858iIcHXV
         fyirOA4cROH8OANUQIU06fPUu1Qew1PdDzcAI5+LSFS1SIrGbhztZzdVKOhXyv1RjHHt
         1DZZ+gUaRUGTHw3cR9qHtvLf7v/9FEsp0MaDal8O3IWOb3Re5TSRtyiFF/SX3g101CEx
         V3zsV+xqmm9XTYigqkIRtNYwdgIkyOBe3s2kmaqHRtdbqSfLkKjIdXQ87vQhJS/Qj8AG
         45ew==
X-Gm-Message-State: AGi0PuYsUucqkGsptCFRU+iEKFDX0p1QwK00mPOTLaRP0cDoNLjBzRGi
        wdDwg0smxmBC0GOYe+HGSPNv2Q==
X-Google-Smtp-Source: APiQypKfDZwaUil+k+EEgL45D4iyo2ZxZVgHgu893LI2qZbwmFgbUzqssqkaXv3mUo462bYdPax3BA==
X-Received: by 2002:a17:902:8e8b:: with SMTP id bg11mr590892plb.139.1586175769460;
        Mon, 06 Apr 2020 05:22:49 -0700 (PDT)
Received: from localhost.localdomain ([117.196.230.86])
        by smtp.gmail.com with ESMTPSA id t3sm11096413pfl.26.2020.04.06.05.22.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 06 Apr 2020 05:22:48 -0700 (PDT)
From:   Sumit Garg <sumit.garg@linaro.org>
To:     linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        matthias.schoepfer@ithinx.io, Philipp.Berg@liebherr.com,
        Michael.Weitner@liebherr.com, daniel.thompson@linaro.org,
        loic.poulain@linaro.org, Sumit Garg <sumit.garg@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH] mac80211: fix race in ieee80211_register_hw()
Date:   Mon,  6 Apr 2020 17:51:17 +0530
Message-Id: <1586175677-3061-1-git-send-email-sumit.garg@linaro.org>
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

    user-space  ieee80211_register_hw()  RX IRQ
    +++++++++++++++++++++++++++++++++++++++++++++
       |                    |             |
       |<---wlan0---wiphy_register()      |
       |----start wlan0---->|             |
       |                    |<---IRQ---(RX packet)
       |              Kernel crash        |
       |              due to unallocated  |
       |              workqueue.          |
       |                    |             |
       |       alloc_ordered_workqueue()  |
       |                    |             |
       |              Misc wiphy init.    |
       |                    |             |
       |            ieee80211_if_add()    |
       |                    |             |

As evident from above sequence diagram, this race condition isn't specific
to a particular wifi driver but rather the initialization sequence in
ieee80211_register_hw() needs to be fixed. So re-order the initialization
sequence and the updated sequence diagram would look like:

    user-space  ieee80211_register_hw()  RX IRQ
    +++++++++++++++++++++++++++++++++++++++++++++
       |                    |             |
       |       alloc_ordered_workqueue()  |
       |                    |             |
       |              Misc wiphy init.    |
       |                    |             |
       |<---wlan0---wiphy_register()      |
       |----start wlan0---->|             |
       |                    |<---IRQ---(RX packet)
       |                    |             |
       |            ieee80211_if_add()    |
       |                    |             |

Cc: <stable@vger.kernel.org>
Signed-off-by: Sumit Garg <sumit.garg@linaro.org>
---
 net/mac80211/main.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 4c2b5ba..4ca62fc 100644
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
@@ -1254,6 +1250,14 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 		local->sband_allocated |= BIT(band);
 	}
 
+	rtnl_unlock();
+
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

