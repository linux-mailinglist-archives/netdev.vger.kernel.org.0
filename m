Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96D404C60B8
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 02:58:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232380AbiB1B70 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Feb 2022 20:59:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232372AbiB1B7Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Feb 2022 20:59:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53E083DDC5
        for <netdev@vger.kernel.org>; Sun, 27 Feb 2022 17:58:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0772FB80D2F
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 01:58:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40CC3C340F2;
        Mon, 28 Feb 2022 01:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646013524;
        bh=abYtWFuf72qUSIeg07hgF7NhwfA4icl5i5Y5YaX9eN0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gw71suKC8glj573lom/CoHsB1DHTR43Igd+7ZuvYy0HI0Oi7n8yyOjy+klwzqmB44
         Ksqks6ci82Zy9Y+a2tIDVtzUrhSLylndWNr5DedLVOWh4rdUfPQHffh10sYOX4Xo+U
         P7QberbtRgGBY63HrF2GFeFaSiRVHpg8iFBEwSR/PY4Ls7iIjK4NnHCRWd9E2OSg7y
         HP/0XEO9Htt1q1L7NzxJ+KulV7jfT9y7FjLjMALVnTUltw8VQu4oWI+XeBj8NRWbGq
         ARY0F8EX3ifQ8rukDrGGaeKJqzI/aJ6lGl5f0f1ivDnchBPKn4SALXLLpylWm9Ci4O
         YUeyifoxBfGWQ==
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, David Ahern <dsahern@kernel.org>
Subject: [PATCH iproute2-next 3/3] bpf: Remove use of bpf_create_map_xattr
Date:   Sun, 27 Feb 2022 18:58:40 -0700
Message-Id: <20220228015840.1413-4-dsahern@kernel.org>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20220228015840.1413-1-dsahern@kernel.org>
References: <20220228015840.1413-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bpf_create_map_xattr is deprecated in v0.7 in favor of bpf_map_create.
bpf_map_create and its bpf_map_create_opts are not available across the
range of v0.1 and up versions of libbpf, so change create_map to use
the bpf syscall directly.

Signed-off-by: David Ahern <dsahern@kernel.org>
---
 lib/bpf_libbpf.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/lib/bpf_libbpf.c b/lib/bpf_libbpf.c
index 921716aec8c6..f4f98caa1e58 100644
--- a/lib/bpf_libbpf.c
+++ b/lib/bpf_libbpf.c
@@ -54,18 +54,18 @@ static const char *get_bpf_program__section_name(const struct bpf_program *prog)
 static int create_map(const char *name, struct bpf_elf_map *map,
 		      __u32 ifindex, int inner_fd)
 {
-	struct bpf_create_map_attr map_attr = {};
-
-	map_attr.name = name;
-	map_attr.map_type = map->type;
-	map_attr.map_flags = map->flags;
-	map_attr.key_size = map->size_key;
-	map_attr.value_size = map->size_value;
-	map_attr.max_entries = map->max_elem;
-	map_attr.map_ifindex = ifindex;
-	map_attr.inner_map_fd = inner_fd;
-
-	return bpf_create_map_xattr(&map_attr);
+	union bpf_attr attr = {};
+
+	attr.map_type = map->type;
+	strlcpy(attr.map_name, name, sizeof(attr.map_name));
+	attr.map_flags = map->flags;
+	attr.key_size = map->size_key;
+	attr.value_size = map->size_value;
+	attr.max_entries = map->max_elem;
+	attr.map_ifindex = ifindex;
+	attr.inner_map_fd = inner_fd;
+
+	return bpf(BPF_MAP_CREATE, &attr, sizeof(attr));
 }
 
 static int create_map_in_map(struct bpf_object *obj, struct bpf_map *map,
-- 
2.24.3 (Apple Git-128)

