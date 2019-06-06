Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D348937F7D
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 23:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728385AbfFFVW6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 17:22:58 -0400
Received: from mail-qk1-f202.google.com ([209.85.222.202]:43929 "EHLO
        mail-qk1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726531AbfFFVW5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 17:22:57 -0400
Received: by mail-qk1-f202.google.com with SMTP id v4so3176756qkj.10
        for <netdev@vger.kernel.org>; Thu, 06 Jun 2019 14:22:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=p0BLfMcr1xZmWjyP9gKz/BHUxmTswBEzaJYzjz87xlY=;
        b=fmsMvV18VbpYzGqgWKkgPnWp30XBPwtO5lngwCKer8W66+SsLpA9VmhCzq9Na/Sj3M
         W6dv718XMhCWNIKoD5AGmYTs5BvA79wyM7NnJf2oLRc46XdH+VJgXWv2VzckIcXc0Es3
         BdRVsd9WMpWgcWr3MBsyznTMk8/znDHaG+sRyyqxU3b4F8R4opUcmikOWQe1yzHBOJvk
         yHvvr6RVNUYzjm7ZtbjBJa2roRES2C/0N56usEST7d2cWhl5hAHe64pPieamQ/t44CPo
         bW5hDD4CS3tM+TsZEEv9jM0QhTx4szx2nYS77ECV3c3+VS9i4l0r8vy7oT2gX/5jETnQ
         I64Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=p0BLfMcr1xZmWjyP9gKz/BHUxmTswBEzaJYzjz87xlY=;
        b=NjUnf4xaIdnUPi7TCd8EcScw06XdqcdS769Np6du3uUYidlIsLPcQAVDwX4BR4dGak
         U/3xNyKd5I7mRBzWmZwMY3OZG9QMVtki6ZrSpLfAc1d4iXi76Q+iFS4NX7YhS7fU+RTr
         F2dsFvMy9hcsB7RPwBcTZUbZpe1ggyV5k+tC68gZ8bHfVAWW0PfAudtwmqH7Kt2Y0ng5
         KZ/rcmAiZBIQPPRuc8K528jOmkyPDIiu7oWKkN9YCy6GuM/BC9nHjVQIgtfGdrITENQY
         ObNSH4xIrUqc+otzppEMCWbQT9a7QjCKXSrHYSRVNtw/5A7qrhBewP1z/Sz1tWZVOs5o
         m9XQ==
X-Gm-Message-State: APjAAAXqYwglkhfEv1LkkJi4Vzq7UVWo05IVymdprvxPWa1Vq0du3cHP
        aoUGSK2U7j0KRI9cu95ESfRH3DLha0i8VA==
X-Google-Smtp-Source: APXvYqypVQ5+5Lf+QuGTIuD2DF2nEMwFhv/5ikp81LzlVM7sWrWCzcYgik3JEq54BUvh6umdxXJ7Sm/ngN9Hvw==
X-Received: by 2002:a0c:9357:: with SMTP id e23mr9988491qve.173.1559856176687;
 Thu, 06 Jun 2019 14:22:56 -0700 (PDT)
Date:   Thu,  6 Jun 2019 14:22:53 -0700
Message-Id: <20190606212253.144131-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.rc1.311.g5d7573a151-goog
Subject: [PATCH net] ipv6: flowlabel: fl6_sock_lookup() must use atomic_inc_not_zero
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RCU 101 : Before taking a refcount, make sure the object is not already
          scheduled for deletion.

Fixes: 18367681a10b ("ipv6 flowlabel: Convert np->ipv6_fl_list to RCU.")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Willem de Bruijn <willemb@google.com>
---
 net/ipv6/ip6_flowlabel.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/ip6_flowlabel.c b/net/ipv6/ip6_flowlabel.c
index be5f3d7ceb966d609121f89a6cc5dcc605834c89..31dec1f00ad267b66449a42ab989236e9f7af5d9 100644
--- a/net/ipv6/ip6_flowlabel.c
+++ b/net/ipv6/ip6_flowlabel.c
@@ -254,9 +254,9 @@ struct ip6_flowlabel *fl6_sock_lookup(struct sock *sk, __be32 label)
 	rcu_read_lock_bh();
 	for_each_sk_fl_rcu(np, sfl) {
 		struct ip6_flowlabel *fl = sfl->fl;
-		if (fl->label == label) {
+
+		if (fl->label == label && atomic_inc_not_zero(&fl->users)) {
 			fl->lastuse = jiffies;
-			atomic_inc(&fl->users);
 			rcu_read_unlock_bh();
 			return fl;
 		}
-- 
2.22.0.rc1.311.g5d7573a151-goog

