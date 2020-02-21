Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CEEC168143
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 16:16:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729067AbgBUPQ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 10:16:27 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:41025 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727053AbgBUPQ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 10:16:26 -0500
Received: by mail-pf1-f195.google.com with SMTP id j9so1360485pfa.8;
        Fri, 21 Feb 2020 07:16:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tt5oxns5lx1f646f1QThGbvv5Sl7/0SEXMWJEeaTqzA=;
        b=XHqUsWyZpog7dGkF2/1vy0XTPQVmrc3GfB3/7gzT7AU3Ppp54bRgKBWQQpv+YyAVRN
         jDMqH+xq/B+yeFSi3bYiI5FZNGGHqK1r8BV2ERyHgdHhpiDtRrQqVvZwvTfuFtru9nVj
         qI1rsAUke55VKP+GCASFz9QPRyXZi88rhE4eonRwFKX5c+tHUZmF4plFiYnLG1twO6Ey
         5gYd8TzBIrgRhdlORR8VXXZH4ghI84aGmmCZZPfXxqBlDMCWfWUt/ldK26EhaK77/toL
         Act9AWx73QCjqqZswcrdKNb/fKAGr8OhCdHETSjBXF45dUAyf/cMMUEwKFVX00cZR9qN
         JA3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tt5oxns5lx1f646f1QThGbvv5Sl7/0SEXMWJEeaTqzA=;
        b=Q1vJMywX3nYNdkwFrSezoxNoWq5tGP56idpTEQ3sdxwQcO0/00RTue+GSmJDYoD3ve
         QureQxs0c6eYPAcqax2bbNy6O5umMcjvD9bTLyxeG0tZGNk9hNWkB2wh9XoWYk5Q0zCz
         lXlrbNepZqYw3zw//0eMHEMycb0Z1m10DX92lve3sKuyA91hKH9eWiRB7BuEMb0XgDti
         vBi92Mf9/7KYAmfEfALdnmXrWrvK6TuZQdFcc0ng3fMMb/YqLHyHsRCiHdoRsjI0bs6J
         R6HOrq8DkgtXZPzT+/72Md7aEN+U/rbLEkNw5m/HRsBG7mypykM3zNL84+kyNp2c8DIb
         1F1Q==
X-Gm-Message-State: APjAAAW+ZOXxiCrEyuyvcLMlpq0Qoq67QHWWyeOp+1nfYWKpjX8BTI5N
        1c3EqaYaFKc2YCehfHuAUbHwTOcc81I=
X-Google-Smtp-Source: APXvYqwS0Ob3VOCEHDxy3+rkM8vo9z+IVglG6FEY74TcvgDu8IUNl4kEuR2PSPfRYJ/RKzHHRSRkaQ==
X-Received: by 2002:a63:5124:: with SMTP id f36mr1105111pgb.288.1582298186030;
        Fri, 21 Feb 2020 07:16:26 -0800 (PST)
Received: from localhost.localdomain ([103.87.57.170])
        by smtp.googlemail.com with ESMTPSA id q25sm3239490pfg.41.2020.02.21.07.16.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Feb 2020 07:16:25 -0800 (PST)
From:   Amol Grover <frextrite@gmail.com>
To:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Joel Fernandes <joel@joelfernandes.org>,
        Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>, netdev@vger.kernel.org,
        Amol Grover <frextrite@gmail.com>
Subject: [PATCH] tcp, ulp: Pass lockdep expression to RCU lists
Date:   Fri, 21 Feb 2020 20:45:38 +0530
Message-Id: <20200221151537.12334-1-frextrite@gmail.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tcp_ulp_list is traversed using list_for_each_entry_rcu
outside an RCU read-side critical section but under the protection
of tcp_ulp_list_lock.

Hence, add corresponding lockdep expression to silence false-positive
warnings, and harden RCU lists.t

Signed-off-by: Amol Grover <frextrite@gmail.com>
---
 net/ipv4/tcp_ulp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_ulp.c b/net/ipv4/tcp_ulp.c
index 38d3ad141161..b9e55759054e 100644
--- a/net/ipv4/tcp_ulp.c
+++ b/net/ipv4/tcp_ulp.c
@@ -22,7 +22,8 @@ static struct tcp_ulp_ops *tcp_ulp_find(const char *name)
 {
 	struct tcp_ulp_ops *e;
 
-	list_for_each_entry_rcu(e, &tcp_ulp_list, list) {
+	list_for_each_entry_rcu(e, &tcp_ulp_list, list,
+				lockdep_is_held(&tcp_ulp_list_lock)) {
 		if (strcmp(e->name, name) == 0)
 			return e;
 	}
-- 
2.24.1

