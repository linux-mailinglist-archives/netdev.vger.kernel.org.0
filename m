Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73EBC323DD3
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 14:23:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235364AbhBXNTq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 08:19:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:59880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235243AbhBXNLL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Feb 2021 08:11:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 16C0864E21;
        Wed, 24 Feb 2021 12:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171320;
        bh=5kZEY3KyNh9cfun4Ukxj9H7DCBC2vj4KjNNWOZulrOQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CIwkQJL57oFFVnSuCWrzfgtDff43KBnWxRWLNSj7FEjoqgJzkP8HQxH4Bfgnvhlq7
         XZyehN/KkyPg5acLcnwXAYN+VioOPqFAHtfMOSrdZxLPyfGzzgYf61k0fDt8ZoOAD+
         u2LC8f1iCB53wdEpCm+Q3IP95naj8NHB25hjQWo5Nyk2YeSP4kCe1NQHPHd5tpol5q
         BNPs/7/4Y6WUE7CvoRxn78ZRNZinfRf2FyvDQCaseJMzBUCSRcIjFdggbmssbcPJDc
         0khMSSSr5nMcNhDep2deN4ERVecNtD11pWUYBFy6nuFIAWifFaoLLaUcUTl+rN2t5f
         tmScwrcPpzIrg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Di Zhu <zhudi21@huawei.com>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 05/16] pktgen: fix misuse of BUG_ON() in pktgen_thread_worker()
Date:   Wed, 24 Feb 2021 07:55:02 -0500
Message-Id: <20210224125514.483935-5-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210224125514.483935-1-sashal@kernel.org>
References: <20210224125514.483935-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Di Zhu <zhudi21@huawei.com>

[ Upstream commit 275b1e88cabb34dbcbe99756b67e9939d34a99b6 ]

pktgen create threads for all online cpus and bond these threads to
relevant cpu repecivtily. when this thread firstly be woken up, it
will compare cpu currently running with the cpu specified at the time
of creation and if the two cpus are not equal, BUG_ON() will take effect
causing panic on the system.
Notice that these threads could be migrated to other cpus before start
running because of the cpu hotplug after these threads have created. so the
BUG_ON() used here seems unreasonable and we can replace it with WARN_ON()
to just printf a warning other than panic the system.

Signed-off-by: Di Zhu <zhudi21@huawei.com>
Link: https://lore.kernel.org/r/20210125124229.19334-1-zhudi21@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/pktgen.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/pktgen.c b/net/core/pktgen.c
index 884afb8e9fc4e..b3132f11afeb9 100644
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -3555,7 +3555,7 @@ static int pktgen_thread_worker(void *arg)
 	struct pktgen_dev *pkt_dev = NULL;
 	int cpu = t->cpu;
 
-	BUG_ON(smp_processor_id() != cpu);
+	WARN_ON(smp_processor_id() != cpu);
 
 	init_waitqueue_head(&t->queue);
 	complete(&t->start_done);
-- 
2.27.0

