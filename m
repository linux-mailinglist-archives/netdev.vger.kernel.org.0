Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEDA9AB338
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 09:32:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404550AbfIFHb7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 03:31:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55664 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404547AbfIFHb6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Sep 2019 03:31:58 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 953C11DA5;
        Fri,  6 Sep 2019 07:31:58 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.205.33])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5F9C760126;
        Fri,  6 Sep 2019 07:31:56 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>
Subject: [PATCH 5/7] libbpf: Return const btf_param from btf_params inline function
Date:   Fri,  6 Sep 2019 09:31:42 +0200
Message-Id: <20190906073144.31068-6-jolsa@kernel.org>
In-Reply-To: <20190906073144.31068-1-jolsa@kernel.org>
References: <20190906073144.31068-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.71]); Fri, 06 Sep 2019 07:31:58 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I'm getting following errors when compiling with -Wcast-qual:

  bpf/btf.h: In function ‘btf_param* btf_params(const btf_type*)’:
  bpf/btf.h:291:35: warning: cast from type ‘const btf_type*’ to type
  ‘btf_param*’ casts away qualifiers [-Wcast-qual]
    291 |  return (struct btf_param *)(t + 1);
        |                                   ^

The argument is const so the cast to following struct btf_param
pointer should be const as well. Casting the const away in btf.c
call where it's correctly used without const in deduplication
code.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/lib/bpf/btf.c | 6 +++---
 tools/lib/bpf/btf.h | 4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index 560d1ae33675..b5121c79fd9f 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -1487,7 +1487,7 @@ static int btf_for_each_str_off(struct btf_dedup *d, str_off_fn_t fn, void *ctx)
 			break;
 		}
 		case BTF_KIND_FUNC_PROTO: {
-			struct btf_param *m = btf_params(t);
+			struct btf_param *m = (struct btf_param *) btf_params(t);
 			__u16 vlen = btf_vlen(t);
 
 			for (j = 0; j < vlen; j++) {
@@ -2622,7 +2622,7 @@ static int btf_dedup_ref_type(struct btf_dedup *d, __u32 type_id)
 		t->type = ref_type_id;
 
 		vlen = btf_vlen(t);
-		param = btf_params(t);
+		param = (struct btf_param *) btf_params(t);
 		for (i = 0; i < vlen; i++) {
 			ref_type_id = btf_dedup_ref_type(d, param->type);
 			if (ref_type_id < 0)
@@ -2811,7 +2811,7 @@ static int btf_dedup_remap_type(struct btf_dedup *d, __u32 type_id)
 	}
 
 	case BTF_KIND_FUNC_PROTO: {
-		struct btf_param *param = btf_params(t);
+		struct btf_param *param = (struct btf_param *) btf_params(t);
 		__u16 vlen = btf_vlen(t);
 
 		r = btf_dedup_remap_type_id(d, t->type);
diff --git a/tools/lib/bpf/btf.h b/tools/lib/bpf/btf.h
index cd1bd018ba8b..2817cf7ce2ee 100644
--- a/tools/lib/bpf/btf.h
+++ b/tools/lib/bpf/btf.h
@@ -286,9 +286,9 @@ static inline __u32 btf_member_bitfield_size(const struct btf_type *t,
 	return kflag ? BTF_MEMBER_BITFIELD_SIZE(m->offset) : 0;
 }
 
-static inline struct btf_param *btf_params(const struct btf_type *t)
+static inline const struct btf_param *btf_params(const struct btf_type *t)
 {
-	return (struct btf_param *)(t + 1);
+	return (const struct btf_param *)(t + 1);
 }
 
 static inline struct btf_var *btf_var(const struct btf_type *t)
-- 
2.21.0

