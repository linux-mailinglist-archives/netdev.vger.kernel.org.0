Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4D51672AB1
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 22:41:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231184AbjARVlY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 16:41:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231174AbjARVlX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 16:41:23 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFB6B16AC4
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 13:41:21 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id n7so6391wrx.5
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 13:41:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0pMAF7eLOpf48HDHSGi29DRHvDztNug+IGFby4/8CII=;
        b=eldce92xmDUkAwn5ojEy4APbipBNx8mgDPZYTycUGyalea/bbOA+8CybcRIua6S8Pa
         t49YwyhOXDoAqfOS2YfYKCydYYPMujgrEOBgUgBbJb9eL30yv0BlVfvqieOpblNd1AmX
         gr6pheUhMa1xLfrDSC8P62jHxts2H0GwPg2ZVFjF7hlEQ2cKRK6CGxNorQNONNnLXD/q
         d1bF1kVpN0f/8m/71xI+YW9gI1JvUiFsfpoIQiU6jv+HGQdOup0R1GvHwcRtgLoF91MQ
         SR/HX6VjxQ6MoPRajStynJxwVfTJO4lUyqSq6gYFoSuMd1hdRDOtcDOnHQYSxBVgtDem
         s0gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0pMAF7eLOpf48HDHSGi29DRHvDztNug+IGFby4/8CII=;
        b=RoB9t9vbMlL1uQHjEaR98xkbvKTtBEdTXcV3jxmjuct7LYhMlY6sffrBH1Kpqpr877
         RTiBuuQk3xnVUme7W2aAAGfQrqGq2HzTzBh8+FhFWFCgQGt5oBTKJQ+vGnKCXKnvYBiR
         AntUBhScscQ76OZy0hvTm0Y+KTBD/99sR2Ng+WiexHxzoFDK/Vg4QXKDEAD5s0WE9itI
         rbNA87a/5hqVRRDG022584/hKR6u8WK0MchfXi+fSsBsyh+7IBwNZb3LlBE/fb1jD69A
         rueeCV58mPgRBYTyFCX+z33JWhSeE20MfvNNpP+z6QC+/3dI6Mm2Ho5Ogal3NpxTMqOY
         1LXg==
X-Gm-Message-State: AFqh2kq0Hi3VnD69NcX1ClAO58GoMqUfcYswa3o8QiM6oahJ3dr4XNW+
        s/ZrOdIngLBan/uMSzdmyDtzjQ==
X-Google-Smtp-Source: AMrXdXs1UL6geTo00GnQEAYiX/Vs5mZpD6Na4G/B+zJdnEdfaIJzTs8iFu3DXdpY0cEzf8Qn8v8XVg==
X-Received: by 2002:a05:6000:603:b0:2bd:f651:3a67 with SMTP id bn3-20020a056000060300b002bdf6513a67mr8614999wrb.64.1674078080361;
        Wed, 18 Jan 2023 13:41:20 -0800 (PST)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id m5-20020a056000024500b00267bcb1bbe5sm33186349wrz.56.2023.01.18.13.41.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 13:41:19 -0800 (PST)
From:   Dmitry Safonov <dima@arista.com>
To:     linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Dmitry Safonov <dima@arista.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Bob Gilligan <gilligan@arista.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Leonard Crestez <cdleonard@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        netdev@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: [PATCH v4 1/4] crypto: Introduce crypto_pool
Date:   Wed, 18 Jan 2023 21:41:08 +0000
Message-Id: <20230118214111.394416-2-dima@arista.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230118214111.394416-1-dima@arista.com>
References: <20230118214111.394416-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce a per-CPU pool of async crypto requests that can be used
in bh-disabled contexts (designed with net RX/TX softirqs as users in
mind). Allocation can sleep and is a slow-path.
Initial implementation has only ahash as a backend and a fix-sized array
of possible algorithms used in parallel.

Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 crypto/Kconfig        |   3 +
 crypto/Makefile       |   1 +
 crypto/crypto_pool.c  | 333 ++++++++++++++++++++++++++++++++++++++++++
 include/crypto/pool.h |  46 ++++++
 4 files changed, 383 insertions(+)
 create mode 100644 crypto/crypto_pool.c
 create mode 100644 include/crypto/pool.h

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 9c86f7045157..7096654419cb 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1388,6 +1388,9 @@ endmenu
 config CRYPTO_HASH_INFO
 	bool
 
+config CRYPTO_POOL
+	tristate
+
 if !KMSAN # avoid false positives from assembly
 if ARM
 source "arch/arm/crypto/Kconfig"
diff --git a/crypto/Makefile b/crypto/Makefile
index d0126c915834..eed8f61bc93b 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -63,6 +63,7 @@ obj-$(CONFIG_CRYPTO_ACOMP2) += crypto_acompress.o
 cryptomgr-y := algboss.o testmgr.o
 
 obj-$(CONFIG_CRYPTO_MANAGER2) += cryptomgr.o
+obj-$(CONFIG_CRYPTO_POOL) += crypto_pool.o
 obj-$(CONFIG_CRYPTO_USER) += crypto_user.o
 crypto_user-y := crypto_user_base.o
 crypto_user-$(CONFIG_CRYPTO_STATS) += crypto_user_stat.o
diff --git a/crypto/crypto_pool.c b/crypto/crypto_pool.c
new file mode 100644
index 000000000000..0237dad937b8
--- /dev/null
+++ b/crypto/crypto_pool.c
@@ -0,0 +1,333 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+#include <crypto/pool.h>
+#include <linux/cpu.h>
+#include <linux/kref.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/percpu.h>
+#include <linux/workqueue.h>
+
+static size_t __scratch_size;
+static DEFINE_PER_CPU(void __rcu *, crypto_pool_scratch);
+
+struct crypto_pool_entry {
+	struct ahash_request * __percpu *req;
+	const char			*alg;
+	struct kref			kref;
+	bool				needs_key;
+};
+
+#define CPOOL_SIZE (PAGE_SIZE/sizeof(struct crypto_pool_entry))
+static struct crypto_pool_entry cpool[CPOOL_SIZE];
+static unsigned int cpool_populated;
+static DEFINE_MUTEX(cpool_mutex);
+
+/* Slow-path */
+struct scratches_to_free {
+	struct rcu_head rcu;
+	unsigned int cnt;
+	void *scratches[];
+};
+static void free_old_scratches(struct rcu_head *head)
+{
+	struct scratches_to_free *stf;
+
+	stf = container_of(head, struct scratches_to_free, rcu);
+	while (stf->cnt--)
+		kfree(stf->scratches[stf->cnt]);
+	kfree(stf);
+}
+/*
+ * crypto_pool_reserve_scratch - re-allocates scratch buffer, slow-path
+ * @size: request size for the scratch/temp buffer
+ */
+static int crypto_pool_reserve_scratch(size_t size)
+{
+	struct scratches_to_free *stf;
+	size_t stf_sz = struct_size(stf, scratches, num_possible_cpus());
+	int cpu, err = 0;
+
+	lockdep_assert_held(&cpool_mutex);
+	if (__scratch_size >= size)
+		return 0;
+
+	stf = kmalloc(stf_sz, GFP_KERNEL);
+	if (!stf)
+		return -ENOMEM;
+	stf->cnt = 0;
+
+	cpus_read_lock();
+	for_each_possible_cpu(cpu) {
+		void *scratch, *old_scratch;
+
+		scratch = kmalloc_node(size, GFP_KERNEL, cpu_to_node(cpu));
+		if (!scratch) {
+			err = -ENOMEM;
+			break;
+		}
+
+		old_scratch = rcu_replace_pointer(per_cpu(crypto_pool_scratch, cpu), scratch, lockdep_is_held(&cpool_mutex));
+		if (!cpu_online(cpu) || !old_scratch) {
+			kfree(old_scratch);
+			continue;
+		}
+		stf->scratches[stf->cnt++] = old_scratch;
+	}
+	cpus_read_unlock();
+	if (!err)
+		__scratch_size = size;
+
+	call_rcu(&stf->rcu, free_old_scratches);
+	return err;
+}
+
+static void crypto_pool_scratch_free(void)
+{
+	int cpu;
+
+	for_each_possible_cpu(cpu)
+		kfree(rcu_replace_pointer(per_cpu(crypto_pool_scratch, cpu),
+					  NULL, lockdep_is_held(&cpool_mutex)));
+	__scratch_size = 0;
+}
+
+static int __cpool_alloc_ahash(struct crypto_pool_entry *e, const char *alg)
+{
+	struct crypto_ahash *hash, *cpu0_hash;
+	int cpu, ret = -ENOMEM;
+
+	e->alg = kstrdup(alg, GFP_KERNEL);
+	if (!e->alg)
+		return -ENOMEM;
+
+	e->req = alloc_percpu(struct ahash_request *);
+	if (!e->req)
+		goto out_free_alg;
+
+	cpu0_hash = crypto_alloc_ahash(alg, 0, CRYPTO_ALG_ASYNC);
+	if (IS_ERR(cpu0_hash)) {
+		ret = PTR_ERR(cpu0_hash);
+		goto out_free_req;
+	}
+
+	/* If hash has .setkey(), allocate ahash per-CPU, not only request */
+	e->needs_key = crypto_ahash_get_flags(cpu0_hash) & CRYPTO_TFM_NEED_KEY;
+
+	hash = cpu0_hash;
+	for_each_possible_cpu(cpu) {
+		struct ahash_request *req;
+
+		/*
+		 * If ahash has a key - it has to be allocated per-CPU.
+		 * In such case re-use for CPU0 hash that just have been
+		 * allocated above.
+		 */
+		if (!hash)
+			hash = crypto_alloc_ahash(alg, 0, CRYPTO_ALG_ASYNC);
+		if (IS_ERR(hash))
+			goto out_free_per_cpu;
+
+		req = ahash_request_alloc(hash, GFP_KERNEL);
+		if (!req)
+			goto out_free_hash;
+
+		ahash_request_set_callback(req, 0, NULL, NULL);
+
+		*per_cpu_ptr(e->req, cpu) = req;
+
+		if (e->needs_key)
+			hash = NULL;
+	}
+	kref_init(&e->kref);
+	return 0;
+
+out_free_hash:
+	if (hash != cpu0_hash)
+		crypto_free_ahash(hash);
+
+out_free_per_cpu:
+	for_each_possible_cpu(cpu) {
+		struct ahash_request *req = *per_cpu_ptr(e->req, cpu);
+		struct crypto_ahash *pcpu_hash;
+
+		if (req == NULL)
+			break;
+		pcpu_hash = crypto_ahash_reqtfm(req);
+		ahash_request_free(req);
+		/* hash per-CPU, e->needs_key == true */
+		if (pcpu_hash != cpu0_hash)
+			crypto_free_ahash(pcpu_hash);
+	}
+
+	crypto_free_ahash(cpu0_hash);
+out_free_req:
+	free_percpu(e->req);
+out_free_alg:
+	kfree(e->alg);
+	e->alg = NULL;
+	return ret;
+}
+
+/**
+ * crypto_pool_alloc_ahash - allocates pool for ahash requests
+ * @alg: name of async hash algorithm
+ * @scratch_size: reserve a crypto_pool::scratch buffer of this size
+ */
+int crypto_pool_alloc_ahash(const char *alg, size_t scratch_size)
+{
+	int i, ret;
+
+	/* slow-path */
+	mutex_lock(&cpool_mutex);
+	ret = crypto_pool_reserve_scratch(scratch_size);
+	if (ret)
+		goto out;
+	for (i = 0; i < cpool_populated; i++) {
+		if (cpool[i].alg && !strcmp(cpool[i].alg, alg)) {
+			if (kref_read(&cpool[i].kref) > 0)
+				kref_get(&cpool[i].kref);
+			else
+				kref_init(&cpool[i].kref);
+			ret = i;
+			goto out;
+		}
+	}
+
+	for (i = 0; i < cpool_populated; i++) {
+		if (!cpool[i].alg)
+			break;
+	}
+	if (i >= CPOOL_SIZE) {
+		ret = -ENOSPC;
+		goto out;
+	}
+
+	ret = __cpool_alloc_ahash(&cpool[i], alg);
+	if (!ret) {
+		ret = i;
+		if (i == cpool_populated)
+			cpool_populated++;
+	}
+out:
+	mutex_unlock(&cpool_mutex);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(crypto_pool_alloc_ahash);
+
+static void __cpool_free_entry(struct crypto_pool_entry *e)
+{
+	struct crypto_ahash *hash = NULL;
+	int cpu;
+
+	for_each_possible_cpu(cpu) {
+		if (*per_cpu_ptr(e->req, cpu) == NULL)
+			continue;
+
+		hash = crypto_ahash_reqtfm(*per_cpu_ptr(e->req, cpu));
+		ahash_request_free(*per_cpu_ptr(e->req, cpu));
+		if (e->needs_key) {
+			crypto_free_ahash(hash);
+			hash = NULL;
+		}
+	}
+	if (hash)
+		crypto_free_ahash(hash);
+	free_percpu(e->req);
+	kfree(e->alg);
+	memset(e, 0, sizeof(*e));
+}
+
+static void cpool_cleanup_work_cb(struct work_struct *work)
+{
+	unsigned int i;
+	bool free_scratch = true;
+
+	mutex_lock(&cpool_mutex);
+	for (i = 0; i < cpool_populated; i++) {
+		if (kref_read(&cpool[i].kref) > 0) {
+			free_scratch = false;
+			continue;
+		}
+		if (!cpool[i].alg)
+			continue;
+		__cpool_free_entry(&cpool[i]);
+	}
+	if (free_scratch)
+		crypto_pool_scratch_free();
+	mutex_unlock(&cpool_mutex);
+}
+
+static DECLARE_WORK(cpool_cleanup_work, cpool_cleanup_work_cb);
+static void cpool_schedule_cleanup(struct kref *kref)
+{
+	schedule_work(&cpool_cleanup_work);
+}
+
+/**
+ * crypto_pool_release - decreases number of users for a pool. If it was
+ * the last user of the pool, releases any memory that was consumed.
+ * @id: crypto_pool that was previously allocated by crypto_pool_alloc_ahash()
+ */
+void crypto_pool_release(unsigned int id)
+{
+	if (WARN_ON_ONCE(id > cpool_populated || !cpool[id].alg))
+		return;
+
+	/* slow-path */
+	kref_put(&cpool[id].kref, cpool_schedule_cleanup);
+}
+EXPORT_SYMBOL_GPL(crypto_pool_release);
+
+/**
+ * crypto_pool_get - increases number of users (refcounter) for a pool
+ * @id: crypto_pool that was previously allocated by crypto_pool_alloc_ahash()
+ */
+void crypto_pool_get(unsigned int id)
+{
+	if (WARN_ON_ONCE(id > cpool_populated || !cpool[id].alg))
+		return;
+	kref_get(&cpool[id].kref);
+}
+EXPORT_SYMBOL_GPL(crypto_pool_get);
+
+int crypto_pool_start(unsigned int id, struct crypto_pool *c)
+{
+	struct crypto_pool_ahash *ret = (struct crypto_pool_ahash *)c;
+
+	rcu_read_lock_bh();
+	if (WARN_ON_ONCE(id > cpool_populated || !cpool[id].alg)) {
+		rcu_read_unlock_bh();
+		return -EINVAL;
+	}
+	ret->req = *this_cpu_ptr(cpool[id].req);
+	/*
+	 * Pairs with crypto_pool_reserve_scratch(), scratch area is
+	 * valid (allocated) until crypto_pool_end().
+	 */
+	ret->base.scratch = rcu_dereference_bh(*this_cpu_ptr(&crypto_pool_scratch));
+	return 0;
+}
+EXPORT_SYMBOL_GPL(crypto_pool_start);
+
+/**
+ * crypto_pool_algo - return algorithm of crypto_pool
+ * @id: crypto_pool that was previously allocated by crypto_pool_alloc_ahash()
+ * @buf: buffer to return name of algorithm
+ * @buf_len: size of @buf
+ */
+size_t crypto_pool_algo(unsigned int id, char *buf, size_t buf_len)
+{
+	size_t ret = 0;
+
+	/* slow-path */
+	mutex_lock(&cpool_mutex);
+	if (cpool[id].alg)
+		ret = strscpy(buf, cpool[id].alg, buf_len);
+	mutex_unlock(&cpool_mutex);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(crypto_pool_algo);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Per-CPU pool of crypto requests");
diff --git a/include/crypto/pool.h b/include/crypto/pool.h
new file mode 100644
index 000000000000..e266c1cba7de
--- /dev/null
+++ b/include/crypto/pool.h
@@ -0,0 +1,46 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+#ifndef _CRYPTO_POOL_H
+#define _CRYPTO_POOL_H
+
+#include <crypto/hash.h>
+
+/**
+ * struct crypto_pool - generic type for different crypto requests
+ * @scratch: per-CPU temporary area, that can be used between
+ *	     crypto_pool_start() and crypto_pool_end() to perform
+ *	     crypto requests
+ */
+struct crypto_pool {
+	void *scratch;
+};
+
+/**
+ * struct crypto_pool_ahash - per-CPU pool of ahash_requests
+ * @base: common members that can be used by any async crypto ops
+ * @req: pre-allocated ahash request
+ */
+struct crypto_pool_ahash {
+	struct crypto_pool base;
+	struct ahash_request *req;
+};
+
+int crypto_pool_alloc_ahash(const char *alg, size_t scratch_size);
+void crypto_pool_get(unsigned int id);
+void crypto_pool_release(unsigned int id);
+
+/**
+ * crypto_pool_start - disable bh and start using crypto_pool
+ * @id: crypto_pool that was previously allocated by crypto_pool_alloc_ahash()
+ * @c: returned crypto_pool for usage (uninitialized on failure)
+ */
+int crypto_pool_start(unsigned int id, struct crypto_pool *c);
+/**
+ * crypto_pool_end - enable bh and stop using crypto_pool
+ */
+static inline void crypto_pool_end(void)
+{
+	rcu_read_unlock_bh();
+}
+size_t crypto_pool_algo(unsigned int id, char *buf, size_t buf_len);
+
+#endif /* _CRYPTO_POOL_H */
-- 
2.39.0

