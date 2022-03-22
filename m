Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27AEC4E4436
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 17:28:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239084AbiCVQaO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 12:30:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234303AbiCVQaN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 12:30:13 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C41C958E72;
        Tue, 22 Mar 2022 09:28:45 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id u26so6742512eda.12;
        Tue, 22 Mar 2022 09:28:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hEJg0IVCeHWZv9DfitcH+qa7KCGsvxY+S9H3HLIfHCs=;
        b=FaP3wupVNnaCpC+7XHofJ3LegU+yLpBpzRn/G8uGZZf/Xwh8P/cqD2ancKHyBiBSbE
         F8jOIpS+VBKm3ZgrNc7/gdCJ/g7PBpzNOqyIfMt2yRucFusT+5161f6R2fGQlE6nz/8d
         Y5JDI5oEx456tyXfDXUGCSzRhFX+/tH+ndMdsJLBg/SGJanUM0H03VIB4i7o4fig3y0T
         sww4/06hREGEtDRNqdk28MMDwJbomilrXYu4etboPrzue8wtlXYRZVtxekTJb07mjGj5
         aZ4IFM42r2QvtS5LnmSbJLPbvquvkJtyT1qe3Yjhy5JHC/uih1MUcRBPLLK+CXBYxSsE
         I6tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hEJg0IVCeHWZv9DfitcH+qa7KCGsvxY+S9H3HLIfHCs=;
        b=dFqwJGVWh2qkkzJv6QYhBlhlvcgs/rOhWlRcTtmSC6gd6Bi4R5FjsEGSQs9JFjaUQ9
         WVEP3WxF2iWYEiV1tMHtVOIg7DSASllNXtzSr+fUrF/Mm1G9zWQDbheJMas4Mqwi158+
         HhLbYJmnnQdPbVKFSsdILCKSFqtKEuyCkQ4MMErllq22TUgTtVYptaXdoBPKUuIqLak2
         /Y9YTqpOMVGbJnBP6yw1H7GzOASWNlB0QP4L7/YcgMc8Q6JCxX5Y6RlSEW1JOenUCl5i
         5fJMEmB8PAzODooWkCwsby8Ildy9/pdhR3dg8xuuH92ruCi4bXjMsvD5bCQbcAfUN8N8
         8Juw==
X-Gm-Message-State: AOAM530zquYkKAovhmpqzKgdYrTgZumSMnJZVHI3Zt9ym0E3vODET3tt
        +abUH0F2OZWhCvpFar05pP8=
X-Google-Smtp-Source: ABdhPJy7d+49CosYTV5vdOCoaqxWbADw6w9A/cni/jagO7tuoTcsZsgTdWQHvxWA9mdV3YAzF5XJ0g==
X-Received: by 2002:aa7:cd7a:0:b0:419:48ce:3a10 with SMTP id ca26-20020aa7cd7a000000b0041948ce3a10mr9350322edb.312.1647966524293;
        Tue, 22 Mar 2022 09:28:44 -0700 (PDT)
Received: from localhost.localdomain ([185.239.71.98])
        by smtp.gmail.com with ESMTPSA id o14-20020a170906774e00b006d5b915f27dsm8501971ejn.169.2022.03.22.09.28.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Mar 2022 09:28:43 -0700 (PDT)
From:   Xiaolong Huang <butterflyhuangxx@gmail.com>
To:     dhowells@redhat.com, marc.dionne@auristor.com, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com
Cc:     linux-afs@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Xiaolong Huang <butterflyhuangxx@gmail.com>
Subject: [PATCH] rxrpc: fix some null-ptr-deref bugs in server_key.c
Date:   Wed, 23 Mar 2022 00:28:22 +0800
Message-Id: <20220322162822.566705-1-butterflyhuangxx@gmail.com>
X-Mailer: git-send-email 2.25.1
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

Some function calls are not implemented in rxrpc_no_security, there are
preparse_server_key, free_preparse_server_key and destroy_server_key.
When rxrpc security type is rxrpc_no_security, user can easily trigger a
null-ptr-deref bug via ioctl. So judgment should be added to prevent it

The crash log:
user@syzkaller:~$ ./rxrpc_preparse_s
[   37.956878][T15626] BUG: kernel NULL pointer dereference, address: 0000000000000000
[   37.957645][T15626] #PF: supervisor instruction fetch in kernel mode
[   37.958229][T15626] #PF: error_code(0x0010) - not-present page
[   37.958762][T15626] PGD 4aadf067 P4D 4aadf067 PUD 4aade067 PMD 0
[   37.959321][T15626] Oops: 0010 [#1] PREEMPT SMP
[   37.959739][T15626] CPU: 0 PID: 15626 Comm: rxrpc_preparse_ Not tainted 5.17.0-01442-gb47d5a4f6b8d #43
[   37.960588][T15626] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1 04/01/2014
[   37.961474][T15626] RIP: 0010:0x0
[   37.961787][T15626] Code: Unable to access opcode bytes at RIP 0xffffffffffffffd6.
[   37.962480][T15626] RSP: 0018:ffffc9000d9abdc0 EFLAGS: 00010286
[   37.963018][T15626] RAX: ffffffff84335200 RBX: ffff888012a1ce80 RCX: 0000000000000000
[   37.963727][T15626] RDX: 0000000000000000 RSI: ffffffff84a736dc RDI: ffffc9000d9abe48
[   37.964425][T15626] RBP: ffffc9000d9abe48 R08: 0000000000000000 R09: 0000000000000002
[   37.965118][T15626] R10: 000000000000000a R11: f000000000000000 R12: ffff888013145680
[   37.965836][T15626] R13: 0000000000000000 R14: ffffffffffffffec R15: ffff8880432aba80
[   37.966441][T15626] FS:  00007f2177907700(0000) GS:ffff88803ec00000(0000) knlGS:0000000000000000
[   37.966979][T15626] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   37.967384][T15626] CR2: ffffffffffffffd6 CR3: 000000004aaf1000 CR4: 00000000000006f0
[   37.967864][T15626] Call Trace:
[   37.968062][T15626]  <TASK>
[   37.968240][T15626]  rxrpc_preparse_s+0x59/0x90
[   37.968541][T15626]  key_create_or_update+0x174/0x510
[   37.968863][T15626]  __x64_sys_add_key+0x139/0x1d0
[   37.969165][T15626]  do_syscall_64+0x35/0xb0
[   37.969451][T15626]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[   37.969824][T15626] RIP: 0033:0x43a1f9

Signed-off-by: Xiaolong Huang <butterflyhuangxx@gmail.com>
Tested-by: Xiaolong Huang <butterflyhuangxx@gmail.com>
---
 net/rxrpc/server_key.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/rxrpc/server_key.c b/net/rxrpc/server_key.c
index ead3471307ee..ee269e0e6ee8 100644
--- a/net/rxrpc/server_key.c
+++ b/net/rxrpc/server_key.c
@@ -84,6 +84,9 @@ static int rxrpc_preparse_s(struct key_preparsed_payload *prep)
 
 	prep->payload.data[1] = (struct rxrpc_security *)sec;
 
+	if (!sec->preparse_server_key)
+		return -EINVAL;
+
 	return sec->preparse_server_key(prep);
 }
 
@@ -91,7 +94,7 @@ static void rxrpc_free_preparse_s(struct key_preparsed_payload *prep)
 {
 	const struct rxrpc_security *sec = prep->payload.data[1];
 
-	if (sec)
+	if (sec && sec->free_preparse_server_key)
 		sec->free_preparse_server_key(prep);
 }
 
@@ -99,7 +102,7 @@ static void rxrpc_destroy_s(struct key *key)
 {
 	const struct rxrpc_security *sec = key->payload.data[1];
 
-	if (sec)
+	if (sec && sec->destroy_server_key)
 		sec->destroy_server_key(key);
 }
 

base-commit: b47d5a4f6b8d42f8a8fbe891b36215e4fddc53be
-- 
2.25.1

