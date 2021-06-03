Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C977C399EB0
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 12:16:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbhFCKSA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 06:18:00 -0400
Received: from mail-wr1-f46.google.com ([209.85.221.46]:43572 "EHLO
        mail-wr1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbhFCKR5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 06:17:57 -0400
Received: by mail-wr1-f46.google.com with SMTP id v23so5246822wrd.10
        for <netdev@vger.kernel.org>; Thu, 03 Jun 2021 03:16:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ubique-spb-ru.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AqoBmwpM3mskBpj4ytwLDL0Bod4MyeUCS+0cjyuGHPs=;
        b=CnrtvE32G9DiEo2EKCwjFh2khsdjCjSeGQgZ/zhmswo8VTJcWfxk2GE3KtHhJ6emwg
         v+5TBgAdVg0h3DGhedoiRjHin7xijcNx3pbaJnNlBeX4b74WF+5b/ITGIdAl+qQBoDun
         t5Y+Os1lXLBX20CJCd2Hdt5lyRroQInlSplHoUnwmRzE+6YO2iF7XD6cn4q72ImIwNg9
         rOBCf8aGdlGioRuoNtK7lHjNHRisE0a3vQGjE5eHz+Rjzc0x1uIC0uvgXzrA1Rc600DA
         nM+CuoHGv1oHYfN2LaAfi137mqo7SsdWAda6XScLd0dzLL5mWd8CPrjr5Q+k8vMCJLGq
         fPdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AqoBmwpM3mskBpj4ytwLDL0Bod4MyeUCS+0cjyuGHPs=;
        b=e4R70CL6zCdiyfGDy4QutrPRg2cG6qPbimbKjk6SHK+qMzotNLjoKwmz4UeZyL0qQS
         0M8UfkARgsFUmZRD4+b5LQ1pY7vAlMbAuw2+lGyg5cK+nFJd/X9alnkNDaHHeRdSUvKc
         CuOh0gNieeA2NLFIiqzfWslYlqpSKkuH6TVyT/VdfhQshwQGFMV8gQPStA3lQZR3RVIy
         3wZZZwhdto/yiKZrEfJoEqILxOeVyc3N52oijyA7M1mBimuq5IGCC9jVp4WhTb5itJy1
         Bz67zMa9xtosZZPQ3OorbCPC80zdV15SZXWBYFafHc0dVmU35gVqM6HQC1F/69YZvyua
         s3+Q==
X-Gm-Message-State: AOAM531yXHrQMYaeDycGlhBo4c20Z1qZN681XTB3xPEap79vhyvKI6sW
        IKQNWw9+P/JJw8/rWHvJoDbxEg==
X-Google-Smtp-Source: ABdhPJwSkIhSqVT26x/8/lIx8Ip3sTyoz4fNAhfE5tZ/ofUBNXAG2e9FQtvk4pJjEcdvFKc5t0cv7A==
X-Received: by 2002:a5d:64e1:: with SMTP id g1mr37655277wri.101.1622715312423;
        Thu, 03 Jun 2021 03:15:12 -0700 (PDT)
Received: from localhost ([154.21.15.43])
        by smtp.gmail.com with ESMTPSA id o9sm2714580wrw.69.2021.06.03.03.15.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jun 2021 03:15:12 -0700 (PDT)
From:   Dmitrii Banshchikov <me@ubique.spb.ru>
To:     bpf@vger.kernel.org
Cc:     Dmitrii Banshchikov <me@ubique.spb.ru>, ast@kernel.org,
        davem@davemloft.net, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, rdna@fb.com
Subject: [PATCH bpf-next v1 09/10] bpfilter: Add handling of setsockopt() calls
Date:   Thu,  3 Jun 2021 14:14:24 +0400
Message-Id: <20210603101425.560384-10-me@ubique.spb.ru>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210603101425.560384-1-me@ubique.spb.ru>
References: <20210603101425.560384-1-me@ubique.spb.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support of iptables' setsockopt(2).
The parameters of a setsockopt(2) call are passed by struct mbox_request
which contains a type of the setsockopt(2) call and its memory buffer
description. The supplied memory buffer is read-written by
process_vm_readv(2)/process_vm_writev(2).

Signed-off-by: Dmitrii Banshchikov <me@ubique.spb.ru>
---
 net/bpfilter/Makefile  |   2 +-
 net/bpfilter/sockopt.c | 409 +++++++++++++++++++++++++++++++++++++++++
 net/bpfilter/sockopt.h |  14 ++
 3 files changed, 424 insertions(+), 1 deletion(-)
 create mode 100644 net/bpfilter/sockopt.c
 create mode 100644 net/bpfilter/sockopt.h

diff --git a/net/bpfilter/Makefile b/net/bpfilter/Makefile
index e16fee837ca0..e5979159ce72 100644
--- a/net/bpfilter/Makefile
+++ b/net/bpfilter/Makefile
@@ -4,7 +4,7 @@
 #
 
 userprogs := bpfilter_umh
-bpfilter_umh-objs := main.o map-common.o context.o match.o target.o rule.o table.o
+bpfilter_umh-objs := main.o map-common.o context.o match.o target.o rule.o table.o sockopt.o
 bpfilter_umh-objs += xt_udp.o
 userccflags += -I $(srctree)/tools/include/ -I $(srctree)/tools/include/uapi
 
diff --git a/net/bpfilter/sockopt.c b/net/bpfilter/sockopt.c
new file mode 100644
index 000000000000..75f36cea4d11
--- /dev/null
+++ b/net/bpfilter/sockopt.c
@@ -0,0 +1,409 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2021 Telegram FZ-LLC
+ */
+
+#define _GNU_SOURCE
+
+#include "sockopt.h"
+
+#include <linux/err.h>
+#include <linux/list.h>
+
+#include <errno.h>
+#include <limits.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/uio.h>
+
+#include "context.h"
+#include "map-common.h"
+#include "match.h"
+#include "msgfmt.h"
+
+static int pvm_read(pid_t pid, void *to, const void *from, size_t count)
+{
+	const struct iovec l_iov = { .iov_base = to, .iov_len = count };
+	const struct iovec r_iov = { .iov_base = (void *)from, .iov_len = count };
+	ssize_t total_bytes;
+
+	total_bytes = process_vm_readv(pid, &l_iov, 1, &r_iov, 1, 0);
+	if (total_bytes == -1)
+		return -errno;
+
+	if (total_bytes != count)
+		return -EFAULT;
+
+	return 0;
+}
+
+static int pvm_read_from_offset(pid_t pid, void *to, const void *from, size_t offset, size_t count)
+{
+	return pvm_read(pid, to + offset, from + offset, count);
+}
+
+static int pvm_write(pid_t pid, void *to, const void *from, size_t count)
+{
+	const struct iovec l_iov = { .iov_base = (void *)from, .iov_len = count };
+	const struct iovec r_iov = { .iov_base = to, .iov_len = count };
+	ssize_t total_bytes;
+
+	total_bytes = process_vm_writev(pid, &l_iov, 1, &r_iov, 1, 0);
+	if (total_bytes == -1)
+		return -errno;
+
+	if (total_bytes != count)
+		return -EFAULT;
+
+	return 0;
+}
+
+static int read_ipt_get_info(const struct mbox_request *req, struct bpfilter_ipt_get_info *info)
+{
+	int err;
+
+	if (req->len != sizeof(*info))
+		return -EINVAL;
+
+	err = pvm_read(req->pid, info, (const void *)req->addr, sizeof(*info));
+	if (err)
+		return err;
+
+	info->name[sizeof(info->name) - 1] = '\0';
+
+	return 0;
+}
+
+static int sockopt_get_info(struct context *ctx, const struct mbox_request *req)
+{
+	struct bpfilter_ipt_get_info info;
+	struct table *table;
+	int err;
+
+	BFLOG_DEBUG(ctx, "handling IPT_SO_GET_INFO\n");
+
+	if (req->len != sizeof(info))
+		return -EINVAL;
+
+	err = read_ipt_get_info(req, &info);
+	if (err) {
+		BFLOG_DEBUG(ctx, "cannot read ipt_get_info: %s\n", strerror(-err));
+		return err;
+	}
+
+	table = map_find(&ctx->table_index.map, info.name);
+	if (IS_ERR(table)) {
+		BFLOG_DEBUG(ctx, "cannot find table: '%s'\n", info.name);
+		return -ENOENT;
+	}
+
+	table_get_info(table, &info);
+
+	return pvm_write(req->pid, (void *)req->addr, &info, sizeof(info));
+}
+
+static int read_ipt_get_entries(const struct mbox_request *req,
+				struct bpfilter_ipt_get_entries *entries)
+{
+	int err;
+
+	if (req->len < sizeof(*entries))
+		return -EINVAL;
+
+	err = pvm_read(req->pid, entries, (const void *)req->addr, sizeof(*entries));
+	if (err)
+		return err;
+
+	entries->name[sizeof(entries->name) - 1] = '\0';
+
+	return 0;
+}
+
+static int sockopt_get_entries(struct context *ctx, const struct mbox_request *req)
+{
+	struct bpfilter_ipt_get_entries get_entries, *entries;
+	struct table *table;
+	int err;
+
+	BFLOG_DEBUG(ctx, "handling IPT_SO_GET_ENTRIES\n");
+
+	err = read_ipt_get_entries(req, &get_entries);
+	if (err) {
+		BFLOG_DEBUG(ctx, "cannot read ipt_get_entries: %s\n", strerror(-err));
+		return err;
+	}
+
+	table = map_find(&ctx->table_index.map, get_entries.name);
+	if (IS_ERR(table)) {
+		BFLOG_DEBUG(ctx, "cannot find table: '%s'\n", get_entries.name);
+		return -ENOENT;
+	}
+
+	if (get_entries.size != table->size) {
+		BFLOG_DEBUG(ctx, "table '%s' get entries size mismatch\n", get_entries.name);
+		return -EINVAL;
+	}
+
+	entries = (struct bpfilter_ipt_get_entries *)req->addr;
+
+	err = pvm_write(req->pid, entries->name, table->name, sizeof(entries->name));
+	if (err)
+		return err;
+
+	err = pvm_write(req->pid, &entries->size, &table->size, sizeof(table->size));
+	if (err)
+		return err;
+
+	return pvm_write(req->pid, entries->entries, table->entries, table->size);
+}
+
+static int read_ipt_get_revision(const struct mbox_request *req,
+				 struct bpfilter_ipt_get_revision *revision)
+{
+	int err;
+
+	if (req->len != sizeof(*revision))
+		return -EINVAL;
+
+	err = pvm_read(req->pid, revision, (const void *)req->addr, sizeof(*revision));
+	if (err)
+		return err;
+
+	revision->name[sizeof(revision->name) - 1] = '\0';
+
+	return 0;
+}
+
+static int sockopt_get_revision_match(struct context *ctx, const struct mbox_request *req)
+{
+	struct bpfilter_ipt_get_revision get_revision;
+	const struct match_ops *found;
+	int err;
+
+	BFLOG_DEBUG(ctx, "handling IPT_SO_GET_REVISION_MATCH\n");
+
+	err = read_ipt_get_revision(req, &get_revision);
+	if (err)
+		return err;
+
+	found = map_find(&ctx->match_ops_map, get_revision.name);
+	if (IS_ERR(found)) {
+		BFLOG_DEBUG(ctx, "cannot find match: '%s'\n", get_revision.name);
+		return PTR_ERR(found);
+	}
+
+	return found->revision;
+}
+
+static int sockopt_get_revision_target(struct context *ctx, const struct mbox_request *req)
+{
+	struct bpfilter_ipt_get_revision get_revision;
+	const struct match_ops *found;
+	int err;
+
+	BFLOG_DEBUG(ctx, "handling IPT_SO_GET_REVISION_TARGET\n");
+
+	err = read_ipt_get_revision(req, &get_revision);
+	if (err)
+		return err;
+
+	found = map_find(&ctx->target_ops_map, get_revision.name);
+	if (IS_ERR(found)) {
+		BFLOG_DEBUG(ctx, "cannot find target: '%s'\n", get_revision.name);
+		return PTR_ERR(found);
+	}
+
+	return found->revision;
+}
+
+static struct bpfilter_ipt_replace *read_ipt_replace(const struct mbox_request *req)
+{
+	struct bpfilter_ipt_replace ipt_header, *ipt_replace;
+	int err;
+
+	if (req->len < sizeof(ipt_header))
+		return ERR_PTR(-EINVAL);
+
+	err = pvm_read(req->pid, &ipt_header, (const void *)req->addr, sizeof(ipt_header));
+	if (err)
+		return ERR_PTR(err);
+
+	if (ipt_header.num_counters == 0)
+		return ERR_PTR(-EINVAL);
+
+	if (ipt_header.num_counters >= INT_MAX / sizeof(struct bpfilter_ipt_counters))
+		return ERR_PTR(-ENOMEM);
+
+	ipt_header.name[sizeof(ipt_header.name) - 1] = '\0';
+
+	ipt_replace = malloc(sizeof(ipt_header) + ipt_header.size);
+	if (!ipt_replace)
+		return ERR_PTR(-ENOMEM);
+
+	memcpy(ipt_replace, &ipt_header, sizeof(ipt_header));
+
+	err = pvm_read_from_offset(req->pid, ipt_replace, (const void *)req->addr,
+				   sizeof(ipt_header), ipt_header.size);
+	if (err) {
+		free(ipt_replace);
+		return ERR_PTR(err);
+	}
+
+	return ipt_replace;
+}
+
+static int sockopt_set_replace(struct context *ctx, const struct mbox_request *req)
+{
+	struct bpfilter_ipt_replace *ipt_replace;
+	struct table *table, *new_table = NULL;
+	int err;
+
+	BFLOG_DEBUG(ctx, "handling IPT_SO_SET_REPLACE\n");
+
+	ipt_replace = read_ipt_replace(req);
+	if (IS_ERR(ipt_replace)) {
+		BFLOG_DEBUG(ctx, "cannot read ipt_replace: %s\n", strerror(-PTR_ERR(ipt_replace)));
+		return PTR_ERR(ipt_replace);
+	}
+
+	table = map_find(&ctx->table_index.map, ipt_replace->name);
+	if (IS_ERR(table)) {
+		err = PTR_ERR(table);
+		BFLOG_DEBUG(ctx, "cannot find table: '%s'\n", ipt_replace->name);
+		goto cleanup;
+	}
+
+	new_table = create_table(ctx, ipt_replace);
+	if (IS_ERR(new_table)) {
+		err = PTR_ERR(new_table);
+		BFLOG_DEBUG(ctx, "cannot read table: %s\n", strerror(-PTR_ERR(new_table)));
+		goto cleanup;
+	}
+
+	// Here be codegen
+	// ...
+	//
+
+	err = map_update(&ctx->table_index.map, new_table->name, new_table);
+	if (err) {
+		BFLOG_DEBUG(ctx, "cannot update table map: %s\n", strerror(-err));
+		goto cleanup;
+	}
+
+	list_add_tail(&new_table->list, &ctx->table_index.list);
+	new_table = table;
+
+cleanup:
+	if (!IS_ERR(new_table))
+		free_table(new_table);
+
+	free(ipt_replace);
+
+	return err;
+}
+
+static struct bpfilter_ipt_counters_info *read_ipt_counters_info(const struct mbox_request *req)
+{
+	struct bpfilter_ipt_counters_info *info;
+	size_t size;
+	int err;
+
+	if (req->len < sizeof(*info))
+		return ERR_PTR(-EINVAL);
+
+	info = malloc(req->len);
+	if (!info)
+		return ERR_PTR(-ENOMEM);
+
+	err = pvm_read(req->pid, info, (const void *)req->addr, sizeof(*info));
+	if (err)
+		goto err_free;
+
+	size = info->num_counters * sizeof(info->counters[0]);
+	if (req->len != sizeof(*info) + size) {
+		err = -EINVAL;
+		goto err_free;
+	}
+
+	info->name[sizeof(info->name) - 1] = '\0';
+
+	err = pvm_read_from_offset(req->pid, info, (const void *)req->addr, sizeof(*info), size);
+	if (err)
+		goto err_free;
+
+	return info;
+
+err_free:
+	free(info);
+
+	return ERR_PTR(err);
+}
+
+static int sockopt_set_add_counters(struct context *ctx, const struct mbox_request *req)
+{
+	struct bpfilter_ipt_counters_info *info;
+	struct table *table;
+	int err = 0;
+
+	BFLOG_DEBUG(ctx, "handling IPT_SO_SET_ADD_COUNTERS\n");
+
+	info = read_ipt_counters_info(req);
+	if (IS_ERR(info)) {
+		err = PTR_ERR(info);
+		BFLOG_DEBUG(ctx, "cannot read ipt_counters_info: %s\n", strerror(-err));
+		goto err_free;
+	}
+
+	table = map_find(&ctx->table_index.map, info->name);
+	if (IS_ERR(table)) {
+		err = PTR_ERR(table);
+		BFLOG_DEBUG(ctx, "cannot find table: '%s'\n", info->name);
+		goto err_free;
+	}
+
+	// TODO handle counters
+
+err_free:
+	free(info);
+
+	return err;
+}
+
+static int handle_get_request(struct context *ctx, const struct mbox_request *req)
+{
+	switch (req->cmd) {
+	case 0:
+		return 0;
+	case BPFILTER_IPT_SO_GET_INFO:
+		return sockopt_get_info(ctx, req);
+	case BPFILTER_IPT_SO_GET_ENTRIES:
+		return sockopt_get_entries(ctx, req);
+	case BPFILTER_IPT_SO_GET_REVISION_MATCH:
+		return sockopt_get_revision_match(ctx, req);
+	case BPFILTER_IPT_SO_GET_REVISION_TARGET:
+		return sockopt_get_revision_target(ctx, req);
+	}
+
+	BFLOG_NOTICE(ctx, "Unexpected SO_GET request: %d\n", req->cmd);
+
+	return -ENOPROTOOPT;
+}
+
+static int handle_set_request(struct context *ctx, const struct mbox_request *req)
+{
+	switch (req->cmd) {
+	case BPFILTER_IPT_SO_SET_REPLACE:
+		return sockopt_set_replace(ctx, req);
+	case BPFILTER_IPT_SO_SET_ADD_COUNTERS:
+		return sockopt_set_add_counters(ctx, req);
+	}
+
+	BFLOG_NOTICE(ctx, "Unexpected SO_SET request: %d\n", req->cmd);
+
+	return -ENOPROTOOPT;
+}
+
+int handle_sockopt_request(struct context *ctx, const struct mbox_request *req)
+{
+	return req->is_set ? handle_set_request(ctx, req) : handle_get_request(ctx, req);
+}
diff --git a/net/bpfilter/sockopt.h b/net/bpfilter/sockopt.h
new file mode 100644
index 000000000000..711c2f295d89
--- /dev/null
+++ b/net/bpfilter/sockopt.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2021 Telegram FZ-LLC
+ */
+
+#ifndef NET_BPFILTER_SOCKOPT_H
+#define NET_BPFILTER_SOCKOPT_H
+
+struct context;
+struct mbox_request;
+
+int handle_sockopt_request(struct context *ctx, const struct mbox_request *req);
+
+#endif // NET_BPFILTER_SOCKOPT_H
-- 
2.25.1

