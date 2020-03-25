Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73EA0192D8B
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 16:56:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727953AbgCYP4D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 11:56:03 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:33838 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727912AbgCYP4D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 11:56:03 -0400
Received: by mail-qt1-f195.google.com with SMTP id 10so2595568qtp.1
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 08:56:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5LjboPnDfMYr+D+3numlwyKRNovhORGQjxZDfSq6m9Y=;
        b=hUPBtEbERszA+YII5Yxm3jnhf4gWvrQeMIUx7nRUKWsaVY/hTEbkcVwZ824Se5rjur
         x16y9PSdBsh167UfAZB5rT8bdfE8B41JnUCsPalmpfBxfrdDF/j6w9juDr9y/qiY8f1h
         pNQfeGBclLRBzT/fGnw6z3HBUlqE3UAo1M36/bqz9zfViGSlGkvioTbJiS2pCU7VlNop
         OQdFs/PIbIFnGIxs+zlMC8scqnUkRuWE0TWt3fVrW/7JpC5dxhnn5niw6m4tH5ntSp8s
         qpps1r0bF2/oiW3GuFKkRAgQUlhbibiMzAZHDiUoxY2kjLYpzPOqOSgyvIRDqfhyupYy
         4Vew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5LjboPnDfMYr+D+3numlwyKRNovhORGQjxZDfSq6m9Y=;
        b=UHy0f7o5o4PutCCEi37fiA1KGz9cBLHCRuNzny0AQypUFrh1MaroIIPALlGc2moIkF
         Xslnq9bGiFvNc2TkaRKuJJZ+dmZNs0CqFZRiTkPVOHaTTTBwta3nALnhwC/rztXsw3Mu
         MnoZmtzXJD1VOOz8rp/DH+lHlLI9dEB9Lyhwj55M6UCxrc51kWDWEf878xB4ZqfQRMSj
         dyepueXePZYljaFuSQFf+CvXQYUjd3t96WVtCR8IP6yAcnQ6HUtRNxkNjHaV+yih7C+0
         COTbdn0xiyoGyQxGVFwLPmmzhYGFMNr/i7/+7v+nsXOogjpoZ1VpuN/uXeEZVNEPLdUL
         /3pA==
X-Gm-Message-State: ANhLgQ2trx0rM2gdytzVMmX3C5l8QIGZRHJZVeUqR2Dm/NZsUS+T8XFh
        Nr7Y/scKEMelpAoU+o2YTqRZbAIhFImngA==
X-Google-Smtp-Source: ADFU+vsnGtXHOB3Q1SbOrengVFBDEEpEz+h2e/kMJ6fU6G+kU2YhLUoG6gF8c+vYKIE7feOWLDUscQ==
X-Received: by 2002:ac8:346f:: with SMTP id v44mr3526427qtb.205.1585151761950;
        Wed, 25 Mar 2020 08:56:01 -0700 (PDT)
Received: from ovpn-66-69.rdu2.redhat.com (pool-71-184-117-43.bstnma.fios.verizon.net. [71.184.117.43])
        by smtp.gmail.com with ESMTPSA id t23sm17931750qtj.63.2020.03.25.08.55.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 25 Mar 2020 08:55:47 -0700 (PDT)
From:   Qian Cai <cai@lca.pw>
To:     davem@davemloft.net
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Qian Cai <cai@lca.pw>
Subject: [PATCH] ipv4: fix a RCU-list lock in fib_triestat_seq_show
Date:   Wed, 25 Mar 2020 11:55:32 -0400
Message-Id: <20200325155532.7238-1-cai@lca.pw>
X-Mailer: git-send-email 2.21.0 (Apple Git-122.2)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

fib_triestat_seq_show() calls hlist_for_each_entry_rcu(tb, head,
tb_hlist) without rcu_read_lock() will trigger a warning,

 net/ipv4/fib_trie.c:2579 RCU-list traversed in non-reader section!!

 other info that might help us debug this:

 rcu_scheduler_active = 2, debug_locks = 1
 1 lock held by proc01/115277:
  #0: c0000014507acf00 (&p->lock){+.+.}-{3:3}, at: seq_read+0x58/0x670

 Call Trace:
  dump_stack+0xf4/0x164 (unreliable)
  lockdep_rcu_suspicious+0x140/0x164
  fib_triestat_seq_show+0x750/0x880
  seq_read+0x1a0/0x670
  proc_reg_read+0x10c/0x1b0
  __vfs_read+0x3c/0x70
  vfs_read+0xac/0x170
  ksys_read+0x7c/0x140
  system_call+0x5c/0x68

Signed-off-by: Qian Cai <cai@lca.pw>
---
 net/ipv4/fib_trie.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index ff0c24371e33..73fa37476f03 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -2577,6 +2577,7 @@ static int fib_triestat_seq_show(struct seq_file *seq, void *v)
 		   " %zd bytes, size of tnode: %zd bytes.\n",
 		   LEAF_SIZE, TNODE_SIZE(0));
 
+	rcu_read_lock();
 	for (h = 0; h < FIB_TABLE_HASHSZ; h++) {
 		struct hlist_head *head = &net->ipv4.fib_table_hash[h];
 		struct fib_table *tb;
@@ -2597,6 +2598,7 @@ static int fib_triestat_seq_show(struct seq_file *seq, void *v)
 #endif
 		}
 	}
+	rcu_read_unlock();
 
 	return 0;
 }
-- 
2.21.0 (Apple Git-122.2)

