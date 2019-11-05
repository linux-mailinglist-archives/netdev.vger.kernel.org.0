Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 956C2F091E
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 23:12:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387428AbfKEWMO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 17:12:14 -0500
Received: from mail-pl1-f202.google.com ([209.85.214.202]:37371 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387415AbfKEWMO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 17:12:14 -0500
Received: by mail-pl1-f202.google.com with SMTP id w17so3991711plp.4
        for <netdev@vger.kernel.org>; Tue, 05 Nov 2019 14:12:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=5JLvuQG2HDKse3nDGDT0RL3IC8kYVEcT0YOkbYM48RY=;
        b=ZVyp/FVVkzi0O1dUotTacYPF4siLsT2WGrRB1kkloZ3uLf4q0z8UpJ4XaWx/KA3bW7
         OOdt7JWPLyY7mHo8laqXfWR3yf4upMXZuv2v4xPKC4y+0LCRkfv+6NINjbNS6s7xclTc
         npJZX6zriIBZ86zYmXB4BFOvWsl9uAw6X/suiuJGAdTuVc9ZXy9AROGGAldby5LyeXWE
         iEzTkxPmCm2a7ogAh1G7q4vva52n3UlJvlkFKEgcQriie2riAOUk9eVdW+HXOT3Bu+MO
         93UiPUfwHRDjIzdpu6RBlYhZijVtQoEqmpTSg7Zf1ZeiOIoeq7+NVy3rPJl7014kLzKs
         H0Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=5JLvuQG2HDKse3nDGDT0RL3IC8kYVEcT0YOkbYM48RY=;
        b=qwp3cj9EQK0mzADQ0/+8F4QN8YvP5juu+K8RWVCnynITTRIn6959fkwyUeq6fz7Mvy
         1o9pdKje4MLYe7W4xfSbIxUj5X7dbxPeQuI7oOacPp2eEVncLmmYV+qKwAK2FY+05X1P
         v3O8iXzL2jjWEihZvgz1gQJEc9ODqbWRNqQofYXvJ8NsYp+sxzEPzXlSUkOBdYq7m8C9
         Tycw3b3hD9N0Ego23oiwef3azjvFNK3bnYZ0DRCqys606q/VSJ9kON8uvvLi1pMUForF
         RrFNFGtswfjg2WeqOBnSBR6WSKSgDfYGxhO/x6TTw6qv/KFP/BU1ntAaZP50tna/aHz1
         bsHA==
X-Gm-Message-State: APjAAAWtW3AcQffOGrOMA+qQ7CrgXT2EC4yEIls+D1+S5BvnSDKdB7I2
        x3tKrfy3/NMTLs2b7fi1hwh/0A2tr+Y1jA==
X-Google-Smtp-Source: APXvYqw5IJ81fvwOc/5a2cJuTcok8B3DLWZG7Qt7m2RPRYzssTEMnkacYQ7W0kmK5n3yepcyCZekh7vLxxBbZw==
X-Received: by 2002:a65:614a:: with SMTP id o10mr22023130pgv.219.1572991932999;
 Tue, 05 Nov 2019 14:12:12 -0800 (PST)
Date:   Tue,  5 Nov 2019 14:11:51 -0800
In-Reply-To: <20191105221154.232754-1-edumazet@google.com>
Message-Id: <20191105221154.232754-4-edumazet@google.com>
Mime-Version: 1.0
References: <20191105221154.232754-1-edumazet@google.com>
X-Mailer: git-send-email 2.24.0.rc1.363.gb1bccd3e3d-goog
Subject: [PATCH net-next 3/6] net: avoid potential false sharing in neighbor
 related code
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are common instances of the following construct :

	if (n->confirmed != now)
		n->confirmed = now;

A C compiler could legally remove the conditional.

Use READ_ONCE()/WRITE_ONCE() to avoid this problem.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/arp.h   |  4 ++--
 include/net/ndisc.h |  8 ++++----
 include/net/sock.h  | 12 ++++++------
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/include/net/arp.h b/include/net/arp.h
index c8f580a0e6b1f5c0853cda1605336fa8eb90917c..4950191f6b2bf424519c7ecf3483336739fea143 100644
--- a/include/net/arp.h
+++ b/include/net/arp.h
@@ -57,8 +57,8 @@ static inline void __ipv4_confirm_neigh(struct net_device *dev, u32 key)
 		unsigned long now = jiffies;
 
 		/* avoid dirtying neighbour */
-		if (n->confirmed != now)
-			n->confirmed = now;
+		if (READ_ONCE(n->confirmed) != now)
+			WRITE_ONCE(n->confirmed, now);
 	}
 	rcu_read_unlock_bh();
 }
diff --git a/include/net/ndisc.h b/include/net/ndisc.h
index b2f715ca056726d75033083d1bccee693cea9672..b5ebeb3b0de0e9de3fa495148ab19830d9767e89 100644
--- a/include/net/ndisc.h
+++ b/include/net/ndisc.h
@@ -414,8 +414,8 @@ static inline void __ipv6_confirm_neigh(struct net_device *dev,
 		unsigned long now = jiffies;
 
 		/* avoid dirtying neighbour */
-		if (n->confirmed != now)
-			n->confirmed = now;
+		if (READ_ONCE(n->confirmed) != now)
+			WRITE_ONCE(n->confirmed, now);
 	}
 	rcu_read_unlock_bh();
 }
@@ -431,8 +431,8 @@ static inline void __ipv6_confirm_neigh_stub(struct net_device *dev,
 		unsigned long now = jiffies;
 
 		/* avoid dirtying neighbour */
-		if (n->confirmed != now)
-			n->confirmed = now;
+		if (READ_ONCE(n->confirmed) != now)
+			WRITE_ONCE(n->confirmed, now);
 	}
 	rcu_read_unlock_bh();
 }
diff --git a/include/net/sock.h b/include/net/sock.h
index ac6042d0af328a7f6e18f8882d2ee0679a0e59c5..f2f853439b6576925e39f6db010964762e39ccf2 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1939,8 +1939,8 @@ struct dst_entry *sk_dst_check(struct sock *sk, u32 cookie);
 
 static inline void sk_dst_confirm(struct sock *sk)
 {
-	if (!sk->sk_dst_pending_confirm)
-		sk->sk_dst_pending_confirm = 1;
+	if (!READ_ONCE(sk->sk_dst_pending_confirm))
+		WRITE_ONCE(sk->sk_dst_pending_confirm, 1);
 }
 
 static inline void sock_confirm_neigh(struct sk_buff *skb, struct neighbour *n)
@@ -1950,10 +1950,10 @@ static inline void sock_confirm_neigh(struct sk_buff *skb, struct neighbour *n)
 		unsigned long now = jiffies;
 
 		/* avoid dirtying neighbour */
-		if (n->confirmed != now)
-			n->confirmed = now;
-		if (sk && sk->sk_dst_pending_confirm)
-			sk->sk_dst_pending_confirm = 0;
+		if (READ_ONCE(n->confirmed) != now)
+			WRITE_ONCE(n->confirmed, now);
+		if (sk && READ_ONCE(sk->sk_dst_pending_confirm))
+			WRITE_ONCE(sk->sk_dst_pending_confirm, 0);
 	}
 }
 
-- 
2.24.0.rc1.363.gb1bccd3e3d-goog

