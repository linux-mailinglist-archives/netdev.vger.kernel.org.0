Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D1D63659F3
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 15:25:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232459AbhDTNZQ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 20 Apr 2021 09:25:16 -0400
Received: from us-smtp-delivery-44.mimecast.com ([207.211.30.44]:22629 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232448AbhDTNZP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 09:25:15 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-547-X9KMndiGMfGSldWhX6i1CA-1; Tue, 20 Apr 2021 09:24:33 -0400
X-MC-Unique: X9KMndiGMfGSldWhX6i1CA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EBB9352800;
        Tue, 20 Apr 2021 13:24:31 +0000 (UTC)
Received: from krava.cust.in.nbox.cz (unknown [10.40.196.37])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 722D219172;
        Tue, 20 Apr 2021 13:24:29 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     Joe Stringer <joe@cilium.io>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: [PATCH bpf-next] selftests/bpf: Add docs target as all dependency
Date:   Tue, 20 Apr 2021 15:24:28 +0200
Message-Id: <20210420132428.15710-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=jolsa@kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently docs target is make dependency for TEST_GEN_FILES,
which makes tests to be rebuilt every time you run make.

Adding docs as all target dependency, so when running make
on top of built selftests it will show just:

  $ make
  make[1]: Nothing to be done for 'docs'.

After cleaning docs, only docs is rebuilt:

  $ make docs-clean
  CLEAN    eBPF_helpers-manpage
  CLEAN    eBPF_syscall-manpage
  $ make
  GEN      ...selftests/bpf/bpf-helpers.rst
  GEN      ...selftests/bpf/bpf-helpers.7
  GEN      ...selftests/bpf/bpf-syscall.rst
  GEN      ...selftests/bpf/bpf-syscall.2
  $ make
  make[1]: Nothing to be done for 'docs'.

Cc: Joe Stringer <joe@cilium.io>
Fixes: a01d935b2e09 ("tools/bpf: Remove bpf-helpers from bpftool docs")
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/testing/selftests/bpf/Makefile | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index c45ae13b88a0..c5bcdb3d4b12 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -187,7 +187,6 @@ $(OUTPUT)/runqslower: $(BPFOBJ) | $(DEFAULT_BPFTOOL)
 		    cp $(SCRATCH_DIR)/runqslower $@
 
 $(TEST_GEN_PROGS) $(TEST_GEN_PROGS_EXTENDED): $(OUTPUT)/test_stub.o $(BPFOBJ)
-$(TEST_GEN_FILES): docs
 
 $(OUTPUT)/test_dev_cgroup: cgroup_helpers.c
 $(OUTPUT)/test_skb_cgroup_id_user: cgroup_helpers.c
@@ -210,6 +209,8 @@ $(DEFAULT_BPFTOOL): $(wildcard $(BPFTOOLDIR)/*.[ch] $(BPFTOOLDIR)/Makefile)    \
 		    OUTPUT=$(HOST_BUILD_DIR)/bpftool/			       \
 		    prefix= DESTDIR=$(HOST_SCRATCH_DIR)/ install
 
+all: docs
+
 docs:
 	$(Q)RST2MAN_OPTS="--exit-status=1" $(MAKE) $(submake_extras)	\
 	            -f Makefile.docs					\
-- 
2.30.2

