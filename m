Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BADFC89A3
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 15:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727884AbfJBNab (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 09:30:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39858 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727869AbfJBNaa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Oct 2019 09:30:30 -0400
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com [209.85.208.200])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A3C868763B
        for <netdev@vger.kernel.org>; Wed,  2 Oct 2019 13:30:29 +0000 (UTC)
Received: by mail-lj1-f200.google.com with SMTP id l13so4865684lji.7
        for <netdev@vger.kernel.org>; Wed, 02 Oct 2019 06:30:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=zxVp0oQW9P1sFKHaI9R9o1AFUMKzBOp7SdYP5JimPZo=;
        b=O92C3MYDkJ9yxM4UlO6buWBZfTtTvEBwB+x9ckLUGccMDrwDy4dVYMVIO8nbOsl4MD
         UGZI49+F83WPEylgNyMSKjyaonP21dCdRv8//P/b+oVmk1vHamcA8i7KjUf4r05WogMN
         Os9BGmXIHuOjfjTJxowK2fGG2XzuFeG5GyXdAy6baW1Hw9sjQlx87mmfr0C/laFbyzUH
         +ty0xgVXwTX4B/W5jXKnh9DUXAkyaAEL/vUAf5JJFNLZdcfpOb7ciAR5gIWWChRIij/j
         Clr/1kupS5IjaW5UxbpHUZziVBe+V/LZbwNRngui8OLvNfyZ9Wuc+Ryf5DlFK0BBYPp9
         XMKQ==
X-Gm-Message-State: APjAAAUih/CPO+g6ATW8q+4+BSthV7UyVz3N4Tviwke31xiLUCeI9eq+
        A3wJEU+S/ZYFeFsKseslrIYRZy9rC6NTpILFvzM0auFIvaWbrq8fItEkk91sM5rgz6qldi0T98X
        1tl/pLkcBK3ajtWd/
X-Received: by 2002:a2e:7010:: with SMTP id l16mr2531612ljc.30.1570023027364;
        Wed, 02 Oct 2019 06:30:27 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxEYmgbkp2r9lxcYPcJPq1Rm82i91/W2uU9/3M8voFck9WzQxTtYO4FjuRGn4ap9COXrQn2xA==
X-Received: by 2002:a2e:7010:: with SMTP id l16mr2531601ljc.30.1570023027166;
        Wed, 02 Oct 2019 06:30:27 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id 202sm4772280ljf.75.2019.10.02.06.30.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Oct 2019 06:30:26 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id B0BBD180640; Wed,  2 Oct 2019 15:30:25 +0200 (CEST)
Subject: [PATCH bpf-next 1/9] hashtab: Add new bpf_map_fd_put_value op
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Marek Majkowski <marek@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Date:   Wed, 02 Oct 2019 15:30:25 +0200
Message-ID: <157002302565.1302756.3212597038181844705.stgit@alrua-x1>
In-Reply-To: <157002302448.1302756.5727756706334050763.stgit@alrua-x1>
References: <157002302448.1302756.5727756706334050763.stgit@alrua-x1>
User-Agent: StGit/0.19-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

The fd type maps all resolve the fd into a pointer to the underlying object
when it is inserted into the map, and stores that pointer as the real array
value. The htab code assumes that the map value is this single pointer, and
dereferences it before passing it to the map fd_put_ptr() op.

For xdp chain maps we want to be able to store multiple pointers, so we
need to get the pointer to the map value store, not the dereferenced
pointer to the actual object. So add a new more general
bpf_map_fd_put_value() op that takes the map value instead of the
dereferenced pointer, and use this on map element free.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 include/linux/bpf.h     |    1 +
 kernel/bpf/hashtab.c    |   16 ++++++----------
 kernel/bpf/map_in_map.c |    7 +++++++
 kernel/bpf/map_in_map.h |    1 +
 4 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 5b9d22338606..be3e9e9109c7 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -50,6 +50,7 @@ struct bpf_map_ops {
 	void *(*map_fd_get_ptr)(struct bpf_map *map, struct file *map_file,
 				int fd);
 	void (*map_fd_put_ptr)(void *ptr);
+	void (*map_fd_put_value)(void *value);
 	u32 (*map_gen_lookup)(struct bpf_map *map, struct bpf_insn *insn_buf);
 	u32 (*map_fd_sys_lookup_elem)(void *ptr);
 	void (*map_seq_show_elem)(struct bpf_map *map, void *key,
diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index 22066a62c8c9..113e1286e184 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -87,11 +87,6 @@ static inline void __percpu *htab_elem_get_ptr(struct htab_elem *l, u32 key_size
 	return *(void __percpu **)(l->key + key_size);
 }
 
-static void *fd_htab_map_get_ptr(const struct bpf_map *map, struct htab_elem *l)
-{
-	return *(void **)(l->key + roundup(map->key_size, 8));
-}
-
 static struct htab_elem *get_htab_elem(struct bpf_htab *htab, int i)
 {
 	return (struct htab_elem *) (htab->elems + i * htab->elem_size);
@@ -679,10 +674,10 @@ static void free_htab_elem(struct bpf_htab *htab, struct htab_elem *l)
 {
 	struct bpf_map *map = &htab->map;
 
-	if (map->ops->map_fd_put_ptr) {
-		void *ptr = fd_htab_map_get_ptr(map, l);
+	if (map->ops->map_fd_put_value) {
+		void *value = l->key + round_up(map->key_size, 8);
 
-		map->ops->map_fd_put_ptr(ptr);
+		map->ops->map_fd_put_value(value);
 	}
 
 	if (htab_is_prealloc(htab)) {
@@ -1400,9 +1395,9 @@ static void fd_htab_map_free(struct bpf_map *map)
 		head = select_bucket(htab, i);
 
 		hlist_nulls_for_each_entry_safe(l, n, head, hash_node) {
-			void *ptr = fd_htab_map_get_ptr(map, l);
+			void *value = l->key + round_up(map->key_size, 8);
 
-			map->ops->map_fd_put_ptr(ptr);
+			map->ops->map_fd_put_value(value);
 		}
 	}
 
@@ -1510,6 +1505,7 @@ const struct bpf_map_ops htab_of_maps_map_ops = {
 	.map_delete_elem = htab_map_delete_elem,
 	.map_fd_get_ptr = bpf_map_fd_get_ptr,
 	.map_fd_put_ptr = bpf_map_fd_put_ptr,
+	.map_fd_put_value = bpf_map_fd_put_value,
 	.map_fd_sys_lookup_elem = bpf_map_fd_sys_lookup_elem,
 	.map_gen_lookup = htab_of_map_gen_lookup,
 	.map_check_btf = map_check_no_btf,
diff --git a/kernel/bpf/map_in_map.c b/kernel/bpf/map_in_map.c
index fab4fb134547..1b4e8b6da777 100644
--- a/kernel/bpf/map_in_map.c
+++ b/kernel/bpf/map_in_map.c
@@ -114,6 +114,13 @@ void bpf_map_fd_put_ptr(void *ptr)
 	bpf_map_put(ptr);
 }
 
+void bpf_map_fd_put_value(void *value)
+{
+	void **ptr = value;
+
+	bpf_map_fd_put_ptr(*ptr);
+}
+
 u32 bpf_map_fd_sys_lookup_elem(void *ptr)
 {
 	return ((struct bpf_map *)ptr)->id;
diff --git a/kernel/bpf/map_in_map.h b/kernel/bpf/map_in_map.h
index a507bf6ef8b9..68d1a52e1757 100644
--- a/kernel/bpf/map_in_map.h
+++ b/kernel/bpf/map_in_map.h
@@ -16,6 +16,7 @@ bool bpf_map_meta_equal(const struct bpf_map *meta0,
 void *bpf_map_fd_get_ptr(struct bpf_map *map, struct file *map_file,
 			 int ufd);
 void bpf_map_fd_put_ptr(void *ptr);
+void bpf_map_fd_put_value(void *value);
 u32 bpf_map_fd_sys_lookup_elem(void *ptr);
 
 #endif

