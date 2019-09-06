Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69EEEAB334
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 09:31:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404137AbfIFHb4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 03:31:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47358 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732504AbfIFHby (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Sep 2019 03:31:54 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E5144369CC;
        Fri,  6 Sep 2019 07:31:53 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.205.33])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 30AEA600CC;
        Fri,  6 Sep 2019 07:31:52 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>
Subject: [PATCH 3/7] libbpf: Return const btf_enum from btf_enum inline function
Date:   Fri,  6 Sep 2019 09:31:40 +0200
Message-Id: <20190906073144.31068-4-jolsa@kernel.org>
In-Reply-To: <20190906073144.31068-1-jolsa@kernel.org>
References: <20190906073144.31068-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Fri, 06 Sep 2019 07:31:54 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I'm getting following errors when compiling with -Wcast-qual:

  bpf/btf.h: In function ‘btf_enum* btf_enum(const btf_type*)’:
  bpf/btf.h:259:34: warning: cast from type ‘const btf_type*’ to type
  ‘btf_enum*’ casts away qualifier
    259 |  return (struct btf_enum *)(t + 1);
        |                                  ^

The argument is const so the cast to following struct btf_enum
pointer should be const as well. Casting the const away in btf.c
call where it's correctly used without const in deduplication
code.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/lib/bpf/btf.c | 2 +-
 tools/lib/bpf/btf.h | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index d6327bcc713a..5a39e9506760 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -1475,7 +1475,7 @@ static int btf_for_each_str_off(struct btf_dedup *d, str_off_fn_t fn, void *ctx)
 			break;
 		}
 		case BTF_KIND_ENUM: {
-			struct btf_enum *m = btf_enum(t);
+			struct btf_enum *m = (struct btf_enum *) btf_enum(t);
 			__u16 vlen = btf_vlen(t);
 
 			for (j = 0; j < vlen; j++) {
diff --git a/tools/lib/bpf/btf.h b/tools/lib/bpf/btf.h
index 6bbf5772aa61..3b3216fa348f 100644
--- a/tools/lib/bpf/btf.h
+++ b/tools/lib/bpf/btf.h
@@ -254,9 +254,9 @@ static inline const struct btf_array *btf_array(const struct btf_type *t)
 	return (const struct btf_array *)(t + 1);
 }
 
-static inline struct btf_enum *btf_enum(const struct btf_type *t)
+static inline const struct btf_enum *btf_enum(const struct btf_type *t)
 {
-	return (struct btf_enum *)(t + 1);
+	return (const struct btf_enum *)(t + 1);
 }
 
 static inline struct btf_member *btf_members(const struct btf_type *t)
-- 
2.21.0

