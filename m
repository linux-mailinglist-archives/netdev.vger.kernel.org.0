Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1AC531E36F
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 01:18:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbhBRARm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 19:17:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229708AbhBRARk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 19:17:40 -0500
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A433C061574;
        Wed, 17 Feb 2021 16:16:59 -0800 (PST)
Received: by mail-ot1-x32f.google.com with SMTP id q4so345892otm.9;
        Wed, 17 Feb 2021 16:16:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VmEI9bK6S+MA6iIG56tLhKiAJVbLpfqcE1mPZiBV0Dk=;
        b=UjVV4Uxj2xDfn/Pw9giP4UOdGVOyMe0l1DhcV3wK5RGp+LeVro/jzvuNKPwROutpfk
         wxErXWYLFm9LFmatrMQgW3PdTXFx+ItE/9SqXmhZFKa7a2XZ+Z+czHM1jz4BKt6Qbf51
         yhKKfQROnxt28QiCZVZzdaws7l+cuEud/OZ57rzQnLDGF8q1dWLWNkv10qychI5Hwx3y
         wlxiX5EakQX2HQXvM3xaq+tAgRlq8RlTmhfMJzzSyHcBHw3LKJ9Lbn3dVrRJvt1PNTBp
         ayq+7tp8aU8Pap9qHycyK1N7RPdmTseDrb9DzgtNLNC3YpdbzWfk+9CQW0pRppRH8nA/
         dqmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VmEI9bK6S+MA6iIG56tLhKiAJVbLpfqcE1mPZiBV0Dk=;
        b=cCdCBHpbsnvnzMWMBd+WoXTG49civQBDe2MpWgzzgDS6hdRAMBVT8SCtkcQms+ZSUP
         ooTuMwC1bp+itEc7H5//5X5tttwDeJvl15RbY7GKolQu8XCupkK87sY5XiuqMuW1M4p+
         i9lidNXRiIe+7xfKCkbCEMbA271H5uIHoXbNtnH4iS2oo36zkEaZyRSvbmFuvVqSgXJa
         nL5AUSHT+t3CufmjN2wI9QgRq0nSCu+yckbx16nMEnxeQESuMdU8a+IroOF8uI9SGPci
         9ymJF5c3Jb8Yj4EKV+yFrdcwIlZfSvsevX9trx1HYS24h7EEPVj2F+OU34pbio/AGOp1
         X+lA==
X-Gm-Message-State: AOAM531DsSFvH5Uyye+QlM3L+CcbekQUbsVEAsM2XJyB+0YU74nj2fCd
        7E00YI5KSHXWBx2Hdou9JOFPql4My5lW6w==
X-Google-Smtp-Source: ABdhPJyTKfJUTD1VslGvUiET3tWsD0LDfHYPn+dV7jul5SByRxcXtAeKaVhS+vLI3x7GmYTGy2QucA==
X-Received: by 2002:a9d:58ca:: with SMTP id s10mr1173586oth.70.1613607417934;
        Wed, 17 Feb 2021 16:16:57 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:1d72:18:7c76:92e4])
        by smtp.gmail.com with ESMTPSA id r205sm807458oib.15.2021.02.17.16.16.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Feb 2021 16:16:57 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [Patch bpf-next v2] bpf: clear percpu pointers in bpf_prog_clone_free()
Date:   Wed, 17 Feb 2021 16:16:47 -0800
Message-Id: <20210218001647.71631-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

Similar to bpf_prog_realloc(), bpf_prog_clone_create() also copies
the percpu pointers, but the clone still shares them with the original
prog, so we have to clear these two percpu pointers in
bpf_prog_clone_free(). Otherwise we would get a double free:

 BUG: kernel NULL pointer dereference, address: 0000000000000000
 #PF: supervisor read access in kernel mode
 #PF: error_code(0x0000) - not-present page
 PGD 0 P4D 0
 Oops: 0000 [#1] SMP PTI
 CPU: 13 PID: 8140 Comm: kworker/13:247 Kdump: loaded Tainted: G                W    OE
  5.11.0-rc4.bm.1-amd64+ #1
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1 04/01/2014
 test_bpf: #1 TXA
 Workqueue: events bpf_prog_free_deferred
 RIP: 0010:percpu_ref_get_many.constprop.97+0x42/0xf0
 Code: [...]
 RSP: 0018:ffffa6bce1f9bda0 EFLAGS: 00010002
 RAX: 0000000000000001 RBX: 0000000000000000 RCX: 00000000021dfc7b
 RDX: ffffffffae2eeb90 RSI: 867f92637e338da5 RDI: 0000000000000046
 RBP: ffffa6bce1f9bda8 R08: 0000000000000000 R09: 0000000000000001
 R10: 0000000000000046 R11: 0000000000000000 R12: 0000000000000280
 R13: 0000000000000000 R14: 0000000000000000 R15: ffff9b5f3ffdedc0
 FS:    0000000000000000(0000) GS:ffff9b5f2fb40000(0000) knlGS:0000000000000000
 CS:    0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 0000000000000000 CR3: 000000027c36c002 CR4: 00000000003706e0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
 Call Trace:
    refill_obj_stock+0x5e/0xd0
    free_percpu+0xee/0x550
    __bpf_prog_free+0x4d/0x60
    process_one_work+0x26a/0x590
    worker_thread+0x3c/0x390
    ? process_one_work+0x590/0x590
    kthread+0x130/0x150
    ? kthread_park+0x80/0x80
    ret_from_fork+0x1f/0x30

This bug is 100% reproducible with test_kmod.sh.

Reported-by: Jiang Wang <jiang.wang@bytedance.com>
Fixes: 700d4796ef59 ("bpf: Optimize program stats")
Fixes: ca06f55b9002 ("bpf: Add per-program recursion prevention mechanism")
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 kernel/bpf/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 0ae015ad1e05..aa1e64196d8d 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -1118,6 +1118,8 @@ static void bpf_prog_clone_free(struct bpf_prog *fp)
 	 * clone is guaranteed to not be locked.
 	 */
 	fp->aux = NULL;
+	fp->stats = NULL;
+	fp->active = NULL;
 	__bpf_prog_free(fp);
 }
 
-- 
2.25.1

