Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75457354122
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 12:38:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232697AbhDEKRV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 06:17:21 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:56425 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232124AbhDEKRT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Apr 2021 06:17:19 -0400
Received: from fsav405.sakura.ne.jp (fsav405.sakura.ne.jp [133.242.250.104])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 135AH7Jv020862;
        Mon, 5 Apr 2021 19:17:07 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav405.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav405.sakura.ne.jp);
 Mon, 05 Apr 2021 19:17:07 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav405.sakura.ne.jp)
Received: from localhost.localdomain (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 135AGsD7020740
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Mon, 5 Apr 2021 19:17:07 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To:     Marek Lindner <mareklindner@neomailbox.ch>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Antonio Quartulli <a@unstable.cc>,
        Sven Eckelmann <sven@narfation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: [PATCH v2] batman-adv: initialize "struct batadv_tvlv_tt_vlan_data"->reserved field
Date:   Mon,  5 Apr 2021 19:16:50 +0900
Message-Id: <20210405101650.6779-1-penguin-kernel@I-love.SAKURA.ne.jp>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <8010915.lm9TqgPHxW@sven-l14>
References: <8010915.lm9TqgPHxW@sven-l14>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

KMSAN found uninitialized value at batadv_tt_prepare_tvlv_local_data()
[1], for commit ced72933a5e8ab52 ("batman-adv: use CRC32C instead of CRC16
in TT code") inserted 'reserved' field into "struct batadv_tvlv_tt_data"
and commit 7ea7b4a142758dea ("batman-adv: make the TT CRC logic VLAN
specific") moved that field to "struct batadv_tvlv_tt_vlan_data" but left
that field uninitialized.

[1] https://syzkaller.appspot.com/bug?id=07f3e6dba96f0eb3cabab986adcd8a58b9bdbe9d

Reported-by: syzbot <syzbot+50ee810676e6a089487b@syzkaller.appspotmail.com>
Tested-by: syzbot <syzbot+50ee810676e6a089487b@syzkaller.appspotmail.com>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Fixes: ced72933a5e8ab52 ("batman-adv: use CRC32C instead of CRC16 in TT code")
Fixes: 7ea7b4a142758dea ("batman-adv: make the TT CRC logic VLAN specific")
---
 net/batman-adv/translation-table.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/batman-adv/translation-table.c b/net/batman-adv/translation-table.c
index f8761281aab0..434b4f042909 100644
--- a/net/batman-adv/translation-table.c
+++ b/net/batman-adv/translation-table.c
@@ -890,6 +890,7 @@ batadv_tt_prepare_tvlv_global_data(struct batadv_orig_node *orig_node,
 	hlist_for_each_entry(vlan, &orig_node->vlan_list, list) {
 		tt_vlan->vid = htons(vlan->vid);
 		tt_vlan->crc = htonl(vlan->tt.crc);
+		tt_vlan->reserved = 0;
 
 		tt_vlan++;
 	}
@@ -973,6 +974,7 @@ batadv_tt_prepare_tvlv_local_data(struct batadv_priv *bat_priv,
 
 		tt_vlan->vid = htons(vlan->vid);
 		tt_vlan->crc = htonl(vlan->tt.crc);
+		tt_vlan->reserved = 0;
 
 		tt_vlan++;
 	}
-- 
2.18.4

