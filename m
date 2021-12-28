Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C627F480885
	for <lists+netdev@lfdr.de>; Tue, 28 Dec 2021 11:42:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236242AbhL1KmD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 05:42:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230112AbhL1KmD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Dec 2021 05:42:03 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDDC2C061574
        for <netdev@vger.kernel.org>; Tue, 28 Dec 2021 02:42:02 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id co15so15623040pjb.2
        for <netdev@vger.kernel.org>; Tue, 28 Dec 2021 02:42:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=V2lufGQJcmKY2cAym2JF7ioLQmysawSKTxtO0HzaVFI=;
        b=4VJdUsBEhq7t1WkLu0/FX++pPUrIZ+ihdvsBbFfX+mmt2GHAAxjUBUgZc7g/AbJbrO
         wU4vxR9KaynziVK8dMTNAXhQJCw6Elg3qWdUZ5K/PUJSzUjIvCOvpH3/LnmySt3kkTmh
         NA7s02zDHtbzwn9ByceoHkoZs48u5D420IcJ77O/IfnHryIqQuA8AU4I5Ux0rajkAmO/
         eMHVeKwiUs2eOPAdvZUoXrPbxEDWc1le9KRcJJQKyD589oCCVXnN1BB5ohc1mtZawffC
         24ALejde0dNyj7Ri1eyKqknxFzrHVwKc2aw7ZYT15a0byY01evzW+8dwIiJ+k8uVyO+L
         swdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=V2lufGQJcmKY2cAym2JF7ioLQmysawSKTxtO0HzaVFI=;
        b=7Cf7aBwvjZNMG9/+rda3Ba65JcNaqSdSoQdcOQPwxY+kTZU+PdI9jAu6edal5CsiwY
         QrhLiVlc/W12/ONqwPvZODl0aOColmhhU7gkSacVbBgWadkMwhHM8lky1QhUZGvCF/S/
         og6tfVBueBWD+fjzqKaBxS78UqTd2VDzaJuCShbLs3zkDdcboc37Sj+xN6tt3pU8QCef
         npzwAm3ibLSoNKzJD9JWvP/TZYMAOoFfzEIMdHFIm5YaubUjCTzixSEhzO24D9mTq3/H
         X59fR6+Ydvzc0GyPAly46YVCh/5/Dn3or2laAWV/b7tdFIW9RUMjyTGQD44o0DyoOGcr
         xZdg==
X-Gm-Message-State: AOAM532eccdyYYmRfgNsbdR6SVa9Nq8ZHSx43BZWgj+m1XdQqNhSQwRl
        dEWZc0keYEgt2lIESuF5t+m7WQ==
X-Google-Smtp-Source: ABdhPJyZpAuRWD66Y8AJSmTUZaoWU1FmBaH3I+KVTM+T0G2Gl26osron+9O84L86g+zngcUGbKodXQ==
X-Received: by 2002:a17:90a:c788:: with SMTP id gn8mr25637549pjb.212.1640688122515;
        Tue, 28 Dec 2021 02:42:02 -0800 (PST)
Received: from C02FF4E5ML7H.bytedance.net ([153.254.110.101])
        by smtp.gmail.com with ESMTPSA id g16sm17521397pfv.159.2021.12.28.02.41.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Dec 2021 02:42:02 -0800 (PST)
From:   Muchun Song <songmuchun@bytedance.com>
To:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, xemul@openvz.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Muchun Song <songmuchun@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Fam Zheng <fam.zheng@bytedance.com>, stable@vger.kernel.org
Subject: [PATCH] net: fix use-after-free in tw_timer_handler
Date:   Tue, 28 Dec 2021 18:41:45 +0800
Message-Id: <20211228104145.9426-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A real world panic issue was found as follow in Linux 5.4.

    BUG: unable to handle page fault for address: ffffde49a863de28
    PGD 7e6fe62067 P4D 7e6fe62067 PUD 7e6fe63067 PMD f51e064067 PTE 0
    RIP: 0010:tw_timer_handler+0x20/0x40
    Call Trace:
     <IRQ>
     call_timer_fn+0x2b/0x120
     run_timer_softirq+0x1ef/0x450
     __do_softirq+0x10d/0x2b8
     irq_exit+0xc7/0xd0
     smp_apic_timer_interrupt+0x68/0x120
     apic_timer_interrupt+0xf/0x20

This issue was also reported since 2017 in the thread [1],
unfortunately, the issue was still can be reproduced after fixing
DCCP.

The ipv4_mib_exit_net is called before tcp_sk_exit_batch when a net
namespace is destroyed since tcp_sk_ops is registered befrore
ipv4_mib_ops, which means tcp_sk_ops is in the front of ipv4_mib_ops
in the list of pernet_list. There will be a use-after-free on
net->mib.net_statistics in tw_timer_handler after ipv4_mib_exit_net
if there are some inflight time-wait timers.

This bug is not introduced by commit f2bf415cfed7 ("mib: add net to
NET_ADD_STATS_BH") since the net_statistics is a global variable
instead of dynamic allocation and freeing. Actually, commit
61a7e26028b9 ("mib: put net statistics on struct net") introduces
the bug since it put net statistics on struct net and free it when
net namespace is destroyed.

Moving init_ipv4_mibs() to the front of tcp_init() to fix this bug
and replace pr_crit() with panic() since continuing is meaningless
when init_ipv4_mibs() fails.

[1] https://groups.google.com/g/syzkaller/c/p1tn-_Kc6l4/m/smuL_FMAAgAJ?pli=1

Fixes: 61a7e26028b9 ("mib: put net statistics on struct net")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Cc: Xiongchun Duan <songmuchun@bytedance.com>
Cc: Cong Wang <cong.wang@bytedance.com>
Cc: Fam Zheng <fam.zheng@bytedance.com>
Cc: <stable@vger.kernel.org>
---
 net/ipv4/af_inet.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 04067b249bf3..cb8ba7a0a114 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1985,6 +1985,10 @@ static int __init inet_init(void)
 
 	ip_init();
 
+	/* Initialise per-cpu ipv4 mibs */
+	if (init_ipv4_mibs())
+		panic("%s: Cannot init ipv4 mibs\n", __func__);
+
 	/* Setup TCP slab cache for open requests. */
 	tcp_init();
 
@@ -2015,12 +2019,6 @@ static int __init inet_init(void)
 
 	if (init_inet_pernet_ops())
 		pr_crit("%s: Cannot init ipv4 inet pernet ops\n", __func__);
-	/*
-	 *	Initialise per-cpu ipv4 mibs
-	 */
-
-	if (init_ipv4_mibs())
-		pr_crit("%s: Cannot init ipv4 mibs\n", __func__);
 
 	ipv4_proc_init();
 
-- 
2.11.0

