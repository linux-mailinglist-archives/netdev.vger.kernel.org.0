Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50789DD6EF
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 08:34:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727787AbfJSGet (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Oct 2019 02:34:49 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:38847 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727590AbfJSGet (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Oct 2019 02:34:49 -0400
Received: by mail-pl1-f194.google.com with SMTP id w8so3912925plq.5
        for <netdev@vger.kernel.org>; Fri, 18 Oct 2019 23:34:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=KykrI1BEUGT2eRmfZuZDpW1vj6XDsSMsLcg0wWy7tj4=;
        b=K5zDyOxySE92cu8VbRSgUzsi/9DLZWAWfk5vm+vdoB0Kr4SH1oUiSXvHsftNJHXwq0
         ToYJLDbmVckzF68Jgk19p4arNtqTQOhST0KU8Jy/xGQiCpe3dFcPrFqbQZgXPznJV5y7
         Fb6VBSDDmqZzovAtnY+E44V8jD4Xjh0GkyDAngyBYHCG6btQxGv5O4MdFRgRujIkNDYB
         bY67yzxH8sr3VTyoh6v/0OXF0whj0tYb/cY98JFo73pwnK71/umMySN6pTzO9X9adQgj
         mkYr/pKFHm3u6H1w5SwhDHURK/YrZanD4O5//41b8JwBQnECCqahkPl9W05e1XTxqyhD
         wZRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=KykrI1BEUGT2eRmfZuZDpW1vj6XDsSMsLcg0wWy7tj4=;
        b=et/50x6DkokCvv+eubMn4iajkbIFKZnWsNCvtBFLQAu8sC5dOI46n2KGyNra8P8GwH
         r2p9ZYDcLQfY9bKVyV4aZ6JUiJgdRblrMiZ51PJKo3sqrPZzN9iVdzFsl/YzjP/d3yyX
         Oym6OczfYF25enD/sYb0RGfYSS0j5CHDGJR5MsFchLAsNXA8H49sgJEz9UrOPae9cn9z
         D0sMAJdSwGDxViMgSr9tpSyqSCAZHy6Z1oW8QFqQ37w0Nxebs9Lomhj9v7Ib3HCdWF6Y
         afkyeVw985uCKHwGyy9gcHR2zv08O1UHDyuGgfR7DmBNdF7SZAHuy8iZCUYp4TSgOTRj
         5yFg==
X-Gm-Message-State: APjAAAW7lWGGh0bh90Ot6hHNd8M/PQYeCQCgZyVlXlnRjkjTeyu8o0f3
        nqJ5HLdF2q2LH8V1Ze1hqw==
X-Google-Smtp-Source: APXvYqx0QCvC59HLCn+lIHa2DtUC9gHKbjtw4fysYFfx3Q4MUh9C/6YLeCLRC5tnEmWqyQA0G2dcZg==
X-Received: by 2002:a17:902:8497:: with SMTP id c23mr14051823plo.84.1571466888437;
        Fri, 18 Oct 2019 23:34:48 -0700 (PDT)
Received: from DESKTOP (softbank126006126096.bbtec.net. [126.6.126.96])
        by smtp.gmail.com with ESMTPSA id r18sm10040245pfc.3.2019.10.18.23.34.45
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 18 Oct 2019 23:34:47 -0700 (PDT)
Date:   Sat, 19 Oct 2019 15:34:43 +0900
From:   Takeshi Misawa <jeliantsurux@gmail.com>
To:     David Howells <dhowells@redhat.com>
Cc:     netdev@vger.kernel.org
Subject: [PATCH net] keys: Fix memory leak in copy_net_ns
Message-ID: <20191019063443.GA1703@DESKTOP>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If copy_net_ns() failed after net_alloc(), net->key_domain is leaked.
Fix this, by freeing key_domain in error path.

syzbot report:
BUG: memory leak
unreferenced object 0xffff8881175007e0 (size 32):
  comm "syz-executor902", pid 7069, jiffies 4294944350 (age 28.400s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000a83ed741>] kmemleak_alloc_recursive include/linux/kmemleak.h:43 [inline]
    [<00000000a83ed741>] slab_post_alloc_hook mm/slab.h:439 [inline]
    [<00000000a83ed741>] slab_alloc mm/slab.c:3326 [inline]
    [<00000000a83ed741>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
    [<0000000059fc92b9>] kmalloc include/linux/slab.h:547 [inline]
    [<0000000059fc92b9>] kzalloc include/linux/slab.h:742 [inline]
    [<0000000059fc92b9>] net_alloc net/core/net_namespace.c:398 [inline]
    [<0000000059fc92b9>] copy_net_ns+0xb2/0x220 net/core/net_namespace.c:445
    [<00000000a9d74bbc>] create_new_namespaces+0x141/0x2a0 kernel/nsproxy.c:103
    [<000000008047d645>] unshare_nsproxy_namespaces+0x7f/0x100 kernel/nsproxy.c:202
    [<000000005993ea6e>] ksys_unshare+0x236/0x490 kernel/fork.c:2674
    [<0000000019417e75>] __do_sys_unshare kernel/fork.c:2742 [inline]
    [<0000000019417e75>] __se_sys_unshare kernel/fork.c:2740 [inline]
    [<0000000019417e75>] __x64_sys_unshare+0x16/0x20 kernel/fork.c:2740
    [<00000000f4c5f2c8>] do_syscall_64+0x76/0x1a0 arch/x86/entry/common.c:296
    [<0000000038550184>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

syzbot also reported other leak in copy_net_ns -> setup_net.
This problem is already fixed by cf47a0b882a4e5f6b34c7949d7b293e9287f1972.

Fixes: 9b242610514f ("keys: Network namespace domain tag")
Reported-and-tested-by: syzbot+3b3296d032353c33184b@syzkaller.appspotmail.com
Signed-off-by: Takeshi Misawa <jeliantsurux@gmail.com>
---
Dear David Howells

syzbot reported memory leak in copy_net_ns.

I send a patch that passed syzbot reproducer test.
Please consider this memory leak and patch.

syzbot link:
https://syzkaller.appspot.com/bug?id=3babacc2ed6bddb8e168d022ef77d32db0e05ea6

Regards.
---
 net/core/net_namespace.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index a0e0d298c991..b88905792795 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -478,6 +478,7 @@ struct net *copy_net_ns(unsigned long flags,
 
 	if (rv < 0) {
 put_userns:
+		key_remove_domain(net->key_domain);
 		put_user_ns(user_ns);
 		net_drop_ns(net);
 dec_ucounts:
-- 
2.17.1

