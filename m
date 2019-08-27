Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A9E19DE6A
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 09:08:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728673AbfH0HIS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 03:08:18 -0400
Received: from mail-pf1-f201.google.com ([209.85.210.201]:50679 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725890AbfH0HIR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 03:08:17 -0400
Received: by mail-pf1-f201.google.com with SMTP id b21so14026482pfb.17
        for <netdev@vger.kernel.org>; Tue, 27 Aug 2019 00:08:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=ZDL6qMUlP3bP/+guwloCvQFaqxEcnmptAKY8PZbvYMg=;
        b=s8jbhp9GQmrF911vHYozD95BwG/hVa3UG/OWTTQyS2+y61vXp4481Y8siAqvTkanFg
         ced1W1zXgByzf/xBe2jy2AOMM6R+ITdLr/eeqTFtTbqIE13tkSsYzfn5zt9TTPqn2sHC
         +6yRkf0SQZuEG4UeYF0fEcri3oA8vV9S2azA019GAK/cqm7FHCCFN4tphyby6cORKG8p
         3m0aax3sdwucJtMsNLS1siYa4J8v5/MH3Bsb5Z2FuFUmer8Ee9CnxGtPZrgSdu/b7lGo
         CIvq/7Aj4H+Vd6eRnvkM5EqDY2c/hoFbD6brDnI/Cx4lDpGoXDCxZWIs1LALfXAFZ5fn
         0Axg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=ZDL6qMUlP3bP/+guwloCvQFaqxEcnmptAKY8PZbvYMg=;
        b=HVymWsaykpTKIbhDcBFaoINuP/FL5X+0UEeMIPG8v2BQ21bLWkj9iNjs/1Pl3r/7QS
         tDpqDtfuqAkFLnmesEmtLv29raL8fp3pbDYcNne9FXg1wXoRLz8jXdSSUKQV2ls6Xxye
         aJ4two7dU9nL/dORBnYFx2isZaO/RrRghdjLhDJyFJhPFlWyKbE4q7eFISqswaI+T6UO
         m37kNPvt6MojMHwbgABk4BROJO5C1xJzCoe7VNjtnB6LIyN52N8v6Ux5t9zvYdHlUU6P
         BZsrROZP/nFwhb2W8GWK14go2ZKvGW2bL97F4lHn+Kil6tsHU+t3rZKQIQdJ3MvCrn4H
         12hA==
X-Gm-Message-State: APjAAAVK50Fbq98Kc3+6FRYsMxfx5/JtlywAeKHKE/qpLLIMfr7gzJDu
        pBcFERsrpQdqYwCHw/9G6xh7lxr9Yleutw==
X-Google-Smtp-Source: APXvYqyZAr8DxUOVoUHFk4OFePQyp3LseBFVnkakrmkOgT0PYY3Hoko0OkBnnnKLl8xpBApb12/uh70xhjYSMw==
X-Received: by 2002:a63:755e:: with SMTP id f30mr20102809pgn.246.1566889696157;
 Tue, 27 Aug 2019 00:08:16 -0700 (PDT)
Date:   Tue, 27 Aug 2019 00:08:12 -0700
Message-Id: <20190827070812.150106-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.187.g17f5b7556c-goog
Subject: [PATCH net-next] ipv6: shrink struct ipv6_mc_socklist
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

Remove two holes on 64bit arches, to bring the size
to one cache line exactly.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/if_inet6.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/if_inet6.h b/include/net/if_inet6.h
index 50037913c9b191cb3793e3f072104c10c4257ff2..a01981d7108f96075b6939f4a78f14e7afe93a4e 100644
--- a/include/net/if_inet6.h
+++ b/include/net/if_inet6.h
@@ -89,9 +89,9 @@ struct ip6_sf_socklist {
 struct ipv6_mc_socklist {
 	struct in6_addr		addr;
 	int			ifindex;
+	unsigned int		sfmode;		/* MCAST_{INCLUDE,EXCLUDE} */
 	struct ipv6_mc_socklist __rcu *next;
 	rwlock_t		sflock;
-	unsigned int		sfmode;		/* MCAST_{INCLUDE,EXCLUDE} */
 	struct ip6_sf_socklist	*sflist;
 	struct rcu_head		rcu;
 };
-- 
2.23.0.187.g17f5b7556c-goog

