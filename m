Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E036AAB33C
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 09:32:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404564AbfIFHcF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 03:32:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36284 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404555AbfIFHcD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Sep 2019 03:32:03 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2CB67308AA11;
        Fri,  6 Sep 2019 07:32:03 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.205.33])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 59D56600CC;
        Fri,  6 Sep 2019 07:32:01 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>
Subject: [PATCH 7/7] libbpf: Return const struct btf_var_secinfo from btf_var_secinfos inline function
Date:   Fri,  6 Sep 2019 09:31:44 +0200
Message-Id: <20190906073144.31068-8-jolsa@kernel.org>
In-Reply-To: <20190906073144.31068-1-jolsa@kernel.org>
References: <20190906073144.31068-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Fri, 06 Sep 2019 07:32:03 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I'm getting following errors when compiling with -Wcast-qual:

  bpf/btf.h: In function ‘btf_var_secinfo* btf_var_secinfos(const btf_type*)’:
  bpf/btf.h:302:41: warning: cast from type ‘const btf_type*’ to type
  ‘btf_var_secinfo*’ casts away qualifiers [-Wcast-qual]
    302 |  return (struct btf_var_secinfo *)(t + 1);
        |                                         ^

The argument is const so the cast to following struct btf_var_secinfo
pointer should be const as well. Casting the const away in btf.c call
where it's correctly used without const in deduplication code.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/lib/bpf/btf.c | 5 +++--
 tools/lib/bpf/btf.h | 4 ++--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index b5121c79fd9f..32527622792d 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -526,7 +526,8 @@ static int btf_fixup_datasec(struct bpf_object *obj, struct btf *btf,
 
 	t->size = size;
 
-	for (i = 0, vsi = btf_var_secinfos(t); i < vars; i++, vsi++) {
+	for (i = 0, vsi = (struct btf_var_secinfo *) btf_var_secinfos(t);
+	     i < vars; i++, vsi++) {
 		t_var = btf__type_by_id(btf, vsi->type);
 		var = btf_var(t_var);
 
@@ -2830,7 +2831,7 @@ static int btf_dedup_remap_type(struct btf_dedup *d, __u32 type_id)
 	}
 
 	case BTF_KIND_DATASEC: {
-		struct btf_var_secinfo *var = btf_var_secinfos(t);
+		struct btf_var_secinfo *var = (struct btf_var_secinfo *) btf_var_secinfos(t);
 		__u16 vlen = btf_vlen(t);
 
 		for (i = 0; i < vlen; i++) {
diff --git a/tools/lib/bpf/btf.h b/tools/lib/bpf/btf.h
index 480dbe780fa7..ecccde0988b1 100644
--- a/tools/lib/bpf/btf.h
+++ b/tools/lib/bpf/btf.h
@@ -296,10 +296,10 @@ static inline const struct btf_var *btf_var(const struct btf_type *t)
 	return (const struct btf_var *)(t + 1);
 }
 
-static inline struct btf_var_secinfo *
+static inline const struct btf_var_secinfo *
 btf_var_secinfos(const struct btf_type *t)
 {
-	return (struct btf_var_secinfo *)(t + 1);
+	return (const struct btf_var_secinfo *)(t + 1);
 }
 
 #ifdef __cplusplus
-- 
2.21.0

