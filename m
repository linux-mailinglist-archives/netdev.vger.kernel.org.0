Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B02855879A4
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 11:10:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236200AbiHBJKk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 05:10:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234911AbiHBJKj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 05:10:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C6D7015FF3
        for <netdev@vger.kernel.org>; Tue,  2 Aug 2022 02:10:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659431436;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=0Yd3q06qvhhVBLQakF8lxb418VQuM5l3HSSy3lJg+aA=;
        b=MfHExTy0bs/k+I79ej/vQaOlxv2dr8afat3EM9xqakHuphNRSQ2BPjgKcRMFC8qKQxaYV5
        yy5NdQjKQ0/cJaSBYw2aQCTNAyVDueLSAri1UxlHnlaNy2vl2nZg/51OPZIGvbhr27ts2C
        ZA/VBbJWMsc5o3Ys1W0urq9NJ7nXRoQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-625-L1MPqx2HPcen8s2AbjgYyQ-1; Tue, 02 Aug 2022 05:10:33 -0400
X-MC-Unique: L1MPqx2HPcen8s2AbjgYyQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C81C1801231;
        Tue,  2 Aug 2022 09:10:32 +0000 (UTC)
Received: from shodan.usersys.redhat.com (unknown [10.43.17.22])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 86E05403166;
        Tue,  2 Aug 2022 09:10:32 +0000 (UTC)
Received: by shodan.usersys.redhat.com (Postfix, from userid 1000)
        id 75B691C026C; Tue,  2 Aug 2022 11:10:31 +0200 (CEST)
From:   Artem Savkov <asavkov@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Andrea Arcangeli <aarcange@redhat.com>,
        Daniel Vacek <dvacek@redhat.com>,
        Jiri Olsa <olsajiri@gmail.com>, Song Liu <song@kernel.org>,
        Daniel Xu <dxu@dxuuu.xyz>, Artem Savkov <asavkov@redhat.com>
Subject: [PATCH bpf-next v2 0/3] destructive bpf_kfuncs
Date:   Tue,  2 Aug 2022 11:10:27 +0200
Message-Id: <20220802091030.3742334-1-asavkov@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

eBPF is often used for kernel debugging, and one of the widely used and
powerful debugging techniques is post-mortem debugging with a full memory dump.
Triggering a panic at exactly the right moment allows the user to get such a
dump and thus a better view at the system's state. Right now the only way to
do this in BPF is to signal userspace to trigger kexec/panic. This is
suboptimal as going through userspace requires context changes and adds
significant delays taking system further away from "the right moment". On a
single-cpu system the situation is even worse because BPF program won't even be
able to block the thread of interest.

This patchset tries to solve this problem by allowing properly marked tracing
bpf programs to call crash_kexec() kernel function. The only requirement for
now to run programs calling crash_kexec() or other destructive kfuncs is
CAP_SYS_BOOT capability. When signature checking for bpf programs is available
it is possible that stricter rules will be applied to programs utilizing
destructive kfuncs.

This is a continuation of bpf_panic patchset with initial feedback taken into
account.

Changes in v2:
 - BPF_PROG_LOAD flag dropped as it doesn't fully achieve it's aim of
   preventing accidental execution of destructive bpf programs
 - selftest moved to the end of patchset
 - switched to kfunc destructive flag instead of a separate set

Changes from RFC:
 - sysctl knob dropped
 - using crash_kexec() instead of panic()
 - using kfuncs instead of adding a new helper

Artem Savkov (3):
  bpf: add destructive kfunc flag
  bpf: export crash_kexec() as destructive kfunc
  selftests/bpf: add destructive kfunc test

 include/linux/btf.h                           |  1 +
 kernel/bpf/verifier.c                         |  5 +++
 kernel/kexec_core.c                           | 21 +++++++++++
 net/bpf/test_run.c                            |  5 +++
 .../selftests/bpf/prog_tests/kfunc_call.c     | 36 +++++++++++++++++++
 .../bpf/progs/kfunc_call_destructive.c        | 14 ++++++++
 6 files changed, 82 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/progs/kfunc_call_destructive.c

-- 
2.35.3

