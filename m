Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E9D3136B59
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 11:51:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727701AbgAJKun (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 05:50:43 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36616 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727668AbgAJKum (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 05:50:42 -0500
Received: by mail-wm1-f66.google.com with SMTP id p17so1477219wma.1
        for <netdev@vger.kernel.org>; Fri, 10 Jan 2020 02:50:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=k0Aj0VLYUwGMhJ4GNkWeTIBSGefgbFRBwyuWeyL3e58=;
        b=RF9X9I26tgK8y3bpWYudKhQ7JksPz+FHhZfm4yDfFEgxyZ1QLxQ2QNjkVfLs5UYD8V
         e8dMZqb114RYX+j/ab5qJfB5LLSqdv5LiCKKfMpZ1lVT/bSdakwqFHhvpPX9CtUPjQQm
         ckfyUImqwj3TLYY6xdkub5qjdViifW+RLadWg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=k0Aj0VLYUwGMhJ4GNkWeTIBSGefgbFRBwyuWeyL3e58=;
        b=ou68D/ZtsqnmmxePC1IM2IRexzhUilAVTlGASb+GHFbTsCYgnMBjNiJkQlvzBap24F
         2GzvqF2D3XaYGhsL4BbuX7PkJEgQyMFNXFRlm2vhRCNbp7Q/3osekF9ZHHY3Eps53cJl
         TnNdB74SIfMPeGlbAKNqulhfnAo5HFMI8FTBmdhJiIb77Cft7ePHM0RtzBeSVsVrTD0X
         FWw8dQrIRf3bg2HyYJLXLujUz3kj39QSckL4oKHbit1UudjuIxCRfmjIkV3xQSAyEpSp
         J19fhNWEtTagCPDdjUgw/t1cOGxotMAkTc8NSr9hZiqBLAjciKYIRHsYkPDfxtu37608
         uh2Q==
X-Gm-Message-State: APjAAAVAnwItDB7JT9p0hmDyAPvN6/ottJLCrXXdxqNOxYi0F2X1A8kI
        hQAHg89M6z2mOeM7yBXM+OstrQ==
X-Google-Smtp-Source: APXvYqzBeW7j2u73cjVsz15Us1l27ET1S6P39Qtvz4fwAQTRPHoPp/8LgBK3uVLWXz7/i8mVIndttQ==
X-Received: by 2002:a1c:1b15:: with SMTP id b21mr3329645wmb.17.1578653440356;
        Fri, 10 Jan 2020 02:50:40 -0800 (PST)
Received: from cloudflare.com ([176.221.114.230])
        by smtp.gmail.com with ESMTPSA id f16sm1738068wrm.65.2020.01.10.02.50.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2020 02:50:39 -0800 (PST)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Eric Dumazet <edumazet@google.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Martin KaFai Lau <kafai@fb.com>
Subject: [PATCH bpf-next v2 08/11] bpf, sockmap: Let all kernel-land lookup values in SOCKMAP
Date:   Fri, 10 Jan 2020 11:50:24 +0100
Message-Id: <20200110105027.257877-9-jakub@cloudflare.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200110105027.257877-1-jakub@cloudflare.com>
References: <20200110105027.257877-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Don't require the kernel code, like BPF helpers, that needs access to
SOCKMAP map contents to live in the sock_map module. Expose the SOCKMAP
lookup operation to all kernel-land.

Lookup from BPF context is not whitelisted yet. While syscalls have a
dedicated lookup handler.

Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 net/core/sock_map.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 3731191a7d1e..a046c86a8362 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -297,7 +297,7 @@ static struct sock *__sock_map_lookup_elem(struct bpf_map *map, u32 key)
 
 static void *sock_map_lookup(struct bpf_map *map, void *key)
 {
-	return ERR_PTR(-EOPNOTSUPP);
+	return __sock_map_lookup_elem(map, *(u32 *)key);
 }
 
 static void *sock_map_lookup_sys(struct bpf_map *map, void *key)
@@ -961,6 +961,11 @@ static void sock_hash_free(struct bpf_map *map)
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
@@ -1040,7 +1045,7 @@ const struct bpf_map_ops sock_hash_ops = {
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

