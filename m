Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4425C30B573
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 03:47:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231482AbhBBCqF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 21:46:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231406AbhBBCp7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 21:45:59 -0500
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A837C061756
        for <netdev@vger.kernel.org>; Mon,  1 Feb 2021 18:45:19 -0800 (PST)
Received: by mail-qk1-x749.google.com with SMTP id 70so14843646qkh.4
        for <netdev@vger.kernel.org>; Mon, 01 Feb 2021 18:45:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=uITZIRq2V6q5qSCUOLhj43gM7pGs59qTkMOHdBiHBX8=;
        b=gY1tDyWFRuA+U5J8SpkhoZAtl/n+BQZ0jU2IUH2scTEb4ip7k5UGLfgxJPpv955Yu3
         y+1YAECTkbOnp8JEoqqhASRyBzzArynhp12Ha0mMBwTAulG7q0SiqsKNpwNOOD1gddaR
         +3NFolkMuHoMwiU2oOe77Kbrf4ORhdry8Tmb87qBN8VFI25Z+ztQOnDjnwsDVyO2XZIa
         PdIu5rPupfsBdnOPTPIxXP4zgFFY4kxAJBU2Ce2cAald0Zko38i4vfzSermB9qxVK4QD
         I7b22E3s2HubXZwNk1x8oq+Mn5mOXth/A352X4mEm6lJfO8xOv7hSA/hBI+c3BsTEsU2
         4NHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=uITZIRq2V6q5qSCUOLhj43gM7pGs59qTkMOHdBiHBX8=;
        b=VABG6pj6fjmxnTD2A0QfojlJOQM435p6ZlaOw7eyLIhI5AwxW27IfLcUFdwca6ktr+
         m9zuwkmD4ZdaMA5en878dSPzza4QXhbMoGpBXisbKMYC17TnuSIawn/IR2Fl8nnPVXiZ
         iFG/pf4eQWaB2swK1StulC7rS9Cv8gzQ4DSI2++77DXq39rZJuv8gL8S3Rw/YR4xw7MB
         p8HJMGz7jPtG0xIOXYxum1iknG4vb4xqVjTmMBPCrhRVKnCCV8RlkwA5txW5f156Ty+b
         tVkfyiFSw84FH7KXznMXu0vyTz3Uvhi8AxpWPQonszB7TFVUjIlU7flsd+VGfkn2ig1s
         AO4A==
X-Gm-Message-State: AOAM531AsV9ZeTZDMxV9PJAfoFiP6VzwP3FXlezzQvhH3PfkiPeMr9q2
        9hYIvijmA9j2HmDikzlvi1ue7DPF3s7m
X-Google-Smtp-Source: ABdhPJydLxnjH3haxCI9g+KQinhtQamnimB5PgiU1eLyouVWd1b/ZdMwmDL8bJ4OYtbFmYyMYlgLc/uVW6WI
Sender: "amistry via sendgmr" <amistry@nandos.syd.corp.google.com>
X-Received: from nandos.syd.corp.google.com ([2401:fa00:9:14:243a:8f72:7104:7a64])
 (user=amistry job=sendgmr) by 2002:a0c:b912:: with SMTP id
 u18mr7724925qvf.2.1612233918714; Mon, 01 Feb 2021 18:45:18 -0800 (PST)
Date:   Tue,  2 Feb 2021 13:45:09 +1100
Message-Id: <20210202134451.1.I0d2e83c42755671b7143504b62787fd06cd914ed@changeid>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.0.365.g02bc693789-goog
Subject: [PATCH] ath10k: Fix suspicious RCU usage warning in ath10k_wmi_tlv_parse_peer_stats_info()
From:   Anand K Mistry <amistry@google.com>
To:     ath10k@lists.infradead.org
Cc:     Anand K Mistry <amistry@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Wen Gong <wgong@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ieee80211_find_sta_by_ifaddr call in
ath10k_wmi_tlv_parse_peer_stats_info must be called while holding the
RCU read lock. Otherwise, the following warning will be seen when RCU
usage checking is enabled:

=============================
WARNING: suspicious RCU usage
5.10.3 #8 Tainted: G        W
-----------------------------
include/linux/rhashtable.h:594 suspicious rcu_dereference_check() usage!

other info that might help us debug this:

rcu_scheduler_active = 2, debug_locks = 1
no locks held by ksoftirqd/1/16.

stack backtrace:
CPU: 1 PID: 16 Comm: ksoftirqd/1 Tainted: G        W         5.10.3 #8
Hardware name: HP Grunt/Grunt, BIOS Google_Grunt.11031.104.0 09/05/2019
Call Trace:
 dump_stack+0xab/0x115
 sta_info_hash_lookup+0x71/0x1e9 [mac80211]
 ? lock_is_held_type+0xe6/0x12f
 ? __kasan_kmalloc+0xfb/0x112
 ieee80211_find_sta_by_ifaddr+0x12/0x61 [mac80211]
 ath10k_wmi_tlv_parse_peer_stats_info+0xbd/0x10b [ath10k_core]
 ath10k_wmi_tlv_iter+0x8b/0x1a1 [ath10k_core]
 ? ath10k_wmi_tlv_iter+0x1a1/0x1a1 [ath10k_core]
 ath10k_wmi_tlv_event_peer_stats_info+0x103/0x13b [ath10k_core]
 ath10k_wmi_tlv_op_rx+0x722/0x80d [ath10k_core]
 ath10k_htc_rx_completion_handler+0x16e/0x1d7 [ath10k_core]
 ath10k_pci_process_rx_cb+0x116/0x22c [ath10k_pci]
 ? ath10k_htc_process_trailer+0x332/0x332 [ath10k_core]
 ? _raw_spin_unlock_irqrestore+0x34/0x61
 ? lockdep_hardirqs_on+0x8e/0x12e
 ath10k_ce_per_engine_service+0x55/0x74 [ath10k_core]
 ath10k_ce_per_engine_service_any+0x76/0x84 [ath10k_core]
 ath10k_pci_napi_poll+0x49/0x141 [ath10k_pci]
 net_rx_action+0x11a/0x347
 __do_softirq+0x2d3/0x539
 run_ksoftirqd+0x4b/0x86
 smpboot_thread_fn+0x1d0/0x2ab
 ? cpu_report_death+0x7f/0x7f
 kthread+0x189/0x191
 ? cpu_report_death+0x7f/0x7f
 ? kthread_blkcg+0x31/0x31
 ret_from_fork+0x22/0x30

Fixes: 0f7cb26830a6e ("ath10k: add rx bitrate report for SDIO")

Signed-off-by: Anand K Mistry <amistry@google.com>
---

 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index 7b5834157fe5..e6135795719a 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -240,8 +240,10 @@ static int ath10k_wmi_tlv_parse_peer_stats_info(struct ath10k *ar, u16 tag, u16
 		   __le32_to_cpu(stat->last_tx_rate_code),
 		   __le32_to_cpu(stat->last_tx_bitrate_kbps));
 
+	rcu_read_lock();
 	sta = ieee80211_find_sta_by_ifaddr(ar->hw, stat->peer_macaddr.addr, NULL);
 	if (!sta) {
+		rcu_read_unlock();
 		ath10k_warn(ar, "not found station for peer stats\n");
 		return -EINVAL;
 	}
@@ -251,6 +253,7 @@ static int ath10k_wmi_tlv_parse_peer_stats_info(struct ath10k *ar, u16 tag, u16
 	arsta->rx_bitrate_kbps = __le32_to_cpu(stat->last_rx_bitrate_kbps);
 	arsta->tx_rate_code = __le32_to_cpu(stat->last_tx_rate_code);
 	arsta->tx_bitrate_kbps = __le32_to_cpu(stat->last_tx_bitrate_kbps);
+	rcu_read_unlock();
 
 	return 0;
 }
-- 
2.30.0.365.g02bc693789-goog

