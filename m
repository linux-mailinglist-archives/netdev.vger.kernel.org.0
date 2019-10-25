Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16F00E4E71
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 16:07:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505117AbfJYNzg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 09:55:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:49530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2505101AbfJYNzf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Oct 2019 09:55:35 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7234222BD;
        Fri, 25 Oct 2019 13:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572011734;
        bh=ZZjjnG3npdaGzZzxef3vjTrq7vHubzzO5lJ6IcAPVKA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HNSG62Phu14zNrKY4EJOnALBH7CTO63QES+mP8l0NAXA2N92+CEWj0M8VslHDRE0T
         DsaxTk67I4v2lMJMRXFpE8KfhI126A+yHg89JT+4o7wq9oFxy3ktn52CgGVLfMEQCP
         /2tjF1cTebVqgDn5wq9K9/R6UHmMzst3gC1RbN/Q=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 16/33] netfilter: connlabels: prefer static lock initialiser
Date:   Fri, 25 Oct 2019 09:54:48 -0400
Message-Id: <20191025135505.24762-16-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191025135505.24762-1-sashal@kernel.org>
References: <20191025135505.24762-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 105333435b4f3b21ffc325f32fae17719310db64 ]

seen during boot:
BUG: spinlock bad magic on CPU#2, swapper/0/1
 lock: nf_connlabels_lock+0x0/0x60, .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
Call Trace:
 do_raw_spin_lock+0x14e/0x1b0
 nf_connlabels_get+0x15/0x40
 ct_init_net+0xc4/0x270
 ops_init+0x56/0x1c0
 register_pernet_operations+0x1c8/0x350
 register_pernet_subsys+0x1f/0x40
 tcf_register_action+0x7c/0x1a0
 do_one_initcall+0x13d/0x2d9

Problem is that ct action init function can run before
connlabels_init().  Lock has not been initialised yet.

Fix it by using a static initialiser.

Fixes: b57dc7c13ea9 ("net/sched: Introduce action ct")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_labels.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_labels.c b/net/netfilter/nf_conntrack_labels.c
index 74b8113f7aebe..d1c6b2a2e7bd1 100644
--- a/net/netfilter/nf_conntrack_labels.c
+++ b/net/netfilter/nf_conntrack_labels.c
@@ -11,7 +11,7 @@
 #include <net/netfilter/nf_conntrack_ecache.h>
 #include <net/netfilter/nf_conntrack_labels.h>
 
-static spinlock_t nf_connlabels_lock;
+static __read_mostly DEFINE_SPINLOCK(nf_connlabels_lock);
 
 static int replace_u32(u32 *address, u32 mask, u32 new)
 {
@@ -89,7 +89,6 @@ int nf_conntrack_labels_init(void)
 {
 	BUILD_BUG_ON(NF_CT_LABELS_MAX_SIZE / sizeof(long) >= U8_MAX);
 
-	spin_lock_init(&nf_connlabels_lock);
 	return nf_ct_extend_register(&labels_extend);
 }
 
-- 
2.20.1

