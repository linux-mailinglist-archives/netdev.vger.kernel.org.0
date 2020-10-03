Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF2022822B7
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 10:55:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725829AbgJCIz1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 04:55:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725824AbgJCIz0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Oct 2020 04:55:26 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CB14C0613D0;
        Sat,  3 Oct 2020 01:55:26 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id k8so3157669pfk.2;
        Sat, 03 Oct 2020 01:55:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=S3nfrEarbedDU7+cG2A8GUy+tauzCAIB7UfM/mCIPRU=;
        b=jihCVLBJ0JkeZQ6J3wFulAsQk7dMrt5K/w1OdRYcbqpNAo6mk2sfa+2fcHpYhkCcCx
         HROdYUzvJieHD11EsmP2FVmA3giANUYWZ6pmlkXn4eLTQPJkmMHLmFu45C6g/SsABFXR
         UPE+KGeeKJDMAvyv+uAtJk9CmGxZHtrcooSk583fBMUjf4+zOvC5Qv/m+G+VGRGFIE57
         23r5UZqu5jpZHfW3PWA7dxVDJ6wi0rURR8ZDhCgeokZlO1V2hcYAGgWWZu89QqvUw+Ea
         xUeoerhPnaYIo/V9cWHoLzq6hMlT5kcKNH/XAmU7k1ZpYSkkTsCmRL2GUuuU526nVs23
         FwbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=S3nfrEarbedDU7+cG2A8GUy+tauzCAIB7UfM/mCIPRU=;
        b=tNoQm9PP5DRM50Sgsp3qbYlW8MybcsGZjGKPn4w5iRRZ/Phq70Yvi54RuUMebhZUO9
         +0AY5ErGq7LRyT2vE5soCFWIuPIiJ75lhNDD9XNO/K9B67DNyeq1ScbRzjTOYYlyDoFp
         i7+QKl8I3D1SAGn3g1k4e+6Eg+Yh7y6E0PVAHeL0T6+Gwd5PECxsVtBWokQTJRjtxK5m
         qCI5udVwCYrbWtN+qwn48QhScXF29gG8hEk3hqU5bvtfnHx41rBH0D3rAULKIHlomz3p
         4dz6Urm6kBtq1SgmFDZcNfXJi7iiF9Oz7NR4Hj05AvvBx0PO2p12IY4Q8zfdbaOebwRt
         4S+g==
X-Gm-Message-State: AOAM532g2jXSmBjTsUqHMF+Zo2ZbCWLyRFBdWukP3ocqsKHmWC0nXLg3
        c1e1KK70HyHdINAHdEnqXOLhs9GwJ5bM2A==
X-Google-Smtp-Source: ABdhPJzl5g7SCdzOiQW0AKBLd54FztTafsaGnDmwHpm4+zy8T/pEFhSPISC70f7HE2KWzniLOcvFTA==
X-Received: by 2002:a63:f815:: with SMTP id n21mr5942108pgh.410.1601715325776;
        Sat, 03 Oct 2020 01:55:25 -0700 (PDT)
Received: from localhost.localdomain.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id a15sm4566374pgi.69.2020.10.03.01.55.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Oct 2020 01:55:25 -0700 (PDT)
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
Subject: [PATCHv2 bpf 2/3] libbpf: check if pin_path was set even map fd exist
Date:   Sat,  3 Oct 2020 16:55:04 +0800
Message-Id: <20201003085505.3388332-3-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201003085505.3388332-1-liuhangbin@gmail.com>
References: <20201002075750.1978298-1-liuhangbin@gmail.com>
 <20201003085505.3388332-1-liuhangbin@gmail.com>
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

v2: keep if condition with existing order

Suggested-by: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 tools/lib/bpf/libbpf.c | 37 ++++++++++++++++++-------------------
 1 file changed, 18 insertions(+), 19 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index c8b5fe45682d..1fb3fd733b23 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -4245,29 +4245,28 @@ bpf_object__create_maps(struct bpf_object *obj)
 		if (map->fd >= 0) {
 			pr_debug("map '%s': skipping creation (preset fd=%d)\n",
 				 map->name, map->fd);
-			continue;
-		}
-
-		err = bpf_object__create_map(obj, map);
-		if (err)
-			goto err_out;
+		} else {
+			err = bpf_object__create_map(obj, map);
+			if (err)
+				goto err_out;
 
-		pr_debug("map '%s': created successfully, fd=%d\n", map->name,
-			 map->fd);
+			pr_debug("map '%s': created successfully, fd=%d\n",
+				 map->name, map->fd);
 
-		if (bpf_map__is_internal(map)) {
-			err = bpf_object__populate_internal_map(obj, map);
-			if (err < 0) {
-				zclose(map->fd);
-				goto err_out;
+			if (bpf_map__is_internal(map)) {
+				err = bpf_object__populate_internal_map(obj, map);
+				if (err < 0) {
+					zclose(map->fd);
+					goto err_out;
+				}
 			}
-		}
 
-		if (map->init_slots_sz) {
-			err = init_map_slots(map);
-			if (err < 0) {
-				zclose(map->fd);
-				goto err_out;
+			if (map->init_slots_sz) {
+				err = init_map_slots(map);
+				if (err < 0) {
+					zclose(map->fd);
+					goto err_out;
+				}
 			}
 		}
 
-- 
2.25.4

