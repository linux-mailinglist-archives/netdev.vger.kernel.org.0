Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A0F91698CE
	for <lists+netdev@lfdr.de>; Sun, 23 Feb 2020 18:20:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbgBWRUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Feb 2020 12:20:21 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:33141 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726208AbgBWRUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Feb 2020 12:20:21 -0500
Received: by mail-pl1-f195.google.com with SMTP id ay11so3026476plb.0;
        Sun, 23 Feb 2020 09:20:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MUfs7lyaep1+x1XygloZl4yBc6FlYxcZEd+NqGjQwiM=;
        b=K2tC5sIvThPq+B1y9vvTpJ7jDeA5hkzOt3jM1gpmMFemAmqb2DZ13w/miPvObBb9s4
         f+fYuH1up+UuDtdTWIoQB7wbpkfOO1WWyFo3mXzs2vDP5+RFnt9U45shdE3HEou5MZ78
         HUtsEwyuz3mGc6vzuZ3tqIkOkHcgAZEoOSeqxIubgspZcBWnZMYZw9w0o6i90ps7ZmOQ
         XMXuMUCOsMAoret4ITR+0aS2xSQK3F4dv7+Ha9M0X3OtCr5WrjEJV26jpgA5shrfM8Fv
         KFxh8UcR8tuZdt8jlArw+CieGDz3+ZrX2pYpDptX6J4gIx8IeSF7/3xZssGRaf7pMaGn
         r4KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MUfs7lyaep1+x1XygloZl4yBc6FlYxcZEd+NqGjQwiM=;
        b=F+6t81up++JtQ3tYBQLqUgODVID4YxBwryjGO5db228x96h7oe1rd3k1iYiebZKEn5
         bvCiuCl/eYW1ucEa6wgQ0Zcmc7cEB1xF9Gm2obvrQ6KPpkQ1Ymh6VykkLrp5M7oc6By8
         Tp9htmgfEb97DA3zS9c2V4W7TzY08M39gEKyD8DliP0/KZGdNJCg+r4bpr+aHMhVR/F0
         v6KyC4Bm2NxcPFghnvO4PYmaDN8KpyIhq22+4XL2HDw0OpomayU6iyS/N6KMaVtMbDfP
         ewlxx+Zpcjq9ooCEk0f6VpOdSiXVBkS4kGZwXvV4u9oDW5HTR/rsEkWGl/h2pTvk3Wou
         Eqqg==
X-Gm-Message-State: APjAAAXbb4GVNPnD7WctZtuJOkSRWJJpz7YyylJ6NYYom39EW3hQYaEc
        16INPu3+rwtw8Fj0p1Q+CT8=
X-Google-Smtp-Source: APXvYqybLZBvG94s/8G7V0fd+jZvZdno/xiWU3JfXcc3IQ+YviQtpNXXBQra6Ll5xFmSqG4cefrHSw==
X-Received: by 2002:a17:902:8eca:: with SMTP id x10mr45052337plo.94.1582478419297;
        Sun, 23 Feb 2020 09:20:19 -0800 (PST)
Received: from localhost.localdomain ([103.87.57.33])
        by smtp.googlemail.com with ESMTPSA id 13sm9505424pfj.68.2020.02.23.09.20.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Feb 2020 09:20:18 -0800 (PST)
From:   Amol Grover <frextrite@gmail.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Joel Fernandes <joel@joelfernandes.org>,
        Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Amol Grover <frextrite@gmail.com>
Subject: [PATCH 1/2] netfilter: Pass lockdep expression to __instance_lookup traversal
Date:   Sun, 23 Feb 2020 22:49:45 +0530
Message-Id: <20200223171945.11391-1-frextrite@gmail.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

log->instance_table[] may be traversed outside RCU read-side
critical section but under the protection of log->instances_lock.

Hence, add the corresponding lockdep expression to silence
false-positive warnings.

Signed-off-by: Amol Grover <frextrite@gmail.com>
---
 net/netfilter/nfnetlink_log.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 0ba020ca38e6..09acc579b566 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -104,7 +104,8 @@ __instance_lookup(struct nfnl_log_net *log, u_int16_t group_num)
 	struct nfulnl_instance *inst;
 
 	head = &log->instance_table[instance_hashfn(group_num)];
-	hlist_for_each_entry_rcu(inst, head, hlist) {
+	hlist_for_each_entry_rcu(inst, head, hlist,
+				 lockdep_is_held(&log->instances_lock)) {
 		if (inst->group_num == group_num)
 			return inst;
 	}
-- 
2.24.1

