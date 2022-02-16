Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A54124B8426
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 10:26:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232050AbiBPJVU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 04:21:20 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:46628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231161AbiBPJVT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 04:21:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38BC52B101A;
        Wed, 16 Feb 2022 01:21:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF37B61852;
        Wed, 16 Feb 2022 09:21:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DC0FC004E1;
        Wed, 16 Feb 2022 09:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645003267;
        bh=buF3r5NHAfCdypvyrxaEC4Bc4uajweUHN+QTAl039Do=;
        h=From:To:Cc:Subject:Date:From;
        b=gSeLltRjoarypgcXnbV1C+kG48RkviwUFQkHaXgj0XlofgKXE2oQKmUzv4MghyrJ+
         rLXXgEGl9cn0vjFzzP7MBa8ynlFShOEfVkVhbtlKMFnpK9FMjZ2sAVuUcJhlh8XktI
         LGZUw1QC191F2DyMpV6mv5Q3Ug5QStqgheQ/xIqfMOr5ykHUxQ6icx25pgiVKwYV3f
         wGzjwMOkGRrN7luh2JWpofWyOGMeWU0tVWm2sBWPaEL++SkDKBuXZnzkaz7DoraRqf
         3v/8EHZehPXB+jzi+7eQUpa0rlwwZaOjfdScK9D87c7aFDrPMl33ip3sSfyj8E4zkk
         oq+XwZBruU2sA==
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Yinjun Zhang <yinjun.zhang@corigine.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: [PATCH bpf-next] bpftool: Fix pretty print dump for maps without BTF loaded
Date:   Wed, 16 Feb 2022 10:21:02 +0100
Message-Id: <20220216092102.125448-1-jolsa@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The commit e5043894b21f ("bpftool: Use libbpf_get_error() to check error")
fails to dump map without BTF loaded in pretty mode (-p option).

Fixing this by making sure get_map_kv_btf won't fail in case there's
no BTF available for the map.

Cc: Yinjun Zhang <yinjun.zhang@corigine.com>
Fixes: e5043894b21f ("bpftool: Use libbpf_get_error() to check error")
Suggested-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/bpf/bpftool/map.c | 29 +++++++++++++----------------
 1 file changed, 13 insertions(+), 16 deletions(-)

diff --git a/tools/bpf/bpftool/map.c b/tools/bpf/bpftool/map.c
index 7a341a472ea4..8562add7417d 100644
--- a/tools/bpf/bpftool/map.c
+++ b/tools/bpf/bpftool/map.c
@@ -805,29 +805,28 @@ static int maps_have_btf(int *fds, int nb_fds)
 
 static struct btf *btf_vmlinux;
 
-static struct btf *get_map_kv_btf(const struct bpf_map_info *info)
+static int get_map_kv_btf(const struct bpf_map_info *info, struct btf **btf)
 {
-	struct btf *btf = NULL;
+	int err = 0;
 
 	if (info->btf_vmlinux_value_type_id) {
 		if (!btf_vmlinux) {
 			btf_vmlinux = libbpf_find_kernel_btf();
-			if (libbpf_get_error(btf_vmlinux))
+			err = libbpf_get_error(btf_vmlinux);
+			if (err) {
 				p_err("failed to get kernel btf");
+				return err;
+			}
 		}
-		return btf_vmlinux;
+		*btf = btf_vmlinux;
 	} else if (info->btf_value_type_id) {
-		int err;
-
-		btf = btf__load_from_kernel_by_id(info->btf_id);
-		err = libbpf_get_error(btf);
-		if (err) {
+		*btf = btf__load_from_kernel_by_id(info->btf_id);
+		err = libbpf_get_error(*btf);
+		if (err)
 			p_err("failed to get btf");
-			btf = ERR_PTR(err);
-		}
 	}
 
-	return btf;
+	return err;
 }
 
 static void free_map_kv_btf(struct btf *btf)
@@ -862,8 +861,7 @@ map_dump(int fd, struct bpf_map_info *info, json_writer_t *wtr,
 	prev_key = NULL;
 
 	if (wtr) {
-		btf = get_map_kv_btf(info);
-		err = libbpf_get_error(btf);
+		err = get_map_kv_btf(info, &btf);
 		if (err) {
 			goto exit_free;
 		}
@@ -1054,8 +1052,7 @@ static void print_key_value(struct bpf_map_info *info, void *key,
 	json_writer_t *btf_wtr;
 	struct btf *btf;
 
-	btf = get_map_kv_btf(info);
-	if (libbpf_get_error(btf))
+	if (get_map_kv_btf(info, &btf))
 		return;
 
 	if (json_output) {
-- 
2.35.1

