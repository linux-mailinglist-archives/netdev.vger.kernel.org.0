Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BED2F41986F
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 18:02:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235376AbhI0QDw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 12:03:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:20782 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235353AbhI0QDu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Sep 2021 12:03:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632758532;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=jUaJ1IKQE0YFnAuJ4WfmBeV1UYM0Oan+ct0lDVq9/lw=;
        b=R/h/BrmrHBwvhwnEXOqJmXvmffv5rYTMC9ZZ+EK7iYwMu5YkWIdBZIzvXlLeIoufCDcxgl
        2gt9jckvpOYClpalwyL6yK9gX9ZSdLMTxDnEnaNmloJ4riHAbxNFy/AZBeIWENonrahI3o
        lHSsEPWsT0GNxtxJArpgzR3Sizh3Pco=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-274-GKKlnJi1PHiE2vB-9pKQXw-1; Mon, 27 Sep 2021 12:02:10 -0400
X-MC-Unique: GKKlnJi1PHiE2vB-9pKQXw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9194050753;
        Mon, 27 Sep 2021 16:02:09 +0000 (UTC)
Received: from griffin.upir.cz (unknown [10.40.193.118])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1106E1A26A;
        Mon, 27 Sep 2021 16:02:07 +0000 (UTC)
From:   Jiri Benc <jbenc@redhat.com>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org
Subject: [PATCH bpf] selftests: bpf: fix makefile dependencies on libbpf
Date:   Mon, 27 Sep 2021 18:01:36 +0200
Message-Id: <ee84ab66436fba05a197f952af23c98d90eb6243.1632758415.git.jbenc@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When building bpf selftest with make -j, I'm randomly getting build failures
such as this one:

> In file included from progs/bpf_flow.c:19:
> [...]/tools/testing/selftests/bpf/tools/include/bpf/bpf_helpers.h:11:10: fatal error: 'bpf_helper_defs.h' file not found
> #include "bpf_helper_defs.h"
>          ^~~~~~~~~~~~~~~~~~~

The file that fails the build varies between runs but it's always in the
progs/ subdir.

The reason is a missing make dependency on libbpf for the .o files in
progs/. There was a dependency before commit 3ac2e20fba07e but that commit
removed it to prevent unneeded rebuilds. However, that only works if libbpf
has been built already; the 'wildcard' prerequisite does not trigger when
there's no bpf_helper_defs.h generated yet.

Keep the libbpf as an order-only prerequisite to satisfy both goals. It is
always built before the progs/ objects but it does not trigger unnecessary
rebuilds by itself.

Fixes: 3ac2e20fba07e ("selftests/bpf: BPF object files should depend only on libbpf headers")
Signed-off-by: Jiri Benc <jbenc@redhat.com>
---
 tools/testing/selftests/bpf/Makefile | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 866531c08e4f..e7c42695dbbf 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -375,7 +375,8 @@ $(TRUNNER_BPF_OBJS): $(TRUNNER_OUTPUT)/%.o:				\
 		     $(TRUNNER_BPF_PROGS_DIR)/%.c			\
 		     $(TRUNNER_BPF_PROGS_DIR)/*.h			\
 		     $$(INCLUDE_DIR)/vmlinux.h				\
-		     $(wildcard $(BPFDIR)/bpf_*.h) | $(TRUNNER_OUTPUT)
+		     $(wildcard $(BPFDIR)/bpf_*.h) | $(TRUNNER_OUTPUT)	\
+		     $$(BPFOBJ)
 	$$(call $(TRUNNER_BPF_BUILD_RULE),$$<,$$@,			\
 					  $(TRUNNER_BPF_CFLAGS))
 
-- 
2.18.1

