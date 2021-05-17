Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA7C3386D55
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 00:54:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344298AbhEQWzb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 18:55:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344157AbhEQWzO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 18:55:14 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1455EC061573
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 15:53:57 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id a4so8077813wrr.2
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 15:53:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ubique-spb-ru.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jVs5W8Q7mp+DFqI9hJt1Fi1/9BKgvTs4LikxRXRXvus=;
        b=YU2HVVdebqEuzumZPGGfdAuMbgnud6qEn8MQhVoGAclEjW/5OpuZvRfsEtXsx7YRA/
         lmAr3j43CQe/3e3g0y2K9LbfQgaPDHnMuDy2WbChP0zisMSdMvjxTGkAH+NmCdA2fe89
         wrRgj4Cj589aiwKJy+2tYpAVhMJRH5RSXYHlsGDmc+y64RpEdKeZo8ya/8791lIqFPub
         Xc+3JMjthhPW/U7nK0edgoDQ6J/tAA7T+zkUyOoJwUGpg19lr6Ixhxai/Xmlqpp8NfJx
         2n3Ylw1vI0dliGoRYE9sDa3x7fID4q9s48oSiBgxNsZX9H7kXlI40kpproqP5d/FzUXo
         lynw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jVs5W8Q7mp+DFqI9hJt1Fi1/9BKgvTs4LikxRXRXvus=;
        b=WqyJlrRfEsyaJ5nXcUJYRVmH3laDWzlyBz0HmQIJqEvhWoHvTf1u86OT9ic1OkhxVF
         yqUpOJzxYsTfAypcqT7goidaitgjrR6VGsFga5SEl1cIEbQJdwPTc71GLCouuAutPZ+2
         oI7woUhGRGOrmgMsNSGvakSBSP6fyB92TIeLIhR0bwvRQUvyyJwaCqL/EZQb8c12Y/sz
         HFwBUVybUiX9gVBDeVjavSOyR6DnvU8JwNJ6sSu6UMRhkLyAXEI/rBrz/HpRXNc2j/w7
         ZrVS35qi6IxjSoUiq9od/DQxKACVVluqXU2GqNBfImH93tS6cgYyzsytCS2WgMPUyGK6
         kMBg==
X-Gm-Message-State: AOAM532tMlJ0Detw8yr427Bu23q/o2sLdTvNmMy+si2GPiu/MYaDexjy
        xJQQKdFZNotV+rXkrcKR+B4P0w==
X-Google-Smtp-Source: ABdhPJxC19PmYktYwqjTZbmfasMsCCINXdBH8ITNp2Xi6MBt5E/GKsHd5n8zxOJy4mDJwzWs4FMHXA==
X-Received: by 2002:a5d:4dcc:: with SMTP id f12mr1394928wru.224.1621292035773;
        Mon, 17 May 2021 15:53:55 -0700 (PDT)
Received: from localhost ([154.21.15.43])
        by smtp.gmail.com with ESMTPSA id t11sm19121827wrz.57.2021.05.17.15.53.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 15:53:55 -0700 (PDT)
From:   Dmitrii Banshchikov <me@ubique.spb.ru>
To:     bpf@vger.kernel.org
Cc:     Dmitrii Banshchikov <me@ubique.spb.ru>, ast@kernel.org,
        davem@davemloft.net, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, rdna@fb.com
Subject: [PATCH bpf-next 10/11] bpfilter: Add handling of setsockopt() calls
Date:   Tue, 18 May 2021 02:53:07 +0400
Message-Id: <20210517225308.720677-11-me@ubique.spb.ru>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210517225308.720677-1-me@ubique.spb.ru>
References: <20210517225308.720677-1-me@ubique.spb.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support of iptables' setsockopt(2).
The parameters of a setsockopt(2) call are passed by struct mbox_request
which contains a type of the setsockopt(2) call and its memory buffer
description.

The typical way to handle hooked setsockopt(2) call is to read the
supplied memory buffer via pvm_read(), process it and write an answer to
the process memory via pvm_write().

Signed-off-by: Dmitrii Banshchikov <me@ubique.spb.ru>
---
 net/bpfilter/Makefile  |   3 +-
 net/bpfilter/sockopt.c | 357 +++++++++++++++++++++++++++++++++++++++++
 net/bpfilter/sockopt.h |  14 ++
 3 files changed, 373 insertions(+), 1 deletion(-)
 create mode 100644 net/bpfilter/sockopt.c
 create mode 100644 net/bpfilter/sockopt.h

diff --git a/net/bpfilter/Makefile b/net/bpfilter/Makefile
index e0090563f2ca..bae14fc9e396 100644
--- a/net/bpfilter/Makefile
+++ b/net/bpfilter/Makefile
@@ -4,7 +4,8 @@
 #
 
 userprogs := bpfilter_umh
-bpfilter_umh-objs := main.o bflog.o io.o map-common.o context.o match.o target.o rule.o table.o
+bpfilter_umh-objs := main.o bflog.o io.o map-common.o context.o match.o target.o rule.o table.o \
+	sockopt.o
 userccflags += -I $(srctree)/tools/include/ -I $(srctree)/tools/include/uapi
 
 ifeq ($(CONFIG_BPFILTER_UMH), y)
diff --git a/net/bpfilter/sockopt.c b/net/bpfilter/sockopt.c
new file mode 100644
index 000000000000..16f0ade203c0
--- /dev/null
+++ b/net/bpfilter/sockopt.c
@@ -0,0 +1,357 @@
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
+
+#include "bflog.h"
+#include "context.h"
+#include "io.h"
+#include "msgfmt.h"
+#include "table-map.h"
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
+	table = table_map_find(&ctx->table_map, info.name);
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
+	table = table_map_find(&ctx->table_map, get_entries.name);
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
+	found = match_ops_map_find(&ctx->match_ops_map, get_revision.name);
+	if (IS_ERR(found)) {
+		BFLOG_DEBUG(ctx, "cannot find match: '%s'\n", get_revision.name);
+		return PTR_ERR(found);
+	}
+
+	return found->revision;
+}
+
+static struct bpfilter_ipt_replace *read_ipt_replace(const struct mbox_request *req)
+{
+	struct bpfilter_ipt_replace *replace;
+	int err;
+
+	if (req->len < sizeof(*replace))
+		return ERR_PTR(-EINVAL);
+
+	replace = malloc(req->len);
+	if (!replace)
+		return ERR_PTR(-ENOMEM);
+
+	err = pvm_read(req->pid, replace, (const void *)req->addr, sizeof(*replace));
+	if (err)
+		goto err_free;
+
+	if (replace->num_counters == 0) {
+		err = -EINVAL;
+		goto err_free;
+	}
+
+	if (replace->num_counters >= INT_MAX / sizeof(struct bpfilter_ipt_counters)) {
+		err = -ENOMEM;
+		goto err_free;
+	}
+
+	replace->name[sizeof(replace->name) - 1] = '\0';
+
+	// TODO: add more checks here
+
+	err = pvm_read(req->pid, replace->entries, (const void *)req->addr + sizeof(*replace),
+		       req->len - sizeof(*replace));
+	if (err)
+		goto err_free;
+
+	return replace;
+
+err_free:
+	free(replace);
+
+	return ERR_PTR(err);
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
+	table = table_map_find(&ctx->table_map, ipt_replace->name);
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
+	err = table_map_update(&ctx->table_map, new_table->name, new_table);
+	if (err) {
+		BFLOG_DEBUG(ctx, "cannot update table map: %s\n", strerror(-err));
+		goto cleanup;
+	}
+
+	list_add_tail(&new_table->list, &ctx->table_list);
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
+	// TODO add more size checks here
+
+	size = info->num_counters * sizeof(info->counters[0]);
+	if (req->len != sizeof(*info) + size) {
+		err = -EINVAL;
+		goto err_free;
+	}
+
+	info->name[sizeof(info->name) - 1] = '\0';
+
+	err = pvm_read(req->pid, info->counters, (const void *)req->addr + sizeof(*info), size);
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
+	table = table_map_find(&ctx->table_map, info->name);
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

