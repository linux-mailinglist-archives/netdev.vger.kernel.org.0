Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D51E5BAA4E
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 12:32:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230120AbiIPKLD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 06:11:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbiIPKKM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 06:10:12 -0400
Received: from m15111.mail.126.com (m15111.mail.126.com [220.181.15.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 231A0AB4E3
        for <netdev@vger.kernel.org>; Fri, 16 Sep 2022 03:08:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=DENW9
        7tklGusy9XvAg/tL2g1mI7NxJ/NZ/HSLezuSdg=; b=pzkS/EZCqY8QUsR0BLGrt
        Qwu3doNAfB/JalocoSc4iihLadvEQdS33m50IQOnQEGVf4P09dwo2MMOxr9m/HoY
        OomJnM41Jr2kiCSdPDbD/xY9xJcFCon+k5U9B729rWdrS+xrHUr07PVvLrT1dhz5
        jJeVqpMfPvNZkKrnkLTz60=
Received: from localhost.localdomain (unknown [124.16.139.61])
        by smtp1 (Coremail) with SMTP id C8mowACHfIDfSiRjTHnJBg--.15371S2;
        Fri, 16 Sep 2022 18:07:29 +0800 (CST)
From:   Liang He <windhl@126.com>
To:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org
Cc:     windhl@126.com
Subject: [PATCH] ipv4: ping: Fix potential use-after-free bug
Date:   Fri, 16 Sep 2022 18:07:27 +0800
Message-Id: <20220916100727.4096852-1-windhl@126.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: C8mowACHfIDfSiRjTHnJBg--.15371S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrZw4fAF45Cw17Cw15KFyrXrb_yoWfGFc_Z3
        4DuFWvyFs5Cr9xXw47ZF4fJFWFyw15Gr1xWryfCF95t345ZF1DXr1kWr9xCr9xWFsIgrWU
        W3WDt3y8C34aqjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7sRWUDLUUUUUU==
X-Originating-IP: [124.16.139.61]
X-CM-SenderInfo: hzlqvxbo6rjloofrz/1tbiuAV+F2JVlaPa3wACsS
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In ping_unhash(), we should move sock_put(sk) after any possible
access point as the put function may free the object.

Fixes: c319b4d76b9e ("net: ipv4: add IPPROTO_ICMP socket kind")
Signed-off-by: Liang He <windhl@126.com>
---

 I have found other places containing similar code patterns.

 net/ipv4/ping.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index b83c2bd9d722..f90c86d37ffc 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -157,10 +157,10 @@ void ping_unhash(struct sock *sk)
 	spin_lock(&ping_table.lock);
 	if (sk_hashed(sk)) {
 		hlist_nulls_del_init_rcu(&sk->sk_nulls_node);
-		sock_put(sk);
 		isk->inet_num = 0;
 		isk->inet_sport = 0;
 		sock_prot_inuse_add(sock_net(sk), sk->sk_prot, -1);
+		sock_put(sk);
 	}
 	spin_unlock(&ping_table.lock);
 }
-- 
2.25.1

