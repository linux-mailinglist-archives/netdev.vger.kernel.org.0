Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 914D9595551
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 10:31:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232776AbiHPIb0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 04:31:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233086AbiHPIaC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 04:30:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B33AB135446
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 22:52:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660629165;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fJw+5XXpYtdUBNAptmDWquCOSql4etovIcYYOct0Agg=;
        b=THw0SS/DcJrLPzhWykpHHhR/rE26yd1q4oMWGieIap7K5G7LhmTrdlJ6ebcYpW1fYr5gZC
        tAkDL6khUn73md7Z5lX0MTLlmSEWEi0/rC+ygzIPm+1e5y0VWfozbju0KenfTNAuHekPxy
        QbzPL2YSUUDBrpkKFbP3IkRtdGqGQ7k=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-436-5z1zJE7hPFmH_v6gqPr1XA-1; Tue, 16 Aug 2022 01:52:40 -0400
X-MC-Unique: 5z1zJE7hPFmH_v6gqPr1XA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 123D0811E75;
        Tue, 16 Aug 2022 05:52:40 +0000 (UTC)
Received: from shodan.usersys.redhat.com (unknown [10.43.17.22])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E2F8340CF8EA;
        Tue, 16 Aug 2022 05:52:39 +0000 (UTC)
Received: by shodan.usersys.redhat.com (Postfix, from userid 1000)
        id C30E91C029C; Tue, 16 Aug 2022 07:52:38 +0200 (CEST)
From:   Artem Savkov <asavkov@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Artem Savkov <asavkov@redhat.com>
Subject: [PATCH bpf-next v2] selftests/bpf: fix attach point for non-x86 arches in test_progs/lsm
Date:   Tue, 16 Aug 2022 07:52:31 +0200
Message-Id: <20220816055231.717006-1-asavkov@redhat.com>
In-Reply-To: <376f20c5-4b1c-efec-4dde-43d91b3d4308@iogearbox.net>
References: <376f20c5-4b1c-efec-4dde-43d91b3d4308@iogearbox.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use SYS_PREFIX macro from bpf_misc.h instead of hard-coded '__x64_'
prefix for sys_setdomainname attach point in lsm test.

Signed-off-by: Artem Savkov <asavkov@redhat.com>
---
 tools/testing/selftests/bpf/DENYLIST.s390x | 2 +-
 tools/testing/selftests/bpf/progs/lsm.c    | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/DENYLIST.s390x b/tools/testing/selftests/bpf/DENYLIST.s390x
index e33cab34d22f..9d8de15e725e 100644
--- a/tools/testing/selftests/bpf/DENYLIST.s390x
+++ b/tools/testing/selftests/bpf/DENYLIST.s390x
@@ -43,7 +43,7 @@ test_bpffs                               # bpffs test  failed 255
 test_bprm_opts                           # failed to auto-attach program 'secure_exec': -524                           (trampoline)
 test_ima                                 # failed to auto-attach program 'ima': -524                                   (trampoline)
 test_local_storage                       # failed to auto-attach program 'unlink_hook': -524                           (trampoline)
-test_lsm                                 # failed to find kernel BTF type ID of '__x64_sys_setdomainname': -3          (?)
+test_lsm                                 # attach unexpected error: -524                                               (trampoline)
 test_overhead                            # attach_fentry unexpected error: -524                                        (trampoline)
 test_profiler                            # unknown func bpf_probe_read_str#45                                          (overlapping)
 timer                                    # failed to auto-attach program 'test1': -524                                 (trampoline)
diff --git a/tools/testing/selftests/bpf/progs/lsm.c b/tools/testing/selftests/bpf/progs/lsm.c
index 33694ef8acfa..d8d8af623bc2 100644
--- a/tools/testing/selftests/bpf/progs/lsm.c
+++ b/tools/testing/selftests/bpf/progs/lsm.c
@@ -4,6 +4,7 @@
  * Copyright 2020 Google LLC.
  */
 
+#include "bpf_misc.h"
 #include "vmlinux.h"
 #include <bpf/bpf_helpers.h>
 #include <bpf/bpf_tracing.h>
@@ -160,7 +161,7 @@ int BPF_PROG(test_task_free, struct task_struct *task)
 
 int copy_test = 0;
 
-SEC("fentry.s/__x64_sys_setdomainname")
+SEC("fentry.s/" SYS_PREFIX "sys_setdomainname")
 int BPF_PROG(test_sys_setdomainname, struct pt_regs *regs)
 {
 	void *ptr = (void *)PT_REGS_PARM1(regs);
-- 
2.37.1

