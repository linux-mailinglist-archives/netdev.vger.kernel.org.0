Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DF8F353BCA
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 07:33:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbhDEFdW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 01:33:22 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:50838 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbhDEFdU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Apr 2021 01:33:20 -0400
Received: from fsav303.sakura.ne.jp (fsav303.sakura.ne.jp [153.120.85.134])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 1355XCY7010840;
        Mon, 5 Apr 2021 14:33:12 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav303.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav303.sakura.ne.jp);
 Mon, 05 Apr 2021 14:33:12 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav303.sakura.ne.jp)
Received: from localhost.localdomain (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 1355X8va010672
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Mon, 5 Apr 2021 14:33:12 +0900 (JST)
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
Subject: [PATCH] batman-adv: initialize "struct batadv_tvlv_tt_vlan_data"->reserved field
Date:   Mon,  5 Apr 2021 14:33:06 +0900
Message-Id: <20210405053306.3437-1-penguin-kernel@I-love.SAKURA.ne.jp>
X-Mailer: git-send-email 2.18.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

KMSAN found uninitialized value at batadv_tt_prepare_tvlv_local_data()
[1], for commit ced72933a5e8ab52 ("batman-adv: use CRC32C instead of CRC16
in TT code") inserted 'reserved' field into "struct batadv_tvlv_tt_data"
and commit 7ea7b4a142758dea ("batman-adv: make the TT CRC logic VLAN
specific") moved that field to "struct batadv_tvlv_tt_vlan_data" but left
that field uninitialized.

Although this patch passed "#syz test:" check, there might be similar bugs
remaining. It might be better to proactively use __GFP_ZERO than trying to
find uninitialized fields in this module.

[1] https://syzkaller.appspot.com/bug?id=07f3e6dba96f0eb3cabab986adcd8a58b9bdbe9d

Reported-by: syzbot <syzbot+50ee810676e6a089487b@syzkaller.appspotmail.com>
Tested-by: syzbot <syzbot+50ee810676e6a089487b@syzkaller.appspotmail.com>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Fixes: ced72933a5e8ab52 ("batman-adv: use CRC32C instead of CRC16 in TT code")
Fixes: 7ea7b4a142758dea ("batman-adv: make the TT CRC logic VLAN specific")
---
 net/batman-adv/translation-table.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/batman-adv/translation-table.c b/net/batman-adv/translation-table.c
index f8761281aab0..eb82576557e6 100644
--- a/net/batman-adv/translation-table.c
+++ b/net/batman-adv/translation-table.c
@@ -973,6 +973,7 @@ batadv_tt_prepare_tvlv_local_data(struct batadv_priv *bat_priv,
 
 		tt_vlan->vid = htons(vlan->vid);
 		tt_vlan->crc = htonl(vlan->tt.crc);
+		tt_vlan->reserved = 0;
 
 		tt_vlan++;
 	}
-- 
2.18.4

