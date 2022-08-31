Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00F5C5A8525
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 20:12:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232565AbiHaSMY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 14:12:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232499AbiHaSME (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 14:12:04 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AFD4ED03E;
        Wed, 31 Aug 2022 11:11:19 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id jm11so14846246plb.13;
        Wed, 31 Aug 2022 11:11:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=UgxFIowahszZp3YqmiisiqrkN1WXXLGBv+HLJWO87II=;
        b=fI5WQhRVN2gjyq/VfwgKVUUSxu94g7sATcfU8pa+n63z0kIiVGbGFnblJV01nSNpjA
         IilbjGvM/mfscoJeAHl3+rnnyJSyViEvXi5uO3UYnQfmDK4wq0sItgJuJyslvWIuJ1xK
         xgy4lYlx8TBhrHvYOeWLqeIlhpC0E7rOWDvjqo8vcpndgDffNyYZP6vY8HULGL3eE8mk
         A+QpZaqX66TxUyh+lf8CD5cAwUMI1dwyk8V5ilGqGGtHTYyBFJKtgBqWyEmoLF2mOslr
         2Mme5B5yAK4DybIKEW/XvNlw2+d1ZnsHWEgDhWPm0uWaqJyircivF3tmV3nel1qDk9bH
         MEkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=UgxFIowahszZp3YqmiisiqrkN1WXXLGBv+HLJWO87II=;
        b=HXKxLbq4gEVHgAFwdkoLLXx5tFNXLtrIh/lBh1Szr22RF2KncXFJYridM5hgK55R4D
         XKAzSOzwaWf+hKvUTp1MPmLJFahcVUFnPaYF4V3Og6dEfo01Y22sn2X7OUF1PrQKRK+9
         ukN1zT1oqaRlj+offW4tJfZf3wq+exAtuvEUXcrkpK46Jn1ueaNwQp3FnzoAipRpu3St
         d/1wz+zlmHEqzlLRefylsWzR8uHfBy47ppspRHsNTiq7Gng5tMsQnrGror2pg/ICXs6I
         +yUsr1Eq2uqMKWHL8slY73OhpBgaJZlW/h5NWOlNvMO7ZRVZ98FsZkb1Kfi1Pw+gx6//
         Nh1Q==
X-Gm-Message-State: ACgBeo1rFKWO/Qd+hrmiFOYyiN7YPCMReYMFI54CbqXUUjm4pSvkhtfF
        +nRac90SwpwA/CyQ/miVr7c=
X-Google-Smtp-Source: AA6agR68NCpgTVFenk7zMwhUValscToqoiIu27dAadrbzR2TvTiklXVBckP6992zWHmQtl26DJnD6g==
X-Received: by 2002:a17:902:e748:b0:175:2ffe:927d with SMTP id p8-20020a170902e74800b001752ffe927dmr7086642plf.168.1661969414955;
        Wed, 31 Aug 2022 11:10:14 -0700 (PDT)
Received: from localhost.localdomain (ec2-18-117-95-84.us-east-2.compute.amazonaws.com. [18.117.95.84])
        by smtp.gmail.com with ESMTPSA id d68-20020a621d47000000b00535e46171c1sm11418557pfd.117.2022.08.31.11.10.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Aug 2022 11:10:14 -0700 (PDT)
From:   Schspa Shi <schspa@gmail.com>
To:     ericvh@gmail.com, lucho@ionkov.net, asmadeus@codewreck.org,
        linux_oss@crudebyte.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Cc:     v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Schspa Shi <schspa@gmail.com>
Subject: [PATCH] p9: trans_fd: Fix deadlock when connection cancel
Date:   Thu,  1 Sep 2022 02:09:50 +0800
Message-Id: <20220831180950.76907-1-schspa@gmail.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a deadlock condition when connection canceled.

Please refer to the following scenarios.
           task 0                task1
------------------------------------------------------------------
p9_client_rpc
  req = p9_client_prepare_req(c, type, c->msize, fmt, ap);
  // refcount = 2
  err = c->trans_mod->request(c, req);
  // req was added to unsent_req_list
  wait_event_killable(req->wq, req->status >= REQ_STATUS_RCVD);

                           p9_read_work
                             // IO error happen
                           error:
                             p9_conn_cancel(m, err);
                              spin_lock(&m->client->lock);
                              // hold client->lock now
                              p9_client_cb
                                req->status = REQ_STATUS_ERROR;
                                wake_up(&req->wq);
                                // task 0 wakeup
                                << preempted >>

reterr:
	p9_req_put(c, req);
    // refcount = 1 now
                                << got scheduled >>
                                p9_req_put
                                  // refcount = 0
                                  p9_tag_remove(c, r);
                                    spin_lock_irqsave(&c->lock, flags);
                           ------------- deadlock -------------

[  651.564169] rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
[  651.564176] rcu:     3-...0: (8 ticks this GP) idle=40b4/1/0x4000000000000000 softirq=1289/1290 fqs=83762
[  651.564185]  (detected by 2, t=420047 jiffies, g=1601, q=992 ncpus=4)
[  651.564190] Sending NMI from CPU 2 to CPUs 3:
[  651.539301] NMI backtrace for cpu 3
[  651.539301] CPU: 3 PID: 46 Comm: kworker/3:1 Not tainted 6.0.0-rc2-rt3-00493-g2af9a9504166 #3
[  651.539301] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.0-0-gd239552ce722-prebuilt.qemu.org 04/01/2014
[  651.539301] Workqueue: events p9_read_work
[  651.539301] RIP: 0010:queued_spin_lock_slowpath+0xfc/0x590
[  651.539301] Code: 00 00 00 65 48 2b 04 25 28 00 00 00 0f 85 a5 04 00 00 48 81 c4 88 00 00 00 5b 5d 41 5c 41 5d 41 5e 41 5f c3 cc0
[  651.539301] RSP: 0018:ffff888002987ad8 EFLAGS: 00000002
[  651.539301] RAX: 0000000000000000 RBX: 0000000000000001 RCX: dffffc0000000000
[  651.539301] RDX: 0000000000000003 RSI: 0000000000000004 RDI: ffff888004adf600
[  651.539301] RBP: ffff888004adf600 R08: ffffffff81d341a0 R09: ffff888004adf603
[  651.539301] R10: ffffed100095bec0 R11: 0000000000000001 R12: 0000000000000001
[  651.539301] R13: 1ffff11000530f5c R14: ffff888004adf600 R15: ffff888002987c38
[  651.539301] FS:  0000000000000000(0000) GS:ffff888036580000(0000) knlGS:0000000000000000
[  651.539301] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  651.539301] CR2: 00007fe012d608dc CR3: 000000000bc16000 CR4: 0000000000350ee0
[  651.539301] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  651.539301] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  651.539301] Call Trace:
[  651.539301]  <TASK>
[  651.539301]  ? osq_unlock+0x100/0x100
[  651.539301]  ? ret_from_fork+0x1f/0x30
[  651.539301]  do_raw_spin_lock+0x196/0x1a0
[  651.539301]  ? spin_bug+0x90/0x90
[  651.539301]  ? do_raw_spin_lock+0x114/0x1a0
[  651.539301]  _raw_spin_lock_irqsave+0x1c/0x30
[  651.539301]  p9_req_put+0x61/0x130
[  651.539301]  p9_conn_cancel+0x321/0x3b0
[  651.539301]  ? p9_conn_create+0x1f0/0x1f0
[  651.539301]  p9_read_work+0x207/0x7d0
[  651.539301]  ? p9_fd_create+0x1d0/0x1d0
[  651.539301]  ? spin_bug+0x90/0x90
[  651.539301]  ? read_word_at_a_time+0xe/0x20
[  651.539301]  process_one_work+0x420/0x720
[  651.539301]  worker_thread+0x2b9/0x700
[  651.539301]  ? rescuer_thread+0x620/0x620
[  651.539301]  kthread+0x176/0x1b0
[  651.539301]  ? kthread_complete_and_exit+0x20/0x20
[  651.539301]  ret_from_fork+0x1f/0x30

To fix it, we can add extra reference counter to avoid deadlock, and
decrease it after we unlock the client->lock.

Fixes: 67dd8e445ee0 ("9p: roll p9_tag_remove into p9_req_put")

Signed-off-by: Schspa Shi <schspa@gmail.com>
---
 net/9p/trans_fd.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
index e758978b44bee..2e4e039b38e3e 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -205,14 +205,19 @@ static void p9_conn_cancel(struct p9_conn *m, int err)
 		list_move(&req->req_list, &cancel_list);
 	}
 
-	list_for_each_entry_safe(req, rtmp, &cancel_list, req_list) {
+	list_for_each_entry(req, &cancel_list, req_list) {
 		p9_debug(P9_DEBUG_ERROR, "call back req %p\n", req);
-		list_del(&req->req_list);
 		if (!req->t_err)
 			req->t_err = err;
+		p9_req_get(req);
 		p9_client_cb(m->client, req, REQ_STATUS_ERROR);
 	}
 	spin_unlock(&m->client->lock);
+
+	list_for_each_entry_safe(req, rtmp, &cancel_list, req_list) {
+		list_del(&req->req_list);
+		p9_req_put(m->client, req);
+	}
 }
 
 static __poll_t
-- 
2.37.2

