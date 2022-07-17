Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBC25577621
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 14:23:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232819AbiGQMWN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jul 2022 08:22:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbiGQMWM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jul 2022 08:22:12 -0400
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CD0C167CD;
        Sun, 17 Jul 2022 05:22:10 -0700 (PDT)
Received: from fsav412.sakura.ne.jp (fsav412.sakura.ne.jp [133.242.250.111])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 26HCLtNS068566;
        Sun, 17 Jul 2022 21:21:55 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav412.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav412.sakura.ne.jp);
 Sun, 17 Jul 2022 21:21:55 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav412.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 26HCLsd5068563
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Sun, 17 Jul 2022 21:21:55 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <9cc9b81d-75a3-3925-b612-9d0ad3cab82b@I-love.SAKURA.ne.jp>
Date:   Sun, 17 Jul 2022 21:21:52 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: [PATCH v2] wifi: mac80211: do not abuse fq.lock in
 ieee80211_do_stop()
Content-Language: en-US
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To:     Johannes Berg <johannes@sipsolutions.net>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@kernel.org>,
        Felix Fietkau <nbd@nbd.name>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org
References: <00000000000040bd4905e3c2c237@google.com>
 <81f3eeda-0888-2869-659e-dc38c0a9debf@I-love.SAKURA.ne.jp>
In-Reply-To: <81f3eeda-0888-2869-659e-dc38c0a9debf@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

lockdep complains use of uninitialized spinlock at ieee80211_do_stop() [1],
for commit f856373e2f31ffd3 ("wifi: mac80211: do not wake queues on a vif
that is being stopped") guards clear_bit() using fq.lock even before
fq_init() from ieee80211_txq_setup_flows() initializes this spinlock.

According to discussion [2], Toke was not happy with expanding usage of
fq.lock. Since __ieee80211_wake_txqs() is called under RCU read lock, we
can instead use synchronize_rcu() for flushing ieee80211_wake_txqs().

Link: https://syzkaller.appspot.com/bug?extid=eceab52db7c4b961e9d6 [1]
Link: https://lkml.kernel.org/r/874k0zowh2.fsf@toke.dk [2]
Reported-by: syzbot <syzbot+eceab52db7c4b961e9d6@syzkaller.appspotmail.com>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Fixes: f856373e2f31ffd3 ("wifi: mac80211: do not wake queues on a vif that is being stopped")
Tested-by: syzbot <syzbot+eceab52db7c4b961e9d6@syzkaller.appspotmail.com>
---
Changes in v2:
  Use synchronize_rcu() instead of initializing fq.lock early.

This bug is current top crasher for syzbot. Please fix as soon as possible.

 net/mac80211/iface.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 15a73b7fdd75..1a9ada411879 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -377,9 +377,8 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata, bool going_do
 	bool cancel_scan;
 	struct cfg80211_nan_func *func;
 
-	spin_lock_bh(&local->fq.lock);
 	clear_bit(SDATA_STATE_RUNNING, &sdata->state);
-	spin_unlock_bh(&local->fq.lock);
+	synchronize_rcu(); /* flush _ieee80211_wake_txqs() */
 
 	cancel_scan = rcu_access_pointer(local->scan_sdata) == sdata;
 	if (cancel_scan)
-- 
2.18.4


