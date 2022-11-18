Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5C5B62F427
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 13:01:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241454AbiKRMBi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 07:01:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235256AbiKRMBg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 07:01:36 -0500
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D9B294A5A
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 04:01:35 -0800 (PST)
Received: by mail-io1-f69.google.com with SMTP id bf14-20020a056602368e00b006ce86e80414so2475507iob.7
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 04:01:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=io3/kjZxYz+EP12Gdr6kUmvSfwYCU8Dd09Zf0yeW8XY=;
        b=Ra43UEJ9t808oJ+JCo3kSdARosAucWAgcf/K6RTPbnSpbnzizashiOtKg+Lh5Bxr30
         mVvgj38y+zECf/uOT0mX8a0NZKsgX/uyxuZDSh6wNOXW7Mwi7uHJd5/8ZCiOTGh3AhFE
         BNhxByIzAR+qB+szRT7uiaxK8bSPZLSuyTe3bk/V1bUgBQ8M6w+IVctmXGN8I1yUsnea
         9hSDu4lP+vDBHYIzrAN3g7MppLS4IspTG9fMK9wxeYk4D5rBqXHWaOrWCS6H+j4ja5v/
         ttqZRw7XpFfy0RbB+NL1mQG95FNZvDi+Gkdfm/0xXaIN746uAfAjC+ARqUBaXRVAENY8
         fU6A==
X-Gm-Message-State: ANoB5pnOyLIC4xqwkMFSUivh1Jr/2pDfIogw8fr26wQxusVp7WSc8ubv
        EfPNdD+1u/TwUrFXFd8cMTpEaCkhxtlsFP78PUvYfnC9Y8Lu
X-Google-Smtp-Source: AA0mqf6MG6V6KHPdVZDEwYenAr6v+B4rh+K1Qwq64Fti4lZsYVQJRVRrY75GzREfEIri1kUHddMysl8QCv7snICt6lDKu6ZlKQgo
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:218b:b0:2ff:1ff9:1d81 with SMTP id
 j11-20020a056e02218b00b002ff1ff91d81mr3323210ila.33.1668772894643; Fri, 18
 Nov 2022 04:01:34 -0800 (PST)
Date:   Fri, 18 Nov 2022 04:01:34 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000098a3e005edbd7776@google.com>
Subject: [syzbot] KMSAN: uninit-value in __hw_addr_add_ex
From:   syzbot <syzbot+cec7816c907e0923fdcc@syzkaller.appspotmail.com>
To:     davem@davemloft.net, glider@google.com, gnaaman@drivenets.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org, luwei32@huawei.com,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        wangxiongfeng2@huawei.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    81c325bbf94e kmsan: hooks: do not check memory in kmsan_in..
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=153cd3c7b00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2d8b9a11641dc9aa
dashboard link: https://syzkaller.appspot.com/bug?extid=cec7816c907e0923fdcc
compiler:       clang version 14.0.0 (/usr/local/google/src/llvm-git-monorepo 2b554920f11c8b763cd9ed9003f4e19b919b8e1f), GNU ld (GNU Binutils for Debian) 2.35.2
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+cec7816c907e0923fdcc@syzkaller.appspotmail.com

IPv6: ADDRCONF(NETDEV_CHANGE): hsr_slave_0: link becomes ready
=====================================================
BUG: KMSAN: uninit-value in memcmp+0x23e/0x290 lib/string.c:789
 memcmp+0x23e/0x290 lib/string.c:789
 __hw_addr_add_ex+0x2f9/0x1020 net/core/dev_addr_lists.c:62
 __hw_addr_sync_one net/core/dev_addr_lists.c:210 [inline]
 __hw_addr_sync_multiple+0x35f/0xa40 net/core/dev_addr_lists.c:250
 dev_mc_sync_multiple+0x195/0x2b0 net/core/dev_addr_lists.c:959
 team_set_rx_mode+0x143/0x230 drivers/net/team/team.c:1780
 __dev_set_rx_mode+0x3b0/0x440 net/core/dev.c:8717
 __dev_mc_add net/core/dev_addr_lists.c:836 [inline]
 dev_mc_add+0x180/0x1d0 net/core/dev_addr_lists.c:850
 igmp6_group_added+0x320/0x830 net/ipv6/mcast.c:680
 __ipv6_dev_mc_inc+0x11e9/0x1620 net/ipv6/mcast.c:949
 ipv6_dev_mc_inc+0x70/0x80 net/ipv6/mcast.c:957
 addrconf_join_solict net/ipv6/addrconf.c:2179 [inline]
 addrconf_dad_begin net/ipv6/addrconf.c:3958 [inline]
 addrconf_dad_work+0x736/0x2210 net/ipv6/addrconf.c:4085
 process_one_work+0xdb9/0x1820 kernel/workqueue.c:2298
 worker_thread+0x10bc/0x21f0 kernel/workqueue.c:2445
 kthread+0x721/0x850 kernel/kthread.c:327
 ret_from_fork+0x1f/0x30

Uninit was stored to memory at:
 __hw_addr_create net/core/dev_addr_lists.c:32 [inline]
 __hw_addr_add_ex+0x718/0x1020 net/core/dev_addr_lists.c:93
 __dev_mc_add net/core/dev_addr_lists.c:832 [inline]
 dev_mc_add+0x10a/0x1d0 net/core/dev_addr_lists.c:850
 igmp6_group_added+0x320/0x830 net/ipv6/mcast.c:680
 __ipv6_dev_mc_inc+0x11e9/0x1620 net/ipv6/mcast.c:949
 ipv6_dev_mc_inc+0x70/0x80 net/ipv6/mcast.c:957
 addrconf_join_solict net/ipv6/addrconf.c:2179 [inline]
 addrconf_dad_begin net/ipv6/addrconf.c:3958 [inline]
 addrconf_dad_work+0x736/0x2210 net/ipv6/addrconf.c:4085
 process_one_work+0xdb9/0x1820 kernel/workqueue.c:2298
 worker_thread+0x10bc/0x21f0 kernel/workqueue.c:2445
 kthread+0x721/0x850 kernel/kthread.c:327
 ret_from_fork+0x1f/0x30

Local variable buf created at:
 igmp6_group_added+0x9b/0x830 net/ipv6/mcast.c:671
 __ipv6_dev_mc_inc+0x11e9/0x1620 net/ipv6/mcast.c:949

CPU: 1 PID: 25 Comm: kworker/1:1 Not tainted 5.16.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: ipv6_addrconf addrconf_dad_work
=====================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
