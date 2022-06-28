Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FF4C55EEA0
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 22:00:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233754AbiF1Tyi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 15:54:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232430AbiF1Tu4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 15:50:56 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C8C013DC8;
        Tue, 28 Jun 2022 12:49:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656445789; x=1687981789;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1xrvhIX2IWhOahXdK1kR3UK2m56gKZ4b7bS+Cp3UyoY=;
  b=UNFyog5gECIDIzKB4WbDHf9yKQDb9XjLLsdTPouQSnCuIsdlBU7D99DB
   pUT+u/qvn55h8k2lV5ntKVTM+EjB6FZCp0VYkmCN+0OSx7X3Xefs7xxcU
   Cz1qddahTEdaPbKo2DrBjIx/bm374ZBVwNA1c4I1CDOxirPF6RfVts5Mw
   1IbGnXv+0aTNPvc1+4ArAHGxil2ozCRW58g4Cka4SaiseFeIy83bpf8mf
   lxR/WN3G7LokNruh7oPEFB6LvRn0G3jt/CLdeswAqPftB5bo8iQScUZpJ
   mSIMMtFh14lqkZepDeLPoUC9PBaPxDBNKS8Onsow/QPBEsAnhoW7ya1uj
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10392"; a="262242974"
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="262242974"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 12:49:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="836809521"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga006.fm.intel.com with ESMTP; 28 Jun 2022 12:49:45 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 25SJmr9b022013;
        Tue, 28 Jun 2022 20:49:43 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Toke Hoiland-Jorgensen <toke@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Yajun Deng <yajun.deng@linux.dev>,
        Willem de Bruijn <willemb@google.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        xdp-hints@xdp-project.net
Subject: [PATCH RFC bpf-next 37/52] rcupdate: fix access helpers for incomplete struct pointers on GCC < 10
Date:   Tue, 28 Jun 2022 21:47:57 +0200
Message-Id: <20220628194812.1453059-38-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220628194812.1453059-1-alexandr.lobakin@intel.com>
References: <20220628194812.1453059-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's been found that currently it is impossible to use RCU for
incomplete struct pointers.
RCU access helpers have the following construct:

	typeof(*p) *local = ...

GCC versions older than 10 don't look at the whole sentence and
believe that there's a dereference happening inside the typeof(),
although it does not.
As RCU doesn't imply any dereference, but only the way to store and
access pointers, this is not a valid case. Moreover, Clang and GCC
10 onwards evaluate it with no issues.
Fix this by introducing a new macro, __rcutype(), which will take
care of pointer annotations inside the RCU access helpers, in two
different ways depending on the compiler used. For sane compilers,
leave it as it is for now, as it ensures that the passed argument
is a pointer, and for the affected ones use...
`typeof(0 ? (p) : (p))`. As:

void fc(void) { }

...
	pr_info("%d", __builtin_types_compatible(typeof(*fn) *, typeof(fn)));
	pr_info("%d", __builtin_types_compatible(typeof(*fn) *, typeof(&fn)));
	pr_info("%d", __builtin_types_compatible(typeof(*fn) *,
						 typeof(0 ? (fn) : (fn)));

emits:

011

and we can't use the second for non-functions.

Fixes: ca5ecddfa8fc ("rcu: define __rcu address space modifier for sparse")
Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
---
 include/linux/rcupdate.h | 37 ++++++++++++++++++++++++++-----------
 1 file changed, 26 insertions(+), 11 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 1a32036c918c..f5971fccf852 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -358,18 +358,33 @@ static inline void rcu_preempt_sleep_check(void) { }
  * (e.g., __srcu), should this make sense in the future.
  */
 
+/*
+ * Unfortunately, GCC versions older than 10 don't look at the whole sentence
+ * and treat `typeof(*(p)) *` as dereferencing although it is not. This makes
+ * it impossible to use those helpers with pointers to incomplete structures.
+ * Plain `typeof(p)` is not the same, as `typeof(func)` returns the type of a
+ * function, not a pointer to it, as `typeof(*(func)) *` does.
+ * `typeof(<anything> ? (func) : (func))` is silly; however, it works just as
+ * the original definition.
+ */
+#if defined(CONFIG_CC_IS_GCC) && CONFIG_GCC_VERSION < 100000
+#define __rcutype(p, ...)	typeof(0 ? (p) : (p)) __VA_ARGS__
+#else
+#define __rcutype(p, ...)	typeof(*(p)) __VA_ARGS__ *
+#endif
+
 #ifdef __CHECKER__
 #define rcu_check_sparse(p, space) \
-	((void)(((typeof(*p) space *)p) == p))
+	((void)((__rcutype(p, space))(p) == (p)))
 #else /* #ifdef __CHECKER__ */
 #define rcu_check_sparse(p, space)
 #endif /* #else #ifdef __CHECKER__ */
 
 #define __unrcu_pointer(p, local)					\
 ({									\
-	typeof(*p) *local = (typeof(*p) *__force)(p);			\
+	__rcutype(p) local = (__rcutype(p, __force))(p);		\
 	rcu_check_sparse(p, __rcu);					\
-	((typeof(*p) __force __kernel *)(local)); 			\
+	((__rcutype(p, __force __kernel))(local)); 			\
 })
 /**
  * unrcu_pointer - mark a pointer as not being RCU protected
@@ -382,29 +397,29 @@ static inline void rcu_preempt_sleep_check(void) { }
 
 #define __rcu_access_pointer(p, local, space) \
 ({ \
-	typeof(*p) *local = (typeof(*p) *__force)READ_ONCE(p); \
+	__rcutype(p) local = (__rcutype(p, __force))READ_ONCE(p); \
 	rcu_check_sparse(p, space); \
-	((typeof(*p) __force __kernel *)(local)); \
+	((__rcutype(p, __force __kernel))(local)); \
 })
 #define __rcu_dereference_check(p, local, c, space) \
 ({ \
 	/* Dependency order vs. p above. */ \
-	typeof(*p) *local = (typeof(*p) *__force)READ_ONCE(p); \
+	__rcutype(p) local = (__rcutype(p, __force))READ_ONCE(p); \
 	RCU_LOCKDEP_WARN(!(c), "suspicious rcu_dereference_check() usage"); \
 	rcu_check_sparse(p, space); \
-	((typeof(*p) __force __kernel *)(local)); \
+	((__rcutype(p, __force __kernel))(local)); \
 })
 #define __rcu_dereference_protected(p, local, c, space) \
 ({ \
 	RCU_LOCKDEP_WARN(!(c), "suspicious rcu_dereference_protected() usage"); \
 	rcu_check_sparse(p, space); \
-	((typeof(*p) __force __kernel *)(p)); \
+	((__rcutype(p, __force __kernel))(p)); \
 })
 #define __rcu_dereference_raw(p, local) \
 ({ \
 	/* Dependency order vs. p above. */ \
-	typeof(p) local = READ_ONCE(p); \
-	((typeof(*p) __force __kernel *)(local)); \
+	__rcutype(p) local = READ_ONCE(p); \
+	((__rcutype(p, __force __kernel))(local)); \
 })
 #define rcu_dereference_raw(p) __rcu_dereference_raw(p, __UNIQUE_ID(rcu))
 
@@ -412,7 +427,7 @@ static inline void rcu_preempt_sleep_check(void) { }
  * RCU_INITIALIZER() - statically initialize an RCU-protected global variable
  * @v: The value to statically initialize with.
  */
-#define RCU_INITIALIZER(v) (typeof(*(v)) __force __rcu *)(v)
+#define RCU_INITIALIZER(v) (__rcutype(v, __force __rcu))(v)
 
 /**
  * rcu_assign_pointer() - assign to RCU-protected pointer
-- 
2.36.1

