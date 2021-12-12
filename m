Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B35A3471893
	for <lists+netdev@lfdr.de>; Sun, 12 Dec 2021 06:41:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232689AbhLLFSh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Dec 2021 00:18:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231886AbhLLFSg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Dec 2021 00:18:36 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B26ABC061714;
        Sat, 11 Dec 2021 21:18:36 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id d11so2928693pgl.1;
        Sat, 11 Dec 2021 21:18:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=jlIYHo2VQhB5Dy3xMpCTQ53s0lSZWeKnDpK15S71oTQ=;
        b=dwe3LIjddRevbulUQuUHNgZpPiTvqfjPpXbs8UOTe/XezSPsJlNDKPv2sB8pn1YNIK
         x3YZzXdzyty7hZIH4djEm1sksPYSQ8jMWvcANzRTPicPdauERRkWQlhJWAIWjSZ/BssX
         ufF5CTBLiqPg7Z51D5OYBGwJOkh0pYIdohRyaogOxu5IJMIAQ2VG2ih3sQ71UOkWwzpd
         ojeT8reJVeVXo0tXKN+mbhRF3755QLl8ukWlOpi0HKYHW8bGsKN25jODFwc/PrHYb6ZO
         Jw3Aj7tdRTCAhnRWeD5sps0ZOiWnrCKiIXN8GfZsVdqWK2SyXBdw4TQQYFx9k/nSsQGo
         bK+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=jlIYHo2VQhB5Dy3xMpCTQ53s0lSZWeKnDpK15S71oTQ=;
        b=HLteqDdvewaRviTwE5+4juC9vBqdezIKTyvGoCCH6zZyCQpMmxgCBZOYbEQMs4iaUK
         Xy8UenrMIPTotd245IHbw2S/8g8oqemxiJt5eDTjNMO290XMpJBLslyvOweqO3+6fHpU
         0Q9gk1j59lEP5SKvzedtvqaqJS+1tIN0pQR6Wgc5P0mksnVz9ts7knketaaTWogkILb/
         fSwW3pjaDDeChkPC2caNsTcAv9UBniNmdt59JYRvv1jUQ+2gVj2S1Fp0NVaCSVsY/E6X
         r7W5dd45MnCYvYFEFtHitPVG/9KFiXrt2pyHGbfTECtedUIb7UE+pB98eBajMrkNU8NS
         EBhA==
X-Gm-Message-State: AOAM532/yFFkVwkXhwC1/IMDdWcMkWHbV6hsW+XU8l9GFQz1H3tK3CKD
        Az4KoW++SZbqmOsnCoT9K3Q=
X-Google-Smtp-Source: ABdhPJzrPL74goJ1X5fkVuGribEiRNlVPHxHbjDd6iWILZdmpBpdz4ZPZjtCQ+IhVenV6uRja1Eahw==
X-Received: by 2002:a63:d811:: with SMTP id b17mr45635979pgh.562.1639286315487;
        Sat, 11 Dec 2021 21:18:35 -0800 (PST)
Received: from localhost.localdomain ([159.226.95.43])
        by smtp.googlemail.com with ESMTPSA id d9sm2950072pjs.2.2021.12.11.21.18.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Dec 2021 21:18:35 -0800 (PST)
From:   Miaoqian Lin <linmq006@gmail.com>
Cc:     linmq006@gmail.com, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] bpftool: Fix NULL vs IS_ERR() checking for return value of hashmap__new
Date:   Sun, 12 Dec 2021 05:18:09 +0000
Message-Id: <20211212051816.20478-1-linmq006@gmail.com>
X-Mailer: git-send-email 2.17.1
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The hashmap__new() function does not return NULL on errors. It returns
ERR_PTR(-ENOMEM). Using IS_ERR() to check the return value to fix this.

Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
---
 tools/bpf/bpftool/link.c | 2 +-
 tools/bpf/bpftool/map.c  | 2 +-
 tools/bpf/bpftool/pids.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/bpf/bpftool/link.c b/tools/bpf/bpftool/link.c
index 2c258db0d352..0dc402a89cd8 100644
--- a/tools/bpf/bpftool/link.c
+++ b/tools/bpf/bpftool/link.c
@@ -306,7 +306,7 @@ static int do_show(int argc, char **argv)
 	if (show_pinned) {
 		link_table = hashmap__new(hash_fn_for_key_as_id,
 					  equal_fn_for_key_as_id, NULL);
-		if (!link_table) {
+		if (IS_ERR(link_table)) {
 			p_err("failed to create hashmap for pinned paths");
 			return -1;
 		}
diff --git a/tools/bpf/bpftool/map.c b/tools/bpf/bpftool/map.c
index cae1f1119296..af83ae37d247 100644
--- a/tools/bpf/bpftool/map.c
+++ b/tools/bpf/bpftool/map.c
@@ -698,7 +698,7 @@ static int do_show(int argc, char **argv)
 	if (show_pinned) {
 		map_table = hashmap__new(hash_fn_for_key_as_id,
 					 equal_fn_for_key_as_id, NULL);
-		if (!map_table) {
+		if (IS_ERR(map_table)) {
 			p_err("failed to create hashmap for pinned paths");
 			return -1;
 		}
diff --git a/tools/bpf/bpftool/pids.c b/tools/bpf/bpftool/pids.c
index 56b598eee043..6c4767e97061 100644
--- a/tools/bpf/bpftool/pids.c
+++ b/tools/bpf/bpftool/pids.c
@@ -101,7 +101,7 @@ int build_obj_refs_table(struct hashmap **map, enum bpf_obj_type type)
 	libbpf_print_fn_t default_print;
 
 	*map = hashmap__new(hash_fn_for_key_as_id, equal_fn_for_key_as_id, NULL);
-	if (!*map) {
+	if (IS_ERR(*map)) {
 		p_err("failed to create hashmap for PID references");
 		return -1;
 	}
-- 
2.17.1

