Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52516596D60
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 13:15:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239139AbiHQLPQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 07:15:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238917AbiHQLPP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 07:15:15 -0400
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 963C967477;
        Wed, 17 Aug 2022 04:15:14 -0700 (PDT)
Received: from fsav411.sakura.ne.jp (fsav411.sakura.ne.jp [133.242.250.110])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 27HBEbQo079590;
        Wed, 17 Aug 2022 20:14:37 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav411.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav411.sakura.ne.jp);
 Wed, 17 Aug 2022 20:14:37 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav411.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 27HBEa7N079586
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Wed, 17 Aug 2022 20:14:37 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <ea64b27e-6cbf-fdd5-1f23-aecc3a308e47@I-love.SAKURA.ne.jp>
Date:   Wed, 17 Aug 2022 20:14:36 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Subject: [PATCH] Bluetooth: hci_sync: fix double mgmt_pending_free() in
 remove_adv_monitor()
Content-Language: en-US
To:     syzbot <syzbot+915a8416bf15895b8e07@syzkaller.appspotmail.com>,
        davem@davemloft.net, edumazet@google.com, johan.hedberg@gmail.com,
        kuba@kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org, luiz.dentz@gmail.com,
        marcel@holtmann.org, netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
References: <000000000000d010b705e66d8520@google.com>
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <000000000000d010b705e66d8520@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=0.6 required=5.0 tests=BAYES_00,SORTED_RECIPS,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot is reporting double kfree() at remove_adv_monitor() [1], for
commit 7cf5c2978f23fdbb ("Bluetooth: hci_sync: Refactor remove Adv
Monitor") forgot to remove duplicated mgmt_pending_remove() when
merging "if (err) {" path and "if (!pending) {" path.

Link: https://syzkaller.appspot.com/bug?extid=915a8416bf15895b8e07 [1]
Reported-by: syzbot <syzbot+915a8416bf15895b8e07@syzkaller.appspotmail.com>
Fixes: 7cf5c2978f23fdbb ("Bluetooth: hci_sync: Refactor remove Adv Monitor")
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 net/bluetooth/mgmt.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 6e31023b84f5..3d2e0773a1c1 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -5054,7 +5054,6 @@ static int remove_adv_monitor(struct sock *sk, struct hci_dev *hdev,
 		else
 			status = MGMT_STATUS_FAILED;
 
-		mgmt_pending_remove(cmd);
 		goto unlock;
 	}
 
-- 
2.18.4

