Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9971F27BB71
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 05:20:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727212AbgI2DUO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 23:20:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726396AbgI2DUN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 23:20:13 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8C63C061755;
        Mon, 28 Sep 2020 20:20:13 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id q123so3178699pfb.0;
        Mon, 28 Sep 2020 20:20:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WtWwqXcT737XkNAJYLifSS4DuG/5VpYPU04Ao8s5w7E=;
        b=NcfQvZK/j7VM4N/i6Aw82YgiQ8k8gnx2zZFZlY8MTq3Gqp+dDAqg5sEDUXTm3EdmHJ
         BsAOrOaOHFvUAGMsUzNfwTAeKWUA147DeDsIHNTimbYVa8ieYddUlL9giX54p8qNBmbs
         nc7MKJnjqLdk4FrL4G2rb5ykx8zxDpASKrkezFYOtAX69Q4ZcRsRlgUhZ9mB2wc5Njbr
         sOnQqcpwYJRDF3pCA9OG1+NUZW3C36yNvZvYK9VKVMmRE99ouQ7lzRycKCi10k4KR2YN
         nSveHiFgTa9g2UmyY7v7oaDF9xk3ZFTLy07Gix115BWiqNWa9Z1SxIYk3o0TU/W1IkFt
         onOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WtWwqXcT737XkNAJYLifSS4DuG/5VpYPU04Ao8s5w7E=;
        b=EHmfq0jAjAnUDdnPVITFKnjJiVTVIg804E7bLVjV6yhDABlPEWbs8LE5UkwnsUPWK/
         8WZvaZU68K/cJDA8jR2CzzbH8hEu4DBJQ8jF2KlM2JUtdj3H4fBiTFCLZIV8v2GUSBHf
         24R36Unpeh2DVyWOMe8ilAJyrAE0bteh1+Q5zPA+PdOKdcRlClUFodpuOJ7xB+GQHVc2
         eVKIZD1aenP7F1SsvuJihwNJJx8rOsbyN1r4BkT2XVopBkvTmVNOA8HWET0F1GRhDf9F
         sJYYimkx+ka3qriWR9astromfl3Ewzd/XgchNtGqA3Fwb0g6G6kZ6qkrV2me2iIWF6Ig
         OgaQ==
X-Gm-Message-State: AOAM5300bsPaA9MmLco7j2bkrweBkOlzMx2EDPRbIPqF0vaizlTVpdux
        YpyrCA/GLH5ZhbWcdo7A5Ihf+JYfK9S1zrJr
X-Google-Smtp-Source: ABdhPJwcJpH2etDJh3eagS4stkeorytvsmW8AU46r8VtIg9WeKdy9oxnZYlbM7ZzG3ipSY/N3kLbrA==
X-Received: by 2002:a17:902:c404:b029:d2:564a:e41d with SMTP id k4-20020a170902c404b02900d2564ae41dmr2381493plk.23.1601349613020;
        Mon, 28 Sep 2020 20:20:13 -0700 (PDT)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id r16sm2685292pjo.19.2020.09.28.20.20.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2020 20:20:12 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH bpf-next] libbpf: export bpf_object__reuse_map() to libbpf api
Date:   Tue, 29 Sep 2020 11:18:45 +0800
Message-Id: <20200929031845.751054-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Besides bpf_map__reuse_fd(), which could let us reuse existing map fd.
bpf_object__reuse_map() could let us reuse existing pinned maps, which
is helpful.

This functions could also be used when we add iproute2 libbpf support,
so we don't need to re-use or re-implement new functions like
bpf_obj_get()/bpf_map_selfcheck_pinned() in iproute2.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 tools/lib/bpf/libbpf.c | 3 +--
 tools/lib/bpf/libbpf.h | 1 +
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 32dc444224d8..e835d7a3437f 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -4033,8 +4033,7 @@ static bool map_is_reuse_compat(const struct bpf_map *map, int map_fd)
 		map_info.map_flags == map->def.map_flags);
 }
 
-static int
-bpf_object__reuse_map(struct bpf_map *map)
+int bpf_object__reuse_map(struct bpf_map *map)
 {
 	char *cp, errmsg[STRERR_BUFSIZE];
 	int err, pin_fd;
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index a750f67a23f6..4b9e615eb393 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -431,6 +431,7 @@ bpf_map__prev(const struct bpf_map *map, const struct bpf_object *obj);
 /* get/set map FD */
 LIBBPF_API int bpf_map__fd(const struct bpf_map *map);
 LIBBPF_API int bpf_map__reuse_fd(struct bpf_map *map, int fd);
+LIBBPF_API int bpf_object__reuse_map(struct bpf_map *map);
 /* get map definition */
 LIBBPF_API const struct bpf_map_def *bpf_map__def(const struct bpf_map *map);
 /* get map name */
-- 
2.25.4

