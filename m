Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5D51AA7F2
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 18:04:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390847AbfIEQE0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 12:04:26 -0400
Received: from correo.us.es ([193.147.175.20]:53074 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390803AbfIEQEL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Sep 2019 12:04:11 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id BB02E1228C7
        for <netdev@vger.kernel.org>; Thu,  5 Sep 2019 18:04:07 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AEAA4B8017
        for <netdev@vger.kernel.org>; Thu,  5 Sep 2019 18:04:07 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A41E3B8005; Thu,  5 Sep 2019 18:04:07 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9A194DA7B6;
        Thu,  5 Sep 2019 18:04:05 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 05 Sep 2019 18:04:05 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 6A16F42EE38E;
        Thu,  5 Sep 2019 18:04:05 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 5/8] netfilter: not mark a spinlock as __read_mostly
Date:   Thu,  5 Sep 2019 18:03:57 +0200
Message-Id: <20190905160400.25399-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190905160400.25399-1-pablo@netfilter.org>
References: <20190905160400.25399-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Li RongQing <lirongqing@baidu.com>

when spinlock is locked/unlocked, its elements will be changed,
so marking it as __read_mostly is not suitable.

and remove a duplicate definition of nf_conntrack_locks_all_lock
strange that compiler does not complain.

Signed-off-by: Li RongQing <lirongqing@baidu.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_core.c   | 3 +--
 net/netfilter/nf_conntrack_labels.c | 2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 81a8ef42b88d..0c63120b2db2 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -73,8 +73,7 @@ struct conntrack_gc_work {
 };
 
 static __read_mostly struct kmem_cache *nf_conntrack_cachep;
-static __read_mostly spinlock_t nf_conntrack_locks_all_lock;
-static __read_mostly DEFINE_SPINLOCK(nf_conntrack_locks_all_lock);
+static DEFINE_SPINLOCK(nf_conntrack_locks_all_lock);
 static __read_mostly bool nf_conntrack_locks_all;
 
 /* every gc cycle scans at most 1/GC_MAX_BUCKETS_DIV part of table */
diff --git a/net/netfilter/nf_conntrack_labels.c b/net/netfilter/nf_conntrack_labels.c
index d1c6b2a2e7bd..522792556632 100644
--- a/net/netfilter/nf_conntrack_labels.c
+++ b/net/netfilter/nf_conntrack_labels.c
@@ -11,7 +11,7 @@
 #include <net/netfilter/nf_conntrack_ecache.h>
 #include <net/netfilter/nf_conntrack_labels.h>
 
-static __read_mostly DEFINE_SPINLOCK(nf_connlabels_lock);
+static DEFINE_SPINLOCK(nf_connlabels_lock);
 
 static int replace_u32(u32 *address, u32 mask, u32 new)
 {
-- 
2.11.0

