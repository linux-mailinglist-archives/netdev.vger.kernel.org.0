Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C178242952
	for <lists+netdev@lfdr.de>; Wed, 12 Aug 2020 14:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727945AbgHLMbP convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 12 Aug 2020 08:31:15 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:36464 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727780AbgHLMbP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Aug 2020 08:31:15 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-71-kGLdQcsNOBislaL2_Ax9eA-1; Wed, 12 Aug 2020 08:31:09 -0400
X-MC-Unique: kGLdQcsNOBislaL2_Ax9eA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8A11C1005504;
        Wed, 12 Aug 2020 12:31:07 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.192.161])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DD0FF5D9D3;
        Wed, 12 Aug 2020 12:31:03 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: [RFC PATCH bpf-next] bpf: Iterate through all PT_NOTE sections when looking for build id
Date:   Wed, 12 Aug 2020 14:31:02 +0200
Message-Id: <20200812123102.20032-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=jolsa@kernel.org
X-Mimecast-Spam-Score: 0.001
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently when we look for build id within bpf_get_stackid helper
call, we check the first NOTE section and we fail if build id is
not there.

However on some system (Fedora) there can be multiple NOTE sections
in binaries and build id data is not always the first one, like:

  $ readelf -a /usr/bin/ls
  ...
  [ 2] .note.gnu.propert NOTE             0000000000000338  00000338
       0000000000000020  0000000000000000   A       0     0     8358
  [ 3] .note.gnu.build-i NOTE             0000000000000358  00000358
       0000000000000024  0000000000000000   A       0     0     437c
  [ 4] .note.ABI-tag     NOTE             000000000000037c  0000037c
  ...

So the stack_map_get_build_id function will fail on build id retrieval
and fallback to BPF_STACK_BUILD_ID_IP.

This patch is changing the stack_map_get_build_id code to iterate
through all the NOTE sections and try to get build id data from
each of them.

When tracing on sched_switch tracepoint that does bpf_get_stackid
helper call kernel build, I can see about 60% increase of successful
build id retrieval. The rest seems fails on -EFAULT.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 kernel/bpf/stackmap.c | 24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/kernel/bpf/stackmap.c b/kernel/bpf/stackmap.c
index 4fd830a62be2..cfed0ac44d38 100644
--- a/kernel/bpf/stackmap.c
+++ b/kernel/bpf/stackmap.c
@@ -213,11 +213,13 @@ static int stack_map_get_build_id_32(void *page_addr,
 
 	phdr = (Elf32_Phdr *)(page_addr + sizeof(Elf32_Ehdr));
 
-	for (i = 0; i < ehdr->e_phnum; ++i)
-		if (phdr[i].p_type == PT_NOTE)
-			return stack_map_parse_build_id(page_addr, build_id,
-					page_addr + phdr[i].p_offset,
-					phdr[i].p_filesz);
+	for (i = 0; i < ehdr->e_phnum; ++i) {
+		if (phdr[i].p_type == PT_NOTE &&
+		    !stack_map_parse_build_id(page_addr, build_id,
+					      page_addr + phdr[i].p_offset,
+					      phdr[i].p_filesz))
+			return 0;
+	}
 	return -EINVAL;
 }
 
@@ -236,11 +238,13 @@ static int stack_map_get_build_id_64(void *page_addr,
 
 	phdr = (Elf64_Phdr *)(page_addr + sizeof(Elf64_Ehdr));
 
-	for (i = 0; i < ehdr->e_phnum; ++i)
-		if (phdr[i].p_type == PT_NOTE)
-			return stack_map_parse_build_id(page_addr, build_id,
-					page_addr + phdr[i].p_offset,
-					phdr[i].p_filesz);
+	for (i = 0; i < ehdr->e_phnum; ++i) {
+		if (phdr[i].p_type == PT_NOTE &&
+		    !stack_map_parse_build_id(page_addr, build_id,
+					      page_addr + phdr[i].p_offset,
+					      phdr[i].p_filesz))
+			return 0;
+	}
 	return -EINVAL;
 }
 
-- 
2.25.4

