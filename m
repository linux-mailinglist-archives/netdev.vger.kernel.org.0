Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1CD5483EA4
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 10:01:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbiADJBg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 04:01:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbiADJBf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 04:01:35 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60639C061761;
        Tue,  4 Jan 2022 01:01:35 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id x15so26651737plg.1;
        Tue, 04 Jan 2022 01:01:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ctf1mWWuee2eocXQttVjNpLZ1hE7ZOnUoALCiLBOPEA=;
        b=jYMtqxtumplVH2Og2dIphyxiDE6m/XKNJmYAzMiOJ0yekjIHnvYYnH74Nl85Tb77BA
         kjRS7/ZW4BckNOq7iusCoF52A9XFR01wf3YR6tsU4NYUfecpyyoZaTV3WVtgCzOQ9Wz5
         dw38hJrYpQnWlOWTt885knE7M/3IZvjCFYikUowvXmgkHIHeL4ct7cRS5jskJU+RPA2/
         jHMABuZcPAtJJYMKE8UMn4ouJAuDsWeOF7I/QAbwenKYIPqdGSMMWKoWNNjHL4czOJqc
         5CHk5t+fF7TRT0hL9IlxwjJflpgihWc+7YlygOQ6SBYjycXRNlE48/disQ+e62SwsE4J
         pL3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ctf1mWWuee2eocXQttVjNpLZ1hE7ZOnUoALCiLBOPEA=;
        b=svH0SgOracH1nbLt3jW2/YrLVryJP7mp3rlPrg6TYSbZOxNbpivDumwYb6tLLlBT7i
         CUs8alfOJdfN1kijCX/L5IDyqJprO3oabzoYs7HSwSH6qbutYp5iUvGc1aN42tAKgP/q
         wE324iJTFmcw8TmlVkXjXQTAsgKUwtIxmxEmTtx7OYkKA0w6nxAtYAlM5nPqrIQhsZ/Y
         yKHuBDbEeZtBFfMEJoxHromGu9lbpYaGJa6m+y0gXhD/armvZnjLKwD4fgke1hthvG5r
         4or9wdWYo0vq35y8xWdiP2a6BPOZM6Ktgb0Q4wB28qNISKV/hV4DXuF8g4Jrr2vP+VWy
         gy+g==
X-Gm-Message-State: AOAM533ftkMz1h3s+uTQtFk0yCz7l86w/NG+gnQ8uiVY+kSY8IM7nUd3
        iKUcO9F3Jck3YXNjRWLWYJY=
X-Google-Smtp-Source: ABdhPJxhuxgGPpARWIATroqM3eoHGWmimeE0qyxNCFBP1FaICeye0IKsZAui4ZEoWwI6/FX+4xzLOA==
X-Received: by 2002:a17:902:c64b:b0:148:b614:5498 with SMTP id s11-20020a170902c64b00b00148b6145498mr48835956pls.168.1641286894932;
        Tue, 04 Jan 2022 01:01:34 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:823c:b112:bdfb:7ef1])
        by smtp.gmail.com with ESMTPSA id h7sm43019183pfv.35.2022.01.04.01.01.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jan 2022 01:01:34 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        bpf <bpf@vger.kernel.org>, syzbot <syzkaller@googlegroups.com>,
        Yonghong Song <yhs@fb.com>
Subject: [PATCH net] bpf: Add missing map_get_next_key method to bloom filter map
Date:   Tue,  4 Jan 2022 01:01:30 -0800
Message-Id: <20220104090130.3121751-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.448.ga2b2bfdf31-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

It appears map_get_next_key() method is mandatory,
as syzbot is able to trigger a NULL deref in map_get_next_key().

Fixes: 9330986c0300 ("bpf: Add bloom filter map implementation")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Yonghong Song <yhs@fb.com>
---
 kernel/bpf/bloom_filter.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/bpf/bloom_filter.c b/kernel/bpf/bloom_filter.c
index 277a05e9c9849324a277d77eeec12963cc7519b7..34f48058515cfd3f8ea6816ccad1f4a26eba0ebf 100644
--- a/kernel/bpf/bloom_filter.c
+++ b/kernel/bpf/bloom_filter.c
@@ -82,6 +82,12 @@ static int bloom_map_delete_elem(struct bpf_map *map, void *value)
 	return -EOPNOTSUPP;
 }
 
+static int bloom_get_next_key(struct bpf_map *map, void *key,
+			      void *next_key)
+{
+	return -ENOTSUPP;
+}
+
 static struct bpf_map *bloom_map_alloc(union bpf_attr *attr)
 {
 	u32 bitset_bytes, bitset_mask, nr_hash_funcs, nr_bits;
@@ -201,4 +207,5 @@ const struct bpf_map_ops bloom_filter_map_ops = {
 	.map_check_btf = bloom_map_check_btf,
 	.map_btf_name = "bpf_bloom_filter",
 	.map_btf_id = &bpf_bloom_map_btf_id,
+	.map_get_next_key = bloom_get_next_key,
 };
-- 
2.34.1.448.ga2b2bfdf31-goog

