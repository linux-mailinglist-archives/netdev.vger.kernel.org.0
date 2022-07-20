Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C7D657B5CE
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 13:47:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240777AbiGTLrE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 07:47:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240637AbiGTLrB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 07:47:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3755B72BFE
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 04:47:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658317619;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=z3KFlTHyS29ABxq7E7+mqrxJZKNMmdmSRTF2Gmd+qak=;
        b=IWv2Nx+OWaasC8K/CuGjN/F39W2zsq+ooO9jiDw1MxYRDDZv3170G2JHHOruSp9d6mnaJe
        ojNeVhJwQu1Gcm5y6U28y07EE7lTx8BrPG/ON4LdOGFURzKpChvqUThggiTuagv1MVcrb7
        6bFffTUKQleME0KNq2DVB8+Gv0iHYQc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-14-rSDRWVgIOImHt2fqhC-V9g-1; Wed, 20 Jul 2022 07:46:55 -0400
X-MC-Unique: rSDRWVgIOImHt2fqhC-V9g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 66FD7804191;
        Wed, 20 Jul 2022 11:46:55 +0000 (UTC)
Received: from shodan.usersys.redhat.com (unknown [10.43.17.22])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EF4CB2166B26;
        Wed, 20 Jul 2022 11:46:54 +0000 (UTC)
Received: by shodan.usersys.redhat.com (Postfix, from userid 1000)
        id E102B1C029C; Wed, 20 Jul 2022 13:46:53 +0200 (CEST)
From:   Artem Savkov <asavkov@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Andrea Arcangeli <aarcange@redhat.com>,
        Daniel Vacek <dvacek@redhat.com>,
        Jiri Olsa <olsajiri@gmail.com>, Song Liu <song@kernel.org>,
        Artem Savkov <asavkov@redhat.com>
Subject: [PATCH bpf-next 0/4] destructive bpf kfuncs (was: bpf_panic)
Date:   Wed, 20 Jul 2022 13:46:48 +0200
Message-Id: <20220720114652.3020467-1-asavkov@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
bpf programs to call crash_kexec() kernel function.

This is a continuation of bpf_panic patchset with initial feedback taken into
account.

Changes from RFC:
 - sysctl knob dropped
 - using crash_kexec() instead of panic()
 - using kfuncs instead of adding a new helper

Artem Savkov (4):
  bpf: add BPF_F_DESTRUCTIVE flag for BPF_PROG_LOAD
  bpf: add destructive kfunc set
  selftests/bpf: add destructive kfunc tests
  bpf: export crash_kexec() as destructive kfunc

 include/linux/bpf.h                           |  1 +
 include/linux/btf.h                           |  2 +
 include/uapi/linux/bpf.h                      |  6 +++
 kernel/bpf/syscall.c                          |  4 +-
 kernel/bpf/verifier.c                         | 12 ++++++
 kernel/kexec_core.c                           | 22 ++++++++++
 net/bpf/test_run.c                            | 12 +++++-
 tools/include/uapi/linux/bpf.h                |  6 +++
 .../selftests/bpf/prog_tests/kfunc_call.c     | 41 +++++++++++++++++++
 .../bpf/progs/kfunc_call_destructive.c        | 14 +++++++
 10 files changed, 118 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/kfunc_call_destructive.c

-- 
2.35.3

