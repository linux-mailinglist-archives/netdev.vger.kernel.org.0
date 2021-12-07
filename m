Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09D1D46B1B1
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 05:02:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234662AbhLGEFm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 23:05:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231678AbhLGEFm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 23:05:42 -0500
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94980C061746
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 20:02:12 -0800 (PST)
Received: by mail-qt1-x82e.google.com with SMTP id j17so13120579qtx.2
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 20:02:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KBG6tNJjIQsq9v3D23PK7hQYlXfoAIJAKhzUZoQd6FI=;
        b=AZbnpbR6YDSwiqE/J4Lexv/JK/stcgXYgK1xyier52Sk1dBnhh2mI4Agm9i3r2+ozy
         3mYgSEeOkk90DOucewuhNicw54rth2zLFywsHCoe1Q8FURlx8kOINfgH8JciI6GGS2Iy
         c6n+Dc7zYGmoPLQ1D4Yx4y4T49LgenRHtcgVYrrc8vV4zmPM92v5gCIUQI7t3qS85jJN
         e5sqRcCSkFmz2to/FwI2Y+u/0urLka6880tnjTbGHCVBJhV//lXCJ/Ypg62VlbFZd/Qb
         AD31AyjlijyPoFZr2oZE6yLce6bgIjyVHPs8j7wtno7cPd2SXGKfhTD6MsQMFWlr9bZK
         SZ6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KBG6tNJjIQsq9v3D23PK7hQYlXfoAIJAKhzUZoQd6FI=;
        b=n1jbMLSyNoObiDF8L9apCzF9+Lf7yxVO0pMGfNF1x3c9J37+gkCHAxymR1l3IdaHAN
         Fnh9F7Dixjey4U2PgVtoHBVEcuU/g4KY6PXpeDxaSr7XmZyzRZG77/H8MeJm2nfzblEg
         jTOfspKJ1UpEPXuhpOP4EFhGvjqUv5NQVcsJkEhAh1KU1SiLDnvTlf1YJ0UmiLsUXdRD
         qOjg4WyzwsXYFz8ryujklKdoQs49QXW+jdbMpUo4GDKLV6UO5we0DPWRF1auEGn8vgHS
         aujk9iUG1Eiq/7phT4EAU/o/itP8GUrsfhEXDQeaoEnhbiVXESnnVfgkuusB86b6BQZI
         k9Zg==
X-Gm-Message-State: AOAM5335V81BFxCigA9jz8nYi80FRNx0A/M+90MARTnvEwXNLLGeD3rw
        /7H/OBSf7doTYTwC/E8as94afaGUi3HcRA==
X-Google-Smtp-Source: ABdhPJymQ4SeMaIGg8wZ2a3sUfpYp9jFY5qAj8hDdwgSaQ/LxFtJ0cfTGT1AShjKk5t0O3M5FIj3Dw==
X-Received: by 2002:a05:622a:1812:: with SMTP id t18mr44682606qtc.455.1638849731540;
        Mon, 06 Dec 2021 20:02:11 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id 14sm8526393qtx.84.2021.12.06.20.02.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 20:02:11 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>, davem@davemloft.net,
        kuba@kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next 1/5] lib: add obj_cnt infrastructure
Date:   Mon,  6 Dec 2021 23:02:04 -0500
Message-Id: <0179540815c25f6fbcf0d350ef118fb1a9330698.1638849511.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1638849511.git.lucien.xin@gmail.com>
References: <cover.1638849511.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to create a lib to counter any operatings to objects,
the same call to operate the same object will be saved as one node
which includes the call trace and object pointer, and the counter
in the node will increase next time when the same call comes to
this object.

There are a few sysctl parameters are exposed to users:

  1. Three of them are used to filter the calls with the objects:
    - index
      a 'int' type that can be used to match objects, such as netdev's
      index for netdev, and xfrm_state's spi for xfrm_state;
    - name
      a 'char *' type that can be used to match objects, such as netdev's
      name for netdev, and dst->dev's name for dst.
    - type
      a 'bitmap' that can be used to mark which operating is allowed to
      be counted, such as dev_hold, dev_put, inet6_hold, inet6_put.

  2. One is used to 'clear' or 'scan' the test result:
     - control
       it uses 'clear' to drop all nodes from the hashtable, and 'scan'
       to print out the details of all counter nodes.

  3. Another one is used to set up the stack depth we want to save:
     - nr_entries
       how detailed is a call trace it wants to use (1 to 16), the bigger
       it set to, the more nodes might be created, as the call might come
       with different call traces.

There are 2 APIs are exported for developers to count any calls to operate
objects they want:

  1. void obj_cnt_track(type, index, name, obj);
     check if this call can be matched with type and this object can be
     matched with any of index, name and obj. If yes, record this call
     to operate one obj, and create a node including this obj and calli
     trace if it doesn't exist in the hashtable, and increment the
     count of this node if it exists.

  2. void obj_cnt_set(index, name, obj);
     this won't be used unless a developer want to set the match condition
     somewhere in kernel code, especially to match with obj.

This lib can typically be used to track one object's refcnt, and all
we have to do is put obj_cnt_track() into this object's hold and put
functions. More details, see the following patches.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/linux/obj_cnt.h |  12 ++
 lib/Kconfig.debug       |   7 +
 lib/Makefile            |   1 +
 lib/obj_cnt.c           | 277 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 297 insertions(+)
 create mode 100644 include/linux/obj_cnt.h
 create mode 100644 lib/obj_cnt.c

diff --git a/include/linux/obj_cnt.h b/include/linux/obj_cnt.h
new file mode 100644
index 000000000000..e5185f7022d1
--- /dev/null
+++ b/include/linux/obj_cnt.h
@@ -0,0 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+#ifndef _LINUX_OBJ_CNT_H
+#define _LINUX_OBJ_CNT_H
+
+enum {
+	OBJ_CNT_TYPE_MAX
+};
+
+void obj_cnt_track(int type, int index, char *name, void *obj);
+void obj_cnt_set(int index, char *name, void *obj);
+
+#endif /* _LINUX_OBJ_CNT_H */
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 6504b97f8dfd..2c9d14b98783 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -2665,6 +2665,13 @@ config HYPERV_TESTING
 
 endmenu # "Kernel Testing and Coverage"
 
+config OBJ_CNT
+	bool "object operating counter"
+	select STACKTRACE
+	help
+	  This lib provide several APIs to count some objects' operating,
+	  and can be used to track refcnt.
+
 source "Documentation/Kconfig"
 
 endmenu # Kernel hacking
diff --git a/lib/Makefile b/lib/Makefile
index b213a7bbf3fd..5dc53da2c0b2 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -271,6 +271,7 @@ KASAN_SANITIZE_stackdepot.o := n
 KCOV_INSTRUMENT_stackdepot.o := n
 
 obj-$(CONFIG_REF_TRACKER) += ref_tracker.o
+obj-$(CONFIG_OBJ_CNT) += obj_cnt.o
 
 libfdt_files = fdt.o fdt_ro.o fdt_wip.o fdt_rw.o fdt_sw.o fdt_strerror.o \
 	       fdt_empty_tree.o fdt_addresses.o
diff --git a/lib/obj_cnt.c b/lib/obj_cnt.c
new file mode 100644
index 000000000000..19ced2303452
--- /dev/null
+++ b/lib/obj_cnt.c
@@ -0,0 +1,277 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+#include <linux/spinlock.h>
+#include <linux/slab.h>
+#include <linux/list.h>
+#include <linux/stacktrace.h>
+#include <linux/sysctl.h>
+#include <linux/obj_cnt.h>
+
+#define OBJ_CNT_HASHENTRIES	(1 << 8)
+#define OBJ_CNT_MAX		UINT_MAX
+#define OBJ_CNT_NRENTRIES	16
+static struct kmem_cache	*obj_cnt_cache	__read_mostly;
+static struct hlist_head	*obj_cnt_head;
+static unsigned int		obj_cnt_num;
+static spinlock_t		obj_cnt_lock;
+
+static char *obj_cnt_str[OBJ_CNT_TYPE_MAX] = {
+};
+
+struct obj_cnt {
+	struct hlist_node	hlist;
+	void			*obj;	/* the obj to count its operations */
+	u64			cnt;	/* how many times it's been operated */
+	int			type;	/* operation to the obj like get put */
+	unsigned long		entries[OBJ_CNT_NRENTRIES];	/* the stack */
+	unsigned int		nr_entries;
+};
+
+static int	obj_cnt_index;
+static int	obj_cnt_type;
+static char	obj_cnt_name[16];
+static void	*obj_cnt_obj;
+static int	obj_cnt_nr_entries;
+static int	obj_cnt_max_nr_entries = OBJ_CNT_NRENTRIES;
+
+static inline struct hlist_head *obj_cnt_hash(unsigned long hash)
+{
+	return &obj_cnt_head[hash & (OBJ_CNT_HASHENTRIES - 1)];
+}
+
+static struct obj_cnt *obj_cnt_lookup(void *obj, int type, unsigned long entries[],
+				      unsigned int nr_entries)
+{
+	struct hlist_head *head;
+	struct obj_cnt *oc;
+
+	head = obj_cnt_hash(entries[0]);
+	hlist_for_each_entry(oc, head, hlist)
+		if (oc->obj == obj && oc->type == type &&
+		    oc->nr_entries == nr_entries &&
+		    !memcmp(oc->entries, entries, nr_entries * sizeof(unsigned long)))
+			return oc;
+
+	return NULL;
+}
+
+static struct obj_cnt *obj_cnt_create(void *obj, int type, unsigned long entries[],
+				      unsigned int nr_entries)
+{
+	struct obj_cnt *oc;
+
+	if (obj_cnt_num == OBJ_CNT_MAX - 1) {
+		pr_err("OBJ_CNT: %s: too many obj_cnt added\n", __func__);
+		return NULL;
+	}
+	oc = kmem_cache_alloc(obj_cnt_cache, GFP_ATOMIC);
+	if (!oc) {
+		pr_err("OBJ_CNT: %s: no memory\n", __func__);
+		return NULL;
+	}
+	oc->nr_entries = nr_entries;
+	memcpy(oc->entries, entries, nr_entries * sizeof(unsigned long));
+	oc->obj = obj;
+	oc->cnt = 0;
+	oc->type = type;
+	hlist_add_head(&oc->hlist, obj_cnt_hash(oc->entries[0]));
+	obj_cnt_num++;
+
+	return oc;
+}
+
+static bool obj_cnt_allowed(int type, int index, char *name, void *obj)
+{
+	if (!(obj_cnt_type & (1 << type)))
+		return false;
+	if (index && index == obj_cnt_index)
+		return true;
+	if (name && !strcmp(name, obj_cnt_name))
+		return true;
+	if (obj && obj == obj_cnt_obj)
+		return true;
+	return false;
+}
+
+void obj_cnt_track(int type, int index, char *name, void *obj)
+{
+	unsigned long entries[OBJ_CNT_NRENTRIES];
+	unsigned int nr_entries;
+	unsigned long flags;
+	struct obj_cnt *oc;
+
+	if (!obj_cnt_allowed(type, index, name, obj))
+		return;
+
+	nr_entries = stack_trace_save(entries, obj_cnt_nr_entries, 1);
+	nr_entries = filter_irq_stacks(entries, nr_entries);
+	spin_lock_irqsave(&obj_cnt_lock, flags);  /* TODO: use rcu lock for lookup */
+	oc = obj_cnt_lookup(obj, type, entries, nr_entries);
+	if (!oc)
+		oc = obj_cnt_create(obj, type, entries, nr_entries);
+	if (oc) {
+		oc->cnt++;
+		WARN_ONCE(!oc->cnt, "OBJ_CNT: %s, the counter overflows\n", __func__);
+		pr_debug("OBJ_CNT: %s: obj: %px, type: %s, cnt: %llu, caller: %pS\n",
+			 __func__, oc->obj, obj_cnt_str[oc->type], oc->cnt, (void *)oc->entries[0]);
+	}
+	spin_unlock_irqrestore(&obj_cnt_lock, flags);
+}
+EXPORT_SYMBOL(obj_cnt_track);
+
+static void obj_cnt_dump(void *obj, int type)
+{
+	struct hlist_head *head;
+	struct obj_cnt *oc;
+	int h, first = 1;
+
+	spin_lock_bh(&obj_cnt_lock);
+	for (h = 0; h < OBJ_CNT_HASHENTRIES; h++) {
+		head = &obj_cnt_head[h];
+		hlist_for_each_entry(oc, head, hlist) {
+			if ((type && oc->type != type) || (obj && oc->obj != obj))
+				continue;
+			if (first) {
+				pr_info("OBJ_CNT: results =>\n");
+				first = 0;
+			}
+			pr_info("OBJ_CNT: %s: obj: %px, type: %s, cnt: %llu, caller: %pS, calltrace:\n",
+				__func__, oc->obj, obj_cnt_str[oc->type], oc->cnt, (void *)oc->entries[0]);
+			if (oc->nr_entries > 1)
+				stack_trace_print(oc->entries, oc->nr_entries, 4);
+		}
+	}
+	spin_unlock_bh(&obj_cnt_lock);
+}
+
+void obj_cnt_set(int index, char *name, void *obj)
+{
+	if (name)
+		strncpy(obj_cnt_name, name, min_t(size_t, 16, strlen(name)));
+	if (index)
+		obj_cnt_index = index;
+	if (obj)
+		obj_cnt_obj = obj;
+}
+EXPORT_SYMBOL(obj_cnt_set);
+
+static void obj_cnt_free(void)
+{
+	struct hlist_head *head;
+	struct hlist_node *tmp;
+	struct obj_cnt *oc;
+	int h;
+
+	spin_lock_bh(&obj_cnt_lock);
+	for (h = 0; h < OBJ_CNT_HASHENTRIES; h++) {
+		head = &obj_cnt_head[h];
+		hlist_for_each_entry_safe(oc, tmp, head, hlist) {
+			hlist_del(&oc->hlist);
+			kmem_cache_free(obj_cnt_cache, oc);
+		}
+	}
+	obj_cnt_num = 0;
+	spin_unlock_bh(&obj_cnt_lock);
+}
+
+static int proc_docntcmd(struct ctl_table *table, int write, void *buffer,
+			 size_t *lenp, loff_t *ppos)
+{
+	struct ctl_table tbl;
+	char cmd[8] = {0};
+	int ret;
+
+	if (!write)
+		return -EINVAL;
+
+	memset(&tbl, 0, sizeof(struct ctl_table));
+	tbl.data = cmd;
+	tbl.maxlen = sizeof(cmd);
+	ret = proc_dostring(&tbl, write, buffer, lenp, ppos);
+	if (ret)
+		return ret;
+
+	if (!strcmp(cmd, "clear"))
+		obj_cnt_free();
+	else if (!strcmp(cmd, "scan"))
+		obj_cnt_dump(NULL, 0);
+	else
+		return -EINVAL;
+	return 0;
+}
+
+static struct ctl_table obj_cnt_table[] = {
+	{
+		.procname	= "index",
+		.data		= &obj_cnt_index,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec
+	},
+	{
+		.procname	= "name",
+		.data		= obj_cnt_name,
+		.maxlen		= 16,
+		.mode		= 0644,
+		.proc_handler	= proc_dostring
+	},
+	{
+		.procname	= "type",
+		.data		= &obj_cnt_type,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec
+	},
+	{
+		.procname	= "control",
+		.maxlen		= 16,
+		.mode		= 0200,
+		.proc_handler	= proc_docntcmd
+	},
+	{
+		.procname	= "nr_entries",
+		.data		= &obj_cnt_nr_entries,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ONE,
+		.extra2         = &obj_cnt_max_nr_entries
+	},
+	{ }
+};
+
+static __init int obj_cnt_init(void)
+{
+	static struct ctl_table_header *hdr;
+	int i;
+
+	memset(obj_cnt_name, 0, sizeof(obj_cnt_name));
+	obj_cnt_index = 0;
+	obj_cnt_type = 0;
+	obj_cnt_obj = NULL;
+	obj_cnt_nr_entries = 8;
+	hdr = register_sysctl("obj_cnt", obj_cnt_table);
+	if (!hdr)
+		return -ENOMEM;
+
+	obj_cnt_cache = kmem_cache_create("obj_cnt_cache", sizeof(struct obj_cnt),
+					  0, SLAB_HWCACHE_ALIGN, NULL);
+	if (!obj_cnt_cache) {
+		unregister_sysctl_table(hdr);
+		return -ENOMEM;
+	}
+
+	obj_cnt_head = kmalloc_array(OBJ_CNT_HASHENTRIES, sizeof(*obj_cnt_head),
+				     GFP_KERNEL);
+	if (!obj_cnt_head) {
+		kmem_cache_destroy(obj_cnt_cache);
+		unregister_sysctl_table(hdr);
+		return -ENOMEM;
+	}
+	for (i = 0; i < OBJ_CNT_HASHENTRIES; i++)
+		INIT_HLIST_HEAD(&obj_cnt_head[i]);
+
+	spin_lock_init(&obj_cnt_lock);
+	return 0;
+}
+
+subsys_initcall(obj_cnt_init);
-- 
2.27.0

