Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC25627308
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 01:51:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727638AbfEVXv1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 19:51:27 -0400
Received: from mail-yw1-f73.google.com ([209.85.161.73]:49349 "EHLO
        mail-yw1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726218AbfEVXv1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 19:51:27 -0400
Received: by mail-yw1-f73.google.com with SMTP id y144so3649279ywg.16
        for <netdev@vger.kernel.org>; Wed, 22 May 2019 16:51:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=nunouXmKj0DdIZpZYd8RzGgryEmtq7BgUyBNM1WhGbA=;
        b=WrnDlat8hpR+XHI78lnfla7QdtcnwWhbL4EShMaDAP/LVp3yabgxl2JOO92p6tJYFY
         sSXmi2/D6acPNnRqH5AGZ5JMe2NZ0infwGVRutBRuUBDB0ZXL+0E6xGwNBrwSQ/zd0K5
         gBGk25ZvX18Vgmf3aik9sih2akN9+qgO8R+WkvqYe6QFIiOWJCpMqdTN/YW+5OVNJK+O
         7ZPTkNMw0blwryXGC2zsJUG3EiZ88ngU1C0SqMC5tG680aejSA/lPslq1fHUJHo8fr91
         6v/pVqZYq0Ru5ClxDqIItfelq3RU/WtAbr5PTj2BQvA9w70cWhg1KL4B06fpXrXkfhYI
         CiIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=nunouXmKj0DdIZpZYd8RzGgryEmtq7BgUyBNM1WhGbA=;
        b=UBmrlEbO0AmoB8lCobu62fus4diPKUTneeGtXKEKu3eKFs7zgQNFwGJioO90P5JfKl
         Cnceok2qcNcsvbJO/PyHaMmCD+lQQnwsiH70hy7kz/IvlmT9hDVp8IV8JlwrSg5bqaqH
         JDn4s9/JDF3uxmG6ncOFtlb2qP6yJx8349qa+lzULwIhuu3ZhCcWm7JHXl/1/NfoJK9Z
         AxbCMG9nFsNUH1zNbkyAYo5ieOJ+170wjNh0nYdJhKsFqCwErAVqbCId6v//rGUjXwRp
         1NwIz5EzEKtNAbm7t02VTWvpM8Skcfc0LIoOwVkcg7Gk9XtdDNm4oIr2cFXer589Hh1V
         dkiQ==
X-Gm-Message-State: APjAAAV0JrIEewKNBv4UL7XBFXuXwGoW45WK5bgLG9PJFcdoPDqxMaBV
        ++XzXZAoqxwCol5Ef0uSiDoqelAwo7TN2Q==
X-Google-Smtp-Source: APXvYqzsIjJpouK+8692xCjStAFDEAYKalWi0azwBSosQ7A71hfvG89HMm2lJJ8PaaEnIFOMNM3MiOA+Z7y5iQ==
X-Received: by 2002:a81:3483:: with SMTP id b125mr41355139ywa.425.1558569086343;
 Wed, 22 May 2019 16:51:26 -0700 (PDT)
Date:   Wed, 22 May 2019 16:51:22 -0700
Message-Id: <20190522235122.254262-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.21.0.1020.gf2820cf01a-goog
Subject: [PATCH net] ipv4/igmp: fix another memory leak in igmpv3_del_delrec()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot reported memory leaks [1] that I have back tracked to
a missing cleanup from igmpv3_del_delrec() when
(im->sfmode != MCAST_INCLUDE)

Add ip_sf_list_clear_all() and kfree_pmc() helpers to explicitely
handle the cleanups before freeing.

[1]

BUG: memory leak
unreferenced object 0xffff888123e32b00 (size 64):
  comm "softirq", pid 0, jiffies 4294942968 (age 8.010s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 e0 00 00 01 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<000000006105011b>] kmemleak_alloc_recursive include/linux/kmemleak.h:55 [inline]
    [<000000006105011b>] slab_post_alloc_hook mm/slab.h:439 [inline]
    [<000000006105011b>] slab_alloc mm/slab.c:3326 [inline]
    [<000000006105011b>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
    [<000000004bba8073>] kmalloc include/linux/slab.h:547 [inline]
    [<000000004bba8073>] kzalloc include/linux/slab.h:742 [inline]
    [<000000004bba8073>] ip_mc_add1_src net/ipv4/igmp.c:1961 [inline]
    [<000000004bba8073>] ip_mc_add_src+0x36b/0x400 net/ipv4/igmp.c:2085
    [<00000000a46a65a0>] ip_mc_msfilter+0x22d/0x310 net/ipv4/igmp.c:2475
    [<000000005956ca89>] do_ip_setsockopt.isra.0+0x1795/0x1930 net/ipv4/ip_sockglue.c:957
    [<00000000848e2d2f>] ip_setsockopt+0x3b/0xb0 net/ipv4/ip_sockglue.c:1246
    [<00000000b9db185c>] udp_setsockopt+0x4e/0x90 net/ipv4/udp.c:2616
    [<000000003028e438>] sock_common_setsockopt+0x38/0x50 net/core/sock.c:3130
    [<0000000015b65589>] __sys_setsockopt+0x98/0x120 net/socket.c:2078
    [<00000000ac198ef0>] __do_sys_setsockopt net/socket.c:2089 [inline]
    [<00000000ac198ef0>] __se_sys_setsockopt net/socket.c:2086 [inline]
    [<00000000ac198ef0>] __x64_sys_setsockopt+0x26/0x30 net/socket.c:2086
    [<000000000a770437>] do_syscall_64+0x76/0x1a0 arch/x86/entry/common.c:301
    [<00000000d3adb93b>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fixes: 9c8bb163ae78 ("igmp, mld: Fix memory leak in igmpv3/mld_del_delrec()")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Hangbin Liu <liuhangbin@gmail.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/ipv4/igmp.c | 47 ++++++++++++++++++++++++++++++-----------------
 1 file changed, 30 insertions(+), 17 deletions(-)

diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
index 6c2febc39dca0e85cfbde4329e903177ed933ae4..1a8d36dd49d40a0bd352e78e87b87735f894e2cf 100644
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -633,6 +633,24 @@ static void igmpv3_clear_zeros(struct ip_sf_list **ppsf)
 	}
 }
 
+static void ip_sf_list_clear_all(struct ip_sf_list *psf)
+{
+	struct ip_sf_list *next;
+
+	while (psf) {
+		next = psf->sf_next;
+		kfree(psf);
+		psf = next;
+	}
+}
+
+static void kfree_pmc(struct ip_mc_list *pmc)
+{
+	ip_sf_list_clear_all(pmc->sources);
+	ip_sf_list_clear_all(pmc->tomb);
+	kfree(pmc);
+}
+
 static void igmpv3_send_cr(struct in_device *in_dev)
 {
 	struct ip_mc_list *pmc, *pmc_prev, *pmc_next;
@@ -669,7 +687,7 @@ static void igmpv3_send_cr(struct in_device *in_dev)
 			else
 				in_dev->mc_tomb = pmc_next;
 			in_dev_put(pmc->interface);
-			kfree(pmc);
+			kfree_pmc(pmc);
 		} else
 			pmc_prev = pmc;
 	}
@@ -1215,14 +1233,18 @@ static void igmpv3_del_delrec(struct in_device *in_dev, struct ip_mc_list *im)
 		im->interface = pmc->interface;
 		if (im->sfmode == MCAST_INCLUDE) {
 			im->tomb = pmc->tomb;
+			pmc->tomb = NULL;
+
 			im->sources = pmc->sources;
+			pmc->sources = NULL;
+
 			for (psf = im->sources; psf; psf = psf->sf_next)
 				psf->sf_crcount = in_dev->mr_qrv ?: net->ipv4.sysctl_igmp_qrv;
 		} else {
 			im->crcount = in_dev->mr_qrv ?: net->ipv4.sysctl_igmp_qrv;
 		}
 		in_dev_put(pmc->interface);
-		kfree(pmc);
+		kfree_pmc(pmc);
 	}
 	spin_unlock_bh(&im->lock);
 }
@@ -1243,21 +1265,18 @@ static void igmpv3_clear_delrec(struct in_device *in_dev)
 		nextpmc = pmc->next;
 		ip_mc_clear_src(pmc);
 		in_dev_put(pmc->interface);
-		kfree(pmc);
+		kfree_pmc(pmc);
 	}
 	/* clear dead sources, too */
 	rcu_read_lock();
 	for_each_pmc_rcu(in_dev, pmc) {
-		struct ip_sf_list *psf, *psf_next;
+		struct ip_sf_list *psf;
 
 		spin_lock_bh(&pmc->lock);
 		psf = pmc->tomb;
 		pmc->tomb = NULL;
 		spin_unlock_bh(&pmc->lock);
-		for (; psf; psf = psf_next) {
-			psf_next = psf->sf_next;
-			kfree(psf);
-		}
+		ip_sf_list_clear_all(psf);
 	}
 	rcu_read_unlock();
 }
@@ -2123,7 +2142,7 @@ static int ip_mc_add_src(struct in_device *in_dev, __be32 *pmca, int sfmode,
 
 static void ip_mc_clear_src(struct ip_mc_list *pmc)
 {
-	struct ip_sf_list *psf, *nextpsf, *tomb, *sources;
+	struct ip_sf_list *tomb, *sources;
 
 	spin_lock_bh(&pmc->lock);
 	tomb = pmc->tomb;
@@ -2135,14 +2154,8 @@ static void ip_mc_clear_src(struct ip_mc_list *pmc)
 	pmc->sfcount[MCAST_EXCLUDE] = 1;
 	spin_unlock_bh(&pmc->lock);
 
-	for (psf = tomb; psf; psf = nextpsf) {
-		nextpsf = psf->sf_next;
-		kfree(psf);
-	}
-	for (psf = sources; psf; psf = nextpsf) {
-		nextpsf = psf->sf_next;
-		kfree(psf);
-	}
+	ip_sf_list_clear_all(tomb);
+	ip_sf_list_clear_all(sources);
 }
 
 /* Join a multicast group
-- 
2.21.0.1020.gf2820cf01a-goog

