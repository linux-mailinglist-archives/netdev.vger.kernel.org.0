Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93A6F315B92
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 01:49:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234721AbhBJArm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 19:47:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234472AbhBJApW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 19:45:22 -0500
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53CFBC061797
        for <netdev@vger.kernel.org>; Tue,  9 Feb 2021 16:42:34 -0800 (PST)
Received: by mail-ot1-x32e.google.com with SMTP id c16so309754otp.0
        for <netdev@vger.kernel.org>; Tue, 09 Feb 2021 16:42:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=z79ZGo6240pzhO2w017tO0EYbGsfaiPNtzjr+o4CyVs=;
        b=IzTLSvrpTU984HA6FPmdIzo9c6yUerDFYx83kwD6vDItCnWrzOaqUZxkMK4IpSWaRu
         X7ouFY7siJXiMCMfiq0Uyv7L12I1VKyxkPiMaRgpx8/WEPNACGL3zdhgYDftwC/uzMyY
         OA1xt8kCu8ptII2jy+Z3CIpBxzLL1s7XaMulQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=z79ZGo6240pzhO2w017tO0EYbGsfaiPNtzjr+o4CyVs=;
        b=kgmQiJ6ZVnIlLdpayESFQ0qFdDNZUzoEF6elxEUuKEnJLuoiFzv8F0tmI43+UKd/wc
         9IHxrJVFjWuRqsgIY2UDvYufo0OHyVKSmbtRf6ji7Q+pGzpfCDN4IdbXReUMLg0vjyy1
         FT5iBnyNy3BbmwZ18zCjW+hZE6PneD+6PbtLwkwMOyZWIvMOBP0twWLKIM4CF0if5khl
         ewpaEAN31PF7APOA63Mkgdqbwf0RHmTECZH+oaDv92pNziG14LMrOh3SxAvt2uVB70kK
         P292wat93OTziOD5ZI05GlAbX07AJjF8T0oy4jSz/4/6EBpKyenzfgI+ZbVwDghQrcjE
         CK4w==
X-Gm-Message-State: AOAM5336BXgmFveXZsMHGquwYASnymUP8barLDhE37Oeal7ymgX17fiY
        HPpTI6WQ893JvjV6UctR8YJtnw==
X-Google-Smtp-Source: ABdhPJxB0TlZqQYNJ/niDq4cWTmLSxwTkRDSAQZFaHU3r9ztbpakBwJQt50GOVe3qiWjqQ1PoSba0g==
X-Received: by 2002:a05:6830:1bc9:: with SMTP id v9mr259484ota.106.1612917752876;
        Tue, 09 Feb 2021 16:42:32 -0800 (PST)
Received: from shuah-t480s.internal (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id s123sm103060oos.3.2021.02.09.16.42.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Feb 2021 16:42:32 -0800 (PST)
From:   Shuah Khan <skhan@linuxfoundation.org>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     Shuah Khan <skhan@linuxfoundation.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] ath10k: fix WARNING: suspicious RCU usage
Date:   Tue,  9 Feb 2021 17:42:23 -0700
Message-Id: <23a1333dfb0367cc69e7177a2e373df0b6d42980.1612915444.git.skhan@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1612915444.git.skhan@linuxfoundation.org>
References: <cover.1612915444.git.skhan@linuxfoundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ieee80211_find_sta_by_ifaddr() must be called under the RCU lock and
the resulting pointer is only valid under RCU lock as well.

Fix ath10k_wmi_tlv_parse_peer_stats_info() to hold RCU lock before it
calls ieee80211_find_sta_by_ifaddr() and release it when the resulting
pointer is no longer needed. The log below shows the problem.

While at it, fix ath10k_wmi_tlv_op_pull_peer_stats_info() to do the same.

=============================
WARNING: suspicious RCU usage
5.11.0-rc7+ #20 Tainted: G        W
-----------------------------
include/linux/rhashtable.h:594 suspicious rcu_dereference_check() usage!
other info that might help us debug this:
               rcu_scheduler_active = 2, debug_locks = 1
no locks held by ksoftirqd/5/44.

stack backtrace:
CPU: 5 PID: 44 Comm: ksoftirqd/5 Tainted: G        W         5.11.0-rc7+ #20
Hardware name: LENOVO 10VGCTO1WW/3130, BIOS M1XKT45A 08/21/2019
Call Trace:
 dump_stack+0x7d/0x9f
 lockdep_rcu_suspicious+0xdb/0xe5
 __rhashtable_lookup+0x1eb/0x260 [mac80211]
 ieee80211_find_sta_by_ifaddr+0x5b/0xc0 [mac80211]
 ath10k_wmi_tlv_parse_peer_stats_info+0x3e/0x90 [ath10k_core]
 ath10k_wmi_tlv_iter+0x6a/0xc0 [ath10k_core]
 ? ath10k_wmi_tlv_op_pull_mgmt_tx_bundle_compl_ev+0xe0/0xe0 [ath10k_core]
 ath10k_wmi_tlv_op_rx+0x5da/0xda0 [ath10k_core]
 ? trace_hardirqs_on+0x54/0xf0
 ? ath10k_ce_completed_recv_next+0x4e/0x60 [ath10k_core]
 ath10k_wmi_process_rx+0x1d/0x40 [ath10k_core]
 ath10k_htc_rx_completion_handler+0x115/0x180 [ath10k_core]
 ath10k_pci_process_rx_cb+0x149/0x1b0 [ath10k_pci]
 ? ath10k_htc_process_trailer+0x2d0/0x2d0 [ath10k_core]
 ? ath10k_pci_sleep.part.0+0x6a/0x80 [ath10k_pci]
 ath10k_pci_htc_rx_cb+0x15/0x20 [ath10k_pci]
 ath10k_ce_per_engine_service+0x61/0x80 [ath10k_core]
 ath10k_ce_per_engine_service_any+0x7d/0xa0 [ath10k_core]
 ath10k_pci_napi_poll+0x48/0x120 [ath10k_pci]
 net_rx_action+0x136/0x500
 __do_softirq+0xc6/0x459
 ? smpboot_thread_fn+0x2b/0x1f0
 run_ksoftirqd+0x2b/0x60
 smpboot_thread_fn+0x116/0x1f0
 kthread+0x14b/0x170
 ? smpboot_register_percpu_thread+0xe0/0xe0
 ? __kthread_bind_mask+0x70/0x70
 ret_from_fork+0x22/0x30

Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
---
 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index 7b5834157fe5..615157dd6866 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -225,6 +225,7 @@ static int ath10k_wmi_tlv_parse_peer_stats_info(struct ath10k *ar, u16 tag, u16
 	const struct wmi_tlv_peer_stats_info *stat = ptr;
 	struct ieee80211_sta *sta;
 	struct ath10k_sta *arsta;
+	int ret = 0;
 
 	if (tag != WMI_TLV_TAG_STRUCT_PEER_STATS_INFO)
 		return -EPROTO;
@@ -240,10 +241,12 @@ static int ath10k_wmi_tlv_parse_peer_stats_info(struct ath10k *ar, u16 tag, u16
 		   __le32_to_cpu(stat->last_tx_rate_code),
 		   __le32_to_cpu(stat->last_tx_bitrate_kbps));
 
+	rcu_read_lock();
 	sta = ieee80211_find_sta_by_ifaddr(ar->hw, stat->peer_macaddr.addr, NULL);
 	if (!sta) {
 		ath10k_warn(ar, "not found station for peer stats\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto exit;
 	}
 
 	arsta = (struct ath10k_sta *)sta->drv_priv;
@@ -252,7 +255,9 @@ static int ath10k_wmi_tlv_parse_peer_stats_info(struct ath10k *ar, u16 tag, u16
 	arsta->tx_rate_code = __le32_to_cpu(stat->last_tx_rate_code);
 	arsta->tx_bitrate_kbps = __le32_to_cpu(stat->last_tx_bitrate_kbps);
 
-	return 0;
+exit:
+	rcu_read_unlock();
+	return ret;
 }
 
 static int ath10k_wmi_tlv_op_pull_peer_stats_info(struct ath10k *ar,
@@ -573,13 +578,13 @@ static void ath10k_wmi_event_tdls_peer(struct ath10k *ar, struct sk_buff *skb)
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
@@ -590,6 +595,8 @@ static void ath10k_wmi_event_tdls_peer(struct ath10k *ar, struct sk_buff *skb)
 					);
 		break;
 	}
+exit:
+	rcu_read_unlock();
 	kfree(tb);
 }
 
-- 
2.27.0

