Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3CC226C86D
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 20:49:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728197AbgIPStU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 14:49:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:44254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728153AbgIPSqK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Sep 2020 14:46:10 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F57B221EC;
        Wed, 16 Sep 2020 18:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600281968;
        bh=PizuCKedVSnuiRnh+VWDe8s8rBgOspdAMA6AwoPh/Gc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dIU3ykcWb2WBvNWiyT3UXZW4LWEhGDEOphqKmW2ht45g5bHd7arfDoUmqR83zdfya
         RSIPqoxJqquhj29t20MbqoKanCRyAH/AkBuuiFaiLGmdlQlKDyhhw8ysWuzvPh5nAM
         Tu8EbtUOhflNPEEgXnGPa9uGCsrC8fgHGfeb9ZsI=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, paulmck@kernel.org, joel@joelfernandes.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        rcu@vger.kernel.org, josh@joshtriplett.org, peterz@infradead.org,
        christian.brauner@ubuntu.com, Jakub Kicinski <kuba@kernel.org>,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us
Subject: [PATCH net-next 4/7] net: sched: remove broken definitions and un-hide for !LOCKDEP
Date:   Wed, 16 Sep 2020 11:45:25 -0700
Message-Id: <20200916184528.498184-5-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200916184528.498184-1-kuba@kernel.org>
References: <20200916184528.498184-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We're trying to make LOCKDEP-related function declarations
visible to the compiler and depend on dead code elimination
to remove them.

Fix up the situation with lockdep_tcf_chain_is_locked() and
lockdep_tcf_proto_is_locked().

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
--
CC: jhs@mojatatu.com
CC: xiyou.wangcong@gmail.com
CC: jiri@resnulli.us
---
 include/net/sch_generic.h | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index d60e7c39d60c..1aaa9e3d2e9c 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -432,7 +432,6 @@ struct tcf_block {
 	struct mutex proto_destroy_lock; /* Lock for proto_destroy hashtable. */
 };
 
-#ifdef CONFIG_PROVE_LOCKING
 static inline bool lockdep_tcf_chain_is_locked(struct tcf_chain *chain)
 {
 	return lockdep_is_held(&chain->filter_chain_lock);
@@ -442,17 +441,6 @@ static inline bool lockdep_tcf_proto_is_locked(struct tcf_proto *tp)
 {
 	return lockdep_is_held(&tp->lock);
 }
-#else
-static inline bool lockdep_tcf_chain_is_locked(struct tcf_block *chain)
-{
-	return true;
-}
-
-static inline bool lockdep_tcf_proto_is_locked(struct tcf_proto *tp)
-{
-	return true;
-}
-#endif /* #ifdef CONFIG_PROVE_LOCKING */
 
 #define tcf_chain_dereference(p, chain)					\
 	rcu_dereference_protected(p, lockdep_tcf_chain_is_locked(chain))
-- 
2.26.2

