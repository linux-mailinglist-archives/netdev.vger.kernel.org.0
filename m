Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FDFC14A447
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 13:56:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726772AbgA0M4E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 07:56:04 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:44861 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726569AbgA0Mzv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 07:55:51 -0500
Received: by mail-lj1-f194.google.com with SMTP id q8so10504590ljj.11
        for <netdev@vger.kernel.org>; Mon, 27 Jan 2020 04:55:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eC0CkR7IbFG6bDxCz3dMivOibOCCpaaJ3Hu5W6QGrjg=;
        b=Y8DmGmBOBARcKoKVntkslzGfDEybnqtXWVcNiy1c3OA2IBMf5Lak2xU9gxmvidUPea
         9s1cLdP8INsLwhJ3J9i6ucAoOpQc0EN175daa993TqHOoHPU8oBbZWjHzYjVIoHCTbRx
         LiTJyePxhS/I79s6jGQZGAB8VdgXgNw3RAegs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eC0CkR7IbFG6bDxCz3dMivOibOCCpaaJ3Hu5W6QGrjg=;
        b=Z8Re0cw6QhsQfncTcobR0eNWxqrfRkL05cfEHEGwxWBCA3MMIqX9nFcdvExY+kD3LT
         JeeCe79nzAYtLxT6nYn7qYLG3LK2YozLcOLGpnGx/6HW8Y9WkuREekMIOsTBroqMH7fv
         JsoJsQr51AgolDFfNg9JXvjvEglywC9CqrJJkMPmSpTSa3GRHs6/A6x4bSl3RJoGrRQu
         BMwvPHHNaZmz/klGVtZKFDW7hMBkey7YNes5Rd0erfwbOZlJLUcCJmeuZ6tA10HJZLp1
         Yo8VgaiQalyMAQkUi2SVZhwXrRjirHcwLcqqwSItrbnBur7sq5EUJlb5DGkUw2AzlDt5
         WsTQ==
X-Gm-Message-State: APjAAAVMyKrH3JRzHNVNX0/mnglTHd4DVlDxeovJdq0Ord3xYiZIpJ8/
        UyAB11NSM2jDDANL6rs2naY40A==
X-Google-Smtp-Source: APXvYqzFwIouLUOSlzfAtQupujoyLs+otnLU8/OKBP1gc7S0nKmo4kvPvZtbgQiNLtCdFSvWlqHhlw==
X-Received: by 2002:a2e:914d:: with SMTP id q13mr10091410ljg.198.1580129748857;
        Mon, 27 Jan 2020 04:55:48 -0800 (PST)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id b13sm7998342lfi.77.2020.01.27.04.55.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2020 04:55:48 -0800 (PST)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Martin KaFai Lau <kafai@fb.com>
Subject: [PATCH bpf-next v5 08/12] bpf, sockmap: Let all kernel-land lookup values in SOCKMAP
Date:   Mon, 27 Jan 2020 13:55:30 +0100
Message-Id: <20200127125534.137492-9-jakub@cloudflare.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200127125534.137492-1-jakub@cloudflare.com>
References: <20200127125534.137492-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Don't require the kernel code, like BPF helpers, that needs access to
SOCKMAP map contents to live in net/core/sock_map.c. Expose the SOCKMAP
lookup operation to all kernel-land.

Lookup from BPF context is not whitelisted yet. While syscalls have a
dedicated lookup handler.

Acked-by: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 net/core/sock_map.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 71d0a21e6db1..2cbde385e1a0 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -300,7 +300,7 @@ static struct sock *__sock_map_lookup_elem(struct bpf_map *map, u32 key)
 
 static void *sock_map_lookup(struct bpf_map *map, void *key)
 {
-	return ERR_PTR(-EOPNOTSUPP);
+	return __sock_map_lookup_elem(map, *(u32 *)key);
 }
 
 static void *sock_map_lookup_sys(struct bpf_map *map, void *key)
@@ -969,6 +969,11 @@ static void sock_hash_free(struct bpf_map *map)
 	kfree(htab);
 }
 
+static void *sock_hash_lookup(struct bpf_map *map, void *key)
+{
+	return ERR_PTR(-EOPNOTSUPP);
+}
+
 static void sock_hash_release_progs(struct bpf_map *map)
 {
 	psock_progs_drop(&container_of(map, struct bpf_htab, map)->progs);
@@ -1048,7 +1053,7 @@ const struct bpf_map_ops sock_hash_ops = {
 	.map_get_next_key	= sock_hash_get_next_key,
 	.map_update_elem	= sock_hash_update_elem,
 	.map_delete_elem	= sock_hash_delete_elem,
-	.map_lookup_elem	= sock_map_lookup,
+	.map_lookup_elem	= sock_hash_lookup,
 	.map_release_uref	= sock_hash_release_progs,
 	.map_check_btf		= map_check_no_btf,
 };
-- 
2.24.1

