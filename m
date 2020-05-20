Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2B4E1DA723
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 03:24:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728353AbgETBYs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 21:24:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726348AbgETBYr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 21:24:47 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE87EC061A0E
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 18:24:47 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id k15so353220ybt.4
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 18:24:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=BjZAv480XGd9fREWpcCLTTW6tn22HghswhtlMvVg8jM=;
        b=HlDKoBmng0sxTvoMIJl48XIYPfP6uGABDKAshG+gm0ewtH7geqEmRP5KmwzMHuVlpU
         v+c2JbDCWYfR+u1PJf9rqYtaCDR8s4pm4NXLbBLnF99rX/3kvaoOQXaVqzSxF2xLMFMC
         MbRb8lCI22dq1Lju9V7ms4WGSEObaEmXRGs6R6U0fb7ERDtGoy7g54gBkhzCULj6waT3
         60Vs+VCC/Afm7/FQd7zKnFEKcX/UuepD2C5Qj1+q/5upsjKErITsVPQK9LE2N8EUKX0U
         xEJU5PNmsAS4ICfNgNk+y/u+Jp7HrCjsxikaxwpKLCUYUItEgZZBLI9TQ4uJJILDh7fD
         DQ6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=BjZAv480XGd9fREWpcCLTTW6tn22HghswhtlMvVg8jM=;
        b=jgtkjL0maPlkXgOyt/d3oWXSKmr4wnP0vo7zWjB3j+fIiYmrzQietOOBi1uRuDM5fV
         S5r9BA5eBjfzJlFIW8cgvaY3mDFtFScn+ZQDP0sNZEOOiuhskGPvXopZumEBriHrRzEz
         QRKW2mdYdeItcRdY8ndoFuDhyn8NMWMZQcwxBH3BzdWMJOu2XHIv70WyDNyqk3DWY6J0
         4BoSvggtmFDFlGos17hT0swA3zq7x8l+2w10CZSalLA3sg+S2d/GvV2cbYOXTIRN8XJJ
         wtoadKLqrVliyvvJbZsl5E2aGIhdKZfzgh7+JR3so9WZ0TUeSNpfmnd3UOIm21ASwAyV
         sJjw==
X-Gm-Message-State: AOAM530xAOGcKEyvf7JuJMXV4PKMeWXEFGwxw1UeQGR55LNgQSHJKBTj
        Lv97iJM74UxNRwDib2F6bJNQh0RmuKPLtw==
X-Google-Smtp-Source: ABdhPJzSRBqm5qNVTQQVHEIIjWcOzpsK8sbl5+KsEgsK9tb+VMd6AwlrJmg8zSJIvmTAbdxdxRfokB5R9YUO0w==
X-Received: by 2002:a5b:5d0:: with SMTP id w16mr3635719ybp.110.1589937886916;
 Tue, 19 May 2020 18:24:46 -0700 (PDT)
Date:   Tue, 19 May 2020 18:24:43 -0700
Message-Id: <20200520012443.31913-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be-goog
Subject: [PATCH net] ax24: fix setsockopt(SO_BINDTODEVICE)
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot was able to trigger this trace [1], probably by using
a zero optlen.

While we are at it, cap optlen to IFNAMSIZ - 1 instead of IFNAMSIZ.

[1]
BUG: KMSAN: uninit-value in strnlen+0xf9/0x170 lib/string.c:569
CPU: 0 PID: 8807 Comm: syz-executor483 Not tainted 5.7.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1c9/0x220 lib/dump_stack.c:118
 kmsan_report+0xf7/0x1e0 mm/kmsan/kmsan_report.c:121
 __msan_warning+0x58/0xa0 mm/kmsan/kmsan_instr.c:215
 strnlen+0xf9/0x170 lib/string.c:569
 dev_name_hash net/core/dev.c:207 [inline]
 netdev_name_node_lookup net/core/dev.c:277 [inline]
 __dev_get_by_name+0x75/0x2b0 net/core/dev.c:778
 ax25_setsockopt+0xfa3/0x1170 net/ax25/af_ax25.c:654
 __compat_sys_setsockopt+0x4ed/0x910 net/compat.c:403
 __do_compat_sys_setsockopt net/compat.c:413 [inline]
 __se_compat_sys_setsockopt+0xdd/0x100 net/compat.c:410
 __ia32_compat_sys_setsockopt+0x62/0x80 net/compat.c:410
 do_syscall_32_irqs_on arch/x86/entry/common.c:339 [inline]
 do_fast_syscall_32+0x3bf/0x6d0 arch/x86/entry/common.c:398
 entry_SYSENTER_compat+0x68/0x77 arch/x86/entry/entry_64_compat.S:139
RIP: 0023:0xf7f57dd9
Code: 90 e8 0b 00 00 00 f3 90 0f ae e8 eb f9 8d 74 26 00 89 3c 24 c3 90 90 90 90 90 90 90 90 90 90 90 90 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90 90 90 90 eb 0d 90 90 90 90 90 90 90 90 90 90 90 90
RSP: 002b:00000000ffae8c1c EFLAGS: 00000217 ORIG_RAX: 000000000000016e
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000000101
RDX: 0000000000000019 RSI: 0000000020000000 RDI: 0000000000000004
RBP: 0000000000000012 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000

Local variable ----devname@ax25_setsockopt created at:
 ax25_setsockopt+0xe6/0x1170 net/ax25/af_ax25.c:536
 ax25_setsockopt+0xe6/0x1170 net/ax25/af_ax25.c:536

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/ax25/af_ax25.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index ff57ea89c27e652c1128f68e69e22d41be361dac..fd91cd34f25e03d0178cbe66568ed392a7013f4e 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -635,8 +635,10 @@ static int ax25_setsockopt(struct socket *sock, int level, int optname,
 		break;
 
 	case SO_BINDTODEVICE:
-		if (optlen > IFNAMSIZ)
-			optlen = IFNAMSIZ;
+		if (optlen > IFNAMSIZ - 1)
+			optlen = IFNAMSIZ - 1;
+
+		memset(devname, 0, sizeof(devname));
 
 		if (copy_from_user(devname, optval, optlen)) {
 			res = -EFAULT;
-- 
2.26.2.761.g0e0b3e54be-goog

