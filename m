Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77EF0AB332
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 09:31:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404347AbfIFHbx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 03:31:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45096 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732504AbfIFHbw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Sep 2019 03:31:52 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D5CFC335C1;
        Fri,  6 Sep 2019 07:31:51 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.205.33])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1ECE0600CC;
        Fri,  6 Sep 2019 07:31:49 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>
Subject: [PATCH 2/7] libbpf: Return const btf_array from btf_array inline function
Date:   Fri,  6 Sep 2019 09:31:39 +0200
Message-Id: <20190906073144.31068-3-jolsa@kernel.org>
In-Reply-To: <20190906073144.31068-1-jolsa@kernel.org>
References: <20190906073144.31068-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Fri, 06 Sep 2019 07:31:52 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I'm getting following errors when compiling with -Wcast-qual:

  bpf/btf.h: In function ‘btf_array* btf_array(const btf_type*)’:
  bpf/btf.h:254:35: warning: cast from type ‘const btf_type*’ to type
  ‘btf_array*’ casts away qualifiers [-Wcast-qual]
    254 |  return (struct btf_array *)(t + 1);
        |                                   ^

The argument is const so the cast to following struct btf_array
pointer should be const as well. Casting the const away in btf.c
calls where it's correctly used without const in deduplication
code.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/lib/bpf/btf.c | 4 ++--
 tools/lib/bpf/btf.h | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index 1aa189a9112a..d6327bcc713a 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -2587,7 +2587,7 @@ static int btf_dedup_ref_type(struct btf_dedup *d, __u32 type_id)
 		break;
 
 	case BTF_KIND_ARRAY: {
-		struct btf_array *info = btf_array(t);
+		struct btf_array *info = (struct btf_array *) btf_array(t);
 
 		ref_type_id = btf_dedup_ref_type(d, info->type);
 		if (ref_type_id < 0)
@@ -2782,7 +2782,7 @@ static int btf_dedup_remap_type(struct btf_dedup *d, __u32 type_id)
 		break;
 
 	case BTF_KIND_ARRAY: {
-		struct btf_array *arr_info = btf_array(t);
+		struct btf_array *arr_info = (struct btf_array *) btf_array(t);
 
 		r = btf_dedup_remap_type_id(d, arr_info->type);
 		if (r < 0)
diff --git a/tools/lib/bpf/btf.h b/tools/lib/bpf/btf.h
index 952e3496467d..6bbf5772aa61 100644
--- a/tools/lib/bpf/btf.h
+++ b/tools/lib/bpf/btf.h
@@ -249,9 +249,9 @@ static inline __u8 btf_int_bits(const struct btf_type *t)
 	return BTF_INT_BITS(*(const __u32 *)(t + 1));
 }
 
-static inline struct btf_array *btf_array(const struct btf_type *t)
+static inline const struct btf_array *btf_array(const struct btf_type *t)
 {
-	return (struct btf_array *)(t + 1);
+	return (const struct btf_array *)(t + 1);
 }
 
 static inline struct btf_enum *btf_enum(const struct btf_type *t)
-- 
2.21.0

