Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84F8323F442
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 23:29:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727794AbgHGV3o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 17:29:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727077AbgHGV3h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Aug 2020 17:29:37 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15577C061756
        for <netdev@vger.kernel.org>; Fri,  7 Aug 2020 14:29:37 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id r1so4457011ybg.4
        for <netdev@vger.kernel.org>; Fri, 07 Aug 2020 14:29:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=DZ1XcM0cED77A7RVE0g/4nios57x9MDZZ5ZxcwQdk5E=;
        b=Bngt9NvknU55LdIMiX02eLN0o6LUzdbtvKXpG+3i0enAKsG8Pk6E/ngdI7IfsJSmDs
         WRdoM/DYrGwjDP5fkQPscla5JCIplKStX7e0zktn6xNUNqd/cHHVqPkZnjkkULa7jAbM
         Ezv/VFLfZAmXLRHOZ+Q/VY4w/7BCOcOISosmV7RA4F7egwzg4noTxcKuJFREVEmtJSIX
         giddv8Mr0Sa2EMpEhiS4+oj9wmTRUSkhnDgnK2GWqKk1v1Q7eJXJ3cRMIHdDOfcIhog1
         8X2s/Ep8pLvxSyFsvZXx3w4taCawiNwIU1j19lSPuP7GM/FZ0vE90yzQUhn077tXy8Sx
         wf5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=DZ1XcM0cED77A7RVE0g/4nios57x9MDZZ5ZxcwQdk5E=;
        b=qoVvmlV57/XILGNaEd+pvkO+jRi2cFyYTPPNU9UHB/8Z9r4VKXzcTKpsHv0mtzSgiz
         5wVyuHSCUG3mTArisOeMNhQ49ru5Pi/+WpHW89Y/7uffTksyoSo3Mu+hbTk9RbB12Mxm
         IxiTpiKVIkTwYiFoGiOcQ4eNsBdESQhGx3QScjIDxNb1gH710OgewRvS5RtTIT4Bku3g
         XLLrU1Cf978eq8H/PmqLTRy1OC2sa3SbavDSuwOy4+9N5dItEqdq8yH2jS9j+myn+8/Y
         jizKcdMRD+Ymhi3LErOVGnWXOKeZo27Q3KyDEK/v1pBtfPq/lc5LlhBI/z0cE+cHrBZ+
         3mnA==
X-Gm-Message-State: AOAM5338urcztdigWyJ4xd0awzTyylv3QoXP8+xVHcHwAIk/pk0xOdyN
        HtNAdm8V3eJg5OcSTHloCrTSJriueYU=
X-Google-Smtp-Source: ABdhPJzRbMgMO+xhrxQ92IW1rQZZD11iWBKacVFoF1vhmUHoAFABKi3OC7+XbcCrftSj+4u2ofvEujECnYpN
X-Received: by 2002:a5b:5c5:: with SMTP id w5mr22848625ybp.102.1596835776257;
 Fri, 07 Aug 2020 14:29:36 -0700 (PDT)
Date:   Fri,  7 Aug 2020 14:29:10 -0700
In-Reply-To: <20200807212916.2883031-1-jwadams@google.com>
Message-Id: <20200807212916.2883031-2-jwadams@google.com>
Mime-Version: 1.0
References: <20200807212916.2883031-1-jwadams@google.com>
X-Mailer: git-send-email 2.28.0.236.gb10cc79966-goog
Subject: [RFC PATCH 1/7] core/metricfs: Create metricfs, standardized files
 under debugfs.
From:   Jonathan Adams <jwadams@google.com>
To:     linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc:     netdev@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Jim Mattson <jmattson@google.com>,
        David Rientjes <rientjes@google.com>,
        Jonathan Adams <jwadams@google.com>,
        Justin TerAvest <teravest@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Justin TerAvest <teravest@google.com>

Metricfs is a standardized set of files and directories under debugfs,
with a kernel API designed to be simpler than exporting new files under
sysfs. Type and field information is reported so that a userspace daemon
can easily process the information.

The statistics live under debugfs, in a tree rooted at:

	/sys/kernel/debug/metricfs

Each metric is a directory, with four files in it.  This patch includes
a single "metricfs_presence" metric, whose files look like:
/sys/kernel/debug/metricfs:
 metricfs_presence/annotations
  DESCRIPTION A\ basic\ presence\ metric.
 metricfs_presence/fields
  value
  int
 metricfs_presence/values
  1
 metricfs_presence/version
  1

Statistics can have zero, one, or two 'fields', which are keys for the
table of metric values.  With no fields, you have a simple statistic as
above, with one field you have a 1-dimensional table of string -> value,
and with two fields you have a 2-dimensional table of
{string, string} -> value.

When a statistic's 'values' file is opened, we pre-allocate a 64k buffer
and call the statistic's callback to fill it with data, truncating if
the buffer overflows.

Statistic creators can create a hierarchy for their statistics using
metricfs_create_subsys().

Signed-off-by: Justin TerAvest <teravest@google.com>
[jwadams@google.com: Forward ported to v5.8, cleaned up and modernized
	code significantly]
Signed-off-by: Jonathan Adams <jwadams@google.com>

---

notes:
* To go upstream, this will need documentation and a MAINTAINERS update.
* It's not clear what the "version" file is for; it's vestigial and
should probably be removed.

jwadams@google.com: Forward ported to v5.8, removed some google-isms and
    cleaned up some anachronisms (atomic->refcount, moving to
    kvmalloc(), using POISON_POINTER_DELTA, made more functions static,
    made 'emitter_fn' into an explicit union instead of a void *),
    renamed 'struct emitter -> metric_emitter' and renamed
    some funcs for consistency.
---
 include/linux/metricfs.h   | 103 ++++++
 kernel/Makefile            |   2 +
 kernel/metricfs.c          | 727 +++++++++++++++++++++++++++++++++++++
 kernel/metricfs_examples.c | 151 ++++++++
 lib/Kconfig.debug          |  18 +
 5 files changed, 1001 insertions(+)
 create mode 100644 include/linux/metricfs.h
 create mode 100644 kernel/metricfs.c
 create mode 100644 kernel/metricfs_examples.c

diff --git a/include/linux/metricfs.h b/include/linux/metricfs.h
new file mode 100644
index 000000000000..65a1baa8e8c1
--- /dev/null
+++ b/include/linux/metricfs.h
@@ -0,0 +1,103 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _METRICFS_H_
+#define _METRICFS_H_
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/stringify.h>
+
+struct metric;
+struct metricfs_subsys;
+
+#define METRIC_EXPORT_GENERIC(name, desc, fname0, fname1, fn, is_str, cumulative) \
+static struct metric *metric_##name; \
+void metric_init_##name(struct metricfs_subsys *parent) \
+{ \
+	metric_##name = metric_register(__stringify(name), (parent), (desc), \
+					(fname0), (fname1), (fn), (is_str), \
+					(cumulative), THIS_MODULE); \
+} \
+void metric_exit_##name(void) \
+{ \
+	metric_unregister(metric_##name); \
+}
+
+/*
+ * Metricfs only deals with two types: int64_t and const char*.
+ *
+ * If a metric has fewer than two fields, pass NULL for the field name
+ * arguments.
+ *
+ * The metric does not take ownership of any of the strings passed in.
+ *
+ * See kernel/metricfs_examples.c for a set of example metrics, with
+ * corresponding output.
+ *
+ * METRIC_EXPORT_INT - An integer-valued metric.
+ * METRIC_EXPORT_COUNTER - An integer-valued cumulative metric.
+ * METRIC_EXPORT_STR - A string-valued metric.
+ */
+#define METRIC_EXPORT_INT(name, desc, fname0, fname1, fn) \
+	METRIC_EXPORT_GENERIC(name, (desc), (fname0), (fname1), (fn), \
+				false, false)
+#define METRIC_EXPORT_COUNTER(name, desc, fname0, fname1, fn) \
+	METRIC_EXPORT_GENERIC(name, (desc), (fname0), (fname1), (fn), \
+				false, true)
+#define METRIC_EXPORT_STR(name, desc, fname0, fname1, fn) \
+	METRIC_EXPORT_GENERIC(name, (desc), (fname0), (fname1), (fn), \
+				true, false)
+
+/* Subsystem support. */
+/* Pass NULL as 'parent' to create a new top-level subsystem. */
+struct metricfs_subsys *metricfs_create_subsys(const char *name,
+						struct metricfs_subsys *parent);
+void metricfs_destroy_subsys(struct metricfs_subsys *d);
+
+/*
+ * An opaque struct that metric emit functions use to keep our internal
+ * state.
+ */
+struct metric_emitter;
+
+/* The number of non-NULL arguments passed to EMIT macros must match the number
+ * of arguments passed to the EXPORT macro for a given metric.
+ *
+ * Failure to do so will cause data to be mangled (or dropped) by userspace or
+ * Monarch.
+ */
+#define METRIC_EMIT_INT(e, v, f0, f1) \
+	metric_emit_int_value((e), (v), (f0), (f1))
+#define METRIC_EMIT_STR(e, v, f0, f1) \
+	metric_emit_str_value((e), (v), (f0), (f1))
+
+/* Users don't have to call any functions below;
+ * use the macro definitions above instead.
+ */
+void metric_emit_int_value(struct metric_emitter *e,
+			   int64_t v, const char *f0, const char *f1);
+void metric_emit_str_value(struct metric_emitter *e,
+			   const char *v, const char *f0, const char *f1);
+
+struct metric *metric_register(const char *name,
+			       struct metricfs_subsys *parent,
+			       const char *description,
+			       const char *fname0, const char *fname1,
+			       void (*fn)(struct metric_emitter *e),
+			       bool is_string,
+			       bool is_cumulative,
+			       struct module *owner);
+
+struct metric *metric_register_parm(const char *name,
+				    struct metricfs_subsys *parent,
+			  const char *description,
+				    const char *fname0, const char *fname1,
+				    void (*fn)(struct metric_emitter *e,
+					       void *parm),
+				    void *parm,
+				    bool is_string,
+				    bool is_cumulative,
+				    struct module *owner);
+
+void metric_unregister(struct metric *m);
+
+#endif /* _METRICFS_H_ */
diff --git a/kernel/Makefile b/kernel/Makefile
index f3218bc5ec69..0edf790935b0 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -109,6 +109,8 @@ obj-$(CONFIG_CPU_PM) += cpu_pm.o
 obj-$(CONFIG_BPF) += bpf/
 obj-$(CONFIG_KCSAN) += kcsan/
 obj-$(CONFIG_SHADOW_CALL_STACK) += scs.o
+obj-$(CONFIG_METRICFS) += metricfs.o
+obj-$(CONFIG_METRICFS_EXAMPLES) += metricfs_examples.o
 
 obj-$(CONFIG_PERF_EVENTS) += events/
 
diff --git a/kernel/metricfs.c b/kernel/metricfs.c
new file mode 100644
index 000000000000..676b7b04aa2b
--- /dev/null
+++ b/kernel/metricfs.c
@@ -0,0 +1,727 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/refcount.h>
+#include <linux/dcache.h>
+#include <linux/debugfs.h>
+#include <linux/init.h>
+#include <linux/kref.h>
+#include <linux/metricfs.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+#include <linux/mm.h>
+
+/*
+ * Metricfs: A mechanism for exporting metrics from the kernel.
+ *
+ * Kernel code must provide:
+ *   - A description of the metric
+ *   - The subsystem for the metric (NULL is ok)
+ *   - Type information about the metric, and
+ *   - A callback function which supplies metric values.
+ *
+ * In return, metricfs provides files in debugfs at:
+ *   /sys/kernel/debug/metricfs/<subsys>/<metric_name>/
+ * The files are:
+ *   - annotations, which provides streamz "annotations"-- the description, and
+ *                  other metadata (e.g. if it's constant, deprecated, etc.)
+ *   - fields, which provides type information about the metric and its fields.
+ *   - values, which contains the actual metric value data.
+ *   - version, which is kept around for future-proofing.
+ *
+ * Metrics only support a limited subset of types-- for fields, they only
+ * support strings, integers, and boolean types. For simplicity, we only support
+ * strings and integers and strictly control how the data is formatted when
+ * displayed from debugfs.
+ *
+ * See kernel/metricfs_examples.c for example code.
+ *
+ * Limitations:
+ *   - "values" files are at MOST 64K. We truncate the file at that point.
+ *   - The list of fields and types is at most 1K.
+ *   - Metrics may have at most 2 fields.
+ *
+ * Best Practices:
+ *   - Emit the most important data first! Once the 64K per-metric buffer
+ *     is full, the emit* functions won't do anything.
+ *   - In userspace, open(), read(), and close() the file quickly! The kernel
+ *     allocation for the metric is alive as long as the file is open. This
+ *     permits users to seek around the contents of the file, while permitting
+ *     an atomic view of the data.
+ *
+ * FAQ:
+ *   - Why is memory allocated for file data at open()?
+ *     Snapshots of data provided by the kernel should be as "atomic" as
+ *     possible. If userspace code performs read()s smaller than the total
+ *     amount of data, we'd like for that tool to still work, while providing a
+ *     consistent view of the file.
+ *
+ * Questions:
+ *   - Would it be simpler if we escaped spaces instead of wrapping strings in
+ *     quotes?
+ */
+struct metric {
+	const char *name;
+	const char *description;
+
+	/* Metric field names (optional, NULL if unused) */
+	const char *fname0;
+	const char *fname1;
+
+	union {
+		void (*emit_noparm)(struct metric_emitter *e); /* !has_parm */
+		void (*emit_parm)(struct metric_emitter *e,
+				  void *parm); /* has_parm */
+	} emit_fn;
+	void *eparm;
+	bool is_string;
+	bool is_cumulative;
+	bool has_parm;
+
+	/* dentry for the directory that contains the metric */
+	struct dentry *dentry;
+
+	struct module *owner;
+
+	refcount_t refcnt;
+
+	/* Inodes that have references to our metric, protected under
+	 * big_mutex.
+	 */
+	struct inode *inodes[4];
+};
+
+/* Returns true if the refcount was successfully incremented for the metric */
+static int metric_module_get(struct metric *m)
+{
+	if (!try_module_get(m->owner))
+		return 0;
+
+	if (!refcount_inc_not_zero(&m->refcnt)) {
+		module_put(m->owner);
+		return 0;
+	}
+
+	return 1;
+}
+
+/* Returns true if the last reference was put. */
+static bool metric_put(struct metric *m)
+{
+	bool rc = refcount_dec_and_test(&m->refcnt);
+
+	if (rc)
+		kfree(m);
+	return rc;
+}
+
+static void metric_module_put(struct metric *m)
+{
+	struct module *owner = m->owner;
+
+	metric_put(m);
+	module_put(owner);
+}
+
+struct metric_emitter {
+	char *buf;
+	char *orig_buf;  /* To calculate total written. */
+	int size;  /* Size of underlying buffer. */
+	struct metric *metric;  /* For type checking. */
+};
+
+#define METRICFS_ANNOTATIONS_BUF_SIZE (1 * 1024)
+#define METRICFS_FIELDS_BUF_SIZE (1 * 1024)
+#define METRICFS_VALUES_BUF_SIZE (64 * 1024)
+#define METRICFS_VERSION_BUF_SIZE (8)
+
+/* Maximum length for fields. They're truncated at this point. */
+#define METRICFS_MAX_FIELD_LEN (100)
+
+static int emit_bytes_left(const struct metric_emitter *e)
+{
+	WARN_ON(e->orig_buf > e->buf);
+	return e->size - (e->buf - e->orig_buf);
+}
+
+struct char_tracker {
+	char *dest;
+	int size;
+	int pos;
+};
+
+static void add_char(struct char_tracker *t, char c)
+{
+	if (t->pos < t->size)
+		t->dest[t->pos] = c;
+	/* Increment pos even if we don't print, so we know how many
+	 * characters we'd print if we had room.
+	 */
+	t->pos++;
+}
+
+/* Escape backslashes, spaces, and newlines in string "s",
+ * copying to "dest", to a maximum of "size" characters.
+ *
+ * examples:
+ *  [Hi\ , "there"] -> [Hi\\\ ,\ "there"]
+ *  [foo
+ *   bar] - > [foo\nbar]
+ *
+ * Returns the number of characters that would be copied, if enough space
+ * was available. Doesn't emit a trailing zero.
+ */
+static int escape_string(char *dest, const char *s, int size)
+{
+	struct char_tracker tracker = {
+		.dest = dest,
+		.size = size,
+		.pos = 0,
+	};
+
+	/* We have to process the entire source string to ensure that
+	 * we return a useful value for the total possible emitted length.
+	 */
+	while (*s != 0) {
+		/* escape newlines */
+		if (*s == '\n') {
+			add_char(&tracker, '\\');
+			add_char(&tracker, 'n');
+			s++;
+			continue;
+		}
+
+		/* escape spaces and backslashes. */
+		if (*s == ' ' || *s == '\\')
+			add_char(&tracker, '\\');
+		add_char(&tracker, *s);
+		s++;
+	}
+
+	return tracker.pos;
+}
+
+/* Emits a string into the emitter buffer, no escaping */
+static bool emit_string(struct metric_emitter *e, const char *s)
+{
+	int bytes_left = emit_bytes_left(e);
+	int rc = snprintf(e->buf, bytes_left, "%s", s);
+
+	e->buf += min(rc, bytes_left);
+	return rc < bytes_left;
+}
+
+/* Emits a string into the emitter buffer, escaping quotes and newlines. */
+static bool emit_quoted_string(struct metric_emitter *e, const char *s)
+{
+	int bytes_left = emit_bytes_left(e);
+	int rc = escape_string(e->buf, s, bytes_left);
+
+	e->buf += min(rc, bytes_left);
+	return rc < bytes_left;
+}
+
+/* Emits an int into the emitter buffer */
+static bool emit_int(struct metric_emitter *e, int64_t i)
+{
+	int bytes_left = emit_bytes_left(e);
+	int rc = snprintf(e->buf, bytes_left, "%lld", i);
+
+	e->buf += min(rc, bytes_left);
+	return rc < bytes_left;
+}
+
+static void check_field_mismatch(struct metric *m, const char *f0,
+				 const char *f1)
+{
+	WARN_ON(m->fname0 && !f0);
+	WARN_ON(!m->fname0 && f0);
+	WARN_ON(m->fname1 && !f1);
+	WARN_ON(!m->fname1 && f1);
+}
+
+void metric_emit_int_value(struct metric_emitter *e, int64_t v,
+			   const char *f0, const char *f1)
+{
+	char *ckpt = e->buf;
+	bool ok = true;
+
+	WARN_ON_ONCE(e->metric->is_string);
+	check_field_mismatch(e->metric, f0, f1);
+	if (f0) {
+		ok &= emit_quoted_string(e, f0);
+		ok &= emit_string(e, " ");
+		if (f1) {
+			ok &= emit_quoted_string(e, f1);
+			ok &= emit_string(e, " ");
+		}
+	}
+	ok &= emit_int(e, v);
+	ok &= emit_string(e, "\n");
+	if (!ok)
+		e->buf = ckpt;
+}
+EXPORT_SYMBOL(metric_emit_int_value);
+
+void metric_emit_str_value(struct metric_emitter *e, const char *v,
+			   const char *f0, const char *f1)
+{
+	char *ckpt = e->buf;
+	bool ok = true;
+
+	WARN_ON_ONCE(!e->metric->is_string);
+	check_field_mismatch(e->metric, f0, f1);
+	if (f0) {
+		ok &= emit_quoted_string(e, f0);
+		ok &= emit_string(e, " ");
+		if (f1) {
+			ok &= emit_quoted_string(e, f1);
+			ok &= emit_string(e, " ");
+		}
+	}
+	ok &= emit_quoted_string(e, v);
+	ok &= emit_string(e, "\n");
+	if (!ok)
+		e->buf = ckpt;
+}
+EXPORT_SYMBOL(metric_emit_str_value);
+
+/* Contains file data generated at open() */
+struct metricfs_file_private {
+	size_t bytes_written;
+	char buf[0];
+};
+
+/* A mutex to prevent races involving the pointer to the inode stored in
+ * inode->i_private. We'll remove this if we can get a callback at inode
+ * deletion in debugfs.
+ */
+static DEFINE_MUTEX(big_mutex);
+
+/* Returns 1 on success, <0 otherwise. */
+static int metric_open_helper(struct inode *inode, struct file *filp,
+			      int buf_size,
+			      struct metric **m,
+			      struct metricfs_file_private **p)
+{
+	int size;
+
+	mutex_lock(&big_mutex);
+	/* Debugfs stores the "data" parameter from debugfs_create_file in
+	 * inode->i_private.
+	 */
+	*m = (struct metric *)inode->i_private;
+	if (!(*m) || !metric_module_get(*m)) {
+		mutex_unlock(&big_mutex);
+		return -ENXIO;
+	}
+	mutex_unlock(&big_mutex);
+
+	size = sizeof(struct metricfs_file_private) + buf_size;
+	*p = kvmalloc(size, GFP_KERNEL);
+	if (!*p) {
+		metric_module_put(*m);
+		return -ENOMEM;
+	}
+	filp->private_data = *p;
+	return 1;
+}
+
+static int metricfs_generic_release(struct inode *inode, struct file *filp)
+{
+	struct metricfs_file_private *p =
+			(struct metricfs_file_private *)filp->private_data;
+	kvfree(p);
+
+	filp->private_data = (void *)(0xDEADBEEFul + POISON_POINTER_DELTA);
+	/* FIXME here too? */
+	metric_module_put((struct metric *)inode->i_private);
+	return 0;
+}
+
+static int metricfs_annotations_open(struct inode *inode, struct file *filp)
+{
+	struct metric_emitter e;
+	struct metric *m;
+	struct metricfs_file_private *p;
+	bool ok = true;
+
+	int rc = metric_open_helper(inode, filp, METRICFS_ANNOTATIONS_BUF_SIZE,
+				    &m, &p);
+	if (rc < 0)
+		return rc;
+
+	e.buf = p->buf;
+	e.orig_buf = p->buf;
+	e.size = METRICFS_ANNOTATIONS_BUF_SIZE;
+	ok &= emit_string(&e, "DESCRIPTION ");
+	ok &= emit_quoted_string(&e, m->description);
+	ok &= emit_string(&e, "\n");
+	if (m->is_cumulative)
+		ok &= emit_string(&e, "CUMULATIVE\n");
+
+	/* Emit all or nothing. */
+	if (ok) {
+		p->bytes_written = e.buf - e.orig_buf;
+	} else {
+		metricfs_generic_release(inode, filp);
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static int metricfs_fields_open(struct inode *inode, struct file *filp)
+{
+	struct metric_emitter e;
+	struct metric *m;
+	struct metricfs_file_private *p;
+	bool ok = true;
+
+	int rc = metric_open_helper(inode, filp, METRICFS_FIELDS_BUF_SIZE,
+				    &m, &p);
+	if (rc < 0)
+		return rc;
+
+	e.buf = p->buf;
+	e.orig_buf = p->buf;
+	e.size = METRICFS_FIELDS_BUF_SIZE;
+	e.metric = m;
+
+	/* We don't have to do string escaping on fields, as quotes aren't
+	 * permitted in field names.
+	 */
+	if (m->fname0) {
+		ok &= emit_string(&e, m->fname0);
+		ok &= emit_string(&e, " ");
+	}
+	if (m->fname1) {
+		ok &= emit_string(&e, m->fname1);
+		ok &= emit_string(&e, " ");
+	}
+	ok &= emit_string(&e, "value\n");
+
+	if (m->fname0)
+		ok &= emit_string(&e, "str ");
+	if (m->fname1)
+		ok &= emit_string(&e, "str ");
+	ok &= emit_string(&e, (m->is_string) ? "str\n" : "int\n");
+
+	/* Emit all or nothing. */
+	if (ok) {
+		p->bytes_written = e.buf - e.orig_buf;
+	} else {
+		metricfs_generic_release(inode, filp);
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static int metricfs_version_open(struct inode *inode, struct file *filp)
+{
+	struct metric *m;
+	struct metricfs_file_private *p;
+	int rc = metric_open_helper(inode, filp, METRICFS_VERSION_BUF_SIZE,
+				    &m, &p);
+	if (rc < 0)
+		return rc;
+
+	p->bytes_written = snprintf(p->buf, METRICFS_VERSION_BUF_SIZE,
+				    "1\n");
+
+	if (p->bytes_written >= METRICFS_VERSION_BUF_SIZE) {
+		metricfs_generic_release(inode, filp);
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static int metricfs_values_open(struct inode *inode, struct file *filp)
+{
+	struct metric_emitter e;
+
+	struct metric *m;
+	struct metricfs_file_private *p;
+	int rc = metric_open_helper(inode, filp, METRICFS_VALUES_BUF_SIZE,
+				    &m, &p);
+	if (rc < 0)
+		return rc;
+
+	e.buf = p->buf;
+	e.orig_buf = p->buf;
+	e.size = METRICFS_VALUES_BUF_SIZE;
+	e.metric = m;
+
+	if (m->has_parm) {
+		if (m->emit_fn.emit_parm)
+			(m->emit_fn.emit_parm)(&e, m->eparm);
+	} else {
+		if (m->emit_fn.emit_noparm)
+			(m->emit_fn.emit_noparm)(&e);
+	}
+	p->bytes_written = e.buf - e.orig_buf;
+	return 0;
+}
+
+static ssize_t metricfs_generic_read(struct file *filp, char __user *ubuf,
+				     size_t cnt, loff_t *ppos)
+{
+	struct metricfs_file_private *p =
+			(struct metricfs_file_private *)filp->private_data;
+	return simple_read_from_buffer(ubuf, cnt, ppos, p->buf,
+					p->bytes_written);
+}
+
+static const struct file_operations metricfs_annotations_ops = {
+	.open = metricfs_annotations_open,
+	.read = metricfs_generic_read,
+	.release = metricfs_generic_release,
+};
+
+static const struct file_operations metricfs_fields_ops = {
+	.open = metricfs_fields_open,
+	.read = metricfs_generic_read,
+	.release = metricfs_generic_release,
+};
+
+static const struct file_operations metricfs_values_ops = {
+	.open = metricfs_values_open,
+	.read = metricfs_generic_read,
+	.release = metricfs_generic_release,
+};
+
+static const struct file_operations metricfs_version_ops = {
+	.open = metricfs_version_open,
+	.read = metricfs_generic_read,
+	.release = metricfs_generic_release,
+};
+
+static struct dentry *d_metricfs;
+
+static struct dentry *metricfs_init_dentry(void)
+{
+	static int once;
+
+	if (d_metricfs)
+		return d_metricfs;
+
+	if (!debugfs_initialized())
+		return NULL;
+
+	d_metricfs = debugfs_create_dir("metricfs", NULL);
+
+	if (!d_metricfs && !once) {
+		once = 1;
+		pr_warn("Could not create debugfs directory 'metricfs'\n");
+		return NULL;
+	}
+
+	return d_metricfs;
+}
+
+/* We always cast in and out to struct dentry. */
+struct metricfs_subsys {
+	struct dentry dentry;
+};
+
+static struct dentry *metricfs_create_file(const char *name,
+					   mode_t mode,
+					   struct dentry *parent,
+					   void *data,
+					   const struct file_operations *fops)
+{
+	struct dentry *ret;
+
+	ret = debugfs_create_file(name, mode, parent, data, fops);
+	if (!ret)
+		pr_warn("Could not create debugfs '%s' entry\n", name);
+
+	return ret;
+}
+
+static struct dentry *metricfs_create_dir(const char *name,
+					  struct metricfs_subsys *s)
+{
+	struct dentry *d;
+
+	if (!s)
+		d = d_metricfs;
+	else
+		d = &s->dentry;
+
+	if (!d) {
+		pr_warn("Couldn't create %s, subsys doesn't exist.", name);
+		return NULL;
+	}
+	return debugfs_create_dir(name, d);
+}
+
+static int metricfs_initialized;
+
+struct metric *metric_register(const char *name,
+				struct metricfs_subsys *parent,
+				const char *description,
+				const char *fname0,
+				const char *fname1,
+				void (*fn)(struct metric_emitter *e),
+				bool is_string,
+				bool is_cumulative,
+				struct module *owner)
+{
+	struct metric *m;
+	struct dentry *d, *t;
+
+	if (!metricfs_initialized) {
+		pr_warn("Could not create metric before initing metricfs\n");
+		return NULL;
+	}
+
+	m = kzalloc(sizeof(*m), GFP_KERNEL);
+	if (!m)
+		return NULL;
+
+	d = metricfs_create_dir(name, parent);
+	if (!d) {
+		pr_warn("Could not create dir '%s' in metricfs.\n", name);
+		kfree(m);
+		return NULL;
+	}
+
+	m->description = description;
+	m->fname0 = fname0;
+	m->fname1 = fname1;
+	m->has_parm = false;
+	m->emit_fn.emit_noparm = fn;
+	m->eparm = NULL;
+	m->is_string = is_string;
+	m->is_cumulative = is_cumulative;
+	refcount_set(&m->refcnt, 1);
+	m->owner = owner;
+	m->dentry = d;
+
+
+	mutex_lock(&big_mutex);
+	t = metricfs_create_file("annotations", 0444, d, m,
+					&metricfs_annotations_ops);
+	if (!t)
+		goto done;
+	m->inodes[0] = t->d_inode;
+
+	t = metricfs_create_file("fields", 0444, d, m,
+					&metricfs_fields_ops);
+	if (!t)
+		goto done;
+	m->inodes[1] = t->d_inode;
+
+	t = metricfs_create_file("values", 0444, d, m,
+					&metricfs_values_ops);
+	if (!t)
+		goto done;
+	m->inodes[2] = t->d_inode;
+
+	t = metricfs_create_file("version", 0444, d, m,
+					&metricfs_version_ops);
+	if (!t)
+		goto done;
+	m->inodes[3] = t->d_inode;
+
+done:
+	/* Unregister the metric before anyone calls open() if we had any
+	 * errors on file creation.
+	 */
+	if (!t) {
+		metric_unregister(m);
+		m = NULL;
+	}
+	mutex_unlock(&big_mutex);
+
+	return m;
+}
+EXPORT_SYMBOL(metric_register);
+
+struct metric *metric_register_parm(const char *name,
+				    struct metricfs_subsys *parent,
+				    const char *description,
+				    const char *fname0,
+				    const char *fname1,
+				    void (*fn)(struct metric_emitter *e,
+					       void *parm),
+				    void *eparm,
+				    bool is_string,
+				    bool is_cumulative,
+				    struct module *owner)
+{
+	struct metric *metric =
+		metric_register(name, parent, description,
+				fname0, fname1,
+				(void (*)(struct metric_emitter *))NULL,
+				is_string,
+				is_cumulative, owner);
+	if (metric) {
+		metric->has_parm = true;
+		metric->emit_fn.emit_parm = fn;
+		metric->eparm = eparm;
+	}
+	return metric;
+}
+EXPORT_SYMBOL(metric_register_parm);
+
+void metric_unregister(struct metric *m)
+{
+	/* We have to NULL out the i_private pointers here so that no other
+	 * callers come into open, getting a pointer to the metric that we
+	 * freed.
+	 */
+	mutex_lock(&big_mutex);
+	m->inodes[0]->i_private = NULL;
+	m->inodes[1]->i_private = NULL;
+	m->inodes[2]->i_private = NULL;
+	m->inodes[3]->i_private = NULL;
+	mutex_unlock(&big_mutex);
+
+	debugfs_remove_recursive(m->dentry);
+	metric_put(m);
+}
+EXPORT_SYMBOL(metric_unregister);
+
+struct metricfs_subsys *metricfs_create_subsys(const char *name,
+					       struct metricfs_subsys *parent)
+{
+	struct dentry *d = metricfs_create_dir(name, parent);
+
+	return container_of(d, struct metricfs_subsys, dentry);
+}
+EXPORT_SYMBOL(metricfs_create_subsys);
+
+void metricfs_destroy_subsys(struct metricfs_subsys *s)
+{
+	if (s)
+		debugfs_remove(&s->dentry);
+}
+EXPORT_SYMBOL(metricfs_destroy_subsys);
+
+static void metricfs_presence_fn(struct metric_emitter *e)
+{
+	METRIC_EMIT_INT(e, 1, NULL, NULL);
+}
+METRIC_EXPORT_INT(metricfs_presence, "A basic presence metric.",
+			NULL, NULL, metricfs_presence_fn);
+
+static int __init metricfs_init(void)
+{
+	if (!metricfs_init_dentry())
+		return -ENOMEM;
+	metricfs_initialized = 1;
+
+	/* Create a basic "presence" metric. */
+	metric_init_metricfs_presence(NULL);
+
+	mutex_init(&big_mutex);
+	return 0;
+}
+
+/*
+ * Debugfs should be fine by the time we're at fs_initcall.
+ */
+fs_initcall(metricfs_init);
diff --git a/kernel/metricfs_examples.c b/kernel/metricfs_examples.c
new file mode 100644
index 000000000000..50d891176728
--- /dev/null
+++ b/kernel/metricfs_examples.c
@@ -0,0 +1,151 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/init.h>
+#include <linux/metricfs.h>
+#include <linux/module.h>
+
+/* A metric to force truncation of the values file. "values" files in
+ * metricfs can be at most 64K in size. It truncates to the last record
+ * that fits entirely in the output file.
+ *
+ * Creates a metric with a values file that looks like:
+ * val"0" 0
+ * val"1" 1
+ * val"2" 2
+ * ...
+ * "val"3565" 3565
+ */
+static void more_than_64k_fn(struct metric_emitter *e)
+{
+	char buf[80];
+	int i;
+
+	for (i = 0; i < 10000; i++) {
+		sprintf(buf, "val\"%d\"", i);
+		/* Argument order is (emitter, value, field0, field1...) */
+		METRIC_EMIT_INT(e, i, buf, NULL);
+	}
+}
+METRIC_EXPORT_INT(more_than_64k, "Stress test metric.",
+			"v", NULL, more_than_64k_fn);
+
+
+/* A metric with two string fields and int64 values.
+ *
+ * # cat /sys/kernel/debug/metricfs/two_string_fields/annotations
+ * DESCRIPTION "Two fields example."
+ * # cat /sys/kernel/debug/metricfs/two_string_fields/fields
+ * disk cgroup value
+ * str str int
+ * # cat /sys/kernel/debug/metricfs/two_string_fields/values
+ * sda /map_reduce1 0
+ * sda /sys 50
+ * sdb /map_reduce2 12
+ */
+static void two_string_fields_fn(struct metric_emitter *e)
+{
+#define NR_ENTRIES 3
+	const char *disk[NR_ENTRIES] = {"sda", "sda", "sdb"};
+	const char *cgroups[NR_ENTRIES] = {
+				"/map_reduce1", "/sys", "/map_reduce2"};
+	const int64_t counters[NR_ENTRIES] = {0, 50, 12};
+	int i;
+
+	for (i = 0; i < NR_ENTRIES; i++) {
+		METRIC_EMIT_INT(e,
+				counters[i], disk[i], cgroups[i]);
+	}
+}
+#undef NR_ENTRIES
+METRIC_EXPORT_INT(two_string_fields, "Two fields example.",
+			"disk", "cgroup", two_string_fields_fn);
+
+
+/* A metric with zero fields and a string value.
+ *
+ * # cat /sys/kernel/debug/metricfs/string_valued_metric/annotations
+ * DESCRIPTION "String metric."
+ * # cat /sys/kernel/debug/metricfs/string_valued_metric/fields
+ * value
+ * str
+ * # cat /sys/kernel/debug/metricfs/string_valued_metric/values
+ * Test\ninfo.
+ */
+static void string_valued_metric_fn(struct metric_emitter *e)
+{
+	METRIC_EMIT_STR(e, "Test\ninfo.", NULL, NULL);
+}
+METRIC_EXPORT_STR(string_valued_metric, "String metric.",
+			NULL, NULL, string_valued_metric_fn);
+
+/* Test metric to ensure we behave properly with a large annotation string. */
+static void huge_annotation_fn(struct metric_emitter *e)
+{
+	METRIC_EMIT_STR(e, "test\n", NULL, NULL);
+}
+static const char *huge_annotation_s =
+	"1231231231231231231231231231231241241212895781930750981347503485"
+	"7029348750923847502384750923847590234857902348759023475028934751"
+	"1111111111111112312312312312312312312312312312412412128957819307"
+	"5098134750348570293487509238475023847509238475902348579023487590"
+	"2347502893475 23123123123123123123123123123124124121289578193075"
+	"0981347503485702934875092384750238475092384759023485790234875902"
+	"347502893475 231231231231231231231231231231241241212895781930750"
+	"9813475034857029348750923847502384750923847590234857902348759023"
+	"47502893475 2312312312312312312312312312312412412128957819307509"
+	"8134750348570293487509238475023847509238475902348579023487590234"
+	"7502893475 23123123123123123123123123123124124121289578193075098"
+	"1347503485702934875092384750238475092384759023485790234875902347"
+	"502893475 231231231231231231231231231231241241212895781930750981"
+	"3475034857029348750923847502384750923847590234857902348759023475"
+	"02893475 2312312312312312312312312312312412412128957819307509813"
+	"4750348570293487509238475023847509238475902348579023487590234750"
+	"2893475 23123123123123123123123123123124124121289578193075098134"
+	"7503485702934875092384750238475092384759023485790234875902347502"
+	"893475 231231231231231231231231231231241241212895781930750981347"
+	"5034857029348750923847502384750923847590234857902348759023475028"
+	"93475 2312312312312312312312312312312412412128957819307509813475"
+	"0348570293487509238475023847509238475902348579023487590234750289"
+	"3475 23123123123123123123123123123124124121289578193075098134750"
+	"3485702934875092384750238475092384759023485790234875902347502893"
+	"475 231231231231231231231231231231241241212895781930750981347503"
+	"4857029348750923847502384750923847590234857902348759023475028934"
+	"75 2312312312312312312312312312312412412128957819307509813475034"
+	"8570293487509238475023847509238475902348579023487590234750289347"
+	"5 23123123123123123123123123123124124121289578193075098134750348"
+	"5702934875092384750238475092384759023485790234875902347502893475"
+	" 231231231231231231231231231231241241212895781930750981347503485"
+	"702934875092384750238475092384759023485790234875902347502893475 "
+	"2312312312312312312312312312312412412128957819307509813475034857"
+	"02934875092384750238475092384759023485790234875902347502893475";
+
+METRIC_EXPORT_STR(huge_annotation, huge_annotation_s, NULL, NULL,
+			huge_annotation_fn);
+
+
+struct metricfs_subsys *examples_subsys;
+
+static int __init metricfs_examples_init(void)
+{
+	examples_subsys = metricfs_create_subsys("examples", NULL);
+	metric_init_more_than_64k(examples_subsys);
+	metric_init_two_string_fields(examples_subsys);
+	metric_init_string_valued_metric(examples_subsys);
+	metric_init_huge_annotation(examples_subsys);
+
+	return 0;
+}
+
+static void __exit metricfs_examples_exit(void)
+{
+	metric_exit_more_than_64k();
+	metric_exit_two_string_fields();
+	metric_exit_string_valued_metric();
+	metric_exit_huge_annotation();
+
+	metricfs_destroy_subsys(examples_subsys);
+}
+
+module_init(metricfs_examples_init);
+module_exit(metricfs_examples_exit);
+
+MODULE_LICENSE("GPL");
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 9ad9210d70a1..8de0244e7804 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -325,6 +325,24 @@ config READABLE_ASM
 	  to keep kernel developers who have to stare a lot at assembler listings
 	  sane.
 
+config METRICFS
+	bool "Metricfs for sysmon"
+	depends on DEBUG_FS
+	help
+	  metricfs is a library for creating rigidly-formatted files in debugfs
+	  which can be automatically monitored by user-space telemetry.  The
+	  hierarchy is rooted at /sys/kernel/debug/metricfs, and each metric
+	  contains metadata about the metric and types involved, as well as a
+	  tabular values file with the metrics themselves.
+
+config METRICFS_EXAMPLES
+	tristate "Metricfs examples"
+	depends on METRICFS
+	help
+	  example tests and metrics for metricfs.  With this, a set of metrics
+	  appear under "examples", covering various corner cases of the metricfs
+	  interface.  These can be used to test the metricfs functionality.
+
 config HEADERS_INSTALL
 	bool "Install uapi headers to usr/include"
 	depends on !UML
-- 
2.28.0.236.gb10cc79966-goog

