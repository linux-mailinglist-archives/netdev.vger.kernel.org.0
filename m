Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF82431D459
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 05:00:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230332AbhBQD7p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 22:59:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbhBQD7n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 22:59:43 -0500
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A03CAC061574;
        Tue, 16 Feb 2021 19:59:03 -0800 (PST)
Received: by mail-oi1-x235.google.com with SMTP id j5so1435206oie.1;
        Tue, 16 Feb 2021 19:59:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AY8ombUPMk1cvNC/PKFtk7SgwFEagvcrvmHWjWPulWw=;
        b=rPDeGPGnqFNQogk9sS4KbskCsEl4kV+jiOr2b6zGfv4gC4oDo4ExjX1ovb2y2T17AP
         RRr7kE0u6w64+DykEA3VC9PEETfu6z74ufOQvLChCrz5KVobeKea8H1X7/759UJ2YdFx
         dE8HBI6G/y9yryLeLWTB2qG+4KD+uPXAf6YJrJTaTA1Af0J39IfgHKMkhg/Bz+95DYqm
         uflGb9Fr5WH7dl5pvO0U5CpeHXIONNzXbrRLiA2XmitqKSfcPRUiugh/wKQM222s0G8u
         MNdqE+tY+qxM0eeZa73IfwlmQJ67FuhCAw+74ONEV+80JGsH3fjPKrrgat0i1uUbIjgY
         1oGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AY8ombUPMk1cvNC/PKFtk7SgwFEagvcrvmHWjWPulWw=;
        b=ZZuM8UAVH3owqyiivAGo77iIEgZ1H8fIEz2vRMdrpMvBXcwnBdsr7OdXy0IqBr+dMR
         AkJ52o9ck0C4ruIO3FfdySIV7/vcFFPs/WlwYJhDiXBxTJmXqM3Bd5CS2Id1tXQGqXOP
         nlfat3a7lBQSEE+E+4uhaIKvikeKtOd6ickX2IB7QoILvIk+efwyekJilX2BemXHspBj
         r3OiKRWvjZZYS/jG6//UrTj8HcS0eJEDuogNqoE1z97HCQkFjEjMlz2wBCjtuFG2PuG/
         DJZ7YV9NiymKtQCbkW8TcmsEQKGM6w9OqQNanUQwVHT0Ni1FjGgVmSB1/Nfwwkjfp8F1
         MNfQ==
X-Gm-Message-State: AOAM531e4C/z8BegrDhVLtYN/jSM1HmEeOh2XrhaQmjIr/LR/lf268H2
        yefYVWVFQvksl+pDk/JwLTWFupe1u5t6vg==
X-Google-Smtp-Source: ABdhPJw5IZraKvC3o1qp08dJu1Yo7WrKD57vKlxpQNOTaGSKP4MEobSvgowVZ33fvIJBJwZdvqcUgg==
X-Received: by 2002:a05:6808:8ec:: with SMTP id d12mr4645118oic.54.1613534342767;
        Tue, 16 Feb 2021 19:59:02 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:1d72:18:7c76:92e4])
        by smtp.gmail.com with ESMTPSA id l110sm185511otc.25.2021.02.16.19.59.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Feb 2021 19:59:02 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [Patch bpf-next] bpf: clear per_cpu pointers in bpf_prog_clone_create()
Date:   Tue, 16 Feb 2021 19:58:44 -0800
Message-Id: <20210217035844.53746-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

Pretty much similar to commit 1336c662474e
("bpf: Clear per_cpu pointers during bpf_prog_realloc") we also need to
clear these two percpu pointers in bpf_prog_clone_create(), otherwise
would get a double free:

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
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 kernel/bpf/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 0ae015ad1e05..b0c11532e535 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -1103,6 +1103,8 @@ static struct bpf_prog *bpf_prog_clone_create(struct bpf_prog *fp_other,
 		 * this still needs to be adapted.
 		 */
 		memcpy(fp, fp_other, fp_other->pages * PAGE_SIZE);
+		fp_other->stats = NULL;
+		fp_other->active = NULL;
 	}
 
 	return fp;
-- 
2.25.1

