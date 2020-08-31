Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE65A257113
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 02:03:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726459AbgHaADZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Aug 2020 20:03:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726396AbgHaADY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Aug 2020 20:03:24 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3ADAC061573;
        Sun, 30 Aug 2020 17:03:23 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id mt12so2203374pjb.4;
        Sun, 30 Aug 2020 17:03:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VMDHtOS8YlHXPnzZc7eh+Kh58CtBgfBUxf6XV1KPMeY=;
        b=pddHhBqHE+kGfFhrWuX+XAEeQE/tkqI15izclQ4EszUXC07BnlweTLLRYOPkQ/eC5x
         RpCeAqvkyVZtisCkCHFieG6Olcmnxf4V/UqxwwDNzs9Qykds6iN9bpOT3Zp1ROUJC7az
         F258I5nFWdxiJSdmRdb55YHirGcD78QLmzJlijgZFEjJP5WGZkv6DYK4BmL5Eea//o4Y
         O2zElJxc7wWMaiFevwYpVFCEyYIG0LQ2jkZVfVNkctO9fscmHj+mWSftTpdXWIc6UmJB
         Te1cxaEHboZwBDx+U3o+HgGpp6AbAB5Qs2psmMeUhxjOEKqDdOUIRGzLN4ry+LrEOKMW
         9WPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VMDHtOS8YlHXPnzZc7eh+Kh58CtBgfBUxf6XV1KPMeY=;
        b=PEtkLazzAoapTuH0Z/fcP4ZJ/B/eCe4jbsU70awZdQVF1tRd8/7NRq3Y1WSw9/khV6
         L9imKZRIb55uavaDkyxYocXe7943kr/U0TVK63KJCv6gPGJy9F17EIbB1angjCfefst3
         JtZfRxokBGZjoSwhMDfefb/ebgI1ALhDEJGUJPNX2IveYeR9GF6YC0H9CcDNPaxl2LAa
         0LPmEpHm7cWLoFKr++MUmKbOGB78TTy4JulSIiINUDHZwDW+oolLtdPiCxMyp2wjZWra
         0gAqrARrBFrT5gff9MlvwrkbwTaaxWTDUEgpilPmTbue7NUYJ8gFqagWR8mSuLEN0Du4
         EHqg==
X-Gm-Message-State: AOAM533p10JZB1kOVfYvnPbSFyyabTuhGKlVDoBG89/aU0oEa9K7fohi
        r1Rn5047NtMQ6XrmpLkIk6w=
X-Google-Smtp-Source: ABdhPJw8VDr2xk3YqzXRL4DZ8QHpt3WTt3QTAMMlDl9+CNUmImPs6jb1hLUvbDuUP1P5qS6YSmSCDg==
X-Received: by 2002:a17:90b:1b09:: with SMTP id nu9mr7947999pjb.214.1598832203367;
        Sun, 30 Aug 2020 17:03:23 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:e92d:10:a55f:6c1b:322e:f753])
        by smtp.gmail.com with ESMTPSA id g17sm5773585pge.9.2020.08.30.17.03.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Aug 2020 17:03:22 -0700 (PDT)
From:   Tony Ambardar <tony.ambardar@gmail.com>
X-Google-Original-From: Tony Ambardar <Tony.Ambardar@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Tony Ambardar <Tony.Ambardar@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH bpf v1] libbpf: fix build failure from uninitialized variable warning
Date:   Sun, 30 Aug 2020 17:03:04 -0700
Message-Id: <20200831000304.1696435-1-Tony.Ambardar@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While compiling libbpf, some GCC versions (at least 8.4.0) have difficulty
determining control flow and a emit warning for potentially uninitialized
usage of 'map', which results in a build error if using "-Werror":

In file included from libbpf.c:56:
libbpf.c: In function '__bpf_object__open':
libbpf_internal.h:59:2: warning: 'map' may be used uninitialized in this function [-Wmaybe-uninitialized]
  libbpf_print(level, "libbpf: " fmt, ##__VA_ARGS__); \
  ^~~~~~~~~~~~
libbpf.c:5032:18: note: 'map' was declared here
  struct bpf_map *map, *targ_map;
                  ^~~

The warning/error is false based on code inspection, so silence it with a
NULL initialization.

Fixes: 646f02ffdd49 ("libbpf: Add BTF-defined map-in-map support")
Ref: 063e68813391 ("libbpf: Fix false uninitialized variable warning")

Signed-off-by: Tony Ambardar <Tony.Ambardar@gmail.com>
---
 tools/lib/bpf/libbpf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index b688aadf09c5..46d727b45c81 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -5804,8 +5804,8 @@ static int bpf_object__collect_map_relos(struct bpf_object *obj,
 	int i, j, nrels, new_sz;
 	const struct btf_var_secinfo *vi = NULL;
 	const struct btf_type *sec, *var, *def;
+	struct bpf_map *map = NULL, *targ_map;
 	const struct btf_member *member;
-	struct bpf_map *map, *targ_map;
 	const char *name, *mname;
 	Elf_Data *symbols;
 	unsigned int moff;
-- 
2.25.1

