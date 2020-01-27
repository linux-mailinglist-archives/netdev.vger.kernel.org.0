Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE15514A4A2
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 14:11:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727590AbgA0NLO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 08:11:14 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:33077 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727025AbgA0NLN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 08:11:13 -0500
Received: by mail-lf1-f67.google.com with SMTP id n25so6157971lfl.0
        for <netdev@vger.kernel.org>; Mon, 27 Jan 2020 05:11:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eC0CkR7IbFG6bDxCz3dMivOibOCCpaaJ3Hu5W6QGrjg=;
        b=tJ+sPj7Vz0gbEnV6wJVNPWyqvGbBupr3Hr1L0OlPU5+WpLLZHKnwaIrcfsy6wW0xgW
         RhGHSuXln1d8DQ9CEzoKbIsiap3YVPC717E+8ffntJwoyWQJspHDnyv+5nVGIm8z8ECH
         pe/Qw874MA8nTueLqhpd5Sg/lq3Q3/X3Ycs34=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eC0CkR7IbFG6bDxCz3dMivOibOCCpaaJ3Hu5W6QGrjg=;
        b=NQg8hgWaOcK1jMs3Xqm/PUUQCevtUR7rwhdrqqnUdNfSfgLT9cT9cM3YHkvr4xO1gc
         UAUWuwE8C5wvAK4LFxPYftoxEI3uQbkrThr4DGZwA4surQh0IkI+hF/Q1xvGu0A5/b+f
         xbTY9nBiK41/HhjOvqxL+pd6mmEYBVo0mOsLAKGZmW+QMKecm1UQRBpzj2ESHa7HuU39
         718hOACvKSFHR8iSJo44FB1+jSKosdOA/Z91uC01tjG7G1d0JyVF3DibJTV7DvO5ZDzf
         BmiDIcZUjroJ02JYrUQoYNFNlf/s5V3NyRUJJVMj+ak07DtQVZCIs5u8a81m4HRCx0Wq
         w0TQ==
X-Gm-Message-State: APjAAAXewmMSEHQWObF1ehEPtGDR1UM2p0u+G74g34oC/2UuPQtfPl9J
        kwHd6Y+5JBVjIDIlVT741PCnhg==
X-Google-Smtp-Source: APXvYqzLgMXpYlkmUZyMlRObE/MZFGz2MqtBCUghAhyndKaZwHfs76SAGY01Urh40n5X1aHQ0wgLTg==
X-Received: by 2002:a19:cc11:: with SMTP id c17mr8028556lfg.161.1580130670986;
        Mon, 27 Jan 2020 05:11:10 -0800 (PST)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id d9sm8129534lja.73.2020.01.27.05.11.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2020 05:11:10 -0800 (PST)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Martin KaFai Lau <kafai@fb.com>
Subject: [PATCH bpf-next v6 08/12] bpf, sockmap: Let all kernel-land lookup values in SOCKMAP
Date:   Mon, 27 Jan 2020 14:10:53 +0100
Message-Id: <20200127131057.150941-9-jakub@cloudflare.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200127131057.150941-1-jakub@cloudflare.com>
References: <20200127131057.150941-1-jakub@cloudflare.com>
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

