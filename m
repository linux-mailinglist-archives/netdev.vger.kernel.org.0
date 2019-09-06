Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E288AAB33A
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 09:32:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404559AbfIFHcC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 03:32:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40936 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404555AbfIFHcB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Sep 2019 03:32:01 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0CF6E307D851;
        Fri,  6 Sep 2019 07:32:01 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.205.33])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3E2B3600CC;
        Fri,  6 Sep 2019 07:31:59 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>
Subject: [PATCH 6/7] libbpf: Return const btf_var from btf_var inline function
Date:   Fri,  6 Sep 2019 09:31:43 +0200
Message-Id: <20190906073144.31068-7-jolsa@kernel.org>
In-Reply-To: <20190906073144.31068-1-jolsa@kernel.org>
References: <20190906073144.31068-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Fri, 06 Sep 2019 07:32:01 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I'm getting following errors when compiling with -Wcast-qual:

  bpf/btf.h: In function ‘btf_var* btf_var(const btf_type*)’:
  bpf/btf.h:296:33: warning: cast from type ‘const btf_type*’ to type
  ‘btf_var*’ casts away qualifiers [-Wcast-qual]
    296 |  return (struct btf_var *)(t + 1);
        |                                 ^

The argument is const so the cast to following struct btf_var
pointer should be const as well.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/lib/bpf/btf.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/btf.h b/tools/lib/bpf/btf.h
index 2817cf7ce2ee..480dbe780fa7 100644
--- a/tools/lib/bpf/btf.h
+++ b/tools/lib/bpf/btf.h
@@ -291,9 +291,9 @@ static inline const struct btf_param *btf_params(const struct btf_type *t)
 	return (const struct btf_param *)(t + 1);
 }
 
-static inline struct btf_var *btf_var(const struct btf_type *t)
+static inline const struct btf_var *btf_var(const struct btf_type *t)
 {
-	return (struct btf_var *)(t + 1);
+	return (const struct btf_var *)(t + 1);
 }
 
 static inline struct btf_var_secinfo *
-- 
2.21.0

