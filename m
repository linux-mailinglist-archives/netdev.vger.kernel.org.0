Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D44154F5E86
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 15:04:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230113AbiDFMvI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 08:51:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231754AbiDFMur (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 08:50:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DC2979D4D7
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 01:54:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649235256;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=C3E55v6H/hYc3LaSvLNAvhU13rJ0i/ZaskPmc70RQYw=;
        b=iZx2hIlt5mqR/lMZmIydfIJJ5163pmJ1P82qni4Kktp1F/KVnbRXu23Bk1+XLg+eEDI4a5
        GXJSjq0iLRvNsLbqA8FFlQE6eZwuMNR/kNtytqqJcWDcjgBU/Jc/6R54p2PyqbC4DFqDS5
        8pXqwsZzO2+tY+monoK+z2U/hHWQVeM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-513-hBdzYFkQP5SA6QJW8XVnrQ-1; Wed, 06 Apr 2022 04:54:12 -0400
X-MC-Unique: hBdzYFkQP5SA6QJW8XVnrQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E7E35800B28;
        Wed,  6 Apr 2022 08:54:11 +0000 (UTC)
Received: from samus.usersys.redhat.com (unknown [10.43.17.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BE7EA2166B2F;
        Wed,  6 Apr 2022 08:54:10 +0000 (UTC)
From:   Artem Savkov <asavkov@redhat.com>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Artem Savkov <asavkov@redhat.com>
Subject: [PATCH bpf-next] bpf/selftests: use bpf_num_possible_cpus() in per-cpu map allocations
Date:   Wed,  6 Apr 2022 10:54:08 +0200
Message-Id: <20220406085408.339336-1-asavkov@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bpf_map_value_size() uses num_possible_cpus() to determine map size, but
some of the tests only allocate enough memory for online cpus. This
results in out-of-bound writes in userspace during bpf(BPF_MAP_LOOKUP_ELEM)
syscalls in cases when number of online cpus is lower than the number of
possible cpus. Fix by switching from get_nprocs_conf() to
bpf_num_possible_cpus() when determining the number of processors in
these tests (test_progs/netcnt and test_cgroup_storage).

Signed-off-by: Artem Savkov <asavkov@redhat.com>
---
 tools/testing/selftests/bpf/prog_tests/netcnt.c   | 2 +-
 tools/testing/selftests/bpf/test_cgroup_storage.c | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/netcnt.c b/tools/testing/selftests/bpf/prog_tests/netcnt.c
index 954964f0ac3d..d3915c58d0e1 100644
--- a/tools/testing/selftests/bpf/prog_tests/netcnt.c
+++ b/tools/testing/selftests/bpf/prog_tests/netcnt.c
@@ -25,7 +25,7 @@ void serial_test_netcnt(void)
 	if (!ASSERT_OK_PTR(skel, "netcnt_prog__open_and_load"))
 		return;
 
-	nproc = get_nprocs_conf();
+	nproc = bpf_num_possible_cpus();
 	percpu_netcnt = malloc(sizeof(*percpu_netcnt) * nproc);
 	if (!ASSERT_OK_PTR(percpu_netcnt, "malloc(percpu_netcnt)"))
 		goto err;
diff --git a/tools/testing/selftests/bpf/test_cgroup_storage.c b/tools/testing/selftests/bpf/test_cgroup_storage.c
index d6a1be4d8020..2ffa08198d1c 100644
--- a/tools/testing/selftests/bpf/test_cgroup_storage.c
+++ b/tools/testing/selftests/bpf/test_cgroup_storage.c
@@ -7,6 +7,7 @@
 #include <sys/sysinfo.h>
 
 #include "bpf_rlimit.h"
+#include "bpf_util.h"
 #include "cgroup_helpers.h"
 #include "testing_helpers.h"
 
@@ -44,7 +45,7 @@ int main(int argc, char **argv)
 	unsigned long long *percpu_value;
 	int cpu, nproc;
 
-	nproc = get_nprocs_conf();
+	nproc = bpf_num_possible_cpus();
 	percpu_value = malloc(sizeof(*percpu_value) * nproc);
 	if (!percpu_value) {
 		printf("Not enough memory for per-cpu area (%d cpus)\n", nproc);
-- 
2.34.1

