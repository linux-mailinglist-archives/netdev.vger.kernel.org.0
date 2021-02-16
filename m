Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D35B31C933
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 12:00:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbhBPLAD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 06:00:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbhBPK7v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 05:59:51 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C06AFC061788
        for <netdev@vger.kernel.org>; Tue, 16 Feb 2021 02:58:18 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id v7so12337016wrr.12
        for <netdev@vger.kernel.org>; Tue, 16 Feb 2021 02:58:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=i2yCinIxoFBwLow1XBzdxruWNWA8TGQLQmqlS/4jbqc=;
        b=FmEdQ8d8GxPQx369N6ZOkR3BwvDEXImJV05u2dufOfs9WfqKyH9pm9y2zG6W1L1i6J
         g38eklpk2UJntpaKyYcczEbS0at70uRxtTNOY0DQGAmA9ep/II3tARqWvGtAUC3y6Kfc
         GzkLh5MOkcjWyqKaTubz9OSpWPlzJq3BbrpyE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=i2yCinIxoFBwLow1XBzdxruWNWA8TGQLQmqlS/4jbqc=;
        b=SMuxey8eKw+zhevULak/j6Aabl2K41YA1+migMpwBsYQbn4cSrxmaU6XG2gef0gRjI
         b1VI8Hn6q0ynYLCq8RIqDigG3MHx28i05v1lL99qkoA/6KDxP9U7JKjBPsgrBpJopp7h
         5XmEbAXCox1YnhYElxVnykf0uxULHkdv6cnRDl9oBxZmk7oHBF9qVKcFyU5QthP5dn+P
         Vp9/9+erWpjkRZKe6EGtIABSLn7dYROqbMCGAwwY25MuNsAn1tXumyo1UUwiy3KmUQOJ
         wDFIXhbW83qguSlu2UIRHzUJjffBxtX57Z4DPnc6vucr7L0XssUCWxdDKn4UF1L/6aAm
         wHYA==
X-Gm-Message-State: AOAM532uqLLRVwauoBxPw2gcAnvmUFKL3hsav41ndPIUsSCT6/4TNa6g
        ZG5TiH3dXdhq3/Z5GxEBQoPZaw==
X-Google-Smtp-Source: ABdhPJxg8Srplv+YucwvNv1NCoeTVROtLTTL5owoswv45Q2dRu+KjoCT/2o2Ej7i1B1BSepK/WJeUQ==
X-Received: by 2002:adf:ee84:: with SMTP id b4mr22799029wro.339.1613473097526;
        Tue, 16 Feb 2021 02:58:17 -0800 (PST)
Received: from antares.lan (111.253.187.81.in-addr.arpa. [81.187.253.111])
        by smtp.gmail.com with ESMTPSA id l1sm2820238wmi.48.2021.02.16.02.58.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Feb 2021 02:58:17 -0800 (PST)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        jakub@cloudflare.com
Cc:     kernel-team@cloudflare.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH bpf-next 2/8] bpf: add for_each_bpf_prog helper
Date:   Tue, 16 Feb 2021 10:57:07 +0000
Message-Id: <20210216105713.45052-3-lmb@cloudflare.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210216105713.45052-1-lmb@cloudflare.com>
References: <20210216105713.45052-1-lmb@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a helper to iterate bpf_prog_arrays, which are a hybrid between
and array and a linked list. Hide this behind a for each macro.

Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
---
 include/linux/bpf.h    | 11 +++++------
 include/linux/filter.h |  4 +---
 2 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index cccaef1088ea..875f6bc4bf1d 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1070,6 +1070,9 @@ int bpf_prog_array_copy(struct bpf_prog_array *old_array,
 /* BPF program asks to set CN on the packet. */
 #define BPF_RET_SET_CN						(1 << 0)
 
+#define for_each_bpf_prog(_array, _item, _prog) \
+	for ((_item) = &(_array)->items[0]; ((_prog) = READ_ONCE((_item)->prog)); (_item)++)
+
 #define BPF_PROG_RUN_ARRAY_FLAGS(array, ctx, func, ret_flags)		\
 	({								\
 		struct bpf_prog_array_item *_item;			\
@@ -1080,13 +1083,11 @@ int bpf_prog_array_copy(struct bpf_prog_array *old_array,
 		migrate_disable();					\
 		rcu_read_lock();					\
 		_array = rcu_dereference(array);			\
-		_item = &_array->items[0];				\
-		while ((_prog = READ_ONCE(_item->prog))) {		\
+		for_each_bpf_prog(_array, _item, _prog) {		\
 			bpf_cgroup_storage_set(_item->cgroup_storage);	\
 			func_ret = func(_prog, ctx);			\
 			_ret &= (func_ret & 1);				\
 			*(ret_flags) |= (func_ret >> 1);			\
-			_item++;					\
 		}							\
 		rcu_read_unlock();					\
 		migrate_enable();					\
@@ -1104,11 +1105,9 @@ int bpf_prog_array_copy(struct bpf_prog_array *old_array,
 		_array = rcu_dereference(array);	\
 		if (unlikely(check_non_null && !_array))\
 			goto _out;			\
-		_item = &_array->items[0];		\
-		while ((_prog = READ_ONCE(_item->prog))) {		\
+		for_each_bpf_prog(_array, _item, _prog) {		\
 			bpf_cgroup_storage_set(_item->cgroup_storage);	\
 			_ret &= func(_prog, ctx);	\
-			_item++;			\
 		}					\
 _out:							\
 		rcu_read_unlock();			\
diff --git a/include/linux/filter.h b/include/linux/filter.h
index 3b00fc906ccd..9ed20ff29d9a 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -1376,8 +1376,7 @@ extern struct static_key_false bpf_sk_lookup_enabled;
 		u32 _ret;						\
 									\
 		migrate_disable();					\
-		_item = &(array)->items[0];				\
-		while ((_prog = READ_ONCE(_item->prog))) {		\
+		for_each_bpf_prog(array, _item, _prog) {		\
 			/* restore most recent selection */		\
 			_ctx->selected_sk = _selected_sk;		\
 			_ctx->no_reuseport = _no_reuseport;		\
@@ -1390,7 +1389,6 @@ extern struct static_key_false bpf_sk_lookup_enabled;
 			} else if (_ret == SK_DROP && _all_pass) {	\
 				_all_pass = false;			\
 			}						\
-			_item++;					\
 		}							\
 		_ctx->selected_sk = _selected_sk;			\
 		_ctx->no_reuseport = _no_reuseport;			\
-- 
2.27.0

