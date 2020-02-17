Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2249B1618A7
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 18:17:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729599AbgBQRRU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 12:17:20 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:58167 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726788AbgBQRRU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 12:17:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581959839;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=qeiA2zNy+KX8mcg4wbgxxGNyHshOOJC4Sg9lsLuNiz0=;
        b=HyTx+hSaO8pHSb8BNsOI4UzjzUWbrAcLnVQm1FeFu5Tjh1Yq4NlQ/CyJ/gyygebuPWAMpG
        wuqSxyCMrb1VcTM+r/uMYMqP+bxLX/F3fXQSf1J1CctyOB5/Mv3HF+8r5kTYFpHjwhdx7o
        rPWP7BTH5J8aIV/asZcxiQy9xclQAQo=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-307-PE-1mdZEOXeOE9pw8HeCUw-1; Mon, 17 Feb 2020 12:17:17 -0500
X-MC-Unique: PE-1mdZEOXeOE9pw8HeCUw-1
Received: by mail-lj1-f198.google.com with SMTP id b3so6083674ljo.23
        for <netdev@vger.kernel.org>; Mon, 17 Feb 2020 09:17:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qeiA2zNy+KX8mcg4wbgxxGNyHshOOJC4Sg9lsLuNiz0=;
        b=i9XvblifgLY6NzxaYECGC8YEhNJxT7C382aL96cV9uUcDhISdRAD8zxutxrpE/tY0s
         byNgi31kS/wP1W5WyQjev+1v9aI+akJqGsgqn9SfSBREyikly86fTkptK/mvbJIbY6gT
         2fsWCVdYmFnd6O2vzNCsC4AOLxbXgt7YXST+CVdIz9GbhSQfC/T4IwmERk24RFU+OseQ
         sAFLhrB6KVKAbdVpB1oylguQaGuvj61iSepgzm8YOlE7YagOU4wNTCEKOofZXtePPzVm
         fbKmGYLXs7nYCF4oF7nkz9XIuDQ5nMrAFlimY05/DnljLVlh2vWatx5aGlfYIM8XFeNA
         uZNA==
X-Gm-Message-State: APjAAAWpJaXJYAB7nMhbycQEqm4+nU9Rl2qYC4o3umZd22f5KUCVugrC
        rh2Fp3XsBc75jPYt90I+oIXpR1VhwPxvZx9eAXB4F2DJZRu1eAHoCNZVu7TLgNm0rcnbcaRVH6M
        j+UdfHFOylLA6P5re
X-Received: by 2002:a2e:8702:: with SMTP id m2mr10741511lji.278.1581959835816;
        Mon, 17 Feb 2020 09:17:15 -0800 (PST)
X-Google-Smtp-Source: APXvYqyT/XRSylcKMU5hkKtXzin0V8eVj+3tuoEYwtYxLeF2KXw8Lvo06GvSDcZZ6TCVSTq5wcEmkA==
X-Received: by 2002:a2e:8702:: with SMTP id m2mr10741501lji.278.1581959835561;
        Mon, 17 Feb 2020 09:17:15 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id k12sm703708lfc.33.2020.02.17.09.17.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Feb 2020 09:17:14 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id A9C3C180365; Mon, 17 Feb 2020 18:17:13 +0100 (CET)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     daniel@iogearbox.net, ast@fb.com
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH bpf] libbpf: Sanitise internal map names so they are not rejected by the kernel
Date:   Mon, 17 Feb 2020 18:17:01 +0100
Message-Id: <20200217171701.215215-1-toke@redhat.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The kernel only accepts map names with alphanumeric characters, underscores
and periods in their name. However, the auto-generated internal map names
used by libbpf takes their prefix from the user-supplied BPF object name,
which has no such restriction. This can lead to "Invalid argument" errors
when trying to load a BPF program using global variables.

Fix this by sanitising the map names, replacing any non-allowed characters
with underscores.

Fixes: d859900c4c56 ("bpf, libbpf: support global data/bss/rodata sections")
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 tools/lib/bpf/libbpf.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 514b1a524abb..7469c7dcc15e 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -24,6 +24,7 @@
 #include <endian.h>
 #include <fcntl.h>
 #include <errno.h>
+#include <ctype.h>
 #include <asm/unistd.h>
 #include <linux/err.h>
 #include <linux/kernel.h>
@@ -1283,7 +1284,7 @@ static size_t bpf_map_mmap_sz(const struct bpf_map *map)
 static char *internal_map_name(struct bpf_object *obj,
 			       enum libbpf_map_type type)
 {
-	char map_name[BPF_OBJ_NAME_LEN];
+	char map_name[BPF_OBJ_NAME_LEN], *p;
 	const char *sfx = libbpf_type_to_btf_name[type];
 	int sfx_len = max((size_t)7, strlen(sfx));
 	int pfx_len = min((size_t)BPF_OBJ_NAME_LEN - sfx_len - 1,
@@ -1292,6 +1293,11 @@ static char *internal_map_name(struct bpf_object *obj,
 	snprintf(map_name, sizeof(map_name), "%.*s%.*s", pfx_len, obj->name,
 		 sfx_len, libbpf_type_to_btf_name[type]);
 
+	/* sanitise map name to characters allowed by kernel */
+	for (p = map_name; *p && p < map_name + sizeof(map_name); p++)
+		if (!isalnum(*p) && *p != '_' && *p != '.')
+			*p = '_';
+
 	return strdup(map_name);
 }
 
-- 
2.25.0

