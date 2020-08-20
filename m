Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4301F24B033
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 09:35:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725916AbgHTHe6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 03:34:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725866AbgHTHe4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 03:34:56 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E0C5C061757
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 00:34:56 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id mw10so608245pjb.2
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 00:34:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=ikWq08EvpDCyzI9v3iVFTyQ5+WIbjjvxO2Nm/ZMsk6Q=;
        b=njnlnfb09DuqkOOmojLuSciF9neE63ZqFQFWPdFNGJdytQ7o3CiHTJlcPJYWVQf0H9
         upjgtw32rWnILEDsFdDEvta8KXu9/n553PYPg1cAYGnFb4wwXkVfsa09HpsV6XNDPkZE
         j097UgUeQBePSu9E+j6kZcbOLKxyDTG7eRj+IGajKxKkvO4oH+EYm9+EEHD121AzZ68/
         FmQIxhU/Bd5S3tAeWNqoOL5da6OhmXv7A7w7OBGr2n9CZEMJSzNVVSN/zQi0Gt3AP3eW
         9oHcLx41F5NMHGYiL35teZm4Vck/7b1XndN/IrhSbBbOy4vzs2iAfudRzYGzxGUDjp3W
         S3Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ikWq08EvpDCyzI9v3iVFTyQ5+WIbjjvxO2Nm/ZMsk6Q=;
        b=efVjgxakx+DZewQdpeADAW1RcMgZNAdWRwg8y5MHAJa2ITx/5T10y4eSNH7OE/qmgo
         GuqFmOCGiqVN0/4A+zQ1sJkFZkzd3yPf1g4j2PMX11w1XgBcqzf/THxJR/etkF2pT+mX
         9d7LeVdHz8NemvyMSsJiQ1OzS/xIJIKWhRm3gSUdMK0WNfK0NNMm/yQl1eO/zZJdX5rO
         L+6+BkoYYpdUzrNYuWo20DilrYqfZyr94cYFaVlpy8EJ6II5ixTCWzfyhKk/Dwkdsx3N
         neUJDMdAostmlezU6xmYqiXOB3xdN8iJfFySsRT0+6R+ZJo6XJs/5IDeCnKWckNY/aTd
         +fhw==
X-Gm-Message-State: AOAM5313viT0NLOm1JUqtjrtR2KQvxD/P9dpvRfOy8TCBh2E2LnTUViO
        Yd2bluOKNRcB9jQ9e/yRaG6yTVZ2bKuwdQ==
X-Google-Smtp-Source: ABdhPJx1fwYiWtGpMFB5LBMaqvJ4cRLP9FE6ZQB456E48OWfp1J0A6PAtO1DLlT2MYP7uFJgOY8UHw==
X-Received: by 2002:a17:902:301:: with SMTP id 1mr1693126pld.198.1597908895693;
        Thu, 20 Aug 2020 00:34:55 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id g10sm1739896pfb.82.2020.08.20.00.34.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Aug 2020 00:34:54 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>,
        tipc-discussion@lists.sourceforge.net,
        Tuong Lien <tuong.t.lien@dektech.com.au>
Subject: [PATCH net] tipc: call rcu_read_lock() in tipc_aead_encrypt_done()
Date:   Thu, 20 Aug 2020 15:34:47 +0800
Message-Id: <7f24b6b0a0d2cb82b9dfbf5343c01266d2840561.1597908887.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

b->media->send_msg() requires rcu_read_lock(), as we can see
elsewhere in tipc,  tipc_bearer_xmit, tipc_bearer_xmit_skb
and tipc_bearer_bc_xmit().

Syzbot has reported this issue as:

  net/tipc/bearer.c:466 suspicious rcu_dereference_check() usage!
  Workqueue: cryptd cryptd_queue_worker
  Call Trace:
   tipc_l2_send_msg+0x354/0x420 net/tipc/bearer.c:466
   tipc_aead_encrypt_done+0x204/0x3a0 net/tipc/crypto.c:761
   cryptd_aead_crypt+0xe8/0x1d0 crypto/cryptd.c:739
   cryptd_queue_worker+0x118/0x1b0 crypto/cryptd.c:181
   process_one_work+0x94c/0x1670 kernel/workqueue.c:2269
   worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
   kthread+0x3b5/0x4a0 kernel/kthread.c:291
   ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:293

So fix it by calling rcu_read_lock() in tipc_aead_encrypt_done()
for b->media->send_msg().

Fixes: fc1b6d6de220 ("tipc: introduce TIPC encryption & authentication")
Reported-by: syzbot+47bbc6b678d317cccbe0@syzkaller.appspotmail.com
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/tipc/crypto.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/tipc/crypto.c b/net/tipc/crypto.c
index 001bcb0..c38baba 100644
--- a/net/tipc/crypto.c
+++ b/net/tipc/crypto.c
@@ -757,10 +757,12 @@ static void tipc_aead_encrypt_done(struct crypto_async_request *base, int err)
 	switch (err) {
 	case 0:
 		this_cpu_inc(tx->stats->stat[STAT_ASYNC_OK]);
+		rcu_read_lock();
 		if (likely(test_bit(0, &b->up)))
 			b->media->send_msg(net, skb, b, &tx_ctx->dst);
 		else
 			kfree_skb(skb);
+		rcu_read_unlock();
 		break;
 	case -EINPROGRESS:
 		return;
-- 
2.1.0

