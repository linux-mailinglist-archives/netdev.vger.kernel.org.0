Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73EE9473C61
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 06:20:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbhLNFUC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 00:20:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbhLNFUC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 00:20:02 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C13ABC061574
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 21:20:01 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id q16so16401425pgq.10
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 21:20:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0jFJ731tO1DafUJR1sZLTJXZ2we/4B1gtDWjogmSxhU=;
        b=IfXwsmBNNugBq+m5WX2ZqN9zhmfa5Z/1ZIiv7dnrDcpefMFarUWVqYDsMCDq3ckX6+
         VdVOLFKeNkL9UGyUYj5CjeBsHh2vn+lTzLGvX7xZ9+AULvJ3HwJNpfxebuKaTZkzhTdE
         +uIKcr1yYt0a4ivOTL+mgypGpzGR1bz2xWTfLeTSW2gWGdcjt/9mWkCZ3rcB7krlSu3f
         QX8+/iVSsQZHih5gQYTUqQwmbIvpeeR0OZ71kkcpF9B+b7AUlxm1Iu3o7W/BJnLuf/GO
         qyLuRyFRUqTSvGvc2Il4ZRKnYz2SJLkLJGIfU1t2dmil9r86JA5AWL/XZQXOEzh20gUr
         ct3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0jFJ731tO1DafUJR1sZLTJXZ2we/4B1gtDWjogmSxhU=;
        b=KgFOHkqmY7nE3jvjsnU3BeplJ2DjVZ78VV/3HekN1Yz6QHGq/+3sd08UfacXi0zp9o
         V3Q3tHs9ThfwrKlm3d7guQx24Z0rR1ezwTdigaAUOwRT34DAwc+8WGXBHNaV7DdaOT/7
         UhYt+hy6LkOlq+gfOo7CQInQOg6Me/DsxBzlqdGYyGPN7Lqtw18YyOIJcpvq6kUpeE0A
         aZFYU1UxRJjStqzLHeGZdotqbbPbeKKNduLYJLDIYkj/K/05AYVN9rez0NI1+VUcls0/
         aSBy3zHOvRLJsBQSRLCU85b2n80HZOFPeFaeLthgC1hGsuEGE38FmbmFrTlj/gfUGo+f
         BtmA==
X-Gm-Message-State: AOAM531vylAO6XqZUH0mlf5DbGLa8aVJuxgECWT7ZJxayGlxik2SgKoz
        Yad5bBTCORRD/75QL+gANDQ=
X-Google-Smtp-Source: ABdhPJxJVJ6LXzV/cTugNNKuUfwny6prc/tZ9AavJ7XGWQVAZyPbrhhDiC2OJkLC8C7GEL2xI5c/7A==
X-Received: by 2002:a63:461c:: with SMTP id t28mr2112956pga.171.1639459201153;
        Mon, 13 Dec 2021 21:20:01 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:5cbb:7251:72ab:eb48])
        by smtp.gmail.com with ESMTPSA id m24sm11912401pgk.39.2021.12.13.21.19.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Dec 2021 21:20:00 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH net-next] net: linkwatch: be more careful about dev->linkwatch_dev_tracker
Date:   Mon, 13 Dec 2021 21:19:55 -0800
Message-Id: <20211214051955.3569843-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Apparently a concurrent linkwatch_add_event() could
run while we are in __linkwatch_run_queue().

We need to free dev->linkwatch_dev_tracker tracker
under lweventlist_lock protection to avoid this race.

syzbot report:
[   77.935949][ T3661] reference already released.
[   77.941015][ T3661] allocated in:
[   77.944482][ T3661]  linkwatch_fire_event+0x202/0x260
[   77.950318][ T3661]  netif_carrier_on+0x9c/0x100
[   77.955120][ T3661]  __ieee80211_sta_join_ibss+0xc52/0x1590
[   77.960888][ T3661]  ieee80211_sta_create_ibss.cold+0xd2/0x11f
[   77.966908][ T3661]  ieee80211_ibss_work.cold+0x30e/0x60f
[   77.972483][ T3661]  ieee80211_iface_work+0xb70/0xd00
[   77.977715][ T3661]  process_one_work+0x9ac/0x1680
[   77.982671][ T3661]  worker_thread+0x652/0x11c0
[   77.987371][ T3661]  kthread+0x405/0x4f0
[   77.991465][ T3661]  ret_from_fork+0x1f/0x30
[   77.995895][ T3661] freed in:
[   77.999006][ T3661]  linkwatch_do_dev+0x96/0x160
[   78.004014][ T3661]  __linkwatch_run_queue+0x233/0x6a0
[   78.009496][ T3661]  linkwatch_event+0x4a/0x60
[   78.014099][ T3661]  process_one_work+0x9ac/0x1680
[   78.019034][ T3661]  worker_thread+0x652/0x11c0
[   78.023719][ T3661]  kthread+0x405/0x4f0
[   78.027810][ T3661]  ret_from_fork+0x1f/0x30
[   78.042541][ T3661] ------------[ cut here ]------------
[   78.048253][ T3661] WARNING: CPU: 0 PID: 3661 at lib/ref_tracker.c:120 ref_tracker_free.cold+0x110/0x14e
[   78.062364][ T3661] Modules linked in:
[   78.066424][ T3661] CPU: 0 PID: 3661 Comm: kworker/0:5 Not tainted 5.16.0-rc4-next-20211210-syzkaller #0
[   78.076075][ T3661] Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
[   78.090648][ T3661] Workqueue: events linkwatch_event
[   78.095890][ T3661] RIP: 0010:ref_tracker_free.cold+0x110/0x14e
[   78.102191][ T3661] Code: ea 03 48 c1 e0 2a 0f b6 04 02 84 c0 74 04 3c 03 7e 4c 8b 7b 18 e8 6b 54 e9 fa e8 26 4d 57 f8 4c 89 ee 48 89 ef e8 fb 33 36 00 <0f> 0b 41 bd ea ff ff ff e9 bd 60 e9 fa 4c 89 f7 e8 16 45 a2 f8 e9
[   78.127211][ T3661] RSP: 0018:ffffc90002b5fb18 EFLAGS: 00010246
[   78.133684][ T3661] RAX: 0000000000000000 RBX: ffff88807467f700 RCX: 0000000000000000
[   78.141928][ T3661] RDX: 0000000000000001 RSI: 0000000000000001 RDI: 0000000000000001
[   78.150087][ T3661] RBP: ffff888057e105b8 R08: 0000000000000001 R09: ffffffff8ffa1967
[   78.158211][ T3661] R10: 0000000000000001 R11: 0000000000000000 R12: 1ffff9200056bf65
[   78.166204][ T3661] R13: 0000000000000292 R14: ffff88807467f718 R15: 00000000c0e0008c
[   78.174321][ T3661] FS:  0000000000000000(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
[   78.183310][ T3661] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   78.190156][ T3661] CR2: 000000c000208800 CR3: 000000007f7b5000 CR4: 00000000003506f0
[   78.198235][ T3661] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   78.206214][ T3661] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   78.214328][ T3661] Call Trace:
[   78.217679][ T3661]  <TASK>
[   78.220621][ T3661]  ? __sanitizer_cov_trace_const_cmp4+0x1c/0x70
[   78.226981][ T3661]  ? nlmsg_notify+0xbe/0x280
[   78.231607][ T3661]  ? ref_tracker_dir_exit+0x330/0x330
[   78.237654][ T3661]  ? linkwatch_do_dev+0x96/0x160
[   78.242628][ T3661]  ? __linkwatch_run_queue+0x233/0x6a0
[   78.248170][ T3661]  ? linkwatch_event+0x4a/0x60
[   78.252946][ T3661]  ? process_one_work+0x9ac/0x1680
[   78.258136][ T3661]  ? worker_thread+0x853/0x11c0
[   78.263020][ T3661]  ? kthread+0x405/0x4f0
[   78.267905][ T3661]  ? ret_from_fork+0x1f/0x30
[   78.272670][ T3661]  ? netdev_state_change+0xa1/0x130
[   78.278019][ T3661]  ? netdev_exit+0xd0/0xd0
[   78.282466][ T3661]  ? dev_activate+0x420/0xa60
[   78.287261][ T3661]  linkwatch_do_dev+0x96/0x160
[   78.292043][ T3661]  __linkwatch_run_queue+0x233/0x6a0
[   78.297505][ T3661]  ? linkwatch_do_dev+0x160/0x160
[   78.302561][ T3661]  linkwatch_event+0x4a/0x60
[   78.307225][ T3661]  process_one_work+0x9ac/0x1680
[   78.312292][ T3661]  ? pwq_dec_nr_in_flight+0x2a0/0x2a0
[   78.317757][ T3661]  ? rwlock_bug.part.0+0x90/0x90
[   78.322726][ T3661]  ? _raw_spin_lock_irq+0x41/0x50
[   78.327844][ T3661]  worker_thread+0x853/0x11c0
[   78.332543][ T3661]  ? process_one_work+0x1680/0x1680
[   78.338500][ T3661]  kthread+0x405/0x4f0
[   78.342610][ T3661]  ? set_kthread_struct+0x130/0x130

Fixes: 63f13937cbe9 ("net: linkwatch: add net device refcount tracker")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/core/link_watch.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/net/core/link_watch.c b/net/core/link_watch.c
index d7d089963b1da4142a0863715382aa81241625eb..b0f5344d1185be66d05cd1dc50cffc5ccfe883ef 100644
--- a/net/core/link_watch.c
+++ b/net/core/link_watch.c
@@ -166,7 +166,10 @@ static void linkwatch_do_dev(struct net_device *dev)
 
 		netdev_state_change(dev);
 	}
-	dev_put_track(dev, &dev->linkwatch_dev_tracker);
+	/* Note: our callers are responsible for
+	 * calling netdev_tracker_free().
+	 */
+	dev_put(dev);
 }
 
 static void __linkwatch_run_queue(int urgent_only)
@@ -209,6 +212,10 @@ static void __linkwatch_run_queue(int urgent_only)
 			list_add_tail(&dev->link_watch_list, &lweventlist);
 			continue;
 		}
+		/* We must free netdev tracker under
+		 * the spinlock protection.
+		 */
+		netdev_tracker_free(dev, &dev->linkwatch_dev_tracker);
 		spin_unlock_irq(&lweventlist_lock);
 		linkwatch_do_dev(dev);
 		do_dev--;
@@ -232,6 +239,10 @@ void linkwatch_forget_dev(struct net_device *dev)
 	if (!list_empty(&dev->link_watch_list)) {
 		list_del_init(&dev->link_watch_list);
 		clean = 1;
+		/* We must release netdev tracker under
+		 * the spinlock protection.
+		 */
+		netdev_tracker_free(dev, &dev->linkwatch_dev_tracker);
 	}
 	spin_unlock_irqrestore(&lweventlist_lock, flags);
 	if (clean)
-- 
2.34.1.173.g76aa8bc2d0-goog

