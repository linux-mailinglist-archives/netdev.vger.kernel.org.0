Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 054A9BA162
	for <lists+netdev@lfdr.de>; Sun, 22 Sep 2019 09:45:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727782AbfIVHpg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Sep 2019 03:45:36 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:34126 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727741AbfIVHpg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Sep 2019 03:45:36 -0400
Received: by mail-pf1-f195.google.com with SMTP id b128so7139573pfa.1
        for <netdev@vger.kernel.org>; Sun, 22 Sep 2019 00:45:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=nCXyLnEgMLjc/Vtkmi/e71X0zH8FHddsmVdaRufJc9I=;
        b=AOGVZE1MZDe1AYoYoqu+KqIeqb6wMtLLkrAA9UxZ8+FaP7zNiFworkyDNrweSLtdgd
         YwSUY9Isqys5EYmbLJIj1+qWAM05kyeqUb+hcTGs1GhnCQiG4jvW6Y8ooK6G7iL1RENg
         E6zfGQHrznh6MJunbU8Df+tRht3wtutHpLmwNP1lVdfWLEFps6FXct/mUFSDON9KorXI
         P9MouUz0zI/wBcWT2cR02ABJ29cYxA5sfe9YFjir/VfxiyQf3KwbSe4g+J5MZWRwU+zG
         6OY/dWRK2z6nt6p9jjx9sWEq2vCfeGzGLWx8WcEoHqDhsOGK19oxDRsWdFSLtwedraZx
         7Rfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=nCXyLnEgMLjc/Vtkmi/e71X0zH8FHddsmVdaRufJc9I=;
        b=mr2heIBc++WRUzMfslrZE8p9RzwwkeykqQdb2dWjUNPl6JKOXFGK5bLDxClq0V4gLu
         FLXhRtT0D1KMGSe3GQQRN+gIp1neT7MT4ExP7UWGM8gPO32u2ac6JWsfpB1gLhK/e9iB
         PlRSq1zEWp113mWp6hC0Gc23A5kcnoN9qdm2ZwudAKdlunVv8OWOal5fnXgLdlGYiJbc
         MmzEV+2eOefYpOw354KADierS5inUJZGK2wsatmmEp5y3kXoHRIGa+N+UZpliumLp8q3
         0UeO+bZT6od4McEkxiLOw0JO+xTjqDUMz0LbNoAKAQ21uswmTaHh82Yyu0fhkyxTe+BG
         S+6w==
X-Gm-Message-State: APjAAAUvnVBFctHoX3ni5P6Y9Al5lk+DC/OaX+/lb2dYnJg7OZJr9vNZ
        1cQd774lnZ4CEFXz4p4nlA==
X-Google-Smtp-Source: APXvYqzF55Rr4Xt8EuL9yCkcGpn4hGF3rt9tGHr8ebtVEnZYS7I35ALxZzet6u5+OzegUXNamP5fCg==
X-Received: by 2002:a62:7911:: with SMTP id u17mr28605727pfc.162.1569138335494;
        Sun, 22 Sep 2019 00:45:35 -0700 (PDT)
Received: from DESKTOP (softbank126011124198.bbtec.net. [126.11.124.198])
        by smtp.gmail.com with ESMTPSA id u17sm7212039pgf.8.2019.09.22.00.45.33
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 22 Sep 2019 00:45:34 -0700 (PDT)
Date:   Sun, 22 Sep 2019 16:45:31 +0900
From:   Takeshi Misawa <jeliantsurux@gmail.com>
To:     Guillaume Nault <gnault@redhat.com>,
        Paul Mackerras <paulus@samba.org>
Cc:     netdev@vger.kernel.org
Subject: [PATCH net] ppp: Fix memory leak in ppp_write
Message-ID: <20190922074531.GA1450@DESKTOP>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When ppp is closing, __ppp_xmit_process() failed to enqueue skb
and skb allocated in ppp_write() is leaked.

syzbot reported :
BUG: memory leak
unreferenced object 0xffff88812a17bc00 (size 224):
  comm "syz-executor673", pid 6952, jiffies 4294942888 (age 13.040s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000d110fff9>] kmemleak_alloc_recursive include/linux/kmemleak.h:43 [inline]
    [<00000000d110fff9>] slab_post_alloc_hook mm/slab.h:522 [inline]
    [<00000000d110fff9>] slab_alloc_node mm/slab.c:3262 [inline]
    [<00000000d110fff9>] kmem_cache_alloc_node+0x163/0x2f0 mm/slab.c:3574
    [<000000002d616113>] __alloc_skb+0x6e/0x210 net/core/skbuff.c:197
    [<000000000167fc45>] alloc_skb include/linux/skbuff.h:1055 [inline]
    [<000000000167fc45>] ppp_write+0x48/0x120 drivers/net/ppp/ppp_generic.c:502
    [<000000009ab42c0b>] __vfs_write+0x43/0xa0 fs/read_write.c:494
    [<00000000086b2e22>] vfs_write fs/read_write.c:558 [inline]
    [<00000000086b2e22>] vfs_write+0xee/0x210 fs/read_write.c:542
    [<00000000a2b70ef9>] ksys_write+0x7c/0x130 fs/read_write.c:611
    [<00000000ce5e0fdd>] __do_sys_write fs/read_write.c:623 [inline]
    [<00000000ce5e0fdd>] __se_sys_write fs/read_write.c:620 [inline]
    [<00000000ce5e0fdd>] __x64_sys_write+0x1e/0x30 fs/read_write.c:620
    [<00000000d9d7b370>] do_syscall_64+0x76/0x1a0 arch/x86/entry/common.c:296
    [<0000000006e6d506>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fix this by freeing skb, if ppp is closing.

Fixes: 6d066734e9f0 ("ppp: avoid loop in xmit recursion detection code")
Reported-and-tested-by: syzbot+d9c8bf24e56416d7ce2c@syzkaller.appspotmail.com
Signed-off-by: Takeshi Misawa <jeliantsurux@gmail.com>
---
Dear Guillaume Nault, Paul Mackerras

syzbot reported memory leak in net/ppp.
- memory leak in ppp_write

I send a patch that passed syzbot reproducer test.
Please consider this memory leak and patch.

Regards.
---
 drivers/net/ppp/ppp_generic.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ppp/ppp_generic.c b/drivers/net/ppp/ppp_generic.c
index a30e41a56085..9a1b006904a7 100644
--- a/drivers/net/ppp/ppp_generic.c
+++ b/drivers/net/ppp/ppp_generic.c
@@ -1415,6 +1415,8 @@ static void __ppp_xmit_process(struct ppp *ppp, struct sk_buff *skb)
 			netif_wake_queue(ppp->dev);
 		else
 			netif_stop_queue(ppp->dev);
+	} else {
+		kfree_skb(skb);
 	}
 	ppp_xmit_unlock(ppp);
 }
-- 
2.17.1

