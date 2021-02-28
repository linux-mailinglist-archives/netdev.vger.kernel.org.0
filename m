Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3511F32752B
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 00:24:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231286AbhB1XXf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Feb 2021 18:23:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231247AbhB1XXe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Feb 2021 18:23:34 -0500
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C8C6C06174A;
        Sun, 28 Feb 2021 15:22:53 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id 18so13959757lff.6;
        Sun, 28 Feb 2021 15:22:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4ldXGh03zy5ClnMT7q7y7sw5ze6F2NXvT0BQp+tFnFA=;
        b=jJC96Eb4lChoHEwPbM9kg5VlJ0LO5Te9A4quhDZ2O6VpuJjb7L0HXdE1OL1qynu13q
         UNbKzw0rQOvti2LPSNzPSpsOoaVhh/O0nvD0TreSJbmJOB3kLTwE5EPpIbhTemS9v0CH
         7Q/Xs6E8fy7W4vH/LxSNzk5MadoBFoLPKokaBdK+M/HdJjIsFc483T0njwBBArgyN6x5
         TP8dhdS4qeGYGtl23chw2r19X8gkoz8SwzIILrbxuaF862ioy7axrts1LEYkihHsxYB6
         jvuch1B8YBVjEBVU7UP1tm7aE68+nV1vtoxUoa8mtF1bV3QsIXKKF4ccLuqY8skQu5Pa
         qVqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4ldXGh03zy5ClnMT7q7y7sw5ze6F2NXvT0BQp+tFnFA=;
        b=kWW/z33c8xYwnEflZyK9ndEbjOkMUICz7Y8vHKGb+CwVgT8OcJRDH0h72fTcWydS+v
         zqdJz1wHB/h37I73pVNRBR4GNrHacCNNkrm1zUnb7jCXgiFl7kVUKswuwVk0ZSTTQUuh
         g72lv1eHnHe+qDQURgu+6MwTnoGq52hL/jv3EUg9O46puLBGakSqXa1AY1xYH8vLnUYY
         LYAKgXEZyXzJb3Npfh59eeH/MtWIR3GdDhPHEtyHaf/gyX3jvbtjmwYXnXSrL7Zf89vW
         b8z5fA8lS+k0gv38YDyYlj4ktdfiXZuQQJVKGYOnHMlrb3bKbQRIhtp29H9+MqrtEeeF
         MfKg==
X-Gm-Message-State: AOAM530WQ4IPYQXqyh4pEwuftbGzpNNOInY4m0Yxffv/b44DBa8OzvEK
        ucF2vLEhyjFNeH38HZc8ufw=
X-Google-Smtp-Source: ABdhPJwMneoTihkP6Ycws6iCtdsRZqkCR4I+sSloNgDxrhE1qQ/76Iiw6Vga1FK56mntenZ8E9JVjw==
X-Received: by 2002:ac2:4e71:: with SMTP id y17mr7687310lfs.153.1614554571918;
        Sun, 28 Feb 2021 15:22:51 -0800 (PST)
Received: from localhost.localdomain ([94.103.235.167])
        by smtp.gmail.com with ESMTPSA id h62sm1246886lfd.234.2021.02.28.15.22.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Feb 2021 15:22:51 -0800 (PST)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     alobakin@pm.me
Cc:     linmiaohe@huawei.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+80dccaee7c6630fa9dcf@syzkaller.appspotmail.com,
        Pavel Skripkin <paskripkin@gmail.com>
Subject: [PATCH v4] net/qrtr: fix __netdev_alloc_skb call
Date:   Mon,  1 Mar 2021 02:22:40 +0300
Message-Id: <20210228232240.972205-1-paskripkin@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210228201000.13606-1-alobakin@pm.me>
References: <20210228201000.13606-1-alobakin@pm.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot found WARNING in __alloc_pages_nodemask()[1] when order >= MAX_ORDER.
It was caused by a huge length value passed from userspace to qrtr_tun_write_iter(),
which tries to allocate skb. Since the value comes from the untrusted source 
there is no need to raise a warning in __alloc_pages_nodemask().

[1] WARNING in __alloc_pages_nodemask+0x5f8/0x730 mm/page_alloc.c:5014
Call Trace:
 __alloc_pages include/linux/gfp.h:511 [inline]
 __alloc_pages_node include/linux/gfp.h:524 [inline]
 alloc_pages_node include/linux/gfp.h:538 [inline]
 kmalloc_large_node+0x60/0x110 mm/slub.c:3999
 __kmalloc_node_track_caller+0x319/0x3f0 mm/slub.c:4496
 __kmalloc_reserve net/core/skbuff.c:150 [inline]
 __alloc_skb+0x4e4/0x5a0 net/core/skbuff.c:210
 __netdev_alloc_skb+0x70/0x400 net/core/skbuff.c:446
 netdev_alloc_skb include/linux/skbuff.h:2832 [inline]
 qrtr_endpoint_post+0x84/0x11b0 net/qrtr/qrtr.c:442
 qrtr_tun_write_iter+0x11f/0x1a0 net/qrtr/tun.c:98
 call_write_iter include/linux/fs.h:1901 [inline]
 new_sync_write+0x426/0x650 fs/read_write.c:518
 vfs_write+0x791/0xa30 fs/read_write.c:605
 ksys_write+0x12d/0x250 fs/read_write.c:658
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Reported-by: syzbot+80dccaee7c6630fa9dcf@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---
 net/qrtr/qrtr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
index b34358282f37..82d2eb8c21d1 100644
--- a/net/qrtr/qrtr.c
+++ b/net/qrtr/qrtr.c
@@ -439,7 +439,7 @@ int qrtr_endpoint_post(struct qrtr_endpoint *ep, const void *data, size_t len)
 	if (len == 0 || len & 3)
 		return -EINVAL;
 
-	skb = netdev_alloc_skb(NULL, len);
+	skb = __netdev_alloc_skb(NULL, len, GFP_ATOMIC | __GFP_NOWARN);
 	if (!skb)
 		return -ENOMEM;
 
-- 
2.25.1

