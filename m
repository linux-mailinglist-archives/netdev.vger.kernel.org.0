Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85A1757732F
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 04:34:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbiGQCdK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jul 2022 22:33:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiGQCdK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jul 2022 22:33:10 -0400
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBD5A186FC;
        Sat, 16 Jul 2022 19:33:06 -0700 (PDT)
Received: from fsav113.sakura.ne.jp (fsav113.sakura.ne.jp [27.133.134.240])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 26H2WkRu030000;
        Sun, 17 Jul 2022 11:32:46 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav113.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav113.sakura.ne.jp);
 Sun, 17 Jul 2022 11:32:46 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav113.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 26H2Wep8029986
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Sun, 17 Jul 2022 11:32:46 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <81f3eeda-0888-2869-659e-dc38c0a9debf@I-love.SAKURA.ne.jp>
Date:   Sun, 17 Jul 2022 11:32:38 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: [PATCH] wifi: mac80211: initialize fq.lock as early as possible
Content-Language: en-US
To:     Johannes Berg <johannes@sipsolutions.net>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@kernel.org>,
        Felix Fietkau <nbd@nbd.name>
References: <00000000000040bd4905e3c2c237@google.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <00000000000040bd4905e3c2c237@google.com>
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
Initialize this spinlock as early as possible.

Link: https://syzkaller.appspot.com/bug?extid=eceab52db7c4b961e9d6 [1]
Reported-by: syzbot <syzbot+eceab52db7c4b961e9d6@syzkaller.appspotmail.com>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Fixes: f856373e2f31ffd3 ("wifi: mac80211: do not wake queues on a vif that is being stopped")
Tested-by: syzbot <syzbot+eceab52db7c4b961e9d6@syzkaller.appspotmail.com>
---
 net/mac80211/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 5a385d4146b9..584e98300bbf 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -642,6 +642,7 @@ struct ieee80211_hw *ieee80211_alloc_hw_nm(size_t priv_data_len,
 	wiphy->bss_priv_size = sizeof(struct ieee80211_bss);
 
 	local = wiphy_priv(wiphy);
+	spin_lock_init(&local->fq.lock);
 
 	if (sta_info_init(local))
 		goto err_free;
-- 
2.18.4

