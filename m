Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6CC62822B6
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 10:55:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725817AbgJCIzY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 04:55:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbgJCIzW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Oct 2020 04:55:22 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4E87C0613E7;
        Sat,  3 Oct 2020 01:55:22 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id g9so1999594pgh.8;
        Sat, 03 Oct 2020 01:55:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3Cq63vVAQgqttSJiTYOC88cJIda331MR96jczDhYXvQ=;
        b=Ssi8vCipS69InurrBShlPBge2sczbFKLxzrF3yr3PIEyeG8hIwonbj6J1wXkU2hoGj
         RM9T2Kgjp51+5nql4jDCBT/OQN3e8Bq1cF6LrF/6KUpEncG0uicsUAAPkRPNlyqJNr3E
         phwmQIFESBOijFk+4awCXJjNVYxRBL0gZf0tCTibJ9PYmODNUCDhiwdYZg0ZYpnJzPSz
         vNpQcRVL5zAYMsVxOEqtu02BpU4dggSxNXRbbAOMHzE3gn4QgapIbFPD7DuYCjcLoIlr
         3qBIVxxkgKfJMrMmuwHM5TlK5l5jlrpaPJluTwgxdEC1mr/7q9DF4DhN2M+1a+XVZO9+
         0a4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3Cq63vVAQgqttSJiTYOC88cJIda331MR96jczDhYXvQ=;
        b=G3KphFWaCNQUwAtTL/K1REcswFNYHntY+eDEutG1ExroG9lXlMyAp/pKTVMoSXTALt
         IF5MOSpu7rLdNbzON+94+U58jO8Ws97PngDurCEADqZSkUCQ7JSYliWWpZtiXbtaZKq/
         tjBjE53Q8PMfT2hTK9bEfptdtuAC3tXIEXdfNKj9RCrFYyu4CMyofPEgwlF/vQKPSdGB
         Wr/crCOjZqfPtc9XNPNOKttwXUhd9D1/NH9NzOtxSrazrttyo28ysemrlY6yH9NlKVAm
         DH2WvPoZM8AIIq31EmmC8K3I0/c/6zecKCocvnu7+scVq+iDYTiF5eaDc/21XBmEoRHz
         vIow==
X-Gm-Message-State: AOAM530nU1s9IwOswa3BAjXrvoBIAxKtgqRpx4oF9tOxwAJWADRRCmIm
        RxMAIhC3JzHP0vseflqTmS6d0pcxug1REg==
X-Google-Smtp-Source: ABdhPJyMwOFioky4ETcrvGXkDk/ggxiQbPp1COij9F+19ekRrntUvSWH5dOwx8g/yoe4pTeoChpD1A==
X-Received: by 2002:a62:1b86:0:b029:13e:d13d:a05b with SMTP id b128-20020a621b860000b029013ed13da05bmr6745167pfb.33.1601715322201;
        Sat, 03 Oct 2020 01:55:22 -0700 (PDT)
Received: from localhost.localdomain.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id a15sm4566374pgi.69.2020.10.03.01.55.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Oct 2020 01:55:21 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        netdev@vger.kernel.org,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv2 bpf 1/3] libbpf: close map fd if init map slots failed
Date:   Sat,  3 Oct 2020 16:55:03 +0800
Message-Id: <20201003085505.3388332-2-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201003085505.3388332-1-liuhangbin@gmail.com>
References: <20201002075750.1978298-1-liuhangbin@gmail.com>
 <20201003085505.3388332-1-liuhangbin@gmail.com>
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

