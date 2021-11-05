Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F50E446AAE
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 22:42:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233102AbhKEVpB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 17:45:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232934AbhKEVpA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Nov 2021 17:45:00 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C8A5C061570
        for <netdev@vger.kernel.org>; Fri,  5 Nov 2021 14:42:18 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id n36-20020a17090a5aa700b0019fa884ab85so4238178pji.5
        for <netdev@vger.kernel.org>; Fri, 05 Nov 2021 14:42:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Q7DYm/VtVMSabGX9/vLK32h3hn/fCqMgaaGrWW1CTOM=;
        b=RoHW6LLSA56MGmjrwLCJ77k77ilY0XLF/QZwZxNYuQ05dPi7iKxlrMHs2k3GDQVRbQ
         wk57ER6u5FhioxK9F9c1PhcKri4mOenYKEXUz5/I9d09314Fu4Z1YH1QnhWpL0FKRhS+
         +tDOZ4LONZHZipc77qPv/lb0rBYwcC77zcE107N3wXf3RagDEPCtDWRbsPccCSf7GBNh
         E6gLTQEyCj4/sS0hFmuxsxXp8nSw8RZeQbRZe18QH/B7VGJHuKNeWPjR2y7zDzJc75Wf
         dr6N4s/JT+gU8k37kQB1wSPcA3Gj/vC0h/tdQHHuuuTiLR5gpCEesaUJhjKeo/a3pZse
         Ls1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Q7DYm/VtVMSabGX9/vLK32h3hn/fCqMgaaGrWW1CTOM=;
        b=LhifSW2ryL9kg+jwEqQHerWp7TpJYgUepeW6wsbPqUm7L4sWs2HmYdUsvQjjSsv2Mi
         rXYrxQMoP1fOIJuXX6YBGWDW/w0pDf/Y/QenU+PSCAYydp8l4dQjDB6nBUsgu9FhLLXL
         SyIndFrI4iFFsBivk3xL8CGVsAmmJx/5sKWDaA3cLcf+jWhwtt2QlqZFC4Kar2gf4O4z
         qN5lgQhyEJ8KfQFF9A2Lbp9I4ZaP6NejfVnjYx85cfN1gE4dVQzlZ9BdMBq7nzmno3at
         KaEVGOUaQDdS9t3uHOKD9RoPoYtpwpcJTfXO23ywF6PPyYyinpLggpB9FzQzQ4j4JU5Z
         rI5g==
X-Gm-Message-State: AOAM530F/2yXtoVqo6DRzkJFB+zH/JWE3zC3FHwF2l7IbktSubD0rv8i
        tNyQYK9OYOgCeP7L43fu5Cc=
X-Google-Smtp-Source: ABdhPJwA5JcnYjLzKkacC6zAnAnZQlg+aRXiblta8GWYL/IWl/TrQ4WUeOoEueOwwMVGdqghubJjiw==
X-Received: by 2002:a17:902:e5c9:b0:142:53c4:478d with SMTP id u9-20020a170902e5c900b0014253c4478dmr3490897plf.33.1636148538401;
        Fri, 05 Nov 2021 14:42:18 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:de44:6393:8b19:6f30])
        by smtp.gmail.com with ESMTPSA id mp12sm10332388pjb.39.2021.11.05.14.42.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Nov 2021 14:42:17 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH net] llc: fix out-of-bound array index in llc_sk_dev_hash()
Date:   Fri,  5 Nov 2021 14:42:14 -0700
Message-Id: <20211105214214.2259841-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Both ifindex and LLC_SK_DEV_HASH_ENTRIES are signed.

This means that (ifindex % LLC_SK_DEV_HASH_ENTRIES) is negative
if @ifindex is negative.

We could simply make LLC_SK_DEV_HASH_ENTRIES unsigned.

In this patch I chose to use hash_32() to get more entropy
from @ifindex, like llc_sk_laddr_hashfn().

UBSAN: array-index-out-of-bounds in ./include/net/llc.h:75:26
index -43 is out of range for type 'hlist_head [64]'
CPU: 1 PID: 20999 Comm: syz-executor.3 Not tainted 5.15.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 ubsan_epilogue+0xb/0x5a lib/ubsan.c:151
 __ubsan_handle_out_of_bounds.cold+0x62/0x6c lib/ubsan.c:291
 llc_sk_dev_hash include/net/llc.h:75 [inline]
 llc_sap_add_socket+0x49c/0x520 net/llc/llc_conn.c:697
 llc_ui_bind+0x680/0xd70 net/llc/af_llc.c:404
 __sys_bind+0x1e9/0x250 net/socket.c:1693
 __do_sys_bind net/socket.c:1704 [inline]
 __se_sys_bind net/socket.c:1702 [inline]
 __x64_sys_bind+0x6f/0xb0 net/socket.c:1702
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7fa503407ae9

Fixes: 6d2e3ea28446 ("llc: use a device based hash table to speed up multicast delivery")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 include/net/llc.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/net/llc.h b/include/net/llc.h
index fd1f9a3fd8dda463cc24d95e0d3a528e505927b4..e250dca03963bf14750d16ebf1cb6d976b7206d3 100644
--- a/include/net/llc.h
+++ b/include/net/llc.h
@@ -72,7 +72,9 @@ struct llc_sap {
 static inline
 struct hlist_head *llc_sk_dev_hash(struct llc_sap *sap, int ifindex)
 {
-	return &sap->sk_dev_hash[ifindex % LLC_SK_DEV_HASH_ENTRIES];
+	u32 bucket = hash_32(ifindex, LLC_SK_DEV_HASH_BITS);
+
+	return &sap->sk_dev_hash[bucket];
 }
 
 static inline
-- 
2.34.0.rc0.344.g81b53c2807-goog

