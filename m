Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30D9638D1C5
	for <lists+netdev@lfdr.de>; Sat, 22 May 2021 01:01:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230014AbhEUXCy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 19:02:54 -0400
Received: from terran.cs.ucr.edu ([169.235.31.181]:54450 "EHLO
        terran.cs.ucr.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbhEUXCr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 May 2021 19:02:47 -0400
X-Greylist: delayed 2043 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 May 2021 19:02:46 EDT
Received: from hang by terran.cs.ucr.edu with local (Exim 4.82)
        (envelope-from <hang@terran.cs.ucr.edu>)
        id 1lkDhl-0006WH-D5; Fri, 21 May 2021 15:33:17 -0700
From:   Hang Zhang <zh.nvgt@gmail.com>
Cc:     Solomon Peachy <pizza@shaftnet.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jia-Ju Bai <baijiaju1990@gmail.com>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hang Zhang <zh.nvgt@gmail.com>
Subject: [PATCH] cw1200: Revert unnecessary patches that fix unreal use-after-free bugs
Date:   Fri, 21 May 2021 15:32:38 -0700
Message-Id: <20210521223238.25020-1-zh.nvgt@gmail.com>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A previous commit 4f68ef64cd7f ("cw1200: Fix concurrency 
use-after-free bugs in cw1200_hw_scan()") tried to fix a seemingly
use-after-free bug between cw1200_bss_info_changed() and
cw1200_hw_scan(), where the former frees a sk_buff pointed
to by frame.skb, and the latter accesses the sk_buff
pointed to by frame.skb. However, this issue should be a
false alarm because:

(1) "frame.skb" is not a shared variable between the above 
two functions, because "frame" is a local function variable,
each of the two functions has its own local "frame" - they
just happen to have the same variable name.

(2) the sk_buff(s) pointed to by these two "frame.skb" are
also two different object instances, they are individually
allocated by different dev_alloc_skb() within the two above
functions. To free one object instance will not invalidate 
the access of another different one.

Based on these facts, the previous commit should be unnecessary.
Moreover, it also introduced a missing unlock which was 
addressed in a subsequent commit 51c8d24101c7 ("cw1200: fix missing 
unlock on error in cw1200_hw_scan()"). Now that the
original use-after-free is unreal, these two commits should
be reverted. This patch performs the reversion.

Fixes: 4f68ef64cd7f ("cw1200: Fix concurrency use-after-free bugs in cw1200_hw_scan()")
Fixes: 51c8d24101c7 ("cw1200: fix missing unlock on error in cw1200_hw_scan()")
Signed-off-by: Hang Zhang <zh.nvgt@gmail.com>
---
 drivers/net/wireless/st/cw1200/scan.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/st/cw1200/scan.c b/drivers/net/wireless/st/cw1200/scan.c
index 988581cc134b..1f856fbbc0ea 100644
--- a/drivers/net/wireless/st/cw1200/scan.c
+++ b/drivers/net/wireless/st/cw1200/scan.c
@@ -75,30 +75,27 @@ int cw1200_hw_scan(struct ieee80211_hw *hw,
 	if (req->n_ssids > WSM_SCAN_MAX_NUM_OF_SSIDS)
 		return -EINVAL;
 
-	/* will be unlocked in cw1200_scan_work() */
-	down(&priv->scan.lock);
-	mutex_lock(&priv->conf_mutex);
-
 	frame.skb = ieee80211_probereq_get(hw, priv->vif->addr, NULL, 0,
 		req->ie_len);
-	if (!frame.skb) {
-		mutex_unlock(&priv->conf_mutex);
-		up(&priv->scan.lock);
+	if (!frame.skb)
 		return -ENOMEM;
-	}
 
 	if (req->ie_len)
 		skb_put_data(frame.skb, req->ie, req->ie_len);
 
+	/* will be unlocked in cw1200_scan_work() */
+	down(&priv->scan.lock);
+	mutex_lock(&priv->conf_mutex);
+
 	ret = wsm_set_template_frame(priv, &frame);
 	if (!ret) {
 		/* Host want to be the probe responder. */
 		ret = wsm_set_probe_responder(priv, true);
 	}
 	if (ret) {
-		dev_kfree_skb(frame.skb);
 		mutex_unlock(&priv->conf_mutex);
 		up(&priv->scan.lock);
+		dev_kfree_skb(frame.skb);
 		return ret;
 	}
 
@@ -120,8 +117,8 @@ int cw1200_hw_scan(struct ieee80211_hw *hw,
 		++priv->scan.n_ssids;
 	}
 
-	dev_kfree_skb(frame.skb);
 	mutex_unlock(&priv->conf_mutex);
+	dev_kfree_skb(frame.skb);
 	queue_work(priv->workqueue, &priv->scan.work);
 	return 0;
 }
-- 
2.31.1

