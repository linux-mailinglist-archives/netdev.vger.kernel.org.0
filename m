Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 465AE58E77C
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 08:59:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231238AbiHJG7N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 02:59:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbiHJG7M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 02:59:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1D51E72EC0
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 23:59:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660114749;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=zls4Cl4FNP8DuIoFTM3V5sZep3mW2y+G5cy1prlx7I0=;
        b=Oa+Xq19lT8oMUDSVJ9ZylSYA3k0GtX7EFTn/OrjnHZg/AS+AGJr4ao1fWP2B5PYaTieoTK
        b8AQaf5IihXzPKfvkZdik3wRESQFRm+Ss+ARc1siNo9urJD+E8hDjoJOIWlC+chr4Pl+Od
        QKg55GshPPF1hENCciFM09ZQLdae+3U=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-412-gkP8E-dwMIC2KGuJo0mo-w-1; Wed, 10 Aug 2022 02:59:08 -0400
X-MC-Unique: gkP8E-dwMIC2KGuJo0mo-w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 269F43821C0B;
        Wed, 10 Aug 2022 06:59:08 +0000 (UTC)
Received: from shodan.usersys.redhat.com (unknown [10.43.17.22])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D6DE618EB5;
        Wed, 10 Aug 2022 06:59:07 +0000 (UTC)
Received: by shodan.usersys.redhat.com (Postfix, from userid 1000)
        id CBA131C02A9; Wed, 10 Aug 2022 08:59:06 +0200 (CEST)
From:   Artem Savkov <asavkov@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Andrea Arcangeli <aarcange@redhat.com>,
        Daniel Vacek <dvacek@redhat.com>,
        Jiri Olsa <olsajiri@gmail.com>, Song Liu <song@kernel.org>,
        Daniel Xu <dxu@dxuuu.xyz>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Artem Savkov <asavkov@redhat.com>
Subject: [PATCH bpf-next v5 0/3] destructive bpf_kfuncs
Date:   Wed, 10 Aug 2022 08:59:02 +0200
Message-Id: <20220810065905.475418-1-asavkov@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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

Changes in v5:
 - documentation numbering fixed
 - no more warning on failed kfunc registration

Changes in v4:
 - added description for KF_DESTRUCTIVE flag to documentation

Changes in v3:
 - moved kfunc set registration to kernel/bpf/helpers.c

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

 Documentation/bpf/kfuncs.rst                  |  9 +++++
 include/linux/btf.h                           |  3 +-
 kernel/bpf/helpers.c                          | 18 ++++++++++
 kernel/bpf/verifier.c                         |  5 +++
 net/bpf/test_run.c                            |  5 +++
 .../selftests/bpf/prog_tests/kfunc_call.c     | 36 +++++++++++++++++++
 .../bpf/progs/kfunc_call_destructive.c        | 14 ++++++++
 7 files changed, 89 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/bpf/progs/kfunc_call_destructive.c

-- 
2.37.1

