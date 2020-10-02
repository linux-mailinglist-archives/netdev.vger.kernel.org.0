Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77047280E5A
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 09:58:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726258AbgJBH6I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 03:58:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725961AbgJBH6H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 03:58:07 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BB84C0613D0;
        Fri,  2 Oct 2020 00:58:06 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id s14so484578pju.1;
        Fri, 02 Oct 2020 00:58:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eGi2apwq+yY2Wz5r2zA4Nn/vN1Dv+imyIRYnEmo7Xts=;
        b=mDYEI6enbAQL8gPODEHHIBWXneMktQX7ABDBFCGDgeeP0mbJUGPRjv5WymQA7Iisvf
         5Sd9Ir7Rba39ENzKX3Vyq6WumA4H5Zxocc2AgOuePAz1YiLPAvbSBWJ0BK9mnr0XZtNn
         yrXeuT/prji1b51wegQdRKIcluqGZVtXE/3Ihtv+gAIkMXYJZBT6jdOQhO/kdudhNq9K
         mcEq7SD0P7xpNAvdjsd95YQJzI3EE/J57lcRX9nUQsw5V8zd9ko552R7jJTuUKqbxV/O
         lmfHw99OMj1XfirAwWRxxC60ybVIfZNbTDwNW0Mp5emMiTZJqpYjVwTisX517VjqY+BY
         54IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eGi2apwq+yY2Wz5r2zA4Nn/vN1Dv+imyIRYnEmo7Xts=;
        b=KdsvOEO28Vvi4IEg8fvRj3a3It3ZYNfDFoma1UHx2d89Awl/eW9j7P7xRkgxs+TCxj
         1L1cF6J2VPOc6beywqyE1fhllby9rkCXtyXfafOmkbtTd3MMZBVDBldfA0kyeTuS+729
         utWEmd/ZJQRJQUr1pRfOMaAlNUvkyOiS2uTcsnqi7QZo3XVcLlWcxZUQU0yVKR/2X3qd
         8wJjp+Sn60HoW6G/YDErRJO2Dvfk3WnoFI3MTCFGXErs8ljD4LTqYU5Qf1JYaXlz6jzj
         +QrCuJaW9ukhjOpcBZA1Bqt6xJlFPnokoSpdhJlAz15ukKxyGs4+duVv/g1k/ZiqgR81
         CVew==
X-Gm-Message-State: AOAM532BXXeF2M5JZ9VtGXyhDsUCztOepvEf4A1QL4DLoNsTMITsmsyO
        7rxKyJJGoD+/qaghFEd8gQ2qdFFxOJCZ2g==
X-Google-Smtp-Source: ABdhPJwJKLzOMdxongEoUp/EZDvE1hcIErFPDLh63UvGDfsPMoq1EI5k0plm96j133Q7AgaYojl41A==
X-Received: by 2002:a17:90a:49c8:: with SMTP id l8mr1446849pjm.24.1601625485746;
        Fri, 02 Oct 2020 00:58:05 -0700 (PDT)
Received: from localhost.localdomain.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id w5sm758558pjj.10.2020.10.02.00.58.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2020 00:58:05 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Subject: [PATCH libbpf] libbpf: check if pin_path was set even map fd exist
Date:   Fri,  2 Oct 2020 15:57:50 +0800
Message-Id: <20201002075750.1978298-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Say a user reuse map fd after creating a map manually and set the
pin_path, then load the object via libbpf.

In libbpf bpf_object__create_maps(), bpf_object__reuse_map() will
return 0 if there is no pinned map in map->pin_path. Then after
checking if map fd exist, we should also check if pin_path was set
and do bpf_map__pin() instead of continue the loop.

Fix it by creating map if fd not exist and continue checking pin_path
after that.

Suggested-by: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 tools/lib/bpf/libbpf.c | 75 +++++++++++++++++++++---------------------
 1 file changed, 37 insertions(+), 38 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index e493d6048143..d4149585a76c 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -3861,50 +3861,49 @@ bpf_object__create_maps(struct bpf_object *obj)
 			}
 		}
 
-		if (map->fd >= 0) {
-			pr_debug("map '%s': skipping creation (preset fd=%d)\n",
-				 map->name, map->fd);
-			continue;
-		}
-
-		err = bpf_object__create_map(obj, map);
-		if (err)
-			goto err_out;
-
-		pr_debug("map '%s': created successfully, fd=%d\n", map->name,
-			 map->fd);
-
-		if (bpf_map__is_internal(map)) {
-			err = bpf_object__populate_internal_map(obj, map);
-			if (err < 0) {
-				zclose(map->fd);
+		if (map->fd < 0) {
+			err = bpf_object__create_map(obj, map);
+			if (err)
 				goto err_out;
-			}
-		}
-
-		if (map->init_slots_sz) {
-			for (j = 0; j < map->init_slots_sz; j++) {
-				const struct bpf_map *targ_map;
-				int fd;
 
-				if (!map->init_slots[j])
-					continue;
+			pr_debug("map '%s': created successfully, fd=%d\n", map->name,
+				 map->fd);
 
-				targ_map = map->init_slots[j];
-				fd = bpf_map__fd(targ_map);
-				err = bpf_map_update_elem(map->fd, &j, &fd, 0);
-				if (err) {
-					err = -errno;
-					pr_warn("map '%s': failed to initialize slot [%d] to map '%s' fd=%d: %d\n",
-						map->name, j, targ_map->name,
-						fd, err);
+			if (bpf_map__is_internal(map)) {
+				err = bpf_object__populate_internal_map(obj, map);
+				if (err < 0) {
+					zclose(map->fd);
 					goto err_out;
 				}
-				pr_debug("map '%s': slot [%d] set to map '%s' fd=%d\n",
-					 map->name, j, targ_map->name, fd);
 			}
-			zfree(&map->init_slots);
-			map->init_slots_sz = 0;
+
+			if (map->init_slots_sz) {
+				for (j = 0; j < map->init_slots_sz; j++) {
+					const struct bpf_map *targ_map;
+					int fd;
+
+					if (!map->init_slots[j])
+						continue;
+
+					targ_map = map->init_slots[j];
+					fd = bpf_map__fd(targ_map);
+					err = bpf_map_update_elem(map->fd, &j, &fd, 0);
+					if (err) {
+						err = -errno;
+						pr_warn("map '%s': failed to initialize slot [%d] to map '%s' fd=%d: %d\n",
+							map->name, j, targ_map->name,
+							fd, err);
+						goto err_out;
+					}
+					pr_debug("map '%s': slot [%d] set to map '%s' fd=%d\n",
+						map->name, j, targ_map->name, fd);
+				}
+				zfree(&map->init_slots);
+				map->init_slots_sz = 0;
+			}
+		} else {
+			pr_debug("map '%s': skipping creation (preset fd=%d)\n",
+				 map->name, map->fd);
 		}
 
 		if (map->pin_path && !map->pinned) {
-- 
2.25.4

