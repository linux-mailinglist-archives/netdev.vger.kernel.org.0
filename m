Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EB861E0691
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 07:53:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388494AbgEYFxs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 01:53:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388203AbgEYFxr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 01:53:47 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A1F6C061A0E
        for <netdev@vger.kernel.org>; Sun, 24 May 2020 22:53:47 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id z64so3894096pfb.1
        for <netdev@vger.kernel.org>; Sun, 24 May 2020 22:53:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=TOP3q9Xu+rDoPF4OE5Ls4ZLZFtW3+K/hUT/lT0LErAo=;
        b=OZeXiNr5uF9wFS19dhMpV3YxSnqLC6BSRSzC+VFWcA9cEUPLAs5OqcnrwBLgaFtwKw
         pphzfVLFICEAZwICMsWyNCCMigNJxoXFlajr2XsbHxctSmEz2MksW9Hi4Vk56pIVLyrM
         xze4haxBeyDhhcuX7duKLD7y4WGHPm/r4vjhOvCF55cz2qm1ByIYsEqiy8YKPgyD/Cf8
         K6zNUuyU4SF/KAVsXCI8ZYhyxJm2AO8CRBWYY0qG7zTwFnrNgGLXod+zh+kMM+XmM9mZ
         NVxp/TBhhn5YJyq+1kECPo++Ju4EKCjLi+tB/OqaTKEFr6VJWe/XPBYPIAI1vZJO4i1p
         RXNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=TOP3q9Xu+rDoPF4OE5Ls4ZLZFtW3+K/hUT/lT0LErAo=;
        b=QQXXkmoMFCOika+GuW2gN4CwnnDDY884aWBj1vwJl60wqpU/6doQERLO7g36FOjqsA
         RiG3FZ+xeBsbF7V2F09bd+hrFL9RoQwxWQ1+HEie0y1U4KvNMBfnb9UBupzxkluarm1A
         fTbXRjy333DE+DhoPDNvzVLDQFmyofs5FPOpdfv95d/+OhATXyCZIN9QqvHKWtb0wNxg
         IcKjm6rBVkhbUDq83Z78Ve1OrwVIbZ5E2tTAPcH2k9wVrMfF99Lvl7wOcRILzlQJXSsM
         V6FdKorM6D6jJMjbiaTQkGxUbHQf+VpvZFsdeDWaHsyjK3lclWxk3rR9i3nZdJr9XNZ4
         WpuA==
X-Gm-Message-State: AOAM5305wD773dKkpGiPZ0kqOKx19ydpaXMnetBC8iQ9dYiA87SBpYT7
        tilxNkuH/3yp+hRnG/WtTxGuas6j
X-Google-Smtp-Source: ABdhPJwkdQbgs4hXa6GxepeBjxctHMoZSl5zvNHo/oxkxU5pKTENtjmqLpYJQwsjsgX0G7JqQsY40A==
X-Received: by 2002:a63:451c:: with SMTP id s28mr25745687pga.340.1590386026606;
        Sun, 24 May 2020 22:53:46 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 5sm10656937pgl.4.2020.05.24.22.53.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 24 May 2020 22:53:46 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sabrina Dubroca <sd@queasysnail.net>, yuehaibing@huawei.com
Subject: [PATCHv2 ipsec] xfrm: fix a warning in xfrm_policy_insert_list
Date:   Mon, 25 May 2020 13:53:37 +0800
Message-Id: <7478dd2a6b6de5027ca96eaa93adae127e6c5894.1590386017.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This waring can be triggered simply by:

  # ip xfrm policy update src 192.168.1.1/24 dst 192.168.1.2/24 dir in \
    priority 1 mark 0 mask 0x10  #[1]
  # ip xfrm policy update src 192.168.1.1/24 dst 192.168.1.2/24 dir in \
    priority 2 mark 0 mask 0x1   #[2]
  # ip xfrm policy update src 192.168.1.1/24 dst 192.168.1.2/24 dir in \
    priority 2 mark 0 mask 0x10  #[3]

Then dmesg shows:

  [ ] WARNING: CPU: 1 PID: 7265 at net/xfrm/xfrm_policy.c:1548
  [ ] RIP: 0010:xfrm_policy_insert_list+0x2f2/0x1030
  [ ] Call Trace:
  [ ]  xfrm_policy_inexact_insert+0x85/0xe50
  [ ]  xfrm_policy_insert+0x4ba/0x680
  [ ]  xfrm_add_policy+0x246/0x4d0
  [ ]  xfrm_user_rcv_msg+0x331/0x5c0
  [ ]  netlink_rcv_skb+0x121/0x350
  [ ]  xfrm_netlink_rcv+0x66/0x80
  [ ]  netlink_unicast+0x439/0x630
  [ ]  netlink_sendmsg+0x714/0xbf0
  [ ]  sock_sendmsg+0xe2/0x110

The issue was introduced by Commit 7cb8a93968e3 ("xfrm: Allow inserting
policies with matching mark and different priorities"). After that, the
policies [1] and [2] would be able to be added with different priorities.

However, policy [3] will actually match both [1] and [2]. Policy [1]
was matched due to the 1st 'return true' in xfrm_policy_mark_match(),
and policy [2] was matched due to the 2nd 'return true' in there. It
caused WARN_ON() in xfrm_policy_insert_list().

This patch is to fix it by only (the same value and priority) as the
same policy in xfrm_policy_mark_match().

Thanks to Yuehaibing, we could make this fix better.

v1->v2:
  - check policy->mark.v == pol->mark.v only without mask.

Fixes: 7cb8a93968e3 ("xfrm: Allow inserting policies with matching mark and different priorities")
Reported-by: Xiumei Mu <xmu@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/xfrm/xfrm_policy.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 297b2fd..564aa649 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -1436,12 +1436,7 @@ static void xfrm_policy_requeue(struct xfrm_policy *old,
 static bool xfrm_policy_mark_match(struct xfrm_policy *policy,
 				   struct xfrm_policy *pol)
 {
-	u32 mark = policy->mark.v & policy->mark.m;
-
-	if (policy->mark.v == pol->mark.v && policy->mark.m == pol->mark.m)
-		return true;
-
-	if ((mark & pol->mark.m) == pol->mark.v &&
+	if (policy->mark.v == pol->mark.v &&
 	    policy->priority == pol->priority)
 		return true;
 
-- 
2.1.0

