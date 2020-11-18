Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEC342B8665
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 22:15:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726787AbgKRVOE convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 18 Nov 2020 16:14:04 -0500
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:60089 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726234AbgKRVOE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 16:14:04 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-174-eaZ1Bnb6M82RkuCO0PUdVQ-1; Wed, 18 Nov 2020 16:13:57 -0500
X-MC-Unique: eaZ1Bnb6M82RkuCO0PUdVQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D102464092;
        Wed, 18 Nov 2020 21:13:54 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.192.157])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8CBB760853;
        Wed, 18 Nov 2020 21:13:51 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     Tony Ambardar <tony.ambardar@gmail.com>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Aurelien Jarno <aurelien@aurel32.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: [PATCH] libbpf: Fix VERSIONED_SYM_COUNT number parsing
Date:   Wed, 18 Nov 2020 22:13:50 +0100
Message-Id: <20201118211350.1493421-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=jolsa@kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We remove "other info" from "readelf -s --wide" output when
parsing GLOBAL_SYM_COUNT variable, which was added in [1].
But we don't do that for VERSIONED_SYM_COUNT and it's failing
the check_abi target on powerpc Fedora 33.

The extra "other info" wasn't problem for VERSIONED_SYM_COUNT
parsing until commit [2] added awk in the pipe, which assumes
that the last column is symbol, but it can be "other info".

Adding "other info" removal for VERSIONED_SYM_COUNT the same
way as we did for GLOBAL_SYM_COUNT parsing.

[1] aa915931ac3e ("libbpf: Fix readelf output parsing for Fedora")
[2] 746f534a4809 ("tools/libbpf: Avoid counting local symbols in ABI check")

Cc: Tony Ambardar <tony.ambardar@gmail.com>
Cc: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Cc: Aurelien Jarno <aurelien@aurel32.net>
Fixes: 746f534a4809 ("tools/libbpf: Avoid counting local symbols in ABI check")
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/lib/bpf/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
index 5f9abed3e226..55bd78b3496f 100644
--- a/tools/lib/bpf/Makefile
+++ b/tools/lib/bpf/Makefile
@@ -146,6 +146,7 @@ GLOBAL_SYM_COUNT = $(shell readelf -s --wide $(BPF_IN_SHARED) | \
 			   awk '/GLOBAL/ && /DEFAULT/ && !/UND/ {print $$NF}' | \
 			   sort -u | wc -l)
 VERSIONED_SYM_COUNT = $(shell readelf --dyn-syms --wide $(OUTPUT)libbpf.so | \
+			      sed 's/\[.*\]//' | \
 			      awk '/GLOBAL/ && /DEFAULT/ && !/UND/ {print $$NF}' | \
 			      grep -Eo '[^ ]+@LIBBPF_' | cut -d@ -f1 | sort -u | wc -l)
 
@@ -214,6 +215,7 @@ check_abi: $(OUTPUT)libbpf.so
 		    awk '/GLOBAL/ && /DEFAULT/ && !/UND/ {print $$NF}'|  \
 		    sort -u > $(OUTPUT)libbpf_global_syms.tmp;		 \
 		readelf --dyn-syms --wide $(OUTPUT)libbpf.so |		 \
+		    sed 's/\[.*\]//' |					 \
 		    awk '/GLOBAL/ && /DEFAULT/ && !/UND/ {print $$NF}'|  \
 		    grep -Eo '[^ ]+@LIBBPF_' | cut -d@ -f1 |		 \
 		    sort -u > $(OUTPUT)libbpf_versioned_syms.tmp; 	 \
-- 
2.26.2

