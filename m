Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49C0057E33
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 10:27:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726497AbfF0I1H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 04:27:07 -0400
Received: from mail-pg1-f202.google.com ([209.85.215.202]:49631 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726059AbfF0I1G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 04:27:06 -0400
Received: by mail-pg1-f202.google.com with SMTP id 30so918090pgk.16
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 01:27:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=n/QYVc2Jf5oL1SZFfr+k9LcV++mYyaPMD6SsIhLP7DM=;
        b=PZsX64X7xC5qUXd7r5OqyZqoruLlCH2cuK1rZm4wgU9IZocVh+2djr9l4QA1RAUUpP
         ncfJhlg1hwmic/y3vjz/kuYbUnWlCWUh8Dt+DmL8/x4oDb5g0ELEJNqDjhHMM56XJvnG
         lLTQZ2aZAkyV8JuiiCihCx5bV2LOHxC6VCQjIvtcxlfi1a0WVzMIXxG+9miLNsGmJRcv
         FmvO653yeCChDbMwkz7HyOxanG3J4r6tyoK4KRPUSzMO/mny9DpsuiP8cWcJNXa1THyq
         ZXSJInajjoo8v3Fp9U2az6um1qWtJ/DMwypCokcvnsguNU+dOl2FUqw9QIIVRPP0Y5OM
         P6iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=n/QYVc2Jf5oL1SZFfr+k9LcV++mYyaPMD6SsIhLP7DM=;
        b=JbfQ0EfRJBwwRnWiMdcfx+fH5W6D2PAAsvk43h4PnlqqLwxs31vvjjm663BM+xt66I
         9+7R3bKlwkcJEydMNPg6G53fiJeWRX0TmhHK3eMqNasFpuYo+sWMUNTwib8kmvSMhw2/
         tp92RtR3yiyM5V46YBBmJe1+ryp6nZilvT1oWQ4hA1u401Z8dMCLgGvCaizi+VAe60gU
         KXGmKvEzTBChxX2Yhf6RbBaus4EE9O8e3Unz6D7lWnT+mhlv6xM7RYkY/k2Qjrza+/O0
         egnlsPmMtqlnhFdcNjkJbsLaIdR7FgwA3utXdoO1GGemvvsOHO0yucT0FfYeiD+X2Rer
         B4CA==
X-Gm-Message-State: APjAAAWJOiu5H2RM9/qoaGpUCeTcE8fhAONovnakS/bbRjel36njsY8r
        v8AafYfmpS9VvzLfGIddqb8B4oPvdUw9CA==
X-Google-Smtp-Source: APXvYqwUXI7fz1N783Xm9AWNKLGOf/De+K6N/QysYHF3WDA2P2GW1k8/q6COW+ulMvGXfUoZOVfl17HCF2VAhQ==
X-Received: by 2002:a63:f807:: with SMTP id n7mr2670178pgh.119.1561624024694;
 Thu, 27 Jun 2019 01:27:04 -0700 (PDT)
Date:   Thu, 27 Jun 2019 01:27:01 -0700
Message-Id: <20190627082701.226711-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH net] igmp: fix memory leak in igmpv3_del_delrec()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        syzbot+6ca1abd0db68b5173a4f@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

im->tomb and/or im->sources might not be NULL, but we
currently overwrite their values blindly.

Using swap() will make sure the following call to kfree_pmc(pmc)
will properly free the psf structures.

Tested with the C repro provided by syzbot, which basically does :

 socket(PF_INET, SOCK_DGRAM, IPPROTO_IP) = 3
 setsockopt(3, SOL_IP, IP_ADD_MEMBERSHIP, "\340\0\0\2\177\0\0\1\0\0\0\0", 12) = 0
 ioctl(3, SIOCSIFFLAGS, {ifr_name="lo", ifr_flags=0}) = 0
 setsockopt(3, SOL_IP, IP_MSFILTER, "\340\0\0\2\177\0\0\1\1\0\0\0\1\0\0\0\377\377\377\377", 20) = 0
 ioctl(3, SIOCSIFFLAGS, {ifr_name="lo", ifr_flags=IFF_UP}) = 0
 exit_group(0)                    = ?

BUG: memory leak
unreferenced object 0xffff88811450f140 (size 64):
  comm "softirq", pid 0, jiffies 4294942448 (age 32.070s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 ff ff ff ff 00 00 00 00  ................
    00 00 00 00 00 00 00 00 01 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000c7bad083>] kmemleak_alloc_recursive include/linux/kmemleak.h:43 [inline]
    [<00000000c7bad083>] slab_post_alloc_hook mm/slab.h:439 [inline]
    [<00000000c7bad083>] slab_alloc mm/slab.c:3326 [inline]
    [<00000000c7bad083>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
    [<000000009acc4151>] kmalloc include/linux/slab.h:547 [inline]
    [<000000009acc4151>] kzalloc include/linux/slab.h:742 [inline]
    [<000000009acc4151>] ip_mc_add1_src net/ipv4/igmp.c:1976 [inline]
    [<000000009acc4151>] ip_mc_add_src+0x36b/0x400 net/ipv4/igmp.c:2100
    [<000000004ac14566>] ip_mc_msfilter+0x22d/0x310 net/ipv4/igmp.c:2484
    [<0000000052d8f995>] do_ip_setsockopt.isra.0+0x1795/0x1930 net/ipv4/ip_sockglue.c:959
    [<000000004ee1e21f>] ip_setsockopt+0x3b/0xb0 net/ipv4/ip_sockglue.c:1248
    [<0000000066cdfe74>] udp_setsockopt+0x4e/0x90 net/ipv4/udp.c:2618
    [<000000009383a786>] sock_common_setsockopt+0x38/0x50 net/core/sock.c:3126
    [<00000000d8ac0c94>] __sys_setsockopt+0x98/0x120 net/socket.c:2072
    [<000000001b1e9666>] __do_sys_setsockopt net/socket.c:2083 [inline]
    [<000000001b1e9666>] __se_sys_setsockopt net/socket.c:2080 [inline]
    [<000000001b1e9666>] __x64_sys_setsockopt+0x26/0x30 net/socket.c:2080
    [<00000000420d395e>] do_syscall_64+0x76/0x1a0 arch/x86/entry/common.c:301
    [<000000007fd83a4b>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fixes: 24803f38a5c0 ("igmp: do not remove igmp souce list info when set link down")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Hangbin Liu <liuhangbin@gmail.com>
Reported-by: syzbot+6ca1abd0db68b5173a4f@syzkaller.appspotmail.com
---
 net/ipv4/igmp.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
index a57f0d69eadb9bdcc4b2c4a82819d2dce44bf428..85107bf812f228ae34e767b2e440aec4776fbe6c 100644
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -1228,12 +1228,8 @@ static void igmpv3_del_delrec(struct in_device *in_dev, struct ip_mc_list *im)
 	if (pmc) {
 		im->interface = pmc->interface;
 		if (im->sfmode == MCAST_INCLUDE) {
-			im->tomb = pmc->tomb;
-			pmc->tomb = NULL;
-
-			im->sources = pmc->sources;
-			pmc->sources = NULL;
-
+			swap(im->tomb, pmc->tomb);
+			swap(im->sources, pmc->sources);
 			for (psf = im->sources; psf; psf = psf->sf_next)
 				psf->sf_crcount = in_dev->mr_qrv ?: net->ipv4.sysctl_igmp_qrv;
 		} else {
-- 
2.22.0.410.gd8fdbe21b5-goog

