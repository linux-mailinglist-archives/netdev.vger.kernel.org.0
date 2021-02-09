Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 669E9314E3B
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 12:30:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbhBIL2w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 06:28:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbhBIL1w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 06:27:52 -0500
Received: from mail-wm1-x349.google.com (mail-wm1-x349.google.com [IPv6:2a00:1450:4864:20::349])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 519CFC06178B
        for <netdev@vger.kernel.org>; Tue,  9 Feb 2021 03:27:12 -0800 (PST)
Received: by mail-wm1-x349.google.com with SMTP id r13so2071337wmq.9
        for <netdev@vger.kernel.org>; Tue, 09 Feb 2021 03:27:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=A5PjxBocm6GkKPxXcYzX2e1AeHxW0gP+W7kFc8REg2E=;
        b=ofP339Bc5incCy4OVOMtxQ6ESTNMLP3Fc6EZ7VuXFsN0nYTCQuk3+Saa2UBlwztZ04
         8ZfX/NKW7MwxFkaStBW0GBGHv5nyLJClX5a4HNKpwvY8aZKkDqS18qOB5fmuiBzgx1lx
         k9IKdZGVfB6c+hJ98cgN3nh35iDKtooVTgyWjrRxFLw76X9Yg3G93wWrLoIHORVj/wj0
         9isSi7YjzfOrQGavjf96/f69AWde9QdwEmcAULfGVvVM90BSaujuIMkxeAzRh81H4aGE
         +n/UGB58fR+evj/4F7nqI10mVBlmJZ9H5/m2oUXnCrvGaHiaY6QFyMXllL0MV+R+pFrf
         4vzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=A5PjxBocm6GkKPxXcYzX2e1AeHxW0gP+W7kFc8REg2E=;
        b=L/Ax11z0NYzHPwgbEJy2P4QSvDiMqJXJEFrOpatE9B9eZ411MYE4hAqxB6Mx6nQF61
         P6797g2Iun59ewgqu5/5PitIb0TX/42SEEcdVaeCeqj9BraIOVLtRTyDRVq0UGOo4VAF
         XQJmTECP5B7qaq1+yHA/Ux9Vgb8HwJ09eaeELBZBoPc1Yfktnh0obJru+1Lvw2bF0z6l
         Gx0OPiZsINKukrjYiz/0/RG5Jh0cCpbSvgm22itsoNl2Cx2iwtlDh6wxvgtfsjbuSFsM
         u0ZzWqrYBboHGZ+DpB8bkXtcSgI8vYT0VVmHCdt85wMVV+xG6aLb/Pp05KHglIbC3DiW
         5VxA==
X-Gm-Message-State: AOAM5317beZ83p9Xqybpz59DpzBeUMhsKQ89ENsbODI/VxbRUAsnFQ3Q
        tQuva8pRa9SLKe0m4TfWZwSbyay81Q==
X-Google-Smtp-Source: ABdhPJy71wYx5F5tGmoACI6FT7+5mPXDTjIjyxo+ykfIRjL5SWm/BBNye+fcUz68j74/ZTvvlLPyboqWrg==
Sender: "elver via sendgmr" <elver@elver.muc.corp.google.com>
X-Received: from elver.muc.corp.google.com ([2a00:79e0:15:13:51c9:b9a4:3e29:2cd0])
 (user=elver job=sendgmr) by 2002:a05:600c:35c9:: with SMTP id
 r9mr396002wmq.0.1612870029964; Tue, 09 Feb 2021 03:27:09 -0800 (PST)
Date:   Tue,  9 Feb 2021 12:27:01 +0100
Message-Id: <20210209112701.3341724-1-elver@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.0.478.g8a0d178c01-goog
Subject: [PATCH] bpf_lru_list: Read double-checked variable once without lock
From:   Marco Elver <elver@google.com>
To:     elver@google.com, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     kasan-dev@googlegroups.com, paulmck@kernel.org, dvyukov@google.com,
        syzbot+3536db46dfa58c573458@syzkaller.appspotmail.com,
        syzbot+516acdb03d3e27d91bcd@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For double-checked locking in bpf_common_lru_push_free(), node->type is
read outside the critical section and then re-checked under the lock.
However, concurrent writes to node->type result in data races.

For example, the following concurrent access was observed by KCSAN:

  write to 0xffff88801521bc22 of 1 bytes by task 10038 on cpu 1:
   __bpf_lru_node_move_in        kernel/bpf/bpf_lru_list.c:91
   __local_list_flush            kernel/bpf/bpf_lru_list.c:298
   ...
  read to 0xffff88801521bc22 of 1 bytes by task 10043 on cpu 0:
   bpf_common_lru_push_free      kernel/bpf/bpf_lru_list.c:507
   bpf_lru_push_free             kernel/bpf/bpf_lru_list.c:555
   ...

Fix the data races where node->type is read outside the critical section
(for double-checked locking) by marking the access with READ_ONCE() as
well as ensuring the variable is only accessed once.

Reported-by: syzbot+3536db46dfa58c573458@syzkaller.appspotmail.com
Reported-by: syzbot+516acdb03d3e27d91bcd@syzkaller.appspotmail.com
Signed-off-by: Marco Elver <elver@google.com>
---
Detailed reports:
	https://groups.google.com/g/syzkaller-upstream-moderation/c/PwsoQ7bfi8k/m/NH9Ni2WxAQAJ
	https://groups.google.com/g/syzkaller-upstream-moderation/c/-fXQO9ehxSM/m/RmQEcI2oAQAJ
---
 kernel/bpf/bpf_lru_list.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/bpf_lru_list.c b/kernel/bpf/bpf_lru_list.c
index 1b6b9349cb85..d99e89f113c4 100644
--- a/kernel/bpf/bpf_lru_list.c
+++ b/kernel/bpf/bpf_lru_list.c
@@ -502,13 +502,14 @@ struct bpf_lru_node *bpf_lru_pop_free(struct bpf_lru *lru, u32 hash)
 static void bpf_common_lru_push_free(struct bpf_lru *lru,
 				     struct bpf_lru_node *node)
 {
+	u8 node_type = READ_ONCE(node->type);
 	unsigned long flags;
 
-	if (WARN_ON_ONCE(node->type == BPF_LRU_LIST_T_FREE) ||
-	    WARN_ON_ONCE(node->type == BPF_LRU_LOCAL_LIST_T_FREE))
+	if (WARN_ON_ONCE(node_type == BPF_LRU_LIST_T_FREE) ||
+	    WARN_ON_ONCE(node_type == BPF_LRU_LOCAL_LIST_T_FREE))
 		return;
 
-	if (node->type == BPF_LRU_LOCAL_LIST_T_PENDING) {
+	if (node_type == BPF_LRU_LOCAL_LIST_T_PENDING) {
 		struct bpf_lru_locallist *loc_l;
 
 		loc_l = per_cpu_ptr(lru->common_lru.local_list, node->cpu);
-- 
2.30.0.478.g8a0d178c01-goog

