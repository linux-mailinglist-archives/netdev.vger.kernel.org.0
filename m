Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A565847B7FA
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 03:03:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234742AbhLUCD0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 21:03:26 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:57680 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234982AbhLUCBs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 21:01:48 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3566361357;
        Tue, 21 Dec 2021 02:01:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32D52C36AF9;
        Tue, 21 Dec 2021 02:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640052107;
        bh=jvczQHQnohJlBACZVSzjhhRT2hVXJP0ZRFI3XIpllaM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HsNsNkKYIsvhoOswVw9zyomr/YGgy1Mjjdlgn70reNrnQxoCLkQQifgn3Mid5l3Ry
         aqNvz/rAdpGF0cyiSzxwfTJFbFhAQ905V4H3zj9y3Geuo5MFmaJVsg/JVPOCTuT/BZ
         2IUFI/FcWLij9Z0ztv0A4Z02lx0IpSlnM1/o2HCoGyt9IHuRQi1cdSVVVPuswiydsQ
         e4Os3c6818e6Rnqrk99FKlohelQk7bjve46k5YaigVwWtfmpyMu1vqwjfV+Z8TJe1r
         zISq1MFZhkY8YOmJef2OmKlZyadZfhUjXzmDnfAVIwoJCH1FJMCke7jUXw7YjOtcOr
         LvRPjNckX3twQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xing Song <xing.song@mediatek.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>, johannes@sipsolutions.net,
        davem@davemloft.net, kuba@kernel.org, matthias.bgg@gmail.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 4.14 2/9] mac80211: set up the fwd_skb->dev for mesh forwarding
Date:   Mon, 20 Dec 2021 21:01:16 -0500
Message-Id: <20211221020123.117380-2-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211221020123.117380-1-sashal@kernel.org>
References: <20211221020123.117380-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xing Song <xing.song@mediatek.com>

[ Upstream commit 942bd1070c3a39d1302fc5db73d60c86e3033c81 ]

Mesh forwarding requires that the fwd_skb->dev is set up for TX handling,
otherwise the following warning will be generated, so set it up for the
pending frames.

[   72.835674 ] WARNING: CPU: 0 PID: 1193 at __skb_flow_dissect+0x284/0x1298
[   72.842379 ] Modules linked in: ksmbd pppoe ppp_async l2tp_ppp ...
[   72.962020 ] CPU: 0 PID: 1193 Comm: kworker/u5:1 Tainted: P S 5.4.137 #0
[   72.969938 ] Hardware name: MT7622_MT7531 RFB (DT)
[   72.974659 ] Workqueue: napi_workq napi_workfn
[   72.979025 ] pstate: 60000005 (nZCv daif -PAN -UAO)
[   72.983822 ] pc : __skb_flow_dissect+0x284/0x1298
[   72.988444 ] lr : __skb_flow_dissect+0x54/0x1298
[   72.992977 ] sp : ffffffc010c738c0
[   72.996293 ] x29: ffffffc010c738c0 x28: 0000000000000000
[   73.001615 ] x27: 000000000000ffc2 x26: ffffff800c2eb818
[   73.006937 ] x25: ffffffc010a987c8 x24: 00000000000000ce
[   73.012259 ] x23: ffffffc010c73a28 x22: ffffffc010a99c60
[   73.017581 ] x21: 000000000000ffc2 x20: ffffff80094da800
[   73.022903 ] x19: 0000000000000000 x18: 0000000000000014
[   73.028226 ] x17: 00000000084d16af x16: 00000000d1fc0bab
[   73.033548 ] x15: 00000000715f6034 x14: 000000009dbdd301
[   73.038870 ] x13: 00000000ea4dcbc3 x12: 0000000000000040
[   73.044192 ] x11: 000000000eb00ff0 x10: 0000000000000000
[   73.049513 ] x9 : 000000000eb00073 x8 : 0000000000000088
[   73.054834 ] x7 : 0000000000000000 x6 : 0000000000000001
[   73.060155 ] x5 : 0000000000000000 x4 : 0000000000000000
[   73.065476 ] x3 : ffffffc010a98000 x2 : 0000000000000000
[   73.070797 ] x1 : 0000000000000000 x0 : 0000000000000000
[   73.076120 ] Call trace:
[   73.078572 ]  __skb_flow_dissect+0x284/0x1298
[   73.082846 ]  __skb_get_hash+0x7c/0x228
[   73.086629 ]  ieee80211_txq_may_transmit+0x7fc/0x17b8 [mac80211]
[   73.092564 ]  ieee80211_tx_prepare_skb+0x20c/0x268 [mac80211]
[   73.098238 ]  ieee80211_tx_pending+0x144/0x330 [mac80211]
[   73.103560 ]  tasklet_action_common.isra.16+0xb4/0x158
[   73.108618 ]  tasklet_action+0x2c/0x38
[   73.112286 ]  __do_softirq+0x168/0x3b0
[   73.115954 ]  do_softirq.part.15+0x88/0x98
[   73.119969 ]  __local_bh_enable_ip+0xb0/0xb8
[   73.124156 ]  napi_workfn+0x58/0x90
[   73.127565 ]  process_one_work+0x20c/0x478
[   73.131579 ]  worker_thread+0x50/0x4f0
[   73.135249 ]  kthread+0x124/0x128
[   73.138484 ]  ret_from_fork+0x10/0x1c

Signed-off-by: Xing Song <xing.song@mediatek.com>
Tested-By: Frank Wunderlich <frank-w@public-files.de>
Link: https://lore.kernel.org/r/20211123033123.2684-1-xing.song@mediatek.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/rx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index cbe1177d95f9e..9fae6254c8d94 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2657,6 +2657,7 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
 		goto out;
 	}
 
+	fwd_skb->dev = sdata->dev;
 	fwd_hdr =  (struct ieee80211_hdr *) fwd_skb->data;
 	fwd_hdr->frame_control &= ~cpu_to_le16(IEEE80211_FCTL_RETRY);
 	info = IEEE80211_SKB_CB(fwd_skb);
-- 
2.34.1

