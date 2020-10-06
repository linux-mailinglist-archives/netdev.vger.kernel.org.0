Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9790F2843FA
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 04:15:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726299AbgJFCPM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 22:15:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725870AbgJFCPL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Oct 2020 22:15:11 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8694DC0613CE;
        Mon,  5 Oct 2020 19:15:10 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id h2so458486pll.11;
        Mon, 05 Oct 2020 19:15:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hWqIIaC1uC7NQxhIyCinlsHBDl2A45Ctu7K6Zjp49H0=;
        b=OWc3/QOkkYktSNZ2pRDUDfPE6Ri9ODmkc/uR6Jp2a/hRlIBwDuBiG7HnqAjvHvEZeN
         NwIxADhInRTNpYCsuJKfMci9YD47HRI4oq7knjkQbyOJXjMS4YXBUF9nmODjKnZq+xVd
         rYiAG5UfNPo7p0dfcPIXhSzOkeA6Rczgq+MXNFUfp3J9d+mGBRnSD0gkzjIYf4XRPoh1
         B9msu0GZmopCeIEK6ihc4EbSDnh/g4L9pVTnDWu+VKB/GEUMiDZwIUwfTnZqVDfGhYeF
         VGDJklx4eo3Qnzi/wi2OcG4I4dLISIfCslbswC7lokGJowjKtHkES+HaPqr0C6zPLNtr
         tjmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hWqIIaC1uC7NQxhIyCinlsHBDl2A45Ctu7K6Zjp49H0=;
        b=ErXXZpl8QWPbZncyYTrSGuE7mYQhRvec3+UpnFbi/mk0tzIsX75iSsOHDFxtDvY5N2
         G9CNCnUhb0p57rAEP1FtspqlrANI5xyErhm6cagDHDjK7HCSb4pici7WrHVOfEV4WtdF
         4XLmuKPI+wOA7TmRSbYseJKwqVA+nI/75AinYMXPBKhWq5hARp1y/mxa7n7b2+zaL7Dx
         b1COeJIroBa3jyCsUMw/geDyWpEnq5BvEStJ+MhCjj22tVV4cVqBM58IhRUm156xkkmJ
         WbokWyH6tfx0q4LYOif1MwIXyOuVFxWYLp35gqfDn3gDWW4jgkXdXWcTVzfI/wK52O1R
         gn+A==
X-Gm-Message-State: AOAM533ocViHumihFPoKaISyeSqUOt5+rfbdDu9RIjktaW5JgAMajz5B
        obb/bz1zDsC9mr/28Fu3aafyr36TqhUU2g==
X-Google-Smtp-Source: ABdhPJz8D133SuKeC3YTXaO86NM+xqpsvM03Y4KoZ9zqjgBeoBVALkqEDrMWFCKPxdD9zA01SRrGZQ==
X-Received: by 2002:a17:90a:634b:: with SMTP id v11mr1552479pjs.108.1601950509897;
        Mon, 05 Oct 2020 19:15:09 -0700 (PDT)
Received: from localhost.localdomain.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id k9sm1301594pfc.96.2020.10.05.19.15.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2020 19:15:09 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        netdev@vger.kernel.org,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>
Subject: [PATCHv3 bpf 1/3] libbpf: close map fd if init map slots failed
Date:   Tue,  6 Oct 2020 10:13:43 +0800
Message-Id: <20201006021345.3817033-2-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201006021345.3817033-1-liuhangbin@gmail.com>
References: <20201003085505.3388332-1-liuhangbin@gmail.com>
 <20201006021345.3817033-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Previously we forgot to close the map fd if bpf_map_update_elem()
failed during map slot init, which will leak map fd.

Let's move map slot initialization to new function init_map_slots() to
simplify the code. And close the map fd if init slot failed.

Reported-by: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 tools/lib/bpf/libbpf.c | 55 ++++++++++++++++++++++++++----------------
 1 file changed, 34 insertions(+), 21 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 32dc444224d8..c8b5fe45682d 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -4192,6 +4192,36 @@ static int bpf_object__create_map(struct bpf_object *obj, struct bpf_map *map)
 	return 0;
 }
 
+static int init_map_slots(struct bpf_map *map)
+{
+	const struct bpf_map *targ_map;
+	unsigned int i;
+	int fd, err;
+
+	for (i = 0; i < map->init_slots_sz; i++) {
+		if (!map->init_slots[i])
+			continue;
+
+		targ_map = map->init_slots[i];
+		fd = bpf_map__fd(targ_map);
+		err = bpf_map_update_elem(map->fd, &i, &fd, 0);
+		if (err) {
+			err = -errno;
+			pr_warn("map '%s': failed to initialize slot [%d] to map '%s' fd=%d: %d\n",
+				map->name, i, targ_map->name,
+				fd, err);
+			return err;
+		}
+		pr_debug("map '%s': slot [%d] set to map '%s' fd=%d\n",
+			 map->name, i, targ_map->name, fd);
+	}
+
+	zfree(&map->init_slots);
+	map->init_slots_sz = 0;
+
+	return 0;
+}
+
 static int
 bpf_object__create_maps(struct bpf_object *obj)
 {
@@ -4234,28 +4264,11 @@ bpf_object__create_maps(struct bpf_object *obj)
 		}
 
 		if (map->init_slots_sz) {
-			for (j = 0; j < map->init_slots_sz; j++) {
-				const struct bpf_map *targ_map;
-				int fd;
-
-				if (!map->init_slots[j])
-					continue;
-
-				targ_map = map->init_slots[j];
-				fd = bpf_map__fd(targ_map);
-				err = bpf_map_update_elem(map->fd, &j, &fd, 0);
-				if (err) {
-					err = -errno;
-					pr_warn("map '%s': failed to initialize slot [%d] to map '%s' fd=%d: %d\n",
-						map->name, j, targ_map->name,
-						fd, err);
-					goto err_out;
-				}
-				pr_debug("map '%s': slot [%d] set to map '%s' fd=%d\n",
-					 map->name, j, targ_map->name, fd);
+			err = init_map_slots(map);
+			if (err < 0) {
+				zclose(map->fd);
+				goto err_out;
 			}
-			zfree(&map->init_slots);
-			map->init_slots_sz = 0;
 		}
 
 		if (map->pin_path && !map->pinned) {
-- 
2.25.4

